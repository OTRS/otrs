# --
# Kernel/Language/ru.pm - provides ru language translation
# Copyright (C) 2003 Serg V Kravchenko <skraft at rgs.ru>
# --
# $Id: ru.pm,v 1.25 2005-12-29 01:12:57 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::ru;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.25 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:50 2005

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%T, %A %D %B, %Y г.';
    $Self->{DateFormatShort} = '%D.%M.%Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Да',
      'No' => 'Нет',
      'yes' => 'да',
      'no' => 'нет',
      'Off' => 'Выключено',
      'off' => 'выключено',
      'On' => 'Включено',
      'on' => 'включено',
      'top' => 'к началу',
      'end' => 'В конец',
      'Done' => 'Готово.',
      'Cancel' => 'Отказ',
      'Reset' => 'Рестарт',
      'last' => '',
      'before' => '',
      'day' => 'сутки',
      'days' => 'сут.',
      'day(s)' => '',
      'hour' => 'час',
      'hours' => 'ч.',
      'hour(s)' => '',
      'minute' => 'минуту',
      'minutes' => 'мин.',
      'minute(s)' => '',
      'month' => '',
      'months' => '',
      'month(s)' => '',
      'week' => '',
      'week(s)' => '',
      'year' => '',
      'years' => '',
      'year(s)' => '',
      'wrote' => 'записано',
      'Message' => 'Сообщение',
      'Error' => 'Ошибка',
      'Bug Report' => 'Отчет об ошибках',
      'Attention' => 'Внимание',
      'Warning' => 'Предупреждение',
      'Module' => 'Модуль',
      'Modulefile' => 'Файл-модуль',
      'Subfunction' => 'Подфункция',
      'Line' => 'Линия',
      'Example' => 'Пример',
      'Examples' => 'Примеры',
      'valid' => 'Состояние записи',
      'invalid' => '',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 Минуты',
      ' 5 minutes' => ' 5 Минут',
      ' 7 minutes' => ' 7 Минут',
      '10 minutes' => '10 Минут',
      '15 minutes' => '15 Минут',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => '',
      'Back' => 'Назад',
      'Next...' => '',
      '...Back' => '',
      '-none-' => '',
      'none' => 'нет',
      'none!' => 'нет!',
      'none - answered' => 'нет - отвечен?',
      'please do not edit!' => 'Не редактировать!',
      'AddLink' => 'Добавить ссылку',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => '',
      'Parent' => '',
      'Child' => '',
      'Hit' => 'Попадание',
      'Hits' => 'Попадания',
      'Text' => 'Текст',
      'Lite' => '',
      'User' => 'Пользователь',
      'Username' => 'Имя пользователя',
      'Language' => 'Язык',
      'Languages' => 'Языки',
      'Password' => 'Пароль',
      'Salutation' => 'Приветствие',
      'Signature' => 'Подпись',
      'Customer' => 'Клиент',
      'CustomerID' => 'ID Пользователя',
      'CustomerIDs' => '',
      'customer' => '',
      'agent' => '',
      'system' => '',
      'Customer Info' => '',
      'go!' => 'ОК!',
      'go' => 'ОК',
      'All' => 'Все',
      'all' => 'все',
      'Sorry' => 'Звиняйте',
      'update!' => 'обновить!',
      'update' => 'обновить',
      'Update' => '',
      'submit!' => 'Ввести!',
      'submit' => 'ввести',
      'Submit' => '',
      'change!' => 'Сменить!',
      'Change' => 'Изменение',
      'change' => 'изменение',
      'click here' => 'кликнуть здесь',
      'Comment' => 'Комментарий',
      'Valid' => 'Состояние записи',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => 'Имя',
      'Group' => 'Группа',
      'Description' => 'Описание',
      'description' => 'описание',
      'Theme' => 'Тема',
      'Created' => 'Создан',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => '',
      'and' => '',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => 'Настройки',
      'Title' => '',
      'Item' => '',
      'Delete' => '',
      'Edit' => '',
      'View' => 'Просмотр',
      'Number' => '',
      'System' => 'Система',
      'Contact' => 'Контакт',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => '',
      'Category' => '',
      'Viewer' => '',
      'New message' => 'новоее сообщение',
      'New message!' => 'новоее сообщение!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Ответьте на эти заявки для перехода к обычному просмотру очереди !',
      'You got new message!' => 'Получите новоее сообщение!',
      'You have %s new message(s)!' => 'Количество новых сообщений: %s',
      'You have %s reminder ticket(s)!' => 'У Вас в очереди %s заявок!',
      'The recommended charset for your language is %s!' => 'Рекомендуемая кодировка для вашего языка %s',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Нет предложений',
      'Word' => 'Слово ?',
      'Ignore' => 'Пренебречь',
      'replace with' => 'заменить на',
      'Welcome to %s' => 'Добро пожаловать в %s',
      'There is no account with that login name.' => 'Нет пользователя с таким именем.',
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешная авторизация! Ваше имя или пароль неверны!',
      'Please contact your admin' => 'Свяжитесь с администратором',
      'Logout successful. Thank you for using OTRS!' => 'Вход успешен. Благодарим за пользование системой OTRS',
      'Invalid SessionID!' => 'Неверный SessionID!',
      'Feature not active!' => '',
      'Take this Customer' => '',
      'Take this User' => 'Выбрать этого пользователя',
      'possible' => 'возможно',
      'reject' => 'отвергнуть',
      'Facility' => 'Приспособление',
      'Timeover' => 'Время ожидания истекло',
      'Pending till' => 'В очереди до',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работать с UserID 1 (Системная учетная запись)! Создайте другого пользователя!',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'No entry found!' => '',
      'Session has timed out. Please log in again.' => '',
      'No Permission!' => '',
      'To: (%s) replaced with database email!' => '',
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '',
      'Preview' => '',
      'Added User "%s"' => '',
      'Contract' => '',
      'Online Customer: %s' => '',
      'Online Agent: %s' => '',
      'Calendar' => '',
      'File' => '',
      'Filename' => '',
      'Type' => 'Тип',
      'Size' => '',
      'Upload' => '',
      'Directory' => '',
      'Signed' => '',
      'Sign' => '',
      'Crypted' => '',
      'Crypt' => '',

      # Template: AAAMonth
      'Jan' => 'Января',
      'Feb' => 'Февраля',
      'Mar' => 'Марта',
      'Apr' => 'Апреля',
      'May' => 'Мая',
      'Jun' => 'Ююня',
      'Jul' => 'Июля',
      'Aug' => 'Августа',
      'Sep' => 'Сентября',
      'Oct' => 'Октября',
      'Nov' => 'Ноября',
      'Dec' => 'Декабря',

      # Template: AAANavBar
      'Admin-Area' => 'Администрирование системы',
      'Agent-Area' => '',
      'Ticket-Area' => '',
      'Logout' => 'Выход',
      'Agent Preferences' => '',
      'Preferences' => 'Предпочтения',
      'Agent Mailbox' => '',
      'Stats' => 'Статистика',
      'Stats-Area' => '',
      'FAQ-Area' => '',
      'FAQ' => 'FAQ (чаВо) Часто Задаваемые Вопросы',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => '',
      'FAQ-State' => '',
      'Admin' => '',
      'A web calendar' => '',
      'WebMail' => '',
      'A web mail client' => '',
      'FileManager' => '',
      'A web file manager' => '',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',
      'Customer Users' => '',
      'Customer Users <-> Groups' => '',
      'Users <-> Groups' => '',
      'Roles' => '',
      'Roles <-> Users' => '',
      'Roles <-> Groups' => '',
      'Salutations' => '',
      'Signatures' => '',
      'Email Addresses' => '',
      'Notifications' => '',
      'Category Tree' => '',
      'Admin Notification' => '',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Настройки успешно обновлены',
      'Mail Management' => 'Управление почтой',
      'Frontend' => 'Режим пользователя',
      'Other Options' => 'Другие настройки',
      'Change Password' => '',
      'New password' => '',
      'New password again' => '',
      'Select your QueueView refresh time.' => 'Выберите время обновления монитора очередей.',
      'Select your frontend language.' => 'Выберите ваш язык.',
      'Select your frontend Charset.' => 'Выберите вашу кодировку.',
      'Select your frontend Theme.' => 'Выберите тему интерфейса',
      'Select your frontend QueueView.' => 'Выберите язык для монитора очередей.',
      'Spelling Dictionary' => '',
      'Select your default spelling dictionary.' => '',
      'Max. shown Tickets a page in Overview.' => '',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

      # Template: AAATicket
      'Lock' => 'Блокировка',
      'Unlock' => 'Разблокировать',
      'History' => 'История',
      'Zoom' => 'Подробно',
      'Age' => 'Возраст',
      'Bounce' => 'Переслать заявку',
      'Forward' => 'Переслать',
      'From' => 'От',
      'To' => 'Для',
      'Cc' => 'Копия для',
      'Bcc' => 'Скрытая копия',
      'Subject' => 'Тема',
      'Move' => 'Переместить',
      'Queue' => 'Очередь',
      'Priority' => 'Приоритет',
      'State' => 'Статус',
      'Compose' => 'Создать',
      'Pending' => 'В очереди',
      'Owner' => 'Собственник',
      'Owner Update' => '',
      'Sender' => 'Отправитель',
      'Article' => 'Содержимое заявки',
      'Ticket' => 'заявка',
      'Createtime' => 'Время создания',
      'plain' => 'обычный',
      'eMail' => 'е-Mail',
      'email' => 'e-mail',
      'Close' => 'Закрыть',
      'Action' => 'Действие',
      'Attachment' => 'Прикрепленный файл',
      'Attachments' => 'Прикрепленные файлы',
      'This message was written in a character set other than your own.' => 'Это сообщение написано в кодировке. отличной от вашей.',
      'If it is not displayed correctly,' => 'Если данный текст отображается некорректно,',
      'This is a' => 'Это',
      'to open it in a new window.' => 'открыть в новоем окне',
      'This is a HTML email. Click here to show it.' => 'Это e-mail в HTML формате. Кликните здесь для просмотра',
      'Free Fields' => '',
      'Merge' => '',
      'closed successful' => 'Закрыт успешно',
      'closed unsuccessful' => 'Закрыт неуспешно',
      'new' => 'нов',
      'open' => 'открыт',
      'closed' => '',
      'removed' => 'удален',
      'pending reminder' => 'очередное напоминание',
      'pending auto close+' => 'очередь на авто закрытие+',
      'pending auto close-' => 'очередь на авто закрытие-',
      'email-external' => 'внешний    e-mail',
      'email-internal' => 'внутренний e-mail',
      'note-external' => 'внешняя Заметка',
      'note-internal' => 'внутренняя Заметка',
      'note-report' => 'Заметка-отчет',
      'phone' => 'телефон',
      'sms' => '',
      'webrequest' => 'web-заявка',
      'lock' => 'блокирован',
      'unlock' => 'разблокирован',
      'very low' => 'самый низкий',
      'low' => 'низкий',
      'normal' => 'нормальный',
      'high' => 'высокий',
      'very high' => 'самый высокий',
      '1 very low' => '1 самый низкий',
      '2 low' => '2 низкий',
      '3 normal' => '3 нормальный',
      '4 high' => '4 высокий',
      '5 very high' => '5 самый высокий',
      'Ticket "%s" created!' => '',
      'Ticket Number' => '',
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'Don\'t show closed Tickets' => '',
      'Show closed Tickets' => '',
      'Email-Ticket' => '',
      'Create new Email Ticket' => '',
      'Phone-Ticket' => '',
      'Create new Phone Ticket' => '',
      'Search Tickets' => '',
      'Edit Customer Users' => '',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => '',
      'Overview of all open Tickets' => '',
      'Locked Tickets' => '',
      'Lock it to work on it!' => '',
      'Unlock to give it back to the queue!' => '',
      'Shows the ticket history!' => '',
      'Print this ticket!' => '',
      'Change the ticket priority!' => '',
      'Change the ticket free fields!' => '',
      'Link this ticket to an other objects!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket customer!' => '',
      'Add a note to this ticket!' => '',
      'Merge this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Close this ticket!' => '',
      'Look into a ticket!' => '',
      'Delete this ticket!' => '',
      'Mark as Spam!' => '',
      'My Queues' => '',
      'Shown Tickets' => '',
      'New ticket notification' => 'Уведомление о новоей заявке',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Follow up notification' => 'Уведомление об обновлениях',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Прислать мне уведомление, если клиент прислал обновление и я собственник заявки.',
      'Ticket lock timeout notification' => 'Уведомление о истечении срока блокировки заявки системой',
      'Send me a notification if a ticket is unlocked by the system.' => 'Прислать мне уведомление, если заявка освобождена системой.',
      'Move notification' => 'Уведомление о перемещении',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => 'Дополнительная (custom) очередь',
      'QueueView refresh time' => 'Время обновления монитора очередей',
      'Screen after new ticket' => '',
      'Select your screen after creating a new ticket.' => '',
      'Closed Tickets' => '',
      'Show closed tickets.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Responses' => 'Ответы',
      'Responses <-> Queue' => '',
      'Auto Responses' => '',
      'Auto Responses <-> Queue' => '',
      'Attachments <-> Responses' => '',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
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
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',

      # Template: AAAWeekDay
      'Sun' => 'Воскр-е',
      'Mon' => 'Понед-к',
      'Tue' => 'Вторник',
      'Wed' => 'Среда  ',
      'Thu' => 'Четверг',
      'Fri' => 'Пятница',
      'Sat' => 'Суббота',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Управление прикрепленными файлами',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Управление авто-ответами',
      'Response' => 'Ответ',
      'Auto Response From' => 'Автоматический ответ от',
      'Note' => 'заметка',
      'Useable options' => 'Используемые опции',
      'to get the first 20 character of the subject' => 'получить первые 20 символов поля "тема"',
      'to get the first 5 lines of the email' => 'получить первые 5 строк письма',
      'to get the from line of the email' => 'получить поле "от" письма',
      'to get the realname of the sender (if given)' => 'получить (если есть) имя отправителя',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'создаваемое сообщение было закрыто. выход.',
      'This window must be called from compose window' => 'Это окно должно вызываться из окна ввода',
      'Customer User Management' => 'Управление пользователями (для клиентов)',
      'Search for' => '',
      'Result' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      'This values are read only.' => '',
      'This values are required.' => '',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => '',
      'Change %s settings' => 'Изменить %s настроек',
      'Select the user:group permissions.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => '',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => '',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => '',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Сообщение отправлено для',
      'Recipents' => 'Получатели',
      'Body' => 'Тело письма',
      'send' => '',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      'Customer User Login' => '',
      '(e. g. U5150)' => '',
      'Agent' => '',
      'TicketFreeText' => '',
      'Ticket Lock' => '',
      'Times' => '',
      'No time settings.' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'New Priority' => '',
      'New Queue' => '',
      'New State' => '',
      'New Agent' => '',
      'New Owner' => '',
      'New Customer' => '',
      'New Ticket Lock' => '',
      'CustomerUser' => 'Пользователь клиента',
      'Add Note' => 'Добавить заметку',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
      'Modules' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',

      # Template: AdminGroupForm
      'Group Management' => 'Управление группами',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Группа admin должна быть в admin зоне, а stats группа в stat зоне',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Создать новые группы для контроля доступа различных групп агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
      'It\'s useful for ASP solutions.' => 'Это подходит для ASP.',

      # Template: AdminLog
      'System Log' => 'Системный журнал',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => 'Группы',
      'Misc' => 'Дополнительно',

      # Template: AdminNotificationForm
      'Notification Management' => '',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',

      # Template: AdminPackageManager
      'Package Manager' => '',
      'Uninstall' => '',
      'Verion' => '',
      'Do you really want to uninstall this package?' => '',
      'Install' => '',
      'Package' => '',
      'Online Repository' => '',
      'Version' => '',
      'Vendor' => '',
      'Upgrade' => '',
      'Local Repository' => '',
      'Status' => '',
      'Overview' => '',
      'Download' => '',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => 'Ключ',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'Управление учетной записью POP3',
      'Host' => 'Сервер',
      'Trusted' => 'Безопасный',
      'Dispatching' => 'Перенаправление',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Все входящие письма с едной учетной записи будут перенесены в избранную очередь!',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => '',
      'Match' => '',
      'Header' => '',
      'Value' => '',
      'Set' => '',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => '',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Управление очередью',
      'Sub-Queue of' => '',
      'Unlock timeout' => 'Срок блокировки',
      '0 = no unlock' => '0 = без блокировки',
      'Escalation time' => 'Время до эскалации заявки (увеличение приоритета)',
      '0 = no escalation' => '0 = без эскалации',
      'Follow up Option' => 'Параметры авто-слежения ?',
      'Ticket lock after a follow up' => 'Блокировка заявки после прихода дополнения',
      'Systemaddress' => 'Системный адрес',
      'Customer Move Notify' => '',
      'Customer State Notify' => '',
      'Customer Owner Notify' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Если агент заблокировал заявку и не послал ответ клиенту в течение установленного времени, то заявка автоматически разблокируется и станет доступной для остальных агентов',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Если заявка не будет обслужена в установленное время, показывать только эту заявку',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Если заявка закрыта, а клиент прислал дополнение,то заявка будет заблокирована для предыдущего владельца',
      'Will be the sender address of this queue for email answers.' => 'Установка адреса отправителя для ответов в этой очереди',
      'The salutation for email answers.' => 'Приветствие для почтовых сообщений',
      'The signature for email answers.' => 'Подпись для почтовых сообщений',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => '',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Ответ',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => '',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Управление ответами',
      'A response is default text to write faster answer (with default text) to customers.' => 'Ответ - заготовка текста для ответа кклиенту',
      'Don\'t forget to add a new response a queue!' => 'Не забудьте добавить ответ для очереди!',
      'Next state' => '',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => '',
      'Your email address is new' => '',

      # Template: AdminRoleForm
      'Role Management' => '',
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => '',
      'move_into' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'create' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'priority' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',

      # Template: AdminRoleGroupForm
      'Role' => '',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Управление приветствиями',
      'customer realname' => 'имя клиента',
      'for agent firstname' => 'для агента - имя',
      'for agent lastname' => 'для агента - фамилия',
      'for agent user id' => '',
      'for agent login' => '',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Дать команду SELECT',
      'SQL' => '',
      'Limit' => 'Лимит',
      'Select Box Result' => 'Выберите из меню',

      # Template: AdminSession
      'Session Management' => 'Управление сессиями',
      'Sessions' => '',
      'Uniq' => '',
      'kill all sessions' => 'Закрыть все текущие сессии',
      'Session' => '',
      'kill session' => 'Закрыть сессию',

      # Template: AdminSignatureForm
      'Signature Management' => 'Управление на подписью',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Управление системными состояниями',
      'State Type' => '',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',
      'See also' => '',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => '',
      'Show' => '',
      'Download Settings' => '',
      'Download all system config changes.' => '',
      'Load Settings' => '',
      'Subgroup' => '',
      'Elements' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Default' => '',
      'Content' => '',
      'New' => 'Новый',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Управление системными e-mail адресами',
      'Email' => 'e-mail',
      'Realname' => 'Реальное Имя',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Все входящие сообщения с этим полем (Для:) будут направлены в выбранную очередь',

      # Template: AdminUserForm
      'User Management' => 'Управление пользователями',
      'Firstname' => 'Имя',
      'Lastname' => 'Фамилия',
      'User will be needed to handle tickets.' => 'Для обработки заявок нужен пользователь',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => '',
      'Return to the compose screen' => 'вернуться в окно ввода',
      'Discard all changes and return to the compose screen' => 'Отказаться от всех изменений и вернуться в окно ввода',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Информация',

      # Template: AgentLinkObject
      'Link Object' => '',
      'Select' => '',
      'Results' => 'Результат',
      'Total hits' => 'Кумулятивные попадания',
      'Site' => 'Место',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Проверка правописания',
      'spelling error(s)' => 'Ошибки правописания',
      'or' => '',
      'Apply these changes' => 'Применить эти изменения',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Сообщение должно иметь поле ДЛЯ: адресата!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Нужен правильный адрес в поле ДЛЯ: (support@rgs.ru)!',
      'Bounce ticket' => 'Пересылка заявки',
      'Bounce to' => 'Переслать для',
      'Next ticket state' => 'Следующее состояние заявки',
      'Inform sender' => 'Информировать отправителя',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => '',
      'Send mail!' => 'Послать e-mail!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Сообщение должно иметь поле "тема"!',
      'Ticket Bulk Action' => '',
      'Spell Check' => 'Проверка правописания',
      'Note type' => 'Тип заметки',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => '',
      'You need to account time!' => '',
      'Close ticket' => 'Закрыть заявку',
      'Note Text' => 'Текст заметки',
      'Close type' => 'Тип закрытия',
      'Time units' => 'Единицы времени',
      ' (work units)' => ' (рабочие единицы)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => '',
      'Compose answer for ticket' => 'Создать ответ на заявку',
      'Attach' => 'Прикреплен файл',
      'Pending Date' => 'Следующая дата',
      'for pending* states' => 'для последующих состояний* ',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Изменить клиента заявки',
      'Set customer user and customer id of a ticket' => '',
      'Customer User' => 'Пользователь клиента',
      'Search Customer' => 'Искать клиента',
      'Customer Data' => 'Учетные данные клиента',
      'Customer history' => 'История клиента',
      'All customer tickets.' => '',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Дополнение к заявке',

      # Template: AgentTicketEmail
      'Compose Email' => '',
      'new ticket' => 'новая Заявка',
      'Clear To' => '',
      'All Agents' => '',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Тип статьи',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => '',

      # Template: AgentTicketHistory
      'History of' => 'История',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Заявка заблокирована!',
      'Ticket unlock!' => '',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Почтовый ящик',
      'Tickets' => 'Заявки',
      'All messages' => 'Все сообщения',
      'New messages' => 'Новые сообщения',
      'Pending messages' => 'сообщения в очереди',
      'Reminder messages' => 'Напоминающие сообщения',
      'Reminder' => 'Напоминание',
      'Sort by' => 'Сортировка по',
      'Order' => 'Порядок',
      'up' => 'вверх',
      'down' => 'вниз',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => '',
      'Move Ticket' => '',
      'Previous Owner' => '',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Добавить заметку к заявке',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Изменить собственика заявки',
      'Message for new Owner' => 'сообщение для нового владельца',

      # Template: AgentTicketPending
      'Set Pending' => 'В очереди - задать',
      'Pending type' => 'В очереди - тип',
      'Pending date' => 'В очереди - дата',

      # Template: AgentTicketPhone
      'Phone call' => 'Телефонный звонок',

      # Template: AgentTicketPhoneNew
      'Clear From' => '',

      # Template: AgentTicketPlain
      'Plain' => 'Обыкновенный',
      'TicketID' => 'ID заявки',
      'ArticleID' => 'ID заметки',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Потраченное на заявку время',
      'Escalation in' => 'Эскалация заявки через',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => '',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Изменить приоритет заявки',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Показаны Заявки',
      'Page' => '',
      'Tickets available' => '',
      'All tickets' => 'Все Заявки',
      'Queues' => 'очереди',
      'Ticket escalation!' => 'Истекло время до эскалации заявки !',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => '',
      'Compose Follow up' => '',
      'Compose Answer' => 'Создать ответ',
      'Contact customer' => 'Связаться с клиентом',
      'Change queue' => 'Переместить в другую очередь',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => '',
      'Profile' => '',
      'Search-Template' => '',
      'Created in Queue' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Yes, save it with name' => '',
      'Customer history search' => 'Поиск истории клиента',
      'Customer history search (e. g. "ID342425").' => 'Поиск истории клиента (напр. "ID342425").',
      'No * possible!' => 'Нельзя использовать символ * !',

      # Template: AgentTicketSearchResult
      'Search Result' => '',
      'Change search options' => '',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'сортировка по возрастанию',
      'U' => '',
      'sort downward' => 'сортировка по убыванию',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      'Split' => '',

      # Template: AgentTicketZoomStatus
      'Locked' => '',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '',

      # Template: CustomerFAQ
      'Print' => 'Печать',
      'Keywords' => '',
      'Symptom' => '',
      'Problem' => '',
      'Solution' => '',
      'Modified' => '',
      'Last update' => '',
      'FAQ System History' => '',
      'modified' => '',
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',
      'FAQ Search Result' => '',
      'FAQ Overview' => '',

      # Template: CustomerFooter
      'Powered by' => '',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => 'Учетное имя',
      'Lost your password?' => 'Забыли свой пароль',
      'Request new password' => 'Прислать новый пароль',
      'Create Account' => 'Создать учетную запись',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Приветствуем %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'на',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Кликнуть здесь,чтобы послать сообщение об ошибке',

      # Template: FAQ
      'Comment (internal)' => '',
      'A article should have a title!' => '',
      'New FAQ Article' => '',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

      # Template: FAQCategoryForm
      'Name is required!' => '',
      'FAQ Category' => '',

      # Template: FAQLanguageForm
      'FAQ Language' => '',

      # Template: Footer
      'QueueView' => 'Просмотр очереди',
      'PhoneView' => 'Заявка по телефону',
      'Top of Page' => '',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Начало',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => '',
      'accept license' => '',
      'don\'t accept license' => '',
      'Admin-User' => '',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',
      'Database-User' => '',
      'default \'hot\'' => '',
      'DB connect host' => '',
      'Database' => '',
      'Create' => '',
      'false' => '',
      'SystemID' => 'Системный ID',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(ID системы. Каждый номер Заявки и каждая http сессия будет начинаться с этого числа)',
      'System FQDN' => 'Системное FQDN',
      '(Full qualified domain name of your system)' => '(Полное доменное имя (FQDN) вашей системы)',
      'AdminEmail' => 'e-mail администратора',
      '(Email of the system admin)' => '(e-mail системного администратора)',
      'Organization' => 'Организация',
      'Log' => '',
      'LogModule' => 'Модуль журнала ',
      '(Used log backend)' => '(Используемый журнал backend)',
      'Logfile' => 'Файл журнала',
      '(Logfile just needed for File-LogModule!)' => '(Журнал-файл необходим только для модуля File-Log)',
      'Webfrontend' => 'Web-интерфейс',
      'Default Charset' => 'Кодировка по умолчанию',
      'Use utf-8 it your database supports it!' => '',
      'Default Language' => 'язык по умолчанию',
      '(Used default language)' => '(Используемый язык по умолчанию)',
      'CheckMXRecord' => '',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Restart your webserver' => '',
      'After doing so your OTRS is up and running.' => '',
      'Start page' => '',
      'Have a lot of fun!' => '',
      'Your OTRS Team' => '',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Нет прав',

      # Template: Notify
      'Important' => '',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'напечатано ',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'Тестовая страница OTRS',
      'Counter' => '',

      # Template: Warning
      # Misc
      'Ticket Number Generator' => 'Генератор номера Заявки',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Ticket Hook' => 'Зацепить Заявку',
      'Close!' => 'Закрыть!',
      'Don\'t forget to add a new user to groups!' => 'Не забудьте добавить новоего пользователя в группы!',
      'License' => '',
      'System Settings' => '',
      'Finished' => '',
      'Change user <-> group settings' => 'Изменить пользователя <-> Настройки групп',
      'next step' => 'следующий шаг',
      'Admin-Email' => 'e-mail администратора',
      'Create new database' => '',
      'Delete old database' => '',
      'OTRS DB User' => '',
      'OTRS DB Password' => '',
      'DB Admin Password' => '',
      'Drop Database' => '',
      '(Used ticket number format)' => '(Используемый формат номеров Заявок)',
      'Package not correctly deployed, you need to deploy it again!' => '',
      'Customer called' => '',
      'Phone' => '',
      'Office' => '',
      'CompanyTickets' => '',
      'MyTickets' => '',
      'New Ticket' => '',
      'Create new Ticket' => '',
      'installed' => '',
      'uninstalled' => '',
    };
    # $$STOP$$
}
# --
1;
