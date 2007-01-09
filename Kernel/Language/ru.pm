# --
# Kernel/Language/ru.pm - provides ru language translation
# Copyright (C) 2003 Serg V Kravchenko <skraft at rgs.ru>
# --
# $Id: ru.pm,v 1.36.2.1 2007-01-09 01:21:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::ru;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.36.2.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Oct  5 06:05:06 2006

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
      'last' => 'последний',
      'before' => 'перед',
      'day' => 'сутки',
      'days' => 'сут.',
      'day(s)' => 'дней',
      'hour' => 'час',
      'hours' => 'ч.',
      'hour(s)' => '',
      'minute' => 'мин.',
      'minutes' => 'мин.',
      'minute(s)' => '',
      'month' => '',
      'months' => '',
      'month(s)' => 'месяцев',
      'week' => '',
      'week(s)' => 'недель',
      'year' => '',
      'years' => '',
      'year(s)' => 'годов',
      'second(s)' => '',
      'seconds' => '',
      'second' => '',
      'wrote' => 'написал(а)',
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
      'valid' => 'действительный',
      'invalid' => 'недействительный',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 Минуты',
      ' 5 minutes' => ' 5 Минут',
      ' 7 minutes' => ' 7 Минут',
      '10 minutes' => '10 Минут',
      '15 minutes' => '15 Минут',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => 'Вперед',
      'Back' => 'Назад',
      'Next...' => 'Вперед...',
      '...Back' => '...Назад',
      '-none-' => '',
      'none' => 'нет',
      'none!' => 'нет!',
      'none - answered' => 'нет - отвечен?',
      'please do not edit!' => 'Не редактировать!',
      'AddLink' => 'Добавить ссылку',
      'Link' => 'Связать',
      'Linked' => 'Связан',
      'Link (Normal)' => 'Связь (обычная)',
      'Link (Parent)' => 'Связь (Родитель)',
      'Link (Child)' => 'Связь (Child)',
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
      'customer' => 'клиент',
      'agent' => 'агент',
      'system' => 'система',
      'Customer Info' => 'Информация о клиенте',
      'go!' => 'ОК!',
      'go' => 'ОК',
      'All' => 'Все',
      'all' => 'все',
      'Sorry' => 'Извините',
      'update!' => 'обновить!',
      'update' => 'обновить',
      'Update' => 'Обновить',
      'submit!' => 'Ввести!',
      'submit' => 'ввести',
      'Submit' => 'Ввести',
      'change!' => 'Изменить!',
      'Change' => 'Изменение',
      'change' => 'изменение',
      'click here' => 'кликнуть здесь',
      'Comment' => 'Комментарий',
      'Valid' => 'Действительный',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => 'Имя',
      'Group' => 'Группа',
      'Description' => 'Описание',
      'description' => 'описание',
      'Theme' => 'Тема',
      'Created' => 'Создан',
      'Created by' => 'Создано',
      'Changed' => 'Изменен',
      'Changed by' => 'Изменено',
      'Search' => 'Поиск',
      'and' => 'и',
      'between' => 'между',
      'Fulltext Search' => '',
      'Data' => 'Дата',
      'Options' => 'Настройки',
      'Title' => 'Заголовок',
      'Item' => '',
      'Delete' => 'Удалить',
      'Edit' => 'Редактировать',
      'View' => 'Просмотр',
      'Number' => 'Число',
      'System' => 'Система',
      'Contact' => 'Контакт',
      'Contacts' => 'Контакты',
      'Export' => 'Экспорт',
      'Up' => 'Вверх',
      'Down' => 'Вниз',
      'Add' => 'Добавить',
      'Category' => 'Категория',
      'Viewer' => '',
      'New message' => 'новое сообщение',
      'New message!' => 'новое сообщение!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Ответьте на эти заявки для перехода к обычному просмотру очереди !',
      'You got new message!' => 'У вас новое сообщение!',
      'You have %s new message(s)!' => 'Количество новых сообщений: %s',
      'You have %s reminder ticket(s)!' => 'Количество %s напоминаний!',
      'The recommended charset for your language is %s!' => 'Рекомендуемая кодировка для вашего языка %s',
      'Passwords doesn\'t match! Please try it again!' => 'Неверный пароль!',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Нет предложений',
      'Word' => 'Слово',
      'Ignore' => 'Пренебречь',
      'replace with' => 'заменить на',
      'Welcome to OTRS' => 'Добро пожаловать в OTRS',
      'There is no account with that login name.' => 'Нет пользователя с таким именем.',
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешная авторизация! Ваше имя или пароль неверны!',
      'Please contact your admin' => 'Свяжитесь с администратором',
      'Logout successful. Thank you for using OTRS!' => 'Выход успешен. Благодарим за пользование системой OTRS',
      'Invalid SessionID!' => 'Неверный идентификатор сессии!',
      'Feature not active!' => '',
      'License' => '',
      'Take this Customer' => 'Выбрать клиента',
      'Take this User' => 'Выбрать этого пользователя',
      'possible' => 'возможно',
      'reject' => 'отвергнуть',
      'reverse' => '',
      'Facility' => 'Приспособление',
      'Timeover' => 'Время ожидания истекло',
      'Pending till' => 'В ожидании еще',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работайте с UserID 1 (Системная учетная запись)! Создайте другого пользователя!',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'No entry found!' => 'Запись не найдена',
      'Session has timed out. Please log in again.' => 'Сессия завершена. Попробуйте войти заново.',
      'No Permission!' => 'Нет доступа!',
      'To: (%s) replaced with database email!' => '',
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '(добавить)',
      'Preview' => 'Просмотр',
      'Package not correctly deployed! You should reinstall the Package again!' => '',
      'Added User "%s"' => '',
      'Contract' => 'Контракт',
      'Online Customer: %s' => '',
      'Online Agent: %s' => '',
      'Calendar' => 'Календарь',
      'File' => 'Файл',
      'Filename' => 'Имя файла',
      'Type' => 'Тип',
      'Size' => 'Размер',
      'Upload' => 'Загрузить',
      'Directory' => '',
      'Signed' => 'Подписано',
      'Sign' => 'Подписать',
      'Crypted' => '',
      'Crypt' => '',
      'Office' => '',
      'Phone' => '',
      'Fax' => '',
      'Mobile' => '',
      'Zip' => '',
      'City' => '',
      'Country' => '',
      'installed' => '',
      'uninstalled' => '',
      'printed at' => '',

      # Template: AAAMonth
      'Jan' => 'Января',
      'Feb' => 'Февраля',
      'Mar' => 'Марта',
      'Apr' => 'Апреля',
      'May' => '',
      'Jun' => 'Июня',
      'Jul' => 'Июля',
      'Aug' => 'Августа',
      'Sep' => 'Сентября',
      'Oct' => 'Октября',
      'Nov' => 'Ноября',
      'Dec' => 'Декабря',
      'January' => 'Января',
      'February' => 'Февраля',
      'March' => '',
      'April' => 'Апреля',
      'June' => 'Июня',
      'July' => '',
      'August' => 'Августа',
      'September' => 'Сентября',
      'October' => 'Октября',
      'November' => 'Ноября',
      'December' => 'Декабря',

      # Template: AAANavBar
      'Admin-Area' => 'Администрирование системы',
      'Agent-Area' => '',
      'Ticket-Area' => '',
      'Logout' => 'Выход',
      'Agent Preferences' => '',
      'Preferences' => 'Предпочтения',
      'Agent Mailbox' => '',
      'Stats' => 'Статистика',
      'Stats-Area' => 'Статистика',
      'New Article' => 'Новая статья',
      'Admin' => 'Администрирование',
      'A web calendar' => 'Календарь',
      'WebMail' => 'Почта',
      'A web mail client' => '',
      'FileManager' => '',
      'A web file manager' => '',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',
      'Customer Users' => 'Клиенты',
      'Customer Users <-> Groups' => 'Группы клиентов',
      'Users <-> Groups' => 'Настройки групп',
      'Roles' => 'Роли',
      'Roles <-> Users' => '',
      'Roles <-> Groups' => '',
      'Salutations' => 'Приветствия',
      'Signatures' => 'Подписи',
      'Email Addresses' => '',
      'Notifications' => 'Уведомления',
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
      'Spelling Dictionary' => 'Словарь',
      'Select your default spelling dictionary.' => 'Выбирете основной словарь',
      'Max. shown Tickets a page in Overview.' => '',
      'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Невозможно сменить пароль, пароли несоответствуют!',
      'Can\'t update password, invalid characters!' => 'Невозможно сменить пароль, неверная кодировка!',
      'Can\'t update password, need min. 8 characters!' => 'Невозможно сменить пароль, необходимо не менее 8 символов!',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => 'Невозможно сменить пароль, должна писутствовать как минимум 1 цифра!',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

      # Template: AAAStats
      'Stat' => '',
      'Please fill out the required fields!' => '',
      'Please select a file!' => '',
      'Please select an object!' => '',
      'Please select a graph size!' => '',
      'Please select one element for the X-axis!' => '',
      'You have to select two or more attributes from the select field!' => '',
      'Please select only one element or turn of the button \'Fixed\' where the select field is marked!' => '',
      'If you use a checkbox you have to select some attributes of the select field!' => '',
      'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
      'The selected end time is before the start time!' => '',
      'You have to select one or more attributes from the select field!' => '',
      'The selected Date isn\'t valid!' => '',
      'Please select only one or two elements via the checkbox!' => '',
      'If you use a time scale element you can only select one element!' => '',
      'You have an error in your time selection!' => '',
      'Your reporting time interval is to small, please use a larger time scale!' => '',
      'The selected start time is before the allowed start time!' => '',
      'The selected end time is after the allowed end time!' => '',
      'The selected time period is larger than the allowed time period!' => '',
      'Common Specification' => '',
      'Xaxis' => '',
      'Value Series' => '',
      'Restrictions' => '',
      'graph-lines' => '',
      'graph-bars' => '',
      'graph-hbars' => '',
      'graph-points' => '',
      'graph-lines-points' => '',
      'graph-area' => '',
      'graph-pie' => '',
      'extended' => '',
      'Agent/Owner' => '',
      'Created by Agent/Owner' => '',
      'Created Priority' => '',
      'Created State' => '',
      'Create Time' => '',
      'CustomerUserLogin' => '',
      'Close Time' => '',

      # Template: AAATicket
      'Lock' => 'Блокировка',
      'Unlock' => 'Разблокировать',
      'History' => 'История',
      'Zoom' => 'Подробно',
      'Age' => 'Возраст',
      'Bounce' => '',
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
      'Pending' => 'Отложить',
      'Owner' => 'Владелец',
      'Owner Update' => '',
      'Responsible' => '',
      'Responsible Update' => '',
      'Sender' => 'Отправитель',
      'Article' => 'Заявка',
      'Ticket' => 'Заявка',
      'Createtime' => 'Время создания',
      'plain' => 'обычный',
      'Email' => 'e-mail',
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
      'Merge' => 'Объединить',
      'closed successful' => 'Закрыт успешно',
      'closed unsuccessful' => 'Закрыт неуспешно',
      'new' => 'новый',
      'open' => 'открытый',
      'closed' => 'закрытый',
      'removed' => 'удаленный',
      'pending reminder' => 'отложенное напоминание',
      'pending auto close+' => 'очередь на авто закрытие+',
      'pending auto close-' => 'очередь на авто закрытие-',
      'email-external' => 'внешний e-mail',
      'email-internal' => 'внутренний e-mail',
      'note-external' => 'внешняя заметка',
      'note-internal' => 'внутренняя заметка',
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
      'very high' => 'безотлагательный',
      '1 very low' => '1 самый низкий',
      '2 low' => '2 низкий',
      '3 normal' => '3 нормальный',
      '4 high' => '4 высокий',
      '5 very high' => '5 безотлагательный',
      'Ticket "%s" created!' => 'Заявка "%s" создана!',
      'Ticket Number' => 'Номер заявки',
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'Don\'t show closed Tickets' => 'Не показывать закрытые заявки',
      'Show closed Tickets' => 'Показывать закрытые заявки',
      'Email-Ticket' => 'Письмо',
      'Create new Email Ticket' => 'Создать новую заявку',
      'Phone-Ticket' => 'Телефонный звонок',
      'Create new Phone Ticket' => 'Создать телефонную заявку',
      'Search Tickets' => 'Поиск заявок',
      'Edit Customer Users' => 'Редактировать клиентов',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => 'Отправить письмо и создать новую заявку',
      'Overview of all open Tickets' => '',
      'Locked Tickets' => '',
      'Lock it to work on it!' => '',
      'Unlock to give it back to the queue!' => 'Разблокировать и вернуть в очередь!',
      'Shows the ticket history!' => 'Показать историю заявки!',
      'Print this ticket!' => 'Печать заявки!',
      'Change the ticket priority!' => 'Изменить приоритет!',
      'Change the ticket free fields!' => '',
      'Link this ticket to an other objects!' => '',
      'Change the ticket owner!' => 'Изменить владельца!',
      'Change the ticket customer!' => 'Изменить клиента!',
      'Add a note to this ticket!' => 'Добавить заметку к заявке!',
      'Merge this ticket!' => 'Объединить заявку',
      'Set this ticket to pending!' => '',
      'Close this ticket!' => 'Закрыть заявку!',
      'Look into a ticket!' => 'Просмотреть заявку!',
      'Delete this ticket!' => 'Удалить заявку!',
      'Mark as Spam!' => '',
      'My Queues' => '',
      'Shown Tickets' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',
      'New ticket notification' => 'Уведомление о новоей заявке',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Уведомление о новых заявках',
      'Follow up notification' => 'Уведомление об обновлениях',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Прислать мне уведомление, если клиент прислал обновление и я собственник заявки.',
      'Ticket lock timeout notification' => 'Уведомление о истечении срока блокировки заявки системой',
      'Send me a notification if a ticket is unlocked by the system.' => 'Прислать мне уведомление, если заявка освобождена системой.',
      'Move notification' => 'Уведомление о перемещении',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '',
      'Custom Queue' => 'Дополнительная (custom) очередь',
      'QueueView refresh time' => 'Время обновления монитора очередей',
      'Screen after new ticket' => '',
      'Select your screen after creating a new ticket.' => '',
      'Closed Tickets' => 'Закрытые заявки',
      'Show closed tickets.' => 'Показывать закрытые заявки',
      'Max. shown Tickets a page in QueueView.' => '',
      'CompanyTickets' => '',
      'MyTickets' => '',
      'New Ticket' => '',
      'Create new Ticket' => '',
      'Customer called' => '',
      'phone call' => 'телефонный звонок',
      'Responses' => 'Ответы',
      'Responses <-> Queue' => '',
      'Auto Responses' => 'Автоответы',
      'Auto Responses <-> Queue' => 'Автоответы очередей',
      'Attachments <-> Responses' => '',
      'History::Move' => 'Заявка перемещена в очередь "%s" (%s) из очереди "%s" (%s).',
      'History::NewTicket' => 'Создание заявки [%s] (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'Ответ на [%s]. %s',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'Автоответ послан "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::Forward' => 'Перенаправлено к "%s".',
      'History::Bounce' => 'Bounced to "%s".',
      'History::SendAnswer' => 'Сообщение оправлено для "%s".',
      'History::SendAgentNotification' => '"%s"-уведомление отправлено "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::EmailAgent' => 'Клиенту отправлено сообщение.',
      'History::EmailCustomer' => 'Получено сообщение. %s',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::AddNote' => 'Добавлена заметка (%s)',
      'History::Lock' => 'Блокировка заявки.',
      'History::Unlock' => 'Разблокирование заявки.',
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
      'Sun' => 'Воскресенье',
      'Mon' => 'Понедельник',
      'Tue' => 'Вторник',
      'Wed' => 'Среда  ',
      'Thu' => 'Четверг',
      'Fri' => 'Пятница',
      'Sat' => 'Суббота',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Управление прикрепленными файлами',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Управление автоответами',
      'Response' => 'Ответ',
      'Auto Response From' => 'Автоматический ответ от',
      'Note' => 'Заметка',
      'Useable options' => 'Используемые опции',
      'to get the first 20 character of the subject' => 'получить первые 20 символов поля "тема"',
      'to get the first 5 lines of the email' => 'получить первые 5 строк письма',
      'to get the from line of the email' => 'получить поле "от" письма',
      'to get the realname of the sender (if given)' => 'получить (если есть) имя отправителя',
      'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
      'Config options (e. g. <OTRS_CONFIG_HttpType>)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'создаваемое сообщение было закрыто. выход.',
      'This window must be called from compose window' => 'Это окно должно вызываться из окна ввода',
      'Customer User Management' => 'Управление пользователями (для клиентов)',
      'Search for' => 'Искать',
      'Result' => 'Результат',
      'Select Source (for add)' => 'Выбрать источник',
      'Source' => 'Источник',
      'This values are read only.' => 'Данное значение только для чтения',
      'This values are required.' => 'Данное значение обязательно',
      'Customer user will be needed to have a customer history and to login via customer panel.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Управление группами клиентов',
      'Change %s settings' => 'Изменить %s настроек',
      'Select the user:group permissions.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => 'Права',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => 'Права только на чтение заявки в данной группе/очереди',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => 'Полные права на заявки в данной группе/очереди',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Сообщение отправлено для',
      'Recipents' => 'Получатели',
      'Body' => 'Тело письма',
      'send' => 'Отправить',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => 'Список задач',
      'Last run' => 'Последний запуск',
      'Run Now!' => 'Выполнить сейчас!',
      'x' => '',
      'Save Job as?' => 'Сохранить задачу как?',
      'Is Job Valid?' => 'Данная задача действительна?',
      'Is Job Valid' => 'Данная задача действительна',
      'Schedule' => 'Расписание',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      'Customer User Login' => '',
      '(e. g. U5150)' => '',
      'Agent' => '',
      'Ticket Lock' => '',
      'TicketFreeFields' => '',
      'Times' => 'Время',
      'No time settings.' => 'Нет временных ограничений',
      'Ticket created' => 'Заявка создана',
      'Ticket created between' => 'Заявка создана между ',
      'New Priority' => 'Новый приоритет',
      'New Queue' => 'Новая очередь',
      'New State' => 'Новый статус',
      'New Agent' => 'Новый агент',
      'New Owner' => 'Новый владелец',
      'New Customer' => 'Новый клиент',
      'New Ticket Lock' => '',
      'CustomerUser' => 'Пользователь клиента',
      'New TicketFreeFields' => '',
      'Add Note' => 'Добавить заметку',
      'CMD' => 'Комманда',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => 'Удалить заявки',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Внимание! Данные заявки будут удалены из базы!',
      'Send Notification' => '',
      'Param 1' => 'Параметр 1',
      'Param 2' => 'Параметр 2',
      'Param 3' => 'Параметр 3',
      'Param 4' => 'Параметр 4',
      'Param 5' => 'Параметр 5',
      'Param 6' => 'Параметр 6',
      'Send no notifications' => '',
      'Yes means, send no agent and customer notifications on changes.' => '',
      'No means, send agent and customer notifications on changes.' => '',
      'Save' => 'Сохранить',
      '%s Tickets affected! Do you really want to use this job?' => '',

      # Template: AdminGroupForm
      'Group Management' => 'Управление группами',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Группа admin должна быть в admin зоне, а stats группа в stat зоне',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Создать новые группы для контроля доступа различных групп агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
      'It\'s useful for ASP solutions.' => 'Это подходит для ASP.',

      # Template: AdminLog
      'System Log' => 'Системный журнал',
      'Time' => 'Время',

      # Template: AdminNavigationBar
      'Users' => 'Пользователи',
      'Groups' => 'Группы',
      'Misc' => 'Дополнительно',

      # Template: AdminNotificationForm
      'Notification Management' => 'Управления уведомлениями',
      'Notification' => 'Уведомление',
      'Notifications are sent to an agent or a customer.' => '',
      'Ticket owner options (e. g. <OTRS_OWNER_USERFIRSTNAME>)' => '',
      'Options of the current user who requested this action (e. g. <OTRS_CURRENT_USERFIRSTNAME>)' => '',
      'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_USERFIRSTNAME>)' => '',
      'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',

      # Template: AdminPackageManager
      'Package Manager' => '',
      'Uninstall' => 'Удалить',
      'Version' => 'Версия',
      'Do you really want to uninstall this package?' => '',
      'Reinstall' => 'Переустановить',
      'Do you really want to reinstall this package (all manual changes get lost)?' => '',
      'Install' => 'Установить',
      'Package' => '',
      'Online Repository' => '',
      'Vendor' => 'Изготовитель',
      'Upgrade' => 'Обновить',
      'Local Repository' => '',
      'Status' => 'Статус',
      'Overview' => 'Обзор',
      'Download' => 'Скачать',
      'Rebuild' => '',
      'Download file from package!' => '',
      'Required' => '',
      'PrimaryKey' => '',
      'AutoIncrement' => '',
      'SQL' => '',
      'Diff' => '',

      # Template: AdminPerformanceLog
      'Performance Log' => '',
      'Logfile too large!' => '',
      'Logfile too large, you need to reset it!' => '',
      'Range' => '',
      'Interface' => '',
      'Requests' => '',
      'Min Response' => '',
      'Max Response' => '',
      'Average Response' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => 'Ключ',
      'Fingerprint' => '',
      'Expires' => 'Истекает',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3
      'POP3 Account Management' => 'Управление учетной записью POP3',
      'Host' => 'Сервер',
      'List' => '',
      'Trusted' => 'Безопасный',
      'Dispatching' => 'Перенаправление',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Все входящие письма с едной учетной записи будут перенесены в избранную очередь!',
      'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => '',
      'Match' => 'Соответствует',
      'Header' => 'Заголовок',
      'Value' => 'Значение',
      'Set' => 'Установить',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Автоответы в очереди',

      # Template: AdminQueueForm
      'Queue Management' => 'Управление очередью',
      'Sub-Queue of' => 'Подочередь в',
      'Unlock timeout' => 'Срок блокировки',
      '0 = no unlock' => '0 = без блокировки',
      'Escalation time' => 'Время до эскалации заявки (увеличение приоритета)',
      '0 = no escalation' => '0 = без эскалации',
      'Follow up Option' => 'Параметры авто-слежения ?',
      'Ticket lock after a follow up' => 'Блокировка заявки после прихода дополнения',
      'Systemaddress' => 'Системный адрес',
      'Customer Move Notify' => 'Извещать клиента о перемещении',
      'Customer State Notify' => 'Извещать клиента о смене состояния',
      'Customer Owner Notify' => 'Извещать клиента о смене владельца',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Если агент заблокировал заявку и не послал ответ клиенту в течение установленного времени, то заявка автоматически разблокируется и станет доступной для остальных агентов',
      'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Если заявка не будет обслужена в установленное время, показывать только эту заявку',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Если заявка закрыта, а клиент прислал дополнение,то заявка будет заблокирована для предыдущего владельца',
      'Will be the sender address of this queue for email answers.' => 'Установка адреса отправителя для ответов в этой очереди',
      'The salutation for email answers.' => 'Приветствие для почтовых сообщений',
      'The signature for email answers.' => 'Подпись для почтовых сообщений',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS отправит уведомление клиенту при перемещении заявки',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS отправит уведомление клиенту при изменении статуса заявки',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS отправит уведомление клиенту при смене владельца заявки',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Управление ответами в очередях',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Ответ',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'Управление приложенными файлами в ответах',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Управление ответами',
      'A response is default text to write faster answer (with default text) to customers.' => 'Ответ - заготовка текста для ответа кклиенту',
      'Don\'t forget to add a new response a queue!' => 'Не забудьте добавить ответ для очереди!',
      'Next state' => 'Следующее состояние',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => 'Данное состояние заявки',
      'Your email address is new' => '',

      # Template: AdminRoleForm
      'Role Management' => 'Управление ролями',
      'Create a role and put groups in it. Then add the role to the users.' => 'Создайте роль и наложите ее на группы. Затем примените роль к пользователям.',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => 'Управление ролями в группах',
      'move_into' => 'переместить',
      'Permissions to move tickets into this group/queue.' => 'Права на перемещение заявок в эту группу/очередь',
      'create' => 'создание',
      'Permissions to create tickets in this group/queue.' => 'Права на создание заявок в этой группе/очереди',
      'owner' => 'владелец',
      'Permissions to change the ticket owner in this group/queue.' => 'Права на смену владельца заявок в этой группе/очереди',
      'priority' => 'приоритет',
      'Permissions to change the ticket priority in this group/queue.' => 'Права на смену приоритета заявок в этой группе/очереди',

      # Template: AdminRoleGroupForm
      'Role' => 'Роль',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => 'Управление ролями пользователей',
      'Active' => 'Активный',
      'Select the role:user relations.' => 'Выберите связь между ролью и пользователем',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Управление приветствиями',
      'customer realname' => 'имя клиента',
      'All Agent variables.' => '',
      'for agent firstname' => 'для агента - имя',
      'for agent lastname' => 'для агента - фамилия',
      'for agent user id' => '',
      'for agent login' => '',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Дать команду SELECT',
      'Limit' => 'Лимит',
      'Select Box Result' => 'Выберите из меню',

      # Template: AdminSession
      'Session Management' => 'Управление сессиями',
      'Sessions' => 'Сессии',
      'Uniq' => 'Уникальный',
      'kill all sessions' => 'Закрыть все текущие сессии',
      'Session' => 'Сессия',
      'Content' => '',
      'kill session' => 'Закрыть сессию',

      # Template: AdminSignatureForm
      'Signature Management' => 'Управление на подписью',

      # Template: AdminSMIMEForm
      'S/MIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Управление системными состояниями',
      'State Type' => '',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',
      'See also' => 'См. также',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => 'Выбор группы',
      'Show' => 'Показать',
      'Download Settings' => '',
      'Download all system config changes.' => '',
      'Load Settings' => '',
      'Subgroup' => 'Подгруппа',
      'Elements' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Default' => '',
      'New' => 'Новый',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'NavBar' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Управление системными e-mail адресами',
      'Realname' => 'Реальное Имя',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Все входящие сообщения с этим полем (Для:) будут направлены в выбранную очередь',

      # Template: AdminUserForm
      'User Management' => 'Управление пользователями',
      'Login as' => '',
      'Firstname' => 'Имя',
      'Lastname' => 'Фамилия',
      'User will be needed to handle tickets.' => 'Для обработки заявок нужен пользователь',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => 'Управление группами пользователей',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'Адресная книга',
      'Return to the compose screen' => 'вернуться в окно ввода',
      'Discard all changes and return to the compose screen' => 'Отказаться от всех изменений и вернуться в окно ввода',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Информация',

      # Template: AgentLinkObject
      'Link Object' => 'Связать объект',
      'Select' => 'Выбрать',
      'Results' => 'Результат',
      'Total hits' => 'Кумулятивные попадания',
      'Page' => 'Страница',
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
      'or' => 'или',
      'Apply these changes' => 'Применить эти изменения',

      # Template: AgentStatsDelete
      'Do you really want to delete this Object?' => '',

      # Template: AgentStatsEditRestrictions
      'Select the restrictions to characterise the stat' => '',
      'Fixed' => '',
      'Please select only one Element or turn of the button \'Fixed\'.' => '',
      'Absolut Period' => '',
      'Between' => '',
      'Relative Period' => '',
      'The last' => '',
      'Finish' => '',
      'Here you can make restrictions to your stat.' => '',
      'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributs of the corresponding element.' => '',

      # Template: AgentStatsEditSpecification
      'Insert of the common specifications' => '',
      'Permissions' => '',
      'Format' => '',
      'Graphsize' => '',
      'Sum rows' => '',
      'Sum columns' => '',
      'Cache' => '',
      'Required Field' => '',
      'Selection needed' => '',
      'Explanation' => '',
      'In this form you can select the basic specifications.' => '',
      'Attribute' => '',
      'Title of the stat.' => '',
      'Here you can insert a description of the stat.' => '',
      'Dynamic-Object' => '',
      'Here you can select the dynamic object you want to use.' => '',
      '(Note: It depends on your installation how many dynamic objects you can use)' => '',
      'Static-File' => '',
      'For very complex stats it is possible to include a hardcoded file.' => '',
      'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
      'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
      'Multiple selection of the output format.' => '',
      'If you use a graph as output format you have to select at least one graph size.' => '',
      'If you need the sum of every row select yes' => '',
      'If you need the sum of every column select yes.' => '',
      'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
      '(Note: Useful for big databases and low performance server)' => '',
      'With an invalid stat it isn\'t feasible to generate a stat.' => '',
      'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

      # Template: AgentStatsEditValueSeries
      'Select the elements for the value series' => '',
      'Scale' => '',
      'minimal' => '',
      'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
      'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

      # Template: AgentStatsEditXaxis
      'Select the element, which will be used at the X-axis' => '',
      'maximal period' => '',
      'minimal scale' => '',
      'Here you can define the x-axis. You can select one element via the radio button. Than you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

      # Template: AgentStatsImport
      'Import' => '',
      'File is not a Stats config' => '',
      'No File selected' => '',

      # Template: AgentStatsOverview
      'Object' => '',

      # Template: AgentStatsPrint
      'Print' => 'Печать',
      'No Element selected.' => '',

      # Template: AgentStatsView
      'Export Config' => '',
      'Informations about the Stat' => '',
      'Exchange Axis' => '',
      'Configurable params of static stat' => '',
      'No element selected.' => '',
      'maximal period form' => '',
      'to' => '',
      'Start' => 'Начало',
      'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Сообщение должно иметь поле ДЛЯ: адресата!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Нужен правильный адрес в поле ДЛЯ: (support@rgs.ru)!',
      'Bounce ticket' => 'Пересылка заявки',
      'Bounce to' => 'Переслать для',
      'Next ticket state' => 'Следующее состояние заявки',
      'Inform sender' => 'Информировать отправителя',
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
      'Ticket locked!' => 'Заявка заблокирована!',
      'Ticket unlock!' => 'Заявка разблокирована!',
      'Previous Owner' => 'Предыдущий владелец',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',
      'Attach' => 'Прикрепить файл',
      'Pending date' => 'Дата ожидания',
      'Time units' => 'Единицы времени',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => '',
      'Compose answer for ticket' => 'Создание ответ на заявку',
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
      'Compose Email' => 'Написать письмо',
      'new ticket' => 'новая Заявка',
      'Refresh' => '',
      'Clear To' => 'Очистить',
      'All Agents' => '',

      # Template: AgentTicketForward
      'Article type' => 'Тип статьи',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => '',

      # Template: AgentTicketHistory
      'History of' => 'История',

      # Template: AgentTicketLocked

      # Template: AgentTicketMailbox
      'Mailbox' => 'Почтовый ящик',
      'Tickets' => 'Заявки',
      'of' => 'на',
      'Filter' => '',
      'All messages' => 'Все сообщения',
      'New messages' => 'Новые сообщения',
      'Pending messages' => 'Сообщения в ожидании',
      'Reminder messages' => 'Напоминающие сообщения',
      'Reminder' => 'Напоминание',
      'Sort by' => 'Сортировка по',
      'Order' => 'Порядок',
      'up' => 'вверх',
      'down' => 'вниз',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => 'Объединение заявок',
      'Merge to' => 'Объединить с',

      # Template: AgentTicketMove
      'Move Ticket' => 'Переместить заявку',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Добавить заметку к заявке',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Изменить собственика заявки',

      # Template: AgentTicketPending
      'Set Pending' => 'Устновка ожидания',

      # Template: AgentTicketPhone
      'Phone call' => 'Телефонный звонок',
      'Clear From' => 'Очистить форму',
      'Create' => '',

      # Template: AgentTicketPhoneOutbound

      # Template: AgentTicketPlain
      'Plain' => 'Обыкновенный',
      'TicketID' => 'ID заявки',
      'ArticleID' => 'ID заметки',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Потраченное на заявку время',
      'Escalation in' => 'Эскалация через',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => '',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Изменить приоритет заявки',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Показаны Заявки',
      'Tickets available' => 'Доступные заявки',
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

      # Template: AgentTicketResponsible
      'Change responsible of ticket' => '',

      # Template: AgentTicketSearch
      'Ticket Search' => 'Поиск заявки',
      'Profile' => 'Параметры',
      'Search-Template' => 'Шаблон',
      'TicketFreeText' => '',
      'Created in Queue' => 'Создано в очереди',
      'Result Form' => 'Вывод результатов',
      'Save Search-Profile as Template?' => 'Сохранить параметры поиска в качестве шаблона?',
      'Yes, save it with name' => 'Да, сохранить с именем',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Результат поиска',
      'Change search options' => 'Изменить установки поиска',

      # Template: AgentTicketSearchResultPrint

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'сортировка по возрастанию',
      'U' => '',
      'sort downward' => 'сортировка по убыванию',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => 'Открытые заявки',

      # Template: AgentTicketZoom
      'Locked' => 'Блокировка',
      'Split' => '',

      # Template: AgentWindowTab

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '',

      # Template: CustomerFooter
      'Powered by' => '',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => '',
      'Lost your password?' => 'Забыли свой пароль',
      'Request new password' => 'Прислать новый пароль',
      'Create Account' => 'Создать учетную запись',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Приветствуем %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView

      # Template: CustomerTicketMessage

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Кликнуть здесь,чтобы послать сообщение об ошибке',

      # Template: Footer
      'Top of Page' => 'Верх страницы',

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
      'Welcome to %s' => '',

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

      # Template: Test
      'OTRS Test Page' => 'Тестовая страница OTRS',
      'Counter' => '',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => '',
      'auto responses set!' => 'установленных автоответов',
      'Create Database' => 'Создать базу',
      ' (work units)' => ' (рабочие единицы)',
      'End' => 'Окончание',
      'DB Host' => '',
      'Change roles <-> groups settings' => '',
      'Ticket Number Generator' => 'Генератор номера Заявки',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Symptom' => 'Признак',
      'Site' => 'Место',
      'Change users <-> roles settings' => '',
      'Customer history search (e. g. "ID342425").' => 'Поиск истории клиента (напр. "ID342425").',
      'Ticket Hook' => 'Зацепить Заявку',
      'Events' => 'События',
      'Close!' => 'Закрыть!',
      'Subgroup \'' => 'подгруппа',
      'TicketZoom' => 'Просмотр заявки',
      'Don\'t forget to add a new user to groups!' => 'Не забудьте добавить новоего пользователя в группы!',
      'CreateTicket' => 'Создание заявки',
      'OTRS DB Name' => '',
      'System Settings' => 'Системные установки',
      'Involved' => 'Совместно с',
      'Hours' => 'Часы',
      'Finished' => 'Закончено',
      'Days' => 'Дни',
      'Locked tickets' => 'Заблокированные заявки',
      'Queue ID' => 'ID очереди',
      'A article should have a title!' => '',
      'System History' => 'История',
      '7 Day' => '7 Дней',
      'Ticket Overview' => 'Обзор заявок',
      'Modules' => 'Модули',
      'Keyword' => '',
      'Close type' => 'Тип закрытия',
      'DB Admin User' => '',
      'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
      'Change user <-> group settings' => 'Изменить настройки групп пользователей',
      'Name is required!' => 'Заголовок обязателен!',
      'Problem' => 'Проблема',
      'for ' => 'для',
      'DB Type' => '',
      'next step' => 'следующий шаг',
      'Customer history search' => 'Поиск истории клиента',
      'FIXME: WHAT IS PGP?' => '',
      'Solution' => 'Решение',
      '5 Day' => '5 Дней',
      'Admin-Email' => 'e-mail администратора',
      'QueueView' => 'Просмотр очереди',
      'Create new database' => '',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => '',
      '\' ' => '',
      'modified' => '',
      'Running' => 'Выполняется',
      'Delete old database' => '',
      'Keywords' => '',
      'Typ' => '',
      'Today' => 'Сегодня',
      'Tommorow' => 'Завтра',
      'Note Text' => 'Текст заметки',
      '3 Month' => '3 Месяца',
      'No * possible!' => 'Нельзя использовать символ * !',
      'Jule' => 'Июля',
      'OTRS DB User' => '',
      'Options ' => 'Опции',
      'PhoneView' => 'Заявка по телефону',
      'FIXME: WHAT IS SMIME?' => '',
      'Verion' => '',
      'Message for new Owner' => 'сообщение для нового владельца',
      'Mart' => 'Марта',
      'OTRS DB Password' => '',
      'Last update' => 'Последнее изменение',
      'DB Admin Password' => '',
      'Drop Database' => 'Удалить базу',
      'Pending type' => 'Тип ожидания',
      'Change setting' => 'Изменить настройки',
      'Comment (internal)' => '',
      'Minutes' => 'Минуты',
      '(Used ticket number format)' => '(Используемый формат номеров Заявок)',
      'Fulltext' => '',
      'Modified' => 'Изменено',
      'Watched Tickets' => '',
      'Watched' => '',
      'Subscribe' => '',
      'Unsubscribe' => '',
    };
    # $$STOP$$
}

1;
