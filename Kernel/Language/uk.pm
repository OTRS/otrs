# --
# Kernel/Language/uk.pm - provides ru language translation
# Copyright (C) 2010 Бельский Артем
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::uk;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-06-14 08:49:51

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%M/%D/%Y %T';
    $Self->{DateFormatLong}      = '%T - %M/%D/%Y';
    $Self->{DateFormatShort}     = '%M/%D/%Y';
    $Self->{DateInputFormat}     = '%M/%D/%Y';
    $Self->{DateInputFormatLong} = '%M/%D/%Y - %T';

    # csv separator
    $Self->{Separator} = ',';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Так',
        'No' => 'Ні',
        'yes' => 'так',
        'no' => 'ні',
        'Off' => 'Вимкнено',
        'off' => 'вимкнено',
        'On' => 'Ввімкнено',
        'on' => 'ввімкнено',
        'top' => 'До початку',
        'end' => 'В кінець',
        'Done' => 'Готово',
        'Cancel' => 'Відмінити',
        'Reset' => 'Перезавантажити',
        'last' => 'останній',
        'before' => 'перш',
        'Today' => 'Сьогодні',
        'Tomorrow' => 'Завтра',
        'Next week' => '',
        'day' => 'день',
        'days' => 'днів',
        'day(s)' => 'днів',
        'd' => '',
        'hour' => 'година',
        'hours' => 'годин',
        'hour(s)' => 'годин',
        'Hours' => 'Годинник',
        'h' => '',
        'minute' => 'хвилина',
        'minutes' => 'хвилин',
        'minute(s)' => 'хвилин',
        'Minutes' => 'Хвилини',
        'm' => '',
        'month' => 'місяць',
        'months' => 'місяців',
        'month(s)' => 'місяців',
        'week' => 'тиждень',
        'week(s)' => 'тижнів',
        'year' => 'рік',
        'years' => 'років',
        'year(s)' => 'років',
        'second(s)' => 'секунд',
        'seconds' => 'секунд',
        'second' => 'секунда',
        's' => '',
        'wrote' => 'написав(ла)',
        'Message' => 'Повідомлення',
        'Error' => 'Помилка',
        'Bug Report' => 'Звіт про помилку',
        'Attention' => 'Увага',
        'Warning' => 'Попередження',
        'Module' => 'Модуль',
        'Modulefile' => 'Фалйл подулю',
        'Subfunction' => 'Підфункця',
        'Line' => 'Лінія',
        'Setting' => 'Параметр',
        'Settings' => 'Параметри',
        'Example' => 'Приклад',
        'Examples' => 'Приклади',
        'valid' => 'дійсний',
        'Valid' => 'Дійсний',
        'invalid' => 'недійсний',
        'Invalid' => '',
        '* invalid' => '* недійсний',
        'invalid-temporarily' => 'тимчасово недійсний',
        ' 2 minutes' => '2 хвилини',
        ' 5 minutes' => '5 хвилин',
        ' 7 minutes' => '7 хвилин',
        '10 minutes' => '10 хвилин',
        '15 minutes' => '15 хвилин',
        'Mr.' => 'Добродій',
        'Mrs.' => 'Пані',
        'Next' => 'Далі',
        'Back' => 'Назад',
        'Next...' => 'Далі...',
        '...Back' => '...Назад',
        '-none-' => '-немає-',
        'none' => 'немає',
        'none!' => 'немає!',
        'none - answered' => 'немає - відповів',
        'please do not edit!' => 'Будьласка, не редагуйте!',
        'Need Action' => 'Необхідна дія',
        'AddLink' => 'Додати посилання',
        'Link' => 'Посиланя',
        'Unlink' => 'Відв\'язати',
        'Linked' => 'Пов\'язаний',
        'Link (Normal)' => 'Посилання (звичайне)',
        'Link (Parent)' => 'Посилання (джерело)',
        'Link (Child)' => 'Посилання (нащадок)',
        'Normal' => 'Звичайний',
        'Parent' => 'Джерело',
        'Child' => 'Нащадок',
        'Hit' => 'Успіх',
        'Hits' => 'Успіхи',
        'Text' => 'Текст',
        'Standard' => 'Стандарт',
        'Lite' => 'Полегшений',
        'User' => 'Користувач',
        'Username' => 'Ім\'я користувача',
        'Language' => 'Мова',
        'Languages' => 'Мови',
        'Password' => 'Пароль',
        'Preferences' => 'Уподобання',
        'Salutation' => 'Привітання',
        'Salutations' => 'Вітаю',
        'Signature' => 'Підпис',
        'Signatures' => 'Підписи',
        'Customer' => 'Клієнт',
        'CustomerID' => 'ID користувача',
        'CustomerIDs' => 'ID користувача',
        'customer' => 'клієнт',
        'agent' => 'агент',
        'system' => 'система',
        'Customer Info' => 'Інформація про агента',
        'Customer Information' => 'Інформація про агента',
        'Customer Company' => 'Компанія клієнта',
        'Customer Companies' => 'Компанії клієнта',
        'Company' => 'Компанія',
        'go!' => 'розпочати!',
        'go' => 'розпочати',
        'All' => 'Всі',
        'all' => 'всі',
        'Sorry' => 'Вибачте',
        'update!' => 'оновити!',
        'update' => 'оновити',
        'Update' => 'Оновити',
        'Updated!' => 'Оновити!',
        'submit!' => 'відправити!',
        'submit' => 'відправити',
        'Submit' => 'Відправити',
        'change!' => 'змінити!',
        'Change' => 'Смінити',
        'change' => 'змінити',
        'click here' => 'натисніть тут',
        'Comment' => 'Коментар',
        'Invalid Option!' => 'Невірний параметр',
        'Invalid time!' => 'Невірний час',
        'Invalid date!' => 'Невірна дата',
        'Name' => 'Ім\'я',
        'Group' => 'Група',
        'Description' => 'Опис',
        'description' => 'опис',
        'Theme' => 'Тема',
        'Created' => 'Створеий',
        'Created by' => 'Створений',
        'Changed' => 'Змінений',
        'Changed by' => 'Змінений',
        'Search' => 'Пошук',
        'and' => 'та',
        'between' => 'між',
        'Fulltext Search' => 'Повнотекстовий пошук',
        'Data' => 'Дата',
        'Options' => 'Опції',
        'Title' => 'Заголовок',
        'Item' => 'пункт',
        'Delete' => 'Видалити',
        'Edit' => 'Редагувати',
        'View' => 'Перегляд',
        'Number' => 'Число',
        'System' => 'Система',
        'Contact' => 'Контакт',
        'Contacts' => 'Контакти',
        'Export' => 'Експорт',
        'Up' => 'Вгору',
        'Down' => 'Вниз',
        'Add' => 'Додати',
        'Added!' => 'Додано',
        'Category' => 'Категорія',
        'Viewer' => 'Переглянути',
        'Expand' => 'РОзгорнути',
        'Small' => 'Маленький',
        'Medium' => 'Середній',
        'Large' => 'Великий',
        'Date picker' => 'Видір дати',
        'New message' => 'Нове повідомлення',
        'New message!' => 'Нове повідомлення',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Будьласка, відповідіть на ці заявки для повернення у звичайний режим перегляду черги',
        'You have %s new message(s)!' => 'Ви маєте %s нових повідомлень',
        'You have %s reminder ticket(s)!' => 'Ви маєте %s нагадувань',
        'The recommended charset for your language is %s!' => 'Рекомендована таблиця символів для вашої мови %s!',
        'Change your password.' => 'Змінити пароль',
        'Please activate %s first!' => 'Будьласка, спочатку активуйте %s',
        'No suggestions' => 'Попередження відсутні',
        'Word' => 'Слово',
        'Ignore' => 'Ігнорувати',
        'replace with' => 'Замінити на',
        'There is no account with that login name.' => 'Немає користувача за таким ім\'ям',
        'Login failed! Your user name or password was entered incorrectly.' =>
            '',
        'There is no acount with that user name.' => '',
        'Please contact your administrator' => '',
        'Logout' => 'Вийти',
        'Logout successful. Thank you for using %s!' => 'Вихід виконано. Дякуемо Вам, за використання %s!',
        'Feature not active!' => 'Функція не активована!',
        'Agent updated!' => '',
        'Create Database' => 'Створити базу',
        'System Settings' => 'Системні параметри',
        'Mail Configuration' => '',
        'Finished' => 'Закінчене',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'Ліцензія',
        'Database' => 'Ім\'я бази даних',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Database setup successful!' => '',
        'Generated password' => '',
        'Login is needed!' => 'Необхідно ввести ім\'я користувача!',
        'Password is needed!' => 'Необхідно ввести пароль!',
        'Take this Customer' => 'Обрати клієнта',
        'Take this User' => 'Обрати користувача',
        'possible' => 'імовірно',
        'reject' => 'відвергнути',
        'reverse' => 'повернути',
        'Facility' => 'Об\'єкт',
        'Time Zone' => 'Вартовий пояс',
        'Pending till' => 'В очікування ще',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Перенаправлення електронного листа по заголовку ТО:',
        'Dispatching by selected Queue.' => 'Перенаправлення по обраній черзі',
        'No entry found!' => 'Запис не знайдений',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Сеанс завершений. Будьласка, виконайте вхід повторно.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Немає прав!',
        '(Click here to add)' => '(Натисніть тут щоб додати)',
        'Preview' => 'Попередній перегляд',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => 'Не можу прочитати %s',
        'Cannot create %s!' => 'Не можу створити %s',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => '',
        'Role added!' => 'Роль додана!',
        'Role updated!' => '',
        'Attachment added!' => '',
        'Attachment updated!' => '',
        'Response added!' => '',
        'Response updated!' => '',
        'Group updated!' => '',
        'Queue added!' => '',
        'Queue updated!' => '',
        'State added!' => '',
        'State updated!' => '',
        'Type added!' => '',
        'Type updated!' => '',
        'Customer updated!' => '',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => '',
        'System e-mail address updated!' => '',
        'Contract' => 'Контракт',
        'Online Customer: %s' => 'Клієнт онлайн: %s',
        'Online Agent: %s' => 'Агент онлайн: %s',
        'Calendar' => 'Каландар',
        'File' => 'Файл',
        'Filename' => 'Ім\'я файлу',
        'Type' => 'Тип',
        'Size' => 'Розмір',
        'Upload' => 'Завантажити',
        'Directory' => 'Директорія',
        'Signed' => 'Підписане',
        'Sign' => 'Підписати',
        'Crypted' => 'Зашифроване',
        'Crypt' => 'Шифрування',
        'PGP' => '',
        'PGP Key' => 'PGP ключ',
        'PGP Keys' => 'PGP ключі',
        'S/MIME' => '',
        'S/MIME Certificate' => '',
        'S/MIME Certificates' => '',
        'Office' => 'Офіс',
        'Phone' => 'Телефон',
        'Fax' => 'Факс',
        'Mobile' => 'Мобільний телефон',
        'Zip' => 'Індекс',
        'City' => 'Місто',
        'Street' => 'Вулиця',
        'Country' => 'Країна',
        'Location' => ' Місце розташування',
        'installed' => 'Установлене',
        'uninstalled' => 'Деінстальовано',
        'Security Note: You should activate %s because application is already running!' =>
            'Попередження про безпеку: ви повинні активувати «%s», тому що додаток уже запущений!',
        'Unable to parse repository index document.' => '',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '',
        'No packages, or no new packages, found in selected repository.' =>
            '',
        'Edit the system configuration settings.' => '',
        'printed at' => 'надруковане в',
        'Loading...' => 'Завантаження...',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => 'Шановний(ая)',
        'Hello %s,' => ' Здрастуйте, %s.',
        'This email address already exists. Please log in or reset your password.' =>
            '',
        'New account created. Sent login information to %s. Please check your email.' =>
            '',
        'Please press Back and try again.' => 'Натисніть «Назад» і спробуйте ще раз',
        'Sent password reset instructions. Please check your email.' => '',
        'Sent new password to %s. Please check your email.' => '',
        'Upcoming Events' => 'Найближчі події',
        'Event' => 'Подія',
        'Events' => 'Події',
        'Invalid Token!' => 'Невірний токен !',
        'more' => 'далі',
        'Collapse' => 'Згорнути',
        'Shown' => 'Показане',
        'Shown customer users' => '',
        'News' => 'Новини',
        'Product News' => 'Новини про продукт',
        'OTRS News' => 'Новини OTRS',
        '7 Day Stats' => 'Статистика за 7 днів',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Bold' => 'Напівжирний',
        'Italic' => 'Курсив',
        'Underline' => 'Підкреслений',
        'Font Color' => 'Колір тексту',
        'Background Color' => 'Колір тла',
        'Remove Formatting' => 'Вилучити форматування',
        'Show/Hide Hidden Elements' => 'Показ схованих елементів',
        'Align Left' => ' По лівому краю',
        'Align Center' => ' По центру',
        'Align Right' => ' По правому краю',
        'Justify' => ' По ширині',
        'Header' => 'Заголовок',
        'Indent' => 'Збільшити відступ',
        'Outdent' => 'Зменшити відступ',
        'Create an Unordered List' => 'Створити ненумерований список',
        'Create an Ordered List' => 'Створити нумерований список',
        'HTML Link' => 'Посилання HTML',
        'Insert Image' => 'Вставити зображення',
        'CTRL' => 'Ctrl',
        'SHIFT' => 'Shift',
        'Undo' => 'Скасувати',
        'Redo' => 'Повторити',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => '',
        'International Workers\' Day' => '',
        'Christmas Eve' => '',
        'First Christmas Day' => '',
        'Second Christmas Day' => '',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => 'Січ.',
        'Feb' => 'Лют.',
        'Mar' => 'Бер.',
        'Apr' => 'Квіт.',
        'May' => 'Трав.',
        'Jun' => 'Черв.',
        'Jul' => 'Лип.',
        'Aug' => 'Серп.',
        'Sep' => 'Вер.',
        'Oct' => 'Жовт.',
        'Nov' => 'Лист.',
        'Dec' => 'Груд.',
        'January' => 'Січень',
        'February' => 'Лютий',
        'March' => 'Березень',
        'April' => 'Квітень',
        'May_long' => 'Травень',
        'June' => 'Червень',
        'July' => 'Липень',
        'August' => 'Серпень',
        'September' => 'Вересень',
        'October' => 'Жовтень',
        'November' => 'Листопад',
        'December' => 'Грудень',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Настроювання успішно оновлені',
        'User Profile' => 'Профіль користувача',
        'Email Settings' => 'Настроювання пошти',
        'Other Settings' => 'Інші настроювання',
        'Change Password' => 'Перемінити пароль',
        'Current password' => 'Поточний пароль',
        'New password' => 'Новий пароль',
        'Verify password' => 'Повторіть пароль',
        'Spelling Dictionary' => 'Словник',
        'Default spelling dictionary' => '',
        'Max. shown Tickets a page in Overview.' => 'Максимальна кількість заявок при показі черги',
        'The current password is not correct. Please try again!' => 'Пароль не вірний. Будь ласка, спробуйте знову!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Неможливо обновити пароль. Нові паролі не збігаються. Будь ласка, спробуйте знову!',
        'Can\'t update password, it contains invalid characters!' => 'Неможливо обновити пароль, тому що він містить заборонені символи!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Неможливо обновити пароль, тому що його довжина повинна бути не менш %s символів!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Неможливо обновити пароль, тому що він повинен містити не менш 2-х рядкових і 2-х заголовних символів!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Неможливо обновити пароль, тому що він повинен містити не менш 1-й цифри!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Неможливо обновити пароль, тому що він повинен містити не менш 2 букв!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Неможливо обновити пароль, тому що він уже використовувався. Будь ласка, виберіть іншої.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '',
        'CSV Separator' => 'Роздільник CSV',

        # Template: AAAStats
        'Stat' => 'Статистика',
        'Sum' => '',
        'Please fill out the required fields!' => 'Заповните обов\'язкові поля!',
        'Please select a file!' => 'Виберіть файл!',
        'Please select an object!' => 'Виберіть об\'єкт!',
        'Please select a graph size!' => 'Виберіть розмір графіка!',
        'Please select one element for the X-axis!' => 'Виберіть один елемент для осі X',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Виберіть тільки один елемент або зніміть прапор \'Fixed\' в обраного поля!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Якщо ви використовуєте прапорці виділення, те повинні вибрати кілька пунктів з обраного поля!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Вставте значення в обране поле або зніміть прапор «Fixed»!',
        'The selected end time is before the start time!' => 'Зазначений час закінчення завчасно початку!',
        'You have to select one or more attributes from the select field!' =>
            'Ви повинні вибрати один або кілька пунктів з обраного поля',
        'The selected Date isn\'t valid!' => 'Обрана дата невірна!',
        'Please select only one or two elements via the checkbox!' => 'Виберіть тільки один або два пункти, використовуючи прапорці',
        'If you use a time scale element you can only select one element!' =>
            'Якщо ви використовуєте елемент періоду, ви можете вибрати тільки один пункт!',
        'You have an error in your time selection!' => 'Помилка вказівки часу',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Період звітності занадто малий, укажіть більший інтервал',
        'The selected start time is before the allowed start time!' => 'Обраний час початку виходить за межі дозволеного!',
        'The selected end time is after the allowed end time!' => 'Обраний час кінця виходить за межі дозволеного!',
        'The selected time period is larger than the allowed time period!' =>
            'Обраний період часу більше, ніж дозволений період!',
        'Common Specification' => 'Загальна специфікація',
        'X-axis' => 'Вісь X',
        'Value Series' => 'Ряд значень',
        'Restrictions' => 'Обмеження',
        'graph-lines' => 'Графік',
        'graph-bars' => 'Гистограмма',
        'graph-hbars' => 'Лінійчата',
        'graph-points' => 'Крапкова',
        'graph-lines-points' => 'Графік із крапковою діаграмою',
        'graph-area' => 'З областями',
        'graph-pie' => 'Кругова',
        'extended' => 'Інша',
        'Agent/Owner' => 'Агент (власник)',
        'Created by Agent/Owner' => 'Створене агентом (власником)',
        'Created Priority' => 'Пріоритет',
        'Created State' => 'Стан',
        'Create Time' => 'Час створення',
        'CustomerUserLogin' => '',
        'Close Time' => 'Час закриття',
        'TicketAccumulation' => '',
        'Attributes to be printed' => 'Атрибути для печатки',
        'Sort sequence' => 'Порядок сортування',
        'Order by' => 'Сортування',
        'Limit' => 'Ліміт',
        'Ticketlist' => 'Список заявок',
        'ascending' => ' По зростанню',
        'descending' => ' По убуванню',
        'First Lock' => 'Перше блокування',
        'Evaluation by' => 'Заблоковане',
        'Total Time' => 'Усього часу',
        'Ticket Average' => 'Середній час розгляду заявки',
        'Ticket Min Time' => 'Мін. час розгляду заявки',
        'Ticket Max Time' => 'Макс. час розгляду заявки',
        'Number of Tickets' => 'Кількість заявок',
        'Article Average' => 'Середній час між повідомленнями',
        'Article Min Time' => 'Мін. час між повідомленнями',
        'Article Max Time' => 'Макс. час між повідомленнями',
        'Number of Articles' => 'Кількість повідомлень',
        'Accounted time by Agent' => 'Витрати робочого часу по агентах',
        'Ticket/Article Accounted Time' => 'Витрати робочого часу на заявку або повідомлення',
        'TicketAccountedTime' => '',
        'Ticket Create Time' => 'Час створення заявки',
        'Ticket Close Time' => 'Час закриття заявки',

        # Template: AAATicket
        'Status View' => '',
        'Bulk' => '',
        'Lock' => 'Блокувати',
        'Unlock' => 'Розблокувати',
        'History' => 'Історія',
        'Zoom' => 'Докладно',
        'Age' => 'Відкрита',
        'Bounce' => 'Повернути',
        'Forward' => 'Переслати',
        'From' => 'Відправник',
        'To' => 'Одержувач',
        'Cc' => 'Копія',
        'Bcc' => 'Схована копія',
        'Subject' => 'Тема',
        'Move' => 'Перемістити',
        'Queue' => 'Черга',
        'Queues' => 'Черги',
        'Priority' => 'Пріоритет',
        'Priorities' => 'Пріоритети',
        'Priority Update' => 'Зміна пріоритету',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => 'Рівень обслуговування',
        'Service Level Agreement' => 'Угода про Рівень Сервісу',
        'Service Level Agreements' => 'Угоди про Рівень Сервісу',
        'Service' => 'Сервіс',
        'Services' => 'Сервіси',
        'State' => 'Статус',
        'States' => 'Стану',
        'Status' => 'Статус',
        'Statuses' => 'Статуси',
        'Ticket Type' => 'Тип заявки',
        'Ticket Types' => 'Типи заявки',
        'Compose' => 'Створити',
        'Pending' => 'Відкладені',
        'Owner' => 'Власник',
        'Owner Update' => 'Новий власник',
        'Responsible' => 'Відповідальний',
        'Responsible Update' => 'Новий відповідальний',
        'Sender' => 'Відправник',
        'Article' => 'Повідомлення',
        'Ticket' => 'Заявка',
        'Createtime' => 'Час створення',
        'plain' => 'Звичайний',
        'Email' => 'Email',
        'email' => 'Email',
        'Close' => 'Закрити',
        'Action' => 'Дія',
        'Attachment' => 'Прикріплений файл',
        'Attachments' => 'Прикріплені файли',
        'This message was written in a character set other than your own.' =>
            'Це повідомлення написане в кодуванні. відмінної від вашої.',
        'If it is not displayed correctly,' => 'Якщо текст відображається некоректно,',
        'This is a' => 'Це',
        'to open it in a new window.' => 'відкрити в новім вікні',
        'This is a HTML email. Click here to show it.' => 'Цей електронний лист у форматі HTML. Натисніть тут для перегляду',
        'Free Fields' => 'Вільне поле',
        'Merge' => 'Об\'єднати',
        'merged' => 'об\'єднаний',
        'closed successful' => 'Закрита успішно',
        'closed unsuccessful' => 'Закрита неуспішно',
        'Locked Tickets Total' => '',
        'Locked Tickets Reminder Reached' => '',
        'Locked Tickets New' => '',
        'Responsible Tickets Total' => '',
        'Responsible Tickets New' => '',
        'Responsible Tickets Reminder Reached' => '',
        'Watched Tickets Total' => '',
        'Watched Tickets New' => '',
        'Watched Tickets Reminder Reached' => '',
        'All tickets' => 'Усі заявки',
        'Available tickets' => '',
        'Escalation' => 'Ескалація',
        'last-search' => '',
        'QueueView' => '',
        'Ticket Escalation View' => 'Вид ескалації заявки',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'нова',
        'open' => 'відкриті',
        'Open' => 'Відкриті',
        'Open tickets' => '',
        'closed' => 'закриті',
        'Closed' => 'Закриті',
        'Closed tickets' => '',
        'removed' => 'вилучені',
        'pending reminder' => 'відкладене нагадування',
        'pending auto' => 'черга на автозакрытие',
        'pending auto close+' => 'черга на автозакрытие+',
        'pending auto close-' => 'черга на автозакрытие-',
        'email-external' => 'зовнішній email',
        'email-internal' => 'внутрішній email',
        'note-external' => 'зовнішня замітка',
        'note-internal' => 'внутрішня замітка',
        'note-report' => ' Замітка-Звіт',
        'phone' => 'дзвінок',
        'sms' => 'SMS',
        'webrequest' => 'веб-заявка',
        'lock' => 'блокована',
        'unlock' => 'розблокована',
        'very low' => ' найнижчий',
        'low' => 'низький',
        'normal' => 'звичайний',
        'high' => 'високий',
        'very high' => 'невідкладний',
        '1 very low' => '1 найнижчий',
        '2 low' => '2 низький',
        '3 normal' => '3 звичайний',
        '4 high' => '4 високий',
        '5 very high' => '5 невідкладний',
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Ticket "%s" created!' => 'Створена заявка «%s».',
        'Ticket Number' => 'Номер заявки',
        'Ticket Object' => 'Об\'єкт заявки',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Заявки з номером «%s» не існує, неможливо зв\'язати з нею!',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Please change the owner first.' => '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => '',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => 'Не показувати закриті заявки',
        'Show closed Tickets' => 'Показувати закриті заявки',
        'New Article' => 'Нове повідомлення',
        'Unread article(s) available' => '',
        'Remove from list of watched tickets' => '',
        'Add to list of watched tickets' => '',
        'Email-Ticket' => 'Лист',
        'Create new Email Ticket' => 'Створити нову заявку',
        'Phone-Ticket' => 'Заявка з телефонний дзвінок',
        'Search Tickets' => 'Пошук заявок',
        'Edit Customer Users' => 'Редагувати клієнтів',
        'Edit Customer Company' => 'Редагувати компанії клієнтів',
        'Bulk Action' => 'Масова дія',
        'Bulk Actions on Tickets' => 'Масова дія над заявками',
        'Send Email and create a new Ticket' => 'Відправити лист і створити нову заявку',
        'Create new Email Ticket and send this out (Outbound)' => 'Створити нову заявку email і відправити її',
        'Create new Phone Ticket (Inbound)' => 'Створити нову телефонну заявку',
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Огляд усіх заявок',
        'Locked Tickets' => 'Заблоковані заявки',
        'My Locked Tickets' => 'Мої заблоковані заявки',
        'My Watched Tickets' => '',
        'My Responsible Tickets' => '',
        'Watched Tickets' => ' заявки, Що Відслідковуються, ',
        'Watched' => ', Що Відслідковуються',
        'Watch' => '',
        'Unwatch' => '',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'Змінити вільні поля заявки!',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'Переглянути заявку!',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Позначити як спам!',
        'My Queues' => 'Мої черги',
        'Shown Tickets' => 'Показувані заявки',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Ваш email з номером заявки «<OTRS_TICKET>» об\'єднаний з "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Заявка %s: час першої відповіді минув (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Заявка %s: час першої відповіді мине через %s!',
        'Ticket %s: update time is over (%s)!' => 'Заявка %s: час відновлення заявки минув (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Заявка %s: час відновлення заявки мине через %s!',
        'Ticket %s: solution time is over (%s)!' => 'Заявка %s: час розв\'язку заявки минув (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Заявка %s: час розв\'язку заявки мине через %s!',
        'There are more escalated tickets!' => 'Ескальованих заявок більше немає!',
        'Plain Format' => '',
        'Reply All' => '',
        'Direction' => 'Напрямок',
        'Agent (All with write permissions)' => '',
        'Agent (Owner)' => '',
        'Agent (Responsible)' => '',
        'New ticket notification' => 'Повідомлення про нову заявку',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Повідомлення про нові заявки',
        'Send new ticket notifications' => 'Відправити повідомлення про нову заявку',
        'Ticket follow up notification' => '',
        'Ticket lock timeout notification' => 'Повідомлення про витікання строку блокування заявки системою',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Надіслати мені повідомлення, якщо заявка звільнена системою.',
        'Send ticket lock timeout notifications' => '',
        'Ticket move notification' => 'Повідомлення про переміщення заявки',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Надіслати мені повідомлення, якщо заявка переміщена в одну з моїх черг.',
        'Send ticket move notifications' => 'Відправити повідомлення про переміщення заявки',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'Резервна черга',
        'QueueView refresh time' => '',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            '',
        'Refresh QueueView after' => '',
        'Screen after new ticket' => 'Розділ після створення нової заявки',
        'Show this screen after I created a new ticket' => '',
        'Closed Tickets' => 'Закриті заявки',
        'Show closed tickets.' => 'Показувати закриті заявки',
        'Max. shown Tickets a page in QueueView.' => '',
        'Ticket Overview "Small" Limit' => '',
        'Ticket limit per page for Ticket Overview "Small"' => '',
        'Ticket Overview "Medium" Limit' => '',
        'Ticket limit per page for Ticket Overview "Medium"' => '',
        'Ticket Overview "Preview" Limit' => '',
        'Ticket limit per page for Ticket Overview "Preview"' => '',
        'Ticket watch notification' => '',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            '',
        'Send ticket watch notifications' => '',
        'Out Of Office Time' => 'Час відсутності в офісі',
        'New Ticket' => 'Нова заявка',
        'Create new Ticket' => 'Створити нову заявку',
        'Customer called' => 'Дзвінок клієнта',
        'phone call' => 'телефонний дзвінок',
        'Phone Call Outbound' => 'Телефонний дзвінок',
        'Phone Call Inbound' => '',
        'Reminder Reached' => 'Нагадування',
        'Reminder Tickets' => 'Заявки з нагадуванням',
        'Escalated Tickets' => 'Ескальовані заявки',
        'New Tickets' => 'Нові заявки',
        'Open Tickets / Need to be answered' => 'Відкриті заявки ( потрібно відповісти)',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            '',
        'All new tickets, these tickets have not been worked on yet' => '',
        'All escalated tickets' => '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
        'History::Move' => 'Заявка переміщена в чергу «%s» (%s) із черги «%s» (%s).',
        'History::TypeUpdate' => '',
        'History::ServiceUpdate' => '',
        'History::SLAUpdate' => '',
        'History::NewTicket' => '',
        'History::FollowUp' => '',
        'History::SendAutoReject' => '',
        'History::SendAutoReply' => '',
        'History::SendAutoFollowUp' => '',
        'History::Forward' => 'Переспрямоване «%s».',
        'History::Bounce' => 'Повернуте «%s».',
        'History::SendAnswer' => '',
        'History::SendAgentNotification' => '',
        'History::SendCustomerNotification' => '',
        'History::EmailAgent' => '',
        'History::EmailCustomer' => '',
        'History::PhoneCallAgent' => '',
        'History::PhoneCallCustomer' => '',
        'History::AddNote' => '',
        'History::Lock' => 'Заблокована заявка.',
        'History::Unlock' => 'Розблокована заявка.',
        'History::TimeAccounting' => '',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => '',
        'History::PriorityUpdate' => '',
        'History::OwnerUpdate' => '',
        'History::LoopProtection' => '',
        'History::Misc' => '%s',
        'History::SetPendingTime' => '',
        'History::StateUpdate' => '',
        'History::TicketDynamicFieldUpdate' => '',
        'History::WebRequestCustomer' => '',
        'History::TicketLinkAdd' => '',
        'History::TicketLinkDelete' => '',
        'History::Subscribe' => 'Додана підписка для користувача «%s».',
        'History::Unsubscribe' => 'Вилучена підписка для користувача «%s».',
        'History::SystemRequest' => '',
        'History::ResponsibleUpdate' => '',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Нд.',
        'Mon' => 'Пн.',
        'Tue' => 'Вівт.',
        'Wed' => 'Сер.',
        'Thu' => 'Чт.',
        'Fri' => 'П\'ят.',
        'Sat' => 'Сб.',

        # Template: AdminAttachment
        'Attachment Management' => 'Керування прикріпленими файлами',
        'Actions' => 'Дії',
        'Go to overview' => 'Перейти до перегляду',
        'Add attachment' => '',
        'List' => 'Список',
        'Validity' => '',
        'No data found.' => 'Дані не знайдені.',
        'Download file' => 'Скачати файл',
        'Delete this attachment' => 'Вилучити це вкладення',
        'Add Attachment' => 'Додати вкладення',
        'Edit Attachment' => 'Редагувати вкладення',
        'This field is required.' => '',
        'or' => 'або',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Керування автовідповідями',
        'Add auto response' => 'Додати автовідповідь',
        'Add Auto Response' => 'Додати автовідповідь',
        'Edit Auto Response' => 'Змінити автовідповідь',
        'Response' => 'Відповідь',
        'Auto response from' => 'Автовідповідь від',
        'Reference' => 'Посилання',
        'You can use the following tags' => 'Ви можете використовувати наступні теги',
        'To get the first 20 character of the subject.' => 'Щоб бачити перші 20 символів теми',
        'To get the first 5 lines of the email.' => 'Щоб бачити перші 5 рядків email',
        'To get the realname of the sender (if given).' => 'Щоб бачити реальне ім\'я відправника (якщо зазначене)',
        'To get the article attribute' => 'Отримати атрибути статті',
        ' e. g.' => ' наприклад,',
        'Options of the current customer user data' => 'Персональні опції клієнта',
        'Ticket owner options' => 'Опції власника заявки',
        'Ticket responsible options' => 'Опції відповідального на заявку',
        'Options of the current user who requested this action' => 'Опції поточного користувача до відповів на подію',
        'Options of the ticket data' => 'Опції інформації заявки',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Налаштування опцій',
        'Example response' => 'Приклад відповіді',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Керування компанією клієнта',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer company' => 'Додати компанію клієнта',
        'Please enter a search term to look for customer companies.' => ' Будь ласка введіть пошукову фразу для пошуку компаній клієнта.',
        'Add Customer Company' => 'Додати компанію клієнта',

        # Template: AdminCustomerUser
        'Customer Management' => 'Керування клієнтами',
        'Back to search results' => '',
        'Add customer' => 'Додати клієнта',
        'Select' => 'Вибір',
        'Hint' => '',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            '',
        'Please enter a search term to look for customers.' => ' Будь ласка, уведіть пошукове вираження для пошуку клієнтів.',
        'Last Login' => 'Останній вхід',
        'Login as' => 'Зайти даним користувачем',
        'Switch to customer' => '',
        'Add Customer' => 'Додати Клієнта',
        'Edit Customer' => 'Редагувати Клієнта',
        'This field is required and needs to be a valid email address.' =>
            '',
        'This email address is not allowed due to the system configuration.' =>
            '',
        'This email address failed MX check.' => '',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => '',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => '',
        'Notice' => 'Оповіщення',
        'This feature is disabled!' => 'Дана функція відключена!',
        'Just use this feature if you want to define group permissions for customers.' =>
            '',
        'Enable it here!' => 'Включити функцію!',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => 'Редагувати групи по-умовчанню клієнта',
        'These groups are automatically assigned to all customers.' => 'Ці групи автоматично призначаються всім клієнтам.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Фільтри для Груп',
        'Select the customer:group permissions.' => 'Выбериет клієнта:дозволу для групи',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '',
        'Search Results' => 'Результати пошуку',
        'Customers' => 'Клієнти',
        'Groups' => 'Групи',
        'No matches found.' => 'Збігів не знайдене.',
        'Change Group Relations for Customer' => '',
        'Change Customer Relations for Group' => '',
        'Toggle %s Permission for all' => '',
        'Toggle %s permission for %s' => '',
        'Customer Default Groups:' => 'Клієнтська група по-умовчанню:',
        'No changes can be made to these groups.' => '',
        'ro' => 'Тільки читання',
        'Read only access to the ticket in this group/queue.' => 'Права тільки на читання заявки в даній групі/черги',
        'rw' => 'Читання/запис',
        'Full read and write access to the tickets in this group/queue.' =>
            'Повні права на заявки в даній групі/черги',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => '',
        'Edit default services' => '',
        'Filter for Services' => '',
        'Allocate Services to Customer' => '',
        'Allocate Customers to Service' => '',
        'Toggle active state for all' => '',
        'Active' => 'Активний',
        'Toggle active state for %s' => '',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => 'Порядок',
        'Object' => 'Об\'єкт',
        'Delete this field' => '',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '',
        'Field' => '',
        'Go back to overview' => '',
        'General' => '',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => '',
        'This field is required and must be numeric.' => '',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Field type' => '',
        'Object type' => '',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => '',
        'Default value' => '',
        'This is the default value for this field.' => '',
        'Save' => 'Зберегти',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '',
        'This field must be numeric.' => '',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'Ключ',
        'Value' => 'Значення',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'Замітка',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',

        # Template: AdminEmail
        'Admin Notification' => 'Повідомлення адміністратором',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '',
        'Create Administrative Message' => '',
        'Your message was sent to' => 'Ваше повідомлення було відправлено к',
        'Send message to users' => 'Відправити повідомлення користувачам',
        'Send message to group members' => 'Відправити сообщенеи членам групи',
        'Group members need to have permission' => 'Члени групи повинні мати дозволу',
        'Send message to role members' => 'Відправити повідомлення членам ролі',
        'Also send to customers in groups' => 'Також відправити клієнтам у групах',
        'Body' => 'Тіло листа',
        'Send' => 'Відправити',

        # Template: AdminGenericAgent
        'Generic Agent' => '',
        'Add job' => 'Додати завдання',
        'Last run' => 'Останній запуск',
        'Run Now!' => 'Виконати зараз!',
        'Delete this task' => 'Вилучити завдання',
        'Run this task' => 'Запустити завдання',
        'Job Settings' => 'Настроювання завдання',
        'Job name' => 'Ім\'я завдання',
        'Currently this generic agent job will not run automatically.' =>
            'Це завдання агента не запускається автоматично',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            ' Для автоматичного запуску вкажіть як мінімум одне зі значень у хвилинах, годиннику або днях',
        'Schedule minutes' => '',
        'Schedule hours' => '',
        'Schedule days' => '',
        'Toggle this widget' => '',
        'Ticket Filter' => 'Фільтр заявок',
        '(e. g. 10*5155 or 105658*)' => '(наприклад, 10*5155 або 105658*)',
        '(e. g. 234321)' => '(наприклад, 234321)',
        'Customer login' => '',
        '(e. g. U5150)' => '(наприклад, U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '',
        'Agent' => 'Агент',
        'Ticket lock' => '',
        'Create times' => '',
        'No create time settings.' => ' Без обліку часу створення',
        'Ticket created' => 'Заявка створена',
        'Ticket created between' => 'Заявка створена між ',
        'Change times' => '',
        'No change time settings.' => 'Не змінювати параметри часу',
        'Ticket changed' => 'Заявка змінена',
        'Ticket changed between' => 'Заявка змінена в період',
        'Close times' => '',
        'No close time settings.' => ' Без обліку часу закриття',
        'Ticket closed' => 'Заявка закрита',
        'Ticket closed between' => 'Заявка закрита між',
        'Pending times' => '',
        'No pending time settings.' => ' Без обліку часу, коли запит був відкладений',
        'Ticket pending time reached' => 'Заявка була відкладена',
        'Ticket pending time reached between' => 'Заявка була відкладена між',
        'Escalation times' => '',
        'No escalation time settings.' => ' Без обліку часу ескалації',
        'Ticket escalation time reached' => 'Заявка була ескальована',
        'Ticket escalation time reached between' => 'Заявка була ескальована між',
        'Escalation - first response time' => 'Ескалація - час першої відповіді',
        'Ticket first response time reached' => 'Перша відповідь',
        'Ticket first response time reached between' => 'Перша відповідь між',
        'Escalation - update time' => 'Ескалація - час відновлення',
        'Ticket update time reached' => 'Заявка була оновлена',
        'Ticket update time reached between' => 'Заявка була оновлена між',
        'Escalation - solution time' => 'Ескалація - час розв\'язку',
        'Ticket solution time reached' => 'Заявка була вирішена',
        'Ticket solution time reached between' => 'Заявка була вирішена між',
        'Archive search option' => '',
        'Ticket Action' => 'Дії за заявкою',
        'Set new service' => 'Установити новий сервіс',
        'Set new Service Level Agreement' => '',
        'Set new priority' => 'Установити новий пріоритет',
        'Set new queue' => '',
        'Set new state' => 'Установити новий стан',
        'Set new agent' => 'Призначити нового агента',
        'new owner' => 'новий власник',
        'new responsible' => '',
        'Set new ticket lock' => '',
        'New customer' => 'Новий клієнт',
        'New customer ID' => 'ID нового клієнта',
        'New title' => 'Новий заголовок',
        'New type' => 'Новий тип',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => '',
        'Add Note' => 'Додати замітку',
        'Time units' => 'Одиниці часу',
        '(work units)' => '( робочі одиниці)',
        'Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Відправляти повідомлення агентові при змінах',
        'CMD' => 'Команда',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ця команда буде виконана. ARG[0] — номер заявки. ARG[1] — id заявки.',
        'Delete tickets' => 'Вилучити заявки',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Попередження: Усі обрані заявки будуть вилучені з бази даних без можливості відновлення!',
        'Execute Custom Module' => '',
        'Param %s key' => '',
        'Param %s value' => '',
        'Save Changes' => '',
        'Results' => 'Результат',
        '%s Tickets affected! What do you want to do?' => '',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '',
        'Edit job' => 'Редагувати завдання',
        'Run job' => 'Запустити завдання',
        'Affected Tickets' => 'Обрані завдання',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Час',
        'Remote IP' => '',
        'Loading' => 'Завантаження',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Обновити',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content' => 'Відобразити або сховати вміст',
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
        'The name you entered already exists.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => '',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Event Triggers' => '',
        'Asynchronous' => '',
        'Delete this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Save and finish' => '',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => '',
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
        'Properties' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
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
        'Import' => 'Імпорт',
        'Configuration history' => '',
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
        'Details' => '',
        'Debug threshold' => '',
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
        'Configuration History List' => '',
        'Version' => 'Версія',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '',
        'Group Management' => 'Керування групами',
        'Add group' => 'Додати групу',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Група admin може здійснювати адміністрування, а група stats — переглядати статистику',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '',
        'It\'s useful for ASP solutions. ' => 'Корисно для сервісів-провайдерів.',
        'Add Group' => 'Додати групу',
        'Edit Group' => 'Редагувати групу',

        # Template: AdminLog
        'System Log' => 'Системний журнал',
        'Here you will find log information about your system.' => '',
        'Hide this message' => '',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Керування поштовими обліковими записами',
        'Add mail account' => 'Додати поштовий обліковий запис',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Усі вхідні листи із зазначеного облікового запису будуть перенесені в обрану чергу!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '',
        'Host' => 'Сервер',
        'Delete account' => 'Вилучити обліковий запис',
        'Fetch mail' => 'Забрати лист',
        'Add Mail Account' => 'Додати поштовий обліковий запис',
        'Example: mail.example.com' => '',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Безпечна',
        'Dispatching' => 'Перенапрямок',
        'Edit Mail Account' => 'Змінити поштовий обліковий запис',

        # Template: AdminNavigationBar
        'Admin' => 'Адміністрування',
        'Agent Management' => 'Керування агентами',
        'Queue Settings' => 'Настроювання черг',
        'Ticket Settings' => 'Настроювання заявок',
        'System Administration' => 'Настроювання системи',

        # Template: AdminNotification
        'Notification Management' => 'Керування повідомленнями',
        'Select a different language' => '',
        'Filter for Notification' => '',
        'Notifications are sent to an agent or a customer.' => 'Повідомлення відправлені агентові або клієнтові',
        'Notification' => 'Повідомлення',
        'Edit Notification' => 'Редагувати повідомлення',
        'e. g.' => 'наприклад,',
        'Options of the current customer data' => '',

        # Template: AdminNotificationEvent
        'Add notification' => '',
        'Delete this notification' => '',
        'Add Notification' => 'Додати повідомлення',
        'Recipient groups' => '',
        'Recipient agents' => '',
        'Recipient roles' => '',
        'Recipient email addresses' => '',
        'Article type' => 'Тип повідомлення',
        'Only for ArticleCreate event' => '',
        'Article sender type' => '',
        'Subject match' => 'Відповідність темі',
        'Body match' => 'Відповідність тілу листа',
        'Include attachments to notification' => 'Додати вкладення в повідомлення',
        'Notification article type' => '',
        'Only for notifications to specified email addresses' => '',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Перші 20 символів теми з останнього повідомлення агента',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Перші 5 рядків останнього повідомлення агента',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Перші 20 символів теми з останнього повідомлення клієнта',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Перші 5 рядків останнього повідомлення клієнта',

        # Template: AdminPGP
        'PGP Management' => 'Керування підписами PGP',
        'Use this feature if you want to work with PGP keys.' => '',
        'Add PGP key' => 'Додати PGP ключ',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            '',
        'Introduction to PGP' => '',
        'Result' => 'Результат',
        'Identifier' => 'Ідентифікатор',
        'Bit' => 'Біт',
        'Fingerprint' => 'Цифровий відбиток',
        'Expires' => 'Минає',
        'Delete this key' => 'Вилучити ключ',
        'Add PGP Key' => 'Додати PGP ключ',
        'PGP key' => '',

        # Template: AdminPackageManager
        'Package Manager' => 'Керування пакетами',
        'Uninstall package' => 'Деінсталювати пакет',
        'Do you really want to uninstall this package?' => 'Вилучити цей пакет?',
        'Reinstall package' => 'Переустановити пакет',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '',
        'Continue' => 'Продовжити',
        'Install' => 'Установити',
        'Install Package' => 'Установити пакет',
        'Update repository information' => 'Обновити інформацію репозитарія',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Онлайновий репозитарій',
        'Vendor' => 'Виготовлювач',
        'Module documentation' => 'Документація модуля',
        'Upgrade' => 'Обновити',
        'Local Repository' => 'Локальний репозитарій',
        'Uninstall' => 'Вилучити',
        'Reinstall' => 'Переустановити',
        'Feature Add-Ons' => '',
        'Download package' => 'Скачати пакет',
        'Rebuild package' => 'Перезібрати пакет',
        'Metadata' => 'Метадані',
        'Change Log' => '',
        'Date' => 'Дата',
        'List of Files' => 'Список файлів',
        'Permission' => 'Права доступу',
        'Download' => 'Завантажити',
        'Download file from package!' => 'Завантажити файл із пакета!',
        'Required' => ' Потрібно',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Файл відмінностей для файлу %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Журнал продуктивності',
        'This feature is enabled!' => 'Дана функція активована!',
        'Just use this feature if you want to log each request.' => 'Використовуйте цю функцію, якщо прагнете затягати кожний запит у журнал',
        'Activating this feature might affect your system performance!' =>
            'Включення цієї функції може позначитися на продуктивності вашої системи',
        'Disable it here!' => 'Відключити функцію!',
        'Logfile too large!' => 'Файл журналу занадто великий!',
        'The logfile is too large, you need to reset it' => 'Файл логу занадто великий, необхідно його очистити',
        'Overview' => 'Огляд',
        'Range' => 'Діапазон',
        'Interface' => 'Інтерфейс',
        'Requests' => 'Запитів',
        'Min Response' => 'Мінімальний час відповіді',
        'Max Response' => 'Максимальний час відповіді',
        'Average Response' => 'Середній час відповіді',
        'Period' => 'Період',
        'Min' => 'Мін',
        'Max' => 'Макс',
        'Average' => 'Середнє',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '',
        'Add filter' => 'Додати фільтр',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Якщо ви прагнете отфильтровать тільки по адресах електронної пошти, використовуйте EMAILADDRESS:info@example.com у полях From, To або Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '',
        'Delete this filter' => 'Вилучити цей фільтр',
        'Add PostMaster Filter' => '',
        'Edit PostMaster Filter' => '',
        'Filter name' => '',
        'The name is required.' => '',
        'Stop after match' => 'Припинити перевірку після збігу',
        'Filter Condition' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => '',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Керування пріоритетами',
        'Add priority' => 'Додати пріоритет',
        'Add Priority' => 'Створити пріоритет',
        'Edit Priority' => 'Змінити пріоритет',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'Фільтр',
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
        'Print' => 'Друк',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => '',
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
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
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
        'Remove the Transition from this Process' => '',
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
        'Manage Queues' => 'Керування чергами',
        'Add queue' => 'Додати черга',
        'Add Queue' => 'Додати Черга',
        'Edit Queue' => 'Змінити черга',
        'Sub-queue of' => 'Підчерга черги',
        'Unlock timeout' => 'Строк блокування',
        '0 = no unlock' => '0 — без блокування',
        'Only business hours are counted.' => 'З обліком тільки робочого часу.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '',
        'Notify by' => 'Повідомлення від',
        '0 = no escalation' => '0 — без ескалації',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Якщо заявка не закрита до зазначеного тут часу завершення, вона ескалюється.',
        'Follow up Option' => 'Параметри автовідповіді',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '',
        'Ticket lock after a follow up' => 'Блокувати заявку після одержання відповіді',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '',
        'System address' => 'Адреса системи',
        'Will be the sender address of this queue for email answers.' => 'Установка адреси відправника для відповідей у цій черзі.',
        'Default sign key' => '',
        'The salutation for email answers.' => 'Вітання для листів',
        'The signature for email answers.' => 'Підпис для листів',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '',
        'Filter for Queues' => '',
        'Filter for Auto Responses' => '',
        'Auto Responses' => 'Автовідповіді',
        'Change Auto Response Relations for Queue' => '',
        'settings' => 'параметри',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => '',
        'Filter for Responses' => '',
        'Responses' => 'Відповіді',
        'Change Queue Relations for Response' => '',
        'Change Response Relations for Queue' => '',

        # Template: AdminResponse
        'Manage Responses' => '',
        'Add response' => 'Додати відповідь',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => '',
        'Add Response' => 'Додати відповідь',
        'Edit Response' => 'Змінити відповідь',
        'The current ticket state is' => 'Поточний стан заявки',
        'Your email address is' => 'Ваш email адреса ',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => '',
        'Filter for Attachments' => '',
        'Change Response Relations for Attachment' => '',
        'Change Attachment Relations for Response' => '',
        'Toggle active for all' => '',
        'Link %s to selected %s' => '',

        # Template: AdminRole
        'Role Management' => 'Керування ролями',
        'Add role' => 'Додати роль',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Створіть роль і додайте в неї групи. Потім розподілите ролі по користувачах.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Ролі не визначені. Будь ласка, використовуйте кнопку \'Додати\' для створення нової ролі.',
        'Add Role' => 'Додати роль',
        'Edit Role' => 'Змінити роль',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '',
        'Filter for Roles' => '',
        'Roles' => 'Ролі',
        'Select the role:group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '',
        'Change Role Relations for Group' => '',
        'Change Group Relations for Role' => '',
        'Toggle %s permission for all' => '',
        'move_into' => 'перемістити',
        'Permissions to move tickets into this group/queue.' => 'Права на переміщення заявок у цю групу/черга',
        'create' => 'створення',
        'Permissions to create tickets in this group/queue.' => 'Права на створення заявок у цій групі/черги',
        'priority' => 'пріоритет',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Права на зміну пріоритету заявок у цій групі/черги',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '',
        'Filter for Agents' => '',
        'Agents' => 'Агенти',
        'Manage Role-Agent Relations' => '',
        'Change Role Relations for Agent' => '',
        'Change Agent Relations for Role' => '',

        # Template: AdminSLA
        'SLA Management' => 'Керування SLA',
        'Add SLA' => 'Додати SLA',
        'Edit SLA' => 'Змінити SLA',
        'Please write only numbers!' => '',

        # Template: AdminSMIME
        'S/MIME Management' => 'Керування S/MIME',
        'Add certificate' => 'Додати сертифікат',
        'Add private key' => 'Додати закритий ключ',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Див. також',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Ви можете редагувати сертифікати й закриті ключі прямо на файловій системі',
        'Hash' => 'Хеш',
        'Create' => 'Створити',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'Вилучити сертифікат',
        'Add Certificate' => 'Додати сертифікат',
        'Add Private Key' => 'Додати закритий ключ',
        'Secret' => 'Пароль',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Керування вітаннями',
        'Add salutation' => '',
        'Add Salutation' => 'Додати вітання',
        'Edit Salutation' => 'Редагувати вітання',
        'Example salutation' => 'Приклад вітання',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => ' Необхідно включити безпечний режим',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Після установки системи звичайно відразу ж включають безпечний режим.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '',

        # Template: AdminSelectBox
        'SQL Box' => 'Запит SQL',
        'Here you can enter SQL to send it directly to the application database.' =>
            '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            '',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => 'Формат результату',
        'Run Query' => 'Запустити чергу',

        # Template: AdminService
        'Service Management' => 'Керування сервісами',
        'Add service' => 'Додати сервіс',
        'Add Service' => 'Додати Сервіс',
        'Edit Service' => 'Змінити Сервіс',
        'Sub-service of' => 'Підсервіс сервісу',

        # Template: AdminSession
        'Session Management' => 'Керування сеансами',
        'All sessions' => 'Усі сеанси',
        'Agent sessions' => 'Сеанси агента',
        'Customer sessions' => 'Сеанси клієнта',
        'Unique agents' => 'Унікальні агенти',
        'Unique customers' => 'Унікальні клієнти',
        'Kill all sessions' => 'Завершити всі сеанси',
        'Kill this session' => 'Завершити сеанс',
        'Session' => 'Сеанс',
        'Kill' => '',
        'Detail View for SessionID' => '',

        # Template: AdminSignature
        'Signature Management' => 'Керування підписами',
        'Add signature' => 'Додати підпис',
        'Add Signature' => 'Додати Підпис',
        'Edit Signature' => 'Змінити підпис',
        'Example signature' => 'Приклад підпису',

        # Template: AdminState
        'State Management' => 'Керування станами',
        'Add state' => 'Додати стан',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'Додати стан',
        'Edit State' => 'Змінити стан',
        'State type' => 'Тип стану',

        # Template: AdminSysConfig
        'SysConfig' => '',
        'Navigate by searching in %s settings' => '',
        'Navigate by selecting config groups' => '',
        'Download all system config changes' => '',
        'Export settings' => 'Експортувати настроювання',
        'Load SysConfig settings from file' => '',
        'Import settings' => 'Імпортувати настроювання',
        'Import Settings' => 'Імпортувати Настроювання',
        'Please enter a search term to look for settings.' => ' Будь ласка, уведіть пошуковий запит для пошуку настроювань.',
        'Subgroup' => 'Підгрупа',
        'Elements' => 'Елементи',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => '',
        'This config item is only available in a higher config level!' =>
            '',
        'Reset this setting' => '',
        'Error: this file could not be found.' => '',
        'Error: this directory could not be found.' => '',
        'Error: an invalid value was entered.' => '',
        'Content' => 'Зміст',
        'Remove this entry' => '',
        'Add entry' => '',
        'Remove entry' => '',
        'Add new entry' => '',
        'Create new entry' => '',
        'New group' => '',
        'Group ro' => '',
        'Readonly group' => '',
        'New group ro' => '',
        'Loader' => '',
        'File to load for this frontend module' => '',
        'New Loader File' => '',
        'NavBarName' => '',
        'NavBar' => '',
        'LinkOption' => '',
        'Block' => 'Розділ',
        'AccessKey' => '',
        'Add NavBar entry' => '',
        'Year' => '',
        'Month' => '',
        'Day' => '',
        'Invalid year' => '',
        'Invalid month' => '',
        'Invalid day' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Керування системними адресами електронної пошти',
        'Add system address' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '',
        'Email address' => 'Email адреса',
        'Display name' => 'Відображуване ім\'я',
        'Add System Email Address' => 'Додати системну Email адресу',
        'Edit System Email Address' => 'Коригувати системну Email адресу',
        'The display name and email address will be shown on mail you send.' =>
            'Це ім\'я та email адреса будуть показані у ваших відправлених лістах',

        # Template: AdminType
        'Type Management' => 'Керування типами заявок',
        'Add ticket type' => 'Додати тип заявки',
        'Add Type' => 'Додати тип',
        'Edit Type' => 'Редагувати тип',

        # Template: AdminUser
        'Add agent' => '',
        'Agents will be needed to handle tickets.' => '',
        'Don\'t forget to add a new agent to groups and/or roles!' => '',
        'Please enter a search term to look for agents.' => '',
        'Last login' => '',
        'Switch to agent' => '',
        'Add Agent' => '',
        'Edit Agent' => '',
        'Firstname' => 'Ім\'я',
        'Lastname' => 'Прізвище',
        'Password is required.' => '',
        'Start' => 'Початок',
        'End' => 'Закінчення',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '',
        'Change Group Relations for Agent' => '',
        'Change Agent Relations for Group' => '',
        'note' => '',
        'Permissions to add notes to tickets in this group/queue.' => '',
        'owner' => 'власник',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '',

        # Template: AgentBook
        'Address Book' => 'Адресна книга',
        'Search for a customer' => '',
        'Add email address %s to the To field' => '',
        'Add email address %s to the Cc field' => '',
        'Add email address %s to the Bcc field' => '',
        'Apply' => '',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID клієнта',
        'Customer User' => 'Користувач клієнта',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Шукати клієнта',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
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
        '%s %s is available!' => '%s %s доступний',
        'Please update now.' => 'Обновите зараз',
        'Release Note' => 'Примітка до релізу',
        'Level' => 'Рівень',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Опубліковане %s',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '',
        'My watched tickets' => '',
        'My responsibilities' => '',
        'Tickets in My Queues' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => '',
        'Undo & close window' => '',

        # Template: AgentInfo
        'Info' => 'Інформація',
        'To accept some news, a license or some changes.' => '',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Зв\'язати об\'єкт: %s',
        'go to link delete screen' => '',
        'Select Target Object' => '',
        'Link Object' => 'Зв\'язати об\'єкт',
        'with' => 'с',
        'Unlink Object: %s' => 'Скасувати прив\'язку об\'єкта: %s',
        'go to link add screen' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => '',

        # Template: AgentSpelling
        'Spell Checker' => 'Перевірка орфографії',
        'spelling error(s)' => 'Орфографічні помилки',
        'Apply these changes' => 'Застосувати зміни',

        # Template: AgentStatsDelete
        'Delete stat' => '',
        'Stat#' => 'Звіт №',
        'Do you really want to delete this stat?' => '',

        # Template: AgentStatsEditRestrictions
        'Step %s' => '',
        'General Specifications' => '',
        'Select the element that will be used at the X-axis' => '',
        'Select the elements for the value series' => 'Виберіть елементи для послідовності значень',
        'Select the restrictions to characterize the stat' => '',
        'Here you can make restrictions to your stat.' => 'Тут ви можете внести обмеження у вашу статистику',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Якщо ви зніміть прапорець параметра «Фіксоване», користувач, який буде створювати звіти, зможе міняти параметри відповідного елемента',
        'Fixed' => 'Фіксоване',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Виберіть тільки один пункт або заберіть прапорець «Фіксоване».',
        'Absolute Period' => '',
        'Between' => ' Між',
        'Relative Period' => 'Відносний період',
        'The last' => 'Останній',
        'Finish' => 'Закінчити',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Права',
        'You can select one or more groups to define access for different agents.' =>
            '',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            '',
        'Please contact your administrator.' => '',
        'Graph size' => 'Розмір графіка',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Якщо ви використовуєте графіки, вам необхідно вибрати хоча б один розмір графіка.',
        'Sum rows' => 'Сума рядків',
        'Sum columns' => 'Сума стовпців',
        'Use cache' => 'Кешувати',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Більшість звітів можуть кешуватись. Це збільшить швидкість показу звітів.',
        'If set to invalid end users can not generate the stat.' => '',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => '',
        'You have the possibility to select one or two elements.' => '',
        'Then you can select the attributes of elements.' => '',
        'Each attribute will be shown as single value series.' => '',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            '',
        'Scale' => 'Масштаб',
        'minimal' => 'Мінімальний',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            '',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            '',
        'maximal period' => 'максимальний період',
        'minimal scale' => 'мінімальний масштаб',

        # Template: AgentStatsImport
        'Import Stat' => 'Імпортувати статистику',
        'File is not a Stats config' => 'Файл не є файлом конфігурації звітів',
        'No File selected' => 'Файл не обраний',

        # Template: AgentStatsOverview
        'Stats' => 'Статистика',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Елемент не обраний.',

        # Template: AgentStatsView
        'Export config' => '',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            '',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            '',
        'Stat Details' => '',
        'Format' => 'Формат',
        'Graphsize' => 'Розмір графіка',
        'Cache' => 'Кеш',
        'Exchange Axis' => 'Поміняти осі',
        'Configurable params of static stat' => 'Налаштовувані параметри статичного звіту',
        'No element selected.' => 'Елементи не обрані',
        'maximal period from' => 'Максимальний період с',
        'to' => 'по',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => '',
        'Change Owner of Ticket' => '',
        'Close Ticket' => '',
        'Add Note to Ticket' => '',
        'Set Pending' => 'Установка очікування',
        'Change Priority of Ticket' => '',
        'Change Responsible of Ticket' => '',
        'Service invalid.' => '',
        'New Owner' => 'Новий власник',
        'Please set a new owner!' => '',
        'Previous Owner' => 'Попередній власник',
        'Inform Agent' => 'Повідомити агента',
        'Optional' => 'Необов\'язково',
        'Inform involved Agents' => 'Повідомити що брав участь агентів',
        'Spell check' => '',
        'Note type' => 'Тип замітки',
        'Next state' => 'Наступний стан',
        'Pending date' => 'Дата очікування',
        'Date invalid!' => '',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Переслати для',
        'You need a email address.' => '',
        'Need a valid email address or don\'t use a local email address.' =>
            '',
        'Next ticket state' => 'Наступний стан заявки',
        'Inform sender' => 'Інформувати відправника',
        'Send mail!' => 'Оправити лист!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Масова дія',
        'Send Email' => '',
        'Merge to' => 'Об\'єднати с',
        'Invalid ticket identifier!' => '',
        'Merge to oldest' => 'Об\'єднати із самим старим',
        'Link together' => 'Зв\'язати',
        'Link to parent' => '',
        'Unlock tickets' => '',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Створення відповідь на заявку',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Адресна книга',
        'Pending Date' => 'Наступна дата',
        'for pending* states' => ' для наступних станів* ',
        'Date Invalid!' => 'Невірна дата!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Змінити клієнта заявки',
        'Customer user' => 'Користувач клієнта',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Заявка по e-mail',
        'From queue' => ' Із черги',
        'To customer' => '',
        'Please include at least one customer for the ticket.' => '',
        'Get all' => '',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Історія',
        'History Content' => 'Історія',
        'Zoom view' => '',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Об\'єднання заявок',
        'You need to use a ticket number!' => 'Вам необхідно використовувати номер заявки!',
        'A valid ticket number is required.' => '',
        'Need a valid email address.' => ' Потрібно вірну поштову адресу.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Перемістити заявку',
        'New Queue' => 'Нова черга',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => '',
        'No ticket data found.' => '',
        'First Response Time' => 'Час до першої відповіді',
        'Service Time' => 'Час обслуговування',
        'Update Time' => 'Час до зміни заявки',
        'Solution Time' => 'Час розв\'язку заявки',
        'Move ticket to a different queue' => 'Перемістити заявку в іншу чергу',
        'Change queue' => 'Перемістити в іншу чергу',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Змінити параметри пошуку',
        'Tickets per page' => '',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Ескалація через',
        'Locked' => 'Блокування',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Заявка по телефону',
        'From customer' => ' Від клієнта',
        'To queue' => 'У чергу',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Телефонний дзвінок',

        # Template: AgentTicketPlain
        'Email Text Plain View' => '',
        'Plain' => 'Звичайний',
        'Download this email' => '',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Інформація про заявку',
        'Accounted time' => 'Витрачене на заявку час',
        'Linked-Object' => 'Зв\'язаний об\'єкт',
        'by' => '',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Шаблон пошуку',
        'Create Template' => 'Створити шаблон',
        'Create New' => 'Створити новий',
        'Profile link' => '',
        'Save changes in template' => '',
        'Add another attribute' => 'Додати ще атрибут',
        'Output' => 'Вивід результатів',
        'Fulltext' => 'Повнотекстовий',
        'Remove' => 'Вилучити',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Логін клієнта',
        'Created in Queue' => 'Створена в черзі',
        'Lock state' => '',
        'Watcher' => '',
        'Article Create Time (before/after)' => '',
        'Article Create Time (between)' => '',
        'Ticket Create Time (before/after)' => '',
        'Ticket Create Time (between)' => '',
        'Ticket Change Time (before/after)' => '',
        'Ticket Change Time (between)' => '',
        'Ticket Close Time (before/after)' => '',
        'Ticket Close Time (between)' => '',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Пошук в архіві',
        'Run search' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => '',
        'Article Type' => 'Тип повідомлення',
        'Sender Type' => '',
        'Save filter settings as default' => 'Зберегти умови фільтра для показу за замовчуванням',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Linked Objects' => 'Зв\'язані Об\'єкти',
        'Article(s)' => 'Заявка(и)',
        'Change Queue' => 'Перемінити черга',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Article Filter' => '',
        'Add Filter' => 'Додати фільтр',
        'Set' => 'Установити',
        'Reset Filter' => 'Скинути фільтр',
        'Show one article' => 'Відобразити одну заявку',
        'Show all articles' => 'Відобразити всі заявки',
        'Unread articles' => 'Непрочитані заявки',
        'No.' => 'Номер',
        'Unread Article!' => 'Непрочитані заявки!',
        'Incoming message' => 'Вхідне повідомлення',
        'Outgoing message' => '',
        'Internal message' => '',
        'Resize' => '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => '',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Відстеження',

        # Template: CustomerFooter
        'Powered by' => 'Використовується',
        'One or more errors occurred!' => '',
        'Close this dialog' => 'Закрити цей діалог',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => '',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => '',
        'The browser you are using is too old.' => '',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            '',
        'Login' => 'Вхід',
        'User name' => '',
        'Your user name' => '',
        'Your password' => '',
        'Forgot password?' => 'Забули пароль?',
        'Log In' => 'Увійти',
        'Not yet registered?' => 'Прагнете зареєструватися?',
        'Sign up now' => 'Увійти',
        'Request new password' => 'Надіслати новий пароль',
        'Your User Name' => 'Логін',
        'A new password will be sent to your email address.' => '',
        'Create Account' => 'Створити обліковий запис',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => '',
        'Your First Name' => 'Ваше Ім\'я',
        'Your Last Name' => 'Ваше Прізвище',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => '',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => '',

        # Template: CustomerTicketOverview
        'Welcome!' => '',
        'Please click the button below to create your first ticket.' => '',
        'Create your first ticket' => '',

        # Template: CustomerTicketPrint
        'Ticket Print' => '',

        # Template: CustomerTicketSearch
        'Profile' => 'Параметри',
        'e. g. 10*5155 or 105658*' => 'наприклад, 10*5155 або 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Повнотекстовий пошук у заявці (наприклад, "Іван*в" або "Петро*")',
        'Recipient' => 'Одержувач',
        'Carbon Copy' => 'Копія',
        'Time restrictions' => 'Тимчасові рамки',
        'No time settings' => '',
        'Only tickets created' => 'Заявки створені',
        'Only tickets created between' => 'Заявки створені проміжку',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => 'Зберегти як шаблон',
        'Save as Template' => '',
        'Template Name' => 'Ім\'я шаблону',
        'Pick a profile name' => '',
        'Output to' => 'Вивести як',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => ' з',
        'Page' => 'Сторінка',
        'Search Results for' => '',

        # Template: CustomerTicketZoom
        'Show  article' => '',
        'Expand article' => '',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Відповісти',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => '',
        'Previous' => '',
        'Sunday' => '',
        'Monday' => '',
        'Tuesday' => '',
        'Wednesday' => '',
        'Thursday' => '',
        'Friday' => '',
        'Saturday' => '',
        'Su' => '',
        'Mo' => '',
        'Tu' => '',
        'We' => '',
        'Th' => '',
        'Fr' => '',
        'Sa' => '',
        'Open date selection' => '',

        # Template: Error
        'Oops! An Error occurred.' => '',
        'Error Message' => '',
        'You can' => '',
        'Send a bugreport' => 'Відправити повідомлення про помилку',
        'go back to the previous page' => '',
        'Error Details' => 'Деталі помилки',

        # Template: Footer
        'Top of page' => 'У початок сторінки',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Ви ввійшли як',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => '',
        'Database Settings' => '',
        'General Specifications and Mail Settings' => '',
        'Registration' => '',
        'Welcome to %s' => ' Ласкаво просимо в %s',
        'Web site' => '',
        'Database check successful.' => '',
        'Mail check successful.' => '',
        'Error in the mail settings. Please correct and try again.' => '',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '',
        'Outbound mail type' => '',
        'Select outbound mail type.' => '',
        'Outbound mail port' => '',
        'Select outbound mail port.' => '',
        'SMTP host' => 'SMTP сервер',
        'SMTP host.' => 'SMTP сервер.',
        'SMTP authentication' => 'SMTP аутентифікація',
        'Does your SMTP host need authentication?' => 'SMTP сервер вимагає аутентифікацію?',
        'SMTP auth user' => '',
        'Username for SMTP auth.' => '',
        'SMTP auth password' => '',
        'Password for SMTP auth.' => '',
        'Configure Inbound Mail' => '',
        'Inbound mail type' => '',
        'Select inbound mail type.' => '',
        'Inbound mail host' => 'Поштовий сервер для вхідної пошти',
        'Inbound mail host.' => '',
        'Inbound mail user' => 'Ім\'я користувача для вхідної пошти',
        'User for inbound mail.' => 'Ім\'я користувача для вхідної пошти.',
        'Inbound mail password' => 'Пароль для вхідної пошти',
        'Password for inbound mail.' => 'Пароль для вхідної пошти.',
        'Result of mail configuration check' => 'Результати перевірки настроювань пошти',
        'Check mail configuration' => 'Перевірити настроювання пошти',
        'Skip this step' => 'Пропустити цей крок',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => '',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Якщо для адміністратора бази даних установлений пароль, укажіть його тут. Якщо ні, залиште поле порожнім. З міркувань безпеки ми рекомендуємо створити пароль адміністратора. Інформацію із цієї теми можна знайти в документації по використовуваній базі даних',
        'Currently only MySQL is supported in the web installer.' => '',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            '',
        'Database-User' => 'Користувач бази даних',
        'New' => 'Новий',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            '',
        'default \'hot\'' => ' За замовчуванням: «hot»',
        'DB host' => '',
        'Check database settings' => '',
        'Result of database check' => '',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Щоб використовувати OTRS, виконайте в командному рядку під правами root наступну команду:',
        'Restart your webserver' => ' Запустите знову ваш веб-сервер',
        'After doing so your OTRS is up and running.' => 'Після цих дій система вже запущена.',
        'Start page' => 'Головна сторінка',
        'Your OTRS Team' => 'Команда розроблювачів OTRS',

        # Template: InstallerLicense
        'Accept license' => 'Ухвалюю умови ліцензії',
        'Don\'t accept license' => 'Не ухвалюю умови ліцензії',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Організація',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => '',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '',
        'System FQDN' => 'Системне FQDN',
        'Fully qualified domain name of your system.' => '',
        'AdminEmail' => '',
        'Email address of the system administrator.' => '',
        'Log' => 'Журнал',
        'LogModule' => '',
        'Log backend to use.' => '',
        'LogFile' => '',
        'Log file location is only needed for File-LogModule!' => '',
        'Webfrontend' => 'Веб-інтерфейс',
        'Default language' => '',
        'Default language.' => '',
        'CheckMXRecord' => '',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '',

        # Template: LinkObject
        'Object#' => '',
        'Add links' => '',
        'Delete links' => '',

        # Template: Login
        'Lost your password?' => 'Забули свій пароль',
        'Request New Password' => 'Вислати новий пароль',
        'Back to login' => 'Повернутися',

        # Template: Motd
        'Message of the Day' => '',

        # Template: NoPermission
        'Insufficient Rights' => '',
        'Back to the previous page' => '',

        # Template: Notify

        # Template: Pagination
        'Show first page' => '',
        'Show previous pages' => '',
        'Show page %s' => '',
        'Show next pages' => '',
        'Show last page' => '',

        # Template: PictureUpload
        'Need FormID!' => '',
        'No file found!' => '',
        'The file is not an image that can be shown inline!' => '',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'надруковане',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Тестова сторінка OTRS',
        'Welcome %s' => ' Здрастуйте, %s',
        'Counter' => 'Лічильник',

        # Template: Warning
        'Go back to the previous page' => '',

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
        'Agent Notifications' => 'Повідомлення агентів',
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
        'Agents <-> Groups' => 'Агенти <-> Групи',
        'Agents <-> Roles' => '',
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
        'Attachments <-> Responses' => 'Прикріплені файли <-> Відповіді',
        'Auto Responses <-> Queues' => '',
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
        'Change password' => 'Змінити пароль',
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
        'Company Tickets' => 'Заявки компанії',
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
        'Create and manage Service Level Agreements (SLAs).' => '',
        'Create and manage agents.' => 'Створення й керування агентами.',
        'Create and manage attachments.' => 'Створення й керування вкладеннями.',
        'Create and manage companies.' => 'Створення й керування компаніями.',
        'Create and manage customers.' => 'Створення й керування клієнтами.',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => '',
        'Create and manage groups.' => 'Створення й керування групами.',
        'Create and manage queues.' => 'Створення й керування чергами.',
        'Create and manage response templates.' => 'Створення й керування шаблонами відповідей.',
        'Create and manage responses that are automatically sent.' => 'Створення й керування автовідповідями.',
        'Create and manage roles.' => 'Створення й керування ролями.',
        'Create and manage salutations.' => 'Створення й керування вітаннями.',
        'Create and manage services.' => 'Створення й керування сервісами.',
        'Create and manage signatures.' => 'Створення й керування підписами.',
        'Create and manage ticket priorities.' => 'Створення й керування пріоритетами заявок.',
        'Create and manage ticket states.' => 'Створення й керування станами заявок.',
        'Create and manage ticket types.' => 'Створення й керування типами заявок.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => '',
        'Create new phone ticket (inbound)' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Клієнти',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Клієнти <-> Групи',
        'Customers <-> Services' => 'Клієнти <-> Сервіси',
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
        'Email Addresses' => 'Адреси email',
        'Enable keep-alive connection header for SOAP responses.' => '',
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
        'Escalation view' => 'Ескальовані заявки',
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
        'Filter incoming emails.' => '',
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
        'Frontend language' => 'Мова інтерфейсу',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => '',
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
            '',
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
        'Interface language' => 'Мова інтерфейсу',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Зв\'язати агентів із групами.',
        'Link agents to roles.' => 'Зв\'язати агентів з ролями.',
        'Link attachments to responses templates.' => '',
        'Link customers to groups.' => 'Зв\'язати клієнтів із групами.',
        'Link customers to services.' => 'Зв\'язати клієнтів із сервісами.',
        'Link queues to auto responses.' => '',
        'Link responses to queues.' => 'Зв\'язати відповіді із чергами.',
        'Link roles to groups.' => '',
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
        'Makes the picture transparent.' => 'Прозора картинка',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'Керування PGP ключами для шифрування поштових повідомлень.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Керування POP3 або IMAP обліковими записами для одержання поштових повідомлень.',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => 'Керування активними сеансами.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Керування повторюваними завданнями.',
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
        'Module to check customer permissions.' => 'Модуль для перевірки прав клієнта.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => 'Модуль для перевірки агента відповідального за заявку.',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => 'Модуль для перевірки власника заявки.',
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
            'Модуль для генерування статистики за часом відгуку та рішення заявки.',
        'Module to generate ticket statistics.' => 'Модуль для формування статистки за заявками.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => 'Мої заявки',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Нова e-mail заявка',
        'New phone ticket' => 'Нова телефонна заявка',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Повідомлення про подію',
        'Number of displayed tickets' => 'Кількість відображуваних заявок',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Перегляд ескальованих заявок.',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => 'Перегляд усіх відкритих заявок.',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Завантажити PGP ключ',
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
        'Queue view' => 'Перегляд черги',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'Оновляти кожні',
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
        'Responses <-> Queues' => 'Відповіді <-> Черга',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Ролі <-> Групи',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Тема інтерфейсу',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '',
        'Send notifications to users.' => 'Відправити повідомлення користувачам.',
        'Send ticket follow up notifications' => '',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => 'Задати адреса відправника для цієї системи.',
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
        'Skin' => '',
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
        'Statistics' => 'Статистика',
        'Status view' => 'Перегляд статусу',
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
        'Ticket overview' => 'Перегляд заявки',
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
        'Types' => 'Типи',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => 'Відновлення й розширення системи за допомогою програмних пакетів.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Перегляд результатів виміру продуктивності.',
        'View system log messages.' => 'Перегляд системних повідомлень.',
        'Wear this frontend skin' => '',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Вибір черг, які вас цікавлять. Ви також будете повідомлятися по електронній пошті, якщо ця функція включена.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Customer Data' => 'Облікові дані клієнта',
        'For more info see:' => 'Додаткова інформація знаходиться за адресою:',
        'Logout successful. Thank you for using OTRS!' => 'Вихід виконано. Дякуемо Вам, за використання OTRS!',
        'Package verification failed!' => 'Помилка перевірки цілісності пакета',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Безпечний режим повинен бути відключений при переустановці через веб-інтерфейс',

    };
    # $$STOP$$
    return;
}

1;
