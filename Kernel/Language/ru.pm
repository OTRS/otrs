# --
# Kernel/Language/ru.pm - provides ru language translation
# Copyright (C) 2003 Serg V Kravchenko <skraft at rgs.ru>
# --
# $Id: ru.pm,v 1.12 2004-08-24 08:20:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::ru;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:11:53 2004 by 

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%T, %A %D %B, %Y г.';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Минуты',
      ' 5 minutes' => ' 5 Минут',
      ' 7 minutes' => ' 7 Минут',
      '(Click here to add)' => '',
      '...Back' => '',
      '10 minutes' => '10 Минут',
      '15 minutes' => '15 Минут',
      'Added User "%s"' => '',
      'AddLink' => 'Добавить ссылку',
      'Admin-Area' => 'Администрирование системы',
      'agent' => '',
      'Agent-Area' => '',
      'all' => 'все',
      'All' => 'Все',
      'Attention' => 'Внимание',
      'Back' => 'Назад',
      'before' => '',
      'Bug Report' => 'Отчет об ошибках',
      'Calendar' => '',
      'Cancel' => 'Отказ',
      'change' => 'изменение',
      'Change' => 'Изменение',
      'change!' => 'Сменить!',
      'click here' => 'кликнуть здесь',
      'Comment' => 'Комментарий',
      'Contract' => '',
      'Crypt' => '',
      'Crypted' => '',
      'Customer' => 'Клиент',
      'customer' => '',
      'Customer Info' => '',
      'day' => 'сутки',
      'day(s)' => '',
      'days' => 'сут.',
      'description' => 'описание',
      'Description' => 'Описание',
      'Directory' => '',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работать с UserID 1 (Системная учетная запись)! Создайте другого пользователя!',
      'Done' => 'Готово.',
      'end' => 'В конец',
      'Error' => 'Ошибка',
      'Example' => 'Пример',
      'Examples' => 'Примеры',
      'Facility' => 'Приспособление',
      'FAQ-Area' => '',
      'Feature not active!' => '',
      'go' => 'ОК',
      'go!' => 'ОК!',
      'Group' => 'Группа',
      'History::AddNote' => 'Added note (%s)',
      'History::Bounce' => 'Bounced to "%s".',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Lock' => 'Locked ticket.',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Unlock' => 'Unlocked ticket.',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'Hit' => 'Попадание',
      'Hits' => 'Попадания',
      'hour' => 'час',
      'hours' => 'ч.',
      'Ignore' => 'Пренебречь',
      'invalid' => '',
      'Invalid SessionID!' => 'Неверный SessionID!',
      'Language' => 'Язык',
      'Languages' => 'Языки',
      'last' => '',
      'Line' => 'Линия',
      'Lite' => '',
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешная авторизация! Ваше имя или пароль неверны!',
      'Logout successful. Thank you for using OTRS!' => 'Вход успешен. Благодарим за пользование системой OTRS',
      'Message' => 'Сообщение',
      'minute' => 'минуту',
      'minutes' => 'мин.',
      'Module' => 'Модуль',
      'Modulefile' => 'Файл-модуль',
      'month(s)' => '',
      'Name' => 'Имя',
      'New Article' => '',
      'New message' => 'новоее сообщение',
      'New message!' => 'новоее сообщение!',
      'Next' => '',
      'Next...' => '',
      'No' => 'Нет',
      'no' => 'нет',
      'No entry found!' => '',
      'No Permission!' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'No suggestions' => 'Нет предложений',
      'none' => 'нет',
      'none - answered' => 'нет - отвечен?',
      'none!' => 'нет!',
      'Normal' => '',
      'off' => 'выключено',
      'Off' => 'Выключено',
      'On' => 'Включено',
      'on' => 'включено',
      'Online Agent: %s' => '',
      'Online Customer: %s' => '',
      'Password' => 'Пароль',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Pending till' => 'В очереди до',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Ответьте на эти заявки для перехода к обычному просмотру очереди !',
      'Please contact your admin' => 'Свяжитесь с администратором',
      'please do not edit!' => 'Не редактировать!',
      'possible' => 'возможно',
      'Preview' => '',
      'QueueView' => 'Просмотр очереди',
      'reject' => 'отвергнуть',
      'replace with' => 'заменить на',
      'Reset' => 'Рестарт',
      'Salutation' => 'Приветствие',
      'Session has timed out. Please log in again.' => '',
      'Show closed Tickets' => '',
      'Sign' => '',
      'Signature' => 'Подпись',
      'Signed' => '',
      'Size' => '',
      'Sorry' => 'Звиняйте',
      'Stats' => 'Статистика',
      'Subfunction' => 'Подфункция',
      'submit' => 'ввести',
      'submit!' => 'Ввести!',
      'system' => '',
      'Take this Customer' => '',
      'Take this User' => 'Выбрать этого пользователя',
      'Text' => 'Текст',
      'The recommended charset for your language is %s!' => 'Рекомендуемая кодировка для вашего языка %s',
      'Theme' => 'Тема',
      'There is no account with that login name.' => 'Нет пользователя с таким именем.',
      'Ticket Number' => '',
      'Timeover' => 'Время ожидания истекло',
      'To: (%s) replaced with database email!' => '',
      'top' => 'к началу',
      'Type' => 'Тип',
      'update' => 'обновить',
      'Update' => '',
      'update!' => 'обновить!',
      'Upload' => '',
      'User' => 'Пользователь',
      'Username' => 'Имя пользователя',
      'Valid' => 'Состояние записи',
      'Warning' => 'Предупреждение',
      'week(s)' => '',
      'Welcome to OTRS' => 'Добро пожаловать в OTRS',
      'Word' => 'Слово ?',
      'wrote' => 'записано',
      'year(s)' => '',
      'Yes' => 'Да',
      'yes' => 'да',
      'You got new message!' => 'Получите новоее сообщение!',
      'You have %s new message(s)!' => 'Количество новых сообщений: %s',
      'You have %s reminder ticket(s)!' => 'У Вас в очереди %s заявок!',

    # Template: AAAMonth
      'Apr' => 'Апреля',
      'Aug' => 'Августа',
      'Dec' => 'Декабря',
      'Feb' => 'Февраля',
      'Jan' => 'Января',
      'Jul' => 'Июля',
      'Jun' => 'Ююня',
      'Mar' => 'Марта',
      'May' => 'Мая',
      'Nov' => 'Ноября',
      'Oct' => 'Октября',
      'Sep' => 'Сентября',

    # Template: AAAPreferences
      'Closed Tickets' => '',
      'CreateTicket' => '',
      'Custom Queue' => 'Дополнительная (custom) очередь',
      'Follow up notification' => 'Уведомление об обновлениях',
      'Frontend' => 'Режим пользователя',
      'Mail Management' => 'Управление почтой',
      'Max. shown Tickets a page in Overview.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Move notification' => 'Уведомление о перемещении',
      'New ticket notification' => 'Уведомление о новоей заявке',
      'Other Options' => 'Другие настройки',
      'PhoneView' => 'Заявка по телефону',
      'Preferences updated successfully!' => 'Настройки успешно обновлены',
      'QueueView refresh time' => 'Время обновления монитора очередей',
      'Screen after new ticket' => '',
      'Select your default spelling dictionary.' => '',
      'Select your frontend Charset.' => 'Выберите вашу кодировку.',
      'Select your frontend language.' => 'Выберите ваш язык.',
      'Select your frontend QueueView.' => 'Выберите язык для монитора очередей.',
      'Select your frontend Theme.' => 'Выберите тему интерфейса',
      'Select your QueueView refresh time.' => 'Выберите время обновления монитора очередей.',
      'Select your screen after creating a new ticket.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Прислать мне уведомление, если клиент прислал обновление и я собственник заявки.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Send me a notification if a ticket is unlocked by the system.' => 'Прислать мне уведомление, если заявка освобождена системой.',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Show closed tickets.' => '',
      'Spelling Dictionary' => '',
      'Ticket lock timeout notification' => 'Уведомление о истечении срока блокировки заявки системой',
      'TicketZoom' => '',

    # Template: AAATicket
      '1 very low' => '1 самый низкий',
      '2 low' => '2 низкий',
      '3 normal' => '3 нормальный',
      '4 high' => '4 высокий',
      '5 very high' => '5 самый высокий',
      'Action' => 'Действие',
      'Age' => 'Возраст',
      'Article' => 'Содержимое заявки',
      'Attachment' => 'Прикрепленный файл',
      'Attachments' => 'Прикрепленные файлы',
      'Bcc' => 'Скрытая копия',
      'Bounce' => 'Переслать заявку',
      'Cc' => 'Копия для',
      'Close' => 'Закрыть',
      'closed' => '',
      'closed successful' => 'Закрыт успешно',
      'closed unsuccessful' => 'Закрыт неуспешно',
      'Compose' => 'Создать',
      'Created' => 'Создан',
      'Createtime' => 'Время создания',
      'email' => 'e-mail',
      'eMail' => 'е-Mail',
      'email-external' => 'внешний    e-mail',
      'email-internal' => 'внутренний e-mail',
      'Forward' => 'Переслать',
      'From' => 'От',
      'high' => 'высокий',
      'History' => 'История',
      'If it is not displayed correctly,' => 'Если данный текст отображается некорректно,',
      'lock' => 'блокирован',
      'Lock' => 'Блокировка',
      'low' => 'низкий',
      'Move' => 'Переместить',
      'new' => 'нов',
      'normal' => 'нормальный',
      'note-external' => 'внешняя Заметка',
      'note-internal' => 'внутренняя Заметка',
      'note-report' => 'Заметка-отчет',
      'open' => 'открыт',
      'Owner' => 'Собственник',
      'Pending' => 'В очереди',
      'pending auto close+' => 'очередь на авто закрытие+',
      'pending auto close-' => 'очередь на авто закрытие-',
      'pending reminder' => 'очередное напоминание',
      'phone' => 'телефон',
      'plain' => 'обычный',
      'Priority' => 'Приоритет',
      'Queue' => 'Очередь',
      'removed' => 'удален',
      'Sender' => 'Отправитель',
      'sms' => 'sms',
      'State' => 'Статус',
      'Subject' => 'Тема',
      'This is a' => 'Это',
      'This is a HTML email. Click here to show it.' => 'Это e-mail в HTML формате. Кликните здесь для просмотра',
      'This message was written in a character set other than your own.' => 'Это сообщение написано в кодировке. отличной от вашей.',
      'Ticket' => 'заявка',
      'Ticket "%s" created!' => '',
      'To' => 'Для',
      'to open it in a new window.' => 'открыть в новоем окне',
      'Unlock' => 'Разблокировать',
      'unlock' => 'разблокирован',
      'very high' => 'самый высокий',
      'very low' => 'самый низкий',
      'View' => 'Просмотр',
      'webrequest' => 'web-заявка',
      'Zoom' => 'Подробно',

    # Template: AAAWeekDay
      'Fri' => 'Пятница',
      'Mon' => 'Понед-к',
      'Sat' => 'Суббота',
      'Sun' => 'Воскр-е',
      'Thu' => 'Четверг',
      'Tue' => 'Вторник',
      'Wed' => 'Среда  ',

    # Template: AdminAttachmentForm
      'Add' => '',
      'Attachment Management' => 'Управление прикрепленными файлами',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'Автоматический ответ от',
      'Auto Response Management' => 'Управление авто-ответами',
      'Note' => 'заметка',
      'Response' => 'Ответ',
      'to get the first 20 character of the subject' => 'получить первые 20 символов поля "тема"',
      'to get the first 5 lines of the email' => 'получить первые 5 строк письма',
      'to get the from line of the email' => 'получить поле "от" письма',
      'to get the realname of the sender (if given)' => 'получить (если есть) имя отправителя',
      'to get the ticket id of the ticket' => 'Получить ID заявки',
      'to get the ticket number of the ticket' => 'Получить номер заявки',
      'Useable options' => 'Используемые опции',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Управление пользователями (для клиентов)',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',
      'Result' => '',
      'Search' => '',
      'Search for' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      'The message being composed has been closed.  Exiting.' => 'создаваемое сообщение было закрыто. выход.',
      'This values are read only.' => '',
      'This values are required.' => '',
      'This window must be called from compose window' => 'Это окно должно вызываться из окна ввода',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Изменить %s настроек',
      'Customer User <-> Group Management' => '',
      'Full read and write access to the tickets in this group/queue.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => '',
      'Read only access to the ticket in this group/queue.' => '',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => '',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Изменить пользователя <-> Настройки групп',

    # Template: AdminEmail
      'Admin-Email' => 'e-mail администратора',
      'Body' => 'Тело письма',
      'OTRS-Admin Info!' => 'Информация от администратора OTRS',
      'Recipents' => 'Получатели',
      'send' => '',

    # Template: AdminEmailSent
      'Message sent to' => 'Сообщение отправлено для',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      '-' => '',
      'Add Note' => 'Добавить заметку',
      'Agent' => '',
      'and' => '',
      'CMD' => '',
      'Customer User Login' => '',
      'CustomerID' => 'ID Пользователя',
      'CustomerUser' => 'Пользователь клиента',
      'Days' => '',
      'Delete' => '',
      'Delete tickets' => '',
      'Edit' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'GenericAgent' => '',
      'Hours' => '',
      'Job-List' => '',
      'Jobs' => '',
      'Last run' => '',
      'Minutes' => '',
      'Modules' => '',
      'New Agent' => '',
      'New Customer' => '',
      'New Owner' => '',
      'New Priority' => '',
      'New Queue' => '',
      'New State' => '',
      'New Ticket Lock' => '',
      'No time settings.' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',
      'Save Job as?' => '',
      'Schedule' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Lock' => '',
      'TicketFreeText' => '',
      'Times' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Создать новые группы для контроля доступа различных групп агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
      'Group Management' => 'Управление группами',
      'It\'s useful for ASP solutions.' => 'Это подходит для ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Группа admin должна быть в admin зоне, а stats группа в stat зоне',

    # Template: AdminLog
      'System Log' => 'Системный журнал',
      'Time' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => 'e-mail администратора',
      'Attachment <-> Response' => '',
      'Auto Response <-> Queue' => 'Авто-ответ <-> Очередь',
      'Auto Responses' => 'Авто-ответы',
      'Customer User' => 'Пользователь клиента',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'адреса e-mail',
      'Groups' => 'Группы',
      'Logout' => 'Выход',
      'Misc' => 'Дополнительно',
      'Notifications' => '',
      'PGP Keys' => '',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'PostMaster учетная запись POP3',
      'Responses' => 'Ответы',
      'Responses <-> Queue' => 'Ответы <-> Очередь',
      'Role' => '',
      'Role <-> Group' => '',
      'Role <-> User' => '',
      'Roles' => '',
      'Select Box' => 'Дать команду SELECT',
      'Session Management' => 'Управление сессиями',
      'SMIME Certificates' => '',
      'Status' => '',
      'System' => 'Система',
      'User <-> Groups' => 'Пользователь <-> Группы',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => '',
      'File' => '',
      'Fingerprint' => '',
      'FIXME: WHAT IS PGP?' => '',
      'Identifier' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Key' => 'Ключ',
      'PGP Key Management' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Все входящие письма с едной учетной записи будут перенесены в избранную очередь!',
      'Dispatching' => 'Перенаправление',
      'Host' => 'Сервер',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',
      'POP3 Account Management' => 'Управление учетной записью POP3',
      'Trusted' => 'Безопасный',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'Filtername' => '',
      'Header' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',
      'Match' => '',
      'PostMaster Filter Management' => '',
      'Set' => '',
      'Value' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Очередь <-> Управление авто-ответами',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = без эскалации',
      '0 = no unlock' => '0 = без блокировки',
      'Customer Move Notify' => '',
      'Customer Owner Notify' => '',
      'Customer State Notify' => '',
      'Escalation time' => 'Время до эскалации заявки (увеличение приоритета)',
      'Follow up Option' => 'Параметры авто-слежения ?',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Если заявка закрыта, а клиент прислал дополнение,то заявка будет заблокирована для предыдущего владельца',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Если заявка не будет обслужена в установленное время, показывать только эту заявку',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Если агент заблокировал заявку и не послал ответ клиенту в течение установленного времени, то заявка автоматически разблокируется и станет доступной для остальных агентов',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'Queue Management' => 'Управление очередью',
      'Sub-Queue of' => '',
      'Systemaddress' => 'Системный адрес',
      'The salutation for email answers.' => 'Приветствие для почтовых сообщений',
      'The signature for email answers.' => 'Подпись для почтовых сообщений',
      'Ticket lock after a follow up' => 'Блокировка заявки после прихода дополнения',
      'Unlock timeout' => 'Срок блокировки',
      'Will be the sender address of this queue for email answers.' => 'Установка адреса отправителя для ответов в этой очереди',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Стандартные ответы <-> Управление очередями',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Ответ',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Станд.ответы <-> Настройка прикрепленных файлов по умолчанию',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Ответ - заготовка текста для ответа кклиенту',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'Не забудьте добавить ответ для очереди!',
      'Next state' => '',
      'Response Management' => 'Управление ответами',
      'The current ticket state is' => '',
      'Your email address is new' => '',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',
      'Role Management' => '',

    # Template: AdminRoleGroupChangeForm
      'create' => '',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'Role <-> Group Management' => '',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => '',

    # Template: AdminRoleUserChangeForm
      'Active' => '',
      'Role <-> User Management' => '',
      'Select the role:user relations.' => '',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => '',

    # Template: AdminSMIMEForm
      'Add Certificate' => '',
      'Add Private Key' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'Secret' => '',
      'SMIME Certificate Management' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'имя клиента',
      'for agent firstname' => 'для агента - имя',
      'for agent lastname' => 'для агента - фамилия',
      'for agent login' => '',
      'for agent user id' => '',
      'Salutation Management' => 'Управление приветствиями',

    # Template: AdminSelectBoxForm
      'Limit' => 'Лимит',
      'SQL' => 'SQL',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Выберите из меню',

    # Template: AdminSession
      'kill all sessions' => 'Закрыть все текущие сессии',
      'kill session' => 'Закрыть сессию',
      'Overview' => '',
      'Session' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSignatureForm
      'Signature Management' => 'Управление на подписью',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => '',
      'System State Management' => 'Управление системными состояниями',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Все входящие сообщения с этим полем (Для:) будут направлены в выбранную очередь',
      'Email' => 'e-mail',
      'Realname' => 'Реальное Имя',
      'System Email Addresses Management' => 'Управление системными e-mail адресами',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Не забудьте добавить новоего пользователя в группы!',
      'Firstname' => 'Имя',
      'Lastname' => 'Фамилия',
      'User Management' => 'Управление пользователями',
      'User will be needed to handle tickets.' => 'Для обработки заявок нужен пользователь',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Пользователь <-> Управление группами',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Отказаться от всех изменений и вернуться в окно ввода',
      'Return to the compose screen' => 'вернуться в окно ввода',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Сообщение должно иметь поле ДЛЯ: адресата!',
      'Bounce ticket' => 'Пересылка заявки',
      'Bounce to' => 'Переслать для',
      'Inform sender' => 'Информировать отправителя',
      'Next ticket state' => 'Следующее состояние заявки',
      'Send mail!' => 'Послать e-mail!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Нужен правильный адрес в поле ДЛЯ: (support@rgs.ru)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => '',

    # Template: AgentBulk
      '$Text{"Note!' => '',
      'A message should have a subject!' => 'Сообщение должно иметь поле "тема"!',
      'Note type' => 'Тип заметки',
      'Note!' => 'заметка!',
      'Options' => 'Настройки',
      'Spell Check' => 'Проверка правописания',
      'Ticket Bulk Action' => '',

    # Template: AgentClose
      ' (work units)' => ' (рабочие единицы)',
      'A message should have a body!' => '',
      'Close ticket' => 'Закрыть заявку',
      'Close type' => 'Тип закрытия',
      'Close!' => 'Закрыть!',
      'Note Text' => 'Текст заметки',
      'Time units' => 'Единицы времени',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => '',
      'Attach' => 'Прикреплен файл',
      'Compose answer for ticket' => 'Создать ответ на заявку',
      'for pending* states' => 'для последующих состояний* ',
      'Is the ticket answered' => 'Послан ответ на заявку',
      'Pending Date' => 'Следующая дата',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Изменить клиента заявки',
      'Search Customer' => 'Искать клиента',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'История клиента',

    # Template: AgentCustomerMessage
      'Follow up' => 'Дополнение к заявке',

    # Template: AgentCustomerView
      'Customer Data' => 'Учетные данные клиента',

    # Template: AgentEmailNew
      'All Agents' => '',
      'Clear To' => '',
      'Compose Email' => '',
      'new ticket' => 'новая Заявка',

    # Template: AgentForward
      'Article type' => 'Тип статьи',
      'Date' => 'Дата',
      'End forwarded message' => 'Конец пересланного сообщения',
      'Forward article of ticket' => 'Переслать статью из заявки',
      'Forwarded message from' => 'Переслано сообщение от',
      'Reply-To' => 'Ответ для',

    # Template: AgentFreeText
      'Change free text of ticket' => '',

    # Template: AgentHistoryForm
      'History of' => 'История',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Информация',

    # Template: AgentLookup
      'Lookup' => '',

    # Template: AgentMailboxNavBar
      'All messages' => 'Все сообщения',
      'down' => 'вниз',
      'Mailbox' => 'Почтовый ящик',
      'New' => 'Новый',
      'New messages' => 'Новые сообщения',
      'Open' => 'Открытые',
      'Open messages' => 'Открытые сообщения',
      'Order' => 'Порядок',
      'Pending messages' => 'сообщения в очереди',
      'Reminder' => 'Напоминание',
      'Reminder messages' => 'Напоминающие сообщения',
      'Sort by' => 'Сортировка по',
      'Tickets' => 'Заявки',
      'up' => 'вверх',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',
      'Add a note to this ticket!' => '',
      'Change the ticket customer!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket priority!' => '',
      'Close this ticket!' => '',
      'Shows the detail view of this ticket!' => '',
      'Unlock this ticket!' => '',

    # Template: AgentMove
      'Move Ticket' => '',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Agent Preferences' => '',
      'Bulk Action' => '',
      'Bulk Actions on Tickets' => '',
      'Create new Email Ticket' => '',
      'Create new Phone Ticket' => '',
      'Email-Ticket' => '',
      'Locked tickets' => 'Заблокированные заявки',
      'new message' => 'новое сообщение',
      'Overview of all open Tickets' => '',
      'Phone-Ticket' => '',
      'Preferences' => 'Предпочтения',
      'Search Tickets' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

    # Template: AgentNote
      'Add note to ticket' => 'Добавить заметку к заявке',

    # Template: AgentOwner
      'Change owner of ticket' => 'Изменить собственика заявки',
      'Message for new Owner' => 'сообщение для нового владельца',

    # Template: AgentPending
      'Pending date' => 'В очереди - дата',
      'Pending type' => 'В очереди - тип',
      'Set Pending' => 'В очереди - задать',

    # Template: AgentPhone
      'Phone call' => 'Телефонный звонок',

    # Template: AgentPhoneNew
      'Clear From' => '',

    # Template: AgentPlain
      'ArticleID' => 'ID заметки',
      'Download' => '',
      'Plain' => 'Обыкновенный',
      'TicketID' => 'ID заявки',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => '',
      'You also get notified about this queues via email if enabled.' => '',
      'Your queue selection of your favorite queues.' => '',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Изменить пароль',
      'New password' => 'Новый пароль',
      'New password again' => 'Повтор пароля',

    # Template: AgentPriority
      'Change priority of ticket' => 'Изменить приоритет заявки',

    # Template: AgentSpelling
      'Apply these changes' => 'Применить эти изменения',
      'Spell Checker' => 'Проверка правописания',
      'spelling error(s)' => 'Ошибки правописания',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'на',
      'Site' => 'Место',
      'sort downward' => 'сортировка по убыванию',
      'sort upward' => 'сортировка по возрастанию',
      'Ticket Status' => 'состояние заявки',
      'U' => 'U',

    # Template: AgentTicketLink
      'Delete Link' => '',
      'Link' => '',
      'Link to' => '',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Заявка заблокирована!',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Потраченное на заявку время',
      'Escalation in' => 'Эскалация заявки через',

    # Template: AgentUtilSearch
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket Search' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Поиск истории клиента',
      'Customer history search (e. g. "ID342425").' => 'Поиск истории клиента (напр. "ID342425").',
      'No * possible!' => 'Нельзя использовать символ * !',

    # Template: AgentUtilSearchResult
      'Change search options' => '',
      'Results' => 'Результат',
      'Search Result' => '',
      'Total hits' => 'Кумулятивные попадания',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => '',
      'All open tickets' => 'Все Открытые Заявки',
      'closed tickets' => '',
      'open tickets' => 'Открытые Заявки',
      'or' => '',
      'Provides an overview of all' => 'дает обзор всех',
      'So you see what is going on in your system.' => 'Вы видите состояние системы',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => '',
      'Your own Ticket' => '',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Создать ответ',
      'Contact customer' => 'Связаться с клиентом',
      'phone call' => 'телефонный звонок',

    # Template: AgentZoomArticle
      'Split' => '',

    # Template: AgentZoomBody
      'Change queue' => 'Переместить в другую очередь',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => '',
      'Free Fields' => '',
      'Link this ticket to an other one!' => '',
      'Lock it to work on it!' => '',
      'Print' => 'Печать',
      'Print this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Shows the ticket history!' => '',

    # Template: AgentZoomStatus
      '"}","18' => '',
      'Locked' => '',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'напечатано ',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Создать учетную запись',
      'Login' => 'Учетное имя',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => '',
      'Keywords' => '',
      'Last update' => '',
      'Problem' => '',
      'Solution' => '',
      'Symptom' => '',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
      'Modified' => '',

    # Template: CustomerFAQOverview
      'FAQ Overview' => '',

    # Template: CustomerFAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => '',

    # Template: CustomerFooter
      'Powered by' => 'Powered by',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Забыли свой пароль',
      'Request new password' => 'Прислать новый пароль',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Создать новую Заявку',
      'FAQ' => 'FAQ (чаВо) Часто Задаваемые Вопросы',
      'MyTickets' => '',
      'New Ticket' => 'новая Заявка',
      'Welcome %s' => 'Приветствуем %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Кликнуть здесь,чтобы послать сообщение об ошибке',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'A article should have a title!' => '',
      'Comment (internal)' => '',
      'Filename' => '',
      'Title' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => '',
      'Name is required!' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => '',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => '',
      'Drop Database' => '',
      'Finished' => '',
      'System Settings' => '',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => '',
      'After doing so your OTRS is up and running.' => '',
      'Have a lot of fun!' => '',
      'Restart your webserver' => '',
      'Start page' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Your OTRS Team' => '',

    # Template: InstallerLicense
      'accept license' => '',
      'don\'t accept license' => '',
      'License' => '',

    # Template: InstallerStart
      'Create new database' => '',
      'DB Admin Password' => '',
      'DB Admin User' => '',
      'DB Host' => '',
      'DB Type' => '',
      'default \'hot\'' => '',
      'Delete old database' => '',
      'next step' => 'следующий шаг',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => '(e-mail системного администратора)',
      '(Full qualified domain name of your system)' => '(Полное доменное имя (FQDN) вашей системы)',
      '(Logfile just needed for File-LogModule!)' => '(Журнал-файл необходим только для модуля File-Log)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(ID системы. Каждый номер Заявки и каждая http сессия будет начинаться с этого числа)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '(Используемый язык по умолчанию)',
      '(Used log backend)' => '(Используемый журнал backend)',
      '(Used ticket number format)' => '(Используемый формат номеров Заявок)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Кодировка по умолчанию',
      'Default Language' => 'язык по умолчанию',
      'Logfile' => 'Файл журнала',
      'LogModule' => 'Модуль журнала ',
      'Organization' => 'Организация',
      'System FQDN' => 'Системное FQDN',
      'SystemID' => 'Системный ID',
      'Ticket Hook' => 'Зацепить Заявку',
      'Ticket Number Generator' => 'Генератор номера Заявки',
      'Use utf-8 it your database supports it!' => '',
      'Webfrontend' => 'Web-интерфейс',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Нет прав',

    # Template: Notify

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: QueueView
      'All tickets' => 'Все Заявки',
      'Page' => '',
      'Queues' => 'очереди',
      'Tickets available' => '',
      'Tickets shown' => 'Показаны Заявки',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'Тестовая страница OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Истекло время до эскалации заявки !',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Начало',

    # Template: customer-css
      'Contact' => 'Контакт',
      'Online-Support' => 'Горячая поддержка',
      'Products' => 'Продукты',
      'Support' => 'Поддержка',

    # Misc
      '"}","15' => '',
      '"}","30' => '',
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(ID Заявки. Некоторые задают как \'Ticket#\', \'Call#\' или \'MyTicket#\')',
      'A message should have a From: recipient!' => 'сообщение должно иметь поле ОТ: отправитель',
      'Add auto response' => 'Добавить автоматический ответ',
      'AgentFrontend' => 'Режим пользователя',
      'Article free text' => 'Свободный текст статьи',
      'Backend' => 'Фон',
      'BackendMessage' => 'Фоновое сообщение',
      'Change Response <-> Attachment settings' => 'Сменить ответ <-> Настройка прикрепленных файлов',
      'Change answer <-> queue settings' => 'Изменение ответа <-> Настройки очереди',
      'Change auto response settings' => 'Настройка авто-ответов',
      'Charset' => 'Кодировка',
      'Charsets' => 'Кодировки',
      'Create' => 'Создать',
      'Customer called' => 'Звонок клиенту: ',
      'Customer info' => 'Данные о клиенте',
      'Customer user will be needed to to login via customer panels.' => 'Пользователь (клиент) должен войти в систему через клиентский интерфейс',
      'FAQ State' => '',
      'Feature not acitv!' => 'Функция не активна',
      'Fulltext search' => 'Полный текстовый поиск',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Полный текстовый поиск (прим. "Mar*in" или "Baue*" или "martin+hallo")',
      'Graphs' => 'Графики',
      'Handle' => 'Манипулятор',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Если ваша учетная запись безопасна, то будет использован x-otrs заголовок !',
      'Lock Ticket' => '',
      'Max Rows' => 'Макс. строк',
      'My Tickets' => 'Мои Заявки',
      'New state' => 'новое состояние',
      'New ticket via call.' => 'новая Заявка через звонок',
      'New user' => 'Новый пользователь',
      'Pending!' => '',
      'Phone call at %s' => 'Телефонный звонок в %s',
      'Please go away!' => '',
      'PostMasterFilter Management' => '',
      'Screen after new phone ticket' => '',
      'Search in' => 'Искать в',
      'Select source:' => '',
      'Select your custom queues' => 'Выберите Вашу дополнительную очередь',
      'Select your screen after creating a new ticket via PhoneView.' => '',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Прислать мне уведомление, если заявка перемещена в дополнительную очередь',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Прислать мне уведомление, если есть новая заявка в моих дополнительных очередях.',
      'SessionID' => 'Идентификатор сессии',
      'Set customer id of a ticket' => 'Задать ID клиента заявки',
      'Short Description' => '',
      'Show all' => 'Показать все',
      'Status defs' => 'Определение статуса',
      'System Charset Management' => 'Управление системной кодировкой',
      'System Language Management' => 'Настройка системного языка',
      'Ticket available' => 'Имеющиеся Заявки',
      'Ticket free text' => 'Свободный текст заявки',
      'Ticket limit:' => 'Время действия заявки:',
      'Ticket-Overview' => 'обзор Заявок',
      'Time till escalation' => 'Время до эскалации (увеличения приоритета)',
      'Utilities' => 'Утилиты',
      'With State' => 'при состоянии',
      'You have to be in the admin group!' => 'Вы должны быть в группе admin!',
      'You have to be in the stats group!' => 'Вы должны быть в группе stat!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Должен быть e-mail адрес (напр. customer@example.com) в поле ОТ:',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Ваше письмо с номером заявки "<OTRS_TICKET>" передано "<OTRS_BOUNCE_TO>". Свяжитесь с получателем для дальнейшей информации',
      'auto responses set' => 'выбор авто-ответов',
      'by' => '',
      'invalid-temporarily' => '',
      'search' => 'Искать',
      'search (e. g. 10*5155 or 105658*)' => 'Искать (напр. 10*5155 или 105658*)',
      'store' => 'сохранить',
      'tickets' => 'Заявки',
      'valid' => 'Состояние записи',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
