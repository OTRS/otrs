# --
# Kernel/Language/uk.pm - provides Ukrainian language translation
# Copyright (C) 2009 - Belskii Artem <admin at alliancebank.org.ua>
# --
# $Id: uk.pm,v 1.2 2009-12-30 12:28:13 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::uk;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri Jul 17 17:59:25 2009

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T, %A %D %B, %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: Aaabase
        'Yes' => 'Так',
        'No' => 'Нi',
        'yes' => 'так',
        'no' => 'нi',
        'Off' => 'Виключене',
        'off' => 'виключене',
        'On' => 'Включене',
        'on' => 'включене',
        'top' => 'У початок',
        'end' => 'У кiнець',
        'Done' => 'Готове.',
        'Cancel' => 'Скасувати',
        'Reset' => 'Вiдхилити',
        'last' => 'останнiй',
        'before' => 'перед',
        'day' => 'день',
        'days' => 'днi',
        'day(s)' => 'днi',
        'hour' => 'година',
        'hours' => 'годин',
        'hour(s)' => 'год.',
        'minute' => 'хв.',
        'minutes' => 'хв.',
        'minute(s)' => 'хв.',
        'month' => 'мiс.',
        'months' => 'мiс.',
        'month(s)' => 'мiс.',
        'week' => 'тиждень',
        'week(s)' => 'тиждень',
        'year' => 'рiк.',
        'years' => 'рiк.',
        'year(s)' => 'рiк.',
        'second(s)' => 'сек.',
        'seconds' => 'сек.',
        'second' => 'сек.',
        'wrote' => 'написав(а)',
        'Message' => 'Повiдомлення',
        'Error' => 'Помилка',
        'Bug Report' => 'Звiт про помилки',
        'Attention' => 'Увага',
        'Warning' => 'Попередження',
        'Module' => 'Модуль',
        'Modulefile' => 'Файл модуля',
        'Subfunction' => 'Пiдфункцiя',
        'Line' => 'Рядок',
        'Setting' => 'Параметр',
        'Settings' => 'Параметри',
        'Example' => 'Приклад',
        'Examples' => 'Приклади',
        'valid' => 'дiйсний',
        'invalid' => 'недiйсний',
        '* invalid' => '* недiйсний',
        'invalid-temporarily' => 'тимчасово недiйсний',
        ' 2 minutes' => ' 2 хвилини',
        ' 5 minutes' => ' 5 хвилин',
        ' 7 minutes' => ' 7 хвилин',
        '10 minutes' => '10 хвилин',
        '15 minutes' => '15 хвилин',
        'Mr.' => '',
        'Mrs.' => '',
        'Next' => 'Уперед',
        'Back' => 'Назад',
        'Next...' => 'Уперед...',
        '...Back' => '...Назад',
        '-none-' => '-немає-',
        'none' => 'нi',
        'none!' => 'немає!',
        'none - answered' => 'немає . вiдповiдi',
        'please do not edit!' => 'Не редагувати!',
        'Addlink' => 'Додати посилання',
        'Link' => 'Зв\'язати',
        'Unlink' => 'Вiдв\'язати',
        'Linked' => 'Зв\'язаний',
        'Link (Normal)' => 'Зв\'язок (звичайна)',
        'Link (Parent)' => 'Зв\'язок (батько)',
        'Link (Child)' => 'Зв\'язок (нащадок)',
        'Normal' => 'Звичайний',
        'Parent' => 'Батько',
        'Child' => 'Нащадок',
        'Hit' => 'Влучення',
        'Hits' => 'Влучення',
        'Text' => 'Текст',
        'Standard' => '',
        'Lite' => 'Полегшений',
        'User' => 'Користувач',
        'Username' => 'Iм\'я користувача',
        'Language' => 'Мова',
        'Languages' => 'Мови',
        'Password' => 'Пароль',
        'Salutation' => 'Вiтання',
        'Signature' => 'Пiдпис',
        'Customer' => 'Клiєнт',
        'Customerid' => 'ID користувача',
        'Customerids' => 'ID користувачiв',
        'customer' => 'клiєнт',
        'agent' => 'агент',
        'system' => 'система',
        'Customer Info' => 'Iнформацiя про клiєнта',
        'Customer Company' => 'Компанiя клiєнта',
        'Company' => 'Компанiя',
        'go!' => 'ОК!',
        'go' => 'ОК',
        'All' => 'Усi',
        'all' => 'усi',
        'Sorry' => ' Вибачте',
        'update!' => 'обновити!',
        'update' => 'обновити',
        'Update' => 'Обновити',
        'Updated!' => 'Оновлене!',
        'submit!' => 'Ввести!',
        'submit' => 'увести',
        'Submit' => 'Ввести',
        'change!' => 'Змiнити!',
        'Change' => 'Змiнити',
        'change' => 'змiна',
        'click here' => 'натиснiть тут',
        'Comment' => 'Коментар',
        'Valid' => 'Дiйсний',
        'Invalid Option!' => 'Невiрний параметр!',
        'Invalid time!' => 'Невiрний час!',
        'Invalid date!' => 'Невiрна дата!',
        'Name' => 'Iм\'я',
        'Group' => 'Група',
        'Description' => 'Опис',
        'description' => 'опис',
        'Theme' => 'Тема',
        'Created' => 'Створений',
        'Created by' => 'Створене',
        'Changed' => 'Змiнений',
        'Changed by' => 'Змiнене',
        'Search' => 'Пошук',
        'and' => 'и',
        'between' => ' мiж',
        'Fulltext Search' => 'Повнотекстовий пошук',
        'Data' => 'Дата',
        'Options' => 'Налаштування',
        'Title' => 'Заголовок',
        'Item' => 'пункт',
        'Delete' => 'Вилучити',
        'Edit' => 'Редагувати',
        'View' => 'Перегляд',
        'Number' => 'Число',
        'System' => 'Система',
        'Contact' => 'Контакт',
        'Contacts' => 'Контакти',
        'Export' => 'Експорт',
        'Up' => 'Нагору',
        'Down' => 'Униз',
        'Add' => 'Додати',
        'Added!' => 'Додане!',
        'Category' => 'Категорiя',
        'Viewer' => 'Перегляд',
        'Expand' => 'Розгорнути',
        'New message' => 'Нове повiдомлення',
        'New message!' => 'Нове повiдомлення!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Вiдповiдайте на цi заявки для перехiд до звичайного перегляду черги !',
        'You got new message!' => ' У вас нове повiдомлення!',
        'You have %s new message(s)!' => 'Кiлькiсть нових повiдомлень: %s',
        'You have %s reminder ticket(s)!' => 'Кiлькiсть нагадувань: %s!',
        'The recommended charset for your language is %s!' => 'Рекомендоване кодування для вашої мови: %s',
        'Passwords doesn\'t match! Please try it again!' => 'Невiрний пароль!',
        'Password is already in use! Please use an other password!' => 'Пароль уже використовується! Спробуйте використовувати iнший пароль',
        'Password is already used! Please use an other password!' => 'Пароль уже використовувався! Спробуйте використовувати iнший пароль',
        'You need to activate %s first to use it!' => 'Вам необхiдно спочатку активувати %s щоб використовувати це',
        'No suggestions' => 'Немає пропозицiй',
        'Word' => 'Слово',
        'Ignore' => 'Iгнорувати',
        'replace with' => 'замiнити на',
        'There is no account with that login name.' => 'Немає користувача з таким iменем.',
        'Login failed! Your username or password was entered incorrectly.' => 'Помилка iдентифiкацiї! Зазначене неправильне iм\'я або пароль!',
        'Please contact your admin' => 'Зв\'яжiться з адмiнiстратором',
        'Logout successful. Thank you for using OTRS!' => 'Ви успiшно вийшли iз системи. Дякуємо за користування системою OTRS !',
        'Invalid Sessionid!' => 'Невiрний iдентифiкатор сесiї!',
        'Feature not active!' => 'Функцiя не активована!',
        'Notification (Event)' => 'Повiдомлення про подiю',
        'Login is needed!' => ' Необхiдно ввести логiн',
        'Password is needed!' => ' Необхiдно ввести пароль',
        'License' => 'Лiцензiя',
        'Take this Customer' => 'Вибрати цього клiєнта',
        'Take this User' => 'Вибрати цього користувача',
        'possible' => 'можливо',
        'reject' => 'вiдкинути',
        'reverse' => 'повернути',
        'Facility' => 'Пристосування',
        'Timeover' => 'Час очiкування минув',
        'Pending till' => ' Чекаючи ще',
        'Don\'t work with Userid 1 (System account)! Create new users!' => 'Не працюйте з Userid 1 (системний облiковий запис)! Створiть iншого користувача!',
        'Dispatching by email To: field.' => 'Перенапрямок по заголовковi To: електронного листа',
        'Dispatching by selected Queue.' => 'Перенапрямок по обранiй черзi',
        'No entry found!' => 'Запис не знайдений',
        'Session has timed out. Please log in again.' => 'Сеанс завершений. Спробуйте ввiйти заново.',
        'No Permission!' => 'Немає доступу!',
        'To: (%s) replaced with database email!' => 'To: (%s) замiнене на e-mail бази даних!',
        'Cc: (%s) added database email!' => 'Cc: (%s) доданий e-mail бази даних!',
        '(Click here to add)' => '(натиснiть сюди щоб додати)',
        'Preview' => 'Перегляд',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Пакет установлений некоректно! Ви повиннi переустановити пакет!',
        'Added User "%s"' => 'Доданий користувач "%s"',
        'Contract' => 'Контракт',
        'Online Customer: %s' => 'Клiєнт онлайн: %s',
        'Online Agent: %s' => 'Користувач онлайн: %s',
        'Calendar' => 'Календар',
        'File' => 'Файл',
        'Filename' => 'Iм\'я файлу',
        'Type' => 'Тип',
        'Size' => 'Розмiр',
        'Upload' => 'Завантажити',
        'Directory' => 'Каталог',
        'Signed' => 'Пiдписане',
        'Sign' => 'Пiдписати',
        'Crypted' => 'Зашифроване',
        'Crypt' => 'Шифрування',
        'Office' => 'Офiс',
        'Phone' => 'Телефон',
        'Fax' => 'Факс',
        'Mobile' => 'Мобiльний телефон',
        'Zip' => 'Iндекс',
        'City' => 'Мiсто',
        'Street' => 'Вулиця',
        'Country' => 'Країна',
        'Location' => ' Мiсце розташування',
        'installed' => 'Установлене',
        'uninstalled' => 'Деiнстальовано',
        'Security Note: You should activate %s because application is already running!' => 'Попередження про безпеку: ви повиннi активувати .%s., тому що додаток уже запущений!',
        'Unable to parse Online Repository index document!' => 'Неможливо обробити iндексний файл мережного репозиторiя!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Немає пакетiв для запитаного середовища в цьому мережному репозиторiї, але є пакети для iнших середовищ!',
        'No Packages or no new Packages in selected Online Repository!' => 'Немає пакетiв або нових пакетiв в обраному мережному репозиторiї!',
        'printed at' => 'надруковане в',
        'Dear Mr. % s,' => 'Шановний %s,',
        'Dear Mrs. % s,' => 'Шановна %s,',
        'Dear %s,' => 'Шановний %s, ',
        'Hello %s,' => 'Вітаємо, %s,',
        'This account exists.' => 'Цей облiковий запис уже iснує.',
        'New account created. Sent Login-Account to %s.' => 'Створений новий облiковий запис. Данi для входу в систему вiдправленi за адресою: %s.',
        'Please press Back and try again.' => 'Натиснiть .Назад. i спробуйте ще раз',
        'Sent password token to: %s' => 'Лист для одержання нового пароля вiдправлене за адресою: %s',
        'Sent new password to: %s' => 'Новий пароль вiдправлений за адресою: %s',
        'Upcoming Events' => 'Найближчi подiї',
        'Event' => 'Подiя',
        'Events' => 'Подiї',
        'Invalid Token!' => 'Невiрний токен !',
        'more' => 'далi',
        'For more info see:' => 'Додаткова iнформацiя знаходиться за адресою:',
        'Package verification failed!' => 'Помилка перевiрки цiлiсностi пакета',
        'Collapse' => 'Згорнути',
        'Shown' => 'Показано',
        'News' => 'Новини',
        'Product News' => 'Новини про продукт',
        'OTRS News' => 'Новини OTRS',
        '7 Day Stats' => 'Статистика за 7 днів',
        'Bold' => 'Напiвжирний',
        'Italic' => 'Курсив',
        'Underline' => 'Пiдкреслений',
        'Font Color' => 'Колiр тексту',
        'Background Color' => 'Колiр тла',
        'Remove Formatting' => 'Вилучити форматування',
        'Show/Hide Hidden Elements' => 'Показ схованих елементiв',
        'Align Left' => ' По лiвому краю',
        'Align Center' => ' По центру',
        'Align Right' => ' По правому краю',
        'Justify' => ' По ширинi',
        'Header' => 'Заголовок',
        'Indent' => 'Збiльшити вiдступ',
        'Outdent' => 'Зменшити вiдступ',
        'Create an Unordered List' => 'Створити ненумерований список',
        'Create an Ordered List' => 'Створити нумерований список',
        'HTML Link' => 'Посилання HTML',
        'Insert Image' => 'Вставити зображення',
        'CTRL' => 'Ctrl',
        'SHIFT' => 'Shift',
        'Undo' => 'Скасувати',
        'Redo' => 'Повторити',

        # Template: Aaamonth
        'Jan' => 'Сiч.',
        'Feb' => 'Лют.',
        'Mar' => 'Бер.',
        'Apr' => 'Квiт.',
        'May' => 'Трав.',
        'Jun' => 'Черв.',
        'Jul' => 'Лип.',
        'Aug' => 'Серп.',
        'Sep' => 'Вер.',
        'Oct' => 'Жовт.',
        'Nov' => 'Лист.',
        'Dec' => 'Груд.',
        'January' => 'Сiчень',
        'February' => 'Лютий',
        'March' => 'Березень',
        'April' => 'Квiтень',
        'May_long' => 'Травень',
        'June' => 'Червень',
        'July' => 'Липень',
        'August' => 'Август',
        'September' => 'Вересень',
        'October' => 'Жовтень',
        'November' => 'Листопад',
        'December' => 'Грудень',

        # Template: Aaanavbar
        'Admin-Area' => 'Адмiнiстрування системи',
        'Agent-Area' => 'Користувач',
        'Ticket-Area' => 'Заявки',
        'Logout' => 'Вихiд',
        'Agent Preferences' => 'Налаштування користувача',
        'Preferences' => 'Уподобання',
        'Agent Mailbox' => ' Поштова скринька користувача',
        'Stats' => 'Статистика',
        'Stats-Area' => 'Статистика',
        'Admin' => 'Адмiнiстрування',
        'Customer Users' => 'Клiєнти',
        'Customer Users <-> Groups' => 'Групи клiєнтiв',
        'Users <-> Groups' => 'Налаштування груп',
        'Roles' => 'Ролi',
        'Roles <-> Users' => 'Ролi <-> Користувачi',
        'Roles <-> Groups' => 'Ролi <-> Групи',
        'Salutations' => 'Вiтання',
        'Signatures' => 'Пiдписи',
        'Email Addresses' => 'Адреси email',
        'Notifications' => 'Повiдомлення',
        'Category Tree' => 'Iєрархiя категорiй',
        'Admin Notification' => 'Повiдомлення адмiнiстратором',

        # Template: Aaapreferences
        'Preferences updated successfully!' => 'Налаштування успiшно оновленi',
        'Mail Management' => 'Керування поштою',
        'Frontend' => 'Режим користувача',
        'Other Options' => 'Iншi настроювання',
        'Change Password' => 'Перемiнити пароль',
        'New password' => 'Новий пароль',
        'New password again' => 'Повторiть новий пароль',
        'Select your Queueview refresh time.' => 'Час оновлення монiтора черг',
        'Select your frontend language.' => 'Мова iнтерфейсу',
        'Select your frontend Charset.' => 'Кодування',
        'Select your frontend Theme.' => 'Тема iнтерфейсу',
        'Select your frontend Queueview.' => 'Мова монiтора черг.',
        'Spelling Dictionary' => 'Словник',
        'Select your default spelling dictionary.' => 'Основний словник',
        'Max. shown Tickets a page in Overview.' => 'Максимальна кiлькiсть заявок при показi черги',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Неможливо перемiнити пароль, паролi не збiгаються!',
        'Can\'t update password, invalid characters!' => 'Неможливо перемiнити пароль, невiрне кодування!',
        'Can\'t update password, must be at least %s characters!' => 'Неможливо перемiнити пароль, пароль повинен бути не менш %s символiв!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Неможливо перемiнити пароль, необхiдно 2 символу в нижньому й 2 . у верхньому регiстрах!',
        'Can\'t update password, needs at least 1 digit!' => 'Неможливо перемiнити пароль, повинна бути присутнiм як мiнiмум 1 цифра!',
        'Can\'t update password, needs at least 2 characters!' => 'Неможливо перемiнити пароль, необхiдно мiнiмум 2 символу!',

        # Template: Aaastats
        'Stat' => 'Статистика',
        'Please fill out the required fields!' => 'Заповните обов\'язковi поля!',
        'Please select a file!' => 'Виберiть файл!',
        'Please select an object!' => 'Виберiть об\'єкт!',
        'Please select a graph size!' => 'Виберiть розмiр графiка!',
        'Please select one element for the X-axis!' => 'Виберiть один елемент для осi X',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Виберiть тiльки один елемент або знiмiть прапор \'Fixed\' в обраному полi!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Якщо ви використовуєте прапорцi видiлення, то повиннi вибрати кiлька пунктiв з обраного поля!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Вставте значення в обране поле або знiмiть прапор .Fixed.!',
        'The selected end time is before the start time!' => 'Зазначений час закiнчення ранiше початку!',
        'You have to select one or more attributes from the select field!' => 'Ви повиннi вибрати один або кiлька пунктiв з обраного поля',
        'The selected Date isn\'t valid!' => 'Обрана дата невiрна!',
        'Please select only one or two elements via the checkbox!' => 'Виберiть тiльки один або два пункти, використовуючи прапорцi',
        'If you use a time scale element you can only select one element!' => 'Якщо ви використовуєте елемент перiоду, ви можете вибрати тiльки один пункт!',
        'You have an error in your time selection!' => 'Помилка вказiвки часу',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Перiод звiтностi занадто малий, укажiть бiльший iнтервал',
        'The selected start time is before the allowed start time!' => 'Обраний час початку виходить за межi дозволеного!',
        'The selected end time is after the allowed end time!' => 'Обраний час кiнця виходить за межi дозволеного!',
        'The selected time period is larger than the allowed time period!' => 'Обраний перiод часу бiльше, нiж дозволений перiод!',
        'Common Specification' => 'Загальна специфiкацiя',
        'Xaxis' => 'Вiсь X',
        'Value Series' => 'Ряд значень',
        'Restrictions' => 'Обмеження',
        'graph-lines' => 'Графiк',
        'graph-bars' => 'Гiстограма',
        'graph-hbars' => 'Лiнiйчата',
        'graph-points' => 'Крапкова',
        'graph-lines-points' => 'Графiк iз крапковою дiаграмою',
        'graph-area' => 'З областями',
        'graph-pie' => 'Кругова',
        'extended' => 'Iнша',
        'Agent/Owner' => 'Агент (власник)',
        'Created by Agent/Owner' => 'Створене агентом (власником)',
        'Created Priority' => 'Прiоритет',
        'Created State' => 'Стан',
        'Create Time' => 'Час створення',
        'Customeruserlogin' => 'Логiн клiєнта',
        'Close Time' => 'Час закриття',
        'Ticketaccumulation' => 'Угруповання заявок',
        'Attributes to be printed' => 'Атрибути для печатки',
        'Sort sequence' => 'Порядок сортування',
        'Order by' => 'Сортування',
        'Limit' => 'Лiмiт',
        'Ticketlist' => 'Список заявок',
        'ascending' => ' По зростанню',
        'descending' => ' По убуванню',
        'First Lock' => 'Перше блокування',
        'Evaluation by' => 'Заблоковане',
        'Total Time' => 'Усього часу',
        'Ticket Average' => 'Середнiй час розгляду заявки',
        'Ticket Min Time' => 'Мiн. час розгляду заявки',
        'Ticket Max Time' => 'Макс. час розгляду заявки',
        'Number of Tickets' => 'Кiлькiсть заявок',
        'Article Average' => 'Середнiй час мiж повiдомленнями',
        'Article Min Time' => 'Мiн. час мiж повiдомленнями',
        'Article Max Time' => 'Макс. час мiж повiдомленнями',
        'Number of Articles' => 'Кiлькiсть повiдомлень',
        'Accounted time by Agent' => 'Витрати робочого часу по агентах',
        'Ticket/Article Accounted Time' => 'Витрати робочого часу на заявку або повiдомлення',
        'Ticketaccountedtime' => 'Витрати робочого часу',
        'Ticket Create Time' => 'Час створення заявки',
        'Ticket Close Time' => 'Час закриття заявки',

        # Template: Aaaticket
        'Lock' => 'Блокувати',
        'Unlock' => 'Розблокувати',
        'History' => 'Iсторiя',
        'Zoom' => 'Докладно',
        'Age' => 'Вiк',
        'Bounce' => 'Повернути',
        'Forward' => 'Переслати',
        'From' => 'Вiдправник',
        'To' => 'Одержувач',
        'Cc' => 'Копiя',
        'Bcc' => 'Схована копiя',
        'Subject' => 'Тема',
        'Move' => 'Перемiстити',
        'Queue' => 'Черга',
        'Priority' => 'Прiоритет',
        'Priority Update' => 'Змiнити прiоритету',
        'State' => 'Статус',
        'Compose' => 'Створити',
        'Pending' => 'Вiдкласти',
        'Owner' => 'Власник',
        'Owner Update' => 'Новий власник',
        'Responsible' => 'Вiдповiдальний',
        'Responsible Update' => 'Новий вiдповiдальний',
        'Sender' => 'Вiдправник',
        'Article' => 'Повiдомлення',
        'Ticket' => 'Заявка',
        'Createtime' => 'Час створення',
        'plain' => 'Звичайний',
        'Email' => 'Email',
        'email' => 'Email',
        'Close' => 'Закрити',
        'Action' => 'Дiя',
        'Attachment' => 'Прикрiплений файл',
        'Attachments' => 'Прикрiпленi файли',
        'This message was written in a character set other than your own.' => 'Це повiдомлення написане в кодуваннi. вiдмiнної вiд вашої.',
        'If it is not displayed correctly,' => 'Якщо текст вiдображається некоректно,',
        'This is a' => 'Це',
        'to open it in a new window.' => 'вiдкрити в новiм вiкнi',
        'This is a HTML email. Click here to show it.' => 'Цей електронний лист у форматi HTML. Натиснiть тут для перегляду',
        'Free Fields' => 'Вiльне поле',
        'Merge' => 'Об\'єднати',
        'merged' => 'об\'єднаний',
        'closed successful' => 'Закритий успiшно',
        'closed unsuccessful' => 'Закритий неуспiшно',
        'new' => 'новий',
        'open' => 'вiдкритий',
        'Open' => 'Вiдкрити',
        'closed' => 'закритий',
        'Closed' => 'Закритий',
        'removed' => 'вилучений',
        'pending reminder' => 'вiдкладене нагадування',
        'pending auto' => 'черга на автозакриття',
        'pending auto close+' => 'черга на автозакриття+',
        'pending auto close-' => 'черга на автозакриття-',
        'email-external' => 'зовнiшнiй email',
        'email-internal' => 'внутрiшнiй email',
        'note-external' => 'зовнiшня замiтка',
        'note-internal' => 'внутрiшня замiтка',
        'note-report' => ' ПриміткакЗвiт',
        'phone' => 'дзвiнок',
        'sms' => 'СМС',
        'webrequest' => 'веб-заявка',
        'lock' => 'блокований',
        'unlock' => 'розблокований',
        'very low' => 'найнижчий',
        'low' => 'низький',
        'normal' => 'звичайний',
        'high' => 'високий',
        'very high' => 'невiдкладний',
        '1 very low' => '1 найнижчий',
        '2 low' => '2 низький',
        '3 normal' => '3 звичайний',
        '4 high' => '4 високий',
        '5 very high' => '5 невiдкладний',
        'Ticket "%s" created!' => 'Створена заявка .%s..',
        'Ticket Number' => 'Номер заявки',
        'Ticket Object' => 'Об\'єкт заявки',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Заявки з номером .%s. не iснує, неможливо зв\'язати з нею!',
        'Don\'t show closed Tickets' => 'Не показувати закритi заявки',
        'Show closed Tickets' => 'Показувати закритi заявки',
        'New Article' => 'Нове повiдомлення',
        'Email-Ticket' => 'Лист',
        'Create new Email Ticket' => 'Створити нову заявку',
        'Phone-Ticket' => 'Телефонний дзвiнок',
        'Search Tickets' => 'Пошук заявок',
        'Edit Customer Users' => 'Редагувати клiєнтiв',
        'Edit Customer Company' => 'Редагувати компанiї клiєнтiв',
        'Bulk Action' => 'Масова дiя',
        'Bulk Actions on Tickets' => 'Масова дiя над заявками',
        'Send Email and create a new Ticket' => 'Вiдправити лист i створити нову заявку',
        'Create new Email Ticket and send this out (Outbound)' => 'Створити нову заявку email i вiдправити її',
        'Create new Phone Ticket (Inbound)' => 'Створити нову телефонну заявку',
        'Overview of all open Tickets' => 'Огляд усiх заявок',
        'Locked Tickets' => 'Заблокованi заявки',
        'Watched Tickets' => ' заявки, Що Вiдслiдковуються, ',
        'Watched' => ', Що Вiдслiдковуються',
        'Subscribe' => 'Пiдписатися',
        'Unsubscribe' => 'Вiдписатися',
        'Lock it to work on it!' => 'Заблокувати, щоб розглянути заявки!',
        'Unlock to give it back to the queue!' => 'Розблокувати й повернути в чергу!',
        'Shows the ticket history!' => 'Показати iсторiю заявки!',
        'Print this ticket!' => 'Друк заявки!',
        'Change the ticket priority!' => 'Змiнити прiоритет!',
        'Change the ticket free fields!' => 'Змiнити вiльнi поля заявки!',
        'Link this ticket to an other objects!' => 'Зв\'язати заявку з iншими об\'єктами!',
        'Change the ticket owner!' => 'Змiнити власника!',
        'Change the ticket customer!' => 'Змiнити клiєнта!',
        'Add a note to this ticket!' => 'Додати замiтку до заявки!',
        'Merge this ticket!' => 'Об\'єднати заявку',
        'Set this ticket to pending!' => 'Поставити цю заявку в режим очiкування!',
        'Close this ticket!' => 'Закрити заявку!',
        'Look into a ticket!' => 'Переглянути заявку!',
        'Delete this ticket!' => 'Вилучити заявку!',
        'Mark as Spam!' => 'Позначити як спам!',
        'My Queues' => 'Мої черги',
        'Shown Tickets' => 'Показуванi заявки',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Ваш email з номером заявки .<OTRS_TICKET>. об\'єднаний з "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Заявка %s: час першої вiдповiдi минув (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Заявка %s: час першої вiдповiдi мине через %s!',
        'Ticket %s: update time is over (%s)!' => 'Заявка %s: час вiдновлення заявки минув (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Заявка %s: час вiдновлення заявки мине через %s!',
        'Ticket %s: solution time is over (%s)!' => 'Заявка %s: час рiшення заявки минув (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Заявка %s: час рiшення заявки мине через %s!',
        'There are more escalated tickets!' => 'Єкскларовiних заявок бiльше немає!',
        'New ticket notification' => 'Повiдомлення про нову заявку',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Повiдомлення про новi заявки',
        'Follow up notification' => 'Повiдомлення про вiдновлення',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Надiслати менi повiдомлення, якщо клiєнт надiслав вiдповiдь i я власник заявки.',
        'Ticket lock timeout notification' => 'Повiдомлення про закiнчення строку блокування заявки системою',
        'Send me a notification if a ticket is unlocked by the system.' => 'Надiслати менi повiдомлення, якщо заявка звiльнена системою.',
        'Move notification' => 'Повiдомлення про перемiщення',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Надiслати менi повiдомлення, якщо заявка перемiщена в одну з моїх черг.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Вибiр черг, якi вас цiкавлять. Вам будуть надходити повiдомлення електронною поштою, про новi заявки, що надiйшли до цих черг.',
        'Custom Queue' => 'Резервна черга',
        'Queueview refresh time' => 'Час вiдновлення монiтора черг',
        'Screen after new ticket' => 'Роздiл пiсля створення нової заявки',
        'Select your screen after creating a new ticket.' => 'Виберiть роздiл пiсля створення нової заявки',
        'Closed Tickets' => 'Закритi заявки',
        'Show closed tickets.' => 'Показувати закритi заявки',
        'Max. shown Tickets a page in Queueview.' => 'Максимальна кiлькiсть заявок при переглядi черги',
        'Watch notification' => 'Повiдомлення при вiдстеженнi',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Надiслати менi й власниковi повiдомлення, якщо оновлена заявка, що вiдслiдковується.',
        'Out Of Office' => 'Повiдомлення про вiдсутнiсть',
        'Select your out of office time.' => 'Укажiть перiод вiдсутностi',
        'Companytickets' => 'Заявки компанiї',
        'CompanyTickets' => 'Заявки компанiї',
        'Mytickets' => 'Мої заявки',
        'MyTickets' => 'Мої заявки',
        'New Ticket' => 'Нова заявка',
        'Create new Ticket' => 'Створити нову заявку',
        'Customer called' => 'Дзвiнок клiєнта',
        'phone call' => 'телефонний дзвiнок',
        'Reminder Reached' => 'Нагадування',
        'Reminder Tickets' => 'Заявки з нагадуванням',
        'Escalated Tickets' => 'Ескальованi заявки',
        'New Tickets' => 'Новi заявки',
        'Open Tickets / Need to be answered' => 'Вiдкритi заявки ( потрiбно вiдповiсти)',
        'Tickets which need to be answered!' => 'Заявки, що вимагають вiдповiдi',
        'All new tickets!' => 'Усi новi заявки',
        'All tickets which are escalated!' => 'Усi єкскларованi заявки',
        'All tickets where the reminder date has reached!' => 'Усi заявки з датою, що настала, нагадування',
        'Responses' => 'Вiдповiдi',
        'Responses <-> Queue' => 'Вiдповiдi <-> Черга',
        'Auto Responses' => 'Автовiдповiдi',
        'Auto Responses <-> Queue' => 'Автовiдповiдi <-> Черга',
        'Attachments <-> Responses' => 'Прикрiпленi файли <-> Вiдповiдi',
        'History::Move' => 'Заявка перемiщена в чергу .%s. (%s) iз черги .%s. (%s).',
        'History::Typeupdate' => 'Тип змiнений на %s (ID=%s).',
        'History::Serviceupdate' => 'Сервiс змiнений на %s (ID=%s).',
        'History::Slaupdate' => 'SLA змiнений на %s (ID=%s).',
        'History::Newticket' => 'Нова заявка [%s] (Q=%s;P=%s;S=%s).',
        'History::Followup' => 'Вiдповiдь на [%s]. % s',
        'History::Sendautoreject' => 'Автозамовлення вiдправлене .%s..',
        'History::Sendautoreply' => 'Автовiдповiдь вiдправлена .%s..',
        'History::Sendautofollowup' => 'Автовiдповiдь вiдправлена .%s..',
        'History::Forward' => 'Переспрямоване .%s..',
        'History::Bounce' => 'Повернуте .%s..',
        'History::Sendanswer' => 'Вiдповiдь вставлена .%s..',
        'History::Sendagentnotification' => '%s: повiдомлення вiдправлене на %s.',
        'History::Sendcustomernotification' => 'Повiдомлення вiдправлене на %s.',
        'History::Emailagent' => 'Клiєнтовi %s вiдправлений лист.',
        'History::Emailcustomer' => 'Отриманий лист вiд %s.',
        'History::Phonecallagent' => 'Спiвробiтник подзвонив клiєнтовi',
        'History::Phonecallcustomer' => 'Клiєнт подзвонив нам.',
        'History::Addnote' => 'Додана замiтка (%s)',
        'History::Lock' => 'Заблокована заявка.',
        'History::Unlock' => 'Розблокована заявка.',
        'History::Timeaccounting' => 'Додане одиниць часу: %s. Усього одиниць часу: %s.',
        'History::Remove' => '%s',
        'History::Customerupdate' => 'Змiнене: %s',
        'History::Priorityupdate' => 'Змiнений прiоритет з .%s. (%s) на .%s. (%s).',
        'History::Ownerupdate' => 'Новий власник .%s. (ID=%s).',
        'History::Loopprotection' => 'Захист вiд зациклення! Авто-вiдповiдь на .%s. не вiдправлений.',
        'History::Misc' => '%s',
        'History::Setpendingtime' => 'Оновлене: %s',
        'History::Stateupdate' => 'Колишнiй стан: %s, новий стан: %s',
        'History::Ticketfreetextupdate' => 'Оновлене: %s=%s;%s=%s;',
        'History::Webrequestcustomer' => 'Веб-запит користувача.',
        'History::Ticketlinkadd' => ' До заявки .%s. доданий зв\'язок.',
        'History::Ticketlinkdelete' => 'Зв\'язок iз заявкою .%s. вилучена.',
        'History::Subscribe' => 'Додана пiдписка для користувача .%s..',
        'History::Unsubscribe' => 'Вилучена пiдписка для користувача .%s..',

        # Template: Aaaweekday
        'Sun' => 'Недiля',
        'Mon' => 'Понедiлок',
        'Tue' => 'Вiвторок',
        'Wed' => 'Середа  ',
        'Thu' => 'Четвер',
        'Fri' => 'П\'ятниця',
        'Sat' => 'Субота',
        'Sat' => 'Субота',

        # Template: Adminattachmentform
        'Attachment Management' => 'Керування прикрiпленими файлами',

        # Template: Adminautoresponseform
        'Auto Response Management' => 'Керування автовiдповiдями',
        'Response' => 'Вiдповiдь',
        'Auto Response From' => 'Автоматична вiдповiдь вiд',
        'Note' => 'Примітка',
        'Useable options' => 'Використовуванi опцiї',
        'To get the first 20 character of the subject.' => 'Щоб бачити першi 20 символiв теми',
        'To get the first 5 lines of the email.' => 'Щоб бачити першi 5 рядкiв email',
        'To get the realname of the sender (if given).' => 'Щоб бачити реальне iм\'я вiдправника (якщо зазначене)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Данi повiдомлення (наприклад, <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> i <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_Userfirstname>).' => 'Поточнi данi про клiєнта (наприклад, <OTRS_CUSTOMER_DATA_Userfirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_Userfirstname>).' => 'Данi власника заявки (наприклад, <OTRS_OWNER_Userfirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_Userfirstname>).' => 'Данi вiдповiдального за заявку (наприклад, <OTRS_RESPONSIBLE_Userfirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_Userfirstname>).' => 'Данi поточного користувача, який запросив цю дiю (наприклад, <OTRS_CURRENT_Userfirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_Ticketnumber>, <OTRS_TICKET_Ticketid>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Данi заявки (наприклад, <OTRS_TICKET_Ticketnumber>, <OTRS_TICKET_Ticketid>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_Httptype>).' => 'Параметри конфiгурацiї (наприклад, <OTRS_CONFIG_Httptype>).',

        # Template: Admincustomercompanyform
        'Customer Company Management' => 'Керування компанiями клiєнтiв',
        'Search for' => 'Пошук',
        'Add Customer Company' => 'Додати компанiю клiєнта',
        'Add a new Customer Company.' => 'Додати компанiю клiєнта',
        'List' => 'Список',
        'This values are required.' => 'Дане поле обов\'язкове',
        'This values are read only.' => 'Дане поле тiльки для читання',

        # Template: Admincustomeruserform
        'The message being composed has been closed.  Exiting.' => 'Створюване повiдомлення було закрито. вихiд.',
        'This window must be called from compose window' => 'Це вiкно повинне викликатися з вiкна введення',
        'Customer User Management' => 'Керування користувачами ( для клiєнтiв)',
        'Add Customer User' => 'Додати клiєнта',
        'Source' => 'Джерело',
        'Create' => 'Створити',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Користувач клiєнта знадобиться, щоб одержувати доступ до iсторiї клiєнта й входити через користувацький iнтерфейс',

        # Template: Admincustomerusergroupchangeform
        'Customer Users <-> Groups Management' => 'Керування групами клiєнтiв',
        'Change %s settings' => 'Змiнити параметри: %s',
        'Select the user:group permissions.' => 'Доступ у виглядi користувач:група.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Якщо нiчого не обране, то заявки будуть недоступнi для користувача',
        'Permission' => 'Права доступу',
        'ro' => 'Тiльки читання',
        'Read only access to the ticket in this group/queue.' => 'Права тiльки на читання заявки в данiй групi/черги',
        'rw' => 'Читання/запис',
        'Full read and write access to the tickets in this group/queue.' => 'Повнi права на заявки в данiй групi/черги',

        # Template: Admincustomerusergroupform

        # Template: Admincustomeruserservice
        'Customer Users <-> Services Management' => 'Клiєнти <-> Сервiси',
        'Customeruser' => 'Клiєнт',
        'Service' => 'Сервiс',
        'Edit default services.' => 'Сервiси за замовчуванням',
        'Search Result' => 'Результат пошуку',
        'Allocate services to Customeruser' => 'Прив\'язати сервiси до клiєнта',
        'Active' => 'Активний',
        'Allocate Customeruser to service' => 'Прив\'язати клiєнта до сервiсiв',

        # Template: Adminemail
        'Message sent to' => 'Повiдомлення вiдправлене для',
        'A message should have a subject!' => 'Повiдомлення повинне мати поле теми!',
        'Recipients' => 'Одержувачi',
        'Body' => 'Тiло листа',
        'Send' => 'Вiдправити',

        # Template: Admingenericagent
        'Genericagent' => 'Планувальник завдань',
        'Job-List' => 'Список завдань',
        'Last run' => 'Останнiй запуск',
        'Run Now!' => 'Виконати зараз!',
        'x' => 'x',
        'Save Job as?' => 'Зберегти завдання як?',
        'Is Job Valid?' => 'Дане завдання дiйсне?',
        'Is Job Valid' => 'Дане завдання дiйсне',
        'Schedule' => 'Розклад',
        'Currently this generic agent job will not run automatically.' => 'Це завдання агента не запускається автоматично',
        'To enable automatic execution select at least one value from minutes, hours and days!' => ' Для автоматичного запуску вкажiть як мiнiмум одне зi значень у хвилинах, годиннику або днях',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Повнотекстовий пошук у заявцi (наприклад, .Mar*in. або .Baue*.)',
        '(e. g. 10*5155 or 105658*)' => '(наприклад, 10*5155 або 105658*)',
        '(e. g. 234321)' => '(наприклад, 234321)',
        'Customer User Login' => 'Логiн клiєнта',
        '(e. g. U5150)' => '(наприклад, U5150)',
        'SLA' => 'Рiвень обслуговування',
        'Agent' => 'Агент',
        'Ticket Lock' => 'Блокування заявки',
        'Ticketfreefields' => 'Вiльнi поля заявки',
        'Create Times' => 'Час створення',
        'No create time settings.' => ' Без облiку часу створення',
        'Ticket created' => 'Заявка створена',
        'Ticket created between' => 'Заявка створена мiж ',
        'Close Times' => 'Час закриття',
        'No close time settings.' => ' Без облiку часу закриття',
        'Ticket closed' => 'Заявка закрита',
        'Ticket closed between' => 'Заявка закрита мiж',
        'Pending Times' => 'Час, коли запит був вiдкладений',
        'No pending time settings.' => ' Без облiку часу, коли запит був вiдкладений',
        'Ticket pending time reached' => 'Заявка була вiдкладена',
        'Ticket pending time reached between' => 'Заявка була вiдкладена мiж',
        'Escalation Times' => 'Час ескалацiї',
        'No escalation time settings.' => ' Без облiку часу ескалацiї',
        'Ticket escalation time reached' => 'Заявка була єкскларована',
        'Ticket escalation time reached between' => 'Заявка була єкскларована мiж',
        'Escalation - First Response Time' => 'Ескалацiя . час першої вiдповiдi',
        'Ticket first response time reached' => 'Перша вiдповiдь',
        'Ticket first response time reached between' => 'Перша вiдповiдь мiж',
        'Escalation - Update Time' => 'Ескалацiя . час вiдновлення',
        'Ticket update time reached' => 'Заявка була оновлена',
        'Ticket update time reached between' => 'Заявка була оновлена мiж',
        'Escalation - Solution Time' => 'Ескалацiя . час рiшення',
        'Ticket solution time reached' => 'Заявка була вирiшена',
        'Ticket solution time reached between' => 'Заявка була вирiшена мiж',
        'New Service' => 'Нова служба',
        'New SLA' => 'Новий SLA',
        'New Priority' => 'Новий прiоритет',
        'New Queue' => 'Нова черга',
        'New State' => 'Новий статус',
        'New Agent' => 'Новий агент',
        'New Owner' => 'Новий власник',
        'New Customer' => 'Новий клiєнт',
        'New Ticket Lock' => 'Новий статус заявки',
        'New Type' => 'Новий тип',
        'New Title' => 'Нова назва',
        'New Ticketfreefields' => 'Новi вiльнi поля заявки',
        'Add Note' => 'Додати замiтку',
        'Time units' => 'Одиницi часу',
        'CMD' => 'Команда',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Ця команда буде виконана. ARG[0] . номер заявки. ARG[1] . id заявки.',
        'Delete tickets' => 'Вилучити заявки',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Увага! Зазначенi заявки будуть вилученi з бази!',
        'Send Notification' => 'Вiдправляти повiдомлення',
        'Param 1' => 'Параметр 1',
        'Param 2' => 'Параметр 2',
        'Param 3' => 'Параметр 3',
        'Param 4' => 'Параметр 4',
        'Param 5' => 'Параметр 5',
        'Param 6' => 'Параметр 6',
        'Send agent/customer notifications on changes' => 'Вiдправляти повiдомлення агентовi при змiнах',
        'Save' => 'Зберегти',
        '%s Tickets affected! Do you really want to use this job?' => '%s заявок буде змiнено! Виконати це завдання?',

        # Template: Admingroupform
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the Sysconfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => 'УВАГА! Якщо ви змiните iм\'я групи .admin. до того, як помiняєте назву цiєї групи конфiгурацiї системи, у вас не буде прав доступу на панель адмiнiстрування. Якщо це вiдбулося, повернiть колишню назву групи (admin) вручну командою SQL.',
        'Group Management' => 'Керування групами',
        'Add Group' => 'Додати групу',
        'Add a new Group.' => 'Додати нову групу',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Група admin може здiйснювати адмiнiстрування, а група stats . переглядати статистику',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Створити новi групи для призначення прав доступу групам агентiв (вiддiл закупiвель, вiддiл продажiв, вiддiл техпiдтримки й т.п.)',
        'It\'s useful for ASP solutions.' => 'Це пiдходить для провайдерiв.',

        # Template: Adminlog
        'System Log' => 'Системний журнал',
        'Time' => 'Час',

        # Template: Adminmailaccount
        'Mail Account Management' => 'Керування поштовими облiковими записами',
        'Host' => 'Сервер',
        'Trusted' => 'Безпечна',
        'Dispatching' => 'Перенапрямок',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Усi вхiднi листи iз зазначеного облiкового запису будуть перенесенi в обрану чергу!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! Postmaster filter will be used anyway.' => 'Якщо ваш облiковий запис безпечний, у листах буде використане поле заголовка X-OTRS ( для прiоритету й iнших даних)! Фiльтр Postmaster буде використаний у кожному разi.',

        # Template: Adminnavigationbar
        'Users' => 'Користувачi',
        'Groups' => 'Групи',
        'Misc' => 'Додатково',

        # Template: Adminnotificationeventform
        'Notification Management' => 'Керування повiдомленнями',
        'Add Notification' => 'Додати повiдомлення',
        'Add a new Notification.' => 'Додати повiдомлення',
        'Name is required!' => 'Назва обов\'язкова!',
        'Event is required!' => 'Подiя обов\'язкова!',
        'A message should have a body!' => 'Тiло листа не може бути порожнiм!',
        'Recipient' => 'Одержувач',
        'Group based' => 'Група',
        'Agent based' => 'Агент',
        'Email based' => 'Адреса електронної пошти',
        'Article Type' => 'Тип повiдомлення',
        'Only for Articlecreate Event.' => 'Тiльки при створеннi повiдомлень',
        'Subject match' => 'Вiдповiднiсть темi',
        'Body match' => 'Вiдповiднiсть тiлу листа',
        'Notifications are sent to an agent or a customer.' => 'Повiдомлення вiдправленi агентовi або клiєнтовi',
        'To get the first 20 character of the subject (of the latest agent article).' => 'Першi 20 символiв теми з останнього повiдомлення агента',
        'To get the first 5 lines of the body (of the latest agent article).' => 'Першi 5 рядкiв останнього повiдомлення агента',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Поля повiдомлення (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>)',
        'To get the first 20 character of the subject (of the latest customer article).' => 'Першi 20 символiв теми з останнього повiдомлення клiєнта',
        'To get the first 5 lines of the body (of the latest customer article).' => 'Першi 5 рядкiв останнього повiдомлення клiєнта',

        # Template: Adminnotificationform
        'Notification' => 'Повiдомлення',

        # Template: Adminpackagemanager
        'Package Manager' => 'Керування пакетами',
        'Uninstall' => 'Вилучити',
        'Version' => 'Версiя',
        'Do you really want to uninstall this package?' => 'Вилучити цей пакет?',
        'Reinstall' => 'Переустановити',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Переустановити цей пакет (усi змiни, зробленi вручну, будуть загубленi)?',
        'Continue' => 'Продовжити',
        'Install' => 'Установити',
        'Package' => 'Пакет',
        'Online Repository' => 'Онлайновий репозиторiй',
        'Vendor' => 'Виготовлювач',
        'Module documentation' => 'Документацiя модуля',
        'Upgrade' => 'Обновити',
        'Local Repository' => 'Локальний репозиторiй',
        'Status' => 'Статус',
        'Overview' => 'Огляд',
        'Download' => 'Завантажити',
        'Rebuild' => 'Перешикувати',
        'Changelog' => 'Журнал змiн',
        'Date' => 'Дата',
        'Filelist' => 'Список файлiв',
        'Download file from package!' => 'Завантажити файл iз пакета!',
        'Required' => ' Потрiбно',
        'Primarykey' => 'Первинний ключ',
        'Autoincrement' => 'Автоiнкремент',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: Adminperformancelog
        'Performance Log' => 'Журнал продуктивностi',
        'This feature is enabled!' => 'Дана функцiя активована!',
        'Just use this feature if you want to log each request.' => 'Використовуйте цю функцiю, якщо прагнете затягати кожний запит у журнал',
        'Activating this feature might affect your system performance!' => 'Включення цiєї функцiї може позначитися на продуктивностi вашої системи',
        'Disable it here!' => 'Вiдключити функцiю!',
        'This feature is disabled!' => 'Дана функцiя вiдключена!',
        'Enable it here!' => 'Включити функцiю!',
        'Logfile too large!' => 'Файл журналу занадто великий!',
        'Logfile too large, you need to reset it!' => 'Файл журналу занадто великий, вам потрiбно очистити його!',
        'Range' => 'Дiапазон',
        'Interface' => 'Iнтерфейс',
        'Requests' => 'Запитiв',
        'Min Response' => 'Мiнiмальний час вiдповiдi',
        'Max Response' => 'Максимальний час вiдповiдi',
        'Average Response' => 'Середнiй час вiдповiдi',
        'Period' => 'Перiод',
        'Min' => 'Мiн',
        'Max' => 'Макс',
        'Average' => 'Середнє',

        # Template: Adminpgpform
        'PGP Management' => 'Керування пiдписами PGP',
        'Result' => 'Результат',
        'Identifier' => 'Iдентифiкатор',
        'Bit' => 'Бiт',
        'Key' => 'Ключ',
        'Fingerprint' => 'Цифровий вiдбиток',
        'Expires' => 'Минає',
        'In this way you can directly edit the keyring configured in Sysconfig.' => ' У цьому випадку ви можете змiнити ключi прямо в конфiгурацiї системи',

        # Template: Adminpostmasterfilter
        'Postmaster Filter Management' => 'Керування фiльтром Postmaster',
        'Filtername' => 'Iм\'я фiльтра',
        'Stop after match' => 'Припинити перевiрку пiсля збiгу',
        'Match' => 'Вiдповiдає',
        'Value' => 'Значення',
        'Set' => 'Установити',
        'Do dispatch or filter incoming emails based on email X-Headers! Regexp is also possible.' => 'Обробляти або вiдфiльтровувати вхiднi листи на основi полiв заголовка! Можливе використання регулярних виражень.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Якщо ви прагнете вiдфiльтруватитiльки по адресах електронної пошти, використовуйте EMAILADDRESS:info@example.com у полях From, To або Cc.',
        'If you use Regexp, you also can use the matched value in () as [***] in \'Set\'.' => 'Якщо ви використовуєте регулярнi вираження, ви можете використовувати змiннi в () як [***] при установцi значень',

        # Template: Adminpriority
        'Priority Management' => 'Керування прiоритетами',
        'Add Priority' => 'Створити прiоритет',
        'Add a new Priority.' => 'Створити прiоритет.',

        # Template: Adminqueueautoresponseform
        'Queue <-> Auto Responses Management' => 'Автовiдповiдi в черзi',
        'settings' => 'параметри',

        # Template: Adminqueueform
        'Queue Management' => 'Керування чергою',
        'Sub-Queue of' => 'Пiдчерга в',
        'Unlock timeout' => 'Строк блокування',
        '0 = no unlock' => '0 . без блокування',
        'Only business hours are counted.' => 'З облiком тiльки робочого часу.',
        '0 = no escalation' => '0 . без ескалацiї',
        'Notify by' => 'Повiдомлення вiд',
        'Follow up Option' => 'Параметри автовiдповiдi',
        'Ticket lock after a follow up' => 'Блокувати заявку пiсля одержання вiдповiдi',
        'Systemaddress' => 'Системна адреса',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Якщо агент заблокував заявку й не вiдправила вiдповiдь клiєнтовi протягом установленого часу, то заявка автоматично розблокується й стане доступною для iнших агентiв.',
        'Escalation time' => 'Час до ескалацiї заявки',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Якщо заявка не буде обслужена у встановлений час, показувати тiльки цю заявку',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Якщо заявка закрита, а клiєнт надiслав повiдомлення, то заявка буде заблокована для попереднього власника',
        'Will be the sender address of this queue for email answers.' => 'Установка адреси вiдправника для вiдповiдей у цiй черзi.',
        'The salutation for email answers.' => 'Вiтання для листiв',
        'The signature for email answers.' => 'Пiдпис для листiв',
        'Customer Move Notify' => 'Сповiщати клiєнта про перемiщення',
        'OTRS sends an notification email to the customer if the ticket is moved.' => ' При перемiщеннi заявки буде вiдправлене повiдомлення клiєнтовi.',
        'Customer State Notify' => 'Сповiщати клiєнта про змiну статусу',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => ' При змiнi статусу заявки буде вiдправлене повiдомлення клiєнтовi.',
        'Customer Owner Notify' => 'Сповiщати клiєнта про змiну власника',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => ' При змiнi власника заявки буде вiдправлене повiдомлення клiєнтовi.',

        # Template: Adminqueueresponseschangeform
        'Responses <-> Queue Management' => 'Керування вiдповiдями в чергах',

        # Template: Adminqueueresponsesform
        'Answer' => 'Вiдповiдь',

        # Template: Adminresponseattachmentchangeform
        'Responses <-> Attachments Management' => 'Керування прикладеними файлами у вiдповiдях',

        # Template: Adminresponseattachmentform

        # Template: Adminresponseform
        'Response Management' => 'Керування вiдповiдями',
        'A response is default text to write faster answer (with default text) to customers.' => 'Вiдповiдь . шаблон вiдповiдi клiєнтовi',
        'Don\'t forget to add a new response a queue!' => 'Не забудьте додати вiдповiдь для черги!',
        'The current ticket state is' => 'Поточний стан заявки',
        'Your email address is new' => 'Ваша адреса електронної пошти новий',

        # Template: Adminroleform
        'Role Management' => 'Керування ролями',
        'Add Role' => 'Додати роль',
        'Add a new Role.' => 'Додати роль',
        'Create a role and put groups in it. Then add the role to the users.' => 'Створiть роль i додайте в неї групи. Потiм розподiлите ролi по користувачах.',
        'It\'s useful for a lot of users and groups.' => 'Це корисно при використаннi безлiчi користувачiв i груп',

        # Template: Adminrolegroupchangeform
        'Roles <-> Groups Management' => 'Керування ролями в групах',
        'move_into' => 'перемiстити',
        'Permissions to move tickets into this group/queue.' => 'Права на перемiщення заявок у цю групу/черга',
        'create' => 'створення',
        'Permissions to create tickets in this group/queue.' => 'Права на створення заявок у цiй групi/черги',
        'owner' => 'власник',
        'Permissions to change the ticket owner in this group/queue.' => 'Права на змiну власника заявок у цiй групi/черги',
        'priority' => 'прiоритет',
        'Permissions to change the ticket priority in this group/queue.' => 'Права на змiну прiоритету заявок у цiй групi/черги',

        # Template: Adminrolegroupform
        'Role' => 'Роль',

        # Template: Adminroleuserchangeform
        'Roles <-> Users Management' => 'Керування ролями користувачiв',
        'Select the role:user relations.' => 'Виберiть зв\'язок мiж роллю й користувачем',

        # Template: Adminroleuserform

        # Template: Adminsalutationform
        'Salutation Management' => 'Керування вiтаннями',
        'Add Salutation' => 'Додати вiтання',
        'Add a new Salutation.' => 'Додати вiтання',

        # Template: Adminsecuremode
        'Secure Mode need to be enabled!' => 'Безпечний режим повинен бути включений',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Пiсля установки системи звичайно вiдразу ж включають безпечний режим.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Безпечний режим повинен бути вiдключений при переустановцi через веб-iнтерфейс',
        'If Secure Mode is not activated, activate it via Sysconfig because your application is already running.' => 'Якщо безпечний режим не включений, включите його в конфiгурацiї системи',

        # Template: Adminselectboxform
        'SQL Box' => 'Запит SQL',
        'CSV' => '',
        'HTML' => '',
        'Select Box Result' => 'Виберiть iз меню',

        # Template: Adminservice
        'Service Management' => 'Керування сервiсами',
        'Add Service' => 'Додати сервiс',
        'Add a new Service.' => 'Додати сервiс',
        'Sub-Service of' => 'Додаткова сервiс для',

        # Template: Adminsession
        'Session Management' => 'Керування сеансами',
        'Sessions' => 'Сеанси',
        'Uniq' => 'Унiкальний',
        'Kill all sessions' => 'Завершити всi сеанси',
        'Session' => 'Сеанс',
        'Content' => 'Змiст',
        'kill session' => 'Завершити сеанс',

        # Template: Adminsignatureform
        'Signature Management' => 'Керування пiдписами',
        'Add Signature' => 'Додати пiдпис',
        'Add a new Signature.' => 'Додати пiдпис',

        # Template: Adminsla
        'SLA Management' => 'Керування SLA',
        'Add SLA' => 'Додати SLA',
        'Add a new SLA.' => 'Додати SLA',

        # Template: Adminsmimeform
        'S/MIME Management' => 'Керування S/MIME',
        'Add Certificate' => 'Додати сертифiкат',
        'Add Private Key' => 'Додати закритий ключ',
        'Secret' => 'Пароль',
        'Hash' => 'Хєш',
        'In this way you can directly edit the certification and private keys in file system.' => 'Ви можете редагувати сертифiкати й закритi ключi прямо на файловiй системi',

        # Template: Adminstateform
        'State Management' => 'Керування статусами',
        'Add State' => 'Додати статус',
        'Add a new State.' => 'Додати статус',
        'State Type' => 'Тип статусу',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Виправте статуси за замовчуванням також i у файлi Kernel/Config.pm!',
        'See also' => 'Див. також',

        # Template: Adminsysconfig
        'Sysconfig' => 'Конфiгурацiя системи',
        'Group selection' => 'Вибiр групи',
        'Show' => 'Показати',
        'Download Settings' => 'Завантажити параметри',
        'Download all system config changes.' => 'Завантажити всi змiни конфiгурацiї, внесенi в систему',
        'Load Settings' => 'Застосувати конфiгурацiю з файлу',
        'Subgroup' => 'Пiдгрупа',
        'Elements' => 'Елементи',

        # Template: Adminsysconfigedit
        'Config Options' => 'Параметри конфiгурацiї',
        'Default' => ' За замовчуванням',
        'New' => 'Новий',
        'New Group' => 'Нова група',
        'Group Ro' => 'Група тiльки для читання',
        'New Group Ro' => 'Нова група тiльки для читання',
        'Navbarname' => 'Iм\'я в меню',
        'Navbar' => 'Меню',
        'Image' => 'Значок',
        'Prio' => 'Прiоритет',
        'Block' => 'Роздiл',
        'Accesskey' => 'Клавiша доступу',

        # Template: Adminsystemaddressform
        'System Email Addresses Management' => 'Керування системними адресами електронної пошти',
        'Add System Address' => 'Додати системна адреса',
        'Add a new System Address.' => 'Додати системну адресу',
        'Realname' => 'Iм\'я',
        'All email addresses get excluded on replaying on composing an email.' => 'Усi адреси, що виключаються при вiдповiдi на лист',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Усi вхiднi повiдомлення iз цим одержувачем будуть спрямованi в задану чергу',

        # Template: Admintypeform
        'Type Management' => 'Керування типами заявок',
        'Add Type' => 'Додати тип',
        'Add a new Type.' => 'Додати тип',

        # Template: Adminuserform
        'User Management' => 'Керування користувачами',
        'Add User' => 'Додати користувача',
        'Add a new Agent.' => 'Додати користувача',
        'Login as' => 'Зайти даним користувачем',
        'Firstname' => 'Iм\'я',
        'Lastname' => 'Прiзвище',
        'Start' => 'Початок',
        'End' => 'Закiнчення',
        'User will be needed to handle tickets.' => ' Для обробки заявок потрiбно зайти користувачем.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Не забудьте додати нового користувача в групи й ролi!',

        # Template: Adminusergroupchangeform
        'Users <-> Groups Management' => 'Керування групами користувачiв',

        # Template: Adminusergroupform

        # Template: Agentbook
        'Address Book' => 'Адресна книга',
        'Return to the compose screen' => 'Повернутися у вiкно складання листа',
        'Discard all changes and return to the compose screen' => 'Вiдмовитися вiд усiх змiн i повернутися у вiкно складання листа',

        # Template: Agentcalendarsmall

        # Template: Agentcalendarsmallicon

        # Template: Agentcustomersearch

        # Template: Agentcustomertableview

        # Template: Agentdashboard
        'Dashboard' => 'Дайджест',

        # Template: Agentdashboardcalendaroverview
        'in' => 'в',

        # Template: Agentdashboardimage

        # Template: Agentdashboardproductnotify
        '%s %s is available!' => '%s %s доступний',
        'Please update now.' => 'Обновите зараз',
        'Release Note' => 'Примiтка до релiзу',
        'Level' => 'Рiвень',

        # Template: Agentdashboardrssoverview
        'Posted %s ago.' => 'Опублiковане %s тому',

        # Template: Agentdashboardticketgeneric

        # Template: Agentdashboardticketstats

        # Template: Agentdashboarduseronline

        # Template: Agentinfo
        'Info' => 'Iнформацiя',

        # Template: Agentlinkobject
        'Link Object: %s' => 'Зв\'язати об\'єкт: %s',
        'Object' => 'Об\'єкт',
        'Link Object' => 'Зв\'язати об\'єкт',
        'with' => 'с',
        'Select' => 'Вибiр',
        'Unlink Object: %s' => 'Скасувати прив\'язку об\'єкта: %s',

        # Template: Agentlookup
        'Lookup' => 'Пошук',

        # Template: Agentnavigationbar

        # Template: Agentpreferencesform

        # Template: Agentspelling
        'Spell Checker' => 'Перевiрка орфографiї',
        'spelling error(s)' => 'Орфографiчнi помилки',
        'or' => 'або',
        'Apply these changes' => 'Застосувати змiни',

        # Template: Agentstatsdelete
        'Do you really want to delete this Object?' => 'Вилучити цей об\'єкт?',

        # Template: Agentstatseditrestrictions
        'Select the restrictions to characterise the stat' => 'Виберiть обмеження для визначення статистики',
        'Fixed' => 'Фiксоване',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Виберiть тiльки один пункт або заберiть прапорець .Фiксоване..',
        'Absolut Period' => 'Точний перiод',
        'Between' => ' Мiж',
        'Relative Period' => 'Вiдносний перiод',
        'The last' => 'Останнiй',
        'Finish' => 'Закiнчити',
        'Here you can make restrictions to your stat.' => 'Тут ви можете внести обмеження у вашу статистику',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Якщо ви знiмiть прапорець параметра "Фiксоване", користувач, який буде створювати звiти, зможе мiняти параметри вiдповiдного елемента',

        # Template: Agentstatseditspecification
        'Insert of the common specifications' => 'Вставте додатковi вимоги',
        'Permissions' => 'Права',
        'Format' => 'Формат',
        'Graphsize' => 'Розмiр графiка',
        'Sum rows' => 'Сума рядкiв',
        'Sum columns' => 'Сума стовпцiв',
        'Cache' => 'Кеш',
        'Required Field' => 'Обов\'язкове поле',
        'Selection needed' => 'Необхiдне видiлення',
        'Explanation' => 'Пояснення',
        'In this form you can select the basic specifications.' => 'У данiй формi ви можете вибрати основнi вимоги.',
        'Attribute' => 'Атрибут',
        'Title of the stat.' => 'Назва звiту',
        'Here you can insert a description of the stat.' => 'Тут ви можете написати опис звiту',
        'Dynamic-Object' => 'Динамiчний об\'єкт',
        'Here you can select the dynamic object you want to use.' => 'Тут ви можете вибрати динамiчний об\'єкт, який ви прагнете використовувати',
        '(Note: It depends on your installation how many dynamic objects you can use)' => 'Зауваження: кiлькiсть динамiчних об\'єктiв залежить вiд системи.',
        'Static-File' => 'Статичний файл',
        'For very complex stats it is possible to include a hardcoded file.' => ' Для дуже складних звiтiв, можливо, необхiдно використовувати тимчасовий файл',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Якщо тимчасовий файл доступний, буде показаний список, з якого ви можете вибрати файл.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Налаштування прав доступу. Ви можете вибрати одну або кiлька груп, щоб звiт був бачив для рiзних користувачiв.',
        'Multiple selection of the output format.' => 'Вибiр форматiв виводу.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Якщо ви використовуєте графiки, вам необхiдно вибрати хоча б один розмiр графiка.',
        'If you need the sum of every row select yes' => 'Якщо вам необхiдний показ суми по кожному рядковi, виберiть .Так.',
        'If you need the sum of every column select yes.' => 'Якщо вам необхiдний показ суми по кожному стовпцю, виберiть .Так.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Бiльшiсть звiтiв можуть кєшуватися. Це збiльшить швидкiсть показу звiтiв.',
        '(Note: Useful for big databases and low performance server)' => 'Примiтка: корисно для бiльших баз даних або для серверiв з низькою продуктивнiстю.',
        'With an invalid stat it isn\'t feasible to generate a stat.' => ' При статусi звiту .недiйсний. звiт не може бути сформований.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Це корисно використовувати для приховання звiту (наприклад, вiн ще не до кiнця настроєний).',

        # Template: Agentstatseditvalueseries
        'Select the elements for the value series' => 'Виберiть елементи для послiдовностi значень',
        'Scale' => 'Масштаб',
        'minimal' => 'Мiнiмальний',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, Valueseries => Year).' => 'Помнiть, що масштаб для послiдовностi значень повинен бути бiльше, нiж масштаб для осi X (наприклад, вiсь Х . мiсяць, послiдовнiсть значень . рiк).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Тут ви можете визначити послiдовнiсть значень. У вас є можливiсть вибрати один або два елементи. Потiм ви можете вибрати атрибути елементiв. Значення кожного атрибута буде показанi як окрема послiдовнiсть значень. Якщо ви не виберiть жодного атрибута, у звiтi будуть використанi всi доступнi атрибути.',

        # Template: Agentstatseditxaxis
        'Select the element, which will be used at the X-axis' => 'Виберiть елемент, який буде використаний на осi Х',
        'maximal period' => 'максимальний перiод',
        'minimal scale' => 'мiнiмальний масштаб',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Тут ви можете визначити значення для осi X. Виберiть один елемент, використовуючи перемикач. Якщо ви не виберiть жодного атрибута, у звiтi будуть використанi всi доступнi атрибути.',

        # Template: Agentstatsimport
        'Import' => 'Iмпорт',
        'File is not a Stats config' => 'Файл не є файлом конфiгурацiї звiтiв',
        'No File selected' => 'Файл не обраний',

        # Template: Agentstatsoverview
        'Results' => 'Результат',
        'Total hits' => 'Знайдено входжень',
        'Page' => 'Сторiнка',

        # Template: Agentstatsprint
        'Print' => 'Друк',
        'No Element selected.' => 'Елемент не обраний.',

        # Template: Agentstatsview
        'Export Config' => 'Експорт конфiгурацiї',
        'Information about the Stat' => 'Iнформацiя про звiт',
        'Exchange Axis' => 'Помiняти осi',
        'Configurable params of static stat' => 'Конфугурованi параметри статичного звiту',
        'No element selected.' => 'Елементи не обранi',
        'maximal period from' => 'Максимальний перiод с',
        'to' => 'по',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Вводячи данi та вибираючи поля, ви можете створювати такий звiт, який вам необхiден. Вiд адмiнiстратора, що створив цей звiт, залежить якi поля даних ви зможете вибрати.',

        # Template: Agentticketbounce
        'A message should have a To: recipient!' => 'У листi повинен бути зазначений одержувач!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Укажiть адресу електронної пошти в поле одержувача (наприклад, support@example.ru)!',
        'Bounce ticket' => 'Пересилання заявки',
        'Ticket locked!' => 'Заявка заблокована!',
        'Ticket unlock!' => 'Заявка розблокована!',
        'Bounce to' => 'Переслати для',
        'Next ticket state' => 'Наступний стан заявки',
        'Inform sender' => 'Iнформувати вiдправника',
        'Send mail!' => 'Оправити лист!',

        # Template: Agentticketbulk
        'You need to account time!' => 'Вам необхiдно порахувати час!',
        'Ticket Bulk Action' => 'Масова дiя',
        'Spell Check' => 'Перевiрка орфографiї',
        'Note type' => 'Тип замiтки',
        'Next state' => 'Наступний стан',
        'Pending date' => 'Дата очiкування',
        'Merge to' => 'Об\'єднати с',
        'Merge to oldest' => 'Об\'єднати iз самим старим',
        'Link together' => 'Зв\'язати',
        'Link to Parent' => 'Зв\'язати з батькiвським об\'єктом',
        'Unlock Tickets' => 'Розблокувати заявки',

        # Template: Agentticketclose
        'Ticket Type is required!' => ' Потрiбно вказати тип!',
        'A required field is:' => 'Необхiдне поле:',
        'Close ticket' => 'Закрити заявку',
        'Previous Owner' => 'Попереднiй власник',
        'Inform Agent' => 'Повiдомити агента',
        'Optional' => 'Необов\'язково',
        'Inform involved Agents' => 'Повiдомити агентов, що участвующих, ',
        'Attach' => 'Прикласти файл',

        # Template: Agentticketcompose
        'A message must be spell checked!' => 'Повiдомлення повинне бути перевiрене на помилки!',
        'Compose answer for ticket' => 'Створення вiдповiдь на заявку',
        'Pending Date' => 'Наступна дата',
        'for pending* states' => ' для наступних станiв* ',

        # Template: Agentticketcustomer
        'Change customer of ticket' => 'Змiнити клiєнта заявки',
        'Set customer user and customer id of a ticket' => 'Указати користувача клiєнта й iдентифiкатор користувача заявки',
        'Customer User' => 'Користувач клiєнта',
        'Search Customer' => 'Шукати клiєнта',
        'Customer Data' => 'Облiковi данi клiєнта',
        'Customer history' => 'Iсторiя клiєнта',
        'All customer tickets.' => 'Усi заявки клiєнта.',

        # Template: Agentticketemail
        'Compose Email' => 'Написати лист',
        'new ticket' => 'Нова заявка',
        'Refresh' => 'Обновити',
        'Clear To' => 'Очистити',
        'All Agents' => 'Усi агенти',

        # Template: Agentticketescalation

        # Template: Agentticketforward
        'Article type' => 'Тип повiдомлення',

        # Template: Agentticketfreetext
        'Change free text of ticket' => 'Змiнити вiльний текст заявки',

        # Template: Agenttickethistory
        'History of' => 'Iсторiя',

        # Template: Agentticketlocked

        # Template: Agentticketmerge
        'You need to use a ticket number!' => 'Вам необхiдно використовувати номер заявки!',
        'Ticket Merge' => 'Об\'єднання заявок',

        # Template: Agentticketmove
        'Move Ticket' => 'Перемiстити заявку',

        # Template: Agentticketnote
        'Add note to ticket' => 'Додати замiтку до заявки',

        # Template: Agentticketoverviewmedium
        'First Response Time' => 'Час до першої вiдповiдi',
        'Service Time' => 'Час обслуговування',
        'Update Time' => 'Час до змiни заявки',
        'Solution Time' => 'Час рiшення заявки',

        # Template: Agentticketoverviewmediummeta
        'You need min. one selected Ticket!' => 'Вам необхiдно вибрати хоча б одну заявку!',

        # Template: Agentticketoverviewnavbar
        'Filter' => 'Фiльтр',
        'Change search options' => 'Змiнити параметри пошуку',
        'Tickets' => 'Заявки',
        'of' => 'на',

        # Template: Agentticketoverviewnavbarsmall

        # Template: Agentticketoverviewpreview
        'Compose Answer' => 'Створити вiдповiдь',
        'Contact customer' => 'Зв\'язатися iз клiєнтом',
        'Change queue' => 'Перемiстити в iншу чергу',

        # Template: Agentticketoverviewpreviewmeta

        # Template: Agentticketoverviewsmall
        'sort upward' => 'сортування по зростанню',
        'up' => 'нагору',
        'sort downward' => 'сортування по убуванню',
        'down' => 'униз',
        'Escalation in' => 'Ескалацiя через',
        'Locked' => 'Блокування',

        # Template: Agentticketowner
        'Change owner of ticket' => 'Змiнити власника заявки',

        # Template: Agentticketpending
        'Set Pending' => 'Установка очiкування',

        # Template: Agentticketphone
        'Phone call' => 'Телефонний дзвiнок',
        'Clear From' => 'Очистити форму',

        # Template: Agentticketphoneoutbound

        # Template: Agentticketplain
        'Plain' => 'Звичайний',

        # Template: Agentticketprint
        'Ticket-Info' => 'Iнформацiя про заявку',
        'Accounted time' => 'Витрачене на заявку час',
        'Linked-Object' => 'Зв\'язаний об\'єкт',
        'by' => '',

        # Template: Agentticketpriority
        'Change priority of ticket' => 'Змiнити прiоритет заявки',

        # Template: Agentticketqueue
        'Tickets shown' => 'Показанi заявки',
        'Tickets available' => 'Доступнi заявки',
        'All tickets' => 'Усi заявки',
        'Queues' => 'Черги',
        'Ticket escalation!' => 'Заявка єкскларована!',

        # Template: Agentticketresponsible
        'Change responsible of ticket' => 'Перемiнити вiдповiдального за заявку',

        # Template: Agentticketsearch
        'Ticket Search' => 'Пошук заявки',
        'Profile' => 'Параметри',
        'Search-Template' => 'Шаблон пошуку',
        'Ticketfreetext' => 'Вiльнi поля заявки',
        'Created in Queue' => 'Створена в черзi',
        'Article Create Times' => 'Час створення повiдомлення',
        'Article created' => 'Повiдомлення створене',
        'Article created between' => 'Повiдомлення створене в перiод',
        'Change Times' => 'Час змiн',
        'No change time settings.' => 'Не змiнювати параметри часу',
        'Ticket changed' => 'Заявка змiнена',
        'Ticket changed between' => 'Заявка змiнена в перiод',
        'Result Form' => 'Вивiд результатiв',
        'Save Search-Profile as Template?' => 'Зберегти параметри пошуку як шаблону?',
        'Yes, save it with name' => ' Так, зберегти з iменем',

        # Template: Agentticketsearchopensearchdescriptionfulltext
        'Fulltext' => 'Повнотекстовий',

        # Template: Agentticketsearchopensearchdescriptionticketnumber

        # Template: Agentticketsearchresultprint

        # Template: Agentticketzoom
        'Expand View' => 'Докладно',
        'Collapse View' => 'Коротко',
        'Split' => 'Роздiлити',

        # Template: Agentticketzoomarticlefilterdialog
        'Article filter settings' => 'Фiльтр повiдомлень',
        'Save filter settings as default' => 'Зберегти умови фiльтра для показу за замовчуванням',

        # Template: Agentwindowtab

        # Template: AJAX

        # Template: Copyright

        # Template: Customeraccept

        # Template: Customercalendarsmallicon

        # Template: Customererror
        'Traceback' => 'Вiдстеження',

        # Template: Customerfooter
        'Powered by' => 'Використовує',

        # Template: Customerfootersmall

        # Template: Customerheader

        # Template: Customerheadersmall

        # Template: Customerlogin
        'Login' => 'Вхiд',
        'Lost your password?' => 'Забули свiй пароль?',
        'Request new password' => 'Надiслати новий пароль',
        'Create Account' => 'Створити облiковий запис',

        # Template: Customernavigationbar
        'Welcome %s' => 'Вітаємо, %s',

        # Template: Customerpreferencesform

        # Template: Customerstatusview

        # Template: Customerticketmessage

        # Template: Customerticketprint

        # Template: Customerticketsearch
        'Times' => 'Час',
        'No time settings.' => ' Без тимчасових обмежень',

        # Template: Customerticketsearchopensearchdescription

        # Template: Customerticketsearchresultcsv

        # Template: Customerticketsearchresultprint

        # Template: Customerticketsearchresultshort

        # Template: Customerticketzoom

        # Template: Customerwarning

        # Template: Error
        'Click here to report a bug!' => 'Вiдправити повiдомлення про помилку!',

        # Template: Footer
        'Top of Page' => 'У початок сторiнки',

        # Template: Footersmall

        # Template: Header
        'Home' => 'Головна сторiнка',

        # Template: Headersmall

        # Template: Installer
        'Web-Installer' => 'Установка через веб-iнтерфейс',
        'Welcome to %s' => ' Ласкаво просимо в %s',
        'Accept license' => 'Прийняти умови лiцензiї',
        'Don\'t accept license' => 'Не ухвалювати умови лiцензiї',
        'Admin-User' => 'Адмiнiстратор',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Якщо для адмiнiстратора бази даних установлений пароль, укажiть його тут. Якщо нi, залишiть поле порожнiм. З мiркувань безпеки ми рекомендуємо створити пароль адмiнiстратора. Iнформацiю iз цiєї теми можна знайти в документацiї по використовуванiй базi даних',
        'Admin-Password' => 'Пароль адмiнiстратора',
        'Database-User' => 'Користувач бази даних',
        'default \'hot\'' => ' За замовчуванням: \'hot\'',
        'DB connect host' => 'Сервер бази даних',
        'Database' => 'Iм\'я бази даних',
        'Default Charset' => 'Кодування за замовчуванням',
        'utf8' => 'utf8',
        'false' => 'нi',
        'Systemid' => 'Системний ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => 'Iдентифiкатор системи. Кожний номер заявки й сеанс починатися iз цього числа)',
        'System FQDN' => 'Системне FQDN',
        '(Full qualified domain name of your system)' => 'Повне доменне iм\'я (FQDN) вашої системи',
        'Adminemail' => 'Адреса електронної пошти адмiнiстратора',
        '(Email of the system admin)' => 'Адреса електронної пошти системного адмiнiстратора',
        'Organization' => 'Органiзацiя',
        'Log' => 'Журнал',
        'Logmodule' => 'Модуль журналу ',
        '(Used log backend)' => 'Використовуваний модуль журналу',
        'Logfile' => 'Файл журналу',
        '(Logfile just needed for File-logmodule!)' => 'Файл журналу необхiдний тiльки для модуля журналу!',
        'Webfrontend' => 'Веб-iнтерфейс',
        'Use utf-8 it your database supports it!' => 'Використовуйте utf-8, якщо ваша база даних пiдтримує це кодування!',
        'Default Language' => 'Мова за замовчуванням',
        '(Used default language)' => 'Використовувана мова за замовчуванням',
        'Checkmxrecord' => 'Перевiряти записи MX',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use Checkmxrecord if your OTRS machine is behinde a dial-up line $!)' => 'Перевiряти MХ Записи домена, на який вiдправляється email при вiдповiдi. Не використовуйте цю можливiсть, якщо сервер з OTRS доступний по слабкому каналу!',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Щоб використовувати OTRS, виконаєте в командному рядку пiд правами root наступну команду:',
        'Restart your webserver' => ' Запустите знову ваш веб-сервер',
        'After doing so your OTRS is up and running.' => 'Пiсля цих дiй система вже запущена.',
        'Start page' => 'Головна сторiнка',
        'Your OTRS Team' => 'Команда розроблювачiв OTRS',

        # Template: Linkobject

        # Template: Login

        # Template: Motd

        # Template: Nopermission
        'No Permission' => 'Недостатньо правий доступу',

        # Template: Notify
        'Important' => 'Важливо',

        # Template: Printfooter
        'URL' => 'URL',

        # Template: Printheader
        'printed by' => 'надруковане',

        # Template: Publicdefault

        # Template: Redirect

        # Template: Richtexteditor

        # Template: Test
        'OTRS Test Page' => 'Тестова сторiнка OTRS',
        'Counter' => 'Лiчильник',

        # Template: Warning

        # Misc
        'Edit Article' => 'Редагувати заявку',
        'auto responses set!' => 'Установлених автовiдповiдей',
        'Create Database' => 'Створити базу',
        'Ticket Number Generator' => 'Генератор номерiв заявок',
        'Create new Phone Ticket' => 'Створити телефонну заявку',
        'Symptom' => 'Ознака',
        'U' => 'U',
        'Site' => 'Мiсце',
        'Customer history search (e. g. "ID342425").' => 'Пошук по клiєнтi (наприклад, .ID342425.).',
        'Can not delete link with %s!' => 'Неможливо вилучити зв\'язок з .%s.!',
        'for agent firstname' => 'iм\'я для агента',
        'Close!' => 'Закрити!',
        'Subgroup \'' => 'Пiдгрупа \'',
        'No means, send agent and customer notifications on changes.' => '.Нi. . вiдправляти повiдомлення агентам i клiєнтам при змiнах',
        'A web calendar' => 'Календар',
        'to get the realname of the sender (if given)' => 'одержати (якщо є) iм\'я вiдправника',
        'Notification (Customer)' => 'Повiдомлення клiєнтовi',
        'Select Source (for add)' => 'Вибiр джерела',
        'Involved' => 'Залучення',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Поля заявки (наприклад, &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => ' Об\'єкт нащадок',
        'Days' => 'Днi',
        'Locked tickets' => 'Заблокованi заявки',
        'Queue ID' => 'ID черги',
        'System History' => 'Iсторiя',
        'customer realname' => 'Iм\'я клiєнта',
        'Pending messages' => 'Повiдомлення чекаючи',
        'Modules' => 'Модулi',
        'Keyword' => 'Ключове слово',
        'Close type' => 'Тип закриття',
        'Change user <-> group settings' => 'Групи користувачiв',
        'Problem' => 'Проблема',
        'for ' => ' для',
        'Escalation' => 'Ескалацiя',
        '"}' => '',
        'Order' => 'Порядок',
        'next step' => 'наступний крок',
        'Follow up' => 'Вiдповiдь',
        'Customer history search' => 'Пошук по iсторiї клiєнта',
        '5 Day' => '5 днiв',
        'Admin-Email' => 'Email адмiнiстратора',
        'Stat#' => 'Звiт .',
        'Create new database' => 'Створити нову бази даних',
        'Articleid' => 'ID замiтки',
        'Go' => 'Виконати',
        'Keywords' => 'Ключовi слова',
        'Ticket Escalation View' => 'Вид ескалацiї заявки',
        'Today' => 'Сьогоднi',
        'Tommorow' => 'Завтра',
        'No * possible!' => ' Не можна використовувати символ .*. !',
        'Options ' => 'Данi',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Поля iнформацiї про користувача, який запросив цю дiю (наприклад, &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Повiдомлення для нового власника',
        'to get the first 5 lines of the email' => 'Одержати першi 5 рядкiв листа',
        'Sort by' => 'Сортування по',
        'Last update' => 'Остання змiна',
        'Tomorrow' => 'Завтра',
        'to get the first 20 character of the subject' => 'Одержати першi 20 символiв теми',
        'Select the customeruser:service relations.' => 'Виберiть вiдносини клiєнта й служби.',
        'Drop Database' => 'Вилучити базу даних',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Тут ви можете визначити вiсь X. У вас є можливiсть вибрати один або два елементи. Потiм ви можете вибрати атрибути елементiв. Значення кожного атрибута буде показанi як окрема послiдовнiсть значень. Якщо ви не виберiть жодного атрибута, у звiтi будуть використанi всi доступнi атрибути.',
        'Filemanager' => 'Керування файлами',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_Userfirstname>)' => 'Поля iнформацiї про користувача (наприклад, <OTRS_CUSTOMER_DATA_Userfirstname>)',
        'Pending type' => 'Тип очiкування',
        'Comment (internal)' => 'Коментар (внутрiшнiй)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Поля iнформацiї про власника заявки (наприклад, &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Minutes' => 'Хвилини',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Поля iнформацiї про заявку (наприклад, <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => 'Використовуваний формат номерiв заявок',
        'Reminder' => 'Нагадування',
        ' (work units)' => ' ( робочi одиницi)',
        'Next Week' => ' Наступного тижня',
        'All Customer variables like defined in config option Customeruser.' => 'Усi додатковi поля iнформацiї про клiєнта визначаються параметрах користувача.',
        'for agent lastname' => ' для агента . прiзвище',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_Userfirstname>)' => 'Поля iнформацiї про користувача, який запросив цю дiю (наприклад <OTRS_CURRENT_Userfirstname>)',
        'Reminder messages' => 'Повiдомлення з нагадуваннями',
        'Change users <-> roles settings' => 'Змiнити розподiлу ролей по користувачах',
        'Parent-Object' => ' Об\'єкто Батько',
        'Of couse this feature will take some system performance it self!' => 'Дана функцiя використовує системнi ресурси!',
        'Ticket Hook' => 'Вибiр заявки',
        'Your own Ticket' => 'Ваша власна заявка',
        'Detail' => 'Докладно',
        'Ticketzoom' => 'Перегляд заявки',
        'Open Tickets' => 'Вiдкритi заявки',
        'Don\'t forget to add a new user to groups!' => 'Не забудьте додати нового користувача в групи!',
        'Createticket' => 'Створення заявки',
        'You have to select two or more attributes from the select field!' => 'Вам необхiдно вибрати два або бiльш пунктiв з обраного поля!',
        'System Settings' => 'Системнi параметри',
        'Webwatcher' => 'Веб-спостерiгач',
        'Hours' => 'Годинник',
        'Finished' => 'Закiнчене',
        'D' => 'D',
        'All messages' => 'Усi повiдомлення',
        'Options of the ticket data (e. g. <OTRS_TICKET_Ticketnumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Поля iнформацiї про заявку (наприклад, <OTRS_TICKET_Ticketnumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Об\'єкт уже пов\'язаний з %s.!',
        '7 Day' => '7 днiв',
        'Ticket Overview' => 'Огляд заявок',
        'All email addresses get excluded on replaying on composing and email.' => 'Усi додатковi адреси електронної пошти будуть виключатися у вiдповiдному листi.',
        'A web mail client' => 'Поштовий веб-клiєнт',
        'Compose Follow up' => 'Написати вiдповiдь',
        'Webmail' => 'Пошта',
        'Options of the ticket data (e. g. <OTRS_TICKET_Ticketnumber>, <OTRS_TICKET_Ticketid>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Поля iнформацiї про заявку (наприклад, <OTRS_TICKET_Ticketnumber>, <OTRS_TICKET_Ticketid>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_Userfirstname>)' => 'Опцiї власника заявки (наприклад <OTRS_OWNER_Userfirstname>)',
        'kill all sessions' => 'Закрити всi поточнi сеанси',
        'to get the from line of the email' => 'одержувач листа',
        'Solution' => 'Рiшення',
        'Queueview' => 'Перегляд черги',
        'Select Box' => 'Команда SELECT',
        'New messages' => 'Новi повiдомлення',
        'Can not create link with %s!' => 'Неможливо створити зв\'язок з %s.!',
        'Linked as' => 'Зв\'язаний як',
        'Welcome to OTRS' => ' Ласкаво просимо в OTRS',
        'modified' => 'Змiнене',
        'Running' => 'Виконується',
        'Have a lot of fun!' => 'Розважайтеся!',
        'send' => 'Вiдправити',
        'Send no notifications' => 'Не вiдправляти повiдомлення',
        'Note Text' => 'Текст замiтки',
        '3 Month' => '3 мiсяця',
        'POP3 Account Management' => 'Керування облiковим записом POP3',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Поля iнформацiї про клiєнта (наприклад, &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'Jule' => 'Липень',
        'System State Management' => 'Керування системними станами',
        'Mailbox' => ' Поштова скринька',
        'Phoneview' => 'Заявка по телефону',
        'maximal period form' => 'Максимальний перiод с',
        'Ticketid' => 'ID заявки',
        'Mart' => 'Березень',
        'Escaladed Tickets' => 'Эскалированные заявки',
        'Yes means, send no agent and customer notifications on changes.' => '.Так. . не вiдправляти повiдомлення агентам i клiєнтам при змiнах.',
        'Change setting' => 'Змiнити параметри',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Ваш лист iз номером заявки "<OTRS_TICKET>" вiдкинут i пересланий за адресою "<OTRS_BOUNCE_TO>". Будь ласка, зв\'яжiться по цiй адресi для з\'ясування причин. ',
        'Ticket Status View' => 'Перегляд статусу заявки',
        'Modified' => 'Змiнене',
        'Ticket selected for bulk action!' => 'Заявка обрана для масової дiї!',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
        'Отправити лист' => 'Відправити  листа',
        'Схована копія' => 'Прихована копія',
        'QueueView' => 'Перегляд черг',
        'CustomerID -ID' => 'Компанії клієнта',
        'Прикласти файл' => 'Вкласти або Прикріпити файл',
        'Изображение' => 'Зображення або малюнок',
        'TicketFreeText' => 'Додатковий текст в заявці',
        'Створене Агент/Власник' => 'Створена (Агент/Власник)',
        'Зберегти параметри пошуку як шаблону' => 'Зберегти параметри пошуку в якості шаблону',
        'Не змiнювати параметри часу' => 'Не враховувати параметр часу змiни в заявках',
        'My Locked Tickets' => 'Мої заблоковані заявки',
        'QueueView refresh time' => 'Час автооновлення сторінки',
        'Select your QueueView refresh time' => 'Вкажіть час автооновлення сторінки з переліком заявок',
        'Укажiть перiод вiдсутностi' => 'Вкажiть перiод вашої вiдсутностi',
        'Обновити' => 'Оновити',
        'Iншi настроювання' => 'Iншi налаштування',
        'Повiдомлення про вiдновлення' => 'Повiдомлення про вiдповіді',
        'Виберiть роздiл пiсля створення нової заявки' => 'Виберiть роздiл, що буде активовано, пiсля створення нової заявки',
        'Заповните обов\'язковi поля' => 'Заповніть обов\'язковi поля',
        'Уперед' => 'Далі',
        'Огляд' => 'Список',
        'Користувач клiєнта знадобиться, щоб одержувати доступ до iсторiї клiєнта й входити через користувацький iнтерфейс' => 'Ім\'я користувача клiєнта потрібно для того, щоб мати доступ до iсторiї клiєнта та для входу через iнтерфейс користувача',
        'StatusView' => 'Перегляд_за статусом',
        'EscalationView' => 'Перегляд ескалацій',

    };
    # $$STOP$$
    return;
}

1;
