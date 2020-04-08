# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::ko;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = [];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '';
    $Self->{DateFormatLong}      = '';
    $Self->{DateFormatShort}     = '';
    $Self->{DateInputFormat}     = '';
    $Self->{DateInputFormatLong} = '';
    $Self->{Completeness}        = 0.96799864544531;

    # csv separator
    $Self->{Separator}         = '';

    $Self->{DecimalSeparator}  = '';
    $Self->{ThousandSeparator} = '';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'ACL 관리',
        'Actions' => '행동',
        'Create New ACL' => '새 ACL',
        'Deploy ACLs' => 'ACL 배포',
        'Export ACLs' => 'ACL 내보내기',
        'Filter for ACLs' => 'ACL 필터',
        'Just start typing to filter...' => '필터링을 시작하는 중...',
        'Configuration Import' => '설정 Import',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 ACL을 가져올 수 있습니다. ACL 편집기 모듈에서 내 보낸 파일은 .yml 형식이어야합니다.',
        'This field is required.' => '이 항목은 필수입니다.',
        'Overwrite existing ACLs?' => '존재하는 ACL을 덮어쓰시겠습니까?',
        'Upload ACL configuration' => 'ACL 설정 업로드',
        'Import ACL configuration(s)' => 'ACL 설정 Import',
        'Description' => '설명',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '새 ACL을 만들려면 다음에서 내 보낸 ACL을 가져올 수 있습니다.다른 시스템을 만들거나 완전한 새 시스템을 만드십시오.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '이후 ACL 데이터를 배포하는 경우 여기에서 ACL을 변경하면 시스템의 동작에만 영향을줍니다. ACL 데이터를 배포하면 새로 변경된 내용이 구성에 기록됩니다.',
        'ACLs' => 'ACL',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '이 테이블은 ACL의 실행 순서를 나타냅니다. ACL이 실행되는 순서를 변경해야하는 경우 영향을받는 ACL의 이름을 변경하십시오',
        'ACL name' => 'ACL 명',
        'Comment' => '의견',
        'Validity' => '정당함',
        'Export' => '내보내기',
        'Copy' => '복사',
        'No data found.' => '데이터가 없음',
        'No matches found.' => '일치하는 것을 찾을 수 없음',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'ACL 수정 %s',
        'Edit ACL' => 'ACL 수정',
        'Go to overview' => '오버뷰로 가기',
        'Delete ACL' => 'ACL 삭제',
        'Delete Invalid ACL' => '비정상 ACL 삭제',
        'Match settings' => '일치 설정',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '이 ACL에 대한 일치 기준을 설정하십시오. \'Properties\'를 사용하여 현재 화면을 일치 시키거나 \'PropertiesDatabase\'를 사용하여 데이터베이스에있는 현재 티켓의 속성과 일치시킵니다.',
        'Change settings' => '설정 변경',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '기준이 일치하면 변경하려는 항목을 설정하십시오. Possible \'은 흰색 목록이고\'PossibleNot \'은 검은 색 목록입니다.',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => '내용 보여주기/가리기',
        'Edit ACL Information' => 'ACL 정보 수정',
        'Name' => '이름',
        'Stop after match' => '다음 매칭을 중지',
        'Edit ACL Structure' => 'ACL 구조 수정',
        'Save ACL' => 'ACL 저장',
        'Save' => '저장',
        'or' => '또는',
        'Save and finish' => '저장 후 종료',
        'Cancel' => '취소',
        'Do you really want to delete this ACL?' => '정말로 이 ACL을 지우시겠습니까?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '양식 데이터를 제출하여 새 ACL을 작성하십시오. ACL을 생성 한 후 편집 모드에서 구성 항목을 추가 할 수 있습니다',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => '캘린더 관리',
        'Add Calendar' => '캘린더 추가',
        'Edit Calendar' => '캘린더 수정',
        'Calendar Overview' => '캘린더 개요',
        'Add new Calendar' => '새 캘린더 추가',
        'Import Appointments' => '예약 Import',
        'Calendar Import' => '캘린더 Import',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 달력을 가져올 수 있습니다. 캘린더 관리 모듈에서 내 보낸 파일은 .yml 형식이어야합니다.',
        'Overwrite existing entities' => '덮어쓰시겠습니까?',
        'Upload calendar configuration' => '캘린더 설정 업로드',
        'Import Calendar' => '캘린더 Import',
        'Filter for Calendars' => '',
        'Filter for calendars' => '캘린터 필터',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            '그룹 필드에 따라 시스템에서 권한 수준에 따라 사용자가 캘린더에 액세스 할 수 있습니다.',
        'Read only: users can see and export all appointments in the calendar.' =>
            '읽기 전용 : 사용자는 캘린더의 모든 약속을보고 내보낼 수 있습니다.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            '다음으로 이동 : 사용자는 캘린더에서 약속을 수정할 수 있지만 캘린더 선택은 변경하지 않습니다.',
        'Create: users can create and delete appointments in the calendar.' =>
            '만들기 : 사용자는 달력에서 약속을 만들고 삭제할 수 있습니다.',
        'Read/write: users can manage the calendar itself.' => '읽기 / 쓰기 : 사용자는 캘린더 자체를 관리 할 수 ​​있습니다.',
        'Group' => '그룹',
        'Changed' => '변경됨',
        'Created' => '생성됨',
        'Download' => '다운로드',
        'URL' => 'URL',
        'Export calendar' => '캘린더 Export',
        'Download calendar' => '캘린더 다운로드',
        'Copy public calendar URL' => '퍼블릭 캘린더 URL 복사',
        'Calendar' => '캘린더',
        'Calendar name' => '캘린더 이름',
        'Calendar with same name already exists.' => '같은 이름의 캘린더가 존재합니다.',
        'Color' => '색깔',
        'Permission group' => '권한 그룹',
        'Ticket Appointments' => '티켓 예약',
        'Rule' => '규칙',
        'Remove this entry' => '이것을 삭제',
        'Remove' => '삭제',
        'Start date' => '시작일',
        'End date' => '종료일',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            '아래의 옵션을 사용하여 티켓 예약이 자동으로 생성되도록 범위를 좁 힙니다.',
        'Queues' => '대기열',
        'Please select a valid queue.' => '올바른 대기열을 선택하십시오.',
        'Search attributes' => '검색 속성',
        'Add entry' => '항목 추가',
        'Add' => '추가',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            '티켓 데이터를 기반으로이 달력에 자동 약속을 만들기위한 규칙을 정의하십시오.',
        'Add Rule' => '규칙 추가',
        'Submit' => '제출',

        # Template: AdminAppointmentImport
        'Appointment Import' => '약속 가져오기',
        'Go back' => '뒤로',
        'Uploaded file must be in valid iCal format (.ics).' => '업로드 된 파일은 유효한 iCal 형식 (.ics)이어야합니다.',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            '원하는 캘린더가 여기에 표시되지 않으면 \'만들기\'권한이 있는지 확인하십시오.',
        'Upload' => '업로드',
        'Update existing appointments?' => '기존 약속을 업데이트 하시겠습니까?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            '동일한 UniqueID를 가진 달력의 기존 약속은 모두 덮어 쓰여집니다.',
        'Upload calendar' => '캘린터 업로드',
        'Import appointments' => '약속 Import',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => '약속 알림 관리',
        'Add Notification' => '알림 추가',
        'Edit Notification' => '알림 수정',
        'Export Notifications' => '알림 Export',
        'Filter for Notifications' => '알림 필터',
        'Filter for notifications' => '알림 필터',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '여기서 구성 파일을 업로드하여 약속 알림을 시스템에 가져올 수 있습니다. 파일은 약속 알림 모듈에서 내 보낸 .yml 형식이어야합니다.',
        'Overwrite existing notifications?' => '존재하는 알림을 덮어쓰시겠습니까?',
        'Upload Notification configuration' => '알림 설정을 업로드하시겠습니까?',
        'Import Notification configuration' => '알림 설정 Import',
        'List' => '목록',
        'Delete' => '삭제',
        'Delete this notification' => '이 알림 삭제',
        'Show in agent preferences' => '상담원 환경설정에서 보기',
        'Agent preferences tooltip' => '상담원 환경설정 툴팁',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '이 메시지는 상담원 기본 설정 화면에이 알림에 대한 툴팁으로 표시됩니다.',
        'Toggle this widget' => '이 위젯을 토글',
        'Events' => '이벤트',
        'Event' => '이벤트',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '여기에서이 알림을 실행할 이벤트를 선택할 수 있습니다. 추가 기준 필터를 적용하여 특정 기준에 대한 약속 만 보낼 수 있습니다.',
        'Appointment Filter' => '약속 필터',
        'Type' => '타입',
        'Title' => '제목',
        'Location' => '위치',
        'Team' => '팀',
        'Resource' => '자원',
        'Recipients' => '접수자',
        'Send to' => '보내기',
        'Send to these agents' => '선택 상담원들에게 보내기',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => '모든 역할 멤버들에게 보내기',
        'Send on out of office' => '부재중인 사람들에게 보내기',
        'Also send if the user is currently out of office.' => '사용자가 현재 부재중인 경우에도 보내기',
        'Once per day' => '하루 한번',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            '선택한 날짜를 사용하여 약속을 하루에 한 번만 알립니다.',
        'Notification Methods' => '알림 방법',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '이러한 알림을 각받는 사람에게 보내는 데 사용할 수있는 방법입니다. 아래에서 하나 이상의 방법을 선택하십시오.',
        'Enable this notification method' => '알림 방법 사용',
        'Transport' => '전송',
        'At least one method is needed per notification.' => '알림 당 하나 이상의 메소드가 필요합니다.',
        'Active by default in agent preferences' => '에이전트 환경 설정에서 기본적으로 활성화 됨',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '이것은 자신의 환경 설정에서이 통지에 대해 아직 선택하지 않은 할당 된 수신자 에이전트의 기본값입니다. 이 상자가 활성화되면 해당 에이전트에 알림이 전송됩니다.',
        'This feature is currently not available.' => '현재 이 기능을 사용할 수 없습니다.',
        'Upgrade to %s' => '%s (으)로 업그레이드',
        'Please activate this transport in order to use it.' => '사용하려면이 운송을 활성화하십시오.',
        'No data found' => '데이터가 없습니다.',
        'No notification method found.' => '알림 방법이 없습니다.',
        'Notification Text' => '알림 내용',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            '이 언어는 시스템에 없거나 사용 가능하지 않습니다. 이 알림 텍스트는 더 이상 필요하지 않은 경우 삭제할 수 있습니다.',
        'Remove Notification Language' => '알림 언어 삭제',
        'Subject' => '제목',
        'Text' => '본문',
        'Message body' => '메시지 본문',
        'Add new notification language' => '새 알림 언어 추가',
        'Save Changes' => '변경 저장',
        'Tag Reference' => '태그 참조',
        'Notifications are sent to an agent.' => '통지는 에이전트로 전송됩니다.',
        'You can use the following tags' => '다음 태그를 사용할 수 있습니다.',
        'To get the first 20 character of the appointment title.' => '약속 제목의 처음 20자를 얻습니다.',
        'To get the appointment attribute' => '약속 특성을 얻으려면',
        ' e. g.' => 'e. g.',
        'To get the calendar attribute' => '달력 속성을 가져 오려면',
        'Attributes of the recipient user for the notification' => '알림에 대한 수신자 사용자의 속성',
        'Config options' => '구성 옵션',
        'Example notification' => '알림 예',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => '추가받는 사람 전자 메일 주소',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '고객이 볼 수있는 기사',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '알림이 고객에게 발송되거나 추가 이메일 주소 인 경우 기사가 생성됩니다.',
        'Email template' => '이메일 템플릿',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '이 템플릿을 사용하여 전체 전자 메일을 생성합니다 (HTML 전자 메일 만 해당).',
        'Enable email security' => '이메일 보안 사용',
        'Email security level' => '이메일 보안 수준',
        'If signing key/certificate is missing' => '서명 키 / 인증서가 누락 된 경우',
        'If encryption key/certificate is missing' => '암호화 키 / 인증서가 누락 된 경우',

        # Template: AdminAttachment
        'Attachment Management' => '첨부파일 관리',
        'Add Attachment' => '첨부파일 추가',
        'Edit Attachment' => '첨부파일 편집',
        'Filter for Attachments' => '첨부파일 필터링',
        'Filter for attachments' => '첨부파일 필터링',
        'Filename' => '파일 이름',
        'Download file' => '파일 다운로드',
        'Delete this attachment' => '첨부파일 삭제',
        'Do you really want to delete this attachment?' => '첨부 파일을 정말로 삭제 하시겠습니까?',
        'Attachment' => '부착',

        # Template: AdminAutoResponse
        'Auto Response Management' => '자동 응답 관리',
        'Add Auto Response' => '자동 응답 추가',
        'Edit Auto Response' => '자동 응답 수정',
        'Filter for Auto Responses' => '자동 응답 필터링',
        'Filter for auto responses' => '자동 응답 필터링',
        'Response' => '응답',
        'Auto response from' => '님의 자동 응답',
        'Reference' => '참고',
        'To get the first 20 character of the subject.' => '주제의 처음 20자를 얻습니다.',
        'To get the first 5 lines of the email.' => '전자 메일의 처음 5 줄을 가져옵니다.',
        'To get the name of the ticket\'s customer user (if given).' => '티켓의 고객 사용자 이름을 알려주는 것입니다 (주어진 경우).',
        'To get the article attribute' => '기사 속성을 얻으려면',
        'Options of the current customer user data' => '현재 고객 사용자 데이터의 옵션',
        'Ticket owner options' => '티켓 소유자 옵션',
        'Ticket responsible options' => '티켓 책임 옵션',
        'Options of the current user who requested this action' => '이 작업을 요청한 현재 사용자의 옵션',
        'Options of the ticket data' => '티켓 데이터의 옵션',
        'Options of ticket dynamic fields internal key values' => '티켓 동적 필드 내부 키 값의 옵션',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '티켓 동적 필드의 옵션은 드롭 다운 및 다중선택 필드에 유용한 값을 표시합니다.',
        'Example response' => '응답 예',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '클라우드 서비스 관리',
        'Support Data Collector' => '지원 데이터 수집기',
        'Support data collector' => '지원 데이터 수집기',
        'Hint' => '힌트',
        'Currently support data is only shown in this system.' => '현재 지원되는 데이터는이 시스템에만 표시됩니다.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '보다 나은 지원을 받으려면이 데이터를 OTRS 그룹에 보내도록하십시오.',
        'Configuration' => '구성',
        'Send support data' => '지원 데이터 보내기',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '이렇게하면 시스템이 OTRS 그룹에 추가 지원 데이터 정보를 보낼 수 있습니다.',
        'Update' => '최신 정보',
        'System Registration' => '시스템 등록',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '데이터 전송을 활성화하려면 시스템을 OTRS 그룹에 등록하거나 시스템 등록 정보를 업데이트하십시오 ( \'지원 데이터 보내기\'옵션을 활성화하십시오).',
        'Register this System' => '이 시스템 등록',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '시스템 등록은 시스템에서 사용할 수 없습니다. 구성을 확인하십시오.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '시스템 등록은 많은 장점을 제공하는 OTRS Group의 서비스입니다!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'OTRS 클라우드 서비스를 사용하려면 시스템을 등록해야합니다.',
        'Register this system' => '이 시스템 등록',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '%s와 안전하게 통신 할 수있는 클라우드 서비스를 구성 할 수 있습니다.',
        'Available Cloud Services' => '사용가능한 클라우드 서비스',

        # Template: AdminCommunicationLog
        'Communication Log' => '통신 로그',
        'Time Range' => '',
        'Show only communication logs created in specific time range.' =>
            '특정 시간 범위에서 생성 된 통신 로그 만 표시합니다.',
        'Filter for Communications' => '',
        'Filter for communications' => '통신용 필터',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '이 화면에서 들어오고 나가는 통신에 대한 개요를 볼 수 있습니다.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '열 머리글을 클릭하여 열의 정렬 및 순서를 변경할 수 있습니다.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '다른 항목을 클릭하면 메시지에 대한 세부 화면으로 리디렉션됩니다.',
        'Status for: %s' => '상태 : %s',
        'Failing accounts' => '실패한 계정',
        'Some account problems' => '일부 계정 문제',
        'No account problems' => '계정 문제 없음',
        'No account activity' => '계정 활동 없음',
        'Number of accounts with problems: %s' => '문제가있는 계정 수 : %s',
        'Number of accounts with warnings: %s' => '경고가있는 계정 수 : %s',
        'Failing communications' => '통신 실패',
        'No communication problems' => '통신 문제 없음',
        'No communication logs' => '통신 로그 없음',
        'Number of reported problems: %s' => '보고 된 문제 수 : %s',
        'Open communications' => '열린 커뮤니케이션',
        'No active communications' => '활성 통신 없음',
        'Number of open communications: %s' => '열린 통신의 수 : %s',
        'Average processing time' => '평균 처리 시간',
        'List of communications (%s)' => '통신 목록 (%s)',
        'Settings' => '설정',
        'Entries per page' => '페이지당 갯수',
        'No communications found.' => '통신이 없습니다.',
        '%s s' => '%s 개',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '계정 상태',
        'Back to overview' => '',
        'Filter for Accounts' => '',
        'Filter for accounts' => '계정 필터링',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '옆 머리글을 클릭하여 해당 열의 정렬 및 순서를 변경할 수 있습니다. ',
        'Account status for: %s' => '다음 계정 상태 : %s',
        'Status' => '상태',
        'Account' => '계정',
        'Edit' => '수정',
        'No accounts found.' => '계정이 없습니다.',
        'Communication Log Details (%s)' => '통신 로그 정보 (%s)',
        'Direction' => '방향',
        'Start Time' => '시작 시간',
        'End Time' => '종료 시간',
        'No communication log entries found.' => '통신 로그 항목을 찾을 수 없습니다.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '지속',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => '우선순위',
        'Module' => '기준 치수',
        'Information' => '정보',
        'No log entries found.' => '로그 항목을 찾을 수 없습니다.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '%s에서 시작된 %s 통신에 대한 상세보기',
        'Filter for Log Entries' => '로그 항목 필터링',
        'Filter for log entries' => '로그 항목 필터링',
        'Show only entries with specific priority and higher:' => '특정 우선 순위 이상의 항목만 표시:',
        'Communication Log Overview (%s)' => '통신 로그 개요 (%s)',
        'No communication objects found.' => '통신 개체를 찾을 수 없습니다.',
        'Communication Log Details' => '통신 로그 세부 정보',
        'Please select an entry from the list.' => '목록에서 항목을 선택하십시오.',

        # Template: AdminCustomerCompany
        'Customer Management' => '고객 관리',
        'Add Customer' => '고객 추가',
        'Edit Customer' => '고객 편집',
        'Search' => '검색',
        'Wildcards like \'*\' are allowed.' => '\'*\'와 같은 와일드 카드는 허용됩니다.',
        'Select' => '선택',
        'List (only %s shown - more available)' => '목록 ( %s 보여짐 - 더있음)',
        'total' => '총',
        'Please enter a search term to look for customers.' => '고객을 찾으려면 검색어를 입력하십시오.',
        'Customer ID' => '고객 ID',
        'Please note' => '주의 사항',
        'This customer backend is read only!' => '이 고객 백엔드는 읽기전용입니다!',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => '고객-그룹 관계 관리',
        'Notice' => '공지',
        'This feature is disabled!' => '부가기능이 불가능으로 설정됨!',
        'Just use this feature if you want to define group permissions for customers.' =>
            '고객에 대한 그룹 권한을 정의하려면 이 기능을 사용하십시오.',
        'Enable it here!' => '여기에서 사용하도록 설정하십시오!',
        'Edit Customer Default Groups' => '고객 기본 그룹 편집',
        'These groups are automatically assigned to all customers.' => '이 그룹은 모든 고객에게 자동으로 할당됩니다.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '"CustomerGroupCompanyAlwaysGroups "구성 설정을 통해 이러한 그룹을 관리 할 수 ​​있습니다.',
        'Filter for Groups' => '그룹 필터링',
        'Select the customer:group permissions.' => '고객 : 그룹 권한을 선택하십시오.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '아무 것도 선택하지 않으면이 그룹에 사용 권한이 없습니다 (티켓 고객에게 제공되지 않습니다).',
        'Search Results' => '검색결과',
        'Customers' => '고객',
        'Groups' => '그룹',
        'Change Group Relations for Customer' => '고객과 그룹의 관계를 변경',
        'Change Customer Relations for Group' => '그룹과 고객의 관계를 변경',
        'Toggle %s Permission for all' => '%s 토글 모든 권한',
        'Toggle %s permission for %s' => '%s에 대한 %s 권한을 토글합니다.',
        'Customer Default Groups:' => '고객 기본 그룹 :',
        'No changes can be made to these groups.' => '이 그룹은 변경할 수 없습니다.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => '이 그룹/대기열에 있는 티켓에 대한 읽기 전용 액세스.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            '이 그룹/대기열의 티켓에 대한 전체 읽기 및 쓰기 액세스',

        # Template: AdminCustomerUser
        'Customer User Management' => '고객 사용자 관리',
        'Add Customer User' => '고객 사용자 추가',
        'Edit Customer User' => '고객 사용자 편집',
        'Back to search results' => '검색 결과로 돌아가기',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '고객 사용자는 고객 기록을 보유하고 고객 패널을 통해 로그인해야 합니다.',
        'List (%s total)' => '목록 (%s 총)',
        'Username' => '사용자 이름',
        'Email' => '이메일',
        'Last Login' => '마지막 로그인',
        'Login as' => '다음 계정으로 로그인',
        'Switch to customer' => '고객 전환',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '이 고객 백엔드는 읽기 전용이지만 고객 사용자 기본 설정은 변경할 수 있습니다!',
        'This field is required and needs to be a valid email address.' =>
            '이 필드는 필수이며 올바른 이메일 주소여야 합니다.',
        'This email address is not allowed due to the system configuration.' =>
            '이 이메일 주소는 시스템 구성으로 인해 허용되지 않습니다.',
        'This email address failed MX check.' => '이 이메일 주소는 mx 확인에 실패했습니다.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS 문제, 구성 및 오류로그를 확인하십시오.',
        'The syntax of this email address is incorrect.' => '이 전자 메일 주소의 구문이 잘못되었습니다.',
        'This CustomerID is invalid.' => '이 CustomerID는 유효하지 않습니다.',
        'Effective Permissions for Customer User' => '고객 사용자를 위한 효과적인 권한',
        'Group Permissions' => '그룹 사용 권한',
        'This customer user has no group permissions.' => '이 고객 사용자에게는 그룹 권한이 없습니다.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '위의 표는 고객 사용자에 대한 효과적인 그룹 권한을 보여줍니다. 매트릭스는 모든 상속 된 권한 (예 : 고객 그룹을 통해)을 고려합니다. 참고 :이 표는 제출하지 않고이 양식의 변경 사항을 고려하지 않습니다.',
        'Customer Access' => '고객 엑세스',
        'Customer' => '고객',
        'This customer user has no customer access.' => '이 고객 사용자에게는 고객 액세스 권한이 없습니다.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '위의 표는 권한 컨텍스트를 통해 고객 사용자에 대해 부여 된 고객 액세스를 보여줍니다. 행렬은 모든 상속 된 액세스 (예 : 고객 그룹을 통해)를 고려합니다. 참고 :이 표는 제출하지 않고이 양식의 변경 사항을 고려하지 않습니다',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '고객 사용자 - 고객 관계 관리',
        'Select the customer user:customer relations.' => '고객 사용자 : 고객 관계를 선택하십시오.',
        'Customer Users' => '고객 사용자',
        'Change Customer Relations for Customer User' => '고객 사용자를 위한 고객관계 변경',
        'Change Customer User Relations for Customer' => '고객의 고객 사용자 관계 변경',
        'Toggle active state for all' => '모든 사용자의 활성 상태를 토글합니다.',
        'Active' => '유효한',
        'Toggle active state for %s' => '%s의 활성 상태 토글',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '고객 사용자 - 그룹 관계 관리',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '고객 사용자에 대한 그룹 권한을 정의하려면 이 기능을 사용하십시오.',
        'Edit Customer User Default Groups' => '고객 사용자 기본 그룹 편집',
        'These groups are automatically assigned to all customer users.' =>
            '이 그룹은 모든 고객 사용자에게 자동으로 할당됩니다.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '"CustomerGroupAlwaysGroups"구성 설정을 통해 이러한 그룹을 관리 할 수 ​​있습니다.',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '고객 사용자 - 그룹 권한을 선택하십시오.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '아무 것도 선택하지 않으면이 그룹에 권한이 없습니다 (티켓을 고객 사용자가 사용할 수 없음).',
        'Customer User Default Groups:' => '고객 사용자 기본 그룹 : ',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => '기본 서비스 수정',
        'Filter for Services' => '서비스 필터링',
        'Filter for services' => '서비스 필터링',
        'Services' => '서비스',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '동적 필드 관리',
        'Add new field for object' => '객체에 대한 새 필드 추가',
        'Filter for Dynamic Fields' => '동적 필드 필터링',
        'Filter for dynamic fields' => '동적 필드 필터링',
        'More Business Fields' => '더 많은 사업 분야',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '비즈니스를위한 추가적인 동적 필드 유형의 혜택을 원하십니까? 다음 필드 유형에 액세스하려면 %s로 업그레이드하십시오.',
        'Database' => '데이터베이스',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '이 동적 필드에 대해 외부 데이터베이스를 구성 가능한 데이터 소스로 사용하십시오.',
        'Web service' => '웹 서비스',
        'External web services can be configured as data sources for this dynamic field.' =>
            '외부 웹 서비스는 이 동적 필드의 데이터 소스로 구성될 수 있습니다.',
        'Contact with data' => '데이터 연락처',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '이 기능을 사용하면 데이터가 있는 연락처를 티켓에 추가 할 수 있습니다.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '새 필드를 추가하려면 객체 목록 중 하나에서 필드 유형을 선택하십시오. 객체는 필드의 경계를 정의하며 필드 작성 후에는 변경할 수 없습니다.',
        'Dynamic Fields List' => '동적 필드 목록',
        'Dynamic fields per page' => '페이지 당 동적 필드',
        'Label' => '상표',
        'Order' => '주문',
        'Object' => '목적',
        'Delete this field' => '이 입력란을 삭제하십시오.',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '동적 필드',
        'Go back to overview' => '개요로 돌아가기',
        'General' => '일반',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '이 필드는 필수이며 값은 영숫자여야 합니다.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '고유해야하며 영문자의 숫자만 사용할 수 있습니다.',
        'Changing this value will require manual changes in the system.' =>
            '이 값을 변경하면 시스템에서 수동으로 변경해야 합니다.',
        'This is the name to be shown on the screens where the field is active.' =>
            '필드가 활성화된 화면에 표시할 이름 입니다.',
        'Field order' => '필드 주문',
        'This field is required and must be numeric.' => '이 필드는 필수이며 숫자여야 합니다.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '이 필드가 활성화 된 화면에 표시되는 순서입니다.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '이 항목을 무효화 할 수 없으므로 모든 구성 설정을 미리 변경해야 합니다.',
        'Field type' => '필드 유형',
        'Object type' => '객체 유형',
        'Internal field' => '내부 필드',
        'This field is protected and can\'t be deleted.' => '이 필드는 보호되어 있으며 삭제할 수 없습니다.',
        'This dynamic field is used in the following config settings:' =>
            '이 동적 필드는 다음 구성 설정에서 사용됩니다.',
        'Field Settings' => '필드 설정',
        'Default value' => '기본값',
        'This is the default value for this field.' => '이 필드의 기본값입니다.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '기본 날짜 차이',
        'This field must be numeric.' => '이 필드는 숫자여야 합니다.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '필드 기본값 (예 : 3600 또는 -60)을 계산하는 NOW와의 차이 (초)입니다.',
        'Define years period' => '년 기간 정의',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '이 기능을 활성화하여 필드의 연도 부분에 표시 할 고정 된 미래 범위 (미래 및 과거)를 정의합니다.',
        'Years in the past' => '과거의 세월',
        'Years in the past to display (default: 5 years).' => '과거의 연도 (기본값 : 5 년).',
        'Years in the future' => '미래의 해',
        'Years in the future to display (default: 5 years).' => '장래에 표시 할 연도 (기본값 : 5 년).',
        'Show link' => '링크 표시',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '개요 및 확대 / 축소 화면에서 필드 값에 대한 선택적 HTTP 링크를 지정할 수 있습니다.',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => '예',
        'Link for preview' => '미리보기 링크',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '입력되면이 URL은 미리보기로 사용되며이 링크는 티켓 확대시 표시됩니다. 이 기능을 사용하려면 위의 일반 URL 입력란도 채워야합니다.',
        'Restrict entering of dates' => '날짜 입력 제한',
        'Here you can restrict the entering of dates of tickets.' => '여기에서 티켓 날짜 입력을 제한할 수 있습니다.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '가능한 값',
        'Key' => '키',
        'Value' => '값',
        'Remove value' => '값 삭제',
        'Add value' => '값 추가',
        'Add Value' => '값 추가',
        'Add empty value' => '빈 값 추가',
        'Activate this option to create an empty selectable value.' => '빈 선택 가능 값을 작성하려면 이 옵션을 활성화 하십시오.',
        'Tree View' => '트리 보기',
        'Activate this option to display values as a tree.' => '값을 트리로 표시하려면 이 옵션을 활성화 하십시오.',
        'Translatable values' => '번역 가능한 값',
        'If you activate this option the values will be translated to the user defined language.' =>
            '이 옵션을 활성화하면 값이 사용자 정의 언어로 변환됩니다.',
        'Note' => '노트',
        'You need to add the translations manually into the language translation files.' =>
            '언어 변환 파일에 수동으로 번역을 추가해야 합니다.',

        # Template: AdminDynamicFieldText
        'Number of rows' => '행 수',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '편집 모드에서이 필드의 높이를 (줄 단위로) 지정하십시오.',
        'Number of cols' => '열 수',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '편집 모드에서이 필드의 너비 (문자)를 지정하십시오.',
        'Check RegEx' => 'RegEx 확인',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '여기서 정규 표현식을 지정하여 값을 확인할 수 있습니다. 정규 표현식은 xms 수정 자로 실행됩니다.',
        'RegEx' => '정규 표현식',
        'Invalid RegEx' => '정규식이 잘못되었습니다.',
        'Error Message' => '에러 메시지',
        'Add RegEx' => '정규 표현식 추가',

        # Template: AdminEmail
        'Admin Message' => '관리자 메시지',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '이 모듈을 사용하여 관리자는 에이전트, 그룹 또는 역할 구성원에게 메시지를 보낼 수 있습니다.',
        'Create Administrative Message' => '관리 메시지 작성',
        'Your message was sent to' => '귀하의 메시지를 보냈습니다.',
        'From' => '에서',
        'Send message to users' => '사용자에게 메시지 보내기',
        'Send message to group members' => '그룹 회원에게 메시지 보내기',
        'Group members need to have permission' => '그룹 회원은 허가를 받아야합니다.',
        'Send message to role members' => '역할 멤버에게 메시지 보내기',
        'Also send to customers in groups' => '또한 그룹으로 고객에게 보내기',
        'Body' => '신체',
        'Send' => '보내다',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => '마지막 실행',
        'Run Now!' => '지금 실행!',
        'Delete this task' => '이 작업 삭제',
        'Run this task' => '이 작업 실행',
        'Job Settings' => '작업 설정',
        'Job name' => '작업 이름',
        'The name you entered already exists.' => '입렵한 이름이 이미 있습니다.',
        'Automatic Execution (Multiple Tickets)' => '자동 실행 (다중 티켓)',
        'Execution Schedule' => '실행 일정',
        'Schedule minutes' => '분 일정',
        'Schedule hours' => '시간 계획',
        'Schedule days' => '하루 일정',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            '현재 이 일반 에이전트 작업은 자동으로 실행되지 않습니다.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '자동 실행을 사용하려면 분, 시간 및 일 중 적어도 하나의 값을 선택하십시오!',
        'Event Based Execution (Single Ticket)' => '이벤트 기반 실행 (단일 티켓)',
        'Event Triggers' => '이벤트 트리거',
        'List of all configured events' => '구성된 모든 이벤트 목록',
        'Delete this event' => '이 일정 삭제',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '주기적 실행에 추가적으로 또는 대신에 이 작업을 트리거 할 티켓 이벤트를 정의할 수 있습니다.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '티켓 이벤트가 발생하면 티켓이 일치하는지 확인하기 위해 티켓 필터가 적용됩니다. 그런 다음에 만 해당 티켓에서 작업이 실행됩니다.',
        'Do you really want to delete this event trigger?' => '이 이벤트 트리거를 정말로 삭제 하시겠습니까?',
        'Add Event Trigger' => '이벤트 트리거 추가',
        'To add a new event select the event object and event name' => '새 이벤트를 추가하려면 이벤트 객체와 이벤트 이름을 선택하십시오.',
        'Select Tickets' => '티켓 선택',
        '(e. g. 10*5155 or 105658*)' => '(예를 들어, 10 * 5155 또는 105658 *)',
        '(e. g. 234321)' => '(예를 들어, 234321)',
        'Customer user ID' => '고객 사용자 ID',
        '(e. g. U5150)' => '(예를 들어, U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '기사에서 전체 텍스트 검색 (예 : "Mar * in"또는 "Baue *").',
        'To' => '수신',
        'Cc' => '참조',
        'Service' => '서비스',
        'Service Level Agreement' => '서비스 레벨 동의',
        'Queue' => '대기열',
        'State' => '상태',
        'Agent' => '상담원',
        'Owner' => '소유자',
        'Responsible' => '책임있는',
        'Ticket lock' => '티켓 잠금',
        'Dynamic fields' => '동적 필드',
        'Add dynamic field' => '',
        'Create times' => '생성시간',
        'No create time settings.' => '생성 시간이 설정되지 않았습니다.',
        'Ticket created' => '티켓이 생성되었습니다.',
        'Ticket created between' => '티켓 생성됨, 기간',
        'and' => '그리고',
        'Last changed times' => '최종 변경 시간',
        'No last changed time settings.' => '마지막으로 변경된 시간 설정이 없습니다.',
        'Ticket last changed' => '마지막으로 변경된 티켓',
        'Ticket last changed between' => '마지막으로 변경된 티켓',
        'Change times' => '시간 변경',
        'No change time settings.' => '변경 시간 설정이 없습니다.',
        'Ticket changed' => '티켓 변경됨',
        'Ticket changed between' => '티켓 변경 사이',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => '끝나는 시간',
        'No close time settings.' => '가까운 시간 설정이 없습니다.',
        'Ticket closed' => '티켓이 폐쇄되었습니다.',
        'Ticket closed between' => '사이에 폐쇄된 티켓',
        'Pending times' => '보류 시간',
        'No pending time settings.' => '대기중인 시간 설정이 없습니다.',
        'Ticket pending time reached' => '티켓 대기 시간에 도달했습니다.',
        'Ticket pending time reached between' => '티켓 대기 시간 사이',
        'Escalation times' => '에스컬레이션 시간',
        'No escalation time settings.' => '에스컬레이션 시간 설정이 없습니다.',
        'Ticket escalation time reached' => '티켓 확대 시간 도달',
        'Ticket escalation time reached between' => '티켓 이관 시간에 도달했습니다.',
        'Escalation - first response time' => '에스컬레이션 - 첫 번째 응답 시간',
        'Ticket first response time reached' => '첫 번째 응답 시간에 도달한 티켓',
        'Ticket first response time reached between' => '첫 번째 응답 시간은 다음 사이에 도달했습니다.',
        'Escalation - update time' => '이관 - 업데이트 시간',
        'Ticket update time reached' => '티켓 업데이트 시간에 도달했습니다.',
        'Ticket update time reached between' => '티켓 업데이트 시간이 사이에 도달했습니다.',
        'Escalation - solution time' => '에스컬레이션 - 솔루션 시간',
        'Ticket solution time reached' => '티켓 솔루션 시간 도달',
        'Ticket solution time reached between' => '티켓 솔루션 시간이 ~ 사이에 도달했습니다.',
        'Archive search option' => '아카이브 검색 옵션',
        'Update/Add Ticket Attributes' => '티켓 속성 업데이트 / 추가',
        'Set new service' => '새 서비스 설정',
        'Set new Service Level Agreement' => '새로운 서비스 수준 계약 설정',
        'Set new priority' => '새로운 우선 순위 설정',
        'Set new queue' => '새 대기열 설정',
        'Set new state' => '새 상태 설정',
        'Pending date' => '대기 중인 날짜',
        'Set new agent' => '새 에이전트 설정',
        'new owner' => '새 주인',
        'new responsible' => '새로운 책임',
        'Set new ticket lock' => '새 티켓 잠금 설정',
        'New customer user ID' => '신규 고객 사용자 ID',
        'New customer ID' => '신규 고객 ID',
        'New title' => '새 직함',
        'New type' => '새로운 유형',
        'Archive selected tickets' => '선택한 티켓 보관 처리',
        'Add Note' => '메모 추가',
        'Visible for customer' => '고객에게 공개',
        'Time units' => '시간 단위',
        'Execute Ticket Commands' => '티켓 명령 실행',
        'Send agent/customer notifications on changes' => '변경 사항에 대한 상담원 / 고객 알림 보내기',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            '이 명령이 실행됩니다. ARG [0]이 티켓 번호입니다. ARG [1] 티켓 ID.',
        'Delete tickets' => '티켓 삭제',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '경고 : 영향을받는 모든 티켓이 데이터베이스에서 제거되어 복원 할 수 없습니다!',
        'Execute Custom Module' => '사용자 정의 모듈 실행',
        'Param %s key' => 'Param %s 키',
        'Param %s value' => '매개 변수 %s 값',
        'Results' => '결과',
        '%s Tickets affected! What do you want to do?' => '영향을받은 티켓 %s 개! 뭐하고 싶어?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '경고 : DELETE 옵션을 사용했습니다. 삭제 된 티켓은 모두 삭제됩니다!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '경고 : %s개의 티켓이 영향을 받지만, 한 번의 작업 실행 중에 %s의 수정 만있을 수 있습니다!',
        'Affected Tickets' => '영향받은 티켓',
        'Age' => '생성이후',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'GenericInterface 웹 서비스 관리',
        'Web Service Management' => '웹서비스 관리',
        'Debugger' => '디버거',
        'Go back to web service' => '웹서비스로 돌아가기',
        'Clear' => '제거',
        'Do you really want to clear the debug log of this web service?' =>
            '이 웹 서비스의 디버그 로그를 정말로 지우시겠습니까?',
        'Request List' => '요청 목록',
        'Time' => '시간',
        'Communication ID' => '통신 ID',
        'Remote IP' => '원격 IP',
        'Loading' => '로딩중',
        'Select a single request to see its details.' => '세부 정보를 보려면 단일 요청을 선택하십시오.',
        'Filter by type' => '유형별 필터링',
        'Filter from' => '필터 : ',
        'Filter to' => '~에 필터링',
        'Filter by remote IP' => '원격 IP로 필터링',
        'Limit' => '한도',
        'Refresh' => '새롭게 하다',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'ErrorHandling 추가',
        'Edit ErrorHandling' => 'ErrorHandling 편집',
        'Do you really want to delete this error handling module?' => '이 오류 처리 모듈을 정말로 삭제 하시겠습니까?',
        'All configuration data will be lost.' => '모든 구성 데이터가 손실됩니다.',
        'General options' => '일반 옵션',
        'The name can be used to distinguish different error handling configurations.' =>
            '이 이름은 다른 오류 처리 구성을 구분하는데 사용할 수 있습니다.',
        'Please provide a unique name for this web service.' => '이 웹 서비스에 고유한 이름을 입력하십시오.',
        'Error handling module backend' => '오류 처리 모듈 백엔드',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            '이 OTRS 오류 처리 백엔드 모듈은 내부적으로 호출되어 오류 처리 메커니즘을 처리합니다.',
        'Processing options' => '처리 옵션',
        'Configure filters to control error handling module execution.' =>
            '오류 처리 모듈 실행을 제어하는 필터를 구성합니다.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '모든 구성된 필터 (있는 경우)와 일치하는 요청 만 모듈 실행을 트리거합니다.',
        'Operation filter' => '작동 필터',
        'Only execute error handling module for selected operations.' => '선택한 작업에 대해서만 오류 처리 모듈을 실행하십시오.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '주 : 들어오는 요청 데이터를 수신하는 중 발생한 오류에 대해서는 조작이 결정되지 않습니다. 이 오류 단계와 관련된 필터는 작동 필터를 사용하지 않아야합니다.',
        'Invoker filter' => '호출자 필터',
        'Only execute error handling module for selected invokers.' => '선택한 호출자에 대해서만 오류 처리 모듈을 실행하십시오.',
        'Error message content filter' => '오류 메시지 내용 필터',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '오류 처리 모듈을 실행할 오류 메시지를 제한하는 정규 표현식을 입력하십시오.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '오류 메시지 제목과 데이터 (디버거 오류 항목에서 볼 수 있음)는 일치하는 것으로 간주됩니다.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '오류 단계 필터',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '특정 처리 단계에서 발생하는 오류에 대해서만 오류 처리 모듈을 실행하십시오.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '예 : 나가는 데이터에 대한 매핑을 적용 할 수없는 오류 만 처리하십시오.',
        'Error code' => '에러 코드',
        'An error identifier for this error handling module.' => '이 오류 처리 모듈의 오류 식별자입니다.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '이 식별자는 XSLT-Mapping에서 사용할 수 있으며 디버거 출력에 표시됩니다.',
        'Error message' => '에러 메시지',
        'An error explanation for this error handling module.' => '이 오류 처리 모듈에 대한 오류 설명.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '이 메시지는 XSLT-Mapping에서 사용할 수 있으며 디버거 출력에 표시됩니다.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '모듈이 실행 된 후 처리가 중단되어야하는지, 남은 모듈을 모두 건너 뛰는 지 또는 같은 백엔드의 모듈 만 건너 뛰는지를 정의하십시오.',
        'Default behavior is to resume, processing the next module.' => '기본 동작은 다음 모듈을 다시 시작하여 처리하는 것입니다.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '이 모듈을 사용하여 실패한 요청에 대한 스케줄 된 재시도를 구성할 수 있습니다.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'GenericInterface 웹 서비스의 기본 동작은 각 요청을 정확히 한 번 보내고 오류가 발생하면 다시 예약하지 않는 것입니다.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '개별 요청에 대해 재시도 일정을 설정할 수있는 둘 이상의 모듈이 실행되면 마지막으로 실행 된 모듈이 신뢰할 수 있고 재시도 일정이 결정됩니다',
        'Request retry options' => '재시도 옵션 요청',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '재 시도 옵션은 요청이 오류 처리 모듈 실행을 유발할 때 (처리 옵션에 따라) 적용됩니다.',
        'Schedule retry' => '일정 다시 시도',
        'Should requests causing an error be triggered again at a later time?' =>
            '오류가 발생한 요청을 나중에 다시 트리거해야 합니까?',
        'Initial retry interval' => '초기 재시도 간격',
        'Interval after which to trigger the first retry.' => '첫 번째 다시 시도를 트리거할 간격입니다.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '주 :이 W 모든 재 시도 간격은 초기 요청에 대한 오류 핸들링 모듈 실행 시간으로합니다. ',
        'Factor for further retries' => '추가 재시도를 위한 요인',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '첫 번째 재 시도 후에도 요청이 오류를 리턴하면 후속 재시도가 동일한 간격 또는 증가 간격으로 트리거되는지 정의하십시오.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '예 : 초기 간격이 \'1 분\'이고 재시도 비율이 \'2\'인 요청을 초기에 10:00에 실행하면 재시도는 10:01 (1 분), 10:03 (2 * 1 = 2 분), 10:07 (2 * 2 = 4 분), 10:15 (2 * 4 = 8 분), ...',
        'Maximum retry interval' => '최대 재시도 간격',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '재 시도 간격 계수 \'1.5\'또는 \'2\'가 선택되면, 허용되는 최대 간격을 정의하여 바람직하지 않게 긴 간격을 방지 할 수 있습니다.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '최대 재시도 간격을 초과하도록 계산 된 간격은 그에 따라 자동으로 단축됩니다.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '예 : 초기 간격이 \'1 분\'인 요청을 10:00에 시작하고 \'2\'에서 다시 시도하고 \'5 분\'에서 최대 간격을 재 시도하면 재시도가 10:01 (1 분), 10 : 03 (2 분), 10:07 (4 분), 10:12 (8 => 5 분), 10:17, ',
        'Maximum retry count' => '최대 재시도 횟수',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '초기 요청을 계산하지 않고 실패한 요청을 버리기 전에 최대 재시도 횟수.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '예 : 초기 간격이 \'1 분\'인 요청을 10:00에 처음 시작하고 \'2\'에서 재시도 계수를, \'2\'에서 최대 재시도 계수를 재 시도하면 재시도가 10시 01 분 및 10시 02 분에만 트리거됩니다.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '참고 : 최대 재시도 횟수가 최대로 설정되고 이전에 도달하면 최대 재시도 횟수에 도달하지 못할 수도 있습니다.',
        'This field must be empty or contain a positive number.' => '이 필드는 비어 있거나 양수를 포함해야 합니다.',
        'Maximum retry period' => '최대 재시도 기간',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '실패한 요청이 재 시도되기 전까지의 최대 재 시도 시간 (초기 요청에 대한 오류 처리 모듈 실행 시간에 기반).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '최대 기간이 경과 한 후 (재시도 간격 계산에 따라) 일반적으로 트리거되는 재시도는 자동으로 최대 기간에 자동으로 트리거됩니다.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '예 : 초기 간격이 \'1 분\'인 요청을 10:00에 시작하고 \'2\'에서 재시도 계수를, \'30 분 \'에서 최대 재시도 기간을 시작하면 재시도가 10:01, 10:03, 10시 07 분, 10시 15 분 그리고 마침내 10시 31 분 => 10시 30 분.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '참고 : 최대 재시도 횟수가 구성되어 있고 이전에 도달 한 경우 최대 재시도 기간에 도달하지 못할 수 있습니다.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '호출자 추가',
        'Edit Invoker' => '호출자 편집',
        'Do you really want to delete this invoker?' => '이 호출자를 정말로 삭제 하시겠습니까?',
        'Invoker Details' => '호출자 세부 정보',
        'The name is typically used to call up an operation of a remote web service.' =>
            '이름은 일반적으로 원격 웹 서비스의 작업을 호출하는데 사용됩니다.',
        'Invoker backend' => '호출자 백엔드',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '이 OTRS 호출자 백엔드 모듈은 원격 시스템에 전송할 데이터를 준비하고 응답 데이터를 처리하기 위해 호출됩니다.',
        'Mapping for outgoing request data' => '나가는 요청 데이터 매핑',
        'Configure' => '구성',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'OTRS 호출자의 데이터는이 매핑에 의해 처리되어 원격 시스템이 예상하는 종류의 데이터로 변환됩니다.',
        'Mapping for incoming response data' => '들어오는 응답 데이터 매핑',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '응답 데이터는이 매핑에 의해 처리되어 OTRS의 호출자가 예상하는 종류의 데이터로 변환됩니다.',
        'Asynchronous' => '비동기식',
        'Condition' => '조건',
        'Edit this event' => '이 일정 수정',
        'This invoker will be triggered by the configured events.' => '이 호출자는 구성된 이벤트에 의해 트리거됩니다.',
        'Add Event' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '새 이벤트를 추가하려면 이벤트 객체와 이벤트 이름을 선택하고 "+"버튼을 클릭하십시오.',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '비동기 이벤트 트리거는 백그라운드에서 OTRS Scheduler Daemon에 의해 처리됩니다 (권장).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '동기 이벤트 트리거는 웹 요청 중에 직접 처리됩니다.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '웹 서비스 %s의 GenericInterface Invoker 이벤트 설정',
        'Go back to' => '돌아가기',
        'Delete all conditions' => '모든 조건 삭제',
        'Do you really want to delete all the conditions for this event?' =>
            '이 이벤트의 모든 조건을 정말로 삭제하시겠습니까?',
        'General Settings' => '일반 설정',
        'Event type' => '이벤트 유형',
        'Conditions' => '조건',
        'Conditions can only operate on non-empty fields.' => '조건은 비어있지 않은 필드에서만 작동할 수 있습니다.',
        'Type of Linking between Conditions' => '조건 간 연결 유형',
        'Remove this Condition' => '이 조건 삭제',
        'Type of Linking' => '연결 유형',
        'Fields' => '전지',
        'Add a new Field' => '새 필드 추가',
        'Remove this Field' => '이 필드 삭제',
        'And can\'t be repeated on the same condition.' => '그리고 같은 조건에서 반복될 수는 없습니다.',
        'Add New Condition' => '새 조건 추가',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => '단순 매핑',
        'Default rule for unmapped keys' => '맵핑되지 않은 키의 기본 규칙',
        'This rule will apply for all keys with no mapping rule.' => '이 규칙은 매핑 규칙이없는 모든 키에 적용됩니다.',
        'Default rule for unmapped values' => '매핑되지 않은 값의 기본 규칙',
        'This rule will apply for all values with no mapping rule.' => '이 규칙은 매핑 규칙이없는 모든 값에 적용됩니다.',
        'New key map' => '새 키 맵',
        'Add key mapping' => '키 매핑 추가',
        'Mapping for Key ' => '키 매핑',
        'Remove key mapping' => '키 매핑 제거',
        'Key mapping' => '키 매핑',
        'Map key' => '키 지도',
        'matching the' => '일치하는',
        'to new key' => '새로운 열쇠에',
        'Value mapping' => '값 매핑',
        'Map value' => '지도 값',
        'to new value' => '새로운 가치로',
        'Remove value mapping' => '값 매핑 제거',
        'New value map' => '새로운 가치지도',
        'Add value mapping' => '값 매핑 추가',
        'Do you really want to delete this key mapping?' => '이 키 매핑을 정말로 삭제 하시겠습니까?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '일반 단축키',
        'MacOS Shortcuts' => 'MacOS 단축키',
        'Comment code' => '주석 코드',
        'Uncomment code' => '코드 주석 처리 해제',
        'Auto format code' => '자동 형식 코드',
        'Expand/Collapse code block' => '확장 / 축소 코드 블록',
        'Find' => '찾기',
        'Find next' => '다음 찾기',
        'Find previous' => '이전 찾기',
        'Find and replace' => '찾기 및 바꾸기',
        'Find and replace all' => '모두 찾기 및 바꾸기',
        'XSLT Mapping' => 'XSLT 매핑',
        'XSLT stylesheet' => 'XSLT 스타일 시트',
        'The entered data is not a valid XSLT style sheet.' => '입력 한 데이터가 유효한 XSLT 스타일 시트가 아닙니다.',
        'Here you can add or modify your XSLT mapping code.' => '여기에서 XSLT 매핑 코드를 추가하거나 수정할 수 있습니다.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '편집 필드에서는 자동 서식 지정, 창 크기 조정, 태그 및 대괄호 완성과 같은 다른 기능을 사용할 수 있습니다.',
        'Data includes' => '데이터 포함',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '이전 요청 / 응답 단계에서 생성 된 하나 이상의 데이터 집합을 표시 가능한 데이터에 포함되도록 선택합니다.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '이러한 세트는 \'/ DataInclude / 1\'의 데이터 구조에 표시됩니다 (자세한 내용은 실제 요청의 디버거 출력 참조).',
        'Data key regex filters (before mapping)' => '데이터 키 정규식 필터 (매핑 전)',
        'Data key regex filters (after mapping)' => '데이터 키 정규식 필터 (매핑 후)',
        'Regular expressions' => '정규 표현식',
        'Replace' => '바꾸다',
        'Remove regex' => '정규식 제거',
        'Add regex' => '정규 표현식 추가',
        'These filters can be used to transform keys using regular expressions.' =>
            '이러한 필터는 정규식을 사용하여 키를 변환하는 데 사용할 수 있습니다.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '데이터 구조는 재귀 적으로 탐색되고 구성된 모든 정규 표현식이 모든 키에 적용됩니다.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '사용 사례는 예 : 원하지 않는 키 접 두부를 제거하거나 유효하지 않은 키 요소를 XML 요소 이름으로 수정합니다.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '예 1 : Search = \'^ jira :\'/ Replace = \'\'는 \'jira : element\'를 \'element\'로 변환합니다.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '예 2 : Search = \'^\'/ Replace = \'_\'는 \'16x16\'을 \'_16x16\'으로 바꿉니다.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            'Perl의 정규 표현식에 대한 정보는 다음을 참조하십시오 :',
        'Perl regular expressions tutorial' => '펄 정규 표현식 튜토리얼',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '수정자가 필요한 경우 정규 표현식 자체 내에서 지정해야합니다.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '여기에 정의 된 정규 표현식은 XSLT 매핑 전에 적용됩니다.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '여기에 정의 된 정규 표현식은 XSLT 매핑 후에 적용됩니다.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '작업 추가',
        'Edit Operation' => '조작 편집',
        'Do you really want to delete this operation?' => '정말로 이 작업을 삭제 하시겠습니까?',
        'Operation Details' => '작업 세부 정보',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '이름은 일반적으로 원격 시스템에서이 웹 서비스 조작을 호출하는 데 사용됩니다.',
        'Operation backend' => '작업 백엔드',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '이 OTRS 연산 백엔드 모듈은 내부적으로 호출되어 요청을 처리하고 응답 데이터를 생성합니다.',
        'Mapping for incoming request data' => '들어오는 요청 데이터 매핑',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '요청 데이터는이 매핑에 의해 처리되어 OTRS가 예상하는 종류의 데이터로 변환됩니다.',
        'Mapping for outgoing response data' => '발신 응답 데이터 매핑',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '응답 데이터는이 매핑에 의해 처리되어 원격 시스템이 예상하는 종류의 데이터로 변환합니다.',
        'Include Ticket Data' => '티켓 데이터 포함',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '네트워크 전송',
        'Properties' => '속성',
        'Route mapping for Operation' => '운영을 위한 경로 매핑',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '이 작업에 매핑되어야하는 경로를 정의하십시오. \':\'로 표시된 변수는 입력 된 이름에 매핑되고 다른 변수와 함께 매핑에 전달됩니다. (예 : / Ticket / : TicketID).',
        'Valid request methods for Operation' => 'Operation에 대한 유효한 요청 메소드',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '이 작동을 특정 요청 방법으로 제한하십시오. 메서드를 선택하지 않으면 모든 요청이 수락됩니다.',
        'Maximum message length' => '최대 메시지 길이',
        'This field should be an integer number.' => '이 필드는 정수여야 합니다.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '여기서 OTRS가 처리 할 REST 메시지의 최대 크기 (바이트)를 지정할 수 있습니다.',
        'Send Keep-Alive' => 'Keep-Alive 보내기',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '이 구성은 들어오는 연결이 닫히거나 살아 있어야 하는지를 정의합니다.',
        'Additional response headers' => '추가 응답 헤더',
        'Add response header' => '응답 헤더 추가',
        'Endpoint' => '종점',
        'URI to indicate specific location for accessing a web service.' =>
            '웹 서비스에 액세스하기위한 특정 위치를 나타내는 URI.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '예 : https://www.otrs.com:10745/api/v1.0( 후행 백 슬래시 없음)',
        'Timeout' => '제한시간',
        'Timeout value for requests.' => '요청에 대한 시간 초과값 입니다.',
        'Authentication' => '입증',
        'An optional authentication mechanism to access the remote system.' =>
            '원격 시스템에 액세스하기 위한 선택적인 인증 메커니즘.',
        'BasicAuth User' => 'BasicAuth 사용자',
        'The user name to be used to access the remote system.' => '원격 시스템에 액세스하는 데 사용할 사용자 이름.',
        'BasicAuth Password' => 'BasicAuth 비밀번호',
        'The password for the privileged user.' => '권한있는 사용자의 암호입니다.',
        'Use Proxy Options' => '프록시 옵션 사용',
        'Show or hide Proxy options to connect to the remote system.' => '원격 시스템에 연결하기위한 프록시 옵션 표시 또는 숨기기.',
        'Proxy Server' => '프록시 서버',
        'URI of a proxy server to be used (if needed).' => '사용할 프록시 서버의 URI (필요한 경우).',
        'e.g. http://proxy_hostname:8080' => '예 : http://proxy_hostname:8080',
        'Proxy User' => '프록시 사용자',
        'The user name to be used to access the proxy server.' => '프록시 서버에 액세스하는 데 사용할 사용자 이름입니다.',
        'Proxy Password' => '프록시 비밀번호',
        'The password for the proxy user.' => '프록시 사용자의 암호입니다.',
        'Skip Proxy' => '프록시 건너 뛰기',
        'Skip proxy servers that might be configured globally?' => '전 세계적으로 구성될 수 있는 프록시 서버를 건너 뛰십시오.',
        'Use SSL Options' => 'SSL 옵션 사용',
        'Show or hide SSL options to connect to the remote system.' => '원격 시스템에 연결할 SSL 옵션을 표시하거나 숨 깁니다.',
        'Client Certificate' => '클라이언트 인증서',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'SSL 클라이언트 인증서 파일의 전체 경로 및 이름 (PEM, DER 또는 PKCS # 12 형식이어야 함).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => '예 : /opt/otrs/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => '클라이언트 인증서 키',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'SSL 클라이언트 인증서 키 파일의 전체 경로 및 이름 (아직 인증서 파일에 포함되어 있지 않은 경우).',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => '예 : /opt/otrs/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => '클라이언트 인증서 키 암호',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '키가 암호화 된 경우 SSL 인증서를 여는 암호입니다.',
        'Certification Authority (CA) Certificate' => '인증 기관 (CA) 인증서',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'SSL 인증서의 유효성을 검사하는 인증 기관 인증서 파일의 전체 경로 및 이름입니다.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '예 : /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '인증 기관 (CA) 디렉토리',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'CA 인증서가 파일 시스템에 저장되는 인증 기관 디렉토리의 전체 경로입니다.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '예 : / opt / otrs / var / certificates / SOAP / CA',
        'Controller mapping for Invoker' => '호출자에 대한 컨트롤러 매핑',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '호출자가 요청을 보내야하는 컨트롤러. \':\'로 표시된 변수는 데이터 값으로 대체되고 요청과 함께 전달됩니다. (예 : / Ticket / : TicketID? UserLogin = : UserLogin & Password = : Password).',
        'Valid request command for Invoker' => '호출자에 대한 유효한 요청 명령',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '이 Invoker (선택 사항)로 요청에 사용할 특정 HTTP 명령입니다.',
        'Default command' => '기본 명령',
        'The default HTTP command to use for the requests.' => '요청에 사용할 기본 HTTP 명령입니다.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '예 : https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'SOAPAction 설정',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '채워진 SOAPAction 헤더를 보내려면 "Yes"로 설정하십시오.',
        'Set to "No" in order to send an empty SOAPAction header.' => '빈 SOAPAction 헤더를 보내려면 "아니오"로 설정하십시오.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '수신 된 SOAPAction 헤더를 확인하려면 "예"로 설정하십시오 (비어 있지 않은 경우).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '수신 된 SOAPAction 헤더를 무시하려면 "아니오"로 설정하십시오.',
        'SOAPAction scheme' => 'SOAPAction 체계',
        'Select how SOAPAction should be constructed.' => 'SOAPAction을 구성하는 방법을 선택하십시오.',
        'Some web services require a specific construction.' => '일부 웹 서비스에는 특정 구성이 필요합니다.',
        'Some web services send a specific construction.' => '일부 웹 서비스는 특정 구성을 보냅니다.',
        'SOAPAction separator' => 'SOAPAction 구분 기호',
        'Character to use as separator between name space and SOAP operation.' =>
            '이름 공간과 SOAP 조작 간의 단락 문자로서 사용하는 캐릭터.',
        'Usually .Net web services use "/" as separator.' => '일반적으로 .Net 웹 서비스는 구분 기호로 "/"를 사용합니다.',
        'SOAPAction free text' => 'SOAPAction 자유 텍스트',
        'Text to be used to as SOAPAction.' => 'SOAPAction로서 사용되는 텍스트.',
        'Namespace' => '네임 스페이스',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI는 SOAP 메소드에 컨텍스트를 제공하여 모호성을 줄입니다.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '예 : urn : otrs-com : soap : 함수 또는 http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => '요청 이름 체계',
        'Select how SOAP request function wrapper should be constructed.' =>
            'SOAP 요청 함수 랩퍼를 구성하는 방법을 선택하십시오.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\'은 실제 호출자 / 작업 이름의 예제로 사용됩니다.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\'는 실제 설정된 값의 예입니다.',
        'Request name free text' => '요청 이름 자유 텍스트',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '함수 래퍼 이름 접미사 또는 대체로 사용할 텍스트입니다.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'XML 요소 이름 지정 제한 사항을 고려하십시오 (예 : \'<\'및 \'&\').',
        'Response name scheme' => '응답 이름 체계',
        'Select how SOAP response function wrapper should be constructed.' =>
            'SOAP 응답 함수 랩퍼를 구성하는 방법을 선택하십시오.',
        'Response name free text' => '응답 이름 자유 텍스트',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '여기서 OTRS가 처리 할 SOAP 메시지의 최대 크기 (바이트)를 지정할 수 있습니다.',
        'Encoding' => '부호화',
        'The character encoding for the SOAP message contents.' => 'SOAP 메시지 내용의 문자 인코딩입니다.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '예를 들어 utf-8, latin1, iso-8859-1, cp1250 등',
        'Sort options' => '정렬 옵션',
        'Add new first level element' => '새로운 첫번째 레벨 요소 추가',
        'Element' => '요소',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'xml 필드에 대한 아웃 바운드 정렬 순서 (함수 이름 래퍼 아래에서 시작하는 구조) - SOAP 전송에 대한 설명서를 참조하십시오.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '웹 서비스 추가',
        'Edit Web Service' => '웹 서비스 편집',
        'Clone Web Service' => '웹 서비스 복제',
        'The name must be unique.' => '이름은 고유해야 합니다.',
        'Clone' => '클론',
        'Export Web Service' => '웹 서비스 내보내기',
        'Import web service' => '웹 서비스 가져오기',
        'Configuration File' => '구성 파일',
        'The file must be a valid web service configuration YAML file.' =>
            '파일은 유효한 웹 서비스 구성 YAML파일이어야 합니다.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '여기서 웹 서비스의 이름을 지정할 수 있습니다. 이 필드가 비어 있으면 구성 파일의 이름이 이름으로 사용됩니다.',
        'Import' => '수입',
        'Configuration History' => '구성 기록',
        'Delete web service' => '웹 서비스 삭제',
        'Do you really want to delete this web service?' => '이 웹 서비스를 정말로 삭제 하시겠습니까?',
        'Ready2Adopt Web Services' => 'Ready2Adopt 웹 서비스',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '여기 %s의 일부인 모범 사례를 보여주는 Ready2Adopt 웹 서비스를 활성화 할 수 있습니다.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '이 웹 서비스는 특정 %s 계약 수준에서만 사용 가능한 다른 모듈에 의존 할 수 있습니다 (가져올 때 자세한 내용이있는 알림이 있음).',
        'Import Ready2Adopt web service' => 'Ready2Adopt 웹 서비스 가져 오기',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '전문가가 만든 웹 서비스의 혜택을 원하십니까? 일부 정교한 Ready2Adopt 웹 서비스를 가져 오려면 %s로 업그레이드하십시오.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '구성을 저장하면 편집 화면으로 다시 이동합니다.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '개요로 돌아가려면 \'개요로 이동\'버튼을 클릭하십시오.',
        'Remote system' => '원격 시스템',
        'Provider transport' => '공급자 전송',
        'Requester transport' => '요청자 전송',
        'Debug threshold' => '디버그 임계 값',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '공급자 모드에서 OTRS는 원격 시스템에서 사용되는 웹 서비스를 제공합니다.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '요청자 모드에서 OTRS는 원격 시스템의 웹 서비스를 사용합니다.',
        'Network transport' => '네트워크 전송',
        'Error Handling Modules' => '오류 처리 모듈',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '오류 처리 모듈은 통신 중 오류가 발생했을 때 반응하는 데 사용됩니다. 이러한 모듈은 특정 순서로 실행되며 끌어서 놓기로 변경할 수 있습니다.',
        'Backend' => '백엔드',
        'Add error handling module' => '오류 처리 모듈 추가',
        'Operations are individual system functions which remote systems can request.' =>
            '운영은 원격 시스템이 요청할 수있는 개별 시스템 기능입니다.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invoker는 원격 웹 서비스에 대한 요청 데이터를 준비하고 응답 데이터를 처리합니다.',
        'Controller' => '제어 장치',
        'Inbound mapping' => '인바운드 매핑',
        'Outbound mapping' => '아웃 바운드 매핑',
        'Delete this action' => '이 작업 삭제',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '하나 이상의 %s 컨트롤러가 활성화되지 않았거나 존재하지 않습니다. 컨트롤러 등록을 확인하거나 %s를 삭제하십시오',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => '역사',
        'Go back to Web Service' => '웹 서비스로 돌아 가기',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '여기서 현재 웹 서비스 구성의 이전 버전을 보거나 내보내거나 복원 할 수 있습니다.',
        'Configuration History List' => '구성 기록 목록',
        'Version' => '번역',
        'Create time' => '시간을 창조하십시오',
        'Select a single configuration version to see its details.' => '세부 사항을 보려면 단일 구성 버전을 선택하십시오.',
        'Export web service configuration' => '웹 서비스 구성 내보내기',
        'Restore web service configuration' => '웹 서비스 구성 복원',
        'Do you really want to restore this version of the web service configuration?' =>
            '이 버전의 웹 서비스 구성을 정말로 복원 하시겠습니까?',
        'Your current web service configuration will be overwritten.' => '현재 웹 서비스 구성을 덮어 씁니다.',

        # Template: AdminGroup
        'Group Management' => '그룹 관리',
        'Add Group' => '그룹 추가',
        'Edit Group' => '그룹 편집',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '관리자 그룹은 관리 영역과 통계 그룹을 가져 와서 통계 영역을 얻는 것입니다.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '서로 다른 에이전트 그룹 (예 : 구매 부서, 지원 부서, 판매 부서 등)에 대한 액세스 권한을 처리 할 새 그룹을 만듭니다.',
        'It\'s useful for ASP solutions. ' => 'ASP 솔루션에 유용합니다.',

        # Template: AdminLog
        'System Log' => '시스템 로그',
        'Here you will find log information about your system.' => '여기서 시스템에 대한 로그 정보를 찾을 수 있습니다.',
        'Hide this message' => '이 메시지 숨기기',
        'Recent Log Entries' => '최근 로그 항목',
        'Facility' => '쉬움',
        'Message' => '메시지',

        # Template: AdminMailAccount
        'Mail Account Management' => '메일 계정 관리',
        'Add Mail Account' => '메일 계정 추가',
        'Edit Mail Account for host' => '호스트용 메일 계정 편집',
        'and user account' => '및 사용자 계정',
        'Filter for Mail Accounts' => '메일 계정 필터링',
        'Filter for mail accounts' => '메일 계정 필터링',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '하나의 계정을 가진 모든 수신 이메일은 선택된 대기열에 발송됩니다.',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '계정이 신뢰할 수있는 것으로 표시되면 도착 시간 (예 : 우선 순위 등)에 이미 존재하는 X-OTRS 헤더가 보존되어 사용됩니다 예 : PostMaster 필터',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '나가는 이메일은 %s의 Sendmail * 설정을 통해 구성 할 수 있습니다.',
        'System Configuration' => '시스템 설정',
        'Host' => '호스트',
        'Delete account' => '계정 삭제',
        'Fetch mail' => '메일 가져오기',
        'Do you really want to delete this mail account?' => '정말로 이 메일 계정을 삭제 하시겠습니까?',
        'Password' => '암호',
        'Example: mail.example.com' => '예 : mail.example.com',
        'IMAP Folder' => 'IMAP 폴더',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'INBOX가 아닌 다른 폴더에서 메일을 가져와야하는 경우에만 수정하십시오.',
        'Trusted' => '신뢰할 수 있는',
        'Dispatching' => '파견',
        'Edit Mail Account' => '메일 계정 편집',

        # Template: AdminNavigationBar
        'Administration Overview' => '관리 개요',
        'Filter for Items' => '항목 필터링',
        'Filter' => '필터',
        'Favorites' => '즐겨찾기',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '오른쪽에있는 항목 위로 커서를 이동하고 별 모양 아이콘을 클릭하여 즐겨 찾기를 추가 할 수 있습니다.',
        'Links' => '링크',
        'View the admin manual on Github' => 'Github에서 관리자 매뉴얼보기',
        'No Matches' => '일치하지 않는다.',
        'Sorry, your search didn\'t match any items.' => '죄송합니다. 검색 결과와 일치하지 않습니다.',
        'Set as favorite' => '즐겨찾기로 설정',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '티켓 알림 관리',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 티켓 알림을 가져올 수 있습니다. 티켓 알림 모듈에서 내 보낸 파일은 .yml 형식이어야합니다.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '여기에서이 알림을 실행할 이벤트를 선택할 수 있습니다. 아래에 추가 티켓 필터를 적용하여 특정 기준에 맞는 티켓 만 보낼 수 있습니다.',
        'Ticket Filter' => '티켓 필터',
        'Lock' => '잠금',
        'SLA' => 'SLA',
        'Customer User ID' => '고객 사용자 ID',
        'Article Filter' => '기사 필터',
        'Only for ArticleCreate and ArticleSend event' => 'ArticleCreate 및 ArticleSend 이벤트에만 해당',
        'Article sender type' => '기사 발신자 유형',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'ArticleCreate 또는 ArticleSend가 트리거 이벤트로 사용되면 기사 필터를 지정해야합니다. 기사 필터 입력란 중 하나 이상을 선택하십시오.',
        'Customer visibility' => '고객 가시성',
        'Communication channel' => '통신 채널',
        'Include attachments to notification' => '알림 첨부파일 포함',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '선택한 전송을 사용하는 단일 티켓에 대해 하루에 한 번 사용자에게 알립니다.',
        'This field is required and must have less than 4000 characters.' =>
            '이 필드는 필수이며 4000 자 미만이어야합니다.',
        'Notifications are sent to an agent or a customer.' => '통지는 상담원 또는 고객에게 전송됩니다.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '(최신 에이전트 기사의) 제목의 처음 20자를 가져옵니다.',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '(최신 에이전트 기사의) 본문의 처음 5 줄을 가져 오려면.',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '(최신 고객 기사의) 제목의 처음 20자를 얻으려면.',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '(최신 고객 기사의) 본문의 첫 번째 5 줄을 가져옵니다.',
        'Attributes of the current customer user data' => '현재 고객 사용자 데이터의 속성',
        'Attributes of the current ticket owner user data' => '현재 티켓 소유자 사용자 데이터의 속성',
        'Attributes of the current ticket responsible user data' => '현재 티켓 책임 사용자 데이터의 속성',
        'Attributes of the current agent user who requested this action' =>
            '이 작업을 요청한 현재 상담원 사용자의 속성',
        'Attributes of the ticket data' => '티켓 데이터의 속성',
        'Ticket dynamic fields internal key values' => '동적 필드 내부 키 값 티켓 ',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '티켓 동적 필드는 드롭 다운 및 Multiselect 필드에 유용한 값을 표시합니다. ',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '<OTRS_TICKET_DynamicField _...>와 같은 OTRS 태그를 사용하여 현재 티켓의 값을 삽입 할 수 있습니다.',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '%s 관리',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => '설명서 읽기',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s는 cloud.otrs.com과 정기적으로 접속하여 사용 가능한 업데이트 및 기본 계약의 유효성을 확인합니다.',
        'Unauthorized Usage Detected' => '무단 사용 발견',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '이 시스템은 적절한 라이센스없이 %s를 사용합니다! 계약을 갱신하거나 활성화하려면 %s와 연락하십시오!',
        '%s not Correctly Installed' => '%s가 올바르게 설치되지 않았습니다.',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '%s이 가 올바르게 설치되지 않았습니다. 아래 버튼으로 다시 설치하십시오. ',
        'Reinstall %s' => '%s 재설치 ',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '%s가 올바르게 설치되지 않았으며 사용 가능한 업데이트도 있습니다. ',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '현재 버전을 다시 설치하거나 아래 버튼을 사용하여 업데이트를 수행 할 수 있습니다 (권장 업데이트).',
        'Update %s' => '%s 업데이트 ',
        '%s Not Yet Available' => '%s 아직 사용할 수없음',
        '%s will be available soon.' => '%s는 곧 제공될 예정입니다.',
        '%s Update Available' => '%s 업데이트 사용 가능',
        'An update for your %s is available! Please update at your earliest!' =>
            '%s에 대한 업데이트를 사용할 수 있습니다! 가능한 빨리 업데이트하십시오!',
        '%s Correctly Deployed' => '%s가 올바르게 배포되었습니다.',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '축하합니다. %s가 올바르게 설치되고 최신 상태입니다!',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => 'OTRS 고객 포털로 이동하십시오.',
        '%s will be available soon. Please check again in a few days.' =>
            '%s는 곧 제공될 예정입니다. 며칠 후에 다시 확인하십시오.',
        'Please have a look at %s for more information.' => '자세한 내용은 %s를 보십시오.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '%s의 혜택을 누리려면 %s로 연락해  %s계약을 획득하세요.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'HTTPS를 통해 cloud.otrs.com에 연결할 수 없습니다. OTRS가 포트 443을 통해 cloud.otrs.com에 연결할 수 있는지 확인하십시오.',
        'Package installation requires patch level update of OTRS.' => '패키지를 설치하려면 OTRS의 패치 레벨 업데이트가 필요합니다.',
        'Please visit our customer portal and file a request.' => '고객 포털을 방문하여 요청을 제출하십시오.',
        'Everything else will be done as part of your contract.' => '그 밖의 모든 것은 계약의 일부로 수행됩니다.',
        'Your installed OTRS version is %s.' => '설치된 OTRS 버전은 %s입니다.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '이 패키지를 설치하려면 %s 이상의 OTRS로 업데이트해야합니다.',
        'To install this package, the Maximum OTRS Version is %s.' => '이 패키지를 설치하려면 최대 OTRS 버전은 %s입니다.',
        'To install this package, the required Framework version is %s.' =>
            '이 패키지를 설치하려면 필요한 Framework 버전이 %s입니다.',
        'Why should I keep OTRS up to date?' => '왜 OTRS를 최신 상태로 유지해야합니까?',
        'You will receive updates about relevant security issues.' => '관련 보안 문제에 대한 업데이트가 제공됩니다.',
        'You will receive updates for all other relevant OTRS issues' => '다른 모든 관련 OTRS 문제에 대한 업데이트를 받게됩니다.',
        'With your existing contract you can only use a small part of the %s.' =>
            '기존 계약을 사용하면 %s의 작은 부분 만 사용할 수 있습니다.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '%s를 최대한 활용하고 싶다면 계약을 지금 업그레이드하십시오! 연락처 %s',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '다운그레이드 취소하고 돌아가기',
        'Go to OTRS Package Manager' => 'OTRS 패키지 관리자로 이동하십시오.',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '죄송하지만 현재 %s에 의존하는 다음 패키지 때문에 다운 그레이드 할 수 없습니다 :',
        'Vendor' => '공급 업체',
        'Please uninstall the packages first using the package manager and try again.' =>
            '먼저 패키지 관리자를 사용하여 패키지를 제거한 후 다시 시도하십시오.',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '~에게 말을 걸다',
        'Report Generator' => '보고서 생성기',
        'Timeline view in ticket zoom' => '티켓의 타임라인보기 확대 / 축소',
        'DynamicField ContactWithData' => 'DynamicField ContactWithData',
        'DynamicField Database' => 'DynamicField 데이터베이스',
        'SLA Selection Dialog' => 'SLA 선택 대화 상자',
        'Ticket Attachment View' => '티켓 첨부보기',
        'The %s skin' => '%s 스킨',

        # Template: AdminPGP
        'PGP Management' => 'PGP 관리',
        'Add PGP Key' => 'PGP 키 추가',
        'PGP support is disabled' => 'PGP 지원이 비활성화되었습니다.',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'OTRS에서 PGP를 사용하려면 먼저 PGP를 활성화해야합니다.',
        'Enable PGP support' => 'PGP 지원 사용',
        'Faulty PGP configuration' => 'PGP 구성 오류',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP 지원이 활성화되었지만 관련 구성에 오류가 있습니다. 아래 단추를 ​​사용하여 구성을 확인하십시오.',
        'Configure it here!' => '여기에서 구성하십시오!',
        'Check PGP configuration' => 'PGP 구성 확인',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '이 방법으로 SysConfig에서 구성된 키 링을 직접 편집 할 수 있습니다.',
        'Introduction to PGP' => 'PGP 소개',
        'Identifier' => '식별자',
        'Bit' => '비트',
        'Fingerprint' => '지문',
        'Expires' => '만료',
        'Delete this key' => '이 키 삭제',
        'PGP key' => 'PGP 키',

        # Template: AdminPackageManager
        'Package Manager' => '패키지 관리자',
        'Uninstall Package' => '패키지 제거',
        'Uninstall package' => '패키지 제거',
        'Do you really want to uninstall this package?' => '이 패키지를 정말로 제거 하시곘습니까?',
        'Reinstall package' => '패키지 다시 설치',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '이 패키지를 정말로 다시 설치 하시겠습니까? 수동으로 변경하면 손실됩니다.',
        'Go to updating instructions' => '',
        'package information' => '패키지 정보',
        'Package installation requires a patch level update of OTRS.' => '패키지를 설치하려면 OTRS의 패치 레벨 업데이트가 필요합니다. ',
        'Package update requires a patch level update of OTRS.' => '패키지 업데이트에는 OTRS의 패치 수준 업데이트가 필요합니다. ',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            'OTRS Business Solution ™ 고객 인 경우 고객 포털을 방문하여 요청을 제출하십시오.',
        'Please note that your installed OTRS version is %s.' => '설치된 OTRS 버전은 %s입니다.',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '이 패키지를 설치하려면 OTRS를 버전 %s 이상으로 업데이트해야합니다.',
        'This package can only be installed on OTRS version %s or older.' =>
            '이 패키지는 OTRS 버전 %s 또는 그 이상에서만 설치할 수 있습니다.',
        'This package can only be installed on OTRS version %s or newer.' =>
            'This package can only be installed on OTRS version %s or newer.',
        'You will receive updates for all other relevant OTRS issues.' =>
            '다른 모든 관련 OTRS 문제에 대한 업데이트가 제공됩니다.',
        'How can I do a patch level update if I don’t have a contract?' =>
            '계약이 없다면 어떻게 패치 레벨 업데이트를 할 수 있습니까?',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            '혹시 더 궁금한 점이 있으시면 답변 해드리겠습니다.',
        'Install Package' => '패키지 설치',
        'Update Package' => '패키지 업데이트',
        'Continue' => '계속하다',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '데이터베이스가 %s 크기 이상의 패키지를 수락하는지 확인하십시오 (현재 패키지는 최대 %s MB 만 허용). 오류를 피하기 위해 데이터베이스의 max_allowed_packet 설정을 조정하십시오.',
        'Install' => '설치',
        'Update repository information' => '저장소 정보 업데이트',
        'Cloud services are currently disabled.' => '클라우드 서비스는 현재 사용할 수 없습니다.',
        'OTRS Verify™ can not continue!' => 'OTRS Verify ™를 계속할 수 없습니다!',
        'Enable cloud services' => '클라우드 서비스 사용',
        'Update all installed packages' => '설치된 모든 패키지를 업데이트 하십시오.',
        'Online Repository' => '온라인 저장소',
        'Action' => '동작',
        'Module documentation' => '모듈 문서',
        'Local Repository' => '로컬 저장소',
        'This package is verified by OTRSverify (tm)' => '이 패키지는 OTRSverify (tm)에 의해 검증됩니다.',
        'Uninstall' => '제거',
        'Package not correctly deployed! Please reinstall the package.' =>
            '패키지가 올바르게 배치되지 않았습니다! 패키지를 다시 설치하십시오.',
        'Reinstall' => '재설치',
        'Features for %s customers only' => '%s 고객 전용 기능',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '%s를 사용하면 다음과 같은 옵션 기능을 활용할 수 있습니다. 더 자세한 정보가 필요하시면 %s로 연락하십시오.',
        'Package Information' => '패키지 정보',
        'Download package' => '패키지 다운로드',
        'Rebuild package' => '패키지 다시 빌드',
        'Metadata' => '메타 데이터',
        'Change Log' => '변경 로그',
        'Date' => '날짜',
        'List of Files' => '파일 목록',
        'Permission' => '허가',
        'Download file from package!' => '패키지에서 파일을 다운로드 하십시오!',
        'Required' => '필수',
        'Size' => '크기',
        'Primary Key' => '기본 키',
        'Auto Increment' => '자동 증가',
        'SQL' => 'SQL',
        'File Differences for File %s' => '파일 %s의 파일 차이점',
        'File differences for file %s' => '파일 %s의 파일 차이점',

        # Template: AdminPerformanceLog
        'Performance Log' => '성능 로그',
        'Range' => '범위',
        'last' => '마지막',
        'This feature is enabled!' => '이 기능을 사용할 수 있습니다!',
        'Just use this feature if you want to log each request.' => '각 요청을 기록하려면 이 기능을 사용하십시오.',
        'Activating this feature might affect your system performance!' =>
            '이 기능을 활성화하면 시스템 성능에 영향을 줄 수 있습니다!',
        'Disable it here!' => '여기에서 사용 중지 하십시오!',
        'Logfile too large!' => '로그파일이 너무 큽니다!',
        'The logfile is too large, you need to reset it' => '로그 파일이 너무 커서 재설정해야 합니다.',
        'Reset' => '리셋',
        'Overview' => '개요',
        'Interface' => '인터페이스',
        'Requests' => '요청',
        'Min Response' => '최소 응답',
        'Max Response' => '최대 응답',
        'Average Response' => '평균 응답',
        'Period' => '기간',
        'minutes' => '분',
        'Min' => '최소',
        'Max' => '최대',
        'Average' => '평균',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster 필터 관리',
        'Add PostMaster Filter' => 'PostMaster 필터 추가',
        'Edit PostMaster Filter' => '포스트 마스터 필터 편집',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '전자 메일 헤더를 기반으로 수신 전자메일을 발송하거나 필터링합니다. 정규표현식을 사용하여 일치시킬 수도 있습니다.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '이메일 주소 만 일치 시키려면 From, To 또는 Cc에서 EMAILADDRESS : info@example.com을 사용하십시오.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '정규 표현식을 사용하는 경우 \'Set\'동작에서 ()의 일치 값을 [***]로 사용할 수도 있습니다.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '이름이 지정된 캡처를 %s사용할 수도 있고 \'설정\'작업 %s의 이름 (예 : 정규 표현식 : %s, 작업 설정 : %s)을 사용할 수 있습니다. 일치하는 EMAILADDRESS의 이름은 \'%s\'입니다.',
        'Delete this filter' => '이 필터 삭제',
        'Do you really want to delete this postmaster filter?' => '이 포스트 마스터 필터를 정말로 삭제 하시겠습니까?',
        'A postmaster filter with this name already exists!' => '이 이름을 가진 전자메일 관리자 필터가 이미 있습니다!',
        'Filter Condition' => '필터 조건',
        'AND Condition' => '조건',
        'Search header field' => '헤더 필드 검색',
        'for value' => '가치관',
        'The field needs to be a valid regular expression or a literal word.' =>
            '필드는 유효한 정규표현식 또는 문자 그대로의 단어여야 합니다.',
        'Negate' => '부정하다',
        'Set Email Headers' => '이메일 헤더 설정',
        'Set email header' => '이메일 헤더 설정',
        'with value' => '가치있는',
        'The field needs to be a literal word.' => '필드는 문자 그대로의 단어여야 합니다.',
        'Header' => '머리글',

        # Template: AdminPriority
        'Priority Management' => '우선 순위 관리',
        'Add Priority' => '우선 순위 추가',
        'Edit Priority' => '우선 순위 편집',
        'Filter for Priorities' => '우선 순위에 대한 필터링',
        'Filter for priorities' => '우선 순위에 대한 필터링',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '이 우선 순위는 SysConfig 설정에 있으며 새로운 우선 순위를 가리 키도록 설정을 업데이트해야합니다!',
        'This priority is used in the following config settings:' => '이 우선 순위는 다음 구성 설정에서 사용됩니다.',

        # Template: AdminProcessManagement
        'Process Management' => '공정 관리',
        'Filter for Processes' => '프로세스 필터링',
        'Filter for processes' => '',
        'Create New Process' => '새 프로세스 만들기',
        'Deploy All Processes' => '모든 프로세스 배포',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '여기서 구성 파일을 업로드하여 시스템에 프로세스를 가져올 수 있습니다. 파일은 프로세스 관리 모듈에서 내 보낸 .yml 형식이어야합니다.',
        'Upload process configuration' => '업로드 프로세스 구성',
        'Import process configuration' => '프로세스 구성 가져오기',
        'Ready2Adopt Processes' => 'Ready2Adopt 프로세스',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '여기에서 우수 사례를 보여주는 Ready2Adopt 프로세스를 활성화 할 수 있습니다. 추가 구성이 필요할 수 있습니다.',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '전문가가 만든 프로세스의 혜택을 원하십니까? 일부 정교한 Ready2Adopt 프로세스를 가져 오려면 %s로 업그레이드하십시오.',
        'Import Ready2Adopt process' => 'Ready2Adopt 프로세스 가져 오기',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '새 프로세스를 만들려면 다른 시스템에서 내 보낸 프로세스를 가져 오거나 완전히 새로운 프로세스를 생성 할 수 있습니다.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '여기에서 프로세스 변경은 프로세스 데이터를 동기화 할 경우에만 시스템의 동작에 영향을 미칩니다. 프로세스를 동기화함으로써 새로 변경된 변경 사항이 구성에 기록됩니다.',
        'Processes' => '프로세스',
        'Process name' => '프로세스 이름',
        'Print' => '인쇄',
        'Export Process Configuration' => '프로세스 구성 내보내기',
        'Copy Process' => '프로세스 복사',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '취소 및 닫기',
        'Go Back' => '돌아가기',
        'Please note, that changing this activity will affect the following processes' =>
            '이 활동을 변경하면 다음 프로세스에 영향을 미칩니다.',
        'Activity' => '활동',
        'Activity Name' => '활동명',
        'Activity Dialogs' => '활동 대화상자',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '마우스로 요소를 왼쪽 목록에서 오른쪽 목록으로 드래그하여 활동 대화 상자를 이 활동에 지정할 수 있습니다.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '드래그 앤 드롭을 사용하여 목록 내의 요소를 정렬 할 수도 있습니다.',
        'Filter available Activity Dialogs' => '사용 가능한 필터 대화상자',
        'Available Activity Dialogs' => '사용 가능한 활동 대화상자',
        'Name: %s, EntityID: %s' => '이름 : %s, EntityID : %s',
        'Create New Activity Dialog' => '새 활동 만들기 대화 상자',
        'Assigned Activity Dialogs' => '할당된 활동 대화상자',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '이 활동 대화상자를 변경하면 다음 활동에 영향을 미칩니다.',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '고객 사용자는 Owner, Responsible, Lock, PendingTime 및 CustomerID 필드를 보거나 사용할 수 없습니다.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '대기열 필드는 새 티켓을 작성할 때 고객이 사용할 수 있습니다.',
        'Activity Dialog' => '활동 대화상자',
        'Activity dialog Name' => '활동 대화 상자 이름',
        'Available in' => '가능',
        'Description (short)' => '설명 (짧다)',
        'Description (long)' => '설명 (길다)',
        'The selected permission does not exist.' => '선택한 권한이 없습니다.',
        'Required Lock' => '필수 잠금',
        'The selected required lock does not exist.' => '선택한 필수 잠금이 없습니다.',
        'Submit Advice Text' => 'Submit Advice Text',
        'Submit Button Text' => '제출 버튼 텍스트',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '마우스로 요소를 왼쪽 목록에서 오른쪽 목록으로 끌어서이 활동 대화 상자에 필드를 할당 할 수 있습니다.',
        'Filter available fields' => '사용 가능한 필드 필터링',
        'Available Fields' => '사용 가능한 필드',
        'Assigned Fields' => '할당된 필드',
        'Communication Channel' => '통신 채널',
        'Is visible for customer' => '고객에게 표시됩니다.',
        'Display' => '다스플레이',

        # Template: AdminProcessManagementPath
        'Path' => '통로',
        'Edit this transition' => '이 전환 편집',
        'Transition Actions' => '전환 액션',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '마우스로 요소를 왼쪽 목록에서 오른쪽 목록으로 드래그하여 전환 동작을이 전환에 지정할 수 있습니다.',
        'Filter available Transition Actions' => '사용 가능한 필터 전환 액션',
        'Available Transition Actions' => '사용 가능한 필터 전환 액션',
        'Create New Transition Action' => '새 전환 액션 만들기',
        'Assigned Transition Actions' => '할당된 전환 액션',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '활동',
        'Filter Activities...' => '활동 필터링...',
        'Create New Activity' => '새 활동 만들기',
        'Filter Activity Dialogs...' => '활동 필터링 대화 상자...',
        'Transitions' => '전환',
        'Filter Transitions...' => '필터 전환',
        'Create New Transition' => '새 전환 만들기',
        'Filter Transition Actions...' => '필터 전환 액션...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '프로세스 편집',
        'Print process information' => '프로세스 정보 인쇄',
        'Delete Process' => '프로세스 삭제',
        'Delete Inactive Process' => '비활성 프로세스 삭제',
        'Available Process Elements' => '사용 가능한 프로세스 요소',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '이 사이드 바에 위에 나열된 요소는 drag\'n\'drop을 사용하여 오른쪽의 캔바스 영역으로 이동할 수 있습니다.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '캔버스 영역에 활동을 배치하여 이 활동을 프로세스에 할당할 수 있습니다.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '액티비티 대화 상자를 액티비티에 할당하려면이 사이드 바의 액티비티 대화 상자 요소를 캔버스 영역에 배치 된 액티비티 위에 놓습니다.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '연결의 시작 활동 위로 전환 요소를 놓음으로써 두 활동 사이의 연결을 시작할 수 있습니다. 그런 다음 화살표의 느슨한 끝을 끝 활동으로 이동할 수 있습니다.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '동작 요소를 전환 레이블에 놓음으로써 동작을 전환에 할당할 수 있습니다.',
        'Edit Process Information' => '프로세스 정보 편집',
        'Process Name' => '프로세스 이름',
        'The selected state does not exist.' => '선택한 상태가 존재하지 않습니다.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '활동, 활동 대화 상자 및 전환 추가 및 편집',
        'Show EntityIDs' => '엔티티 ID 표시',
        'Extend the width of the Canvas' => '캔버스 너비 늘리기',
        'Extend the height of the Canvas' => '캔버스의 높이 늘리기',
        'Remove the Activity from this Process' => '이 프로세스에서 활동 제거',
        'Edit this Activity' => '이 활동 편집',
        'Save Activities, Activity Dialogs and Transitions' => '활동, 활동 대화 상자 및 전환 저장',
        'Do you really want to delete this Process?' => '이 프로세스를 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Activity?' => '이 활동을 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Activity Dialog?' => '이 활동 대화 상자를 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Transition?' => '이 전환을 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this Transition Action?' => '이 전환 액션을 정말로 삭제 하시겠습니까?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '이 활동을 캔버스에서 정말로 제거 하시겠습니까? 저장하지 않고이 화면을 나가면 취소 할 수 있습니다.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '이 전환을 캔버스에서 정말로 제거 하시겠습니까? 저장하지 않고이 화면을 나가면 취소 할 수 있습니다.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '이 화면에서 새 프로세스를 만들 수 있습니다. 사용자가 새 프로세스를 사용할 수있게하려면 상태를 \'활성\'으로 설정하고 작업 완료 후 동기화하십시오.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => '취소 및 닫기',
        'Start Activity' => '활동 시작',
        'Contains %s dialog(s)' => '%s 대화 상자(s)를 포함합니다.',
        'Assigned dialogs' => '할당된 대화상자',
        'Activities are not being used in this process.' => '활동이 이 프로세스에서 사용되지 않습니다.',
        'Assigned fields' => '지정된 필드',
        'Activity dialogs are not being used in this process.' => '활동 대화상자는 이 프로세스에서 사용되지 않습니다.',
        'Condition linking' => '조건 연결',
        'Transitions are not being used in this process.' => '전환은 이 프로세스에서 사용되지 않습니다.',
        'Module name' => '모듈 이름',
        'Transition actions are not being used in this process.' => '전환 작업은 이 프로세스에서 사용되지 않습니다.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '이 전환을 변경하면 다음 프로세스에 영항을 미칩니다.',
        'Transition' => '전환',
        'Transition Name' => '전환 이름',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '이 전환 작업을 변경하면 다음 프로세스에 영향을 미칩니다.',
        'Transition Action' => '전환 액션',
        'Transition Action Name' => '전환 액션 이름',
        'Transition Action Module' => '전환 액션 모듈',
        'Config Parameters' => '구성 매개 변수',
        'Add a new Parameter' => '새 매개 변수 추가',
        'Remove this Parameter' => '이 매개 변수 제거',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => '대기열 추가',
        'Edit Queue' => '대기열 편집',
        'Filter for Queues' => '대기열 필터링',
        'Filter for queues' => '대기열 필터링',
        'A queue with this name already exists!' => '이 이름을 가진 대기열이 이미 있습니다!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '이 대기열은 SysConfig 설정에 있으며, 새로운 대기열을 가리 키도록 설정을 업데이트해야합니다!',
        'Sub-queue of' => '하위 큐',
        'Unlock timeout' => '제한 시간 잠금 해제',
        '0 = no unlock' => '0 = 잠금 해제 없음',
        'hours' => '시간',
        'Only business hours are counted.' => '영업시간만 계산됩니다.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '에이전트가 티켓을 잠그고 잠금 해제 시간 초과가 지나기 전에 티켓을 닫지 않으면 티켓이 잠금 해제되고 다른 에이전트에서 사용할 수있게됩니다.',
        'Notify by' => '알림',
        '0 = no escalation' => '0 = 에스컬레이션 없음',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '여기에 정의 된 시간이 만료되기 전에 고객 연락처 전자 메일 외부 또는 전화가 새 티켓에 추가되지 않으면 티켓이 에스컬레이트됩니다.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '전자 메일 또는 고객 포털을 통한 후속 조치와 같이 기사가 추가되면 에스컬레이션 업데이트 시간이 재설정됩니다. 여기에 정의 된 시간이 만료되기 전에 고객 연락처 전자 메일 외부 또는 전화가 티켓에 추가되면 티켓이 에스컬레이션됩니다.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '여기에 정의된 시간이 만료되기 전에 티켓이 닫히도록 설정되어 있지 않으면 티켓이 에스컬레이트 됩니다.',
        'Follow up Option' => '후속 옵션',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '폐쇄 된 티켓에 대한 후속 조치가 티켓을 다시 열 것인지, 거절되거나 새로운 티켓으로 이어질지 여부를 지정합니다.',
        'Ticket lock after a follow up' => '후속 조치 후 티켓 잠금',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '티켓이 닫히고 고객이 후속 조치를 보내면 티켓이 이전 소유자에게 고정됩니다.',
        'System address' => '시스템 주소',
        'Will be the sender address of this queue for email answers.' => '전자 메일 응답을 위한 이 큐의 보낸사람 주소가 됩니다.',
        'Default sign key' => '기본 기호 키',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => '인사말',
        'The salutation for email answers.' => '이메일 답변에 대한 인사말.',
        'Signature' => '서명',
        'The signature for email answers.' => '이메일 답변을 위한 서명.',
        'This queue is used in the following config settings:' => '이 대기열은 다음 구성 설정에서 사용됩니다.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '대기열 관리 - 자동 응답 관계 관리',
        'Change Auto Response Relations for Queue' => '대기열에 대한 자동 응답관계 변경',
        'This filter allow you to show queues without auto responses' => '이 필터를 사용하면 자동응답 없이 대기열을 표시할 수 있습니다.',
        'Queues without Auto Responses' => '자동응답이 없는 대기열',
        'This filter allow you to show all queues' => '이 필터를 사용하면 모든 대기열을 표시할 수 있습니다.',
        'Show All Queues' => '모든 대기열 표시',
        'Auto Responses' => '자동 응답',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '템플릿 - 대기열 관계 관리',
        'Filter for Templates' => '템플릿 필터링',
        'Filter for templates' => '',
        'Templates' => '템플릿',

        # Template: AdminRegistration
        'System Registration Management' => '시스템 등록 관리',
        'Edit System Registration' => '시스템 등록 편집',
        'System Registration Overview' => '시스템 등록 개요',
        'Register System' => '시스템 등록',
        'Validate OTRS-ID' => 'OTRS-ID 확인',
        'Deregister System' => 'Deregister System',
        'Edit details' => '세부 정보 수정',
        'Show transmitted data' => '전송된 데이터 표시',
        'Deregister system' => 'Deregister system',
        'Overview of registered systems' => '등록된 시스템 개요',
        'This system is registered with OTRS Group.' => '이 시스템은 OTRS 그룹에 등록되어 있습니다.',
        'System type' => '시스템 유형',
        'Unique ID' => '고유 ID',
        'Last communication with registration server' => '등록 서버와의 마지막 통신',
        'System Registration not Possible' => '시스템 등록이 불가능합니다.',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'OTRS 데몬이 올바르게 실행되지 않으면 시스템을 등록 할 수 없습니다.',
        'Instructions' => '명령',
        'System Deregistration not Possible' => '시스템 등록 취소가 불가능합니다.',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '%s를 사용 중이거나 유효한 서비스 계약이있는 경우 시스템 등록을 취소 할 수 없습니다.',
        'OTRS-ID Login' => 'OTRS-ID 로그인',
        'Read more' => '더 많은 것을 읽으십시오',
        'You need to log in with your OTRS-ID to register your system.' =>
            '시스템을 등록하려면 OTRS-ID로 로그인해야합니다.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'OTRS-ID는 OTRS.com 웹 페이지에 가입 할 때 사용한 이메일 주소입니다.',
        'Data Protection' => '데이터 보호',
        'What are the advantages of system registration?' => '시스템 등록의 이점은 무엇입니까?',
        'You will receive updates about relevant security releases.' => '관련 보안 릴리스에 대한 업데이트가 제공됩니다.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '시스템 등록을 통해 우리는 모든 관련 정보를 이용할 수 있으므로 귀하를 위해 서비스를 개선 할 수 있습니다.',
        'This is only the beginning!' => '이것은 단지 시작일뿐입니다!',
        'We will inform you about our new services and offerings soon.' =>
            '조만간 새로운 서비스와 제품에 대해 알려 드리겠습니다.',
        'Can I use OTRS without being registered?' => 'OTRS를 등록하지 않고도 사용할 수 있습니까?',
        'System registration is optional.' => '시스템 등록은 선택 사항입니다.',
        'You can download and use OTRS without being registered.' => '등록없이 OTRS를 다운로드하여 사용할 수 있습니다.',
        'Is it possible to deregister?' => '등록 취소가 가능합니까?',
        'You can deregister at any time.' => '언제든지 등록 취소 할 수 있습니다.',
        'Which data is transfered when registering?' => '등록할 때 어떤 데이터가 전송됩니까?',
        'A registered system sends the following data to OTRS Group:' => '등록 된 시스템은 다음 데이터를 OTRS 그룹에 보냅니다.',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'FQDN (정규화 된 도메인 이름), OTRS 버전, 데이터베이스, 운영 체제 및 Perl 버전',
        'Why do I have to provide a description for my system?' => '왜 내 시스템에 대한 설명을 제공해야 합니까?',
        'The description of the system is optional.' => '시스템 설명은 선택 사항 입니다.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '지정하는 설명 W 시스템 유형은 등록 된 시스템의 세부 사항을 식별하고 관리하는 데 도움을줍니다.',
        'How often does my OTRS system send updates?' => 'OTRS 시스템은 얼마나 자주 업데이트를 보내나요?',
        'Your system will send updates to the registration server at regular intervals.' =>
            '시스템은 일정한 간격으로 등록 서버에 업데이트를 보냅니다.',
        'Typically this would be around once every three days.' => '일반적으로 3일에 1번 정도입니다.',
        'If you deregister your system, you will lose these benefits:' =>
            '시스템 등록을 취소하면 다음과 같은 이점을 잃게 됩니다.',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '시스템 등록을 취소하려면 OTRS-ID로 로그인해야합니다.',
        'OTRS-ID' => 'OTRS-ID ',
        'You don\'t have an OTRS-ID yet?' => '아직 OTRS-ID가 없습니까?',
        'Sign up now' => '지금 등록하세요',
        'Forgot your password?' => '비밀번호를 잊어 버렸습니까?',
        'Retrieve a new one' => '새 항목 가져 오기',
        'Next' => '다음',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '이 시스템을 등록 할 때이 데이터는 OTRS 그룹으로 자주 전송됩니다.',
        'Attribute' => '속성',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRS 버전',
        'Operating System' => '운영 체제',
        'Perl Version' => '펄 버전',
        'Optional description of this system.' => '이 시스템에 대한 선택적 설명.',
        'Register' => '기록',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '이 단계를 계속하면 OTRS 그룹의 시스템 등록이 취소됩니다.',
        'Deregister' => '위임자',
        'You can modify registration settings here.' => '여기에서 등록 설정을 수정할 수 있습니다.',
        'Overview of Transmitted Data' => '전송된 데이터의 개요',
        'There is no data regularly sent from your system to %s.' => '시스템에서 %s로 정기적으로 전송되는 데이터는 없습니다.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '다음 데이터는 최소 3 일마다 시스템에서 %s로 전송됩니다.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '데이터는 안전한 https 연결을 통해 JSON 형식으로 전송됩니다.',
        'System Registration Data' => '시스템 등록 데이터',
        'Support Data' => '지원 데이터',

        # Template: AdminRole
        'Role Management' => '역할 관리',
        'Add Role' => '역할 추가',
        'Edit Role' => '역할 편집',
        'Filter for Roles' => '역할 필터링',
        'Filter for roles' => '역할 필터링',
        'Create a role and put groups in it. Then add the role to the users.' =>
            '역할을 만들고 그 안에 그룹을 넣으십시오. 그런 다음 사용자에게 역할을 추가 하십시오.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '정의 된 역할이 없습니다. \'추가\'버튼을 사용하여 새 역할을 만드십시오.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '역할 그룹 관계 관리',
        'Roles' => '역할',
        'Select the role:group permissions.' => '역할 : 그룹 권한을 선택 하십시오.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '아무 것도 선택하지 않으면이 그룹에 권한이 없습니다 (티켓을 역할에 사용할 수 없음).',
        'Toggle %s permission for all' => '모든 사용자에게 %s의 권한을 토글합니다.',
        'move_into' => 'move_into',
        'Permissions to move tickets into this group/queue.' => '이 그룹 / 대기열로 티켓을 이동하는 권한.',
        'create' => '생성',
        'Permissions to create tickets in this group/queue.' => '이 그룹 / 대기열에서 티켓을 만들 수 있는 권한.',
        'note' => '노트',
        'Permissions to add notes to tickets in this group/queue.' => '이 그룹 / 대기열의 티켓에 메모를 추가할 권한.',
        'owner' => '소유자',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '이 그룹 / 대기열에서 티켓 소유자를 변경할 권한.',
        'priority' => '우선 순위',
        'Permissions to change the ticket priority in this group/queue.' =>
            '이 그룹 / 큐에서 티켓 우선 순위를 변경할 권한.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '에이전트 역할 관계 관리',
        'Add Agent' => '상담원 추가',
        'Filter for Agents' => '에이전트 필터링',
        'Filter for agents' => '',
        'Agents' => '에이전트',
        'Manage Role-Agent Relations' => '역할 - 에이전트 관계 관리',

        # Template: AdminSLA
        'SLA Management' => 'SLA 관리',
        'Edit SLA' => 'SLA 편집',
        'Add SLA' => 'SLA 추가',
        'Filter for SLAs' => 'SLA 필터링',
        'Please write only numbers!' => '숫자만 써주세요!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S / MIME 관리',
        'Add Certificate' => '인증서 추가',
        'Add Private Key' => '비공개 키 추가',
        'SMIME support is disabled' => 'SMIME 지원이 비활성화되었습니다.',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'OTRS에서 SMIME을 사용하려면 먼저 SMIME를 활성화해야합니다.',
        'Enable SMIME support' => 'SMIME 지원 사용',
        'Faulty SMIME configuration' => 'SMIME 구성 오류',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME 지원이 활성화되었지만 관련 구성에 오류가 있습니다. 아래 단추를 ​​사용하여 구성을 확인하십시오.',
        'Check SMIME configuration' => 'SMIME 구성 확인',
        'Filter for Certificates' => '인증서 필터링',
        'Filter for certificates' => '',
        'To show certificate details click on a certificate icon.' => '인증서 세부 사항을 보려면 인증서 아이콘을 클릭 하십시오.',
        'To manage private certificate relations click on a private key icon.' =>
            '개인 인증서 관계를 관리하려면 개인 키 아이콘을 클릭하십시오.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '여기에서 개인 인증서에 관계를 추가 할 수 있습니다.이 인증서는이 인증서를 사용하여 전자 메일에 서명 할 때마다 S / MIME 서명에 포함됩니다.',
        'See also' => '또한 보십시오',
        'In this way you can directly edit the certification and private keys in file system.' =>
            '이 방법으로 파일 시스템의 인증 및 개인 키를 직접 편집할 수 있습니다.',
        'Hash' => '해쉬',
        'Create' => '생성',
        'Handle related certificates' => '관련 인증서 처리',
        'Read certificate' => '인증서 읽기',
        'Delete this certificate' => '이 인증서 삭제',
        'File' => '파일',
        'Secret' => '비밀',
        'Related Certificates for' => '관련 인증서',
        'Delete this relation' => '이 관계 삭제',
        'Available Certificates' => '사용 가능한 인증서',
        'Filter for S/MIME certs' => 'S / MIME 인증서 필터링',
        'Relate this certificate' => '이 인증서 연관',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S / MIME 인증서',
        'Close this dialog' => '이 대화 상자를 닫습니다.',
        'Certificate Details' => '인증서 세부 정보',

        # Template: AdminSalutation
        'Salutation Management' => '인사말 관리',
        'Add Salutation' => '인사말 추가',
        'Edit Salutation' => '인사말 편집',
        'Filter for Salutations' => '인사말 필터링',
        'Filter for salutations' => '인사말 필터링',
        'e. g.' => '예를들면',
        'Example salutation' => '예시 인사말',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '보안 모드가 활성화되어야 합니다!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '보안 모드는 초기 설치가 완료된 후 (일반적으로) 설정됩니다.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '보안 모드가 활성화되어 있지 않으면 응용 프로그램이 이미 실행 중이기 때문에 SysConfig를 통해 활성화하십시오.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL 박스',
        'Filter for Results' => '결과 필터링',
        'Filter for results' => '결과 필터링',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '여기서 SQL을 입력하여 응용 프로그램 데이터베이스로 직접 보낼 수 있습니다. 테이블 내용을 변경할 수 없으며 선택 쿼리 만 허용됩니다.',
        'Here you can enter SQL to send it directly to the application database.' =>
            '여기서 SQL을 입력하여 응용 프로그램 데이터베이스로 직접 보낼 수 있습니다.',
        'Options' => '옵션',
        'Only select queries are allowed.' => '선택 쿼리만 허용됩니다.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL 쿼리 구문에 실수가 있습니다. 그것을 확인하십시오.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '바인딩에 누락 된 매개 변수가 하나 이상 있습니다. 그것을 확인하십시오.',
        'Result format' => '결과 형식',
        'Run Query' => '검색어 실행',
        '%s Results' => '결과 %s개',
        'Query is executed.' => '쿼리가 실행됩니다.',

        # Template: AdminService
        'Service Management' => '서비스 관리',
        'Add Service' => '서비스 추가',
        'Edit Service' => '서비스 편집',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '서비스 이름의 최대 길이는 200 자 (서브 서비스 포함)입니다.',
        'Sub-service of' => '의 서브 서비스',

        # Template: AdminSession
        'Session Management' => '세션 관리',
        'Detail Session View for %s (%s)' => '%s (%s)에 대한 세부 세션보기',
        'All sessions' => '모든 세션',
        'Agent sessions' => '에이전트 세션',
        'Customer sessions' => '고객 세션',
        'Unique agents' => '고유 에이전트',
        'Unique customers' => '고유 고객',
        'Kill all sessions' => '모든 세션을 종료하십시오.',
        'Kill this session' => '이 세션을 종료하십시오.',
        'Filter for Sessions' => '세션 필터링',
        'Filter for sessions' => '세션 필터링',
        'Session' => '세션',
        'User' => '사용자',
        'Kill' => '종료',
        'Detail View for SessionID: %s - %s' => 'SessionID 세부 정보보기 : %s - %s',

        # Template: AdminSignature
        'Signature Management' => '시그니처 관리',
        'Add Signature' => '시그니처 추가',
        'Edit Signature' => '시그니처 편집',
        'Filter for Signatures' => '시그니처 필터링',
        'Filter for signatures' => '시그니처 필터링',
        'Example signature' => '서명의 예',

        # Template: AdminState
        'State Management' => '주 관리',
        'Add State' => '주 추가',
        'Edit State' => '주 편집',
        'Filter for States' => '주 필터링',
        'Filter for states' => '주 필터링',
        'Attention' => '주의',
        'Please also update the states in SysConfig where needed.' => '필요한 경우 SysConfig의 상태도 업데이트하십시오.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '이 상태는 SysConfig 설정에 있으며, 새 유형을 가리 키도록 설정을 업데이트해야합니다!',
        'State type' => '상태 유형',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '이 상태는 다음 구성 설정에서 사용됩니다.',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'OTRS 그룹에 지원 데이터를 보낼 수 없습니다!',
        'Enable Cloud Services' => '클라우드 서비스 사용',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '이 데이터는 정기적으로 OTRS 그룹에 전송됩니다. 이 데이터의 전송을 중지하려면 시스템 등록을 업데이트하십시오.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '이 버튼을 눌러 Support Data를 수동으로 트리거 할 수 있습니다 :',
        'Send Update' => '업데이트 보내기',
        'Currently this data is only shown in this system.' => '현재 이 데이터는 이 시스템에만 표시됩니다.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '이 단추를 누르면 지원 번들 (시스템 등록 정보, 지원 데이터, 설치된 패키지 목록 및 모든 로컬로 수정 된 소스 코드 파일 포함)을 생성 할 수 있습니다.',
        'Generate Support Bundle' => '지원 번들 생성',
        'The Support Bundle has been Generated' => '지원 번들이 생성 되었습니다.',
        'Please choose one of the following options.' => '다음 옵션 중 하나를 선택 하십시오.',
        'Send by Email' => '이메일로 보내기',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '지원 번들이 너무 커서 전자 메일로 보낼 수 없으면이 옵션이 비활성화되었습니다.',
        'The email address for this user is invalid, this option has been disabled.' =>
            '이 사용자의 이메일 주소가 유효하지 않습니다.이 옵션은 사용 중지되었습니다.',
        'Sending' => '보내다',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '지원 번들은 이메일을 통해 OTRS 그룹에 자동으로 전송됩니다.',
        'Download File' => '다운로드 파일',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '지원 번들이 들어있는 파일은 로컬 시스템에 다운로드됩니다. 파일을 저장하고 대체 방법을 사용하여 OTRS 그룹에 보내십시오.',
        'Error: Support data could not be collected (%s).' => '오류 : 지원 데이터를 수집 할 수 없습니다 (%s).',
        'Details' => '세부',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => '시스템 전자 메일 주소 관리',
        'Add System Email Address' => '시스템 전자 메일 주소 추가',
        'Edit System Email Address' => '시스템 전자 메일 주소 편집',
        'Add System Address' => '시스템 주소 추가',
        'Filter for System Addresses' => '시스템 주소 필터링',
        'Filter for system addresses' => '시스템 주소 필터링',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'To 또는 Cc에이 주소가있는 모든 수신 이메일이 선택된 대기열로 발송됩니다.',
        'Email address' => '이메일 주소',
        'Display name' => '표시 이름',
        'This email address is already used as system email address.' => '이 전자 메일 주소는 이미 시스템 전자 메일 주소로 사용됩니다.',
        'The display name and email address will be shown on mail you send.' =>
            '표시 이름과 이메일 주소가 보내는 메일에 표시됩니다.',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '온라인 관리자 문서',
        'System configuration' => '시스템 설정',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '왼쪽에있는 탐색 상자의 트리를 사용하여 사용 가능한 설정을 탐색하십시오.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '아래 검색란을 사용하거나 상단 탐색 메뉴의 검색 아이콘을 사용하여 특정 설정을 찾습니다.',
        'Find out how to use the system configuration by reading the %s.' =>
            '%s를 읽음으로써 시스템 구성을 사용하는 방법을 알아보십시오.',
        'Search in all settings...' => '모든 설정에서 검색...',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '현재 사용할 수있는 설정이 없습니다. 소프트웨어를 사용하기 전에 \'otrs.Console.pl Maint :: Config :: Rebuild\'를 실행하십시오. ',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '변경 사항 배포',
        'Help' => '도움',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '이것은 지금 시작하면 배포의 일부가 될 모든 설정에 대한 개요입니다. 오른쪽 상단의 아이콘을 클릭하여 이전 상태와 각 설정을 비교할 수 있습니다.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '배포에서 특정 설정을 제외하려면 설정의 헤더 모음에서 확인란을 클릭합니다.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '기본적으로 사용자가 직접 변경 한 설정 만 배포합니다. 다른 사용자가 변경 한 설정을 배포하려면 화면 상단의 링크를 클릭하여 고급 배포 모드로 전환하십시오.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '배포가 방금 복원 되었습니다. 즉, 영향을 받는 모든 설정이 선택한 배포의 상태로 되돌아 왔음을 의미합니다.',
        'Please review the changed settings and deploy afterwards.' => '변경된 설정을 검토하고 나중에 배포하십시오.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '변경 내용이 비어있는 목록은 영향을 받는 설정의 복원된 상태와 현재 상태간에 차이가 없음을 의미합니다.',
        'Changes Overview' => '변경 개요',
        'There are %s changed settings which will be deployed in this run.' =>
            '이 실행에 배포 될 설정이 %s개 변경되었습니다.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '기본 모드로 전환하면 변경된 설정만 배포됩니다.',
        'You have %s changed settings which will be deployed in this run.' =>
            '이 실행에 배포 할 설정이 %s개 변경되었습니다.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '다른 사용자가 변경한 설정을 배포하려면 고급 모드로 전환하십시오.',
        'There are no settings to be deployed.' => '배포할 설정이 없습니다.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '고급 모드로 전환하면 다른 사용자가 배포 가능한 설정을 변경할 수 있습니다.',
        'Deploy selected changes' => '선택한 변경 사항 배포',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '이 그룹에는 설정이 없습니다. 하위 그룹 중 하나를 탐색 해보십시오.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '수입 수출',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '시스템에 가져올 파일을 업로드하십시오 (시스템 구성 모듈에서 내 보낸 .yml 형식).',
        'Upload system configuration' => '시스템 구성 업로드',
        'Import system configuration' => '시스템 구성 가져오기',
        'Download current configuration settings of your system in a .yml file.' =>
            '.yml 파일에서 시스템의 현재 구성 설정을 다운로드하십시오.',
        'Include user settings' => '사용자 설정 포함',
        'Export current configuration' => '현재 구성 내보내기',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '검색',
        'Search for category' => '카테고리 검색',
        'Settings I\'m currently editing' => '설정 현재 편집 중입니다.',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '"%s"카테고리에서 "%s"로 검색 한 결과가 없습니다.',
        'Your search for "%s" in category "%s" returned one result.' => '"%s"카테고리에서 "%s"로 검색 한 결과가 1 개입니다.',
        'Your search for "%s" in category "%s" returned %s results.' => '"%s" 로 "%s"카테고리에서 검색한 결과 :  %s개',
        'You\'re currently not editing any settings.' => '현재 설정을 수정하지 않으셨습니다.',
        'You\'re currently editing %s setting(s).' => '현재 %s개의 설정 변경 중입니다.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => '범주',
        'Run search' => '검색 실행',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '사용자 정의 설정 목록보기',
        'View single Setting: %s' => '단일보기 설정 : %s',
        'Go back to Deployment Details' => '배치 세부 사항으로 돌아가기',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '시스템 유지 보수 관리',
        'Schedule New System Maintenance' => '새로운 시스템 유지 보수 일정 계획',
        'Filter for System Maintenances' => '시스템 유지 관리를 위한 필터',
        'Filter for system maintenances' => '시스템 유지 관리를 위한 필터',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '상담원과 고객을 알리기 휘한 시스템 유지 보수 기간을 예약하면 일정 기간 시스템이 다운됩니다.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '이 시스템 유지 보수가 시작되기 전에 사용자는 각 화면에서 이 사실을 알리는 알림을 받게 됩니다.',
        'Stop date' => '종료 날짜',
        'Delete System Maintenance' => '시스템 유지 보수 삭제',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '시스템 유지 보수 편집',
        'Edit System Maintenance Information' => '시스템 유지 보수 정보 편집',
        'Date invalid!' => '날짜가 잘못 되었습니다!',
        'Login message' => '로그인 메시지',
        'This field must have less then 250 characters.' => '이 입력란은 250자 미만이어야 합니다.',
        'Show login message' => '로그인 메시지 표시',
        'Notify message' => '알림 메시지',
        'Manage Sessions' => '세션 관리',
        'All Sessions' => '모든 세션',
        'Agent Sessions' => '에이전트 세션',
        'Customer Sessions' => '고객 세션',
        'Kill all Sessions, except for your own' => '자기만의 것을 제외한 모든 세션을 죽이십시오.',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => '템플릿 추가',
        'Edit Template' => '템플릿 편집',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '템플릿은 에이전트가 티켓, 응답 또는 전달을 더 빨리 작성할 수 있도록 도와주는 기본 텍스트입니다.',
        'Don\'t forget to add new templates to queues.' => '대기열에 새 템플릿을 추가하는 것을 잊지 마십시오.',
        'Attachments' => '첨부파일',
        'Delete this entry' => '이 항목 삭제',
        'Do you really want to delete this template?' => '이 템플릿을 정말로 삭제 하시겠습니까?',
        'A standard template with this name already exists!' => '이 이름을 가진 표준 템플릿이 이미 존재합니다!',
        'Template' => '템플릿',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => '만들기 유형 템플릿은 이 스마트 태그만 지원합니다.',
        'Example template' => '템플릿 예제',
        'The current ticket state is' => '현재 티켓 상태는 다음과 같습니다.',
        'Your email address is' => '귀하의 이메일 주소 : ',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => '모든 사용자에게 전환 사용',
        'Link %s to selected %s' => '%s를 선택한 %s에 연결',

        # Template: AdminType
        'Type Management' => '유형 관리',
        'Add Type' => '유형 추가',
        'Edit Type' => '유형 편집',
        'Filter for Types' => '유형 필터',
        'Filter for types' => '유형 필터',
        'A type with this name already exists!' => '이 이름을 가진 유형이 이미 존재합니다!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '이 유형은 SysConfig 설정에 있으며, 새 유형을 가리 키도록 설정을 업데이트해야합니다!',
        'This type is used in the following config settings:' => '이 유형은 다음 구성 설정에서 사용됩니다.',

        # Template: AdminUser
        'Agent Management' => '상담원 관리',
        'Edit Agent' => '상담원 수정',
        'Edit personal preferences for this agent' => '이 상담원의 개인 설정 수정',
        'Agents will be needed to handle tickets.' => '티켓을 처리하려면 상담원이 필요합니다.',
        'Don\'t forget to add a new agent to groups and/or roles!' => '그룹이나 역할에 새 상담원을 추가하는 것을 잊지마세요.',
        'Please enter a search term to look for agents.' => '상담원을 찾으려면 검색어를 입력하십시오.',
        'Last login' => '최종 로그인',
        'Switch to agent' => '상담원으로 변경',
        'Title or salutation' => '제목이나 인사말',
        'Firstname' => '이름',
        'Lastname' => '성',
        'A user with this username already exists!' => '이 사용자 이름을 가진 사용자가 이미 있습니다.',
        'Will be auto-generated if left empty.' => '비워 둘 경우 자동 생성됩니다.',
        'Mobile' => '모바일폰',
        'Effective Permissions for Agent' => '상담원 유효 권한',
        'This agent has no group permissions.' => '상담원이 그룹권한을 가지고 있지 않음',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '위의 표는 에이전트에 대한 효과적인 그룹 사용 권한을 보여줍니다. 행렬은 상속 된 모든 권한 (예 : 역할을 통해)을 고려합니다.',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '상담원-그룹 관계 관리',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Agenda 개요',
        'Manage Calendars' => '캘린더 관리',
        'Add Appointment' => '약속 추가',
        'Today' => '오늘',
        'All-day' => '매일',
        'Repeat' => '반복',
        'Notification' => '알림',
        'Yes' => '예',
        'No' => '아니요',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            '캘린더가 없습니다. 먼저 캘린더 관리 페이지를 사용하여 캘린더를 추가하십시오.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => '새 약속 추가',
        'Calendars' => '캘린더',

        # Template: AgentAppointmentEdit
        'Basic information' => '기본 정보',
        'Date/Time' => '날짜/시간',
        'Invalid date!' => '잘못된 날짜',
        'Please set this to value before End date.' => '종료일 전으로 선택하세요',
        'Please set this to value after Start date.' => '시작일 이후로 선택하세요',
        'This an occurrence of a repeating appointment.' => '반복 약속 생성',
        'Click here to see the parent appointment.' => '클릭하여 상위 약속 보기',
        'Click here to edit the parent appointment.' => '클릭하여 상위 약속 수정',
        'Frequency' => '주기',
        'Every' => '매',
        'day(s)' => '일',
        'week(s)' => '주',
        'month(s)' => '월',
        'year(s)' => '년',
        'On' => '온',
        'Monday' => '월요일',
        'Mon' => '월',
        'Tuesday' => '화요일',
        'Tue' => '화',
        'Wednesday' => '수요일',
        'Wed' => '수',
        'Thursday' => '목요일',
        'Thu' => '목',
        'Friday' => '금요일',
        'Fri' => '금',
        'Saturday' => '토요일',
        'Sat' => '토',
        'Sunday' => '일요일',
        'Sun' => '일',
        'January' => '1월',
        'Jan' => '1',
        'February' => '2월',
        'Feb' => '2',
        'March' => '3월',
        'Mar' => '3',
        'April' => '4월',
        'Apr' => '4',
        'May_long' => '5월',
        'May' => '5',
        'June' => '6월',
        'Jun' => '6',
        'July' => '7월',
        'Jul' => '7',
        'August' => '8월',
        'Aug' => '8',
        'September' => '9월',
        'Sep' => '9',
        'October' => '10월',
        'Oct' => '10',
        'November' => '11월',
        'Nov' => '11',
        'December' => '12월',
        'Dec' => '12',
        'Relative point of time' => '상대 시간',
        'Link' => '링크',
        'Remove entry' => '삭제',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '고객 정보 센터',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => '고객 사용자',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '고객이 바르지 않습니다.',
        'Start chat' => '채팅 시작',
        'Video call' => '비디오 전화',
        'Audio call' => '오디오 전화',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '고객 사용자 주소록',
        'Search for recipients and add the results as \'%s\'.' => '수신자를 검색하고 결과를 \'%s\'로 추가하세요.',
        'Search template' => '템플릿 검색',
        'Create Template' => '템플릿 생성',
        'Create New' => '새로 생성',
        'Save changes in template' => '템플릿의 변경 저장',
        'Filters in use' => '사용중인 필터',
        'Additional filters' => '추가 필터',
        'Add another attribute' => '다른 속성 추가',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '식별자가 \'(Customer)\'인 속성은 고객의 속성입니다',
        '(e. g. Term* or *Term*)' => '(예를 들어, 용어 * 또는 * 용어 *)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => '전체선택',
        'The customer user is already selected in the ticket mask.' => '티켓 마스크에서 고객 사용자가 이미 선택되었습니다.',
        'Select this customer user' => '이 고객 사용자 선택',
        'Add selected customer user to' => '선택한 고객 사용자를 추가',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => '검색 옵션을 변경',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '고객 사용자 정보 센터',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS Daemon은 비동기 작업을 수행하는 데몬 프로세스입니다. 티켓 에스컬레이션 트리거링, 이메일 전송 등',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            '올바른 시스템 작동을 위해서는 실행중인 OTRS 데몬이 필수입니다.',
        'Starting the OTRS Daemon' => 'OTRS Daemon 시작',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            '.dist (확장자없이) \'%s\'파일이 있는지 확인하십시오. 이 cron 작업은 OTRS 데몬이 실행중인 경우 5 분마다 점검하고 필요한 경우 시작합니다.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            '\'%s start\'를 실행하여 \'otrs\'사용자의 cron 작업이 활성 상태인지 확인하십시오.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            '5 분 후, OTRS 데몬이 시스템에서 실행 중인지 확인하십시오 ( \'bin / otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => '현황판',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => '새 약속',
        'Tomorrow' => '내일',
        'Soon' => '곧',
        '5 days' => '5일',
        'Start' => '시작',
        'none' => '없음',

        # Template: AgentDashboardCalendarOverview
        'in' => '...에서',

        # Template: AgentDashboardCommon
        'Save settings' => '설정 저장',
        'Close this widget' => '이 위젯 닫기',
        'more' => '더',
        'Available Columns' => '가능한 컬럼',
        'Visible Columns (order by drag & drop)' => '보여지는 컬럼(드래그드롭으로 순서정렬 가능)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '고객 관계 변경',
        'Open' => '진행중',
        'Closed' => '종료됨',
        '%s open ticket(s) of %s' => '진행중 티켓 중 %s / %s',
        '%s closed ticket(s) of %s' => '종료된 티켓 중 %s / %s',
        'Edit customer ID' => '고객 ID 수정',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Escalated 티켓',
        'Open tickets' => '진행중 티켓',
        'Closed tickets' => '종료된 티켓',
        'All tickets' => '모든 티켓',
        'Archived tickets' => '보관된 티켓',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '노트: 고객 사용자가 바르지 않습니다.',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '고객 사용자 정보',
        'Phone ticket' => '폰 티켓',
        'Email ticket' => '이메일 티켓',
        'New phone ticket from %s' => '%s로 새 폰 티켓',
        'New email ticket to %s' => '새 이메일 티켓을 %s로',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s 가능',
        'Please update now.' => '업데이트해주세요.',
        'Release Note' => '노트해 주세요.',
        'Level' => '레벨',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '작성한지 %s 지남',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '이 통계 위젯의 구성에 오류가 있습니다. 설정을 검토하십시오.',
        'Download as SVG file' => 'SVG로 다운로드',
        'Download as PNG file' => 'PNG로 다운로드',
        'Download as CSV file' => 'CSV로 다운로드',
        'Download as Excel file' => '엑셀로 다운로드',
        'Download as PDF file' => 'PDF로 다운로드',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '이 위젯의 ​​구성에서 유효한 그래프 출력 형식을 선택하십시오.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '이 통계의 내용이 준비 중입니다. 기다려주십시오.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '이 통계는 통계 관리자가 구성을 수정해야하기 때문에 현재 사용할 수 없습니다.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '고객 사용자에게 할당 됨',
        'Accessible for customer user' => '고객 사용자가 엑세스 가능',
        'My locked tickets' => '내 잠긴 티켓',
        'My watched tickets' => '내가 본 티켓',
        'My responsibilities' => '내 책임',
        'Tickets in My Queues' => '내 대기열의 티켓',
        'Tickets in My Services' => '내 서비스의 티켓',
        'Service Time' => '서비스 시간',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '총',

        # Template: AgentDashboardUserOnline
        'out of office' => '부재중',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '까지',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => '일부 뉴스, 라이센스 또는 일부 변경 사항을 수락합니다.',
        'Yes, accepted.' => '예, 수락됨',

        # Template: AgentLinkObject
        'Manage links for %s' => '관리하려면 %s',
        'Create new links' => '새로운 링크 생성',
        'Manage existing links' => '링크 관리',
        'Link with' => '연결',
        'Start search' => '검색 시작',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '현재 링크가 없습니다. 이 항목을 다른 개체에 링크하려면 상단의 \'새 링크 만들기\'를 클릭하십시오.',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '%s의 무단 사용이 감지되었습니다.',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => '환경설정 수정',
        'Personal Preferences' => '개인 환경 설정',
        'Preferences' => '환경설정',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '참고 : 현재 %s의 환경 설정을 수정 중입니다.',
        'Go back to editing this agent' => '이 에이전트 편집으로 돌아가기',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '개인적인 취향을 설정하십시오. 오른쪽의 체크 표시를 클릭하여 각 설정을 저장 하십시오.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '아래 탐색 트리를 사용하여 특정 그룹의 설정만 표시할 수 있습니다.',
        'Dynamic Actions' => '동적 동작',
        'Filter settings...' => '필터 설정...',
        'Filter for settings' => '설정 필터링',
        'Save all settings' => '모든 설정 저장',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '시스템 관리자는 아바타를 비활성화했습니다. 대신 이니셜을 볼 수 있습니다.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '이메일 주소 %s at %s 에 등록하여 아바타 이미지를 변경할 수 있습니다. 새로운 아바타가 캐싱으로 인해 사용 가능해질 때까지 약간의 시간이 걸릴 수 있습니다.',
        'Off' => '떨어져서',
        'End' => '종료',
        'This setting can currently not be saved.' => '이 설정은 현재 저장할 수 없습니다.',
        'This setting can currently not be saved' => '이 설정은 현재 저장할 수 없습니다.',
        'Save this setting' => '이 설정 저장',
        'Did you know? You can help translating OTRS at %s.' => '아시나요? OTRS를 %s에서 번역 할 수 있습니다.',

        # Template: SettingsList
        'Reset to default' => '기본값으로 재설정',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '오른쪽 그룹을 선택하여 변경하려는 설정을 찾으십시오.',
        'Did you know?' => '아시나요?',
        'You can change your avatar by registering with your email address %s on %s' =>
            '%s 에 %s의 이메일 주소로 등록하여 아바타를 변경할 수 있습니다.',

        # Template: AgentSplitSelection
        'Target' => '목적',
        'Process' => '프로세스',
        'Split' => '분리',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '통계 추가',
        'Read more about statistics in OTRS' => 'OTRS의 통계에 대해 자세히 알아보십시오.',
        'Dynamic Matrix' => '가변 매트릭스',
        'Each cell contains a singular data point.' => '각 셀에는 단일 데이터 요소가 포함되어 있습니다.',
        'Dynamic List' => '가변 리스트',
        'Each row contains data of one entity.' => '각 행은 하나의 엔티티의 데이터를 포함합니다.',
        'Static' => '정적인',
        'Non-configurable complex statistics.' => '구성할 수없는 복잡한 통계',
        'General Specification' => '일반 사양',
        'Create Statistic' => '통계 생성',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => '지금 실행',
        'Statistics Preview' => '통계 미리보기',
        'Save Statistic' => '통계 저장',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '통계 설정 Import',

        # Template: AgentStatisticsOverview
        'Statistics' => '통계',
        'Run' => '실행',
        'Edit statistic "%s".' => '통계 "%s"을 수정하십시오.',
        'Export statistic "%s"' => '통계 "%s" 내보내기',
        'Export statistic %s' => '통계 "%s" 내보내기',
        'Delete statistic "%s"' => '통계 "%s"  삭제',
        'Delete statistic %s' => '통계 "%s" 삭제',

        # Template: AgentStatisticsView
        'Statistics Overview' => '통계 개요',
        'View Statistics' => '',
        'Statistics Information' => '통계 정보',
        'Created by' => '작성자 : ',
        'Changed by' => '변경자 ',
        'Sum rows' => '행 합계',
        'Sum columns' => '열 합계',
        'Show as dashboard widget' => '대시 보드 위젯으로 표시',
        'Cache' => '저장하다',
        'This statistic contains configuration errors and can currently not be used.' =>
            '이 통계에는 구성 오류가 있으며 현재 사용할 수 없습니다.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '%s%s%s의 자유 텍스트 변경 ',
        'Change Owner of %s%s%s' => '%s%s%s의 소유자 변경',
        'Close %s%s%s' => '닫기 %s%s%s',
        'Add Note to %s%s%s' => '%s%s%s에 메모 추가',
        'Set Pending Time for %s%s%s' => '%s%s%s의 보류 시간 설정',
        'Change Priority of %s%s%s' => '%s%s%s의 우선 순위 변경',
        'Change Responsible of %s%s%s' => '%s%s%s의 책임 변경',
        'All fields marked with an asterisk (*) are mandatory.' => '별표 (*)로 표시된 모든 필드는 필수 항목입니다.',
        'The ticket has been locked' => '티켓이 잠겼습니다.',
        'Undo & close' => '실행 취소 및 닫기',
        'Ticket Settings' => '티켓 설정',
        'Queue invalid.' => '대기열이 잘못 되었습니다.',
        'Service invalid.' => '서비스가 유효하지 않습니다.',
        'SLA invalid.' => 'SLA가 유효하지 않습니다.',
        'New Owner' => '신규 소유자',
        'Please set a new owner!' => '새 주인을 설정하십시오!',
        'Owner invalid.' => '소유자가 유효하지 않습니다.',
        'New Responsible' => '새로운 책임',
        'Please set a new responsible!' => '새로운 책임을 설정하십시오!',
        'Responsible invalid.' => '책임지지 않습니다.',
        'Next state' => '다음 상태',
        'State invalid.' => '상태가 유효하지 않습니다.',
        'For all pending* states.' => '모든 보류 * 상태.',
        'Add Article' => '기사 추가',
        'Create an Article' => '기사 작성',
        'Inform agents' => '에이전트에게 알리기',
        'Inform involved agents' => '관련 요원에게 알린다.',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '여기에서 새 기사와 관련된 알림을 받을 추가 상담원을 선택할 수 있습니다.',
        'Text will also be received by' => '다음에 의해 텍스트도 받게 됩니다.',
        'Text Template' => '텍스트 템플릿',
        'Setting a template will overwrite any text or attachment.' => '템플릿을 설정하면 텍스트나 첨부파일을 덮어씁니다.',
        'Invalid time!' => '시간이 잘못 되었습니다!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '바운스 %s%s%s',
        'Bounce to' => '바운스',
        'You need a email address.' => '이메일 주소가 필요합니다.',
        'Need a valid email address or don\'t use a local email address.' =>
            '유효한 전자 메일 주소가 필요하거나 로컬 전자 메일 주소를 사용하지 마십시오.',
        'Next ticket state' => '다음 티켓 상태',
        'Inform sender' => '발신자에게 알리기',
        'Send mail' => '이메일 전송',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '티켓 일괄 작업',
        'Send Email' => '이메일 전송',
        'Merge' => '합침',
        'Merge to' => '합침',
        'Invalid ticket identifier!' => '잘못된 티켓 식별자입니다!',
        'Merge to oldest' => '가장 오래된 병합',
        'Link together' => '함께 연결',
        'Link to parent' => '상위 링크',
        'Unlock tickets' => '티켓 잠금 해제',
        'Execute Bulk Action' => '일괄 작업 실행',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '%s%s%s에 대한 답변 작성',
        'This address is registered as system address and cannot be used: %s' =>
            '이 주소는 시스템 주소로 등록되어 있으므로 사용할 수 없습니다 : %s',
        'Please include at least one recipient' => '수신자를 한 명 이상 포함하십시오.',
        'Select one or more recipients from the customer user address book.' =>
            '고객 사용자 주소록에서 하나 이상의 수신자를 선택하십시오.',
        'Customer user address book' => '고객 사용자 주소록',
        'Remove Ticket Customer' => '티켓 고객 제거',
        'Please remove this entry and enter a new one with the correct value.' =>
            '이 항목을 제거하고 올바른 값으로 새 항목을 입력하십시오.',
        'This address already exists on the address list.' => '이 주소는 이미 주소록에 있습니다.',
        'Remove Cc' => '참조 삭제',
        'Bcc' => '숨은 참조',
        'Remove Bcc' => '숨은 참조 제거',
        'Date Invalid!' => '잘못된 날짜!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '고객을 %s%s%s로 변경하십시오.',
        'Customer Information' => '고객 정보',
        'Customer user' => '고객 사용자',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => '새 전자 메일 티켓 만들기',
        'Example Template' => '템플릿 예제',
        'From queue' => '대기열에서',
        'To customer user' => '고객 사용자에게',
        'Please include at least one customer user for the ticket.' => '적어도 한 명의 고객 사용자를 티켓에 포함하십시오.',
        'Select this customer as the main customer.' => '이 고객을 주요 고객으로 선택하십시오.',
        'Remove Ticket Customer User' => '티켓 고객 사용자 제거',
        'Get all' => '모든 것을 가져라',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '%s%s%s의 발신 이메일',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '%s%s%s에게 이메일 다시 보내기',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '티켓 %s: 첫 번째 응답 시간이 끝났습니다 (%s/ %s)!',
        'Ticket %s: first response time will be over in %s/%s!' => '티켓 %s : 첫 번째 응답 시간은 %s/ %s로 끝납니다!',
        'Ticket %s: update time is over (%s/%s)!' => '티켓 %s : 업데이트 시간이 끝났습니다 (%s / %s)!',
        'Ticket %s: update time will be over in %s/%s!' => '티켓 %s: 업데이트 시간이 %s / %s 이상입니다!',
        'Ticket %s: solution time is over (%s/%s)!' => '티켓 %s : 해결 시간이 끝났습니다 (%s / %s)!',
        'Ticket %s: solution time will be over in %s/%s!' => '티켓 %s : 해결 시간은 %s / %s로 끝납니다!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '전달 %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '%s%s%s의 기록',
        'Filter for history items' => '기록 항목 필터링',
        'Expand/collapse all' => '모두 펼치기 / 접기',
        'CreateTime' => 'Created',
        'Article' => '조',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '병합 %s%s%s',
        'Merge Settings' => '병합 설정',
        'You need to use a ticket number!' => '티켓 번호를 사용해야합니다!',
        'A valid ticket number is required.' => '유효한 티켓 번호가 필요합니다.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '티켓 번호 또는 제목의 일부를 입력하여 검색하십시오.',
        'Limit the search to tickets with same Customer ID (%s).' => '같은 고객 ID (%s)의 티켓으로 검색을 제한하십시오.',
        'Inform Sender' => 'Inform Sender',
        'Need a valid email address.' => '유효한 이메일 주소가 필요합니다.',

        # Template: AgentTicketMove
        'Move %s%s%s' => '%s%s%s 로 이동',
        'New Queue' => '새로운 대기열',
        'Move' => '이동',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => '티켓이 없습니다.',
        'Open / Close ticket action menu' => '티켓 열기 / 닫기 액션 메뉴',
        'Select this ticket' => '이 티켓 선택',
        'Sender' => '보낸사람',
        'First Response Time' => '첫 번째 응답 시간',
        'Update Time' => '업데이트 시간',
        'Solution Time' => '솔루션 시간',
        'Move ticket to a different queue' => '티켓을 다른 대기열로 이동',
        'Change queue' => '대기열 변경',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => '이 화면에서 활성 필터를 제거하십시오.',
        'Tickets per page' => '페이지 당 티켓',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '누란된 채널',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '개요 재설정',
        'Column Filters Form' => '열 필터 양식',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '새로운 폰 티켓으로 분리',
        'Save Chat Into New Phone Ticket' => '채팅을 새로운 폰 티켓으로 저장',
        'Create New Phone Ticket' => '새로운 폰 티켓 생성',
        'Please include at least one customer for the ticket.' => '최소한 한 명의 고객을 티켓에 포함하십시오.',
        'To queue' => '대기열에 넣기',
        'Chat protocol' => '채팅 프로토콜',
        'The chat will be appended as a separate article.' => '채팅은 별도의 기사로 추가됩니다.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '%s%s%s 통화 중입니다.',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '%s%s%s에 대한 이메일보기 일반 텍스트',
        'Plain' => '명백한',
        'Download this email' => '이 이메일 다운로드',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '새 프로세스 티켓 만들기',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '티켓을 프로세스에 등록',

        # Template: AgentTicketSearch
        'Profile link' => '프로필 링크',
        'Output' => '산출',
        'Fulltext' => 'Fulltext',
        'Customer ID (complex search)' => '고객 ID (복합 검색)',
        '(e. g. 234*)' => '(예 : 234 *)',
        'Customer ID (exact match)' => '고객 ID (일치 항목)',
        'Assigned to Customer User Login (complex search)' => '고객 사용자 로그인 (복잡한 검색)에 할당 됨',
        '(e. g. U51*)' => '(예컨대, U51 *)',
        'Assigned to Customer User Login (exact match)' => '고객 사용자 로그인 (정확한 일치)에 할당 됨',
        'Accessible to Customer User Login (exact match)' => '고객 사용자 로그인 가능 (완전 일치)',
        'Created in Queue' => '대기열에서 생성됨',
        'Lock state' => '잠금 상태',
        'Watcher' => '참관인',
        'Article Create Time (before/after)' => '기사 작성 시간 (이전 / 이후)',
        'Article Create Time (between)' => '기사 작성 시간 (사이)',
        'Please set this to value before end date.' => '종료일 이전에 값으로 설정하십시오.',
        'Please set this to value after start date.' => '시작일 이후 값으로 설정 하십시오.',
        'Ticket Create Time (before/after)' => '티켓 생성 시간 (이전 / 이후)',
        'Ticket Create Time (between)' => '티켓 생성 시간 (사이)',
        'Ticket Change Time (before/after)' => '티켓 변경 시간 (이전 / 이후)',
        'Ticket Change Time (between)' => '티켓 변경 시간 (사이)',
        'Ticket Last Change Time (before/after)' => '티켓 마지막 변경 시간 (이전 / 이후)',
        'Ticket Last Change Time (between)' => '티켓 마지막 변경 시간 (사이)',
        'Ticket Pending Until Time (before/after)' => '시간 전까지 티켓 보류 중 (이전 / 이후)',
        'Ticket Pending Until Time (between)' => '시간 전까지 티켓 보류 중 (사이)',
        'Ticket Close Time (before/after)' => '티켓 종료 시간 (전후)',
        'Ticket Close Time (between)' => '티켓 종료 시간 (사이) ',
        'Ticket Escalation Time (before/after)' => '티켓 에스컬레이션 시간 (이전 / 이후)',
        'Ticket Escalation Time (between)' => '티켓 에스컬레이션 시간 (사이)',
        'Archive Search' => '아카이브 검색',

        # Template: AgentTicketZoom
        'Sender Type' => '발신자 유형',
        'Save filter settings as default' => '필터 설정을 기본값으로 저장',
        'Event Type' => '이벤트 유형',
        'Save as default' => '기본값으로 저장',
        'Drafts' => '체커',
        'by' => '으로',
        'Change Queue' => '대기열 변경',
        'There are no dialogs available at this point in the process.' =>
            '현재 이 과정에서 사용할 수 있는 대화 상자가 없습니다.',
        'This item has no articles yet.' => '이 항목에는 아직 기사가 없습니다.',
        'Ticket Timeline View' => '티켓 타임 라인보기',
        'Article Overview - %s Article(s)' => '기사 개관 - %s건의 기사',
        'Page %s' => '페이지 %s',
        'Add Filter' => '필터 추가',
        'Set' => '세트',
        'Reset Filter' => '필터 재설정',
        'No.' => '아니오.',
        'Unread articles' => '읽지 않은 기사',
        'Via' => '~를 이용해',
        'Important' => '중대한',
        'Unread Article!' => '읽지 않은 기사!',
        'Incoming message' => '수신 메시지 ',
        'Outgoing message' => '보내는 메시지',
        'Internal message' => '내부 메시지',
        'Sending of this message has failed.' => '이 메시지를 보내지 못했습니다.',
        'Resize' => '크기 조정',
        'Mark this article as read' => '이 기사를 읽음으로 표시 하십시오.',
        'Show Full Text' => '전체 텍스트 보기',
        'Full Article Text' => '전체 기사 텍스트',
        'No more events found. Please try changing the filter settings.' =>
            '이벤트가 더이상 없습니다. 필터 설정을 변경하십시오.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => '%s를 통해',
        'by %s' => '%s에 의해',
        'Toggle article details' => '기사 세부 정보 토글',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '이 메시지는 처리 중입니다. 이미 %s의 시간(s)을 보냈습니다. 다음 시도는 %s입니다.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '다음 문서에서 링크를 열려면 Ctrl 또는 Cmd 또는 Shift 키를 누른 상태에서 링크를 클릭해야합니다 (브라우저 및 OS에 따라 다름).',
        'Close this message' => '이 메시지를 닫습니다.',
        'Image' => '이미지',
        'PDF' => 'PDF',
        'Unknown' => '알 수 없는',
        'View' => '전망',

        # Template: LinkTable
        'Linked Objects' => '연결된 개체',

        # Template: TicketInformation
        'Archive' => '아카이브',
        'This ticket is archived.' => '이 티켓은 보관 처리됩니다.',
        'Note: Type is invalid!' => '참고 : 유형이 유효하지 않습니다!',
        'Pending till' => '대기 시간까지',
        'Locked' => '잠김',
        '%s Ticket(s)' => '%s개 티켓',
        'Accounted time' => '소요 시간',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '시스템에서 %s의 채널이 누락되었으므로이 기사의 미리보기를 사용할 수 없습니다.',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '이 기능은 %s의 일부입니다. 업그레이드하려면 %s로 문의하십시오.',
        'Please re-install %s package in order to display this article.' =>
            '이 기사를 표시하려면 %s의 패키지를 다시 설치하십시오.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '개인 정보를 보호하기 위해 원격 콘텐츠가 차단되었습니다.',
        'Load blocked content.' => '차단된 콘텐츠를 로드합니다.',

        # Template: Breadcrumb
        'Home' => '홈',
        'Back to admin overview' => '관리자 개요로 돌아가기',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '이 기능에는 클라우드 서비스가 필요합니다.',
        'You can' => '너는 할 수있다.',
        'go back to the previous page' => '이전 페이지로 돌아가기',

        # Template: CustomerAccept
        'Dear Customer,' => '친애하는 고객,',
        'thank you for using our services.' => '우리의 서비스를 이용해주셔서 감사합니다.',
        'Yes, I accept your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '고객 ID는 변경할 수 없으며이 티켓에 다른 고객 ID를 지정할 수 없습니다.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '먼저 고객 사용자를 선택한 다음이 티켓에 지정할 고객ID를 선택할 수 있습니다.',
        'Select a customer ID to assign to this ticket.' => '이 티켓에 지정할 고객 ID를 선택하십시오.',
        'From all Customer IDs' => '모든 고객 ID에서',
        'From assigned Customer IDs' => '할당 된 고객 ID로부터',

        # Template: CustomerError
        'An Error Occurred' => '에러 발생됨',
        'Error Details' => '오류 정보',
        'Traceback' => '역 추적',

        # Template: CustomerFooter
        '%s powered by %s™' => '%s powered by %s™',
        'Powered by %s™' => 'Powered by %s™',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '연결이 일시적으로 끊어진 후 다시 설정되었습니다. 이로 인해이 페이지의 요소가 올바르게 작동하지 않을 수 있습니다. 모든 요소를 ​​올바르게 다시 사용할 수있게하려면이 페이지를 다시로드하는 것이 좋습니다.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript를 사용할 수 없음',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '이 소프트웨어를 사용하려면 브라우저에서 JavaScript를 활성화해야합니다.',
        'Browser Warning' => '브라우저 경고',
        'The browser you are using is too old.' => '사용중인 브라우저가 너무 오래되었습니다.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '이 소프트웨어는 거대한 브라우저 목록과 함께 실행됩니다.이 중 하나를 업그레이드하십시오.',
        'Please see the documentation or ask your admin for further information.' =>
            '자세한 내용은 설명서를 참조하거나 관리자에게 문의하십시오.',
        'One moment please, you are being redirected...' => '잠시만 기다려주십시오. 리디렉션 중입니다...',
        'Login' => '로그인',
        'User name' => '사용자 이름',
        'Your user name' => '사용자 이름',
        'Your password' => '너의 비밀번호',
        'Forgot password?' => '비밀번호를 잊으셨나요?',
        '2 Factor Token' => '2 요소 토큰',
        'Your 2 Factor Token' => '당신의 2 팩터 토큰',
        'Log In' => '로그인',
        'Not yet registered?' => '아직 등록되지 않았습니까?',
        'Back' => '뒤',
        'Request New Password' => '새 비밀번호 요청',
        'Your User Name' => '사용자 이름',
        'A new password will be sent to your email address.' => '새 비밀번호가 이메일 주소로 전송됩니다.',
        'Create Account' => '계정 만들기',
        'Please fill out this form to receive login credentials.' => '로그인 자격 증명을 받으려면 이 양식을 작성하십시오.',
        'How we should address you' => '우리가 너를 어떻게 대해야하는지',
        'Your First Name' => '당신의 이름',
        'Your Last Name' => '당신의 성',
        'Your email address (this will become your username)' => '귀하의 이메일 주소 (귀하의 사용자 이름이됩니다)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '들어오는 채팅 요청',
        'Edit personal preferences' => '개인 환경 설정 편집',
        'Logout %s' => '로그 아웃 %s',

        # Template: CustomerTicketMessage
        'Service level agreement' => '서비스 수준 계약',

        # Template: CustomerTicketOverview
        'Welcome!' => '환영!',
        'Please click the button below to create your first ticket.' => '첫 번째 티켓을 만드려면 아래 버튼을 클릭하십시오.',
        'Create your first ticket' => '첫 번째 티켓 만들기',

        # Template: CustomerTicketSearch
        'Profile' => '프로필',
        'e. g. 10*5155 or 105658*' => '이자형. 지. 10 * 5155 또는 105658 *',
        'CustomerID' => '고객 ID',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '티켓에서 전체 텍스트 검색 (예 : "John * n"또는 "Will *")',
        'Types' => '유형',
        'Time Restrictions' => '시간 제한',
        'No time settings' => '시간 설정 없음',
        'All' => '모든',
        'Specific date' => '특정 날짜',
        'Only tickets created' => '생성된 티켓만',
        'Date range' => '날짜 범위',
        'Only tickets created between' => '사이에 생성된 티켓만',
        'Ticket Archive System' => '티켓 보관 시스템',
        'Save Search as Template?' => '검색을 템플릿으로 저장하시겠습니까?',
        'Save as Template?' => '템플릿으로 저장?',
        'Save as Template' => '템플릿으로 저장?',
        'Template Name' => '템플릿 이름',
        'Pick a profile name' => '프로필 이름 선택',
        'Output to' => '출력',

        # Template: CustomerTicketSearchResultShort
        'of' => '의',
        'Page' => '페이지',
        'Search Results for' => '에 대한 검색 결과',
        'Remove this Search Term.' => '이 검색 용어를 제거하십시오.',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '이 티켓에서 채팅 시작',
        'Next Steps' => '다음 단계',
        'Reply' => '댓글',

        # Template: Chat
        'Expand article' => '기사 펼치기',

        # Template: CustomerWarning
        'Warning' => '경고',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => '이벤트 정보',
        'Ticket fields' => '타켓 필드',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '정말 버그입니까? 10가지 중 5 가지 버그 리포트는 OTRS의 잘못되었거나 불완전한 설치로 인해 발생합니다.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '%s의 비용으로 전문가가 정확한 설치를 처리하고 지원 및 정기 보안 업데이트로 등을 제공합니다.',
        'Contact our service team now.' => '지금 서비스 팀에 문의하십시오.',
        'Send a bugreport' => 'bugreport 보내기',
        'Expand' => '넓히다',

        # Template: AttachmentList
        'Click to delete this attachment.' => '첨부파일을 삭제하려면 클릭하십시오.',

        # Template: DraftButtons
        'Update draft' => '초안 업데이트',
        'Save as new draft' => '새 초안으로 저장',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '"%s"초안을 로드했습니다.',
        'You have loaded the draft "%s". You last changed it %s.' => '"%s"초안을 로드했습니다. 마지막으로 %s로 변경했습니다.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '"%s"초안을로드했습니다. 마지막으로%s %s변경되었습니다.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '이 초안이 작성된 이후 티켓이 수정되었기 때문에 이 초안은 구식입니다.',

        # Template: Header
        'View notifications' => '알림보기',
        'Notifications' => '알림',
        'Notifications (OTRS Business Solution™)' => '알림 (OTRS Business Solution ™)',
        'Personal preferences' => '개인 환경설정',
        'Logout' => '로그아웃',
        'You are logged in as' => '귀하는 다음 계정으로 로그인했습니다.',

        # Template: Installer
        'JavaScript not available' => '자바스트립트를 사용할 수 없습니다.',
        'Step %s' => '%s 단계',
        'License' => '특허',
        'Database Settings' => '데이터베이스 설정',
        'General Specifications and Mail Settings' => '일반 사양 및 메일 설정',
        'Finish' => '끝',
        'Welcome to %s' => '%s에 오신 것을 환영합니다.',
        'Germany' => '',
        'Phone' => '전화',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => '웹 사이트',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '아웃 바운드 메일 구성',
        'Outbound mail type' => '발신 메일 유형',
        'Select outbound mail type.' => '아웃바운드 메일 유형을 선택하십시오.',
        'Outbound mail port' => '발신 메일 포트',
        'Select outbound mail port.' => '아웃 바운드 메일 포트를 선택하십시오.',
        'SMTP host' => 'SMTP 호스트',
        'SMTP host.' => 'SMTP 호스트',
        'SMTP authentication' => 'SMTP 인증',
        'Does your SMTP host need authentication?' => 'SMTP 호스트에 인증이 필요합니까?',
        'SMTP auth user' => 'SMTP 인증 사용자',
        'Username for SMTP auth.' => 'SMTP 인증을위한 사용자 이름.',
        'SMTP auth password' => 'SMTP 인증 암호',
        'Password for SMTP auth.' => 'SMTP 인증을위한 암호.',
        'Configure Inbound Mail' => '인바운드 메일 구성',
        'Inbound mail type' => '인바운드 메일 유형',
        'Select inbound mail type.' => '인바운드 메일 유형을 선택하십시오.',
        'Inbound mail host' => '인바운드 메일 호스트',
        'Inbound mail host.' => '인바운드 메일 호스트',
        'Inbound mail user' => '인바운드 메일 사용자',
        'User for inbound mail.' => '인바운드 메일의 사용자입니다.',
        'Inbound mail password' => '인바운드 메일 암호',
        'Password for inbound mail.' => '인바운드 메일의 비밀번호 입니다.',
        'Result of mail configuration check' => '메일 구성 검사 결과',
        'Check mail configuration' => '메일 구성 확인',
        'Skip this step' => '이 단계를 건너뛰기',

        # Template: InstallerDBResult
        'Done' => '끝난',
        'Error' => '오류',
        'Database setup successful!' => '데이터베이스 설정이 설공적으로 완료되었습니다!',

        # Template: InstallerDBStart
        'Install Type' => '설치 유형',
        'Create a new database for OTRS' => 'OTRS를위한 새로운 데이터베이스 생성',
        'Use an existing database for OTRS' => 'OTRS에 기존 데이터베이스 사용',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '데이터베이스의 루트 암호를 설정 한 경우 여기에 입력해야합니다. 그렇지 않은 경우이 필드를 비워 두십시오.',
        'Database name' => '데이터베이스 이름',
        'Check database settings' => '데이터베이스 설정 확인',
        'Result of database check' => '데이터베이스 검사 결과',
        'Database check successful.' => '데이터베이스 검사에 성공했습니다.',
        'Database User' => '데이터베이스 사용자',
        'New' => '새로운',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            '제한된 권한을 가진 새로운 데이터베이스 사용자가이 OTRS 시스템에 대해 생성됩니다.',
        'Repeat Password' => '비밀번호 반복',
        'Generated password' => '생성된 암호',

        # Template: InstallerDBmysql
        'Passwords do not match' => '비밀번호가 일치하지 않습니다.',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => '포트',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTRS를 사용하려면 명령 줄 (터미널 / 쉘)에 다음 행을 루트로 입력해야합니다.',
        'Restart your webserver' => '웹 서버 다시 시작',
        'After doing so your OTRS is up and running.' => '그렇게하면 OTRS가 실행됩니다.',
        'Start page' => '시작 페이지',
        'Your OTRS Team' => 'OTRS 팀',

        # Template: InstallerLicense
        'Don\'t accept license' => '면허를 받지마라.',
        'Accept license and continue' => '라이센스 수락 및 계속',

        # Template: InstallerSystem
        'SystemID' => '시스템 ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '시스템 식별자. 각 티켓 ​​번호와 각 HTTP 세션 ID에는이 번호가 들어 있습니다.',
        'System FQDN' => '시스템 FQDN',
        'Fully qualified domain name of your system.' => '시스템의 완전한 도메인 이름.',
        'AdminEmail' => 'AdminEmail',
        'Email address of the system administrator.' => '시스템 관리자의 전자 메일 주소입니다.',
        'Organization' => '조직',
        'Log' => '로그',
        'LogModule' => '로그모듈',
        'Log backend to use.' => '사용할 백엔드를 기록하십시오.',
        'LogFile' => '로그파일',
        'Webfrontend' => '웹 프론트 엔드',
        'Default language' => '기본 언어',
        'Default language.' => '기본 언어',
        'CheckMXRecord' => 'CheckMXRecord',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '수동으로 입력 한 전자 메일 주소는 DNS에있는 MX 레코드와 비교하여 검사됩니다. DNS가 느리거나 공개 주소를 확인하지 못하면이 옵션을 사용하지 마십시오.',

        # Template: LinkObject
        'Delete link' => '링크 삭제',
        'Delete Link' => '링크 삭제',
        'Object#' => '목적#',
        'Add links' => '링크 추가',
        'Delete links' => '링크 삭제',

        # Template: Login
        'Lost your password?' => '비밀번호를 잊어 버렸습니까?',
        'Back to login' => '로그인으로 돌아 가기',

        # Template: MetaFloater
        'Scale preview content' => '미리보기 콘텐츠 크기 조정',
        'Open URL in new tab' => '새 탭에서 URL 열기',
        'Close preview' => '미리보기 닫기',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '이 웹 사이트의 미리보기는 삽입할 수 없기 때문에 제공할 수 없습니다.',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '사용할 수없는 기능',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '죄송합니다. 현재 OTRS의이 기능은 휴대 기기에서 사용할 수 없습니다. 이 기능을 사용하려면 데스크톱 모드로 전환하거나 일반 데스크톱 장치를 사용할 수 있습니다.',

        # Template: Motd
        'Message of the Day' => '오늘의 메시지',
        'This is the message of the day. You can edit this in %s.' => '오늘의 메시지입니다. 이것을 %s에서 편집 할 수 있습니다.',

        # Template: NoPermission
        'Insufficient Rights' => '불충분한 권리',
        'Back to the previous page' => '이전 페이지로 돌아가기',

        # Template: Alert
        'Alert' => '경보',
        'Powered by' => 'Powered by',

        # Template: Pagination
        'Show first page' => '첫 페이지 표시',
        'Show previous pages' => '이전 페이지 보기',
        'Show page %s' => '%s페이지보기',
        'Show next pages' => '다음 페이지보기',
        'Show last page' => '마지막 페이지 표시',

        # Template: PictureUpload
        'Need FormID!' => 'FormID가 필요합니다!',
        'No file found!' => '파일을 찾을 수 없습니다!',
        'The file is not an image that can be shown inline!' => '파일은 인라인으로 표시할 수 있는 이미지가 아닙니다!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => '사용자가 구성할 수 있는 알림이 없습니다.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '\'%s\' 알림 메시지를 전송 방법 \'%s\'을 통해 수신합니다.',

        # Template: ActivityDialogHeader
        'Process Information' => '프로세스 정보',
        'Dialog' => '대화',

        # Template: Article
        'Inform Agent' => '에이전트에게 알리기',

        # Template: PublicDefault
        'Welcome' => '환영',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '이것은 OTRS의 기본 공용 인터페이스입니다! 주어진 행동 매개 변수가 없습니다.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '공용 인터페이스가있는 FAQ 모듈과 같이 (패키지 관리자)를 통해 사용자 정의 공용 모듈을 설치할 수 있습니다.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => '권한',
        'You can select one or more groups to define access for different agents.' =>
            '하나 이상의 그룹을 선택하여 다른 에이전트에 대한 엑세스를 정의할 수 있습니다.',
        'Result formats' => '결과 포맷',
        'Time Zone' => '시간대',
        'The selected time periods in the statistic are time zone neutral.' =>
            '통계에서 선택한 기간은 시간대 중립입니다.',
        'Create summation row' => '합계 행 만들기',
        'Generate an additional row containing sums for all data rows.' =>
            '모든 데이터 행에 대한 합계를 포함하는 추가 행을 생성하십시오.',
        'Create summation column' => '합계 열 만들기',
        'Generate an additional column containing sums for all data columns.' =>
            '모든 데이터 열에 대해 합계를 포함하는 추가 열을 생성하십시오.',
        'Cache results' => '결과 캐시',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '동일한 구성으로 후속 뷰에서 사용할 통계 결과 데이터를 캐시에 저장합니다 (적어도 하나의 선택된 시간 필드 필요).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '상담원이 대시 보드에서 활성화 할 수있는 위젯으로 통계를 제공합니다.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '대시 보드 위젯을 활성화하면 대시 보드에서 이 통계에 대한 캐싱이 활성화됩니다.',
        'If set to invalid end users can not generate the stat.' => '무효로 설정된 경우 최종사용자는 통계를 생성할 수 없습니다.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => '이 통계 구성에 문제가 있습니다.',
        'You may now configure the X-axis of your statistic.' => '이제 통계의 X 축을 구성 할 수 있습니다.',
        'This statistic does not provide preview data.' => '이 통계는 미리보기 데이터를 제공하지 않습니다.',
        'Preview format' => '미리보기 형식',
        'Please note that the preview uses random data and does not consider data filters.' =>
            '미리보기는 무작위 데이터를 사용하며 데이터 필터는 고려하지 않습니다.',
        'Configure X-Axis' => 'X 축 구성',
        'X-axis' => 'X 축',
        'Configure Y-Axis' => 'Y 축 구성',
        'Y-axis' => 'Y축',
        'Configure Filter' => '필터 구성',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '요소 하나만 선택하거나 \'고정\'버튼을 해제하십시오.',
        'Absolute period' => '절대 기간',
        'Between %s and %s' => '%s에서 %s 사이',
        'Relative period' => '상대 기간',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '과거 %s완료 및 현재 + 다음 완료 %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            '통계가 생성될 때 이 요소에 대한 변경을 허용하지 마십시오.',

        # Template: StatsParamsWidget
        'Format' => '체재',
        'Exchange Axis' => '교환 축',
        'Configurable Params of Static Stat' => '정적 통계의 구성 가능한 매개 변수',
        'No element selected.' => '선택된 요소가 없습니다.',
        'Scale' => '규모',
        'show more' => '자세히보기',
        'show less' => '적은 것을 보여준다',

        # Template: D3
        'Download SVG' => 'SVG 다운로드',
        'Download PNG' => 'PNG 다운로드',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            '선택한 기간은 이 통계가 데이터를 수집하는 기본 시간 프레임을 정의합니다.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '선택한 기간을 보고 데이터 요소로 분할하는데 사용할 시간 단위를 정의합니다.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Y 축의 축척은 X 축의 축척보다 커야합니다 (예 : X 축 => 월, Y 축 => 연도).',

        # Template: SettingsList
        'This setting is disabled.' => '이 설정은 사용할 수 없습니다.',
        'This setting is fixed but not deployed yet!' => '이 설정은 고정되어 있지만 아직 배포되지 않았습니다!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '이 설정은 현재 %s에서 덮어써지고 있으므로 여기에서 변경할 수 없습니다!',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '%s (%s)가 현재이 설정을 진행 중입니다.',
        'Toggle advanced options for this setting' => '이 설정에 대한 고급 옵션 토글',
        'Disable this setting, so it is no longer effective' => '이 설정을 비활성화하면 더이상 효과적이지 않습니다.',
        'Disable' => '사용 안함',
        'Enable this setting, so it becomes effective' => '이 설정을 사용하면 효과적입니다.',
        'Enable' => '사용',
        'Reset this setting to its default state' => '이 설정을 기본 상태로 재설정하십시오.',
        'Reset setting' => '재설정 설정',
        'Allow users to adapt this setting from within their personal preferences' =>
            '사용자가 개인 환경 설정에서 이 설정을 적용하도록 허용',
        'Allow users to update' => '사용자가 업데이트하도록 허용',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '사용자가 자신의 개인 취향 내에서 이 설정을 더이상 적용할 수 없게 하십시오.',
        'Forbid users to update' => '사용자가 업데이트 하는 것을 금지합니다.',
        'Show user specific changes for this setting' => '이 설정에 대한 사용자별 변경 사항 표시',
        'Show user settings' => '사용자 설정 표시',
        'Copy a direct link to this setting to your clipboard' => '이 설정에 대한 직접 링크를 클립 보드로 복사하십시오.',
        'Copy direct link' => '직접 링크 복사',
        'Remove this setting from your favorites setting' => '즐겨찾기 설정에서 이 설정을 제거하십시오.',
        'Remove from favourites' => '즐겨찾기에서 삭제',
        'Add this setting to your favorites' => '즐겨찾기에 이 설정 추가',
        'Add to favourites' => '즐겨찾기에 추가',
        'Cancel editing this setting' => '이 설정 편집 취소',
        'Save changes on this setting' => '이 설정의 변경사항 저장',
        'Edit this setting' => '이 설정 편집',
        'Enable this setting' => '이 설정 사용',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '이 그룹에는 설정이 없습니다. 하위 그룹 또는 다른 그룹으로 이동해보십시오.',

        # Template: SettingsListCompare
        'Now' => '지금',
        'User modification' => '사용자 수정',
        'enabled' => '사용 가능',
        'disabled' => '불구가 된',
        'Setting state' => '상태 설정 중',

        # Template: Actions
        'Edit search' => '검색 수정',
        'Go back to admin: ' => '관리자에게 돌아가기 : ',
        'Deployment' => '전개',
        'My favourite settings' => '내가 가장 좋아하는 설정',
        'Invalid settings' => '설정이 잘못되었습니다.',

        # Template: DynamicActions
        'Filter visible settings...' => '표시 설정 필터링...',
        'Enable edit mode for all settings' => '모든 설정에 대해 편집 모드 사용',
        'Save all edited settings' => '편집된 모든 설정 저장',
        'Cancel editing for all settings' => '모든 설정에 대한 편집 취소',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '이 위젯의 모든 동작은 오른쪽의 보이는 설정에만 적용됩니다.',

        # Template: Help
        'Currently edited by me.' => '현재 나를 편집했습니다.',
        'Modified but not yet deployed.' => '수정되었지만 아직 배치되지 않았습니다.',
        'Currently edited by another user.' => '다른 사용자가 현재 편집 중입니다.',
        'Different from its default value.' => '기본값과 다릅니다.',
        'Save current setting.' => '현재 설정을 저장하십시오.',
        'Cancel editing current setting.' => '현재 설정 편집 취소.',

        # Template: Navigation
        'Navigation' => '항해',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '%s에서 시스템 환경설정은 버전 관리, 롤백 및 사용자 별 구성 설정을 지원합니다.',

        # Template: Test
        'OTRS Test Page' => 'OTRS 테스트 페이지',
        'Unlock' => '잠금해제',
        'Welcome %s %s' => '환영합니다 %s %s',
        'Counter' => '계수기',

        # Template: Warning
        'Go back to the previous page' => '이전 페이지로 돌아가기',

        # JS Template: CalendarSettingsDialog
        'Show' => '보여주다',

        # JS Template: FormDraftAddDialog
        'Draft title' => '초안 제목',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '기사 표시',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '"%s"을 정말로 삭제 하시겠습니까?',
        'Confirm' => '확인',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '로딩 중 기다려주세요...',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '업로드 할 파일을 선택하려면 클릭하십시오.',
        'Click to select files or just drop them here.' => '여기를 클릭하여 파일을 선택하거나 그냥 클릭하십시오.',
        'Click to select a file or just drop it here.' => '클릭하여 파일을 선택하거나 여기에 놓으십시오.',
        'Uploading...' => '업로드 중...',

        # JS Template: InformationDialog
        'Process state' => '프로세스 상태',
        'Running' => '달리는',
        'Finished' => '끝마친',
        'No package information available.' => '사용할 수있는 패키지 정보가 없습니다.',

        # JS Template: AddButton
        'Add new entry' => '새 항목 추가',

        # JS Template: AddHashKey
        'Add key' => '키 추가',

        # JS Template: DialogDeployment
        'Deployment comment...' => '배포 설명...',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '배포 중입니다. 잠시 기다려주십시오...',
        'Preparing to deploy, please wait...' => '배포 준비 중입니다, 기다려주세요...',
        'Deploy now' => '지금 배포',
        'Try again' => '다시 시도하십시오.',

        # JS Template: DialogReset
        'Reset options' => '재설정 옵션',
        'Reset setting on global level.' => '글로벌 수준에서 설정을 다시 설정하십시오.',
        'Reset globally' => '전 세계적으로 재설정',
        'Remove all user changes.' => '모든 사용자 변경 사항을 제거하십시오.',
        'Reset locally' => '로컬로 재설정',
        'user(s) have modified this setting.' => '사용자(S)가 이 설정을 수정했습니다.',
        'Do you really want to reset this setting to it\'s default value?' =>
            '이 설정을 기본값으로 재설정 하시겠습니까?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '범주 선택을 사용하여 아래 탐색 트리를 선택한 범주의 항목으로 제한 할 수 있습니다. 카테고리를 선택하자마자 트리가 다시 빌드됩니다.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '데이터베이스 백엔드',
        'CustomerIDs' => '고객ID',
        'Fax' => '팩스',
        'Street' => '거리',
        'Zip' => 'Postal Code',
        'City' => '시티',
        'Country' => '국가',
        'Valid' => '유효한',
        'Mr.' => 'Mr.',
        'Mrs.' => 'Mrs.',
        'Address' => '주소',
        'View system log messages.' => '시스템 로그 메시지를 봅니다.',
        'Edit the system configuration settings.' => '시스템 구성 설정을 편집 하십시오.',
        'Update and extend your system with software packages.' => '소프트웨어 패키지로 시스템을 업데이트하고 확장하십시오.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '데이터베이스의 ACL 정보가 시스템 구성과 일치하지 않습니다. 모든 ACL을 배포하십시오.',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '알 수없는 오류로 인해 ACL을 가져올 수 없습니다. 자세한 내용은 OTRS 로그를 확인하십시오.',
        'The following ACLs have been added successfully: %s' => '다음 ACL이 성공적으로 추가되었습니다 : %s',
        'The following ACLs have been updated successfully: %s' => '다음 ACL이 성공적으로 업데이트되었습니다 : %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '다음 ACL을 추가 / 업데이트 할 때 오류가 발생합니다 : %s. 자세한 정보는 로그 파일을 확인하십시오.',
        'This field is required' => '이 필드는 필수 항목입니다.',
        'There was an error creating the ACL' => 'ACL을 만드는 중 오류가 발생했습니다.',
        'Need ACLID!' => 'ACLID가 필요합니다!',
        'Could not get data for ACLID %s' => 'ACLID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the ACL' => 'ACL 업데이트 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status.' => '엔티티 동기화 상태를 설정하는 중에 오류가 발생했습니다.',
        'There was an error synchronizing the ACLs.' => 'ACL을 동기화하는 중 오류가 발생했습니다.',
        'ACL %s could not be deleted' => 'ACL %s을 삭제할 수 없습니다.',
        'There was an error getting data for ACL with ID %s' => 'ID가 %s 인 ACL에 대한 데이터를 가져 오는 중 오류가 발생했습니다.',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '수퍼 유저 계정 (UserID 1)에 대한 ACL 제한은 무시됩니다.',
        'Exact match' => '정확히 일치',
        'Negated exact match' => '부정 일치 검색',
        'Regular expression' => '정규식',
        'Regular expression (ignore case)' => '정규식 (대소 문자 무시)',
        'Negated regular expression' => '부정적인 정규 표현식',
        'Negated regular expression (ignore case)' => '부정적 정규 표현식 (대소 문자 무시)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => '시스템에서 캘린더를 만들 수 없습니다!',
        'Please contact the administrator.' => '관리자에게 문의하십시오.',
        'No CalendarID!' => 'CalendarID 없음!',
        'You have no access to this calendar!' => '이 캘린더에 액세스 할 수 없습니다.',
        'Error updating the calendar!' => '달력을 업데이트하는 중 오류가 발생했습니다!',
        'Couldn\'t read calendar configuration file.' => '달력 구성 파일을 읽을 수 없습니다.',
        'Please make sure your file is valid.' => '파일이 유효한지 확인하십시오.',
        'Could not import the calendar!' => '캘린더를 가져올 수 없습니다!',
        'Calendar imported!' => '가져온 캘린더!',
        'Need CalendarID!' => 'CalendarID가 필요합니다!',
        'Could not retrieve data for given CalendarID' => '주어진 CalendarID에 대한 데이터를 검색 할 수 없습니다.',
        'Successfully imported %s appointment(s) to calendar %s.' => '%s의 약속을 캘린더 %s에  가져 왔습니다.',
        '+5 minutes' => '+5분',
        '+15 minutes' => '+15분',
        '+30 minutes' => '+30분',
        '+1 hour' => '+1시간',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => '권한 없음',
        'System was unable to import file!' => '시스템에서 파일을 가져올 수 없습니다!',
        'Please check the log for more information.' => '자세한 내용은 로그를 확인하십시오.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => '알람 이름이 이미 있습니다!',
        'Notification added!' => '알림 추가됨!',
        'There was an error getting data for Notification with ID:%s!' =>
            'ID가 %s 인 알림 데이터를 가져 오는 중 오류가 발생했습니다.',
        'Unknown Notification %s!' => '알 수없는 알림 %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => '알림을 만드는 중 오류가 발생했습니다.',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '알 수없는 오류로 인해 알림을 가져올 수 없습니다. 자세한 내용은 OTRS 로그를 확인하십시오.',
        'The following Notifications have been added successfully: %s' =>
            '다음 알림이 성공적으로 추가되었습니다 : %s',
        'The following Notifications have been updated successfully: %s' =>
            '다음 알림이 성공적으로 업데이트되었습니다 : %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '다음 알림을 추가 / 업데이트하는 중에 오류가 발생합니다 : %s. 자세한 정보는 로그 파일을 확인하십시오.',
        'Notification updated!' => '알림이 업데이트 되었습니다!',
        'Agent (resources), who are selected within the appointment' => '약속 내에서 선택된 상담원 (리소스)',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            '약속 (캘린더)에 대한 (적어도) 읽기 권한이있는 모든 상담원',
        'All agents with write permission for the appointment (calendar)' =>
            '약속 (캘린더)에 대한 쓰기 권한이있는 모든 상담원',
        'Yes, but require at least one active notification method.' => '예, 하나 이상의 활성 알림 방법이 필요합니다.',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => '첨부 파일이 추가되었습니다.',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '자동 응답이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '잘못된 CommunicationID!',
        'All communications' => '모든 통신',
        'Last 1 hour' => '지난 1시간',
        'Last 3 hours' => '지난 3시간',
        'Last 6 hours' => '지난 6시간',
        'Last 12 hours' => '지난 12시간',
        'Last 24 hours' => '지난 24시간',
        'Last week' => '지난주',
        'Last month' => '지난 달',
        'Invalid StartTime: %s!' => '잘못된 시작 시간 : %s!',
        'Successful' => '성공한',
        'Processing' => '가공',
        'Failed' => '실패한',
        'Invalid Filter: %s!' => '잘못된 필터 : %s!',
        'Less than a second' => '1초 미만',
        'sorted descending' => '내림차순 정렬',
        'sorted ascending' => '오름차순으로 정렬된',
        'Trace' => '자취',
        'Debug' => '디버그',
        'Info' => '정보',
        'Warn' => '경고',
        'days' => '일',
        'day' => '일',
        'hour' => '시간',
        'minute' => '분',
        'seconds' => '초',
        'second' => '초',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => '고객 회사가 업데이트 되었습니다!',
        'Dynamic field %s not found!' => '동적 필드 %s을 찾을 수 없습니다!',
        'Unable to set value for dynamic field %s!' => '동적 필드 %s에 대한 값을 설정할 수 없습니다!',
        'Customer Company %s already exists!' => '고객 회사 %s가 이미 존재합니다!',
        'Customer company added!' => '고객 회사가 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '\'CustomerGroupPermissionContext\'에 대한 구성이 없습니다!',
        'Please check system configuration.' => '시스템 구성을 확인하십시오.',
        'Invalid permission context configuration:' => '잘못된 권한 컨텍스트 구성 : ',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => '고객 업데이트됨',
        'New phone ticket' => '새로운 폰 티켓',
        'New email ticket' => '새로운 메일 티켓',
        'Customer %s added' => '고객 추가됨 : %s',
        'Customer user updated!' => '고객 사용자 업데이트됨',
        'Same Customer' => '같은 고객',
        'Direct' => '직접',
        'Indirect' => '간접적',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '그룹에 대한 고객 사용자 관계 변경',
        'Change Group Relations for Customer User' => '고객 사용자를 위한 그룹 관계 변경',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '고객 사용자를 서비스에 할당',
        'Allocate Services to Customer User' => '고객 사용자에게 서비스 할당',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '필드 설정이 바르지 않습니다.',
        'Objects configuration is not valid' => '오브젝트 설정이 바르지 않습니다.',
        'Database (%s)' => '데이터베이스 (%s)',
        'Web service (%s)' => '웹 서비스 (%s)',
        'Contact with data (%s)' => '데이터와의 접촉 (%s)',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '동적 필드 순서를 제대로 재설정 할 수 없습니다. 자세한 내용은 오류 로그를 확인하십시오.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '지정되지 않은 서브액션',
        'Need %s' => '%s 필요',
        'Add %s field' => '%s 필드 추가',
        'The field does not contain only ASCII letters and numbers.' => '입력란에는 ASCII 문자와 숫자 만 포함되지 않습니다.',
        'There is another field with the same name.' => '같은 이름의 다른 필드가 있습니다.',
        'The field must be numeric.' => '이 필드는 숫자여야 합니다.',
        'Need ValidID' => 'ValidID 필요',
        'Could not create the new field' => '새 필드를 만들지 못했습니다.',
        'Need ID' => '신분증이 필요함',
        'Could not get data for dynamic field %s' => '동적 필드 %s에 대한 데이터를 가져올 수 없습니다.',
        'Change %s field' => '동적 필드 %s에 대한 데이터가 없습니다.',
        'The name for this field should not change.' => '이 입력란의 이름은 변경해서는 안됩니다.',
        'Could not update the field %s' => '%s 필드를 업데이트 할 수 없습니다.',
        'Currently' => '현재',
        'Unchecked' => '선택하지 않았다.',
        'Checked' => '체크됨',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '미래의 날짜 입력 금지',
        'Prevent entry of dates in the past' => '과거 날짜 입력 금지',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '이 필드 값은 중복됩니다.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '받는 사람을 한 명 이상 선택하십시오.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => '분(s)',
        'hour(s)' => '시간(s)',
        'Time unit' => '시간 단위',
        'within the last ...' => '마지막으로...',
        'within the next ...' => '내에서...',
        'more than ... ago' => '이상...전',
        'Unarchived tickets' => '보관되지 않은 티켓',
        'archive tickets' => '보관 티켓',
        'restore tickets from archive' => '보관에서 티켓을 복원',
        'Need Profile!' => '프로필이 필요',
        'Got no values to check.' => '확인할 가치가 없습니다.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '티켓 선택에 사용할 수 없으므로 다음 단어를 삭제하십시오.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'WebserviceID가 필요합니다!',
        'Could not get data for WebserviceID %s' => 'WebserviceID %s에 대한 데이터를 가져올 수 없습니다.',
        'ascending' => '오름차순',
        'descending' => '내림차순',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '통신 유형이 필요합니다!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '통신 유형은 \'리퀘 스터\'또는 \'제공자\'여야합니다!',
        'Invalid Subaction!' => '부제가 잘못되었습니다.',
        'Need ErrorHandlingType!' => 'ErrorHandlingType이 필요합니다!',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType %s이 등록되지 않았습니다.',
        'Could not update web service' => '웹 서비스를 업데이트 할 수 없습니다.',
        'Need ErrorHandling' => 'ErrorHandling이 필요함',
        'Could not determine config for error handler %s' => 'Error handler %s에 대한 구성을 결정할 수 없습니다.',
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
        'Operation deleted' => '작업이 삭제되었습니다.',
        'Invoker deleted' => '호출자가 삭제되었습니다.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0초',
        '15 seconds' => '15초',
        '30 seconds' => '30초',
        '45 seconds' => '45초',
        '1 minute' => '1분',
        '2 minutes' => '2분',
        '3 minutes' => '3분',
        '4 minutes' => '4분',
        '5 minutes' => '5분',
        '10 minutes' => '10분',
        '15 minutes' => '15분',
        '30 minutes' => '30분',
        '1 hour' => '1시간',
        '2 hours' => '2시간',
        '3 hours' => '3시간',
        '4 hours' => '4시간',
        '5 hours' => '5시간',
        '6 hours' => '6시간',
        '12 hours' => '12시간',
        '18 hours' => '18시간',
        '1 day' => '1일',
        '2 days' => '2일',
        '3 days' => '3일',
        '4 days' => '4일',
        '6 days' => '6일',
        '1 week' => '1주',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Invoker %s의 구성을 결정할 수 없습니다.',
        'InvokerType %s is not registered' => 'InvokerType %s이 등록되지 않았습니다.',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '호출자가 필요합니다!',
        'Need Event!' => '이벤트가 필요합니다!',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'WebserviceID %s 의 설정을 업데이트 할 수 업습니다.',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => '끈',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Action type %s에 대한 등록 된 구성을 가져올 수 없습니다.',
        'Could not get backend for %s %s' => '%s %s의 백엔드를 가져올 수 없습니다.',
        'Keep (leave unchanged)' => '유지 (변경하지 않음)',
        'Ignore (drop key/value pair)' => '무시 (키 / 값 쌍 삭제)',
        'Map to (use provided value as default)' => '지도에 (제공된 값을 기본값으로 사용)',
        'Exact value(s)' => '정확한 값(들)',
        'Ignore (drop Value/value pair)' => '무시 (값 / 값 쌍 놓기)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => '필요한 라이브러리 %s을 찾을 수 없습니다.',
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
        'Could not determine config for operation %s' => '%s Operation에 대한 구성을 결정할 수 없습니다.',
        'OperationType %s is not registered' => 'OperationType %s이 등록되지 않았습니다.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '유효한 서브 액션이 필요합니다!',
        'This field should be an integer.' => '이 필드는 정수여야 합니다.',
        'File or Directory not found.' => '파일 또는 디렉터리를 찾을 수 없음.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '같은 이름의 다른 웹 서비스가 있습니다.',
        'There was an error updating the web service.' => '웹',
        'There was an error creating the web service.' => '웹 서비스를 업데이트 하는 중 오류가 발생했습니다.',
        'Web service "%s" created!' => 'Web service "%s"가 생성되었습니다! ',
        'Need Name!' => '이름이 필요합니다!',
        'Need ExampleWebService!' => 'ExampleWebService가 필요합니다!',
        'Could not load %s.' => '',
        'Could not read %s!' => '%s를 읽을 수 없습니다!',
        'Need a file to import!' => '가져올 파일이 필요합니다!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '가져온 파일에 유효한 YAML 콘텐츠가 없습니다! 자세한 내용은 OTRS 로그를 확인하십시오.',
        'Web service "%s" deleted!' => 'Web service "%s"이 삭제되었습니다!',
        'OTRS as provider' => '공급자 인 OTRS',
        'Operations' => '운영',
        'OTRS as requester' => '요청자 인 OTRS',
        'Invokers' => '인보커',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '웹 서비스 기록 ID가 없습니다!',
        'Could not get history data for WebserviceHistoryID %s' => 'WebserviceHistoryID %s의 기록 데이터를 가져올 수 없습니다.',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => '그룹이 업데이트 되었습니다!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => '메일 계정이 추가되었습니다!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '이메일 계정 가져오기가 이미 다른 프로세스에서 가져왔습니다. 나중에 다시 시도 해주십시오!',
        'Dispatching by email To: field.' => '이메일로 발송 : 수신자 : 필드.',
        'Dispatching by selected Queue.' => '선택한 대기열로 발송.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '티켓을 만든 에이전트',
        'Agent who owns the ticket' => '티켓을 소유한 에이전트',
        'Agent who is responsible for the ticket' => '티켓을 책임지는 요원',
        'All agents watching the ticket' => '티켓을 보고 있는 모든 요원',
        'All agents with write permission for the ticket' => '티켓에 대한 쓰기 권한이 있는 모든 에이전트',
        'All agents subscribed to the ticket\'s queue' => '모든 상담원이 티켓 대기열에 가입합니다.',
        'All agents subscribed to the ticket\'s service' => '티켓의 서비스에 가입한 모든 에이전트',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '티켓의 대기열과 서비스 모두에 가입한 모든 에이전트',
        'Customer user of the ticket' => '티켓의 고객 사용자',
        'All recipients of the first article' => '첫 번째 기사의 모든 수신자',
        'All recipients of the last article' => '마지막 기사의 모든 수신자',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => '시스템이 %s로 성공적으로 업그레이드되었습니다.',
        'There was a problem during the upgrade to %s.' => '%s로 업그레이드하는 동안 문제가 발생했습니다.',
        '%s was correctly reinstalled.' => '%s을 올바르게 다시 설치했습니다.',
        'There was a problem reinstalling %s.' => '%s을 재설치하는 중에 문제가 발생했습니다.',
        'Your %s was successfully updated.' => '%s이 성공적으로 업데이트되었습니다.',
        'There was a problem during the upgrade of %s.' => '%s 업그레이드 중 문제가 발생했습니다. ',
        '%s was correctly uninstalled.' => '%s이 올바르게 제거되었습니다.',
        'There was a problem uninstalling %s.' => '%s을 제거하는 중에 문제가 발생했습니다.',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP 환경이 작동하지 않습니다. 자세한 정보는 로그를 확인하십시오!',
        'Need param Key to delete!' => '필요한 param을 삭제하십시오!',
        'Key %s deleted!' => '키 %s 삭제됨!',
        'Need param Key to download!' => '다운로드하려면 param이 필요합니다!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '죄송합니다, Apache :: Reload는 Apache config 파일의 PerlModule 및 PerlInitHandler로 필요합니다. scripts / apache2-httpd.include.conf도 참조하십시오. 또는 명령 행 도구 bin / otrs.Console.pl을 사용하여 패키지를 설치할 수 있습니다!',
        'No such package!' => '그런 패키지는 없습니다!',
        'No such file %s in package!' => '패키지에 %s 파일이 없습니다!',
        'No such file %s in local file system!' => '로컬 파일 시스템에 %s 파일이 없습니다!',
        'Can\'t read %s!' => '%s를 읽을 수 없습니다!',
        'File is OK' => '파일은 정상입니다.',
        'Package has locally modified files.' => '패키지에 로컬로 수정된 파일이 있습니다.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '패키지가 OTRS 그룹에 의해 확인되지 않았습니다! 이 패키지를 사용하지 않는 것이 좋습니다.',
        'Not Started' => '시작되지 않음',
        'Updated' => '업데이트 됨',
        'Already up-to-date' => '이미 최신',
        'Installed' => '설치됨',
        'Not correctly deployed' => '올바르게 배치되지 않음',
        'Package updated correctly' => '패키지가 올바르게 업데이트 되었습니다.',
        'Package was already updated' => '패키지가 이미 업데이트 되었습니다.',
        'Dependency installed correctly' => '종속성이 올바르게 설치 되었습니다.',
        'The package needs to be reinstalled' => '패키지를 다시 설치해야 합니다.',
        'The package contains cyclic dependencies' => '패키지에는 순환 종속성이 있습니다.',
        'Not found in on-line repositories' => '온라인 리포지토리에는 없습니다.',
        'Required version is higher than available' => '필수 버전이 사용 가능한 버전보다 큽니다.',
        'Dependencies fail to upgrade or install' => '종속성을 업그레이드 또는 설치하지 못함',
        'Package could not be installed' => '패키지를 설치할 수 없습니다.',
        'Package could not be upgraded' => '패키지를 업그레이드 할 수 없습니다.',
        'Repository List' => '저장소 목록',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            '확인 서버와의 통신 문제로 인해 패키지가 확인되지 않았습니다!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'OTRS 기능 추가 기능 목록 서버에 연결할 수 없습니다!',
        'Can\'t get OTRS Feature Add-on list from server!' => '서버에서 OTRS 기능 추가 기능 목록을 가져올 수 없습니다!',
        'Can\'t get OTRS Feature Add-on from server!' => '서버에서 OTRS 기능 추가 기능을 가져올 수 없습니다!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '해당 필터 없음 : %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => '우선 순위가 추가되었습니다.',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '데이터베이스의 프로세스 관리 정보가 시스템 구성과 동기화되지 않았습니다. 모든 프로세스를 동기화 하십시오.',
        'Need ExampleProcesses!' => 'ExampleProcesses가 필요합니다!',
        'Need ProcessID!' => 'ProcessID가 필요합니다!',
        'Yes (mandatory)' => '예 (필수)',
        'Unknown Process %s!' => '알 수없는 프로세스 %s!',
        'There was an error generating a new EntityID for this Process' =>
            '이 프로세스에 대한 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'The StateEntityID for state Inactive does not exists' => '상태 비활성에 대한 StateEntityID가 없습니다.',
        'There was an error creating the Process' => '프로세스를 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '프로세스 엔티티에 대한 엔티티 동기화 상태를 설정하는 중 오류가 발생했습니다 : %s',
        'Could not get data for ProcessID %s' => 'ProcessID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the Process' => '프로세스를 업데이트 하는 중 오류가 발생했습니다.',
        'Process: %s could not be deleted' => 'Process : %s을 삭제할 수 없습니다.',
        'There was an error synchronizing the processes.' => '프로세스를 동기화하는 중 오류가 발생했습니다.',
        'The %s:%s is still in use' => '%s : %s는 아직 사용 중입니다.',
        'The %s:%s has a different EntityID' => '%s : %s의 EntityID가 다릅니다.',
        'Could not delete %s:%s' => '%s : %s을 삭제할 수 없습니다.',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '엔티티 동기화 상태 설정 오류 : %s, 엔티티 %s',
        'Could not get %s' => '%s를 얻을 수 없음',
        'Need %s!' => '%s 필요!',
        'Process: %s is not Inactive' => 'Process : %s이 비활성 상태가 아닙니다.',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '이 활동에 대한 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the Activity' => '활동을 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Activity 엔티티에 대한 엔티티 동기화 상태를 설정하는 중 오류가 발생했습니다 : %s',
        'Need ActivityID!' => 'ActivityID가 필요합니다!',
        'Could not get data for ActivityID %s' => 'ActivityID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the Activity' => '활동을 업데이트 하는 중 오류가 발생했습니다.',
        'Missing Parameter: Need Activity and ActivityDialog!' => '누락 된 매개 변수 : 필요한 활동 및 ActivityDialog!',
        'Activity not found!' => '활동을 찾을 수 없습니다!',
        'ActivityDialog not found!' => 'ActivityDialog를 찾을 수 없습니다!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'ActivityDialog가 이미 Activity에 할당되었습니다. ActivityDialog를 두 번 추가 할 수는 없습니다!',
        'Error while saving the Activity to the database!' => '활동을 데이터베이스에 저장하는 동안 오류가 발생했습니다!',
        'This subaction is not valid' => '이 하위 작업이 유효하지 않습니다.',
        'Edit Activity "%s"' => 'Activity 편집 "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '이 ActivityDialog에 대한 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the ActivityDialog' => 'ActivityDialog를 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'ActivityDialog 엔터티에 대한 엔터티 동기화 상태를 설정하는 중 오류가 발생했습니다 : %s',
        'Need ActivityDialogID!' => 'ActivityDialogID가 필요합니다!',
        'Could not get data for ActivityDialogID %s' => 'ActivityDialogID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the ActivityDialog' => 'ActivityDialog를 업데이트하는 중 오류가 발생했습니다.',
        'Edit Activity Dialog "%s"' => 'Activity Dialog 수정 "%s"',
        'Agent Interface' => '에이전트 인터페이스',
        'Customer Interface' => '고객 인터페이스',
        'Agent and Customer Interface' => '에이전트 및 고객 인터페이스',
        'Do not show Field' => '필드 표시 안 함',
        'Show Field' => '필드 표시',
        'Show Field As Mandatory' => '필수 입력란으로 표시',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '경로 편집',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '이 전환에 대해 새 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the Transition' => '전환을 만드는 중에 오류가 발생했습니다.',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '전환 엔티티에 대한 엔티티 동기화 상태를 설정하는 중에 오류가 발생했습니다 : %s',
        'Need TransitionID!' => '전환 ID가 필요합니다!',
        'Could not get data for TransitionID %s' => 'TransitionID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the Transition' => '전환을 업데이트 하는 중 오류가 발생했습니다.',
        'Edit Transition "%s"' => '전환 편집 "%s"',
        'Transition validation module' => '전환 유효성 검사 모듈',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '하나 이상의 유효한 config 매개 변수가 필요합니다.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '이 TransitionAction에 대한 새로운 EntityID를 생성하는 중 오류가 발생했습니다.',
        'There was an error creating the TransitionAction' => 'TransitionAction을 만드는 중 오류가 발생했습니다.',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'TransitionAction 항목의 항목 동기화 상태를 설정하는 중에 오류가 발생했습니다 : %s',
        'Need TransitionActionID!' => 'TransitionActionID가 필요합니다!',
        'Could not get data for TransitionActionID %s' => 'TransitionActionID %s에 대한 데이터를 가져올 수 없습니다.',
        'There was an error updating the TransitionAction' => 'TransitionAction을 업데이트하는 중 오류가 발생했습니다.',
        'Edit Transition Action "%s"' => '전환 Action 편집 "%s"',
        'Error: Not all keys seem to have values or vice versa.' => '오류 : 모든 키가 값을 가진 것처럼 보이지 않거나 그 반대의 경우도 있습니다.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => '대기열이 업데이트 되었습니다.',
        'Don\'t use :: in queue name!' => '큐 이름에 ::를 사용하지 마십시오!',
        'Click back and change it!' => '뒤로 클릭하고 변경하십시오!',
        '-none-' => '- 없음 -',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '대기열 (자동 응답 없음)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => '템플릿에 대한 대기열 관계 변경',
        'Change Template Relations for Queue' => '대기열에 대한 템플릿 관계 변경',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '생산',
        'Test' => '테스트',
        'Training' => '훈련',
        'Development' => '개발',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => '역할이 업데이트 되었습니다!',
        'Role added!' => '역할이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => '역할에 대한 그룹 관계 변경',
        'Change Role Relations for Group' => '그룹의 역할 관계 변경',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '역할',
        'Change Role Relations for Agent' => '에이전트의 역할 관계 변경',
        'Change Agent Relations for Role' => '역할에 대한 에이전트 관계 변경',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => '먼저 %s를 활성화하십시오!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S / MIME 환경이 작동하지 않습니다. 자세한 정보는 로그를 확인하십시오!',
        'Need param Filename to delete!' => '제거 할 param 파일 이름이 필요합니다!',
        'Need param Filename to download!' => 'param 파일 이름을 다운로드해야합니다!',
        'Needed CertFingerprint and CAFingerprint!' => '필요한 CertFingerprint 및 CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint는 CertFingerprint와 달라야합니다.',
        'Relation exists!' => '관계가 존재합니다!',
        'Relation added!' => '관계가 추가되었습니다!',
        'Impossible to add relation!' => '관계를 추가할 수 없습니다!',
        'Relation doesn\'t exists' => '관계가 존재하지 않습니다.',
        'Relation deleted!' => '관계가 삭제되었습니다!',
        'Impossible to delete relation!' => '관계를 삭제할 수 없습니다!',
        'Certificate %s could not be read!' => '인증서 %s을 읽을 수 없습니다.',
        'Needed Fingerprint' => '필요한 지문',
        'Handle Private Certificate Relations' => '개인 인증서 관계 처리',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => '인사말이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => '서명이 업데이트 되었습니다!',
        'Signature added!' => '서명이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => '상태가 추가 되었습니다!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '파일 %s을 읽을 수 없습니다!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => '시스템 전자 메일 주소가 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '잘못된 설정',
        'There are no invalid settings active at this time.' => '현재 잘못된 설정이 활성화되어 있지 않습니다.',
        'You currently don\'t have any favourite settings.' => '현재 즐겨찾는 설정이 없습니다.',
        'The following settings could not be found: %s' => '다음 설정을 찾을 수 없습니다 : %s',
        'Import not allowed!' => '가져오기가 허용되지 않습니다!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '알 수없는 오류로 인해 시스템 구성을 가져올 수 없습니다. 자세한 내용은 OTRS 로그를 확인하십시오.',
        'Category Search' => '카테고리 검색',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '일부 가져온 설정은 구성의 현재 상태에 나타나지 않거나 업데이트 할 수 없습니다. 자세한 내용은 OTRS 로그를 확인하십시오.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '잠금 전에 설정을 활성화해야 합니다!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '%s(%s)가 현재 작업 중이므로이 설정으로 작업 할 수 없습니다.',
        'Missing setting name!' => '설정 이름이 없습니다!',
        'Missing ResetOptions!' => '누락 된 ResetOptions!',
        'Setting is locked by another user!' => '다른 사용자가 설정을 잠갔습니다!',
        'System was not able to lock the setting!' => '시스템이 설정을 잠글 수 없습니다!',
        'System was not able to reset the setting!' => '시스템에서 설정을 재설정 할 수 없었습니다!',
        'System was unable to update setting!' => '시스템이 설정을 업데이트 할 수 없습니다!',
        'Missing setting name.' => '설정 이름이 없습니다.',
        'Setting not found.' => '설정을 찾을 수 없습니다.',
        'Missing Settings!' => '설정이 없습니다!',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '시작일은 종요일 이후에 정의되어서는 안됩니다!',
        'There was an error creating the System Maintenance' => '시스템 유지 보수를 작성하는 중 오류가 발생했습니다.',
        'Need SystemMaintenanceID!' => 'SystemMaintenanceID가 필요합니다!',
        'Could not get data for SystemMaintenanceID %s' => 'SystemMaintenanceID %s에 대한 데이터를 가져올 수 없습니다.',
        'System Maintenance was added successfully!' => '시스템 유지 보수가 성공적으로 추가 되었습니다!',
        'System Maintenance was updated successfully!' => '시스템 유지 보수가 성공적으로 업데이트되었습니다!',
        'Session has been killed!' => '세션이 종료되었습니다!',
        'All sessions have been killed, except for your own.' => '모든 세션이 자신의 것을 제외한 모든 세션에서 종료되었습니다.',
        'There was an error updating the System Maintenance' => '시스템 유지 보수를 업데이트하는 중 오류가 발생했습니다.',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'SystemMaintenance 항목을 삭제할 수 없습니다 : %s',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '템플릿이 업데이트 되었습니다!',
        'Template added!' => '템플릿이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => '템플릿에 대한 첨부 파일 관계 변경',
        'Change Template Relations for Attachment' => '첨부 파일에 대한 템플릿 관계 변경',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '유형 필요!',
        'Type added!' => '유형이 추가되었습니다!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => '에이전트가 업데이트 되었습니다!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => '에이전트에 대한 그룹 관계 변경',
        'Change Agent Relations for Group' => '그룹에 대한 상담원 관계 변경',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => '달',
        'Week' => '주',
        'Day' => '일',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => '모든 약속',
        'Appointments assigned to me' => '나에게 할당된 약속',
        'Showing only appointments assigned to you! Change settings' => '나에게 할당된 약속만 표시! 설정 변경',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => '약속을 찾을 수 없습니다!',
        'Never' => '절대로',
        'Every Day' => '매일',
        'Every Week' => '매주',
        'Every Month' => '매달',
        'Every Year' => '매년',
        'Custom' => '관습',
        'Daily' => '매일',
        'Weekly' => '주간',
        'Monthly' => '월간',
        'Yearly' => '연간',
        'every' => '...마다',
        'for %s time(s)' => '1 %s 시간 동안',
        'until ...' => '때까지...',
        'for ... time(s)' => '...시간(들) 동안',
        'until %s' => '%s 까지',
        'No notification' => '알림없음',
        '%s minute(s) before' => '%s 분전',
        '%s hour(s) before' => '%s 시간전',
        '%s day(s) before' => '%s 일전',
        '%s week before' => '%s 주일 전에',
        'before the appointment starts' => '약속 시작 전에',
        'after the appointment has been started' => '약속이 시작된 후',
        'before the appointment ends' => '약속이 끝나기 전에',
        'after the appointment has been ended' => '약속이 끝난 후',
        'No permission!' => '비허가!',
        'Cannot delete ticket appointment!' => '티켓 예약을 삭제할 수 없습니다!',
        'No permissions!' => '비허가!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s 이상',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => '고객 이력',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'RecipientField가 제공되지 않습니다!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '%s에 해당하는 설정이 없습니다.',
        'Statistic' => '통계량',
        'No preferences for %s!' => '%s에 대한 환경 설정이 없습니다!',
        'Can\'t get element data of %s!' => '%s의 요소 데이터를 가져올 수 없습니다!',
        'Can\'t get filter content data of %s!' => '%s의 필터 콘텐츠 데이터를 가져올 수 없습니다!',
        'Customer Name' => '고객 이름',
        'Customer User Name' => '고객 사용자 이름',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'SourceObject와 SourceKey가 필요합니다!',
        'You need ro permission!' => '당신은 허가가 필요합니다!',
        'Can not delete link with %s!' => '%s의 링크를 삭제할 수 없습니다!',
        '%s Link(s) deleted successfully.' => '%s 링크(들)가 성공적으로 삭제되었습니다.',
        'Can not create link with %s! Object already linked as %s.' => '%s의 링크를 만들 수 없습니다! 개체가 이미 %s로 연결되었습니다.',
        'Can not create link with %s!' => '%s의 링크를 만들 수 없습니다!',
        '%s links added successfully.' => '%s의 링크가 성공적으로 추가되었습니다.',
        'The object %s cannot link with other object!' => '%s의 개체는 다른 개체와 연결할 수 없습니다!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Param 그룹이 필요합니다!',
        'Updated user preferences' => '업데이트 된 사용자 환경설정',
        'System was unable to deploy your changes.' => '시스템에서 변경 사항을 배치할 수 없습니다.',
        'Setting not found!' => '설정을 찾을 수 없습니다!',
        'System was unable to reset the setting!' => '시스템에서 설정을 재설정 할 수 없습니다!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '티켓 처리',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '매개 변수 %s이 없습니다.',
        'Invalid Subaction.' => '부제가 잘못되었습니다.',
        'Statistic could not be imported.' => '통계를 가져올 수 없습니다.',
        'Please upload a valid statistic file.' => '유효한 통계 파일을 업로드 하십시오.',
        'Export: Need StatID!' => '내보내기 : StatID가 필요합니다!',
        'Delete: Get no StatID!' => '삭제 : StatID를 가져 오지 마십시오!',
        'Need StatID!' => 'StatID가 필요합니다!',
        'Could not load stat.' => '통계를 로드 할 수 없습니다.',
        'Add New Statistic' => '새 통계 추가',
        'Could not create statistic.' => '통계를 만들 수 없습니다.',
        'Run: Get no %s!' => '실행 :  No %s 획득!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'TicketID가 주어지지 않았습니다!',
        'You need %s permissions!' => '%s의 권한이 필요합니다!',
        'Loading draft failed!' => '초안로드 실패!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '죄송합니다. 이 작업을 수행하려면 티켓 소유자여야 합니다.',
        'Please change the owner first.' => '먼저 소유자를 변경하십시오.',
        'FormDraft functionality disabled!' => 'FormDraft 기능이 비활성화되었습니다!',
        'Draft name is required!' => '초안 이름이 필요합니다!',
        'FormDraft name %s is already in use!' => 'FormDraft 이름 %s이 이미 사용 중입니다!',
        'Could not perform validation on field %s!' => '%s 필드에서 유효성 검사를 수행 할 수 없습니다!',
        'No subject' => '제목 없음',
        'Could not delete draft!' => '초안을 삭제할 수 없습니다!',
        'Previous Owner' => '이전 소유자',
        'wrote' => '쓴',
        'Message from' => '님의 메시지',
        'End message' => '메시지 끝내기',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s가 필요합니다!',
        'Plain article not found for article %s!' => '%s Article에 대한 일반 Article이 없습니다!',
        'Article does not belong to ticket %s!' => 'Article는 티켓 %s에 속하지 않습니다!',
        'Can\'t bounce email!' => '이메일을 반송할 수 없습니다!',
        'Can\'t send email!' => '이메일을 보낼 수 없습니다!',
        'Wrong Subaction!' => '잘못된 교섭!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '티켓을 잠글 수 없으며 TicketID가 제공되지 않습니다!',
        'Ticket (%s) is not unlocked!' => '티켓 (%s)은 잠금 해제되지 않았습니다!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => '하나 이상의 티켓을 선택해야 합니다.',
        'Bulk feature is not enabled!' => '대량 기능을 사용할 수 없습니다!',
        'No selectable TicketID is given!' => '선택할 수있는 TicketID가 제공되지 않습니다!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '티켓을 선택하지 않았거나 다른 상담원이 잠근 티켓만 선택했습니다.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '다음 티켓은 다른 에이전트에 의해 잠겨 있거나이 티켓에 대한 쓰기 권한이 없기 때문에 무시되었습니다 : %s.',
        'The following tickets were locked: %s.' => '다음 티켓이 잠겼습니다 : %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => '주소 %s는 등록 된 고객 주소로 바뀝니다.',
        'Customer user automatically added in Cc.' => 'Cc에 고객 사용자가 자동으로 추가되었습니다.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => '티켓 "%s"가 생성되었습니다!',
        'No Subaction!' => '아니요!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'TicketID가 없습니다!',
        'System Error!' => '시스템 오류!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'ArticleID가 주어지지 않았습니다!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => '다음 주',
        'Ticket Escalation View' => '티켓 Escalation 뷰',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'Article %s을 찾을 수 없습니다!',
        'Forwarded message from' => '에서 전달된 메시지',
        'End forwarded message' => '전달된 메시지 끝내기',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '기록을 표시 할 수 없으며 TicketID가 제공되지 않습니다!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '티켓을 잠글 수 없으며 TicketID가 제공되지 않습니다!',
        'Sorry, the current owner is %s!' => '죄송합니다, 현재 소유자는 %s입니다!',
        'Please become the owner first.' => '먼저 주인이 되십시오.',
        'Ticket (ID=%s) is locked by %s!' => '티켓 (ID = %s)이 %s에 의해 잠김!',
        'Change the owner!' => '소유자 변경',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => '새 게시물',
        'Pending' => '지연',
        'Reminder Reached' => '알림발생',
        'My Locked Tickets' => '나의 잠긴 티켓',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '티켓을 합칠 수 없습니다.',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '이동할 권한이 없습니다.',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '채팅이 Active 되지 않음',
        'No permission.' => '권한 없음',
        '%s has left the chat.' => '%s이 채팅에서 탈퇴했습니다.',
        'This chat has been closed and will be removed in %s hours.' => '이 채팅은 폐쇄되었으며 %s 시간 후에 삭제됩니다.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => '티켓이 잠겼습니다.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '아니 ArticleID!',
        'This is not an email article.' => '이것은 이메일 기사가 아닙니다.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '평범한 기사를 읽을 수 없습니다! 어쩌면 백엔드에 일반 전자 메일이 없습니다! 백엔드 메시지를 읽습니다.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'TicketID가 필요합니다!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'ActivityDialogEntityID "%s"을 가져올 수 없습니다!',
        'No Process configured!' => '프로세스가 구성되지 않았습니다!',
        'The selected process is invalid!' => '선택한 프로세스가 유효하지 않습니다!',
        'Process %s is invalid!' => '프로세스 %s이 잘못되었습니다!',
        'Subaction is invalid!' => '하위 작업이 잘못되었습니다.',
        'Parameter %s is missing in %s.' => '매개 변수 %s이 없습니다. %s',
        'No ActivityDialog configured for %s in _RenderAjax!' => '_RenderAjax에서 %s에 대해 구성된 ActivityDialog 없음!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '프로세스에 대한 Start ActivityEntityID 또는 Start ActivityDialogEntityID가 없습니다. _GetParam에서 %s!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'TicketID에 대한 티켓을 가져올 수 없습니다 : _GetParam에서 %s!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'ActivityEntityID를 결정할 수 없습니다. DynamicField 또는 Config가 올바르게 설정되지 않았습니다!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s 구성 값이 없습니다!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'ProcessEntityID 또는 TicketID 및 ActivityDialogEntityID가 없습니다!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'ProcessEntityID "%s"에 대해 StartActivityDialog 및 StartActivityDialog를 가져올 수 없습니다!',
        'Can\'t get Ticket "%s"!' => '티켓 "%s"을 얻을 수 없습니다!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '티켓 "%s"에 대한 ProcessEntityID 또는 ActivityEntityID를 가져올 수 없습니다!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'ActivityEntityID "%s"에 대한 활동 구성을 가져올 수 없습니다!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'ActivityDialogEntityID "%s"에 대한 ActivityDialog 구성을 가져올 수 없습니다!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '"%s"필드에 대한 데이터를 가져올 수 없습니다! ActivityDialog "%s" ',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '상태 또는 StateID가 동일한 ActivityDialog에 대해 구성된 경우 PendingTime을 사용할 수 있습니다. ActivityDialog : %s!',
        'Pending Date' => '보류 날짜',
        'for pending* states' => '보류 중 * 상태',
        'ActivityDialogEntityID missing!' => 'ActivityDialogEntityID가 없습니다!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'ActivityDialogEntityID "%s"에 대한 구성을 가져올 수 없습니다!',
        'Couldn\'t use CustomerID as an invisible field.' => '보이지 않는 필드로 CustomerID를 사용할 수 없습니다.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '누락 된 ProcessEntityID, ActivityDialogHeader.tt를 확인하십시오!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '프로세스 "%s"에 대한 StartActivityDialog 또는 StartActivityDialog가 구성되지 않았습니다!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'ProcessEntityID "%s"로 프로세스 티켓을 만들 수 없습니다!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'ProcessEntityID "%s"을 설정할 수 없습니다! TicketID "%s"에',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'ActivityEntityID "%s"을 설정할 수 없습니다! TicketID "%s"',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'ActivityDialog를 저장할 수 없습니다. 유효하지 않습니다. TicketID : %s!',
        'Invalid TicketID: %s!' => '잘못된 TicketID : %s!',
        'Missing ActivityEntityID in Ticket %s!' => '티켓 %s에 ActivityEntityID가 누락되었습니다!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '이 단계는 \'%s %s %s\'티켓의 진행중인 현재 활동에 더 이상 속하지 않습니다! 다른 사용자가이 티켓을 변경했습니다. 이 창을 닫고 티켓을 다시로드하십시오.',
        'Missing ProcessEntityID in Ticket %s!' => '티켓 %s에 ProcessEntityID가 누락되었습니다!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '%s의 DynamicField값 설정할 수 없음 - 티켓 ID "%s" - ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'PendingTime 설정할 수 없음 - 티켓 ID "%s" - ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '잘못된 ActivityDialog 필드 설정 : %s는 표시 => 1 / 표시 필드 일 수 없습니다. (표시 => 0 / 필드 표시 안 함 또는 표시 => 2 / 표시 필드를 필수로 변경하십시오)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '%s 설정할 수 없음 - 티켓 ID "%s" - ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'Process::Default%s 의 기본 구성이 누락되었습니다!',
        'Default Config for Process::Default%s invalid!' => 'Process::Default%s 의 기본 구성이 잘못되었습니다!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => '가능한 티켓',
        'including subqueues' => '하위대기열 포함',
        'excluding subqueues' => '하위대기열 제외',
        'QueueView' => '대기열보기',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => '내 책임있는 티켓',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => '최종검색',
        'Untitled' => '이름없음',
        'Ticket Number' => '티켓 번호',
        'Ticket' => '티켓',
        'printed by' => '프린트',
        'CustomerID (complex search)' => '고객ID(복합검색)',
        'CustomerID (exact match)' => '고객ID(일치)',
        'Invalid Users' => '잘못된 사용자',
        'Normal' => '일반',
        'CSV' => 'CSV',
        'Excel' => '엑셀',
        'in more than ...' => '이상...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '부가기능이 사용가능하지 않음',
        'Service View' => '서비스 뷰',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => '상태 뷰',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => '내가 본 티켓',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '부가기능이 활성화되지 않음',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => '링크 삭제됨',
        'Ticket Locked' => '티켓이 잠김',
        'Pending Time Set' => '지연시간 셋팅',
        'Dynamic Field Updated' => 'Dynamic 필트가 업데이트됨',
        'Outgoing Email (internal)' => '발송 이메일(내부)',
        'Ticket Created' => '티켓이 생성됨',
        'Type Updated' => '타입이 생성됨',
        'Escalation Update Time In Effect' => '효과의 에스컬레이션 업데이트 시간',
        'Escalation Update Time Stopped' => '에스컬레이션 업데이트 시간 중지됨',
        'Escalation First Response Time Stopped' => '에스컬레이션 첫 번째 응답 시간 중지됨',
        'Customer Updated' => '고객가 업데이트됨',
        'Internal Chat' => '내부 채팅',
        'Automatic Follow-Up Sent' => '자동 후속 보냄',
        'Note Added' => '노트가 추가됨',
        'Note Added (Customer)' => '노트가 추가됨(고객)',
        'SMS Added' => 'SMS 추가됨',
        'SMS Added (Customer)' => 'SMS 추가됨(고객)',
        'State Updated' => '상태가 업데이트됨',
        'Outgoing Answer' => '답변 보내기',
        'Service Updated' => '서비스가 업데이트됨',
        'Link Added' => '링크가 추가됨',
        'Incoming Customer Email' => '수신 고객 이메일',
        'Incoming Web Request' => '수신 웹 요청',
        'Priority Updated' => '심각도 업데이트됨',
        'Ticket Unlocked' => '티켓이 잠금해제됨',
        'Outgoing Email' => '발신 이메일',
        'Title Updated' => '제목이 업데이트됨',
        'Ticket Merged' => '티켓이 합쳐짐',
        'Outgoing Phone Call' => '발신 전화',
        'Forwarded Message' => '전달된 메시지',
        'Removed User Subscription' => '삭제된 사용자 가입',
        'Time Accounted' => '회계 시간',
        'Incoming Phone Call' => '수신 전화',
        'System Request.' => '시스템 요청',
        'Incoming Follow-Up' => '들어오는 후속 조치',
        'Automatic Reply Sent' => '자동으로 답변 보냄',
        'Automatic Reject Sent' => '자동으로 거부 보냄',
        'Escalation Solution Time In Effect' => '에스컬레이션 솔루션 시간의 효과',
        'Escalation Solution Time Stopped' => '에스컬레이션 솔루션 시간 중지됨',
        'Escalation Response Time In Effect' => '에스컬레이셔 응답 시간',
        'Escalation Response Time Stopped' => '에스컬레이션 응답 시간 중지됨',
        'SLA Updated' => 'SLA 업데이트 됨',
        'External Chat' => '외부 채팅',
        'Queue Changed' => '대기열이 변경됨',
        'Notification Was Sent' => '알림을 보냈습니다.',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '이 티켓이 없거나 현재 상태로 액세스 할 수있는 권한이 없습니다.',
        'Missing FormDraftID!' => '누락 된 FormDraftID!',
        'Can\'t get for ArticleID %s!' => 'ArticleID %s를 얻을 수 없습니다!',
        'Article filter settings were saved.' => '기사 필터 설정이 저장되었습니다.',
        'Event type filter settings were saved.' => '이벤트 유형 필터 설정이 저장되었습니다.',
        'Need ArticleID!' => 'ArticleID가 필요합니다!',
        'Invalid ArticleID!' => '잘못된 ArticleID!',
        'Forward article via mail' => '우편으로 기사 전달',
        'Forward' => '전달',
        'Fields with no group' => '그룹이 없는 필드',
        'Invisible only' => '보이지 않는 곳만',
        'Visible only' => '표시 전용',
        'Visible and invisible' => '표시 및 숨김',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '기사를 열 수 없습니다! 아마 다른 기사 페이지에 있습니까?',
        'Show one article' => '기사 한 개 표시',
        'Show all articles' => '모든 기사 표시',
        'Show Ticket Timeline View' => '티켓 타임 라인보기 표시',
        'Show Ticket Timeline View (%s)' => '티켓 타임라인 보기 (%s)',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'FormID 없음.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '오류 : 파일을 제대로 삭제할 수 없습니다. 관리자에게 문의하십시오 (누락 된 FileID).',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'ArticleID이 필요합니다!',
        'No TicketID for ArticleID (%s)!' => 'ArticleID (%s)에 대한 TicketID가 없습니다!',
        'HTML body attachment is missing!' => 'HTML 본문 첨부가 없습니다.',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'FileID와 ArticleID가 필요합니다!',
        'No such attachment (%s)!' => '첨부 파일이 없습니다 (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '%s::QueueDefault에 대한 SysConfig 설정을 확인하십시오.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '%s::TicketTypeDefault에 대한 SysConfig 설정을 확인하십시오.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '고객 ID가 필요합니다!',
        'My Tickets' => '내 티켓',
        'Company Tickets' => '회사 티켓',
        'Untitled!' => '제목없는!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => '고객 실명',
        'Created within the last' => '마지막으로 생성된',
        'Created more than ... ago' => '만든 이상 ...전',
        'Please remove the following words because they cannot be used for the search:' =>
            '다음 단어를 검색에 사용할 수 없으므로 제거하십시오.',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '티켓을 다시 열 수 없으며 이 대기열에서 불가능합니다!',
        'Create a new ticket!' => '새 티켓을 만드십시오!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureMode 활성!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '설치 프로그램을 다시 실행하려면 SysConfig에서 SecureMode를 비활성화하십시오.',
        'Directory "%s" doesn\'t exist!' => '"%s" 디렉토리가 존재하지 않습니다!',
        'Configure "Home" in Kernel/Config.pm first!' => '먼저 Kernel / Config.pm에서 "홈"을 구성하십시오!',
        'File "%s/Kernel/Config.pm" not found!' => '"%s/Kernel/Config.pm"파일을 찾을 수 없습니다!',
        'Directory "%s" not found!' => '"%s" 디렉토리를 찾을 수 없습니다!',
        'Install OTRS' => 'OTRS 설치',
        'Intro' => '소개',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel / Config.pm에 쓸 수 없습니다!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '설치 프로그램을 사용하려면 웹 서버 사용자에게 Kernel / Config.pm 쓰기 권한을 설정하십시오!',
        'Database Selection' => '데이터베이스 선택',
        'Unknown Check!' => '알 수없는 확인!',
        'The check "%s" doesn\'t exist!' => '"%s" 체크가 존재하지 않습니다!',
        'Enter the password for the database user.' => '데이터베이스 사용자의 암호를입력하십시오.',
        'Database %s' => '데이터베이스 %s',
        'Configure MySQL' => 'MySQL 구성',
        'Enter the password for the administrative database user.' => '관리 데이터베이스 사용자의 암호를 입력하십시오.',
        'Configure PostgreSQL' => 'PostgreSQL 설정',
        'Configure Oracle' => 'Oracle 구성',
        'Unknown database type "%s".' => '알 수없는 데이터베이스 유형 "%s".',
        'Please go back.' => '돌아가 주세요.',
        'Create Database' => '데이터베이스 생성',
        'Install OTRS - Error' => 'OTRS 설치 - 오류',
        'File "%s/%s.xml" not found!' => '"%s / %s.xml"파일을 찾을 수 없습니다!',
        'Contact your Admin!' => '관리자에게 문의하십시오!',
        'System Settings' => '환경 설정',
        'Syslog' => 'Syslog',
        'Configure Mail' => '메일 구성',
        'Mail Configuration' => '메일 구성',
        'Can\'t write Config file!' => '구성 파일을 쓸 수 없습니다!',
        'Unknown Subaction %s!' => '알 수없는 Subaction %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '데이터베이스에 연결할 수 없습니다. Perl 모듈 DBD :: %s이 설치되지 않았습니다!',
        'Can\'t connect to database, read comment!' => '데이터베이스에 연결할 수 없으므로 주석을 읽으십시오!',
        'Database already contains data - it should be empty!' => '데이터베이스에 이미 데이터가 있습니다. 비워두워야 합니다.',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '오류 : 데이터베이스가 크기가 %s를 넘는 패킷을 수락하는지 확인하십시오 (패키지는 현재 최대 %s MB 만 허용). 오류를 피하기 위해 데이터베이스의 max_allowed_packet 설정을 조정하십시오.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '오류 : 데이터베이스의 innodb_log_file_size 값을 최소 %s MB (현재 : %s MB, 권장 : %s MB)로 설정하십시오. 자세한 내용은 %s를보십시오.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '잘못된 데이터베이스 정렬 (%s는 %s이지만 utf8이어야합니다).',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => '아니 %s!',
        'No such user!' => '그런 사용자가 없습니다!',
        'Invalid calendar!' => '캘린더가 잘못되었습니다.',
        'Invalid URL!' => '잘못된 URL!',
        'There was an error exporting the calendar!' => '캘린더를 내보내는 중에 오류가 발생했습니다!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '구성 필요 패키지 :: RepositoryAccessRegExp',
        'Authentication failed from %s!' => '%s에서 인증 실패!',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => '다른 메일 주소로 기사 반송',
        'Bounce' => '되튐',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => '모든 응답',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '이 기사 다시 보내기',
        'Resend' => '재전송',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '이 기사의 메시지 로그 세부 사항보기',
        'Message Log' => '메시지 로그',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => '메모에 회신',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => '이 기사 분할',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => '이 기사의 출처보기',
        'Plain Format' => '일반 형식',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => '이 기사 인쇄',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'sales@otrs.com으로 문의하십시오.',
        'Get Help' => '도움말 보기',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => '마크',
        'Unmark' => '마크 해제',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => 'OTRS Business Solution ™으로 업그레이드하십시오.',
        'Re-install Package' => '패키지 다시 설치',
        'Upgrade' => '업그레이드',
        'Re-install' => '다시 설치',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Crypted',
        'Sent message encrypted to recipient!' => '수신자에게 암호화 된 메시지를 보냈습니다!',
        'Signed' => '서명 됨',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE"헤더가 발견되었지만 유효하지 않습니다!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S / MIME SIGNED MESSAGE"헤더가 발견되었지만 유효하지 않습니다!',
        'Ticket decrypted before' => '이 전에 해독된 티켓',
        'Impossible to decrypt: private key for email was not found!' => '불가능 해독 : 전자 메일의 개인 키를 찾을 수 없습니다!',
        'Successful decryption' => '성공적인 해독',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '주소에 사용할 수있는 암호화 키가 없습니다 \'%s\'.',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '주소에 대해 선택된 암호화 키가 없습니다 : \'%s\'.',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '암호화',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '키 / 인증서는 둘 이상의 키 / 인증서가있는 수신자에 대해서만 표시됩니다. 처음 발견 된 키 / 인증서가 사전 선택됩니다. 올바른 것을 선택하십시오.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '이메일 보안',
        'PGP sign' => 'PGP 서명',
        'PGP sign and encrypt' => 'PGP 서명 및 암호화',
        'PGP encrypt' => 'PGP 암호화',
        'SMIME sign' => 'SMIME 사인',
        'SMIME sign and encrypt' => 'SMIME 서명 및 암호화',
        'SMIME encrypt' => 'SMIME 암호화',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '\'%s\'주소에 사용할 수있는 서명 키가 없습니다.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '\'%s\'주소에 대해 선택한 서명 키가 없습니다.',
        'Sign' => '신호',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '하나 이상의 키 / 인증서가있는 발신자에 대해서만 키 / 인증서가 표시됩니다. 처음 발견 된 키 / 인증서가 사전 선택됩니다. 올바른 것을 선택하십시오.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => '표시된',
        'Refresh (minutes)' => '새로고침(분)',
        'off' => '떨어져서',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '표시된 고객 ID',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => '표시된 고객 사용자',
        'Offline' => '오프라인',
        'User is currently offline.' => '사용자는 현재 오프라인 상태입니다.',
        'User is currently active.' => '사용자가 현재 활성 상태입니다.',
        'Away' => '떨어져',
        'User was inactive for a while.' => '사용자는 잠시동안 비활성 상태였습니다.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '종료 시간 후에 티켓의 시작 시간이 설정되었습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => 'OTRS 뉴스 서버에 연결할 수 없습니다!',
        'Can\'t get OTRS News from server!' => '서버에서 OTRS 뉴스를 가져올 수 없습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '제품 뉴스 서버에 연결할 수 없습니다!',
        'Can\'t get Product News from server!' => '서버에서 제품 뉴스를 가져올 수 없습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '%s에 연결할 수 없습니다!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => '표시된 티켓',
        'Shown Columns' => '표시된 열',
        'filter not active' => '필터가 활성화되지 않음',
        'filter active' => '활성 필터',
        'This ticket has no title or subject' => '이 티켓에는 제목이나 주제가 없습니다.',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => '7일간 통계',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => '사용자가 상태를 사용할 수 없도록 설정했습니다.',
        'Unavailable' => '불가능',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => '표준',
        'The following tickets are not updated: %s.' => '',
        'h' => '시간',
        'm' => '분',
        'd' => '일',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '이 티켓이 없거나 현재 상태로 액세스 할 수 있는 권한이 없습니다. 다음 작업 중 하나를 수행할 수 있습니다.',
        'This is a' => '이것은',
        'email' => '이메일',
        'click here' => '여기를 클릭',
        'to open it in a new window.' => '새 창에서 열려면.',
        'Year' => '년',
        'Hours' => '시간',
        'Minutes' => '분',
        'Check to activate this date' => '이 날짜를 활성화하려면 선택하십시오.',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => '비허가!',
        'No Permission' => '비허가',
        'Show Tree Selection' => '트리 선택 표시',
        'Split Quote' => '분할 견적',
        'Remove Quote' => '견적을 제거하십시오',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '로 연결된',
        'Search Result' => '검색 결과',
        'Linked' => '연결됨',
        'Bulk' => '일괄',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => '라이트',
        'Unread article(s) available' => '읽지 않은 기사(들)',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => '약속',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '보관 검색',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => '클라우드 서비스로 모든 OTRS 기능을 구현할 수 있습니다!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s 지금 %s로 업그레이드하십시오! %s',
        'Please verify your license data!' => '라이센스 데이터를 확인 하십시오!',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '%s에 대한 라이센스가 곧 만료됩니다. 계약을 갱신 하시려면%s와 연락하십시오!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '%s의 업데이트를 사용할 수 있지만 프레임 워크 버전과 충돌이 있습니다! 먼저 프레임 워크를 업데이트하십시오!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => '온라인 상담원 : %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => '에스컬레이트 된 티켓이 더 많습니다!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '환경 설정에서 시간대를 선택하고 저장버튼을 클릭하여 확인하십시오.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => '온라인 고객 : %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '시스템 유지 보수가 활성화 되었습니다!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '시스템 유지 보수 기간은 %s에서 시작되며 %s에서 중단 될 것으로 예상됩니다.',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRS 데몬이 실행되고 있지 않습니다.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            '부재 중 기능을 사용하도록 설정 했습니까? 사용하지 않도록 설정 하시겠습니까?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '배포된 %s 설정(들)이 잘못되었습니다. 잘못된 설정을 보려면 여기를 클릭하십시오.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '배포 취소 설정이 있습니다. 배포하시겠습니까?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '구성이 업데이트 되고 있습니다. 기다려주십시오...',
        'There is an error updating the system configuration!' => '시스템 구성을 업데이트 하는 중 오류가 발생했습니다!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '수퍼 유저 계정을 사용하여 %s 작업을하지 마십시오! 새 에이전트를 만들고 대신이 계정으로 작업하십시오.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '필수 알림을 위한 전송 방법을 하나 이상 선택했는지 확인하십시오.',
        'Preferences updated successfully!' => '환경 설정이 성공적으로 업데이트 되었습니다!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(과정에서)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => '시작일 이후의 종료일을 지정 하십시오.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => '현재 비밀번호',
        'New password' => '새로운 비밀번호',
        'Verify password' => '비밀번호 확인',
        'The current password is not correct. Please try again!' => '현재 암호가 올바르지 않습니다. 다시 시도하십시오!',
        'Please supply your new password!' => '새 암호를 입력하십시오!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            '암호를 업데이트 할 수 없으므로 새 암호가 일치하지 않습니다. 다시 시도하십시오!',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '이 암호는 현재 시스템 구성에 의해 금지됩니다. 추가 질문이 있으면 관리자에게 문의하십시오.',
        'Can\'t update password, it must be at least %s characters long!' =>
            '암호를 업데이트 할 수 없습니다. 길이는 %s 이상이어야합니다!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '암호를 업데이트 할 수 없으며 최소 2 자의 대문자와 2 자 이상의 대문자를 포함해야합니다!',
        'Can\'t update password, it must contain at least 1 digit!' => '암호를 업데이트 할 수 없으며, 적어도 1자리 이상 포함해야합니다!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '비밀번호를 업데이트 할 수 없으며 문자 2 자 이상을 포함해야합니다!',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '시간대가 성공적으로 업데이트 되었습니다.',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => '무효의',
        'valid' => '유효한',
        'No (not supported)' => '아니요(지원되지 않음)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '과거 완료 또는 현재 + 향후 완료 상대시간 값이 없습니다.',
        'The selected time period is larger than the allowed time period.' =>
            '선택한 기간이 허용된 기간보다 깁니다.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'X축에서 현재 선택된 시간 눈금 값에 사용할 수있는 시간 눈금 값이 없습니다.',
        'The selected date is not valid.' => '선택한 날짜가 유효하지 않습니다.',
        'The selected end time is before the start time.' => '선택한 종료 시간은 시작시간 전입니다.',
        'There is something wrong with your time selection.' => '시간 선택에 문제가 있습니다.',
        'Please select only one element or allow modification at stat generation time.' =>
            '통계 생성 시간에 하나의 요소만 선택하거나 수정을 허용하십시오.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '이 필드의 값을 하나 이상 선택하거나 통계 생성 시간에 수정을 허용하십시오.',
        'Please select one element for the X-axis.' => 'X 축에 대해 하나의 요소를 선택하십시오.',
        'You can only use one time element for the Y axis.' => 'Y 축에는 하나의 시간 요소 만 사용할 수 있습니다.',
        'You can only use one or two elements for the Y axis.' => 'Y 축에는 하나 또는 두 개의 요소 만 사용할 수 있습니다.',
        'Please select at least one value of this field.' => '이 입력란의 값을 하나 이상 선택하십시오.',
        'Please provide a value or allow modification at stat generation time.' =>
            '통계 생성 시간에 값을 제공하거나 수정을 허용하십시오.',
        'Please select a time scale.' => '시간 척도를 선택하십시오.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '보고 시간 간격이 너무 작으면 더 큰 시간 척도를 사용하십시오.',
        'second(s)' => '초(s)',
        'quarter(s)' => '쿼터(s)',
        'half-year(s)' => '반년(들)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '다음 단어는 티켓 제한에 사용할 수 없으므로 제거하십시오. %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '이 설정 편집 및 잠금 해제를 취소하십시오.',
        'Reset this setting to its default value.' => '이 설정을 기본값으로 다시 설정하십시오.',
        'Unable to load %s!' => '%s를 로드 할 수 없습니다!',
        'Content' => '만족',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => '잠금 해제하여 다시 대기열로 보냅니다.',
        'Lock it to work on it' => '잠금 기능',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => '언 워치',
        'Remove from list of watched tickets' => '감상한 티켓 목록에서 제거',
        'Watch' => '살피다',
        'Add to list of watched tickets' => '시청 티켓 목록에 추가',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => '주문',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => '티켓 정보',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => '잠긴 티켓 신규',
        'Locked Tickets Reminder Reached' => '잠긴 티켓 알리미에 도달 했습니다.',
        'Locked Tickets Total' => '잠긴 티켓 합계',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => '책임 티켓',
        'Responsible Tickets Reminder Reached' => '책임감 있는 티켓 알림 도달',
        'Responsible Tickets Total' => '책임 티켓 총계',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => '새로운 티켓을 보았습니다.',
        'Watched Tickets Reminder Reached' => '감상한 티켓 알리미에 도달함',
        'Watched Tickets Total' => '총 시청 티켓',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => '티켓 동적 필드',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'ACL 구성 파일을 읽을 수 없습니다. 파일이 유효한지 확인하십시오.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '현재 예약된 시스템 유지보수로 인해 로그인 할 수 없습니다.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '동시 상담원 수를 초과했습니다. sales@otrs.com으로 문의하십시오.',
        'Please note that the session limit is almost reached.' => '세션 한도에 거의 도달했음을 유의하십시오.',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '로그인이 거부되었습니다! 최대 동시 상담원 수를 초과했습니다! 즉시 sales@otrs.com에 문의하십시오! ',
        'Session limit reached! Please try again later.' => '세션 한도에 도달했습니다. 나중에 다시 시도 해주십시오.',
        'Session per user limit reached!' => '사용자 당 세션 한도에 도달했습니다.',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => '세션이 잘못되었습니다. 다시 로그인하십시오.',
        'Session has timed out. Please log in again.' => '세션 시간이 초과되었습니다. 다시 로그인하십시오.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'PGP 서명 만',
        'PGP encrypt only' => 'PGP 만 암호화 함',
        'SMIME sign only' => 'SMIME 서명 만',
        'SMIME encrypt only' => 'SMIME 암호화 만',
        'PGP and SMIME not enabled.' => 'PGP 및 SMIME이 활성화되지 않았습니다.',
        'Skip notification delivery' => '알림 전달 건너 뛰기',
        'Send unsigned notification' => '서명되지 않은 알림 보내기',
        'Send unencrypted notification' => '암호화되지 않은 알림을 보냅니다.',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '구성 옵션 참조',
        'This setting can not be changed.' => '이 설정은 변경할 수 없습니다.',
        'This setting is not active by default.' => '이 설정은 기본적으로 활성화되어 있지 않습니다.',
        'This setting can not be deactivated.' => '이 설정은 비활성화 할 수 없습니다.',
        'This setting is not visible.' => '이 설정은 표시되지 않습니다.',
        'This setting can be overridden in the user preferences.' => '이 설정은 사용자 기본 설정에서 무시할 수 있습니다.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '이 설정은 사용자 기본 설정에서 무시될 수 있지만 기본적으로 활성화되지는 않습니다.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '고객 사용자 "%s"이 이미 있습니다.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '이 이메일 주소는 이미 다른 고객 사용자를 위해 사용 중입니다.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => '전/후',
        'between' => '사이에',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '예 : 텍스트 또는 문자 *',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '이 입력란을 무시하십시오.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => '이 필드는 필수이거나',
        'The field content is too long!' => '입력란 내용이 너무 깁니다.',
        'Maximum size is %s characters.' => '최대 크기는%s자입니다.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '알림 구성 파일을 읽을 수 없습니다. 파일이 유효한지 확인하십시오.',
        'Imported notification has body text with more than 4000 characters.' =>
            '가져온 알림에는 4000자 이상의 본문 텍스트가 있습니다.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '설치되지 않았다.',
        'installed' => '설치된',
        'Unable to parse repository index document.' => '저장소 색인 문서를 구문 분석 할 수 없습니다.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '이 저장소에 있는 프레임 워크 버전의 패키지가 없으며 다른 프레임 워크 버전의 패키지만 포함합니다.',
        'File is not installed!' => '파일이 설치되지 않았습니다!',
        'File is different!' => '파일이 다릅니다!',
        'Can\'t read file!' => '파일을 읽을 수 없습니다!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '1이 패키지를 계속 설치하면 다음과 같은 문제가 발생할 수 있습니다. 123 보안 문제 34 안정성 문제 45 성능 문제 566이 패키지로 작업하여 발생하는 문제는 OTRS 서비스 계약의 적용을받지 않습니다.',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '"%s"프로세스와 모든 데이터가 성공적으로 가져 왔습니다.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => '비활성',
        'FadeAway' => '사라지다',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => '등록 서버에 접속할 수 없습니다. 나중에 다시 시도 해주십시오.',
        'No content received from registration server. Please try again later.' =>
            '등록 서버에서 받은 내용이 없습니다. 나중에 다시 시도 해주십시오.',
        'Can\'t get Token from sever' => '토큰을 서버에서 가져올 수 없습니다.',
        'Username and password do not match. Please try again.' => '사용자 이름과 암호가 일치하지 않습니다. 다시 시도하십시오.',
        'Problems processing server result. Please try again later.' => '서버 결과 처리 문제. 나중에 다시 시도 해주십시오.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => '합집합',
        'week' => '주',
        'quarter' => '쿼터',
        'half-year' => '반년',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '상태 유형',
        'Created Priority' => '생성된 우선 순위',
        'Created State' => '생성된 주',
        'Create Time' => '시간 생성',
        'Pending until time' => '시간까지 보류 중입니다.',
        'Close Time' => '종료 시간',
        'Escalation' => '단계적 확대',
        'Escalation - First Response Time' => '에스컬레이션 - 첫 번째 응답 시간',
        'Escalation - Update Time' => '에스컬레이션 - 업데이트 시간',
        'Escalation - Solution Time' => '에스컬레이션 - 솔루션 시간',
        'Agent/Owner' => '담당상담원',
        'Created by Agent/Owner' => '담당상담원이 만듬',
        'Assigned to Customer User Login' => '고객 사용자 로그인에 할당 됨',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => '에 의한 평가',
        'Ticket/Article Accounted Time' => '티켓 / 물품 소요 시간',
        'Ticket Create Time' => '티켓 생성 시간',
        'Ticket Close Time' => '티켓 종료 시간',
        'Accounted time by Agent' => '요원에 의해 정해진 시간',
        'Total Time' => '총 시간',
        'Ticket Average' => '티켓 평균',
        'Ticket Min Time' => '티켓 최소 시간',
        'Ticket Max Time' => '티켓 최대 시간',
        'Number of Tickets' => '티켓 수',
        'Article Average' => '기사 평균',
        'Article Min Time' => '기사 최소 시간',
        'Article Max Time' => '기사 최대 시간',
        'Number of Articles' => '기사 수',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '제한 없는',
        'Attributes to be printed' => '인쇄할 속성',
        'Sort sequence' => '정렬 순서',
        'State Historic' => '주 역사',
        'State Type Historic' => '국가 유형 역사',
        'Historic Time Range' => '역사적인 시간 범위',
        'Number' => '번호',
        'Last Changed' => '마지막 변경됨',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '술루션 평균',
        'Solution Min Time' => '솔루션 최소 시간',
        'Solution Max Time' => '솔루션 최대 시간',
        'Solution Average (affected by escalation configuration)' => '솔루션 평균 (에스컬레이션 구성의 영향을 받음)',
        'Solution Min Time (affected by escalation configuration)' => '솔루션 최소 시간 (에스컬레이션 구성의 영향을 받음)',
        'Solution Max Time (affected by escalation configuration)' => '솔루션 최대 시간 (에스컬레이션 구성의 영향을 받음)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '솔루션 근무 시간 평균 (에스컬레이션 구성의 영향을 받음)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '솔루션 최소 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '솔루션 최대 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Average (affected by escalation configuration)' =>
            '첫 번째 응답 평균 (에스컬레이션 구성의 영향을 받음)',
        'First Response Min Time (affected by escalation configuration)' =>
            '첫 번째 응답 최소 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Max Time (affected by escalation configuration)' =>
            '첫 번째 응답 최대 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '첫 번째 응답 근무 시간 평균 (에스컬레이션 구성의 영향을 받음)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '첫 번째 응답 최소 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '첫 번째 응답 최대 작업 시간 (에스컬레이션 구성의 영향을 받음)',
        'Number of Tickets (affected by escalation configuration)' => '티켓 수 (에스컬레이션 구성의 영향을 받음)',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => '일',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '오래된 테이블',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '오래된 테이블이 데이터베이스에서 발견되었습니다. 비어있는 경우 제거할 수 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => '표 존재',
        'Internal Error: Could not open file.' => '내부 오류 : 파일을 열 수 없습니다.',
        'Table Check' => '표 확인',
        'Internal Error: Could not read file.' => '내부 오류 : 파일을 읽을 수 없습니다.',
        'Tables found which are not present in the database.' => '발견된 테이블은 데이터베이스에 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => '데이터베이스 크기',
        'Could not determine database size.' => '데이터베이스 크기를 결정할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '데이터베이스 버전',
        'Could not determine database version.' => '데이터베이스 버전을 확인할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '클라이언트 연결 문자 세트',
        'Setting character_set_client needs to be utf8.' => 'character_set_client 설정은 utf8이어야합니다.',
        'Server Database Charset' => '서버 데이터베이스 문자 세트',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '설정 character_set_database는 \'utf8\'이어야합니다.',
        'Table Charset' => '표 문자 집합',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '\'utf8\'이없는 테이블이 charset으로 발견되었습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB 로그 파일 사이즈',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'innodb_log_file_size 설정은 256MB 이상이어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '잘못된 기본값',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '잘못된 기본값이있는 테이블을 찾았습니다. 자동으로 수정하려면 다음을 실행하십시오. bin / otrs.Console.pl Maint :: Database :: Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '최대 쿼리 크기',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '\'max_allowed_packet\'설정은 64MB보다 커야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '쿼리 캐시 크기',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '\'query_cache_size\'설정을 사용해야합니다 (10MB 이상 512MB 이하).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '기본 저장소 엔진',
        'Table Storage Engine' => '테이블 스토리지 엔진',
        'Tables with a different storage engine than the default engine were found.' =>
            '기본 엔진과 다른 저장소 엔진이 있는 테이블이 발견 되었습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x 이상이 필요합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG 설정',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG는 al32utf8 (예 : GERMAN_GERMANY.AL32UTF8)로 설정해야합니다.',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT 설정',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT는 \'YYYY-MM-DD HH24 : MI : SS\'로 설정해야합니다.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'NLS_DATE_FORMAT SQL 확인 설정',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '기본 키 시퀀스 및 트리거',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '잘못된 이름을 가진 다음 시퀀스 및 / 또는 트리거가 발견되었습니다. 수동으로 이름을 변경하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'client_encoding 설정은 UNICODE 또는 UTF8이어야합니다.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'server_encoding 설정은 UNICODE 또는 UTF8이어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '날짜 형식',
        'Setting DateStyle needs to be ISO.' => 'DateStyle 설정은 ISO 여야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '기본 키 시퀀스',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '가능한 잘못된 이름을 가진 다음 시퀀스가 발견되었습니다. 수동으로 이름을 변경하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'PostgreSQL 9.2 이상이 필요합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS 디스크 파티션',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '디스크 사용량',
        'The partition where OTRS is located is almost full.' => 'OTRS가 위치한 파티션이 거의 찼습니다.',
        'The partition where OTRS is located has no disk space problems.' =>
            'OTRS가 위치한 파티션에는 디스크 공간 문제가 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '디스크 파티션 사용법',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '분포',
        'Could not determine distribution.' => '배포를 결정할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '커널 버전',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '시스템로드',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '시스템로드는 시스템에있는 CPU의 최대 수 (예 : 8 개의 CPU가있는 시스템에서 8 이하의로드가 좋음) 여야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '펄 모듈',
        'Not all required Perl modules are correctly installed.' => '필요한 Perl 모듈이 모두 올바르게 설치되지는 않았습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '무료 스왑 공간 (%)',
        'No swap enabled.' => '스왑을 사용할 수 없습니다.',
        'Used Swap Space (MB)' => '사용 된 스왑 공간 (MB)',
        'There should be more than 60% free swap space.' => '스왑 공간이 60 % 이상 있어야합니다.',
        'There should be no more than 200 MB swap space used.' => '사용 된 스왑 공간은 200MB 이상이어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => '기사 검색 색인 상태',
        'Indexed Articles' => '색인 생성된 기사',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '커뮤니케이션 채널 당 기사',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '수신 통신',
        'Outgoing communications' => '나가는 통신',
        'Failed communications' => '실패한 통신',
        'Average processing time of communications (s)' => '통신 평균 처리 시간(s)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '통신 로그 계정 상태 (지난 24시간)',
        'No connections found.' => '연결이 없습니다.',
        'ok' => '승인',
        'permanent connection errors' => '영구 연결 오류',
        'intermittent connection errors' => '간헐적인 연결 오류',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => '구성 설정',
        'Could not determine value.' => '가치를 결정할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => '데몬',
        'Daemon is running.' => '데몬이 실행 중입니다.',
        'Daemon is not running.' => '데몬이 실행되고 있지 않습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '데이터베이스 레코드',
        'Tickets' => '티켓',
        'Ticket History Entries' => '티켓 기록 항목',
        'Articles' => '게시물',
        'Attachments (DB, Without HTML)' => '첨부 파일 (DB, HTML 제외)',
        'Customers With At Least One Ticket' => '최소 하나의 티켓을 소지한 고객',
        'Dynamic Field Values' => '동적 필드 값',
        'Invalid Dynamic Fields' => '잘못된 동적 필드',
        'Invalid Dynamic Field Values' => '잘못된 동적 필드 값',
        'GenericInterface Webservices' => 'GenericInterface 웹 서비스',
        'Process Tickets' => '티켓 처리',
        'Months Between First And Last Ticket' => '첫 번째 티켓과 마지막 티켓 간의 개월',
        'Tickets Per Month (avg)' => '월간 티켓 (평균)',
        'Open Tickets' => '진행중 티켓',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '기본 SOAP 사용자 이름 및 암호',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '보안 위험 : SOAP :: User 및 SOAP :: Password의 기본 설정을 사용합니다. 변경하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '기본 관리자 비밀번호',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '보안 위험 : 에이전트 계정 root @ localhost에는 여전히 기본 암호가 있습니다. 계정을 변경하거나 계정을 무효화하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '이메일 전송 대기열',
        'Emails queued for sending' => '전송 대기중인 이메일',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (도메인 이름)',
        'Please configure your FQDN setting.' => 'FQDN 설정을 구성하십시오.',
        'Domain Name' => '도메인 이름',
        'Your FQDN setting is invalid.' => 'FQDN 설정이 잘못되었습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '파일 시스템 쓰기 가능',
        'The file system on your OTRS partition is not writable.' => 'OTRS 파티션의 파일 시스템에 쓸 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '레거시 구성 백업',
        'No legacy configuration backup files found.' => '레거시 구성 백업 파일이 없습니다.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '패키지 설치 상태',
        'Some packages have locally modified files.' => '일부 패키지에는 로컬로 수정된 파일이 있습니다.',
        'Some packages are not correctly installed.' => '일부 패키지가 올바르게 설치되지 않았습니다.',
        'Package Verification Status' => '패키지 확인 상태',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '일부 패키지는 OTRS 그룹에 의해 검증되지 않습니다! 이 패키지를 사용하지 않는 것이 좋습니다.',
        'Package Framework Version Status' => '패키지 프레임 워크 버전 상태',
        'Some packages are not allowed for the current framework version.' =>
            '일부 패키지는 현재 프레임 워크 버전에 허용되지 않습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => '패키지 목록',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '세션 구성 설정',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '스풀된 전자 메일',
        'There are emails in var/spool that OTRS could not process.' => 'OTRS가 처리 할 수없는 var / spool에 이메일이 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '시스템 ID 설정이 잘못되었습니다. 숫자 만 포함해야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '기본 티켓 유형',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '구성된 기본 티켓 유형이 잘못되었거나 누락되었습니다. Ticket :: Type :: Default 설정을 변경하고 유효한 티켓 유형을 선택하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '티켓 색인 모듈',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '60,000 개 이상의 티켓이 있으며 StaticDB 백엔드를 사용해야합니다. 자세한 내용은 관리자 설명서 (성능 튜닝)를 참조하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '잠긴 티켓이 있는 사용자가 잘못되었습니다.',
        'There are invalid users with locked tickets.' => '잠긴 티켓이 있는 유효하지 않은 사용자가 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '시스템에 8,000개 이상의 티켓이 없어야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '티켓 검색 Index Module',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '색인 생성 프로세스는 필터를 실행하거나 정지 단어 목록을 적용하지 않고 기사 검색 색인에 원본 기사 텍스트의 저장을 강제합니다. 이렇게하면 검색 색인의 크기가 커지고 전체 텍스트 검색 속도가 느려질 수 있습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'ticket_lock_index 테이블의 고아 레코드',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '표 ticket_lock_index에는 분리 된 레코드가 있습니다. bin / otrs.Console.pl "Maint :: Ticket :: QueueIndexCleanup"을 실행하여 StaticDB 색인을 정리하십시오.',
        'Orphaned Records In ticket_index Table' => 'ticket_index 테이블의 고아 레코드',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '표 ticket_index에는 분리 된 레코드가 있습니다. bin / otrs.Console.pl "Maint :: Ticket :: QueueIndexCleanup"을 실행하여 StaticDB 색인을 정리하십시오.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '시간 설정',
        'Server time zone' => '서버 시간대',
        'OTRS time zone' => 'OTRS 시간대',
        'OTRS time zone is not set.' => 'OTRS 시간대가 설정되지 않았습니다.',
        'User default time zone' => '사용자 기본 시간대',
        'User default time zone is not set.' => '사용자 기본 시간대가 설정되지 않았습니다.',
        'Calendar time zone is not set.' => '달력 표준 시간대가 설정되지 않았습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - 에이전트 스킨 사용',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - 에이전트 테마 사용법',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - 특수 통계',
        'Agents using custom main menu ordering' => '사용자 정의 주 메뉴 순서를 사용하는 에이전트',
        'Agents using favourites for the admin overview' => '관리자 개요에 즐겨찾기를 사용하는 에이전트',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => '웹 서버',
        'Loaded Apache Modules' => '로드 된 Apache 모듈',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM 모델',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS는 \'prefork\'MPM 모델로 아파치를 실행해야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'CGI 가속기 사용법',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '성능을 높이려면 FastCGI 또는 mod_perl을 사용해야합니다.',
        'mod_deflate Usage' => 'mod_deflate 사용법',
        'Please install mod_deflate to improve GUI speed.' => 'GUI 속도를 높이려면 mod_deflate를 설치하십시오.',
        'mod_filter Usage' => 'mod_filter 사용법',
        'Please install mod_filter if mod_deflate is used.' => 'mod_deflate가 사용되는 경우 mod_filter를 설치하십시오.',
        'mod_headers Usage' => 'mod_headers 사용법',
        'Please install mod_headers to improve GUI speed.' => 'GUI 속도를 높이려면 mod_headers를 설치하십시오.',
        'Apache::Reload Usage' => 'Apache :: Reload 사용법',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache :: Reload 또는 Apache2 :: Reload를 PerlModule 및 PerlInitHandler로 사용하여 모듈 설치 및 업그레이드시 웹 서버가 다시 시작되지 않도록해야합니다.',
        'Apache2::DBI Usage' => 'Apache2 :: DBI 사용법',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '사전 설정된 데이터베이스 연결을 사용하여 더 나은 성능을 얻으려면 Apache2 :: DBI를 사용해야합니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '환경 변수',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '지원 데이터 수집',
        'Support data could not be collected from the web server.' => '지원 데이터를 웹 서버에서 수집할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '웹 서버 버전',
        'Could not determine webserver version.' => '웹 서버 버전을 확인할 수 없습니다.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '동시 사용자 세부 정보',
        'Concurrent Users' => '동시 사용자',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '승인',
        'Problem' => '문제',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '%s 설정이 없습니다!',
        'Setting %s is not locked to this user!' => '설정 %s이 이 사용자에게 잠겨 있지 않습니다.',
        'Setting value is not valid!' => '설정 값이 유효하지 않습니다!',
        'Could not add modified setting!' => '수정된 설정을 추가할 수 없습니다!',
        'Could not update modified setting!' => '수정된 설정을 업데이트 할 수 없습니다!',
        'Setting could not be unlocked!' => '설정을 잠금 해제 할 수 없습니다!',
        'Missing key %s!' => '누락 된 키 %s!',
        'Invalid setting: %s' => '잘못된 설정 : %s',
        'Could not combine settings values into a perl hash.' => '설정 값을 perl 해시에 결합 할 수 없습니다.',
        'Can not lock the deployment for UserID \'%s\'!' => 'UserID \'%s\'에 대한 배포를 잠글 수 없습니다!',
        'All Settings' => '모든 설정',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => '부족',
        'Value is not correct! Please, consider updating this field.' => '값이 올바르지 않습니다! 이 필드를 업데이트 하십시오.',
        'Value doesn\'t satisfy regex (%s).' => '값이 정규식 (%s)을 만족하지 않습니다.',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '사용',
        'Disabled' => '불구가 된',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => '시스템이 OTRSTimeZone에서 사용자 날짜를 계산할 수 없습니다!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            '시스템은 OTRSTimeZone에서 사용자 DateTime을 계산할 수 없었습니다!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '값이 올바르지 않습니다! 이 모듈을 업데이트 하십시오.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '값이 올바르지 않습니다! 이 설정을 업데이트 하십시오.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '잠금 해제 시간 재설정.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            '로그인 실패! 사용자 이름 또는 암호가 잘못 입력되었습니다.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '인증에 성공했지만 데이터베이스에 사용자 데이터 레코드가 없습니다. 관리자에게 문의하십시오.',
        'Can`t remove SessionID.' => 'SessionID를 제거 할 수 없습니다.',
        'Logout successful.' => '로그아웃에 성공했습니다.',
        'Feature not active!' => '기능이 활성화되지 않았습니다!',
        'Sent password reset instructions. Please check your email.' => '보낸 암호 재설정 지침. 이메일을 확인하십시오.',
        'Invalid Token!' => '잘못된 토큰!',
        'Sent new password to %s. Please check your email.' => '새 암호를 %s로 보냈습니다. 이메일을 확인하십시오.',
        'Error: invalid session.' => '오류 : 세션이 잘못되었습니다.',
        'No Permission to use this frontend module!' => '이 프론트 엔드 모듈을 사용할 권한이 없습니다!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '인증은 성공했지만 고객 레코드는 고객 백엔드에서 발견되지 않습니다. 관리자에게 문의하십시오.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '비밀번호를 재설정하지 못했습니다. 관리자에게 문의하십시오.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '이 전자 메일 주소는 이미 있습니다. 로그인하거나 비밀번호를 재설정하십시오.',
        'This email address is not allowed to register. Please contact support staff.' =>
            '이 이메일 주소는 등록 할 수 없습니다. 지원 담당자에게 문의하십시오.',
        'Added via Customer Panel (%s)' => '고객 패널을 통해 추가 (%s)',
        'Customer user can\'t be added!' => '고객 사용자를 추가 할 수 없습니다!',
        'Can\'t send account info!' => '계정 정보를 보낼 수 없습니다!',
        'New account created. Sent login information to %s. Please check your email.' =>
            '새 계정이 생성되었습니다. 로그인 정보를 %s로 보냈습니다. 이메일을 확인하십시오.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Action "%s"을 찾을 수 없습니다!',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => '유효하지 않은 일시적',
        'Group for default access.' => '기본 액세스 그룹.',
        'Group of all administrators.' => '모든 관리자 그룹.',
        'Group for statistics access.' => '통계 액세스 그룹.',
        'new' => '새로운',
        'All new state types (default: viewable).' => '모든 새 상태 유형 (기본값 : 표시 가능).',
        'open' => '열다',
        'All open state types (default: viewable).' => '모든 열린 상태 유형 (기본값 : 표시 가능).',
        'closed' => '닫은',
        'All closed state types (default: not viewable).' => '모든 닫힌 상태 유형 (기본값 : 볼 수 없음).',
        'pending reminder' => '대기중인 알림',
        'All \'pending reminder\' state types (default: viewable).' => '\'보류중인 모든 알림\'상태 유형 (기본값 : 표시 가능).',
        'pending auto' => '보류중인 자동',
        'All \'pending auto *\' state types (default: viewable).' => '\'보류 중 자동 *\'상태 유형 (기본값 : 표시 가능).',
        'removed' => '제거된',
        'All \'removed\' state types (default: not viewable).' => '\'제거 된\'모든 상태 유형 (기본값 : 볼 수 없음).',
        'merged' => '합병된',
        'State type for merged tickets (default: not viewable).' => '병합 된 티켓의 상태 유형 (기본값 : 볼 수 없음).',
        'New ticket created by customer.' => '고객이 만든 새 티켓입니다.',
        'closed successful' => '폐쇄 성공',
        'Ticket is closed successful.' => '티켓이 성공적으로 닫힙니다.',
        'closed unsuccessful' => '닫힌 실패',
        'Ticket is closed unsuccessful.' => '티켓이 성공적으로 닫히지 않았습니다.',
        'Open tickets.' => '진행중 티켓',
        'Customer removed ticket.' => '고객이 티켓을 내렸습니다.',
        'Ticket is pending for agent reminder.' => '에이전트 알림을 위해 티켓이 보류 중입니다.',
        'pending auto close+' => '보류 중 자동 닫기 +',
        'Ticket is pending for automatic close.' => '자동 종료를 위해 티켓 보류 중입니다.',
        'pending auto close-' => '보류 중인 자동 닫기 - ',
        'State for merged tickets.' => '병합된 티켓의 상태.',
        'system standard salutation (en)' => '시스템 표준 인사말 (en)',
        'Standard Salutation.' => '표준 인사말.',
        'system standard signature (en)' => '시스템 표준 서명 (en)',
        'Standard Signature.' => '표준 서명.',
        'Standard Address.' => '표준 주소.',
        'possible' => '가능한',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '닫힌 티켓에 대한 후속 조치가 가능합니다. 티켓이 재개됩니다.',
        'reject' => '받지 않다',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '닫힌 티켓에 대한 후속 조치는 불가능합니다. 새로운 티켓이 생성되지 않습니다.',
        'new ticket' => '새로운 티켓',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '닫힌 티켓에 대한 후속 조치는 불가능합니다. 새로운 티켓이 생성됩니다.',
        'Postmaster queue.' => '포스트 마스터 대기열.',
        'All default incoming tickets.' => '모든 기본 수신 티켓.',
        'All junk tickets.' => '모든 정크 티켓.',
        'All misc tickets.' => '모든 기타 티켓.',
        'auto reply' => '자동 회신',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '새 티켓이 생성된 후 발송될 자동응답 입니다.',
        'auto reject' => '자동 거부',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '후속 조치가 거부 된 후 발송 될 자동 거부 (대기열 후속 옵션이 "거부"인 경우)',
        'auto follow up' => '자동 후속 조치',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '티켓에 대한 후속 조치를받은 후 발송되는 자동 확인 (대기열 후속 옵션이 "가능"인 경우)',
        'auto reply/new ticket' => '자동 회신 / 새 티켓',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '후속 조치가 거부되고 새 티켓이 생성 된 후 발송 될 자동 응답 (대기열 후속 옵션이 "새 티켓"인 경우)',
        'auto remove' => '자동 제거',
        'Auto remove will be sent out after a customer removed the request.' =>
            '고객이 요청을 삭제하면 자동 제거가 발송됩니다.',
        'default reply (after new ticket has been created)' => '기본 답장 (새 티켓을 만든 후)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '가본 거부 (후속 조치 후 닫힌 티켓 거부)',
        'default follow-up (after a ticket follow-up has been added)' => '기본 후속 조치 (티켓 후속 조치가 추가된 후)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '기본 거부 / 새 티켓 생성 (새 티켓 작성으로 마감된 후속 조치)',
        'Unclassified' => '분류되지 않은',
        '1 very low' => '1 매우 낮음',
        '2 low' => '2 낮음',
        '3 normal' => '3 정상',
        '4 high' => '4 높음',
        '5 very high' => '5 매우 높음',
        'unlock' => '잠금해제',
        'lock' => '잠금',
        'tmp_lock' => 'tmp_lock',
        'agent' => '에이전트',
        'system' => '시스템',
        'customer' => '고객',
        'Ticket create notification' => '티켓 생성 알림',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '"내 대기열"또는 "내 서비스"중 하나에 새 티켓이 생성 될 때마다 알림을 받게됩니다.',
        'Ticket follow-up notification (unlocked)' => '티켓 후속 알림 (잠금 해제)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '고객이 "내 대기열"또는 "내 서비스"에있는 잠겨 있지 않은 티켓을 후속 전송하는 경우 알림을 받게됩니다.',
        'Ticket follow-up notification (locked)' => '티켓 후속 알림(잠김)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '고객이 티켓 소유자 또는 책임자인 잠긴 티켓에 대한 후속 조치를 보내는 경우 알림을 받게 됩니다.',
        'Ticket lock timeout notification' => '티켓 잠금 제한 시간 알림',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '소유한 티켓이 자동으로 잠금 해제되면 곧 알림이 전송됩니다.',
        'Ticket owner update notification' => '티켓 소유자 업데이트 알림',
        'Ticket responsible update notification' => '티켓 책임 업데이트 알림',
        'Ticket new note notification' => '티켓 새로운 노트 통지',
        'Ticket queue update notification' => '티켓 대기열 업데이트 알림',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '티켓이 "내 대기열"중 하나로 이동되면 알림을 받게됩니다.',
        'Ticket pending reminder notification (locked)' => '티켓 보류 알림(잠김)',
        'Ticket pending reminder notification (unlocked)' => '티켓 보류 알림 알림 (잠금 해제됨)',
        'Ticket escalation notification' => '티켓 에스컬레이션 알림',
        'Ticket escalation warning notification' => '티켓 에스컬레이션 경고 알림',
        'Ticket service update notification' => '티켓 서비스 업데이트 알림',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '티켓 서비스가 "내 서비스"중 하나로 변경되면 알림을 받게됩니다.',
        'Appointment reminder notification' => '약속 알림',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            '약속 중 하나에 대해 미리 알림 시간에 도달할 때마다 알림을 받게 됩니다.',
        'Ticket email delivery failure notification' => '티켓 전자 메일 배달 실패 알림',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'AJAX 통신 중 오류가 발생했습니다. 상태 : %s, 오류 : %s',
        'This window must be called from compose window.' => '이 창은 작성 창에서 호출해야합니다.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => '모두 추가',
        'An item with this name is already present.' => '이 이름을 가진 항목이 이미 있습니다.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '이 항목에는 여전히 하위 항목이 있습니다. 하위 항목을 포함하여 이 항목을 제거 하시겠습니까?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => '더',
        'Less' => '적게',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Ctrl + C (Cmd + C)를 눌러 클립 보드에 복사하십시오.',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '이 첨부 파일 삭제',
        'Deleting attachment...' => '첨부 파일을 삭제하는 중...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '첨부 파일을 삭제하는 중 오류가 발생했습니다. 자세한 내용은 로그를 확인하십시오.',
        'Attachment was deleted successfully.' => '첨부 파일을 삭제했습니다.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '이 동적 필드를 정말로 삭제 하시겠습니까? 관련된 모든 데이터가 손실됩니다!',
        'Delete field' => '입력란 삭제',
        'Deleting the field and its data. This may take a while...' => '필드 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => '선택 항목 삭제',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => '이 이벤트 트리거 삭제',
        'Duplicate event.' => '중복 이벤트.',
        'This event is already attached to the job, Please use a different one.' =>
            '이 이벤트는 이미 작업에 첨부되어 있습니다. 다른 이벤트를 사용하십시오.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => '통신 중에 오류가 발생했습니다.',
        'Request Details' => '요청 세부 정보',
        'Request Details for Communication ID' => '통신 ID 요청 세부 정보',
        'Show or hide the content.' => '내용을 표시하거나 숨깁니다.',
        'Clear debug log' => '디버그 로그 지우기',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '오류 처리 모듈 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => '이 호출자 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '죄송합니다. 기존 상태만 제거 할 수 없습니다.',
        'Sorry, the only existing field can\'t be removed.' => '죄송합니다. 기존 필드만 제거 할 수 없습니다.',
        'Delete conditions' => '조건 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '키 %s에 대한 매핑',
        'Mapping for Key' => '키 매핑',
        'Delete this Key Mapping' => '이 키 매핑 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => '이 작업 삭제',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => '웹 서비스 복제',
        'Delete operation' => '작업 삭제',
        'Delete invoker' => '호출자 삭제',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '경고 : SysConfig에서 적절한 변경을 수행하기 전에 \'admin\'그룹의 이름을 변경하면 관리 패널에서 잠길 것입니다! 이 경우 SQL 문에 따라 admin으로 다시 그룹 이름을 변경하십시오.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '이 메일 계정 삭제',
        'Deleting the mail account and its data. This may take a while...' =>
            '메일 계정 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => '이 알림 언어를 정말로 삭제 하시겠습니까?',
        'Do you really want to delete this notification?' => '이 알림을 정말로 삭제 하시겠습니까?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '패키지 업그레이드 프로세스가 실행 중입니다. 여기를 클릭하면 업그레이드 진행 상태에 대한 상태 정보를 볼 수 있습니다.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '패키지 업그레이드가 최근 완료 되었습니다. 결과를 보려면 여기를 클릭하십시오.',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '모든 패키지 업데이트',
        'Dismiss' => '버리다',
        'Update All Packages' => '모든 패키지 업데이트',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '현재 불가능',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '진행중인 패키지 업그레이드로 인해 현재 이 기능을 사용할 수 없습니다.',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            'OTRS 데몬이 실행 중이 아니기 때문에이 옵션은 현재 비활성화되어 있습니다.',
        'Are you sure you want to update all installed packages?' => '설치된 패키지를 모두 업데이트 하시겠습니까?',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '이 PostMasterFilter 삭제',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '전자 메일 관리자 필터 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => '캔버스에서 엔티티 제거',
        'No TransitionActions assigned.' => '과도 행동이 할당되지 않았습니다.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '대화 상자가 아직 할당되지 않았습니다. 왼쪽의 목록에서 활동 대화 상자를 선택하고 여기로 드래그 하십시오.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '이 활동은 시작 활동이기 때문에 삭제할 수 없습니다.',
        'Remove the Transition from this Process' => '이 프로세스에서 전환 제거',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '이 버튼이나 링크를 사용하자마자 이 화면을 떠나고 현재 상태가 자동으로 저장됩니다. 계속 하시겠습니까?',
        'Delete Entity' => '엔티티 삭제',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '이 활동은 이미 프로세스에서 사용됩니다. 두 번 추가 할 수 없습니다!',
        'Error during AJAX communication' => 'AJAX 통신 중 오류가 발생했습니다.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '연결되지 않은 전환이 이미 캔버스에 배치되었습니다. 다른 전환을 배치하기 전에 이 전환을 먼저 연결하십시오.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '이 전환은 이미 이 활동에 사용됩니다. 두 번 사용할 수 없습니다!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '이 전환 액션은 이미 이 경로에서 사용됩니다. 두 번 사용할 수 없습니다!',
        'Hide EntityIDs' => '엔티티 ID 숨기기',
        'Edit Field Details' => '필드 세부 정보 편집',
        'Customer interface does not support articles not visible for customers.' =>
            '고객 인터페이스는 고객이 볼 수없는 기사를 지원하지 않습니다.',
        'Sorry, the only existing parameter can\'t be removed.' => '죄송합니다. 기존 매개변수만 제거 할 수 없습니다.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '정말로 이 인증서를 삭제하시겠습니까?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => '업데이트 전송 중...',
        'Support Data information was successfully sent.' => '지원 데이터 정보가 성공적으로 전송되었습니다.',
        'Was not possible to send Support Data information.' => '지원 데이터 정보를 보낼 수 없었습니다.',
        'Update Result' => '업데이트 결과',
        'Generating...' => '생성 중...',
        'It was not possible to generate the Support Bundle.' => '지원 번들을 생성할 수 없었습니다.',
        'Generate Result' => '결과 생성',
        'Support Bundle' => '지원 번들',
        'The mail could not be sent' => '메일을 보낼 수 없습니다.',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '이 항목을 유효하지 않게 설정할 수는 없습니다. 영향을 받는 모든 구성 설정을 미리 변경해야 합니다.',
        'Cannot proceed' => '진행할 수 없습니다.',
        'Update manually' => '수동으로 업데이트',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '영향을받은 설정을 방금 만든 변경 사항을 반영하도록 자동으로 업데이트하거나 "수동으로 업데이트"를 눌러 직접 설정할 수 있습니다.',
        'Save and update automatically' => '자동 저장 및 업데이트',
        'Don\'t save, update manually' => '저장하지 않고 수동으로 업데이트 하십시오.',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '현재 보고 있는 항목은 아직 배포되지 않은 구성 설정의 일부이므로 현재 상태로 편집할 수 없습니다. 설정이 배포될 때까지 기다려주십시오. 다음에 해야할 일이 확실치 않으면 시스템 관리자에게 문의하십시오.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => '로딩 중...',
        'Search the System Configuration' => '시스템 구성 검색',
        'Please enter at least one search word to find anything.' => '검색할 단어를 하나 이상 입력하십시오.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '안타깝게도 다른 에이전트가 이미 배포 중이므로 현재 배포할 수 없습니다. 나중에 다시 시도 해주십시오.',
        'Deploy' => '배포',
        'The deployment is already running.' => '배포가 이미 실행 중입니다.',
        'Deployment successful. You\'re being redirected...' => '배포가 완료되었습니다. 리디렉션 중입니다...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '오류가 있었습니다. 자세한 정보는 편집 중인 모든 설정을 저장하고 로그를 확인하십시오.',
        'Reset option is required!' => '재설정 옵션이 필요합니다!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '이 배포를 복원하면 모든 설정이 배포 당시의 값으로 되돌아갑니다. 계속 하시겠습니까?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '값이 있는 키는 이름을 바꿀 수 없습니다. 대신 이 키/값 쌍을 제거하고 나중에 다시 추가하십시오.',
        'Unlock setting.' => '잠금 해제 설정.',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            '이 예약된 시스템 유지관리를 정말로 삭제 하시겠습니까?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '이 템플릿 삭제',
        'Deleting the template and its data. This may take a while...' =>
            '템플릿 및 해당 데이터 삭제. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => '도약',
        'Timeline Month' => '타임라인 달',
        'Timeline Week' => '타임라인 주',
        'Timeline Day' => '타임라인 일',
        'Previous' => '너무 이른',
        'Resources' => '자원',
        'Su' => '일요일',
        'Mo' => '월요일',
        'Tu' => '화요일',
        'We' => '수요일',
        'Th' => '목요일',
        'Fr' => '금요일',
        'Sa' => '토요일',
        'This is a repeating appointment' => '이것은 반복되는 약속입니다.',
        'Would you like to edit just this occurrence or all occurrences?' =>
            '이 발생 또는 모든 발생만 편집 하시겠습니까?',
        'All occurrences' => '모든 발생',
        'Just this occurrence' => '바로 이 사건',
        'Too many active calendars' => '활성 캘린더가 너무 많습니다.',
        'Please either turn some off first or increase the limit in configuration.' =>
            '먼저 설정을 해제하거나 설정 한도를 늘리십시오.',
        'Restore default settings' => '기본 설정 복원',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            '이 약속을 삭제 하시겠습니까? 이 작업은 실행 취소할 수 없습니다.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '먼저 고객 사용자를 선택한 다음이 티켓에 지정할 고객 ID를 선택하십시오.',
        'Duplicated entry' => '중복 입력',
        'It is going to be deleted from the field, please try again.' => '현장에서 삭제 될 예정입니다. 다시 시도하십시오.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            '검색 값을 하나 이상 입력하거나 *를 입력하십시오.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'OTRS 데몬에 대한 정보',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => '유효한 입력을 위해 빨간색으로 표시된 필드를 확인하십시오.',
        'month' => '달',
        'Remove active filters for this widget.' => '이 위젯에 대한 활성 필터를 제거하십시오.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '잠시만 기다려주십시오...',
        'Searching for linkable objects. This may take a while...' => '링크 가능한 객체 검색. 이 작업은 다소 시간이 걸릴 수 있습니다...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '이 링크를 정말로 삭제 하시겠습니까?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'AdBlock 또는 AdBlockPlus와 같은 브라우저 플러그인을 사용하고 있습니까? 이로 인해 여러 가지 문제가 발생할 수 있으며이 도메인에 예외를 추가하는 것이 좋습니다.',
        'Do not show this warning again.' => '이 경고를 다시 표시하지 마십시오.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '죄송합니다. 하지만 필수로 표시된 알림에 대해서는 모든 방법을 사용 중지 할 수 없습니다.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '죄송합니다만 이 알림에 대한 모든 방법을 사용중지 할 수는 없습니다.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '변경한 설정 중 적어도 하나는 페이지를 새로고침해야 합니다. 현재 화면을 다시 로드하려면 여기를 클릭하십시오.',
        'An unknown error occurred. Please contact the administrator.' =>
            '알 수없는 오류가 발생했습니다. 관리자에게 문의하십시오.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => '데스크톱 모드로 전환',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            '검색할 수 없으므로 다음 단어를 검색에서 제거하십시오.',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '이 요소는 하위 요소를 가지며 현재 제거할 수 없습니다.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => '정말로 이 통계를 삭제 하시겠습니까?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '이 티켓에 지정할 고객 ID를 선택하십시오.',
        'Do you really want to continue?' => '계속하시겠습니까?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '...  %s 더',
        ' ...show less' => '... 덜 보임',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '새 초안 추가',
        'Delete draft' => '초안 삭제',
        'There are no more drafts available.' => '더이상 사용할 수있는 초안이 없습니다.',
        'It was not possible to delete this draft.' => '이 초안을 삭제할 수 없습니다.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => '기사 필터',
        'Apply' => '적용하다',
        'Event Type Filter' => '이벤트 유형 필터',

        # JS File: Core.Agent
        'Slide the navigation bar' => '탐색 바 슬라이드 하기',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Internet Explorer에서 호환 모드를 해제하십시오!',
        'Find out more' => '더 찾아봐',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => '모바일 모드로 전환',

        # JS File: Core.App
        'Error: Browser Check failed!' => '오류 : 브라우저 확인에 실패했습니다!',
        'Reload page' => '페이지 새로고침',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'Namespace %s을 초기화 할 수 없습니다. %s을 찾을 수 없으므로',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '에러 발생됨! 자세한 내용은 브라우저 오류 로그를 확인하십시오!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => '하나 이상의 오류가 발생했습니다!',

        # JS File: Core.Installer
        'Mail check successful.' => '메일 검사가 완료되었습니다.',
        'Error in the mail settings. Please correct and try again.' => '메일 설정에 오류가 있습니다. 수정하고 다시 시도하십시오.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '새 창에서 이 노드 열기',
        'Please add values for all keys before saving the setting.' => '설정을 저장하기 전에 모든 키의 값을 추가하십시오.',
        'The key must not be empty.' => '키는 비워 둘 수 없습니다.',
        'A key with this name (\'%s\') already exists.' => '이 이름을 가진 키 (\'%s\')가 이미 있습니다.',
        'Do you really want to revert this setting to its historical value?' =>
            '이 설정을 이전 값으로 되돌리시겠습니까?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => '영업일 선택',
        'Invalid date (need a future date)!' => '날짜가 잘못 되었습니다 (미래 날짜 필요)!',
        'Invalid date (need a past date)!' => '날짜가 잘못 되었습니다 (지난 날짜 필요)!',

        # JS File: Core.UI.InputFields
        'Not available' => '사용 불가',
        'and %s more...' => '그리고 %s 더 ...',
        'Show current selection' => '현재 선택 항목 표시',
        'Current selection' => '현재 선택',
        'Clear all' => '모두 지우기',
        'Filters' => '필터',
        'Clear search' => '명확한 검색',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '지금 이 페이지를 떠나면 열려있는 모든 팝업 창이 닫힙니다.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '이 화면의 팝업이 이미 열려 있습니다. 이 파일을 닫고 이 파일을 로드하시겠습니까?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '팝업 창을 열 수 없습니다. 이 응용 프로그램에 대한 팝업 차단기를 비활성화하십시오.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '오름차순 정렬 적용,',
        'Descending sort applied, ' => '내림차순 정렬 적용,',
        'No sort applied, ' => '적용된 정렬 없음,',
        'sorting is disabled' => '정렬이 비활성화되었습니다.',
        'activate to apply an ascending sort' => '오름차순 정렬을 적용하려면 활성화',
        'activate to apply a descending sort' => '내림차순 정렬을 적용하려면 활성화',
        'activate to remove the sort' => '활성화하여 정렬을 제거하십시오.',

        # JS File: Core.UI.Table
        'Remove the filter' => '필터를 제거하십시오.',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => '현재 선택할 수 있는 요소가 없습니다.',

        # JS File: Core.UI
        'Please only select one file for upload.' => '업로드 할 파일을 하나만 선택하십시오.',
        'Sorry, you can only upload one file here.' => '죄송합니다. 여기에 하나의 파일만 업로드 할 수 있습니다.',
        'Sorry, you can only upload %s files.' => '죄송합니다. %s 파일 만 업로드 할 수 있습니다.',
        'Please only select at most %s files for upload.' => '업로드하려면 최대 %s 파일 만 선택하십시오.',
        'The following files are not allowed to be uploaded: %s' => '다음 파일은 업로드 할 수 없습니다 : %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '다음 파일은 파일 당 최대 허용 크기인 %s를 초과하여 업로드되지 않았습니다 : %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '다음 파일은 이미 업로드되었으며 다시 업로드되지 않았습니다 : %s',
        'No space left for the following files: %s' => '다음 파일에 공간이 없습니다 : %s',
        'Available space %s of %s.' => '사용 가능한 공간 %s / %s',
        'Upload information' => '정보 업로드',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '첨부파일을 삭제할 때 알 수없는 오류가 발생했습니다. 다시 시도하십시오. 오류가 계속되면 시스템 관리자에게 문의하십시오.',

        # JS File: Core.Language.UnitTest
        'yes' => '예',
        'no' => '아니오',
        'This is %s' => '이것은 %s입니다.',
        'Complex %s with %s arguments' => '%s 인수가있는 복합 %s',

        # JS File: OTRSLineChart
        'No Data Available.' => '자료 없음.',

        # JS File: OTRSMultiBarChart
        'Grouped' => '그룹화 된',
        'Stacked' => '누적된',

        # JS File: OTRSStackedAreaChart
        'Stream' => '흐름',
        'Expanded' => '퍼지는',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
고객 여러분,

불행히도 유효한 티켓 번호를 찾을 수 없습니다
이 이메일은 처리할 수 없습니다.

고객 패널을 통해 새 티켓을 만드십시오.

도와줘서 고마워!

헬프 데스크 팀
',
        ' (work units)' => '(작업단위)',
        ' 2 minutes' => '2분',
        ' 5 minutes' => '5분',
        ' 7 minutes' => '7분',
        '"Slim" skin which tries to save screen space for power users.' =>
            '고급 사용자를 위해 화면 공간을 절약하려고하는 "슬림"스킨.',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(사용자 로그인) 이름 성',
        '(UserLogin) Lastname Firstname' => '(사용자 로그인) 성 이름',
        '(UserLogin) Lastname, Firstname' => '(UserLogin) 성, 이름',
        '*** out of office until %s (%s d left) ***' => '*** %s까지 부재중(%s 남음) ***',
        '0 - Disabled' => '0 - 사용 중지됨',
        '1 - Available' => '1 - 사용 가능',
        '1 - Enabled' => '1 - 사용',
        '10 Minutes' => '10분',
        '100 (Expert)' => '100 (전문가)',
        '15 Minutes' => '15분',
        '2 - Enabled and required' => '2 - 사용 가능 및 필수',
        '2 - Enabled and shown by default' => '2 - 기본적으로 사용 및 표시됩니다.',
        '2 - Enabled by default' => '2 - 기본적으로 사용',
        '2 Minutes' => '2분',
        '200 (Advanced)' => '200(고급)',
        '30 Minutes' => '30분',
        '300 (Beginner)' => '300(초급)',
        '5 Minutes' => '5분',
        'A TicketWatcher Module.' => 'TicketWatcher 모듈.',
        'A Website' => '웹 사이트',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '병합 작업 중에 주 티켓에 병합되는 동적 필드 목록입니다. 기본 티켓에서 비어있는 동적 필드만 설정됩니다.',
        'A picture' => '사진',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '모든 자식 티켓이 이미 닫힌 경우에만 부모 티켓을 닫을 수있는 ACL 모듈 ( "상태"는 모든 자식 티켓이 닫힐 때까지 부모 티켓에 사용할 수없는 상태를 보여줍니다).',
        'Access Control Lists (ACL)' => '액세스 제어 목록 (ACL)',
        'AccountedTime' => 'AccountedTime',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '가장 오래된 티켓을 포함하는 큐의 깜박이는 메커니즘을 활성화합니다.',
        'Activates lost password feature for agents, in the agent interface.' =>
            '에이전트 인터페이스에서 에이전트에 대해 손실된 암호 기능을 활성화합니다.',
        'Activates lost password feature for customers.' => '고객을 위해 손실된 암호 기능을 활성화합니다.',
        'Activates support for customer and customer user groups.' => '고객 및 고객 사용자 그룹에 대한 지원을 활성화합니다.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '확대 / 축소 보기에서 기사 필터를 활성화하여 표시할 기사를 지정합니다.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '시스템에서 사용 가능한 테마를 활성화합니다. 값 1은 활성을 의미하고 0은 비활성을 의미합니다.',
        'Activates the ticket archive system search in the customer interface.' =>
            '고객 인터페이스에서 티켓 아카이브 시스템 검색을 활성화합니다.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '일일 범위에서 일부 티켓을 이동하여 티켓 아카이브 시스템이 더 빠른 시스템을 갖도록 활성화합니다. 이 티켓을 검색하려면 티켓 검색에서 아카이브 플래그를 사용 가능하게 설정해야 합니다.',
        'Activates time accounting.' => '시간 계산을 활성화 합니다.',
        'ActivityID' => '활동 ID',
        'Add a note to this ticket' => '이 티켓에 메모 추가',
        'Add an inbound phone call to this ticket' => '이 티켓에 인바운드 전화통화 추가',
        'Add an outbound phone call to this ticket' => '이 티켓에 발신 전화를 추가하십시오.',
        'Added %s time unit(s), for a total of %s time unit(s).' => '1%s시간 단위가 총 %s 시간 단위에 추가되었습니다.',
        'Added email. %s' => '%s 이메일 추가됨',
        'Added follow-up to ticket [%s]. %s' => '티켓 [%s]에 후속 조치가 추가되었습니다. %s',
        'Added link to ticket "%s".' => 'Added link to ticket "%s".',
        'Added note (%s).' => '메모 추가 (%s).',
        'Added phone call from customer.' => '고객이 전화를 추가했습니다.',
        'Added phone call to customer.' => '고객에게 전화를 추가했습니다.',
        'Added subscription for user "%s".' => 'Added subscription for user "%s".',
        'Added system request (%s).' => '시스템 요구 사항을 추가했습니다 (%s).',
        'Added web request from customer.' => '고객의 웹 요청을 추가했습니다.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'OTRS 로그 파일에 실제 연도와 월이있는 접미어를 추가합니다. 매월 로그 파일이 생성됩니다.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '상담원 인터페이스의 티켓 작성 화면에서 고객 전자 메일 주소를 받는 사람에게 추가합니다. 기사 유형이 이메일 내부인 경우 고객 이메일 주소는 추가되지 않습니다.',
        'Adds the one time vacation days for the indicated calendar.' => '표시된 달력에 대해 휴가일을 한 번 추가합니다.',
        'Adds the one time vacation days.' => '한 번 휴가를 추가합니다.',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '지정된 달력에 대한 영구 휴가 일을 추가합니다.',
        'Adds the permanent vacation days.' => '영구 휴가 일을 추가합니다.',
        'Admin' => '관리자',
        'Admin Area.' => '관리자 영역',
        'Admin Notification' => '관리자 알림',
        'Admin area navigation for the agent interface.' => '에이전트 인터페이스의 관리 영역 탐색.',
        'Admin modules overview.' => '관리 모듈 개요.',
        'Admin.' => '관리자.',
        'Administration' => '관리',
        'Agent Customer Search' => '고객 검색',
        'Agent Customer Search.' => '상담원 고객 검색.',
        'Agent Name' => '에이전트 이름',
        'Agent Name + FromSeparator + System Address Display Name' => '에이전트 이름 + 발신자 + 시스템 주소 표시 이름',
        'Agent Preferences.' => '에이전트 환경 설정.',
        'Agent Statistics.' => '에이전트 통계.',
        'Agent User Search' => '에이전트 사용자 검색',
        'Agent User Search.' => '에이전트 사용자 검색.',
        'Agent interface article notification module to check PGP.' => 'PGP를 확인하는 에이전트 인터페이스 기사 알림 모듈',
        'Agent interface article notification module to check S/MIME.' =>
            'S / MIME을 확인하는 에이전트 인터페이스 기사 알림 모듈.',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '탐색 인터페이스를 통해 CIC 검색에 액세스하는 에이전트 인터페이스 모듈. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '탐색 인터페이스를 통해 전체 텍스트 검색에 액세스 할 수있는 에이전트 인터페이스 모듈. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '탐색 인터페이스를 통해 검색 프로파일에 액세스하는 에이전트 인터페이스 모듈. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'S / MIME 키가 사용 가능하고 참이면 Ticket-Zoom-View에서 수신 전자 메일을 확인하는 에이전트 인터페이스 모듈.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '잠긴 티켓 수를보기위한 에이전트 인터페이스 알림 모듈. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '에이전트 인터페이스 통지 모듈은 에이전트가 담당하는 티켓 수를 확인합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '내 서비스에서 티켓 수를 확인할 수있는 에이전트 인터페이스 알림 모듈 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '감시 된 티켓 수를보기위한 에이전트 인터페이스 알림 모듈. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '티켓에 연결된 객체 테이블을 표시하는 AgentTicketZoom 위젯입니다.',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '사이드 바에 티켓에 대한 고객 정보를 표시하는 AgentTicketZoom 위젯.',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '사이드 바에 티켓 데이터를 표시하는 AgentTicketZoom 위젯.',
        'Agents ↔ Groups' => '에이전트 ↔ 그룹',
        'Agents ↔ Roles' => '에이전트 ↔ 역할',
        'All CustomerIDs of a customer user.' => '고객 사용자의 모든 고객 ID.',
        'All attachments (OTRS Business Solution™)' => '모든 첨부 파일 (OTRS Business Solution ™)',
        'All customer users of a CustomerID' => 'CustomerID의 모든 고객 사용자',
        'All escalated tickets' => '모든 에스컬레이션된 티켓',
        'All new tickets, these tickets have not been worked on yet' => '모든 새로운 티켓이 그 티켓은 아직 작동하지 않았습니다.',
        'All open tickets, these tickets have already been worked on.' =>
            '열려있는 모든 티켓, 이 티켓들은 이미 작업되었습니다.',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '미리 알림이 있는 모든 티켓은 미리 알림 날짜에 도달했습니다.',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트 인터페이스의 닫기 티켓 화면에 메모를 추가 할 수 있습니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트 인터페이스의 티켓없는 텍스트 화면에 메모를 추가 할 수 있습니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트 인터페이스의 티켓 메모 화면에 메모를 추가 할 수 있습니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트 인터페이스에서 확대 된 티켓의 티켓 소유자 화면에 노트를 추가 할 수 있습니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 메모를 추가 할 수 있습니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트 인터페이스에서 확대 된 티켓의 티켓 우선 순위 화면에 노트를 추가 할 수 있습니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 메모를 추가 할 수 있습니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '에이전트가 통계를 생성할 경우 에이전트가 축을 교환할 수 있습니다.',
        'Allows agents to generate individual-related stats.' => '상담원이 개인 관련 통계를 생성할 수 있습니다.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '브라우저에서 티켓의 첨부 파일 표시 (인라인) 또는 다운로드 만 가능 (첨부) 중에서 선택할 수 있습니다.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '고객 인터페이스에서 고객 티켓에 대한 다음 작성 상태를 선택할 수 있습니다.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '고객이 고객 인터페이스에서 티켓 우선순위를 변경할 수 있습니다.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '고객이 고객 인터페이스에서 티켓 SLA를 설정할 수 있습니다.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '고객이 고객 인터페이스에서 티켓 우선순위를 설정할 수 있습니다.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '고객이 고객 인터페이스에서 티켓 서비스를 설정할 수 있습니다.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '기존 고객이 아닌 경우에도 기본 서비스를 선택할 수 있습니다.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '티켓 (예 : 전자 메일, 데스크톱, 네트워크, ...)에 대한 서비스 및 SLA 및 SLA에 대한 에스컬레이션 특성 (티켓 서비스 / SLA 기능이 활성화 된 경우)을 정의 할 수 있습니다.',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '에이전트 인터페이스의 티켓 검색에서 확장 된 검색 조건을 허용합니다. 이 기능을 사용하면 e. 지. "(* key1 * && * key2 *)"또는 "(* key1 * || * key2 *)"와 같은 조건의 티켓 제목',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '고객 인터페이스의 티켓 검색에서 확장 된 검색 조건을 허용합니다. 이 기능을 사용하면 e. 지. "(* key1 * && * key2 *)"또는 "(* key1 * || * key2 *)"와 같은 조건의 티켓 제목을 사용하십시오.',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '일반 에이전트 인터페이스의 티켓 검색에서 확장 된 검색 조건을 허용합니다. 이 기능을 사용하면 e. 지. "(* key1 * && * key2 *)"또는 "(* key1 * || * key2 *)"와 같은 조건의 티켓 제목을 사용하십시오.',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '중간 형식 티켓 개요 (CustomerInfo => 1 - 고객 정보도 표시)를 허용합니다.',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '작은 형식의 티켓 개요를 가질 수 있습니다 (CustomerInfo => 1 - 고객 정보 표시).',
        'Allows invalid agents to generate individual-related stats.' => '잘못된 에이전트가 개인 관련 통계를 생성할 수 있습니다.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '관리자가 고객 사용자 관리 패널을 통해 다른 고객으로 로그인 할 수 있습니다.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '관리자가 사용자 관리 패널을 통해 다른 사용자로 로그인 할 수있게 합니다.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 닫기 티켓 화면에서 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 전자 메일 아웃바운드 화면에 현재 작업 내용을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 작성 화면에서 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전달 화면에서 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 없는 텍스트 화면에 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면에서 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 소유자 화면에 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 보류 화면에 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 인바운드 인바운드 화면에 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 폰 아웃바운드 화면에 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 우선 순위 화면에 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 현재 작업을 초안으로 저장할 수 있습니다.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면에서 새 티켓 상태를 설정할 수 있습니다.',
        'Always show RichText if available' => '가능한 경우 리치 텍스트 표시',
        'Answer' => '응답',
        'Appointment Calendar overview page.' => '약속 일정 개요 페이지.',
        'Appointment Notifications' => '약속 알림',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            '약속에 대한 알림 항목을 준비하는 약속 일정 이벤트 모듈입니다.',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            '티켓 약속의 데이터로 티켓을 업데이트 하는 약속 캘린더 이벤트 모듈입니다.',
        'Appointment edit screen.' => '약속 수정 화면',
        'Appointment list' => '약속 목록',
        'Appointment list.' => '약속 목록',
        'Appointment notifications' => '약속 알림',
        'Appointments' => '약속',
        'Arabic (Saudi Arabia)' => '아랍어 (사우디 아라비아)',
        'ArticleTree' => 'ArticleTree',
        'Attachment Name' => '첨부명',
        'Automated line break in text messages after x number of chars.' =>
            'X 문자 수 후에 문자 메시지의 자동 줄바꿈',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '유효하지 않은 소유자가 잠금 해제된 티켓의 상태를 자동으로 변경합니다. 상태 유형에서 새 티켓 상태로 매핑합니다.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면을 연 다음 자동으로 현재 에이전트를 잠그고 소유자를 설정합니다.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '대량 작업을 선택한 후 자동으로 소유자를 현재 에이전트로 잠그고 설정합니다.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '티켓의 소유자를 자동으로 책임자로 설정합니다 (티켓 책임 기능이 활성화 된 경우). 이것은 로그인 한 사용자의 수동 작업으로 만 작동합니다. 자동 작업에는 작동하지 않습니다. GenericAgent, 전자 메일 관리자 및 GenericInterface.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '첫 번째 소유자가 업데이트된 후 티켓의 책임을 자동으로 설정합니다 (티켓이 아직 설정되지 않은 경우).',
        'Avatar' => '화신',
        'Balanced white skin by Felix Niklas (slim version).' => 'Felix Niklas (슬림 버전)의 균형 잡힌 하얀 피부.',
        'Balanced white skin by Felix Niklas.' => 'Felix Niklas의 균형 잡힌 하얀 피부.',
        'Based on global RichText setting' => '전역 서식있는 텍스트 설정에 기반',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '보낸 사람 : @ example.com 주소로 유효한 티켓 번호가없는 수신 전자 메일을 모두 차단합니다.',
        'Bounced to "%s".' => 'Bounced to "%s".',
        'Bulgarian' => '불가리아 사람',
        'Bulk Action' => '일괄 작업',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD 예제 설정. 외부 CMD가 STDOUT에서 일부 출력을 반환하는 전자 메일을 무시합니다 (전자 메일은 some.bin의 STDIN으로 파이프됩니다).',
        'CSV Separator' => 'CSV 구분 기호',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'GenericInterface에서 에이전트 인증을위한 캐시 시간.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'GenericInterface에서 고객 인증을위한 캐시 시간 초. ',
        'Cache time in seconds for the DB ACL backend.' => 'DB ACL 백엔드의 캐시 시간 초.',
        'Cache time in seconds for the DB process backend.' => 'DB 프로세스 백엔드의 캐시 시간 초. ',
        'Cache time in seconds for the SSL certificate attributes.' => 'SSL 인증서 속성의 캐시 시간 초.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '티켓 프로세스 탐색 모음 출력 모듈의 캐시 시간 초.',
        'Cache time in seconds for the web service config backend.' => '웹 서비스 설정 백엔드의 캐시 시간 초.',
        'Calendar manage screen.' => '캘린더 관리 화면.',
        'Catalan' => '카탈로니아 사람',
        'Change password' => '비밀번호 변경',
        'Change queue!' => '대기열을 변경하십시오!',
        'Change the customer for this ticket' => '이 티켓의 고객 변경',
        'Change the free fields for this ticket' => '이 티켓의 빈 필드를 변경하십시오',
        'Change the owner for this ticket' => '이 티켓의 소유자 변경',
        'Change the priority for this ticket' => '이 티켓의 우선 순위 변경',
        'Change the responsible for this ticket' => '이 티켓의 책임자를 변경하십시오.',
        'Change your avatar image.' => '아바타 이미지를 변경하십시오.',
        'Change your password and more.' => '암호 등을 변경하십시오.',
        'Changed SLA to "%s" (%s).' => 'SLA를 "%s"(%s)로 변경했습니다.',
        'Changed archive state to "%s".' => 'Archive 상태를 "%s"로 변경했습니다.',
        'Changed customer to "%s".' => '고객을 "%s"로 변경했습니다.',
        'Changed dynamic field %s from "%s" to "%s".' => '동적 필드 %s을 "%s"에서 "%s"로 변경했습니다.',
        'Changed owner to "%s" (%s).' => '소유자를 "%s"(%s)로 변경했습니다.',
        'Changed pending time to "%s".' => '보류 시간을 "%s"로 변경했습니다.',
        'Changed priority from "%s" (%s) to "%s" (%s).' => '"%s" (%s)에서 "%s" (%s)로 중요도를 변경했습니다.',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '"%s"(%s)에서 "%s"(%s)로 대기열을 변경했습니다.',
        'Changed responsible to "%s" (%s).' => '책임을 "%s"(%s)로 변경했습니다.',
        'Changed service to "%s" (%s).' => '서비스를 "%s"(%s)로 변경했습니다.',
        'Changed state from "%s" to "%s".' => '상태를 "%s"에서 "%s"로 변경했습니다.',
        'Changed title from "%s" to "%s".' => '제목을 "%s"에서 "%s"로 변경했습니다.',
        'Changed type from "%s" (%s) to "%s" (%s).' => '유형을 "%s"(%s)에서 "%s"(%s)로 변경했습니다.',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '모든 사람에게 티켓 소유자를 변경합니다 (ASP에 유용함). 일반적으로 티켓 대기열에 rw 권한이있는 에이전트 만 표시됩니다.',
        'Chat communication channel.' => '채팅 통신 채널.',
        'Checkbox' => '체크 박스',
        'Checks for articles that needs to be updated in the article search index.' =>
            '기사 검색 색인에서 업데이트 해야하는 기사를 확인합니다.',
        'Checks for communication log entries to be deleted.' => '삭제할 통신 로그 항목을 확인합니다.',
        'Checks for queued outgoing emails to be sent.' => '보낸 대기중인 보내는 전자 메일을 확인합니다.',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '유효한 티켓 번호를 검색하여 전자 메일이 기존 티켓의 후속 조치인지 확인합니다.',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '후속 조치를 위해 티켓 번호 검색에서 SystemID를 확인합니다. 활성화되지 않은 경우 시스템을 사용한 후 SystemID가 변경됩니다.',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '이 시스템에 대한 OTRS Business Solution ™의 가용성을 확인합니다.',
        'Checks the entitlement status of OTRS Business Solution™.' => 'OTRS Business Solution ™의 자격 상태를 확인합니다.',
        'Child' => '어린이',
        'Chinese (Simplified)' => '중국어(간체)',
        'Chinese (Traditional)' => '중국(전통)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            '알림을 받으려는 약속 변경 유형을 선택하십시오.',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '알림을 수신할 티켓 변경 유형을 선택하십시오. 필수로 표시된 알림은 완전히 사용 중지할 수 없습니다.',
        'Choose which notifications you\'d like to receive.' => '수신할 알림을 선택하십시오.',
        'Christmas Eve' => '크리스마스 이브',
        'Close' => '닫기',
        'Close this ticket' => '이 티켓을 닫습니다.',
        'Closed tickets (customer user)' => '폐쇄된 티켓 (고객 사용자)',
        'Closed tickets (customer)' => '정기권(고객)',
        'Cloud Services' => '클라우드 서비스',
        'Cloud service admin module registration for the transport layer.' =>
            '전송 계층에 대한 클라우드 서비스 관리 모듈 등록',
        'Collect support data for asynchronous plug-in modules.' => '비동기 플러그인 모듈에 대한 지원 데이터를 수집하십시오.',
        'Column ticket filters for Ticket Overviews type "Small".' => '티켓 개요에 대한 열 티켓 필터는 "Small"입니다.',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의 에스컬레이션보기에서 필터링 할 수있는 열. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의 잠긴보기에서 필터링 할 수있는 열입니다. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의 대기열보기에서 필터링 할 수있는 열입니다. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의 담당 뷰에서 필터링 할 수있는 열입니다. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의 서비스보기에서 필터링 할 수있는 열입니다. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의 상태보기에서 필터링 할 수있는 열입니다. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의 티켓 검색 결과보기에서 필터링 할 수있는 열입니다. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '에이전트 인터페이스의보기보기에서 필터링 할 수있는 열입니다. 참고 : 티켓 속성, 동적 필드 (DynamicField_NameX) 및 고객 속성 (예 : CustomerUserPhone, CustomerCompanyName, ...) 만 허용됩니다.',
        'Comment for new history entries in the customer interface.' => '고객 인터페이스의 새로운 기록 항목에 대한 설명.',
        'Comment2' => '의견 2',
        'Communication' => '통신',
        'Communication & Notifications' => '통신 및 알림',
        'Communication Log GUI' => '통신 로그 GUI',
        'Communication log limit per page for Communication Log Overview.' =>
            '통신 로그 개요 페이지 당 통신 로그 제한.',
        'CommunicationLog Overview Limit' => 'CommunicationLog 개요 제한',
        'Company Status' => '회사 현황',
        'Company Tickets.' => '회사 티켓.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '발신 이메일에 X-Header로 포함될 회사 이름.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'AgentZoom과 AgentTicketZoom의 호환성 모듈.',
        'Complex' => '복잡한',
        'Compose' => '조립하다',
        'Configure Processes.' => '프로세스 구성.',
        'Configure and manage ACLs.' => 'ACL 구성 및 관리',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '사용할 추가 읽기 전용 미러 데이터베이스를 구성하십시오.',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '향상된 지원을 위해 OTRS 그룹에 지원 데이터를 보내도록 구성합니다.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '새 티켓이 작성된 후 표시할 화면을 구성하십시오.',
        'Configure your own log text for PGP.' => 'PGP에 대한 자체 로그 텍스트를 구성하십시오.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '기본 TicketDynamicField 설정을 구성합니다. "Name"은 사용할 동적 필드를 정의하고, "Value"는 설정할 데이터이고 "Event"는 트리거 이벤트를 정의합니다. 개발자 설명서 (https://doc.otrs.com/doc/), "Ticket Event Module"장을 확인하십시오.',
        'Controls how to display the ticket history entries as readable values.' =>
            '티켓 기록 항목을 읽을 수 있는 값으로 표시하는 방법을 제어합니다.',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '알 수없는 고객의 보낸 사람 주소에서 CustomerID가 자동으로 복사되는지 여부를 제어합니다.',
        'Controls if CustomerID is read-only in the agent interface.' => 'CustomerID가 에이전트 인터페이스에서 읽기 전용인지 여부를 제어합니다.',
        'Controls if customers have the ability to sort their tickets.' =>
            '고객이 티켓을 정렬할 수 있는지 여부를 제어합니다.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '항목에서 둘 이상이 상담원 인터페이스의 새 전화 티켓에 설정될 수 있는지 여부를 제어합니다.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '관리자가 SysConfig에서 저장된 시스템 구성을 가져올 수 있는지 여부를 제어합니다.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '관리자가 AdminSelectBox를 통해 데이터베이스를 변경할 수 있는지 여부를 제어합니다.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '자동 완성 필드가 AdminCustomerUser 인터페이스의 고객 ID 선택에 사용되는지 여부를 제어합니다.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '티켓을 보관할 때 티켓 및 집필 플래그가 제거되는지 여부를 제어합니다.',
        'Converts HTML mails into text messages.' => 'HTML 메일을 텍스트 메시지로 변환합니다.',
        'Create New process ticket.' => '새 프로세스 티켓을 만듭니다.',
        'Create Ticket' => '티켓 만들기',
        'Create a new calendar appointment linked to this ticket' => '이 티켓에 연결된 새 일정 약속을 만듭니다.',
        'Create and manage Service Level Agreements (SLAs).' => 'SLA (Service Level Agreements) 작성 및 관리',
        'Create and manage agents.' => '에이전트 생성 및 관리.',
        'Create and manage appointment notifications.' => '약속 알림을 작성하고 관리하십시오.',
        'Create and manage attachments.' => '첨부파일을 만들고 관리합니다.',
        'Create and manage calendars.' => '캘린더를 만들고 관리합니다.',
        'Create and manage customer users.' => '고객 사용자를 생성하고 관라하십시오.',
        'Create and manage customers.' => '고객 생성 및 관리.',
        'Create and manage dynamic fields.' => '동적 필드를 만들고 관리합니다.',
        'Create and manage groups.' => '그룹을 만들고 관리합니다.',
        'Create and manage queues.' => '대기열을 만들고 관리합니다.',
        'Create and manage responses that are automatically sent.' => '자동으로 전송되는 응답을 작성하고 관리하십시오.',
        'Create and manage roles.' => '역할을 만들고 관리합니다.',
        'Create and manage salutations.' => '인사이트를 만들고 관리하십시오.',
        'Create and manage services.' => '서비스를 만들고 관리하십시오.',
        'Create and manage signatures.' => '서명 작성 및 관리.',
        'Create and manage templates.' => '템플릿을 만들고 관리합니다.',
        'Create and manage ticket notifications.' => '티켓 알림을 생성하고 관리하십시오.',
        'Create and manage ticket priorities.' => '티켘ㅅ 우선 순위를 만들고 관리합니다.',
        'Create and manage ticket states.' => '티켓 상태를 생성하고 관리합니다.',
        'Create and manage ticket types.' => '티켓 유형을 생성하고 관리하십시오.',
        'Create and manage web services.' => '웹 서비스를 만들고 관리합니다.',
        'Create new Ticket.' => '새 티켓을 만듭니다.',
        'Create new appointment.' => '새 약속을 만듭니다.',
        'Create new email ticket and send this out (outbound).' => '새 이메일 티켓을 작성하여 보내십시오 (아웃 바운드).',
        'Create new email ticket.' => '새 이메일 티켓을 만드십시오.',
        'Create new phone ticket (inbound).' => '새 전화 티켓 (인바운드)을 만듭니다.',
        'Create new phone ticket.' => '새 전화 티켓을 만듭니다.',
        'Create new process ticket.' => '새 프로세스 티켓을 작성 하십시오.',
        'Create tickets.' => '티켓을 만드십시오.',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '티켓 [%s] 생성 : "%s", 우선 순위 -"%s" , 상태 -"%s"',
        'Croatian' => '크로아티아 사람',
        'Custom RSS Feed' => '사용자 정의 RSS 피드',
        'Custom RSS feed.' => '사용자 정의 RSS 피드.',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '티켓이 없는 고객에게 표시되는 페이지의 사용자 정의 텍스트(번역된 텍스트가 필요한 경우 사용자 정의 번역 모듈에 추가).',
        'Customer Administration' => '고객 관리',
        'Customer Companies' => '고객사',
        'Customer IDs' => '고객 ID',
        'Customer Information Center Search.' => '고객 정보 센터 검색',
        'Customer Information Center search.' => '고객 정보 센터 검색',
        'Customer Information Center.' => '고객 정보 센터',
        'Customer Ticket Print Module.' => '고객 티켓 인쇄 모듈',
        'Customer User Administration' => '고객 사용자 관리',
        'Customer User Information' => '고객 사용자 정보',
        'Customer User Information Center Search.' => '고객 사용자 정보 센터 검색',
        'Customer User Information Center search.' => '고객 사용자 정보 센터 검색',
        'Customer User Information Center.' => '고객 사용자 정보 센터',
        'Customer Users ↔ Customers' => '고객 사용자 ↔ 고객',
        'Customer Users ↔ Groups' => '고객 사용자 ↔ 그룹',
        'Customer Users ↔ Services' => '고객 사용자 ↔ 서비스',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '이 고객의 닫힌 티켓을 정보 블록으로 표시하는 고객 아이템 (아이콘). CustomerUserLogin을 1로 설정하면 CustomerID가 아닌 로그인 이름을 기반으로하는 티켓이 검색됩니다.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '고객의 오픈 티켓을 정보 블록으로 보여주는 고객 아이템 (아이콘). CustomerUserLogin을 1로 설정하면 CustomerID가 아닌 로그인 이름을 기반으로하는 티켓이 검색됩니다.',
        'Customer preferences.' => '고객 환경설정',
        'Customer ticket overview' => '고객 티켓 개요',
        'Customer ticket search.' => '고객 티켓 검색',
        'Customer ticket zoom' => '고객 티켓 줌',
        'Customer user search' => '고객 사용자 검색',
        'CustomerID search' => '고객 ID 검색',
        'CustomerName' => '고객 이름',
        'CustomerUser' => '고객사용자',
        'Customers ↔ Groups' => '고객 ↔ 그룹',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '전체 텍스트 인덱스에 대한 사용자 지정 가능한 중지 단어. 이 단어는 검색 색인에서 제거됩니다.',
        'Czech' => '체코',
        'Danish' => '덴마크어',
        'Dashboard overview.' => '현황판 개요',
        'Data used to export the search result in CSV format.' => '검색 결과를 CSV 형식으로 내보내는데 사용되는 데이터입니다.',
        'Date / Time' => '날짜 / 시간',
        'Default (Slim)' => '기본값 (슬림)',
        'Default ACL values for ticket actions.' => '티켓 조치에 대한 기본 ACL 값.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '자동으로 생성되는 엔티티 ID에 대한 기본 ProcessManagement 엔티티 접두사입니다.',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '티켓 검색 화면의 속성에 사용할 기본 데이터입니다. 예 : "TicketCreateTimePointFormat = year; TicketCreateTimePointStart = 마지막; TicketCreateTimePoint = 2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '티켓 검색 화면의 속성에 사용할 기본 데이터입니다. 예 : "TicketCreateTimeStartYear = 2010, TicketCreateTimeStartMonth = 10, TicketCreateTimeStopDay = 4, TicketCreateTimeStopYear = 2010, TicketCreateTimeStopMonth = 11, TicketCreateTimeStopDay = 3; ',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'AgentTicketZoom 및 CustomerTicketZoom의받는 사람 (받는 사람, 참조) 이름의 기본 표시 유형입니다.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'AgentTicketZoom 및 CustomerTicketZoom의 보낸 사람 (보낸 사람) 이름의 기본 표시 유형입니다.',
        'Default loop protection module.' => '기본 루프 보호 모듈.',
        'Default queue ID used by the system in the agent interface.' => '에이전트 인터페이스에서 시스템이 사용하는 기본 대기열 ID입니다.',
        'Default skin for the agent interface (slim version).' => '에이전트 인터페이스 (슬림버전)의 기본 스킨입니다.',
        'Default skin for the agent interface.' => '에이전트 인터페이스의 기본 스킨입니다.',
        'Default skin for the customer interface.' => '고객 인터페이스의 기본 스킨입니다.',
        'Default ticket ID used by the system in the agent interface.' =>
            '에이전트 인터페이스에서 시스템이 사용하는 기본 티켓 ID 입니다.',
        'Default ticket ID used by the system in the customer interface.' =>
            '고객 인터페이스에서 시스템이 사용하는 기본 티켓 ID입니다.',
        'Default value for NameX' => 'NameX의 기본값',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '링크 객체 위젯에서 설정 버튼을 사용할 수있는 액션 정의 (LinkObject :: ViewMode = "complex"). 이러한 작업은 다음 JS 및 CSS 파일을 등록해야합니다. Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '정의 된 문자열 뒤에 링크를 추가하기 위해 html 출력을위한 필터를 정의하십시오. Image 요소는 두 가지 입력 종류를 허용합니다. 한 번에 이미지의 이름 (예 : faq.png). 이 경우 OTRS 이미지 경로가 사용됩니다. 두 번째 가능성은 링크를 이미지에 삽입하는 것입니다.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            '고객 사용자 데이터 (키)의 변수와 티켓의 동적 필드 (값) 간의 매핑을 정의하십시오. 그 목적은 티켓 동적 필드에 고객 사용자 데이터를 저장하는 것입니다. 동적 필드는 시스템에 있어야하며 에이전트에서 수동으로 설정하거나 업데이트 할 수 있도록 AgentTicketFreeText에 대해 활성화해야합니다. AgentTicketPhone, AgentTicketEmail 및 AgentTicketCustomer에는 사용할 수 없습니다. 그럴 경우 자동으로 설정된 값보다 우선합니다. 이 매핑을 사용하려면 Ticket :: EventModulePost ### 4100-DynamicFieldFromCustomerUser 설정을 활성화해야합니다.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '종료 시간의 동적 필드 이름을 정의하십시오. 이 필드는 티켓 : "날짜 / 시간"으로 시스템에 수동으로 추가되어야하며 티켓 생성 화면 및 / 또는 기타 티켓 동작 화면에서 활성화해야합니다.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '시작 시간의 동적 필드 이름을 정의하십시오. 이 필드는 티켓 : "날짜 / 시간"으로 시스템에 수동으로 추가되어야하며 티켓 생성 화면 및 / 또는 기타 티켓 동작 화면에서 활성화해야합니다.',
        'Define the max depth of queues.' => '대기열의 최대 깊이를 정의하십시오.',
        'Define the queue comment 2.' => '큐 설명 정의 2.',
        'Define the service comment 2.' => '서비스 주석 정의2.',
        'Define the sla comment 2.' => 'sla 주석 정의 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '표시된 달력의 날짜 선택 도구에 대한 시작 요일을 정의하십시오.',
        'Define the start day of the week for the date picker.' => '날짜 선택 도구의 시작 요일을 정의하십시오.',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '에이전트 아바타에 사용할 아바타 엔진과 AgentTicketZoom의 보낸 사람 이미지를 정의하십시오. \'없음\'을 선택하면 대신 이니셜이 표시됩니다. \'없음\'이외의 다른 것을 선택하면 특정 사용자의 암호화 된 이메일 주소가 외부 서비스로 전송됩니다.',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '연결된 약속 위젯에 표시 할 열을 정의하십시오 (LinkObject :: ViewMode = "complex"). 가능한 설정 : 0 = 사용 안 함, 1 = 사용 가능, 2 = 기본적으로 사용함.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '연결된 티켓 위젯에 표시 할 열을 정의하십시오 (LinkObject :: ViewMode = "complex"). 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '고객 정보 블록의 끝에 LinkedIn 아이콘을 생성하는 고객 항목을 정의합니다.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '고객 정보 블록의 끝에 XING 아이콘을 생성하는 고객 항목을 정의합니다.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '고객 정보 블록의 끝에 Google 아이콘을 생성하는 고객 항목을 정의합니다.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '고객 정보 블록의 끝에 Google지도 아이콘을 생성하는 고객 항목을 정의합니다.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'CVE 번호 뒤에 링크를 추가하는 html 출력을위한 필터를 정의합니다. Image 요소는 두 가지 입력 종류를 허용합니다. 한 번에 이미지의 이름 (예 : faq.png). 이 경우 OTRS 이미지 경로가 사용됩니다. 두 번째 가능성은 링크를 이미지에 삽입하는 것입니다.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'MSBulletin 번호 뒤에 링크를 추가하기 위해 html 출력을위한 필터를 정의합니다. Image 요소는 두 가지 입력 종류를 허용합니다. 한 번에 이미지의 이름 (예 : faq.png). 이 경우 OTRS 이미지 경로가 사용됩니다. 두 번째 가능성은 링크를 이미지에 삽입하는 것입니다.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '정의 된 문자열 뒤에 링크를 추가하는 html 출력을위한 필터를 정의합니다. Image 요소는 두 가지 입력 종류를 허용합니다. 한 번에 이미지의 이름 (예 : faq.png). 이 경우 OTRS 이미지 경로가 사용됩니다. 두 번째 가능성은 링크를 이미지에 삽입하는 것입니다.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'bugtraq 번호 뒤에 링크를 추가하기위한 html 출력을위한 필터를 정의합니다. Image 요소는 두 가지 입력 종류를 허용합니다. 한 번에 이미지의 이름 (예 : faq.png). 이 경우 OTRS 이미지 경로가 사용됩니다. 두 번째 가능성은 링크를 이미지에 삽입하는 것입니다.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'AgentTicketZoom의 기사 텍스트에서 CVE 번호를 수집하는 필터를 정의합니다. 결과는 기사 옆의 메타 상자에 표시됩니다. 링크 요소 위로 마우스 커서를 이동할 때 미리보기를 보려면 URLPreview를 채 웁니다. URL과 동일한 URL 일 수도 있지만 대체 URL 일 수도 있습니다. 일부 웹 사이트는 iframe (예 : Google)에 표시되지 않으므로 미리보기 모드에서는 작동하지 않습니다.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '미리 정의된 키워드를 강조 표시하기 위해 기사의 텍스트를 처리하는 필터를 정의합니다.',
        'Defines a permission context for customer to group assignment.' =>
            '고객 대 그룹 할당에 대한 사용 권한 컨텍스트를 정의합니다.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '구문 검사에서 일부 주소를 제외하는 정규 표현식을 정의합니다 ( "CheckEmailAddresses"가 "Yes"로 설정된 경우). 문법적으로 유효하지는 않지만 시스템에 필요한 전자 메일 주소 (예 : "root @ localhost")는이 필드에 정규식을 입력하십시오.',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '응용 프로그램에서 사용해서는 안되는 모든 전자 메일 주소를 필터링하는 정규식을 정의합니다.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '작업에 의해 처리된 티켓 사이의 슬립시간을 정의합니다. 마이크로 초',
        'Defines a useful module to load specific user options or to display news.' =>
            '특정 사용자 옵션을 로드하거나 뉴스를 표시하는데 유용한 모듈을 정의합니다.',
        'Defines all the X-headers that should be scanned.' => '검사해야할 모든 X- 헤더를 정의합니다.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '응용 프로그램에서 사용할 수 있는 모든 언어를 정의합니다. 여기에 영어의 영어이름만 지정하십시오.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '응용 프로그램에서 사용할 수있는 모든 언어를 정의합니다. 여기에는 언어의 고유이름만 지정하십시오.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '고객 인터페이스의 고객 환경 설정에서 RefreshTime 객체의 모든 매개 변수를 정의합니다.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '고객 인터페이스의 고객 기본 설정에서 ShownTickets 객체의 모든 매개 변수를 정의합니다.',
        'Defines all the parameters for this item in the customer preferences.' =>
            '고객 환경 설정에서 이 항목의 모든 매개 변수를 정의합니다.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '고객 환경 설정에서이 항목의 모든 매개 변수를 정의합니다. \'PasswordRegExp\'는 정규 표현식과 암호를 일치시킵니다. \'PasswordMinSize\'를 사용하여 최소 문자 수를 정의하십시오. 적절한 옵션을 \'1\'로 설정하여 최소한 2 개의 소문자와 2 개의 대문자가 필요한지 정의하십시오. \'PasswordMin2Characters\'는 암호가 2 자 이상의 문자 (0 또는 1로 설정)를 포함해야 하는지를 정의합니다. \'PasswordNeedDigit\'은 최소 1 자리 숫자의 필요성을 제어합니다 (제어하려면 0 또는 1로 설정).',
        'Defines all the parameters for this notification transport.' => '이 알림 전송에 대한 모든 매개 변수를 정의합니다.',
        'Defines all the possible stats output formats.' => '가능한 모든 통계 출력형식을 정의합니다.',
        'Defines an alternate URL, where the login link refers to.' => '로그인 링크가 참조하는 대체 URL을 정의합니다.',
        'Defines an alternate URL, where the logout link refers to.' => '로그 아웃 링크가 참조하는 대체 URL을 정의합니다.',
        'Defines an alternate login URL for the customer panel..' => '고객 패널에 대한 대체 로그인 URL을 정의합니다.',
        'Defines an alternate logout URL for the customer panel.' => '고객 패널에 대한 대체 로그 아웃 URL을 정의합니다.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '고객의 데이터베이스에 대한 외부 링크를 정의합니다 (예 : \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            '약속 편집 화면에서 현재 위치의 Google지도 페이지로 연결되는 아이콘을 정의합니다.',
        'Defines an overview module to show the address book view of a customer user list.' =>
            'Customer User List의 주소록보기를 보여주는 개요 모듈을 정의합니다.',
        'Defines available article actions for Chat articles.' => '채팅 기사에 대해 사용 가능한 기사 작업을 정의합니다.',
        'Defines available article actions for Email articles.' => '전자 메일 아티클에 대해 사용 가능한 아티클 동작을 정의합니다.',
        'Defines available article actions for Internal articles.' => '내부 기사에 대해 사용가능한 기사 조치를 정의합니다.',
        'Defines available article actions for Phone articles.' => '전화 기사에 대해 사용가능한 기사 조치를 정의합니다.',
        'Defines available article actions for invalid articles.' => '유효하지 않은 기사에 대해 사용 가능한 기사 조치를 정의합니다.',
        'Defines available groups for the admin overview screen.' => '관리자 개요 화면에 사용할 수 있는 그룹을 정의합니다.',
        'Defines chat communication channel.' => '채팅 통신 채널을 정의합니다.',
        'Defines default headers for outgoing emails.' => '보내는 전자 메일의 기본 헤더를 정의합니다.',
        'Defines email communication channel.' => '전자 메일 통신 채널을 정의합니다.',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '에이전트가 결과 순서를 선택할 수 있는 티켓 속성을 정의합니다.',
        'Defines groups for preferences items.' => '기본 설정 항목에 대한 그룹을 정의합니다.',
        'Defines how many deployments the system should keep.' => '시스템이 유지해야하는 배포 수를 정의합니다.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '보낸 사람(응답 및 전자 메일 티켓에서 보낸 전자 메일) 필드가 어떻게 표시되는지 정의합니다.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '대기열 뷰에서 우선 순위 별 사전 정렬을 수향해야하는지 여부를 정의합니다.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '우선 순위 별 사전 정렬을 서비스 보기에서 수행해야하는지 여부를 정의합니다.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 닫기 티켓 화면에서 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정됨).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 전자 메일 아웃바운드 화면에 티켓 잠금이 필요한지 여부를 정의합니다 ( 티켓이 아직 잠겨있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정됨).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 전자 메일 재전송 화면에서 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 잠겨있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정됨).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 바운스 화면에서 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정됨).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스 티켓 작성 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 잠겨있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정됨).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 전달 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 소유자로 자동 설정 됨).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 프리 텍스트 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정 됨).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 확대 / 축소 된 티켓의 티켓 병합 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 소유자로 자동 설정 됨).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 메모 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 소유자로 자동 설정 됨).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 확대 / 축소 된 티켓의 티켓 소유자 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 소유자로 자동 설정 됨).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 소유자로 자동 설정 됨).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 인바운드 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정 됨).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 전화 아웃 바운드 화면에서 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정 됨).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 줌 된 티켓의 티켓 우선 순위 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 소유자로 자동 설정 됨).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 책임 화면에 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정됨).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '에이전트 인터페이스의 티켓 고객을 변경하기 위해 티켓 잠금이 필요한지 여부를 정의합니다 (티켓이 아직 잠겨 있지 않은 경우 티켓이 잠기고 현재 에이전트가 자동으로 소유자로 설정 됨).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '상담원이 기본 설정에 공유 암호가 저장되어 있지 않아 이중 인증을 사용하지 않는 경우 로그인을 허용해야하는지 여부를 정의합니다.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '공유 설정이 환경 설정에 저장되어 있지 않아 이중 인증을 사용하지 않는 경우 고객이 로그인 할 수 있도록 허용해야하는지 정의합니다.',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '클라우드 서비스를 제공하는이 시스템과 OTRS 그룹 서버 간의 통신이 가능한지 여부를 정의합니다. \'클라우드 서비스 사용 안 함\'으로 설정하면 시스템 등록, 지원 데이터 전송, OTRS Business Solution ™, OTRS Verify ™, OTRS News 및 제품 뉴스 대시 보드 위젯 등의 업그레이드 및 사용과 같은 일부 기능이 손실됩니다.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '고객 인터페이스에서 확장 모드를 사용해야하는지 (테이블, 바꾸기, 아래첨자, 위 첨자, 단어에서 붙여넣기 등 사용가능) 정의합니다.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '확장 모드를 사용해야하는지 정의합니다 (테이블, 바꾸기, 아래 첨자, 위 첨자, 단어 붙여 넣기 등 사용 가능).',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '첫 번째 기사를 확장된 것으로 표시할지, 관련 고객에게 표시할지 여부를 정의합니다. 아무것도 정의하지 않으면 최신 기사가 확장됩니다.',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '상담원 인터페이스의 전자 메일 아웃바운드 화면에 있는 메시지가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '상담원 인터페이스의 전자 메일 다시보내기 화면에 있는 메시지가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '고객이 기본적으로 에이전트 인터페이스의 티켓 작성 화면에 메시지가 표시되는지 여부를 정의합니다.',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '에이전트 인터페이스의 티켓 전달 화면에 있는 메시지가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '상담원 인터페이스의 닫기 티켓 화면에 있는 메모가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '에이전트 인터페이스의 티켓 대량 화면에 있는 노트가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '상담원 인터페이스의 티켓 프리 텍스트 화면에있는 노트가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '상담원 인터페이스의 티켓 메모 화면에있는 메모가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '에이전트 인터페이스의 티켓 소유자 화면에있는 노트가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '에이전트 인터페이스의 티켓 보류 화면에있는 메모가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '에이전트 인터페이스의 티켓 우선 순위화면에 있는 노트가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '에이전트 인터페이스의 티켓 담당 화면에 있는 노트가 기본적으로 고객에게 표시되는지 여부를 정의합니다.',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '이전에 유효한 토큰이 인증을 위해 수락되어야 하는지 여부를 정의합니다. 이는 보안이 다소 떨어지지만 사용자가 일회용 암호를 입력하는데 30초 이상 더 많은 시간을 줍니다.',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '사용 가능한 모든 티켓에서 필터 값을 검색해야하는지 여부를 정의합니다. 활성화 된 경우 실제로 티켓에서 사용되는 값만 필터링에 사용할 수 있습니다. 참고 : 고객 목록은 항상 이와 같이 검색됩니다.',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '상담원 인터페이스에서 시간 계산이 필수인지 정의합니다. 활성화 된 경우 모든 티켓 동작에 대해 노트를 입력해야 합니다 (노트 자체가 활성으로 구성되어 있거나 원래 개별 티켓 동작 화면에 필수적이든간에).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '일괄 처리로 시간 계산을 모든 티켓으로 설정해야하는지 여부를 정의합니다.',
        'Defines internal communication channel.' => '내부 통신 채널을 정의합니다.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '부재 중 메시지 템플릿을 정의합니다. 사용 가능한 두 개의 문자열 매개 변수 (%s) : 종료 날짜 및 남은 일 수.',
        'Defines phone communication channel.' => '전화 통신 채널을 정의합니다.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '달력 이벤트로 표시하기 위해 티켓을 사용하는 대기열을 정의합니다.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '\'PublicSupportDataCollector\'공용 모듈 (예 : OTRS 데몬에서 사용)을 사용하여 지원 데이터 수집을위한 HTTP 호스트 이름을 정의합니다.',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '로컬 저장소에 액세스하기위한 IP 정규식을 정의합니다. 이것을 사용하여 로컬 저장소에 액세스 할 수 있어야하며 패키지 :: RepositoryList가 원격 호스트에 필요합니다.',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '티켓의 현재 상태를 유지하기 위해 필터에 사용할 PostMaster 헤더를 정의합니다.',
        'Defines the URL CSS path.' => 'URL CSS 경로를 정의합니다.',
        'Defines the URL base path of icons, CSS and Java Script.' => '아이콘, CSS 및 Java Script의 URL 기본 경로를 정의합니다.',
        'Defines the URL image path of icons for navigation.' => '탐색을위한 아이콘의 URL 이미지 경로를 정의합니다.',
        'Defines the URL java script path.' => 'URL java 스크립트 경로를 정의합니다.',
        'Defines the URL rich text editor path.' => 'URL 서식있는 텍스트 편집기 경로를 정의합니다.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '필요한 경우 "CheckMXRecord"조회를 위해 전용 DNS 서버의 주소를 정의합니다.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '공유 비밀 키가 저장되는 에이전트 기본 설정 키를 정의합니다.',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '시간 선택에서 사용 가능한 단계를 정의합니다. 1-59까지 1 시간 동안 모든 분을 선택할 수 있으려면 "분"을 선택하십시오. 풀 30 시간 만 사용하려면 "30 Minutes"를 선택하십시오.',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '에이전트에 보내는 알림 메일의 본문 텍스트를 새 암호로 정의합니다.',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '에이전트에게 보낸 알림 메일의 본문 텍스트를 정의하고 요청된 새 비밀번호에 대한 토큰을 지정합니다.',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '새 계정에 대한 고객에게 발송된 알림메일의 본문 텍스트를 정의합니다.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '새 비밀번호에 대한 알림 메일의 본문 텍스트를 고객에게 전달합니다.',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '새로운 요청된 비밀번호에 대한 토큰과 함께 고객에게 발송된 통지 메일의 본문 텍스트를 정의합니다.',
        'Defines the body text for rejected emails.' => '거부된 전자 메일의 본문 텍스트를 정의합니다.',
        'Defines the calendar width in percent. Default is 95%.' => '달력의 너비를 백분율로 정의합니다. 기본값은 95%입니다.',
        'Defines the column to store the keys for the preferences table.' =>
            '환경 설정 테이블의 키를 저장할 열을 정의합니다.',
        'Defines the config options for the autocompletion feature.' => '자동 완성 기능의 구성 옵션을 정의합니다.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '환경 설정 보기에 표시할 이 항목의 구성 매개 변수를 정의합니다.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '환경 설정보기에 표시 할이 항목의 구성 매개 변수를 정의합니다. \'PasswordRegExp\'는 정규 표현식과 암호를 일치시킵니다. \'PasswordMinSize\'를 사용하여 최소 문자 수를 정의하십시오. 적절한 옵션을 \'1\'로 설정하여 최소한 2 개의 소문자와 2 개의 대문자가 필요한지 정의하십시오. \'PasswordMin2Characters\'는 암호가 2 자 이상의 문자 (0 또는 1로 설정)를 포함해야 하는지를 정의합니다. \'PasswordNeedDigit\'은 최소 1 자리 숫자의 필요성을 제어합니다 (제어하려면 0 또는 1로 설정). \'PasswordMaxLoginFailed\'는 최대 실패 로그인에 도달하면 에이전트를 유효하지 않게 임시로 설정할 수 있습니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '환경 설정보기에 표시 할이 항목의 구성 매개 변수를 정의합니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Defines the connections for http/ftp, via a proxy.' => '프록시를 통해 http / ftp에 대한 연결을 정의합니다.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '공유 비밀 키가 저장되는 고객 기본 설정 키를 정의합니다.',
        'Defines the date input format used in forms (option or input fields).' =>
            '양식 (옵션 또는 입력 필드)에 사용되는 날짜 입력 형식을 정의합니다.',
        'Defines the default CSS used in rich text editors.' => '서식있는 텍스트 편집기에 사용되는 기본 CSS를 정의합니다.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            '이 작업에 대한 아티클의 기본 자동 응답 유형을 정의합니다.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 비어있는 텍스트 화면에서 노트의 기본 본문을 정의합니다.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '고객 사용자 주소록 검색 (CustomerUser 또는 CustomerCompany)의 기본 필터 필드를 정의합니다. CustomerCompany 필드의 경우 접두사 \'CustomerCompany_\'를 추가해야합니다.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '에이전트 및 고객이 사용할 기본 프런트 엔드 (HTML) 테마를 정의합니다. 원한다면 자신 만의 테마를 추가 할 수 있습니다. https://doc.otrs.com/doc/ 에있는 관리자 설명서를 참조하십시오.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '기본 프런트 엔드 언어를 정의합니다. 가능한 모든 값은 시스템에서 사용 가능한 언어 파일에 의해 결정됩니다 (다음 설정 참조).',
        'Defines the default history type in the customer interface.' => '고객 인터페이스에서 기본 기록 유형을 정의합니다.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '시간 스케일에 대한 X 축 속성의 기본 최대 수를 정의합니다.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '개요 화면에서 페이지 당 기본 최대 통계 수를 정의합니다.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '고객 인터페이스에서 고객 후속 조치 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에서 메모를 추가한 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓없는 텍스트 화면에 메모를 추가한 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에 메모를 추가한 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 / 축소 된 티켓의 티켓 소유자 화면에 노트를 추가한 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대된 티켓의 티켓 보류 화면에 노트를 추가한 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대된 티켓의 티켓 우선 순위 화면에 노트를 추가한 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 메모를 추가한 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 바운스 화면에서 바운스 된 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전달 화면에서 전달된 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 전자 메일 아웃바운드 화면에서 메시지를 보낸 후 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 작성 화면에서 작성 / 응답된 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 티켓의 기본 다음 상태를 정의합니다.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 인바운드 화면에서 전화 티켓의 기본 노트 본문 텍스트를 정의합니다.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전화 아웃바운드 화면에서 전화 티켓의 기본 노트 본문 텍스트를 정의합니다.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '고객 인터페이스의 티켓 확대 / 축소 화면에서 후속 고객 티켓의 기본 우선 순위를 정의합니다.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '고객 인터페이스에서 새 고객 티켓의 기본 우선 순위를 정의합니다.',
        'Defines the default priority of new tickets.' => '새 티켓의 기본 우선순위를 정의합니다.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '고객 인터페이스에서 새 고객 티켓의 기본 큐를 정의합니다.',
        'Defines the default queue for new tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 티켓의 기본 대기열을 정의합니다.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '동적 객체의 드롭 다운 메뉴에서 기본 선택을 정의합니다 (형식 : 공통 사양).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '권한 (양식 : 공통 사양)에 대한 드롭 다운 메뉴에서 기본 선택을 정의합니다.',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '통계 형식 (양식 : 공통 사양)에 대한 드롭 다운 메뉴에서 기본 선택을 정의합니다. 형식 키를 삽입하십시오 (Stats :: Format 참조).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 인바운드 화면에서 전화 티켓의 기본 발신자 유형을 정의합니다.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전화 아웃바운드 화면에서 전화 티켓의 기본 발신자 유형을 정의합니다.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '고객 인터페이스의 티켓 확대 / 축소 화면에서 티켓의 기본 보낸 사람 유형을 정의합니다.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '티켓 검색 화면 (AllTickets / ArchivedTickets / NotArchivedTickets)에 대해 표시된 기본 티켓 검색 속성을 정의합니다.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '티켓 검색 화면에 대해 표시된 기본 티켓 검색 속성을 정의합니다.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '티켓 검색 화면에 대해 표시된 기본 티켓 검색 속성을 정의합니다. 예 : \'Key\'는 Dynamic Field의 이름을 가져야합니다. \'X\', \'Content\'는 동적 필드 유형, Text : \'a text\', 드롭 다운 : \'1\'에 따라 동적 필드의 값을 가져야합니다. , 날짜 / 시간 : \'Search_DynamicField_XTimeSlotStartYear = 1974; Search_DynamicField_XTimeSlotStartMonth = 01; Search_DynamicField_XTimeSlotStartDay = 26; Search_DynamicField_XTimeSlotStartHour = 00; Search_DynamicField_XTimeSlotStartMinute = 00; Search_DynamicField_XTimeSlotStartSecond = 00; Search_DynamicField_XTimeSlotStopYear = 2013; Search_DynamicField_XTimeSlotStopMonth = 01; Search_DynamicField_XTimeSlotStopDay = 26; Search_DynamicField_XTimeSlotStopHour = 23; Search_DynamicField_XTimeSlotStopMinute = 59; Search_DynamicField_XTimeSlotStopSecond = 59; \' and \'또는 Search_DynamicField_XTimePointFormat = 주; Search_DynamicField_XTimePointStart = 이전; Search_DynamicField_XTimePointValue = 7 \';',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '대기열 보기에 표시된 모든 대기열의 기본 정렬 기준을 정의합니다.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '서비스 보기에 표시된 모든 서비스에 대한 기본 정렬 기준을 정의합니다.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '우선 순위 정렬 후 대기열 보기의 모든 대기열에 대한 기본 정렬 순서를 정의합니다.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '우선 순위 정렬 후 서비스 보기의 모든 서비스에 대한 기본 정렬 순서를 정의합니다.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '고객 인터페이스에서 새 고객 티켓의 기본 상태를 정의합니다.',
        'Defines the default state of new tickets.' => '새 티켓의 기본 상태를 정의합니다.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 인바운드 화면에서 전화 티켓의 기본제목을 정의합니다.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전화 아웃바운드 화면에서 전화 티켓의 기본 제목을 정의합니다.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 프리 텍스트 화면에서 노트의 기본 제목을 정의합니다.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '일반적인 인터페이스 실패 작업을 다시 예약하기 위해 기본값 (현재 시간부터)을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '고객 인터페이스의 티켓 검색에서 티켓 정렬에 대한 기본 티켓 속성을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '에이전트 인터페이스의 에스컬레이션 보기에서 티켓 정렬에 대한 기본 티켓 속성을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '에이전트 인터페이스의 잠긴 티켓 보기에서 티켓 정렬에 대한 기본 티켓 속성을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '에이전트 인터페이스의 담당 뷰에서 티켓 정렬에 대한 기본 티켓 속성을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '에이전트 인터페이스의 상태 보기에서 티켓 정렬에 대한 기본 속성을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '에이전트 인터페이스의 보기에서 티켓 정렬에 대한 기본 티켓 속성을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '에이전트 인터페이스의 티켓 검색 결과에 대한 티켓 정렬을 위한 기본 티켓 속성을 정의합니다.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '이 작업의 티켓 검색 결과에 대한 티켓 정렬을 위한 기본 티켓 특성을 정의합니다.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 바운스 화면에서 고객 / 발신자에 대한 기본 티켓 반송 알림을 정의합니다.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 인바운드 화면에 전화 메모를 추가한 후 기본 티켓 다음 상태를 정의합니다.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 폰 아웃바운드 화면에 전화 메모를 추가한 후 기본 티켓 다음 상태를 정의합니다.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '에이전트 인터페이스의 에스컬레이션보기에서 기본 티켓 순서 (우선 순위 정렬 후)를 정의합니다. 위로 : 가장 오래된 것. 아래 : 위에 최신.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '에이전트 인터페이스의 상태보기에서 기본 티켓 순서 (우선 순위 정렬 후)를 정의합니다. 위로 : 가장 오래된 것. 아래 : 위에 최신.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '에이전트 인터페이스의 담당 뷰에서 기본 티켓 순서를 정의합니다. 위로 : 가장 오래된 것. 아래 : 위에 최신.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '에이전트 인터페이스의 티켓 잠김보기에서 기본 티켓 순서를 정의합니다. 위로 : 가장 오래된 것. 아래 : 위에 최신.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '에이전트 인터페이스의 티켓 검색 결과에서 기본 티켓 순서를 정의합니다. 위로 : 가장 오래된 것. 아래 : 위에 최신.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '이 작업의 티켓 검색 결과에서 기본 티켓 순서를 정의합니다. 위로 : 가종 오래된 것. 아래 : 위에 최신',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '에이전트 인터페이스의보기보기에서 기본 티켓 순서를 정의합니다. 위로 : 가장 오래된 것. 아래 : 위에 최신.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '고객 인터페이스에서 검색 결과의 기본 티켓 순서를 정의합니다. 위로 : 가장 오래된 것. 아래 : 위에 최신.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓없는 텍스트 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대된 티켓의 티켓 소유자 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대/축소된  티켓의 티켓 보류 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대된 티켓의 티켓우선순위 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에서 기본 티켓 우선 순위를 정의합니다.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '고객 인터페이스에서 새 고객 티켓의 기본 티켓 유형을 정의합니다.',
        'Defines the default ticket type.' => '기본 티켓 유형을 정의합니다.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '에이전트 인터페이스의 url에 Action 매개 변수가 지정되지 않은 경우 사용 된 기본 프론트 엔드 모듈을 정의합니다.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '고객 인터페이스의 URL에 Action 매개 변수가 지정되지 않은 경우 사용 된 기본 프론트 엔드 모듈을 정의합니다.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'public frontend에 대한 action 매개 변수의 기본값을 정의합니다. action 매개 변수는 시스템의 스크립트에서 사용됩니다.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '티켓의 기본 볼 수있는 보낸 사람 유형을 정의합니다 (기본값 : 고객).',
        'Defines the default visibility of the article to customer for this operation.' =>
            '이 작업을 위해 고객에게 기사의 기본 가시성을 정의합니다.',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '달력 이벤트에 표시하는데 사용되는 동적 필드를 정의합니다.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            'AdminAppointmentNotificationEvent를 통해 처리 할 이벤트 객체 유형을 정의합니다.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'fetchmail 바이너리를 여는 폴백 경로를 정의합니다. 참고 : 바이너리의 이름은 \'fetchmail\'이어야하며, 다른 경우 심볼릭 링크를 사용하십시오.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'URL을 강조 표시하기 위해 기사의 텍스트를 처리하는 필터를 정의합니다.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '에이전트 인터페이스 ([% Data.OrigFrom | html %]는 From 1 : 1, [% Data.OrigFromName | html %]는 From의 실제 이름 임)의 티켓 작성 화면에서 응답 형식을 정의합니다.',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '시스템의 정규화 된 도메인 이름을 정의합니다. 이 설정은 응용 프로그램에서 사용하는 모든 형식의 메시징에있는 변수 인 OTRS_CONFIG_FQDN으로 사용되어 시스템 내의 티켓에 대한 링크를 만듭니다.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '모든 고객 사용자가있을 그룹을 정의합니다 (CustomerGroupSupport가 사용 가능하고이 그룹에 대한 모든 고객 사용자를 관리하지 않으려는 경우).',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '모든 고객이 속할 그룹을 정의합니다 (CustomerGroupSupport가 사용 가능하고이 그룹의 모든 고객을 관리하지 않으려는 경우).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '이 화면의 서식있는 텍스트 편집기 구성 요소의 높이를 정의합니다. 숫자 (픽셀) 또는 퍼센트 값 (상대)을 입력하십시오.',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '서식있는 텍스트 편집기 구성 요소의 높이를 정의합니다. 숫자 (픽셀) 또는 퍼센트 값 (상대)을 입력하십시오.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 닫기 티켓 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 기록에 사용되는 전자 메일 티켓 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 티켓 인터페이스에서 티켓 기록에 사용되는 전화 티켓 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '티켓 기록에 사용되는 티켓 비어있는 텍스트 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 메모 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 기록에 사용되는 티켓 소유자 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 기록에 사용되는 티켓 보류 화면 조치에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 전화 인바운드 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 전화 아웃 바운드 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 우선 순위 화면 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 책임 화면 조치에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '고객 인터페이스에서 티켓 기록에 사용되는 티켓 확대 작업에 대한 기록 주석을 정의합니다.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는이 작업의 기록 주석을 정의합니다.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 닫기 화면 작업의 기록 유형을 정의합니다.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 기록에 사용되는 전자 메일 티켓 화면 작업의 기록 유형을 정의합니다.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 티켓 인터페이스에서 티켓 기록에 사용되는 전화 티켓 화면 작업의 기록 유형을 정의합니다.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '티켓 기록에 사용되는 티켓 비어있는 텍스트 화면 조치에 대한 기록 유형을 정의합니다.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 메모 화면 작업의 기록 유형을 정의합니다.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스 화면의 티켓 기록에 사용되는 티켓 소유자 화면 작업의 기록 유형을 정의합니다.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 히스토리에 사용되는 티켓 보류 화면 조치의 히스토리 유형을 정의합니다.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '티켓 인터페이스 인바운드 화면 작업에 대한 기록 유형을 정의합니다.이 기록은 에이전트 인터페이스의 티켓 기록에 사용됩니다.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 전화 아웃 바운드 화면 작업의 기록 유형을 정의합니다.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 우선 순위 화면 작업의 기록 유형을 정의합니다.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는 티켓 책임 화면 조치의 히스토리 유형을 정의합니다.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '고객 인터페이스의 티켓 기록에 사용되는 티켓 확대 / 축소 작업의 기록 유형을 정의합니다.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '에이전트 인터페이스의 티켓 기록에 사용되는이 작업의 기록 유형을 정의합니다.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '작업 시간을 계산하기 위해 표시된 달력의 시간과 요일을 정의합니다.',
        'Defines the hours and week days to count the working time.' => '근무 시간을 계산할 시간과 요일을 정의합니다.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Kernel :: Modules :: AgentInfo 모듈로 확인할 키를 정의합니다. 이 사용자 기본 설정 키가 true이면 시스템에서 메시지를 수락합니다.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'CustomerAccept로 확인할 키를 정의합니다. 이 사용자 기본 설정 키가 true이면 시스템에서 메시지를 수락합니다.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '\'Normal\'링크 유형을 정의합니다. 소스 이름과 대상 이름이 동일한 값을 포함하면 결과 링크는 비 방향성 링크입니다. 그렇지 않은 경우 결과는 방향 링크입니다.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '링크 유형 \'ParentChild\'를 정의합니다. 소스 이름과 대상 이름이 동일한 값을 포함하면 결과 링크는 비 방향성 링크입니다. 그렇지 않은 경우 결과는 방향 링크입니다.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '링크 유형 그룹을 정의합니다. 같은 그룹의 링크 유형은 서로 취소합니다. 예 : 항공권 A가 티켓 B와 \'일반\'링크별로 링크 된 경우이 티켓을 \'ParentChild\'관계의 링크와 추가로 연결할 수 없습니다.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '온라인 리포지토리의 목록을 정의합니다. 다른 설치를 저장소로 사용할 수 있습니다 예 : Key= "http://example.com/otrs/public.pl?Action=PublicRepository;File= "and Content="Some Name".',
        'Defines the list of params that can be passed to ticket search function.' =>
            '티켓 검색 기능에 전달할 수있는 매개변수의 목록을 정의합니다.',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '오류 화면에서 가능한 다음 작업 목록을 정의하고 전체 경로가 필요하며 필요한 경우 외부 링크를 추가할 수 있습니다.',
        'Defines the list of types for templates.' => '템플릿의 유형 목록을 정의합니다.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '추가 패키지 온라인 저장소 목록을 가져올 위치를 정의합니다. 첫 번째 가능한 결과가 사용됩니다.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '시스템의 로그 모듈을 정의합니다. "파일"은 주어진 로그 파일에 모든 메시지를 쓰고 "syslog"는 시스템의 syslog 데몬을 사용합니다. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '브라우저를 통한 파일 업로드의 최대 크기 (바이트)를 정의합니다. 경고 :이 옵션을 너무 낮은 값으로 설정하면 OTRS 인스턴스의 많은 마스크가 작동을 멈출 수 있습니다 (사용자가 입력 한 마스크 일 가능성이 있음).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '세션 ID의 최대 유효 시간 (초)을 정의합니다.',
        'Defines the maximum number of affected tickets per job.' => '작업 당 영향을 받는 티켓의 최대 수를 정의합니다.',
        'Defines the maximum number of pages per PDF file.' => 'PDF 파일 당 최대 페이지 수를 정의합니다.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '응답에 추가할 따옴표 붙은 최대 줄 수를 정의합니다.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '같은 시간에 실행될 최대 작업 수를 정의합니다.',
        'Defines the maximum size (in MB) of the log file.' => '로그 파일의 최대 크기 (MB)를 정의합니다.',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'gi_debugger_entry_content 테이블에 기록되는 GenericInterface 응답의 최대 크기를 KiloByte로 정의합니다.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '에이전트 인터페이스에서 일반 알림을 표시하는 모듈을 정의합니다. "텍스트"- 구성된 경우 - 또는 "파일"의 내용이 표시됩니다.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '에이전트 인터페이스에 현재 로그인 되어 있는 모든 에이전트를 표시하는 모듈을 정의합니다.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '에이전트 인터페이스에 현재 로그인 한 모든 고객을 표시하는 모듈을 정의합니다.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '현재 로그인 한 상담원을 고객 인터페이스에 표시하는 모듈을 정의합니다.',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '현재 로그인 한 고객을 고객 인터페이스에 표시하는 모듈을 정의합니다.',
        'Defines the module to authenticate customers.' => '고객을 인증할 모듈을 정의합니다.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '클라우드 서비스가 비활성화 된 경우 알림을 표시할 모듈을 정의합니다.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'OTRS Business Solution ™의 여러 경우에 서로 다른 인터페이스에 알림을 표시 할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            'OTRS 데몬이 실행되고 있지 않은 경우 에이전트 인터페이스에 알림을 표시 할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '시스템 구성이 동기화되지 않은 경우 에이전트 인터페이스에 알림을 표시 할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '에이전트가 아직 시간대를 선택하지 않은 경우 에이전트 인터페이스에 알림을 표시할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '에이전트가 부재중 상태로 로그인되어 있는 경우 에이전트 인터페이스에 알림을 표시할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '시스템 유지 관리가 활성화 된 상태에서 에이전트가 로그인 한 경우 에이전트 인터페이스에 알림을 표시할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '에이전트 세션 제한 사전 경고에 도달하면 에이전트 인터페이스에 알림을 표시 할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '관리자 사용자가 시스템을 사용하는 경우 에이전트 인터페이스에 알림을 표시 할 모듈을 정의합니다 (일반적으로 관리자로 사용하면 안 됨).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '잘못된 sysconfig 설정이 배포 된 경우 에이전트 인터페이스에 알림을 표시 할 모듈을 정의합니다.',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '아직 배포되지 않은 수정 된 sysconfig 설정이있는 경우 에이전트 인터페이스에 알림을 표시 할 모듈을 정의합니다.',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '시스템 유지 보수가 활성화 된 상태에서 고객이 로그인 한 경우 고객 인터페이스에 알림을 표시 할 모듈을 정의합니다.',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '고객 사용자가 아직 시간대를 선택하지 않은 경우 고객 인터페이스에 알림을 표시할 모듈을 정의합니다.',
        'Defines the module to generate code for periodic page reloads.' =>
            '정기적 페이지 제로드를 위한 코드를 생성하는 모듈을 정의합니다.',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '세션 데이터를 저장하는 데 사용되는 모듈을 정의합니다. "DB"를 사용하면 프론트 엔드 서버를 db 서버에서 분리 할 수 ​​있습니다. "FS"가 빠릅니다.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '웹 인터페이스, 탭 및 웹 브라우저의 제목 표시 줄에 표시된 응용 프로그램의 이름을 정의합니다.',
        'Defines the name of the column to store the data in the preferences table.' =>
            '환경 설정 테이블에 데이터를 저장할 열의 이름을 정의합니다.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '환경 설정 테이블에 사용자 식별자를 저장할 열의 이름을 정의합니다.',
        'Defines the name of the indicated calendar.' => '표시된 달력의 이름을 정의합니다.',
        'Defines the name of the key for customer sessions.' => '고객 세션의 키 이름을 정의합니다.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '세션 키의 이름을 정의합니다. 예 : 세션, 세션 ID 또는 OTRS.',
        'Defines the name of the table where the user preferences are stored.' =>
            '사용자 기본 설정이 저장된 테이블의 이름을 정의합니다.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 작성 화면에서 티켓을 작성 / 응답한 후 가능한 다음 상태를 정의합니다.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전달 화면에서 티켓을 전달한 후 가능한 다음 상태를 정의합니다.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 전자 메일 아웃바운드 화면에서 메시지를 보낸 후 가능한 다음 상태를 정의합니다.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '고객 인터페이스에서 고객 티켓에 대한 다음 가능한 상태를 정의합니다.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에서 메모를 추가한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓없는 텍스트 화면에 메모를 추가한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 메모를 추가 한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 소유자 화면에 노트를 추가 한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 보류 화면에 노트를 추가 한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 우선 순위 화면에 노트를 추가 한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 메모를 추가 한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 바운스 화면에서 바운스 된 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면에서 다른 대기열로 이동 한 후 티켓의 다음 상태를 정의합니다.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 티켓의 다음 상태를 정의합니다.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'EventNotifications에 대한 TemplateGenerator의 HTML 기사 미리보기 바꾸기에 사용되는 줄당 문자 수를 정의합니다.',
        'Defines the number of days to keep the daemon log files.' => '데몬 로그 파일을 보관할 기간을 정의합니다.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '포스트 마스터 필터 추가 및 업데이트를 위한 프론트 엔드 모듈의 헤더 필드 수를 정의합니다. 최대 99개의 필드가 가능합니다.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '통신이 저장될 시간을 분으로 정의합니다',
        'Defines the number of hours a successful communication will be stored.' =>
            '성공적인 통신을 저장할 시간을 정의합니다.',
        'Defines the parameters for the customer preferences table.' => '고객 환경 설정 테이블의 매개 변수를 정의합니다.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '대시 보드 백엔드의 매개 변수를 정의합니다. "Cmd"는 매개 변수가있는 명령을 지정하는 데 사용됩니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 또는 사용자가 수동으로 활성화해야하는지 여부를 나타냅니다. "CacheTTL"은 플러그인의 캐시 만기 기간을 나타냅니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '대시 보드 백엔드의 매개 변수를 정의합니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 또는 사용자가 수동으로 활성화해야하는지 여부를 나타냅니다. "CacheTTL"은 플러그인의 캐시 만기 기간을 나타냅니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '대시 보드 백엔드의 매개 변수를 정의합니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 또는 사용자가 수동으로 활성화해야하는지 여부를 나타냅니다. "CacheTTLLocal"은 플러그인의 캐시 만기 기간을 분 단위로 정의합니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '대시 보드 백엔드의 매개 변수를 정의합니다. "제한"은 기본적으로 표시되는 항목 수를 정의합니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 또는 사용자가 수동으로 활성화해야하는지 여부를 나타냅니다. "CacheTTL"은 플러그인의 캐시 만기 기간을 나타냅니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '대시 보드 백엔드의 매개 변수를 정의합니다. "제한"은 기본적으로 표시되는 항목 수를 정의합니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 또는 사용자가 수동으로 활성화해야하는지 여부를 나타냅니다. "CacheTTLLocal"은 플러그인의 캐시 만기 기간을 분 단위로 정의합니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAP 핸들 (bin / cgi-bin / rpc.pl)에 액세스하기위한 암호를 정의합니다.',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'PDF 문서에서 굵은 기울임 꼴 고정 폭 글꼴을 처리 할 경로와 TTF-File을 정의합니다.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'PDF 문서에서 굵은 기울임 꼴 비례 글꼴을 처리 할 경로와 TTF-File을 정의합니다.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'PDF 문서에서 굵은 고정 폭 글꼴을 처리 할 경로와 TTF-File을 정의합니다.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'PDF 문서에서 굵은 글꼴을 처리 할 경로와 TTF 파일을 정의합니다.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'PDF 문서에서 이탤릭체로 고정 폭 글꼴을 처리 할 경로와 TTF 파일을 정의합니다.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'PDF 문서에서 기울임 꼴 비례 글꼴을 처리 할 경로와 TTF-File을 정의합니다.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'PDF 문서에서 고정 폭 글꼴을 처리 할 경로와 TTF-File을 정의합니다.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'PDF 문서에서 비례 글꼴을 처리 할 경로와 TTF-File을 정의합니다.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'Kernel / Output / HTML / Templates / Standard / CustomerAccept.tt에있는 표시된 정보 파일의 경로를 정의합니다.',
        'Defines the path to PGP binary.' => 'PGP 바이너리 경로를 정의합니다.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'ssl 바이너리를 여는 경로를 정의합니다. HOME 환경 변수 ($ ENV {HOME} = \'/ var / lib / wwwrun\';)가 필요합니다.',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '비활성 상태 (예 : \'로그인 사용자\'위젯 또는 채팅)로 인해 상담원이 \'자리 비움\'으로 표시되기까지의 시간 (분)을 정의합니다.',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '비활성 상태 (예 : \'로그인 사용자\'위젯 또는 채팅)로 인해 고객이 \'자리 비움\'으로 표시되기까지의 시간 (분)을 정의합니다.',
        'Defines the postmaster default queue.' => '전자 메일 관리자 기본 큐를 정의합니다.',
        'Defines the priority in which the information is logged and presented.' =>
            '정보가 기록되고 표시되는 우선 순위를 정의합니다.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '에이전트 티켓에서 전화 티켓의받는 사람 대상과 전자 메일 티켓의 보낸 사람을 정의합니다 ( "대기열"은 모든 대기열을 나타내며 "시스템 주소"는 모든 시스템 주소를 표시합니다).',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '티켓의 수신자 대상을 정의합니다 ( "대기열"은 모든 대기열을 나타내며 "시스템 주소"는 시스템 주소에 할당 된 대기열 만 표시 함).',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '에이전트 인터페이스의 에스컬레이션 보기에 티켓을 표시하는데 필요한 권한을 정의합니다.',
        'Defines the search limit for the stats.' => '통계에 대한 검색 제한을 정의합니다.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            'AgentCustomerUserAddressBook 화면에 대한 검색 매개 변수를 정의합니다. \'CustomerTicketTextField\'설정을 사용하면받는 사람 필드의 값을 지정할 수 있습니다.',
        'Defines the sender for rejected emails.' => '거부된 전자메일에 대한 보낸 사람을 정의합니다.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '에이전트 실명과 주어진 대기열 전자메일 주소 사이의 구분 기호를 정의합니다.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            'AgentCustomerUserAddressBook 결과 화면에 표시된 열과 위치를 정의합니다.',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '응용 프로그램 내에서 고객이 사용할 수있는 표준 사용 권한을 정의합니다. 더 많은 권한이 필요하면 여기에 입력 할 수 있습니다. 사용 권한은 효과적 이도록 하드 코딩해야합니다. 앞서 언급 한 권한 중 하나를 추가 할 때 "rw"권한이 마지막 항목으로 남아 있는지 확인하십시오.',
        'Defines the standard size of PDF pages.' => 'PDF 페이지의 표준 크기를 정의합니다.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '후속 조치를 받았고 티켓이 이미 폐쇄된 경우 티켓의 상태를 정의합니다.',
        'Defines the state of a ticket if it gets a follow-up.' => '후속 조치를 받는 티켓의 상태를 정의합니다.',
        'Defines the state type of the reminder for pending tickets.' => '보류 중인 티켓에 대한 미리 알림의 상태 유형을 정의합니다.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '에이전트에 보내는 알림 메일의 제목과 새 암호를 정의합니다.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '에이전트에게 보낸 알림 메일의 제목을 정의하고 요청 된 새 비밀번호에 대한 토큰을 사용합니다.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '새 계정에 대한 고객에게 발송된 알림 메일 제목을 정의합니다.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '고객에게 보낸 알림 메일 제목과 새 비밀번호를 정의합니다.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '새로운 요청된 비밀번호에 대한 토큰과 함께 고객에게 발송된 통지 메일의 제목을 정의합니다.',
        'Defines the subject for rejected emails.' => '거부된 전자메일의 제목을 정의합니다.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '시스템 관리자의 전자 메일 주소를 정의합니다. 응용 프로그램의 오류 화면에 표시됩니다.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '시스템 식별자를 정의합니다. 모든 티켓 번호와 http 세션 문자열에는이 ID가 들어 있습니다. 이렇게하면 시스템에 속한 티켓 만 후속 조치로 처리됩니다 (OTRS의 두 인스턴스간에 통신 할 때 유용함).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '외부 고객 데이터베이스 링크의 대상 속성을 정의합니다. 예 : \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '외부 고객 데이터베이스 링크의 대상 속성을 정의합니다. 예 : \'target = "cdb"\'.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '티켓 동적 필드 날짜 시간에 대한 티켓 약속 유형 백엔드를 정의합니다.',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '티켓 에스컬레이션 시간에 대한 티켓 약속 유형 백엔드를 정의합니다.',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '티켓 보류 시간에 대한 티켓 약속 유형 백엔드를 정의합니다.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '달력 이벤트를 표시 할 티켓 필드를 정의합니다. "Key"는 필드 또는 티켓 속성을 정의하고 "Content"는 표시 이름을 정의합니다.',
        'Defines the ticket plugin for calendar appointments.' => '일정 약속을 위한 티켓 플러그인을 정의합니다.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '지정된 일정에 나중에 할당할 수 있는 지정된 달력의 표준 시간대를 정의합니다.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '공개 모듈 \'PublicSupportDataCollector\'(예 : OTRS 데몬에서 사용)를 사용하여 지원 데이터 수집에 대한 시간 초과 (최소, 20 초)를 정의합니다.',
        'Defines the two-factor module to authenticate agents.' => '에이전트를 인증할 2요소 모듈을 정의합니다.',
        'Defines the two-factor module to authenticate customers.' => '고객을 인증할 2요소 모듈을 정의합니다.',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '응용 프로그램을 제공하기 위해 웹 서버에서 사용하는 프로토콜 유형을 정의합니다. https 프로토콜이 일반 http 대신 사용되는 경우 여기에 지정해야합니다. 이것은 웹 서버의 설정이나 동작에 영향을 미치지 않으므로 응용 프로그램에 대한 액세스 방법을 변경하지 않으며, 틀린 경우 응용 프로그램에 로그인하지 못하게하지 않습니다. 이 설정은 응용 프로그램에서 사용하는 모든 형식의 메시징에서 찾을 수있는 OTRS_CONFIG_HttpType 변수로만 사용되어 시스템 내의 티켓에 대한 링크를 만듭니다.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '에이전트 인터페이스의 티켓 작성 화면에서 일반 텍스트 전자 메일 따옴표에 사용되는 문자를 정의합니다. 비어 있거나 비활성 인 경우 원래 이메일은 인용되지 않고 응답에 추가됩니다.',
        'Defines the user identifier for the customer panel.' => '고객 패널에 대한 사용자 ID를 정의합니다.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'SOAP 핸들 (bin / cgi-bin / rpc.pl)에 액세스하기위한 사용자 이름을 정의합니다.',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '사용자 아바타를 정의합니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '잠금 해제 된 티켓의 유효한 상태를 정의합니다. 티켓의 잠금을 해제하려면 "bin / otrs.Console.pl Maint :: Ticket :: UnlockTimeout"스크립트를 사용할 수 있습니다.',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '티켓의 표시 가능 잠금을 정의합니다. 참고 :이 설정을 변경할 때 새 값을 사용하려면 캐시를 삭제해야합니다. 기본값 : 잠금 해제, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '이 화면의 서식있는 텍스트 편집기 구성 요소의 너비를 정의합니다. 숫자 (픽셀) 또는 퍼센트 값 (상대)을 입력하십시오.',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '서식있는 텍스트 편집기 구성 요소의 너비를 정의합니다. 숫자 (픽셀) 또는 퍼센트 값 (상대)을 입력하십시오.',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '만료된 것으로 간주되기 전에 지정된 유형의 초안에 대한 최종 수정 이후의 시간을 분으로 정의합니다.',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '전체 텍스트 검색을 위해 보관된 티켓의 색인을 생성할지 여부를 정의합니다.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '티켓 미리보기에 표시할 기사 발신자 유형을 정의합니다.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'ACL 구조의 세 번째 레벨에서 \'작업\'에 사용할 수있는 항목을 정의합니다.',
        'Defines which items are available in first level of the ACL structure.' =>
            'ACL 구조의 첫 번째 레벨에서 사용할 수있는 항목을 정의합니다.',
        'Defines which items are available in second level of the ACL structure.' =>
            'ACL 구조의 두 번째 레벨에서 사용할 수있는 항목을 정의합니다.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '보류 상태 (키)에 도달 한 후 자동으로 설정할 상태 (내용)를 정의합니다.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '티켓 상태 유형이 링크된 티켓 목록에 나열되어서는 안되는 티켓을 정의합니다.',
        'Delete expired cache from core modules.' => '만료된 캐시를 코어 모듈에서 삭제하십시오.',
        'Delete expired loader cache weekly (Sunday mornings).' => '매주 만료된 로더 캐시를 삭제하십시오 (일요일 오전).',
        'Delete expired sessions.' => '만료된 세션을 삭제하십시오.',
        'Delete expired ticket draft entries.' => '만료된 티켓 초안 항목을 삭제하십시오.',
        'Delete expired upload cache hourly.' => '만료된 업로드 캐시를 매시간 삭제하십시오.',
        'Delete this ticket' => '이 티켓 삭제',
        'Deleted link to ticket "%s".' => 'Deleted link to ticket "%s".',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '세션 ID가 유효하지 않은 원격 IP주소와 함께 사용되면 세션을 삭제합니다.',
        'Deletes requested sessions if they have timed out.' => '요청한 세션이 시간 초과된 경우 삭제합니다.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '활성화 된 경우 AJAX 오류가 발생할 경우 프론트 엔드에 확장 디버깅 정보를 제공합니다.',
        'Deploy and manage OTRS Business Solution™.' => 'OTRS Business Solution ™ 배포 및 관리',
        'Detached' => '분리된',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '링크를 삭제할 버튼이 각 줌 마스크의 각 링크 옆에 표시되어야 하는지 여부를 결정합니다.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '티켓으로 이동할 수있는 대기열 목록을 드롭 다운 목록이나 에이전트 인터페이스의 새 창에 표시할지 결정합니다. "새 창"이 설정되면 티켓에 이동 노트를 추가 할 수 있습니다.',
        'Determines if the statistics module may generate ticket lists.' =>
            '통계 모듈이 티켓 목록을 생성할 수 있는지 여부를 결정합니다.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '에이전트 인터페이스에서 새 전자 메일 티켓을 만든 후 가능한 다음 티켓 상태를 결정합니다.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '에이전트 인터페이스에서 새 전화 티켓을 만든 후 가능한 다음 티켓 상태를 결정합니다.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '에이전트 인터페이스에서 프로세스 티켓에 대한 다음 가능한 티켓 상태를 결정합니다.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '고객 인터페이스의 프로세스 티켓에 대한 다음 가능한 티켓 상태를 결정합니다.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '고객 인터페이스에서 새 고객 티켓 다음 화면을 결정합니다.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '고객 인터페이스에서 확대 된 티켓의 후속 화면 이후의 다음 화면을 결정합니다.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '티켓을 이동 한 후 다음 화면을 결정합니다. LastScreenOverview는 마지막 개요 화면 (예 : 검색 결과, 대기열보기, 대시 보드)을 반환합니다. TicketZoom은 TicketZoom으로 돌아갑니다.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '제한 시간에 도달한 후 상태가 변경된 보류중인 티켓의 가능한 상태를 결정합니다.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '에이전트 티켓에서 전화 티켓의받는 사람 (To :) 및 전자 메일 티켓의 보낸 사람 (From :)으로 표시 될 문자열을 결정합니다. Queue as NewQueueSelectionType "1"은 대기열의 이름을 표시하고 SystemAddress의 "2 3"은받는 사람의 이름과 전자 메일을 표시합니다.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '고객 인터페이스에서 티켓의받는 사람 (To :)으로 표시 될 문자열을 결정합니다. Queue는 CustomerPanelSelectionType으로, "1"은 대기열의 이름을 표시하고 SystemAddress의 경우 "2 3"은 수신자의 이름과 전자 메일을 표시합니다.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '링크된 개체가 각 줌 마스크에 표시되는 방식을 결정합니다.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '상담원 인터페이스에서 수신자 (전화 티켓) 및 발신자 (전자 메일 티켓)에 대해 유효한 옵션을 결정합니다.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '고객 인터페이스에서 티켓의 수신인에 대해 유효한 대기열을 결정합니다.',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '외부 스크립트 내용로드를 허용하려면 HTTP 헤더 "Content-Security-Policy"를 비활성화하십시오. 이 HTTP 헤더를 비활성화하면 보안 문제가 발생할 수 있습니다! 자신이하는 일을 아는 경우에만 사용을 중지하십시오!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'HTTP 헤더 "X-Frame-Options : SAMEORIGIN"을 사용하지 않도록 설정하여 OTRS를 다른 웹 사이트의 IFrame으로 포함 할 수 있습니다. 이 HTTP 헤더를 비활성화하면 보안 문제가 발생할 수 있습니다! 자신이하는 일을 아는 경우에만 사용을 중지하십시오!',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => '클라우드 서비스 사용 중지',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '책임있는 에이전트에게 티켓 알림을 보내는 것을 비활성화합니다 (Ticket :: Responsible을 활성화해야합니다).',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '시스템이 하이재킹되지 않도록 웹 설치 프로그램 (http://yourhost.example.com/otrs/installer.pl)을 비활성화합니다. 사용하도록 설정하지 않으면 시스템을 다시 설치하고 현재 기본 구성을 사용하여 설치 프로그램 스크립트에서 질문을 미리 채 웁니다. 활성화 된 경우 GenericAgent, PackageManager 및 SQL Box도 비활성화됩니다.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '전체 텍스트 검색 내에서 중지 단어를 사용할 때 경고를 표시하고 검색을 차단합니다.',
        'Display communication log entries.' => '통신 로그 항목을 표시하십시오.',
        'Display settings to override defaults for Process Tickets.' => '프로세스 티켓의 기본값을 대체하는 설정 표시.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '티켓 확대보기에서 기사의 계정 시간을 표시합니다.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '티켓 확대보기에서 현재 티켓과 동일한 CustomerID를 가진 모든 티켓 수를 표시합니다.',
        'Down' => '하위',
        'Dropdown' => '쓰러지다',
        'Dutch' => '네덜란드 사람',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '전체 텍스트 색인에 대한 네덜란드어 중지 단어. 이 단어는 검색 색인에서 제거됩니다.',
        'Dynamic Fields Checkbox Backend GUI' => '동적 필드 확인란 백엔드 GUI',
        'Dynamic Fields Date Time Backend GUI' => '동적 필드 날짜 시간 백엔드 GUI',
        'Dynamic Fields Drop-down Backend GUI' => '동적 필드 드롭 다운 백엔드 GUI',
        'Dynamic Fields GUI' => '동적 필드 GUI',
        'Dynamic Fields Multiselect Backend GUI' => '동적 필드 다중 선택 백엔드 GUI',
        'Dynamic Fields Overview Limit' => '동적 필드 개요 제한',
        'Dynamic Fields Text Backend GUI' => '동적 필드 텍스트 백엔드 GUI',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '검색 결과를 CSV 형식으로 내보내는 데 사용되는 동적 필드입니다.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '프로세스 위젯의 동적 필드 그룹. 키는 그룹의 이름이고, 값은 표시 할 필드를 포함합니다. 예 : \'Key => My Group\', \'Content : Name_X, NameY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '동적 필드 개요에 대한 페이지 당 동적 필드 제한',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '동적 필드 옵션은 고객 인터페이스의 티켓 메시지 화면에 표시됩니다. 노트. 이러한 필드를 고객 인터페이스의 티켓 확대에도 표시하려면 CustomerTicketZoom ### DynamicField에서 활성화해야합니다.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '동적 필드 옵션은 고객 인터페이스의 티켓 확대 / 축소 화면에서 티켓 응답 섹션에 표시됩니다.',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 전자 메일 아웃바운드 화면에 표시되는 동적 필드입니다.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 확대 / 축소 화면에서 프로세스 위젯에 표시되는 동적 필드입니다.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 확대 / 축소 화면의 사이드 바에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 작성 화면에 표시된 동적 필드',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전자 메일 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전달 화면에 표시되는 동적 필드입니다.',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 프리 텍스트 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 중간 형식 개요 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면에 표시된 동적 필드',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '동적 인터페이스는 고객 인터페이스의 티켓 개요 화면에 표시됩니다.',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 소유자 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 보류 화면에 표시되는 동적 필드입니다.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전화 인바운드 화면에 표시되는 동적 필드입니다.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전화 아웃바운드 화면에 표시되는 동적 필드입니다.',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 전화 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 미리보기 형식 개요 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 인쇄 화면에 표시되는 동적 필드.',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '동적 인터페이스는 고객 인터페이스의 티켓 인쇄 화면에 표시됩니다.',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 우선 순위 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 담당 화면에 표시되는 동적 필드입니다.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '고객 인터페이스의 티켓 검색 개요 결과 화면에 표시된 동적 필드.',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 검색 화면에 표시되는 동적 필드.',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '동적 필드는 고객 인터페이스의 티켓 검색 화면에 표시됩니다.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 소형 형식 개요 화면에 표시된 동적 필드입니다.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '동적 인터페이스는 고객 인터페이스의 티켓 확대 / 축소 화면에 표시됩니다.',
        'DynamicField' => 'DynamicField',
        'DynamicField backend registration.' => 'DynamicField 백엔드 등록.',
        'DynamicField object registration.' => 'DynamicField 개체 등록.',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => '전자 메일 아웃 바운드',
        'Edit Customer Companies.' => '고객 회사 편집.',
        'Edit Customer Users.' => '고객 사용자 편집.',
        'Edit appointment' => '약속 편집',
        'Edit customer company' => '고객 회사 편집',
        'Email Addresses' => '이메일 주소',
        'Email Outbound' => '이메일 발신',
        'Email Resend' => '이메일 재전송',
        'Email communication channel.' => '이메일 커뮤니케이션 채널.',
        'Enable highlighting queues based on ticket age.' => '티켓 수명에 따라 강조 표시 대기열을 활성화합니다.',
        'Enable keep-alive connection header for SOAP responses.' => 'SOAP 응답에 대해 연결 유지 연결 헤더를 사용합니다.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '신뢰할 수있는 서명으로 인증되지 않았더라도 모든 공용 및 개인용 PGP 키를 신뢰하는 경우이 옵션을 활성화하십시오.',
        'Enabled filters.' => '필터를 사용합니다.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'PGP 지원을 사용합니다. 메일 서명 및 암호화에 대해 PGP 지원을 사용하는 경우 웹 서버를 OTRS 사용자로 실행하는 것이 좋습니다. 그렇지 않으면 .gnupg 폴더에 액세스 할 때 권한에 문제가 있습니다.',
        'Enables S/MIME support.' => 'S / MIME 지원을 사용합니다.',
        'Enables customers to create their own accounts.' => '고객이 자신의 계정을 만들 수 있습니다.',
        'Enables fetch S/MIME from CustomerUser backend support.' => '고객사용자 백 엔드 지원에서 S / MIME을 가져올 수 있습니다.',
        'Enables file upload in the package manager frontend.' => '패키지 관리자 프론트 엔드에서 파일 업로드를 사용 가능하게 합니다.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '템플릿에 대한 캐싱을 사용하거나 사용하지 않도록 설정합니다. 경고 : 프로덕션 환경에서 템플릿 캐싱을 사용하지 않도록 설정하면 성능이 크게 떨어질 수 있습니다. 이 설정은 디버깅을 이유로 사용하지 않아야 합니다!',
        'Enables or disables the debug mode over frontend interface.' => '프론트 엔드 인터페이스에서 디버그 모드를 활성화 또는 비활성화합니다. ',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '티켓 워처 기능을 사용 또는 사용 중지하여 소유자 또는 책임자가 아닌 티켓을 추적합니다.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '성능 로그를 사용 가능하게합니다 (페이지 응답 시간을 기록). 시스템 성능에 영향을줍니다. Frontend :: Module ### AdminPerformanceLog가 활성화되어 있어야합니다.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '최소 티켓 카운터 크기를 활성화합니다 ( "Date"가 TicketNumberGenerator로 선택된 경우).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '에이전트 프론트 엔드의 티켓 대량 작업 기능을 사용하여 한 번에 둘 이상의 티켓에서 작업할 수 있습니다.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '나열된 그룹에 대해서만 티켓 대량 작업 기능을 사용합니다.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '티켓 관련 기능을 사용하여 특정 티켓을 추적합니다.',
        'Enables ticket type feature.' => '티켓 유형 기능을 사용합니다.',
        'Enables ticket watcher feature only for the listed groups.' => '나열된 그룹에 대해서만 티켓 감시자 기능을 사용합니다.',
        'English (Canada)' => '영어 (캐나다)',
        'English (United Kingdom)' => '영어 (영국)',
        'English (United States)' => '영어 (미국)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '전체 텍스트 색인에 대한 영어 중지 단어. 이 단어는 검색 색인에서 제거됩니다.',
        'Enroll process for this ticket' => '이 티켓에 대한 프로세스 등록',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Escalated 티켓',
        'Escalation view' => 'Escalation 뷰',
        'EscalationTime' => '에스컬레이션 시간',
        'Estonian' => '에스토니아 사람',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '이벤트 모듈 등록. 성능 향상을 위해 트리거 이벤트를 정의 할 수 있습니다 (예 : Event => TicketCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '이벤트 모듈 등록. 성능 향상을 위해 트리거 이벤트를 정의 할 수 있습니다 (예 : Event => TicketCreate). 모든 티켓 동적 필드가 동일한 이벤트를 필요로하는 경우에만 가능합니다.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '필요한 경우 및 StaticDB가 실제로 사용되는 경우 큐 이름을 바꾸기 위해 TicketIndex에서 업데이트 문을 수행하는 이벤트 모듈입니다.',
        'Event module that updates customer company object name for dynamic fields.' =>
            '동적 필드에 대한 고객 회사 개체 이름을 업데이트하는 이벤트 모듈입니다.',
        'Event module that updates customer user object name for dynamic fields.' =>
            '동적 필드에 대한 고객 사용자 개체 이름을 업데이트 하는 이벤트 모듈입니다.',
        'Event module that updates customer user search profiles if login changes.' =>
            '로그인이 변경되면 고객 사용자 검색 프로파일을 업데이트 하는 이벤트 모듈입니다.',
        'Event module that updates customer user service membership if login changes.' =>
            '로그인이 변경되면 고객 사용자 서비스 멤버십을 업데이트 하는 이벤트 모듈입니다.',
        'Event module that updates customer users after an update of the Customer.' =>
            '고객 업데이트 후 고객 사용자를 업데이트 하는 이벤트 모듈입니다.',
        'Event module that updates tickets after an update of the Customer User.' =>
            '고객 사용자의 업데이트 후 티켓을 업데이트 하는 이벤트 모듈입니다.',
        'Event module that updates tickets after an update of the Customer.' =>
            '고객 사용자의 업데이트 후 티켓을 업데이트 하는 이벤트 모듈입니다.',
        'Events Ticket Calendar' => '이벤트 티켓 캘린더',
        'Example package autoload configuration.' => '패키지 자동로드 구성 예제.',
        'Execute SQL statements.' => 'SQL 문을 실행하십시오.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '사용자 지정 명령 또는 모듈을 실행합니다. 참고 : 모듈을 사용하는 경우 기능이 필요합니다.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '제목에 티켓 번호가없는 메일에 대한 In-Reply-To 또는 References 헤더의 후속 검사를 실행합니다.',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => 'OTRS Header \'X-OTRS-Bounce\'에 대한 후속 검사를 실행합니다.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '제목에 티켓 번호가 없는 메일의 첨부파일 내용에 대한 후속 검사를 실행합니다.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '제목에 티켓 번호가 없는 메일에 대한 이메일 본문에 대한 후속 검사를 실행합니다.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '제목에 티켓 번호가 없는 메일의 원시 원본 전자 메일에 대한 후속 검사를 실행합니다.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '검색 결과에 전체 아티클 트리를 내보냅니다 (시스템 성능에 영향을 미칠 수 있음).',
        'External' => '외부',
        'External Link' => '외부 링크',
        'Fetch emails via fetchmail (using SSL).' => 'fetchmail (SSL 사용)을 통해 전자 메일을 가져옵니다.',
        'Fetch emails via fetchmail.' => 'fetchmail을 통해 이메일을 가져옵니다.',
        'Fetch incoming emails from configured mail accounts.' => '구성된 메일 계정에서 수신 전자 메일을 가져옵니다.',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '프록시를 통해 패키지를 가져옵니다. "WebUserAgent :: Proxy"를 덮어 씁니다.',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'Kernel :: Outputs / HTML / Templates / Standard / AgentInfo.tt 아래에있는 경우 Kernel :: Modules :: AgentInfo 모듈에 표시되는 파일.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'ACL 디버깅 용 필터. 참고 : 더 많은 티켓 속성을 1과 같은 형식으로 추가 할 수 있습니다. 2.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '전환 디버깅을위한 필터. 참고 : 더 많은 필터를 1과 같은 형식으로 추가 할 수 있습니다. 2.',
        'Filter incoming emails.' => '수신 이메일 필터링.',
        'Finnish' => '핀란드어',
        'First Christmas Day' => '크리스마스 첫날',
        'First Queue' => '첫 번째 대기열',
        'First response time' => '첫 번째 응답 시간',
        'FirstLock' => 'FirstLock',
        'FirstResponse' => 'FirstResponse',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'FirstResponseInMin',
        'Firstname Lastname' => '이름 성',
        'Firstname Lastname (UserLogin)' => '이름 성 (UserLogin)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '이러한 상태 유형의 경우 티켓 번호는 링크 테이블에서 제거됩니다.',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '필터를 실행하거나 정지 단어 목록을 적용하지 않고 기사 검색 색인에서 원본 기사 텍스트의 저장을 강제 실행합니다. 이렇게하면 검색 색인의 크기가 커지고 전체 텍스트 검색 속도가 느려질 수 있습니다.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '보내는 전자 메일을 강제로 인코딩합니다 (7bit | 8bit | quoted-printable | base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '잠금 조치 후 다른 티켓 상태 (현재 상태에서)를 강제로 선택합니다. 현재 상태를 키로 정의하고, 잠금 조치 후 다음 상태를 내용으로 정의하십시오.',
        'Forces to unlock tickets after being moved to another queue.' =>
            '다른 대기열로 이동한 후 강제로 티켓의 잠금을 해제합니다.',
        'Forwarded to "%s".' => 'Forwarded to "%s".',
        'Free Fields' => '자유 필드',
        'French' => '프랑스 국민',
        'French (Canada)' => '프랑스어(캐나다)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '전체 텍스트 인덱스에 대한 프랑스어 중지 단어. 이 단어는 검색 색인에서 제거됩니다.',
        'Frontend' => '프론트 엔드',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '프론트 엔드 모듈 등록 (티켓 서비스 기능을 사용하지 않는 경우 AgentTicketService 링크를 비활성화).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '프론트 엔드 모듈 등록 (회사 기능이 사용되지 않는 경우 회사 링크 비활성화).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '프런트 엔드 모듈 등록 (사용 가능한 프로세스가 없을 경우 티켓 프로세스 화면을 비활성화).',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '프론트 엔드 모듈 등록 (사용 가능한 프로세스가없는 경우 티켓 프로세스 화면을 사용하지 않음).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '프론트 엔드 모듈 등록 (개인 즐겨 찾기를 \'Admin\'의 하위 네비게이션 항목으로 표시).',
        'Frontend module registration for the agent interface.' => '에이전트 인터페이스에 대한 프론트 엔드 모듈 등록.',
        'Frontend module registration for the customer interface.' => '고객 인터페이스에 대한 프론트 엔드 모듈 등록.',
        'Frontend module registration for the public interface.' => '',
        'Full value' => '최대 가치',
        'Fulltext index regex filters to remove parts of the text.' => '전체 텍스트 색인 정규식 필터는 텍스트의 일부를 제거합니다.',
        'Fulltext search' => '전체 텍스트 검색',
        'Galician' => '갈리시아 사람',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '티켓 개요에 표시된 일반 티켓 데이터 (폴백). TicketNumber는 필요하므로 비활성화 할 수 없습니다.',
        'Generate dashboard statistics.' => '대시 보드 통계를 생성합니다.',
        'Generic Info module.' => '일반 정보 모듈.',
        'GenericAgent' => 'GenericAgent',
        'GenericInterface Debugger GUI' => 'GenericInterface 디버거 GUI',
        'GenericInterface ErrorHandling GUI' => 'GenericInterface ErrorHandling GUI',
        'GenericInterface Invoker Event GUI' => 'GenericInterface Invoker 이벤트 GUI',
        'GenericInterface Invoker GUI' => 'GenericInterface Invoker GUI',
        'GenericInterface Operation GUI' => 'GenericInterface 조작 GUI',
        'GenericInterface TransportHTTPREST GUI' => 'GenericInterface TransportHTTPREST GUI',
        'GenericInterface TransportHTTPSOAP GUI' => 'GenericInterface TransportHTTPSOAP GUI',
        'GenericInterface Web Service GUI' => 'GenericInterface 웹 서비스 GUI',
        'GenericInterface Web Service History GUI' => 'GenericInterface 웹 서비스 기록 GUI',
        'GenericInterface Web Service Mapping GUI' => 'GenericInterface 웹 서비스 매핑 GUI',
        'GenericInterface module registration for an error handling module.' =>
            '오류 처리 모듈에 대한 GenericInterface 모듈 등록.',
        'GenericInterface module registration for the invoker layer.' => '호출자 레이어의 GenericInterface 모듈 등록.',
        'GenericInterface module registration for the mapping layer.' => '매핑 레이어의 GenericInterface 모듈 등록.',
        'GenericInterface module registration for the operation layer.' =>
            '조작 계층에 대한 GenericInterface 모듈 등록.',
        'GenericInterface module registration for the transport layer.' =>
            '전송 레이어의 GenericInterface 모듈 등록.',
        'German' => '독일 사람',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '전체 텍스트 색인에 대한 독일어 중지 단어. 이 단어는 검색 색인에서 제거됩니다.',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '동일한 고객 (고객 ID의 티켓은 고객 사용자의 고객 ID)의 고객 사용자로부터 티켓에 대한 그룹 기반 액세스를 고객에게 제공합니다.',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '최종 사용자에게 번역 파일에 정의 된 CSV 파일의 구분 문자를 무시할 수 있습니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Global Search Module.' => '글로벌 검색 모듈.',
        'Go to dashboard!' => '대시 보드로 이동!',
        'Good PGP signature.' => '',
        'Google Authenticator' => 'Google OTP',
        'Graph: Bar Chart' => '그래프 : 막대 차트',
        'Graph: Line Chart' => '그래프 : 선 차트',
        'Graph: Stacked Area Chart' => '그래프 : 누적 영역 차트',
        'Greek' => '그리스 사람',
        'Hebrew' => '헤브라이 사람',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '고 대비',
        'High contrast skin for visually impaired users.' => '시각 장애가 있는 사용자를 위한 고 대비 피부.',
        'Hindi' => '힌디 어',
        'Hungarian' => '헝가리 인',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Customer :: AuthModule에 대해 "DB"가 선택되면 데이터베이스 드라이버 (일반적으로 자동 감지가 사용됨)를 지정할 수 있습니다.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Customer :: AuthModule에 대해 "DB"가 선택되면 고객 테이블에 연결할 암호를 지정할 수 있습니다.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Customer :: AuthModule에 대해 "DB"가 선택되면 고객 테이블에 연결할 사용자 이름을 지정할 수 있습니다.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Customer :: AuthModule에 대해 "DB"를 선택한 경우 고객 테이블에 대한 연결에 대한 DSN을 지정해야합니다.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Customer :: AuthModule에 대해 "DB"가 선택되면 customer 테이블의 CustomerPassword에 대한 열 이름을 지정해야합니다.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            'Customer :: AuthModule에 대해 "DB"가 선택되면 암호의 암호화 유형을 지정해야합니다.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Customer :: AuthModule에 대해 "DB"가 선택되면 customer 테이블의 CustomerKey에 대한 열의 이름을 지정해야합니다.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Customer :: AuthModule에 대해 "DB"가 선택되면 고객 데이터를 저장해야하는 테이블의 이름을 지정해야합니다.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'SessionModule에 대해 "DB"가 선택되면 세션 데이터가 저장 될 데이터베이스의 테이블을 지정해야합니다.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'SessionModule에 대해 "FS"가 선택되면 세션 데이터가 저장 될 디렉토리를 지정해야합니다.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Customer :: AuthModule에 대해 "HTTPBasicAuth"를 선택한 경우 (예 : RegExp를 사용하여) REMOTE_USER의 일부를 제거하도록 지정할 수 있습니다 (예 : 후행 도메인 제거). RegExp-Note, $ 1이 새로운 로그인이됩니다.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Customer :: AuthModule에 대해 "LDAP"가 선택되고 모든 고객 로그인 이름에 접미어를 추가하려는 경우 여기서 여기를 지정하십시오. 지. 사용자 이름 사용자를 쓰고 싶지만 LDAP 디렉토리에는 user @ domain이 있어야합니다.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Customer :: AuthModule에서 "LDAP"가 선택되고 Net :: LDAP perl 모듈에 특수 매개 변수가 필요한 경우 여기에서 지정할 수 있습니다. 매개 변수에 대한 자세한 정보는 "perldoc Net :: LDAP"를 참조하십시오.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Customer :: AuthModule에 "LDAP"가 선택되고 사용자가 LDAP 트리에 익명으로 액세스 할 수 있지만 데이터를 검색하려는 경우 LDAP 디렉토리에 액세스 할 수있는 사용자에게이 작업을 수행 할 수 있습니다. 이 특별 사용자의 암호를 여기에 지정하십시오.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Customer :: AuthModule에 "LDAP"가 선택되고 사용자가 LDAP 트리에 익명으로 액세스 할 수 있지만 데이터를 검색하려는 경우 LDAP 디렉토리에 액세스 할 수있는 사용자에게이 작업을 수행 할 수 있습니다. 이 특별한 사용자의 사용자 이름을 여기에 지정하십시오.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Customer :: AuthModule에서 "LDAP"를 선택한 경우 BaseDN을 지정해야합니다.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Customer :: AuthModule에 대해 "LDAP"를 선택한 경우 LDAP 호스트를 지정할 수 있습니다.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Customer :: AuthModule에 대해 "LDAP"를 선택한 경우 사용자 식별자를 지정해야합니다.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Customer :: AuthModule에 대해 "LDAP"가 선택되면 사용자 속성을 지정할 수 있습니다. LDAP posixGroups의 경우 UID를 사용하고 비 LDAP의 경우 posixGroups는 전체 사용자 DN을 사용합니다.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Customer :: AuthModule에 대해 "LDAP"를 선택한 경우 여기에서 액세스 속성을 지정할 수 있습니다.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Customer :: AuthModule에 대해 "LDAP"가 선택된 경우, e. 지. 네트워크 문제로 인해 서버에 연결할 수 없습니다.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Customer :: Authmodule에 대해 "LDAP"가 선택된 경우 사용자가 posixGroup에 있기 때문에 인증 할 수 있는지 확인할 수 있습니다. 사용자는 OTRS를 사용하려면 그룹 xyz에 있어야합니다. 시스템에 액세스 할 수있는 그룹을 지정하십시오.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '"LDAP"를 선택한 경우 각 LDAP 쿼리에 필터를 추가 할 수 있습니다. (메일 = *), (objectclass = 사용자) 또는 (! objectclass = 컴퓨터).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Customer :: AuthModule에서 "반경"을 선택한 경우 반지름 호스트에 인증 할 암호를 지정해야합니다.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Customer :: AuthModule에서 "반경"을 선택한 경우 반지름 호스트를 지정해야합니다.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Customer :: AuthModule에 대해 "반경"을 선택한 경우 e. 지. 네트워크 문제로 인해 서버에 연결할 수 없습니다.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '"Sendmail"이 SendmailModule로 선택된 경우 sendmail 바이너리의 위치와 필요한 옵션을 지정해야합니다.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'LogModule에 대해 "SysLog"가 선택되면 특수 로그 기능을 지정할 수 있습니다.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'LogModule에 "SysLog"를 선택하면 로깅에 사용해야하는 charset을 지정할 수 있습니다.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            'CryptType에 대해 "bcrypt"를 선택한 경우 bcrypt 해싱에 여기에 지정된 비용을 사용하십시오. 현재 최대 지원 비용 값은 31입니다.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'LogModule에 대해 "file"을 선택하면 로그 파일을 지정해야합니다. 파일이 없으면 시스템에 의해 작성됩니다.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '활성화되어 있는 경우 등록을 허용하는 정규 표현식이 사용자의 전자 메일 주소와 일치하지 않을 수 있습니다.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '활성화 되어있는 경우 등록을 허용하는 정규 표현식이 사용자의 전자 메일 주소와 일치하지 않을 수 있습니다.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '"SMTP"메커니즘 중 하나가 SendmailModule로 선택되고 메일 서버에 대한 인증이 필요하면 암호를 지정해야합니다.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '"SMTP"메커니즘 중 하나가 SendmailModule로 선택되고 메일 서버에 대한 인증이 필요하면 사용자 이름을 지정해야합니다.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '"SMTP"메커니즘 중 하나가 SendmailModule로 선택된 경우 메일을 보내는 메일 호스트를 지정해야합니다.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '"SMTP"메커니즘 중 하나가 SendmailModule로 선택된 경우 메일 서버가 들어오는 연결을 수신하는 포트를 지정해야합니다.',
        'If enabled debugging information for ACLs is logged.' => '활성화 된 경우 ACL에 대한 디버깅 정보가 기록됩니다.',
        'If enabled debugging information for transitions is logged.' => '활성화 된 경우 전환에 대한 디버깅 정보가 기록됩니다.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '사용 가능하면 데몬은 표준 오류 스트림을 로그 파일로 재지정합니다.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '사용 가능하면 데몬은 표준 출력 스트림을 로그 파일로 재지정합니다.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '이 설정을 사용하면 데몬은이 디렉토리를 사용하여 PID 파일을 만듭니다. 참고 : 변경하기 전에 데몬을 중지하고 <$ OTRSHome> / var / run /을 사용할 수없는 경우에만이 설정을 사용하십시오.',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '사용하도록 설정하면 OTRS는 모든 CSS 파일을 축소 된 형식으로 제공합니다.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '사용하도록 설정하면 OTRS는 모든 JavaScript 파일을 축소 된 형식으로 제공합니다.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '사용하도록 설정하면 TicketPhone 및 TicketEmail이 새 창에서 열립니다.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '사용 설정하면 OTRS 버전 태그가 웹 인터페이스, 나가는 메일의 HTTP 헤더 및 X 헤더에서 삭제됩니다. 참고 :이 옵션을 변경하면 캐시를 삭제하십시오.',
        'If enabled, the cache data be held in memory.' => '활성화된 경우 캐시 데이터가 메모리에 보관됩니다.',
        'If enabled, the cache data will be stored in cache backend.' => '활성화된 경우 캐시 데이터가 캐시 백엔드에 저장됩니다.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '사용하도록 설정된 경우 고객은 모든 서비스의 티켓을 검색할 수 있습니다 (고객에게 할당된 서비스에 관계없음).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '활성화 된 경우 다른 개요 (Dashboard, LockedView, QueueView)가 지정된 시간 후에 자동으로 새로 고침됩니다.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '이 옵션을 사용하면 메인 메뉴의 첫 번째 레벨이 마우스를 올리면 열리게 됩니다 (클릭만 하는 대신).',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '사용하도록 설정하면 아직 시간대를 선택하지 않은 사용자에게 알림이 전송됩니다. 참고 : (1) 사용자가 아직 시간대를 선택하지 않았으며 (2) OTRSTimeZone과 UserDefaultTimeZone이 일치하고 (3) UTC로 설정되지 않은 경우 알림이 표시되지 않습니다.',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'SendmailNotificationEnvelopeFrom이 지정되지 않은 경우이 설정을 사용하면 빈 봉투 발신자 대신 (특정 전자 메일 서버 구성에서 필요) 전자 메일의 보낸 사람 주소를 사용할 수 있습니다.',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '설정된 경우이 주소는 보내는 알림의 봉투 보낸 사람 헤더로 사용됩니다. 주소를 지정하지 않으면 봉투 송신자 헤더가 비어 있습니다 (SendmailNotificationEnvelopeFrom :: FallbackToEmailFrom이 설정되지 않은 경우).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '설정된 경우 이 주소는 발신 메일에서 봉투 발신자로 사용됩니다 ( 알림이 아님 - 아래 참조). 주소를 지정하지 않으면 봉투 송신자는 대기열 전자 우편 주소와 같습니다.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '이 옵션을 사용하면 Customers 나 Agents를 통해 웹 인터페이스를 통해 생성 된 티켓은 자동 응답을받습니다. 이 옵션을 사용하지 않으면 자동 응답이 전송되지 않습니다.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '이 정규식이 일치하면 자동 응답으로 보낼 메시지가 없습니다.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '이 설정을 사용하면 로컬 수정 내용이 패키지 관리자 및 지원 데이터 수집기에서 오류로 강조 표시되지 않습니다.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '부재중이라면 부재자의 정확한 날짜를 설정하여 다른 사용자에게 알릴 수 있습니다.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            'AgentTicketZoom에서 시스템 발신자 기사 유형 (예 : 자동 응답 또는 이메일 알림)을 \'읽지 않은 기사\'로 표시하거나 큰보기 화면에서 자동으로 확장하도록 무시합니다.',
        'Import appointments screen.' => '약속 가져오기 화면.',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '큐를 선택할 때 기본값 당 서브 큐 티켓을 포함하십시오.',
        'Include unknown customers in ticket filter.' => '티켓 필터에 알 수없는 고객을 포함시킵니다.',
        'Includes article create times in the ticket search of the agent interface.' =>
            '에이전트 인터페이스의 티켓 검색에서 기사 작성 시간을 포함합니다.',
        'Incoming Phone Call.' => '수신 전화.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'IndexAccelerator : 백엔드 TicketViewAccelerator 모듈을 선택합니다. "RuntimeDB"는 티켓 테이블에서 각 큐 뷰를 생성합니다 (성능상의 문제없이 최대 약 60,000 개의 티켓과 시스템의 6.000 개 티켓). "StaticDB"는보기와 같이 작동하는 별도의 티켓 색인 표를 사용하는 가장 강력한 모듈입니다 (80.000 개 이상의 티켓이 시스템에 저장되어있는 경우 권장). 초기 색인 작성은 "bin / otrs.Console.pl Maint :: Ticket :: QueueIndexRebuild"명령을 사용하십시오.',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '반송 전자 메일을 항상 정상적인 후속조치로 처리해야하는지 나타냅니다.',
        'Indonesian' => '인도네시아인',
        'Inline' => '인라인',
        'Input' => '입력',
        'Interface language' => '인터페이스 언어',
        'Internal communication channel.' => '내부 통신 채널.',
        'International Workers\' Day' => '국제 노동의 날',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '응용 프로그램 내에서 도메인별로 사용되도록 다른 스킨을 구성 할 수 있습니다 예 : 다른 에이전트를 구분할 수 있음. 정규식 (정규식)을 사용하면 키 / 내용 쌍을 도메인과 일치하도록 구성 할 수 있습니다. "Key"의 값은 도메인과 일치해야하며 "Content"의 값은 시스템의 유효한 스킨이어야합니다. 올바른 형식의 정규식에 대한 예제 항목을 참조하십시오.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '서로 다른 스킨을 구성하여 서로 다른 고객을 구별하고 응용 프로그램 내에서 도메인별로 사용할 수 있습니다. 정규식 (정규식)을 사용하면 키 / 내용 쌍을 도메인과 일치하도록 구성 할 수 있습니다. "Key"의 값은 도메인과 일치해야하며 "Content"의 값은 시스템의 유효한 스킨이어야합니다. 올바른 형식의 정규식에 대한 예제 항목을 참조하십시오.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '에이전트와 고객을 구별하기 위해 응용 프로그램 내에서 도메인별로 사용되도록 다른 테마를 구성 할 수 있습니다. 정규식 (정규식)을 사용하면 키 / 내용 쌍을 도메인과 일치하도록 구성 할 수 있습니다. "Key"의 값은 도메인과 일치해야하며 "Content"의 값은 시스템의 유효한 테마 여야합니다. 올바른 형식의 정규식에 대한 예제 항목을 참조하십시오.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '이탈리아 사람',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '전체 텍스트 색인에 대한 이탈리아어 중지 단어. 이 단어는 검색 색인에서 제거됩니다.',
        'Ivory' => '아이보리',
        'Ivory (Slim)' => '아이보리(슬림)',
        'Japanese' => '일본어',
        'JavaScript function for the search frontend.' => '검색 프론트 엔드 용 JavaScript 함수.',
        'Korean' => '',
        'Language' => '언어',
        'Large' => '큰',
        'Last Screen Overview' => '마지막 화면 개요',
        'Last customer subject' => '마지막 고객 주제',
        'Lastname Firstname' => '성 이름',
        'Lastname Firstname (UserLogin)' => '성 이름 (UserLogin)',
        'Lastname, Firstname' => '성, 이름',
        'Lastname, Firstname (UserLogin)' => '성, 이름 (UserLogin)',
        'LastnameFirstname' => '성 이름',
        'Latvian' => '라트비아 사람',
        'Left' => '왼쪽',
        'Link Object' => '링크 개체',
        'Link Object.' => '링크 개체.',
        'Link agents to groups.' => '에이전트를 그룹에 연결하십시오.',
        'Link agents to roles.' => '에이전트를 역할에 연결하십시오.',
        'Link customer users to customers.' => '고객 사용자와 고객을 연결하십시오.',
        'Link customer users to groups.' => '고객 사용자를 그룹에 연결하십시오.',
        'Link customer users to services.' => '고객 사용자를 서비스에 연결하십시오.',
        'Link customers to groups.' => '고객을 그룹과 연결하십시오.',
        'Link queues to auto responses.' => '대기열을 자동 응답에 연결합니다.',
        'Link roles to groups.' => '그룹에 역할을 연결하십시오.',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => '템플리트를 대기열에 링크하십시오.',
        'Link this ticket to other objects' => '이 티켓을 다른 객체에 연결하십시오.',
        'Links 2 tickets with a "Normal" type link.' => '2 개의 티켓을 "일반"유형 링크로 연결합니다.',
        'Links 2 tickets with a "ParentChild" type link.' => '2 개의 티켓을 "ParentChild"유형 링크로 연결합니다.',
        'Links appointments and tickets with a "Normal" type link.' => '약속과 티켓을 "일반"유형 링크로 연결합니다.',
        'List of CSS files to always be loaded for the agent interface.' =>
            '에이전트 인터페이스 용으로 항상로드 될 CSS 파일 목록입니다.',
        'List of CSS files to always be loaded for the customer interface.' =>
            '고객 인터페이스를 위해 항상로드 될 CSS 파일 목록.',
        'List of JS files to always be loaded for the agent interface.' =>
            '에이전트 인터페이스 용으로 항상로드 될 JS 파일 목록.',
        'List of JS files to always be loaded for the customer interface.' =>
            '고객 인터페이스 용으로 항상로드 될 JS 파일 목록.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'GUI에 표시 될 모든 CustomerCompany 이벤트 목록.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'GUI에 표시 될 모든 고객사용자 이벤트 목록입니다.',
        'List of all DynamicField events to be displayed in the GUI.' => 'GUI에 표시 할 모든 DynamicField 이벤트 목록입니다.',
        'List of all LinkObject events to be displayed in the GUI.' => 'GUI에 표시 될 모든 LinkObject 이벤트 목록입니다.',
        'List of all Package events to be displayed in the GUI.' => 'GUI에 표시 할 모든 패키지 이벤트 목록.',
        'List of all appointment events to be displayed in the GUI.' => 'GUI에 표시 할 모든 약속 이벤트 목록입니다.',
        'List of all article events to be displayed in the GUI.' => 'GUI에 표시 할 모든 기사 이벤트 목록입니다.',
        'List of all calendar events to be displayed in the GUI.' => 'GUI에 표시 할 모든 캘린더 이벤트 목록입니다.',
        'List of all queue events to be displayed in the GUI.' => 'GUI에 표시 될 모든 대기열 이벤트 목록.',
        'List of all ticket events to be displayed in the GUI.' => 'GUI에 표시 될 모든 티켓 이벤트 목록입니다.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '달력을 만들 때 선택할 수있는 16 진수 RGB 색상 목록입니다. 흰색 텍스트를 오버레이 할 수 있도록 색이 충분히 어두워 졌는지 확인하십시오.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '생성시 새 대기열에 자동으로 할당되는 기본 표준 템플릿 목록입니다.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '에이전트 인터페이스 용으로 항상로드되는 반응 형 CSS 파일 목록입니다.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '응답 성 CSS 파일 목록은 고객 인터페이스 용으로 항상로드됩니다.',
        'List view' => '목록보기',
        'Lithuanian' => '리투아니아 사람',
        'Loader module registration for the agent interface.' => '에이전트 인터페이스에 대한 로더 모듈 등록.',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => '이 티켓 잠금 / 잠금 해제',
        'Locked Tickets' => '잠긴 티켓',
        'Locked Tickets.' => '잠긴 티켓.',
        'Locked ticket.' => 'Locked ticket.',
        'Logged in users.' => '로그인 한 사용자.',
        'Logged-In Users' => '로그인 사용자',
        'Logout of customer panel.' => '고객 패널 로그 아웃.',
        'Look into a ticket!' => '표를 보세요!',
        'Loop protection: no auto-response sent to "%s".' => '루프 보호 : 자동 응답이 "%s"로 전송되지 않습니다.',
        'Macedonian' => '',
        'Mail Accounts' => '메일 계정',
        'MailQueue configuration settings.' => 'MailQueue 구성 설정.',
        'Main menu item registration.' => '기본 메뉴 항목 등록.',
        'Main menu registration.' => '기본 메뉴 등록.',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '전자 메일을 보내거나 전화 또는 전자 메일 티켓을 제출하기 전에 응용 프로그램에서 전자 메일 주소의 MX 레코드를 확인하게합니다.',
        'Makes the application check the syntax of email addresses.' => '응용 프로그램이 전자 메일 주소의 구문을 검사하도록 합니다.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '세션 관리가 html 쿠키를 사용하게합니다. html 쿠키가 비활성화되거나 클라이언트 브라우저가 html 쿠키를 비활성화 한 경우 시스템은 평소와 같이 작동하고 링크에 세션 ID를 추가합니다.',
        'Malay' => '말레이 사람',
        'Manage OTRS Group cloud services.' => 'OTRS 그룹 클라우드 서비스를 관리합니다.',
        'Manage PGP keys for email encryption.' => '전자 메일 암호화를위한 PGP 키 관리.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'POP3 또는 IMAP 계정을 관리하여 전자 메일을 가져옵니다.',
        'Manage S/MIME certificates for email encryption.' => '전자 메일 암호화를위한 S / MIME 인증서를 관리합니다.',
        'Manage System Configuration Deployments.' => '시스템 구성 배포 관리.',
        'Manage different calendars.' => '다른 캘린더를 관리하십시오.',
        'Manage existing sessions.' => '기존 세션을 관리합니다.',
        'Manage support data.' => '지원 데이터를 관리합니다.',
        'Manage system registration.' => '시스템 등록을 관리합니다.',
        'Manage tasks triggered by event or time based execution.' => '이벤트 또는 시간 기반 실행에 의해 트리거된 작업을 관리합니다.',
        'Mark as Spam!' => '스팸으로 표시하십시오!',
        'Mark this ticket as junk!' => '이 티켓을 정크로 표시하십시오!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '작성 화면의 고객 정보 테이블 (전화 및 이메일)의 최대 크기 (문자 수).',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '에이전트 인터페이스의 정보 저장소 에이전트 상자의 최대 크기 (행 수)',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '에이전트 인터페이스의 관련 상담원 상자의 최대 크기 (행).',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '전자 메일 회신 및 일부 개요 화면에서 주체의 최대 크기입니다.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '하루 동안 자신의 이메일 주소에 대한 최대 자동 이메일 응답(반복 방지).',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '전자 메일 주소 (루프 보호)로 구성 가능한 하루 전자 메일 주소에 대한 최대 자동 전자 메일 응답.',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'POP3 / POP3S / IMAP / IMAPS (KBytes)를 통해 가져올 수있는 메일의 최대 크기입니다.',
        'Maximum Number of a calendar shown in a dropdown.' => '드롭 다운에 표시된 최대 달력 수입니다.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '티켓 확대보기의 기사에서 동적 필드의 최대 길이(문자 수)',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '티켓 확대보기의 사이드 바에 있는 동적 필드의 최대 길이(문자 수).',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '개요 화면의 최대 활성 캘린더 수입니다. 많은 수의 활성 캘린더가 동시 호출을 너무 많이하여 서버에 성능에 영향을 줄 수 있습니다.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '에이전트 인터페이스의 검색 결과에 표시할 최대 티켓 수입니다.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '고객 인터페이스에서 검색 결과에 표시할 최대 티켓 수입니다.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '이 작업의 결과로 표시될 최대 티켓 수입니다.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '티켓 확대보기의 고객 정보 테이블의 최대 크기 (문자 수)',
        'Medium' => '중간의',
        'Merge this ticket and all articles into another ticket' => '이 티켓과 모든 기사를 다른 티켓으로 병합하십시오.',
        'Merged Ticket (%s/%s) to (%s/%s).' => '합쳐진 티켓 (%s/%s) ~ (%s/ 1 %s).',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'Merged Ticket 1 to 2.',
        'Minute' => '분',
        'Miscellaneous' => '기타',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '고객 인터페이스의 새 티켓 화면에서 선택 대상 모듈.',
        'Module to check if a incoming e-mail message is bounce.' => '들어오는 전자 메일 메시지가 바운드되는지 확인하는 모듈입니다.',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '도착한 전자 메일이 내부 전자 메일로 표시되어야하는지 확인하는 모듈입니다 (원래 전달 된 내부 전자 메일 때문에). IsVisibleForCustomer 및 SenderType은 도착한 전자 메일 / 기사의 값을 정의합니다.',
        'Module to check the group permissions for customer access to tickets.' =>
            '모듈이 티켓에 대한 고객 액세스에 대한 그룹 권한을 확인합니다.',
        'Module to check the group permissions for the access to tickets.' =>
            '티켓 액세스 권한에 대한 그룹 권한을 확인하는 모듈',
        'Module to compose signed messages (PGP or S/MIME).' => '서명 된 메시지를 구성하는 모듈 (PGP 또는 S / MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '사용할 이메일 보안 옵션을 정의하는 모듈 (PGP 또는 S / MIME).',
        'Module to encrypt composed messages (PGP or S/MIME).' => '구성된 메시지를 암호화하는 모듈 (PGP 또는 S / MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '들어오는 메시지의 고객 사용자 SMIME 인증서를 가져 오는 모듈.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '들어오는 메시지를 필터링하고 조작하는 모듈입니다. 보낸 사람 : noreply @ 주소로 모든 스팸 전자 메일을 차단 / 무시합니다.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '들어오는 메시지를 필터링하고 조작하는 모듈입니다. 항공권 프리 텍스트에 4 자리 숫자를 가져오고 Match e에서 regex를 사용하십시오. 지. From => \'(. +?) @. +?\'그리고 Set =>에서 [***]로 ()를 사용하십시오.',
        'Module to filter encrypted bodies of incoming messages.' => '들어오는 메시지의 암호화 된 본문을 필터링하는 모듈입니다.',
        'Module to generate accounted time ticket statistics.' => '모듈은 계산된 타임 티켓 통계를 생성합니다.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '에이전트 인터페이스에서 짧은 티켓 검색을위한 html OpenSearch 프로파일을 생성하는 모듈.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '모듈은 고객 인터페이스에서 짧은 티켓 검색을위한 html OpenSearch 프로파일을 생성합니다.',
        'Module to generate ticket solution and response time statistics.' =>
            '티켓 솔루션 및 응답 시간 통계를 생성하는 모듈.',
        'Module to generate ticket statistics.' => '티켓 통계를 생성하는 모듈.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '고객의 고객 ID에 필요한 그룹 권한이 있는 경우 액세스 권한을 부여하는 모듈입니다.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '티켓의 CustomerID가 고객의 CustomerID와 일치하는 경우 액세스 권한을 부여하는 모듈입니다.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '티켓의 고객사용자ID가 고객의 고객사용자ID와 일치하면 액세스 권한 부여 모듈.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '모듈은 (티켓 내역 항목을 기반으로) 과거 티켓과 관련된 모든 에이전트에 액세스 권한을 부여합니다.',
        'Module to grant access to the agent responsible of a ticket.' =>
            '티켓 책임자에게 액세스 권한을 부여하는 모듈.',
        'Module to grant access to the creator of a ticket.' => '티켓을 만든 사람에게 액세스 권한을 부여하는 모듈입니다.',
        'Module to grant access to the owner of a ticket.' => '티켓 소유자에게 액세스 권한을 부여하는 모듈입니다.',
        'Module to grant access to the watcher agents of a ticket.' => '감시자에게 티켓의 액세스 권한을 부여하는 모듈.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '알림 및 에스컬레이션을 표시하는 모듈 (ShownMax : 최대 에스컬레이션 에스컬레이션, EscalationInMinutes : 에스컬레이션 할 티켓 표시, CacheTime : 계산 된 에스컬레이션의 캐시 초).',
        'Module to use database filter storage.' => '모듈은 데이터베이스 필터 저장소를 사용합니다.',
        'Module used to detect if attachments are present.' => '첨부 파일이 있는지 감지하는데 사용되는 모듈입니다.',
        'Multiselect' => '다중선택',
        'My Queues' => '나의 대기열',
        'My Services' => '나의 서비스',
        'My Tickets.' => '나의 티켓',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '사용자 정의 대기열의 이름입니다. 사용자 정의 대기열은 기본 설정 대기열의 대기열 선택이며 환경 설정에서 선택할 수 있습니다.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '사용자 지정 서비스의 이름입니다. 사용자 지정 서비스는 기본 설정 서비스에서 선택한 서비스이며 기본 설정에서 선택할 수 있습니다.',
        'NameX' => 'NameX',
        'New Ticket' => '새 티켓',
        'New Tickets' => '새 티켓',
        'New Window' => '새 윈도우',
        'New Year\'s Day' => '새해첫날',
        'New Year\'s Eve' => '새해 전날',
        'New process ticket' => '새 프로세스 티켓',
        'News about OTRS releases!' => 'OTRS 출시에 대한 뉴스!',
        'News about OTRS.' => 'OTRS에 관한 뉴스.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '다음 가능한 티켓 상태는 에이전트 인터페이스의 티켓 인바운드 인바운드 화면에 전화 메모를 추가한 후의 상태입니다.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '가능한 다음 티켓 상태는 상담원 인터페이스의 티켓 전화 아웃 바운드 화면에 전화 메모를 추가한 후의 상태입니다.',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => '없음',
        'Norwegian' => '노르웨이인',
        'Notification Settings' => '알림 설정',
        'Notified about response time escalation.' => '응답 시간 에스컬레이션에 대한 알림',
        'Notified about solution time escalation.' => '솔루션 시간 확대에 대한 알림',
        'Notified about update time escalation.' => '업데이트 시간 이관에 대한 알림.',
        'Number of displayed tickets' => '표시된 티켓 수',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '에이전트 인터페이스에서 검색 유틸리티가 표시하는 행당 (티켓 당) 수.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '에이전트 인터페이스에서 검색 결과의 각 페이지에 표시할 티넷 수입니다.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '고객 인터페이스에서 검색 결과의 각 페이지에 표시할 티켓 수입니다.',
        'Number of tickets to be displayed in each page.' => '각 페이지에 표시할 티켓 수입니다.',
        'OTRS Group Services' => 'OTRS 그룹 서비스',
        'OTRS News' => 'OTRS 뉴스',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            'OTRS는 전체 텍스트 검색이나 통계 생성과 같은 값 비싼 작업에 대해 하나 이상의 읽기 전용 미러 데이터베이스를 사용할 수 있습니다. 여기서 첫 번째 미러 데이터베이스에 대해 DSN을 지정할 수 있습니다.',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            'OTRS는 끝 날짜 또는 반복 횟수가없는 되풀이 약속을 지원하지 않습니다. 가져 오기 프로세스 중에 ICS 파일에 이러한 약속이 포함될 수 있습니다. 대신, 시스템은 과거의 모든 약속과 다음 N 개월 (기본적으로 120 개월 / 10 년)의 약속을 작성합니다.',
        'Open an external link!' => '외부 링크 열기',
        'Open tickets (customer user)' => '진행중 티켓 (고객 사용자)',
        'Open tickets (customer)' => '진행중 티켓 (고객)',
        'Option' => '옵션',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'CreatorCheck 권한 모듈의 선택적 큐 제한 사항입니다. 설정된 경우 지정된 큐의 티켓에 대해서만 사용 권한이 부여됩니다.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'InvolvedCheck 권한 모듈에 대한 선택적 큐 제한입니다. 설정된 경우 지정된 큐의 티켓에 대해서만 사용 권한이 부여됩니다.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'OwnerCheck 권한 모듈에 대한 선택적 큐 제한입니다. 설정된 경우 지정된 큐의 티켓에 대해서만 사용 권한이 부여됩니다.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'ResponsibleCheck 권한 모듈에 대한 선택적 큐 제한입니다. 설정된 경우 지정된 큐의 티켓에 대해서만 사용 권한이 부여됩니다.',
        'Other Customers' => '다른 고객들',
        'Out Of Office' => '부재중',
        'Out Of Office Time' => '부재중 시간',
        'Out of Office users.' => '부재중 사용자',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Kernel :: System :: Ticket의 기존 함수를 오버로드 (재정의)합니다. 쉽게 사용자 정의를 추가하는 데 사용됩니다.',
        'Overview Escalated Tickets.' => 'Escalated 티켓 개요',
        'Overview Refresh Time' => '개요 리프레쉬 시간',
        'Overview of all Tickets per assigned Queue.' => '할당된 대기열 당 모든 티켓 개요.',
        'Overview of all appointments.' => '모든 약속 개요.',
        'Overview of all escalated tickets.' => '에스컬레이트 된 티켓 개요.',
        'Overview of all open Tickets.' => '열려있는 모든 티켓 개요.',
        'Overview of all open tickets.' => '열려있는 모든 티켓 개요.',
        'Overview of customer tickets.' => '고객 티켓 개요.',
        'PGP Key' => 'PGP 키',
        'PGP Key Management' => 'PGP 키 관리',
        'PGP Keys' => 'PGP 키',
        'Package event module file a scheduler task for update registration.' =>
            '패키지 이벤트 모듈은 업데이트 등록을 위한 스케줄러 태스크를 파일로 작성합니다.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '에이전트 인터페이스의 기본 설정보기에있는 CreateNextMask 객체의 매개 변수입니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '에이전트 인터페이스의 환경 설정 뷰에서 CustomQueue 객체의 매개 변수입니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '에이전트 인터페이스의 환경 설정보기에서 CustomService 객체의 매개 변수입니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '에이전트 인터페이스의 환경 설정 뷰에있는 RefreshTime 객체의 매개 변수입니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '작은 티켓 개요의 열 필터에 대한 매개 변수입니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '에이전트 인터페이스의 고객 회사 정보의 대시 보드 백엔드에 대한 매개 변수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다.',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '고객 ID의 대시 보드 백엔드에 대한 매개 변수 에이전트 인터페이스 개요. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '에이전트 인터페이스의 고객 ID 상태 위젯의 대시 보드 백엔드에 대한 매개 변수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '에이전트 인터페이스의 고객 사용자 정보의 대시 보드 백엔드에 대한 매개 변수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '고객 사용자 목록의 대시 보드 백엔드 매개 변수는 에이전트 인터페이스 개요입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '새 티켓의 대시 보드 백엔드에 대한 매개 변수 에이전트 인터페이스 개요입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '새 티켓의 대시 보드 백엔드에 대한 매개 변수 에이전트 인터페이스 개요입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '에이전트 인터페이스의 열린 티켓 개요의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '에이전트 인터페이스의 열린 티켓 개요의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '에이전트 인터페이스의 대기열 개요 위젯의 대시 보드 백엔드에 대한 매개 변수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "QueuePermissionGroup"은 필수는 아니지만 큐를 사용하는 경우이 사용 권한 그룹에 속한 큐만 나열됩니다. "상태"는 상태 목록이며, 키는 위젯에있는 상태의 정렬 순서입니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '실행중인 프로세스 티켓의 대시 보드 백엔드에 대한 매개 변수 에이전트 인터페이스의 개요. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '에이전트 인터페이스의 티켓 에스컬레이션 개요의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '에이전트 인터페이스의 티켓 에스컬레이션 개요의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '에이전트 인터페이스의 티켓 이벤트 달력의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '에이전트 인터페이스의 티켓 보류 알림 요약의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '에이전트 인터페이스의 티켓 보류 알림 요약의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. 참고 : Ticket 속성과 Dynamic Fields (DynamicField_NameX) 만 DefaultColumn에 허용됩니다.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '에이전트 인터페이스의 티켓 통계 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '에이전트 인터페이스의 다가오는 이벤트 위젯의 대시 보드 백엔드에 대한 매개 변수입니다. "제한"은 기본적으로 표시되는 항목 수입니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "기본값"은 플러그인이 기본적으로 활성화되어 있는지 여부 또는 사용자가 수동으로 활성화해야하는지 여부를 결정합니다. "CacheTTLLocal"은 플러그인의 캐시 시간입니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '통신 로그 개요의 페이지 (통신 로그 항목이 표시된 페이지)의 매개 변수.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '동적 필드 개요의 페이지 (동적 필드가 표시되는 페이지)의 매개 변수입니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '매체 티켓 개요의 페이지 (티켓이 표시된 페이지)의 매개 변수. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '작은 티켓 개요의 페이지 (티켓이 표시된 페이지)의 매개 변수. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '티켓 미리보기 개요의 페이지 (티켓이 표시된 페이지)의 매개 변수입니다. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Parameters of the example SLA attribute Comment2.' => '예제 SLA 속성 Comment2의 매개 변수.',
        'Parameters of the example queue attribute Comment2.' => '예제 큐 속성 Comment2의 매개 변수.',
        'Parameters of the example service attribute Comment2.' => '예제 서비스 속성 Comment2의 매개 변수.',
        'Parent' => '부모의',
        'ParentChild' => '부모 자녀',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '로그 파일 경로 (LoopProtectionModule에 대해 "FS"가 선택되고 필수 항목 인 경우에만 적용됩니다).',
        'Pending time' => '보류 시간',
        'People' => '사람들',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '구성된 각 웹 서비스의 각 이벤트 (Invoker)에 대해 구성된 작업을 수행합니다.',
        'Permitted width for compose email windows.' => '전자 메일 작성용으로 허용된 너비.',
        'Permitted width for compose note windows.' => '노트 작성 윈도우의 너비 허용.',
        'Persian' => '페르시아인',
        'Phone Call Inbound' => '전화 통화 인바운드',
        'Phone Call Outbound' => '전화 통화 발신',
        'Phone Call.' => '전화.',
        'Phone call' => '전화',
        'Phone communication channel.' => '전화 통신 채널.',
        'Phone-Ticket' => '전화티켓',
        'Picture Upload' => '사진 업로드',
        'Picture upload module.' => '사진 업로드 모듈.',
        'Picture-Upload' => '사진 업로드',
        'Plugin search' => '플러그인 검색',
        'Plugin search module for autocomplete.' => '자동 완성을 위한 플러그인 검색 모듈.',
        'Polish' => '폴란드어',
        'Portuguese' => '포르투갈인',
        'Portuguese (Brasil)' => '포르투갈어(브라질)',
        'PostMaster Filters' => 'PostMaster 필터',
        'PostMaster Mail Accounts' => 'PostMaster 메일 계정',
        'Print this ticket' => '이 티켓 인쇄',
        'Priorities' => '우선 순위',
        'Process Management Activity Dialog GUI' => '프로세스 관리 활동 대화 상자 GUI',
        'Process Management Activity GUI' => '프로세스 관리 활동 GUI',
        'Process Management Path GUI' => '프로세스 관리 경로 GUI',
        'Process Management Transition Action GUI' => '프로세스 관리 전환 액션 GUI',
        'Process Management Transition GUI' => '프로세스 관리 전환 GUI',
        'Process Ticket.' => '프로세스 티켓.',
        'Process pending tickets.' => '대기중인 티켓 처리.',
        'ProcessID' => 'ProcessID',
        'Processes & Automation' => '프로세스 및 자동화',
        'Product News' => '제품 뉴스',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '큐당 상태 별 티켓 개요를 제공합니다.',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '권한 그룹을 기반으로 동일한 고객 ID(들)의 고객 사용자에게 티켓이 할당되지 않은 경우에도 고객 사용자에게 티켓 액세스 권한을 제공합니다.',
        'Public Calendar' => '공개 캘린더',
        'Public calendar.' => '공개 캘린더',
        'Queue view' => '대기열 보기',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => 'AgentTicketQueue 티켓 색인을 다시 작성하십시오.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => '리프레쉬 간격',
        'Registers a log module, that can be used to log communication related information.' =>
            '통신 관련 정보를 기록하는데 사용할 수있는 로그 모듈을 등록합니다.',
        'Reminder Tickets' => '잊지 말아야 할 티켓',
        'Removed subscription for user "%s".' => '"%s" 사용자에 대한 가입이 삭제되었습니다.',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '이전 시스템 구성 배포 (일요일 오전)를 제거합니다.',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '티켓 보관시 티켓 감시자 정보를 제거합니다.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '고객 백엔드에서 기존 SMIME 인증서를 갱신하십시오. 참고 : SysConfig에서 SMIME 및 SMIME :: FetchFromCustomer를 활성화해야하며 고객 백엔드가 UserSMIMECertificate 특성을 가져 오도록 구성해야합니다.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '상담원 인터페이스의 티켓 작성 화면에서 작성 응답에 원래 보낸 사람을 현재 고객의 전자 메일 주소로 바꿉니다.',
        'Reports' => '보고서',
        'Reports (OTRS Business Solution™)' => '보고서 (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '처음부터 가져올 수 없었던 스풀 디렉토리의 메일을 다시 처리하십시오.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '에이전트 인터페이스에서 티켓의 고객을 변경하는데 필요한 권한입니다.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 닫기 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '에이전트 인터페이스에서 전자 메일 아웃 바운드 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the email resend screen in the agent interface.' =>
            '에이전트 인터페이스에서 전자 메일 다시 보내기 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 바운스 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '에이전트 인터페이스의 티켓 작성 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 전달 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '에이전트 인터페이스에서 티켓없는 텍스트 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소된 티켓의 티켓 병합 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '에아전트 인터페이스에서 티켓 메모 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소된 티켓의 티켓 소유자 화면을 사용하는데 필요한 권한입니다.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면을 사용하는 데 필요한 권한입니다.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '에이전트 인터페이스의 티켓 인바운드 화면을 사용하는 데 필요한 권한입니다.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 전화 아웃 바운드 화면을 사용하는 데 필요한 권한입니다.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 우선 순위 화면을 사용하는 데 필요한 권한입니다.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 책임 화면을 사용하는데 필요한 권한입니다.',
        'Resend Ticket Email.' => '티켓 전자 메일을 다시 보냅니다.',
        'Resent email to "%s".' => '이메일을 "%s"로 다시 보내십시오.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '다른 대기열로 이동된 티켓의 소유자를 재설정하고 잠금 해제합니다.',
        'Resource Overview (OTRS Business Solution™)' => '리소스 개요 (OTRS Business Solution ™)',
        'Responsible Tickets' => '책임 티켓',
        'Responsible Tickets.' => '책임 티켓.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '아카이브에서 티켓을 복원합니다(이벤트가 사용 가능한 열린 상태로 상태가 변경된 경우에만).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '서비스가 잘못된 요소의 하위 항목인 경우에도 목록의 모든 서비스를 유지합니다.',
        'Right' => '권리',
        'Roles ↔ Groups' => '역할 ↔ 그룹',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '파일 기반 일반 에이전트 작업 실행 (참고 : 모듈 이름은 -configuration-module 매개 변수 예 : "Kernel :: System :: GenericAgent")에서 지정해야합니다.',
        'Running Process Tickets' => '프로세스 티켓 실행',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'AdminCustomerCompany 모듈에 액세스 할 때 기존 고객 회사의 초기 와일드 카드 검색을 실행합니다.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'AdminCustomerUser 모듈에 액세스 할 때 기존 고객 사용자의 초기 와일드 카드 검색을 실행합니다.',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '시스템을 "데모"모드로 실행합니다. 이 옵션을 사용하면 상담원 웹 인터페이스를 통해 언어 및 테마 선택과 같은 기본 설정을 변경할 수 있습니다. 이러한 변경은 현재 세션에서만 유효합니다. 에이전트가 암호를 변경할 수는 없습니다.',
        'Russian' => '러시아인',
        'S/MIME Certificates' => 'S / MIME 인증서',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (단문 메시지 서비스)',
        'Salutations' => '인사말',
        'Sample command output' => '샘플 명령 출력',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '기사의 첨부 파일을 저장합니다. "DB"는 모든 데이터를 데이터베이스에 저장합니다 (큰 첨부 파일 저장에는 권장되지 않음). "FS"는 데이터를 파일 시스템에 저장합니다. 이것은 더 빠르지 만 웹 서버는 OTRS 사용자 하에서 실행되어야합니다. 데이터 손실없이 이미 생산중인 시스템에서도 모듈 간을 전환 할 수 있습니다. 참고 : "FS"를 사용하면 첨부 파일 이름을 검색 할 수 없습니다.',
        'Schedule a maintenance period.' => '유지 보수 기간을 예약하십시오.',
        'Screen after new ticket' => '새로운 티켓 후에 화면',
        'Search Customer' => '고객 검색',
        'Search Ticket.' => '티켓 검색.',
        'Search Tickets.' => '티켓 검색.',
        'Search User' => '사용자 검색',
        'Search backend default router.' => '백엔드 기본 라우터를 검색합니다.',
        'Search backend router.' => '검색 백엔드 라우터.',
        'Search.' => '검색.',
        'Second Christmas Day' => '두 번째 크리스마스',
        'Second Queue' => '두 번째 대기열',
        'Select after which period ticket overviews should refresh automatically.' =>
            '티켓 개요가 자동으로 새로 고쳐져야하는 기간을 선택하십시오.',
        'Select how many tickets should be shown in overviews by default.' =>
            '개요별로 표시할 티켓 수를 기본적으로 선택하십시오.',
        'Select the main interface language.' => '기본 인터페이스 언어를 선택하십시오.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'CSV 파일 (통계 및 검색)에 사용되는 구분 문자를 선택하십시오. 여기에서 구분 기호를 선택하지 않으면 언어의 기본 구분 기호가 사용됩니다.',
        'Select your frontend Theme.' => '프론트 엔드 테마를 선택하십시오.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '개인 시간대를 선택하십시오. 모든 시간은이 시간대를 기준으로 표시됩니다.',
        'Select your preferred layout for the software.' => '소프트웨어의 기본 레이아웃을 선택하십시오.',
        'Select your preferred theme for OTRS.' => 'OTRS에 대한 선호 테마를 선택하십시오.',
        'Selects the cache backend to use.' => '사용할 캐시 백엔드를 선택합니다.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '웹 인터페이스를 통해 업로드를 처리 할 모듈을 선택합니다. "DB"는 모든 업로드를 데이터베이스에 저장하고 "FS"는 파일 시스템을 사용합니다.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '티켓 번호 생성기 모듈을 선택합니다. "AutoIncrement"는 티켓 번호를 증가시키고, SystemID 및 카운터는 SystemID.counter 형식 (예 : 1010138, 1010139)과 함께 사용됩니다. "날짜"를 사용하면 티켓 번호가 현재 날짜, 시스템 ID 및 카운터에 의해 생성됩니다. 형식은 Year.Month.Day.SystemID.counter와 같습니다 (예 : 200206231010138, 200206231010139). "DateChecksum"을 사용하면 카운터가 date 및 SystemID 문자열에 체크섬으로 추가됩니다. 체크섬은 매일 회전됩니다. 형식은 Year.Month.Day.SystemID.Counter.CheckSum과 같습니다 (예 : 2002070110101520, 2002070110101535).',
        'Send new outgoing mail from this ticket' => '이 티켓에서 보내는 메일을 새로 보냅니다.',
        'Send notifications to users.' => '사용자에게 알림을 보냅니다.',
        'Sender type for new tickets from the customer inteface.' => '고객 인터페이스에서 보낸 새 티켓의 발신자 유형입니다.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '티켓 잠금이 해제 된 경우 소유자에게만 에이전트 후속 알림을 보냅니다. (기본값은 모든 에이전트에게 알림을 보내는 것입니다).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '모든 발신 이메일을 bcc를 통해 지정된 주소로 보냅니다. 백업 목적으로 만 사용하십시오.',
        'Sends customer notifications just to the mapped customer.' => '매핑된 고객에게 고객 알림만 보냅니다.',
        'Sends registration information to OTRS group.' => 'OTRS 그룹에 등록 정보를 보냅니다.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '미리 알림 날짜에 도달 한 후 잠금 해제 된 티켓에 대한 미리 알림을 전송합니다 (티켓 소유자에게만 전송 됨).',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '"티켓 통지"에서 관리 인터페이스에 구성된 통지를 보냅니다.',
        'Sent "%s" notification to "%s" via "%s".' => '"%s"알림을 "%s"에  "%s"을 통해 보냈습니다.',
        'Sent auto follow-up to "%s".' => '자동 추적을 "%s"로 보냈습니다.',
        'Sent auto reject to "%s".' => '자동 거부를 "%s"로 보냈습니다.',
        'Sent auto reply to "%s".' => '자동 응답을 "%s"로 보냈습니다.',
        'Sent email to "%s".' => '"%s"로 이메일을 보냈습니다.',
        'Sent email to customer.' => '고객에게 이메일을 보냈습니다.',
        'Sent notification to "%s".' => '"%s"로 알림을 보냈습니다.',
        'Serbian Cyrillic' => '세르비아어 키릴 문자',
        'Serbian Latin' => '세르비아어 라틴어',
        'Service Level Agreements' => '서비스 수준 계약',
        'Service view' => '서비스 보기',
        'ServiceView' => '서비스 보기',
        'Set a new password by filling in your current password and a new one.' =>
            '현재 암호와 새 암호를 입력하여 새 암호를 설정하십시오.',
        'Set sender email addresses for this system.' => '이 시스템의 보낸 사람 전자 메일 주소를 설정하십시오.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoom에서 인라인 HTML 기사의 기본 높이 (픽셀 단위)를 설정합니다.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '단일 generic 에이전트 작업 실행시 실행될 티켓의 한계를 설정하십시오.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'AgentTicketZoom에서 인라인 HTML 기사의 최대 높이 (픽셀 단위)를 설정합니다.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '최소 로그 레벨을 설정하십시오. \'오류\'를 선택하면 오류 만 기록됩니다. \'디버그\'를 사용하면 모든 로깅 메시지를 얻을 수 있습니다. 로그 수준의 순서는 \'debug\', \'info\', \'notice\'및 \'error\'입니다.',
        'Set this ticket to pending' => '이 티켓을 보류 중으로 설정하십시오.',
        'Sets if SLA must be selected by the agent.' => '에이전트가 SLA를 선택해야하는지 여부를 설정합니다.',
        'Sets if SLA must be selected by the customer.' => '고객이 SLA를 선택해야하는지 여부를 설정합니다.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '에이전트가 노트를 입력해야하는지 설정합니다. Ticket :: Frontend :: NeedAccountedTime으로 덮어 쓸 수 있습니다.',
        'Sets if queue must be selected by the agent.' => '에이전트가 대기열을 선택해야하는지 여부를 설정합니다.',
        'Sets if service must be selected by the agent.' => '에이전트가 서비스를 선택해야하는지 여부를 설정합니다.',
        'Sets if service must be selected by the customer.' => '고객이 서비스를 선택해야하는지 여부를 설정합니다.',
        'Sets if state must be selected by the agent.' => '에이전트가 상태를 선택해야하는지 설정합니다.',
        'Sets if ticket owner must be selected by the agent.' => '에이전트가 티켓 소유자를 선택해야하는지 설정합니다.',
        'Sets if ticket responsible must be selected by the agent.' => '책임 티켓을 에이전트가 선택해야하는지 설정합니다.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '상태가 비 보류 상태로 변경되면 티켓의 PendingTime을 0으로 설정합니다.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '손길이 닿지 않은 티켓이있는 대기열을 강조 표시 할 때의 경과 시간 (1 단계)을 설정합니다.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '변경되지 않은 티켓이 포함된 대기열을 강조 표시할 때의 경과 시간 (초 단위)을 설정합니다.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '관리자의 구성 수준을 설정합니다. 구성 수준에 따라 일부 sysconfig 옵션이 표시되지 않습니다. 구성 수준은 오름차순으로되어 있습니다 : 전문가, 고급, 초보자. 구성 수준이 높을수록 (예 : 초보자가 가장 높음), 사용자가 실수로 더 이상 사용할 수없는 방식으로 시스템을 구성 할 가능성이 줄어 듭니다.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '티켓 개요의 미리보기 모드에서 볼 수 있는 기사의 수를 설정합니다.',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 전자 메일 티켓에 대한 기본 아티클 고객 가시성을 설정합니다.',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 전화 티켓에 대한 기본 아티클 고객 가시성을 설정합니다.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫이 화면에 추가된 메모의 기본 본문 텍스트를 설정합니다.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면에 추가 된 노트의 기본 본문 텍스트를 설정합니다.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에 추가 된 노트의 기본 본문 텍스트를 설정합니다.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 소유자 화면에 추가 된 노트의 기본 본문 텍스트를 설정합니다.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소된 티켓의 티켓 보류 화면에 추가된 노트의 기본 본문 텍스트를 설정합니다.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 우선 순위 화면에 추가 된 노트의 기본 본문 텍스트를 설정합니다.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 추가 된 노트의 기본 본문 텍스트를 설정합니다.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '에이전트 시스템 및 고객 인터페이스의 로그인 화면에 대한 기본 오류 메시지를 설정합니다. 이는 실행중인 시스템 유지 보수 기간이 활성 일 때 표시됩니다.',
        'Sets the default link type of split tickets in the agent interface.' =>
            '에이전트 인터페이스에서 분할 티켓의 기본 링크 유형을 설정합니다.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '에이전트 인터페이스에서 분할 된 티켓의 기본 링크 유형을 설정합니다.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '에이전트 시스템 및 고객 인터페이스의 로그인 화면에 대한 기본 메시지를 설정합니다. 이는 실행중인 시스템 유지 보수 기간이 활성 상태 일 때 표시됩니다.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            '실행중인 시스템 유지 보수 기간에 알림의 기본 메시지가 표시되도록 설정합니다.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 전화 티켓의 기본 다음 상태를 설정합니다.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '에이전트 인터페이스에서 전자 메일 티켓을 만든 후 기본 티켓 상태를 설정합니다.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '새 전화 티켓의 기본 메모 텍스트를 설정합니다. 예 : 상담원 인터페이스의 \'통화를 통한 신규 티켓\'',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 전자 메일 티켓의 기본 우선 순위를 설정합니다.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 전화 티켓의 기본 우선 순위를 설정합니다.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 전자 메일 티켓의 기본 보낸 사람 유형을 설정합니다.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '에이전트 인터페이스에서 새 전화 티켓의 기본 발신자 유형을 설정합니다.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '에이전트 인터페이스에서 새 이메일 티켓의 기본 제목 (예 : \'이메일 발신\')을 설정합니다.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '상담원 인터페이스에서 새 전화 티켓의 기본 제목 (예 : \'전화 통화\')을 설정합니다.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에 추가 된 노트의 기본 제목을 설정합니다.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면에 추가된 노트의 기본 제목을 설정합니다.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에 추가 된 노트의 기본 제목을 설정합니다.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 된 티켓의 티켓 소유자 화면에 추가 된 노트의 기본 제목을 설정합니다.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 추가 된 노트의 기본 제목을 설정합니다.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 우선 순위 화면에 추가 된 노트의 기본 제목을 설정합니다.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 담당 화면에 추가 된 노트의 기본 제목을 설정합니다.',
        'Sets the default text for new email tickets in the agent interface.' =>
            '에이전트 인터페이스에서 새 전자 메일 티켓의 기본 텍스트를 설정합니다.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '세션이 종료되고 사용자가 로그 아웃하기 전에 비 활동 시간 (초)을 설정합니다.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '로그인 된 에이전트에 대해 이전 경고가 표시되기 전에 SessionMaxIdleTime에 정의 된 시간 범위 내에서 활성 에이전트의 최대 수를 설정합니다.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            'SessionMaxIdleTime에 정의 된 시간 범위 내에서 활성 에이전트의 최대 수를 설정합니다.',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            'SessionMaxIdleTime에 정의 된 시간 범위 내의 활성 고객의 최대 수를 설정합니다.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            'SessionMaxIdleTime에 정의 된 시간 범위 내에서 에이전트 당 최대 활성 세션 수를 설정합니다.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            'SessionMaxIdleTime에 정의 된 시간 범위 내에서 고객 당 활성 세션의 최대 수를 설정합니다.',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            'PGP가 전자 메일을 노래하고 암호화하는 데 사용할 방법을 설정합니다. 참고 인라인 메서드는 서식있는 텍스트 메시지와 호환되지 않습니다.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '"AutoIncrement"가 TicketNumberGenerator로 선택된 경우 최소 티켓 카운터 크기를 설정합니다. 기본값은 5이며, 이는 카운터가 10000에서 시작 함을 의미합니다. ',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '다가오는 시스템 유지 보수 기간에 대한 알림을 표시하는 시간을 설정합니다.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '문자 메시지에 표시되는 줄 수를 설정합니다 (예 : QueueZoom의 티켓 줄).',
        'Sets the options for PGP binary.' => 'PGP 바이너리의 옵션을 설정합니다.',
        'Sets the password for private PGP key.' => '비공개 PGP 키의 암호를 설정합니다.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '선호 시간 단위 (예 : 작업 단위, 시간, 분)를 설정합니다.',
        'Sets the preferred digest to be used for PGP binary.' => 'PGP 바이너리에 사용할 선호 다이제스트를 설정합니다.',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '접두어를 웹 서버에 구성된대로 서버의 scripts 폴더에 설정합니다. 이 설정은 응용 프로그램에서 사용하는 모든 형식의 메시징에서 발견되는 변수 인 OTRS_CONFIG_ScriptAlias로 사용되어 시스템 내의 티켓에 대한 링크를 작성합니다.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소된 티켓의 티켓 닫기 화면에서 대기열을 설정합니다.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 프리 텍스트 화면에 대기열을 설정합니다.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 메모 화면에 대기열을 설정합니다.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 소유자 화면에 대기열을 설정합니다.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 대기열을 설정합니다.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 우선 순위 화면에 대기열을 설정합니다.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 책임 화면에 대기열을 설정합니다.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 닫기 티켓 화면에서 티켓의 담당 에이전트를 설정합니다.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 티켓의 담당 에이전트를 설정합니다.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '티켓의 담당 에이전트를 에이전트 인터페이스의 티켓 프리 텍스트 화면에 설정합니다.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 티켓의 담당 에이전트를 설정합니다.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 소유자 화면에 티켓의 책임자를 설정합니다.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '티켓의 담당 에이전트를 에이전트 인터페이스의 확대 된 티켓의 티켓 보류 화면에 설정합니다.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 우선 순위 화면에 티켓의 책임자를 설정합니다.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 티켓의 담당 에이전트를 설정합니다.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '에이전트 인터페이스의 닫기 티켓 화면에 서비스를 설정합니다 (Ticket :: Service를 활성화해야 함).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '에이전트 인터페이스의 티켓 프리 텍스트 화면에 서비스를 설정합니다 (Ticket :: Service를 활성화해야 함).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '에이전트 인터페이스의 티켓 메모 화면에 서비스를 설정합니다 (Ticket :: Service를 활성화해야 함).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 소유자 화면에 서비스를 설정합니다 (Ticket :: Service를 활성화해야 함).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 서비스를 설정합니다 (Ticket :: Service를 활성화해야 함).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 우선 순위 화면에 서비스를 설정합니다 (Ticket :: Service를 활성화해야 함).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '에이전트 인터페이스의 티켓 책임 화면에 서비스를 설정합니다 (Ticket :: Service를 활성화해야 함).',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에서 티켓의 상태를 설정합니다.',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 티켓의 상태를 설정합니다.',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 프리 텍스트 화면에서 티켓의 상태를 설정합니다.',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 티켓의 상태를 설정합니다.',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 담당 화면에서 티켓의 상태를 설정합니다.',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 소유자 화면에서 티켓의 상태를 설정합니다.',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 티켓의 상태를 설정합니다.',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 우선 순위 화면에서 티켓의 상태를 설정합니다.',
        'Sets the stats hook.' => '통계 후크를 설정합니다.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 닫기 티켓 화면에서 티켓 소유자를 설정합니다.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 티켓 소유자를 설정합니다.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 프리 텍스트 화면에 티켓 소유자를 설정합니다.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 티켓 소유자를 설정합니다.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 소유자 화면에서 티켓 소유자를 설정합니다.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 티켓 소유자를 설정합니다.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대 된 티켓의 티켓 우선 순위 화면에 티켓 소유자를 설정합니다.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 티켓 소유자를 설정합니다.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '에이전트 인터페이스의 티켓 닫기 화면에서 티켓 유형을 설정합니다 (Ticket :: Type을 활성화해야합니다).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 티켓 유형을 설정합니다.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '에이전트 인터페이스의 티켓 프리 텍스트 화면에 티켓 유형을 설정합니다 (Ticket :: Type을 활성화해야합니다).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 티켓 유형을 설정합니다 (Ticket :: Type을 활성화해야합니다).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 소유자 화면에 티켓 유형을 설정합니다 (Ticket :: Type을 활성화해야합니다).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 보류 화면에 티켓 유형을 설정합니다 (Ticket :: Type을 활성화해야합니다).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '에이전트 인터페이스에서 확대 / 축소 된 티켓의 티켓 우선 순위 화면에 티켓 유형을 설정합니다 (Ticket :: Type을 활성화해야합니다).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '에이전트 인터페이스의 티켓 책임 화면에 티켓 유형을 설정합니다 (Ticket :: Type을 활성화해야합니다).',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            'OTRS에 의해 내부적으로 사용되는 시간대를 e로 설정합니다. 지. 날짜와 시간을 데이터베이스에 저장하십시오. 경고 :이 설정은 일단 설정하고 티켓 또는 날짜 / 시간이 포함 된 다른 데이터를 작성한 후에 변경하면 안됩니다.',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            '새로 생성 된 사용자에게 할당되고 아직 시간대를 설정하지 않은 사용자에게 사용될 시간대를 설정합니다. 이 시간대는 OTRS 시간대와 사용자 시간대 사이의 날짜와 시간을 변환하기 위해 기본값으로 사용됩니다.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'http / ftp 다운로드에 대한 시간 초과 (초)를 설정합니다.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '패키지 다운로드의 시간 초과 (초)를 설정합니다. "WebUserAgent :: Timeout"을 덮어 씁니다.',
        'Shared Secret' => '공유된 비밀',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '상담원 인터페이스에서 전화 및 전자 메일 티켓에 책임감 있는 선택을 표시합니다.',
        'Show article as rich text even if rich text writing is disabled.' =>
            '리치 텍스트 쓰기가 비활성화된 경우에도 기사를 리치 텍스트로 표시하십시오.',
        'Show command line output.' => '명령 행 출력보기.',
        'Show queues even when only locked tickets are in.' => '잠긴 티켓만 있는 경우에도 대기열을 표시하십시오.',
        'Show the current owner in the customer interface.' => '고객 인터페이스에 현재 소유자를 표시하십시오.',
        'Show the current queue in the customer interface.' => '고객 인터페이스에 현재 대기열을 표시하십시오.',
        'Show the history for this ticket' => '이 티켓의 기록 표시',
        'Show the ticket history' => '티켓 기록보기',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '기사에 첨부 파일이 있는 경우 티켓 확대 / 축소의 첨부 파일 수를 표시합니다.',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '에이전트 인터페이스의 티켓 확대보기에서 직접 티켓에 링크 된 일정 약속을 만드는 링크를 메뉴에 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '에이전트 인터페이스의 티켓 확대보기에서 티켓을 구독하거나 탈퇴하기위한 링크를 메뉴에 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에서 티켓을 에이전트 인터페이스의 티켓 확대보기에서 다른 오브젝트와 링크 할 수있는 링크를 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '에이전트 인터페이스의 티켓 확대보기에서 티켓을 병합 할 수있는 링크를 메뉴에 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에서 티켓 기록에 액세스합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에 자유 텍스트 필드를 추가합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 상담원 인터페이스의 티켓 확대보기에 메모를 추가합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '메뉴에 링크를 표시하여 상담원 인터페이스의 모든 티켓 개요에 있는 티켓에 메모를 추가합니다.',
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
            '메뉴의 링크를 표시하여 에이전트 인터페이스의 모든 티켓 개요에서 티켓을 닫습니다.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에서 티켓을 닫습니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 모든 티켓 개요에서 티켓을 삭제합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에서 티켓을 삭제합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에서 티켓을 프로세스에 등록합니다.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크가 표시되어 상담원 인터페이스의 티켓 확대보기로 돌아갑니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '에이전트 인터페이스의 티켓 개요에서 티켓을 잠그거나 잠금 해제할 수 있는 링크를 메뉴에 표시합니다.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '에이전트 인터페이스의 티켓 확대보기에서 티켓을 잠 그거나 잠금 해제 할 수있는 링크를 메뉴에 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 모든 티켓 개요에서 티켓을 이동합니다.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에서 티켓이나 기사를 에이전트 인터페이스의 티켓 확대보기로 인쇄 할 수있는 링크를 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 모든 티켓 개요에 있는 티켓의 내역을 확인합니다.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에서 티켓의 우선 순위를 확인합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에서 아웃 바운드 전자 메일을 보냅니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 모든 티켓 개요에 티켓을 정크로 설정합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 확대보기에서 보류중인 티켓을 설정합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 모든 티켓 개요에 있는 티켓의 우선 순위를 설정합니다.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '메뉴에 링크를 표시하여 에이전트 인터페이스의 티켓 개요에서 티켓을 확대 / 축소합니다.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '에이전트 인터페이스의 기사 확대보기에서 html 온라인 뷰어를 통해 기사 첨부물에 액세스하는 링크를 표시합니다.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '에이전트 인터페이스의 기사 확대 / 축소보기에서 기사 첨부 파일을 다운로드 하는 링크를 표시합니다.',
        'Shows a link to see a zoomed email ticket in plain text.' => '확대 / 축소된 전자 메일 티켓을 일반 텍스트로 보려면 링크를 표시합니다.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '에이전트 인터페이스의 티켓 확대보기에서 티켓을 쓰레기로 설정하는 링크를 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다. 클러스터 항목 메뉴를 사용하려면 Key "ClusterName"에 사용하고 Content 이름에는 UI에 표시합니다. "ClusterPriority"를 사용하여 툴바에서 특정 클러스터의 순서를 구성하십시오.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 닫기 티켓 화면에서 이 티켓에 관련된 모든 에이전트의 목록을 표시합니다.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓없는 텍스트 화면에 이 티켓의 모든 관련 에이전트 목록을 표시합니다.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 이 티켓에 관련된 모든 에이전트의 목록을 표시합니다.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대된 티켓의 티켓 소유자 화면에서 이 티켓에 관련된 모든 에이전트의 목록을 표시합니다.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대된 티켓의 티켓 보류 화면에 이 티켓에 이 티켓에 포함된 모든 관련 에이전트의 목록을 표시합니다.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대된 티켓의 티켓 우선 순위 화면에서 이 티켓에 관련된 모든 에이전트의 목록을 표시합니다.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에서 이 티켓에 관련된 모든 에이전트의 목록을 표시합니다.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '가능한 모든 에이전트 (대기열 / 티켓에 대한 메모 권한이있는 모든 에이전트)의 목록을 표시하여 에이전트 인터페이스의 티켓 닫기 화면에서이 메모에 대한 정보를 알릴 사용자를 결정합니다.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓없는 텍스트 화면에서 가능한 모든 에이전트 (큐 / 티켓에 대한 메모 권한이있는 모든 에이전트)의 목록을 표시하여이 참고 사항에 대해 사용자에게 알릴 정보를 결정합니다.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 가능한 모든 에이전트 (대기열 / 티켓에 대한 메모 권한을 가진 모든 에이전트)의 목록을 표시하여이 참고 사항에 대해 사용자에게 알릴 정보를 결정합니다.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스의 확대 된 티켓의 티켓 소유자 화면에서 가능한 모든 에이전트 (대기열 / 티켓에 대한 메모 권한이있는 모든 에이전트)의 목록을 표시하여이 참고 사항에 대해 사용자에게 알릴 사용자를 결정합니다.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '가능한 모든 상담원 (대기열 / 티켓에 대한 메모 권한이있는 모든 상담원)의 목록을 표시하여 상담원 인터페이스의 확대 된 티켓의 티켓 보류 화면에서이 메모에 대한 정보를받는 사람을 결정합니다.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '상담원 인터페이스의 확대 된 티켓의 티켓 우선 순위 화면에서 가능한 모든 상담원 (대기열 / 티켓에 대한 메모 권한이있는 모든 상담원)의 목록을 표시하여이 메모에 대한 정보를 알릴 사용자를 결정합니다.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에서 가능한 모든 에이전트 (대기열 / 티켓에 대한 메모 권한이있는 모든 에이전트)의 목록을 표시하여이 참고 사항에 대한 정보를 제공해야합니다.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '티켓 개요의 미리보기를 표시합니다 (CustomerInfo => 1 - Customer-Info, CustomerInfoMaxSize 최대 크기는 Customer-Info의 문자로 표시).',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '메뉴에 OTRS Business Solution ™의 티켓 첨부보기에 대한 티저 링크를 표시합니다.',
        'Shows all both ro and rw queues in the queue view.' => '대기열보기에서 ro 및 rw 대기열을 모두 표시합니다.',
        'Shows all both ro and rw tickets in the service view.' => '서비스보기에서 ro와 rw 티켓을 모두 표시합니다.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '에이전트 인터페이스의 에스컬레이션 보기에서 열려있는 모든 티켓(잠긴 경우에도 있음)을 표시합니다.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '에이전트 확대 / 축소보기에서 티켓의 모든 항목을 표시합니다(확장된).',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '고객 확대보기에서 티켓의 모든 기사를 표시합니다(확장 된).',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '다중 선택 필드에 모든 고객 식별자를 표시합니다(많은 고객 식별자가 있는 경우 유용하지 않음).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '다중 선택 필드에 모든 고객 사용자 식별자를 표시합니다 (많은 고객 사용자 식별자가 있는 경우 유용하지 않음).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '상담원 인터페이스의 전화 및 전자 메일 티켓에서 소유자 선택을 표시합니다.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'AgentTicketPhone, AgentTicketEmail 및 AgentTicketCustomer에 고객 기록 티켓을 표시합니다.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '마지막 고객 기사의 제목이나 작은 제목 개요의 티켓 제목을 표시합니다.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '시스템의 기존 상위/하위 대기열 목록을 트리 또는 목록 형태로 표시합니다.',
        'Shows information on how to start OTRS Daemon' => 'OTRS 데몬을 시작하는 방법에 대한 정보를 보여줍니다.',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '에이전트 인터페이스의 티켓 확대보기에서 외부 페이지에 대한 링크를 표시합니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '에이전트 인터페이스의 티켓 확대/축소에서 기사를 정상적으로 또는 역순으로 정렬하여 표시합니다.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '작성 화면에서 고객 사용자 정보(전화 및 전자메일)를 표시합니다.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '사용 가능한 티켓 특성을 고객 인터페이스에 표시합니다 (0 = 사용 안 함, 1 = 사용함).',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '에이전트 대시 보드에 오늘의 메시지 (MOTD)를 표시합니다. "그룹"은 플러그인 (예 : 그룹 : 관리자, 그룹 1, 그룹 2)에 대한 액세스를 제한하는 데 사용됩니다. "Default"는 플러그인이 기본적으로 활성화되어 있는지 또는 사용자가 수동으로 활성화해야하는지 여부를 나타냅니다. "필수"는 플러그인이 항상 표시되는지 여부를 결정하며 에이전트가 플러그인을 제거 할 수 없습니다.',
        'Shows the message of the day on login screen of the agent interface.' =>
            '에이전트 인터페이스의 로그인 화면에서 오늘의 메시지를 표시합니다.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '에이전트 인터페이스에서 티켓 내역을 (역순으로) 표시합니다.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에서 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 이동 화면에서 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 대량 화면에서 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓없는 텍스트 화면에서 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에서 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대된 티켓의 티켓 소유자 화면에 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대/축소된 티켓의 티켓 보류 화면에 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대된 티켓의 티켓 우선 순위 화면에 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 티켓 우선 순위 옵션을 표시합니다.',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 닫기 화면에 제목 필드를 표시합니다.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 없는 텍스트 화면에 제목 필드를 표시합니다.',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 메모 화면에 제목 필드를 표시합니다.',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대/축소된 티켓의 티켓 소유자 화면에 제목 필드를 표시합니다.',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대/축소된 티켓의 티켓 보류 화면에 제목 필드를 표시합니다.',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '에이전트 인터페이스에서 확대/축소된 티켓의 티켓 우선 순위 화면에 제목 필드를 표시합니다.',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '에이전트 인터페이스의 티켓 책임 화면에 제목 필드를 표시합니다.',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '사용 가능한 경우 긴 형식 (일, 시간, 분)으로 시간을 표시합니다. 또는 짧은 형식 (일, 시간)으로 설정할 수 있습니다.',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '사용 가능한 경우 시간 사용 완료 설명 (일, 시간, 분)을 표시합니다. 또는 활성화되지 않은 경우 첫 번째 문자 (d, h, m).',
        'Signature data.' => '',
        'Signatures' => '서명',
        'Simple' => '단순한',
        'Skin' => '피부',
        'Slovak' => '슬로바키아 사람',
        'Slovenian' => '슬로베니아',
        'Small' => '작은',
        'Software Package Manager.' => '소프트웨어 패키지 관리자.',
        'Solution time' => '솔루션 시간',
        'SolutionDiffInMin' => 'SolutionDiffInMin',
        'SolutionInMin' => 'SolutionInMin',
        'Some description!' => '어떤 묘사!',
        'Some picture description!' => '어떤 그림 설명!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '대기열보기에서 하나의 대기열을 선택한 경우와 티켓을 우선 순위별로 정렬 한 후에 티켓을 정렬합니다 (오름차순 또는 내림차순). 값 : 0 = 오름차순 (가장 오래된 것, 기본값), 1 = 내림차순 (맨 위에 가장 어린 것). 키에는 QueueID를 사용하고 값에는 0 또는 1을 사용하십시오.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '서비스보기에서 하나의 대기열을 선택한 경우와 티켓을 우선 순위별로 정렬 한 후에 티켓을 정렬합니다 (오름차순 또는 내림차순). 값 : 0 = 오름차순 (가장 오래된 것, 기본값), 1 = 내림차순 (맨 위에 가장 어린 것). 키에는 ServiceID를 사용하고 값에는 0 또는 1을 사용하십시오.',
        'Spam' => '스팸',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '스팸 어쌔신 예제 설정. SpamAssassin으로 표시된 이메일을 무시합니다.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '스팸 어쌔신 예제 설정. 표시된 메일을 스팸 대기열로 이동합니다.',
        'Spanish' => '스페인 사람',
        'Spanish (Colombia)' => '스페인어(콜롬비아)',
        'Spanish (Mexico)' => '스페인어(멕시코)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '전체 텍스트 색인에 대한 스페인어 중지 단어. 이 단어는 검색 색인에서 제거됩니다.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '상담원이 자신의 작업에 대한 전자 메일 알림을 수신해야하는지 여부를 지정합니다.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            'ArticleStorage에 대해 "FS"를 선택한 경우 데이터를 저장할 디렉토리를 지정합니다.',
        'Specifies the directory where SSL certificates are stored.' => 'SSL 인증서가 저장되는 디렉토리를 지정합니다.',
        'Specifies the directory where private SSL certificates are stored.' =>
            '개인 SSL 인증서가 저장되는 디렉토리를 지정합니다.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '알림을 보낼 때 응용 프로그램에서 사용해야하는 전자 메일 주소를 지정합니다. 이메일 주소는 알림 마스터의 전체 표시 이름 (예 : "OTRS Notifications"otrs@your.example.com)을 작성하는 데 사용됩니다. OTRS_CONFIG_FQDN 변수를 설정에 사용하거나 다른 이메일 주소를 선택할 수 있습니다.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '스케줄러 테스크에서 알림 메시지를 가져올 이메일 주소를 지정합니다.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '"SwitchToCustomer"기능에 액세스 할 수 있도록 사용자에게 rw 권한이 필요한 그룹을 지정합니다.',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '다른 사용자 기본 설정을 편집 할 수 있도록 사용자에게 rw 권한이 필요한 그룹을 지정합니다.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '알림을 보낼 때 응용 프로그램에서 사용해야하는 이름을 지정합니다. 발신자 이름은 알림 마스터의 전체 표시 이름 (예 : "OTRS Notifications"otrs@your.example.com)을 작성하는 데 사용됩니다.',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '에이전트의 성 및 성을 표시하는 순서를 지정합니다.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '페이지 머리글에 로고 파일 경로를 지정합니다 (gif | jpg | png, 700 x 100 픽셀).',
        'Specifies the path of the file for the performance log.' => '성능 로그 파일의 경로를 지정합니다.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '웹 인터페이스에서 Microsoft Excel 파일보기를 허용하는 변환기의 경로를 지정합니다.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '웹 인터페이스에서 Microsoft Word 파일보기를 허용하는 변환기의 경로를 지정합니다.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '웹 인터페이스에서 PDF 문서의보기를 허용하는 변환기의 경로를 지정합니다.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '웹 인터페이스에서 XML 파일보기를 허용하는 변환기의 경로를 지정합니다.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '로그 파일에 표시 할 텍스트를 지정하여 CGI 스크립트 항목을 나타냅니다.',
        'Specifies user id of the postmaster data base.' => '전자 메일 관리자 데이터베이스의 사용자 ID를 지정합니다.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '첨부 파일을 찾을 때 모든 저장소 백엔드를 검사할지 여부를 지정합니다. 일부 첨부 파일이 파일 시스템에 있고 다른 파일 시스템에 있는 설치에만 필요합니다.',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '(MIMEBase) 아티클 첨부 파일을 인덱싱하여 검색 할 수 있는지 여부를 지정합니다.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '캐시 파일을 만들 때 사용할 하위 디렉토리 수준 수를 지정하십시오. 이렇게하면 너무 많은 캐시 파일이 하나의 디렉토리에 있는 것을 방지할 수 있습니다.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'OTRS Business Solution ™ 업데이트를 가져 오는 데 사용할 채널을 지정하십시오. 경고 : 개발 릴리스가 완전하지 않을 수 있습니다. 시스템에 복구 할 수없는 오류가 발생할 수 있으며 극단적 인 경우에 응답하지 않을 수 있습니다!',
        'Specify the password to authenticate for the first mirror database.' =>
            '첫 번째 미러 데이터베이스에 대해 인증할 암호를 지정하십시오.',
        'Specify the username to authenticate for the first mirror database.' =>
            '첫 번째 미러 데이터베이스에 대해 인증할 사용자 이름을 지정하십시오.',
        'Stable' => '안정된',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '응용 프로그램 내의 에이전트에 대한 표준 사용 권한. 더 많은 권한이 필요하면 여기에 입력 할 수 있습니다. 권한은 효과가 있도록 정의되어야합니다. 메모, 닫기, 보류 중, 고객, 프리 텍스트, 이동, 작성, 책임, 전달 및 반송과 같은 기타 훌륭한 사용 권한도 내장되어 있습니다. "rw"가 항상 마지막으로 등록 된 권한인지 확인하십시오.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '통계 계산의 시작 번호입니다. 모든 새로운 통계는 이 숫자를 증가시킵니다.',
        'Started response time escalation.' => '응답',
        'Started solution time escalation.' => '응답 시간 확대를 시작했습니다.',
        'Started update time escalation.' => '업데이트 시간 에스컬레이션을 시작했습니다.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '링크 개체 마스크가 시작된 후 활성 개체의 와일드 카드 검색을 시작합니다.',
        'Stat#' => '통계#',
        'States' => '상태',
        'Statistic Reports overview.' => '통계 보고서 개요.',
        'Statistics overview.' => '통계 개요.',
        'Status view' => '상태 보기',
        'Stopped response time escalation.' => '응답 시간 에스컬레이션이 중지되었습니다.',
        'Stopped solution time escalation.' => '중지된 솔루션 시간 에스컬레이션.',
        'Stopped update time escalation.' => '업데이트 시간 에스컬레이션이 중지되었습니다.',
        'Stores cookies after the browser has been closed.' => '브라우저가 닫힌 후에 쿠키를 저장합니다.',
        'Strips empty lines on the ticket preview in the queue view.' => '대기열 보기의 티켓 미리보기에서 빈 줄을 제거합니다.',
        'Strips empty lines on the ticket preview in the service view.' =>
            '서비스보기의 티켓 미리보기에서 빈 줄을 제거합니다.',
        'Support Agent' => '',
        'Swahili' => '스와힐리어',
        'Swedish' => '스웨덴어',
        'System Address Display Name' => '시스템 주소 표시 이름',
        'System Configuration Deployment' => '시스템 구성 배치',
        'System Configuration Group' => '시스템 구성 그룹',
        'System Maintenance' => '시스템 유지 보수',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '템플릿 ↔ 대기열',
        'Textarea' => '텍스트 영역',
        'Thai' => '태국 사람',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '에이전트 인터페이스에서 사용해야하는 에이전트 스킨의 InternalName입니다. Frontend :: Agent :: Skins에서 사용 가능한 스킨을 확인하십시오.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '고객 인터페이스에서 사용해야하는 고객 스킨의 InternalName입니다. Frontend :: Customer :: Skins에서 사용 가능한 스킨을 확인하십시오.',
        'The daemon registration for the scheduler cron task manager.' =>
            '스케줄러 cron 작업 관리자에 대한 데몬 등록.',
        'The daemon registration for the scheduler future task manager.' =>
            '스케줄러 미래 작업 관리자에 대한 데몬 등록.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '스케줄러 제네릭 에이전트 작업 관리자에 대한 데몬 등록입니다.',
        'The daemon registration for the scheduler task worker.' => '스케줄러 태스크 작업자에 대한 데몬 등록.',
        'The daemon registration for the system configuration deployment sync manager.' =>
            '시스템 구성 배포 동기화 관리자에 대한 데몬 등록입니다.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'TicketHook과 티켓 번호 사이의 구분선. 예 : \':\'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '새 에스컬레이션 알림 및 시작 이벤트가 표시되지 않는 이벤트 발생 후 경과 분입니다.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '주제의 형식. \'Left\'는 \'[TicketHook # : 12345]\'Some Subject \',\'Right \'는\'Some Subject [TicketHook # : 12345] \',\'None \'은\'Some Subject \'를 의미하며 티켓 번호는 없음을 의미합니다. 후자의 경우 PostMaster :: CheckFollowUpModule ### 0200-References 설정이 활성화되어 전자 메일 머리글을 기반으로 한 후속 작업을 인식하는지 확인해야합니다.',
        'The headline shown in the customer interface.' => '고객 인터페이스에 표시되는 헤드 라인.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '티켓 식별자 예 : 티켓 #, 콜 #, 마이 티켓 #. 기본값은 Ticket #입니다.',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '스킨 "기본"에 대한 에이전트 인터페이스의 머리글에 표시된 로고입니다. 자세한 설명은 "AgentLogo"를 참조하십시오.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '피부 "아이보리"의 에이전트 인터페이스 헤더에 표시된 로고입니다. 자세한 설명은 "AgentLogo"를 참조하십시오.',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '스킨 "아이보리 - 슬림"을위한 에이전트 인터페이스의 헤더에 표시된 로고. 자세한 설명은 "AgentLogo"를 참조하십시오.',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '스킨 "슬림"을위한 에이전트 인터페이스의 헤더에 표시된 로고. 자세한 설명은 "AgentLogo"를 참조하십시오.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '에이전트 인터페이스의 헤더에 표시된 로고. 이미지의 URL은 스킨 이미지 디렉토리에 대한 상대 URL이거나 원격 웹 서버에 대한 전체 URL 일 수 있습니다.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '고객 인터페이스의 머리글에 표시된 로고입니다. 이미지의 URL은 스킨 이미지 디렉토리에 대한 상대 URL이거나 원격 웹 서버에 대한 전체 URL 일 수 있습니다.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '에이전트 인터페이스의 로그인 상자 상단에 표시된 로고입니다. 이미지의 URL은 스킨 이미지 디렉토리에 대한 상대 URL이거나 원격 웹 서버에 대한 전체 URL 일 수 있습니다.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'AgentTicketZoom의 단일 페이지에서 확장 된 기사의 최대 수입니다.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'AgentTicketZoom의 단일 페이지에 표시되는 기사의 최대 수입니다.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '서버에 다시 연결하기 전에 한 번에 가져온 최대 메일 수입니다.',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '제공 한 비밀 정보가 유효하지 않습니다. 비밀은 문자 (A-Z, 대문자)와 숫자 (2-7) 만 포함하고 16 자로 구성되어야합니다.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '이메일 답장에서 제목의 시작 부분에있는 텍스트입니다 예 : RE, AW 또는 AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '이메일이 전달 될 때 제목의 시작 부분에있는 텍스트입니다 예 : FW, FWD 또는 WG.',
        'The value of the From field' => '',
        'Theme' => '테마',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '이 이벤트 모듈은 CustomerUser의 특성을 DynamicFields 티켓으로 저장합니다. 매핑을 구성하는 방법은 DynamicFieldFromCustomerUser::Mapping 설정을 참조하십시오.',
        'This is a Description for Comment on Framework.' => '이것은 Framework에 대한 설명을위한 설명입니다.',
        'This is a Description for DynamicField on Framework.' => '이것은 Framework의 DynamicField에 대한 설명입니다.',
        'This is the default orange - black skin for the customer interface.' =>
            '이것은 고객 인터페이스의 기본 오렌지색 검정색 스킨입니다.',
        'This is the default orange - black skin.' => '이것은 기본 오랜지색 검은색 피부입니다.',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '이 모듈과 PreRun () 함수는 모든 요청에 ​​대해 정의 된 경우 실행됩니다. 이 모듈은 일부 사용자 옵션을 확인하거나 새 응용 프로그램에 대한 뉴스를 표시하는 데 유용합니다.',
        'This module is part of the admin area of OTRS.' => '이 모듈은 OTRS의 관리 영역의 일부입니다.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '이 옵션은 프로세스 관리 활동 엔티티ID가 저장되는 동적 필드를 정의합니다.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '이 옵션은 프로세스 관리 프로세스 엔티티 ID가 저장되는 동적 필드를 정의합니다.',
        'This option defines the process tickets default lock.' => '이 옵션은 프로세스 티켓 기본 잠금을 정의합니다.',
        'This option defines the process tickets default priority.' => '이 옵션은 프로세스 티켓의 기본 우선 순위를 정의합니다.',
        'This option defines the process tickets default queue.' => '이 옵션은 프로세스 티켓 기본 큐를 정의합니다.',
        'This option defines the process tickets default state.' => '이 옵션은 프로세스 티켓 기본 상태를 정의합니다.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '이 옵션은 고객 사용자가 생성하지 않은 고객 회사 티켓에 대한 액세스를 거부합니다.',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '이 설정을 사용하면 기본 제공 국가 목록을 자신의 국가 목록으로 대체할 수 있습니다. 소규모 그룹을 선택하고 싶을 때 특히 편리합니다.',
        'This setting is deprecated. Set OTRSTimeZone instead.' => '이 설정은 사용되지 않습니다. 대신 OTRSTimeZone을 설정하십시오.',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '이 설정은 대기열보기 뿐만 아니라 모든 개요 화면에서 정렬 속성을 표시합니다.',
        'This will allow the system to send text messages via SMS.' => '이렇게하면 시스템이 SMS를 통해 문자 메시지를 보낼 수 있습니다.',
        'Ticket Close.' => '티켓 닫기.',
        'Ticket Compose Bounce Email.' => '티켓 작성 반송 이메일.',
        'Ticket Compose email Answer.' => '티켓 전자 메일 응답을 작성하십시오.',
        'Ticket Customer.' => '티켓 고객.',
        'Ticket Forward Email.' => '티켓 전달 이메일.',
        'Ticket FreeText.' => 'Ticket FreeText.',
        'Ticket History.' => '티켓 기록.',
        'Ticket Lock.' => '티켓 잠금.',
        'Ticket Merge.' => '표 병합.',
        'Ticket Move.' => '티켓 이동.',
        'Ticket Note.' => '티켓 메모.',
        'Ticket Notifications' => '티켓 알림',
        'Ticket Outbound Email.' => '티켓 아웃 바운드 이메일.',
        'Ticket Overview "Medium" Limit' => '티켓 개요 "Medium"Limit',
        'Ticket Overview "Preview" Limit' => '티켓 개요 "미리보기"제한',
        'Ticket Overview "Small" Limit' => '티켓 개요 "작은"한도',
        'Ticket Owner.' => '티켓 소유자',
        'Ticket Pending.' => '티켓 지연',
        'Ticket Print.' => '티켓 인쇄',
        'Ticket Priority.' => '티켓 심각도',
        'Ticket Queue Overview' => '티켓 대기열 개요',
        'Ticket Responsible.' => '책임 티켓.',
        'Ticket Watcher' => '티켓 워처',
        'Ticket Zoom' => '티켓 확대/축소',
        'Ticket Zoom.' => '티켓 확대/축소.',
        'Ticket bulk module.' => '티켓 벌크 모듈.',
        'Ticket event module that triggers the escalation stop events.' =>
            '에스컬레이션 중지 이벤트를 트리거하는 티켓 이벤트 모듈.',
        'Ticket limit per page for Ticket Overview "Medium".' => '티켓 개요 "보통"에 대한 페이지 당 티켓 한도.',
        'Ticket limit per page for Ticket Overview "Preview".' => '티켓 개요 "미리보기"에 대한 페이지 당 티켓 한도.',
        'Ticket limit per page for Ticket Overview "Small".' => '티켓 개요 "Small"에 대한 페이지 당 티켓 한도.',
        'Ticket notifications' => '티켓 알림',
        'Ticket overview' => '티켓 개요',
        'Ticket plain view of an email.' => '전자 메일의 일반보기 티켓.',
        'Ticket split dialog.' => '티켓 분할 대화 상자.',
        'Ticket title' => '티켓 제목',
        'Ticket zoom view.' => '티켓 줌뷰',
        'TicketNumber' => '티켓번호',
        'Tickets.' => '티켓',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '보류 중 상태 (기본값 : 86400 = 1 일)를 설정하면 실제 시간에 추가되는 시간 초입니다.',
        'To accept login information, such as an EULA or license.' => 'EULA 또는 라이센스와 같은 로그인 정보를 수락합니다.',
        'To download attachments.' => '첨부 파일을 다운로드 하려면.',
        'To view HTML attachments.' => 'HTML 첨부 파일을 봅니다.',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'PackageManager의 OTRS FeatureAddons 목록 표시를 토글합니다.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '도구 모음 단축키 항목입니다. 이 링크를 표시하거나 표시하지 않으려는 추가 액세스 제어는 키 "그룹"과 "rw : group1; move_into : group2"와 같은 내용을 사용하여 수행 할 수 있습니다.',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '약속 알림을위한 전송 선택. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '티켓 알림을위한 전송 선택. 참고 : \'활성\'을 0으로 설정하면 상담원이이 그룹의 개인 환경 설정에서 설정을 편집하지 못하게되지만 관리자가 다른 사용자를 대신하여 설정을 편집 할 수 있습니다. \'PreferenceGroup\'을 사용하여 이러한 설정을 사용자 인터페이스에 표시 할 영역을 제어하십시오.',
        'Tree view' => '트리뷰',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            '특정 티켓 시간을 기준으로 자동 달력 약속을 추가하거나 업데이트 합니다.',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '에스컬레이션을 위해 티켓 에스컬레이션 이벤트 및 알림 이벤트를 트리거합니다.',
        'Turkish' => '터키어',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '투명한 HTTPS 프록시를 사용하는 경우와 같이 SSL 인증서 유효성 검사를 끕니다. 자신의 책임하에 사용하십시오!',
        'Turns on drag and drop for the main navigation.' => '기본 탐색에 대한 드래그 앤 드롭을 켭니다.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '원격 IP 주소 확인을 켭니다. 예를 들어 프록시 팜이나 전화 접속 연결을 통해 응용 프로그램을 사용하는 경우에는 원격 IP 주소가 대부분 요청마다 다릅니다.',
        'Tweak the system as you wish.' => '원하는대로 시스템을 조정하십시오.',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '사용할 데몬 로그 회전 유형 : OTRS 시스템이 파일 순환을 처리하도록하려면 \'OTRS\'를 선택하고 제3자 회전 메커니즘 (즉, logrotate)을 사용하려면 \'외부\'를 선택하십시오. 참고 : 외부 회전 메커니즘은 자체적으로 독립적인 구성이 필요합니다.',
        'Ukrainian' => '우크라이나 말',
        'Unlock tickets that are past their unlock timeout.' => '잠금 해제 시간 초과가 된 티켓의 잠금을 해제하십시오.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '메모가 추가되고 소유자가 부재할 때마다 티켓을 잠금 해제하십시오.',
        'Unlocked ticket.' => '잠금해제된 티켓',
        'Up' => '위',
        'Upcoming Events' => '다가오는 이벤트',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '모든 기사가 보거나 새로운 기사가 생성되면 티켓을 읽습니다.',
        'Update time' => '업데이트 시간',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '티켓 특성이 업데이트 된 후 티켓 에스컬레이션 인덱스를 업데이트 합니다.',
        'Updates the ticket index accelerator.' => '티켓 인덱스 가속기를 업데이트 합니다.',
        'Upload your PGP key.' => 'PGP 키를 업로드하십시오.',
        'Upload your S/MIME certificate.' => 'S / MIME 인증서를 업로드하십시오.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '적용 가능한 경우 에이전트 인터페이스에서 새로운 유형의 선택 및 자동 완성 필드를 사용하십시오 (InputFields).',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '해당되는 경우 고객 인터페이스에서 새로운 유형의 선택 및 자동 완성 필드를 사용하십시오 (InputFields).',
        'User Profile' => '사용자 프로필',
        'UserFirstname' => '사용자이름',
        'UserLastname' => '사용자성',
        'Users, Groups & Roles' => '사용자, 그룹과 역할',
        'Uses richtext for viewing and editing ticket notification.' => '티켓 통지를보고 편집하기 위해 richtext를 사용합니다.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '기사, 인사말, 서명, 표준 템플릿, 자동 응답 및 알림과 같은보기 및 편집을 위해 richtext를 사용합니다.',
        'Vietnam' => '베트남',
        'View all attachments of the current ticket' => '현재 티켓의 첨부 파일 모두보기',
        'View performance benchmark results.' => '실적 벤치 마크 결과를 봅니다.',
        'Watch this ticket' => '티켓보기',
        'Watched Tickets' => '이미본티켓',
        'Watched Tickets.' => '이미본티켓',
        'We are performing scheduled maintenance.' => '우리는 예정된 유지보수를 수행하고 있습니다.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '우리는 예정된 유지 보수를 수행하고 있습니다. 일시적으로 로그인 할 수 없습니다.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '우리는 예정된 유지보수를 수행하고 있습니다. 우리는 곧 온라인으로 돌아와야 합니다.',
        'Web Services' => '웹서비스',
        'Web View' => '웹보기',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '에이전트가 티켓을 만들 때 티켓이 에이전트에 자동으로 잠겨있는지 여부.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '티켓이 병합되면 더이상 활성화되지 않은 티켓에 자동으로 노트가 추가됩니다. 여기에서 이 메모의 본문을 정의할 수 있습니다. (이 텍스트는 상담원이 변경할 수 없습니다)',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '티켓이 병합되면 더이상 활성화되지 않은 티켓에 자동으로 노트가 추가됩니다. 여기에서 이 메모의 제목을 정의할 수 있습니다.(이 주제는 상담원이 변경할 수 없음)',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '티켓이 병합되면 고객에게 "보낸 사람에게 알림"확인란을 설정하여 전자 메일별로 알릴 수 있습니다. 이 텍스트 영역에서는 나중에 에이전트로 수정할 수있는 미리 형식이 지정된 텍스트를 정의 할 수 있습니다.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Ticket :: Frontend :: ZoomCollectMetaFilters에서 구성된 필터를 사용하여 아티클에서 메타 정보를 수집할지 여부.',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            'http에서 https 프로토콜로 모든 요청을 강제로 리디렉션할지 여부입니다. 이 옵션을 활성화하기 전에 웹 서버가 https 프로토콜에 맞게 올바르게 구성되어 있는지 확인하십시오.',
        'Yes, but hide archived tickets' => '예, 보관된 티켓은 숨깁니다.',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '티켓 번호가 "1"인 이메일은 "2"로 반송됩니다. 자세한 내용은이 주소로 문의하십시오.',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            '티켓 번호가 "1"인 이메일은 "2"로 병합됩니다.',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '선호하는 대기열에 대한 대기열 선택. 또한 활성화된 경우 이메일을 통해 대기열에 대한 알림을 받습니다.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '원하는 서비스에 대한 귀하의 서비스 선택. 또한 활성화된 경우 이메일을 통해 해당 서비스에 대한 알림을 받습니다.',
        'Zoom' => '줌',
        'attachment' => '첨부',
        'bounce' => '바운스',
        'compose' => '짓다',
        'debug' => '디버그',
        'error' => '에러',
        'forward' => '전달',
        'info' => '정보',
        'inline' => '인라인',
        'normal' => '표준',
        'notice' => '알림',
        'pending' => '지연',
        'phone' => '전화',
        'responsible' => '책임있는',
        'reverse' => '거꾸로',
        'stats' => '통계',

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
};

1;
