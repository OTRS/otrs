# --
# Kernel/Language/ru.pm - provides ru language translation
# Copyright (C) 2003 Serg V Kravchenko <skraft at rgs.ru>
# --
# $Id: ru.pm,v 1.4 2004-01-21 23:46:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::ru;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Thu Jan 22 00:29:13 2004 by 

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
      '10 minutes' => '10 Минут',
      '15 minutes' => '15 Минут',
      'AddLink' => 'Добавить ссылку',
      'Admin-Area' => 'Администрирование системы',
      'agent' => '',
      'Agent-Area' => '',
      'all' => 'все',
      'All' => 'Все',
      'Attention' => 'Внимание',
      'Bug Report' => 'Отчет об ошибках',
      'Cancel' => 'Отказ',
      'change' => 'изменение',
      'Change' => 'Изменение',
      'change!' => 'Сменить!',
      'click here' => 'кликнуть здесь',
      'Comment' => 'Комментарий',
      'Customer' => 'Клиент',
      'customer' => '',
      'Customer Info' => '',
      'day' => 'сутки',
      'days' => 'сут.',
      'description' => 'описание',
      'Description' => 'Описание',
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
      'Hit' => 'Попадание',
      'Hits' => 'Попадания',
      'hour' => 'час',
      'hours' => 'ч.',
      'Ignore' => 'Пренебречь',
      'invalid' => '',
      'Invalid SessionID!' => 'Неверный SessionID!',
      'Language' => 'Язык',
      'Languages' => 'Языки',
      'Line' => 'Линия',
      'Lite' => '',
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешная авторизация! Ваше имя или пароль неверны!',
      'Logout successful. Thank you for using OTRS!' => 'Вход успешен. Благодарим за пользование системой OTRS',
      'Message' => 'Сообщение',
      'minute' => 'минуту',
      'minutes' => 'мин.',
      'Module' => 'Модуль',
      'Modulefile' => 'Файл-модуль',
      'Name' => 'Имя',
      'New Article' => '',
      'New message' => 'новоее сообщение',
      'New message!' => 'новоее сообщение!',
      'No' => 'Нет',
      'no' => 'нет',
      'No entry found!' => '',
      'No suggestions' => 'Нет предложений',
      'none' => 'нет',
      'none - answered' => 'нет - отвечен?',
      'none!' => 'нет!',
      'Off' => 'Выключено',
      'off' => 'выключено',
      'On' => 'Включено',
      'on' => 'включено',
      'Password' => 'Пароль',
      'Pending till' => 'В очереди до',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Ответьте на эти заявки для перехода к обычному просмотру очереди !',
      'Please contact your admin' => 'Свяжитесь с администратором',
      'please do not edit!' => 'Не редактировать!',
      'Please go away!' => '',
      'possible' => 'возможно',
      'QueueView' => 'Просмотр очереди',
      'reject' => 'отвергнуть',
      'replace with' => 'заменить на',
      'Reset' => 'Рестарт',
      'Salutation' => 'Приветствие',
      'Session has timed out. Please log in again.' => '',
      'Show closed Tickets' => '',
      'Signature' => 'Подпись',
      'Sorry' => 'Звиняйте',
      'Stats' => 'Статистика',
      'Subfunction' => 'Подфункция',
      'submit' => 'ввести',
      'submit!' => 'Ввести!',
      'system' => '',
      'Take this User' => 'Выбрать этого пользователя',
      'Text' => 'Текст',
      'The recommended charset for your language is %s!' => 'Рекомендуемая кодировка для вашего языка %s',
      'Theme' => 'Тема',
      'There is no account with that login name.' => 'Нет пользователя с таким именем.',
      'Timeover' => 'Время ожидания истекло',
      'To: (%s) replaced with database email!' => '',
      'top' => 'к началу',
      'update' => 'обновить',
      'update!' => 'обновить!',
      'User' => 'Пользователь',
      'Username' => 'Имя пользователя',
      'Valid' => 'Состояние записи',
      'Warning' => 'Предупреждение',
      'Welcome to OTRS' => 'Добро пожаловать в OTRS',
      'Word' => 'Слово ?',
      'wrote' => 'записано',
      'yes' => 'да',
      'Yes' => 'Да',
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
      'Screen after new phone ticket' => '',
      'Select your default spelling dictionary.' => '',
      'Select your frontend Charset.' => 'Выберите вашу кодировку.',
      'Select your frontend language.' => 'Выберите ваш язык.',
      'Select your frontend QueueView.' => 'Выберите язык для монитора очередей.',
      'Select your frontend Theme.' => 'Выберите тему интерфейса',
      'Select your QueueView refresh time.' => 'Выберите время обновления монитора очередей.',
      'Select your screen after creating a new ticket via PhoneView.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Прислать мне уведомление, если клиент прислал обновление и я собственник заявки.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Прислать мне уведомление, если заявка перемещена в дополнительную очередь',
      'Send me a notification if a ticket is unlocked by the system.' => 'Прислать мне уведомление, если заявка освобождена системой.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Прислать мне уведомление, если есть новая заявка в моих дополнительных очередях.',
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
      'unlock' => 'разблокирован',
      'Unlock' => 'Разблокировать',
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
      'Add auto response' => 'Добавить автоматический ответ',
      'Auto Response From' => 'Автоматический ответ от',
      'Auto Response Management' => 'Управление авто-ответами',
      'Change auto response settings' => 'Настройка авто-ответов',
      'Note' => 'заметка',
      'Response' => 'Ответ',
      'to get the first 20 character of the subject' => 'получить первые 20 символов поля "тема"',
      'to get the first 5 lines of the email' => 'получить первые 5 строк письма',
      'to get the from line of the email' => 'получить поле "от" письма',
      'to get the realname of the sender (if given)' => 'получить (если есть) имя отправителя',
      'to get the ticket id of the ticket' => 'Получить ID заявки',
      'to get the ticket number of the ticket' => 'Получить номер заявки',
      'Type' => 'Тип',
      'Useable options' => 'Используемые опции',

    # Template: AdminCharsetForm
      'Charset' => 'Кодировка',
      'System Charset Management' => 'Управление системной кодировкой',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Управление пользователями (для клиентов)',
      'Customer user will be needed to to login via customer panels.' => 'Пользователь (клиент) должен войти в систему через клиентский интерфейс',

    # Template: AdminCustomerUserGeneric

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

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'e-mail администратора',
      'Body' => 'Тело письма',
      'OTRS-Admin Info!' => 'Информация от администратора OTRS',
      'Recipents' => 'Получатели',
      'send' => '',

    # Template: AdminEmailSent
      'Message sent to' => 'Сообщение отправлено для',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Создать новые группы для контроля доступа различных групп агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
      'Group Management' => 'Управление группами',
      'It\'s useful for ASP solutions.' => 'Это подходит для ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Группа admin должна быть в admin зоне, а stats группа в stat зоне',

    # Template: AdminLog
      'System Log' => 'Системный журнал',

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
      'POP3 Account' => 'учетная запись POP3',
      'Responses' => 'Ответы',
      'Responses <-> Queue' => 'Ответы <-> Очередь',
      'Select Box' => 'Дать команду SELECT',
      'Session Management' => 'Управление сессиями',
      'Status' => '',
      'System' => 'Система',
      'User <-> Groups' => 'Пользователь <-> Группы',

    # Template: AdminNotificationForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Ответ - заготовка текста для ответа кклиенту',
      'Don\'t forget to add a new response a queue!' => 'Не забудьте добавить ответ для очереди!',
      'Next state' => '',
      'Notification Management' => '',
      'The current ticket state is' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Все входящие письма с едной учетной записи будут перенесены в избранную очередь!',
      'Dispatching' => 'Перенаправление',
      'Host' => 'Сервер',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Если ваша учетная запись безопасна, то будет использован x-otrs заголовок !',
      'Login' => 'Учетное имя',
      'POP3 Account Management' => 'Управление учетной записью POP3',
      'Trusted' => 'Безопасный',

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
      'Key' => 'Ключ',
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
      'Change answer <-> queue settings' => 'Изменение ответа <-> Настройки очереди',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Станд.ответы <-> Настройка прикрепленных файлов по умолчанию',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Сменить ответ <-> Настройка прикрепленных файлов',

    # Template: AdminResponseForm
      'Response Management' => 'Управление ответами',

    # Template: AdminSalutationForm
      'customer realname' => 'имя клиента',
      'for agent firstname' => 'для агента - имя',
      'for agent lastname' => 'для агента - фамилия',
      'for agent login' => '',
      'for agent user id' => '',
      'Salutation Management' => 'Управление приветствиями',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Макс. строк',

    # Template: AdminSelectBoxResult
      'Limit' => 'Лимит',
      'Select Box Result' => 'Выберите из меню',
      'SQL' => 'SQL',

    # Template: AdminSession
      'Agent' => '',
      'kill all sessions' => 'Закрыть все текущие сессии',
      'Overview' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Закрыть сессию',
      'SessionID' => 'Идентификатор сессии',

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
      'create' => '',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'User <-> Group Management' => 'Пользователь <-> Управление группами',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Отказаться от всех изменений и вернуться в окно ввода',
      'Return to the compose screen' => 'вернуться в окно ввода',
      'Search' => '',
      'The message being composed has been closed.  Exiting.' => 'создаваемое сообщение было закрыто. выход.',
      'This window must be called from compose window' => 'Это окно должно вызываться из окна ввода',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Сообщение должно иметь поле ДЛЯ: адресата!',
      'Bounce ticket' => 'Пересылка заявки',
      'Bounce to' => 'Переслать для',
      'Inform sender' => 'Информировать отправителя',
      'Next ticket state' => 'Следующее состояние заявки',
      'Send mail!' => 'Послать e-mail!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Нужен правильный адрес в поле ДЛЯ: (support@rgs.ru)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => '',

    # Template: AgentClose
      ' (work units)' => ' (рабочие единицы)',
      'A message should have a body!' => '',
      'A message should have a subject!' => 'Сообщение должно иметь поле "тема"!',
      'Close ticket' => 'Закрыть заявку',
      'Close type' => 'Тип закрытия',
      'Close!' => 'Закрыть!',
      'Note Text' => 'Текст заметки',
      'Note type' => 'Тип заметки',
      'Options' => 'Настройки',
      'Spell Check' => 'Проверка правописания',
      'Time units' => 'Единицы времени',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => '',
      'Attach' => 'Прикреплен файл',
      'Compose answer for ticket' => 'Создать ответ на заявку',
      'for pending* states' => 'для последующих состояний* ',
      'Is the ticket answered' => 'Послан ответ на заявку',
      'Pending Date' => 'Следующая дата',

    # Template: AgentCustomer
      'Back' => 'Назад',
      'Change customer of ticket' => 'Изменить клиента заявки',
      'CustomerID' => 'ID Пользователя',
      'Search Customer' => 'Искать клиента',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'История клиента',

    # Template: AgentCustomerMessage
      'Follow up' => 'Дополнение к заявке',

    # Template: AgentCustomerView
      'Customer Data' => 'Учетные данные клиента',

    # Template: AgentForward
      'Article type' => 'Тип статьи',
      'Date' => 'Дата',
      'End forwarded message' => 'Конец пересланного сообщения',
      'Forward article of ticket' => 'Переслать статью из заявки',
      'Forwarded message from' => 'Переслано сообщение от',
      'Reply-To' => 'Ответ для',

    # Template: AgentFreeText
      'Change free text of ticket' => '',
      'Value' => '',

    # Template: AgentHistoryForm
      'History of' => 'История',

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

    # Template: AgentMove
      'All Agents' => '',
      'Move Ticket' => '',
      'New Owner' => '',
      'New Queue' => '',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Заблокированные заявки',
      'new message' => 'новое сообщение',
      'Preferences' => 'Предпочтения',
      'Utilities' => 'Утилиты',

    # Template: AgentNote
      'Add note to ticket' => 'Добавить заметку к заявке',
      'Note!' => 'заметка!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Изменить собственика заявки',
      'Message for new Owner' => 'сообщение для нового владельца',

    # Template: AgentPending
      'Pending date' => 'В очереди - дата',
      'Pending type' => 'В очереди - тип',
      'Pending!' => '',
      'Set Pending' => 'В очереди - задать',

    # Template: AgentPhone
      'Customer called' => 'Звонок клиенту: ',
      'Phone call' => 'Телефонный звонок',
      'Phone call at %s' => 'Телефонный звонок в %s',

    # Template: AgentPhoneNew
      'Clear From' => '',
      'Lock Ticket' => '',
      'new ticket' => 'новая Заявка',

    # Template: AgentPlain
      'ArticleID' => 'ID заметки',
      'Plain' => 'Обыкновенный',
      'TicketID' => 'ID заявки',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Выберите Вашу дополнительную очередь',

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

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Заявка заблокирована!',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint
      'by' => '',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Потраченное на заявку время',
      'Escalation in' => 'Эскалация заявки через',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      'and' => '',
      'Customer User Login' => '',
      'Delete' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'No time settings.' => '',
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Search' => '',
      'TicketFreeText' => '',
      'Times' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Поиск истории клиента',
      'Customer history search (e. g. "ID342425").' => 'Поиск истории клиента (напр. "ID342425").',
      'No * possible!' => 'Нельзя использовать символ * !',

    # Template: AgentUtilSearchNavBar
      'Change search options' => '',
      'Results' => 'Результат',
      'Search Result' => '',
      'Total hits' => 'Кумулятивные попадания',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

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
      'Free Fields' => '',
      'Print' => 'Печать',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Создать учетную запись',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'delete' => '',
      'edit' => '',
      'FAQ History' => '',
      'print' => '',
      'view' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => '',
      'Keywords' => '',
      'Last update' => '',
      'Problem' => '',
      'Solution' => '',
      'Sympthom' => '',

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

    # Template: CustomerHeader
      'Contact' => 'Контакт',
      'Home' => 'Начало',
      'Online-Support' => 'Горячая поддержка',
      'Products' => 'Продукты',
      'Support' => 'Поддержка',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Забыли свой пароль',
      'Request new password' => 'Прислать новый пароль',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Создать новую Заявку',
      'FAQ' => 'FAQ (чаВо) Часто Задаваемые Вопросы',
      'New Ticket' => 'новая Заявка',
      'Ticket-Overview' => 'обзор Заявок',
      'Welcome %s' => 'Приветствуем %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Мои Заявки',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Кликнуть здесь,чтобы послать сообщение об ошибке',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'Filename' => '',
      'Short Description' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView
      'history' => '',

    # Template: FAQCategoryForm
      'FAQ Category' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => '',

    # Template: Header

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
      'Webfrontend' => 'Web-интерфейс',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Нет прав',

    # Template: Notify
      'Info' => 'Информация',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader
      'printed by' => 'напечатано ',

    # Template: QueueView
      'All tickets' => 'Все Заявки',
      'Page' => '',
      'Queues' => 'очереди',
      'Tickets available' => '',
      'Tickets shown' => 'Показаны Заявки',

    # Template: SystemStats
      'Graphs' => 'Графики',

    # Template: Test
      'OTRS Test Page' => 'Тестовая страница OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Истекло время до эскалации заявки !',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Добавить заметку',

    # Template: Warning

    # Misc
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(ID Заявки. Некоторые задают как \'Ticket#\', \'Call#\' или \'MyTicket#\')',
      'A message should have a From: recipient!' => 'сообщение должно иметь поле ОТ: отправитель',
      'AgentFrontend' => 'Режим пользователя',
      'Article free text' => 'Свободный текст статьи',
      'Backend' => 'Фон',
      'BackendMessage' => 'Фоновое сообщение',
      'Charsets' => 'Кодировки',
      'Create' => 'Создать',
      'Customer info' => 'Данные о клиенте',
      'CustomerUser' => 'Пользователь клиента',
      'Feature not acitv!' => 'Функция не активна',
      'Fulltext search' => 'Полный текстовый поиск',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Полный текстовый поиск (прим. "Mar*in" или "Baue*" или "martin+hallo")',
      'Handle' => 'Манипулятор',
      'New state' => 'новое состояние',
      'New ticket via call.' => 'новая Заявка через звонок',
      'New user' => 'Новый пользователь',
      'Search in' => 'Искать в',
      'Set customer id of a ticket' => 'Задать ID клиента заявки',
      'Show all' => 'Показать все',
      'Status defs' => 'Определение статуса',
      'System Language Management' => 'Настройка системного языка',
      'Ticket available' => 'Имеющиеся Заявки',
      'Ticket free text' => 'Свободный текст заявки',
      'Ticket limit:' => 'Время действия заявки:',
      'Time till escalation' => 'Время до эскалации (увеличения приоритета)',
      'With State' => 'при состоянии',
      'You have to be in the admin group!' => 'Вы должны быть в группе admin!',
      'You have to be in the stats group!' => 'Вы должны быть в группе stat!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Должен быть e-mail адрес (напр. customer@example.com) в поле ОТ:',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Ваше письмо с номером заявки "<OTRS_TICKET>" передано "<OTRS_BOUNCE_TO>". Свяжитесь с получателем для дальнейшей информации',
      'auto responses set' => 'выбор авто-ответов',
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
