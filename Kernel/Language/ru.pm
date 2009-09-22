# --
# Kernel/Language/ru.pm - provides ru language translation
# Copyright (C) 2003 Serg V Kravchenko <skraft at rgs.ru>
# Copyright (C) 2007 Andrey Feldman <afeldman at alt-lan.ru>
# Copyright (C) 2008-2009 Egor Tsilenko <bg8s at symlink.ru>
# Copyright (C) 2009 Andrey Cherepanov <cas at altlinux.ru>
# --
# $Id: ru.pm,v 1.87.2.1 2009-09-22 13:04:56 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.87.2.1 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri Jul 17 17:59:25 2009

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T, %A %D %B, %Y г.';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
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
        'top' => 'В начало',
        'end' => 'В конец',
        'Done' => 'Готово.',
        'Cancel' => 'Отменить',
        'Reset' => 'Отклонить',
        'last' => 'последний',
        'before' => 'перед',
        'day' => 'сутки',
        'days' => 'суток',
        'day(s)' => 'суток',
        'hour' => 'час',
        'hours' => 'часов',
        'hour(s)' => 'ч.',
        'minute' => 'мин.',
        'minutes' => 'мин.',
        'minute(s)' => 'мин.',
        'month' => 'мес.',
        'months' => 'мес.',
        'month(s)' => 'мес.',
        'week' => 'нед.',
        'week(s)' => 'нед.',
        'year' => 'год.',
        'years' => 'год.',
        'year(s)' => 'год.',
        'second(s)' => 'сек.',
        'seconds' => 'сек.',
        'second' => 'сек.',
        'wrote' => 'написал(а)',
        'Message' => 'Сообщение',
        'Error' => 'Ошибка',
        'Bug Report' => 'Отчет об ошибках',
        'Attention' => 'Внимание',
        'Warning' => 'Предупреждение',
        'Module' => 'Модуль',
        'Modulefile' => 'Файл модуля',
        'Subfunction' => 'Подфункция',
        'Line' => 'Строка',
        'Setting' => 'Параметр',
        'Settings' => 'Параметры',
        'Example' => 'Пример',
        'Examples' => 'Примеры',
        'valid' => 'действительный',
        'invalid' => 'недействительный',
        '* invalid' => '* недействительный',
        'invalid-temporarily' => 'временно недействительный',
        ' 2 minutes' => ' 2 минуты',
        ' 5 minutes' => ' 5 минут',
        ' 7 minutes' => ' 7 минут',
        '10 minutes' => '10 минут',
        '15 minutes' => '15 минут',
        'Mr.' => '',
        'Mrs.' => '',
        'Next' => 'Вперед',
        'Back' => 'Назад',
        'Next...' => 'Вперед...',
        '...Back' => '...Назад',
        '-none-' => '-нет-',
        'none' => 'нет',
        'none!' => 'нет!',
        'none - answered' => 'нет — отвечен',
        'please do not edit!' => 'Не редактировать!',
        'AddLink' => 'Добавить ссылку',
        'Link' => 'Связать',
        'Unlink' => 'Отвязать',
        'Linked' => 'Связан',
        'Link (Normal)' => 'Связь (обычная)',
        'Link (Parent)' => 'Связь (родитель)',
        'Link (Child)' => 'Связь (потомок)',
        'Normal' => 'Обычный',
        'Parent' => 'Родитель',
        'Child' => 'Потомок',
        'Hit' => 'Попадание',
        'Hits' => 'Попадания',
        'Text' => 'Текст',
        'Standard' => '',
        'Lite' => 'Облегченный',
        'User' => 'Пользователь',
        'Username' => 'Имя пользователя',
        'Language' => 'Язык',
        'Languages' => 'Языки',
        'Password' => 'Пароль',
        'Salutation' => 'Приветствие',
        'Signature' => 'Подпись',
        'Customer' => 'Клиент',
        'CustomerID' => 'ID пользователя',
        'CustomerIDs' => 'ID пользователей',
        'customer' => 'клиент',
        'agent' => 'агент',
        'system' => 'система',
        'Customer Info' => 'Информация о клиенте',
        'Customer Company' => 'Компания клиента',
        'Company' => 'Компания',
        'go!' => 'ОК!',
        'go' => 'ОК',
        'All' => 'Все',
        'all' => 'все',
        'Sorry' => 'Извините',
        'update!' => 'обновить!',
        'update' => 'обновить',
        'Update' => 'Обновить',
        'Updated!' => 'Обновлено!',
        'submit!' => 'Ввести!',
        'submit' => 'ввести',
        'Submit' => 'Ввести',
        'change!' => 'Изменить!',
        'Change' => 'Изменение',
        'change' => 'изменение',
        'click here' => 'нажмите здесь',
        'Comment' => 'Комментарий',
        'Valid' => 'Действительный',
        'Invalid Option!' => 'Неверный параметр!',
        'Invalid time!' => 'Неверное время!',
        'Invalid date!' => 'Неверная дата!',
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
        'Fulltext Search' => 'Полнотекстовый поиск',
        'Data' => 'Дата',
        'Options' => 'Настройки',
        'Title' => 'Заголовок',
        'Item' => 'пункт',
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
        'Added!' => 'Добавлено!',
        'Category' => 'Категория',
        'Viewer' => 'Просмотр',
        'Expand' => 'Развернуть',
        'New message' => 'Новое сообщение',
        'New message!' => 'Новое сообщение!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Ответьте на эти заявки для перехода к обычному просмотру очереди !',
        'You got new message!' => 'У вас новое сообщение!',
        'You have %s new message(s)!' => 'Количество новых сообщений: %s',
        'You have %s reminder ticket(s)!' => 'Количество напоминаний: %s!',
        'The recommended charset for your language is %s!' => 'Рекомендуемая кодировка для вашего языка: %s',
        'Passwords doesn\'t match! Please try it again!' => 'Неверный пароль!',
        'Password is already in use! Please use an other password!' => 'Пароль уже используется! Попробуйте использовать другой пароль',
        'Password is already used! Please use an other password!' => 'Пароль уже использовался! Попробуйте использовать другой пароль',
        'You need to activate %s first to use it!' => 'Вам необходимо сначала активировать %s чтобы использовать это',
        'No suggestions' => 'Нет предложений',
        'Word' => 'Слово',
        'Ignore' => 'Игнорировать',
        'replace with' => 'заменить на',
        'There is no account with that login name.' => 'Нет пользователя с таким именем.',
        'Login failed! Your username or password was entered incorrectly.' => 'Ошибка идентификации! Указано неправильное имя или пароль!',
        'Please contact your admin' => 'Свяжитесь с администратором',
        'Logout successful. Thank you for using OTRS!' => 'Вы успешно вышли из системы. Благодарим за пользование системой OTRS !',
        'Invalid SessionID!' => 'Неверный идентификатор сессии!',
        'Feature not active!' => 'Функция не активирована!',
        'Notification (Event)' => 'Уведомление о событии',
        'Login is needed!' => 'Необходимо ввести логин',
        'Password is needed!' => 'Необходимо ввести пароль',
        'License' => 'Лицензия',
        'Take this Customer' => 'Выбрать этого клиента',
        'Take this User' => 'Выбрать этого пользователя',
        'possible' => 'возможно',
        'reject' => 'отвергнуть',
        'reverse' => 'вернуть',
        'Facility' => 'Приспособление',
        'Timeover' => 'Время ожидания истекло',
        'Pending till' => 'В ожидании еще',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работайте с UserID 1 (системная учетная запись)! Создайте другого пользователя!',
        'Dispatching by email To: field.' => 'Перенаправление по заголовку To: электронного письма',
        'Dispatching by selected Queue.' => 'Перенаправление по выбранной очереди',
        'No entry found!' => 'Запись не найдена',
        'Session has timed out. Please log in again.' => 'Сеанс завершен. Попробуйте войти заново.',
        'No Permission!' => 'Нет доступа!',
        'To: (%s) replaced with database email!' => 'To: (%s) заменено на e-mail базы данных!',
        'Cc: (%s) added database email!' => 'Cc: (%s) добавлен e-mail базы данных!',
        '(Click here to add)' => '(нажмите сюда чтобы добавить)',
        'Preview' => 'Просмотр',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Пакет установлен некорректно! Вы должны переустановить пакет!',
        'Added User "%s"' => 'Добавлен пользователь "%s"',
        'Contract' => 'Контракт',
        'Online Customer: %s' => 'Клиент онлайн: %s',
        'Online Agent: %s' => 'Пользователь онлайн: %s',
        'Calendar' => 'Календарь',
        'File' => 'Файл',
        'Filename' => 'Имя файла',
        'Type' => 'Тип',
        'Size' => 'Размер',
        'Upload' => 'Загрузить',
        'Directory' => 'Каталог',
        'Signed' => 'Подписано',
        'Sign' => 'Подписать',
        'Crypted' => 'Зашифровано',
        'Crypt' => 'Шифрование',
        'Office' => 'Офис',
        'Phone' => 'Телефон',
        'Fax' => 'Факс',
        'Mobile' => 'Мобильный телефон',
        'Zip' => 'Индекс',
        'City' => 'Город',
        'Street' => 'Улица',
        'Country' => 'Страна',
        'Location' => 'Местоположение',
        'installed' => 'Установлено',
        'uninstalled' => 'Деинсталлировано',
        'Security Note: You should activate %s because application is already running!' => 'Предупреждение о безопасности: вы должны активировать «%s», так как приложение уже запущено!',
        'Unable to parse Online Repository index document!' => 'Невозможно обработать индексный файл сетевого репозитория!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Нет пакетов для запрошенной среды в этом сетевом репозитории, но есть пакеты для других сред!',
        'No Packages or no new Packages in selected Online Repository!' => 'Нет пакетов или новых пакетов в выбранном сетевом репозитории!',
        'printed at' => 'напечатано в',
        'Dear Mr. %s,' => 'Уважаемый %s,',
        'Dear Mrs. %s,' => 'Уважаемая %s,',
        'Dear %s,' => 'Уважаемый(ая)',
        'Hello %s,' => 'Здравствуйте, %s.',
        'This account exists.' => 'Эта учетная запись уже существует.',
        'New account created. Sent Login-Account to %s.' => 'Создана новая учетная запись. Данные для входа в систему отправлены по адресу: %s.',
        'Please press Back and try again.' => 'Нажмите «Назад» и попробуйте еще раз',
        'Sent password token to: %s' => 'Письмо для получения нового пароля отправлено по адресу: %s',
        'Sent new password to: %s' => 'Новый пароль отправлен по адресу: %s',
        'Upcoming Events' => 'Ближайшие события',
        'Event' => 'Событие',
        'Events' => 'События',
        'Invalid Token!' => 'Неверный токен !',
        'more' => 'далее',
        'For more info see:' => 'Дополнительная информация находится по адресу:',
        'Package verification failed!' => 'Ошибка проверки целостности пакета',
        'Collapse' => 'Свернуть',
        'Shown' => '',
        'News' => 'Новости',
        'Product News' => 'Новости о продукте',
        'OTRS News' => '',
        '7 Day Stats' => '',
        'Bold' => 'Полужирный',
        'Italic' => 'Курсив',
        'Underline' => 'Подчеркнутый',
        'Font Color' => 'Цвет текста',
        'Background Color' => 'Цвет фона',
        'Remove Formatting' => 'Удалить форматирование',
        'Show/Hide Hidden Elements' => 'Показ скрытых элементов',
        'Align Left' => 'По левому краю',
        'Align Center' => 'По центру',
        'Align Right' => 'По правому краю',
        'Justify' => 'По ширине',
        'Header' => 'Заголовок',
        'Indent' => 'Увеличить отступ',
        'Outdent' => 'Уменьшить отступ',
        'Create an Unordered List' => 'Создать ненумерованный список',
        'Create an Ordered List' => 'Создать нумерованный список',
        'HTML Link' => 'Ссылка HTML',
        'Insert Image' => 'Вставить изображение',
        'CTRL' => 'Ctrl',
        'SHIFT' => 'Shift',
        'Undo' => 'Отменить',
        'Redo' => 'Повторить',

        # Template: AAAMonth
        'Jan' => 'Янв',
        'Feb' => 'Фев',
        'Mar' => 'Мар',
        'Apr' => 'Апр',
        'May' => 'Май',
        'Jun' => 'Июн',
        'Jul' => 'Июл',
        'Aug' => 'Авг',
        'Sep' => 'Сен',
        'Oct' => 'Окт',
        'Nov' => 'Ноя',
        'Dec' => 'Дек',
        'January' => 'Январь',
        'February' => 'Февраль',
        'March' => 'Март',
        'April' => 'Апрель',
        'May_long' => 'Май',
        'June' => 'Июнь',
        'July' => 'Июль',
        'August' => 'Август',
        'September' => 'Сентябрь',
        'October' => 'Октябрь',
        'November' => 'Ноябрь',
        'December' => 'Декабрь',

        # Template: AAANavBar
        'Admin-Area' => 'Администрирование системы',
        'Agent-Area' => 'Пользователь',
        'Ticket-Area' => 'Заявки',
        'Logout' => 'Выход',
        'Agent Preferences' => 'Настройки пользователя',
        'Preferences' => 'Предпочтения',
        'Agent Mailbox' => 'Почтовый ящик пользователя',
        'Stats' => 'Статистика',
        'Stats-Area' => 'Статистика',
        'Admin' => 'Администрирование',
        'Customer Users' => 'Клиенты',
        'Customer Users <-> Groups' => 'Группы клиентов',
        'Users <-> Groups' => 'Настройки групп',
        'Roles' => 'Роли',
        'Roles <-> Users' => 'Роли <-> Пользователи',
        'Roles <-> Groups' => 'Роли <-> Группы',
        'Salutations' => 'Приветствия',
        'Signatures' => 'Подписи',
        'Email Addresses' => 'Адреса email',
        'Notifications' => 'Уведомления',
        'Category Tree' => 'Иерархия категорий',
        'Admin Notification' => 'Уведомление администратором',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Настройки успешно обновлены',
        'Mail Management' => 'Управление почтой',
        'Frontend' => 'Режим пользователя',
        'Other Options' => 'Другие настройки',
        'Change Password' => 'Сменить пароль',
        'New password' => 'Новый пароль',
        'New password again' => 'Повторите новый пароль',
        'Select your QueueView refresh time.' => 'Время обновления монитора очередей',
        'Select your frontend language.' => 'Язык интерфейса',
        'Select your frontend Charset.' => 'Кодировка',
        'Select your frontend Theme.' => 'Тема интерфейса',
        'Select your frontend QueueView.' => 'Язык монитора очередей.',
        'Spelling Dictionary' => 'Словарь',
        'Select your default spelling dictionary.' => 'Основной словарь',
        'Max. shown Tickets a page in Overview.' => 'Максимальное количество заявок при показе очереди',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Невозможно сменить пароль, пароли не совпадают!',
        'Can\'t update password, invalid characters!' => 'Невозможно сменить пароль, неверная кодировка!',
        'Can\'t update password, must be at least %s characters!' => 'Невозможно сменить пароль, пароль должен быть не менее %s символов!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Невозможно сменить пароль, необходимо 2 символа в нижнем и 2 — в верхнем регистрах!',
        'Can\'t update password, needs at least 1 digit!' => 'Невозможно сменить пароль, должна присутствовать как минимум 1 цифра!',
        'Can\'t update password, needs at least 2 characters!' => 'Невозможно сменить пароль, необходимо минимум 2 символа!',

        # Template: AAAStats
        'Stat' => 'Статистика',
        'Please fill out the required fields!' => 'Заполните обязательные поля!',
        'Please select a file!' => 'Выберите файл!',
        'Please select an object!' => 'Выберите объект!',
        'Please select a graph size!' => 'Выберите размер графика!',
        'Please select one element for the X-axis!' => 'Выберите один элемент для оси X',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Выберите только один элемент или снимите флаг \'Fixed\' у выбранного поля!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Если вы используете флажки выделения, то должны выбрать несколько пунктов из выбранного поля!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Вставьте значение в выбранное поле или снимите флаг «Fixed»!',
        'The selected end time is before the start time!' => 'Указанное время окончания раньше времени начала!',
        'You have to select one or more attributes from the select field!' => 'Вы должны выбрать один или несколько пунктов из выбранного поля',
        'The selected Date isn\'t valid!' => 'Выбранная дата неверна!',
        'Please select only one or two elements via the checkbox!' => 'Выберите только один или два пункта, используя флажки',
        'If you use a time scale element you can only select one element!' => 'Если вы используете элемент периода, вы можете выбрать только один пункт!',
        'You have an error in your time selection!' => 'Ошибка указания времени',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Период отчетности слишком мал, укажите больший интервал',
        'The selected start time is before the allowed start time!' => 'Выбранное время начала выходит за пределы разрешенного!',
        'The selected end time is after the allowed end time!' => 'Выбранное время конца выходит за пределы разрешенного!',
        'The selected time period is larger than the allowed time period!' => 'Выбранный период времени больше, чем разрешенный период!',
        'Common Specification' => 'Общая спецификация',
        'Xaxis' => 'Ось X',
        'Value Series' => 'Ряд значений',
        'Restrictions' => 'Ограничения',
        'graph-lines' => 'График',
        'graph-bars' => 'Гистограмма',
        'graph-hbars' => 'Линейчатая',
        'graph-points' => 'Точечная',
        'graph-lines-points' => 'График с точечной диаграммой',
        'graph-area' => 'С областями',
        'graph-pie' => 'Круговая',
        'extended' => 'Другая',
        'Agent/Owner' => 'Агент (владелец)',
        'Created by Agent/Owner' => 'Создано агентом (владельцем)',
        'Created Priority' => 'Приоритет',
        'Created State' => 'Состояние',
        'Create Time' => 'Время создания',
        'CustomerUserLogin' => 'Логин клиента',
        'Close Time' => 'Время закрытия',
        'TicketAccumulation' => 'Группировка заявок',
        'Attributes to be printed' => 'Атрибуты для печати',
        'Sort sequence' => 'Порядок сортировки',
        'Order by' => 'Сортировка',
        'Limit' => 'Лимит',
        'Ticketlist' => 'Список заявок',
        'ascending' => 'По возрастанию',
        'descending' => 'По убыванию',
        'First Lock' => 'Первая блокировка',
        'Evaluation by' => 'Заблокировано',
        'Total Time' => 'Всего времени',
        'Ticket Average' => 'Среднее время рассмотрения заявки',
        'Ticket Min Time' => 'Мин. время рассмотрения заявки',
        'Ticket Max Time' => 'Макс. время рассмотрения заявки',
        'Number of Tickets' => 'Количество заявок',
        'Article Average' => 'Среднее время между сообщениями',
        'Article Min Time' => 'Мин. время между сообщениями',
        'Article Max Time' => 'Макс. время между сообщениями',
        'Number of Articles' => 'Количество сообщений',
        'Accounted time by Agent' => 'Затраты рабочего времени по агентам',
        'Ticket/Article Accounted Time' => 'Затраты рабочего времени на заявку или сообщение',
        'TicketAccountedTime' => 'Затраты рабочего времени',
        'Ticket Create Time' => 'Время создания заявки',
        'Ticket Close Time' => 'Время закрытия заявки',

        # Template: AAATicket
        'Lock' => 'Блокировать',
        'Unlock' => 'Разблокировать',
        'History' => 'История',
        'Zoom' => 'Подробно',
        'Age' => 'Возраст',
        'Bounce' => 'Возвратить',
        'Forward' => 'Переслать',
        'From' => 'Отправитель',
        'To' => 'Получатель',
        'Cc' => 'Копия',
        'Bcc' => 'Скрытая копия',
        'Subject' => 'Тема',
        'Move' => 'Переместить',
        'Queue' => 'Очередь',
        'Priority' => 'Приоритет',
        'Priority Update' => 'Изменение приоритета',
        'State' => 'Статус',
        'Compose' => 'Создать',
        'Pending' => 'Отложить',
        'Owner' => 'Владелец',
        'Owner Update' => 'Новый владелец',
        'Responsible' => 'Ответственный',
        'Responsible Update' => 'Новый ответственный',
        'Sender' => 'Отправитель',
        'Article' => 'Сообщение',
        'Ticket' => 'Заявка',
        'Createtime' => 'Время создания',
        'plain' => 'Обычный',
        'Email' => 'Email',
        'email' => 'Email',
        'Close' => 'Закрыть',
        'Action' => 'Действие',
        'Attachment' => 'Прикрепленный файл',
        'Attachments' => 'Прикрепленные файлы',
        'This message was written in a character set other than your own.' => 'Это сообщение написано в кодировке. отличной от вашей.',
        'If it is not displayed correctly,' => 'Если текст отображается некорректно,',
        'This is a' => 'Это',
        'to open it in a new window.' => 'открыть в новом окне',
        'This is a HTML email. Click here to show it.' => 'Этот электронное письмо в формате HTML. Нажмите здесь для просмотра',
        'Free Fields' => 'Свободное поле',
        'Merge' => 'Объединить',
        'merged' => 'объединенный',
        'closed successful' => 'Закрыт успешно',
        'closed unsuccessful' => 'Закрыт неуспешно',
        'new' => 'новый',
        'open' => 'открытый',
        'Open' => 'Открыть',
        'closed' => 'закрытый',
        'Closed' => 'Закрытый',
        'removed' => 'удаленный',
        'pending reminder' => 'отложенное напоминание',
        'pending auto' => 'очередь на автозакрытие',
        'pending auto close+' => 'очередь на автозакрытие+',
        'pending auto close-' => 'очередь на автозакрытие-',
        'email-external' => 'внешний email',
        'email-internal' => 'внутренний email',
        'note-external' => 'внешняя заметка',
        'note-internal' => 'внутренняя заметка',
        'note-report' => 'Заметка-отчет',
        'phone' => 'звонок',
        'sms' => 'СМС',
        'webrequest' => 'веб-заявка',
        'lock' => 'блокирован',
        'unlock' => 'разблокирован',
        'very low' => 'самый низкий',
        'low' => 'низкий',
        'normal' => 'обычный',
        'high' => 'высокий',
        'very high' => 'безотлагательный',
        '1 very low' => '1 самый низкий',
        '2 low' => '2 низкий',
        '3 normal' => '3 обычный',
        '4 high' => '4 высокий',
        '5 very high' => '5 безотлагательный',
        'Ticket "%s" created!' => 'Создана заявка «%s».',
        'Ticket Number' => 'Номер заявки',
        'Ticket Object' => 'Объект заявки',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Заявки с номером «%s» не существует, невозможно связать с нею!',
        'Don\'t show closed Tickets' => 'Не показывать закрытые заявки',
        'Show closed Tickets' => 'Показывать закрытые заявки',
        'New Article' => 'Новое сообщение',
        'Email-Ticket' => 'Письмо',
        'Create new Email Ticket' => 'Создать новую заявку',
        'Phone-Ticket' => 'Телефонный звонок',
        'Search Tickets' => 'Поиск заявок',
        'Edit Customer Users' => 'Редактировать клиентов',
        'Edit Customer Company' => 'Редактировать компании клиентов',
        'Bulk Action' => 'Массовое действие',
        'Bulk Actions on Tickets' => 'Массовое действие над заявками',
        'Send Email and create a new Ticket' => 'Отправить письмо и создать новую заявку',
        'Create new Email Ticket and send this out (Outbound)' => 'Создать новую заявку email и отправить ее',
        'Create new Phone Ticket (Inbound)' => 'Создать новую телефонную заявку',
        'Overview of all open Tickets' => 'Обзор всех заявок',
        'Locked Tickets' => 'Заблокированные заявки',
        'Watched Tickets' => 'Отслеживаемые заявки',
        'Watched' => 'Отслеживаемые',
        'Subscribe' => 'Подписаться',
        'Unsubscribe' => 'Отписаться',
        'Lock it to work on it!' => 'Заблокировать, чтобы рассмотреть заявки!',
        'Unlock to give it back to the queue!' => 'Разблокировать и вернуть в очередь!',
        'Shows the ticket history!' => 'Показать историю заявки!',
        'Print this ticket!' => 'Печать заявки!',
        'Change the ticket priority!' => 'Изменить приоритет!',
        'Change the ticket free fields!' => 'Изменить свободные поля заявки!',
        'Link this ticket to an other objects!' => 'Связать заявку с другими объектами!',
        'Change the ticket owner!' => 'Изменить владельца!',
        'Change the ticket customer!' => 'Изменить клиента!',
        'Add a note to this ticket!' => 'Добавить заметку к заявке!',
        'Merge this ticket!' => 'Объединить заявку',
        'Set this ticket to pending!' => 'Поставить эту заявку в режим ожидания!',
        'Close this ticket!' => 'Закрыть заявку!',
        'Look into a ticket!' => 'Просмотреть заявку!',
        'Delete this ticket!' => 'Удалить заявку!',
        'Mark as Spam!' => 'Пометить как спам!',
        'My Queues' => 'Мои очереди',
        'Shown Tickets' => 'Показываемые заявки',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Ваш email с номером заявки «<OTRS_TICKET>» объединен с "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Заявка %s: время первого ответа истекло (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Заявка %s: время первого ответа истечет через %s!',
        'Ticket %s: update time is over (%s)!' => 'Заявка %s: время обновления заявки истекло (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Заявка %s: время обновления заявки истечет через %s!',
        'Ticket %s: solution time is over (%s)!' => 'Заявка %s: время решения заявки истекло (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Заявка %s: время решения заявки истечет через %s!',
        'There are more escalated tickets!' => 'Эскалированных заявок больше нет!',
        'New ticket notification' => 'Уведомление о новой заявке',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Уведомление о новых заявках',
        'Follow up notification' => 'Уведомление об обновлениях',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Прислать мне уведомление, если клиент прислал ответ и я владелец заявки.',
        'Ticket lock timeout notification' => 'Уведомление об истечении срока блокировки заявки системой',
        'Send me a notification if a ticket is unlocked by the system.' => 'Прислать мне уведомление, если заявка освобождена системой.',
        'Move notification' => 'Уведомление о перемещении',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Прислать мне уведомление, если заявка перемещена в одну из моих очередей.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Выбор очередей, которые вас интересуют. Вы также будете уведомляться по электронной почте, если эта функция включена.',
        'Custom Queue' => 'Резервная очередь',
        'QueueView refresh time' => 'Время обновления монитора очередей',
        'Screen after new ticket' => 'Раздел после создания новой заявки',
        'Select your screen after creating a new ticket.' => 'Выберите раздел после создания новой заявки',
        'Closed Tickets' => 'Закрытые заявки',
        'Show closed tickets.' => 'Показывать закрытые заявки',
        'Max. shown Tickets a page in QueueView.' => 'Максимальное количество заявок при просмотре очереди',
        'Watch notification' => 'Уведомление при отслеживании',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Прислать мне и владельцу уведомление, если обновлена отслеживаемая заявка.',
        'Out Of Office' => 'Уведомление об отсутствии',
        'Select your out of office time.' => 'Укажите период отсутствия',
        'CompanyTickets' => 'Заявки компании',
        'MyTickets' => 'Мои заявки',
        'New Ticket' => 'Новая заявка',
        'Create new Ticket' => 'Создать новую заявку',
        'Customer called' => 'Звонок клиента',
        'phone call' => 'телефонный звонок',
        'Reminder Reached' => 'Напоминание',
        'Reminder Tickets' => 'Заявки с напоминанием',
        'Escalated Tickets' => 'Эскалированные заявки',
        'New Tickets' => 'Новые заявки',
        'Open Tickets / Need to be answered' => 'Открытые заявки (требуется ответить)',
        'Tickets which need to be answered!' => 'Заявки, требующие ответа',
        'All new tickets!' => 'Все новые заявки',
        'All tickets which are escalated!' => 'Все эскалированные заявки',
        'All tickets where the reminder date has reached!' => 'Все заявки с наступившей датой напоминания',
        'Responses' => 'Ответы',
        'Responses <-> Queue' => 'Ответы <-> Очередь',
        'Auto Responses' => 'Автоответы',
        'Auto Responses <-> Queue' => 'Автоответы <-> Очередь',
        'Attachments <-> Responses' => 'Прикрепленные файлы <-> Ответы',
        'History::Move' => 'Заявка перемещена в очередь «%s» (%s) из очереди «%s» (%s).',
        'History::TypeUpdate' => 'Тип изменен на %s (ID=%s).',
        'History::ServiceUpdate' => 'Сервис изменен на %s (ID=%s).',
        'History::SLAUpdate' => 'SLA изменен на %s (ID=%s).',
        'History::NewTicket' => 'Новая заявка [%s] (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Ответ на [%s]. %s',
        'History::SendAutoReject' => 'Автоотказ отправлен «%s».',
        'History::SendAutoReply' => 'Автоответ отправлен «%s».',
        'History::SendAutoFollowUp' => 'Автоответ отправлен «%s».',
        'History::Forward' => 'Перенаправлено «%s».',
        'History::Bounce' => 'Возвращено «%s».',
        'History::SendAnswer' => 'Ответ оправлен «%s».',
        'History::SendAgentNotification' => '%s: уведомление отправлено на %s.',
        'History::SendCustomerNotification' => 'Уведомление отправлено на %s.',
        'History::EmailAgent' => 'Клиенту %s отправлено письмо.',
        'History::EmailCustomer' => 'Получено письмо от %s.',
        'History::PhoneCallAgent' => 'Сотрудник позвонил клиенту',
        'History::PhoneCallCustomer' => 'Клиент позвонил нам.',
        'History::AddNote' => 'Добавлена заметка (%s)',
        'History::Lock' => 'Заблокирована заявка.',
        'History::Unlock' => 'Разблокирована заявка.',
        'History::TimeAccounting' => 'Добавлено единиц времени: %s. Всего единиц времени: %s.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Изменено: %s',
        'History::PriorityUpdate' => 'Изменен приоритет с «%s» (%s) на «%s» (%s).',
        'History::OwnerUpdate' => 'Новый владелец «%s» (ID=%s).',
        'History::LoopProtection' => 'Защита от зацикливания! Авто-ответ на «%s» не отправлен.',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Обновлено: %s',
        'History::StateUpdate' => 'Прежнее состояние: %s, новое состояние: %s',
        'History::TicketFreeTextUpdate' => 'Обновлено: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Веб-запрос пользователя.',
        'History::TicketLinkAdd' => 'К заявке «%s» добавлена связь.',
        'History::TicketLinkDelete' => 'Связь с заявкой «%s» удалена.',
        'History::Subscribe' => 'Добавлена подписка для пользователя «%s».',
        'History::Unsubscribe' => 'Удалена подписка для пользователя «%s».',

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
        'To get the first 20 character of the subject.' => 'Чтобы видеть первые 20 символов темы',
        'To get the first 5 lines of the email.' => 'Чтобы видеть первые 5 строк email',
        'To get the realname of the sender (if given).' => 'Чтобы видеть реальное имя отправителя (если указано)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Данные сообщения (например, <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> и <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Текущие данные о клиенте (например, <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Данные владельца заявки (например, <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Данные ответственного за заявку (например, <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Данные текущего пользователя, который запросил это действие (например, <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Данные заявки (например, <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Параметры конфигурации (например, <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Управление компаниями клиентов',
        'Search for' => 'Поиск',
        'Add Customer Company' => 'Добавить компанию клиента',
        'Add a new Customer Company.' => 'Добавить компанию клиента',
        'List' => 'Список',
        'This values are required.' => 'Данное поле обязательно',
        'This values are read only.' => 'Данное поле только для чтения',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'Создаваемое сообщение было закрыто. выход.',
        'This window must be called from compose window' => 'Это окно должно вызываться из окна ввода',
        'Customer User Management' => 'Управление пользователями (для клиентов)',
        'Add Customer User' => 'Добавить клиента',
        'Source' => 'Источник',
        'Create' => 'Создать',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Пользователь клиента понадобится, чтобы получать доступ к истории клиента и входить через пользовательский интерфейс',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Управление группами клиентов',
        'Change %s settings' => 'Изменить параметры: %s',
        'Select the user:group permissions.' => 'Доступ в виде пользователь:группа.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Если ничего не выбрано, то заявки будут недоступны для пользователя',
        'Permission' => 'Права доступа',
        'ro' => 'Только чтение',
        'Read only access to the ticket in this group/queue.' => 'Права только на чтение заявки в данной группе/очереди',
        'rw' => 'Чтение/запись',
        'Full read and write access to the tickets in this group/queue.' => 'Полные права на заявки в данной группе/очереди',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Клиенты <-> Сервисы',
        'CustomerUser' => 'Клиент',
        'Service' => 'Сервис',
        'Edit default services.' => 'Сервисы по умолчанию',
        'Search Result' => 'Результат поиска',
        'Allocate services to CustomerUser' => 'Привязать сервисы к клиенту',
        'Active' => 'Активный',
        'Allocate CustomerUser to service' => 'Привязать клиента к сервисам',

        # Template: AdminEmail
        'Message sent to' => 'Сообщение отправлено для',
        'A message should have a subject!' => 'Сообщение должно иметь поле темы!',
        'Recipients' => 'Получатели',
        'Body' => 'Тело письма',
        'Send' => 'Отправить',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Планировщик задач',
        'Job-List' => 'Список задач',
        'Last run' => 'Последний запуск',
        'Run Now!' => 'Выполнить сейчас!',
        'x' => 'x',
        'Save Job as?' => 'Сохранить задачу как?',
        'Is Job Valid?' => 'Данная задача действительна?',
        'Is Job Valid' => 'Данная задача действительна',
        'Schedule' => 'Расписание',
        'Currently this generic agent job will not run automatically.' => 'Это задание агента не запускается автоматически',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'Для автоматического запуска укажите как минимум одно из значений в минутах, часах или днях',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Полнотекстовый поиск в заявке (например, «Mar*in» или «Baue*»)',
        '(e. g. 10*5155 or 105658*)' => '(например, 10*5155 или 105658*)',
        '(e. g. 234321)' => '(например, 234321)',
        'Customer User Login' => 'Логин клиента',
        '(e. g. U5150)' => '(например, U5150)',
        'SLA' => 'Уровень обслуживания',
        'Agent' => 'Агент',
        'Ticket Lock' => 'Блокирование заявки',
        'TicketFreeFields' => 'Свободные поля заявки',
        'Create Times' => 'Время создания',
        'No create time settings.' => 'Без учета времени создания',
        'Ticket created' => 'Заявка создана',
        'Ticket created between' => 'Заявка создана между ',
        'Close Times' => 'Время закрытия',
        'No close time settings.' => 'Без учета времени закрытия',
        'Ticket closed' => 'Заявка закрыта',
        'Ticket closed between' => 'Заявка закрыта между',
        'Pending Times' => 'Время, когда запрос был отложен',
        'No pending time settings.' => 'Без учета времени, когда запрос был отложен',
        'Ticket pending time reached' => 'Заявка была отложена',
        'Ticket pending time reached between' => 'Заявка была отложена между',
        'Escalation Times' => 'Время эскалации',
        'No escalation time settings.' => 'Без учета времени эскалации',
        'Ticket escalation time reached' => 'Заявка была эскалирована',
        'Ticket escalation time reached between' => 'Заявка была эскалирована между',
        'Escalation - First Response Time' => 'Эскалация — время первого ответа',
        'Ticket first response time reached' => 'Первый ответ',
        'Ticket first response time reached between' => 'Первый ответ между',
        'Escalation - Update Time' => 'Эскалация — время обновления',
        'Ticket update time reached' => 'Заявка была обновлена',
        'Ticket update time reached between' => 'Заявка была обновлена между',
        'Escalation - Solution Time' => 'Эскалация — время решения',
        'Ticket solution time reached' => 'Заявка была решена',
        'Ticket solution time reached between' => 'Заявка была решена между',
        'New Service' => 'Новая служба',
        'New SLA' => 'Новый SLA',
        'New Priority' => 'Новый приоритет',
        'New Queue' => 'Новая очередь',
        'New State' => 'Новый статус',
        'New Agent' => 'Новый агент',
        'New Owner' => 'Новый владелец',
        'New Customer' => 'Новый клиент',
        'New Ticket Lock' => 'Новый статус заявки',
        'New Type' => 'Новый тип',
        'New Title' => 'Новое название',
        'New TicketFreeFields' => 'Новые свободные поля заявки',
        'Add Note' => 'Добавить заметку',
        'Time units' => 'Единицы времени',
        'CMD' => 'Команда',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Эта команда будет выполнена. ARG[0] — номер заявки. ARG[1] — id заявки.',
        'Delete tickets' => 'Удалить заявки',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Внимание! Указанные заявки будут удалены из базы!',
        'Send Notification' => 'Отправлять уведомление',
        'Param 1' => 'Параметр 1',
        'Param 2' => 'Параметр 2',
        'Param 3' => 'Параметр 3',
        'Param 4' => 'Параметр 4',
        'Param 5' => 'Параметр 5',
        'Param 6' => 'Параметр 6',
        'Send agent/customer notifications on changes' => 'Отправлять уведомление агенту при изменениях',
        'Save' => 'Сохранить',
        '%s Tickets affected! Do you really want to use this job?' => '%s заявок будет изменено! Выполнить это задание?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'ВНИМАНИЕ! Если вы измените имя группы «admin» до того, как поменяете название этой группы конфигурации системы, у вас не будет прав доступа на панель администрирования. Если это произошло, верните прежнее название группы (admin) вручную командой SQL.',
        'Group Management' => 'Управление группами',
        'Add Group' => 'Добавить группу',
        'Add a new Group.' => 'Добавить новую группу',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Группа admin может осуществлять администрирование, а группа stats — просматривать статистику',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Создать новые группы для назначения прав доступа группам агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
        'It\'s useful for ASP solutions.' => 'Это подходит для провайдеров.',

        # Template: AdminLog
        'System Log' => 'Системный журнал',
        'Time' => 'Время',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Управление почтовыми учетными записями',
        'Host' => 'Сервер',
        'Trusted' => 'Безопасная',
        'Dispatching' => 'Перенаправление',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Все входящие письма с указанной учетной записи будут перенесены в выбранную очередь!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Если ваша учётная запись безопасная, в письмах будет использовано поле заголовка X-OTRS (для приоритета и прочих данных)! Фильтр PostMaster будет использован в любом случае.',

        # Template: AdminNavigationBar
        'Users' => 'Пользователи',
        'Groups' => 'Группы',
        'Misc' => 'Дополнительно',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Управления уведомлениями',
        'Add Notification' => 'Добавить уведомление',
        'Add a new Notification.' => 'Добавить уведомление',
        'Name is required!' => 'Название обязательно!',
        'Event is required!' => 'Событие обязательно!',
        'A message should have a body!' => 'Тело письма не может быть пустым!',
        'Recipient' => 'Получатель',
        'Group based' => 'Группа',
        'Agent based' => 'Агент',
        'Email based' => 'Адрес электронной почты',
        'Article Type' => 'Тип сообщения',
        'Only for ArticleCreate Event.' => 'Только при создании сообщений',
        'Subject match' => 'Соответствие теме',
        'Body match' => 'Соответствие телу письма',
        'Notifications are sent to an agent or a customer.' => 'Уведомления отправлены агенту или клиенту',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Первые 20 символов темы из последнего сообщения агента',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Первые 5 строк последнего сообщения агента',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Поля сообщения (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>)',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Первые 20 символов темы из последнего сообщения клиента',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Первые 5 строк последнего сообщения клиента',

        # Template: AdminNotificationForm
        'Notification' => 'Уведомление',

        # Template: AdminPackageManager
        'Package Manager' => 'Управление пакетами',
        'Uninstall' => 'Удалить',
        'Version' => 'Версия',
        'Do you really want to uninstall this package?' => 'Удалить этот пакет?',
        'Reinstall' => 'Переустановить',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Переустановить этот пакет (все изменения, сделанные вручную, будут утеряны)?',
        'Continue' => 'Продолжить',
        'Install' => 'Установить',
        'Package' => 'Пакет',
        'Online Repository' => 'Онлайновый репозиторий',
        'Vendor' => 'Изготовитель',
        'Module documentation' => 'Документация модуля',
        'Upgrade' => 'Обновить',
        'Local Repository' => 'Локальный репозиторий',
        'Status' => 'Статус',
        'Overview' => 'Обзор',
        'Download' => 'Загрузить',
        'Rebuild' => 'Перестроить',
        'ChangeLog' => 'Журнал изменений',
        'Date' => 'Дата',
        'Filelist' => 'Список файлов',
        'Download file from package!' => 'Загрузить файл из пакета!',
        'Required' => 'Требуется',
        'PrimaryKey' => 'Первичный ключ',
        'AutoIncrement' => 'Автоинкремент',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Журнал производительности',
        'This feature is enabled!' => 'Данная функция активирована!',
        'Just use this feature if you want to log each request.' => 'Используйте эту функцию, если хотите заносить каждый запрос в журнал',
        'Activating this feature might affect your system performance!' => 'Включение этой функции может сказаться на производительности вашей системы',
        'Disable it here!' => 'Отключить функцию!',
        'This feature is disabled!' => 'Данная функция отключена!',
        'Enable it here!' => 'Включить функцию!',
        'Logfile too large!' => 'Файл журнала слишком большой!',
        'Logfile too large, you need to reset it!' => 'Файл журнала слишком большой, вам нужно очистить его!',
        'Range' => 'Диапазон',
        'Interface' => 'Интерфейс',
        'Requests' => 'Запросов',
        'Min Response' => 'Минимальное время ответа',
        'Max Response' => 'Максимальное время ответа',
        'Average Response' => 'Среднее время ответа',
        'Period' => 'Период',
        'Min' => 'Мин',
        'Max' => 'Макс',
        'Average' => 'Среднее',

        # Template: AdminPGPForm
        'PGP Management' => 'Управление подписями PGP',
        'Result' => 'Результат',
        'Identifier' => 'Идентификатор',
        'Bit' => 'Бит',
        'Key' => 'Ключ',
        'Fingerprint' => 'Цифровой отпечаток',
        'Expires' => 'Истекает',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'В данном случае вы можете изменить ключи прямо в конфигурации системы',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Управление фильтром PostMaster',
        'Filtername' => 'Имя фильтра',
        'Stop after match' => 'Прекратить проверку после совпадения',
        'Match' => 'Соответствует',
        'Value' => 'Значение',
        'Set' => 'Установить',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Обрабатывать или отфильтровывать входящие письма на основе полей заголовка! Возможно использование регулярных выражений.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Если вы хотите отфильтровать только по адресам электронной почты, используйте EMAILADDRESS:info@example.com в полях From, To или Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Если вы используете регулярные выражения, вы можете использовать переменные в () как [***] при установке значений',

        # Template: AdminPriority
        'Priority Management' => 'Управление приоритетами',
        'Add Priority' => 'Создать приоритет',
        'Add a new Priority.' => 'Создать приоритет.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Автоответы в очереди',
        'settings' => 'параметры',

        # Template: AdminQueueForm
        'Queue Management' => 'Управление очередью',
        'Sub-Queue of' => 'Подочередь в',
        'Unlock timeout' => 'Срок блокировки',
        '0 = no unlock' => '0 — без блокировки',
        'Only business hours are counted.' => 'С учетом только рабочего времени.',
        '0 = no escalation' => '0 — без эскалации',
        'Notify by' => 'Уведомление от',
        'Follow up Option' => 'Параметры автоответа',
        'Ticket lock after a follow up' => 'Блокировать заявку после получения ответа',
        'Systemaddress' => 'Системный адрес',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Если агент заблокировал заявку и не отправил ответ клиенту в течение установленного времени, то заявка автоматически разблокируется и станет доступной для остальных агентов.',
        'Escalation time' => 'Время до эскалации заявки',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Если заявка не будет обслужена в установленное время, показывать только эту заявку',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Если заявка закрыта, а клиент прислал сообщение, то заявка будет заблокирована для предыдущего владельца',
        'Will be the sender address of this queue for email answers.' => 'Установка адреса отправителя для ответов в этой очереди.',
        'The salutation for email answers.' => 'Приветствие для писем',
        'The signature for email answers.' => 'Подпись для писем',
        'Customer Move Notify' => 'Извещать клиента о перемещении',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'При перемещении заявки будет отправлено уведомление клиенту.',
        'Customer State Notify' => 'Извещать клиента об изменении статуса',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'При изменении статуса заявки будет отправлено уведомление клиенту.',
        'Customer Owner Notify' => 'Извещать клиента о смене владельца',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'При смене владельца заявки будет отправлено уведомление клиенту.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Управление ответами в очередях',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Ответ',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Управление приложенными файлами в ответах',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Управление ответами',
        'A response is default text to write faster answer (with default text) to customers.' => 'Ответ — шаблон ответа клиенту',
        'Don\'t forget to add a new response a queue!' => 'Не забудьте добавить ответ для очереди!',
        'The current ticket state is' => 'Текущее состояние заявки',
        'Your email address is new' => 'Ваш адрес электронной почты новый',

        # Template: AdminRoleForm
        'Role Management' => 'Управление ролями',
        'Add Role' => 'Добавить роль',
        'Add a new Role.' => 'Добавить роль',
        'Create a role and put groups in it. Then add the role to the users.' => 'Создайте роль и добавьте в неё группы. Затем распределите роли по пользователям.',
        'It\'s useful for a lot of users and groups.' => 'Это полезно при использовании множества пользователей и групп',

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
        'Select the role:user relations.' => 'Выберите связь между ролью и пользователем',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Управление приветствиями',
        'Add Salutation' => 'Добавить приветствие',
        'Add a new Salutation.' => 'Добавить приветствие',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Безопасный режим должен быть включен',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'После установки системы обычно сразу же включают безопасный режим.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Безопасный режим должен быть отключен при переустановке через веб-интерфейс',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Если безопасный режим не включен, включите его в конфигурации системы',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'Запрос SQL',
        'CSV' => '',
        'HTML' => '',
        'Select Box Result' => 'Выберите из меню',

        # Template: AdminService
        'Service Management' => 'Управление сервисами',
        'Add Service' => 'Добавить сервис',
        'Add a new Service.' => 'Добавить сервис',
        'Sub-Service of' => 'Дополнительная сервис для',

        # Template: AdminSession
        'Session Management' => 'Управление сеансами',
        'Sessions' => 'Сеансы',
        'Uniq' => 'Уникальный',
        'Kill all sessions' => 'Завершить все сеансы',
        'Session' => 'Сеанс',
        'Content' => 'Содержание',
        'kill session' => 'Завершить сеанс',

        # Template: AdminSignatureForm
        'Signature Management' => 'Управление подписями',
        'Add Signature' => 'Добавить подпись',
        'Add a new Signature.' => 'Добавить подпись',

        # Template: AdminSLA
        'SLA Management' => 'Управление SLA',
        'Add SLA' => 'Добавить SLA',
        'Add a new SLA.' => 'Добавить SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Управление S/MIME',
        'Add Certificate' => 'Добавить сертификат',
        'Add Private Key' => 'Добавить закрытый ключ',
        'Secret' => 'Пароль',
        'Hash' => 'Хеш',
        'In this way you can directly edit the certification and private keys in file system.' => 'Вы можете редактировать сертификаты и закрытые ключи прямо на файловой системе',

        # Template: AdminStateForm
        'State Management' => 'Управление статусами',
        'Add State' => 'Добавить статус',
        'Add a new State.' => 'Добавить статус',
        'State Type' => 'Тип статуса',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Исправьте статусы по умолчанию также и в файле Kernel/Config.pm!',
        'See also' => 'См. также',

        # Template: AdminSysConfig
        'SysConfig' => 'Конфигурация системы',
        'Group selection' => 'Выбор группы',
        'Show' => 'Показать',
        'Download Settings' => 'Загрузить параметры',
        'Download all system config changes.' => 'Загрузить все изменения конфигурации, внесенные в систему',
        'Load Settings' => 'Применить конфигурацию из файла',
        'Subgroup' => 'Подгруппа',
        'Elements' => 'Элементы',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Параметры конфигурации',
        'Default' => 'По умолчанию',
        'New' => 'Новый',
        'New Group' => 'Новая группа',
        'Group Ro' => 'Группа только для чтения',
        'New Group Ro' => 'Новая группа только для чтения',
        'NavBarName' => 'Имя в меню',
        'NavBar' => 'Меню',
        'Image' => 'Значок',
        'Prio' => 'Приоритет',
        'Block' => 'Раздел',
        'AccessKey' => 'Клавиша доступа',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Управление системными адресами электронной почты',
        'Add System Address' => 'Добавить системный адрес',
        'Add a new System Address.' => 'Добавить системный адрес',
        'Realname' => 'Имя',
        'All email addresses get excluded on replaying on composing an email.' => 'Все адреса, исключаемые при ответе на письмо',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Все входящие сообщения с этим получателем будут направлены в заданную очередь',

        # Template: AdminTypeForm
        'Type Management' => 'Управление типами заявок',
        'Add Type' => 'Добавить тип',
        'Add a new Type.' => 'Добавить тип',

        # Template: AdminUserForm
        'User Management' => 'Управление пользователями',
        'Add User' => 'Добавить пользователя',
        'Add a new Agent.' => 'Добавить пользователя',
        'Login as' => 'Зайти данным пользователем',
        'Firstname' => 'Имя',
        'Lastname' => 'Фамилия',
        'Start' => 'Начало',
        'End' => 'Окончание',
        'User will be needed to handle tickets.' => 'Для обработки заявок нужно зайти пользователем.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Не забудьте добавить нового пользователя в группы и роли!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Управление группами пользователей',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Адресная книга',
        'Return to the compose screen' => 'Вернуться в окно составления письма',
        'Discard all changes and return to the compose screen' => 'Отказаться от всех изменений и вернуться в окно составления письма',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Дайджест',

        # Template: AgentDashboardCalendarOverview
        'in' => 'в',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s доступен',
        'Please update now.' => 'Обновите сейчас',
        'Release Note' => 'Примечание к релизу',
        'Level' => 'Уровень',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Опубликовано %s',

        # Template: AgentDashboardTicketGeneric

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline

        # Template: AgentInfo
        'Info' => 'Информация',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Связать объект: %s',
        'Object' => 'Объект',
        'Link Object' => 'Связать объект',
        'with' => 'с',
        'Select' => 'Выбор',
        'Unlink Object: %s' => 'Отменить привязку объекта: %s',

        # Template: AgentLookup
        'Lookup' => 'Поиск',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Проверка орфографии',
        'spelling error(s)' => 'Орфографические ошибки',
        'or' => 'или',
        'Apply these changes' => 'Применить изменения',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Удалить этот объект?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Выберите ограничения для определения статистики',
        'Fixed' => 'Фиксировано',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Выберите только один пункт или уберите флажок «Фиксировано».',
        'Absolut Period' => 'Точный период',
        'Between' => 'Между',
        'Relative Period' => 'Относительный период',
        'The last' => 'Последний',
        'Finish' => 'Закончить',
        'Here you can make restrictions to your stat.' => 'Здесь вы можете внести ограничения в вашу статистику',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Если вы снимите флажок параметра «Фиксировано», пользователь, который будет создавать отчеты, сможет менять параметры соответствующего элемента',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Вставьте дополнительные требования',
        'Permissions' => 'Права',
        'Format' => 'Формат',
        'Graphsize' => 'Размер графика',
        'Sum rows' => 'Сумма строк',
        'Sum columns' => 'Сумма столбцов',
        'Cache' => 'Кеш',
        'Required Field' => 'Обязательное поле',
        'Selection needed' => 'Необходимо выделение',
        'Explanation' => 'Пояснение',
        'In this form you can select the basic specifications.' => 'В данной форме вы можете выбрать основные требования.',
        'Attribute' => 'Атрибут',
        'Title of the stat.' => 'Название отчета',
        'Here you can insert a description of the stat.' => 'Здесь вы можете написать описание отчета',
        'Dynamic-Object' => 'Динамический объект',
        'Here you can select the dynamic object you want to use.' => 'Здесь вы можете выбрать динамический объект, который вы хотите использовать',
        '(Note: It depends on your installation how many dynamic objects you can use)' => 'Замечание: количество динамических объектов зависит от системы.',
        'Static-File' => 'Статический файл',
        'For very complex stats it is possible to include a hardcoded file.' => 'Для очень сложных отчетов, возможно, необходимо использовать временный файл',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Если временный файл доступен, будет показан список, из которого вы можете выбрать файл.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Настройки прав доступа. Вы можете выбрать одну или несколько групп, чтобы отчет был видел для разных пользователей.',
        'Multiple selection of the output format.' => 'Выбор форматов вывода.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Если вы используете графики, вам необходимо выбрать хотя бы один размер графика.',
        'If you need the sum of every row select yes' => 'Если вам необходим показ суммы по каждой строке, выберите «Да»',
        'If you need the sum of every column select yes.' => 'Если вам необходим показ суммы по каждому столбцу, выберите «Да»',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Большинство отчетов могут кешироваться. Это увеличит скорость показа отчетов.',
        '(Note: Useful for big databases and low performance server)' => 'Примечание: полезно для больших баз данных или для серверов с низкой производительностью.',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'При статусе отчета «недействительный» отчет не может быть сформирован.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Это полезно использовать для скрытия отчета (например, он еще не до конца настроен).',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Выберите элементы для последовательности значений',
        'Scale' => 'Масштаб',
        'minimal' => 'Минимальный',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Помните, что масштаб для последовательности значений должен быть больше, чем масштаб для оси X (например, ось Х — месяц, последовательность значений — год).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Здесь вы можете определить последовательность значений. У вас есть возможность выбрать один или два элемента. Затем вы можете выбрать атрибуты элементов. Значения каждого атрибута будет показаны как отдельная последовательность значений. Если вы не выберите ни одного атрибута, в отчете будут использованы все доступные атрибуты.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Выберите элемент, который будет использован на оси Х',
        'maximal period' => 'максимальный период',
        'minimal scale' => 'минимальный масштаб',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Здесь вы можете определить значения для оси X. Выберите один элемент, используя переключатель. Если вы не выберите ни одного атрибута, в отчете будут использованы все доступные атрибуты.',

        # Template: AgentStatsImport
        'Import' => 'Импорт',
        'File is not a Stats config' => 'Файл не является файлом конфигурации отчетов',
        'No File selected' => 'Файл не выбран',

        # Template: AgentStatsOverview
        'Results' => 'Результат',
        'Total hits' => 'Найдено вхождений',
        'Page' => 'Страница',

        # Template: AgentStatsPrint
        'Print' => 'Печать',
        'No Element selected.' => 'Элемент не выбран.',

        # Template: AgentStatsView
        'Export Config' => 'Экспорт конфигурации',
        'Information about the Stat' => 'Информация об отчете',
        'Exchange Axis' => 'Поменять оси',
        'Configurable params of static stat' => 'Конфигурируемые параметры статического отчета',
        'No element selected.' => 'Элементы не выбраны',
        'maximal period from' => 'Максимальный период с',
        'to' => 'по',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Вводя данные и выбирая поля, вы можете настраивать отчет как вам необходимо. От администратора, создававшего данный отчет, зависит какие данные вы можете настраивать. ',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'В письме должен быть указан получатель!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Укажите адрес электронной почты в поле получателя (например, support@example.ru)!',
        'Bounce ticket' => 'Пересылка заявки',
        'Ticket locked!' => 'Заявка заблокирована!',
        'Ticket unlock!' => 'Заявка разблокирована!',
        'Bounce to' => 'Переслать для',
        'Next ticket state' => 'Следующее состояние заявки',
        'Inform sender' => 'Информировать отправителя',
        'Send mail!' => 'Оправить письмо!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Вам необходимо посчитать время!',
        'Ticket Bulk Action' => 'Массовое действие',
        'Spell Check' => 'Проверка орфографии',
        'Note type' => 'Тип заметки',
        'Next state' => 'Следующее состояние',
        'Pending date' => 'Дата ожидания',
        'Merge to' => 'Объединить с',
        'Merge to oldest' => 'Объединить с самым старым',
        'Link together' => 'Связать',
        'Link to Parent' => 'Связать с родительским объектом',
        'Unlock Tickets' => 'Разблокировать заявки',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Требуется указать тип!',
        'A required field is:' => 'Необходимое поле:',
        'Close ticket' => 'Закрыть заявку',
        'Previous Owner' => 'Предыдущий владелец',
        'Inform Agent' => 'Уведомить агента',
        'Optional' => 'Необязательно',
        'Inform involved Agents' => 'Уведомить участвующих агентов',
        'Attach' => 'Приложить файл',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Сообщение должно быть проверено на ошибки!',
        'Compose answer for ticket' => 'Создание ответ на заявку',
        'Pending Date' => 'Следующая дата',
        'for pending* states' => 'для последующих состояний* ',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Изменить клиента заявки',
        'Set customer user and customer id of a ticket' => 'Указать пользователя клиента и идентификатор пользователя заявки',
        'Customer User' => 'Пользователь клиента',
        'Search Customer' => 'Искать клиента',
        'Customer Data' => 'Учетные данные клиента',
        'Customer history' => 'История клиента',
        'All customer tickets.' => 'Все заявки клиента.',

        # Template: AgentTicketEmail
        'Compose Email' => 'Написать письмо',
        'new ticket' => 'Новая заявка',
        'Refresh' => 'Обновить',
        'Clear To' => 'Очистить',
        'All Agents' => 'Все агенты',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Тип сообщения',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Изменить свободный текст заявки',

        # Template: AgentTicketHistory
        'History of' => 'История',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Вам необходимо использовать номер заявки!',
        'Ticket Merge' => 'Объединение заявок',

        # Template: AgentTicketMove
        'Move Ticket' => 'Переместить заявку',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Добавить заметку к заявке',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Время до первого ответа',
        'Service Time' => 'Время обслуживания',
        'Update Time' => 'Время до изменения заявки',
        'Solution Time' => 'Время решения заявки',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Вам необходимо выбрать хотя бы одну заявку!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Фильтр',
        'Change search options' => 'Изменить параметры поиска',
        'Tickets' => 'Заявки',
        'of' => 'на',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Создать ответ',
        'Contact customer' => 'Связаться с клиентом',
        'Change queue' => 'Переместить в другую очередь',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'сортировка по возрастанию',
        'up' => 'вверх',
        'sort downward' => 'сортировка по убыванию',
        'down' => 'вниз',
        'Escalation in' => 'Эскалация через',
        'Locked' => 'Блокировка',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Изменить владельца заявки',

        # Template: AgentTicketPending
        'Set Pending' => 'Установка ожидания',

        # Template: AgentTicketPhone
        'Phone call' => 'Телефонный звонок',
        'Clear From' => 'Очистить форму',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Обычный',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Информация о заявке',
        'Accounted time' => 'Потраченное на заявку время',
        'Linked-Object' => 'Связанный объект',
        'by' => '',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Изменить приоритет заявки',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Показаны заявки',
        'Tickets available' => 'Доступные заявки',
        'All tickets' => 'Все заявки',
        'Queues' => 'Очереди',
        'Ticket escalation!' => 'Заявка эскалирована!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Сменить ответственного за заявку',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Поиск заявки',
        'Profile' => 'Параметры',
        'Search-Template' => 'Шаблон поиска',
        'TicketFreeText' => 'Свободные поля заявки',
        'Created in Queue' => 'Создана в очереди',
        'Article Create Times' => 'Время создания сообщения',
        'Article created' => 'Сообщение создано',
        'Article created between' => 'Сообщение создано в период',
        'Change Times' => 'Время изменений',
        'No change time settings.' => 'Не изменять параметры времени',
        'Ticket changed' => 'Заявка изменена',
        'Ticket changed between' => 'Заявка изменена в период',
        'Result Form' => 'Вывод результатов',
        'Save Search-Profile as Template?' => 'Сохранить параметры поиска в качестве шаблона?',
        'Yes, save it with name' => 'Да, сохранить с именем',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Полнотекстовый',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Подробно',
        'Collapse View' => 'Кратко',
        'Split' => 'Разделить',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Фильтр сообщений',
        'Save filter settings as default' => 'Сохранить условия фильтра для показа по умолчанию',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Отслеживание',

        # Template: CustomerFooter
        'Powered by' => 'Использует',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Вход',
        'Lost your password?' => 'Забыли свой пароль',
        'Request new password' => 'Прислать новый пароль',
        'Create Account' => 'Создать учетную запись',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Здравствуйте, %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Время',
        'No time settings.' => 'Без временных ограничений',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Отправить сообщение об ошибке!',

        # Template: Footer
        'Top of Page' => 'В начало страницы',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Главная страница',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Установка через веб-интерфейс',
        'Welcome to %s' => 'Добро пожаловать в %s',
        'Accept license' => 'Принять условия лицензии',
        'Don\'t accept license' => 'Не принимать условия лицензии',
        'Admin-User' => 'Администратор',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Если для администратора базы данных установлен пароль, укажите его здесь. Если нет, оставьте поле пустым. Из соображений безопасности мы рекомендуем создать пароль администратора. Информацию по этой теме можно найти в документации по используемой базе данных',
        'Admin-Password' => 'Пароль администратора',
        'Database-User' => 'Пользователь базы данных',
        'default \'hot\'' => 'По умолчанию: «hot»',
        'DB connect host' => 'Сервер базы данных',
        'Database' => 'Имя базы данных',
        'Default Charset' => 'Кодировка по умолчанию',
        'utf8' => 'utf8',
        'false' => 'нет',
        'SystemID' => 'Системный ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => 'Идентификатор системы. Каждый номер заявки и сеанс начинаться с этого числа)',
        'System FQDN' => 'Системное FQDN',
        '(Full qualified domain name of your system)' => 'Полное доменное имя (FQDN) вашей системы',
        'AdminEmail' => 'Адрес электронной почты администратора',
        '(Email of the system admin)' => 'Адрес электронной почты системного администратора',
        'Organization' => 'Организация',
        'Log' => 'Журнал',
        'LogModule' => 'Модуль журнала ',
        '(Used log backend)' => 'Используемый модуль журнала',
        'Logfile' => 'Файл журнала',
        '(Logfile just needed for File-LogModule!)' => 'Файл журнала необходим только для модуля журнала!',
        'Webfrontend' => 'Веб-интерфейс',
        'Use utf-8 it your database supports it!' => 'Используйте utf-8, если ваша база данных поддерживает эту кодировку!',
        'Default Language' => 'Язык по умолчанию',
        '(Used default language)' => 'Используемый язык по умолчанию',
        'CheckMXRecord' => 'Проверять записи MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => 'Проверять MX-записи домена, на который отправляется email при ответе. Не используйте эту возможность, если сервер с OTRS доступен по слабому каналу!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Чтобы использовать OTRS, выполните в командной строке под правами root следующую команду:',
        'Restart your webserver' => 'Перезапустите ваш веб-сервер',
        'After doing so your OTRS is up and running.' => 'После этих действий система уже запущена.',
        'Start page' => 'Главная страница',
        'Your OTRS Team' => 'Команда разработчиков OTRS',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Недостаточно прав доступа',

        # Template: Notify
        'Important' => 'Важно',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'напечатано',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: Test
        'OTRS Test Page' => 'Тестовая страница OTRS',
        'Counter' => 'Счетчик',

        # Template: Warning

        # Misc
        'Edit Article' => 'Редактировать заявку',
        'auto responses set!' => 'Установленных автоответов',
        'Create Database' => 'Создать базу',
        'Ticket Number Generator' => 'Генератор номеров заявок',
        'Create new Phone Ticket' => 'Создать телефонную заявку',
        'Symptom' => 'Признак',
        'U' => 'U',
        'Site' => 'Место',
        'Customer history search (e. g. "ID342425").' => 'Поиск по клиенту (например, «ID342425»).',
        'Can not delete link with %s!' => 'Невозможно удалить связь с «%s»!',
        'for agent firstname' => 'для агента — имя',
        'Close!' => 'Закрыть!',
        'Subgroup \'' => 'Подгруппа \'',
        'No means, send agent and customer notifications on changes.' => '«Нет» — отправлять уведомления агентам и клиентам при изменениях',
        'A web calendar' => 'Календарь',
        'to get the realname of the sender (if given)' => 'получить (если есть) имя отправителя',
        'Notification (Customer)' => 'Уведомление клиенту',
        'Select Source (for add)' => 'Выбор источника',
        'Involved' => 'Привлечение',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Поля заявки (например, &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Объект-потомок',
        'Days' => 'Дни',
        'Locked tickets' => 'Заблокированные заявки',
        'Queue ID' => 'ID очереди',
        'System History' => 'История',
        'customer realname' => 'Имя клиента',
        'Pending messages' => 'Сообщения в ожидании',
        'Modules' => 'Модули',
        'Keyword' => 'Ключевое слово',
        'Close type' => 'Тип закрытия',
        'Change user <-> group settings' => 'Группы пользователей',
        'Problem' => 'Проблема',
        'for ' => 'для',
        'Escalation' => 'Эскалация',
        '"}' => '',
        'Order' => 'Порядок',
        'next step' => 'следующий шаг',
        'Follow up' => 'Ответ',
        'Customer history search' => 'Поиск по истории клиента',
        '5 Day' => '5 дней',
        'Admin-Email' => 'Email администратора',
        'Stat#' => 'Отчет№',
        'Create new database' => 'Создать новую базы данных',
        'ArticleID' => 'ID заметки',
        'Go' => 'Выполнить',
        'Keywords' => 'Ключевые слова',
        'Ticket Escalation View' => 'Вид эскалации заявки',
        'Today' => 'Сегодня',
        'Tommorow' => 'Завтра',
        'No * possible!' => 'Нельзя использовать символ «*» !',
        'Options ' => 'Данные',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Поля информации о пользователе, который запросил это действие (например, &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Сообщение для нового владельца',
        'to get the first 5 lines of the email' => 'Получить первые 5 строк письма',
        'Sort by' => 'Сортировка по',
        'Last update' => 'Последнее изменение',
        'Tomorrow' => 'Завтра',
        'to get the first 20 character of the subject' => 'Получить первые 20 символов темы',
        'Select the customeruser:service relations.' => 'Выберите отношения клиента и службы.',
        'Drop Database' => 'Удалить базу данных',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Здесь вы можете определить ось X. У вас есть возможность выбрать один или два элемента. Затем вы можете выбрать атрибуты элементов. Значения каждого атрибута будет показаны как отдельная последовательность значений. Если вы не выберите ни одного атрибута, в отчете будут использованы все доступные атрибуты.',
        'FileManager' => 'Управление файлами',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Поля информации о пользователе (например, <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Тип ожидания',
        'Comment (internal)' => 'Комментарий (внутренний)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Поля информации о владельце заявки (например, &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Minutes' => 'Минуты',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Поля информации о заявке (например, <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => 'Используемый формат номеров заявок',
        'Reminder' => 'Напоминание',
        ' (work units)' => ' (рабочие единицы)',
        'Next Week' => 'На будущей неделе',
        'All Customer variables like defined in config option CustomerUser.' => 'Все дополнительные поля информации о клиенте определяются параметрах пользователя.',
        'for agent lastname' => 'для агента — фамилия',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Поля информации о пользователе, который запросил это действие (например <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Сообщения с напоминаниями',
        'Change users <-> roles settings' => 'Изменить распределения ролей по пользователям',
        'Parent-Object' => 'Объект-родитель',
        'Of couse this feature will take some system performance it self!' => 'Данная функция использует системные ресурсы!',
        'Ticket Hook' => 'Выбор заявки',
        'Your own Ticket' => 'Ваша собственная заявка',
        'Detail' => 'Подробно',
        'TicketZoom' => 'Просмотр заявки',
        'Open Tickets' => 'Открытые заявки',
        'Don\'t forget to add a new user to groups!' => 'Не забудьте добавить нового пользователя в группы!',
        'CreateTicket' => 'Создание заявки',
        'You have to select two or more attributes from the select field!' => 'Вам необходимо выбрать два или более пунктов из выбранного поля!',
        'System Settings' => 'Системные параметры',
        'WebWatcher' => 'Веб-наблюдатель',
        'Hours' => 'Часы',
        'Finished' => 'Закончено',
        'D' => 'D',
        'All messages' => 'Все сообщения',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Поля информации о заявке (например, <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Объект уже связан с «%s»!',
        '7 Day' => '7 дней',
        'Ticket Overview' => 'Обзор заявок',
        'All email addresses get excluded on replaying on composing and email.' => 'Все дополнительные адреса электронной почты будут исключаться в ответном письме.',
        'A web mail client' => 'Почтовый веб-клиент',
        'Compose Follow up' => 'Написать ответ',
        'WebMail' => 'Почта',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Поля информации о заявке (например, <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Опции владельца заявки (например <OTRS_OWNER_UserFirstname>)',
        'kill all sessions' => 'Закрыть все текущие сеансы',
        'to get the from line of the email' => 'получатель письма',
        'Solution' => 'Решение',
        'QueueView' => 'Просмотр очереди',
        'Select Box' => 'Команда SELECT',
        'New messages' => 'Новые сообщения',
        'Can not create link with %s!' => 'Невозможно создать связь с «%s»!',
        'Linked as' => 'Связан как',
        'Welcome to OTRS' => 'Добро пожаловать в OTRS',
        'modified' => 'Изменено',
        'Running' => 'Выполняется',
        'Have a lot of fun!' => 'Развлекайтесь!',
        'send' => 'Отправить',
        'Send no notifications' => 'Не отправлять уведомления',
        'Note Text' => 'Текст заметки',
        '3 Month' => '3 месяца',
        'POP3 Account Management' => 'Управление учетной записью POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Поля информации о клиенте (например, &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Jule' => 'Июль',
        'System State Management' => 'Управление системными состояниями',
        'Mailbox' => 'Почтовый ящик',
        'PhoneView' => 'Заявка по телефону',
        'maximal period form' => 'Максимальный период с',
        'TicketID' => 'ID заявки',
        'Mart' => 'Март',
        'Escaladed Tickets' => 'Эскалированные заявки',
        'Yes means, send no agent and customer notifications on changes.' => '«Да» — не отправлять уведомления агентам и клиентам при изменениях.',
        'Change setting' => 'Изменить параметры',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Ваше письмо с номером заявки "<OTRS_TICKET>" отвергнут и переслан по адресу "<OTRS_BOUNCE_TO>". Пожалуйста, свяжитесь по этому адресу для выяснения причин. ',
        'Ticket Status View' => 'Просмотр статуса заявки',
        'Modified' => 'Изменено',
        'Ticket selected for bulk action!' => 'Заявка выбрана для массового действия!',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
