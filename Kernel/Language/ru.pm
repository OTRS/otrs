# --
# Kernel/Language/ru.pm - provides ru language translation
# Copyright (C) 2003 Serg V Kravchenko <skraft at rgs.ru>
# Copyright (C) 2007 Andrey Feldman <afeldman at alt-lan.ru>
# Copyright (C) 2008-2009 Egor Tsilenko <bg8s at symlink.ru>
# Copyright (C) 2009 Andrey Cherepanov <cas at altlinux.ru>
# Copyright (C) 2010 Denis Kot <denis.kot at gmail.com>
# Copyright (C) 2010 Andrey A. Fedorov <2af at mail.ru>
# Copyright (C) 2010-2011 Eugene Kungurov <ekungurov83 at ya.ru>
# Copyright (C) 2010 Sergey Romanov <romanov_s at mail.ru>
# Copyright (C) 2012-2013 Vadim Goncharov <vgoncharov at mail.ru>
# Copyright (C) 2013 Alexey Gluhov <glalexnn at yandex.ru>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-05-31 15:13:01

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T, %A %D %B, %Y г.';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

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
        'last' => 'последние',
        'before' => 'кроме последних',
        'Today' => 'Сегодня',
        'Tomorrow' => 'Завтра',
        'Next week' => 'Следующая неделя',
        'day' => 'день',
        'days' => 'дней',
        'day(s)' => 'день(дней)',
        'd' => 'дн',
        'hour' => 'час',
        'hours' => 'часов',
        'hour(s)' => 'час(ов)',
        'Hours' => 'Часы',
        'h' => 'ч',
        'minute' => 'минута',
        'minutes' => 'минут',
        'minute(s)' => 'минут(а)',
        'Minutes' => 'Минуты',
        'm' => 'мин',
        'month' => 'месяц',
        'months' => 'месяцев',
        'month(s)' => 'месяц(ев)',
        'week' => 'неделя',
        'week(s)' => 'неделя(ль)',
        'year' => 'год',
        'years' => 'лет',
        'year(s)' => 'год(лет)',
        'second(s)' => 'секунд(а)',
        'seconds' => 'секунд',
        'second' => 'секунда',
        's' => 'с',
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
        'Valid' => 'Действительный',
        'invalid' => 'недействительный',
        'Invalid' => 'Недействительный',
        '* invalid' => '* недействительный',
        'invalid-temporarily' => 'временно недействительный',
        ' 2 minutes' => ' 2 минуты',
        ' 5 minutes' => ' 5 минут',
        ' 7 minutes' => ' 7 минут',
        '10 minutes' => '10 минут',
        '15 minutes' => '15 минут',
        'Mr.' => 'Г-н',
        'Mrs.' => 'Г-жа',
        'Next' => 'Вперед',
        'Back' => 'Назад',
        'Next...' => 'Вперед...',
        '...Back' => '...Назад',
        '-none-' => '-нет-',
        'none' => 'нет',
        'none!' => 'нет!',
        'none - answered' => 'нет — отвечен',
        'please do not edit!' => 'Не редактировать!',
        'Need Action' => 'Требуется действие',
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
        'Standard' => 'Стандартный',
        'Lite' => 'Облегченный',
        'User' => 'Пользователь',
        'Username' => 'Логин',
        'Language' => 'Язык',
        'Languages' => 'Языки',
        'Password' => 'Пароль',
        'Preferences' => 'Предпочтения',
        'Salutation' => 'Приветствие',
        'Salutations' => 'Приветствия',
        'Signature' => 'Подпись',
        'Signatures' => 'Подписи',
        'Customer' => 'Клиент',
        'CustomerID' => 'ID клиента',
        'CustomerIDs' => 'ID клиентов',
        'customer' => 'клиент',
        'agent' => 'агент',
        'system' => 'система',
        'Customer Info' => 'Информация о клиенте',
        'Customer Information' => 'Информация о клиенте',
        'Customer Company' => 'Компания клиента',
        'Customer Companies' => 'Компании клиента',
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
        'submit!' => 'отправить!',
        'submit' => 'отправить',
        'Submit' => 'Отправить',
        'change!' => 'Изменить!',
        'Change' => 'Изменение',
        'change' => 'изменение',
        'click here' => 'нажмите здесь',
        'Comment' => 'Комментарий',
        'Invalid Option!' => 'Неверный параметр!',
        'Invalid time!' => 'Неверное время!',
        'Invalid date!' => 'Неверная дата!',
        'Name' => 'Имя',
        'Group' => 'Группа',
        'Description' => 'Описание',
        'description' => 'описание',
        'Theme' => 'Тема',
        'Created' => 'Создан',
        'Created by' => 'Создавший',
        'Changed' => 'Изменен',
        'Changed by' => 'Изменивший',
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
        'Small' => 'Маленький',
        'Medium' => 'Средний',
        'Large' => 'Большой',
        'Date picker' => 'Выбор даты',
        'New message' => 'Новое сообщение',
        'New message!' => 'Новое сообщение!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Ответьте на эти заявки для перехода к обычному просмотру очереди !',
        'You have %s new message(s)!' => 'Количество новых сообщений: %s',
        'You have %s reminder ticket(s)!' => 'Количество напоминаний: %s!',
        'The recommended charset for your language is %s!' => 'Рекомендуемая кодировка для вашего языка: %s',
        'Change your password.' => 'Измените пароль.',
        'Please activate %s first!' => 'Пожалуйста, сначала активируйте %s!',
        'No suggestions' => 'Нет предложений',
        'Word' => 'Слово',
        'Ignore' => 'Игнорировать',
        'replace with' => 'заменить на',
        'There is no account with that login name.' => 'Нет учетной записи с таким именем пользователя.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Ошибка идентификации! Указано неправильное имя или пароль!',
        'There is no acount with that user name.' => 'Аккаунта с таким именем пользователя нет',
        'Please contact your administrator' => 'Свяжитесь с администратором',
        'Logout' => 'Выход',
        'Logout successful. Thank you for using %s!' => 'Вы успешно вышли из системы. Благодарим за пользование системой %s !',
        'Feature not active!' => 'Функция не активирована!',
        'Agent updated!' => 'Агент обновлен!',
        'Create Database' => 'Создать базу',
        'System Settings' => 'Системные параметры',
        'Mail Configuration' => 'Конфигурация почты',
        'Finished' => 'Закончено',
        'Install OTRS' => 'Инсталлировать OTRS',
        'Intro' => 'Интро',
        'License' => 'Лицензия',
        'Database' => 'Имя базы данных',
        'Configure Mail' => 'Конфигурировать почту',
        'Database deleted.' => 'База данных удалена.',
        'Database setup successful!' => 'База данных настроена успешно!',
        'Generated password' => '',
        'Login is needed!' => 'Необходимо ввести логин',
        'Password is needed!' => 'Необходимо ввести пароль',
        'Take this Customer' => 'Выбрать этого клиента',
        'Take this User' => 'Выбрать этого пользователя',
        'possible' => 'возможно',
        'reject' => 'отвергнуть',
        'reverse' => 'вернуть',
        'Facility' => 'Приспособление',
        'Time Zone' => 'Часовой пояс',
        'Pending till' => 'В ожидании еще',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Не используйте учетную запись суперпользователя для работы с OTRS! Создайте новых Агентов и работайте с ними.',
        'Dispatching by email To: field.' => 'Перенаправление по заголовку To: электронного письма',
        'Dispatching by selected Queue.' => 'Перенаправление по выбранной очереди',
        'No entry found!' => 'Запись не найдена',
        'Session invalid. Please log in again.' => 'Ошибка сессии. Пожалуйста авторизуйтесь вновь.',
        'Session has timed out. Please log in again.' => 'Сеанс завершен. Попробуйте войти заново.',
        'Session limit reached! Please try again later.' => 'Срок жизни сессии прошел. Пожалуйста попробуйте еще раз.',
        'No Permission!' => 'Нет доступа!',
        '(Click here to add)' => '(нажмите сюда чтобы добавить)',
        'Preview' => 'Предварительный просмотр',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Пакет установлен некорректно! Вы должны переустановить пакет!',
        '%s is not writable!' => '%s не доступен для записи!',
        'Cannot create %s!' => 'Не могу создать %s!',
        'Check to activate this date' => 'Активировать эту дату',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Вы включали Отсутствие в офисе, хотите отключить?',
        'Customer %s added' => 'Клиент %s добавлен',
        'Role added!' => 'Роль добавлена!',
        'Role updated!' => 'Роль обновлена!',
        'Attachment added!' => 'Вложение добавлено!',
        'Attachment updated!' => 'Вложение обновлено!',
        'Response added!' => 'Ответ добавлен!',
        'Response updated!' => 'Ответ обновлен!',
        'Group updated!' => 'Группа обновлена!',
        'Queue added!' => 'Очередь добавлена!',
        'Queue updated!' => 'Очередь обновлена!',
        'State added!' => 'Состояние добавлено!',
        'State updated!' => 'Состояние обновлено',
        'Type added!' => 'Тип добавлен!',
        'Type updated!' => 'Тип обновлен!',
        'Customer updated!' => 'Клиент обновлен!',
        'Customer company added!' => 'Компания клиента добавлена!',
        'Customer company updated!' => 'Компания клиента обновлена!',
        'Mail account added!' => 'Учетная запись почты добавлена!',
        'Mail account updated!' => 'Учетная запись почты обновлена!',
        'System e-mail address added!' => 'Системный адрес электронной почты добавлен!',
        'System e-mail address updated!' => 'Системный адрес электронной почты обновлен!',
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
        'PGP' => 'PGP',
        'PGP Key' => 'PGP ключ',
        'PGP Keys' => 'PGP ключи',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'Сертификат S/MIME',
        'S/MIME Certificates' => 'Сертификаты S/MIME',
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
        'Security Note: You should activate %s because application is already running!' =>
            'Предупреждение о безопасности: вы должны активировать «%s», так как приложение уже запущено!',
        'Unable to parse repository index document.' => 'Не получилось разобрать формат индексного файла репозитория.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Нет пакетов для вашей версии фреймворка в этом репозитории, он содержит пакеты для других версий фреймворка.',
        'No packages, or no new packages, found in selected repository.' =>
            'Нет пакетов или новых пакетов в выбранном репозитории.',
        'Edit the system configuration settings.' => 'Редактировать настройки конфигурации системы',
        'printed at' => 'напечатано в',
        'Loading...' => 'Загрузка...',
        'Dear Mr. %s,' => 'Уважаемый %s,',
        'Dear Mrs. %s,' => 'Уважаемая %s,',
        'Dear %s,' => 'Уважаемый(ая)',
        'Hello %s,' => 'Здравствуйте, %s.',
        'This email address already exists. Please log in or reset your password.' =>
            'Такой адрес электронной почты уже существует. Пожалуйста, войдите, или сбросьте свой пароль.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Новая учетная запись создана. Информация о логине отправлена на %s. Проверьте свою почту.',
        'Please press Back and try again.' => 'Нажмите «Назад» и попробуйте еще раз',
        'Sent password reset instructions. Please check your email.' => 'Отправлены инструкции по сбросу пароля. Проверьте свою почту.',
        'Sent new password to %s. Please check your email.' => 'Новый пароль выслан на %s. Проверьте свою почту.',
        'Upcoming Events' => 'Ближайшие события',
        'Event' => 'Событие',
        'Events' => 'События',
        'Invalid Token!' => 'Неверный токен !',
        'more' => 'далее',
        'Collapse' => 'Свернуть',
        'Shown' => 'Показано',
        'Shown customer users' => 'Отображенные клиенты',
        'News' => 'Новости',
        'Product News' => 'Новости о продукте',
        'OTRS News' => 'Новости OTRS',
        '7 Day Stats' => 'Статистика за 7 дней',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
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
        'Scheduler process is registered but might not be running.' => 'Процесс планировщика зарегистрирован, но может не быть запущен.',
        'Scheduler is not running.' => 'Планировщик не запущен.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Новый Год',
        'International Workers\' Day' => 'День международной солидарности трудящихся',
        'Christmas Eve' => 'Сочельник',
        'First Christmas Day' => 'Первый день Рождества',
        'Second Christmas Day' => 'Второй день Рождества',
        'New Year\'s Eve' => 'Канун Нового Года',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS как запрашивающий',
        'OTRS as provider' => 'OTRS как провайдер',
        'Webservice "%s" created!' => 'Вебсервис «%s» создан!',
        'Webservice "%s" updated!' => 'Вебсервис «%s» обновлен!',

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

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Настройки успешно обновлены',
        'User Profile' => 'Профиль пользователя',
        'Email Settings' => 'Настройки почты',
        'Other Settings' => 'Прочие настройки',
        'Change Password' => 'Сменить пароль',
        'Current password' => 'Текущий пароль',
        'New password' => 'Новый пароль',
        'Verify password' => 'Подтвердите пароль',
        'Spelling Dictionary' => 'Словарь',
        'Default spelling dictionary' => 'Словарь по умолчанию',
        'Max. shown Tickets a page in Overview.' => 'Максимальное количество заявок при показе очереди',
        'The current password is not correct. Please try again!' => 'Пароль не верен. Пожалуйста, попробуйте снова!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Невозможно обновить пароль. Новые пароли не совпадают. Пожалуйста, попробуйте снова!',
        'Can\'t update password, it contains invalid characters!' => 'Невозможно обновить пароль, т.к. он содержит запрещенные символы!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Невозможно обновить пароль, т.к. его длина должна быть не менее %s символов!',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            'Невозможно обновить пароль, т.к. он должен содержать не менее 2-х строчных и 2-х заглавных символов!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Невозможно обновить пароль, т.к. он должен содержать не менее 1-й цифры!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Невозможно обновить пароль, т.к. он должен содержать не менее 2 букв!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Невозможно обновить пароль, т.к. он уже использовался. Пожалуйста, выберите другой.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Выберите символ разделителя, используемый в файлах CSV (статистика и поиски). Если вы не выберете его здесь, будет использован разделитель по умолчанию для вашего языка.',
        'CSV Separator' => 'Разделитель CSV',

        # Template: AAAStats
        'Stat' => 'Статистика',
        'Sum' => 'Сумма',
        'Please fill out the required fields!' => 'Заполните обязательные поля!',
        'Please select a file!' => 'Выберите файл!',
        'Please select an object!' => 'Выберите объект!',
        'Please select a graph size!' => 'Выберите размер графика!',
        'Please select one element for the X-axis!' => 'Выберите один элемент для оси X',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Выберите только один элемент или снимите флаг \'Fixed\' у выбранного поля!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Если вы используете флажки выделения, то должны выбрать несколько пунктов из выбранного поля!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Вставьте значение в выбранное поле или снимите флаг «Fixed»!',
        'The selected end time is before the start time!' => 'Указанное время окончания раньше времени начала!',
        'You have to select one or more attributes from the select field!' =>
            'Вы должны выбрать один или несколько пунктов из выбранного поля',
        'The selected Date isn\'t valid!' => 'Выбранная дата неверна!',
        'Please select only one or two elements via the checkbox!' => 'Выберите только один или два пункта, используя флажки',
        'If you use a time scale element you can only select one element!' =>
            'Если вы используете элемент периода, вы можете выбрать только один пункт!',
        'You have an error in your time selection!' => 'Ошибка указания времени',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Период отчетности слишком мал, укажите больший интервал',
        'The selected start time is before the allowed start time!' => 'Выбранное время начала выходит за пределы разрешенного!',
        'The selected end time is after the allowed end time!' => 'Выбранное время конца выходит за пределы разрешенного!',
        'The selected time period is larger than the allowed time period!' =>
            'Выбранный период времени больше, чем разрешенный период!',
        'Common Specification' => 'Общая спецификация',
        'X-axis' => 'Ось X',
        'Value Series' => 'Группы значений',
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
        'Status View' => 'Просмотр статуса',
        'Bulk' => 'Массовое действие',
        'Lock' => 'Блокировка',
        'Unlock' => 'Разблокировать',
        'History' => 'История',
        'Zoom' => 'Подробно',
        'Age' => 'Возраст',
        'Bounce' => 'Перенаправить',
        'Forward' => 'Переслать',
        'From' => 'Отправитель',
        'To' => 'Получатель',
        'Cc' => 'Копия',
        'Bcc' => 'Скрытая копия',
        'Subject' => 'Тема',
        'Move' => 'Переместить',
        'Queue' => 'Очередь',
        'Queues' => 'Очереди',
        'Priority' => 'Приоритет',
        'Priorities' => 'Приоритеты',
        'Priority Update' => 'Изменение приоритета',
        'Priority added!' => 'Приоритет добавлен!',
        'Priority updated!' => 'Приоритет обновлен!',
        'Signature added!' => 'Подпись добавлена!',
        'Signature updated!' => 'Подпись обновлена!',
        'SLA' => 'Уровень обслуживания',
        'Service Level Agreement' => 'Соглашение об Уровне Сервиса',
        'Service Level Agreements' => 'Соглашения об Уровне Сервиса',
        'Service' => 'Сервис',
        'Services' => 'Сервисы',
        'State' => 'Состояние',
        'States' => 'Состояния',
        'Status' => 'Статус',
        'Statuses' => 'Статусы',
        'Ticket Type' => 'Тип заявки',
        'Ticket Types' => 'Типы заявки',
        'Compose' => 'Создать',
        'Pending' => 'Напоминание',
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
        'This message was written in a character set other than your own.' =>
            'Это сообщение написано в кодировке. отличной от вашей.',
        'If it is not displayed correctly,' => 'Если текст отображается некорректно,',
        'This is a' => 'Это',
        'to open it in a new window.' => 'открыть в новом окне',
        'This is a HTML email. Click here to show it.' => 'Этот электронное письмо в формате HTML. Нажмите здесь для просмотра',
        'Free Fields' => 'Свободные поля',
        'Merge' => 'Объединить',
        'merged' => 'объединенный',
        'closed successful' => 'закрыт успешно',
        'closed unsuccessful' => 'закрыт неуспешно',
        'Locked Tickets Total' => 'Заблокированные заявки: Всего',
        'Locked Tickets Reminder Reached' => 'Заблокированные заявки: Напоминание истекло',
        'Locked Tickets New' => 'Заблокированные заявки: Новые',
        'Responsible Tickets Total' => 'Ответственные заявки: Всего',
        'Responsible Tickets New' => 'Ответственные заявки: Новые',
        'Responsible Tickets Reminder Reached' => 'Ответственные заявки: Напоминание истекло',
        'Watched Tickets Total' => 'Наблюдаемые заявки: Всего',
        'Watched Tickets New' => 'Наблюдаемые заявки: Новые',
        'Watched Tickets Reminder Reached' => 'Наблюдаемые заявки: Напоминание истекло',
        'All tickets' => 'Все заявки',
        'Available tickets' => 'Доступные заявки',
        'Escalation' => 'Эскалация',
        'last-search' => 'последний поиск',
        'QueueView' => 'Просмотр очереди',
        'Ticket Escalation View' => 'Просмотр заявок с эскалацией',
        'Message from' => 'Сообщение от',
        'End message' => 'Конец сообщения',
        'Forwarded message from' => 'Пересылаемое сообщение от',
        'End forwarded message' => 'Конец пересылаемого сообщения',
        'new' => 'новый',
        'open' => 'открытый',
        'Open' => 'Открытый',
        'Open tickets' => 'Открытые заявки',
        'closed' => 'закрытый',
        'Closed' => 'Закрытый',
        'Closed tickets' => 'Закрытые заявки',
        'removed' => 'удаленный',
        'pending reminder' => 'ожидает напоминания',
        'pending auto' => 'ожидает автозакрытия',
        'pending auto close+' => 'ожидает автозакрытия(+)',
        'pending auto close-' => 'ожидает автозакрытия(-)',
        'email-external' => 'внешний email',
        'email-internal' => 'внутренний email',
        'note-external' => 'внешняя заметка',
        'note-internal' => 'внутренняя заметка',
        'note-report' => 'Заметка-отчет',
        'phone' => 'звонок',
        'sms' => 'SMS',
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
        'auto follow up' => 'авто-отклик',
        'auto reject' => 'авто-отказ',
        'auto remove' => 'авто-удаление',
        'auto reply' => 'авто-ответ',
        'auto reply/new ticket' => 'авто-ответ/новая заявка',
        'Ticket "%s" created!' => 'Создана заявка «%s».',
        'Ticket Number' => 'Номер заявки',
        'Ticket Object' => 'Объект заявки',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Заявки с номером «%s» не существует, невозможно связать с нею!',
        'You don\'t have write access to this ticket.' => 'У вас нет прав на запись в эту заявку.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Извините, для выполнения этого действия вам необходимо быть владельцем заявки.',
        'Please change the owner first.' => 'Пожалуйста, сначала измените владельца',
        'Ticket selected.' => 'Заявка выбрана.',
        'Ticket is locked by another agent.' => 'Заявка заблокирована другим агентом.',
        'Ticket locked.' => 'Заявка заблокирована.',
        'Don\'t show closed Tickets' => 'Не показывать закрытые заявки',
        'Show closed Tickets' => 'Показывать закрытые заявки',
        'New Article' => 'Новое сообщение',
        'Unread article(s) available' => 'Доступны непрочтенные сообщения',
        'Remove from list of watched tickets' => 'Удалить из списка наблюдаемых заявок',
        'Add to list of watched tickets' => 'Добавить в список наблюдаемых заявок',
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
        'Address %s replaced with registered customer address.' => 'Адрес %s заменен зарегистрированным адресом клиента',
        'Customer automatically added in Cc.' => 'Клиент автоматически добавлен в Cc',
        'Overview of all open Tickets' => 'Обзор всех открытых заявок',
        'Locked Tickets' => 'Заблокированные заявки',
        'My Locked Tickets' => 'Мои заблокированные заявки',
        'My Watched Tickets' => 'Мои наблюдаемые заявки',
        'My Responsible Tickets' => 'Мои ответственные заявки',
        'Watched Tickets' => 'Наблюдаемые заявки',
        'Watched' => 'Наблюдаемые',
        'Watch' => 'Наблюдать',
        'Unwatch' => 'Не наблюдать',
        'Lock it to work on it' => 'Заблокировать, чтобы работать',
        'Unlock to give it back to the queue' => 'Разблокировать, чтобы вернуть в очередь',
        'Show the ticket history' => 'Показать историю заявки',
        'Print this ticket' => 'Печать этой заявки',
        'Print this article' => 'Печать этого сообщения',
        'Split' => 'Разделить',
        'Split this article' => 'Разделить это сообщение',
        'Forward article via mail' => 'Переслать сообщение почтой',
        'Change the ticket priority' => 'Сменить приоритет заявки',
        'Change the ticket free fields!' => 'Изменить свободные поля заявки!',
        'Link this ticket to other objects' => 'Связать эту заявку с другими объектами',
        'Change the owner for this ticket' => 'Сменить владельца этой заявки',
        'Change the  customer for this ticket' => 'Сменить клиента для этой заявки',
        'Add a note to this ticket' => 'Добавить заметку к этой заявке',
        'Merge into a different ticket' => 'Объединить с другой заявкой',
        'Set this ticket to pending' => 'Поставить заявку в ожидание',
        'Close this ticket' => 'Закрыть эту заявку',
        'Look into a ticket!' => 'Просмотреть заявку!',
        'Delete this ticket' => 'Удалить эту заявку',
        'Mark as Spam!' => 'Пометить как спам!',
        'My Queues' => 'Мои очереди',
        'Shown Tickets' => 'Показываемые заявки',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Ваш email с номером заявки «<OTRS_TICKET>» объединен с "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Заявка %s: время первого ответа истекло (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Заявка %s: время первого ответа истечет через %s!',
        'Ticket %s: update time is over (%s)!' => 'Заявка %s: время обновления заявки истекло (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Заявка %s: время обновления заявки истечет через %s!',
        'Ticket %s: solution time is over (%s)!' => 'Заявка %s: время решения заявки истекло (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Заявка %s: время решения заявки истечет через %s!',
        'There are more escalated tickets!' => 'Эскалированных заявок больше нет!',
        'Plain Format' => 'Исходный формат',
        'Reply All' => 'Ответить всем',
        'Direction' => 'Направление',
        'Agent (All with write permissions)' => 'Агент (все с правом записи)',
        'Agent (Owner)' => 'Агент (Владелец)',
        'Agent (Responsible)' => 'Агент (Ответственный)',
        'New ticket notification' => 'Уведомление о новой заявке',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Прислать мне уведомление, если есть новая заявка в одной из моих очередей.',
        'Send new ticket notifications' => 'Отправлять уведомления о новых заявках',
        'Ticket follow up notification' => 'Уведомление об откликах клиента в заявке',
        'Ticket lock timeout notification' => 'Уведомление об истечении срока блокировки заявки системой',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Прислать мне уведомление, если заявка освобождена системой.',
        'Send ticket lock timeout notifications' => 'Отправлять уведомления об истечении блокировок',
        'Ticket move notification' => 'Уведомление о перемещении заявки',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Прислать мне уведомление, если заявка перемещена в одну из моих очередей.',
        'Send ticket move notifications' => 'Отправлять уведомления о перемещении заявок',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Ваш выбор предпочитаемых очередей. Также, если включено, вы будете получать уведомления почтой об этих очередях.',
        'Custom Queue' => 'Резервная очередь',
        'QueueView refresh time' => 'Время обновления монитора очередей',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Монитор очередей будет автоматически обновляться через указанный промежуток времени.',
        'Refresh QueueView after' => 'Обновлять монитор очередей каждые',
        'Screen after new ticket' => 'Раздел после создания новой заявки',
        'Show this screen after I created a new ticket' => 'Показывать этот раздел после создания заявки',
        'Closed Tickets' => 'Закрытые заявки',
        'Show closed tickets.' => 'Показывать закрытые заявки',
        'Max. shown Tickets a page in QueueView.' => 'Максимальное количество заявок при просмотре очереди',
        'Ticket Overview "Small" Limit' => 'Обзор заявок - лимит режима «Маленький»',
        'Ticket limit per page for Ticket Overview "Small"' => 'Лимит числа заявок на одной странице в обзоре заявок в режиме «Маленький»',
        'Ticket Overview "Medium" Limit' => 'Обзор заявок - лимит режима «Средний»',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Лимит числа заявок на одной странице в обзоре заявок в режиме «Средний»',
        'Ticket Overview "Preview" Limit' => 'Обзор заявок - лимит режима «Предварительный просмотр»',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Лимит числа заявок на одной странице в обзоре заявок в режиме «Предварительный просмотр»',
        'Ticket watch notification' => 'Уведомление по наблюдаемым заявкам',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Прислать мне те же уведомления для наблюдаемых заявок, которые получают владельцы заявок.',
        'Send ticket watch notifications' => 'Отправлять уведомления по наблюдаемым заявкам',
        'Out Of Office Time' => 'Период отсутствия в офисе',
        'New Ticket' => 'Новая заявка',
        'Create new Ticket' => 'Создать новую заявку',
        'Customer called' => 'Звонок клиента',
        'phone call' => 'телефонный звонок',
        'Phone Call Outbound' => 'Сделать звонок',
        'Phone Call Inbound' => 'Входящий звонок',
        'Reminder Reached' => 'Напоминание истекает',
        'Reminder Tickets' => 'Заявки с напоминанием',
        'Escalated Tickets' => 'Эскалированные заявки',
        'New Tickets' => 'Новые заявки',
        'Open Tickets / Need to be answered' => 'Открытые заявки (требуется ответить)',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Все открытые заявки; с этими заявками уже работали, но они нуждаются в ответе',
        'All new tickets, these tickets have not been worked on yet' => 'Все новые заявки; с этими заявками еще никто не работал',
        'All escalated tickets' => 'Все эскалированные заявки',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Все заявки с напоминанием, у которых назначенная дата напоминания наступила',
        'Archived tickets' => 'Архивированные заявки',
        'Unarchived tickets' => 'Неархивированные заявки',
        'History::Move' => 'Заявка перемещена в очередь «%s» (%s) из очереди «%s» (%s).',
        'History::TypeUpdate' => 'Тип изменен на %s (ID=%s).',
        'History::ServiceUpdate' => 'Сервис изменен на %s (ID=%s).',
        'History::SLAUpdate' => 'SLA изменен на %s (ID=%s).',
        'History::NewTicket' => 'Новая заявка [%s] (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Отклик на [%s]. %s',
        'History::SendAutoReject' => 'Автоотказ отправлен «%s».',
        'History::SendAutoReply' => 'Автоответ отправлен «%s».',
        'History::SendAutoFollowUp' => 'Автоотклик отправлен «%s».',
        'History::Forward' => 'Переcлано «%s».',
        'History::Bounce' => 'Перенаправлено «%s».',
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
        'History::TicketDynamicFieldUpdate' => 'Обновлено: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Веб-запрос пользователя.',
        'History::TicketLinkAdd' => 'К заявке «%s» добавлена связь.',
        'History::TicketLinkDelete' => 'Связь с заявкой «%s» удалена.',
        'History::Subscribe' => 'Добавлена подписка для пользователя «%s».',
        'History::Unsubscribe' => 'Удалена подписка для пользователя «%s».',
        'History::SystemRequest' => 'Системный запрос (%s)',
        'History::ResponsibleUpdate' => 'Новый ответственный теперь «%s» (ID=%s)',
        'History::ArchiveFlagUpdate' => 'Архивный статус изменен: «%s»',

        # Template: AAAWeekDay
        'Sun' => 'Вск',
        'Mon' => 'Пнд',
        'Tue' => 'Втр',
        'Wed' => 'Срд',
        'Thu' => 'Чтв',
        'Fri' => 'Птн',
        'Sat' => 'Сбт',

        # Template: AdminAttachment
        'Attachment Management' => 'Управление прикрепленными файлами',
        'Actions' => 'Действия',
        'Go to overview' => 'Перейти к обзору',
        'Add attachment' => 'Добавить вложение',
        'List' => 'Список',
        'Validity' => 'Действительность',
        'No data found.' => 'Данные не найдены.',
        'Download file' => 'Скачать файл',
        'Delete this attachment' => 'Удалить это вложение',
        'Add Attachment' => 'Добавить вложение',
        'Edit Attachment' => 'Редактировать вложение',
        'This field is required.' => 'Это поле обязательно.',
        'or' => 'или',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Управление автоответами',
        'Add auto response' => 'Добавить автоответ',
        'Add Auto Response' => 'Добавить автоответ',
        'Edit Auto Response' => 'Изменить автоответ',
        'Response' => 'Ответ',
        'Auto response from' => 'Автоответ от',
        'Reference' => 'Ссылка',
        'You can use the following tags' => 'Вы можете использовать следующие теги',
        'To get the first 20 character of the subject.' => 'Чтобы получить первые 20 символов темы',
        'To get the first 5 lines of the email.' => 'Чтобы получить первые 5 строк email',
        'To get the realname of the sender (if given).' => 'Чтобы получить реальное имя отправителя (если указано)',
        'To get the article attribute' => 'Чтобы получить атрибут сообщения',
        ' e. g.' => ' например,',
        'Options of the current customer user data' => 'Атрибуты данных о пользователе текущего клиента',
        'Ticket owner options' => 'Атрибуты владельца заявки',
        'Ticket responsible options' => 'Атрибуты ответственного за заявку',
        'Options of the current user who requested this action' => 'Атрибуты текущего пользователя, запросившего это действие',
        'Options of the ticket data' => 'Атрибуты данных заявки',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Опции конфигурации',
        'Example response' => 'Пример ответа',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Управление компанией клиента',
        'Wildcards like \'*\' are allowed.' => 'Разрешены шаблоны типа \'*\'.',
        'Add customer company' => 'Добавить компанию клиента',
        'Please enter a search term to look for customer companies.' => 'Введите запрос для поиска компаний клиента.',
        'Add Customer Company' => 'Добавить компанию клиента',

        # Template: AdminCustomerUser
        'Customer Management' => 'Управление клиентами',
        'Back to search result' => 'Назад к результатам поиска',
        'Add customer' => 'Добавить клиента',
        'Select' => 'Выбор',
        'Hint' => 'Подсказка',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Учетная запись клиента необходима для ведения истории клиента и для доступа к клиентской панели.',
        'Please enter a search term to look for customers.' => 'Введите запрос для поиска клиентов.',
        'Last Login' => 'Последний вход',
        'Login as' => 'Зайти данным пользователем',
        'Switch to customer' => 'Переключится на клиента',
        'Add Customer' => 'Добавить клиента',
        'Edit Customer' => 'Редактировать клиента',
        'This field is required and needs to be a valid email address.' =>
            'Это поле обязательно, и должно быть корректным адресом электронной почты.',
        'This email address is not allowed due to the system configuration.' =>
            'Этот адрес электронной почты не разрешен в конфигурации системы.',
        'This email address failed MX check.' => 'Этот адрес электронной почты не прошел проверку наличия MX-записей.',
        'DNS problem, please check your configuration and the error log.' =>
            'Проблема с DNS, проверьте вашу конфигурацию и лог ошибок.',
        'The syntax of this email address is incorrect.' => 'Синтаксис этого адреса электронной почты некорректен.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Связь Клиентов с Группами',
        'Notice' => 'Замечание',
        'This feature is disabled!' => 'Данная функция отключена!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Просто используйте эту возможность, если хотите определить групповые права для клиентов.',
        'Enable it here!' => 'Включить функцию!',
        'Search for customers.' => 'Поиск клиентов.',
        'Edit Customer Default Groups' => 'Редактировать группы по-умолчанию клиента',
        'These groups are automatically assigned to all customers.' => 'Эти группы автоматически назначаются всем клиентам.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Этими группами можно управлять в настройке конфигурации "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Фильтры для Групп',
        'Select the customer:group permissions.' => 'Выберите разрешения клиент:группа.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Если ничего не выбрано, тогда у этой группы не будет прав (заявки будут недоступны клиенту).',
        'Search Result:' => 'Результаты поиска:',
        'Customers' => 'Клиенты',
        'Groups' => 'Группы',
        'No matches found.' => 'Совпадений не найдено.',
        'Change Group Relations for Customer' => 'Изменить связи с группами для клиента',
        'Change Customer Relations for Group' => 'Изменить связь клиентов с группой',
        'Toggle %s Permission for all' => 'Переключить разрешение «%s» для всех',
        'Toggle %s permission for %s' => 'Переключить разрешение «%s» для %s',
        'Customer Default Groups:' => 'Клиентские группы по-умолчанию:',
        'No changes can be made to these groups.' => 'В эти группы нельзя внести изменения.',
        'ro' => 'Только чтение',
        'Read only access to the ticket in this group/queue.' => 'Права только на чтение заявки в данной группе/очереди',
        'rw' => 'Чтение/запись',
        'Full read and write access to the tickets in this group/queue.' =>
            'Полные права на заявки в данной группе/очереди',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Связь Клиентов с Сервисами',
        'Edit default services' => 'Редактировать сервисы по-умолчанию',
        'Filter for Services' => 'Фильтр для Сервисов',
        'Allocate Services to Customer' => 'Распределить сервисы клиенту',
        'Allocate Customers to Service' => 'Распределить клиентов в сервис',
        'Toggle active state for all' => 'Переключить активное состояние для всех',
        'Active' => 'Активный',
        'Toggle active state for %s' => 'Переключить активное состояние для %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Управление динамическими полями',
        'Add new field for object' => 'Добавить новое поле для объекта',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Чтобы добавить новое поле, выберите тип поля из одного из списков объектов выше; объект определяет границы применения поля, которые не могут быть изменены после создания поля.',
        'Dynamic Fields List' => 'Список динамических полей',
        'Dynamic fields per page' => 'Динамических полей на страницу',
        'Label' => 'Надпись',
        'Order' => 'Порядок',
        'Object' => 'Объект',
        'Delete this field' => 'Удалить это поле',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Вы действительно хотите удалить это динамическое поле? ВСЕ связанные данные будут ПОТЕРЯНЫ!',
        'Delete field' => 'Удалить поле',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Динамические поля',
        'Field' => 'Поле',
        'Go back to overview' => 'Обратно в обзор',
        'General' => 'Общие',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Данное поле ввода обязательно, и может состоять только из латинских букв и цифр.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Должно быть уникальным, и может состоять только из латинских букв и цифр.',
        'Changing this value will require manual changes in the system.' =>
            'Изменение этого значения потребует ручных изменений в системе.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Это имя, под которым поле будет показано на тех экранах, на которых оно активно.',
        'Field order' => 'Порядок поля',
        'This field is required and must be numeric.' => 'Это поле обязательно, и должно быть числовым.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Это порядок, в котором поле будет показываться среди других полей на тех экранах, где оно активно.',
        'Field type' => 'Тип поля',
        'Object type' => 'Тип объекта',
        'Internal field' => 'Внутреннее поле',
        'This field is protected and can\'t be deleted.' => 'Это поле защищено и не может быть удалено.',
        'Field Settings' => ' - настройки поля',
        'Default value' => 'Значение по умолчанию',
        'This is the default value for this field.' => 'Это значение по умолчанию для данного поля.',
        'Save' => 'Сохранить',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Разница дат по умолчанию',
        'This field must be numeric.' => 'Это поле должно быть числовым',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Разница в секундах с NOW (текущим моментом) для подсчета значения по умолчанию для этого поля (например, 3600 или -60).',
        'Define years period' => 'Задать период лет',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Активируйте эту возможность для задания фиксированного диапазона лет (в прошлое и в будущее) для отображения в части поля, показывающей год.',
        'Years in the past' => 'Лет в прошлое',
        'Years in the past to display (default: 5 years).' => 'Число лет в прошлое для отображения (по умолчанию: 5 лет)',
        'Years in the future' => 'Лет в будущее',
        'Years in the future to display (default: 5 years).' => 'Число лет в будущее для отображения (по умолчанию: 5 лет)',
        'Show link' => 'Показывать ссылку',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Здесь можно указать необязательную HTTP-ссылку для значения поля в экранах Обзоров и Подробного просмотра',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Возможные значения',
        'Key' => 'Ключ',
        'Value' => 'Значение',
        'Remove value' => 'Удалить значение',
        'Add value' => 'Добавить значение',
        'Add Value' => 'Добавить Значение',
        'Add empty value' => 'Добавить пустое значение',
        'Activate this option to create an empty selectable value.' => 'Отметьте эту опцию для создания пустого выбирабельного значения.',
        'Translatable values' => 'Переводимые значения',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Если включить эту опцию, значения будут переведены в заданный язык пользователя.',
        'Note' => 'Заметка',
        'You need to add the translations manually into the language translation files.' =>
            'Вам необходимо вручную добавить переводы в файлы переводов для языков.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Число строк',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Задает высоту (в строках) для этого поля в режиме редактирования.',
        'Number of cols' => 'Число столбцов',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Задает ширину (в символах) для этого поля в режиме редактирования.',

        # Template: AdminEmail
        'Admin Notification' => 'Уведомление администратором',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'С помощью этого модуля администраторы могут отправлять сообщения агентам, членам группы или роли.',
        'Create Administrative Message' => 'Создать административное сообщение',
        'Your message was sent to' => 'Ваше сообщение было отправлено к',
        'Send message to users' => 'Отправить сообщение пользователям',
        'Send message to group members' => 'Отправить сообщение членам группы',
        'Group members need to have permission' => 'Члены группы должны иметь разрешение',
        'Send message to role members' => 'Отправить сообщение членам роли',
        'Also send to customers in groups' => 'Также отправить клиентам в группах',
        'Body' => 'Тело письма',
        'Send' => 'Отправить',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Планировщик задач',
        'Add job' => 'Добавить задание',
        'Last run' => 'Последний запуск',
        'Run Now!' => 'Выполнить сейчас!',
        'Delete this task' => 'Удалить задачу',
        'Run this task' => 'Запустить задачу',
        'Job Settings' => 'Настройки задания',
        'Job name' => 'Имя задания',
        'Currently this generic agent job will not run automatically.' =>
            'Это задание агента не запускается автоматически',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Для автоматического запуска укажите как минимум одно из значений в минутах, часах или днях!',
        'Schedule minutes' => 'Запускать в минуты',
        'Schedule hours' => 'Запускать в часы',
        'Schedule days' => 'Запускать в дни',
        'Toggle this widget' => 'Переключить показ этого блока',
        'Ticket Filter' => 'Фильтр заявок',
        '(e. g. 10*5155 or 105658*)' => '(например, 10*5155 или 105658*)',
        '(e. g. 234321)' => '(например, 234321)',
        'Customer login' => 'Логин клиента',
        '(e. g. U5150)' => '(например, U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Полнотекстовый поиск в сообщении (например, "Mar*in" или "Baue*").',
        'Agent' => 'Агент',
        'Ticket lock' => 'Блокировка заявки',
        'Create times' => 'Когда создана',
        'No create time settings.' => 'Без учета времени создания',
        'Ticket created' => 'Заявка создана',
        'Ticket created between' => 'Заявка создана между ',
        'Change times' => 'Когда изменена',
        'No change time settings.' => 'Не изменять параметры времени',
        'Ticket changed' => 'Заявка изменена',
        'Ticket changed between' => 'Заявка изменена в период',
        'Close times' => 'Когда закрыта',
        'No close time settings.' => 'Без учета времени закрытия',
        'Ticket closed' => 'Заявка закрыта',
        'Ticket closed between' => 'Заявка закрыта между',
        'Pending times' => 'Когда отложена',
        'No pending time settings.' => 'Без учета времени, когда запрос был отложен',
        'Ticket pending time reached' => 'Заявка была отложена',
        'Ticket pending time reached between' => 'Заявка была отложена между',
        'Escalation times' => 'Когда эскалирована',
        'No escalation time settings.' => 'Без учета времени эскалации',
        'Ticket escalation time reached' => 'Заявка была эскалирована',
        'Ticket escalation time reached between' => 'Заявка была эскалирована между',
        'Escalation - first response time' => 'Эскалация - время первого ответа',
        'Ticket first response time reached' => 'Первый ответ',
        'Ticket first response time reached between' => 'Первый ответ между',
        'Escalation - update time' => 'Эскалация - время обновления',
        'Ticket update time reached' => 'Заявка была обновлена',
        'Ticket update time reached between' => 'Заявка была обновлена между',
        'Escalation - solution time' => 'Эскалация - время решения',
        'Ticket solution time reached' => 'Заявка была решена',
        'Ticket solution time reached between' => 'Заявка была решена между',
        'Archive search option' => 'Поиск в архиве',
        'Ticket Action' => 'Действия по заявке',
        'Set new service' => 'Установить новый сервис',
        'Set new Service Level Agreement' => 'Установить новое Соглашение об Уровне Сервиса (SLA)',
        'Set new priority' => 'Установить новый приоритет',
        'Set new queue' => 'Установить новую очередь',
        'Set new state' => 'Установить новое состояние',
        'Set new agent' => 'Назначить нового агента',
        'new owner' => 'новый владелец',
        'new responsible' => 'новый ответственный',
        'Set new ticket lock' => 'Установить новое состояние блокировки',
        'New customer' => 'Новый клиент',
        'New customer ID' => 'ID нового клиента',
        'New title' => 'Новый заголовок',
        'New type' => 'Новый тип',
        'New Dynamic Field Values' => 'Новые значения динамических полей',
        'Archive selected tickets' => 'Архивировать выбранные заявки',
        'Add Note' => 'Добавить заметку',
        'Time units' => 'Единицы времени',
        '(work units)' => '(рабочие единицы)',
        'Ticket Commands' => 'Команды по заявке',
        'Send agent/customer notifications on changes' => 'Отправлять уведомление агенту при изменениях',
        'CMD' => 'Команда',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Эта команда будет выполнена. ARG[0] — номер заявки. ARG[1] — id заявки.',
        'Delete tickets' => 'Удалить заявки',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Предупреждение: Все выбранные заявки будут удалены из базы данных без возможности восстановления!',
        'Execute Custom Module' => 'Запустить пользовательский модуль',
        'Param %s key' => 'Параметр %s: ключ',
        'Param %s value' => 'Параметр %s: значение',
        'Save Changes' => 'Сохранить изменения',
        'Results' => 'Результат',
        '%s Tickets affected! What do you want to do?' => 'Затронуто %s заявок! Что желаете сделать?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Внимание! Вы использовали опцию УДАЛЕНИЯ. Все удаленные заявки будут потеряны!',
        'Edit job' => 'Редактировать задание',
        'Run job' => 'Запустить задание',
        'Affected Tickets' => 'Выбранные задания',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => 'Вебсервисы',
        'Debugger' => 'Отладчик',
        'Go back to web service' => 'Перейти назад к веб сервису',
        'Clear' => 'Очистить',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Время',
        'Remote IP' => 'Удаленный IP-адрес',
        'Loading' => 'Загрузка',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Обновить',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content' => 'Отобразить или скрыть содержимое',
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
        'The name you entered already exists.' => 'Введенное вами имя уже существует.',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => 'Конфигурировать',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Event Triggers' => '',
        'Asynchronous' => 'Асинхронно',
        'Delete this event' => 'Удалить это событие',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'Сохранить и продолжить',
        'Save and finish' => 'Сохранить и закончить',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => 'Вернуться к',
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
        'Properties' => 'Свойства',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => 'Пространство имен',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => 'Максимальная длина сообщения',
        'This field should be an integer number.' => 'Это поле должно быть целым числом.',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => 'Кодировка',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'например, utf-8, latin1, iso-8859-1, cp1250, и т.д.',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => 'Аутентификация',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => 'Файл сертификата',
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
        'Import' => 'Импорт',
        'Configuration history' => 'История конфигурации',
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
        'Details' => 'Подробно',
        'Debug threshold' => 'Порог отладки',
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
        'Configuration History List' => 'Список истории конфигурации',
        'Version' => 'Версия',
        'Create time' => 'Время создания',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => 'Показать или убрать содержимое',
        'Restore' => 'Восстановить',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ВНИМАНИЕ! Если вы измените имя группы «admin» до того, как поменяете название этой группы конфигурации системы, у вас не будет прав доступа на панель администрирования. Если это произошло, верните прежнее название группы (admin) вручную командой SQL.',
        'Group Management' => 'Управление группами',
        'Add group' => 'Добавить группу',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Группа admin может осуществлять администрирование, а группа stats — просматривать статистику',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Создать новые группы, чтобы управлять правами для разных групп агентов (например, департамент закупок, департамент поддержки, департамент продаж, ...).',
        'It\'s useful for ASP solutions. ' => 'Полезно для сервис-провайдеров.',
        'Add Group' => 'Добавить группу',
        'Edit Group' => 'Редактировать группу',

        # Template: AdminLog
        'System Log' => 'Системный журнал',
        'Here you will find log information about your system.' => 'Здесь вы найдете логи с информацией о вашей системе.',
        'Hide this message' => 'Убрать это сообщение',
        'Recent Log Entries' => 'Свежие записи в логе',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Управление почтовыми учетными записями',
        'Add mail account' => 'Добавить почтовую учетную запись',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Все входящие письма с указанной учетной записи будут перенесены в выбранную очередь!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Если к вашей учётной записи есть доверие, будут использованы уже существующие в письмах на момент прибытия заголовки X-OTRS (для выставления приоритета и прочих данных)! Фильтр PostMaster будет использован в любом случае.',
        'Host' => 'Сервер',
        'Delete account' => 'Удалить учетную запись',
        'Fetch mail' => 'Забрать письмо',
        'Add Mail Account' => 'Добавить почтовую учетную запись',
        'Example: mail.example.com' => 'Пример: mail.example.com',
        'IMAP Folder' => 'Папка IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Изменение здесь требуется только в случае необходимости забирать почту из другой папки, не из INBOX.',
        'Trusted' => 'Доверенная',
        'Dispatching' => 'Перенаправление',
        'Edit Mail Account' => 'Изменить почтовую учетную запись',

        # Template: AdminNavigationBar
        'Admin' => 'Администрирование',
        'Agent Management' => 'Управление агентами',
        'Queue Settings' => 'Настройки очередей',
        'Ticket Settings' => 'Настройки заявок',
        'System Administration' => 'Администрирование системы',

        # Template: AdminNotification
        'Notification Management' => 'Управления уведомлениями',
        'Select a different language' => 'Выберите другой язык',
        'Filter for Notification' => 'Фильтр для уведомлений',
        'Notifications are sent to an agent or a customer.' => 'Уведомления отправляются агенту или клиенту',
        'Notification' => 'Уведомление',
        'Edit Notification' => 'Редактировать уведомления',
        'e. g.' => 'например,',
        'Options of the current customer data' => 'Атрибуты данных о текущем клиенте',

        # Template: AdminNotificationEvent
        'Add notification' => 'Добавить уведомление',
        'Delete this notification' => 'Удалить это уведомление',
        'Add Notification' => 'Добавить уведомление',
        'Recipient groups' => 'Получат группы',
        'Recipient agents' => 'Получат агенты',
        'Recipient roles' => 'Получат роли',
        'Recipient email addresses' => 'Получат адреса электронной почты',
        'Article type' => 'Тип сообщения',
        'Only for ArticleCreate event' => 'Только для события ArticleCreate',
        'Article sender type' => '',
        'Subject match' => 'Соответствие теме',
        'Body match' => 'Соответствие телу письма',
        'Include attachments to notification' => 'Добавить вложения в уведомление',
        'Notification article type' => 'Тип сообщения с уведомлением',
        'Only for notifications to specified email addresses' => 'Только для уведомлений на указанный адрес электронной почты',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Первые 20 символов темы из последнего сообщения агента',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Первые 5 строк последнего сообщения агента',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Первые 20 символов темы из последнего сообщения клиента',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Первые 5 строк последнего сообщения клиента',

        # Template: AdminPGP
        'PGP Management' => 'Управление подписями PGP',
        'Use this feature if you want to work with PGP keys.' => 'Используйте эту возможность, если хотите работать с PGP-ключами.',
        'Add PGP key' => 'Добавить PGP ключ',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'В данном случае вы можете изменить ключи прямо в конфигурации системы',
        'Introduction to PGP' => 'Введение в PGP',
        'Result' => 'Результат',
        'Identifier' => 'Идентификатор',
        'Bit' => 'Бит',
        'Fingerprint' => 'Цифровой отпечаток',
        'Expires' => 'Истекает',
        'Delete this key' => 'Удалить ключ',
        'Add PGP Key' => 'Добавить PGP ключ',
        'PGP key' => 'PGP-ключ',

        # Template: AdminPackageManager
        'Package Manager' => 'Управление пакетами',
        'Uninstall package' => 'Деинсталлировать пакет',
        'Do you really want to uninstall this package?' => 'Удалить этот пакет?',
        'Reinstall package' => 'Переустановить пакет',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Вы действительно хотите переустановить этот пакет? Все ручные изменения будут потеряны.',
        'Continue' => 'Продолжить',
        'Install' => 'Установить',
        'Install Package' => 'Установить пакет',
        'Update repository information' => 'Обновить информацию репозитория',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            'Не нашли требующуюся функцию? Клиентам заключившим сервисный контракт, OTRS Group предлагает набор расширений(Add-One)',
        'Online Repository' => 'Онлайновый репозиторий',
        'Vendor' => 'Изготовитель',
        'Module documentation' => 'Документация модуля',
        'Upgrade' => 'Обновить',
        'Local Repository' => 'Локальный репозиторий',
        'Uninstall' => 'Удалить',
        'Reinstall' => 'Переустановить',
        'Feature Add-Ons' => 'Адд-Оны с дополнительными возможностями/функциями',
        'Download package' => 'Скачать пакет',
        'Rebuild package' => 'Пересобрать пакет',
        'Metadata' => 'Метаданные',
        'Change Log' => 'Список изменений',
        'Date' => 'Дата',
        'List of Files' => 'Список файлов',
        'Permission' => 'Права доступа',
        'Download' => 'Загрузить',
        'Download file from package!' => 'Загрузить файл из пакета!',
        'Required' => 'Требуется',
        'PrimaryKey' => 'Первичный ключ',
        'AutoIncrement' => 'Автоинкремент',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Файл различий для файла %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Журнал производительности',
        'This feature is enabled!' => 'Данная функция активирована!',
        'Just use this feature if you want to log each request.' => 'Используйте эту функцию, если хотите заносить каждый запрос в журнал',
        'Activating this feature might affect your system performance!' =>
            'Включение этой функции может сказаться на производительности вашей системы',
        'Disable it here!' => 'Отключить функцию!',
        'Logfile too large!' => 'Файл журнала слишком большой!',
        'The logfile is too large, you need to reset it' => 'Логфайл слишком большой, необходимо его очистить',
        'Overview' => 'Обзор',
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

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Управление фильтром PostMaster',
        'Add filter' => 'Добавить фильтр',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Для распределения или фильтрации входящей электронной почты по заголовкам. Возможна также проверка и по регулярным выражениям.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Если вы хотите отфильтровать только по адресам электронной почты, используйте EMAILADDRESS:info@example.com в полях From, To или Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Если вы используете регулярные выражения, вы также можете использовать совпавшее в () значение как [***] в действии "Выставить"',
        'Delete this filter' => 'Удалить этот фильтр',
        'Add PostMaster Filter' => 'Добавить фильтр PostMaster-а',
        'Edit PostMaster Filter' => 'Редактировать фильтр PostMaster-а',
        'Filter name' => 'Имя фильтра',
        'The name is required.' => 'Имя обязательно.',
        'Stop after match' => 'Прекратить проверку после совпадения',
        'Filter Condition' => 'Условие фильтра',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Это поле должно быть корректным регулярным выражением либо буквально совпадающей строкой.',
        'Set Email Headers' => 'Выставить заголовки письма',
        'The field needs to be a literal word.' => 'Это поле должно быть буквальной строкой.',

        # Template: AdminPriority
        'Priority Management' => 'Управление приоритетами',
        'Add priority' => 'Добавить приоритет',
        'Add Priority' => 'Создать приоритет',
        'Edit Priority' => 'Изменить приоритет',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'Фильтр',
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
        'Print' => 'Печать',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Отменить и закрыть окно',
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
        'Customer interface does not support internal article types.' => 'Клиентский интерфейс не поддерживает внутренний тип заметки',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => 'Редактировать это преобразование',
        'Transition Actions' => 'Действия преобразований',
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
        'Manage Queues' => 'Управление очередями',
        'Add queue' => 'Добавить очередь',
        'Add Queue' => 'Добавить Очередь',
        'Edit Queue' => 'Изменить очередь',
        'Sub-queue of' => 'Подочередь очереди',
        'Unlock timeout' => 'Срок блокировки',
        '0 = no unlock' => '0 — без блокировки',
        'Only business hours are counted.' => 'С учетом только рабочего времени.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Если агент блокирует заявку и не закрывает её, когда подошел таймаут разблокировки, заявка будет разблокирована и станет доступна другим агентам.',
        'Notify by' => 'Уведомление от',
        '0 = no escalation' => '0 — без эскалации',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Если к новой заявке не добавляются контакты клиента, либо телефонные, либо внешний email, до истечения указанного здесь времени, заявка эскалируется.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Когда к заявке добавляется сообщение, через клиентский портал или электронной почтой, счетчик времени эскалации по обновлению сбрасывается и начинает отсчитываться заново. Если к заявке не добавляются контакты клиента, либо телефонные, либо внешний email, до истечения указанного здесь времени, заявка эскалируется.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Если заявка не закрыта до истечения указанного здесь времени разрешения, она эскалируется.',
        'Follow up Option' => 'Параметры повторных ответов',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Что делать с повторно полученными ответами клиента на уже закрытую заявку: открыть заново, отвергнуть или создать новую заявку.',
        'Ticket lock after a follow up' => 'Блокировка заявки после получения повторного ответа клиента',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Если заявка закрыта, а клиент снова посылает ответ, заявка будет заблокирована на старого владельца.',
        'System address' => 'Адрес системы',
        'Will be the sender address of this queue for email answers.' => 'Установка адреса отправителя для ответов в этой очереди.',
        'Default sign key' => 'Ключ подписи по умолчанию',
        'The salutation for email answers.' => 'Приветствие для писем',
        'The signature for email answers.' => 'Подпись для писем',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Связь Очереди с Автоответами',
        'Filter for Queues' => 'Фильтр для Очередей',
        'Filter for Auto Responses' => 'Фильтр для Автоответов',
        'Auto Responses' => 'Автоответы',
        'Change Auto Response Relations for Queue' => 'Изменить Автоответ для Очереди',
        'settings' => 'параметры',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Связь Ответов с Очередями',
        'Filter for Responses' => 'Фильтр для Ответов',
        'Responses' => 'Ответы',
        'Change Queue Relations for Response' => 'Изменить Очередь для Ответа',
        'Change Response Relations for Queue' => 'Изменить Ответ для Очереди',

        # Template: AdminResponse
        'Manage Responses' => 'Управление ответами',
        'Add response' => 'Добавить ответ',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            'Ответ суть текст по умолчанию, который помогает вашим агентам быстрее писать ответы клиентам.',
        'Don\'t forget to add new responses to queues.' => 'Не забудьте добавить новые ответы в очереди.',
        'Delete this entry' => 'Удалить эту запись',
        'Add Response' => 'Добавить ответ',
        'Edit Response' => 'Изменить ответ',
        'The current ticket state is' => 'Текущее состояние заявки',
        'Your email address is' => 'Ваш email адрес ',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Связь Ответов с Прикрепленными файлами',
        'Filter for Attachments' => 'Фильтр для Прикрепленных файлов',
        'Change Response Relations for Attachment' => 'Изменить связь Ответов с Прикрепленными файлами',
        'Change Attachment Relations for Response' => 'Изменить связь Прикрепленных файлов с Ответами',
        'Toggle active for all' => 'Переключить для всех',
        'Link %s to selected %s' => 'Связать %s с выбранным %s',

        # Template: AdminRole
        'Role Management' => 'Управление ролями',
        'Add role' => 'Добавить роль',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Создайте роль и добавьте в неё группы. Затем распределите роли по пользователям.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Роли не определены. Пожалуйста, используйте кнопку \'Добавить\' для создания новой роли.',
        'Add Role' => 'Добавить роль',
        'Edit Role' => 'Изменить роль',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Связь ролей с группами',
        'Filter for Roles' => 'Фильтр для Ролей',
        'Roles' => 'Роли',
        'Select the role:group permissions.' => 'Выберите разрешения роль:группа.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Если ничего не выбрано, тогда в этой группе нет прав (для этой роли заявки не будут доступны).',
        'Change Role Relations for Group' => 'Изменить связи с ролями для группы',
        'Change Group Relations for Role' => 'Изменить связи с группами для роли',
        'Toggle %s permission for all' => 'Переключить разрешение «%s» для всех',
        'move_into' => 'переместить',
        'Permissions to move tickets into this group/queue.' => 'Права на перемещение заявок в эту группу/очередь',
        'create' => 'создание',
        'Permissions to create tickets in this group/queue.' => 'Права на создание заявок в этой группе/очереди',
        'priority' => 'приоритет',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Права на смену приоритета заявок в этой группе/очереди',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Связь агентов с ролями',
        'Filter for Agents' => 'Фильтр для Агентов',
        'Agents' => 'Агенты',
        'Manage Role-Agent Relations' => 'Связь ролей с агентами',
        'Change Role Relations for Agent' => 'Изменить связи с ролями для агента',
        'Change Agent Relations for Role' => 'Изменить связи с агентами для роли',

        # Template: AdminSLA
        'SLA Management' => 'Управление SLA',
        'Add SLA' => 'Добавить SLA',
        'Edit SLA' => 'Изменить SLA',
        'Please write only numbers!' => 'Сюда можно писать только числа!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Управление S/MIME',
        'Add certificate' => 'Добавить сертификат',
        'Add private key' => 'Добавить закрытый ключ',
        'Filter for certificates' => 'Фильтр для сертификатов',
        'Filter for SMIME certs' => 'Фильтр для сертификатов SMIME',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Здесь вы можете добавлять связи с вашими приватными сертификатами, которые будут встраиваться в подпись SMIME каждый раз, когда вы используете этот сертификат для подписи электронной почты.',
        'See also' => 'См. также',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Вы можете редактировать сертификаты и закрытые ключи прямо на файловой системе',
        'Hash' => 'Хэш',
        'Create' => 'Создать',
        'Handle related certificates' => 'Управлять связанными сертификатами',
        'Read certificate' => '',
        'Delete this certificate' => 'Удалить сертификат',
        'Add Certificate' => 'Добавить сертификат',
        'Add Private Key' => 'Добавить закрытый ключ',
        'Secret' => 'Пароль',
        'Related Certificates for' => 'Связанные сертификаты для',
        'Delete this relation' => 'Удалить эту связь',
        'Available Certificates' => 'Доступные сертификаты',
        'Relate this certificate' => 'Связать этот сертификат',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'Закрыть окно',

        # Template: AdminSalutation
        'Salutation Management' => 'Управление приветствиями',
        'Add salutation' => 'Добавить приветствие',
        'Add Salutation' => 'Добавить приветствие',
        'Edit Salutation' => 'Редактировать приветствие',
        'Example salutation' => 'Пример приветствия',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Эта опция принудительно запустит Планировщик, даже если процесс всё еще зарегистрирован в базе данных.',
        'Start scheduler' => 'Запустить планировщик.',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'Планировщик не может быть запущен. Проверьте, что он сейчас не работает, и попробуйте снова с опцией принудительного запуска.',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Необходимо включить безопасный режим',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'После установки системы обычно сразу же включают безопасный режим.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Если безопасный режим не активирован, включите его через SysConfig, поскольку ваше приложение уже запущено.',

        # Template: AdminSelectBox
        'SQL Box' => 'Запрос SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Здесь вы можете ввести SQL-запрос и напрямую отправить его в базу данных приложения.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Ошибка синтаксиса в вашем SQL-запросе, пожалуйста, проверьте его еще раз. ',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Отсутствует как минимум один параметр привязки. Пожалуйста, проверьте его.',
        'Result format' => 'Формат вывода',
        'Run Query' => 'Выполнить запрос',

        # Template: AdminService
        'Service Management' => 'Управление сервисами',
        'Add service' => 'Добавить сервис',
        'Add Service' => 'Добавить Сервис',
        'Edit Service' => 'Изменить Сервис',
        'Sub-service of' => 'Подсервис сервиса',

        # Template: AdminSession
        'Session Management' => 'Управление сеансами',
        'All sessions' => 'Все сеансы',
        'Agent sessions' => 'Сеансы агента',
        'Customer sessions' => 'Сеансы клиента',
        'Unique agents' => 'Уникальные агенты',
        'Unique customers' => 'Уникальные клиенты',
        'Kill all sessions' => 'Завершить все сеансы',
        'Kill this session' => 'Завершить сеанс',
        'Session' => 'Сеанс',
        'Kill' => 'Закрыть',
        'Detail View for SessionID' => 'Подробный показ для ID сеанса',

        # Template: AdminSignature
        'Signature Management' => 'Управление подписями',
        'Add signature' => 'Добавить подпись',
        'Add Signature' => 'Добавить Подпись',
        'Edit Signature' => 'Изменить подпись',
        'Example signature' => 'Пример подписи',

        # Template: AdminState
        'State Management' => 'Управление состояниями',
        'Add state' => 'Добавить состояние',
        'Please also update the states in SysConfig where needed.' => 'Пожалуйста, обновите также состояния и в Конфигурации Системы (там, где необходимо).',
        'Add State' => 'Добавить состояние',
        'Edit State' => 'Изменить состояние',
        'State type' => 'Тип состояния',

        # Template: AdminSysConfig
        'SysConfig' => 'Конфигурация системы',
        'Navigate by searching in %s settings' => 'Навигация с помощью поиска в %s настройках',
        'Navigate by selecting config groups' => 'Навигация с помощью выбора групп конфигурации',
        'Download all system config changes' => 'Скачать все изменения в конфигурации системы',
        'Export settings' => 'Экспортировать настройки',
        'Load SysConfig settings from file' => 'Загрузить настройки SysConfig из файла',
        'Import settings' => 'Импортировать настройки',
        'Import Settings' => 'Импортировать Настройки',
        'Please enter a search term to look for settings.' => 'Пожалуйста, введите поисковый запрос для поиска настроек.',
        'Subgroup' => 'Подгруппа',
        'Elements' => 'Элементы',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Редактировать настройки конфигурации',
        'This config item is only available in a higher config level!' =>
            'Этот пункт конфигурации доступен только при более высоком уровне допуска к конфигурации, чем у вас!',
        'Reset this setting' => 'Сбросить эту настройку',
        'Error: this file could not be found.' => 'Ошибка: такой файл не найден.',
        'Error: this directory could not be found.' => 'Ошибка: такой каталог не найден.',
        'Error: an invalid value was entered.' => 'Ошибка: было введено некорректное значение.',
        'Content' => 'Содержание',
        'Remove this entry' => 'Удалить эту запись',
        'Add entry' => 'Добавить запись',
        'Remove entry' => 'Удалить запись',
        'Add new entry' => 'Добавить новую запись',
        'Create new entry' => 'Создать новую запись',
        'New group' => 'Новая группа',
        'Group ro' => 'Группа только чтения',
        'Readonly group' => 'Группа только для чтения',
        'New group ro' => 'Новая группа только для чтения',
        'Loader' => 'Загрузчик',
        'File to load for this frontend module' => 'Файл, который подгружать для этого модуля интерфейса',
        'New Loader File' => 'Новый файл загрузчика',
        'NavBarName' => 'Имя в меню',
        'NavBar' => 'Меню',
        'LinkOption' => 'Параметры в теге ссылки',
        'Block' => 'Раздел',
        'AccessKey' => 'Клавиша доступа',
        'Add NavBar entry' => 'Добавить пункт меню',
        'Year' => 'Год',
        'Month' => 'Месяц',
        'Day' => 'День',
        'Invalid year' => 'Некорректный год',
        'Invalid month' => 'Некорректный месяц',
        'Invalid day' => 'Некорректный день',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Управление системными адресами электронной почты',
        'Add system address' => 'Добавить системный адрес',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Вся входящая электронная почта с этим адресом в To или Cc будет направлена в выбранную очередь.',
        'Email address' => 'Адрес электронной почты',
        'Display name' => 'Отображаемое имя',
        'Add System Email Address' => 'Добавить системный адрес электронной почты',
        'Edit System Email Address' => 'Редактировать системный адрес электронной почты',
        'The display name and email address will be shown on mail you send.' =>
            'Отображаемое имя и адрес электронной почты будут показываться в отправляемой вами почте.',

        # Template: AdminType
        'Type Management' => 'Управление типами заявок',
        'Add ticket type' => 'Добавить тип заявки',
        'Add Type' => 'Добавить тип',
        'Edit Type' => 'Редактировать тип',

        # Template: AdminUser
        'Add agent' => 'Добавить агента',
        'Agents will be needed to handle tickets.' => 'Для обработки заявок потребуются агенты.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Не забудьте добавить новых агентов в группы и/или роли!',
        'Please enter a search term to look for agents.' => 'Пожалуйста, введите поисковый запрос для поиска агентов.',
        'Last login' => 'Последний вход',
        'Switch to agent' => 'Переключиться на агента.',
        'Add Agent' => 'Добавить агента',
        'Edit Agent' => 'Редактирование агента',
        'Firstname' => 'Имя',
        'Lastname' => 'Фамилия',
        'Password is required.' => 'Требуется пароль.',
        'Start' => 'Начало',
        'End' => 'Окончание',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Связь агентов с группами',
        'Change Group Relations for Agent' => 'Изменить связи с группами для агента',
        'Change Agent Relations for Group' => 'Изменить связи с агентами для группы',
        'note' => 'заметка',
        'Permissions to add notes to tickets in this group/queue.' => 'Права на добавление заметок в заявки в этой группе/очереди.',
        'owner' => 'владелец',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Права на смену владельца заявок в этой группе/очереди.',

        # Template: AgentBook
        'Address Book' => 'Адресная книга',
        'Search for a customer' => 'Искать клиента',
        'Add email address %s to the To field' => 'Добавить адрес электронной почты %s в поле To',
        'Add email address %s to the Cc field' => 'Добавить адрес электронной почты %s в поле Cc',
        'Add email address %s to the Bcc field' => 'Добавить адрес электронной почты %s в поле Bcc',
        'Apply' => 'Применить',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID клиента',
        'Customer User' => 'Учетная запись клиента',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Искать клиента',
        'Duplicated entry' => 'Дублирующаяся запись',
        'This address already exists on the address list.' => 'Такой адрес уже существует в списке адресов.',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Дайджест',

        # Template: AgentDashboardCalendarOverview
        'in' => 'в',

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
        '%s %s is available!' => '%s %s доступен',
        'Please update now.' => 'Обновите сейчас',
        'Release Note' => 'Примечание к релизу',
        'Level' => 'Уровень',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Опубликовано %s',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Мои заблокированные заявки',
        'My watched tickets' => 'Заявки в моем списке наблюдения',
        'My responsibilities' => 'Заявки, где я ответственный',
        'Tickets in My Queues' => 'Заявки в моих очередях',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Заявка была заблокирована',
        'Undo & close window' => 'Отменить и закрыть окно',

        # Template: AgentInfo
        'Info' => 'Информация',
        'To accept some news, a license or some changes.' => 'Чтобы принять какие-нибудь новости, лицензию или какие-то изменения.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Связать объект: %s',
        'go to link delete screen' => 'перейти к удалению связи',
        'Select Target Object' => 'Выберите целевой объект',
        'Link Object' => 'Связать объект',
        'with' => 'с',
        'Unlink Object: %s' => 'Отменить привязку объекта: %s',
        'go to link add screen' => 'перейти к добавлению связи',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Измените ваши настройки',

        # Template: AgentSpelling
        'Spell Checker' => 'Проверка орфографии',
        'spelling error(s)' => 'Орфографические ошибки',
        'Apply these changes' => 'Применить изменения',

        # Template: AgentStatsDelete
        'Delete stat' => 'Удалить отчет',
        'Stat#' => 'Отчет#',
        'Do you really want to delete this stat?' => 'Вы действительно хотите удалить этот отчет?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Шаг %s',
        'General Specifications' => 'Общие характеристики',
        'Select the element that will be used at the X-axis' => 'Выберите элемент для использования по горизонтали',
        'Select the elements for the value series' => 'Выберите элементы для группировки значений',
        'Select the restrictions to characterize the stat' => 'Выберите ограничения для конкретизации отчета',
        'Here you can make restrictions to your stat.' => 'Здесь вы можете внести ограничения в вашу статистику',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Если вы снимите флажок параметра «Фиксировано», пользователь, который будет создавать отчеты, сможет менять параметры соответствующего элемента',
        'Fixed' => 'Фиксировано',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Выберите только один пункт или уберите флажок «Фиксировано».',
        'Absolute Period' => 'Абсолютный период',
        'Between' => 'Между',
        'Relative Period' => 'Относительный период',
        'The last' => 'Последний',
        'Finish' => 'Закончить',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Права',
        'You can select one or more groups to define access for different agents.' =>
            'Вы можете выбрать одну или несколько групп для определения доступа для разных агентов.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Некоторые форматы вывода были отключены, так как не установлен по крайней мере один требуемый пакет.',
        'Please contact your administrator.' => 'Пожалуйста, свяжитесь с вашим администратором.',
        'Graph size' => 'Размер графика',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Если вы используете графики, вам необходимо выбрать хотя бы один размер графика.',
        'Sum rows' => 'Сумма строк',
        'Sum columns' => 'Сумма столбцов',
        'Use cache' => 'Использовать кэш',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Большинство отчетов могут кэшироваться. Это увеличит скорость показа отчетов.',
        'If set to invalid end users can not generate the stat.' => 'Если установлен недействительным, конечные пользователи не могут генерировать этот отчет.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Здесь вы можете задать группы значений.',
        'You have the possibility to select one or two elements.' => 'У вас есть возможность выбрать один или два элемента.',
        'Then you can select the attributes of elements.' => 'Затем вы можете выбрать атрибуты элементов.',
        'Each attribute will be shown as single value series.' => 'Каждый атрибут будет показан как одна группа значений.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Если вы не выберете никакого атрибута, для генерации отчета будут использованы все атрибуты элемента, а также новые атрибуты, которые были добавлены после последней конфигурации.',
        'Scale' => 'Масштаб',
        'minimal' => 'Минимальный',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Помните, что масштаб для групп значений должен быть больше, чем масштаб для оси X (например, ось Х — месяц, группы значений — год).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Здесь вы можете задать ось X (по горизонтали). Вы можете выбрать один элемент с помощью переключателя.',
        'maximal period' => 'максимальный период',
        'minimal scale' => 'минимальный масштаб',

        # Template: AgentStatsImport
        'Import Stat' => 'Импортировать отчет',
        'File is not a Stats config' => 'Файл не является файлом конфигурации отчетов',
        'No File selected' => 'Файл не выбран',

        # Template: AgentStatsOverview
        'Stats' => 'Отчеты',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Элемент не выбран.',

        # Template: AgentStatsView
        'Export config' => 'Экспорт конфигурации',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'С помощью полей вводы и выбора вы можете влиять на формат и содержание отчета по статистике.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Конкретные поля и форматы, на которые вы можете влиять, задаются администратором отчетов/статистики.',
        'Stat Details' => 'Подробнее об отчете',
        'Format' => 'Формат',
        'Graphsize' => 'Размер графика',
        'Cache' => 'Кэш',
        'Exchange Axis' => 'Поменять оси',
        'Configurable params of static stat' => 'Конфигурируемые параметры статического отчета',
        'No element selected.' => 'Элементы не выбраны',
        'maximal period from' => 'Максимальный период с',
        'to' => 'по',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Изменить свободный текст заявки',
        'Change Owner of Ticket' => 'Изменить владельца заявки',
        'Close Ticket' => 'Закрыть заявку',
        'Add Note to Ticket' => 'Добавить заметку к заявке',
        'Set Pending' => 'Поставить в ожидание',
        'Change Priority of Ticket' => 'Изменить приоритет заявки',
        'Change Responsible of Ticket' => 'Изменить ответственного заявки',
        'Service invalid.' => 'Некорректный сервис.',
        'New Owner' => 'Новый владелец',
        'Please set a new owner!' => 'Пожалуйста, установите',
        'Previous Owner' => 'Предыдущий владелец',
        'Inform Agent' => 'Уведомить агента',
        'Optional' => 'Необязательно',
        'Inform involved Agents' => 'Уведомить участвующих агентов',
        'Spell check' => 'Проверка орфографии',
        'Note type' => 'Тип заметки',
        'Next state' => 'Следующее состояние',
        'Pending date' => 'Дата ожидания',
        'Date invalid!' => 'Некорректная дата!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Перенаправить заявку',
        'Bounce to' => 'Перенаправить на',
        'You need a email address.' => 'Нужно указать адрес электронной почты.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Требуется корректный адрес электронной почты либо не указывайте локальный адрес.',
        'Next ticket state' => 'Следующее состояние заявки',
        'Inform sender' => 'Информировать отправителя',
        'Send mail!' => 'Оправить письмо!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Массовое действие',
        'Send Email' => 'Отправить письмо',
        'Merge to' => 'Объединить с',
        'Invalid ticket identifier!' => 'Некорректный идентификатор заявки!',
        'Merge to oldest' => 'Объединить с самым старым',
        'Link together' => 'Связать',
        'Link to parent' => 'Связать с родителем',
        'Unlock tickets' => 'Разблокировать заявки',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Создание ответа на заявку',
        'Remove Ticket Customer' => 'Удалить клиента-инициатора заявки',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Пожалуйста, удалите эту запись и введите новую с корректным значением.',
        'Please include at least one recipient' => 'Пожалуйста, включите хотя бы одного получателя.',
        'Remove Cc' => 'Удалить из копии',
        'Remove Bcc' => 'Удалить из скрытой копии',
        'Address book' => 'Адресная книга',
        'Pending Date' => 'Дата ожидания',
        'for pending* states' => 'для состояний "ожидает ..."',
        'Date Invalid!' => 'Неверная дата!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Изменить клиента заявки',
        'Customer user' => 'Учетная запись клиента',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Создать заявку по email',
        'From queue' => 'Из очереди',
        'To customer' => 'Клиенту',
        'Please include at least one customer for the ticket.' => 'Пожалуйста, включите хотя бы одного клиента в заявку.',
        'Get all' => 'Получить всех',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Переслать заявку: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'История по',
        'History Content' => 'Содержимое истории',
        'Zoom view' => 'Подробный показ',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Объединить заявку',
        'You need to use a ticket number!' => 'Вам необходимо использовать номер заявки!',
        'A valid ticket number is required.' => 'Требуется корректный номер заявки.',
        'Need a valid email address.' => 'Требуется верный почтовый адрес.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Переместить заявку',
        'New Queue' => 'Новая очередь',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Выбрать все',
        'No ticket data found.' => 'Не найдено данных о заявках.',
        'First Response Time' => 'Время до первого ответа',
        'Service Time' => 'Время обслуживания',
        'Update Time' => 'Время до изменения заявки',
        'Solution Time' => 'Время до решения заявки',
        'Move ticket to a different queue' => 'Переместить заявку в другую очередь',
        'Change queue' => 'Переместить в другую очередь',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Изменить параметры поиска',
        'Tickets per page' => 'Заявок на страницу',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Эскалация через',
        'Locked' => 'Блокировка',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Создать телефонную заявку',
        'From customer' => 'От клиента',
        'To queue' => 'В очередь',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Телефонный звонок',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Текст письма в исходном виде',
        'Plain' => 'Исходный',
        'Download this email' => 'Скачать это письмо',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Информация о заявке',
        'Accounted time' => 'Потраченное на заявку время',
        'Linked-Object' => 'Связанный объект',
        'by' => 'кем:',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Шаблон поиска',
        'Create Template' => 'Создать шаблон',
        'Create New' => 'Создать новый',
        'Profile link' => 'Ссылка на шаблон',
        'Save changes in template' => 'Сохранить изменения в шаблоне',
        'Add another attribute' => 'Добавить атрибут поиска',
        'Output' => 'Вывод результатов',
        'Fulltext' => 'Полнотекстовый',
        'Remove' => 'Удалить',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Искать в свойствах От, Для, Копия, Тема и тело сообщения, перекрывая другие атрибуты с тем же именем.',
        'Customer User Login' => 'Логин клиента',
        'Created in Queue' => 'Создана в очереди',
        'Lock state' => 'Состояние блокировки',
        'Watcher' => 'Наблюдатель',
        'Article Create Time (before/after)' => 'Время создания сообщения (до/после)',
        'Article Create Time (between)' => 'Время создания сообщения (между)',
        'Ticket Create Time (before/after)' => 'Время создания заявки (до/после)',
        'Ticket Create Time (between)' => 'Время создания заявки (между)',
        'Ticket Change Time (before/after)' => 'Время изменения заявки (до/после)',
        'Ticket Change Time (between)' => 'Время изменения заявки (между)',
        'Ticket Close Time (before/after)' => 'Время закрытия заявки (до/после)',
        'Ticket Close Time (between)' => 'Время закрытия заявки (между)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Поиск в архиве',
        'Run search' => 'Выполнить поиск',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Фильтр сообщений',
        'Article Type' => 'Тип сообщения',
        'Sender Type' => 'Тип отправителя',
        'Save filter settings as default' => 'Сохранить условия фильтра для показа по умолчанию',
        'Archive' => 'Архив',
        'This ticket is archived.' => 'Заявка перемещена в архив.',
        'Linked Objects' => 'Связанные объекты',
        'Article(s)' => 'сообщений',
        'Change Queue' => 'Сменить очередь',
        'There are no dialogs available at this point in the process.' =>
            'Нет диалогов доступных в этой части процесса',
        'This item has no articles yet.' => 'Этот элемент пока не имеет заметок.',
        'Article Filter' => 'Фильтр сообщений',
        'Add Filter' => 'Добавить фильтр',
        'Set' => 'Установить',
        'Reset Filter' => 'Сбросить фильтр',
        'Show one article' => 'Отобразить одно сообщение',
        'Show all articles' => 'Отобразить все сообщения',
        'Unread articles' => 'Непрочитанные сообщения',
        'No.' => '№',
        'Unread Article!' => 'Непрочитанные сообщения!',
        'Incoming message' => 'Входящее сообщение',
        'Outgoing message' => 'Исходящее сообщение',
        'Internal message' => 'Внутреннее сообщение',
        'Resize' => 'Изменить размер',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Загрузить заблокированное содержимое.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Отслеживание',

        # Template: CustomerFooter
        'Powered by' => 'Используется',
        'One or more errors occurred!' => 'Произошла одна или несколько ошибок!',
        'Close this dialog' => 'Закрыть этот диалог',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Невозможо открыть всплывающее окно. Пожалуйста, отключите для этого приложения любые блокировки всплывающих окон.',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript не доступен',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Для работы с OTRS вам потребуется включить JavaScript в вашем браузере.',
        'Browser Warning' => 'Предупреждение о браузере',
        'The browser you are using is too old.' => 'Используемый вами браузер слишком стар.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS работает с большим списком браузеров, пожалуйста, обновитесь до одного из них.',
        'Please see the documentation or ask your admin for further information.' =>
            'Обратитесь к документации или спросите своего администратора для получения дополнительной информации.',
        'Login' => 'Вход',
        'User name' => 'Имя пользователя',
        'Your user name' => 'Ваше имя пользователя',
        'Your password' => 'Ваш пароль',
        'Forgot password?' => 'Забыли пароль?',
        'Log In' => 'Войти',
        'Not yet registered?' => 'Хотите зарегистрироваться?',
        'Sign up now' => 'Войти',
        'Request new password' => 'Прислать новый пароль',
        'Your User Name' => 'Логин',
        'A new password will be sent to your email address.' => 'Новый пароль будет отправлен на ваш адрес электронной почты',
        'Create Account' => 'Создать учетную запись',
        'Please fill out this form to receive login credentials.' => 'Пожалуйста, заполните эту форму, чтобы получить учетные данные для входа',
        'How we should address you' => 'Как мы должны к вам обращаться',
        'Your First Name' => 'Ваше Имя',
        'Please supply a first name' => 'Пожалуйста, введите имя',
        'Your Last Name' => 'Ваша Фамилия',
        'Please supply a last name' => 'Пожалуйста, введите фамилию',
        'Your email address (this will become your username)' => 'Ваш адрес электронной почты (он станет вашим именем пользователя)',
        'Please supply a' => 'Пожалуйста, введите',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Редактировать персональные настройки',
        'Logout %s' => 'Выход %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Соглашение об уровне сервиса',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Добро пожаловать!',
        'Please click the button below to create your first ticket.' => 'Пожалуйста, еажмите на кнопку ниже, чтобы создать вашу первую заявку.',
        'Create your first ticket' => 'Создать вашу первую заявку.',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Печать заявки.',

        # Template: CustomerTicketSearch
        'Profile' => 'Параметры',
        'e. g. 10*5155 or 105658*' => 'например, 10*5155 или 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Полнотекстовый поиск в заявке (например, "Иван*в" или "Петр*")',
        'Recipient' => 'Получатель',
        'Carbon Copy' => 'Копия',
        'Time restrictions' => 'Временные рамки',
        'No time settings' => 'Без указания времени',
        'Only tickets created' => 'Заявки созданные',
        'Only tickets created between' => 'Заявки, созданные в промежутке',
        'Ticket archive system' => 'Система архивирования заявок',
        'Save search as template?' => 'Сохранить параметры поиска как шаблон?',
        'Save as Template?' => 'Сохранить как шаблон?',
        'Save as Template' => 'Сохранить как шаблон',
        'Template Name' => 'Имя шаблона',
        'Pick a profile name' => 'Выберите имя шаблона',
        'Output to' => 'Вывести как',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'из',
        'Page' => 'Страница',
        'Search Results for' => 'Результаты поиска для',

        # Template: CustomerTicketZoom
        'Show  article' => 'Показать сообщение',
        'Expand article' => 'Развернуть сообщение',
        'Information' => 'Сведения',
        'Next Steps' => 'Далее',
        'Reply' => 'Ответить',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Некорректная дата (нужна дата в будущем)!',
        'Previous' => 'Назад',
        'Sunday' => 'Воскресенье',
        'Monday' => 'Понедельник',
        'Tuesday' => 'Вторник',
        'Wednesday' => 'Среда',
        'Thursday' => 'Четверг',
        'Friday' => 'Пятница',
        'Saturday' => 'Суббота',
        'Su' => 'Вс',
        'Mo' => 'Пн',
        'Tu' => 'Вт',
        'We' => 'Ср',
        'Th' => 'Чт',
        'Fr' => 'Пт',
        'Sa' => 'Сб',
        'Open date selection' => 'Открыть выбор даты',

        # Template: Error
        'Oops! An Error occurred.' => 'Ой! Возникла ошибка.',
        'Error Message' => 'Текст ошибки',
        'You can' => 'Вы можете',
        'Send a bugreport' => 'Отправить сообщение об ошибке',
        'go back to the previous page' => 'перейти на предыдущую страницу',
        'Error Details' => 'Детали ошибки',

        # Template: Footer
        'Top of page' => 'В начало страницы',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Если вы сейчас покинете эту страницу, будут также закрыты и все всплывающие окна!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Всплывающее окно с таким экраном уже открыто. Хотите закрыть тот и открыть вместо него этот?',
        'Please enter at least one search value or * to find anything.' =>
            'Пожалуйста, введите хотя бы одно значение для поиска, или * (звездочку) для поиска чего угодно.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => 'Полнотекстовый поиск',
        'CustomerID Search' => 'Поиск по ID клиента',
        'CustomerUser Search' => 'Поиск по логину',
        'You are logged in as' => 'Вы вошли как',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript недоступен',
        'Database Settings' => 'Настройки базы данных',
        'General Specifications and Mail Settings' => 'Общие указания и настройки почты',
        'Registration' => 'Регистрация',
        'Welcome to %s' => 'Добро пожаловать в %s',
        'Web site' => 'Веб-сайт',
        'Database check successful.' => 'База данных проверена успешно.',
        'Mail check successful.' => 'Почта проверена успешно.',
        'Error in the mail settings. Please correct and try again.' => 'Ошибка в настройках почты. Пожалуйста, исправьте и попробуйте снова.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Конфигурация исходящей почты',
        'Outbound mail type' => 'Тип исходящей почты',
        'Select outbound mail type.' => 'Выберите протокол/способ для отправки исходящей почты.',
        'Outbound mail port' => 'Порт исходящей почты',
        'Select outbound mail port.' => 'Выберите порт исходящей почты.',
        'SMTP host' => 'SMTP-сервер',
        'SMTP host.' => 'SMTP-сервер.',
        'SMTP authentication' => 'SMTP-аутентификация',
        'Does your SMTP host need authentication?' => 'SMTP сервер требует аутентификацию?',
        'SMTP auth user' => 'Пользователь для SMTP-аутентификации',
        'Username for SMTP auth.' => 'Имя пользователя для использования в SMTP-аутентификации.',
        'SMTP auth password' => 'Пароль для SMTP-аутентификации',
        'Password for SMTP auth.' => 'Пароль для использования в SMTP-аутентификации',
        'Configure Inbound Mail' => 'Конфигурация входящей почты',
        'Inbound mail type' => 'Тип входящей почты',
        'Select inbound mail type.' => 'Выберите протокол/способ для получения входящей почты.',
        'Inbound mail host' => 'Почтовый сервер для входящей почты',
        'Inbound mail host.' => 'Почтовый сервер для входящей почты.',
        'Inbound mail user' => 'Имя пользователя для входящей почты',
        'User for inbound mail.' => 'Имя пользователя для входящей почты.',
        'Inbound mail password' => 'Пароль для входящей почты',
        'Password for inbound mail.' => 'Пароль для входящей почты.',
        'Result of mail configuration check' => 'Результаты проверки настроек почты',
        'Check mail configuration' => 'Проверить настройки почты',
        'Skip this step' => 'Пропустить этот шаг',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Пропуск этого шага автоматически пропустит и регистрацию вашей OTRS. Вы действительно хотите продолжить?',

        # Template: InstallerDBResult
        'False' => 'Облом',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Если для администратора базы данных установлен пароль, укажите его здесь. Если нет, оставьте поле пустым. Из соображений безопасности мы рекомендуем создать пароль администратора. Информацию по этой теме можно найти в документации по используемой базе данных',
        'Currently only MySQL is supported in the web installer.' => 'На текущий момент веб-инсталлятор поддерживает только MySQL.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Если вы хотите инсталлировать OTRS с другим типом базы данных, обратитесь к файлу README.database.',
        'Database-User' => 'Пользователь базы данных',
        'New' => 'Новое',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'Для этой системы OTRS будет создан новый пользователь базы данных с ограниченными правами.',
        'default \'hot\'' => 'По умолчанию: «hot»',
        'DB host' => 'БД--- сервер',
        'Check database settings' => 'Проверить настройки БД',
        'Result of database check' => 'Результат проверки базы данных',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Чтобы использовать OTRS, выполните в командной строке под правами root следующую команду:',
        'Restart your webserver' => 'Перезапустите ваш веб-сервер',
        'After doing so your OTRS is up and running.' => 'После этих действий ваша система OTRS станет запущенной и работающей.',
        'Start page' => 'Главная страница',
        'Your OTRS Team' => 'Команда разработчиков OTRS',

        # Template: InstallerLicense
        'Accept license' => 'Принимаю условия лицензии',
        'Don\'t accept license' => 'Не принимаю условия лицензии',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Организация',
        'Position' => 'Сфера деятельности',
        'Complete registration and continue' => 'Завершить регистрацию и продолжить',
        'Please fill in all fields marked as mandatory.' => 'Пожалуйста, заполните все поля, отмеченные как обязательные.',

        # Template: InstallerSystem
        'SystemID' => 'Системный ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Идентификатор системы. Каждый номер заявки и каждый идентификатор HTTP-сессии - содержат этот номер.',
        'System FQDN' => 'Системное FQDN',
        'Fully qualified domain name of your system.' => 'Полное доменное имя вашей системы.',
        'AdminEmail' => 'Адрес администратора',
        'Email address of the system administrator.' => 'Адрес электронной почты администратора',
        'Log' => 'Журнал',
        'LogModule' => 'Модуль журнала ',
        'Log backend to use.' => 'Какой бэкенд использовать для собственно записи журнала.',
        'LogFile' => 'Файл журнала',
        'Log file location is only needed for File-LogModule!' => 'Указание расположения файла журнала требуется только для ',
        'Webfrontend' => 'Веб-интерфейс',
        'Default language' => 'Язык по умолчанию',
        'Default language.' => 'Язык по умолчанию.',
        'CheckMXRecord' => 'Проверять записи MX',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Вручную вводимые адреса электронной почты будут проверяться на MX-записи в DNS. Не используйте эту опцию, если ваш DNS-сервер медленный или не разрешает публичные адреса.',

        # Template: LinkObject
        'Object#' => 'Объект#',
        'Add links' => 'Добавить связи',
        'Delete links' => 'Удалить связи',

        # Template: Login
        'Lost your password?' => 'Забыли свой пароль',
        'Request New Password' => 'Запросить новый пароль',
        'Back to login' => 'Обратно ко входу',

        # Template: Motd
        'Message of the Day' => 'Новость дня',

        # Template: NoPermission
        'Insufficient Rights' => 'Недостаточно прав',
        'Back to the previous page' => 'Обратно на предыдущую страницу',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Показать первую страницу',
        'Show previous pages' => 'Показать предыдущие страницы',
        'Show page %s' => 'Показать страницу %s',
        'Show next pages' => 'Показать следующие страницы',
        'Show last page' => 'Показать последнюю страницу',

        # Template: PictureUpload
        'Need FormID!' => 'Требуется FormID!',
        'No file found!' => 'Файл не найден!',
        'The file is not an image that can be shown inline!' => 'Этот файл не может быть отображен как часть текста!',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'напечатано',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Тестовая страница OTRS',
        'Welcome %s' => 'Здравствуйте, %s',
        'Counter' => 'Счетчик',

        # Template: Warning
        'Go back to the previous page' => 'Перейти на предыдущую страницу',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'AccountedTime' => '',
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
        'Agent Notifications' => 'Уведомление агентов',
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
        'Agents <-> Groups' => 'Агенты <-> Группы',
        'Agents <-> Roles' => 'Агенты <-> Роли',
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
        'Attachments <-> Responses' => 'Прикрепленные файлы <-> Ответы',
        'Auto Responses <-> Queues' => 'Автоответы <-> Очередь',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
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
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Изменить пароль',
        'Change queue!' => '',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => '',
        'Company Tickets' => 'Заявки компании',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Создание и управление Соглашениями об Уровне Сервиса (SLA-ми).',
        'Create and manage agents.' => 'Создание и управление агентами.',
        'Create and manage attachments.' => 'Создание и управление вложениями.',
        'Create and manage companies.' => 'Создание и управление компаниями.',
        'Create and manage customers.' => 'Создание и управление клиентами.',
        'Create and manage dynamic fields.' => 'Создание и управление динамическими полями.',
        'Create and manage event based notifications.' => 'Создание и управление уведомлениями по событию.',
        'Create and manage groups.' => 'Создание и управление группами.',
        'Create and manage queues.' => 'Создание и управление очередями.',
        'Create and manage response templates.' => 'Создание и управление шаблонами ответов.',
        'Create and manage responses that are automatically sent.' => 'Создание и управление автоответами.',
        'Create and manage roles.' => 'Создание и управление ролями.',
        'Create and manage salutations.' => 'Создание и управление приветствиями.',
        'Create and manage services.' => 'Создание и управление сервисами.',
        'Create and manage signatures.' => 'Создание и управление подписями.',
        'Create and manage ticket priorities.' => 'Создание и управление приоритетами заявок.',
        'Create and manage ticket states.' => 'Создание и управление состояними заявок.',
        'Create and manage ticket types.' => 'Создание и управление типами заявок.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Создать заявку по email (исходящую) и отправить ее',
        'Create new phone ticket (inbound)' => 'Создать телефонную заявку (входящую)',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Клиенты',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Клиенты <-> Группы',
        'Customers <-> Services' => 'Клиенты <-> Сервисы',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
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
        'Default skin for interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
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
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
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
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
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
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
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
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
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
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
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
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
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
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
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
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
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
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
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
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
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
        'Email Addresses' => 'Адреса email',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Просмотр эскалаций',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => '',
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
        'Filter incoming emails.' => 'Фильтрация входящей почты.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Язык интерфейса',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Тема интерфеса',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => 'Планировщик задач',
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
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Если включено, экраны обзоров (дайджест, просмотр заблокированных, просмотр очереди) будут автоматически обновляться по истечении указанного времени.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
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
        'Interface language' => 'Язык интерфейса',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Связать агентов с группами.',
        'Link agents to roles.' => 'Связать агентов с ролями.',
        'Link attachments to responses templates.' => 'Связать прикрепленный файлы с ответами.',
        'Link customers to groups.' => 'Связать клиентов с группами.',
        'Link customers to services.' => 'Связать клиентов с сервисами.',
        'Link queues to auto responses.' => 'Связать очереди с автоответами.',
        'Link responses to queues.' => 'Связать ответы с очередями.',
        'Link roles to groups.' => 'Связать роли с группами.',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => 'Прозрачная картинка',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'Управления PGP ключами для шифрования почтовых сообщений.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Управление POP3 или IMAP учетными записями для получения почтовых сообщений.',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => 'Управление активными сеансами.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Управление повторяющимися задачами.',
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
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => 'Модуль для проверки прав клиента.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => 'Модуль для проверки агента ответственного за заявку.',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => 'Модуль для проверки владельца заявки.',
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
            'Модуль для формирования статистки по времени реакции и разрешения заявки.',
        'Module to generate ticket statistics.' => 'Модуль для формирования статистки по заявкам.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => 'Мои заявки',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Новая заявка по email',
        'New phone ticket' => 'Новая телефонная заявка',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Уведомление о событии',
        'Number of displayed tickets' => 'Количество отображаемых заявок',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Обзор эскалированных заявок',
        'Overview Refresh Time' => 'Время обновления обзоров',
        'Overview of all open Tickets.' => 'Обзор всех заявок',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Загрузить PGP ключ',
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
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Просмотр очередей',
        'Refresh Overviews after' => 'Обновлять обзоры каждые',
        'Refresh interval' => 'Интервал обновления',
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
        'Responses <-> Queues' => 'Ответы <-> Очередь',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Роли <-> Группы',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Тема интерфейса',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Отправлять мне уведомление, если клиент прислал отклик, а я владелец заявки, или если заявка разблокирована в одной из моих очередей.',
        'Send notifications to users.' => 'Отправить уведомление пользователям.',
        'Send ticket follow up notifications' => 'Отправлять уведомления об откликах в заявках',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Отправлять уведомления агентам об откликах только владельцу, если заявка разблокирована (по умолчанию уведомляются все агенты).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => 'Задать адрес отправителя для этой системы.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
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
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
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
        'Skin' => 'Окрас',
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
        'Statistics' => 'Отчеты',
        'Status view' => 'Просмотр статусов',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Textarea' => '',
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
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Обзор заявок',
        'TicketNumber' => '',
        'Tickets' => 'Заявки',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => 'Типы',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'Обновление и расширение системы с помощью программных пакетов.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Просмотр результатов измерения производительности.',
        'View system log messages.' => 'Просмотр системных сообщений.',
        'Wear this frontend skin' => 'Использовать этот окрас интерфейса',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Выбор очередей, которые вас интересуют. Вы также будете уведомляться по электронной почте, если эта функция включена.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        '%s Tickets affected! Do you really want to use this job?' => '%s заявок будет изменено! Выполнить это задание?',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' =>
            'Проверять MX-записи домена, на который отправляется email при ответе. Не используйте эту возможность, если сервер с OTRS доступен по слабому каналу!',
        '(Email of the system admin)' => 'Адрес электронной почты системного администратора',
        '(Full qualified domain name of your system)' => 'Полное доменное имя (FQDN) вашей системы',
        '(Logfile just needed for File-LogModule!)' => 'Файл журнала необходим только для модуля журнала!',
        '(Note: It depends on your installation how many dynamic objects you can use)' =>
            'Замечание: количество динамических объектов зависит от системы.',
        '(Note: Useful for big databases and low performance server)' => 'Примечание: полезно для больших баз данных или для серверов с низкой производительностью.',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' =>
            'Идентификатор системы. Каждый номер заявки и сеанс начинаться с этого числа)',
        '(Used default language)' => 'Используемый язык по умолчанию',
        '(Used log backend)' => 'Используемый модуль журнала',
        '(Used ticket number format)' => 'Используемый формат номеров заявок',
        '3 Month' => '3 месяца',
        '5 Day' => '5 дней',
        '7 Day' => '7 дней',
        'A message must be spell checked!' => 'Сообщение должно быть проверено на ошибки!',
        'A message should have a To: recipient!' => 'В письме должен быть указан получатель!',
        'A message should have a body!' => 'Сообщение не может быть пустым!',
        'A message should have a customer!' => 'Сообщение должно быть от клиента!',
        'A message should have a subject!' => 'Сообщение должно иметь поле темы!',
        'A new password will be sent to your e-mail adress.' => 'Новый пароль будет отослан на указанный e-mail.',
        'A required field is:' => 'Необходимое поле:',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Ответ — шаблон ответа клиенту',
        'A ticket should be associated with a queue!' => 'Заявке должна быть назначена очередь!',
        'A web calendar' => 'Календарь',
        'A web mail client' => 'Почтовый веб-клиент',
        'About OTRS' => 'О OTRS',
        'Absolut Period' => 'Точный период',
        'Add Customer User' => 'Добавить клиента',
        'Add System Address' => 'Добавить системный адрес',
        'Add User' => 'Добавить пользователя',
        'Add a new Agent.' => 'Добавить пользователя',
        'Add a new Customer Company.' => 'Добавить компанию клиента',
        'Add a new Group.' => 'Добавить новую группу',
        'Add a new Notification.' => 'Добавить уведомление',
        'Add a new Priority.' => 'Создать приоритет.',
        'Add a new Role.' => 'Добавить роль',
        'Add a new SLA.' => 'Добавить SLA',
        'Add a new Salutation.' => 'Добавить приветствие',
        'Add a new Service.' => 'Добавить сервис',
        'Add a new Signature.' => 'Добавить подпись',
        'Add a new State.' => 'Добавить статус',
        'Add a new System Address.' => 'Добавить системный адрес',
        'Add a new Type.' => 'Добавить тип',
        'Add a new salutation' => 'Добавить новое приветствие',
        'Add a note to this ticket!' => 'Добавить заметку к заявке!',
        'Add new attachment' => 'Добавить новое вложение',
        'Add note to ticket' => 'Добавить заметку к заявке',
        'Added User "%s"' => 'Добавлен пользователь "%s"',
        'Admin-Area' => 'Администрирование системы',
        'Admin-Email' => 'Email администратора',
        'Admin-Password' => 'Пароль администратора',
        'Admin-User' => 'Администратор',
        'Admin-password' => 'Пароль администратора',
        'Agent Mailbox' => 'Почтовый ящик пользователя',
        'Agent Preferences' => 'Настройки пользователя',
        'Agent based' => 'Агент',
        'Agent-Area' => 'Пользователь',
        'All Agents' => 'Все агенты',
        'All Customer variables like defined in config option CustomerUser.' =>
            'Все дополнительные поля информации о клиенте определяются параметрах пользователя.',
        'All customer tickets.' => 'Все заявки клиента.',
        'All email addresses get excluded on replaying on composing an email.' =>
            'Все адреса, исключаемые при ответе на письмо',
        'All email addresses get excluded on replaying on composing and email.' =>
            'Все дополнительные адреса электронной почты будут исключаться в ответном письме.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' =>
            'Все входящие сообщения с этим получателем будут направлены в заданную очередь',
        'All messages' => 'Все сообщения',
        'All new tickets!' => 'Все новые заявки',
        'All tickets where the reminder date has reached!' => 'Все заявки с наступившей датой напоминания',
        'All tickets which are escalated!' => 'Все эскалированные заявки',
        'Allocate CustomerUser to service' => 'Привязать клиента к сервисам',
        'Allocate services to CustomerUser' => 'Привязать сервисы к клиенту',
        'Answer' => 'Ответ',
        'Article Create Times' => 'Время создания сообщения',
        'Article created' => 'Сообщение создано',
        'Article created between' => 'Сообщение создано в период',
        'Article filter settings' => 'Фильтр сообщений',
        'ArticleID' => 'ID заметки',
        'Attach' => 'Приложить файл',
        'Attribute' => 'Атрибут',
        'Auto Response From' => 'Автоматический ответ от',
        'Bounce ticket' => 'Пересылка заявки',
        'Can not create link with %s!' => 'Невозможно создать связь с «%s»!',
        'Can not delete link with %s!' => 'Невозможно удалить связь с «%s»!',
        'Can\'t update password, invalid characters!' => 'Невозможно сменить пароль, неверная кодировка!',
        'Can\'t update password, must be at least %s characters!' => 'Невозможно сменить пароль, пароль должен быть не менее %s символов!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' =>
            'Невозможно сменить пароль, необходимо 2 символа в нижнем и 2 — в верхнем регистрах!',
        'Can\'t update password, needs at least 1 digit!' => 'Невозможно сменить пароль, должна присутствовать как минимум 1 цифра!',
        'Can\'t update password, needs at least 2 characters!' => 'Невозможно сменить пароль, необходимо минимум 2 символа!',
        'Can\'t update password, your new passwords do not match! Please try again!' =>
            'Невозможно сменить пароль, пароли не совпадают!',
        'Category Tree' => 'Иерархия категорий',
        'Cc: (%s) added database email!' => 'Cc: (%s) добавлен e-mail базы данных!',
        'Change %s settings' => 'Изменить параметры: %s',
        'Change Times' => 'Время изменений',
        'Change free text of ticket' => 'Изменить свободный текст заявки',
        'Change owner of ticket' => 'Изменить владельца заявки',
        'Change priority of ticket' => 'Изменить приоритет заявки',
        'Change responsible of ticket' => 'Сменить ответственного за заявку',
        'Change setting' => 'Изменить параметры',
        'Change the ticket customer!' => 'Изменить клиента заявки!',
        'Change the ticket owner!' => 'Изменить владельца заявки!',
        'Change the ticket priority!' => 'Изменить приоритет заявки!',
        'Change the ticket responsible!' => 'Изменить ответственного заявки!',
        'Change user <-> group settings' => 'Группы пользователей',
        'Change users <-> roles settings' => 'Изменить распределения ролей по пользователям',
        'ChangeLog' => 'Журнал изменений',
        'Child-Object' => 'Объект-потомок',
        'Clear From' => 'Очистить форму',
        'Clear To' => 'Очистить',
        'Click here to report a bug!' => 'Отправить сообщение об ошибке!',
        'Close Times' => 'Время закрытия',
        'Close this ticket!' => 'Закрыть заявку!',
        'Close ticket' => 'Закрыть заявку',
        'Close type' => 'Тип закрытия',
        'Close!' => 'Закрыть!',
        'Collapse View' => 'Кратко',
        'Comment (internal)' => 'Комментарий (внутренний)',
        'CompanyTickets' => 'Заявки компании',
        'Compose Answer' => 'Создать ответ',
        'Compose Email' => 'Написать письмо',
        'Compose Follow up' => 'Написать ответ',
        'Config Options' => 'Параметры конфигурации',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Параметры конфигурации (например, <OTRS_CONFIG_HttpType>).',
        'Contact customer' => 'Связаться с клиентом',
        'Context Settings' => 'Параметры контекста',
        'Country{CustomerUser}' => 'Страна{ПользовательКлиента}',
        'Create New Template' => 'Создать новый шаблон',
        'Create Times' => 'Время создания',
        'Create and manage notifications that are sent to agents.' => 'Создание и управление уведомлениями для агентов.',
        'Create new Phone Ticket' => 'Создать телефонную заявку',
        'Create new database' => 'Создать новую базы данных',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' =>
            'Создать новые группы для назначения прав доступа группам агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
        'Create your first Ticket' => 'Добавить первую заявку',
        'CreateTicket' => 'Создание заявки',
        'Customer Data' => 'Учетные данные клиента',
        'Customer Move Notify' => 'Извещать клиента о перемещении',
        'Customer Owner Notify' => 'Извещать клиента о смене владельца',
        'Customer State Notify' => 'Извещать клиента об изменении статуса',
        'Customer User Management' => 'Управление пользователями (для клиентов)',
        'Customer Users <-> Groups' => 'Группы клиентов',
        'Customer Users <-> Groups Management' => 'Управление группами клиентов',
        'Customer Users <-> Services Management' => 'Клиенты <-> Сервисы',
        'Customer history' => 'История клиента',
        'Customer history search' => 'Поиск по истории клиента',
        'Customer history search (e. g. "ID342425").' => 'Поиск по клиенту (например, «ID342425»).',
        'Customer user will be needed to have a customer history and to login via customer panel.' =>
            'Учетная запись клиента необходима для ведения истории клиента и для доступа к клиентской панели.',
        'CustomerUser' => 'Клиент',
        'D' => 'D',
        'DB connect host' => 'Сервер базы данных',
        'Days' => 'Дни',
        'Default Charset' => 'Кодировка по умолчанию',
        'Default Language' => 'Язык по умолчанию',
        'Delete this ticket!' => 'Удалить заявку!',
        'Detail' => 'Подробно',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Не нашли требуемую возможность/функцию? OTRS Group предоставляет купившим подписку клиентам эксклюзивные Адд-Оны:',
        'Diff' => 'Diff',
        'Discard all changes and return to the compose screen' => 'Отказаться от всех изменений и вернуться в окно составления письма',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' =>
            'Обрабатывать или отфильтровывать входящие письма на основе полей заголовка! Возможно использование регулярных выражений.',
        'Do you really want to delete this Object?' => 'Удалить этот объект?',
        'Do you really want to reinstall this package (all manual changes get lost)?' =>
            'Переустановить этот пакет (все изменения, сделанные вручную, будут утеряны)?',
        'Don\'t forget to add a new response a queue!' => 'Не забудьте добавить ответ для очереди!',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Не забудьте добавить нового пользователя в группы и роли!',
        'Don\'t forget to add a new user to groups!' => 'Не забудьте добавить нового пользователя в группы!',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'Не работайте с UserID 1 (системная учетная запись)! Создайте другого пользователя!',
        'Download Settings' => 'Загрузить параметры',
        'Download all system config changes.' => 'Загрузить все изменения конфигурации, внесенные в систему',
        'Drop Database' => 'Удалить базу данных',
        'Dynamic-Object' => 'Динамический объект',
        'Edit Article' => 'Редактировать заявку',
        'Edit Customers' => 'Редактировать клиентов',
        'Edit default services.' => 'Сервисы по умолчанию',
        'Email based' => 'Адрес электронной почты',
        'Escaladed Tickets' => 'Эскалированные заявки',
        'Escalation - First Response Time' => 'Эскалация — время первого ответа',
        'Escalation - Solution Time' => 'Эскалация — время решения',
        'Escalation - Update Time' => 'Эскалация — время обновления',
        'Escalation Times' => 'Время эскалации',
        'Escalation time' => 'Время до эскалации заявки',
        'Event is required!' => 'Событие обязательно!',
        'Expand View' => 'Подробно',
        'Explanation' => 'Пояснение',
        'Export Config' => 'Экспорт конфигурации',
        'FileManager' => 'Управление файлами',
        'Filelist' => 'Список файлов',
        'Filtername' => 'Имя фильтра',
        'Follow up' => 'Ответ',
        'Follow up notification' => 'Уведомление об обновлениях',
        'For more info see:' => 'Дополнительная информация находится по адресу:',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'Для очень сложных отчетов, возможно, необходимо использовать временный файл',
        'Form' => 'Форма',
        'Foward ticket: ' => 'Переслать заявку',
        'Frontend' => 'Режим пользователя',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Полнотекстовый поиск в заявке (например, «Mar*in» или «Baue*»)',
        'Go' => 'Выполнить',
        'Group Ro' => 'Группа только для чтения',
        'Group based' => 'Группа',
        'Group selection' => 'Выбор группы',
        'Hash/Fingerprint' => 'Хэш/Отпечаток пальца',
        'Have a lot of fun!' => 'Развлекайтесь!',
        'Help' => 'Помощь',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Здесь вы можете определить группы значений. У вас есть возможность выбрать один или два элемента. Затем вы можете выбрать атрибуты элементов. Значения каждого атрибута будет показаны как отдельная группа значений. Если вы не выберите ни одного атрибута, в отчете будут использованы все доступные атрибуты.',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Здесь вы можете определить значения для оси X. Выберите один элемент, используя переключатель. Если вы не выберите ни одного атрибута, в отчете будут использованы все доступные атрибуты.',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Здесь вы можете определить ось X. У вас есть возможность выбрать один или два элемента. Затем вы можете выбрать атрибуты элементов. Значения каждого атрибута будет показаны как отдельная последовательность значений. Если вы не выберите ни одного атрибута, в отчете будут использованы все доступные атрибуты.',
        'Here you can insert a description of the stat.' => 'Здесь вы можете написать описание отчета',
        'Here you can select the dynamic object you want to use.' => 'Здесь вы можете выбрать динамический объект, который вы хотите использовать',
        'Home' => 'Главная страница',
        'How we should adress you' => 'Как нам к вам обращаться',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Если безопасный режим не включен, включите его в конфигурации системы',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' =>
            'Если временный файл доступен, будет показан список, из которого вы можете выбрать файл.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' =>
            'Если заявка закрыта, а клиент прислал сообщение, то заявка будет заблокирована для предыдущего владельца',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' =>
            'Если заявка не будет обслужена в установленное время, показывать только эту заявку',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' =>
            'Если агент заблокировал заявку и не отправил ответ клиенту в течение установленного времени, то заявка автоматически разблокируется и станет доступной для остальных агентов.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' =>
            'Если ничего не выбрано, то заявки будут недоступны для пользователя',
        'If you need the sum of every column select yes.' => 'Если вам необходим показ суммы по каждому столбцу, выберите «Да»',
        'If you need the sum of every row select yes' => 'Если вам необходим показ суммы по каждой строке, выберите «Да»',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Если вы используете регулярные выражения, вы можете использовать переменные в () как [***] при установке значений',
        'Image' => 'Значок',
        'Important' => 'Важно',
        'In this form you can select the basic specifications.' => 'В данной форме вы можете выбрать основные требования.',
        'Information about the Stat' => 'Информация об отчете',
        'Insert of the common specifications' => 'Вставьте дополнительные требования',
        'Invalid SessionID!' => 'Неверный идентификатор сессии!',
        'Involved' => 'Привлечение',
        'Is Job Valid' => 'Данная задача действительна',
        'Is Job Valid?' => 'Данная задача действительна?',
        'It\'s useful for ASP solutions.' => 'Это подходит для провайдеров.',
        'It\'s useful for a lot of users and groups.' => 'Это полезно при использовании множества пользователей и групп',
        'Job-List' => 'Список задач',
        'Jule' => 'Июль',
        'Keyword' => 'Ключевое слово',
        'Keywords' => 'Ключевые слова',
        'Last update' => 'Последнее изменение',
        'Link Table' => 'Таблица связей',
        'Link auto responses to queues.' => 'Связать автоответы с очередями.',
        'Link groups to roles.' => 'Связать группы с ролями',
        'Link this ticket to an other objects!' => 'Связать заявку с другими объектами!',
        'Link this ticket to other objects!' => 'Связать заявку с другими объектами!',
        'Link to Parent' => 'Связать с родительским объектом',
        'Linked as' => 'Связан как',
        'Load Settings' => 'Применить конфигурацию из файла',
        'Lock it to work on it!' => 'Заблокировать, чтобы рассмотреть заявку!',
        'Locked tickets' => 'Заблокированные заявки',
        'Logfile' => 'Файл журнала',
        'Logfile too large, you need to reset it!' => 'Файл журнала слишком большой, вам нужно очистить его!',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Ошибка идентификации! Указано неправильное имя или пароль!',
        'Logout successful. Thank you for using OTRS!' => 'Вы успешно вышли из системы. Благодарим за пользование системой OTRS !',
        'Lookup' => 'Поиск',
        'Mail Management' => 'Управление почтой',
        'Mailbox' => 'Почтовый ящик',
        'Mart' => 'Март',
        'Match' => 'Соответствует',
        'Max. displayed tickets' => 'Заявок на страницу',
        'Max. shown Tickets a page' => 'Заявок на страницу',
        'Merge this ticket!' => 'Объединить заявку!',
        'Message for new Owner' => 'Сообщение для нового владельца',
        'Message sent to' => 'Сообщение отправлено для',
        'Misc' => 'Дополнительно',
        'Modified' => 'Изменено',
        'Modules' => 'Модули',
        'Move notification' => 'Уведомление о перемещении',
        'Multiple selection of the output format.' => 'Выбор форматов вывода.',
        'My Responsible' => 'Моя ответственность',
        'MyTickets' => 'Мои заявки',
        'Name is required!' => 'Название обязательно!',
        'Need a valid email address or don\'t use a local email address' =>
            'Требуется корректный адрес электронной почты либо не указывайте локальный адрес',
        'New Agent' => 'Новый агент',
        'New Customer' => 'Новый клиент',
        'New Group' => 'Новая группа',
        'New Group Ro' => 'Новая группа только для чтения',
        'New Password' => 'Новый пароль',
        'New Priority' => 'Новый приоритет',
        'New SLA' => 'Новый SLA',
        'New Service' => 'Новая служба',
        'New State' => 'Новый статус',
        'New Ticket Lock' => 'Новый статус заявки',
        'New TicketFreeFields' => 'Новые свободные поля заявки',
        'New Title' => 'Новое название',
        'New Type' => 'Новый тип',
        'New account created. Sent Login-Account to %s.' => 'Создана новая учетная запись. Данные для входа в систему отправлены по адресу: %s.',
        'New messages' => 'Новые сообщения',
        'New password again' => 'Повторите новый пароль',
        'Next Week' => 'На неделе',
        'No * possible!' => 'Нельзя использовать символ «*» !',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' =>
            'Нет пакетов для запрошенного фреймворка в этом сетевом репозитории, но есть пакеты для других фреймворков!',
        'No Packages or no new Packages in selected Online Repository!' =>
            'Нет пакетов или новых пакетов в выбранном сетевом репозитории!',
        'No Permission' => 'Недостаточно прав доступа',
        'No Ticket has been written yet.' => 'Ни одной заявки пока не создано.',
        'No matches found' => 'Совпадений не найдено',
        'No means, send agent and customer notifications on changes.' => '«Нет» — отправлять уведомления агентам и клиентам при изменениях',
        'No time settings.' => 'Без временных ограничений',
        'Note Text' => 'Текст заметки',
        'Notification (Customer)' => 'Уведомление клиенту',
        'Notifications' => 'Уведомления',
        'OTRS sends an notification email to the customer if the ticket is moved.' =>
            'При перемещении заявки будет отправлено уведомление клиенту.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' =>
            'При смене владельца заявки будет отправлено уведомление клиенту.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' =>
            'При изменении статуса заявки будет отправлено уведомление клиенту.',
        'Object already linked as %s.' => 'Объект уже связан с «%s»!',
        'Of couse this feature will take some system performance it self!' =>
            'Данная функция использует системные ресурсы!',
        'Only for ArticleCreate Event.' => 'Только при создании сообщений',
        'Open Tickets' => 'Открытые заявки',
        'Options ' => 'Данные',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' =>
            'Поля информации о клиенте (например, &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' =>
            'Поля информации о пользователе (например, <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' =>
            'Текущие данные о клиенте (например, <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' =>
            'Поля информации о пользователе, который запросил это действие (например, &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' =>
            'Поля информации о пользователе, который запросил это действие (например <OTRS_CURRENT_UserFirstname>)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' =>
            'Данные текущего пользователя, который запросил это действие (например, <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' =>
            'Поля заявки (например, &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Поля информации о заявке (например, <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Поля информации о заявке (например, <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Поля информации о заявке (например, <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' =>
            'Данные заявки (например, <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Other Options' => 'Другие настройки',
        'Out Of Office' => 'Уведомление об отсутствии',
        'POP3 Account Management' => 'Управление учетной записью POP3',
        'Package' => 'Пакет',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'Пакет установлен некорректно! Вы должны переустановить пакет!',
        'Package verification failed!' => 'Ошибка проверки целостности пакета',
        'Param 1' => 'Параметр 1',
        'Param 2' => 'Параметр 2',
        'Param 3' => 'Параметр 3',
        'Param 4' => 'Параметр 4',
        'Param 5' => 'Параметр 5',
        'Param 6' => 'Параметр 6',
        'Parent-Object' => 'Объект-родитель',
        'Password is already in use! Please use an other password!' => 'Пароль уже используется! Попробуйте использовать другой пароль',
        'Password is already used! Please use an other password!' => 'Пароль уже использовался! Попробуйте использовать другой пароль',
        'Passwords doesn\'t match! Please try it again!' => 'Неверный пароль!',
        'Pending Times' => 'Время, когда запрос был отложен',
        'Pending messages' => 'Сообщения в ожидании',
        'Pending type' => 'Тип ожидания',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' =>
            'Настройки прав доступа. Вы можете выбрать одну или несколько групп, чтобы отчет был видел для разных пользователей.',
        'Permissions to change the ticket owner in this group/queue.' => 'Права на смену владельца заявок в этой группе/очереди',
        'PhoneView' => 'Заявка по телефону',
        'Please contact your admin' => 'Свяжитесь с администратором',
        'Please enter subject.' => 'Пожалуйста, введите тему.',
        'Please provide a name.' => 'Пожалуйста, введите имя.',
        'Print this ticket!' => 'Печать заявки!',
        'Prio' => 'Приоритет',
        'Problem' => 'Проблема',
        'Queue <-> Auto Responses Management' => 'Автоответы в очереди',
        'Queue ID' => 'ID очереди',
        'Queue Management' => 'Управление очередью',
        'Queue is required.' => 'Необходимо указать очередь.',
        'QueueView Refresh Time' => 'Время обновления монитора очередей',
        'Queues <-> Auto Responses' => 'Очередь <-> Автоответы',
        'Realname' => 'Имя',
        'Rebuild' => 'Перестроить',
        'Recipients' => 'Получатели',
        'Reminder' => 'Отложенное напоминание',
        'Reminder messages' => 'Сообщения с напоминаниями',
        'ReminderReached' => 'Напоминание истекло',
        'Required Field' => 'Обязательное поле',
        'Response Management' => 'Управление ответами',
        'Responses <-> Attachments Management' => 'Управление приложенными файлами в ответах',
        'Responses <-> Queue Management' => 'Управление ответами в очередях',
        'Return to the compose screen' => 'Вернуться в окно составления письма',
        'Role' => 'Роль',
        'Roles <-> Agents' => 'Роли <-> Агенты',
        'Roles <-> Groups Management' => 'Управление ролями в группах',
        'Roles <-> Users' => 'Роли <-> Пользователи',
        'Roles <-> Users Management' => 'Управление ролями пользователей',
        'Run Search' => 'Выполнить поиск',
        'Running' => 'Выполняется',
        'Save Job as?' => 'Сохранить задачу как?',
        'Save Search-Profile as Template?' => 'Сохранить параметры поиска в качестве шаблона?',
        'Schedule' => 'Расписание',
        'Search Result' => 'Результат поиска',
        'Search Ticket' => 'Найти заявку',
        'Search for' => 'Поиск',
        'Search for customers (wildcards are allowed).' => 'Поиск клиентов (шаблоны поддерживаются).',
        'Search-Profile as Template?' => 'Поисковый запрос как шаблон?',
        'Secure Mode need to be enabled!' => 'Безопасный режим должен быть включен',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Безопасный режим должен быть отключен при переустановке через веб-интерфейс',
        'Select Box' => 'Команда SELECT',
        'Select Box Result' => 'Выберите из меню',
        'Select Group' => 'Выберите Группу',
        'Select Source (for add)' => 'Выбор источника',
        'Select group' => 'Выберите группу',
        'Select the customeruser:service relations.' => 'Выберите отношения клиента и службы.',
        'Select the element, which will be used at the X-axis' => 'Выберите элемент, который будет использован на оси Х',
        'Select the restrictions to characterise the stat' => 'Выберите ограничения для определения статистики',
        'Select the role:user relations.' => 'Выберите связь между ролью и пользователем',
        'Select the user:group permissions.' => 'Доступ в виде пользователь:группа.',
        'Select your QueueView refresh time.' => 'Время обновления монитора очередей',
        'Select your default spelling dictionary.' => 'Основной словарь',
        'Select your frontend Charset.' => 'Кодировка',
        'Select your frontend QueueView.' => 'Язык монитора очередей.',
        'Select your frontend language.' => 'Язык интерфейса',
        'Select your out of office time.' => 'Укажите период отсутствия',
        'Select your screen after creating a new ticket.' => 'Выберите раздел после создания новой заявки',
        'Selection needed' => 'Необходимо выделение',
        'Send Administrative Message to Agents' => 'Отправить сообщение администратора агентам',
        'Send Notification' => 'Отправлять уведомление',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' =>
            'Прислать мне уведомление, если клиент прислал ответ и я владелец заявки.',
        'Send me a notification of an watched ticket like an owner of an ticket.' =>
            'Прислать мне и владельцу уведомление, если обновлена отслеживаемая заявка.',
        'Send no notifications' => 'Не отправлять уведомления',
        'Sent new password to: %s' => 'Новый пароль отправлен по адресу: %s',
        'Sent password token to: %s' => 'Письмо для получения нового пароля отправлено по адресу: %s',
        'Sessions' => 'Сеансы',
        'Set customer user and customer id of a ticket' => 'Указать учетную запись клиента и идентификатор клиента для заявки',
        'Set new SLA' => 'Установить новый SLA',
        'Set this ticket to pending!' => 'Поставить заявку в режим ожидания!',
        'Show' => 'Показать',
        'Shows the ticket history!' => 'Показать историю заявки!',
        'Site' => 'Место',
        'Solution' => 'Решение',
        'Sorry, you need to be the owner to do this action!' => 'Вы должны быть владельцем для выполнения этого действия!',
        'Sort by' => 'Сортировка по',
        'Source' => 'Источник',
        'Spell Check' => 'Проверка орфографии',
        'State Type' => 'Тип статуса',
        'Static-File' => 'Статический файл',
        'Stats-Area' => 'Статистика',
        'Sub-Queue of' => 'Подочередь в',
        'Sub-Service of' => 'Дополнительная сервис для',
        'Subgroup \'' => 'Подгруппа \'',
        'Subscribe' => 'Подписаться',
        'Symptom' => 'Признак',
        'System History' => 'История',
        'System State Management' => 'Управление системными состояниями',
        'Systemaddress' => 'Системный адрес',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Исправьте состояния по умолчанию также и в файле Kernel/Config.pm!',
        'Text is required!' => 'Необходимо ввести текст!',
        'The User Name you wish to have' => 'Желаемый логин',
        'The customer id is required!' => 'Необходимо указать id клиента!',
        'The customer is required!' => 'Необходимо указать название клиента!',
        'The customer is required.' => 'Необходимо ввести клиента.',
        'The field is required.' => 'Обязательное поле.',
        'The message being composed has been closed.  Exiting.' => 'Создаваемое сообщение было закрыто. выход.',
        'The subject is required!' => 'Необходимо указать тему!',
        'The text is required!' => 'Необходимо ввести текст!',
        'These values are read-only.' => 'Данное поле только для чтения',
        'These values are required.' => 'Данное поле обязательно',
        'This account exists.' => 'Эта учетная запись уже существует.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' =>
            'Это полезно использовать для скрытия отчета (например, он еще не до конца настроен).',
        'This window must be called from compose window' => 'Это окно должно вызываться из окна ввода',
        'Ticket Change Times (from moment)' => 'Время изменения заявки (с момента)',
        'Ticket Close Times (from moment)' => 'Время закрытия заявки (с момента)',
        'Ticket Create Times (from moment)' => 'Время создания заявки (с момента)',
        'Ticket Hook' => 'Выбор заявки',
        'Ticket Information' => 'Информация о заявке',
        'Ticket Lock' => 'Блокирование заявки',
        'Ticket Merged' => 'Заявка объединена',
        'Ticket Number Generator' => 'Генератор номеров заявок',
        'Ticket Overview' => 'Обзор заявок',
        'Ticket Search' => 'Поиск заявки',
        'Ticket Status View' => 'Просмотр статуса заявки',
        'Ticket Type is required!' => 'Требуется указать тип!',
        'Ticket escalation!' => 'Заявка эскалирована!',
        'Ticket locked!' => 'Заявка заблокирована!',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' =>
            'Поля информации о владельце заявки (например, &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Опции владельца заявки (например <OTRS_OWNER_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Данные владельца заявки (например, <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' =>
            'Данные ответственного за заявку (например, <OTRS_RESPONSIBLE_UserFirstname>).',
        'Ticket selected for bulk action!' => 'Заявка выбрана для массового действия!',
        'Ticket unlock!' => 'Заявка разблокирована!',
        'Ticket#' => '№ заявки',
        'Ticket-Area' => 'Заявки',
        'TicketFreeFields' => 'Свободные поля заявки',
        'TicketFreeText' => 'Свободные поля заявки',
        'TicketID' => 'ID заявки',
        'TicketZoom' => 'Просмотр заявки',
        'Tickets available' => 'Доступные заявки',
        'Tickets shown' => 'Показаны заявки',
        'Tickets which need to be answered!' => 'Заявки, требующие ответа',
        'Timeover' => 'Время ожидания истекло',
        'Times' => 'Время',
        'Title of the stat.' => 'Название отчета',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' =>
            'Поля сообщения (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' =>
            'Данные сообщения (например, <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> и <OTRS_CUSTOMER_Body>).',
        'To protect your privacy, active or/and remote content has blocked.' =>
            'Чтобы защитить вашу конфиденциальность, активное и/или удаленное содержимое было заблокировано.',
        'To: (%s) replaced with database email!' => 'To: (%s) заменено на e-mail базы данных!',
        'Tommorow' => 'Завтра',
        'Top of Page' => 'В начало страницы',
        'Total hits' => 'Найдено вхождений',
        'U' => 'U',
        'Unable to parse Online Repository index document!' => 'Не получилось разобрать формат индексного файла сетевого репозитория!',
        'Uniq' => 'Уникальный',
        'Unlock Tickets' => 'Разблокировать заявки',
        'Unlock to give it back to the queue!' => 'Разблокировать и вернуть в очередь!',
        'Unsubscribe' => 'Отписаться',
        'Use utf-8 it your database supports it!' => 'Используйте utf-8, если ваша база данных поддерживает эту кодировку!',
        'Useable options' => 'Используемые опции',
        'User Management' => 'Управление пользователями',
        'User will be needed to handle tickets.' => 'Для обработки заявок нужно зайти пользователем.',
        'Users' => 'Пользователи',
        'Users <-> Groups' => 'Настройки групп',
        'Users <-> Groups Management' => 'Управление группами пользователей',
        'Verify New Password' => 'Подтверждение пароля',
        'Warning! This tickets will be removed from the database! This tickets are lost!' =>
            'Внимание! Указанные заявки будут удалены из базы!',
        'Watch notification' => 'Уведомление при отслеживании',
        'Web-Installer' => 'Установка через веб-интерфейс',
        'WebMail' => 'Почта',
        'WebWatcher' => 'Веб-наблюдатель',
        'Welcome to OTRS' => 'Добро пожаловать в OTRS',
        'Wildcards are allowed.' => 'Подстановочные символы допустимы.',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'При статусе отчета «недействительный» отчет не может быть сформирован.',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' =>
            'Вводя данные и выбирая поля, вы можете настраивать отчет как вам необходимо. От администратора, создававшего данный отчет, зависит какие данные вы можете настраивать. ',
        'Yes means, send no agent and customer notifications on changes.' =>
            '«Да» — не отправлять уведомления агентам и клиентам при изменениях.',
        'Yes, save it with name' => 'Да, сохранить с именем',
        'You got new message!' => 'У вас новое сообщение!',
        'You have to select two or more attributes from the select field!' =>
            'Вам необходимо выбрать два или более пунктов из выбранного поля!',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'Укажите адрес электронной почты в поле получателя (например, support@example.ru)!',
        'You need min. one selected Ticket!' => 'Вам необходимо выбрать хотя бы одну заявку!',
        'You need to account time!' => 'Вам необходимо посчитать время!',
        'You need to activate %s first to use it!' => 'Вам необходимо сначала активировать %s чтобы использовать это',
        'Your Password' => 'Пароль',
        'Your email address is new' => 'Ваш адрес электронной почты новый',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Ваше письмо с номером заявки "<OTRS_TICKET>" отвергнут и переслан по адресу "<OTRS_BOUNCE_TO>". Пожалуйста, свяжитесь по этому адресу для выяснения причин. ',
        'Your language' => 'Язык',
        'Your own Ticket' => 'Ваша собственная заявка',
        'auto responses set!' => 'Установленных автоответов',
        'customer realname' => 'Имя клиента',
        'delete' => 'удалить',
        'down' => 'вниз',
        'false' => 'нет',
        'for ' => 'для',
        'for agent firstname' => 'для агента — имя',
        'for agent lastname' => 'для агента — фамилия',
        'kill all sessions' => 'Закрыть все текущие сеансы',
        'kill session' => 'Завершить сеанс',
        'maximal period form' => 'Максимальный период с',
        'modified' => 'Изменено',
        'new ticket' => 'Новая заявка',
        'next step' => 'следующий шаг',
        'send' => 'Отправить',
        'sort downward' => 'сортировка по убыванию',
        'sort upward' => 'сортировка по возрастанию',
        'to get the first 20 character of the subject' => 'Получить первые 20 символов темы',
        'to get the first 5 lines of the email' => 'Получить первые 5 строк письма',
        'to get the from line of the email' => 'получатель письма',
        'to get the realname of the sender (if given)' => 'получить (если есть) имя отправителя',
        'up' => 'вверх',
        'utf8' => 'utf8',
        'x' => 'x',

    };
    # $$STOP$$
    return;
}

1;
