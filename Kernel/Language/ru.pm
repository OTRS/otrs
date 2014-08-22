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
# Copyright (C) 2013 Andrey N. Burdin <BurdinAN at it-sakh.net>
# Copyright (C) 2013 Yuriy Kolesnikov <ynkolesnikov at gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::ru;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
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
        'Done' => 'Готово',
        'Cancel' => 'Отменить',
        'Reset' => 'Отклонить',
        'more than ... ago' => 'более чем ... назад',
        'in more than ...' => 'в более чем ...',
        'within the last ...' => 'в течение последних ...',
        'within the next ...' => 'в течение следующих ...',
        'Created within the last' => 'Созданы в течение последних ...',
        'Created more than ... ago' => 'Созданы более чем ... назад',
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
        'Time unit' => '',
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
        'CustomerID' => 'ID компании',
        'CustomerIDs' => 'ID клиентов',
        'customer' => 'клиент',
        'agent' => 'агент',
        'system' => 'система',
        'Customer Info' => 'Информация о клиенте',
        'Customer Information' => 'Информация о клиенте',
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
        'before/after' => '',
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
        'Show Tree Selection' => '',
        'The field content is too long!' => '',
        'Maximum size is %s characters.' => '',
        'This field is required or' => '',
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
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'Logout' => 'Выход',
        'Logout successful. Thank you for using %s!' => 'Вы успешно вышли из системы. Благодарим за пользование системой %s !',
        'Feature not active!' => 'Функция не активирована!',
        'Agent updated!' => 'Агент обновлен!',
        'Database Selection' => 'Выбор базы данных',
        'Create Database' => 'Создать базу',
        'System Settings' => 'Системные параметры',
        'Mail Configuration' => 'Конфигурация почты',
        'Finished' => 'Закончено',
        'Install OTRS' => 'Инсталлировать OTRS',
        'Intro' => 'Интро',
        'License' => 'Лицензия',
        'Database' => 'База данных',
        'Configure Mail' => 'Конфигурировать почту',
        'Database deleted.' => 'База данных удалена.',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Если вы установили root пароль для базы данных, введите его здесь, иначе, оставьте поле пустым.',
        'Database already contains data - it should be empty!' => 'В базе данных уже есть данные - она должна быть пустой.',
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
        'News about OTRS releases!' => '',
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
        'Note: Company is invalid!' => '',
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
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '',
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
            'Управление Процесами. Информация из базы данных не синхронизирована с системой, выполните синхронизацию всех процессов.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Пакет не верифицирован OTRS Group! Не рекомендуем его использовать',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Если вы продолжите установку этого пакета, могут возникнуть следующие проблемы!<br><br>&nbsp;-Проблемы безопасности<br>&nbsp;-Стабильности<br>&nbsp;-Производительности<br><br>Помните, что возникшие при работе с таким пакетом проблемы не решаются в рамках сервисного контракта OTRS!<br><br>',
        'Mark' => 'Пометить',
        'Unmark' => 'Снять пометку',
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
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Problems processing server result. Please try again later.' => 'Проблемы, обрабатывающие результат сервера. Попробуйте еще раз позже.',
        'Username and password do not match. Please try again.' => 'Имя пользователя и пароль не соовпадают. Попробуйте еще раз.',
        'The selected process is invalid!' => 'Выбранный процесс - неправильный!',

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
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
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
        'No (not supported)' => '',
        'Days' => 'Дни',
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

        # Template: AAASupportDataCollector
        'Unknown' => '',
        'Information' => 'Сведения',
        'OK' => '',
        'Problem' => 'Проблема',
        'Webserver' => '',
        'Operating System' => 'Операционная система',
        'OTRS' => '',
        'Table Presence' => '',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',
        'Database Size' => '',
        'Could not determine database size.' => '',
        'Database Version' => '',
        'Could not determine database version.' => '',
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'Setting character_set_database needs to be UNICODE or UTF8.' => '',
        'Table Charset' => '',
        'There were tables found which no not have utf8 as charset.' => '',
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            '',
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',
        'Default Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',
        'Table Status' => '',
        'Tables found which do not have a regular status.' => '',
        'MySQL 5.x or higher is required.' => '',
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to AL32UTF8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',
        'PostgreSQL 8.x or higher is required.' => '',
        'OTRS Disk Partition' => '',
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',
        'Disk Partitions Usage' => '',
        'Distribution' => '',
        'Could not determine distribution.' => '',
        'Kernel Version' => '',
        'Could not determine kernel version.' => '',
        'Load' => '',
        'The load should be at maximum, the number of procesors the system have (e.g. a load of 8 or less on a 8 CPUs system is OK.' =>
            '',
        'Could not determine system load.' => '',
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',
        'Perl Version' => 'Версия Perl',
        'Free Swap Space (%)' => '',
        'No Swap Enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',
        'Config Settings' => '',
        'Could not determine value.' => '',
        'Database Records' => '',
        'Tickets' => 'Заявки',
        'Ticket History Entries' => '',
        'Articles' => '',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Queues' => 'Очереди',
        'Agents' => 'Агенты',
        'Roles' => 'Роли',
        'Groups' => 'Группы',
        'Dynamic Fields' => 'Динамические поля',
        'Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Processes' => 'Процессы',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Default SOAP Username and Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',
        'Error Log' => '',
        'There are error reports in your system log.' => '',
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',
        'Package installation status' => '',
        'Some packages are not correctly installed.' => '',
        'Package List' => '',
        'SystemID' => 'Системный ID',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',
        'OTRS Version' => 'Версия OTRS',
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',
        'Open Tickets' => 'Открытые заявки',
        'You should not have more than 8,000 open tickets in your system.' =>
            '',
        'Ticket Search Index module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',
        'Environment Variables' => '',
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache::DBI Usage' => '',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',
        'You should use PerlEx to increase your performance.' => '',

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
        'Bounce Article to a different mail address' => '',
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
        'Create' => 'Создать',
        'Answer' => 'Ответ',
        'Phone call' => 'Телефонный звонок',
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
        'Edit Customer' => 'Редактировать компанию',
        'Bulk Action' => 'Массовое действие',
        'Bulk Actions on Tickets' => 'Массовое действие над заявками',
        'Send Email and create a new Ticket' => 'Отправить письмо и создать новую заявку',
        'Create new Email Ticket and send this out (Outbound)' => 'Создать новую заявку email и отправить ее',
        'Create new Phone Ticket (Inbound)' => 'Создать новую телефонную заявку',
        'Address %s replaced with registered customer address.' => 'Адрес %s заменен зарегистрированным адресом клиента',
        'Customer user automatically added in Cc.' => '',
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
        'Shown Columns' => 'Показываемые колонки',
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
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Отправлять мне уведомление, если клиент прислал отклик, а я владелец заявки, или если заявка разблокирована в одной из моих очередей.',
        'Send ticket follow up notifications' => 'Отправлять уведомления об откликах в заявках',
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
        'Ticket Information' => 'Информация о заявке',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Заявка перемещена в очередь «%s» (%s) из очереди «%s» (%s).',
        'Updated Type to %s (ID=%s).' => 'Тип изменен на %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Сервис изменен на %s (ID=%s).',
        'Updated SLA to %s (ID=%s).' => 'SLA изменен на %s (ID=%s).',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Новая заявка [%s] (Q=%s;P=%s;S=%s).',
        'FollowUp for [%s]. %s' => 'Отклик на [%s]. %s',
        'AutoReject sent to "%s".' => 'Автоотказ отправлен «%s».',
        'AutoReply sent to "%s".' => 'Автоответ отправлен «%s».',
        'AutoFollowUp sent to "%s".' => 'Автоотклик отправлен «%s».',
        'Forwarded to "%s".' => 'Переcлано «%s».',
        'Bounced to "%s".' => 'Перенаправлено «%s».',
        'Email sent to "%s".' => 'Ответ оправлен «%s».',
        '"%s"-notification sent to "%s".' => '%s: уведомление отправлено на %s.',
        'Notification sent to "%s".' => 'Уведомление отправлено на %s.',
        'Email sent to customer.' => 'Клиенту %s отправлено письмо.',
        'Added email. %s' => 'Получено письмо от %s.',
        'Agent called customer.' => 'Сотрудник позвонил клиенту',
        'Customer called us.' => 'Клиент позвонил нам.',
        'Added note (%s)' => 'Добавлена заметка (%s)',
        'Locked ticket.' => 'Заблокирована заявка.',
        'Unlocked ticket.' => 'Разблокирована заявка.',
        '%s time unit(s) accounted. Now total %s time unit(s).' => 'Добавлено единиц времени: %s. Всего единиц времени: %s.',
        '%s' => 'Удалено %s',
        'Updated: %s' => 'Изменено: %s',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Изменен приоритет с «%s» (%s) на «%s» (%s).',
        'New owner is "%s" (ID=%s).' => 'Новый владелец «%s» (ID=%s).',
        'Loop-Protection! No auto-response sent to "%s".' => 'Защита от зацикливания! Авто-ответ на «%s» не отправлен.',
        '%s' => 'Прочее %s',
        'Updated: %s' => 'Обновлено: %s',
        'Old: "%s" New: "%s"' => 'Прежнее состояние: %s, новое состояние: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Обновлено: %s=%s;%s=%s;%s=%s;',
        'Customer request via web.' => 'Веб-запрос пользователя.',
        'Added link to ticket "%s".' => 'К заявке «%s» добавлена связь.',
        'Deleted link to ticket "%s".' => 'Связь с заявкой «%s» удалена.',
        'Added subscription for user "%s".' => 'Добавлена подписка для пользователя «%s».',
        'Removed subscription for user "%s".' => 'Удалена подписка для пользователя «%s».',
        'System Request (%s).' => 'Системный запрос (%s)',
        'New responsible is "%s" (ID=%s).' => 'Новый ответственный теперь «%s» (ID=%s)',
        'Archive state changed: "%s"' => 'Архивный статус изменен: «%s»',
        'Title updated: Old: "%s", New: "%s"' => 'Обновлен заголовок заявки',

        # Template: AAAWeekDay
        'Sun' => 'Вск',
        'Mon' => 'Пнд',
        'Tue' => 'Втр',
        'Wed' => 'Срд',
        'Thu' => 'Чтв',
        'Fri' => 'Птн',
        'Sat' => 'Сбт',

        # Template: AdminACL
        'ACL Management' => 'Управление ACL',
        'Filter for ACLs' => 'Фильтр для ACL',
        'Filter' => 'Фильтр',
        'ACL Name' => 'Имя ACL',
        'Actions' => 'Действия',
        'Create New ACL' => 'Создать новый ACL',
        'Deploy ACLs' => 'Синхронизировать ACL',
        'Export ACLs' => 'Экспорт  ACLs',
        'Configuration import' => 'Импорт конфигурации',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Здесь вы можете загрузить конфигурационный файл для импорта ACL в вашу систему. Файл должен быть в формате .yml, экспортированыый из редактора  ACL.',
        'This field is required.' => 'Это поле обязательно.',
        'Overwrite existing ACLs?' => 'Перезаписать существующие ACL?',
        'Upload ACL configuration' => 'Загрузить настройки ACL',
        'Import ACL configuration(s)' => 'Импортировать настройки ACL',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Для создания нового ACL или импортируйте его из файла экспорта другой системы или создайте заново.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Помните: Эта таблица отображает порядок выполнения ACLs. Если вы хотите изменить порядок в котором они исполняются, измените их имена',
        'ACL name' => 'Имя ACL',
        'Validity' => 'Действительность',
        'Copy' => 'Скопировать',
        'No data found.' => 'Данные не найдены.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Редактировать ACL %s',
        'Go to overview' => 'Перейти к обзору',
        'Delete ACL' => 'Удалить ACL',
        'Delete Invalid ACL' => 'Удалить неправильный ACL',
        'Match settings' => 'Настройки условий',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Задайте условия совпадения для этого ACL. Используйте \'Properties\' для данных текущей формы или \'PropertiesDatabase\' для проверки данных текущей заявки, которые уже в базе данных',
        'Change settings' => 'Настройки действий',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Задайте, что вы хотите изменить в случае выполнения условия. Имейте в виду, что \'Possible\' это "белый список", а \'PossibleNot\' - "черный список"',
        'Check the official' => 'Обратитесь к официальной',
        'documentation' => 'документации',
        'Show or hide the content' => 'Отобразить или скрыть содержимое',
        'Edit ACL information' => 'Редактировать описание ACL',
        'Stop after match' => 'Прекратить проверку после совпадения',
        'Edit ACL structure' => 'Редактировать ACL',
        'Save' => 'Сохранить',
        'or' => 'или',
        'Save and finish' => 'Сохранить и закончить',
        'Do you really want to delete this ACL?' => 'Вы действительно хотите удалить этот ACL',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Этот элемент содержит подэлементы. Вы уверены что желаете удалить его, включая его подэлементы?',
        'An item with this name is already present.' => 'Элемент с таким именем уже существует',
        'Add all' => 'Добавить все. После добавления вы можете изменить статус элемента нажав на пометку справа',
        'There was an error reading the ACL data.' => 'Произошла ошибка при чтении данных ACL',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Для создания нового ACL заполните форму описания и сохраните. После этого можно добавлять наборы условий и действий в режиме редактирования.',

        # Template: AdminAttachment
        'Attachment Management' => 'Управление прикрепленными файлами',
        'Add attachment' => 'Добавить вложение',
        'List' => 'Список',
        'Download file' => 'Скачать файл',
        'Delete this attachment' => 'Удалить это вложение',
        'Add Attachment' => 'Добавить вложение',
        'Edit Attachment' => 'Редактировать вложение',

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
        'Options of ticket dynamic fields internal key values' => 'Атрибуты динамических полей заявки (значения внутренних ключей)',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Атрибуты отображаемых значений динамических полей заявки, полезно при использовании типов Dropdown и Multiselect',
        'Config options' => 'Опции конфигурации',
        'Example response' => 'Пример ответа',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Управление компаниями',
        'Wildcards like \'*\' are allowed.' => 'Разрешены шаблоны типа \'*\'.',
        'Add customer' => 'Добавить компанию',
        'Select' => 'Выбор',
        'Please enter a search term to look for customers.' => 'Введите запрос для поиска компании.',
        'Add Customer' => 'Добавить компанию',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Управление клиентами',
        'Back to search results' => 'Назад к результатам поиска',
        'Add customer user' => 'Добавить клиента',
        'Hint' => 'Подсказка',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Необходимо для наличия данных о клиенте и подключения к системе через интерфейс клиента',
        'Last Login' => 'Последний вход',
        'Login as' => 'Зайти данным пользователем',
        'Switch to customer' => 'Переключится на клиента',
        'Add Customer User' => 'Добавить клиента',
        'Edit Customer User' => 'Редактировать клиента',
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
        'Edit Customer Default Groups' => 'Редактировать группы по-умолчанию клиента',
        'These groups are automatically assigned to all customers.' => 'Эти группы автоматически назначаются всем клиентам.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Этими группами можно управлять в настройке конфигурации "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Фильтры для Групп',
        'Just start typing to filter...' => '',
        'Select the customer:group permissions.' => 'Выберите разрешения клиент:группа.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Если ничего не выбрано, тогда у этой группы не будет прав (заявки будут недоступны клиенту).',
        'Search Results' => 'Результаты поиска:',
        'Customers' => 'Клиенты',
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
        'Allocate Services to Customer' => 'Назначить Сервисы для Клиента',
        'Allocate Customers to Service' => 'Связать Клиентов с Сервисом',
        'Toggle active state for all' => 'Сделать активным для всех',
        'Active' => 'Активный',
        'Toggle active state for %s' => 'Сделать активным для %s',

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
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Возможные значения',
        'Key' => 'Ключ',
        'Value' => 'Значение',
        'Remove value' => 'Удалить значение',
        'Add value' => 'Добавить значение',
        'Add Value' => 'Добавить Значение',
        'Add empty value' => 'Добавить пустое значение',
        'Activate this option to create an empty selectable value.' => 'Отметьте эту опцию для создания пустого выбирабельного значения.',
        'Tree View' => 'Иерархический вид',
        'Activate this option to display values as a tree.' => 'Включите для отображения в иерархическом виде',
        'Translatable values' => 'Переводимые значения',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Если включить эту опцию, значения будут переведены на заданный язык.',
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
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => 'Текст ошибки',
        'Add RegEx' => '',

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
        'The name you entered already exists.' => 'Введенное вами имя уже существует.',
        'Toggle this widget' => 'Переключить показ этого блока',
        'Automatic execution (multiple tickets)' => 'Автоматическое выполнение (несколько заявок)',
        'Execution Schedule' => 'Управление запуском',
        'Schedule minutes' => 'Запускать в минуты',
        'Schedule hours' => 'Запускать в часы',
        'Schedule days' => 'Запускать в дни',
        'Currently this generic agent job will not run automatically.' =>
            'Это задание агента не запускается автоматически',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Для автоматического запуска укажите как минимум одно из значений в минутах, часах или днях!',
        'Event based execution (single ticket)' => 'Триггеры событий (одна заявка)',
        'Event Triggers' => 'Триггеры событий',
        'List of all configured events' => 'Список всех настроенных событий',
        'Delete this event' => 'Удалить это событие',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Дополнительно или или вместо запуска по расписанию, вы можете задать события для заявки, которое включит эту задачу',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Если событие по заявке наступило, фильтр заявок находит соответствующие заявки. Только после этого стартует задача для этой заявки.',
        'Do you really want to delete this event trigger?' => 'Вы действительно хотите удалить этот триггер события?',
        'Add Event Trigger' => 'Добавить триггер события',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Чтобы добавить новое событие выберите тип, событие и щелкните "+" кнопку.',
        'Duplicate event.' => 'Дублировать событие',
        'This event is already attached to the job, Please use a different one.' =>
            'Это событие уже назначено задаче. Выберите другое.',
        'Delete this Event Trigger' => 'Удаление Триггера События',
        'Select Tickets' => '',
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
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'Установить новый сервис',
        'Set new Service Level Agreement' => 'Установить новое Соглашение об Уровне Сервиса (SLA)',
        'Set new priority' => 'Установить новый приоритет',
        'Set new queue' => 'Установить новую очередь',
        'Set new state' => 'Установить новое состояние',
        'Pending date' => 'Дата ожидания',
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
        'Time units' => 'Затраченное время',
        'Execute Ticket Commands' => '',
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
        'GenericInterface Debugger for Web Service %s' => 'Интерфейс отладки для Веб-сервисов',
        'Web Services' => 'Веб-сервисы',
        'Debugger' => 'Отладчик',
        'Go back to web service' => 'Перейти назад к веб-сервису',
        'Clear' => 'Очистить',
        'Do you really want to clear the debug log of this web service?' =>
            'Вы действительно хотите очистить отладочный журнал для этого веб-сервиса',
        'Request List' => '',
        'Time' => 'Время',
        'Remote IP' => 'Удаленный IP-адрес',
        'Loading' => 'Загрузка',
        'Select a single request to see its details.' => '',
        'Filter by type' => 'Фильт по типу',
        'Filter from' => 'Фильтр по from',
        'Filter to' => 'Фильтр по to',
        'Filter by remote IP' => 'Фильтр по удаленному IP-адресу',
        'Refresh' => 'Обновить',
        'Request Details' => 'Детали запроса (Request)',
        'An error occurred during communication.' => 'Ошибка при попытке связи',
        'Show or hide the content.' => 'Показать или убрать содержимое',
        'Clear debug log' => 'Очистить журнал отладки',

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
        'Asynchronous' => 'Асинхронно',
        'This invoker will be triggered by the configured events.' => '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'Сохранить и продолжить',
        'Delete this Invoker' => '',

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
        'Network transport' => 'Сетевой транспорт',
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
        'Proxy Server' => 'Прокси-сервер',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => 'Пароль Прокси',
        'The password for the proxy user.' => 'Пароль пользователя прокси',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Интерфейс управления Веб-сервисами',
        'Add web service' => 'Добавить Веб-сервис',
        'Clone web service' => 'Дублировать Веб-сервис',
        'The name must be unique.' => 'Имя должно быть уникальным',
        'Clone' => 'Скопировать',
        'Export web service' => 'Экспорт Веб-сервиса',
        'Import web service' => 'Импорт Веб-сервиса',
        'Configuration File' => 'Файл конфигурации',
        'The file must be a valid web service configuration YAML file.' =>
            'Файл должен быть файлом конфигурации веб-сервисов формата YAML.',
        'Import' => 'Импорт',
        'Configuration history' => 'История конфигурации',
        'Delete web service' => 'Удалить Веб-сервис',
        'Do you really want to delete this web service?' => 'Вы действительно желаете удалить этот веб-сервис',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'После сохранения конфигурации вы вернетесь обратно на экран редактирования',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Если желаете вернуться к обзору, нажмите кнопку Перейти к обзору.',
        'Web Service List' => 'Список Веб-сервисов',
        'Remote system' => 'Удаленная система',
        'Provider transport' => 'Транспорт провайдера',
        'Requester transport' => 'Транспорт запрашиваюшего',
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
        'Delete webservice' => 'Удалить веб-сервис',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => 'Скопировать веб-сервис',
        'Import webservice' => 'Импортировать веб-сервис',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => 'Вернуться в веб-сервис',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Здесь вы можете просмотреть старые версии конфигурации текущего веб-сервиса(ов), экспортировать или восстановить их.',
        'Configuration History List' => 'Список истории конфигурации',
        'Version' => 'Версия',
        'Create time' => 'Время создания',
        'Select a single configuration version to see its details.' => 'Выберите отдельную версию конфигурации для ее просмотра',
        'Export web service configuration' => 'Экспортировать конфигурацию веб-сервиса',
        'Restore web service configuration' => 'Восстановить конфигурацию веб-сервиса',
        'Do you really want to restore this version of the web service configuration?' =>
            'Вы действительно желаете восстановить эту версию конфигурации веб-сервиса',
        'Your current web service configuration will be overwritten.' => 'Ваша текущая конфигурация веб-сервиса будет перезаписана.',
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
        'Hide this message' => 'Скрыть это сообщение',
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
        'Ticket Filter' => 'Фильтр заявок',
        'Article Filter' => 'Фильтр сообщений',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'Тип сообщения',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => 'Тип отправителя сообщения',
        'Subject match' => 'Соответствие теме',
        'Body match' => 'Соответствие телу письма',
        'Include attachments to notification' => 'Добавить вложения в уведомление',
        'Recipient' => 'Получатель',
        'Recipient groups' => 'Получат группы',
        'Recipient agents' => 'Получат агенты',
        'Recipient roles' => 'Получат роли',
        'Recipient email addresses' => 'Получат адреса электронной почты',
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
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Убедитесь что ваша СУБД принимает пакеты размером больше %s MB (текущее значение размера пакета - до %s MB). Измените значение параметра max_allowed_packet для вашей СУБД во избежание ошибок.',
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
        'This package is verified by OTRSverify (tm)' => '',
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
        'last' => 'последние',
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
        'The name is required.' => 'Имя обязательно.',
        'Filter Condition' => 'Условие фильтра',
        'AND Condition' => 'Условие "И"(AND)',
        'Check email header' => '',
        'Negate' => 'Отрицание ("НЕ")',
        'Look for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Это поле должно быть корректным регулярным выражением либо буквально совпадающей строкой.',
        'Set Email Headers' => 'Выставить заголовки письма',
        'Set email header' => '',
        'Set value' => '',
        'The field needs to be a literal word.' => 'Это поле должно быть буквальной строкой.',

        # Template: AdminPriority
        'Priority Management' => 'Управление приоритетами',
        'Add priority' => 'Добавить приоритет',
        'Add Priority' => 'Создать приоритет',
        'Edit Priority' => 'Изменить приоритет',

        # Template: AdminProcessManagement
        'Process Management' => 'Управление Процессами',
        'Filter for Processes' => 'Фильтр для Процессов',
        'Create New Process' => 'Создать новый Процесс',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Здесь вы можете загрузить файл конфигурации для импорта Процесса в вашу систему. Файл должен быть в формате .yml (файл экспорта из модуля управления Процессами.',
        'Overwrite existing entities' => '',
        'Upload process configuration' => 'Загрузить конфигурацию Процесса',
        'Import process configuration' => 'Импортировать конфигурацию Процесса',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Для создания нового Процесса вы можете импортировать Процесс экспортированный из другой системы или создать полностью новый.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Изменения в Процессах сделанные здесь будут актуальны после синхронизации данных Процесса. При синхронизации, все вновь внесенные изменения будут записаны в конигурационные файлы системы.',
        'Process name' => 'Имя Процесса',
        'Print' => 'Печать',
        'Export Process Configuration' => 'Экспортировать конфигурацию Процесса',
        'Copy Process' => 'Скопировать процесс',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Отменить и закрыть окно',
        'Go Back' => 'Назад',
        'Please note, that changing this activity will affect the following processes' =>
            'Помните, что изменение этой Активности повлияет на следующие Процессы',
        'Activity' => 'Активность',
        'Activity Name' => 'Имя Активности',
        'Activity Dialogs' => 'Диалог Активности',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Вы можете назначить Диалоги Активности для этой Активности перетаскиванием элементов мышью из левого списка в правый.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Порядок элементов в списке изменяется перетаскиванием элементов (drag \'n\' drop)',
        'Filter available Activity Dialogs' => 'Фильтр доступных Диалогов Активности',
        'Available Activity Dialogs' => 'Доступные Диалоги Активности',
        'Create New Activity Dialog' => 'Создать новый Диалог Активности',
        'Assigned Activity Dialogs' => 'Назначить Диалоги Активности',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'После использования этой кнопки или ссылки, вы можете выйти с этого экрана и его текущее состояние будет сохранено автоматически. Желаете продолжить?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Помните, что изменение этого Диалога Активности повлияет на следующие Активности',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Помните, что клиенты не смогут видеть или использовать следующие поля: Владелец, Ответственный, Блокировка, Время ожидания и CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => 'Диалог Активности',
        'Activity dialog Name' => 'Имя Диалога Активности',
        'Available in' => 'Доступно в',
        'Description (short)' => 'Описание (краткое)',
        'Description (long)' => 'Описание (полное)',
        'The selected permission does not exist.' => 'Выбранные права не существуют',
        'Required Lock' => 'Требуется блокировка',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => 'Текст подсказки кнопки Отправить',
        'Submit Button Text' => 'Название кнопки Отправить',
        'Fields' => 'Поля',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Вы можете назначить поля для этого Диалога Активности перетаскиванием элементов мышью из левого списка в правый.',
        'Filter available fields' => 'Фильтр для доступных полей',
        'Available Fields' => 'Доступные поля',
        'Assigned Fields' => 'Назначенные поля',
        'Edit Details for Field' => 'Редактировать атрибуты поля',
        'ArticleType' => 'Тип сообщения',
        'Display' => 'Отобразить',
        'Edit Field Details' => 'Редактировать атрибуты поля',
        'Customer interface does not support internal article types.' => 'Клиентский интерфейс не поддерживает внутренний тип заметки',

        # Template: AdminProcessManagementPath
        'Path' => 'Схема',
        'Edit this transition' => 'Редактировать этот Переход',
        'Transition Actions' => 'Действия Перехода',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Вы можете назначить Действия Перехода для этого Перехода перетаскиванием элементов мышью из левого списка в правый.',
        'Filter available Transition Actions' => 'Фильтр для доступных Действий Перехода',
        'Available Transition Actions' => 'Доступные Действия Перехода',
        'Create New Transition Action' => 'Создать новое Действие Перехода',
        'Assigned Transition Actions' => 'Назначить Действия Перехода',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Активности',
        'Filter Activities...' => 'Фильтр для Активностей...',
        'Create New Activity' => 'Создать новую Активность',
        'Filter Activity Dialogs...' => 'Фильтр для Диалогов Активности',
        'Transitions' => 'Переходы',
        'Filter Transitions...' => 'Фильтр для Переходов...',
        'Create New Transition' => 'Создать новый Переход',
        'Filter Transition Actions...' => 'Фильтр для Действий Переходов...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Редактировать процесс',
        'Print process information' => 'Печать информации о Процессе',
        'Delete Process' => 'Удалить Процесс',
        'Delete Inactive Process' => 'Удалить неактивный Процесс',
        'Available Process Elements' => 'Доступные элементы Процесса',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Элементы показанные в этом окне можно перенести на поле схемы справа используя перетаскивание мышью',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Вы можете поместить Активности на схему для назначения ее Процессу.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Для назначения Диалога Активности для этой Активности перетащите его из списка на значок Активности на схеме',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Для начала организации связи между Активностями перетащите Переход на исходную Активность. После этого вы можете переместить конец стрелки к Активности мишени',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Действия могут быть назначены Переходу переиаскиванием Действия на метку(значок) Перехода',
        'Edit Process Information' => 'Редактировать информацию о Процессе',
        'Process Name' => 'Имя Процесса',
        'The selected state does not exist.' => 'Выбранное состояние не существует.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Добавление и Редактирование Активностей, Диалогов Активности и Переходов',
        'Show EntityIDs' => 'Схема связей в Процессе',
        'Extend the width of the Canvas' => 'Увеличит ширину схемы',
        'Extend the height of the Canvas' => 'Увеличить высоту схемы',
        'Remove the Activity from this Process' => 'Удалить Активность из этого Процесса',
        'Edit this Activity' => 'Редактировать Активность',
        'Save settings' => 'Сохранить настройки',
        'Save Activities, Activity Dialogs and Transitions' => 'Сохранить Активности, Диалоги Активности и Переходы',
        'Do you really want to delete this Process?' => 'Вы действительно желаете удалить этот Процесс?',
        'Do you really want to delete this Activity?' => 'Вы действительно желаете удалить эту Активность?',
        'Do you really want to delete this Activity Dialog?' => 'Вы действительно желаете удалить этот Диалог Активности?',
        'Do you really want to delete this Transition?' => 'Вы действительно желаете удалить этот Переход?',
        'Do you really want to delete this Transition Action?' => 'Вы действительно желаете удалить это Действие Перехода',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Вы действительно желаете удалить эту Актвность из схемы? Это можно отменить только покинув этот экран без сохранения.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Вы действительно желаете удалить этот Переход из схемы? Это можно отменить только покинув этот экран без сохранения.',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Эта Активность уже используется в этом Процессе. Ее нельзя использовать дважды!',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Эту Активность нельзя удалить, т.к. она первая.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Этот Переход уже используется для этой Активности. Его нельзя использовать дважды!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Это Действие Перехода уже используется на этой Схеме. Его нельзя использовать дважды!',
        'Remove the Transition from this Process' => 'Удалить Переход из этого Процесса',
        'No TransitionActions assigned.' => 'Не назначено ни одного Действия Перехода.',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Не назначено Диалога. Просто перетащите Диалог Активности из списка слева и поместите его сюда.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Не связанные Переходы есть на схеме. Соедините их до помещения на схему нового(следующего).',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'На этом экране вы можете создать новый Процесс. Чтобы новый Процесс стал доступным пользователям, убедитесь, что его состояние установлено в \'Active\' и он синхронизирован с системой по окончании его создания.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Начальная Активность',
        'Contains %s dialog(s)' => 'Содержит %s диалог(ов)',
        'Assigned dialogs' => 'Назначенные диалоги',
        'Activities are not being used in this process.' => 'Активности не используются в этом процессе',
        'Assigned fields' => 'Назначенные поля',
        'Activity dialogs are not being used in this process.' => 'Диалоги Активности не используются в этом процессе',
        'Condition linking' => 'Связывание условий',
        'Conditions' => 'Условия',
        'Condition' => 'Условие',
        'Transitions are not being used in this process.' => 'Переходы не используются в этом процессе',
        'Module name' => 'Имя модуля',
        'Configuration' => 'Конфигурация',
        'Transition actions are not being used in this process.' => 'Действия Переходов не используются в этом процессе',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Имейте в виду, что изменение в этом Переходе повлияет на следующие Процессы',
        'Transition' => 'Переход',
        'Transition Name' => 'Имя Перехода',
        'Type of Linking between Conditions' => 'Тип связи между Условиями',
        'Remove this Condition' => 'Удалить это Условие',
        'Type of Linking' => 'Тип связи',
        'Remove this Field' => 'Удалить это поле',
        'Add a new Field' => 'Добавить новое поле',
        'Add New Condition' => 'Добавить новое Условие',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Имейте в виду, что изменение в этом Действии Перехода повлияет на следующие Процессы',
        'Transition Action' => 'Действие Перехода',
        'Transition Action Name' => 'Имя Действия Перехода',
        'Transition Action Module' => 'Модуль Действия Перехода',
        'Config Parameters' => 'Параметры конфигурации',
        'Remove this Parameter' => 'Удалить этот параметр',
        'Add a new Parameter' => 'Добавить новый параметр',

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

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Управление сязями Щаблон - Очередь',
        'Filter for Templates' => 'Фильтр для Шаблонов',
        'Templates' => 'Шаблоны',
        'Change Queue Relations for Template' => 'Изменить связь Очереди с Шаблоном',
        'Change Template Relations for Queue' => 'Изменить связь Шаблона с Очередью',

        # Template: AdminRegistration
        'System Registration Management' => 'Управление регистрацией',
        'Edit details' => 'Редактировать информацию',
        'Deregister system' => 'Удалить регистрацию системы',
        'Overview of registered systems' => 'Обзор зарегистрированных систем',
        'System Registration' => 'Регистрация системы',
        'This system is registered with OTRS Group.' => 'Эта система зарегистрирована в OTRS Group.',
        'System type' => 'Тип системы',
        'Unique ID' => 'Уникальный индентификатор',
        'Last communication with registration server' => 'Последняя связь с регистрационным сервером',
        'Send support data' => '',
        'OTRS-ID Login' => 'Уч. запись OTRS-ID',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Регистрация системы - это сервис от OTRS Group, который предоставляет много преимуществ!',
        'Read more' => 'Подробно',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Вы должны войти в систему со своей уч. записью OTRS-ID, чтобы зарегистрировать Вашу систему.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Ваша уч. запись OTRS-ID - это адрес электронной почты, Вы раньше регистрировались в системе на веб-странице OTRS.com.',
        'Data Protection' => '',
        'What are the advantages of system registration?' => 'Каковы преимущества регистрации системы?',
        'You will receive updates about relevant security releases.' => 'Вы получите обновления о соответствующих выпусках безопасности.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'С Вашей регистрацией мы можем улучшить наши службы для Вас, потому что мы имеем всю релевантную информацию в наличии.',
        'This is only the beginning!' => 'Это - только начало!',
        'We will inform you about our new services and offerings soon.' =>
            'Мы сообщим Вам о наших новых службах и предложениях быстрее.',
        'Can I use OTRS without being registered?' => 'Я могу использовать OTRS без регистрации?',
        'System registration is optional.' => 'Регистрация как дополнительная опция.',
        'You can download and use OTRS without being registered.' => 'Вы можете загрузить и использовать OTRS без регистрации.',
        'Is it possible to deregister?' => 'Действительно ли возможно удалить регистрацию системы (отрегистрироватся)?',
        'You can deregister at any time.' => 'В любое время Вы можете удалить регистрацию(отрегистрироватся).',
        'Which data is transfered when registering?' => 'Какие данные будут переданы, при регистрации?',
        'A registered system sends the following data to OTRS Group:' => 'Зарегистрированная система посылает следующие данные в OTRS Group:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), версия OTRS, Базаданных, Операционная система и версия Perl',
        'Why do I have to provide a description for my system?' => 'Почему я должен предоставить описание для своей системы?',
        'The description of the system is optional.' => 'Описание системы (необязательно).',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Описание и тип системы, который Вы определяете сами, это помогает Вам идентифицировать и управлять деталями своих зарегистрированных систем.',
        'How often does my OTRS system send updates?' => 'Как часто моя система OTRS отправляет обновления(отчеты)?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Ваша система отправит обновления (отчет) на сервер OTRS Group периодически.',
        'Typically this would be around once every three days.' => 'Обычно это происходит один раз в три дня.',
        'In case you would have further questions we would be glad to answer them.' =>
            'В случае, если у Вас возникли вопросы, мы будем рады ответить на них.',
        'Please visit our' => 'Посетите наш',
        'portal' => 'портал',
        'and file a request.' => 'и задайте вопрос.',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            '',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            '',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            '',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            '',
        'Data Handling with \'System Registration\'' => '',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            '',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            '',
        'Safety of Personal Details' => '',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            '',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            '',
        'Disclosure of Details' => '',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            '',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            '',
        'Amendment of Data Protection Policy' => '',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            '',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            '',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            '',
        'Right to Information' => '',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            '',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            '',
        'Further Information' => '',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            '',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            '',
        'If you deregister your system, you will loose these benefits:' =>
            'Если Вы удалите зарегистрированую систему, то Вы потеряете следующие преимущества:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Вы должны войти в систему под своей уч. записью OTRS-ID, чтобы удалить зарегистрированую Вашу систему.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'У Вас еще нет уч. записи OTRS-ID?',
        'Sign up now' => 'Войти',
        'Forgot your password?' => 'Забыли свой пароль?',
        'Retrieve a new one' => 'Получите новый',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Эти данные будут часто передаваться OTRS Group, когда Вы зарегистрируете эту систему.',
        'Attribute' => 'Атрибут',
        'FQDN' => 'Полное имя домена',
        'Optional description of this system.' => 'Необязательное описание этой системы',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'Service Center' => '',
        'Support Data Management' => '',
        'Register' => 'Регистрация',
        'Deregister System' => 'Удалить зарегистрированиую систему(отрегистрировать)',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Продолжите этот шаг и вы удалите зарегистрированиую ситему из скписка OTRS Group.',
        'Deregister' => 'Удалить регистрацию',
        'You can modify registration settings here.' => '',

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
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Здесь вы можете добавлять связи с вашими приватными сертификатами, которые будут встраиваться в подпись SMIME каждый раз, когда вы используете этот сертификат для подписи электронной почты.',
        'See also' => 'См. также',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Вы можете редактировать сертификаты и закрытые ключи прямо на файловой системе',
        'Hash' => 'Хэш',
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
        'SMIME Certificate' => 'Сертификат SMIME',
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

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Currently this data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',
        'The support bundle has been generated.' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this ption has been disabled.' =>
            '',
        'Sending' => '',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Support Data' => '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => 'Подробно',

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
        'Delete this entry' => 'Удалить эту запись',
        'Create new entry' => 'Создать новую запись',
        'New group' => 'Новая группа',
        'Group ro' => 'Группа только для чтения',
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
        'Show more' => 'Показать еще',

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

        # Template: AdminTemplate
        'Manage Templates' => 'Управление шаблонами',
        'Add template' => 'Добавить шаблон',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Шаблон - текст по умолчанию, который помогает Вашим агентам писать более быстрые заявки, ответы или перенаправления.',
        'Don\'t forget to add new templates to queues.' => 'Не забудьте добавить новые шаблоны к очередям',
        'Add Template' => 'Добавить шаблон',
        'Edit Template' => 'Изменить шаблон',
        'Template' => 'Шаблон',
        'Create type templates only supports this smart tags' => 'Создайте шаблоны типа, только поддерживает это умные теги',
        'Example template' => 'Пример шаблона',
        'The current ticket state is' => 'Текущее состояние заявки',
        'Your email address is' => 'Ваш email адрес ',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Управление связью Шаблоны - Вложения',
        'Filter for Attachments' => 'Фильтр для вложений',
        'Change Template Relations for Attachment' => 'Изменить связь Шаблона с Вложением',
        'Change Attachment Relations for Template' => 'Изменить связь Вложения с Шаблоном',
        'Toggle active for all' => 'Включить для всех',
        'Link %s to selected %s' => 'Связать %s с выбранным %s',

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
        'Will be auto-generated if left empty.' => '',
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
        'Customer Information Center' => 'Информация о клиенте',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Учетная запись клиента',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Дублирующаяся запись',
        'This address already exists on the address list.' => 'Такой адрес уже существует в списке адресов.',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Замечание: неверный Клиент!',

        # Template: AgentDashboard
        'Dashboard' => 'Дайджест',

        # Template: AgentDashboardCalendarOverview
        'in' => 'в',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Доступные для отображения',
        'Visible Columns (order by drag & drop)' => 'Отображаемые (порядок устанавливается перетаскиванием)',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Эскалированные заявки',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Информация о клиенте',
        'Phone ticket' => 'Заявка по телефону',
        'Email ticket' => 'Заявка по почте',
        '%s open ticket(s) of %s' => '%s открытых заявок из %s',
        '%s closed ticket(s) of %s' => '%s закрытых заявок из %s',
        'New phone ticket from %s' => 'Новая телефонная заявка от %s',
        'New email ticket to %s' => 'Новая заявка по почте от %s',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s доступен',
        'Please update now.' => 'Обновите сейчас',
        'Release Note' => 'Примечание к релизу',
        'Level' => 'Уровень',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Опубликовано %s',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'Grouped' => '',
        'Stacked' => '',
        'Expanded' => '',
        'Stream' => '',
        'CSV' => '',
        'PDF' => '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Мои заблокированные заявки',
        'My watched tickets' => 'Заявки в моем списке наблюдения',
        'My responsibilities' => 'Заявки, где я ответственный',
        'Tickets in My Queues' => 'Заявки в моих очередях',
        'Service Time' => 'Время обслуживания',
        'Remove active filters for this widget.' => 'Удалить активные фильтры для этого виджета.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Итого',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => 'вне офиса',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'до',

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
        'Show as dashboard widget' => '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            '',
        'Please note' => '',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            '',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            '',
        'IE8 doesn\'t support statistics dashboard widgets.' => '',
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
            'С помощью полей ввода и выбора вы можете влиять на формат и содержание отчета.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Конкретные поля и форматы, на которые вы можете влиять, задаются администратором отчетов/статистики.',
        'Stat Details' => 'Подробнее об отчете',
        'Format' => 'Формат',
        'Graphsize' => 'Размер графика',
        'Cache' => 'Кэш',
        'Exchange Axis' => 'Поменять оси',

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Конфигурируемые параметры статического отчета',
        'No element selected.' => 'Элементы не выбраны',
        'maximal period from' => 'Максимальный период с',
        'to' => 'по',
        'not changable for dashboard statistics' => '',
        'Select Chart Type' => '',
        'Chart Type' => '',
        'Multi Bar Chart' => '',
        'Multi Line Chart' => '',
        'Stacked Area Chart' => '',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Изменить свободный текст заявки',
        'Change Owner of Ticket' => 'Изменить владельца заявки',
        'Close Ticket' => 'Закрыть заявку',
        'Add Note to Ticket' => 'Добавить заметку к заявке',
        'Set Pending' => 'Поставить в ожидание',
        'Change Priority of Ticket' => 'Изменить приоритет заявки',
        'Change Responsible of Ticket' => 'Изменить ответственного заявки',
        'All fields marked with an asterisk (*) are mandatory.' => 'Все поля отмеченные (*) являются обязательными',
        'Service invalid.' => 'Некорректный сервис.',
        'New Owner' => 'Новый владелец',
        'Please set a new owner!' => 'Пожалуйста, задайте нового владельца',
        'Previous Owner' => 'Предыдущий владелец',
        'Inform Agent' => 'Уведомить агента',
        'Optional' => 'Необязательно',
        'Inform involved Agents' => 'Уведомить участвующих агентов',
        'Spell check' => 'Проверка орфографии',
        'Note type' => 'Тип заметки',
        'Next state' => 'Следующее состояние',
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
        'Send mail' => 'Отправить письмо!',

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
        'Please include at least one recipient' => 'Пожалуйста, включите хотя бы одного получателя.',
        'Remove Ticket Customer' => 'Удалить клиента-инициатора заявки',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Пожалуйста, удалите эту запись и введите новую с корректным значением.',
        'Remove Cc' => 'Удалить из копии',
        'Remove Bcc' => 'Удалить из скрытой копии',
        'Address book' => 'Адресная книга',
        'Pending Date' => 'Ожидать до',
        'for pending* states' => 'для состояний "ожидает ..."',
        'Date Invalid!' => 'Неверная дата!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Изменить клиента заявки',
        'Customer user' => 'Учетная запись клиента',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Создать заявку по email',
        'Example Template' => '',
        'From queue' => 'Из очереди',
        'To customer user' => 'Клиенту',
        'Please include at least one customer user for the ticket.' => 'Укажите, пожалуйста, хотя бы одного клиента',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => 'Удалить клиента заявки',
        'Get all' => 'Получить всех',
        'Text Template' => 'Текстовый шаблон',

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
        'Select this ticket' => '',
        'First Response Time' => 'Время до первого ответа',
        'Update Time' => 'Время до изменения заявки',
        'Solution Time' => 'Время до решения заявки',
        'Move ticket to a different queue' => 'Переместить заявку в другую очередь',
        'Change queue' => 'Переместить в другую очередь',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Изменить параметры поиска',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Заявок на страницу',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Сбросить настройки просмотра',
        'Column Filters Form' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Создать телефонную заявку',
        'Please include at least one customer for the ticket.' => 'Пожалуйста, включите хотя бы одного клиента в заявку.',
        'To queue' => 'В очередь',

        # Template: AgentTicketPhoneCommon

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
        'Create New Process Ticket' => 'Создать новую процессную заявку',
        'Process' => 'Процесс',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Шаблон поиска',
        'Create Template' => 'Создать шаблон',
        'Create New' => 'Создать новый',
        'Profile link' => 'Ссылка на шаблон',
        'Save changes in template' => 'Сохранить изменения в шаблоне',
        'Filters in use' => '',
        'Additional filters' => '',
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
        'Ticket Escalation Time (before/after)' => 'Время эскалации заявки (до/после)',
        'Ticket Escalation Time (between)' => 'Время эскалации заявки (между)',
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
        'Locked' => 'Блокировка',
        'Linked Objects' => 'Связанные объекты',
        'Change Queue' => 'Сменить очередь',
        'Dialogs' => '',
        'There are no dialogs available at this point in the process.' =>
            'Нет диалогов доступных в этой части процесса',
        'This item has no articles yet.' => 'Этот элемент пока не имеет заметок.',
        'Article Overview' => '',
        'Article(s)' => 'сообщений',
        'Add Filter' => 'Добавить фильтр',
        'Set' => 'Установить',
        'Reset Filter' => 'Сбросить фильтр',
        'Show one article' => 'Отобразить одно сообщение',
        'Show all articles' => 'Отобразить все сообщения',
        'Unread articles' => 'Непрочитанные сообщения',
        'No.' => '№',
        'Important' => 'Важно',
        'Unread Article!' => 'Непрочитанные сообщения!',
        'Incoming message' => 'Входящее сообщение',
        'Outgoing message' => 'Исходящее сообщение',
        'Internal message' => 'Внутреннее сообщение',
        'Resize' => 'Изменить размер',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Для защиты конфиденциальности, содержимое из внешнего источника было заблокировано',
        'Load blocked content.' => 'Загрузить заблокированное содержимое.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Отслеживание',

        # Template: CustomerFooter
        'Powered by' => 'Используется',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Произошла одна или несколько ошибок!',
        'Close this dialog' => 'Закрыть этот диалог',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Невозможо открыть всплывающее окно. Пожалуйста, отключите для этого приложения любые блокировки всплывающих окон.',
        'There are currently no elements available to select from.' => 'Отсутствуют элементы доступные для выбора',

        # Template: CustomerFooterSmall

        # Template: CustomerHTMLHead

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
        'Request new password' => 'Прислать новый пароль',
        'Your User Name' => 'Логин',
        'A new password will be sent to your email address.' => 'Новый пароль будет отправлен на ваш адрес электронной почты',
        'Create Account' => 'Создать учетную запись',
        'Please fill out this form to receive login credentials.' => 'Пожалуйста, заполните эту форму, чтобы получить учетные данные для входа',
        'How we should address you' => 'Как мы должны к вам обращаться',
        'Your First Name' => 'Ваше Имя',
        'Your Last Name' => 'Ваша Фамилия',
        'Your email address (this will become your username)' => 'Ваш адрес электронной почты (он станет вашим именем пользователя)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Редактировать персональные настройки',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Соглашение об уровне сервиса',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Добро пожаловать!',
        'Please click the button below to create your first ticket.' => 'Пожалуйста, нажмите на кнопку ниже, чтобы создать вашу первую заявку.',
        'Create your first ticket' => 'Создать вашу первую заявку.',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Печать заявки.',
        'Ticket Dynamic Fields' => 'Динамические поля заявки',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Параметры',
        'e. g. 10*5155 or 105658*' => 'например, 10*5155 или 105658*',
        'Customer ID' => 'ID клиента',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Полнотекстовый поиск в заявке (например, "Иван*в" или "Петр*")',
        'Carbon Copy' => 'Копия',
        'Types' => 'Типы',
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
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Expand article' => 'Развернуть сообщение',
        'Next Steps' => 'Далее',
        'Reply' => 'Ответить',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'All-day' => '',
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
        'Event Information' => 'Информация о событии',
        'Ticket fields' => 'Поля заявки',
        'Dynamic fields' => 'Динамические поля',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Некорректная дата (нужна дата в будущем)!',
        'Invalid date (need a past date)!' => '',
        'Previous' => 'Назад',
        'Open date selection' => 'Открыть выбор даты',

        # Template: Error
        'Oops! An Error occurred.' => 'Ой! Возникла ошибка.',
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
            'Всплывающее окно с таким экраном уже открыто. Хотите закрыть то и открыть вместо него это?',
        'Please enter at least one search value or * to find anything.' =>
            'Пожалуйста, введите хотя бы одно значение для поиска, или * (звездочку) для поиска чего угодно.',
        'Please check the fields marked as red for valid inputs.' => '',
        'Please perform a spell check on the the text first.' => '',
        'Slide the navigation bar' => '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: HTMLHeadRefresh

        # Template: HTTPHeaders

        # Template: Header
        'You are logged in as' => 'Вы вошли как',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript недоступен',
        'Database Settings' => 'Настройки базы данных',
        'General Specifications and Mail Settings' => 'Общие указания и настройки почты',
        'Web site' => 'Веб-сайт',
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

        # Template: InstallerDBResult
        'Database setup successful!' => 'База данных настроена успешно!',

        # Template: InstallerDBStart
        'Install Type' => 'Тип установки',
        'Create a new database for OTRS' => 'Создать новую базу данных для OTRS',
        'Use an existing database for OTRS' => 'Использовать существующую базу данных OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Имя базы данных',
        'Check database settings' => 'Проверить настройки БД',
        'Result of database check' => 'Результат проверки базы данных',
        'Database check successful.' => 'База данных проверена успешно.',
        'Database User' => 'Пользователь базы данных',
        'New' => 'Новое',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Для этой системы OTRS будет создан новый пользователь базы данных с ограниченными правами.',
        'Repeat Password' => 'Повторите пароль',
        'Generated password' => 'Сгенерированный пароль',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Пароли не подходят',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerDBpostgresql

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

        # Template: InstallerSystem
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Идентификатор системы. Каждый номер заявки и каждый идентификатор HTTP-сессии - содержат этот номер.',
        'System FQDN' => 'Системное FQDN',
        'Fully qualified domain name of your system.' => 'Полное доменное имя вашей системы.',
        'AdminEmail' => 'Адрес администратора',
        'Email address of the system administrator.' => 'Адрес электронной почты администратора',
        'Organization' => 'Организация',
        'Log' => 'Журнал',
        'LogModule' => 'Модуль журнала ',
        'Log backend to use.' => 'Какой бэкенд использовать для собственно записи журнала.',
        'LogFile' => 'Файл журнала',
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
        'Back to login' => 'Вернуться к странице входа в систему',

        # Template: Motd
        'Message of the Day' => 'Новость дня',

        # Template: NoPermission
        'Insufficient Rights' => 'Недостаточно прав',
        'Back to the previous page' => 'Обратно на предыдущую страницу',

        # Template: Notify
        'Close this message' => '',

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

        # Template: PrintHeader
        'printed by' => 'Напечатал:',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Тестовая страница OTRS',
        'Counter' => 'Счетчик',

        # Template: Warning
        'Go back to the previous page' => 'Перейти на предыдущую страницу',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL модуль, который позволяет закрывать родительские заявки только после того как все младшие закрыты ("State" задает доступные состояния для родительских заявок до закрытия всех младших',
        'Access Control Lists (ACL)' => 'Списки управления доступом (ACL)',
        'AccountedTime' => 'Затраченное время',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Включить "мигание" для очередей содержащих наиболее старые заявки',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Включить функцию восстановления пароля для агентов в интерфейсе агента',
        'Activates lost password feature for customers.' => 'Включить функцию восстановления пароля для клиентов',
        'Activates support for customer groups.' => 'Включить поддержку групп клиентов',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Включить фильтр сообщений в подробном просмотре, для выбора сообщений для показа',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Включить доступные темы системы. Значение 1 - включена, 0 - отключена',
        'Activates the ticket archive system search in the customer interface.' =>
            'Включить возможность поиска заявок в архиве в интерфейсе клиента',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Включить функцию архивирования заявок для ускорения работы, путем перемещения некоторых заявок из ежедневного объема. Для поиска таких заявок необходимо включить архивный флажок при создании поискового запроса',
        'Activates time accounting.' => 'Включить учет времени выполнения',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Добавляет суффикс с текущим годом и месяцем к имени лог файла OTRS. Лог-файл создается для каждого месяца.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Добавляет почтовые адреса клиентов - получателей на экране создания ответа в интерфейсе агента. E-mail адреса нельзя добавить, если тип сообщения - email-internal.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Добавляет разовый выходной день для выбранного календаря. Для цифр от 1 до 9 используйте один разряд (вместо 01 - 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Добавляет разовый выходной день. Для цифр от 1 до 9 используйте один разряд (вместо 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Добавляет постоянный выходной день для выбранного календаря. Для цифр от 1 до 9 используйте один разряд (вместо 01 - 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Добавляет постоянный выходной день. Для цифр от 1 до 9 используйте один разряд (вместо 01 - 09).',
        'Agent Notifications' => 'Уведомление агентов',
        'Agent interface article notification module to check PGP.' => 'Модуль уведомления для проверки PGP в интерфейсе агента.',
        'Agent interface article notification module to check S/MIME.' =>
            'Модуль уведомления для проверки S/MIME в интерфейсе агента.',
        'Agent interface module to access CIC search via nav bar.' => 'Отображение окна поиска по CustomerID в CIC (Центр информации о Компании) в навигационной панели в интерфейсе агента',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Отображение окна полнотекстового поиска в навигационной панели в интерфейсе агента.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Отображение окна поиска по сохраненным шаблонам в интерфейсе агента',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Модуль проверки входящих emails в окне Ticket-Zoom-View если S/MIME-key доступен и верен.',
        'Agent interface notification module to check the used charset.' =>
            'Вызов модуля проверки используемого набора символов в интерфейсе агента.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Включение отображения иконки с количеством заявок, по которым агент является ответственным.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Включение отображения иконки с количеством наблюдаемых агентом заявок.',
        'Agents <-> Groups' => 'Агенты <-> Группы',
        'Agents <-> Roles' => 'Агенты <-> Роли',
        'All customer users of a CustomerID' => 'Все клиенты Компании (по CustomerID)',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Позволяет добавить сообщение на экране закрытия заявки в интерфейсе агента.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Позволяет добавить сообщение на экране Свободные(Дополн.) поля заявки в интерфейсе агента.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Позволяет добавить сообщение на экране создания заметки в интерфейсе агента.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Позволяет добавить сообщение на экране Владелец в интерфейсе агента.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Позволяет добавить сообщение на экране Отложить в просмотре заявки в интерфейсе агента.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Позволяет добавить сообщение на экране Приоритет в просмотре заявки в интерфейсе агента.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Позволяет добавить сообщение на экране Ответственный в просмотре заявки в интерфейсе агента.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Позволяет поменять местами оси графика в отчете.',
        'Allows agents to generate individual-related stats.' => '',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Выбор варианта показа вложения к заявке - в окне браузера или как файл для загрузки(вложение).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Позволяет отобразить в интерфейсе клиента возможность выбора следующего состояния заявки при ответе.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Позволяет в интерфейсе клиента изменить приоритет заявки.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Позволяет клиенту выбирать SLA для заявки.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Позволяет в интерфейсе клиента установить приоритет заявки.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Позволяет клиенту выбрать очередь для заявки. Если установить "Нет", необходимо настроить параметр QueueDefault (Очередь по умолчанию).',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Позволяет клиенту выбирать Сервис для заявки.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Позволяет клиенту выбирать Тип для заявки. Если установить "Нет", необходимо настроить параметр TicketTypeDefault(Тип по умолчанию).',
        'Allows default services to be selected also for non existing customers.' =>
            'Разрешает установить Сервис по умолчанию для не существующих клиентов.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Позволяет определить новые Типы для заявок (если включено использование Типа).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Позволяет определить Сервисы и SLA для заявок (напр. Почта, ПК, Сеть, ...), и параметры эскалации для SLA (при условии, что поддержка Сервисов и SLA включена).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Позволяет задать расширенные возможности поиска в интерфейсе агента. При включении его, появится возможность поска с использованием конструкций типа "(key1&&key2)" или "(key1||key2)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Позволяет задать расширенные возможности поиска в интерфейсе клиента. При включении его, появится возможность поска с использованием конструкций типа "(key1&&key2)" или "(key1||key2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Допускает использование medium режима просмотра заявок (CustomerInfo => 1 - показывает также информацию о клиенте).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Допускает использование small(краткий) режима просмотра заявок (CustomerInfo => 1 - показывает также информацию о клиенте).',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Дает возможность администратору войти в систему как клиенту, через панель управления учетными записями клиентов.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Дает возможность администратору войти в систему как обычному агенту, через панель управления агентами.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Позволяет установить новое Состояние заявки на экране смены очереди в интерфейсе агента.',
        'ArticleTree' => 'Дерево сообщений',
        'Attachments <-> Templates' => 'Вложения <-> Шаблоны',
        'Auto Responses <-> Queues' => 'Автоответы <-> Очередь',
        'Automated line break in text messages after x number of chars.' =>
            'Автоматический перевод строки в тексте сообщения после х символов.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Автоматически блокирует заявку и назначает текущего агента владельцем при выборе массового действия',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Автоматически назначает Владельца заявки ее Ответственным (если возможность использования Ответственных включена).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Автоматически назначает Ответственного (если это еще не произошло) после первой смены Владельца.',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Базовые настройки индексирования для полнотекстового поиска. Выполните скрипт "bin/otrs.RebuildFulltextIndex.pl" для генерации новых индексов.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Блокирует все входящие письма, не содержащие в поле Тема правильного номера заявки и имеющих в поле From(от): @example.com',
        'Builds an article index right after the article\'s creation.' =>
            'Строить индексы сообщений сразу после их создания',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Пример настройки CMD. Игнорирует письма, если внешняя CMD возвращает некоторый вывод на STDOUT (письмо будет направлено в STDIN в некий .bin).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Cache time, в сек, для аутентификации агентов в GenericInterface.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Cache time, в сек, для аутентификации клиентов в GenericInterface.',
        'Cache time in seconds for the DB ACL backend.' => 'Cache time, в сек, для DB ACL backend.',
        'Cache time in seconds for the DB process backend.' => 'Cache time, в сек, для DB process backend.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Cache time, в сек, для SSL certificate атрибутов.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Cache time, в сек, для модуля вывода на навигационной панели процессных заявок.',
        'Cache time in seconds for the web service config backend.' => 'Cache time, в сек, для backend конфигурации веб сервисов.',
        'Change password' => 'Изменить пароль',
        'Change queue!' => 'Сменить очередь!',
        'Change the customer for this ticket' => 'Изменить клиента для этой заявки',
        'Change the free fields for this ticket' => 'Изменить свободные поля для этой заявки',
        'Change the priority for this ticket' => 'Поменять приоритет заявки',
        'Change the responsible person for this ticket' => 'Изменить ответственного за заявку',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Изменить Владельца заявок на любого (полезно для ASP). Обычно, только агенты с rw - правами в очереди отображаются.',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Проверяет SystemID в номере заявки при обнаружении ответа коиента(follow-ups)(Используйте "Нет" если SystemID был изменен до получения ответа).',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Фильтры в столбцах для просмотра заявок в режиме "Small".',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Комметарий для новых записей истории в интерфейсе клиента.',
        'Company Status' => 'Информация по компании клиента',
        'Company Tickets' => 'Заявки компании',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Имя Компании, включаемое в исходящее письмо как X-Header.',
        'Configure Processes.' => 'Настройка Процессов',
        'Configure and manage ACLs.' => 'Создание/Редактирование и управление ACL',
        'Configure your own log text for PGP.' => 'Настроить свой собственный текст журнала для PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Задает возможность сортировки заявок для клиента',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Задает возможность указать более одного клиента для новой телефонной заявки в интерфейсе агента.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Управляет удалением флагов просмотра заявок и сообщений при архивирвании заявки.',
        'Converts HTML mails into text messages.' => 'Преобразовать письмо из HTML в текст',
        'Create New process ticket' => 'Создать новую процессную заявку',
        'Create and manage Service Level Agreements (SLAs).' => 'Создание и управление Соглашениями об Уровне Сервиса (SLA-ми).',
        'Create and manage agents.' => 'Создание и управление агентами.',
        'Create and manage attachments.' => 'Создание и управление вложениями.',
        'Create and manage customer users.' => 'Создание и управление клиентом.',
        'Create and manage customers.' => 'Создание и управление компаниями.',
        'Create and manage dynamic fields.' => 'Создание и управление динамическими полями.',
        'Create and manage event based notifications.' => 'Создание и управление уведомлениями по событию.',
        'Create and manage groups.' => 'Создание и управление группами.',
        'Create and manage queues.' => 'Создание и управление очередями.',
        'Create and manage responses that are automatically sent.' => 'Создание и управление автоответами.',
        'Create and manage roles.' => 'Создание и управление ролями.',
        'Create and manage salutations.' => 'Создание и управление приветствиями.',
        'Create and manage services.' => 'Создание и управление сервисами.',
        'Create and manage signatures.' => 'Создание и управление подписями.',
        'Create and manage templates.' => 'Создание и управление шаблонами.',
        'Create and manage ticket priorities.' => 'Создание и управление приоритетами заявок.',
        'Create and manage ticket states.' => 'Создание и управление состояними заявок.',
        'Create and manage ticket types.' => 'Создание и управление типами заявок.',
        'Create and manage web services.' => 'Создание и управление веб-сервисами.',
        'Create new email ticket and send this out (outbound)' => 'Создать заявку по email (исходящую) и отправить ее',
        'Create new phone ticket (inbound)' => 'Создать телефонную заявку (входящую)',
        'Create new process ticket' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '',
        'Customer User <-> Groups' => 'Клиенты <-> Группы',
        'Customer User <-> Services' => 'Клиенты <-> Сервисы',
        'Customer User Administration' => 'Управление клиентами',
        'Customer Users' => 'Клиенты',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Показать количество закрытых заявок клиента в Информации о клиенте. Установка CustomerUserLogin в 1 считает все заявки для логина клиента, а не по CustomerID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Показать количество открытых заявок клиента в Информации о клиенте. Установка CustomerUserLogin в 1 считает все заявки для логина клиента, а не по CustomerID.',
        'CustomerName' => 'Имя Клиента',
        'Customers <-> Groups' => 'Клиенты <-> Группы',
        'Data used to export the search result in CSV format.' => 'Данные используемые для экспорта результатов поиска в CSV формате',
        'Date / Time' => 'Дата/Время',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Отладка состояния локализации. Если установлено в "Да"("Yes"), все непереведенные строки записываются в STDERR. Это полезно при создании пользовательского файла локализации (ru_custom.pm). В рабочем режиме, значение параметра д.б. "Нет".',
        'Default ACL values for ticket actions.' => 'Стандартные значения ACL для действий по заявке.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Стандартные префиксы идентификаторов элементов процессов в Управлении Процессами, генерируемые автоматически (напр. A, T, AD, TA).',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Стандартные данные, используемые для атрибутов поиска. Например: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Стандартные данные, используемые для атрибутов поиска. Например: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default loop protection module.' => 'Стандартный модуль защиты от зацикливания.',
        'Default queue ID used by the system in the agent interface.' => 'ID очереди по умолчанию используемый в системе в интерфейсе агента.',
        'Default skin for OTRS 3.0 interface.' => 'Стандартная тема оформления для интерфейса OTRS 3.0.',
        'Default skin for the agent interface (slim version).' => 'Стандартная тема оформления для интерфейса агента (slim version).',
        'Default skin for the agent interface.' => 'Стандартная тема оформления для интерфейса агента.',
        'Default ticket ID used by the system in the agent interface.' =>
            'TicketID по умолчанию, для использования в интерфейсе агента.',
        'Default ticket ID used by the system in the customer interface.' =>
            'TicketID по умолчанию, для использования в интерфейсе клиента.',
        'Default value for NameX' => 'Умалчиваемое значение для NameX',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Задать фильтр для вывода в HTML для добавления ссылки после определенной строки. Элемент Image может быть в двух вариантах. Первый - имя рисунка (напр. faq.png). В этом случае должен использоваться путь к файлам рисунков OTRS. Во втором вставить ссылку на рисунок.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'Задать сопоставление между переменной, содержащей данные клиента (ключ) и динамическим полем заявки (значение). Целью является сохранить данные клиента в динамических полях заявки. Эти поля должны быть созданы в системе и сделаны доступными в AgentTicketFreeText, чтобы агент мог их ввести или исправить вручную. Они не должны быть доступны для ввода или редактирования в AgentTicketPhone, AgentTicketEmail или AgentTicketCustomer, во избежание перекрытия автоматическии установленных значений. Для использования этой возможности Вы должны также активизировать следующий параметр ниже.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Задайте имя динамического поля для конца периода. Это поле надо создать как Тип "Заявка": "Date / Time" и активировать для экранов создания заявки и/или любого другого действия с заявкой.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Задайте имя динамического поля для начала периода. Это поле надо создать как Тип "Заявка": "Date / Time" и активировать для экранов создания заявки и/или любого другого действия с заявкой.',
        'Define the max depth of queues.' => 'Задайте максимальный уровень вложенности для очередей',
        'Define the start day of the week for the date picker.' => 'Укажите первый день недели для использовании при выборе даты',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Задайте список слов, игнорируемых при проверке правописания',
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
            'Задать регулярное выражение для исключения некоторых адресов из проверки правописания (если "CheckEmailAddresses" установлено в "Да"). Введите regex в это поле для почтовых адресов, которые синтаксически неверны, но необходимы в системе (напр. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Задать регулярное выражение для  для фильтрации всех почтовых адресов, которые не будут использоваться в системе.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Задать полезные модули для загрузки пользовательских опций или отображения новостей',
        'Defines all the X-headers that should be scanned.' => 'Задать все X-headers, которые должны проверятся.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Задать все языки, которые могут использоваться в системе. Пара Ключ/Содержание задает связь отображаемого названия языка в настройках с именем соответствующег PM языкового файла (т.е. ru.pm это файл, тогда как ru - значение ключа. "Содержание" должно содержать его название на экранах выбора параметров.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Задать все параметры для объекта "Интервал обновления" в личных настройках в интерфейсе клиента',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Задать все параметры для объекта "Заявок на страницу" в личных настройках в интерфейсе клиента',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Задать все параметры для этого элемента в личных настройках в интерфейсе клиента',
        'Defines all the possible stats output formats.' => 'Задает возможные форматы вывода отчетов',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Задает какие атрибуты заявки агент может выбрать для сортировки в обзоре заявок в очередях.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Задает состав атрибутов в поле От письма (отправляемых в ответах и почтовых заявках)',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Устанавливает, должна ли быть выполнена предварительная сортировка поп приоритету в обзоре очередей',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при закрытии заявки в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при пересылке заявки в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при ответе на заявку в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при перенаправлении (forward) заявки в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при редактировании Дополнительных полей заявки в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при слиянии на заявок в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при написании Заметки к заявке в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при изменении Владельца заявки в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при переводе заявки в ожидание в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при регистрации входящего звонка клиента в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при регистрации исходящего звонка клиенту в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при изменении приоритета заявки в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при изменении Ответственного за заявку в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Требуется ли блокировка заявки при изменении клента заявки в интерфейсе агента (если заявка еще не заблокирована, она блокируется и текущий агент становится ее Владельцем)',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Включает проверку правописания при написании сообщений.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Включает расширенные средства редактирования.',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Сделать Учет времени обязательным в интерфейсе агента.',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Включить Учет времени для всех заявок при массовом действии.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Выбор очередей, заявки из которых будут отображаться в Календаре событий по заявкам в Дайджесте.',
        'Defines scheduler PID update time in seconds.' => '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            'Задает время перехода планировщика в спящий режим после выполнения всех доступных задач (число с плавающей точкой).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Задает регулярное выражение для IP для доступа к локальному репозиторию. его надо указать, чтбы иметь доступ к вашему локальному репозиторию и package::RepositoryList требуется для удаленного хоста.',
        'Defines the URL CSS path.' => 'Задает путь к URL CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Задает путь в виде URL к icons, CSS и Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Задает путь в виде URL к файлам иконок навигационной панели.',
        'Defines the URL java script path.' => 'Задает путь в виде URL к java скриптам.',
        'Defines the URL rich text editor path.' => 'Задает путь в виде URL к rich text editor',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Задать адрес выделенного DNS сервера , если необходимо, для проверки "CheckMXRecord".',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Задает текст письма в почтовом уведомлении, посылаемом агентам, о новом пароле (после использования этой ссылки, будет выслан новый пароль).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Задает текст письма в почтовом уведомлении, посылаемом агентам, с сообщением о запросе нового пароля (после использования этой ссылки, будет выслан новый пароль).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Задает текст письма в почтовом уведомлении, посылаемом клиентам, о создании новой учетной записи.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Задает текст письма в почтовом уведомлении, посылаемом клиентам, о новом пароле (после использования этой ссылки, будет выслан новый пароль)',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Задает текст письма в почтовом уведомлении, посылаемом клиентам, с сообщением о запросе нового пароля (после использования этой ссылки, будет выслан новый пароль).',
        'Defines the body text for rejected emails.' => 'Задает содержание сообщения для отвергнутых писем',
        'Defines the boldness of the line drawed by the graph.' => 'Определяет толщину линии для графика',
        'Defines the calendar width in percent. Default is 95%.' => 'Задает ширину фрейма для Календаря в процентах. Стандартно - 95%.',
        'Defines the colors for the graphs.' => 'Задает цвета для графика/диаграммы',
        'Defines the column to store the keys for the preferences table.' =>
            'Задает колонку для хранения ключей для таблицы личных настроек.',
        'Defines the config options for the autocompletion feature.' => 'Задает настройки для функции автозавершения.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Задает параметры для этого элемента, которые будут отображаться на экране личных настроек.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Задает параметры для этого элемента, которые будут отображаться на экране личных настроек. Следите за содержанием соответствующих словарей в системе.',
        'Defines the connections for http/ftp, via a proxy.' => 'Задает параметры для соединения для http/ftp, через proxy.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Задает способ ввода даты (выбором (option) или прямым вводом в поле (input).',
        'Defines the default CSS used in rich text editors.' => 'Задает стандартные CSS, используемые в текстовом редакторе (rich text editor).',
        'Defines the default auto response type of the article for this operation.' =>
            'Задает стандартный тип автоответа для этой операции.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Задает стандартный текст заметки при редактировании Дополнительных полей (ticket free text) в интерфейсе агента.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Задает имя темы (HTML theme)(имя папки для альтернативных модулей), которая будет использоваться в интерфейсах агентов и клиентов. По желанию, вы можете добавить свою собственную тему. Подробности в руководстве администратора http://doc.otrs.org/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Задает язык интерфейса по умолчанию. Все доступные значения определяются наличием соответствующих языковых файлов в системе (см. следующий параметр).',
        'Defines the default history type in the customer interface.' => 'Задает тип записи истории в интерфейсе клиента.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Задает максимальное количество атрибутов для оси - Х для временНой шкалы.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Задает максимальное количество строк результата поиска на странице обзора.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Задает следующее состояние по умолчанию для заявки в интерфейсе клиента после ответа на сообщение.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки при закрытии заявки в интерфейсе агента.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки при массовом действии (bulk action) в интерфейсе агента.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки при редактировании Дополнительных полей в интерфейсе агента.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки в интерфейсе агента.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки при смене Владельца заявки при ее просмотре в интерфейсе агента.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки при переводе заявки в ожидание в интерфейсе агента.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки при изменении приоритета заявки в интерфейсе агента.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после добавления заметки при смене Ответственного за заявку в интерфейсе агента.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после отправки (bounce) на экране Отправить заявки в интерфейсе агента.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки после перенаправлении (forward) заявки на экране Переслать в интерфейсе агента.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию для заявки при создании ответа/сообщения в интерфейсе агента.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Задать стандартный текст для телефонной заявки при регистрации входящего звонка клиента в интерфейсе агента.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Задать стандартный текст для телефонной заявки при регистрации исходящего звонка клиенту в интерфейсе агента.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Задает приоритет по умолчанию при ответе клиента через клиентский интерфейс.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Задает приоритет по умолчанию для новой заявки клиента через клиентский интерфейс.',
        'Defines the default priority of new tickets.' => 'Задает умалчиваемый приоритет для новых заявок',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Задает умалчиваемую очередь для новых заявок, создаваемых клиентом в WEB интерфейсе.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Задает стандартный выбор для выпадающего меню для динамических объектов (Экран: Общие характеристики).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Задает стандартный выбор для выпадающего меню для прав доступа (Экран: Общие характеристики).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Задает стандартный выбор для выпадающего меню для формата вывода (Экран: Общие характеристики). Выберите тип формата (смотрите параметр Формат вывода).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Выберите умалчиваемый тип отправителя для телефонной заявки при регистрации входящего звонка в интерфейсе агента.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Выберите умалчиваемый тип отправителя для телефонной заявки при регистрации исходящего звонка клиенту в интерфейсе агента.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Выберите умалчиваемый тип отправителя для заявки при ответе в интерфейсе клиента.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Выберите атрибут по умолчанию для показа на экране поискового запроса.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Выберите атрибут по умолчанию для показа на экране поискового запроса. Пример: "Ключ" должен содержать имя динамического поля в этом случае \'X\', "Содержание" значение динамического поля в зависимости от его типа,  Текст: \'текст\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' и или \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Умалчиваемый критерий сортировки для всех очередей отображаемых в обзоре очередей.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Умалчиваемый порядок сортировки для всех очередей отображаемых в обзоре очередей, после сортировки по приоритету.',
        'Defines the default spell checker dictionary.' => 'Словарь для проверки правописания.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Умалчиваемое состояние для новых заявок в интерфейсе клиента.',
        'Defines the default state of new tickets.' => 'Задает состояние по умалчанию для новых заявок',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Тема по умолчанию для телефонной заявки на экране регистрации входящего звонка клиента в интерфейсе агента.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Тема по умолчанию для телефонной заявки на экране регистрации исходящего звонка клиенту в интерфейсе агента.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Тема по умолчанию для сообщения при редактировании Дополнительных полей в интерфейсе агента',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Задает атрибут заявки по умолчанию для сортировки заявок при поиске в интерфейсе клиента.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Задает атрибут заявки по умолчанию для сортировки заявок в обзоре эскалаций в интерфейсе агента.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Задает атрибут заявки по умолчанию для сортировки заявок в обзоре блокированных заявок в интерфейсе агента.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Задает атрибут заявки по умолчанию для сортировки заявок в обзоре заявок Ответственного в интерфейсе агента.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Задает атрибут заявки по умолчанию для сортировки заявок в обзоре статусов заявок в интерфейсе агента.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Задает атрибут заявки по умолчанию для сортировки заявок в обзоре наблюдаемых заявок в интерфейсе агента.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Задает атрибут заявки по умолчанию для сортировки заявок в обзоре результатов поиска в интерфейсе агента.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Задает  стандартный текст сообщения об отправке заявки  для клиента/получателя заявки на экране Отправить в интерфейсе агента.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию после регистрации входящего звонка клиента в интерфейсе агента.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Задает следующее состояние по умолчанию после регистрации исходящего звонка клиента в интерфейсе агента.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Задает стандартный порядок сортировки (после приоритета) в обзоре эскалаций в интерфейсе агента. Up: старые вверху. Down: новые вверху.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Задает стандартный порядок сортировки (после приоритета) в обзоре статусов в интерфейсе агента. Up: старые вверху. Down: новые вверху.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Задает стандартный порядок сортировки в обзоре Ответственных в интерфейсе агента. Up: старые вверху. Down: новые вверху.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Задает стандартный порядок сортировки в обзоре заблокированных в интерфейсе агента. Up: старые вверху. Down: новые вверху.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Задает стандартный порядок сортировки в результатах поиска в интерфейсе агента. Up: старые вверху. Down: новые вверху.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Задает стандартный порядок сортировки в обзоре наблюдаемых заявок в интерфейсе агента. Up: старые вверху. Down: новые вверху.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Задает стандартный порядок сортировки в результатах поиска в интерфейсе клиента. Up: старые вверху. Down: новые вверху.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране закрытия заявки в интерфейсе агента.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране массовых действий в интерфейсе агента.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране изменения Дополнительных полей заявки в интерфейсе агента.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране создания заметки к заявке в интерфейсе агента.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране назначения Владельца при просмотре заявки в интерфейсе агента.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране перевода заявки в ожидание при просмотре заявки в интерфейсе агента.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране назначения Приоритета при просмотре заявки в интерфейсе агента.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Задает умалчиваемый приоритет заявки на экране назначения Ответственного при просмотре заявки в интерфейсе агента.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Задает умалчиваемый приоритет заявки для новой заявки в интерфейсе клиента.',
        'Defines the default type for article in the customer interface.' =>
            'Задает умалчиваемый тип сообщения в интерфейсе клиента.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения при пересылке на экране Переслать в интерфейсе агента.',
        'Defines the default type of the article for this operation.' => 'Задает умалчиваемый тип сообщения для этой операции.',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране закрытия в интерфейсе агента.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения при массовых действиях в интерфейсе агента.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране изменения Дополнительных полей в интерфейсе агента.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране создания Заметки в интерфейсе агента.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране назначения Владельца при просмотре заявки в интерфейсе агента.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране при переводе заявки в ожидание при просмотре заявки в интерфейсе агента.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране регистрации входящего звонка при просмотре заявки в интерфейсе агента.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране регистрации исходящего звонка при просмотре заявки в интерфейсе агента.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране изменения приоритета при просмотре заявки в интерфейсе агента.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Задает умалчиваемый тип сообщения на экране назначения Ответственного при просмотре заявки в интерфейсе агента.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Задает умалчиваемый тип сообщения на экране просмотра в интерфейсе клиента.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Задает модуль по умолчанию, если никакой параметр Action (в url)не указан в интерфейсе агента.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Задает модуль по умолчанию, если никакой параметр Action (в url)не указан в интерфейсе клиента.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Задает умалчиваемое значение параметра Action для общедоступного (public) интерфейса. Параметр Action используется в скриптах системы.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Задает умалчиваемый отображаемый тип отправителя заявки (стандартно: customer).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Задает динамическое поле, отображаемое при событиях календаря.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Задает фильтр для текста сообщений для подсветки URLs.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Задает полный доменный адрес системы. ОН используется в качестве тэга OTRS_CONFIG_FQDN при написании текстов сообщений для ссылки на заявки. ',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Задает список групп, в которые включаются все клиенты (если CustomerGroupSupport включена и вы не желаете делать это для каждого клиента по отдельности).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Задает высоту окна текстового редактора на этом экране. Введите число пикселей и значение в процентах.',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Задает высоту окна текстового редактора. Введите число пикселей и значение в процентах.',
        'Defines the height of the legend.' => 'Задает высоту поля легенды',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории при закрытии заявки, в интерфейсе агента.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для новой почтовой заявки, в интерфейсе агента.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для новой телефонной заявки, в интерфейсе агента.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Задает текст комментария в записи истории при изменении Дополнительных полей, в интерфейсе агента.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для новой заметки, в интерфейсе агента.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории при назначении Владельца заявки, в интерфейсе агента.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для экрана перевода заявки в ожидание, в интерфейсе агента.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для экрана регистрации входящего звонка клиента, в интерфейсе агента.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для экрана регистрации исходящего звонка клиента, в интерфейсе агента.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для экрана изменения приоритета, в интерфейсе агента.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для экрана назначения Ответственного, в интерфейсе агента.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Задает текст комментария в записи истории для экрана подробного просмотра заявки, в интерфейсе агента.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Задает текст комментария в записи истории для этой операции, в интерфейсе агента.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана закрытия заявки, в интерфейсе агента.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана новой почтовой заявки, в интерфейсе агента.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана новой телефонной заявки, в интерфейсе агента.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Задает текст в записи истории для экрана изменения Дополнительных полей заявки, в интерфейсе агента.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана новой заметки в заявке, в интерфейсе агента.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана назначения Владельца заявки, в интерфейсе агента.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана перевода заявки в ожидание, в интерфейсе агента.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана регистрации входящего звонка клиента, в интерфейсе агента.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана регистрации исходящего звонка клиента, в интерфейсе агента.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана изменения проритета заявки, в интерфейсе агента.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для экрана изменения Ответственного за заявку, в интерфейсе агента.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Задает текст в записи истории для экрана подробного просмотра заявки, в интерфейсе агента.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Задает текст в записи истории для этой операции, в интерфейсе агента.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => 'Задает часы и дни недели для подсчета рабочего времени',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Задает ключ, который проверяется модулем Kernel::Modules::AgentInfo. Если этот ключ личных настроек верен, сообщение принимается системой.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Задает ключ, который проверяется модулем CustomerAccept. Если этот ключ личных настроек верен, сообщение принимается системой.',
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Задает тип связи \'Normal\'. Если исходное имя и планируемое имя содержат одинаковое значение, то результирующая связь - ненаправленная; иначе - направленная.',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Задает тип связи \'ParentChild\'. Если исходное имя и планируемое имя содержат одинаковое значение, то результирующая связь - ненаправленная; иначе - направленная.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Задает группы типов связи. Типы связи одинаковых групп отменяют друг друга. Например: Если заявка А связана связью типа \'Normal\'с заявкой Б, то эти заявки не могут быть дополнительно связаны связью типа \'ParentChild\'.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Задает список online репозиториев. Другие установленные системы могут быть использованы в качестве репозиториев, например: Ключ="http://example.com/otrs/public.pl?Action=PublicRepository;File=" и Содержание="Some Name".',
        'Defines the list of possible next actions on an error screen.' =>
            '',
        'Defines the list of types for templates.' => 'Задает список типов для шаблонов',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Задает расположение для получения списка online репозиториев для дополнительных пакетов. Будет использоваться первый доступный.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Задает тип журнала для системы. "File" пишет все сообщения в указанный logfile, "SysLog" использует syslog daemon системы, т.е. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Задает максимальный размер в байтах для файлов загружаемых через браузер. Предупреждение: Не задавайте слишком малое значение этому параметру во избежание остановки работы OTRS',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Задает максимально возможное время (в секундах) для сессии (session id).',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            'Задает максимальную длину (в символах) для данных Планировщика. Внимание: Не изменяйте этот параметр, не проверив текущее значение в БД для "task_data" полученное из таблицы "scheduler_data_list".',
        'Defines the maximum number of pages per PDF file.' => 'Задает максимальное количество страниц для PDF файла',
        'Defines the maximum size (in MB) of the log file.' => 'Задает максимальный размер (в MB) для файла журнала.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Задает модуль который показывает основные уведомления в интерфейсе агента. Либо "Text", если настроен, либо содержимое "File" будет отображаться.',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Задает модуль который показывает всех подключившихся клиентов в интерфейсе агента.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Задает модуль который показывает всех подключившихся агентов в интерфейсе агента.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Задает модуль который показывает всех подключившихся агентов в интерфейсе клиента.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Задает модуль который показывает всех подключившихся клиентов в интерфейсе клиента.',
        'Defines the module to authenticate customers.' => 'Задает модуль аутентификации клиентов',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            'Задает модуль который показывает уведомление в интерфейсе агента, если не запущен Планировщик.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Задает модуль который показывает уведомление в интерфейсе агента, если агент зашел в систему при включенном режиме "Вне офиса".',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Задает модуль который показывает уведомление в интерфейсе агента, что вы зашли в систему как администратор (в обычном режиме вы не должны работать под этой учетной записью).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Задает модуль для отправки почты. "Sendmail" непосредственно использует sendmail сервис вашей ОС. Любой из "SMTP" механизмов использует заданный (внешний) почтовый сервер. "DoNotSendEmail" отключает отправку почты, это может быть полезно при тестировании системы.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Задает модуль для сохранения данных сеансов. "DB" - сохраняются в БД системы. "FS" - быстрее.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Имя приложения, показываемое в веб - интерфейсе, вкладке и заголовке браузера.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Задает имя колонки для хранения данных в preferences table.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'адает имя колонки для хранения идентификатора пользователя в preferences table.',
        'Defines the name of the indicated calendar.' => 'Задает имя выбранного календаря.',
        'Defines the name of the key for customer sessions.' => 'Задает имя ключа для сеансов клиента.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Задает имя ключа для сеанса. Т.е. Session, SessionID или OTRS.',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Задает имя таблицы в которой сохраняются личные настройки клиентов.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Задает список следующих доступных состояний после ответа на заявку на экране создания ответа в интерфейсе агента.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Задает список следующих доступных состояний после пресылки заявки на экране Переслать в интерфейсе агента.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Задает список следующих доступных состояний для заявок клиента в интерфейсе клиента.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране закрытия заявки в интерфейсе агента.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране Массовое действие в интерфейсе агента.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране Дополнительные поля в интерфейсе агента.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране Заметка (Сообщение) в интерфейсе агента.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране назначения Вдладельца заявки в интерфейсе агента.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране перевода заявки в состояние ожидания в интерфейсе агента.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране смены Приоритета заявки в интерфейсе агента.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Задает следующее состояние заявки после добавления заметки на экране назначения Ответственного в интерфейсе агента.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Задает следующее состояние заявки после перенаправления заявки на экране перенаправления заявки в интерфейсе агента.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Задает следующее состояние заявки после перемещения заявки в другую очередь на экране  перемещения заявки в другую очередь в интерфейсе агента.',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => 'Задает параметры личных настроек для клиента',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Задает параметры для Дайджеста. "Group" используется для ограничения доступа к нему (т.е. Group: admin;group1;group2;). "Default" означает, что он досупен по умолчанию или агент может его включить сам. "CacheTTL"  задает период обновления кэша в минутах.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Задает параметры для Дайджеста. "Group" используется для ограничения доступа к нему (т.е. Group: admin;group1;group2;). "Default" означает, что он досупен по умолчанию или агент может его включить сам. "CacheTTLLocal" задает период обновления кэша в минутах.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Задает параметры для Дайджеста. "Limit" задает количество записей отображаемых по умолчанию. "Group" используется для ограничения доступа к нему (т.е. Group: admin;group1;group2;). "Default" означает, что он досупен по умолчанию или агент может его включить сам. "CacheTTL"  задает период обновления кэша в минутах.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Задает параметры для Дайджеста. "Limit" задает количество записей отображаемых по умолчанию. "Group" используется для ограничения доступа к нему (т.е. Group: admin;group1;group2;). "Default" означает, что он досупен по умолчанию или агент может его включить сам. "CacheTTLLocal"  задает период обновления кэша в минутах.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Задает пароль доступа к обработчику SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Задает путь и файл TTF для bold italic monospaced font для PDF докуметов.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Задает путь и файл TTF для bold italic proportional font для PDF докуметов.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Задает путь и файл TTF для bold monospaced font для PDF докуметов.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Задает путь и файл TTF для bold proportional font для PDF докуметов.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Задает путь и файл TTF для  italic monospaced font для PDF докуметов.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Задает путь и файл TTF для  italic proportional font для PDF докуметов.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Задает путь и файл TTF для monospaced font для PDF докуметов.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Задает путь и файл TTF для proportional font для PDF докуметов.',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            'Задает путь к файлу вывода сообщений Планировщика (SchedulerOUT.log и SchedulerERR.log).',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Задает путь к файлу info file (информационного сообщения), расположенного в Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Задает путь к PGP binary.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Задает путь к ssl binary. Может понадобиться переменная HOME - ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Задает расположение легенды. Это должен быть двухбуквенный ключ вида: \'B[LCR]|R[TCB]\'. Первая буква задает положение (Bottom or Right), вторая - выравнивание (Left, Right, Center, Top, or Bottom).',
        'Defines the postmaster default queue.' => 'Задает очередь по умолчанию для postmaster.',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            'Задает получателя телефонной заявки и отправителя для почтовой заявки ("Queue" показывает все очереди, "SystemAddress" показывает все системные адреса) в интерфейсе агента',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Задает получателя заявки ("Queue" показывает все очереди, "SystemAddress" показывает все системные адреса) в интерфейсе клиента',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Задает требуемые права для просмотра эскалаций в интерфейсе агента.',
        'Defines the search limit for the stats.' => 'Задает лимит поиска для отчетов.',
        'Defines the sender for rejected emails.' => 'Задает отправителя для отвергнутых заявок.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Задает разделитель между real name агента и почтовым адресом очереди.',
        'Defines the spacing of the legends.' => 'Задает расстояние между легендами.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Задает стандартный набор прав для клиентов в системе. Если требуются дополнительные права, вы можете указать их здесь. Права должны существовать в системе (или добавлены в нее). При дополнении таблицы с правами помните, что строка с правом "rw" всегда должна быть последней в списке.',
        'Defines the standard size of PDF pages.' => 'Задает стандартный размер страницы при выводе в PDF',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Задает новое состояние заявки при получении ответа клиента, когда заявка была уже закрыта',
        'Defines the state of a ticket if it gets a follow-up.' => 'Задает состояние заявки при получении ответа клиента',
        'Defines the state type of the reminder for pending tickets.' => 'Задает тип состояния для отложенных заявок.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Задает тему почтового сообщения, отправляемого агенту о новом пароле.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Задает тему почтового сообщения, отправляемого агенту о вновь запрошенном пароле.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Задает тему почтового сообщения, отправляемого клиенту о новой учетной записи.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Задает тему почтового сообщения, отправляемого клиенту о новом пароле.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Задает тему почтового сообщения, отправляемого клиенту о вновь запрошенном пароле.',
        'Defines the subject for rejected emails.' => 'Задает текст поля Тема для отвергнутых заявок',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Задает почтовый адрес системного администратора. Он будет отображаться в сообщениях об ошибках.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Задает идентификатор системы. Каждый номер заявки и http-сеанса содержит его. Это дает уверенность в том, что заявки только вашей системы будут обработаны как ответы (дополнения) (может быть полезно при связи между двумя установками OTRS).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Задает поля, которые будут отображаться для заявки в Календаре событий по заявкам. Ключ - задает поле или атрибут заявки, а Содержание - отображаемое имя.',
        'Defines the time in days to keep log backup files.' => 'Задает время (в днях) хранения log backup files.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Задает время в секундах, после которого выполняется авторестарт Планировщика.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Задает временную зону выбранног календаря, который позднее может быть назначен определенной очереди.',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Задает тип протокола, используемого веб-сервером для системы. Если протокол https используется вместо простого http, он должен быть указан здесь. Этот параметр не влияет на настройки сервера/ов и не изменяет метода доступа к системе, и если указан неверно, не может закрыть возможность подключения к ней. Это значение используется лишь как переменная OTRS_CONFIG_HttpType используемая как тэг при построении сообщений/уведомлений, для построения ссылки на заявку.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Задает идентификатор пользователя для клиентской панели.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Задает username для доступа к обработчику SOAP (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Задает действительные типы состояний для заявки',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Задает действительные состояния для разблокированных заявок. Для разблокирования заявок используйте скрипт "bin/otrs.UnlockTickets.pl".',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Задает отображение заявок при просмотре с этими видами блокировки . Стандартно: unlock(разблокирована), tmp_lock(временно блокировна).',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Задает ширину окна текстового редактора на этом экране. Введите число (пикселов) или значение в процентах.',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Задает ширину окна текстового редактора. Введите число (пикселов) или значение в процентах.',
        'Defines the width of the legend.' => 'Задает ширину легенды.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Задает тип отправителя сообщения, показываемый при просмотре заявки.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Задает, какие элементы доступны для "Action" на третьем уровне структуры ACL.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Задает, какие элементы доступны на первом уровне структуры ACL.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Задает, какие элементы доступны на втором уровне структуры ACL.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Задает, какие состояния будут установлены автоматически (Содержание), в зависимости от состояния ожидания (Ключ) после истечения его срока.',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Задает, какой тип сообщения открывается при входе в просмотр. Если ничего не указано, открывается последнее сообщение.',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Удаляет сеанс, если его id используется с некорректным remote IP address.',
        'Deletes requested sessions if they have timed out.' => 'Удаляет запрошенные сеансы с истекшим сроком.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Задает список доступных очередей для перемещения заявки в выпадающем списке или в новом окне в интерфейсе агента. Если выбрана опция "New Window" (в новом окне) вы можете добавить заметку о перемещении к заявке.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Задает, может ли модуль статистки создавать список заявок.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Задает список следующих доступных состояний после создания новой почтовой заявки в интерфейсе агента.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Задает список следующих доступных состояний после создания новой телефонной заявки в интерфейсе агента.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Задает список следующих доступных состояний после создания новой процессной заявки в интерфейсе агента.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Задает какой следующий экран открывается после создания заявки в интерфейсе клиента.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Задает какой следующий экран открывается после создания ответа в экране просмотра заявки в интерфейсе клиента.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Задает какой следующий экран открывается после перемещения заявки. LastScreenOverview - возвращает к последнему экрану обзора )т.е. экран результата поиска, просмотру очередей, дайджесту). TicketZoom - возвращает в просмотр заявки.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Задает возможные состояния для заявок с ожиданием, которые меняют состояние после истечения времени.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Задает строку, которая будет отображаться в поле получатель (To:) телефонной заявки или отправитель (From:) почтовой заявки в интерфейсе агента. Для очереди, если NewQueueSelectionType "<Queue>"(Очередь) отображается список имен очередей. Для SystemAddress "<Realname> <<Email>>" показывается имя и email получателя.',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Задает строку, которая будет отображаться в поле получатель (To:) заявки в интерфейсе клиента. Для очереди, если CustomerPanelSelectionType, "<Queue>" отображается список имен очередей. Для SystemAddress "<Realname> <<Email>>" показывается имя и email получателя.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Задает какие варианты будут доступны для поля Получатель (в телефонной) или Отправитель (в почтовой заявке) в интерфейсе агента.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Задает список доступных очередей для новой заяаки в интерфейсе клиента.',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Отключает отправку напоминаний ответственному агенту (Ticket::Responsible должен быть включен).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'Деактивирует веб-инсталлятор (http://yourhost.example.com/otrs/installer.pl) во избежание возможности вскрытия (хакером) системы. Если установлен в "Нет", система будет переинсталлирована и текущая базовая конфигурация будет использована для предварительного заполнения ответов на вопросы установщика. Если не включено, также отключаются возможности GenericAgent, PackageManager и SQL Box.',
        'Display settings to override defaults for Process Tickets.' => 'Отображает настройки, перекрывающие умалчиваемые для процессных заявок.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Отображает учтенное время для заметки в подробном просмотре заявки.',
        'Dropdown' => 'Выпадающий список',
        'Dynamic Fields Checkbox Backend GUI' => 'Редактор динамических полей типа Checkbox',
        'Dynamic Fields Date Time Backend GUI' => 'Редактор динамических полей типа Date Time',
        'Dynamic Fields Drop-down Backend GUI' => 'Редактор динамических полей типа Drop-down',
        'Dynamic Fields GUI' => 'Редактор динамических полей',
        'Dynamic Fields Multiselect Backend GUI' => 'Редактор динамических полей типа Multiselect',
        'Dynamic Fields Overview Limit' => 'Количество строк списка динамических полей на странице.',
        'Dynamic Fields Text Backend GUI' => 'Редактор динамических полей типа Text',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Динамические поля включаемые в результат поиска при экспорте в формате CSV.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Группы динамических полей для процессного виджета. Ключ - имя группы, Значение - содержит имена показываемых полей. Например: Ключ - "My Group", Содержание: "Name_X, NameY".',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Количество строк списка динамических полей на странице.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Параметры отображения динамических полей при создании заявки в интерфейсе клиента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено. Внимание. Если вы желаете отобразить эти поля на экране просмотра заявки в клиентском интерфейсе, необходимо активировать их в параметре CustomerTicketZoom###DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры отображения динамических полей при создании ответа на сообщение на экране просмотра заявки в интерфейсе клиента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей в процессном виджете на экране просмотра заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей в информации о заявке на экране просмотра заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране закрытия заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране ответа на заявку в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране создания почтовой заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране пересылки заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране Дополнительные поля в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей на экране просмотра заявок в medium формате в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране перемещения заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране создания заметки (сообщения) в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране обзора заявок в интерфейсе клиента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране назначения Владельца в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране перевода заявки в ожидание в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране регистрации входящего звонка клиента в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране регистрации исходящего звонка клиента в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране создания телефонной заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей в режиме предварительного просмотра на экране обзора в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей на экране печати заявки в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей на экране печати заявки в интерфейсе клиента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране назначения приоритета в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Параметры показа динамических полей на экране назначения Ответственного в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и должно быть заполнено.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей на экране обзора результатов поиска в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'Параметры показа динамических полей на экране параметров поиска в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать, 2 - показывать и ???.',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей на экране поиска в интерфейсе клиента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей на экране просмотра заявки интерфейсе клиента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'DynamicField backend registration.' => 'Регистрация типов используемых динамических полей (dropdown, text, checbox...).',
        'DynamicField object registration.' => 'Регистрация объектов  для динамических полей (поле заявки или сообщения/заметки).',
        'Edit customer company' => 'Редактировать компанию клиента',
        'Email Addresses' => 'Адреса email',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => 'Доступные фильтры.',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Включает возможность вывода в PDF формате. Требуется наличие модуля CPAN - PDF::API2, если он не установлен, вывод в PDF будет отключен.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Включает поддержку PGP, когда она включается для возможности подписи и дешифровки почты, настоятельно рекомендуется, чтобы веб-сервер запускался от имени пользователя OTRS. Иначе, возможны проблемы с привилегиями при доступе к папке .gnupg.',
        'Enables S/MIME support.' => 'Включить поддержку S/MIME',
        'Enables customers to create their own accounts.' => 'Дать возможность клиентам самостоятельно создавать свои учетные записи.',
        'Enables file upload in the package manager frontend.' => 'Включает возможность загрузки дополнительных пакетов (расширений) в Управлении пакетами.',
        'Enables or disable the debug mode over frontend interface.' => 'Включает или выключает возможность режима отладки через веб-интерфейс.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Включает/выключает функцию наблюдения за заявками, чтобы иметь возможность отслеживания заявок не будучи ее владельцем или ответственным.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Включает журналирование производительности (время загрузки страниц). Этот параметр снижает производительность системы. Параметр Frontend::Module###AdminPerformanceLog должен быть активирован.',
        'Enables spell checker support.' => 'Включает проверку правописания',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Включает минимальный размер счетчика заявок (Если "Date" было выбрано в качестве TicketNumberGenerator).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Включает возможность массовых операций с заявками',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Включает возможность массовых операций с заявками только для выбранных групп.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Включает возможностьназначения Ответственных для заявки.',
        'Enables ticket watcher feature only for the listed groups.' => 'Включает возможность Наблюдения для заявок для выбранных групп агентов.',
        'Escalation view' => 'Просмотр эскалированных заявок',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Регистрация модуля обработки события. Для большей производительности вы должны задать событие (например: Event => TicketCreate).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Регистрация модуля обработки события. Для большей производительности вы должны задать событие (например: Event => TicketCreate). Это возможно только в случае, если все динамические поля заявки нуждаются в одном и том же событии.',
        'Event module that updates customer user service membership if login changes.' =>
            'Модуль обработки события, который обновляет принадлежность сервисов клиентов после смены логина клиента.',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Модуль обработки события, который обновляет заявки клиентов после обновления учетной записи клиента.',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Execute SQL statements.' => 'Выполнить SQL запрос.',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Выполняет проверку ответа клиента в In-Reply-To или References заголовках для писем не имеющих в Теме номер заявки.',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            'Выполняет проверку вложения к почтовым ответам клиента, не имеющих в Теме номер заявки.',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            'Выполняет проверку тела сообщения в почтовых ответах клиента, не имеющих в Теме номер заявки.',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            'Выполняет проверку тела сообщения (plain/raw) в почтовых ответах клиента, не имеющих в Теме номер заявки.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Экспортирует все дерево сообщений в результат поиска (приводит к снижению производительности).',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Получает пакеты через proxy. Перекрывает параметр "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            'Файл отображаемый модулем Kernel::Modules::AgentInfo, если он помещен в Kernel/Output/HTML/Standard/AgentInfo.dtl.',
        'Filter incoming emails.' => 'Фильтрация входящей почты.',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Устанавливает кодировку исходящей почты (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Принудительно устанавливает новое состояние (отличное от текущего) поле блокрования заявки. Задайте текущее состояние как Ключ и следующее состояние как Содержание.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Сброс блокировки заявки при перемещении в другую очередь.',
        'Frontend language' => 'Язык интерфейса',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Frontend module registration (отключает ссылку на компанию, если отключена поддержка компаний).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Frontend module registration (отключает экран процессеой заявки, если нет доступных процессов) для клиента.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Frontend module registration (отключает экран процессеой заявки, если нет доступных процессов).',
        'Frontend module registration for the agent interface.' => 'Frontend module registration для интерфейса агента.',
        'Frontend module registration for the customer interface.' => 'Frontend module registration для интерфейса клиента.',
        'Frontend theme' => 'Тема интерфеса',
        'Fulltext index regex filters to remove parts of the text.' => 'Регулярное выражение для удаления части текста в запросе полнотекстового поиска.',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
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
            'Дает конечному пользователю возможность переопределить символ - разделитель для файла CSV, заданный в файле локализации.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Разрешает доступ, если customer ID заявки совпадает с customer user\'s ID и клент имеет групповые права на доступ к очереди в которой находится заявка.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Позволяет расширить возможности полнотекстового поиска (в полях From, To, Cc, Subject и Body). Runtime - выполняет поиск  по 2живым" данным (хорошо работает при количестве заявок до 50000). StaticDB удаляет все сообщения/заметки и строит индекс после их создания, увеличивая скорость поиска до 50%. Для создания начальных индексов используйте "bin/otrs.RebuildFulltextIndex.pl".',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, драйвер СУБД (обычно используется автоопределение) должен быть задан.',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, пароль для доступа к таблице клиентов должен быть указан.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, имя пользователя для доступа к таблице клиентов должно быть указано.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, имя файла для доступа к таблице клиентов должно быть указано.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, имя колонки для CustomerPassword (пароль клиента) в таблице клиентов должно быть указано.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, тип шифрования для пароля должен быть задан.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, имя колонки для CustomerKey в таблице клиентов должно быть задано.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Если "DB" выбрано для Customer::AuthModule, имя таблицы где будут храниться данные клиентов должно быть задано.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Если "DB" выбрано для SessionModule, таблица в БД, где будут храниться сеансы должна быть указана.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Если "DB" выбрано для SessionModule, папка в БД, где будут храниться сеансы должна быть указана.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Если "HTTPBasicAuth" было выбрано для Customer::AuthModule, вы можете задать (используя RegExp) удаление части REMOTE_USER (т.е. для удаления имени домена). RegExp-Note, $1 будет новый Login.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Если "HTTPBasicAuth" было выбрано для Customer::AuthModule, вы можете задать удаление части имени пользователя ( т.е. для домена типа example_domain\user получится user).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule и вы желаете добавить суффикс к каждому логину пользователя, задайте его здесь, т.е. вы вы хотите имя пользователя user, но в вашем LDAP существует user@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule и специальные параметры необходимы для Net::LDAP perl module, вы можете задать их здесь. См. "perldoc Net::LDAP" для дополнительной информации о параметрах.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule, BaseDN должен быть указан.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule, хост для LDAP должен быть указан.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule, идентификатор пользователя должен быть указан.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule, атрибуты пользователя должны быть указаны. для LDAP posixGroups используйте UID, для не LDAP posixGroups используйте полный DN пользователя.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule, вы можете задать атрибуты доступа здесь.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule, вы можете задать должно ли приложение быть остановлено если, например, соединение с сервером не может быть установлено из-за проблем с сетью.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Если "LDAP" было выбрано для Customer::AuthModule, вы можете проверять позволено ли клиенту входить, т.к. он член posixGroup, например, пользователь должен быть в группе xyz длч работы в OTRS. Задайте группу, которая имеет доступ к системе.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Если "LDAP" было выбрано, вы можете добавить фильтр для каждого LDAP запроса, например (mail=*), (objectclass=user) или (!objectclass=computer).',
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
            'Если "SysLog" было выбрано для LogModule, набор символов (charset) для запси в журнал может быть задан.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Если "file" было выбрано для LogModule, файл должен быть задан. Если файл не существует, он будет создан системой.',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране закрытия в интерфейсе агента.',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране массового действия в интерфейсе агента.',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране Дополнительные поля в интерфейсе агента.',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране создания сообщения/заметки в интерфейсе агента.',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране назначения Ответственного в интерфейсе агента.',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране назначения Владельца в интерфейсе агента.',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на экране перевода в ожидание в интерфейсе агента.',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Если сообщение/заметка добавлена агентом, задает состояние заявки на смены приоритета в интерфейсе агента.',
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
            'Если включено, OTRS выполняет все JavaScript в минимизированной форме.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Если включено, TicketPhone and TicketEmail будут открываться в новом окне браузера.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            'Если включено, номер версии OTRS будет удален из веб-интерфейса, HTTP-заголовков и X-Headers в исходящей почте.',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Если включено, экраны обзоров (дайджест, просмотр заблокированных, просмотр очереди) будут автоматически обновляться по истечении указанного времени.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Если включено, первый уровень меню будет открываться по наведению указателя мыши (вместо только "клика").',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
            'Если включено, то расшифрованное содержимое будет сохраняться в БД, если оно отображается в AgentTicketZoom.',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            'Если установлено в "Да", заявки, созданные через веб - интерфес клиента или агента, будут получать автоответы (если они заданы). Иначе, автоответы посылаться не будут.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Если это регулярное выражение верно, сообщение не будет посылаться автоответчиком.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            'Если вы хотите использовать зеркальную базу данных для полнотекстового поиска или построения отчетов агентом, задайте ее имя (DSN).',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            'Если вы хотите использовать зеркальную базу данных для полнотекстового поиска или построения отчетов агентом, задайте пароль для доступа к ней.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            'Если вы хотите использовать зеркальную базу данных для полнотекстового поиска или построения отчетов агентом, задайте логин для доступа к ней.',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            'Игнорировать системные сообщения для новых сообщений (например автоответы или почтовые уведомления).',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Включить время создания сообщений/заметок в атрибуты поиска в интерфейсе агента.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            'IndexAccelerator: для выбора серверного TicketViewAccelerator модуля. "RuntimeDB" - строит каждый обзор (view) на лету из таблицы заявок (не будет проблем с производительностью, примерно, до общего объема в 60000 заявок и 6000 открытых). "StaticDB" - наиболее мощный модуль, он использует внешнюю таблицу индексов заявок (рекомендуется при объеме более 80000 заявок при 6000 открытых хранимых в системе). Используйте скрипт "bin/otrs.RebuildTicketIndex.pl" для первичного обновления индексов.',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Язык интерфейса',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Можно задать разные схемы оформления, напрмер, чтобы отличать агентов из разных доменов. Используя регулярные выражения (regex), вы можете задать пары Ключ/Содержание, соответствующие доменам. Значение Ключа должно соответствовать домену, а значение Содержания - имя схемы (skin) в системе. Смотрите пример для правильного построения регулярного выражения.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Можно задать разные схемы оформления, напрмер, чтобы отличать клиентов из разных доменов. Используя регулярные выражения (regex), вы можете задать пары Ключ/Содержание, соответствующие доменам. Значение Ключа должно соответствовать домену, а значение Содержания - имя схемы (skin) в системе. Смотрите пример для правильного построения регулярного выражения.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Можно задать разные схемы оформления, напрмер, чтобы отличать агентов и клиентов, на основе принадлежности к доменам. Используя регулярные выражения (regex), вы можете задать пары Ключ/Содержание, соответствующие доменам. Значение Ключа должно соответствовать домену, а значение Содержания - имя схемы (skin) в системе. Смотрите пример для правильного построения регулярного выражения.',
        'Lastname, Firstname' => 'Фамилия, Имя',
        'Lastname, Firstname (UserLogin)' => 'Фамилия, Имя (UserLogin)',
        'Link agents to groups.' => 'Связать агентов с группами.',
        'Link agents to roles.' => 'Связать агентов с ролями.',
        'Link attachments to templates.' => 'Связать вложения с шаблонами.',
        'Link customer user to groups.' => 'Связать клиентов с группами.',
        'Link customer user to services.' => 'Связать клиентов с сервисами.',
        'Link queues to auto responses.' => 'Связать очереди с автоответами.',
        'Link roles to groups.' => 'Связать роли с группами.',
        'Link templates to queues.' => 'Связать шаблоны с очередями.',
        'Links 2 tickets with a "Normal" type link.' => 'Связывает 2 заявки связью типа "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Связывает 2 заявки связью типа "ParentChild".',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Список CSS файлов всегда загружаемых в интерфейсе агента.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Список CSS файлов всегда загружаемых в интерфейсе клиента.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Список IE8-specific CSS файлов всегда загружаемых в интерфейсе агента.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Список IE8-specific CSS файлов всегда загружаемых в интерфейсе клиента.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Список JS файлов всегда загружаемых в интерфейсе агента.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Список JS файлов всегда загружаемых в интерфейсе клиента.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Список по умолчанию для Стандартных Шаблонов, которые назначаются автоматически при создании новой очереди.',
        'Log file for the ticket counter.' => 'Файл для счетчика заявок',
        'Mail Accounts' => 'Почтовые аккаунты',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Включает проверку MX record почтовых адресов клиента до отправки почты или приема почтовой или телефонной заявки.',
        'Makes the application check the syntax of email addresses.' => 'Включает проверку синтаксиса адреса электронной почты.',
        'Makes the picture transparent.' => 'Прозрачная картинка',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage OTRS Group services.' => '',
        'Manage PGP keys for email encryption.' => 'Управления PGP ключами для шифрования почтовых сообщений.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Управление POP3 или IMAP учетными записями для получения почтовых сообщений.',
        'Manage S/MIME certificates for email encryption.' => 'Управление S/MIME сертификатами для шифрования почты',
        'Manage existing sessions.' => 'Управление активными сеансами.',
        'Manage notifications that are sent to agents.' => 'Управление уведомлениями, посылаемыми агентам',
        'Manage system registration.' => 'Регистрация системы на портале OTRS Group',
        'Manage tasks triggered by event or time based execution.' => 'Управление заданиями, основанными на событиях или времени выполнения',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Максимальный размер (в символах) таблицы с информацией о клиенте (при создании заявки или ответа).',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Максимальный размер (в строках) списка информируемых агентов, в агентском интерфейсе.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Максимальный размер (в строках) списка привлекаемых агентов, в агентском интерфейсе.',
        'Max size of the subjects in an email reply.' => 'Максимальная длина Темы в почтовом ответе.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Максимальное количество почтовых автоответов на собственный почтовый адрес в день (Loop-Protection).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Максимальный размер в KBytes для писем принимаемых через POP3/POP3S/IMAP/IMAPS.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Максимальная длина (в символах) для динамических полей в сообщении в подробном просмотре заявки.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Максимальная длина (в символах) для динамических полей в информации о заявке в подробном просмотре заявки.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Максимальное количество заявок отображаемых в результате поиска в интерфейсе агента.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Максимальное количество заявок отображаемых в результате поиска в интерфейсе клиента.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Максимальная длина (в символах) для таблицы информации о клиенте при просмотре заявки.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Модуль для выбора значения поля To в новой заявке в интерфейсе клиента.',
        'Module to check customer permissions.' => 'Модуль для проверки прав клиента.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            'Модуль проверки принадлежности пользователя к определенной группе. Доступ разрешается, если он принадлежит указанной группе и имеет в ней ro или rw права.',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => 'Модуль для проверки агента ответственного за заявку.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Модуль проверки прав в группах для доступа к заявкам клиента.',
        'Module to check the owner of a ticket.' => 'Модуль для проверки владельца заявки.',
        'Module to check the watcher agents of a ticket.' => 'Модуль проверки прав наблюдения за заявкой для агента',
        'Module to compose signed messages (PGP or S/MIME).' => 'Модуль создания подписанных сообщений (PGP or S/MIME).',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Модуль шифрования созданных сообщений (PGP or S/MIME).',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Модуль фильтрации и управления входящими сообщениями. Блокировать/Игнорировать весь спам от отправителей: noreply@ address.',
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
            'Модуль для показа уведомлений и эскалаций (ShownMax: мак. кол-во показываемых эскалаций, EscalationInMinutes: Показать эскалированные заявки, CacheTime: Cache для вычисленных эскалаций в сек.).',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => 'Мои заявки',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Имя пользовательского списка очередей. Это набор очередей, выбранных из списка доступных очередей в личных настройках.',
        'NameX' => '',
        'New email ticket' => 'Новая заявка по email',
        'New phone ticket' => 'Новая телефонная заявка',
        'New process ticket' => 'Новая процессная заявка',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Следующее доступное состояние после добавления заметки при регистрации входящего звонка в интерфейсе агента.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Следующее доступное состояние после добавления заметки при регистрации исходящего звонка в интерфейсе агента.',
        'Notifications (Event)' => 'Уведомление о событии',
        'Number of displayed tickets' => 'Количество отображаемых заявок',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Количество строк (на заявку) которое показывается при выводе результатов поиска в интерфейсе агента.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Количество заявок которое показывается на каждой странице при выводе результатов поиска в интерфейсе агента.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Количество заявок которое показывается на каждой странице при выводе результатов поиска в интерфейсе клиента.',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Переопределяет функции заданные в Kernel::System::Ticket::(имя папки с альтернативными модулями). Применяется для облегчения кастомизации.',
        'Overview Escalated Tickets' => 'Обзор эскалированных заявок',
        'Overview Refresh Time' => 'Время обновления обзоров',
        'Overview of all open Tickets.' => 'Обзор всех заявок',
        'PGP Key Management' => 'Управление ключами PGP',
        'PGP Key Upload' => 'Загрузить PGP ключ',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => 'Параметры для .',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            'Параметры для объекта CreateNextMask в личных настройках агента.',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            'Параметры для объекта CustomQueue в личных настройках агента.',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            'Параметры для объекта FollowUpNotify в личных настройках агента.',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            'Параметры для объекта LockTimeoutNotify в личных настройках агента.',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            'Параметры для объекта MoveNotify в личных настройках агента.',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            'Параметры для объекта NewTicketNotify в личных настройках агента.',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            'Параметры для объекта RefreshTime в личных настройках агента.',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            'Параметры для объекта WatcherNotify в личных настройках агента.',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста (CIC - Центр информации о клиентах) с информацией о компании клиента в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о состоянии заявок компании клиента в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о списке клиентов компании в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о новых заявках клиентов в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о состоянии очередей в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "QueuePermissionGroup" не обязателен, очереди отображаются только в случае принадлежности к этим группам. "States" задает список состояний, где в первой колонке указывается порядок сортировки состояний. "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о ближайших событиях (ticket calendar) в интерфейсе агента. "Limit" - количество строк по умолчанию. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией об эскалированных заявках  в интерфейсе агента. "Limit" - количество строк по умолчанию. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о заявках ожидающих напоминания в интерфейсе агента. "Limit" - количество строк по умолчанию. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о заявках ожидающих напоминания в интерфейсе агента. "Limit" - количество строк по умолчанию. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметры для раздела Дайджеста с информацией о статистике по заявкам в интерфейсе агента. "Group" используется для ограничения доступа к разделу (например, Group: admin;group1;group2;). "Default" - задает, будет ли раздел доступен по умолчанию или агент должен активировать его вручную. "CacheTTLLocal" - время обновления кэша в минутах для этого раздела.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            'Параметры для страницы (на которой отображаются динамические поля) при обзоре динамических полей.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            'Параметры для страницы (на которой отображаются заявки) при обзоре заявок в medium формате.',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            'Параметры для страницы (на которой отображаются заявки) при обзоре заявок в small формате.',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            'Параметры для страницы (на которой отображаются заявки) при обзоре заявок в preview (large) формате.',
        'Parameters of the example SLA attribute Comment2.' => 'Параметры для дополнительного атрибута SLA  Комментарий2(Comment2).',
        'Parameters of the example queue attribute Comment2.' => 'Параметры для дополнительного атрибута Очереди Комментарий2(Comment2).',
        'Parameters of the example service attribute Comment2.' => 'Параметры для дополнительного атрибута Сервиса Комментарий2(Comment2).',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Путь к лог файлу (применяется только если выбран атрибут "FS" для LoopProtectionModule и он обязателен).',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            'Путь к файлу в котором сохраняются параметры объекта QueueObject для интерфейса агента.',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            'Путь к файлу в котором сохраняются параметры объекта QueueObject для интерфейса клиента.',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            'Путь к файлу в котором сохраняются параметры объекта TicketObject для интерфейса агента.',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            'Путь к файлу в котором сохраняются параметры объекта TicketObject для интерфейса клиента.',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            'Выполняет заданное действие для каждого события (как Invoker) для каждого настроенного Webservice.',
        'Permitted width for compose email windows.' => 'Ширина окна для текста ответа.',
        'Permitted width for compose note windows.' => 'Ширина окна для текста сообщения/заметки.',
        'Picture-Upload' => 'Загрузка рисунка',
        'PostMaster Filters' => 'Фильтры PostMaster (входящей почты)',
        'PostMaster Mail Accounts' => 'Учетные записи почты для PostMaster',
        'Process Information' => 'Информация о процессе',
        'Process Management Activity Dialog GUI' => 'Управление процессами Интерфейс Диалоги Активности',
        'Process Management Activity GUI' => 'Управление процессами Интерфейс Активности',
        'Process Management Path GUI' => 'Управление процессами Интерфейс Схема',
        'Process Management Transition Action GUI' => 'Управление процессами Интерфейс Действия Переходов',
        'Process Management Transition GUI' => 'Управление процессами Интерфейс Переходы',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Защита от CSRF (Cross Site Request Forgery) эксплойтов (для более подробной информации см. http://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue.' =>
            'Обеспечивает обзор количества заявок в очередях по состояниям в виде таблицы.',
        'Queue view' => 'Просмотр очередей',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            'Распознает, что ответ/дополнение к существующей заявке использует внешний номер заявки.',
        'Refresh Overviews after' => 'Обновлять обзоры каждые',
        'Refresh interval' => 'Интервал обновления',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Удаляет признак наблюдения за заявкой при ее архивировании.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Заменяет оригинального отправителя текущим почтовым адресом клиента при написании ответа в интерфейсе агента.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Права, требуемые для изменения клиента заявки в интерфейсе агента.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Права, требуемые для закрытия заявки в интерфейсе агента.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Права, требуемые для перенаправлении заявки в интерфейсе агента.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Права, требуемые для ответа на заявки в интерфейсе агента.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Права, требуемые для пересылки заявки в интерфейсе агента.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Права, требуемые для изменения Дополнительных полей заявки в интерфейсе агента.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Права, требуемые для сляния заявок в интерфейсе агента.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Права, требуемые для написания сообщения/заметки для заявки в интерфейсе агента.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Права, требуемые для изменения Владельца заявки в интерфейсе агента.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Права, требуемые для заявки в ожидание в интерфейсе агента.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Права, требуемые для регистрации входящего звонка клиента в интерфейсе агента.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Права, требуемые для регистрации исходящего звонка клиента в интерфейсе агента.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Права, требуемые для изменения приоритета заявки в интерфейсе агента.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Права, требуемые для изменения Ответственного заявки в интерфейсе агента.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Сбрасывает Владельца и разблокирует заявку при перемещнии ее в другую очередь.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Восстанавливает заявку из архива (только по событию изменения состояния из "закрыта" в любое другое доступное состояние).',
        'Roles <-> Groups' => 'Роли <-> Группы',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Выполняет начальный поиск по символу подстановки в списке клиентов при доступе к модулю AdminCustomerUser.',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Запускает систему в режиме "Demo". Если установлено в "Да", агенты могут менять личные настройки, например, выбор языка интерфейса или темы в интерфейсе агента. Эти изменения действуют только в течение текущего сеанса. В этом режиме пароль агентом не может быть изменен.',
        'S/MIME Certificate Upload' => 'Загрузка сертификата S/MIME',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            'Сохраняет вложения из сообщений/заметок. "DB" - сохраняет их в БД (не рекомендуется для больших вложений). "FS" - сохраняет данные в файловой системе; это быстрее, но веб-сервер должен запускаться от имени пользователя OTRS. Вы можете переключать это значение в процессе работы без потери данных.',
        'Search Customer' => 'Искать клиента',
        'Search User' => 'Искать агента',
        'Search backend default router.' => 'Модуль поиска по умолчанию.',
        'Search backend router.' => 'Модуль поиска.',
        'Select your frontend Theme.' => 'Тема интерфейса (имя папки с кастомными модулями).',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Выбирает способ управления загрузкой через веб-интерфейс. "DB" - сохраняет загружаемые файлы в БД, "FS" использует файловую систему.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Выбирает способ генерации номеров заявок. "AutoIncrement" - увеличивает номер на 1 (формат - SystemID.counter(например, 1010138, 1010139). "Date" - использует текущую дату, SystemID и счетчик (вид: Year.Month.Day.SystemID.counter (200206231010138, 200206231010139). "DateChecksum" - счетчик дополняется контрольной суммой к строке из даты и SystemID. Формат строится как Year.Month.Day.SystemID.Counter.CheckSum. Контрольная сумма обновляется ежедневно (вид: 2002070110101520, 2002070110101535). "Random" - генерирует случайный номер в формате "SystemID.Random" (напр. 100057866352, 103745394596).',
        'Send notifications to users.' => 'Отправить уведомление пользователям.',
        'Sender type for new tickets from the customer inteface.' => 'Тип отправителя для новых заявок из интерфейса клиента.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Отправлять уведомления агентам об откликах только владельцу, если заявка разблокирована (по умолчанию уведомляются все агенты).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Отсылать всю исходящую почту через bcc на заданные адреса. Используйте эту опцию только резервного копирования.',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Посылать уведомление клиента показанным клиентам. Если не показано ни одного клиента, последний отправитель получит уведомление.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Посылать напоминание о разблокированных заявках после истечения времени напоминания (посылается только владельцу заявки).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Отсылать уведомления, настроенные администратором в разделе Уведомленя о событиях.',
        'Set sender email addresses for this system.' => 'Задать адрес отправителя для этой системы.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Задает высоту (в пикселах) по умолчанию для inline HTML сообщений в AgentTicketZoom.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Задает максимальную высоту (в пикселах) для inline HTML сообщений в AgentTicketZoom.',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => 'Задает, что SLA должен быть выбран агентом.',
        'Sets if SLA must be selected by the customer.' => 'Задает, что SLA должен быть выбран клиентом.',
        'Sets if note must be filled in by the agent.' => 'Задает, что сообщение должно быть заполнено агентом.',
        'Sets if service must be selected by the agent.' => 'Задает, что Сервис должен быть выбран агентом.',
        'Sets if service must be selected by the customer.' => 'Задает, что Сервис должен быть выбран клиентом.',
        'Sets if ticket owner must be selected by the agent.' => 'Задает, что Владелец должен быть выбран агентом.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Устанавливает время ожидания в 0 если состояние изменяется на состояние без ожидания.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Устанавливает возраст в минутах (первый уровень) для подсветки очередей, содержащих непросмотренные заявки.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Устанавливает возраст в минутах (второй уровень) для подсветки очередей, содержащих непросмотренные заявки.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Устанавливает уровень доступа администратора к SysConfig. В зависисмости от установленного уровня, некоторые параметры конфигурации не будут показываться. Чем выше уровень (Beginner - наивысший, всего их три - Expert, Advanced, Beginner), тем меньше вероятность внесения в конфигурацию изменений, которые могут привести ее в неработоспособное состояние.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Устанавливает видимость счетчика сообщений в preview mode (L) просмотра заявок.',
        'Sets the default article type for new email tickets in the agent interface.' =>
            'Устанавливает тип сообщения по умолчанию для новой почтовой заявки в интерфейсе агента.',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            'Устанавливает тип сообщения по умолчанию для новой телефонной заявки в интерфейсе агента.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Устанавливает текст сообщения по умолчанию при закрытии заявки в интерфейсе агента.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Устанавливает текст сообщения по умолчанию при перемещении заявки в другую очередь в интерфейсе агента.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Устанавливает текст сообщения по умолчанию при создании сообщения к заявке в интерфейсе агента.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Устанавливает текст сообщения по умолчанию при смене Владельца заявки в интерфейсе агента.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Устанавливает текст сообщения по умолчанию при переводе заявки в ожидание в интерфейсе агента.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Устанавливает текст сообщения по умолчанию при смене приоритета заявки в интерфейсе агента.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Устанавливает текст сообщения по умолчанию при назначении Ответственного заявки в интерфейсе агента.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Задает тип связи по умолчанию при разделения заявки в интерфейсе агента.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Устанавливает следующее состояние по умолчанию для новой телефонной заявки в интерфейсе агента.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Устанавливает следующее состояние по умолчанию при создании новой почтовой заявки в интерфейсе агента.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Устанавливает текст заявки по умолчанию для новой телефонной заявки в интерфейсе агента.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Устанавливает приоритет по умолчанию для новой почтовой заявки в интерфейсе агента.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Устанавливает приоритет по умолчанию для новой телефонной заявки в интерфейсе агента.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Устанавливает отправителя по умолчанию для новой почтовой заявки в интерфейсе агента.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Устанавливает отправителя по умолчанию для новой телефонной заявки в интерфейсе агента.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Устанавливает Тему по умолчанию для новых почтовых заявок в интерфейсе агента.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Устанавливает Тему по умолчанию для новых телефонных заявок в интерфейсе агента.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Устанавливает Тему по умолчанию для сообщений при закрытии заявок в интерфейсе агента.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Устанавливает Тему по умолчанию для сообщений при перемещении заявок в интерфейсе агента.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Устанавливает Тему по умолчанию для сообщений при создании сообщения к заявке в интерфейсе агента.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Устанавливает Тему по умолчанию для сообщений при назначении Владельца заявки в интерфейсе агента.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Устанавливает Тему по умолчанию для сообщений при переводе заявки в ожидание в интерфейсе агента.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Устанавливает Тему по умолчанию для сообщений при назначении приоритета заявки в интерфейсе агента.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Устанавливает Тему по умолчанию для сообщений при назначении Ответственного заявки в интерфейсе агента.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Устанавливает Текст по умолчанию для новых почтовых заявок в интерфейсе агента.',
        'Sets the display order of the different items in the preferences view.' =>
            'Задает порядок отображения различных атрибутов в личных настройках.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            'Устанавливает время неактивности (в сек) после которого сеанс прекращается и агент будет отключен от системы (loged out).',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            'Задает макс. число активных анкетов в интервале заданном в SessionActiveTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            'Задает макс. число активных клиентов в интервале заданном в SessionActiveTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            'Задает минимальное количество разрядов счетчика (если "AutoIncrement" выбран в качестве TicketNumberGenerator). По умочанию - 5, что означает, что счетчик стартует с 10000.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Задает количество строк отображаемых в текстовых сообщениях (например, строк заявки в QueueZoom).',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            'Задает порядок отображения разделов личных настроек клиента.',
        'Sets the password for private PGP key.' => 'Устанавливает праоль для частного ключа PGP.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Задает единицы измерения для единиц времени (например: рабочие часы, часы, минуты).',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Задает префикс к имени папки скриптов на сервере, как установлено в веб-сервере. Этот параметр используется как переменная OTRS_CONFIG_ScriptAlias для применения в сообщениях для построения ссылки на заявки.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Задает очередь при закрытии заявки в интерфейсе агента.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Задает очередь при изменении Дополнительных полей заявки в интерфейсе агента.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Задает очередь при создании сообщения/заметки к заявке в интерфейсе агента.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Задает очередь при назначении Владельца заявки в интерфейсе агента.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Задает очередь при переводе заявки в ожидание в интерфейсе агента.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Задает очередь при изменении приоритета заявки в интерфейсе агента.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Задает очередь при назначении Ответственног для заявки в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Задает Ответственного за заявку при закрытии заявки в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Задает Ответственного за заявку при массовом действии с заявками в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Задает Ответственного за заявку при изменении Дополнительных полей заявки в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Задает Ответственного за заявку при создании заметки к заявке в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Задает Ответственного за заявку при назначении Владельца заявки в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Задает Ответственного за заявку при переводе заявки в ожидание в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Задает Ответственного за заявку при изменении приоритета заявки в интерфейсе агента.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Задает Ответственного за заявку при назначении Ответственного заявки в интерфейсе агента.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Задает Сервис при закрытии заявки в интерфейсе агента. (Ticket::Service должен быть включен).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Задает Сервис при изменении Дополнительных полей заявки в интерфейсе агента. (Ticket::Service должен быть включен).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Задает Сервис при создании заметки к заявке в интерфейсе агента. (Ticket::Service должен быть включен).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Задает Сервис при назначении Владельца заявки в интерфейсе агента. (Ticket::Service должен быть включен).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Задает Сервис при переводе заявки в ожидание в интерфейсе агента. (Ticket::Service должен быть включен).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            'Задает Сервис при изменении приоритета заявки в интерфейсе агента. (Ticket::Service должен быть включен).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            'Задает Сервис при назначении ответственного заявки в интерфейсе агента. (Ticket::Service должен быть включен).',
        'Sets the size of the statistic graph.' => 'Задает размер графика.',
        'Sets the stats hook.' => 'Задает признак (знак, префикс) для имени отчета.',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Задает Владельца при закрытии заявки в интерфейсе агента.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Задает Владельца при массовом действии с заявками в интерфейсе агента.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Задает Владельца при измененииДополнительных полей заявки в интерфейсе агента.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Задает Владельца при создании заметки к заявке в интерфейсе агента.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Задает Владельца при назначении Владельца заявки в интерфейсе агента.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Задает Владельца при переводе заявки в ожидание в интерфейсе агента.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Задает Владельца при изменении приоритета заявки в интерфейсе агента.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Задает Владельца при назначении Ответственного за заявку в интерфейсе агента.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Задает Тип заявки при закрытии заявки в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Задает Тип заявки при массовом действии с заявками в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Задает Тип заявки при изменении Дополнительных полей заявки в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Задает Тип заявки при создании заметки к заявке в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Задает Тип заявки при назначении Владельца заявки в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Задает Тип заявки при переводе заявки в ожидание в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            'Задает Тип заявки при изменении приоритета заявки в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            'Задает Тип заявки при назначении Ответственного за заявку в интерфейсе агента. (Ticket::Type должен быть активирован).',
        'Sets the time (in seconds) a user is marked as active.' => 'Задает время (в сек) в течении которого агент считается активным.',
        'Sets the time type which should be shown.' => 'Задает тип времени для отображения.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Задает timeout (в сек) для http/ftp downloads.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Задает timeout (в сек) для загрузки пакетов. Перекрывает "WebUserAgent::Timeout".',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            'Задает для системы time zone (временНую зону) для агента(надо, чтобы в системе время задавалось с UTC). В противном случае, это будет разницей с локальным временем.',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            'Задает для агента time zone (временНую зону) основанную на java script / browser time zone в момент входа.',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Выводит окно выбора Ответственного при создании телефонных (почтовых) заявок в интерфейсеагента.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Показывает сообщение как rich text даже если применение rich text отключено.',
        'Show the current owner in the customer interface.' => 'Показывать текущего Владельца в интерфейсе клиента.',
        'Show the current queue in the customer interface.' => 'Показывать текущую Очередь в интерфейсе клиента.',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            'Показывать количество иконок в ticket zoom, если всообщение имеет вложения.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Наблюдать/Не наблюдать (subscribing / unsubscribing) при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Связать при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Объединить при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню История при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Дополнительные поля при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Заметка при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'Показывает пункт меню Заметка при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'Показывает пункт меню Закрыть при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Закрыть при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Показывает пункт меню Удалить при просмотре заявки в интерфейсе агента. Дополнительно, можно ограничить доступ к этому пункту меню, использованием параметра "Group", где В содержании указывается перечень групп, которым эта кнопка будет доступна ("rw:group1;move_into:group2").',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Показывает пункт меню Удалить при просмотре заявки в интерфейсе агента. Дополнительно, можно ограничить доступ к этому пункту меню, использованием параметра "Group", где В содержании указывается перечень групп, которым эта кнопка будет доступна ("rw:group1;move_into:group2").',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Назад при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'Показывает пункт меню Блокировать / Разблокировать при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Блокировать / Разблокировать при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'Показывает пункт меню Сменить очередь при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Печать при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Клиенты при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'Показывает пункт меню История при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Владелец при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Приоритет при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Ответственный при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            'Показывает пункт меню Отложить при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Показывает пункт меню Спам при просмотре заявки в интерфейсе агента. Дополнительно, можно ограничить доступ к этому пункту меню, использованием параметра "Group", где В содержании указывается перечень групп, которым эта кнопка будет доступна ("rw:group1;move_into:group2").',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'Показывает пункт меню Приоритет при просмотре заявки в интерфейсе агента.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'Показывает пункт меню Подробно при просмотре заявок в интерфейсе агента.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'Показывает пункт меню для просмотра вложений к сообщениям через html online viewer при просмотре сообщений в интерфейсе агента.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'Показывает кнопку для загрузки вложений при просмотре сообщений в интерфейсе агента.',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Показывет пункт меню для просмотра почтовой заявки как plain text.',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Показывает пункт меню Спам при просмотре заявки в интерфейсе агента. Дополнительно, можно ограничить доступ к этому пункту меню, использованием параметра "Group", где В содержании указывается перечень групп, которым эта кнопка будет доступна ("rw:group1;move_into:group2").',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Показывает список всех привлекаемых агентов по этой заявке при закрытии заявки в интерфейсе агента.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Показывает список всех привлекаемых агентов по этой заявке при изменении Дополнительных полей заявки в интерфейсе агента.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Показывает список всех привлекаемых агентов по этой заявке при создании зпметки к заявке в интерфейсе агента.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Показывает список всех привлекаемых агентов по этой заявке при назначении Владельца заявки в интерфейсе агента.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Показывает список всех привлекаемых агентов по этой заявке при переводе заявки в ожидание в интерфейсе агента.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Показывает список всех привлекаемых агентов по этой заявке при изменении приоритета заявки в интерфейсе агента.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Показывает список всех привлекаемых агентов по этой заявке при назначении Ответственного за заявку в интерфейсе агента.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы определить кого нужно информировать об этой заметке при закрытии заявки в интерфейсе агента.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы определить кого нужно информировать об этой заметке при изменении Дополнительных полей заявки в интерфейсе агента.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы определить кого нужно информировать об этой заметке при создании заметки к заявке в интерфейсе агента.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы определить кого нужно информировать об этой заметке при назначении Владельца заявки в интерфейсе агента.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы определить кого нужно информировать об этой заметке при переводе заявки в ожидание в интерфейсе агента.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы определить кого нужно информировать об этой заметке при изменении приоритета заявки в интерфейсе агента.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Показывает список всех доступных агентов (всех агентов с правами note для очереди/заявки), чтобы определить кого нужно информировать об этой заметке при назначении Ответственного за заявку в интерфейсе агента.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            'Показывает выбор атрибутов заявки для упорядочения заявок при просмотре очередей. Доступные поля могут быть заданы в TicketOverviewMenuSort###SortAttributes.',
        'Shows all both ro and rw queues in the queue view.' => 'Показывает заявки агентов с правами ro и rw в просмотре очередей.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Показывает все открытые заявки (даже блокированные) при просмотре эскалаций в интерфейсе агента.',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Показывает все открытые заявки (даже блокированные) при просмотре статусов в интерфейсе агента.',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Показывает все сообщения заявки в развернутом виде при подробном просмотре заявки.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Показывает поле выбора Владельца при создании почтовых и телефонных заявок в интерфейсе агента.',
        'Shows colors for different article types in the article table.' =>
            'Показывать разные типы сообщений разным цветом в таблице сообщений/заметок. ',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Показывать предыдущие заявки клиента в AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Показывать последнюю тему сообщения клиента или тему заявки при small format обзоре заявок.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Показывать список очередей Родитель/Потомок в виде списка или дерева.',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Показывать атрибуты заявки в интерфейсе клмента (0 - не поакзывать, 1 - показывать).',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Показывать сообщения к заявке отсортированными в обычном или обратном порядке в интерфейсе агента.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Показывать информацию о клиенте при создании сообщений для почтовой или телефонной заявки.',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Показывать информацию о клиенте при подробном просмотре заявки.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Показывать сообщение дня (MOTD) в Дайджесте. Можно ограничить доступ к его отображению указав список групп, которым они будут доступны в "Group". "Default" указывает включен ли он по умолчанию или агент сам может его включать.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Показывает сообщение дня на экране входа агента.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Показывает историю заявки (в обратном порядке) в интерфейсе агента.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Дает возможность изменить приоритет на экране закрытия заявки в интерфейсе агента.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Дает возможность изменить приоритет на экране смены очереди заявки в интерфейсе агента.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Дает возможность изменить приоритет на экране массовых действий с заявками в интерфейсе агента.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Дает возможность изменить приоритет на экране изменения Дополнительных полей заявки в интерфейсе агента.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Дает возможность изменить приоритет на экране создания заметки заявки в интерфейсе агента.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Дает возможность изменить приоритет на экране назначения Владельца заявки в интерфейсе агента.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Дает возможность изменить приоритет на экране перевода заявки в ожидание в интерфейсе агента.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Дает возможность изменить приоритет на экране изменения приоритета заявки в интерфейсе агента.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Дает возможность изменить приоритет на экране назначения Ответственного за заявку в интерфейсе агента.',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            'Показывать поле Тема при закрытии заявки в интерфейсе агента.',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            'Показывать поле Тема при изменении Дополнительных полей заявки в интерфейсе агента.',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            'Показывать поле Тема при создании заметки к заявке в интерфейсе агента.',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Показывать поле Тема при назначении Владельца заявки в интерфейсе агента.',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Показывать поле Тема при переводе заявки в ожидание в интерфейсе агента.',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Показывать поле Тема при изменении приоритета заявки в интерфейсе агента.',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            'Показывать поле Тема при назначении Ответственного за заявку в интерфейсе агента.',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            'Показывать время в полном формате (дни, часы, минуты), если установлено "Да"; или в коротком (дни, часы), если "Нет".',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            'Показывать время, используя полное обозначение (дни, часы, минуты), если установлено "Да"; или краткое (д, ч, м), если "Нет".',
        'Skin' => 'Окрас',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Сортировать заявки (по возрастанию или убыванию) если выбрана одна очередь при просмотре очередей и после сортировки по приоритету. Значения: 0 = по возрастанию (старые сверху, по умолчанию), 1 = по убыванию (новешие сверху). Испльзуйте QueueID в качестве Ключа и 0 или 1 в Содержании.',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Задает будет ли агент получать уведомления о собственных действиях.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            'Задает доступные типы заметок/сообщений для этого набора. Если этот параметр не включен, используются значения из ArticleTypeDefault и окно выбора не отображается.',
        'Specifies the background color of the chart.' => 'Задает цвет фона для графика.',
        'Specifies the background color of the picture.' => 'Задает цвет фона для изображения.',
        'Specifies the border color of the chart.' => 'Задает цвет рамки для графика.',
        'Specifies the border color of the legend.' => 'Задает цвет рамки для легенды.',
        'Specifies the bottom margin of the chart.' => 'Задает нижнюю границу для графика.',
        'Specifies the different article types that will be used in the system.' =>
            'Задает различные типы сообщений для использования в системе.',
        'Specifies the different note types that will be used in the system.' =>
            'Задает различные типы сообщений/заметок для использования в системе.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Задает каталог для хранения данных если "FS" выбрано в TicketStorageModule.',
        'Specifies the directory where SSL certificates are stored.' => 'Задает каталог для хранения SSL сертификатов.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Задает каталог для хранения частных SSL сертификатов.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Задает email address, который должен использоваться при отсылке уведомлений. Он используется построения полного отображаемого имени для мастера уведомлений (т.е. "OTRS Notification Master" otrs@your.example.com). Вы можете использовать переменную OTRS_CONFIG_FQDN заданную в конфигурации или выбрать другой адрес. Это относится к уведомлениям типа ru::Customer::QueueUpdate или ru::Agent::Move.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Задает группу с rw правами для агента, члены которой могут использовать возможность "SwitchToCustomer" (войти как клиент).',
        'Specifies the left margin of the chart.' => 'Задает левую границу диаграммы.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Задает имя, которое будет использоваться при отсылке уведомлений. Оно используется для построения полного отображаемого имени для мастера уведомлений (т.е. "OTRS Notification Master" otrs@your.example.com). Это относится к уведомлениям типа ru::Customer::QueueUpdate или ru::Agent::Move.',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Задает порядок в котором отображаются Фамилия и Имя агентов.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Задает путь к файлу логотипа на отображаемого в заголовке страницы (gif|jpg|png, 700 x 100 pixel).',
        'Specifies the path of the file for the performance log.' => 'Задает путь к файлу журнала производительности.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Задает путь к модулю конвертера, позволяющему просматривать файлы Microsoft Excel в веб-интерфейсе.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Задает путь к модулю конвертера, позволяющему просматривать файлы Microsoft Word в веб-интерфейсе.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Задает путь к модулю конвертера, позволяющему просматривать файлы PDF в веб-интерфейсе.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Задает путь к модулю конвертера, позволяющему просматривать файлы XML в веб-интерфейсе.',
        'Specifies the right margin of the chart.' => 'Задает правую границу диаграммы.',
        'Specifies the text color of the chart (e. g. caption).' => 'Задает цвет текста в диаграмме (например, подписи).',
        'Specifies the text color of the legend.' => 'Задает цвет текста легенды.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Задает текст, который записывается в лог для регистрации обращения к скриптам CGI.',
        'Specifies the top margin of the chart.' => 'Задает верхнюю границу диаграммы.',
        'Specifies user id of the postmaster data base.' => 'Задает user id БД postmaster.',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Задает количество уровней подкаталога для кэш файлов. параметр предотвращает от создания большого количества файлов в одном каталоге.',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Задает набор доступных прав агентов в системе. Если требуются дополнительные права, они могут быть заданы здесь. Права должны быть определены, чтобы использоваться в системе. Некоторые другие полезные права, также встроены в систему: note, close, pending, customer, freetext, move, compose, responsible, forward, и bounce. Последней строкой в таблице всегда дорлжна быть строка с "rw".',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Начальный номер для нумерации отчетов. Каждый новый отчет увеличивает этот номер.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Запускает поиск с символами подстановки активного объекта в окне связывания объектов.',
        'Stat#' => 'Отчет#',
        'Statistics' => 'Отчеты',
        'Status view' => 'Просмотр статусов',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Сохраняет cookies после закрытия браузера.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Убирает пустые строки при предпросмотре заявки в обзоре очередей.',
        'Templates <-> Queues' => 'Шаблоны <-> Очереди',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'Скрипт "bin/PostMasterMailAccount.pl" переподключает POP3/POP3S/IMAP/IMAPS хост после заданного количества сообщений.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Внутреннее имя окраса (skin) экрана для интерфейса агента. Доступные варианты заданы в Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Внутреннее имя окраса (skin) экрана для интерфейса клиента. Доступные варианты заданы в Frontend::Customer::Skins.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Разделитель между символом номера и его значением. (Например ":", ".").',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Период в минутах, после наступления события, в который новое уведомление об эскалации подавляется.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            'Формат поля Тема. "Left" означает "[TicketHook#:12345] текст темы", "Right" - "текст темы [TicketHook#:12345]", "None" "текст темы без номера заявки". В последнем случае вы должны активировать параметр PostmasterFollowupSearchInRaw или  PostmasterFollowUpSearchInReferences для распознавания ответов/дополнений, на основании анализа заголовка (темы) или тела письма.',
        'The headline shown in the customer interface.' => 'Заголовок, отображаемый в интерфейсе клиента.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Идентфикатор заявки, например, Заявка№, Звонок#. По умолчанию - Ticket#.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Логотип, отображаемый в заголовке экрана в интерфейсе агента. URL ссылка может быть относительным URL на каталог с файлами (skin) или быть полным URL на внешний веб-сервер.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Логотип, отображаемый в заголовке экрана в интерфейсе клиента. URL ссылка может быть относительным URL на каталог с файлами (skin) или быть полным URL на внешний веб-сервер.',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'Логотип, отображаемый в рамке окна входа (login box) экрана в интерфейсе агента. URL ссылка должен быть относительным URL на каталог с файлами (skin).',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Текст, предшествующий теме в ответе на письмо, например, RE, AW, или AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Текст, предшествующий теме при пересылке письма, например, FW, Fwd, или WG.',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
            'Модуль, который сохраняет атрибуты клиента в динамических полях заявки. Смотрите в параметрах выше как настроить соответствие.',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Этот модуль и его PreRun() функция будет запускаться, если он определен для каждого запроса. Он полезен для проверки некоторых атрибутов пользователя или отображать новости о новых приложениях.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Этот параметр задает динамическое поле для хранения идентификаторов элементов Активности в Управлении Процессами.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Этот параметр задает динамическое поле для хранения идентификаторов элементов Процесса в Управлении Процессами.',
        'This option defines the process tickets default lock.' => 'Задает блокировку по умолчанию для процессной заявки.',
        'This option defines the process tickets default priority.' => 'Задает приоритет по умолчанию для процессной заявки.',
        'This option defines the process tickets default queue.' => 'Задает очередь по умолчанию для процессной заявки.',
        'This option defines the process tickets default state.' => 'Задает состояние по умолчанию для процессной заявки.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Позволяет переопределить встроенный список стран своим списком. Это позволит сократить отображаемый список до необходимого минимума.',
        'Ticket Queue Overview' => 'Итоги по очередям',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Обзор заявок',
        'TicketNumber' => 'Заявка №',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Время (в сек) добавляемое к текущему, если установлено состояние ожидания. (по умолчанию: 86400 = 1 день).',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Переключает отображение списка OTRS FeatureAddons в Управлении пакетами.',
        'Toolbar Item for a shortcut.' => 'Описание ярлыка(иконки) для навигационной панели.',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            'Включает анимацию в интерфейсе. Если у вас будут проблемы с ней (проблемы производительности), вы можете выключить ее здесь.',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Включает проверку remote ip address. Его можно установить в "Нет" если система работает, например, через proxy или используется dialup подключение, т.к. remote ip address может отличаться от запроса к запросу. ',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Обновляет значение флага "Seen"(прочитано), если каждое сообщение просмотрено или создано новое сообщение.',
        'Update and extend your system with software packages.' => 'Обновление и расширение системы с помощью программных пакетов.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => 'Имя',
        'UserLastname' => 'Фамилия',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing notification events.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Просмотр результатов измерения производительности.',
        'View system log messages.' => 'Просмотр системных сообщений.',
        'Wear this frontend skin' => 'Использовать этот окрас интерфейса',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Когда выполняется слияние заявок, заметка автоматически добавляется к заявке, которая более неактивна. Здесь можно задать текст сообщения/заметки (он не может быть изменен агентом).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Когда выполняется слияние заявок, заметка автоматически добавляется к заявке, которая более неактивна. Здесь можно задать Тему сообщения/заметки (она не может быть изменена агентом).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'При слиянии/объединении заявок, клиент может быть информирован об этом почтовым сообщением, активацией параметра "Inform Sender". Здесь вы можете задать текст, который  потом может быть изменен агентом.',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Выбор очередей, которые вас интересуют. Вы также будете уведомляться по электронной почте, если эта функция включена.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        ' (work units)' => ' (мин.)',
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
        '(work units)' => '(мин.)',
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
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            'Ответ суть текст по умолчанию, который помогает вашим агентам быстрее писать ответы клиентам.',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Ответ — шаблон ответа клиенту',
        'A ticket should be associated with a queue!' => 'Заявке должна быть назначена очередь!',
        'A web calendar' => 'Календарь',
        'A web mail client' => 'Почтовый веб-клиент',
        'About OTRS' => 'О OTRS',
        'Absolut Period' => 'Точный период',
        'Add Customer Company' => 'Добавить компанию клиента',
        'Add Response' => 'Добавить ответ',
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
        'Add customer company' => 'Добавить компанию клиента',
        'Add new attachment' => 'Добавить новое вложение',
        'Add note to ticket' => 'Добавить заметку к заявке',
        'Add response' => 'Добавить ответ',
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
        'Article Create Times' => 'Время создания сообщения',
        'Article created' => 'Сообщение создано',
        'Article created between' => 'Сообщение создано в период',
        'Article filter settings' => 'Фильтр сообщений',
        'ArticleID' => 'ID заметки',
        'Attach' => 'Приложить файл',
        'Attachments <-> Responses' => 'Прикрепленные файлы <-> Ответы',
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
        'Change Attachment Relations for Response' => 'Изменить связь Прикрепленных файлов с Ответами',
        'Change Queue Relations for Response' => 'Изменить Очередь для Ответа',
        'Change Response Relations for Attachment' => 'Изменить связь Ответов с Прикрепленными файлами',
        'Change Response Relations for Queue' => 'Изменить Ответ для Очереди',
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
        'Closed tickets of customer' => 'Закрытые заявки клиента',
        'Collapse View' => 'Кратко',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Столбцы в которых допускаются фильтры в просмотре статусов в интерфейсе агента. Допустимые значения: 0 = Выключено, 1 = Включено, 2 - Включено по умолчанию. Внимание: здесь нельзя добавлять колонки, дополнительные будут проигнорированы (можно только заменить существующие).',
        'Comment (internal)' => 'Комментарий (внутренний)',
        'CompanyTickets' => 'Заявки компании',
        'Complete registration and continue' => 'Завершить регистрацию и продолжить',
        'Compose Answer' => 'Создать ответ',
        'Compose Email' => 'Написать письмо',
        'Compose Follow up' => 'Написать ответ',
        'Config Options' => 'Параметры конфигурации',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Параметры конфигурации (например, <OTRS_CONFIG_HttpType>).',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Настройка умалчиваемых значений для динамических полей (TicketDynmicField). "Имя" задает используемое поле. "Значение" - устанавливает значение поля и "Событие" определят событие установки. Подробно см. (http://doc.otrs.org/), часть "Ticket Event Module".',
        'Contact customer' => 'Связаться с клиентом',
        'Context Settings' => 'Параметры контекста',
        'Country{CustomerUser}' => 'Страна{ПользовательКлиента}',
        'Create New Template' => 'Создать новый шаблон',
        'Create Times' => 'Время создания',
        'Create and manage companies.' => 'Создание и управление компаниями.',
        'Create and manage notifications that are sent to agents.' => 'Создание и управление уведомлениями для агентов.',
        'Create and manage response templates.' => 'Создание и управление шаблонами ответов.',
        'Create new Phone Ticket' => 'Создать телефонную заявку',
        'Create new database' => 'Создать новую базы данных',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' =>
            'Создать новые группы для назначения прав доступа группам агентов (отдел закупок, отдел продаж, отдел техподдержки и т.п.)',
        'Create your first Ticket' => 'Добавить первую заявку',
        'CreateTicket' => 'Создание заявки',
        'Currently only MySQL is supported in the web installer.' => 'На текущий момент веб-инсталлятор поддерживает только MySQL.',
        'Customer Company' => 'Компания клиента',
        'Customer Company Administration' => 'Управление компаниями клиентов',
        'Customer Company Information' => 'Информация о компании клиента',
        'Customer Company Management' => 'Управление компанией клиента',
        'Customer Data' => 'Учетные данные клиента',
        'Customer Move Notify' => 'Извещать клиента о перемещении',
        'Customer Owner Notify' => 'Извещать клиента о смене владельца',
        'Customer State Notify' => 'Извещать клиента об изменении статуса',
        'Customer Users <-> Groups' => 'Группы клиентов',
        'Customer Users <-> Groups Management' => 'Управление группами клиентов',
        'Customer Users <-> Services Management' => 'Клиенты <-> Сервисы',
        'Customer automatically added in Cc.' => 'Клиент автоматически добавлен в Cc',
        'Customer history' => 'История клиента',
        'Customer history search' => 'Поиск по истории клиента',
        'Customer history search (e. g. "ID342425").' => 'Поиск по клиенту (например, «ID342425»).',
        'Customer user will be needed to have a customer history and to login via customer panel.' =>
            'Учетная запись клиента необходима для ведения истории клиента и для доступа к клиентской панели.',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Учетная запись клиента необходима для ведения истории клиента и для доступа к клиентской панели.',
        'CustomerID Search' => 'Поиск по ID клиента',
        'CustomerUser' => 'Клиент',
        'CustomerUser Search' => 'Поиск по логину',
        'Customers <-> Services' => 'Клиенты <-> Сервисы',
        'D' => 'D',
        'DB connect host' => 'Сервер базы данных',
        'DB host' => 'БД--- сервер',
        'Database-User' => 'Пользователь базы данных',
        'Default Charset' => 'Кодировка по умолчанию',
        'Default Language' => 'Язык по умолчанию',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'Задает внешнюю ссылку на БД клиента (т.е. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            'Определяет интервал обновления в секундах для PID планировщика (число с плавающей точкой).',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            'Задает формат ответа на экране создания ответа в интерфейсе агента. ($QData{"OrigFrom"} из From 1:1, $QData{"OrigFromName"} только realname из From).',
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
        'Don\'t forget to add new responses to queues.' => 'Не забудьте добавить новые ответы в очереди.',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'Не работайте с UserID 1 (системная учетная запись)! Создайте другого пользователя!',
        'Download Settings' => 'Загрузить параметры',
        'Download all system config changes.' => 'Загрузить все изменения конфигурации, внесенные в систему',
        'Drop Database' => 'Удалить базу данных',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Параметры показа динамических полей на экране обзора в формате small в интерфейсе агента. Возможные значения: 0 = не показывать, 1 - показывать.',
        'Dynamic-Object' => 'Динамический объект',
        'Edit Article' => 'Редактировать заявку',
        'Edit Customer Company' => 'Редактировать компании клиентов',
        'Edit Customers' => 'Редактировать клиентов',
        'Edit Response' => 'Изменить ответ',
        'Edit default services.' => 'Сервисы по умолчанию',
        'Email based' => 'Адрес электронной почты',
        'Escaladed Tickets' => 'Эскалированные заявки',
        'Escalation - First Response Time' => 'Эскалация — время первого ответа',
        'Escalation - Solution Time' => 'Эскалация — время решения',
        'Escalation - Update Time' => 'Эскалация — время обновления',
        'Escalation Times' => 'Время эскалации',
        'Escalation in' => 'Эскалация через',
        'Escalation time' => 'Время до эскалации заявки',
        'Event is required!' => 'Событие обязательно!',
        'Event module that updates customer users after an update of the Customer Company.' =>
            'Модуль обработки события, который обновляет клиентов после обновления Компании клиента.',
        'Event module that updates tickets after an update of the Customer Company.' =>
            'Модуль обработки события, который обновляет заявки клиентов после обновления Компании клиента.',
        'Expand View' => 'Подробно',
        'Explanation' => 'Пояснение',
        'Export Config' => 'Экспорт конфигурации',
        'False' => 'Облом',
        'FileManager' => 'Управление файлами',
        'Filelist' => 'Список файлов',
        'Filter for Responses' => 'Фильтр для Ответов',
        'Filter name' => 'Имя фильтра',
        'Filtername' => 'Имя фильтра',
        'Follow up' => 'Ответ',
        'Follow up notification' => 'Уведомление об обновлениях',
        'For more info see:' => 'Дополнительная информация находится по адресу:',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'Для очень сложных отчетов, возможно, необходимо использовать временный файл',
        'Form' => 'Форма',
        'Foward ticket: ' => 'Переслать заявку',
        'From customer' => 'От клиента',
        'Frontend' => 'Режим пользователя',
        'Fulltext search' => 'Полнотекстовый поиск',
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
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Если для администратора базы данных установлен пароль, укажите его здесь. Если нет, оставьте поле пустым. Из соображений безопасности мы рекомендуем создать пароль администратора. Информацию по этой теме можно найти в документации по используемой базе данных',
        'If you need the sum of every column select yes.' => 'Если вам необходим показ суммы по каждому столбцу, выберите «Да»',
        'If you need the sum of every row select yes' => 'Если вам необходим показ суммы по каждой строке, выберите «Да»',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Если вы используете регулярные выражения, вы можете использовать переменные в () как [***] при установке значений',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Если вы хотите инсталлировать OTRS с другим типом базы данных, обратитесь к файлу README.database.',
        'Image' => 'Значок',
        'In this form you can select the basic specifications.' => 'В данной форме вы можете выбрать основные требования.',
        'Information about the Stat' => 'Информация об отчете',
        'Insert of the common specifications' => 'Вставьте дополнительные требования',
        'Install Information' => 'Информация по установке',
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
        'Link attachments to responses templates.' => 'Связать прикрепленный файлы с ответами.',
        'Link auto responses to queues.' => 'Связать автоответы с очередями.',
        'Link customers to groups.' => 'Связать клиентов с группами.',
        'Link customers to services.' => 'Связать клиентов с сервисами.',
        'Link groups to roles.' => 'Связать группы с ролями',
        'Link responses to queues.' => 'Связать ответы с очередями.',
        'Link this ticket to an other objects!' => 'Связать заявку с другими объектами!',
        'Link this ticket to other objects!' => 'Связать заявку с другими объектами!',
        'Link to Parent' => 'Связать с родительским объектом',
        'Linked as' => 'Связан как',
        'Load Settings' => 'Применить конфигурацию из файла',
        'Lock it to work on it!' => 'Заблокировать, чтобы рассмотреть заявку!',
        'Locked tickets' => 'Заблокированные заявки',
        'Log file location is only needed for File-LogModule!' => 'Указание расположения файла журнала требуется только для ',
        'Logfile' => 'Файл журнала',
        'Logfile too large, you need to reset it!' => 'Файл журнала слишком большой, вам нужно очистить его!',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Ошибка идентификации! Указано неправильное имя или пароль!',
        'Logout %s' => 'Выход %s',
        'Logout successful. Thank you for using OTRS!' => 'Вы успешно вышли из системы. Благодарим за пользование системой OTRS !',
        'Lookup' => 'Поиск',
        'Mail Management' => 'Управление почтой',
        'Mailbox' => 'Почтовый ящик',
        'Manage Response-Queue Relations' => 'Связь Ответов с Очередями',
        'Manage Responses' => 'Управление ответами',
        'Manage Responses <-> Attachments Relations' => 'Связь Ответов с Прикрепленными файлами',
        'Manage periodic tasks.' => 'Управление повторяющимися задачами.',
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
        'Next Week' => 'На следующей неделе',
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
        'Only for ArticleCreate event' => 'Только для события ArticleCreate',
        'Open tickets of customer' => 'Открытые заявки клиента',
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
        'Password is required.' => 'Требуется пароль.',
        'Passwords doesn\'t match! Please try it again!' => 'Неверный пароль!',
        'Pending Times' => 'Время, когда запрос был отложен',
        'Pending messages' => 'Сообщения в ожидании',
        'Pending type' => 'Тип ожидания',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' =>
            'Настройки прав доступа. Вы можете выбрать одну или несколько групп, чтобы отчет был видел для разных пользователей.',
        'Permissions to change the ticket owner in this group/queue.' => 'Права на смену владельца заявок в этой группе/очереди',
        'PhoneView' => 'Заявка по телефону',
        'Please contact your admin' => 'Свяжитесь с администратором',
        'Please enter a search term to look for customer companies.' => 'Введите запрос для поиска компаний клиента.',
        'Please enter subject.' => 'Пожалуйста, введите тему.',
        'Please fill in all fields marked as mandatory.' => 'Пожалуйста, заполните все поля, отмеченные как обязательные.',
        'Please provide a name.' => 'Пожалуйста, введите имя.',
        'Please supply a' => 'Пожалуйста, введите',
        'Please supply a first name' => 'Пожалуйста, введите имя',
        'Please supply a last name' => 'Пожалуйста, введите фамилию',
        'Position' => 'Сфера деятельности',
        'Print this ticket!' => 'Печать заявки!',
        'Prio' => 'Приоритет',
        'Queue <-> Auto Responses Management' => 'Автоответы в очереди',
        'Queue ID' => 'ID очереди',
        'Queue Management' => 'Управление очередью',
        'Queue is required.' => 'Необходимо указать очередь.',
        'QueueView Refresh Time' => 'Время обновления монитора очередей',
        'Queues <-> Auto Responses' => 'Очередь <-> Автоответы',
        'Realname' => 'Имя',
        'Rebuild' => 'Перестроить',
        'Recipients' => 'Получатели',
        'Registration' => 'Регистрация',
        'Reminder' => 'Отложенное напоминание',
        'Reminder messages' => 'Сообщения с напоминаниями',
        'ReminderReached' => 'Напоминание истекло',
        'Required Field' => 'Обязательное поле',
        'Response Management' => 'Управление ответами',
        'Responses' => 'Ответы',
        'Responses <-> Attachments Management' => 'Управление приложенными файлами в ответах',
        'Responses <-> Queue Management' => 'Управление ответами в очередях',
        'Responses <-> Queues' => 'Ответы <-> Очередь',
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
        'Search for customers.' => 'Поиск клиентов.',
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
        'Select this customer user as the main customer user.' => 'Выберите этого клиента как основного.',
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
        'Show  article' => 'Показать сообщение',
        'Shows the ticket history!' => 'Показать историю заявки!',
        'Site' => 'Место',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Пропуск этого шага автоматически пропустит и регистрацию вашей OTRS. Вы действительно хотите продолжить?',
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
        'Synchronize All Processes' => 'Синхронизировать все Процессы',
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
        'Ticket Action' => 'Действия по заявке',
        'Ticket Change Times (from moment)' => 'Время изменения заявки (с момента)',
        'Ticket Close Times (from moment)' => 'Время закрытия заявки (с момента)',
        'Ticket Commands' => 'Команды по заявке',
        'Ticket Create Times (from moment)' => 'Время создания заявки (с момента)',
        'Ticket Hook' => 'Выбор заявки',
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
        'Ticket#' => 'Заявка №',
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
        'To customer' => 'Клиенту',
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
        'URL' => 'URL',
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
        'Welcome %s' => 'Здравствуйте, %s',
        'Welcome to %s' => 'Добро пожаловать в %s',
        'Welcome to OTRS' => 'Добро пожаловать в OTRS',
        'Wildcards are allowed.' => 'Подстановочные символы допустимы.',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'При статусе отчета «недействительный» отчет не может быть сформирован.',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' =>
            'Вводя данные и выбирая поля, вы можете настраивать отчет как вам необходимо. От администратора, создававшего данный отчет, зависит какие данные вы можете настраивать. ',
        'Yes means, send no agent and customer notifications on changes.' =>
            '«Да» — не отправлять уведомления агентам и клиентам при изменениях.',
        'Yes, save it with name' => 'Да, сохранить с именем',
        'You can modify the system type and description here.' => 'Вы можете изменить тип системы и описание здесь.',
        'You got new message!' => 'У вас новое сообщение!',
        'You have to select two or more attributes from the select field!' =>
            'Вам необходимо выбрать два или более пунктов из выбранного поля!',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'Укажите адрес электронной почты в поле получателя (например, customer@example.ru)!',
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
        'before' => 'кроме последних',
        'customer realname' => 'Имя клиента',
        'default \'hot\'' => 'По умолчанию: «hot»',
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
        'settings' => 'параметры',
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
