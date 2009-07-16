# --
# Kernel/Language/ru.pm - provides ru language translation
# Copyright (C) 2003 Serg V Kravchenko <skraft at rgs.ru>
# Copyright (C) 2007 Andrey Feldman <afeldman at alt-lan.ru>
# Copyright (C) 2008 Egor Tsilenko <bg8s at symlink.ru>
# Copyright (C) 2009 Mike Lykov <combrs at gmail.com>
# Copyright (C) 2009 Egor Tsilenko <bg8s at symlink.ru>
# --
# $Id: ru.pm,v 1.84 2009-07-16 22:00:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.84 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 13:55:38 2009

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
        'top' => 'к началу',
        'end' => 'В конец',
        'Done' => 'Готово.',
        'Cancel' => 'Отказ',
        'Reset' => 'Рестарт',
        'last' => 'последний',
        'before' => 'перед',
        'day' => 'сутки',
        'days' => 'суток',
        'day(s)' => 'дней',
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
        'Modulefile' => 'Файл-модуль',
        'Subfunction' => 'Подфункция',
        'Line' => 'Линия',
        'Setting' => 'Настройка',
        'Settings' => 'Настройки',
        'Example' => 'Пример',
        'Examples' => 'Примеры',
        'valid' => 'действительный',
        'invalid' => 'недействительный',
        '* invalid' => '* недействительный',
        'invalid-temporarily' => 'временно недействительный',
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
        '-none-' => '-нет-',
        'none' => 'нет',
        'none!' => 'нет!',
        'none - answered' => 'нет - отвечен',
        'please do not edit!' => 'Не редактировать!',
        'AddLink' => 'Добавить ссылку',
        'Link' => 'Связать',
        'Unlink' => 'Отвязать',
        'Linked' => 'Связан',
        'Link (Normal)' => 'Связь (обычная)',
        'Link (Parent)' => 'Связь (Родитель)',
        'Link (Child)' => 'Связь (Потомок)',
        'Normal' => 'Нормальный',
        'Parent' => 'Родитель',
        'Child' => 'Потомок',
        'Hit' => 'Попадание',
        'Hits' => 'Попадания',
        'Text' => 'Текст',
        'Lite' => 'Облегченный',
        'User' => 'Пользователь',
        'Username' => 'Имя пользователя',
        'Language' => 'Язык',
        'Languages' => 'Языки',
        'Password' => 'Пароль',
        'Salutation' => 'Приветствие',
        'Signature' => 'Подпись',
        'Customer' => 'Клиент',
        'CustomerID' => 'ID Пользователя',
        'CustomerIDs' => 'ID Пользователей',
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
        'click here' => 'кликнуть здесь',
        'Comment' => 'Комментарий',
        'Valid' => 'Действительный',
        'Invalid Option!' => 'Неверная опция!',
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
        'Viewer' => 'Просмотрщик',
        'Expand' => 'Развернуть',
        'New message' => 'новое сообщение',
        'New message!' => 'новое сообщение!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Ответьте на эти заявки для перехода к обычному просмотру очереди !',
        'You got new message!' => 'У вас новое сообщение!',
        'You have %s new message(s)!' => 'Количество новых сообщений: %s',
        'You have %s reminder ticket(s)!' => 'Количество %s напоминаний!',
        'The recommended charset for your language is %s!' => 'Рекомендуемая кодировка для вашего языка %s',
        'Passwords doesn\'t match! Please try it again!' => 'Неверный пароль!',
        'Password is already in use! Please use an other password!' => 'Пароль уже используется! Попробуйте использовать другой пароль',
        'Password is already used! Please use an other password!' => 'Пароль уже использовался! Попробуйте использовать другой пароль',
        'You need to activate %s first to use it!' => 'Вам необходимо сначала активировать %s чтобы использовать это',
        'No suggestions' => 'Нет предложений',
        'Word' => 'Слово',
        'Ignore' => 'Пренебречь',
        'replace with' => 'заменить на',
        'There is no account with that login name.' => 'Нет пользователя с таким именем.',
        'Login failed! Your username or password was entered incorrectly.' => 'Вход не удался! Ваше имя или пароль неверны!',
        'Please contact your admin' => 'Свяжитесь с администратором',
        'Logout successful. Thank you for using OTRS!' => 'Выход успешен. Благодарим за пользование системой OTRS',
        'Invalid SessionID!' => 'Неверный идентификатор сессии!',
        'Feature not active!' => 'Функция не активирована!',
        'Notification (Event)' => 'Уведомление (Событие)',
        'Login is needed!' => 'Необходимо ввести логин',
        'Password is needed!' => 'Необходимо ввести пароль',
        'License' => 'Лицензия',
        'Take this Customer' => 'Выбрать клиента',
        'Take this User' => 'Выбрать этого пользователя',
        'possible' => 'возможно',
        'reject' => 'отвергнуть',
        'reverse' => 'вернуть',
        'Facility' => 'Приспособление',
        'Timeover' => 'Время ожидания истекло',
        'Pending till' => 'В ожидании еще',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работайте с UserID 1 (Системная учетная запись)! Создайте другого пользователя!',
        'Dispatching by email To: field.' => 'Перенаправление по заголовку To: электронного письма',
        'Dispatching by selected Queue.' => 'Перенаправление по выбранной очереди',
        'No entry found!' => 'Запись не найдена',
        'Session has timed out. Please log in again.' => 'Сессия завершена. Попробуйте войти заново.',
        'No Permission!' => 'Нет доступа!',
        'To: (%s) replaced with database email!' => 'To: (%s) заменено на e-mail базы данных!',
        'Cc: (%s) added database email!' => 'Cc: (%s) добавлен e-mail базы данных!',
        '(Click here to add)' => '(Нажмите сюда чтобы добавить)',
        'Preview' => 'Просмотр',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Пакет установлен некорректно!Вы должны переустановить пакет!',
        'Added User "%s"' => 'Добавлен Пользователь "%s"',
        'Contract' => 'Контракт',
        'Online Customer: %s' => 'Клиент в системе: %s',
        'Online Agent: %s' => 'Пользователь в системе: %s',
        'Calendar' => 'Календарь',
        'File' => 'Файл',
        'Filename' => 'Имя файла',
        'Type' => 'Тип',
        'Size' => 'Размер',
        'Upload' => 'Загрузить',
        'Directory' => 'Директория',
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
        'installed' => 'установлено',
        'uninstalled' => 'удалено',
        'Security Note: You should activate %s because application is already running!' => 'Заметка о безопасности: Вы должны активировать %s т.к. приложение уже запущено!',
        'Unable to parse Online Repository index document!' => 'Невозможно применить содержимое индексного файла Онлайн Репозитория!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Нет пакетов для запрошенного Framework в этом Онлайн Репозитории, но есть пакеты для других Framework-ов!',
        'No Packages or no new Packages in selected Online Repository!' => 'Нет пакетов или новых пакетов в выбранном Онлайн Репозитории!',
        'printed at' => 'напечатано в',
        'Dear Mr. %s,' => 'Уважаемый %s,',
        'Dear Mrs. %s,' => 'Уважаемая %s,',
        'Dear %s,' => 'Уважаемый(ая)',
        'Hello %s,' => 'Здравствуйте %s,',
        'This account exists.' => 'Эта учетная запись уже существует.',
        'New account created. Sent Login-Account to %s.' => 'Создана новая учетная запись. Данные для входа в систему отправлены %s.',
        'Please press Back and try again.' => 'Пожалуйста нажмите Назад и попробуйте еще раз',
        'Sent password token to: %s' => 'Парольный токен отправлен %s',
        'Sent new password to: %s' => 'Новый пароль отправлен',
        'Upcoming Events' => 'Ближайшие события',
        'Event' => 'Событие',
        'Events' => 'События',
        'Invalid Token!' => 'Неверный токен!',
        'more' => 'дальше',
        'For more info see:' => 'Для дальнейшей информации смотрите:',
        'Package verification failed!' => 'Проверка пакета провалена!',
        'Collapse' => 'Свернуть',
        'News' => 'Новости',
        'Product News' => 'Новости продукта',
        'Bold' => 'Жирный',
        'Italic' => 'Наклонный',
        'Underline' => 'Подчеркнутый',
        'Font Color' => 'Цвет шрифта',
        'Background Color' => 'Цвет фона',
        'Remove Formatting' => 'Удалить форматирование',
        'Show/Hide Hidden Elements' => 'Показать/скрыть скрытые элементы',
        'Align Left' => 'По левому краю',
        'Align Center' => 'По центру',
        'Align Right' => 'По правому краю',
        'Justify' => 'По ширине',
        'Header' => 'Заголовок',
        'Indent' => 'Отступ вправо',
        'Outdent' => 'Отступ влево',
        'Create an Unordered List' => 'Создать ненумерованный список',
        'Create an Ordered List' => 'Создать нумерованный список',
        'HTML Link' => 'HTML ссылка',
        'Insert Image' => 'Вставка изображения',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Отменить',
        'Redo' => 'Вернуть',

        # Template: AAAMonth
        'Jan' => 'Января',
        'Feb' => 'Февраля',
        'Mar' => 'Марта',
        'Apr' => 'Апреля',
        'May' => 'Май',
        'Jun' => 'Июня',
        'Jul' => 'Июля',
        'Aug' => 'Августа',
        'Sep' => 'Сентября',
        'Oct' => 'Октября',
        'Nov' => 'Ноября',
        'Dec' => 'Декабря',
        'January' => 'Января',
        'February' => 'Февраля',
        'March' => 'Март',
        'April' => 'Апреля',
        'June' => 'Июня',
        'July' => 'Июль',
        'August' => 'Августа',
        'September' => 'Сентября',
        'October' => 'Октября',
        'November' => 'Ноября',
        'December' => 'Декабря',

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
        'Email Addresses' => 'E-mail адреса',
        'Notifications' => 'Уведомления',
        'Category Tree' => 'Древо категорий',
        'Admin Notification' => 'Уведомление администратором',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Настройки успешно обновлены',
        'Mail Management' => 'Управление почтой',
        'Frontend' => 'Режим пользователя',
        'Other Options' => 'Другие настройки',
        'Change Password' => 'Сменить Пароль',
        'New password' => 'Новый пароль',
        'New password again' => 'Новый пароль повторно',
        'Select your QueueView refresh time.' => 'Выберите время обновления монитора очередей.',
        'Select your frontend language.' => 'Выберите ваш язык.',
        'Select your frontend Charset.' => 'Выберите вашу кодировку.',
        'Select your frontend Theme.' => 'Выберите тему интерфейса',
        'Select your frontend QueueView.' => 'Выберите язык для монитора очередей.',
        'Spelling Dictionary' => 'Словарь',
        'Select your default spelling dictionary.' => 'Выберите основной словарь',
        'Max. shown Tickets a page in Overview.' => 'Макс. кол-во Заявок на странице при отображении очереди',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Невозможно сменить пароль, новые пароли не совпадают!',
        'Can\'t update password, invalid characters!' => 'Невозможно сменить пароль, неверные символы в пароле!',
        'Can\'t update password, must be at least %s characters!' => 'Невозможно сменить пароль,  длина должна быть не менее  %s символов!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Невозможно сменить пароль, необходимо 2 символа в нижнем и 2 в верхнем регистрах!',
        'Can\'t update password, needs at least 1 digit!' => 'Невозможно сменить пароль, необходима как минимум 1 цифра!',
        'Can\'t update password, needs at least 2 characters!' => 'Невозможно сменить пароль, необходимо минимум 2 символа!',

        # Template: AAAStats
        'Stat' => 'Статистика',
        'Please fill out the required fields!' => 'Пожалуйста, заполните необходимые поля!',
        'Please select a file!' => 'Пожалуйста, выберите файл!',
        'Please select an object!' => 'Пожалуйста, выберите объект!',
        'Please select a graph size!' => 'Пожалуйста, выберите размер графика!',
        'Please select one element for the X-axis!' => 'Пожалуйста, выберите один элемент для оси X',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Пожалуйста, выберите только один элемент или снимите флаг \'Fixed\' у выбранного поля!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Если вы используете чекбокс, вы должны выбрать несколько пунктов из выбранного поля!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Пожалуйста, вставьте значение в выбранное поле или снимите флаг \'Fixed\'!',
        'The selected end time is before the start time!' => 'Выбранное время окончания до времени начала!',
        'You have to select one or more attributes from the select field!' => 'Вы должны выбрать один или несколько пунктов из выбранного поля',
        'The selected Date isn\'t valid!' => 'Выбранная дата неверна!',
        'Please select only one or two elements via the checkbox!' => 'Пожалуйста, выберите только один или два пункта используя чекбоксы',
        'If you use a time scale element you can only select one element!' => 'Если вы используете элемент временного интервала , вы можете выбрать только один элемент!',
        'You have an error in your time selection!' => 'Ошибка выбора времени',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Временной интервал отчетности слишком мал, пожалуйста, выберите больший интервал',
        'The selected start time is before the allowed start time!' => 'Выбранное время начала отчета выходит за пределы разрешенного!',
        'The selected end time is after the allowed end time!' => 'Выбранное время конца отчета выходит за пределы разрешенного!',
        'The selected time period is larger than the allowed time period!' => 'Выбранный период времени больше, чем разрешенный период!',
        'Common Specification' => 'Общая спецификация',
        'Xaxis' => 'Ось X',
        'Value Series' => 'Ряд значений',
        'Restrictions' => 'Ограничения',
        'graph-lines' => 'фигурная диаграмма(линии)',
        'graph-bars' => 'гистограмма',
        'graph-hbars' => 'горизонтальная гистограмма',
        'graph-points' => 'точечная диаграмма',
        'graph-lines-points' => 'фигурная-точечная диаграмма',
        'graph-area' => 'фигурная диаграмма(с заливкой)',
        'graph-pie' => 'круговая диаграмма',
        'extended' => 'расширенный',
        'Agent/Owner' => 'Пользователь/Владелец',
        'Created by Agent/Owner' => 'Создано Пользователем/Владелец',
        'Created Priority' => 'Приоритет',
        'Created State' => 'Состояние',
        'Create Time' => 'Время создания',
        'CustomerUserLogin' => 'Логин клиента',
        'Close Time' => 'Время закрытия',
        'TicketAccumulation' => 'Скопление заявок',
        'Attributes to be printed' => 'Атрибуты для печати',
        'Sort sequence' => 'Порядок сортировки',

        'Order by' => 'Сортировать по',
        'Limit' => 'Лимит',
        'Ticketlist' => 'Список тикетов',
        'ascending' => 'убыванию',
        'descending' => 'возрастанию',
        'First Lock' => 'Первая блокировка',
        'Evaluation by' => '',
        'Total Time' => 'Всего времени',
        'Ticket Average' => 'В среднем на заявку',
        'Ticket Min Time' => 'Минимальное время на заявку',
        'Ticket Max Time' => 'Минимальное время на заявку',
        'Number of Tickets' => 'Количество заявок',
        'Article Average' => 'В среднем на статью',
        'Article Min Time' => 'Минимальное время на статью',
        'Article Max Time' => 'Максимальное время на статью',
        'Number of Articles' => 'Количество статей',
        'Accounted time by Agent' => 'Потраченное время',
        'Ticket/Article Accounted Time' => 'Потраченное на заявку время',
        'TicketAccountedTime' => 'Потраченное на заявку время',
        'Ticket Create Time' => 'Время создания заявки',
        'Ticket Close Time' => 'Время закрытия заявки',

        # Template: AAATicket
        'Lock' => 'Блокировка',
        'Unlock' => 'Разблокировать',
        'History' => 'История',
        'Zoom' => 'Подробно',
        'Age' => 'Возраст',
        'Bounce' => 'Возвратить',
        'Forward' => 'Переслать',
        'From' => 'От',
        'To' => 'Для',
        'Cc' => 'Копия для',
        'Bcc' => 'Скрытая копия',
        'Subject' => 'Тема',
        'Move' => 'Переместить',
        'Queue' => 'Очередь',
        'Priority' => 'Приоритет',
        'Priority Update' => 'Обновление приоритета',
        'State' => 'Статус',
        'Compose' => 'Создать',
        'Pending' => 'Отложить',
        'Owner' => 'Владелец',
        'Owner Update' => 'Новый владелец',
        'Responsible' => 'Ответственный',
        'Responsible Update' => 'Новый ответственный',
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
        'This is a HTML email. Click here to show it.' => 'Этот e-mail в HTML формате. Кликните здесь для просмотра',
        'Free Fields' => 'Свободное поле',
        'Merge' => 'Объединить',
        'merged' => 'объединенный',
        'closed successful' => 'Закрыт успешно',
        'closed unsuccessful' => 'Закрыт неуспешно',
        'new' => 'новый',
        'open' => 'открытый',
        'Open' => 'Открыть',
        'closed' => 'закрытый',
        'Closed' => 'Закрыть',
        'removed' => 'удаленный',
        'pending reminder' => 'отложенное напоминание',
        'pending auto' => 'очередь на авто',
        'pending auto close+' => 'очередь на авто-закрытие+',
        'pending auto close-' => 'очередь на авто-закрытие-',
        'email-external' => 'внешний e-mail',
        'email-internal' => 'внутренний e-mail',
        'note-external' => 'внешняя заметка',
        'note-internal' => 'внутренняя заметка',
        'note-report' => 'Заметка-отчет',
        'phone' => 'телефон',
        'sms' => 'смс',
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
        'Ticket Object' => 'Объект заявки',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Заявки с номером "%s" не существует, невозможно связать ее!',
        'Don\'t show closed Tickets' => 'Не показывать закрытые заявки',
        'Show closed Tickets' => 'Показывать закрытые заявки',
        'New Article' => 'Новая статья',
        'Email-Ticket' => 'Письмо',
        'Create new Email Ticket' => 'Создать новую заявку',
        'Phone-Ticket' => 'Телефонный звонок',
        'Search Tickets' => 'Поиск заявок',
        'Edit Customer Users' => 'Редактировать клиентов',
        'Edit Customer Company' => 'Редактировать компании клиентов',
        'Bulk Action' => 'Массовое действие',
        'Bulk Actions on Tickets' => 'Массовое действие над заявками',
        'Send Email and create a new Ticket' => 'Отправить письмо и создать новую заявку',
        'Create new Email Ticket and send this out (Outbound)' => 'Создать новую e-mail заявку и отослать ее',
        'Create new Phone Ticket (Inbound)' => 'Создать новую телефонную заявку',
        'Overview of all open Tickets' => 'Обзор всех заявок',
        'Locked Tickets' => 'Заблокированные заявки',
        'Watched Tickets' => 'Отслеживаемые заявки',
        'Watched' => 'Отслеживаемые',
        'Subscribe' => 'Подписаться',
        'Unsubscribe' => 'Отписаться',
        'Lock it to work on it!' => 'Заблокировать чтобы рассмотреть заявки!',
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
        'Mark as Spam!' => 'Пометить как Spam!',
        'My Queues' => 'Мои очереди',
        'Shown Tickets' => 'Показываемые заявки',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Ваш email с номером заявки "<OTRS_TICKET>" объединен с "<OTRS_MERGE_TO_TICKET>".',
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
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Прислать мне уведомление, если клиент прислал обновление и я собственник заявки.',
        'Ticket lock timeout notification' => 'Уведомление о истечении срока блокировки заявки системой',
        'Send me a notification if a ticket is unlocked by the system.' => 'Прислать мне уведомление, если заявка освобождена системой.',
        'Move notification' => 'Уведомление о перемещении',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Прислать мне уведомление, если заявка перемещена в одну из "Моих очередей".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Выбор очередей, которые вас интересуют. Вы также будете уведомляться по email, если эта функция включена. ',
        'Custom Queue' => 'Дополнительная (custom) очередь',
        'QueueView refresh time' => 'Время обновления монитора очередей',
        'Screen after new ticket' => 'Раздел после создания новой заявки',
        'Select your screen after creating a new ticket.' => 'Выберите раздел после создания новой заявки',
        'Closed Tickets' => 'Закрытые заявки',
        'Show closed tickets.' => 'Показывать закрытые заявки',
        'Max. shown Tickets a page in QueueView.' => 'Макс. кол-во заявок на странице в Просмотре Очереди',
        'Watch notification' => 'Отслеживание уведомления',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Отправлять мне уведомления об отслеживаемых заявках так же как и владельцу заявки.',
        'Out Of Office' => 'Вне офиса',
        'Select your out of office time.' => 'Выберите время вашего отсутствия в офисе',
        'CompanyTickets' => 'Заявки компании',
        'MyTickets' => 'Мои заявки',
        'New Ticket' => 'Новая заявка',
        'Create new Ticket' => 'Создать новую заявку',
        'Customer called' => 'Звонок клиента',
        'phone call' => 'телефонный звонок',
        'Reminder Reached' => 'Время напоминания достигнуто',
        'Reminder Tickets' => 'Заявок для напоминания',
        'Escalated Tickets' => 'Эскалированных тикетов',
        'New Tickets' => 'Новых заявок',
        'Open Tickets / Need to be answered' => 'Открытых заявок / Необходимо ответить',
        'Tickets which need to be answered!' => 'Заявок на которые необходимо ответить!',
        'All new tickets!' => 'Всех новых заявок!',
        'All tickets which are escalated!' => 'Всех эскалированных заявок!',
        'All tickets where the reminder date has reached!' => 'Всех заявок с подошедшей датой напоминания!',
        'Responses' => 'Ответы',
        'Responses <-> Queue' => 'Ответы <-> Очередь',
        'Auto Responses' => 'Автоответы',
        'Auto Responses <-> Queue' => 'Авто-ответы очередей',
        'Attachments <-> Responses' => 'Прикрепленные файлы <-> Ответы',
        'History::Move' => 'Заявка перемещена в очередь "%s" (%s) из очереди "%s" (%s).',
        'History::TypeUpdate' => 'Тип изменен на %s (ID=%s).',
        'History::ServiceUpdate' => 'Сервис изменен на %s (ID=%s).',
        'History::SLAUpdate' => 'SLA изменен на %s (ID=%s).',
        'History::NewTicket' => 'Создание заявки [%s] (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Ответ на [%s]. %s',
        'History::SendAutoReject' => 'Авто-отказ выслан "%s".',
        'History::SendAutoReply' => 'Авто-ответ послан "%s".',
        'History::SendAutoFollowUp' => 'AutoFollowUp выслан "%s".',
        'History::Forward' => 'Перенаправлено к "%s".',
        'History::Bounce' => 'Возвращено  к "%s".',
        'History::SendAnswer' => 'Сообщение оправлено для "%s".',
        'History::SendAgentNotification' => '"%s"-уведомление отправлено на "%s".',
        'History::SendCustomerNotification' => 'Уведомление отправлено на "%s".',
        'History::EmailAgent' => 'Клиенту отправлено сообщение.',
        'History::EmailCustomer' => 'Получено сообщение. %s',
        'History::PhoneCallAgent' => 'Сотрудник позвонил клиенту',
        'History::PhoneCallCustomer' => 'Клиент позвонил нам.',
        'History::AddNote' => 'Добавлена заметка (%s)',
        'History::Lock' => 'Блокировка заявки.',
        'History::Unlock' => 'Разблокирование заявки.',
        'History::TimeAccounting' => 'Добавлено %s time-юнитов. Всего %s time-юнитов.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Изменено: %s',
        'History::PriorityUpdate' => 'Изменен приоритет с "%s" (%s) на "%s" (%s).',
        'History::OwnerUpdate' => 'Новый владелец "%s" (ID=%s).',
        'History::LoopProtection' => 'Защита от зацикливания! Авто-ответ на "%s" не отослан.',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Обновлено: %s',
        'History::StateUpdate' => 'Старое: "%s" Новое: "%s"',
        'History::TicketFreeTextUpdate' => 'Обновлено: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Web-запрос пользователя.',
        'History::TicketLinkAdd' => 'Добавлена связь  к заявке "%s".',
        'History::TicketLinkDelete' => 'Связь у заявки "%s" удалена.',
        'History::Subscribe' => 'Добавлена подписка для пользователя "%s".',
        'History::Unsubscribe' => 'Удалена подписка для пользователя "%s".',

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
        'To get the realname of the sender (if given).' => 'Чтобы видеть реальное имя отправителя(если указано)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Чтобы видеть опции заявки (например (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> и <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Опции текущих данных клиента (например <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Опции владельца заявки (например <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Опции ответственного за заявку (например <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Опции текущего пользователя, который запросил это действие(например <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Опции данных заявки (например <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Опции конфигурации (например <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Управление компаниями клиентов',
        'Search for' => 'Искать',
        'Add Customer Company' => 'Добавить компанию клиента',
        'Add a new Customer Company.' => 'Добавить новую компанию клиента',
        'List' => 'Список',
        'This values are required.' => 'Данное значение обязательно',
        'This values are read only.' => 'Данное значение только для чтения',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'создаваемое сообщение было закрыто. выход.',
        'This window must be called from compose window' => 'Это окно должно вызываться из окна ввода',
        'Customer User Management' => 'Управление пользователями (для клиентов)',
        'Add Customer User' => 'Добавить клиента',
        'Source' => 'Источник',
        'Create' => 'Создать',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Клиентский пользователь понадобиться чтобы обладать клиентской историей и входить через пользовательский интерфейс',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Управление группами клиентов',
        'Change %s settings' => 'Изменить %s настроек',
        'Select the user:group permissions.' => 'Выбрать user:group доступ.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Если ничего не выбрано, то в данной группе нет доступа(заявки будут недоступны для пользователя)',
        'Permission' => 'Права',
        'ro' => 'Только чтение',
        'Read only access to the ticket in this group/queue.' => 'Права только на чтение заявки в данной группе/очереди',
        'rw' => 'Чтение/запись',
        'Full read and write access to the tickets in this group/queue.' => 'Полные права на заявки в данной группе/очереди',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Клиенты <-> Сервисы',
        'CustomerUser' => 'Клиент',
        'Service' => 'Сервис',
        'Edit default services.' => 'Правка сервисов по умолчанию',
        'Search Result' => 'Результат поиска',
        'Allocate services to CustomerUser' => 'Привязать сервисы к клиенту',
        'Active' => 'Активный',
        'Allocate CustomerUser to service' => 'Привязать клиента к сервисам',

        # Template: AdminEmail
        'Message sent to' => 'Сообщение отправлено для',
        'A message should have a subject!' => 'Сообщение должно иметь поле "тема"!',
        'Recipients' => 'Получатели',
        'Body' => 'Тело письма',
        'Send' => 'Отправить',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Планировщик задач',
        'Job-List' => 'Список задач',
        'Last run' => 'Последний запуск',
        'Run Now!' => 'Выполнить сейчас!',
        'x' => '',
        'Save Job as?' => 'Сохранить задачу как?',
        'Is Job Valid?' => 'Данная задача действительна?',
        'Is Job Valid' => 'Данная задача действительна',
        'Schedule' => 'Расписание',
        'Currently this generic agent job will not run automatically.' => 'Теперь эта задача не будет запускаться автоматически.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'Для того чтобы включить автоматичческое выполнение выберите хотя бы одно значение из минут, часов и дней',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Полнотекстовый поиск в заявке (например "Mar*in" или "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(например 10*5155 или 105658*)',
        '(e. g. 234321)' => '(например 234321)',
        'Customer User Login' => 'Логин клиента',
        '(e. g. U5150)' => '(например U5150)',
        'SLA' => 'Уровень обслуживания',
        'Agent' => 'Пользователь',
        'Ticket Lock' => 'Состояни заявки',
        'TicketFreeFields' => 'Свободные поля заявки',
        'Create Times' => 'Время создания',
        'No create time settings.' => 'Без учета данного времени',
        'Ticket created' => 'Заявка создана',
        'Ticket created between' => 'Заявка создана между ',
        'Close Times' => 'Время закрытия',
        'No close time settings.' => 'Без учета времени закрытия',
        'Ticket closed' => 'Заявка закрыта',
        'Ticket closed between' => 'Заявка закрыта между',
        'Pending Times' => 'Время, когда запрос был отложен',
        'No pending time settings.' => 'Без учета данного времени',
        'Ticket pending time reached' => 'Запрос был отложен',
        'Ticket pending time reached between' => 'Запрос был отложен между',
        'Escalation Times' => 'Количество эскалаций',
        'No escalation time settings.' => 'Нет настроек времени эскалации',
        'Ticket escalation time reached' => 'Подошло время эскалации заявки',
        'Ticket escalation time reached between' => 'Время эскалации заявки подошло между',
        'Escalation - First Response Time' => 'Эскалация - Время первого ответа',
        'Ticket first response time reached' => 'Подошло время первого ответа на заявку',
        'Ticket first response time reached between' => 'Время первого ответа на заявку подошло между',
        'Escalation - Update Time' => 'Эскалация - Время Изменения',
        'Ticket update time reached' => 'Подошло время обновления заявки',
        'Ticket update time reached between' => 'Время обновления заявки подошло между',
        'Escalation - Solution Time' => 'Эскалация - Время Решения',
        'Ticket solution time reached' => 'Подошло время решения заявки',
        'Ticket solution time reached between' => 'Время решения заявки подошло между',
        'New Service' => 'Новый сервис',
        'New SLA' => 'Новый SLA',
        'New Priority' => 'Новый приоритет',
        'New Queue' => 'Новая очередь',
        'New State' => 'Новый статус',
        'New Agent' => 'Новый агент',
        'New Owner' => 'Новый владелец',
        'New Customer' => 'Новый клиент',
        'New Ticket Lock' => 'Новый статус заявки',
        'New Type' => 'Новый тип',
        'New Title' => 'Новый заголовок',
        'New TicketFreeFields' => 'Новые свободные поля заявки',
        'Add Note' => 'Добавить заметку',
        'Time units' => 'Единицы времени',
        'CMD' => 'Комманда',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Эта команда будет выполнена. ARG[0] - номер заявки. ARG[1] - id заявки.',
        'Delete tickets' => 'Удалить заявки',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Внимание! Данные заявки будут удалены из базы!',
        'Send Notification' => 'Послать уведомление',
        'Param 1' => 'Параметр 1',
        'Param 2' => 'Параметр 2',
        'Param 3' => 'Параметр 3',
        'Param 4' => 'Параметр 4',
        'Param 5' => 'Параметр 5',
        'Param 6' => 'Параметр 6',
        'Send agent/customer notifications on changes' => 'Отправлять уведомления об изменениях',
        'Save' => 'Сохранить',
        '%s Tickets affected! Do you really want to use this job?' => '%s заявок будет модифицировано! Вы действительно хотите выполнить это задание?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'ПРЕДОСТЕРЕЖЕНИЕ: Если вы измените имя группы \'admin\' до того, как внесете соответствующие изменения в Системные настройки, вы не сможете попасть в панель администрирования! Если этого случится, переименуйте группу обратно в admin используюя SQL запрос.',
        'Group Management' => 'Управление группами',
        'Add Group' => 'Добавить группу',
        'Add a new Group.' => 'Добавить новую группу',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Группа admin должна быть в admin зоне, а stats группа в stat зоне',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Создать новые группы для контроля доступа различных групп агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
        'It\'s useful for ASP solutions.' => 'Это подходит для ASP.',

        # Template: AdminLog
        'System Log' => 'Системный журнал',
        'Time' => 'Время',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Управление почтовыми учетными записями',
        'Host' => 'Сервер',
        'Trusted' => 'Безопасный',
        'Dispatching' => 'Перенаправление',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Все входящие письма с едной учетной записи будут перенесены в избранную очередь!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Если ваш акаунт безопасный, уже существующий хедер X-OTRS будет использован при доставке(для приоритета, ...)! Фильтр PostMaster будет использован в любом случае.',

        # Template: AdminNavigationBar
        'Users' => 'Пользователи',
        'Groups' => 'Группы',
        'Misc' => 'Дополнительно',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Управления уведомлениями',
        'Add Notification' => 'Добавить уведомление',
        'Add a new Notification.' => 'Добавить новое уведомление',
        'Name is required!' => 'Заголовок обязателен!',
        'Event is required!' => 'Событие обязательно!',
        'A message should have a body!' => 'Тело сообщения не может быть пустым!',
        'Recipient' => 'Получатель',
        'Group based' => 'Основано на группе',
        'Agent based' => 'Основано на агенте',
        'Email based' => 'Основано на e-mail',
        'Article Type' => 'Тип статьи',
        'Only for ArticleCreate Event.' => 'Только для события СозданиеСтатьи',
        'Subject match' => 'Тема совпадает',
        'Body match' => 'Содержимое совпадает',
        'Notifications are sent to an agent or a customer.' => 'Уведомления посланы пользовтелю или клиенту',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Для получения первых 20 символов темы (последней статьи агента)',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Для получения первых 5 строк содержимого (последней статьи агента)',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Для получения атрибутов статьи (таких как (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> и <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Для получения первых 20 символов темы (последней статьи пользователя).',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Для получения первых 5 строк содержимого (последней статьи пользователя)',

        # Template: AdminNotificationForm
        'Notification' => 'Уведомление',

        # Template: AdminPackageManager
        'Package Manager' => 'Управление пакетами',
        'Uninstall' => 'Удалить',
        'Version' => 'Версия',
        'Do you really want to uninstall this package?' => 'Вы действительно хотите удалить этот пакет?',
        'Reinstall' => 'Переустановить',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Вы действительно хотите переустановить этот пакет (все ручные изменения будут утеряны)?',
        'Continue' => 'Продолжить',
        'Install' => 'Установить',
        'Package' => 'Пакет',
        'Online Repository' => 'Онлайн репозиторий',
        'Vendor' => 'Изготовитель',
        'Module documentation' => 'Документация модуля',
        'Upgrade' => 'Обновить',
        'Local Repository' => 'Локальный репозиторий',
        'Status' => 'Статус',
        'Overview' => 'Обзор',
        'Download' => 'Скачать',
        'Rebuild' => 'Перестроить',
        'ChangeLog' => 'Лог изменений',
        'Date' => 'Дата',
        'Filelist' => 'Список файлов',
        'Download file from package!' => 'Скачать файл из пакета!',
        'Required' => 'Необходим',
        'PrimaryKey' => 'Первичный ключ',
        'AutoIncrement' => 'Автоинкремент',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Лог производительности',
        'This feature is enabled!' => 'Данная функция задйствована!',
        'Just use this feature if you want to log each request.' => 'Просто используйте эту функцию если вы хотите логгировать каждый запрос',
        'Activating this feature might affect your system performance!' => 'Включение этой функции может сказаться на производительности вашей системы',
        'Disable it here!' => 'Отключить ее!',
        'This feature is disabled!' => 'Данная функция отключена!',
        'Enable it here!' => 'Включить ее!',
        'Logfile too large!' => 'Лог-файл слишком большой!',
        'Logfile too large, you need to reset it!' => 'Лог-файл слишком большой, вам нужно очистить его!',
        'Range' => 'Промежуток',
        'Interface' => 'Интерфейс',
        'Requests' => 'Запросов',
        'Min Response' => 'Мин. время ответа',
        'Max Response' => 'Макс. время ответа',
        'Average Response' => 'Средн. время ответа',
        'Period' => 'Период',
        'Min' => 'Мин',
        'Max' => 'Макс',
        'Average' => 'Среднее',

        # Template: AdminPGPForm
        'PGP Management' => 'Управление PGP',
        'Result' => 'Результат',
        'Identifier' => 'Идентефикатор',
        'Bit' => 'Бит',
        'Key' => 'Ключ',
        'Fingerprint' => 'Цифровой отпечаток',
        'Expires' => 'Истекает',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'В данном случае вы можете изменить "keyring" прямо в Конфигурации Системы',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Управление фильтром PostMaster-а',
        'Filtername' => 'Имя фильтра',
        'Stop after match' => 'Прекратить после совпадения',
        'Match' => 'Соответствует',
        'Value' => 'Значение',
        'Set' => 'Установить',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Отправлять или фильтровать входящие письма опираясь на X-хедеры!Возможно использование регексопв.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Если вы хотите фильтровать только по email-адресам, используйте EMAILADDRESS:info@example.com в From, To или Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Если вы используете регекспы, вы можете также использовать переменные в () как [***] \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => 'Управление приоритетами',
        'Add Priority' => 'Создать приоритет',
        'Add a new Priority.' => 'Создать новый приоритет.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Автоответы в очереди',
        'settings' => 'настройки',

        # Template: AdminQueueForm
        'Queue Management' => 'Управление очередью',
        'Sub-Queue of' => 'Подочередь в',
        'Unlock timeout' => 'Срок блокировки',
        '0 = no unlock' => '0 = без блокировки',
        'Only business hours are counted.' => 'С учетом только рабочего времени.',
        '0 = no escalation' => '0 = без эскалации',
        'Notify by' => 'Уведомить через',
        'Follow up Option' => 'Параметры авто-слежения ?',
        'Ticket lock after a follow up' => 'Блокировка заявки после прихода дополнения',
        'Systemaddress' => 'Системный адрес',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Если агент заблокировал заявку и не послал ответ клиенту в течение установленного времени, то заявка автоматически разблокируется и станет доступной для остальных агентов',
        'Escalation time' => 'Время до эскалации заявки (увеличение приоритета)',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Если заявка не будет обслужена в установленное время, показывать только эту заявку',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Если заявка закрыта, а клиент прислал дополнение,то заявка будет заблокирована для предыдущего владельца',
        'Will be the sender address of this queue for email answers.' => 'Установка адреса отправителя для ответов в этой очереди',
        'The salutation for email answers.' => 'Приветствие для почтовых сообщений',
        'The signature for email answers.' => 'Подпись для почтовых сообщений',
        'Customer Move Notify' => 'Извещать клиента о перемещении',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS отправит уведомление клиенту при перемещении заявки',
        'Customer State Notify' => 'Извещать клиента о смене состояния',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS отправит уведомление клиенту при изменении статуса заявки',
        'Customer Owner Notify' => 'Извещать клиента о смене владельца',
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
        'The current ticket state is' => 'Текущее состояние заявки',
        'Your email address is new' => 'Ваш email адрес новый',

        # Template: AdminRoleForm
        'Role Management' => 'Управление ролями',
        'Add Role' => 'Добавить Роль',
        'Add a new Role.' => 'Добавить новую Роль',
        'Create a role and put groups in it. Then add the role to the users.' => 'Создайте роль и наложите ее на группы. Затем примените роль к пользователям.',
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
        'Add a new Salutation.' => 'Добавить новое приветствие',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Необходимо включить режим шифрования!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Режим шифрования включится после завершения начальной установки.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Режим шифрования необходимо выключить для того чтобы переустановить систему через веб-инсталятор',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Если режим шифрования выключен, активируйте его в Системных настройках, т.к. приложение уже используется.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL запрос',
        'Go' => 'Выполнить',
        'Select Box Result' => 'Выберите из меню',

        # Template: AdminService
        'Service Management' => 'Управление сервисами',
        'Add Service' => 'Добавить сервис',
        'Add a new Service.' => 'Добавить новый сервис',
        'Sub-Service of' => 'Подсервис',

        # Template: AdminSession
        'Session Management' => 'Управление сессиями',
        'Sessions' => 'Сессии',
        'Uniq' => 'Уникальный',
        'Kill all sessions' => 'Убить все сессии',
        'Session' => 'Сессия',
        'Content' => 'Содержание',
        'kill session' => 'Закрыть сессию',

        # Template: AdminSignatureForm
        'Signature Management' => 'Управление подписью',
        'Add Signature' => 'Добавить подпись',
        'Add a new Signature.' => 'Добавить новую подпись',

        # Template: AdminSLA
        'SLA Management' => 'Управление SLA',
        'Add SLA' => 'Добавить SLA',
        'Add a new SLA.' => 'Добавить новое SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Управление S/MIME',
        'Add Certificate' => 'Добавить сертификат',
        'Add Private Key' => 'Добавить Private Key',
        'Secret' => 'Секрет',
        'Hash' => 'Хэш',
        'In this way you can directly edit the certification and private keys in file system.' => 'В данном случае вы можете редактировать сертификаты и Private Keys прямо на файловой системе',

        # Template: AdminStateForm
        'State Management' => 'Управление статусами',
        'Add State' => 'Добавить статус',
        'Add a new State.' => 'Добавить новый статус',
        'State Type' => 'Тип статуса',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Вы можете также обновить дефолтные статусы в Kernel/Config.pm!',
        'See also' => 'См. также',

        # Template: AdminSysConfig
        'SysConfig' => 'Конфигурация системы',
        'Group selection' => 'Выбор группы',
        'Show' => 'Показать',
        'Download Settings' => 'Скачать настройки',
        'Download all system config changes.' => 'Скачать все изменения конфигурации, внесенные в систему',
        'Load Settings' => 'Загрузить настройки',
        'Subgroup' => 'Подгруппа',
        'Elements' => 'Элементы',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Опции конфигурации',
        'Default' => 'По-умолчанию',
        'New' => 'Новый',
        'New Group' => 'Новая группа',
        'Group Ro' => 'Группа только чтение',
        'New Group Ro' => 'Новая группа только чтение',
        'NavBarName' => 'Имя в навигационном меню',
        'NavBar' => 'Навигационное меню',
        'Image' => 'Картинка',
        'Prio' => 'Расположение',
        'Block' => 'Раздел',
        'AccessKey' => 'Клавиша доступа',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Управление системными e-mail адресами',
        'Add System Address' => 'Добавить системный адрес',
        'Add a new System Address.' => 'Добавить новый системный адрес',
        'Realname' => 'Реальное Имя',
        'All email addresses get excluded on replaying on composing an email.' => '',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Все входящие сообщения с этим полем (Для:) будут направлены в выбранную очередь',

        # Template: AdminTypeForm
        'Type Management' => 'Управление типами заявок',
        'Add Type' => 'Добавить тип',
        'Add a new Type.' => 'Добавить новый тип',

        # Template: AdminUserForm
        'User Management' => 'Управление пользователями',
        'Add User' => 'Добавить пользователя',
        'Add a new Agent.' => 'Добавить новго пользователя',
        'Login as' => 'Залогиниться данным пользователем',
        'Firstname' => 'Имя',
        'Lastname' => 'Фамилия',
        'Start' => 'Начало',
        'End' => 'Окончание',
        'User will be needed to handle tickets.' => 'Для обработки заявок нужен пользователь',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Не забудьте добавить нового пользователя в группы и роли!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Управление группами пользователей',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Адресная книга',
        'Return to the compose screen' => 'вернуться в окно ввода',
        'Discard all changes and return to the compose screen' => 'Отказаться от всех изменений и вернуться в окно ввода',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => 'в',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s доступен!',
        'Please update now.' => 'Пожалуйста, обновите сейчас.',
        'Release Note' => 'Примечание к релизу',
        'Level' => 'Уровень',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Написано %s назад',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Информация',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Связать объект:',
        'Object' => 'Объект',
        'Link Object' => 'Связать объект',
        'with' => 'с',
        'Select' => 'Выбрать',
        'Unlink Object: %s' => 'Отвязать объект:',

        # Template: AgentLookup
        'Lookup' => 'Поиск',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Проверка правописания',
        'spelling error(s)' => 'Ошибки правописания',
        'or' => 'или',
        'Apply these changes' => 'Применить эти изменения',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Вы действительно хотите удалить этот объект?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Выберите ограничения для определения статистики',
        'Fixed' => 'Фиксировано',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Пожалуйста, выберите только один Элемент или уберите флажок \'Fixed\'.',
        'Absolut Period' => 'Полный период',
        'Between' => 'Между',
        'Relative Period' => 'Относительный период',
        'The last' => 'Последний',
        'Finish' => 'Закончить',
        'Here you can make restrictions to your stat.' => 'Здесь вы можете внести ограничения в вашу статистику',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Если вы уберете галочку из чекбокса "Fixed", пользователь, который будет создавать отчеты сможет менять настройки соответствующего элемента',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Вставьте дополнительные требования',
        'Permissions' => 'Права',
        'Format' => 'Формат',
        'Graphsize' => 'Размер графика',
        'Sum rows' => 'Сумма строк',
        'Sum columns' => 'Сумма столбцов',
        'Cache' => 'Кэш',
        'Required Field' => 'Обязательное поле',
        'Selection needed' => 'Необходимо выделение',
        'Explanation' => 'Пояснение',
        'In this form you can select the basic specifications.' => 'В данной форме вы можете выбрать основные требования.',
        'Attribute' => 'Аттрибут',
        'Title of the stat.' => 'Название отчета',
        'Here you can insert a description of the stat.' => 'Здесь вы можете написать описание отчета',
        'Dynamic-Object' => 'Динамический-Объект',
        'Here you can select the dynamic object you want to use.' => 'Здесь вы можете выбрать динмический объект, который вы хотите использовать',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(заметка: То, сколько объектов можно использовать, зависит от вашей инсталляции)',
        'Static-File' => 'Статический-Файл',
        'For very complex stats it is possible to include a hardcoded file.' => 'Для очень комплексных отчетов возможно подключить "hardcoded" файл',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Если новый "hardcoded" файл доступен, этот аттрибут будет показан и вы сможете выбрать один из них.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Настройки доступа. Вы можете выбрать одну или несколько групп чтобы отчет был видел для разных пользователей.',
        'Multiple selection of the output format.' => 'Выбор форматов вывода.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Если вы используете графики, вам необходимо выбрать хотябы один размер графика.',
        'If you need the sum of every row select yes' => 'Если вам необходима сумма каждого ряда выберите Да',
        'If you need the sum of every column select yes.' => 'Если вам необходима сумма каждого столбца выберите Да',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Большинство отчетов могут кэшироваться. Это увеличит скорость презентации отчетов.',
        '(Note: Useful for big databases and low performance server)' => '(Заметка: Полезно для больших баз данных или для серверов с низкой производительностью)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'При статусе отчета "недействительный" отчет не может быть сформирован.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Это полезно если вы не хотите чтобы ктонибудь смог получить результаты отчета или отчет еще окончательно не сконфигурирован.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Выберите элементы для последовательности значений',
        'Scale' => 'Масштаб',
        'minimal' => 'Минимальный',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Помните, что масштаб для последовательности значений должен быть больше, чем масштаб для оси X (например Ось Х => Месяц, последовательность значений => Год).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Здесь вы можете (пропущен глагол) серии значений. У вас есть возможность выбрать один или два элемента. Затем вы можете выбрать признаки элементов. Каждый признак будет отображен как отдельная серия значений. Если вы не выберете ни одного признака, все признаки элемента будут использованы при генерирации отчета. Так же новый атрибут добавлен с прошлой конфигурации',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Выберите элемент, который будет использован на оси Х',
        'maximal period' => 'максимальный период',
        'minimal scale' => 'минимальный масштаб',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Здесь вы можете определить ось X. Вы можете выбрать один элемент. Если вы не выберите ни одного элемента, все атрибуты будут использованы для генерации отчета.',

        # Template: AgentStatsImport
        'Import' => 'Импорт',
        'File is not a Stats config' => 'Файл не является файлом конфигурации отчетов',
        'No File selected' => 'Файл не выбран',

        # Template: AgentStatsOverview
        'Results' => 'Результат',
        'Total hits' => 'Кумулятивные попадания',
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
        'to' => 'до',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Вводя данные и выбирая поля вы можете конфигурировать отчет как вам необходимо. От администратора , создававшего данный отчет, зависит какие данные вы можете конфигурировать. ',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Сообщение должно иметь поле ДЛЯ: адресата!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Нужен правильный адрес в поле ДЛЯ: (support@example.ru)!',
        'Bounce ticket' => 'Пересылка заявки',
        'Ticket locked!' => 'Заявка заблокирована!',
        'Ticket unlock!' => 'Заявка разблокирована!',
        'Bounce to' => 'Переслать для',
        'Next ticket state' => 'Следующее состояние заявки',
        'Inform sender' => 'Информировать отправителя',
        'Send mail!' => 'Послать e-mail!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Вам необходимо посчитать время!',
        'Ticket Bulk Action' => 'Массовое действие',
        'Spell Check' => 'Проверка правописания',
        'Note type' => 'Тип заметки',
        'Next state' => 'Следующее состояние',
        'Pending date' => 'Дата ожидания',
        'Merge to' => 'Объединить с',
        'Merge to oldest' => 'Объединить с ',
        'Link together' => 'Связать вместе',
        'Link to Parent' => 'Связать с родителем',
        'Unlock Tickets' => 'Разблокировать заявки',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Необходимо ввести тип заявки',
        'A required field is:' => 'Поля обязательные к заполнению:',
        'Close ticket' => 'Закрыть заявку',
        'Previous Owner' => 'Предыдущий владелец',
        'Inform Agent' => 'Оповестить пользователя',
        'Optional' => 'Опционально',
        'Inform involved Agents' => 'Оповестить участвующих пользователей',
        'Attach' => 'Прикрепить файл',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Сообщение должно быть проверено на ошибки!',
        'Compose answer for ticket' => 'Создание ответ на заявку',
        'Pending Date' => 'Следующая дата',
        'for pending* states' => 'для последующих состояний* ',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Изменить клиента заявки',
        'Set customer user and customer id of a ticket' => 'Установить клиентского пользователя и клиенсткий id для заявки',
        'Customer User' => 'Пользователь клиента',
        'Search Customer' => 'Искать клиента',
        'Customer Data' => 'Учетные данные клиента',
        'Customer history' => 'История клиента',
        'All customer tickets.' => 'Все заявки клиента.',

        # Template: AgentTicketEmail
        'Compose Email' => 'Написать письмо',
        'new ticket' => 'Новая Заявка',
        'Refresh' => 'Обновить',
        'Clear To' => 'Очистить',
        'All Agents' => 'Все',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Тип статьи',

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
        'You need min. one selected Ticket!' => 'Вам необхоимо выбрать хотябы одну заявку!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Фильтр',
        'Change search options' => 'Изменить установки поиска',
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
        'Change owner of ticket' => 'Изменить собственика заявки',

        # Template: AgentTicketPending
        'Set Pending' => 'Устновка ожидания',

        # Template: AgentTicketPhone
        'Phone call' => 'Телефонный звонок',
        'Clear From' => 'Очистить форму',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Обыкновенный',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Информация о заявке',
        'Accounted time' => 'Потраченное на заявку время',
        'Linked-Object' => 'Слинкованный-Объект',
        'by' => '',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Изменить приоритет заявки',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Показаны Заявки',
        'Tickets available' => 'Доступные заявки',
        'All tickets' => 'Все Заявки',
        'Queues' => 'очереди',
        'Ticket escalation!' => 'Истекло время до эскалации заявки !',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Сменить ответственного за заявку',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Поиск заявки',
        'Profile' => 'Параметры',
        'Search-Template' => 'Шаблон поиска',
        'TicketFreeText' => 'Свободные поля заявки',
        'Created in Queue' => 'Создано в очереди',
        'Article Create Times' => 'Время создания',
        'Article created' => 'Заявка создана',
        'Article created between' => 'Заявка создана между',
        'Change Times' => 'Время изменения',
        'No change time settings.' => 'Без учета времени изменения',
        'Ticket changed' => 'Заявка изменена',
        'Ticket changed between' => 'Заявка изменена между',
        'Result Form' => 'Вывод результатов',
        'Save Search-Profile as Template?' => 'Сохранить параметры поиска в качестве шаблона?',
        'Yes, save it with name' => 'Да, сохранить с именем',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Полнотекстовый',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Развернутый вид',
        'Collapse View' => 'Сжатый вид',
        'Split' => 'Разделить',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Настройки фильтра',
        'Save filter settings as default' => 'Сохранить настройки фильтра по умолчанию',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Отслежевание',

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
        'No time settings.' => 'Нет временных ограничений',

        # Template: CustomerTicketSearchOpenSearchDescription

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
        'Web-Installer' => 'Вёб инсталлятор',
        'Welcome to %s' => 'Добро пожаловать в %s',
        'Accept license' => 'Принять условия лицензии',
        'Don\'t accept license' => 'Не принимать условия лицензии',
        'Admin-User' => 'Имя пользователя(Администратор)',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Если вы создали пароль администратора для вашей базы данных, он должен быть введен здесь. Если нет, оставьте поле пустым. Из соображений безопасности мы рекомендуем создать пароль администратора. Для более детальной информации пожалуйста обратитесь к документации по вашей базе данных',
        'Admin-Password' => 'Пароль пользователя',
        'Database-User' => 'БД пользователь',
        'default \'hot\'' => 'По умолчанию \'hot\'',
        'DB connect host' => 'Имя БД-хоста',
        'Database' => 'Имя БД',
        'Default Charset' => 'Кодировка по умолчанию',
        'utf8' => 'utf8',
        'false' => 'ложь',
        'SystemID' => 'Системный ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(ID системы. Каждый номер Заявки и каждая http сессия будет начинаться с этого числа)',
        'System FQDN' => 'Системное FQDN',
        '(Full qualified domain name of your system)' => '(Полное доменное имя (FQDN) вашей системы)',
        'AdminEmail' => 'e-mail администратора',
        '(Email of the system admin)' => '(e-mail системного администратора)',
        'Organization' => 'Организация',
        'Log' => 'Лог',
        'LogModule' => 'Модуль журнала ',
        '(Used log backend)' => '(Используемый журнал backend)',
        'Logfile' => 'Файл журнала',
        '(Logfile just needed for File-LogModule!)' => '(Журнал-файл необходим только для модуля File-Log)',
        'Webfrontend' => 'Web-интерфейс',
        'Use utf-8 it your database supports it!' => 'Используйте utf-8 если ваша БД это поддерживает!',
        'Default Language' => 'язык по умолчанию',
        '(Used default language)' => '(Используемый язык по умолчанию)',
        'CheckMXRecord' => 'Проверять MX запси',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => 'Проверяет MX записи домена, на который отправляется e-mail(при составлении ответа). Не используйте CheckMXRecord если сервер с OTRS соединен по dial-up !',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Чтобы использовать OTRS вам необходимо ввести следующую строку в шеле (от пользователя root).',
        'Restart your webserver' => 'Перезапустите ваш web-сервер',
        'After doing so your OTRS is up and running.' => 'После этих действий ваш OTRS уже запущен.',
        'Start page' => 'Стартовая страница',
        'Your OTRS Team' => 'Команда разработчиков OTRS',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Нет прав',

        # Template: Notify
        'Important' => 'Важно',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'напечатано',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Тестовая страница OTRS',
        'Counter' => 'счетчик',

        # Template: Warning

        # Template: YUI

        # Misc
        'Edit Article' => 'Редактировать заявку',
        'auto responses set!' => 'установленных автоответов',
        'Create Database' => 'Создать базу',
        'Ticket Number Generator' => 'Генератор номера Заявки',
        'Create new Phone Ticket' => 'Создать телефонную заявку',
        'Symptom' => 'Признак',
        'U' => 'U',
        'Site' => 'Место',
        'Customer history search (e. g. "ID342425").' => 'Поиск истории клиента (напр. "ID342425").',
        'Can not delete link with %s!' => 'Невозможно удалить связь с %s!',
        'Close!' => 'Закрыть!',
        'for agent firstname' => 'для агента - имя',
        'Subgroup \'' => 'Подгруппа \'',
        'No means, send agent and customer notifications on changes.' => 'Нет значит отсылать уведомления пользователям и клиентам при изменениях',
        'A web calendar' => 'Календарь',
        'to get the realname of the sender (if given)' => 'получить (если есть) имя отправителя',
        'Notification (Customer)' => 'Уведомление (Клиенту)',
        'Involved' => 'Совместно с',
        'Select Source (for add)' => 'Выбрать источник',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Опции данных заявки (например  &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Объект-Потомок',
        'Days' => 'Дни',
        'Queue ID' => 'ID очереди',
        'Locked tickets' => 'Заблокированные заявки',
        'System History' => 'История',
        'customer realname' => 'имя клиента',
        'Pending messages' => 'Сообщения в ожидании',
        'Modules' => 'Модули',
        'Keyword' => 'Ключевое слово',
        'Close type' => 'Тип закрытия',
        'Change user <-> group settings' => 'Изменить настройки групп пользователей',
        'Problem' => 'Проблема',
        'for ' => 'для',
        'Escalation' => 'Эскалация',
        '"}' => '"}',
        'Order' => 'Порядок',
        'next step' => 'следующий шаг',
        'Follow up' => 'Дополнение к заявке',
        'Customer history search' => 'Поиск истории клиента',
        '5 Day' => '5 Дней',
        'Admin-Email' => 'e-mail администратора',
        'Stat#' => 'Стат N',
        'Create new database' => 'Создать новую БД',
        'ArticleID' => 'ID заметки',
        'Keywords' => 'Ключевые слова',
        'Ticket Escalation View' => 'Вид эскалации заявки',
        'Today' => 'Сегодня',
        'Tommorow' => 'Завтра',
        'No * possible!' => 'Нельзя использовать символ * !',
        'Options ' => 'Опции',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Опции текущего пользователя, который запросил это действие (например &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'сообщение для нового владельца',
        'to get the first 5 lines of the email' => 'получить первые 5 строк письма',
        'Sort by' => 'Сортировка по',
        'Last update' => 'Последнее изменение',
        'Tomorrow' => 'Завтра',
        'to get the first 20 character of the subject' => 'получить первые 20 символов поля "тема"',
        'Select the customeruser:service relations.' => 'Выберите связь: клиент-сервис.',
        'Drop Database' => 'Удалить базу',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Здесь вы можете определить ось X. Вы можете выбрать один элемент. Затем необходимо выбрать два или более аттрибутов элемента. Если вы совсем не выберите аттрибутов элемента - все аттрибуты будут использованы для генерации отчета, а также вновь добавленные аттрибуты.',
        'FileManager' => 'Файл менеджер',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Опции текущих данных пользователя (например <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Тип ожидания',
        'Comment (internal)' => 'Комментарий (внутренний)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Опции владельца заявки (например &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Minutes' => 'Минуты',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Опции данных заявки (например <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Используемый формат номеров Заявок)',
        'Reminder' => 'Напоминание',
        ' (work units)' => ' (рабочие единицы)',
        'Next Week' => 'На будущей неделе',
        'All Customer variables like defined in config option CustomerUser.' => 'Все переменные клиента содержаться в конфигурации клиентского пользователя.',
        'for agent lastname' => 'для агента - фамилия',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Опции для текущего пользователя, который запросил это действие (например <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Напоминающие сообщения',
        'Change users <-> roles settings' => 'Изменить настройки пользователи <-> роли',
        'Parent-Object' => 'Объект-Родитель',
        'Of couse this feature will take some system performance it self!' => 'Конечно, данная функция сама съедает немного ресурсов!',
        'Ticket Hook' => 'Зацепить Заявку',
        'Detail' => 'Подробно',
        'Your own Ticket' => 'Ваша собственная заявка',
        'TicketZoom' => 'Просмотр заявки',
        'Don\'t forget to add a new user to groups!' => 'Не забудьте добавить новоего пользователя в группы!',
        'Open Tickets' => 'Открытые заявки',
        'CreateTicket' => 'Создание заявки',
        'You have to select two or more attributes from the select field!' => 'Вам необходимо выбрать два или более пунктов из выбранного поля!',
        'System Settings' => 'Системные установки',
        'WebWatcher' => 'Web-наблюдатель',
        'Hours' => 'Часы',
        'Finished' => 'Закончено',
        'D' => 'D',
        'All messages' => 'Все сообщения',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Опции заявки (например <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Объект уже связан с %s!',
        '7 Day' => '7 Дней',
        'Ticket Overview' => 'Обзор заявок',
        'All email addresses get excluded on replaying on composing and email.' => '',
        'A web mail client' => 'Почтовый Веб-клиент',
        'Compose Follow up' => 'Создать автоответ(Ваша заявка принята)',
        'WebMail' => 'Почта',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Опции заявки (например <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Опции владельца заявки (например <OTRS_OWNER_UserFirstname>)',
        'kill all sessions' => 'Закрыть все текущие сессии',
        'to get the from line of the email' => 'получить поле "от" письма',
        'Solution' => 'Решение',
        'QueueView' => 'Просмотр очереди',
        'Select Box' => 'Дать команду SELECT',
        'New messages' => 'Новые сообщения',
        'Can not create link with %s!' => 'Невозможно создать связь с %s!',
        'Linked as' => 'Связан как',
        'Welcome to OTRS' => 'Добро пожаловать в OTRS',
        'modified' => 'Изменено',
        'Running' => 'Выполняется',
        'Have a lot of fun!' => 'Развлекайтесь!',
        'send' => 'Отправить',
        'Send no notifications' => 'Не отсылать уведомления',
        'Note Text' => 'Текст заметки',
        'POP3 Account Management' => 'Управление учетной записью POP3',
        '3 Month' => '3 Месяца',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Опции для данных текущего пользователя-клиента (например &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Jule' => 'Июля',
        'System State Management' => 'Управление системными состояниями',
        'Mailbox' => 'Почтовый ящик',
        'PhoneView' => 'Заявка по телефону',
        'maximal period form' => 'Максимальный период с',
        'TicketID' => 'ID заявки',
        'Mart' => 'Марта',
        'Escaladed Tickets' => 'Эскалированные заявки',
        'Change setting' => 'Изменить настройки',
        'Yes means, send no agent and customer notifications on changes.' => 'Да значит не отсылать уведомления пользователям и клиентам при изменениях',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Ваш e-mail с номером заявки "<OTRS_TICKET>" отвергнут и переслан по адресу "<OTRS_BOUNCE_TO>". Пожалуйста, свяжитесь по этому адресу для выяснения причин. ',
        'Ticket Status View' => 'Просмотр статуса заявки',
        'Modified' => 'Изменено',
        'Ticket selected for bulk action!' => 'Заявка выбрана для массового действия!',
    };
    # $$STOP$$
    return;
}

1;
