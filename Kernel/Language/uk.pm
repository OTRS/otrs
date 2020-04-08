# --
# Copyright (C) 2010 ÐÐµÐ»ÑÑÐºÐ¸Ð¹ ÐÑÑÐµÐ¼
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::uk;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%M/%D/%Y %T';
    $Self->{DateFormatLong}      = '%T - %M/%D/%Y';
    $Self->{DateFormatShort}     = '%M/%D/%Y';
    $Self->{DateInputFormat}     = '%M/%D/%Y';
    $Self->{DateInputFormatLong} = '%M/%D/%Y - %T';
    $Self->{Completeness}        = 0.494920419911954;

    # csv separator
    $Self->{Separator}         = ',';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Керування ACL',
        'Actions' => 'Дії',
        'Create New ACL' => 'Створити новий ACL',
        'Deploy ACLs' => 'Розгорнути ACL-и',
        'Export ACLs' => 'Експортувати ACL-и',
        'Filter for ACLs' => 'Фільтри для ACL',
        'Just start typing to filter...' => 'Просто почніть друкувати для фільтрування…',
        'Configuration Import' => 'Імпорт Конфігурації',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Тут Ви можете завантажити файл конфігурації для імпорту ACL-ів у свою ситстему. Файл має бути у форматі .yml, як його експортував модуль редагування ACL.',
        'This field is required.' => 'Це обов\'язкове поле.',
        'Overwrite existing ACLs?' => 'Перезаписати наявні ACL-и?',
        'Upload ACL configuration' => 'Завантажити конфігурацію ACL',
        'Import ACL configuration(s)' => 'Імпортувати конфігурацію(-ї) ACL',
        'Description' => 'Опис',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Щоб створити новий ACL, Ви можете або імпортувати ACL-и, які було експортовано з іншої системи, або створити цілком новий.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Зміни до ACL-ів тут впливають на поведінку системи, лише якщо Ви зрешою розгортаєте дані ACL. При розгортанні даних ACL новозроблені зміни будуть записані у конфігурацію.',
        'ACLs' => 'ACL-и',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Будь ласка, зауважте: Ця таблиця відображає порядок виконання ACL-ів. Якщо Вам треба змінити порядок, у якому виконуються ACL-и, будь ласка, змініть назви відповідних ACL-ів.',
        'ACL name' => 'Назва ACL',
        'Comment' => 'Коментар',
        'Validity' => 'Дійсність',
        'Export' => 'Експорт',
        'Copy' => 'Копіювати',
        'No data found.' => 'Дані не знайдені.',
        'No matches found.' => 'Збігів не знайдено.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Редагувати ACL %s',
        'Edit ACL' => 'Редагувати ACL %s',
        'Go to overview' => 'Перейти до перегляду',
        'Delete ACL' => 'Вилучити ACL',
        'Delete Invalid ACL' => 'Вилучити недійсний ACL',
        'Match settings' => 'Налаштування співпадання',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Встановіть налаштування співпадання для цього ACL. Скористайтеся «Налаштуваннями», щоб поточний екран чи «PropertiesDatabase» співпадали з атрибутами поточної заявки, які є у базі даних.',
        'Change settings' => 'Змінити налаштування',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Установіть що Ви хочете змінити, якщо є відповідність критеріям. Майте на увазі, що «Можливо» — білий список, «Не можливо» — чорний список.',
        'Check the official %sdocumentation%s.' => '',
        'Show or hide the content' => 'Відобразити або сховати вміст',
        'Edit ACL Information' => '',
        'Name' => 'Ім\'я',
        'Stop after match' => 'Припинити перевірку після збігу',
        'Edit ACL Structure' => '',
        'Save ACL' => 'Зберегти ACL',
        'Save' => 'Зберегти',
        'or' => 'або',
        'Save and finish' => 'Зберегти та завершити',
        'Cancel' => 'Скасувати',
        'Do you really want to delete this ACL?' => 'Ви дійсно хочете вилучити цей ACL?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Створити новий ACL шляхом надсилання даних формою. Після створення цього ACL, Ви зможете додати елементи налаштування у режимі редагування.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Керування календарем',
        'Add Calendar' => 'Додати календар',
        'Edit Calendar' => 'Редагувати календар',
        'Calendar Overview' => 'Перегляд календаря',
        'Add new Calendar' => 'Додати новий календар',
        'Import Appointments' => 'Імпортувати Події',
        'Calendar Import' => 'Імпорт календаря',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Тут ви можете завантажити файл конфігурації, щоб імпортувати календар до Вашої системи.Файл повинен бути в .yml форматі, що експортуються модулем управління календаря',
        'Overwrite existing entities' => 'Перезапис об\'єктів що існують',
        'Upload calendar configuration' => 'Завантажити конфігурацію календаря',
        'Import Calendar' => 'Імпорт календаря',
        'Filter for Calendars' => '',
        'Filter for calendars' => 'Фільтр для календаря',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'Залежно від поля групи, система надасть користувачам доступ до календаря відповідно до їх рівня доступу',
        'Read only: users can see and export all appointments in the calendar.' =>
            'Тільки для читання: користувачі зможуть переглядати та експортувати всі події в календарі',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Перемістити в: користувачі можуть змінювати події в календарі, але без зміни вибору календаря',
        'Create: users can create and delete appointments in the calendar.' =>
            'Створити: користувачі можуть створювати і видаляти зустрічі в календарі',
        'Read/write: users can manage the calendar itself.' => 'Читання/запис: користувачі можуть управляти календарем самостійно',
        'Group' => 'Група',
        'Changed' => 'Змінено',
        'Created' => 'Створено',
        'Download' => 'Завантажити',
        'URL' => 'шлях URL',
        'Export calendar' => 'Експортувати календар',
        'Download calendar' => 'Завантажити календар',
        'Copy public calendar URL' => 'Копіювати URL публічного календаря',
        'Calendar' => 'Каландар',
        'Calendar name' => 'Імя календаря',
        'Calendar with same name already exists.' => 'Календар з таким імям уже існує',
        'Color' => 'Колір',
        'Permission group' => 'Група дозволів',
        'Ticket Appointments' => 'Події заявки',
        'Rule' => 'Правило',
        'Remove this entry' => 'Вилучити цей запис',
        'Remove' => 'Вилучити',
        'Start date' => 'Дата початку',
        'End date' => 'Кінцева дата',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Використовуйте опції нижче, щоб звузити, для яких тікетів події будуть створені автоматично.',
        'Queues' => 'Черги',
        'Please select a valid queue.' => 'Будь ласка виберіть дійсну чергу',
        'Search attributes' => 'Пошук атрибутів',
        'Add entry' => 'Додати запис',
        'Add' => 'Додати',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Визначення правил для створення автоматичних подій в цьому календарі на підставі даних заявки',
        'Add Rule' => 'Додати правило',
        'Submit' => 'Відправити',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Імпортувати Подію',
        'Go back' => '',
        'Uploaded file must be in valid iCal format (.ics).' => 'Завантажений файл повинен бути в правильному ical форматі (.ics)',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Якщо обраний календар не в списку, переконайтеся будь ласка, що у вас є повноваження на створення',
        'Upload' => 'Завантажити',
        'Update existing appointments?' => 'Оновити існуючі Події',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Всі існуючі події в календарі з таким же UniqueID будуть перезаписані',
        'Upload calendar' => 'Завантажити календар',
        'Import appointments' => 'Імпортувати Події',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Управління повідомленнями Подій',
        'Add Notification' => 'Додати повідомлення',
        'Edit Notification' => 'Редагувати повідомлення',
        'Export Notifications' => 'Експортувати Сповіщень',
        'Filter for Notifications' => '',
        'Filter for notifications' => '',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            '',
        'Overwrite existing notifications?' => 'Перезаписати наявні сповіщення?',
        'Upload Notification configuration' => 'Вивантажити конфігурацію Сповіщень',
        'Import Notification configuration' => 'Імпортувати конфігурацію Сповіщень',
        'List' => 'Список',
        'Delete' => 'Вилучити',
        'Delete this notification' => 'Видалити це сповіщення',
        'Show in agent preferences' => 'Показати в налаштуваннях агента',
        'Agent preferences tooltip' => 'Підказка налаштувань агента',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Це повідомлення буде відображатись на екрані налаштувань агента у вигляді підказок для цього сповіщення.',
        'Toggle this widget' => 'Приховати цей віджет',
        'Events' => 'Події',
        'Event' => 'Подія',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            '',
        'Appointment Filter' => 'Фільтр Подій',
        'Type' => 'Тип',
        'Title' => 'Заголовок',
        'Location' => ' Місце розташування',
        'Team' => 'Команда',
        'Resource' => 'Ресурс',
        'Recipients' => 'Одержувачі',
        'Send to' => 'Відправити',
        'Send to these agents' => 'Надіслати цим агентам',
        'Send to all group members (agents only)' => '',
        'Send to all role members' => 'Надіслати всім членам ролі',
        'Send on out of office' => 'Надіслано з «Не при справах»',
        'Also send if the user is currently out of office.' => 'Також надіслати, якщо користувач зараз не при справах.',
        'Once per day' => 'Один раз на день',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Повідомляти користувача тільки один раз в день по одній події з використанням обраного способу',
        'Notification Methods' => 'Методи Сповіщення',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Це можливі методи, що можуть бути використані для відправлення цього сповіщення кожному з одержувачів. Будь ласка, виберіть нижче принаймні один метод.',
        'Enable this notification method' => 'Дозволити цей метод сповіщення',
        'Transport' => 'Транспорт',
        'At least one method is needed per notification.' => 'Принаймні один метод необхідний для кожного сповіщення.',
        'Active by default in agent preferences' => 'Типово активний в налаштуваннях агента.',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Це типове значення для призначених агентів-одержувачів, які ще не зробили вибір для цього сповіщення в їх налаштуваннях. Якщо прапорець увімкнений, сповіщення буде відправлено для таких агентів.',
        'This feature is currently not available.' => 'Ця функція наразі недоступна.',
        'Upgrade to %s' => 'Оновити до %s',
        'Please activate this transport in order to use it.' => '',
        'No data found' => 'Даних не знайдено',
        'No notification method found.' => 'Жодного метода сповіщення не знайдено.',
        'Notification Text' => 'Текст сповіщення',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Цієї мови немає або вона не доступна в системі. Цей текст сповіщення може бути вилучений якщо він більше не потрібний.',
        'Remove Notification Language' => 'Видалити мову сповіщення',
        'Subject' => 'Тема',
        'Text' => 'Текст',
        'Message body' => 'Тіло повідомлення',
        'Add new notification language' => 'Додати нову мову сповіщення',
        'Save Changes' => 'Зберегти зміни',
        'Tag Reference' => 'Тег посилання',
        'Notifications are sent to an agent.' => 'Повідомлення, що надсилаються агенту',
        'You can use the following tags' => 'Ви можете використовувати наступні теги',
        'To get the first 20 character of the appointment title.' => 'Для отримання перших 20-ти символів заголовку Події',
        'To get the appointment attribute' => 'Для отримання атрибуту Події',
        ' e. g.' => ' наприклад,',
        'To get the calendar attribute' => 'Для отримання аатрибутів календаря',
        'Attributes of the recipient user for the notification' => 'Атрибути користувача-одержувача для сповіщення',
        'Config options' => 'Налаштування опцій',
        'Example notification' => 'Приклад сповіщення',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Додаткові адреси електронної пошти одержувача',
        'This field must have less then 200 characters.' => '',
        'Article visible for customer' => '',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Статтю буде створено, якщо сповіщення буде відправлено замовнику або на альтернативну електронну адресу.',
        'Email template' => 'Шаблон повідомлення електронної пошти',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Використовуйте цей шаблон для створення повного повідомлення електронної пошти (тільки для HTML-листів)',
        'Enable email security' => 'Включити захист електронної пошти',
        'Email security level' => 'Рівень безпеки електронної пошти',
        'If signing key/certificate is missing' => 'Якщо ключ підпису або сертифікат відсутні',
        'If encryption key/certificate is missing' => 'Якщо ключ шифрування або сертифікат відсутні',

        # Template: AdminAttachment
        'Attachment Management' => 'Керування прикріпленими файлами',
        'Add Attachment' => 'Додати вкладення',
        'Edit Attachment' => 'Редагувати вкладення',
        'Filter for Attachments' => 'Фільтр для Прикріплень',
        'Filter for attachments' => '',
        'Filename' => 'Ім\'я файлу',
        'Download file' => 'Завантажити файл',
        'Delete this attachment' => 'Вилучити це вкладення',
        'Do you really want to delete this attachment?' => 'Ви насправді хочете вилучити це долучення?',
        'Attachment' => 'Прикріплення',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Керування автовідповідями',
        'Add Auto Response' => 'Додати автовідповідь',
        'Edit Auto Response' => 'Змінити автовідповідь',
        'Filter for Auto Responses' => 'Фільтр для Авто-Відповідей',
        'Filter for auto responses' => '',
        'Response' => 'Відповідь',
        'Auto response from' => 'Автовідповідь від',
        'Reference' => 'Посилання',
        'To get the first 20 character of the subject.' => 'Щоб бачити перші 20 символів теми',
        'To get the first 5 lines of the email.' => 'Щоб бачити перші 5 рядків email',
        'To get the name of the ticket\'s customer user (if given).' => 'Для того, щоб отримати ім\'я користувача клієнтського квитка (якщо воно є).',
        'To get the article attribute' => 'Отримати атрибути статті',
        'Options of the current customer user data' => 'Персональні опції клієнта',
        'Ticket owner options' => 'Опції власника заявки',
        'Ticket responsible options' => 'Опції відповідального на заявку',
        'Options of the current user who requested this action' => 'Опції поточного користувача до відповів на подію',
        'Options of the ticket data' => 'Опції інформації заявки',
        'Options of ticket dynamic fields internal key values' => 'Опції значень внутрішніх ключів динамічних полів заявки',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Опції значень динамічних полів заявки, корисні для полів-випадних меню та з підтримкою багатьох варіантів вибору.',
        'Example response' => 'Приклад відповіді',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Керування хмарним сервісом',
        'Support Data Collector' => 'Збір даних підтримки',
        'Support data collector' => 'Збір даних підтримки',
        'Hint' => 'Підказка',
        'Currently support data is only shown in this system.' => 'Наразі дані підтримки показуються лише у цій системі',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Дуже рекомендується надіслати ці дані до групи OTRS з метою отримати кращу підтримку.',
        'Configuration' => 'Налаштування',
        'Send support data' => 'Надсилати дані підтримки',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Це дозволить системі надсилати додаткову інформацію даних підтримки до групи OTRS.',
        'Update' => 'Оновити',
        'System Registration' => 'Реєстрація системи',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Щоб увімкнути надсилання, будь ласка, зареєструйте Вашу систему у групі OTRS, або оновіть Вашу інформацію реєстрації системи (переконайтесь, що опцію «надсилати дані підтримки» активовано).',
        'Register this System' => 'Зареєструвати цю систему',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Реєстрація системи вимкнена у Вашій системі. Будь ласка, перевірте Ваші налаштування.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Реєстрація системи — це сервіс групи OTRS, який надає багато переваг!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Будь ласка, зауважте, що використання хмарних сервісів OTRS вимагає, щоб систему було зареєстровано.',
        'Register this system' => 'Зареєструвати цю систему.',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Тут Ви можете налаштувати наявні хмарні сервіси, що захищено комунікують з ',
        'Available Cloud Services' => 'Доступні хмарні сервіси',

        # Template: AdminCommunicationLog
        'Communication Log' => '',
        'Time Range' => '',
        'Show only communication logs created in specific time range.' =>
            '',
        'Filter for Communications' => '',
        'Filter for communications' => '',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            '',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            '',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            '',
        'Status for: %s' => '',
        'Failing accounts' => '',
        'Some account problems' => '',
        'No account problems' => '',
        'No account activity' => '',
        'Number of accounts with problems: %s' => '',
        'Number of accounts with warnings: %s' => '',
        'Failing communications' => '',
        'No communication problems' => '',
        'No communication logs' => '',
        'Number of reported problems: %s' => '',
        'Open communications' => '',
        'No active communications' => '',
        'Number of open communications: %s' => '',
        'Average processing time' => '',
        'List of communications (%s)' => '',
        'Settings' => 'Параметри',
        'Entries per page' => '',
        'No communications found.' => '',
        '%s s' => '',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => '',
        'Back to overview' => '',
        'Filter for Accounts' => '',
        'Filter for accounts' => '',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            '',
        'Account status for: %s' => '',
        'Status' => 'Статус',
        'Account' => '',
        'Edit' => 'Редагувати',
        'No accounts found.' => '',
        'Communication Log Details (%s)' => '',
        'Direction' => 'Напрямок',
        'Start Time' => '',
        'End Time' => '',
        'No communication log entries found.' => '',

        # Template: AdminCommunicationLogCommunications
        'Duration' => '',

        # Template: AdminCommunicationLogObjectLog
        '#' => '',
        'Priority' => 'Пріоритет',
        'Module' => 'Модуль',
        'Information' => 'Інформація',
        'No log entries found.' => '',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => '',
        'Filter for Log Entries' => '',
        'Filter for log entries' => '',
        'Show only entries with specific priority and higher:' => '',
        'Communication Log Overview (%s)' => '',
        'No communication objects found.' => '',
        'Communication Log Details' => '',
        'Please select an entry from the list.' => '',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Керування клієнтами',
        'Add Customer' => 'Додати Клієнта',
        'Edit Customer' => 'Редагувати клієнта',
        'Search' => 'Пошук',
        'Wildcards like \'*\' are allowed.' => 'Підстановочні символи як-то «*» є дозволеними.',
        'Select' => 'Вибір',
        'List (only %s shown - more available)' => 'тільки %s показано - більше варіантів',
        'total' => 'загально',
        'Please enter a search term to look for customers.' => ' Будь ласка, уведіть пошукове вираження для пошуку клієнтів.',
        'Customer ID' => 'ID клієнта',
        'Please note' => '',
        'This customer backend is read only!' => '',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Керувати відносини клієнт—група',
        'Notice' => 'Сповіщення',
        'This feature is disabled!' => 'Цю функцію вимкнено!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Використовуйте цю функцію лише якщо Ви хочете визначити групові права для клієнтів.',
        'Enable it here!' => 'Увімкніть це тут!',
        'Edit Customer Default Groups' => 'Редагувати групи клієнта за замовчуванням.',
        'These groups are automatically assigned to all customers.' => 'Ці групи автоматично призначаються усім клієнтам.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Фільтри для груп',
        'Select the customer:group permissions.' => 'Выбериет клієнта:дозволу для групи',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Якщо нічого не обрано, то у цієї групи немає прав (заявки не будуть доступними для клієнта).',
        'Search Results' => 'Результати пошуку',
        'Customers' => 'Клієнти',
        'Groups' => 'Групи',
        'Change Group Relations for Customer' => 'Зміна привязки групи до Клієнта',
        'Change Customer Relations for Group' => 'Зміна привязки Клієнта до групи ',
        'Toggle %s Permission for all' => 'Застосувати %s для всіх',
        'Toggle %s permission for %s' => 'Застосувати %s повноваження для %s',
        'Customer Default Groups:' => 'Клієнтська група по-умовчанню:',
        'No changes can be made to these groups.' => 'Не можливо зробити зміни для цих груп',
        'ro' => 'Тільки читання',
        'Read only access to the ticket in this group/queue.' => 'Права тільки на читання заявки в даній групі/черги',
        'rw' => 'Читання/запис',
        'Full read and write access to the tickets in this group/queue.' =>
            'Повні права на заявки в даній групі/черги',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Керування користувачами-клієнтами',
        'Add Customer User' => 'Додати користувача-клієнта',
        'Edit Customer User' => 'Редагувати користувача-клієнта',
        'Back to search results' => 'Повернутись до результатів пошуку',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Користувачі-клієнти необхідні для того, щоб мати історію клієнта, а також для входу через панель клієнта.',
        'List (%s total)' => 'Список (%s всього)',
        'Username' => 'Ім\'я користувача',
        'Email' => 'Email',
        'Last Login' => 'Останній вхід',
        'Login as' => 'Увійти як',
        'Switch to customer' => 'Перемкнутись на клієнта',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            '',
        'This field is required and needs to be a valid email address.' =>
            'Це поле є обов\'язковим і повинно бути дійсною адресою електронної пошти',
        'This email address is not allowed due to the system configuration.' =>
            'Ця адреса електронної пошти не дозволена через системні налаштування',
        'This email address failed MX check.' => 'Ця адреса електронної пошти не змогла пройти перевірку MX.',
        'DNS problem, please check your configuration and the error log.' =>
            'Проблема DNS, будь ласка, перевірте Ваші налаштування та журнал помилок.',
        'The syntax of this email address is incorrect.' => 'Синтаксис цієї адреси електронної пошти є неправильним.',
        'This CustomerID is invalid.' => '',
        'Effective Permissions for Customer User' => '',
        'Group Permissions' => '',
        'This customer user has no group permissions.' => '',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',
        'Customer Access' => '',
        'Customer' => 'Клієнт',
        'This customer user has no customer access.' => '',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            '',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => '',
        'Select the customer user:customer relations.' => '',
        'Customer Users' => 'Клієнти',
        'Change Customer Relations for Customer User' => '',
        'Change Customer User Relations for Customer' => '',
        'Toggle active state for all' => 'Встановити активний стан для всіх',
        'Active' => 'Активний',
        'Toggle active state for %s' => 'Встановити активний стан для %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => '',
        'Just use this feature if you want to define group permissions for customer users.' =>
            '',
        'Edit Customer User Default Groups' => '',
        'These groups are automatically assigned to all customer users.' =>
            '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Ви можете керувати цими групами за допомогою налаштування «CustomerGroupAlwaysGroups».',
        'Filter for groups' => '',
        'Select the customer user - group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            '',
        'Customer User Default Groups:' => '',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => '',
        'Edit default services' => 'Редагувати сервіси по замовчуванню',
        'Filter for Services' => 'Фільтр для сервісів',
        'Filter for services' => '',
        'Services' => 'Сервіси',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Керування динамічними полями',
        'Add new field for object' => 'Додати нове полк для обєкту',
        'Filter for Dynamic Fields' => '',
        'Filter for dynamic fields' => '',
        'More Business Fields' => '',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            '',
        'Database' => 'База даних',
        'Use external databases as configurable data sources for this dynamic field.' =>
            '',
        'Web service' => '',
        'External web services can be configured as data sources for this dynamic field.' =>
            '',
        'Contact with data' => '',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Для того, щоб додати нове поле, виберіть тип поля з наступного переліку об\'єктів, об\'єкт визначає зв\'язки поля та не може бути змінений після його створення.',
        'Dynamic Fields List' => 'Список динамічних полів',
        'Dynamic fields per page' => 'Кількість динамічних полів на сторінку',
        'Label' => 'Мітка',
        'Order' => 'Порядок',
        'Object' => 'Об\'єкт',
        'Delete this field' => 'Видалити це поле',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Динамічні поля',
        'Go back to overview' => 'Повернутись до перегляду',
        'General' => 'Загалом',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Це поле є обовязкове, значення повинні бути лише літери чи цифри',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Повинне бути ункальним, значення повинні бути лише літери чи цифри',
        'Changing this value will require manual changes in the system.' =>
            'Зміна цього значення вимагає ручних змін в системі',
        'This is the name to be shown on the screens where the field is active.' =>
            'Імя, що буде відображатись на екрані, коли поле активне',
        'Field order' => 'Порядок поля',
        'This field is required and must be numeric.' => 'Це поле є обовязковим і повинне складатись з цифр',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Порядок в якому поля будуть відображатись на екрані коли активні',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            '',
        'Field type' => 'Тип поля',
        'Object type' => 'Тип обєкту',
        'Internal field' => 'Внутрішнє поле',
        'This field is protected and can\'t be deleted.' => 'Це поле захищене та не може бути вилучене.',
        'This dynamic field is used in the following config settings:' =>
            '',
        'Field Settings' => 'Налаштування поля',
        'Default value' => 'Значення за замовчуванням',
        'This is the default value for this field.' => 'Це значення за замовчуванням для цього поля',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Різниця дати за замовчуванням',
        'This field must be numeric.' => 'Це поле повинно бути цифровим',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Час для прорахунку (від зараз) значення поля за замовчуванням (приклад 3600 або -60)',
        'Define years period' => 'Визначіть рік',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Активація цієї опції визначає сталий перелік років (в майбутньому і минулому) для відображення в полі рік',
        'Years in the past' => 'Років тому',
        'Years in the past to display (default: 5 years).' => 'показувати років назад (за замовчуванням: 5 років)',
        'Years in the future' => 'Років в майбутньому',
        'Years in the future to display (default: 5 years).' => 'показувати років в майбутньому (за замовчуванням: 5 років)',
        'Show link' => 'Показати посилання',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Тут Ви можете визначити додатковий HTTP лінк для значення поля перегляд і розширений перегляд',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            '',
        'Example' => 'Приклад',
        'Link for preview' => 'Посилання для перегляду',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Якщо заповнені, це посилання буде використовуватися для попереднього перегляду у розширеному перегляді тікету.Зверніть увагу, що для цієї дії, регулярне поле посилання вище повинно бути заповнене також',
        'Restrict entering of dates' => 'Обмежеити введення дати',
        'Here you can restrict the entering of dates of tickets.' => 'Тут Ви можете обмежити введення дати тікету',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Можливі значення',
        'Key' => 'Ключ',
        'Value' => 'Значення',
        'Remove value' => 'Вилучити значення',
        'Add value' => 'Додати значення',
        'Add Value' => 'Додати значення',
        'Add empty value' => 'Додати порожнє значення',
        'Activate this option to create an empty selectable value.' => 'Активувати цю опцію для створення порожнього значення, яке можна обрати',
        'Tree View' => 'Перегляд дерева',
        'Activate this option to display values as a tree.' => 'Активувати цю опцію для відображення значень у вигляді дерева.',
        'Translatable values' => 'Значення, що можна перекладати',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Якщо Ви активуєте цю опцію, значення буде перекладено на мову визначену користувачем.',
        'Note' => 'Замітка',
        'You need to add the translations manually into the language translation files.' =>
            'Вам потрібно додати переклади вручну до файлів перекладу мови.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Число рядків',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Вкажіть висоту (у рядках) цього поля у режимі редагування',
        'Number of cols' => 'Число колонок',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Вкажіть ширину (у символах) цього поля у режимі редагування.',
        'Check RegEx' => 'Перевірити регулярним виразом',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Тут Ви можете вказати регулярний вираз для перевірки значення. Регулярний вираз буде запущено з модифікаторами  xms.',
        'RegEx' => 'Регулярний вираз',
        'Invalid RegEx' => 'Неправильний регулярний вираз',
        'Error Message' => 'Повідомлення про помилку',
        'Add RegEx' => 'Додати регулярний вираз',

        # Template: AdminEmail
        'Admin Message' => '',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'За допомогою цього модуля, адміністратори можуть надсилати повідомлення до агентів, груп, або ролей членів.',
        'Create Administrative Message' => 'Створити адміністративне повідомлення',
        'Your message was sent to' => 'Ваше повідомлення було надіслано до',
        'From' => 'Від кого',
        'Send message to users' => 'Надіслати повідомлення користувачам',
        'Send message to group members' => 'Надіслати повідомлення групі користувачів',
        'Group members need to have permission' => 'Члени групи повинні мати право',
        'Send message to role members' => 'Надіслати повідомлення членам ролі',
        'Also send to customers in groups' => 'Також надіслати клієнтам у групах',
        'Body' => 'Тіло листа',
        'Send' => 'Надіслати',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => '',
        'Edit Job' => '',
        'Add Job' => '',
        'Run Job' => '',
        'Filter for Jobs' => '',
        'Filter for jobs' => '',
        'Last run' => 'Останній запуск',
        'Run Now!' => 'Виконати зараз!',
        'Delete this task' => 'Вилучити завдання',
        'Run this task' => 'Запустити завдання',
        'Job Settings' => 'Настроювання завдання',
        'Job name' => 'Ім\'я завдання',
        'The name you entered already exists.' => 'Ім\'я, що Ви ввели, вже існує.',
        'Automatic Execution (Multiple Tickets)' => '',
        'Execution Schedule' => 'Графік запуску',
        'Schedule minutes' => 'Хвилини графіку',
        'Schedule hours' => 'Години графіку',
        'Schedule days' => 'Дні графіку',
        'Automatic execution values are in the system timezone.' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Це завдання агента не запускається автоматично',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            ' Для автоматичного запуску вкажіть як мінімум одне зі значень у хвилинах, годиннику або днях',
        'Event Based Execution (Single Ticket)' => '',
        'Event Triggers' => 'Тригери події',
        'List of all configured events' => 'Список усіх налаштованих подій',
        'Delete this event' => 'Вилучити цю подію',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Додатково або альтернативно до періодичного запуску, Ви можете визначити події заявок, що будуть тригерами цього завдання.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Якщо сталась подія заявки, фільтр заявки буде застосовано для перевірки чи заявка співпадає. Лише тоді завдання буде запущено виконано для цієї заявки.',
        'Do you really want to delete this event trigger?' => 'Ви дійсно хочете вилучити цей тригер події?',
        'Add Event Trigger' => 'Додати тригер події',
        'To add a new event select the event object and event name' => '',
        'Select Tickets' => 'Обрати заявки',
        '(e. g. 10*5155 or 105658*)' => '(наприклад, 10*5155 або 105658*)',
        '(e. g. 234321)' => '(наприклад, 234321)',
        'Customer user ID' => '',
        '(e. g. U5150)' => '(наприклад, U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Повнотекстовий пошук статтею (наприклад, «Mar*in» чи «Baue*»).',
        'To' => 'Кому',
        'Cc' => 'Копія',
        'Service' => 'Сервіс',
        'Service Level Agreement' => 'Угода про рівень сервісу',
        'Queue' => 'Черга',
        'State' => 'Стан',
        'Agent' => 'Агент',
        'Owner' => 'Власник',
        'Responsible' => 'Відповідальний',
        'Ticket lock' => 'Блокування заявки',
        'Dynamic fields' => 'Динамічні поля',
        'Add dynamic field' => '',
        'Create times' => 'Часи створення',
        'No create time settings.' => ' Без обліку часу створення',
        'Ticket created' => 'Заявка створена',
        'Ticket created between' => 'Заявка створена між ',
        'and' => 'та',
        'Last changed times' => 'Час останньої зміни',
        'No last changed time settings.' => 'Не має часу змін налаштувань',
        'Ticket last changed' => 'Заявка змінена',
        'Ticket last changed between' => 'Заявка змінена між',
        'Change times' => 'Час зміни',
        'No change time settings.' => 'Не змінювати параметри часу',
        'Ticket changed' => 'Заявка змінена',
        'Ticket changed between' => 'Заявка змінена в період',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Часів закриття',
        'No close time settings.' => ' Без обліку часу закриття',
        'Ticket closed' => 'Заявка закрита',
        'Ticket closed between' => 'Заявка закрита між',
        'Pending times' => 'Часів очікування',
        'No pending time settings.' => ' Без обліку часу, коли запит був відкладений',
        'Ticket pending time reached' => 'Заявка була відкладена',
        'Ticket pending time reached between' => 'Заявка була відкладена між',
        'Escalation times' => 'час ротермінування',
        'No escalation time settings.' => ' Без обліку часу ескалації',
        'Ticket escalation time reached' => 'Заявка була ескальована',
        'Ticket escalation time reached between' => 'Заявка була ескальована між',
        'Escalation - first response time' => 'Ескалація - час першої відповіді',
        'Ticket first response time reached' => 'Перша відповідь',
        'Ticket first response time reached between' => 'Перша відповідь між',
        'Escalation - update time' => 'Ескалація - час оновлення',
        'Ticket update time reached' => 'Заявка була оновлена',
        'Ticket update time reached between' => 'Заявка була оновлена між',
        'Escalation - solution time' => 'Ескалація - час вирішення',
        'Ticket solution time reached' => 'Заявка була вирішена',
        'Ticket solution time reached between' => 'Заявка була вирішена між',
        'Archive search option' => 'Опція пошуку архівом',
        'Update/Add Ticket Attributes' => 'Оновити/Додати атрибути заявки',
        'Set new service' => 'Установити новий сервіс',
        'Set new Service Level Agreement' => 'Установити нове погодження рівня сервісу',
        'Set new priority' => 'Установити новий пріоритет',
        'Set new queue' => 'Установити нову чергу',
        'Set new state' => 'Установити новий стан',
        'Pending date' => 'Дата очікування',
        'Set new agent' => 'Призначити нового агента',
        'new owner' => 'новий власник',
        'new responsible' => 'нова відповідь',
        'Set new ticket lock' => 'Встановити нове блокування заявки',
        'New customer user ID' => '',
        'New customer ID' => 'ID нового клієнта',
        'New title' => 'Новий заголовок',
        'New type' => 'Новий тип',
        'Archive selected tickets' => 'Заархівувати обрані заявки',
        'Add Note' => 'Додати замітку',
        'Visible for customer' => '',
        'Time units' => 'Одиниці часу',
        'Execute Ticket Commands' => 'Виконати команди заявки',
        'Send agent/customer notifications on changes' => 'Відправляти повідомлення агентові при змінах',
        'CMD' => 'Команда',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ця команда буде виконана. ARG[0] — номер заявки. ARG[1] — id заявки.',
        'Delete tickets' => 'Вилучити заявки',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Попередження: Усі обрані заявки будуть вилучені з бази даних без можливості відновлення!',
        'Execute Custom Module' => 'Виконати модуль користувача',
        'Param %s key' => 'Ключ параметра ',
        'Param %s value' => 'Значення параметра ',
        'Results' => 'Результат',
        '%s Tickets affected! What do you want to do?' => 'Квитки %s ушкоджені. Що ви хочете робити далі?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Увага: Ви використали опцію ВИЛУЧИТИ. Всі вилучені квитки буде втрачено!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Увага: є ушкоджені квитки %s але тільки %s можна змінити впродовж виконання одного завдання.',
        'Affected Tickets' => 'Обрані завдання',
        'Age' => 'Відкрита',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'ЗагальноІнтерфейсне Керування веб-службою',
        'Web Service Management' => '',
        'Debugger' => 'Відладчик',
        'Go back to web service' => 'Повернутись до веб серівісів',
        'Clear' => 'Очистити',
        'Do you really want to clear the debug log of this web service?' =>
            'Ви дійсно бажаєте очистити лог відладки цього веб сервісу?',
        'Request List' => 'Необхідний перелік',
        'Time' => 'Час',
        'Communication ID' => '',
        'Remote IP' => 'Віддалений IP',
        'Loading' => 'Завантаження',
        'Select a single request to see its details.' => 'Обрати один запит для перегляду його деталей',
        'Filter by type' => 'Фільтрувати за типом',
        'Filter from' => 'Фільтрувати від',
        'Filter to' => 'Фільтрувати до',
        'Filter by remote IP' => 'Фільтрувати за віддаленим IP',
        'Limit' => 'Обмеження',
        'Refresh' => 'Обновити',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => '',
        'Edit ErrorHandling' => '',
        'Do you really want to delete this error handling module?' => '',
        'All configuration data will be lost.' => 'Всі конфігураційні дані будуть втрачені.',
        'General options' => '',
        'The name can be used to distinguish different error handling configurations.' =>
            '',
        'Please provide a unique name for this web service.' => 'Вкажіть будь ласка унікальне ім\'я для цієї веб-служби.',
        'Error handling module backend' => '',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            '',
        'Processing options' => '',
        'Configure filters to control error handling module execution.' =>
            '',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            '',
        'Operation filter' => '',
        'Only execute error handling module for selected operations.' => '',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            '',
        'Invoker filter' => '',
        'Only execute error handling module for selected invokers.' => '',
        'Error message content filter' => '',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            '',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            '',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            '',
        'Error stage filter' => '',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            '',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            '',
        'Error code' => '',
        'An error identifier for this error handling module.' => '',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Error message' => '',
        'An error explanation for this error handling module.' => '',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            '',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            '',
        'Default behavior is to resume, processing the next module.' => '',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            '',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            '',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            '',
        'Request retry options' => '',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            '',
        'Schedule retry' => '',
        'Should requests causing an error be triggered again at a later time?' =>
            '',
        'Initial retry interval' => '',
        'Interval after which to trigger the first retry.' => '',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            '',
        'Factor for further retries' => '',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            '',
        'Maximum retry interval' => '',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            '',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            '',
        'Maximum retry count' => '',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            '',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            '',
        'This field must be empty or contain a positive number.' => '',
        'Maximum retry period' => '',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            '',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            '',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            '',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => '',
        'Edit Invoker' => '',
        'Do you really want to delete this invoker?' => 'Ви справді бажаєте вилучити цей активатор?',
        'Invoker Details' => 'Деталі активатора',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Ім\'я, що типово використовується для виклику операцій віддаленої веб-служби.',
        'Invoker backend' => 'Нутрощі активатора',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Цей внутрішній модуль OTRS активатора буде викликаний щоб підготувати дані для відправки до віддаленої системи та обробляти дані її відповіді.',
        'Mapping for outgoing request data' => 'Відображення для даних вихідного запиту',
        'Configure' => 'Налаштувати',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Дані з активатора OTRS будуть оброблені цим відображенням, щоб перетворити їх до того вигляду даних, який очікує віддалена система.',
        'Mapping for incoming response data' => 'Відображення для вхідних даних відгуку',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Дані відповіді будуть оброблені цим відображенням так, щоб перетворити їх до того виду, що очікує активатор OTRS.',
        'Asynchronous' => 'Асинхронний',
        'Condition' => 'Умова',
        'Edit this event' => '',
        'This invoker will be triggered by the configured events.' => 'Цей активатор буде викликаний сконфігурованою подією.',
        'Add Event' => 'Додати подію',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Щоб додати нову подію, вкажіть об\'єкт події та назву події, після чого натисніть кнопку «+»',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Асинхронні тригери подій будуть оброблятись Службою Планувальника OTRS у фоновому режимі (рекомендовано).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Синхронні тригери подій будуть обробляться безпосередньо під час веб-запиту.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => '',
        'Go back to' => 'Повернутися до',
        'Delete all conditions' => '',
        'Do you really want to delete all the conditions for this event?' =>
            '',
        'General Settings' => '',
        'Event type' => '',
        'Conditions' => 'Умови',
        'Conditions can only operate on non-empty fields.' => 'Умови можуть діяти тільки з непорожніми полями.',
        'Type of Linking between Conditions' => 'Тип Зв\'язку між Умовами',
        'Remove this Condition' => 'Видалити цю Умову',
        'Type of Linking' => 'Тип Зв\'язку',
        'Fields' => 'Поля',
        'Add a new Field' => 'Додати нове Поле',
        'Remove this Field' => 'Вилучити це Поле',
        'And can\'t be repeated on the same condition.' => 'Та не може бути повторений при тих самих умовах.',
        'Add New Condition' => 'Додати Нову Умову',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Просте відображення',
        'Default rule for unmapped keys' => 'Типове правило для ключів без відображення',
        'This rule will apply for all keys with no mapping rule.' => 'Це правило буде застосовуватися для всіх ключів, що не мають правил відображення.',
        'Default rule for unmapped values' => 'Типове правило для значень без відображення',
        'This rule will apply for all values with no mapping rule.' => 'Це правило буде застосовуватись для всіх значень, що не мають правил відображення.',
        'New key map' => 'Новий ключ відображення',
        'Add key mapping' => 'Додати ключ відображення',
        'Mapping for Key ' => 'Відображення для Ключа',
        'Remove key mapping' => 'Вилучити ключ відображення',
        'Key mapping' => 'Ключ відображення',
        'Map key' => 'Ключ відображення',
        'matching the' => 'відповідність',
        'to new key' => 'для нового ключа',
        'Value mapping' => 'Перетворення значень',
        'Map value' => 'Значення відображення',
        'to new value' => 'на нове значення',
        'Remove value mapping' => 'Вилучити відображення значення',
        'New value map' => 'Нове значення відображення',
        'Add value mapping' => 'Додати значення відображення',
        'Do you really want to delete this key mapping?' => 'Ви дійсно бажаєте вилучити цей ключ відображення?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => '',
        'MacOS Shortcuts' => '',
        'Comment code' => '',
        'Uncomment code' => '',
        'Auto format code' => '',
        'Expand/Collapse code block' => '',
        'Find' => '',
        'Find next' => '',
        'Find previous' => '',
        'Find and replace' => '',
        'Find and replace all' => '',
        'XSLT Mapping' => '',
        'XSLT stylesheet' => '',
        'The entered data is not a valid XSLT style sheet.' => '',
        'Here you can add or modify your XSLT mapping code.' => '',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            '',
        'Data includes' => '',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            '',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            '',
        'Data key regex filters (before mapping)' => '',
        'Data key regex filters (after mapping)' => '',
        'Regular expressions' => '',
        'Replace' => '',
        'Remove regex' => '',
        'Add regex' => '',
        'These filters can be used to transform keys using regular expressions.' =>
            '',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            '',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            '',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            '',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            '',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            '',
        'For information about regular expressions in Perl please see here:' =>
            '',
        'Perl regular expressions tutorial' => '',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            '',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            '',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => '',
        'Edit Operation' => '',
        'Do you really want to delete this operation?' => 'Ви дійсно бажаєте видалити цю операцію?',
        'Operation Details' => 'Деталі операції.',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Ім\'я, що типово використовується для виклику операції цієї веб-служби віддаленої системи.',
        'Operation backend' => 'Внутрішня операція',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Цей внутрішній операційний модуль OTRS буде викликаний внутрішньо щоб обробити запит та згенерувати дані для відповіді.',
        'Mapping for incoming request data' => 'Відображенні вхідних даних запиту',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Дані запиту будуть оброблені цим відображенням, щоб перетворити його до виду даних, що очікує OTRS.',
        'Mapping for outgoing response data' => 'Відображення для вихідних даних відповіді',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Дані відповіді будуть оброблені цим відображенням, щоб перетворити їх до того виду, який очікує віддалена система.',
        'Include Ticket Data' => '',
        'Include ticket data in response.' => '',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => '',
        'Properties' => 'Властивості',
        'Route mapping for Operation' => 'Відображення маршруту для Операції',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Визначення маршруту що дасть відображення для цієї операції. Змінні, що помічаються \':\' будуть відображені з вказаним ім\'ям та передається з іншими до відображення. (Наприклад /Ticket/:TicketID)',
        'Valid request methods for Operation' => 'Правильні методи запиту для Операції',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Обмежити цю Операцію до певних методів запиту. Якщо ви не вкажете жодного методу, всі запити будуть прийняті.',
        'Maximum message length' => 'Максимальна довжина повідомлення',
        'This field should be an integer number.' => 'Це поле має містити ціле число.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Тут ви можете визначити максимальний розмір (в байтах) REST повідомлення, що буде оброблено OTRS.',
        'Send Keep-Alive' => 'Надіслати Keep-аlive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Ця конфігурація визначає які вхідні з\'єднання мають бути зачинені або збережені.',
        'Additional response headers' => '',
        'Add response header' => '',
        'Endpoint' => 'Кінцева точка',
        'URI to indicate specific location for accessing a web service.' =>
            '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'наприклад https://www.otrs.com:10745/api/v1.0 (без оберненої косої межі)',
        'Timeout' => '',
        'Timeout value for requests.' => '',
        'Authentication' => 'Автентифікація',
        'An optional authentication mechanism to access the remote system.' =>
            '',
        'BasicAuth User' => '',
        'The user name to be used to access the remote system.' => 'Ім\'я користувача для доступу до віддаленої системи.',
        'BasicAuth Password' => '',
        'The password for the privileged user.' => 'Пароль для привілейованого користувача.',
        'Use Proxy Options' => '',
        'Show or hide Proxy options to connect to the remote system.' => '',
        'Proxy Server' => 'Проксі-сервер',
        'URI of a proxy server to be used (if needed).' => 'URI проксі-сервера, що використовується (якщо треба).',
        'e.g. http://proxy_hostname:8080' => 'наприклад http://proxy_hostname:8080',
        'Proxy User' => 'Користувач проксі-сервера',
        'The user name to be used to access the proxy server.' => 'Ім\'я користувача для доступу до проксі-сервера.',
        'Proxy Password' => 'Пароль проксі-сервера',
        'The password for the proxy user.' => 'Пароль користувача проксі-сервера.',
        'Skip Proxy' => '',
        'Skip proxy servers that might be configured globally?' => '',
        'Use SSL Options' => 'Використовувати SSL опції',
        'Show or hide SSL options to connect to the remote system.' => 'Показати або приховати SSL опції для під\'єднання до віддаленої системи.',
        'Client Certificate' => '',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => '',
        'Client Certificate Key' => '',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => '',
        'Client Certificate Key Password' => '',
        'The password to open the SSL certificate if the key is encrypted.' =>
            '',
        'Certification Authority (CA) Certificate' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Повний шлях та ім\'я файлу сертифікату сертифікаційної автентифікації що підтверджує SSL сертифікат',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'наприклад /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Директорія сертифікаційної авторизації (СА)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Повний шлях у файловій системі до директорії сертифікаційної авторизації де зберігаються СА сертифікати.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'наприклад /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => 'Відображення контролера для активатора.',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Контролер, якому активатор має посилати запити. Змінні, позначені як \':\' будуть замінені на значення даних та передаватись разом із запитом. (наприклад /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Чинна команда запиту для активатора',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Конкретна HTTP команда  що буде використовуватись для запитів з цим активатором (необов\'язково).',
        'Default command' => 'Типова команда',
        'The default HTTP command to use for the requests.' => 'Типова HTTP команда для використання у запитах.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => '',
        'Set SOAPAction' => '',
        'Set to "Yes" in order to send a filled SOAPAction header.' => '',
        'Set to "No" in order to send an empty SOAPAction header.' => '',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            '',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            '',
        'SOAPAction scheme' => '',
        'Select how SOAPAction should be constructed.' => '',
        'Some web services require a specific construction.' => '',
        'Some web services send a specific construction.' => '',
        'SOAPAction separator' => 'Відокремлювач SOAPДії',
        'Character to use as separator between name space and SOAP operation.' =>
            '',
        'Usually .Net web services use "/" as separator.' => '',
        'SOAPAction free text' => '',
        'Text to be used to as SOAPAction.' => '',
        'Namespace' => 'Простір Імен',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI, щоб дати контекст методів SOAP, зменшуючи двозначність.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'наприклад urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Схема імені запиту',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Виберіть як має бути побудована функція обгортка SOAP запиту.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' використовується в якості прикладу для фактичного імені активатора/операції.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' використовується у якості прикладу для фактичного налаштованого значення.',
        'Request name free text' => 'ім\'я запиту вільним текстом',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Текст що буде використовуватись як суфікс імені функції обгортки або заміна імені.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Будь ласка зверніть увагу на обмеження іменування XML-елементу (наприклад - не використовувати \'<\' та \'&\')',
        'Response name scheme' => 'Схема імені відгуку',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Виберіть як має бути побудована функція-обгортка SOAP відповіді.',
        'Response name free text' => 'Ім\'я відповіді вільним текстом.',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Тут ви можете визначити максимальний обсяг (в байтах) SOAP повідомлення, що буде обробляти OTRS.',
        'Encoding' => 'Кодування',
        'The character encoding for the SOAP message contents.' => 'Кодування символів для вмісту SOAP повідомлень.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'наприклад utf-8, latin1, iso-8859-1, cp1250 тощо.',
        'Sort options' => 'Параметри сортування',
        'Add new first level element' => 'Додати новий елемент першого рівня',
        'Element' => 'Елемент',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Вихідний порядок сортування для xml полів (структура що починається нижче імені функції обгортки) - дивись документацію на транспорт SOAP',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => '',
        'Edit Web Service' => '',
        'Clone Web Service' => '',
        'The name must be unique.' => 'ім\'я повинно бути унікальним.',
        'Clone' => 'Клонувати',
        'Export Web Service' => '',
        'Import web service' => 'Імпортувати веб-службу',
        'Configuration File' => 'Файл конфігурації',
        'The file must be a valid web service configuration YAML file.' =>
            'Файл повинен бути чинним YAML конфігураційним файлом веб-служби.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            '',
        'Import' => 'Імпорт',
        'Configuration History' => '',
        'Delete web service' => 'Вилучити веб-службу',
        'Do you really want to delete this web service?' => 'Ви насправді хочете вилучити цю веб-службу?',
        'Ready2Adopt Web Services' => '',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Зверніть увагу, що ці веб-служби можуть залежати від інших модулів, доступних тільки з певним %s рівнем контракту (буде повідомлення з більш докладними поясненнями при імпорті).',
        'Import Ready2Adopt web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Після збереження конфігурації вас буде перенаправлено знову до екрану редагування.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Якщо ви хочете повернутись до огляду, будь ласка, натисніть кнопку "Перейти до огляду".',
        'Remote system' => 'Віддалена система',
        'Provider transport' => 'Транспорт провайдера',
        'Requester transport' => 'Транспорт замовника',
        'Debug threshold' => 'Поріг зневадження',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'В режимі постачальника, OTRS пропонує веб-служби, які використовуються віддаленими системами.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'В режимі запитувача, OTRS використовую веб-служби віддалених систем.',
        'Network transport' => 'Мережевий транспорт',
        'Error Handling Modules' => '',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            '',
        'Backend' => '',
        'Add error handling module' => '',
        'Operations are individual system functions which remote systems can request.' =>
            'Операції - це окремі системні функції, які можуть запросити віддалені системи.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Активатори готують дані для запиту до віддаленої веб-служби та обробляють дані їх відповіді.',
        'Controller' => 'Контролер',
        'Inbound mapping' => 'Вхідне відображення',
        'Outbound mapping' => 'Вихідне відображення',
        'Delete this action' => 'Вилучити цю дію',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Принаймні один %s має контролер, який або не активний або не присутній, будь ласка перевірте реєстрацію контролера або вилучіть %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Історія',
        'Go back to Web Service' => 'Повернутись до веб-служби',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Тут ви можете переглянути старі версії поточної конфігурації веб-служб, експортувати або навіть відновити їх.',
        'Configuration History List' => 'Перелік історії конфігурації.',
        'Version' => 'Версія',
        'Create time' => 'Створити час',
        'Select a single configuration version to see its details.' => 'Вибрати один варіант конфігурації щоб переглянути  його деталі.',
        'Export web service configuration' => 'Експорт конфігурації веб-служби',
        'Restore web service configuration' => 'Відновлення конфігурації веб-служби',
        'Do you really want to restore this version of the web service configuration?' =>
            'Ви дійсно бажаєте відновити цю версію конфігурації веб-служби?',
        'Your current web service configuration will be overwritten.' => 'Ваша поточна конфігурація веб-служби буде перезаписана.',

        # Template: AdminGroup
        'Group Management' => 'Керування групами',
        'Add Group' => 'Додати групу',
        'Edit Group' => 'Редагувати групу',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Група admin може здійснювати адміністрування, а група stats — переглядати статистику',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Створення нових груп для обробки прав доступу до різних груп агентів (наприклад відділ закупівель, відділ підтримки, відділ продаж,...).',
        'It\'s useful for ASP solutions. ' => 'Корисно для сервісів-провайдерів.',

        # Template: AdminLog
        'System Log' => 'Системний журнал',
        'Here you will find log information about your system.' => 'Тут ви знайдете журнальну інформацію вашої системи.',
        'Hide this message' => 'Приховати це повідомлення',
        'Recent Log Entries' => 'Останні Записи Журналу',
        'Facility' => 'Об\'єкт',
        'Message' => 'Повідомлення',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Керування поштовими обліковими записами',
        'Add Mail Account' => 'Додати поштовий обліковий запис',
        'Edit Mail Account for host' => '',
        'and user account' => '',
        'Filter for Mail Accounts' => '',
        'Filter for mail accounts' => '',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            '',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            '',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            '',
        'System Configuration' => '',
        'Host' => 'Сервер',
        'Delete account' => 'Вилучити обліковий запис',
        'Fetch mail' => 'Забрати лист',
        'Do you really want to delete this mail account?' => '',
        'Password' => 'Пароль',
        'Example: mail.example.com' => 'Приклад: mail.example.com',
        'IMAP Folder' => 'Тека IMAP',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Змініть це, якщо вам потрібно отримати пошту з іншої теки, ніж INBOX. ',
        'Trusted' => 'Безпечна',
        'Dispatching' => 'Перенапрямок',
        'Edit Mail Account' => 'Змінити поштовий обліковий запис',

        # Template: AdminNavigationBar
        'Administration Overview' => '',
        'Filter for Items' => '',
        'Filter' => 'Фільтр',
        'Favorites' => '',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            '',
        'Links' => '',
        'View the admin manual on Github' => '',
        'No Matches' => '',
        'Sorry, your search didn\'t match any items.' => '',
        'Set as favorite' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Керування Сповіщеннями про Квитки',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Тут ви можете вивантажити файл конфігурації для імпорту Сповіщень о Квитках до вашої системи. Файл повинен бути у .yml форматі такий як експортується модулем Сповіщення о Квитках.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Тут ви можете вибрати події, що будуть вмикати це сповіщення. Додатковий фільтр квитків може бути доданий нижче, щоб відправити сповіщення для квитка з певними критеріями.',
        'Ticket Filter' => 'Фільтр заявок',
        'Lock' => 'Блокувати',
        'SLA' => 'Рівень обслуговування',
        'Customer User ID' => 'ID користувача клієнта',
        'Article Filter' => 'Фільтр Статей',
        'Only for ArticleCreate and ArticleSend event' => 'Тільки для подій ArticleCreate та ArticleSend ',
        'Article sender type' => 'Тип статті відправника',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Якщо ArticleCreate або ArticleSend використовуються як ініціюючи події, вам необхідно також вказати фільтр статті. Будь ласка виберіть принаймні одне поле фільтру статті.',
        'Customer visibility' => '',
        'Communication channel' => '',
        'Include attachments to notification' => 'Додати вкладення в повідомлення',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Повідомляти користувача тільки один раз на день про один квиток використовуючи вибраний транспорт.',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Notifications are sent to an agent or a customer.' => 'Повідомлення відправлені агентові або клієнтові',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Перші 20 символів теми з останнього повідомлення агента',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Перші 5 рядків останнього повідомлення агента',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Перші 20 символів теми з останнього повідомлення клієнта',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Перші 5 рядків останнього повідомлення клієнта',
        'Attributes of the current customer user data' => 'Атрибути поточних даних клієнта користувача.',
        'Attributes of the current ticket owner user data' => 'Атрибути поточних даних користувача власника квитка.',
        'Attributes of the current ticket responsible user data' => 'Атрибути поточних даних користувача відповідального за квиток',
        'Attributes of the current agent user who requested this action' =>
            'Атрибути поточного користувача-агента, який запросив цю дію',
        'Attributes of the ticket data' => 'Атрибути даних квитка.',
        'Ticket dynamic fields internal key values' => 'Значення внутрішніх ключів динамічних полів квитка.',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Динамічні поля квитка відображають значення, корисні для полів що Розкриваються та з Множинним вибором',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => '',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Ви можете використовувати OTRS-теги, такі як  <OTRS_TICKET_DynamicField_...>  щоб вставити значення з поточного квитка.',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Керування %s',
        'Downgrade to ((OTRS)) Community Edition' => '',
        'Read documentation' => 'Читайте документацію',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s регулярно контактує з  cloud.otrs.com, щоб перевірити наявність оновлень і терміну дії основної угоди.',
        'Unauthorized Usage Detected' => 'Виявлено несанкційоване використання',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Ця система використовує %s без належної ліцензії! Будь ласка зв\'яжіться з %s для поновлення або активації своєї угоди!',
        '%s not Correctly Installed' => '%s встановлений неправильно',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Ваш %s встановлений неправильно. Будь ласка, перевстановіть його за допомогою кнопки нижче.',
        'Reinstall %s' => 'Перевстановлення %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Ваш %s встановлений неправильно, і є також оновлення.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Ви можете або перевстановити поточну версію або оновити за допомогою кнопок нижче (оновлення рекомендується)',
        'Update %s' => 'Оновлення $s',
        '%s Not Yet Available' => '$s ще не доступний',
        '%s will be available soon.' => '%s буде доступний найближчим часом.',
        '%s Update Available' => 'Доступні оновлення %s',
        'An update for your %s is available! Please update at your earliest!' =>
            'Оновлення для вашого %s доступне! Будь ласка, поновіть найближчим часом!',
        '%s Correctly Deployed' => '%s розгорнуто правильно',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Вітаємо, ваш %s встановлено правильно та має актуальну версію!',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => 'Перейти до порталу клієнтів OTRS',
        '%s will be available soon. Please check again in a few days.' =>
            '%s незабаром буде доступний. Будь ласка, перевірте ще раз через кілька днів.',
        'Please have a look at %s for more information.' => 'Будь ласка, зверніть увагу на %s для отримання додаткової інформації.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Перш ніж скористатися %s, зв\'яжіться із %s щоб отримати вашу %s угоду.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Неможливо встановити з\'єднання із cloud.otrs.com за допомогою HTTPS. Будь ласка, переконайтеся в тому, що ваш OTRS може під\'єднатися до cloud.otrs.com використовуючи порт 443.',
        'Package installation requires patch level update of OTRS.' => 'Встановлення пакунка потребує оновлення рівня виправлень OTRS.',
        'Please visit our customer portal and file a request.' => 'Будь ласка, відвідайте наш портал клієнта та подайте заявку.',
        'Everything else will be done as part of your contract.' => 'Все інше буде зроблено в рамках угоди.',
        'Your installed OTRS version is %s.' => 'Версія вашого встановленого OTRS %s.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            'Щоб встановити цей пакунок, вам необхідно оновитись до OTRS %s або вище.',
        'To install this package, the Maximum OTRS Version is %s.' => 'Максимальна версія OTRS для встановлення цього пакунку, це %s.',
        'To install this package, the required Framework version is %s.' =>
            'Щоб встановити цей пакунок, необхідний Фреймворк версії %s.',
        'Why should I keep OTRS up to date?' => 'Чому я маю тримати OTRS в актуальному стані?',
        'You will receive updates about relevant security issues.' => 'Ви будете отримувати нову інформацію з відповідних питань безпеки.',
        'You will receive updates for all other relevant OTRS issues' => 'Ви будете отримувати оновлення для всіх інших відповідних питань OTRS',
        'With your existing contract you can only use a small part of the %s.' =>
            'З вашою чинною угодою ви можете використовувати лише невелику частку %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Якщо ви маєте бажання скористатися всіма перевагами %s, покращить вашу угоду зараз! Зв\'яжіться з %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Скасувати погіршення та повернутися',
        'Go to OTRS Package Manager' => 'Перейти до менеджера пакунків OTRS',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Вибачте, але зараз ви не можете погіршити угоду за рахунок наступних пакунків, що залежать від %s:',
        'Vendor' => 'Виготовлювач',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Будь ласка, спершу вилучіть  пакунки з використанням менеджера пакунків та спробуйте ще раз.',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            '',
        'Chat' => 'Чат',
        'Report Generator' => 'Генератор звітів',
        'Timeline view in ticket zoom' => 'Вигляд лінії часу в збільшенні квитка',
        'DynamicField ContactWithData' => 'ДинамічнеПоле Зв\'язокЗДаними',
        'DynamicField Database' => 'Динамічне поле БазаДаних',
        'SLA Selection Dialog' => 'Діалог вибору SLA',
        'Ticket Attachment View' => 'Перегляд долучення квитка',
        'The %s skin' => 'Зовнішній вигляд %s',

        # Template: AdminPGP
        'PGP Management' => 'Керування підписами PGP',
        'Add PGP Key' => 'Додати PGP ключ',
        'PGP support is disabled' => 'Підтримку PGP скасовано.',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'Щоб мати змогу використовувати PGP в OTRS ви повинні спочатку увімкнути його.',
        'Enable PGP support' => 'Дозволити підтримку PGP',
        'Faulty PGP configuration' => 'Невірні налаштування PGP',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Підтримка PGP увімкнена, але відповідна конфігурація містить помилки. Будь ласка перевірте конфігурацію за допомогою кнопки нижче.',
        'Configure it here!' => 'Налаштуйте це тут!',
        'Check PGP configuration' => 'Перевірте конфігурацію PGP',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Таким чином, Ви можете безпосередньо редагувати кільце налаштоване в SysConfig.',
        'Introduction to PGP' => 'Введення до PGP',
        'Identifier' => 'Ідентифікатор',
        'Bit' => 'Біт',
        'Fingerprint' => 'Цифровий відбиток',
        'Expires' => 'Минає',
        'Delete this key' => 'Вилучити ключ',
        'PGP key' => 'PGP ключ',

        # Template: AdminPackageManager
        'Package Manager' => 'Керування пакетами',
        'Uninstall Package' => '',
        'Uninstall package' => 'Деінсталювати пакет',
        'Do you really want to uninstall this package?' => 'Вилучити цей пакет?',
        'Reinstall package' => 'Переустановити пакет',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Ви дійсно хочете перевстановити цей пакунок? Аби-які ручні зміни буде втрачено!',
        'Go to updating instructions' => '',
        'package information' => 'інформація про пакет',
        'Package installation requires a patch level update of OTRS.' => 'Установка пакунку потребує оновлення рівня виправлень OTRS.',
        'Package update requires a patch level update of OTRS.' => 'Оновлення пакунку потребує оновлення рівня оновлень OTRS.',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            'Якщо ви є клієнтом OTRS Business Solution™, будь ласка, відвідайте наш портал клієнтів та подайте заявку.',
        'Please note that your installed OTRS version is %s.' => 'Зверніть увагу, що версія встановленого OTRS %s.',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            'Щоб встановити цей пакунок, ви маєте оновити OTRS до версії %s або новіше.',
        'This package can only be installed on OTRS version %s or older.' =>
            'Цей пакунок можна встановити на OTRS версії %s або старше.',
        'This package can only be installed on OTRS version %s or newer.' =>
            'Цей пакунок можна встановити на OTRS версії %s або новіше.',
        'You will receive updates for all other relevant OTRS issues.' =>
            'Ви будете отримувати оновлення для всіх інших питань стосовно OTRS.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Як я можу оновити рівень виправлень якщо у мене немає угоди?',
        'Please find all relevant information within the updating instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'У разі, якщо ви маєте додаткові запитання, ми будемо раді відповісти на них.',
        'Install Package' => 'Установити пакет',
        'Update Package' => '',
        'Continue' => 'Продовжити',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Будь ласка, переконайтеся в тому, що ваша база даних приймає пакунки за розміром більше ніж %s МБ (в даний час приймаються пакунки за розміром до %s МБ). Будь ласка адаптуйте установку max_allowed_packet  вашої бази даних, щоб уникнути помилок.',
        'Install' => 'Установити',
        'Update repository information' => 'Обновити інформацію репозитарія',
        'Cloud services are currently disabled.' => 'Хмарні служби наразі вимкнуті.',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ не може тривати!',
        'Enable cloud services' => 'Дозволити хмарні служби',
        'Update all installed packages' => '',
        'Online Repository' => 'Онлайновий репозитарій',
        'Action' => 'Дія',
        'Module documentation' => 'Документація модуля',
        'Local Repository' => 'Локальний репозитарій',
        'This package is verified by OTRSverify (tm)' => 'Цей пакунок перевірений OTRSverify (tm)',
        'Uninstall' => 'Вилучити',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Пакет розгорнуто некоректно! Будь ласка, перевстановіть пакет.',
        'Reinstall' => 'Переустановити',
        'Features for %s customers only' => 'Функція тільки для клієнтів %s',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'З %s ви можете скористатися наступними додатковими функціями. Будь ласка зв\'яжіться із %s, якщо вам потрібна додаткова інформація.',
        'Package Information' => '',
        'Download package' => 'Скачати пакет',
        'Rebuild package' => 'Перезібрати пакет',
        'Metadata' => 'Метадані',
        'Change Log' => 'Журнал змін',
        'Date' => 'Дата',
        'List of Files' => 'Список файлів',
        'Permission' => 'Права доступу',
        'Download file from package!' => 'Завантажити файл із пакета!',
        'Required' => ' Потрібно',
        'Size' => 'Розмір',
        'Primary Key' => 'Первинний ключ',
        'Auto Increment' => 'Автоматичний приріст',
        'SQL' => 'SQL',
        'File Differences for File %s' => '',
        'File differences for file %s' => 'Файл відмінностей для файлу %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Журнал продуктивності',
        'Range' => 'Діапазон',
        'last' => 'останній',
        'This feature is enabled!' => 'Дана функція активована!',
        'Just use this feature if you want to log each request.' => 'Використовуйте цю функцію, якщо прагнете затягати кожний запит у журнал',
        'Activating this feature might affect your system performance!' =>
            'Включення цієї функції може позначитися на продуктивності вашої системи',
        'Disable it here!' => 'Відключити функцію!',
        'Logfile too large!' => 'Файл журналу занадто великий!',
        'The logfile is too large, you need to reset it' => 'Файл логу занадто великий, необхідно його очистити',
        'Reset' => 'Перезавантажити',
        'Overview' => 'Огляд',
        'Interface' => 'Інтерфейс',
        'Requests' => 'Запитів',
        'Min Response' => 'Мінімальний час відповіді',
        'Max Response' => 'Максимальний час відповіді',
        'Average Response' => 'Середній час відповіді',
        'Period' => 'Період',
        'minutes' => 'хвилин',
        'Min' => 'Мін',
        'Max' => 'Макс',
        'Average' => 'Середнє',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Керування фільтром PostMaster ',
        'Add PostMaster Filter' => 'Додати PostMaster фільтр',
        'Edit PostMaster Filter' => 'Редагувати PostMaster фільтр',
        'Filter for PostMaster Filters' => '',
        'Filter for PostMaster filters' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Для відправки або фільтрації вхідних повідомлень електронної пошти на основі заголовків повідомлень. Також можливе зіставлення з використанням регулярних висловів.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Якщо ви прагнете отфильтровать тільки по адресах електронної пошти, використовуйте EMAILADDRESS:info@example.com у полях From, To або Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'При використанні регулярних висловів, ви також можете використовувати значення зіставлення в () як [***] в дії \'Set\'.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            '',
        'Delete this filter' => 'Вилучити цей фільтр',
        'Do you really want to delete this postmaster filter?' => '',
        'A postmaster filter with this name already exists!' => 'Postmaster фільтр з таким ім\'ям вже існує!',
        'Filter Condition' => 'Умова фільтру',
        'AND Condition' => 'Умова ТА',
        'Search header field' => '',
        'for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Поле має бути регулярним висловом або літеральним словом.',
        'Negate' => 'Заперечення (НІ)',
        'Set Email Headers' => 'Встановити Заголовки електронної пошти',
        'Set email header' => 'Встановити заголовок електронної пошти',
        'with value' => '',
        'The field needs to be a literal word.' => 'Поле має бути літеральним словом.',
        'Header' => 'Заголовок',

        # Template: AdminPriority
        'Priority Management' => 'Керування пріоритетами',
        'Add Priority' => 'Створити пріоритет',
        'Edit Priority' => 'Змінити пріоритет',
        'Filter for Priorities' => '',
        'Filter for priorities' => '',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            '',
        'This priority is used in the following config settings:' => '',

        # Template: AdminProcessManagement
        'Process Management' => 'Керування процессом',
        'Filter for Processes' => 'Фільтр для процесів',
        'Filter for processes' => '',
        'Create New Process' => 'Створити новий процес',
        'Deploy All Processes' => 'Розгорнути всі процеси',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Тут ви можете вивантажити файл конфігурації для імпорту процесу до вашої системи. Файл має бути в форматі .yml, таким як експортується модулем керування процесом.',
        'Upload process configuration' => 'Вивантажити конфігурацію процесу',
        'Import process configuration' => 'Імпортувати конфігурацію процесу',
        'Ready2Adopt Processes' => '',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            '',
        'Import Ready2Adopt process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Щоб створити новий процес Ви можете або імпортувати Процес, що був експортований з іншої системи, або створити цілком новий.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Зміни в процесах тут вплинуть на поведінку системи тільки після синхронізації даних процесу. При синхронізації процесів, нещодавно зроблені зміни будуть записані до конфігурації.',
        'Processes' => 'Процеси',
        'Process name' => 'Ім\'я процесу',
        'Print' => 'Друк',
        'Export Process Configuration' => 'Експорт конфігурації процесу',
        'Copy Process' => 'Копіювання процесу',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Скасувати & закрити',
        'Go Back' => 'Повернутись',
        'Please note, that changing this activity will affect the following processes' =>
            'Зверніть увагу. що зміна цієї активності буде впливати на наступні процеси',
        'Activity' => 'Активність',
        'Activity Name' => 'Ім\'я активності',
        'Activity Dialogs' => 'Діалоги активності',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Ви можете призначити Діалоги Активності на цю Активність шляхом перетягування елементів за допомогою миші зі списку ліворуч у список праворуч.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Впорядковування елементів в списку також можна робити за допомогою "тягни-й-пусти" (drag \'n\' drop).',
        'Filter available Activity Dialogs' => 'Фільтр доступних Діалогів Активності.',
        'Available Activity Dialogs' => 'Доступні Діалоги Активності',
        'Name: %s, EntityID: %s' => 'Ім\'я: %s, EntityID: %s',
        'Create New Activity Dialog' => 'Створити новий Діалог Активності',
        'Assigned Activity Dialogs' => 'Призначені Діалоги Активності',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Зверніть увагу, будь ласка, що змінення цього діалогу активності змінить наступні активності',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Зверніть увагу, будь ласка, що клієнт-користувач не буде мати змогу бачити або використовувати наступні поля: Owner (Власник), Responsible (Відповідач), Lock (Блокування), PendingTime (ЧасЗатримки) та CustomerID (ІдентифікаторКлієнта).',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Поле Queue (Черга) може бути використана клієнтом тільки під час створення нового квитка.',
        'Activity Dialog' => 'Діалог активності',
        'Activity dialog Name' => 'Ім\'я діалогу активності',
        'Available in' => 'Доступне в',
        'Description (short)' => 'Опис (стисло)',
        'Description (long)' => 'Опис (докладно)',
        'The selected permission does not exist.' => 'Вибрані дозволи не існують.',
        'Required Lock' => 'Обов\'язкове блокування',
        'The selected required lock does not exist.' => 'Вибране обов\'язкове блокування не існує.',
        'Submit Advice Text' => 'Надіслати текст поради',
        'Submit Button Text' => 'Надіслати текст кнопки',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Ви можете призначити Поля для цього Діалогу активності шляхом перетягування елементів за допомогою миші з лівого списку до правого. ',
        'Filter available fields' => 'Фільтрувати доступні поля',
        'Available Fields' => 'Доступні поля',
        'Assigned Fields' => 'Призначені поля',
        'Communication Channel' => '',
        'Is visible for customer' => '',
        'Display' => 'Відображення',

        # Template: AdminProcessManagementPath
        'Path' => 'Шлях',
        'Edit this transition' => 'Редагувати цей перехід',
        'Transition Actions' => 'Дії переходу',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Ви можете призначити Дії Переходу до цього Переходу шляхом перетягування елементів за допомогою миші зі списку ліворуч до списку праворуч.',
        'Filter available Transition Actions' => 'Фільтрувати доступні Дії Переходу',
        'Available Transition Actions' => 'Доступні Дії Переходу',
        'Create New Transition Action' => 'Створити Нову Дію Переходу',
        'Assigned Transition Actions' => 'Призначити Перехідні Дії',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Активності',
        'Filter Activities...' => 'Фільтрувати Активності...',
        'Create New Activity' => 'Створити Нову Активність',
        'Filter Activity Dialogs...' => 'Фільтрувати Діалоги Активності...',
        'Transitions' => 'Переходи',
        'Filter Transitions...' => 'Фільтрувати Переходи...',
        'Create New Transition' => 'Створити Новий Перехід',
        'Filter Transition Actions...' => 'Фільтрувати Дії Переходу...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Редагувати Процес',
        'Print process information' => 'Друкувати інформацію про процес',
        'Delete Process' => 'Вилучити Процес',
        'Delete Inactive Process' => 'Вилучити неактивний процес',
        'Available Process Elements' => 'Доступні Елементи Процесу',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Елементи, що перераховані вище в цій бічній панелі, можуть бути переміщені в область полотна праворуч використовуючи "тягни-й-пусти".',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Ви можете розмістити Активності на площі полотна, щоб призначити Активність Процесу.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Щоб призначити Діалог Активності до Активності, перетягніть елемент Діалогу Активності з цієї бічної панелі на Активність, що розташована в області полотна.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Ви можете створити зв\'язок між двома Активностями перетягуючи елемент Перетворення на Початкову  Активність з\'єднання. Після цього ви можете переміщати вільний кінець стрілки до Кінцевої Активності.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Дії можуть бути віднесені до Переходу перетягуючи Елемент Дії на позначку Переходу.',
        'Edit Process Information' => 'Редагувати Інформацію про Процес',
        'Process Name' => 'Ім\'я Процесу',
        'The selected state does not exist.' => 'Вибраного стану не існує.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Додати та Редагувати Активності, Діалоги Активності та Переходи',
        'Show EntityIDs' => 'Показати EntityIDs',
        'Extend the width of the Canvas' => 'Розсунути довжину Полотна',
        'Extend the height of the Canvas' => 'Розсунути висоту Полотна',
        'Remove the Activity from this Process' => 'Вилучити Активність з цього Процесу',
        'Edit this Activity' => 'Редагувати Активність',
        'Save Activities, Activity Dialogs and Transitions' => 'Переглянути Активності, Діалоги Активності та Переходи',
        'Do you really want to delete this Process?' => 'Ви насправді хочете вилучити цей Процес?',
        'Do you really want to delete this Activity?' => 'Ви насправді хочете вилучити цю Активність?',
        'Do you really want to delete this Activity Dialog?' => 'Ви насправді хочете вилучити цей Діалог Активності?',
        'Do you really want to delete this Transition?' => 'Ви насправді хочете вилучити цей Перехід?',
        'Do you really want to delete this Transition Action?' => 'Ви насправді хочете вилучити цю Дію Переходу?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Ви дійсно хочете вилучити цю активність з цього полотна? Це може бути скасовано лише шляхом виходу з цього екрану без збереження. ',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Ви дійсно хочете вилучити цей перехід з полотна? Це може бути скасовано лише шляхом виходу з цього екрану без збереження.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'На цьому екрані ви маєте змогу створити новий процес. Для того щоб створити новий процес доступним для користувачів, будь ласка, переконайтеся що його встановлено в стан "Активний" та проведено синхронізацію після завершення вашої роботи.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'скасувати & закрити',
        'Start Activity' => 'Початкова Активність',
        'Contains %s dialog(s)' => 'Містить %s діалог(и)',
        'Assigned dialogs' => 'Призначені діалоги',
        'Activities are not being used in this process.' => 'Активності не використовуються у цьому процесі.',
        'Assigned fields' => 'Призначені поля',
        'Activity dialogs are not being used in this process.' => 'Діалоги активності не використовуються у цьому процесі.',
        'Condition linking' => 'Умова з\'єднання',
        'Transitions are not being used in this process.' => 'Переходи не використовуються у цьому процесі.',
        'Module name' => 'Ім\'я модуля',
        'Transition actions are not being used in this process.' => 'Переходові дії не використовуються у цьому процесі.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Зверніть увагу, що зміна цього переходу буде впливати на наступні процеси.',
        'Transition' => 'Перехід',
        'Transition Name' => 'Ім\'я Переходу',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Зверніть увагу, що зміна цієї переходової дії вплине на наступні процеси',
        'Transition Action' => 'Переходова Дія',
        'Transition Action Name' => 'Ім\'я Переходової Дії',
        'Transition Action Module' => 'Модуль Переходової Дії',
        'Config Parameters' => 'Параметри Конфігурації',
        'Add a new Parameter' => 'Додати новий Параметр',
        'Remove this Parameter' => 'Вилучити цей Параметр',

        # Template: AdminQueue
        'Queue Management' => '',
        'Add Queue' => 'Додати Черга',
        'Edit Queue' => 'Змінити черга',
        'Filter for Queues' => 'Фільтр для Черг',
        'Filter for queues' => '',
        'A queue with this name already exists!' => 'Черга з таким ім\'ям вже існує!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            '',
        'Sub-queue of' => 'Підчерга черги',
        'Unlock timeout' => 'Строк блокування',
        '0 = no unlock' => '0 — без блокування',
        'hours' => 'годин',
        'Only business hours are counted.' => 'З обліком тільки робочого часу.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Якщо агент блокує квиток та не закриває його до того, як  буде вичерпаний період розблокування, квиток буде розблокований та доступний для інших агентів.',
        'Notify by' => 'Повідомлення від',
        '0 = no escalation' => '0 — без ескалації',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Якщо не буде додано контакт клієнта, або зовнішня електронна адреса чи телефон до нового квитка перед тим як зазначений тут час буде вичерпано, квиток буде підвищено.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Якщо додається стаття, наприклад, спостерігання за допомогою електронної скриньки або порталу клієнта, час поновлення підвищення (ескалації) буде скинуто. Якщо немає контакту клієнта або адреси зовнішньої скриньки чи номеру телефону, доданих до квитка до вичерпання зазначеного тут часу, квиток буде підвищено (ескаловано).',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Якщо заявка не закрита до зазначеного тут часу завершення, вона ескалюється.',
        'Follow up Option' => 'Параметри автовідповіді',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Вказує, якщо слідувати до закритих квитків то це може призвести до їх повторного відкриття, тому буде відхилено або направлено до створення нового квитка.',
        'Ticket lock after a follow up' => 'Блокувати заявку після одержання відповіді',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Якщо квиток закритий та клієнт намагається встановити стеження, квиток буде заблокований для старого власника.',
        'System address' => 'Адреса системи',
        'Will be the sender address of this queue for email answers.' => 'Установка адреси відправника для відповідей у цій черзі.',
        'Default sign key' => 'Типовий ключ підпису',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            '',
        'Salutation' => 'Привітання',
        'The salutation for email answers.' => 'Вітання для листів',
        'Signature' => 'Підпис',
        'The signature for email answers.' => 'Підпис для листів',
        'This queue is used in the following config settings:' => '',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Керування Залежностями Авто-Відповідей Черги',
        'Change Auto Response Relations for Queue' => 'Змінити Залежності Авто-Відповідей для Черги',
        'This filter allow you to show queues without auto responses' => 'Цей фільтр дозволяє вам побачити черги без авто-відповідей',
        'Queues without Auto Responses' => '',
        'This filter allow you to show all queues' => 'Цей фільтр дозволяє вам побачити всі черги',
        'Show All Queues' => '',
        'Auto Responses' => 'Автовідповіді',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Керувати Залежностями Черг-Шаблонів',
        'Filter for Templates' => 'Фільтр по шаблонам',
        'Filter for templates' => '',
        'Templates' => 'Шаблони',

        # Template: AdminRegistration
        'System Registration Management' => 'Керування Регистрацією Системи',
        'Edit System Registration' => '',
        'System Registration Overview' => '',
        'Register System' => '',
        'Validate OTRS-ID' => '',
        'Deregister System' => 'Скасувати реєстрацію Системи',
        'Edit details' => 'Редагувати деталі',
        'Show transmitted data' => 'Показати передані дані',
        'Deregister system' => 'Скасувати реєстрацію системи',
        'Overview of registered systems' => 'Огляд зареєстрованих систем',
        'This system is registered with OTRS Group.' => 'Ця система реєстрована OTRS Group.',
        'System type' => 'Тип системи',
        'Unique ID' => 'Унікальний ID',
        'Last communication with registration server' => 'Останній зв\'язок із сервером реєстрації',
        'System Registration not Possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Будь ласка зверніть увагу, що ви не можете зареєструвати вашу систему якщо фонова програма OTRS не працює правильно!',
        'Instructions' => 'Інструкції',
        'System Deregistration not Possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Зверніть увагу, що ви не можете скасувати реєстрацію вашої системи якщо ви використовуєте %s або маєте чинну угоду на обслуговування.',
        'OTRS-ID Login' => 'OTRS-ID Ім\'я',
        'Read more' => 'Докладніше',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Ви маєте увійти з вашим ім\'ям OTRS-ID, щоб зареєструвати вашу систему.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Ваш OTRS-ID це адреса поштової скриньки, якою ви скористалися для реєстрації на сайті OTRS.com',
        'Data Protection' => 'Захист Даних',
        'What are the advantages of system registration?' => 'Які переваги реєстрації системи?',
        'You will receive updates about relevant security releases.' => 'Ви будете отримувати нову інформацію про відповідні оновлення безпеки.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'З вашою реєстрацією ви можемо поліпшити наші послуги для вас, тому що в нас є вся необхідна інформація.',
        'This is only the beginning!' => 'Це тільки початок!',
        'We will inform you about our new services and offerings soon.' =>
            'Ми будемо інформувати вас про наші нові послуги та найновіші пропозиції.',
        'Can I use OTRS without being registered?' => 'Чи можу я використовувати OTRS без реєстрації?',
        'System registration is optional.' => 'Реєстрація системи не є обов\'язковою.',
        'You can download and use OTRS without being registered.' => 'Ви можете завантажити та використовувати OTRS без реєстрації.',
        'Is it possible to deregister?' => 'Чи можна скасувати реєстрацію?',
        'You can deregister at any time.' => 'Ви можете скасувати реєстрацію у будь-який час.',
        'Which data is transfered when registering?' => 'Які дані передаються під час реєстрації?',
        'A registered system sends the following data to OTRS Group:' => 'Зареєстрована система надсилає наступні дані до OTRS Group:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Повне доменне ім\'я (FQDN), версія OTRS, База даних, Операційна система та версія Perl.',
        'Why do I have to provide a description for my system?' => 'Чому я маю надати опис для моєї системи?',
        'The description of the system is optional.' => 'Опис системи не є обов\'язковим.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Надані вами опис та тип системи допоможе нам визначати та керувати подробицями ваших зареєстрованих систем.',
        'How often does my OTRS system send updates?' => 'Як часто моя OTRS система відправляє оновлення?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Ваша система буде відправляти оновлення на реєстраційний сервер через регулярні проміжки часу.',
        'Typically this would be around once every three days.' => 'Типово, це буде приблизно один раз в три дні.',
        'If you deregister your system, you will lose these benefits:' =>
            'Якщо скасувати реєстрацію вашої системи, ви втратите ці переваги:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Ви маєте увійти під своїм OTRS-ID щоб скасувати реєстрацію вашої системи.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'У вас ще немає OTRS-ID?',
        'Sign up now' => 'Увійти',
        'Forgot your password?' => 'Забули свій пароль?',
        'Retrieve a new one' => 'Отримати новий',
        'Next' => 'Далі',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Ці дані найчастіше передаються до OTRS Group під час реєстрації системи.',
        'Attribute' => 'Атрибут',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'Версій OTRS',
        'Operating System' => 'Операційна Система',
        'Perl Version' => 'Версія Perl',
        'Optional description of this system.' => 'Додатковий опис цієї системи.',
        'Register' => 'Реєстрація',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Продовжуючи далі, ви скасуєте реєстрацію системи від OTRS Group. ',
        'Deregister' => 'Скасувати реєстрацію',
        'You can modify registration settings here.' => 'Тут ви можете змінити налаштування реєстрації.',
        'Overview of Transmitted Data' => '',
        'There is no data regularly sent from your system to %s.' => 'Немає даних, що регулярно відправляються з вашої системи до %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Наступні дані надсилаються мінімум раз на 3 дні з вашої системи до %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Дані будуть надіслані в формати JSON крізь захищене з\'єднання https.',
        'System Registration Data' => 'Система реєстрації даних',
        'Support Data' => 'Дані підтримки',

        # Template: AdminRole
        'Role Management' => 'Керування ролями',
        'Add Role' => 'Додати роль',
        'Edit Role' => 'Змінити роль',
        'Filter for Roles' => 'Фільтр для ролей',
        'Filter for roles' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Створіть роль і додайте в неї групи. Потім розподілите ролі по користувачах.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Ролі не визначені. Будь ласка, використовуйте кнопку \'Додати\' для створення нової ролі.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Керувати Role-Group відносинами',
        'Roles' => 'Ролі',
        'Select the role:group permissions.' => 'Виберіть дозволи role:group',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Якщо нічого не вибрано, для цієї групи немає жодного дозволу (квитки не будуть доступні для цієї ролі).',
        'Toggle %s permission for all' => 'Перемикнути %s дозвіл для всіх',
        'move_into' => 'перемістити',
        'Permissions to move tickets into this group/queue.' => 'Права на переміщення заявок у цю групу/черга',
        'create' => 'створення',
        'Permissions to create tickets in this group/queue.' => 'Права на створення заявок у цій групі/черги',
        'note' => 'Замітка',
        'Permissions to add notes to tickets in this group/queue.' => 'Дозвіл додавати замітки до квитків в цій групі/черзі.',
        'owner' => 'власник',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Дозволи змінювати власника квитків в цій групі/черзі.',
        'priority' => 'пріоритет',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Права на зміну пріоритету заявок у цій групі/черги',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Керування Залежностями Агент-Роль',
        'Add Agent' => 'Додати Агента',
        'Filter for Agents' => 'Фільтри для Агентів',
        'Filter for agents' => '',
        'Agents' => 'Агенти',
        'Manage Role-Agent Relations' => 'Керування Залежностями Роль-Агент',

        # Template: AdminSLA
        'SLA Management' => 'Керування SLA',
        'Edit SLA' => 'Змінити SLA',
        'Add SLA' => 'Додати SLA',
        'Filter for SLAs' => '',
        'Please write only numbers!' => 'Будь ласка, пишіть тільки цифри!',

        # Template: AdminSMIME
        'S/MIME Management' => 'Керування S/MIME',
        'Add Certificate' => 'Додати сертифікат',
        'Add Private Key' => 'Додати закритий ключ',
        'SMIME support is disabled' => 'Підтримка SMIME відключена',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'Для того, щоб мати можливість використовувати SMIME в OTRS, ви повинні спочатку його дозволити.',
        'Enable SMIME support' => 'Дозволити підтримку ',
        'Faulty SMIME configuration' => 'Неправильне налаштування SMIME ',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'Підтримку SMIME увімкнено, але відповідні налаштування містять помилки. Будь ласка, перевірте налаштування за допомогою кнопки, що розташована нижче.',
        'Check SMIME configuration' => 'Перевірка налаштувань SMIME',
        'Filter for Certificates' => '',
        'Filter for certificates' => 'Фільтр сертифікатів',
        'To show certificate details click on a certificate icon.' => 'Щоб показати деталі сертифікату, натисніть на його значок.',
        'To manage private certificate relations click on a private key icon.' =>
            'За для керування залежностями приватного сертифікату натисніть на значок приватного ключа.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Тут ви можете додати залежності до вашого приватного сертифікату, вони будуть вбудовані в підпис S/MIME щоразу, коли ви використовуєте цей сертифікат, щоб підписати лист.',
        'See also' => 'Див. також',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Ви можете редагувати сертифікати й закриті ключі прямо на файловій системі',
        'Hash' => 'Хеш',
        'Create' => 'Створити',
        'Handle related certificates' => 'Обробляти залежні сертифікати',
        'Read certificate' => 'Прочитати сертифікат',
        'Delete this certificate' => 'Вилучити сертифікат',
        'File' => 'Файл',
        'Secret' => 'Пароль',
        'Related Certificates for' => 'Пов\'язаний сертифікат із',
        'Delete this relation' => 'Вилучити цю залежність',
        'Available Certificates' => 'Доступні Сертифікати',
        'Filter for S/MIME certs' => 'Фільтр S/MIME сертифікатів',
        'Relate this certificate' => 'Зіставити цей сертифікат',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME-сертифікат',
        'Close this dialog' => 'Закрити цей діалог',
        'Certificate Details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Керування вітаннями',
        'Add Salutation' => 'Додати вітання',
        'Edit Salutation' => 'Редагувати вітання',
        'Filter for Salutations' => '',
        'Filter for salutations' => '',
        'e. g.' => 'наприклад,',
        'Example salutation' => 'Приклад вітання',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Після установки системи звичайно відразу ж включають безпечний режим.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Якщо безпечний режим не активований, активуйте його за допомогою SysConfig, тому що ваш додаток вже запущений.',

        # Template: AdminSelectBox
        'SQL Box' => 'Запит SQL',
        'Filter for Results' => '',
        'Filter for results' => '',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Тут ви можете ввести SQL, щоб надіслати його безпосередньо до бази даних програми. Цим неможливо змінити вміст таблиць - дозволені тільки select запити.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Тут ви можете ввести SQL щоб надіслати його безпосередньо до бази даних програми.',
        'Options' => 'Опції',
        'Only select queries are allowed.' => 'Дозволені тільки select запити.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Синтаксис вашого SQL запиту містить помилку. Будь ласка, перевірте його.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Існує принаймні, один пропущений параметр за прив\'язки. Будь ласка, перевірте його.',
        'Result format' => 'Формат результату',
        'Run Query' => 'Запустити чергу',
        '%s Results' => '',
        'Query is executed.' => 'Запит виконується.',

        # Template: AdminService
        'Service Management' => 'Керування сервісами',
        'Add Service' => 'Додати Сервіс',
        'Edit Service' => 'Змінити Сервіс',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Максимальна довжина імені служби 200 символів (з під-службами).',
        'Sub-service of' => 'Підсервіс сервісу',

        # Template: AdminSession
        'Session Management' => 'Керування сеансами',
        'Detail Session View for %s (%s)' => '',
        'All sessions' => 'Усі сеанси',
        'Agent sessions' => 'Сеанси агента',
        'Customer sessions' => 'Сеанси клієнта',
        'Unique agents' => 'Унікальні агенти',
        'Unique customers' => 'Унікальні клієнти',
        'Kill all sessions' => 'Завершити всі сеанси',
        'Kill this session' => 'Завершити сеанс',
        'Filter for Sessions' => '',
        'Filter for sessions' => '',
        'Session' => 'Сеанс',
        'User' => 'Користувач',
        'Kill' => 'Завершити',
        'Detail View for SessionID: %s - %s' => '',

        # Template: AdminSignature
        'Signature Management' => 'Керування підписами',
        'Add Signature' => 'Додати Підпис',
        'Edit Signature' => 'Змінити підпис',
        'Filter for Signatures' => '',
        'Filter for signatures' => '',
        'Example signature' => 'Приклад підпису',

        # Template: AdminState
        'State Management' => 'Керування станами',
        'Add State' => 'Додати стан',
        'Edit State' => 'Змінити стан',
        'Filter for States' => '',
        'Filter for states' => '',
        'Attention' => 'Увага',
        'Please also update the states in SysConfig where needed.' => 'Прохання також оновити стан в SysConfig де це необхідно.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'State type' => 'Тип стану',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            '',
        'This state is used in the following config settings:' => '',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'Передача даних по підтримці до OTRS Group не представляється можливим!',
        'Enable Cloud Services' => 'Дозволити Хмарні Служби',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Ці дані надсилаються до OTRS Group на регулярній основі. Щоб припинити передачу цієї інформації, будь ласка, поновіть реєстрацію системи.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Ви можете вручну викликати передачу Даних Підтримки натиснувши на цю кнопку:',
        'Send Update' => 'Надіслати Оновлення',
        'Currently this data is only shown in this system.' => 'Наразі ці дані показані тільки в цій системі.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'В\'язка підтримки (що містить: відомості про реєстрацію системи, дані підтримки, перелік встановлених пакунків та всі локально змінені файли вихідного коду) може бути згенерована шляхом натискання на цю кнопку:',
        'Generate Support Bundle' => 'Створити В\'язку Підтримки',
        'The Support Bundle has been Generated' => '',
        'Please choose one of the following options.' => 'Будь ласка, виберіть один з наступних варіантів.',
        'Send by Email' => 'Надіслати електронною поштою',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'В\'язка підтримки занадто велика, щоб відправити її електронною поштою, ця опція буде вимкнена.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Адреса електронної пошти для цього користувача не є чинною, цю опцію буде скасовано.',
        'Sending' => 'Відправник',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'В\'язку підтримки буде надіслано до OTRS Group електронною поштою автоматично.',
        'Download File' => 'Завантаження файлу',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Файл, що містить в\'язку підтримки, буде завантажено до локальної системи. Будь ласка, збережіть файл та надішліть його до OTRS Group іншим шляхом.',
        'Error: Support data could not be collected (%s).' => 'Помилка: дані підтримки не можуть бути зібрані (%s).',
        'Details' => 'Подробиці',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Керування системними адресами електронної пошти',
        'Add System Email Address' => 'Додати системну Email адресу',
        'Edit System Email Address' => 'Коригувати системну Email адресу',
        'Add System Address' => '',
        'Filter for System Addresses' => '',
        'Filter for system addresses' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Усі вхідні повідомлення з цією адресою в полі Кому або Копія буде перенаправлена до вибраної черги.',
        'Email address' => 'Email адреса',
        'Display name' => 'Відображуване ім\'я',
        'This email address is already used as system email address.' => 'Ця поштова скринька вже використовується як системна.',
        'The display name and email address will be shown on mail you send.' =>
            'Це ім\'я та email адреса будуть показані у ваших відправлених лістах',
        'This system address cannot be set to invalid.' => '',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            '',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => '',
        'System configuration' => '',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            '',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            '',
        'Find out how to use the system configuration by reading the %s.' =>
            '',
        'Search in all settings...' => '',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            '',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => '',
        'Help' => '',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            '',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            '',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            '',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            '',
        'Please review the changed settings and deploy afterwards.' => '',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            '',
        'Changes Overview' => '',
        'There are %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to basic mode to deploy settings only changed by you.' =>
            '',
        'You have %s changed settings which will be deployed in this run.' =>
            '',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            '',
        'There are no settings to be deployed.' => '',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            '',
        'Deploy selected changes' => '',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            '',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => '',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            '',
        'Upload system configuration' => '',
        'Import system configuration' => '',
        'Download current configuration settings of your system in a .yml file.' =>
            '',
        'Include user settings' => '',
        'Export current configuration' => '',

        # Template: AdminSystemConfigurationSearch
        'Search for' => '',
        'Search for category' => '',
        'Settings I\'m currently editing' => '',
        'Your search for "%s" in category "%s" did not return any results.' =>
            '',
        'Your search for "%s" in category "%s" returned one result.' => '',
        'Your search for "%s" in category "%s" returned %s results.' => '',
        'You\'re currently not editing any settings.' => '',
        'You\'re currently editing %s setting(s).' => '',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Категорія',
        'Run search' => 'Запустити пошук',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => '',
        'View single Setting: %s' => '',
        'Go back to Deployment Details' => '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Керування Обслуговуванням Системи',
        'Schedule New System Maintenance' => 'Запланувати Нове Обслуговування Системи',
        'Filter for System Maintenances' => '',
        'Filter for system maintenances' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Запланувати період обслуговування системи для оголошення попередження Агентам та Клієнтам, що система не буде працювати впродовж визначеного часу.',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'За деякий час до цього обслуговування системи, користувачі будуть отримувати сповіщення на кожному екрані, оголошуючи про цей факт.',
        'Stop date' => 'Дата закінчення',
        'Delete System Maintenance' => 'Вилучити Обслуговування Системи',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => '',
        'Edit System Maintenance Information' => 'Редагувати Інформацію Обслуговування Системи',
        'Date invalid!' => 'Неприпустима дата!',
        'Login message' => 'Повідомлення входу',
        'This field must have less then 250 characters.' => '',
        'Show login message' => 'Показати повідомлення входу',
        'Notify message' => 'Повідомлення сповіщення',
        'Manage Sessions' => 'Керування сесіями',
        'All Sessions' => 'Всі сесії',
        'Agent Sessions' => 'Сесії Агента',
        'Customer Sessions' => 'Сесії Клієнта',
        'Kill all Sessions, except for your own' => 'Припинити всі Сесії за винятком вашої',

        # Template: AdminTemplate
        'Template Management' => '',
        'Add Template' => 'Додати шаблон',
        'Edit Template' => 'Редагувати шаблон',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Шаблон являє собою типовий текст, який допомагає вашим агентам швидше писати квитки, відповідати на них або пересилати.',
        'Don\'t forget to add new templates to queues.' => 'Не забувайте додавати нові шаблони до черг.',
        'Attachments' => 'Прикріплення',
        'Delete this entry' => 'Вилучити цей запис',
        'Do you really want to delete this template?' => 'Ви дійсно бажаєте вилучити цей шаблон?',
        'A standard template with this name already exists!' => 'Стандартний шаблон з таким ім\'ям вже існує!',
        'Template' => 'Зразок',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Створення типу шаблонів підтримує тільки ці смарт-теги',
        'Example template' => 'Приклад шаблону',
        'The current ticket state is' => 'Поточний стан заявки',
        'Your email address is' => 'Ваш email адреса ',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => '',
        'Toggle active for all' => 'Увімкнути активність для всіх',
        'Link %s to selected %s' => 'Поєднати %s до вибраного %s',

        # Template: AdminType
        'Type Management' => 'Керування типами заявок',
        'Add Type' => 'Додати тип',
        'Edit Type' => 'Редагувати тип',
        'Filter for Types' => '',
        'Filter for types' => '',
        'A type with this name already exists!' => 'Тип з таким ім\'ям вже існує!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            '',
        'This type is used in the following config settings:' => '',

        # Template: AdminUser
        'Agent Management' => 'Керування агентами',
        'Edit Agent' => 'Редагувати Агента',
        'Edit personal preferences for this agent' => '',
        'Agents will be needed to handle tickets.' => 'Для обробки квитків будуть необхідні агенти.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Не забудьте додати нового агента до груп та/або ролей!',
        'Please enter a search term to look for agents.' => 'Будь ласка, введіть слово для пошуку, щоб знайти агентів.',
        'Last login' => 'Останній вхід',
        'Switch to agent' => 'Переключитись до агента',
        'Title or salutation' => 'Назва або привітання',
        'Firstname' => 'Ім\'я',
        'Lastname' => 'Прізвище',
        'A user with this username already exists!' => 'Користувач з таким ім\'ям вже існує!',
        'Will be auto-generated if left empty.' => 'Буде автоматично створено, якщо залишити порожнім.',
        'Mobile' => 'Мобільний телефон',
        'Effective Permissions for Agent' => '',
        'This agent has no group permissions.' => '',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            '',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Керувати залежностями Агент-Група',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Огляд порядку денного',
        'Manage Calendars' => 'керувати календарями',
        'Add Appointment' => 'Додати подію',
        'Today' => 'Сьогодні',
        'All-day' => 'Всі дні',
        'Repeat' => 'Повторити',
        'Notification' => 'Повідомлення',
        'Yes' => 'Так',
        'No' => 'Ні',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Календарі не знайдені. Будь ласка, спочатку додайте календар за допомогою сторінки Управління календарями',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Додати нову Подію',
        'Calendars' => 'Календарі',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Базова інформація',
        'Date/Time' => 'Дата/Час',
        'Invalid date!' => 'Недійсна дата!',
        'Please set this to value before End date.' => 'Будь ласка встановіть це перед датою заершення',
        'Please set this to value after Start date.' => 'Будь ласка встановіть це перед датою початку',
        'This an occurrence of a repeating appointment.' => 'Цей випадок повторюваної події',
        'Click here to see the parent appointment.' => 'Натисніть сюди, щоб побачити батьківську Подію',
        'Click here to edit the parent appointment.' => 'Натисніть тут для редагування батьківського календаря',
        'Frequency' => 'Частота',
        'Every' => 'Кожні',
        'day(s)' => 'днів',
        'week(s)' => 'тижнів',
        'month(s)' => 'місяців',
        'year(s)' => 'років',
        'On' => 'Ввімкнено',
        'Monday' => 'Понеділок',
        'Mon' => 'Пн',
        'Tuesday' => 'Вівторок',
        'Tue' => 'Вт',
        'Wednesday' => 'Середа',
        'Wed' => 'Ср',
        'Thursday' => 'Четвер',
        'Thu' => 'Чт',
        'Friday' => 'П\'ятниця',
        'Fri' => 'Пт',
        'Saturday' => 'Субота',
        'Sat' => 'Сб',
        'Sunday' => 'Неділя',
        'Sun' => 'Нд',
        'January' => 'Січень',
        'Jan' => 'Січ.',
        'February' => 'Лютий',
        'Feb' => 'Лют.',
        'March' => 'Березень',
        'Mar' => 'Бер.',
        'April' => 'Квітень',
        'Apr' => 'Квіт.',
        'May_long' => 'Травень',
        'May' => 'Трав.',
        'June' => 'Червень',
        'Jun' => 'Черв.',
        'July' => 'Липень',
        'Jul' => 'Лип.',
        'August' => 'Серпень',
        'Aug' => 'Серп.',
        'September' => 'Вересень',
        'Sep' => 'Вер.',
        'October' => 'Жовтень',
        'Oct' => 'Жовт.',
        'November' => 'Листопад',
        'Nov' => 'Лист.',
        'December' => 'Грудень',
        'Dec' => 'Груд.',
        'Relative point of time' => 'Відносна часова точка',
        'Link' => 'Зв\'язати',
        'Remove entry' => 'Вилучити запис',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Інформаційний центр Клієнта',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Користувач клієнта',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Примітка: Клієнт не є чинним!',
        'Start chat' => 'Почати спілкування',
        'Video call' => 'Відео виклик',
        'Audio call' => 'Аудіо виклик',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => '',
        'Search for recipients and add the results as \'%s\'.' => '',
        'Search template' => 'Шаблон пошуку',
        'Create Template' => 'Створити шаблон',
        'Create New' => 'Створити новий',
        'Save changes in template' => 'Зберегти зміни в шаблоні',
        'Filters in use' => 'Фільтри що використовуються',
        'Additional filters' => 'Додаткові фільтри',
        'Add another attribute' => 'Додати ще атрибут',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            '',
        '(e. g. Term* or *Term*)' => '',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Вибрати всі',
        'The customer user is already selected in the ticket mask.' => '',
        'Select this customer user' => '',
        'Add selected customer user to' => '',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Змінити параметри пошуку',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS демон це фоновий процес, що виконує асинхронні завдання, на кшталт ввімкнення підвищення квитка, надсилання пошти тощо.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'Демон OTRS, що працює, є обов\'язковою умовою для коректної роботи системи.',
        'Starting the OTRS Daemon' => 'Запуск OTRS демона.',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'Переконайтесь в тому, що файл \'%s\' існує (без розширення .dist). Це заплановане завдання буде перевіряти кожні 5 хвилин чи запущений демон OTRS та запустить його за потреби.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'Виконайте \'%s start\' щоб впевнитись в тому, заплановані завдання користувача \'otrs\' активні.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'Після 5 хвилин, переконайтеся, що OTRS демон працює в системі (\'bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Панель',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Нова Подія',
        'Tomorrow' => 'Завтра',
        'Soon' => 'Скоро',
        '5 days' => '5 днів',
        'Start' => 'Початок',
        'none' => 'немає',

        # Template: AgentDashboardCalendarOverview
        'in' => 'в',

        # Template: AgentDashboardCommon
        'Save settings' => 'Зберегти налаштування',
        'Close this widget' => 'Закрити цей віджет',
        'more' => 'далі',
        'Available Columns' => 'Доступні колонки',
        'Visible Columns (order by drag & drop)' => 'Видимі стовпці (упорядковуйте шляхом тягни-й-пусти)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => '',
        'Open' => 'Відкриті',
        'Closed' => 'Закриті',
        '%s open ticket(s) of %s' => '%s відкритий квиток(-ки) %s',
        '%s closed ticket(s) of %s' => '%s закритий квиток(-ки) %s',
        'Edit customer ID' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Підвищені квитки',
        'Open tickets' => 'Відкриті заявки',
        'Closed tickets' => 'Закриті заявки',
        'All tickets' => 'Усі заявки',
        'Archived tickets' => 'Архівовані заявки',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => '',
        'Phone ticket' => 'Телефонний квиток',
        'Email ticket' => 'Поштовий квиток',
        'New phone ticket from %s' => 'Новий телефонний квиток від %s',
        'New email ticket to %s' => 'Новий поштовий квиток від %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s доступний',
        'Please update now.' => 'Обновите зараз',
        'Release Note' => 'Примітка до релізу',
        'Level' => 'Рівень',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Опубліковане %s',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Конфігурація цього статистичного віджета містить помилки, будь ласка, перевірте параметри.',
        'Download as SVG file' => 'Завантажити як SVG-файл',
        'Download as PNG file' => 'Завантажити як PNG-файл',
        'Download as CSV file' => 'Завантажити як CSV-файл',
        'Download as Excel file' => 'Завантажити як файл Екселю',
        'Download as PDF file' => 'Завантажити як PDF-файл',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Будь ласка, виберіть правильний графічний вихідний формат в конфігурації цього віджета.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Зміст цієї статистики буде приготовлена для вас, будь ласка, зачекайте.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Ця статистика наразі не може бути використана тому що її конфігурація має бути виправлена адміністратором статистики.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => '',
        'Accessible for customer user' => '',
        'My locked tickets' => 'Мої заблоковані заявки',
        'My watched tickets' => 'Квитки за якими я спостерігаю',
        'My responsibilities' => 'Мої обов\'язки',
        'Tickets in My Queues' => 'Заявки в моїй черзі',
        'Tickets in My Services' => 'Заявки в Моїх Сервісах',
        'Service Time' => 'Час обслуговування',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => 'не при справах',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'до',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Для того, щоб прийняти якісь новини, ліцензії або деякі зміни.',
        'Yes, accepted.' => '',

        # Template: AgentLinkObject
        'Manage links for %s' => '',
        'Create new links' => '',
        'Manage existing links' => '',
        'Link with' => '',
        'Start search' => '',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            '',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => 'Виявлено несанкційоване використання %s ',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Змінити налаштування',
        'Personal Preferences' => '',
        'Preferences' => 'Налаштування',
        'Please note: you\'re currently editing the preferences of %s.' =>
            '',
        'Go back to editing this agent' => '',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            '',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            '',
        'Dynamic Actions' => '',
        'Filter settings...' => '',
        'Filter for settings' => '',
        'Save all settings' => '',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            '',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            '',
        'Off' => 'Вимкнено',
        'End' => 'Закінчення',
        'This setting can currently not be saved.' => '',
        'This setting can currently not be saved' => '',
        'Save this setting' => '',
        'Did you know? You can help translating OTRS at %s.' => 'Ви можете допомогти перекласти OTRD в %s.',

        # Template: SettingsList
        'Reset to default' => '',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            '',
        'Did you know?' => '',
        'You can change your avatar by registering with your email address %s on %s' =>
            '',

        # Template: AgentSplitSelection
        'Target' => '',
        'Process' => 'Процес',
        'Split' => 'Розділити',

        # Template: AgentStatisticsAdd
        'Statistics Management' => '',
        'Add Statistics' => '',
        'Read more about statistics in OTRS' => '',
        'Dynamic Matrix' => 'Динамічна Матриця',
        'Each cell contains a singular data point.' => '',
        'Dynamic List' => 'Динамічний список',
        'Each row contains data of one entity.' => '',
        'Static' => 'Статика',
        'Non-configurable complex statistics.' => '',
        'General Specification' => 'Загальні Характеристики',
        'Create Statistic' => 'Створити Статистику',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => '',
        'Run now' => 'Запустити зараз',
        'Statistics Preview' => 'Перегляд статистики',
        'Save Statistic' => '',

        # Template: AgentStatisticsImport
        'Import Statistics' => '',
        'Import Statistics Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Статистика',
        'Run' => 'Запустити',
        'Edit statistic "%s".' => 'Редагувати статистику "%s".',
        'Export statistic "%s"' => 'Експортувати статистику "%s"',
        'Export statistic %s' => 'Експортувати статистику %s',
        'Delete statistic "%s"' => 'Вилучити статистику "%s"',
        'Delete statistic %s' => 'Вилучити статистику %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => '',
        'View Statistics' => '',
        'Statistics Information' => '',
        'Created by' => 'Створено',
        'Changed by' => 'Змінено',
        'Sum rows' => 'Сума рядків',
        'Sum columns' => 'Сума стовпців',
        'Show as dashboard widget' => 'Відобразити як віджет панелі',
        'Cache' => 'Кеш',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Ця статистика містить помилки налаштування та наразі не може використовуватись.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Змінити Вільний Текст ',
        'Change Owner of %s%s%s' => 'Зміна Власника: %s%s%s',
        'Close %s%s%s' => 'Закрити %s%s%s',
        'Add Note to %s%s%s' => 'Додати замітку до %s%s%s',
        'Set Pending Time for %s%s%s' => 'Встановити Відкладений Час для ',
        'Change Priority of %s%s%s' => 'Змінити Пріоритет ',
        'Change Responsible of %s%s%s' => 'Змінити Відповідального',
        'All fields marked with an asterisk (*) are mandatory.' => 'Всі поля, позначені (*) є обов\'язковими.',
        'The ticket has been locked' => 'Заявка заблокована',
        'Undo & close' => 'Скасувати та закрити',
        'Ticket Settings' => 'Настроювання заявок',
        'Queue invalid.' => '',
        'Service invalid.' => 'Служба недійсна.',
        'SLA invalid.' => '',
        'New Owner' => 'Новий власник',
        'Please set a new owner!' => 'Будь ласка вкажіть нового власника!',
        'Owner invalid.' => '',
        'New Responsible' => 'Новий Відповідальний',
        'Please set a new responsible!' => '',
        'Responsible invalid.' => '',
        'Next state' => 'Наступний стан',
        'State invalid.' => '',
        'For all pending* states.' => 'Для всіх станів, що очкують*.',
        'Add Article' => 'Додати замітку',
        'Create an Article' => 'Створити Статтю',
        'Inform agents' => 'Інформувати агентів',
        'Inform involved agents' => 'Інформувати залучених агентів',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Тут ви можете вибрати додаткових агентів, що мають отримувати повідомлення стосовно нової статті.',
        'Text will also be received by' => 'Текст буде також отриманий',
        'Text Template' => 'Шаблон тексту',
        'Setting a template will overwrite any text or attachment.' => 'Налаштування шаблону перепише будь-який текст або вкладення.',
        'Invalid time!' => 'Недійсний час!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Повернути %s%s%s',
        'Bounce to' => 'Повернути до',
        'You need a email address.' => 'Вам потрібна адреса електронної пошти.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Потрібна дійсна адреса електронної пошти або не використовуйте локальну адресу електронної пошти.',
        'Next ticket state' => 'Наступний стан заявки',
        'Inform sender' => 'Інформувати відправника',
        'Send mail' => 'Відправити лист',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Масова дія',
        'Send Email' => 'Відправити лист',
        'Merge' => 'Об\'єднати',
        'Merge to' => 'Об\'єднати с',
        'Invalid ticket identifier!' => 'Недійсний ідентифікатор квитка!',
        'Merge to oldest' => 'Об\'єднати із самим старим',
        'Link together' => 'Зв\'язати',
        'Link to parent' => 'Зв\'язати з батьком',
        'Unlock tickets' => 'Розблокувати квитки',
        'Execute Bulk Action' => 'Виконати Масову Дію',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Написати відповідь для %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Ця адреса зареєстрована як системна та не може бути використана: %s',
        'Please include at least one recipient' => 'Будь ласка, додайте хоч одного одержувача',
        'Select one or more recipients from the customer user address book.' =>
            '',
        'Customer user address book' => '',
        'Remove Ticket Customer' => 'Вилучити Квиток Клієнта',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Будь ласка, вилучіть цей запис та додайте новий з правильним значенням.',
        'This address already exists on the address list.' => 'Ця адреса вже є в списку адрес',
        'Remove Cc' => 'Вилучити Копія',
        'Bcc' => 'Прихована копія',
        'Remove Bcc' => 'Вилучити Прихована Копія',
        'Date Invalid!' => 'Невірна дата!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Зміна Клаєнта: %s%s%s',
        'Customer Information' => 'Інформація про клієнта',
        'Customer user' => 'Користувач клієнта',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Заявка по e-mail',
        'Example Template' => 'Приклад шаблону',
        'From queue' => ' Із черги',
        'To customer user' => 'Для користувача',
        'Please include at least one customer user for the ticket.' => 'Будь ласка, додайте хоча б одного користувача-клієнта для квитка.',
        'Select this customer as the main customer.' => 'Виберіть клієнта у якості основного.',
        'Remove Ticket Customer User' => 'Вилучити Користувача-Клієнта',
        'Get all' => 'Отримати всі',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Вихідна адреса електронної пошти для %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Квиток %s: час першого відгуку складає більше (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Квиток %s: час першої відповіді буде більшою на %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Квиток %s: час оновлення складає більше (',
        'Ticket %s: update time will be over in %s/%s!' => 'Квиток %s: час оновлення буде більше ніж %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Квиток %s: час розв\'язання більше ніж (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Квиток %s: час розв\'язання буде більше ніж %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Перенаправити %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Історія: %s%s%s',
        'Filter for history items' => '',
        'Expand/collapse all' => '',
        'CreateTime' => '',
        'Article' => 'Повідомлення',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Об\'єднати %s%s%s',
        'Merge Settings' => 'Об\'єднати Налаштування',
        'You need to use a ticket number!' => 'Вам необхідно використовувати номер заявки!',
        'A valid ticket number is required.' => 'Треба вказати чинний номер квитка.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            '',
        'Limit the search to tickets with same Customer ID (%s).' => '',
        'Inform Sender' => '',
        'Need a valid email address.' => ' Потрібно вірну поштову адресу.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Перемістити %s%s%s',
        'New Queue' => 'Нова черга',
        'Move' => 'Перемістити',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Не знайдено даних про квитки',
        'Open / Close ticket action menu' => 'Відкрити/Закрити меню дій з квитком',
        'Select this ticket' => 'Вибрати цей квиток',
        'Sender' => 'Відправник',
        'First Response Time' => 'Час до першої відповіді',
        'Update Time' => 'Час до зміни заявки',
        'Solution Time' => 'Час розв\'язку заявки',
        'Move ticket to a different queue' => 'Перемістити заявку в іншу чергу',
        'Change queue' => 'Перемістити в іншу чергу',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Скасувати чинні фільтри на цьому екрані.',
        'Tickets per page' => 'Квитків на сторінку.',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Скинути огляд',
        'Column Filters Form' => 'Фільтри Стовпчиків Форми',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Розділити на Нові Телефонні Квитки',
        'Save Chat Into New Phone Ticket' => 'Зберегти Чат у Новому Телефонному Квитку',
        'Create New Phone Ticket' => 'Заявка по телефону',
        'Please include at least one customer for the ticket.' => 'Будь ласка, вкажіть хоча б одного клієнта для квитка.',
        'To queue' => 'У чергу',
        'Chat protocol' => 'Протокол чату',
        'The chat will be appended as a separate article.' => 'Чат буде додано у якості окремої статті.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Телефонний виклик для %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Переглянути простий текст електронного повідомлення для %s%s%s',
        'Plain' => 'Звичайний',
        'Download this email' => 'Завантажити це повідомлення',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Створити Новий  Квиток Процесу',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Залучити Квиток в Процес',

        # Template: AgentTicketSearch
        'Profile link' => 'Посилання на профіль',
        'Output' => 'Вивід результатів',
        'Fulltext' => 'Повнотекстовий',
        'Customer ID (complex search)' => '',
        '(e. g. 234*)' => '(наприклад 234*)',
        'Customer ID (exact match)' => '',
        'Assigned to Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '(наприклад U51*)',
        'Assigned to Customer User Login (exact match)' => '',
        'Accessible to Customer User Login (exact match)' => '',
        'Created in Queue' => 'Створена в черзі',
        'Lock state' => 'Заблокувати стан',
        'Watcher' => 'Спостерігач',
        'Article Create Time (before/after)' => 'Час Створення Статті (до/після)',
        'Article Create Time (between)' => 'Час Створення Статті (поміж)',
        'Please set this to value before end date.' => '',
        'Please set this to value after start date.' => '',
        'Ticket Create Time (before/after)' => 'Час Створення Квитка (до/після)',
        'Ticket Create Time (between)' => 'Час Створення Квитка (поміж)',
        'Ticket Change Time (before/after)' => 'Час Змінення Квитка (до/після)',
        'Ticket Change Time (between)' => 'Час Змінення Квитка (поміж)',
        'Ticket Last Change Time (before/after)' => 'Час Останнього Змінення Квитка (до/після)',
        'Ticket Last Change Time (between)' => 'Час Останнього Змінення Квитка (поміж)',
        'Ticket Pending Until Time (before/after)' => '',
        'Ticket Pending Until Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Час Закриття Квитка (до/після)',
        'Ticket Close Time (between)' => 'Час Закриття Квитка (поміж)',
        'Ticket Escalation Time (before/after)' => 'Час Підвищення Квитка (до/після)',
        'Ticket Escalation Time (between)' => 'Час Підвищення Квитка (поміж)',
        'Archive Search' => 'Пошук в архіві',

        # Template: AgentTicketZoom
        'Sender Type' => 'Тип відправника',
        'Save filter settings as default' => 'Зберегти умови фільтра для показу за замовчуванням',
        'Event Type' => 'Тип Події',
        'Save as default' => 'Зберегти як типовий',
        'Drafts' => '',
        'by' => 'ні',
        'Change Queue' => 'Перемінити черга',
        'There are no dialogs available at this point in the process.' =>
            'На даний момент в цьому процесі немає ніяких діалогових вікон.',
        'This item has no articles yet.' => 'У цього елемента ще немає статей.',
        'Ticket Timeline View' => 'Вигляд Лінії часу Квитка',
        'Article Overview - %s Article(s)' => '',
        'Page %s' => '',
        'Add Filter' => 'Додати фільтр',
        'Set' => 'Установити',
        'Reset Filter' => 'Скинути фільтр',
        'No.' => 'Номер',
        'Unread articles' => 'Непрочитані заявки',
        'Via' => '',
        'Important' => 'Важливо',
        'Unread Article!' => 'Непрочитані заявки!',
        'Incoming message' => 'Вхідне повідомлення',
        'Outgoing message' => 'Вихідні повідомлення',
        'Internal message' => 'Внутрішні повідомлення',
        'Sending of this message has failed.' => '',
        'Resize' => 'Змінити розмір',
        'Mark this article as read' => 'Позначити цю статтю як прочитану',
        'Show Full Text' => 'Показати увесь текст',
        'Full Article Text' => 'Весь Текст Статті',
        'No more events found. Please try changing the filter settings.' =>
            'Не знайдено більше подій. Будь ласка, спробуйте змінити налаштування фільтрів.',

        # Template: Chat
        '#%s' => '',
        'via %s' => '',
        'by %s' => '',
        'Toggle article details' => '',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            '',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Для відкриття посилання в наступній статті, ви маєте натиснути кнопки Ctrl, Cmd або Shift при натисканні на посилання (залежить від вашого браузера та операційної системи).',
        'Close this message' => 'Закрити це повідомлення',
        'Image' => '',
        'PDF' => '',
        'Unknown' => '',
        'View' => 'Перегляд',

        # Template: LinkTable
        'Linked Objects' => 'Зв\'язані Об\'єкти',

        # Template: TicketInformation
        'Archive' => 'Архів',
        'This ticket is archived.' => 'Цей квиток архивований',
        'Note: Type is invalid!' => 'Примітка: Тип недійсний!',
        'Pending till' => 'В очікуванні до',
        'Locked' => 'Блокування',
        '%s Ticket(s)' => '',
        'Accounted time' => 'Витрачене на заявку час',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            '',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            '',
        'Please re-install %s package in order to display this article.' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Щоб захистити вашу приватність, видалений вміст буде заблоковано.',
        'Load blocked content.' => 'Завантажити заблокований вміст.',

        # Template: Breadcrumb
        'Home' => '',
        'Back to admin overview' => '',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => '',
        'You can' => 'Ви можете',
        'go back to the previous page' => 'повернутися до попередньої сторінки',

        # Template: CustomerAccept
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accept your license.' => '',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            '',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            '',
        'Select a customer ID to assign to this ticket.' => '',
        'From all Customer IDs' => '',
        'From assigned Customer IDs' => '',

        # Template: CustomerError
        'An Error Occurred' => 'Виникла Помилка',
        'Error Details' => 'Деталі помилки',
        'Traceback' => 'Відстеження',

        # Template: CustomerFooter
        '%s powered by %s™' => '',
        'Powered by %s™' => '',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'Зв\'язок був відновлений після тимчасової втрати. Через це, деякі елементи на цій сторінці можуть бути зупинені, щоб працювати правильно. Для того, щоб мати змогу використовувати всі елементи правильно знову, настійно рекомендується перезавантажити цю сторінку.',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript не доступне',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => 'Попередження Браузера',
        'The browser you are using is too old.' => 'Ви використовуєте застарий браузер!',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            'Будь ласка, зверніться до документації або до адміністратора для отримання додаткової інформації.',
        'One moment please, you are being redirected...' => 'Хвилинку, будь ласка, вас буде перенаправлено...',
        'Login' => 'Вхід',
        'User name' => 'Ім\'я користувача',
        'Your user name' => 'Ваше ім\'я користувача',
        'Your password' => 'Ваш пароль',
        'Forgot password?' => 'Забули пароль?',
        '2 Factor Token' => '2-факторний Токен',
        'Your 2 Factor Token' => 'Ваш 2-факторний Токен',
        'Log In' => 'Увійти',
        'Not yet registered?' => 'Прагнете зареєструватися?',
        'Back' => 'Назад',
        'Request New Password' => 'Вислати новий пароль',
        'Your User Name' => 'Логін',
        'A new password will be sent to your email address.' => 'Новий пароль буде надісланий до вашої електронної скриньки.',
        'Create Account' => 'Створити обліковий запис',
        'Please fill out this form to receive login credentials.' => 'Будь ласка, заповніть поля цієї форми щоб отримати реєстраційні дані.',
        'How we should address you' => 'Як ми можемо звертатися до Вас',
        'Your First Name' => 'Ваше Ім\'я',
        'Your Last Name' => 'Ваше Прізвище',
        'Your email address (this will become your username)' => 'Адреса вашої поштової скриньки (це стане вашим ім\'ям користувача)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Вхідні Запити Чату',
        'Edit personal preferences' => 'Редагувати особисті налаштування',
        'Logout %s' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Рівень обслуговування',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Ласкаво просимо!',
        'Please click the button below to create your first ticket.' => 'Будь ласка, натисніть на кнопку нижче, щоб створити ваш перший квиток.',
        'Create your first ticket' => 'Створення вашого першого квитка',

        # Template: CustomerTicketSearch
        'Profile' => 'Параметри',
        'e. g. 10*5155 or 105658*' => 'наприклад, 10*5155 або 105658*',
        'CustomerID' => 'ID клієнта',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => '',
        'Types' => 'Типи',
        'Time Restrictions' => '',
        'No time settings' => 'Немає налаштувань часу',
        'All' => 'Усі',
        'Specific date' => 'Вкажіть дату',
        'Only tickets created' => 'Заявки створені',
        'Date range' => 'Проміжок часу',
        'Only tickets created between' => 'Заявки створені проміжку',
        'Ticket Archive System' => '',
        'Save Search as Template?' => '',
        'Save as Template?' => 'Зберегти як шаблон',
        'Save as Template' => 'Зберегти у якості шаблону',
        'Template Name' => 'Ім\'я шаблону',
        'Pick a profile name' => 'Виберіть ім\'я профілю',
        'Output to' => 'Вивести як',

        # Template: CustomerTicketSearchResultShort
        'of' => ' з',
        'Page' => 'Сторінка',
        'Search Results for' => 'Результати пошуку для',
        'Remove this Search Term.' => 'Вилучити цей елемент пошуку',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Почати чат з цього квитка',
        'Next Steps' => 'Наступний крок',
        'Reply' => 'Відповісти',

        # Template: Chat
        'Expand article' => 'Розгорнути статтю',

        # Template: CustomerWarning
        'Warning' => 'Попередження',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Інформація про подію',
        'Ticket fields' => 'Поля квитка',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'Справді помилка? 5 з 10 повідомлень про помилку пов\'язани з неправильним або неповним встановленням OTRS.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            'З %s, наші фахівці дбають про правильне встановлення та прикривають вас підтримкою та періодичними оновленнями безпеки.',
        'Contact our service team now.' => 'Негайно зверніться до нашої сервісної служби.',
        'Send a bugreport' => 'Відправити повідомлення про помилку',
        'Expand' => 'Розгорнути',

        # Template: AttachmentList
        'Click to delete this attachment.' => '',

        # Template: DraftButtons
        'Update draft' => '',
        'Save as new draft' => '',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => '',
        'You have loaded the draft "%s". You last changed it %s.' => '',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            '',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            '',

        # Template: Header
        'View notifications' => '',
        'Notifications' => '',
        'Notifications (OTRS Business Solution™)' => '',
        'Personal preferences' => '',
        'Logout' => 'Вийти',
        'You are logged in as' => 'Ви ввійшли як',

        # Template: Installer
        'JavaScript not available' => 'JavaScript не доступний',
        'Step %s' => 'Крок %s',
        'License' => 'Ліцензія',
        'Database Settings' => 'Налаштування бази даних',
        'General Specifications and Mail Settings' => 'Загальні характеристики та налаштування пошти',
        'Finish' => 'Закінчити',
        'Welcome to %s' => 'Ласкаво просимо до %s',
        'Germany' => '',
        'Phone' => 'Телефон',
        'United States' => '',
        'Mexico' => '',
        'Hungary' => '',
        'Brazil' => '',
        'Singapore' => '',
        'Hong Kong' => '',
        'Web site' => 'Веб-сторінка',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Налаштування Вихідної пошти',
        'Outbound mail type' => 'Тип',
        'Select outbound mail type.' => 'Вибір типу вихідної пошти.',
        'Outbound mail port' => 'Порт вихідної пошти',
        'Select outbound mail port.' => 'Виберіть порт вихідної пошти.',
        'SMTP host' => 'SMTP сервер',
        'SMTP host.' => 'SMTP сервер.',
        'SMTP authentication' => 'SMTP аутентифікація',
        'Does your SMTP host need authentication?' => 'SMTP сервер вимагає аутентифікацію?',
        'SMTP auth user' => 'Користувач SMTP автентифікації',
        'Username for SMTP auth.' => 'Ім\'я користувача для автентифікації в SMTP.',
        'SMTP auth password' => 'Пароль SMTP автентифікації',
        'Password for SMTP auth.' => 'Пароль для SMTP автентифікації',
        'Configure Inbound Mail' => 'Налаштування вхідної пошти',
        'Inbound mail type' => 'Тип',
        'Select inbound mail type.' => 'Виберіть тип вхідної пошти.',
        'Inbound mail host' => 'Поштовий сервер для вхідної пошти',
        'Inbound mail host.' => 'Хост вхідної пошти.',
        'Inbound mail user' => 'Ім\'я користувача для вхідної пошти',
        'User for inbound mail.' => 'Ім\'я користувача для вхідної пошти.',
        'Inbound mail password' => 'Пароль для вхідної пошти',
        'Password for inbound mail.' => 'Пароль для вхідної пошти.',
        'Result of mail configuration check' => 'Результати перевірки настроювань пошти',
        'Check mail configuration' => 'Перевірити настроювання пошти',
        'Skip this step' => 'Пропустити цей крок',

        # Template: InstallerDBResult
        'Done' => 'Готово',
        'Error' => 'Помилка',
        'Database setup successful!' => 'Базу даних успішно налаштовано!',

        # Template: InstallerDBStart
        'Install Type' => 'Тип установки',
        'Create a new database for OTRS' => 'Створити нову базу даних OTRS',
        'Use an existing database for OTRS' => 'Використати наявну базу даних OTRS',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Якщо Ви встановили кореневий пароль до своєї бази даних, його треба ввести тут. Якщо ні, залиште це поле пустим.',
        'Database name' => 'Ім\'я бази даних',
        'Check database settings' => 'Перевірити налаштування бази даних',
        'Result of database check' => 'Результат перевірки бази даних',
        'Database check successful.' => 'Базу даних перевірено успішно.',
        'Database User' => 'Користувач бази даних',
        'New' => 'Новий',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Для цієї системи OTRS буде створено нового користувача бази даних з обмеженими правами.',
        'Repeat Password' => 'Повторити Пароль',
        'Generated password' => 'Створений пароль',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Паролі не збігаються',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Порт',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Щоб використовувати OTRS, виконайте в командному рядку під правами root наступну команду:',
        'Restart your webserver' => ' Запустите знову ваш веб-сервер',
        'After doing so your OTRS is up and running.' => 'Після цих дій система вже запущена.',
        'Start page' => 'Головна сторінка',
        'Your OTRS Team' => 'Команда розроблювачів OTRS',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Не ухвалюю умови ліцензії',
        'Accept license and continue' => 'Погодитися з ліцензією та продовжити далі',

        # Template: InstallerSystem
        'SystemID' => 'SystemID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Ідентифікатор системи. Кожний номер квитка та кожна ID HTTP-сесії містять цей номер.',
        'System FQDN' => 'Системне FQDN',
        'Fully qualified domain name of your system.' => 'Повне доменне ім\'я вашої системи.',
        'AdminEmail' => 'Поштова скринька Адміністратора',
        'Email address of the system administrator.' => 'Адреса поштової скриньки системного адміністратора.',
        'Organization' => 'Організація',
        'Log' => 'Журнал',
        'LogModule' => 'Модуль Журналювання',
        'Log backend to use.' => 'Механізм журналювання що буде використовуватись',
        'LogFile' => 'Файл журналу',
        'Webfrontend' => 'Веб-інтерфейс',
        'Default language' => 'Типова мова',
        'Default language.' => 'Типова мова.',
        'CheckMXRecord' => 'Перевірити МХ запис',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Адреси електронної пошти, що введено вручну, перевіряються з МХ записами, що знайдено в DNS. Не використовуйте цю опцію якщо у вас повільний DNS або він не дозволяє розв\'язувати публічні адреси.',

        # Template: LinkObject
        'Delete link' => '',
        'Delete Link' => '',
        'Object#' => 'Об\'єкт#',
        'Add links' => 'Додати посилання',
        'Delete links' => 'Вилучити посилання',

        # Template: Login
        'Lost your password?' => 'Забули свій пароль',
        'Back to login' => 'Повернутися',

        # Template: MetaFloater
        'Scale preview content' => 'Масштабувати перегляд вмісту',
        'Open URL in new tab' => 'Відкрити посилання в новій вкладинці',
        'Close preview' => 'Закрити попередній перегляд',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Попередній перегляд цього сайту неможливий, тому що він не дозволяє бути вбудованим.',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Вибачте, але ця функція OTRS наразі не доступна для мобільних пристроїв. Якщо ви бажаєте скористатися нею, ви можете увімкнути стільничний режим або використати стаціонарний комп\'ютер.',

        # Template: Motd
        'Message of the Day' => 'Повідомлення Дня',
        'This is the message of the day. You can edit this in %s.' => 'Це повідомлення дня. Ви можете змінити його в %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Недостатньо прав.',
        'Back to the previous page' => 'Повернутися до попередньої сторінки',

        # Template: Alert
        'Alert' => '',
        'Powered by' => 'Використовується',

        # Template: Pagination
        'Show first page' => 'Показати першу сторінку',
        'Show previous pages' => 'Показати попередню сторінку',
        'Show page %s' => 'Показати сторінку %s',
        'Show next pages' => 'Показати наступну сторінку',
        'Show last page' => 'Показати останню сторінку',

        # Template: PictureUpload
        'Need FormID!' => 'Треба FormID!',
        'No file found!' => 'Файла не знайдено!',
        'The file is not an image that can be shown inline!' => 'Це не файл зображення що можна вбудувати!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Немає налаштованих користувачами сповіщень.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Прийом повідомлень для сповіщення \'%s\' за допомогою транспортного метода \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Інформація про процес',
        'Dialog' => 'Діалог',

        # Template: Article
        'Inform Agent' => 'Повідомити агента',

        # Template: PublicDefault
        'Welcome' => 'Ласкаво просимо',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            'Це типовий публічний інтерфейс OTRS! Не задано жодного дійового параметра.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Ви можете встановити спеціальний загальнодоступний модуль (через менеджер пакунків), наприклад модуль ЧАП-ів, який має відкритий інтерфейс.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Права',
        'You can select one or more groups to define access for different agents.' =>
            'Ви можете вибрати одну чи більше груп для визначення доступу для різних агентів.',
        'Result formats' => 'Формати результату',
        'Time Zone' => 'Часовий пояс',
        'The selected time periods in the statistic are time zone neutral.' =>
            'Вибрані періоди часу в статистиці є нейтральним часовим поясом.',
        'Create summation row' => 'Створення підсумкового рядка',
        'Generate an additional row containing sums for all data rows.' =>
            'Створити додатковий рядок, що містить суми для всіх рядків з даними.',
        'Create summation column' => 'Створення підсумкового стовпчика',
        'Generate an additional column containing sums for all data columns.' =>
            'Створення додаткового стовпчика, що містить підсумки всіх стовпчиків з даними.',
        'Cache results' => 'Кешувати результати',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Зберігання даних результатів статистики в кеші для використання в наступних переглядах з тією ж самою конфігурацією (потрібно вибрати принаймні одне поле з часом).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Забезпечує статистику у вигляді віджету, який можуть активувати агенти на своїх панелях.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Зверніть увагу, що включення до панелі приладів віджета активує кешування для цієї статистики.',
        'If set to invalid end users can not generate the stat.' => 'Статистику не буде створено, якщо вказати недійсних кінцевих користувачів.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'В налаштуваннях цієї статистики наступні проблеми:',
        'You may now configure the X-axis of your statistic.' => 'Зараз ви маєте налаштувати вісь Х вашої статистики.',
        'This statistic does not provide preview data.' => 'Ця статистика не надає попереднього перегляду.',
        'Preview format' => '',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Зверніть увагу, що попередній перегляд використовує випадкові дані, що не враховує використання фільтрів.',
        'Configure X-Axis' => 'Налаштування осі Х',
        'X-axis' => 'Вісь X',
        'Configure Y-Axis' => 'Налаштування осі Y',
        'Y-axis' => 'Вісь Y',
        'Configure Filter' => 'Налаштування Фільтру',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Виберіть тільки один пункт або заберіть прапорець «Фіксоване».',
        'Absolute period' => 'Абсолютний Період',
        'Between %s and %s' => '',
        'Relative period' => 'Відносний період',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Минулий повний %s та поточний+майбутній повний %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Не погоджуйтесь на зміни цього елемента коли створюється статистика.',

        # Template: StatsParamsWidget
        'Format' => 'Формат',
        'Exchange Axis' => 'Поміняти осі',
        'Configurable Params of Static Stat' => '',
        'No element selected.' => 'Елементи не обрані',
        'Scale' => 'Масштаб',
        'show more' => 'показати більше',
        'show less' => 'показати менше',

        # Template: D3
        'Download SVG' => 'Завантажити SVG',
        'Download PNG' => 'Завантажити PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'Вибраний період визначає типові межі часу в яких будуть збиратися дані для статистики.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Визначає одиницю часу, що буде використовуватись для поділу вибраного періоду в даних звітності.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Запам\'ятайте будь ласка, що шкала осі Y має бути більшою ніж шкала осі X (наприклад, вісь Х => Місяць, вісь Y => Рік).',

        # Template: SettingsList
        'This setting is disabled.' => '',
        'This setting is fixed but not deployed yet!' => '',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            '',
        'Changing this setting is only available in a higher config level!' =>
            '',
        '%s (%s) is currently working on this setting.' => '',
        'Toggle advanced options for this setting' => '',
        'Disable this setting, so it is no longer effective' => '',
        'Disable' => '',
        'Enable this setting, so it becomes effective' => '',
        'Enable' => '',
        'Reset this setting to its default state' => '',
        'Reset setting' => '',
        'Allow users to adapt this setting from within their personal preferences' =>
            '',
        'Allow users to update' => '',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            '',
        'Forbid users to update' => '',
        'Show user specific changes for this setting' => '',
        'Show user settings' => '',
        'Copy a direct link to this setting to your clipboard' => '',
        'Copy direct link' => '',
        'Remove this setting from your favorites setting' => '',
        'Remove from favourites' => '',
        'Add this setting to your favorites' => '',
        'Add to favourites' => '',
        'Cancel editing this setting' => '',
        'Save changes on this setting' => '',
        'Edit this setting' => '',
        'Enable this setting' => '',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            '',

        # Template: SettingsListCompare
        'Now' => '',
        'User modification' => '',
        'enabled' => '',
        'disabled' => '',
        'Setting state' => '',

        # Template: Actions
        'Edit search' => '',
        'Go back to admin: ' => '',
        'Deployment' => '',
        'My favourite settings' => '',
        'Invalid settings' => '',

        # Template: DynamicActions
        'Filter visible settings...' => '',
        'Enable edit mode for all settings' => '',
        'Save all edited settings' => '',
        'Cancel editing for all settings' => '',
        'All actions from this widget apply to the visible settings on the right only.' =>
            '',

        # Template: Help
        'Currently edited by me.' => '',
        'Modified but not yet deployed.' => '',
        'Currently edited by another user.' => '',
        'Different from its default value.' => '',
        'Save current setting.' => '',
        'Cancel editing current setting.' => '',

        # Template: Navigation
        'Navigation' => '',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'Тестова сторінка OTRS',
        'Unlock' => 'Розблокувати',
        'Welcome %s %s' => 'Ласкаво просимо %s %s',
        'Counter' => 'Лічильник',

        # Template: Warning
        'Go back to the previous page' => 'Повернутись до попередньої сторінки',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Показати',

        # JS Template: FormDraftAddDialog
        'Draft title' => '',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => '',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => '',
        'Confirm' => 'Підтвердити',

        # JS Template: WidgetLoading
        'Loading, please wait...' => '',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => '',
        'Click to select files or just drop them here.' => '',
        'Click to select a file or just drop it here.' => '',
        'Uploading...' => '',

        # JS Template: InformationDialog
        'Process state' => '',
        'Running' => '',
        'Finished' => 'Закінчено',
        'No package information available.' => '',

        # JS Template: AddButton
        'Add new entry' => 'Додати новий запис',

        # JS Template: AddHashKey
        'Add key' => '',

        # JS Template: DialogDeployment
        'Deployment comment...' => '',
        'This field can have no more than 250 characters.' => '',
        'Deploying, please wait...' => '',
        'Preparing to deploy, please wait...' => '',
        'Deploy now' => '',
        'Try again' => '',

        # JS Template: DialogReset
        'Reset options' => '',
        'Reset setting on global level.' => '',
        'Reset globally' => '',
        'Remove all user changes.' => '',
        'Reset locally' => '',
        'user(s) have modified this setting.' => '',
        'Do you really want to reset this setting to it\'s default value?' =>
            '',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            '',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'CustomerIDs' => 'ID клієнта',
        'Fax' => 'Факс',
        'Street' => 'Вулиця',
        'Zip' => 'Індекс',
        'City' => 'Місто',
        'Country' => 'Країна',
        'Valid' => 'Дійсний',
        'Mr.' => 'пан',
        'Mrs.' => 'пані',
        'Address' => 'Адреса',
        'View system log messages.' => 'Перегляд системних повідомлень.',
        'Edit the system configuration settings.' => 'Редагувати параметри налаштування системи.',
        'Update and extend your system with software packages.' => 'Відновлення й розширення системи за допомогою програмних пакетів.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL-інформація з бази даних не синхронізована з конфігурацією системи, будь ласка, розгорніть усі ACL.',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Списки АСL не можуть бути імпортовані через невідому помилку, будь ласка, перевірте журнал OTRS для отримання додаткової інформації.',
        'The following ACLs have been added successfully: %s' => 'Вдало додано наступні списки ACL: %s',
        'The following ACLs have been updated successfully: %s' => 'Вдало поновлено наступні списки ACL: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Виникли помилки при додаванні/оновленні наступних списків ACL: %s. Будь ласка, перевірте файл журналу для отримання додаткової інформації.',
        'This field is required' => 'Це поле є обов\'язковим',
        'There was an error creating the ACL' => 'При створенні списку ACL виникла помилка',
        'Need ACLID!' => 'Потрібний ACLID!',
        'Could not get data for ACLID %s' => 'Не можу отримати дані для ACLID %s',
        'There was an error updating the ACL' => 'При оновленні списку ACL виникла помилка',
        'There was an error setting the entity sync status.' => 'Під час встановлення статусу синхронізації об\'єкту виникла помилка.',
        'There was an error synchronizing the ACLs.' => 'Під час синхронізації списків ACL виникла помилка.',
        'ACL %s could not be deleted' => 'ACL список %s не може бути видалений',
        'There was an error getting data for ACL with ID %s' => 'При отримані даних для ACL з ID %s виникла помилка.',
        '%s (copy) %s' => '',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            '',
        'Exact match' => 'Точний збіг',
        'Negated exact match' => 'Точний збіг заперечується',
        'Regular expression' => 'Регулярний вислів',
        'Regular expression (ignore case)' => 'Регулярний вислів (ігнорувати регістр)',
        'Negated regular expression' => 'Регулярний вислів заперечується',
        'Negated regular expression (ignore case)' => 'Регулярний вислів заперечується (ігнорувати регістр)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Система не може створити календар!',
        'Please contact the administrator.' => 'Будь ласка, зверніться до адміністратора.',
        'No CalendarID!' => 'Немає CalendarID',
        'You have no access to this calendar!' => 'Ви не маєте доступу до цього календаря!',
        'Error updating the calendar!' => 'Помилка при оновлденні календаря',
        'Couldn\'t read calendar configuration file.' => 'Не можливо прочитати файл конфігурації календаря',
        'Please make sure your file is valid.' => 'Будь ласка переконайтесь, що фай файл не пошкоджений',
        'Could not import the calendar!' => 'Не можливо імпортувати календар',
        'Calendar imported!' => 'Календар імпортовано',
        'Need CalendarID!' => 'Потреьується CalendarID',
        'Could not retrieve data for given CalendarID' => 'Не можливо отримати дані для CalendarID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Успішно імпортовано %s подій в календар %s',
        '+5 minutes' => '+5 хвилин',
        '+15 minutes' => '+15 хвилин',
        '+30 minutes' => '+30 хвилин',
        '+1 hour' => '+1 година',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Немає повноважень',
        'System was unable to import file!' => 'Система не може імпортувати файл',
        'Please check the log for more information.' => 'Будь ласка перевірте лог для додаткової інформації',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Імя нагадування вже існує',
        'Notification added!' => 'Сповіщення додано!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Під час отримання даних для Сповіщення з ID:%s виникла помилка!',
        'Unknown Notification %s!' => 'Невідоме Сповіщення %s!',
        '%s (copy)' => '',
        'There was an error creating the Notification' => 'Під час створення Сповіщення виникла помилка',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Через невідому помилку Сповіщення не вдалося імпортувати, будь ласка, перегляньте OTRS-журнали для отримання додаткової інформації.',
        'The following Notifications have been added successfully: %s' =>
            'Вдало додано наступні Сповіщення: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Вдало оновлено наступні Сповіщення: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Під час додавання/оновлення наступних Сповіщень виникли помилки: %s. Будь ласка, перегляньте файл журналу для отримання більш детальної інформації.',
        'Notification updated!' => 'Сповіщення оновлено!',
        'Agent (resources), who are selected within the appointment' => 'Агент (ресурси), які вибираються в рамках події',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Всі агенти з дозволом на читання для події (календар)',
        'All agents with write permission for the appointment (calendar)' =>
            'Всі агенти, які мають дозвіл на запис для подій (календар)',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Прикріплення додано!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => '',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => '',
        'All communications' => '',
        'Last 1 hour' => '',
        'Last 3 hours' => '',
        'Last 6 hours' => '',
        'Last 12 hours' => '',
        'Last 24 hours' => '',
        'Last week' => '',
        'Last month' => '',
        'Invalid StartTime: %s!' => '',
        'Successful' => '',
        'Processing' => '',
        'Failed' => '',
        'Invalid Filter: %s!' => 'Нечинний фільтр: %s!',
        'Less than a second' => '',
        'sorted descending' => 'відсортований за спаданням',
        'sorted ascending' => 'відсортоване за зростанням',
        'Trace' => '',
        'Debug' => '',
        'Info' => 'Інформація',
        'Warn' => '',
        'days' => 'днів',
        'day' => 'день',
        'hour' => 'година',
        'minute' => 'хвилина',
        'seconds' => 'секунд',
        'second' => 'секунда',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Компанію клієнта оновлено!',
        'Dynamic field %s not found!' => '',
        'Unable to set value for dynamic field %s!' => '',
        'Customer Company %s already exists!' => 'Компанія Клієнта %s вже їснує!',
        'Customer company added!' => 'Компанію клієнта додано!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            '',
        'Please check system configuration.' => '',
        'Invalid permission context configuration:' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Клієнта оновлено!',
        'New phone ticket' => 'Нова телефонна заявка',
        'New email ticket' => 'Нова e-mail заявка',
        'Customer %s added' => 'Додано клієнта %s',
        'Customer user updated!' => '',
        'Same Customer' => '',
        'Direct' => '',
        'Indirect' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => '',
        'Change Group Relations for Customer User' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => '',
        'Allocate Services to Customer User' => '',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Неправильне налаштування полів',
        'Objects configuration is not valid' => 'Неправильне налаштування об\'єктів',
        'Database (%s)' => '',
        'Web service (%s)' => '',
        'Contact with data (%s)' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Не можу правильно скинути  порядок Динамічного Поля, будь ласка перевірте журнал помилок для отримання більш докладної інформації.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Невизначена субдія.',
        'Need %s' => 'Потрібний %s',
        'Add %s field' => '',
        'The field does not contain only ASCII letters and numbers.' => 'Поле не містить жодної ASCII літери або числа.',
        'There is another field with the same name.' => 'Тут вже є інше поле з таким самим ім\'ям.',
        'The field must be numeric.' => 'Поле має бути числовим.',
        'Need ValidID' => 'Потрібний ValidID',
        'Could not create the new field' => 'Не вдалося створити нове поле',
        'Need ID' => 'Потрібний ID',
        'Could not get data for dynamic field %s' => 'Не можу отримати дані для динамічного поля %s',
        'Change %s field' => '',
        'The name for this field should not change.' => 'ім\'я цього поля не повинно змінюватися.',
        'Could not update the field %s' => 'Не можу оновити поле %s',
        'Currently' => 'Наразі',
        'Unchecked' => 'Непозначено',
        'Checked' => 'Позначено',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Попередити уведення дати в майбутньому',
        'Prevent entry of dates in the past' => 'Попередити уведення дат в минулому',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'Значення цього поля дублюється.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Виберіть принаймні, одного одержувача.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'хвилин',
        'hour(s)' => 'годин',
        'Time unit' => 'Одиниця часу',
        'within the last ...' => 'за останні ...',
        'within the next ...' => 'за наступні ...',
        'more than ... ago' => 'понад ... тому',
        'Unarchived tickets' => 'Неархівовані заявки',
        'archive tickets' => 'архівувати квитки',
        'restore tickets from archive' => 'відновити квитки з архіву',
        'Need Profile!' => 'Потрібний Профіль!',
        'Got no values to check.' => 'Немає значень для перевірки.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Будь ласка, вилучіть наступні слова, тому що їх не можна використати для вибору квитка:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Потрібний WebserviceID!',
        'Could not get data for WebserviceID %s' => 'Неможливо отримати дані для WebserviceID %s',
        'ascending' => ' По зростанню',
        'descending' => ' По убуванню',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => '',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            '',
        'Invalid Subaction!' => '',
        'Need ErrorHandlingType!' => '',
        'ErrorHandlingType %s is not registered' => '',
        'Could not update web service' => '',
        'Need ErrorHandling' => '',
        'Could not determine config for error handler %s' => '',
        'Invoker processing outgoing request data' => '',
        'Mapping outgoing request data' => '',
        'Transport processing request into response' => '',
        'Mapping incoming response data' => '',
        'Invoker processing incoming response data' => '',
        'Transport receiving incoming request data' => '',
        'Mapping incoming request data' => '',
        'Operation processing incoming request data' => '',
        'Mapping outgoing response data' => '',
        'Transport sending outgoing response data' => '',
        'skip same backend modules only' => '',
        'skip all modules' => '',
        'Operation deleted' => '',
        'Invoker deleted' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '',
        '15 seconds' => '',
        '30 seconds' => '',
        '45 seconds' => '',
        '1 minute' => '',
        '2 minutes' => '',
        '3 minutes' => '',
        '4 minutes' => '',
        '5 minutes' => '',
        '10 minutes' => '10 хвилин',
        '15 minutes' => '15 хвилин',
        '30 minutes' => '',
        '1 hour' => '',
        '2 hours' => '',
        '3 hours' => '',
        '4 hours' => '',
        '5 hours' => '',
        '6 hours' => '',
        '12 hours' => '',
        '18 hours' => '',
        '1 day' => '',
        '2 days' => '',
        '3 days' => '',
        '4 days' => '',
        '6 days' => '',
        '1 week' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Не можу визначити налаштування для активатора %s',
        'InvokerType %s is not registered' => 'Тип Активатора %s не зареєстрований',
        'MappingType %s is not registered' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => '',
        'Need Event!' => '',
        'Could not get registered modules for Invoker' => '',
        'Could not get backend for Invoker %s' => '',
        'The event %s is not valid.' => '',
        'Could not update configuration data for WebserviceID %s' => 'Не можу оновити дані налаштування WebserviceID %s',
        'This sub-action is not valid' => '',
        'xor' => 'xor',
        'String' => 'Рядок',
        'Regexp' => '',
        'Validation Module' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => '',
        'Simple Mapping for Incoming Data' => '',
        'Could not get registered configuration for action type %s' => 'Не можу отримати зареєстровані налаштування для типу дій %s',
        'Could not get backend for %s %s' => 'Не можу визначити механізм для %s %s',
        'Keep (leave unchanged)' => 'Полишити (залишити без змін)',
        'Ignore (drop key/value pair)' => 'Ігнорувати (відкинути пари ключ/значення)',
        'Map to (use provided value as default)' => 'Відобразити до (використовувати надане значення як типове)',
        'Exact value(s)' => 'Точне(-і) значення',
        'Ignore (drop Value/value pair)' => 'Ігнорувати (відкинути пари Значення/значення)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => '',
        'XSLT Mapping for Incoming Data' => '',
        'Could not find required library %s' => 'Не вдалося знайти необхідну бібліотеку %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            '',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            '',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            '',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            '',
        'Incoming request data before mapping (ProviderRequestInput)' => '',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            '',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            '',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Не можу визначити налаштування для операції %s',
        'OperationType %s is not registered' => 'Тип операції %s не зареєстровано',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => '',
        'This field should be an integer.' => '',
        'File or Directory not found.' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Тут вже є інша веб-служба з таким самим ім\'ям.',
        'There was an error updating the web service.' => 'Під час оновлення веб-служби виникла помилка.',
        'There was an error creating the web service.' => 'Під час створення веб-служби виникла помилка.',
        'Web service "%s" created!' => 'Веб-службу "%s" створено!',
        'Need Name!' => 'Потрібно Ім\'я!',
        'Need ExampleWebService!' => 'Потрібний Взірець Веб-служби!',
        'Could not load %s.' => '',
        'Could not read %s!' => 'Неможливо прочитати %s!',
        'Need a file to import!' => 'Потрібний файл для імпорту!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'Файл, що імпортується, не має правильного YAML вмісту! Будь ласка, перегляньте OTRS журнал для отримання детальної інформації.',
        'Web service "%s" deleted!' => 'Веб-службу "%s" вилучено!',
        'OTRS as provider' => 'OTRS як провайдер',
        'Operations' => '',
        'OTRS as requester' => 'OTRS як подавач запиту',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'WebserviceHistoryID не отримано!',
        'Could not get history data for WebserviceHistoryID %s' => 'Неможливо отримати дані історії для WebserviceHistoryID  %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Групу оновлено!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Електронну пошту додано!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            '',
        'Dispatching by email To: field.' => 'Перенаправлення за полем електронного листа Кому:',
        'Dispatching by selected Queue.' => 'Перенаправлення за обраною чергою.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => '',
        'Agent who owns the ticket' => 'Агент, якому належить квиток',
        'Agent who is responsible for the ticket' => 'Агент, який несе відповідальність за квиток',
        'All agents watching the ticket' => 'Всі агенти стежать за квитком',
        'All agents with write permission for the ticket' => 'Всі агенти, що мають дозвіл на запис для квитка',
        'All agents subscribed to the ticket\'s queue' => 'Всі агенти, що підписалися на чергу квитка',
        'All agents subscribed to the ticket\'s service' => 'Всі агенти, що підписалися на службу квитка',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Всі агенти, що підписалися на чергу та службу квитка',
        'Customer user of the ticket' => '',
        'All recipients of the first article' => '',
        'All recipients of the last article' => '',
        'Invisible to customer' => '',
        'Visible to customer' => '',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'Вашу систему було успішно оновлено до %s.',
        'There was a problem during the upgrade to %s.' => 'Сталася проблема під час оновлення до %s.',
        '%s was correctly reinstalled.' => '%s було коректно перевстановлено.',
        'There was a problem reinstalling %s.' => 'Сталася проблема з перевстановленням %s.',
        'Your %s was successfully updated.' => 'Ваш %s було успішно оновлено.',
        'There was a problem during the upgrade of %s.' => 'Сталася проблема під час оновлення %s.',
        '%s was correctly uninstalled.' => '%s було коректно деінстальовано.',
        'There was a problem uninstalling %s.' => 'Сталася проблема з деінсталюванням %s.',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP оточення не працює. Будь ласка перегляньте журнал для отримання додаткової інформації.',
        'Need param Key to delete!' => 'Потрібний Ключ, щоб вилучити.',
        'Key %s deleted!' => 'Ключ %s вилучено!',
        'Need param Key to download!' => 'Потрібний Ключ щоб завантажити!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            'На жаль, потрібно вказати Perl-модуль та PerlInitHandler Apache::Reload в файлі налаштувань Apache. Дивись також scripts/apache2-httpd.include.conf. Крім того, ви можете скористатися знаряддям командного рядка bin/otrs.Console.pl для встановлення пакунків!',
        'No such package!' => 'Немає такого пакунка!',
        'No such file %s in package!' => 'Немає файлу %s в пакунку!',
        'No such file %s in local file system!' => 'Немає файлу %s в локальній файловій системі!',
        'Can\'t read %s!' => 'Неможливо прочитати %s!',
        'File is OK' => 'Файл в нормі',
        'Package has locally modified files.' => 'Пакунок має локально змінені файли.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Пакет не верифіковано OTRS Group! Рекомендовано не використовувати цей пакет.',
        'Not Started' => '',
        'Updated' => '',
        'Already up-to-date' => '',
        'Installed' => '',
        'Not correctly deployed' => '',
        'Package updated correctly' => '',
        'Package was already updated' => '',
        'Dependency installed correctly' => '',
        'The package needs to be reinstalled' => '',
        'The package contains cyclic dependencies' => '',
        'Not found in on-line repositories' => '',
        'Required version is higher than available' => '',
        'Dependencies fail to upgrade or install' => '',
        'Package could not be installed' => '',
        'Package could not be upgraded' => '',
        'Repository List' => '',
        'No packages found in selected repository. Please check log for more info!' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            'Пакунок не перевірено через проблеми зі зв\'язком з сервером перевірки!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'Неможливо встановити зв\'язок із сервером списку Додаткових функцій OTRS!',
        'Can\'t get OTRS Feature Add-on list from server!' => 'Неможливо отримати список Додаткових функцій OTRS з серверу!',
        'Can\'t get OTRS Feature Add-on from server!' => 'Неможливо отримати Додаткові функції OTRS з серверу!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Немає такого фільтру: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Пріоритет додано!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Інформація керування процесами з бази даних не синхронізована з конфігурацією системи, будь ласка, синхронізуйте усі процеси.',
        'Need ExampleProcesses!' => 'Потрібний Зразок Процесів!',
        'Need ProcessID!' => 'Потрібний ProcessID!',
        'Yes (mandatory)' => 'Так (обов\'язково)',
        'Unknown Process %s!' => 'Незнайомий Процес %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Під час обчислення нового EntityID для цього Процесу виникла помилка',
        'The StateEntityID for state Inactive does not exists' => 'Не існує StateEntityID для неактивного стану',
        'There was an error creating the Process' => 'Виникла помилка під час створення Процесу',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Виникла помилка під час встановлення статусу об\'єктної синхронізації об\'єкта Процесу: %s',
        'Could not get data for ProcessID %s' => 'Не можу отримати дані для ProcessID %s',
        'There was an error updating the Process' => 'Під час оновлення Процесу виникла помилка',
        'Process: %s could not be deleted' => 'Процес %s не може бути вилучений',
        'There was an error synchronizing the processes.' => 'Під час синхронізації процесів виникла помилка.',
        'The %s:%s is still in use' => '%s:%s ще досі використовується',
        'The %s:%s has a different EntityID' => '%s:%s має інший EntityID',
        'Could not delete %s:%s' => 'Неможливо видалити %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Виникла помилка під час встановлення статусу об\'єктної синхронізації об\'єкта для %s об\'єкту: %s',
        'Could not get %s' => 'Неможливо отримати %s',
        'Need %s!' => 'Потрібний %s!',
        'Process: %s is not Inactive' => 'Процес: %s не є активним',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Під час створення нового EntityID для цієї Активності виникла помилка',
        'There was an error creating the Activity' => 'Під час створення Активності виникла помилка',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Виникла помилка під час встановлення статусу об\'єктної синхронізації для об\'єкта Активності: %s',
        'Need ActivityID!' => 'Потрібний ActivityID!',
        'Could not get data for ActivityID %s' => 'Не можу отримати дані для ActivityID %s',
        'There was an error updating the Activity' => 'Під час оновлення Активності виникла помилка',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Відсутній параметр: потрібна Активність та Діалог Активності!',
        'Activity not found!' => 'Активність не знайдена!',
        'ActivityDialog not found!' => 'Діалога Активності не знайдено!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Діалог Активності вже призначений для Активності. Ви не можете додати Діалог Активності двічі!',
        'Error while saving the Activity to the database!' => 'Під час збереження Активності до бази даних виникла помилка!',
        'This subaction is not valid' => 'Ця піддія неправильна',
        'Edit Activity "%s"' => 'Редагувати Активність "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Під час створення нового EntityID для цього Діалогу Активності виникла помилка',
        'There was an error creating the ActivityDialog' => 'Під час створення Діалогу Активності виникла помилка',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Виникла помилка під час встановлення статусу об\'єктної синхронізації для об\'єкту Діалогу Активності: %s',
        'Need ActivityDialogID!' => 'Потрібний ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Не можу отримати дані для ActivityDialogID %s',
        'There was an error updating the ActivityDialog' => 'Під час оновлення Діалогу Активності виникла помилка',
        'Edit Activity Dialog "%s"' => 'Редагувати Діалог Активності "%s"',
        'Agent Interface' => 'Інтерфейс агента',
        'Customer Interface' => 'Інтерфейс клієнта',
        'Agent and Customer Interface' => 'Інтерфейс Агента та Клієнта',
        'Do not show Field' => 'Не показувати поле',
        'Show Field' => 'Показувати поле',
        'Show Field As Mandatory' => 'Показувати поле як обов\'язкове',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Змінити Шлях',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Під час створення нового EntityID для цього Переходу виникла помилка',
        'There was an error creating the Transition' => 'Під час створення Переходу виникла помилка',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Виникла помилка під час встановлення статусу об\'єктної синхронізації для об\'єкту Переходу: %s',
        'Need TransitionID!' => 'Потрібний TransitionID!',
        'Could not get data for TransitionID %s' => 'Не можу отримати дані для TransitionID %s',
        'There was an error updating the Transition' => 'Під час оновлення Переходу виникла помилка',
        'Edit Transition "%s"' => 'Редагувати Перехід "%s"',
        'Transition validation module' => 'Модуль перевірки Переходу',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Потрібен принаймні один дійсний параметр налаштування.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Під час створення нового EntityID для цієї Дії Переходу виникла помилка',
        'There was an error creating the TransitionAction' => 'Під час створення Дії Переходу виникла помилка',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Виникла помилка під час встановлення статусу об\'єктної синхронізації для об\'єкту Дії Переходу: %s',
        'Need TransitionActionID!' => 'Потрібна TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Не можу отримати дані для TransitionActionID %s',
        'There was an error updating the TransitionAction' => 'Під час оновлення Дії Переходу виникла помилка',
        'Edit Transition Action "%s"' => 'Редагувати Дію Переходу "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Помилка: здається не всі ключі мають значення, або навпаки.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Чергу оновлено!',
        'Don\'t use :: in queue name!' => 'Не використовуйте :: в імені черги!',
        'Click back and change it!' => 'Натисніть назад та змініть це!',
        '-none-' => '-немає-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Черги (без автовідповідей)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Змінити Залежності Черг для Шаблона',
        'Change Template Relations for Queue' => 'Змінити Залежності Шаблонів для Черги',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => '',
        'Test' => '',
        'Training' => '',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Роль оновлено!',
        'Role added!' => 'Роль додана!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Змінити Залежності Групи для Ролі',
        'Change Role Relations for Group' => 'Змінити Залежності Ролі для Групи',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',
        'Change Role Relations for Agent' => 'Змінити Залежності Ролі для Агента',
        'Change Agent Relations for Role' => 'Змінити Залежності Агента для Ролі',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Будь ласка, спочатку активуйте %s!',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME оточення не працює. Будь ласка перевірте журнал для більше детальної інформації!',
        'Need param Filename to delete!' => 'Потрібний параметр Ім\'я файлу для вилучення!',
        'Need param Filename to download!' => 'Потрібний параметр Ім\'я файлу для завантаження!',
        'Needed CertFingerprint and CAFingerprint!' => 'Потрібні CertFingerprint та CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint має відрізнятись від CertFingerprint',
        'Relation exists!' => 'Стосунок існує!',
        'Relation added!' => 'Стосунок додано!',
        'Impossible to add relation!' => 'Неможливо додати стосунок!',
        'Relation doesn\'t exists' => 'Стосунку не існує',
        'Relation deleted!' => 'Стосунок вилучено!',
        'Impossible to delete relation!' => 'Неможливо видалити стосунок!',
        'Certificate %s could not be read!' => 'Неможливо прочитати сертифікат %s!',
        'Needed Fingerprint' => 'Потрібний цифровий відбиток',
        'Handle Private Certificate Relations' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Привітання додано!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Підпис оновлено!',
        'Signature added!' => 'Підпис додано!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Статус додано!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Неможливо прочитати файл %s!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Системну електронну адресу додано!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => '',
        'There are no invalid settings active at this time.' => '',
        'You currently don\'t have any favourite settings.' => '',
        'The following settings could not be found: %s' => '',
        'Import not allowed!' => 'Імпорт не допускається!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            '',
        'Category Search' => '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            '',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => '',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            '',
        'Missing setting name!' => '',
        'Missing ResetOptions!' => '',
        'Setting is locked by another user!' => '',
        'System was not able to lock the setting!' => '',
        'System was not able to reset the setting!' => '',
        'System was unable to update setting!' => '',
        'Missing setting name.' => '',
        'Setting not found.' => '',
        'Missing Settings!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Початкова дата не може бути визначена після кінцевої!',
        'There was an error creating the System Maintenance' => 'Під час створення технічного обслуговування системи виникла помилка',
        'Need SystemMaintenanceID!' => 'Потрібний SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Не можу отримати дані для SystemMaintenanceID %s',
        'System Maintenance was added successfully!' => '',
        'System Maintenance was updated successfully!' => '',
        'Session has been killed!' => 'Сесію було завершено!',
        'All sessions have been killed, except for your own.' => 'За винятком вашої особистої сесії, всі інші було завершено.',
        'There was an error updating the System Maintenance' => 'Під час оновлення Технічного обслуговування системи виникла помілка',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Не можливо було видалити запис технічного обслуговування системи: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Шаблон оновлений!',
        'Template added!' => 'Шаблон додано!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Змінити залежності прикріплення для шаблону',
        'Change Template Relations for Attachment' => 'Змінити залежності шаблону для прикріплення',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Потрібний Тип!',
        'Type added!' => 'Тип додано!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Агент оновлений!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Змінити залежності Групи для Агента',
        'Change Agent Relations for Group' => 'Змінити залежності Агента для Групи',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Місяць',
        'Week' => 'Тиждень',
        'Day' => 'День',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Всі події',
        'Appointments assigned to me' => 'Події, повязані зі мною',
        'Showing only appointments assigned to you! Change settings' => 'Показуються тільки повязані з вами події. Змінити налаштуванння.',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Подія не знайдена!',
        'Never' => 'Ніколи',
        'Every Day' => 'Щодня',
        'Every Week' => 'Щотижня',
        'Every Month' => 'Щомісяця',
        'Every Year' => 'Щороку',
        'Custom' => 'Користувацький вибір',
        'Daily' => 'Щоденно',
        'Weekly' => 'Щотижнево',
        'Monthly' => 'Щомісячно',
        'Yearly' => 'Щорічно',
        'every' => 'кожні',
        'for %s time(s)' => 'для %s разу(ів)',
        'until ...' => 'доки...',
        'for ... time(s)' => 'до ... разу(ів)',
        'until %s' => 'доки %s',
        'No notification' => 'Немає повідомлень',
        '%s minute(s) before' => '%s хвилин до',
        '%s hour(s) before' => '%s годин до',
        '%s day(s) before' => '%s дні(ів) до',
        '%s week before' => '%s тижнів до',
        'before the appointment starts' => 'перед початком події',
        'after the appointment has been started' => 'після початку події',
        'before the appointment ends' => 'перед завершенням події',
        'after the appointment has been ended' => 'після завершення події',
        'No permission!' => 'Немає повноважень!',
        'Cannot delete ticket appointment!' => 'Не можливо видалити подію заявки',
        'No permissions!' => 'Немає повновавжень!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Історія клієнта',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Немає налаштувань для %s',
        'Statistic' => 'Статистика',
        'No preferences for %s!' => 'Немає уподобань для %s!',
        'Can\'t get element data of %s!' => 'Не можу отримати елемент даних %s!',
        'Can\'t get filter content data of %s!' => 'Неможливо отримати дані вмісту фільтру для %s!',
        'Customer Name' => 'Ім\'я Клієнта',
        'Customer User Name' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Потрібні SourceObject та SourceKey!',
        'You need ro permission!' => 'Вам потрібен дозвіл на читання (ro)!',
        'Can not delete link with %s!' => 'Не можу вилучити зв\'язок з %s!',
        '%s Link(s) deleted successfully.' => '',
        'Can not create link with %s! Object already linked as %s.' => 'Не можу створити посилання до %s! Об\'єкт вже пов\'язаний із %s.',
        'Can not create link with %s!' => 'Не можу створити зв\'язок з %s!',
        '%s links added successfully.' => '',
        'The object %s cannot link with other object!' => 'Об\'єкт %s не може бути пов\'язаний з іншим об\'єктом!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Необхідний параметр Група!',
        'Updated user preferences' => '',
        'System was unable to deploy your changes.' => '',
        'Setting not found!' => '',
        'System was unable to reset the setting!' => '',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Параметр %s відсутній.',
        'Invalid Subaction.' => 'Нечинна Піддія.',
        'Statistic could not be imported.' => 'Неможливо імпортувати статистику.',
        'Please upload a valid statistic file.' => 'Будь ласка вивантажте чинний файл статистики.',
        'Export: Need StatID!' => 'Експорт: потрібний StatID!',
        'Delete: Get no StatID!' => 'Вилучення: не можу отримати StatID!',
        'Need StatID!' => 'Потрібний StatID!',
        'Could not load stat.' => 'Не вдалося завантажити статистику.',
        'Add New Statistic' => 'Додати Нову Статистику',
        'Could not create statistic.' => 'Не можу створити статистику.',
        'Run: Get no %s!' => 'Виконання: не можу отримати %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Не надано TicketID!',
        'You need %s permissions!' => 'Вам потрібні дозволи %s!',
        'Loading draft failed!' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Вибачте, Ви маєте бути власником заявки, щоб виконати цю дію.',
        'Please change the owner first.' => 'Будь ласка, змініть спочатку власника.',
        'FormDraft functionality disabled!' => '',
        'Draft name is required!' => '',
        'FormDraft name %s is already in use!' => '',
        'Could not perform validation on field %s!' => 'Не вдалось виконати перевірку на полі %s!',
        'No subject' => 'Без теми',
        'Could not delete draft!' => '',
        'Previous Owner' => 'Попередній власник',
        'wrote' => 'написав(-ла)',
        'Message from' => 'Повідомлення від',
        'End message' => 'Кінець повідомлення',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => 'Потрібний %s!',
        'Plain article not found for article %s!' => 'Для статті %s не знайдено статті зі звичайного тексту!',
        'Article does not belong to ticket %s!' => 'Стаття не відноситься до квитка %s!',
        'Can\'t bounce email!' => 'Не можу повернути лист!',
        'Can\'t send email!' => 'Не можу надіслати листа!',
        'Wrong Subaction!' => 'Помилкова Піддія!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Не можу заблокувати квиток, не надано TicketID!',
        'Ticket (%s) is not unlocked!' => 'Квиток (%s) не разблоковано!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            '',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            '',
        'You need to select at least one ticket.' => 'Ви маєте вибрати принаймні один квиток.',
        'Bulk feature is not enabled!' => 'Масову функцію не увімкнено!',
        'No selectable TicketID is given!' => 'Не надано TicketID, який можна вибрати!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Ви або не вибрали квитка, або вибрали квиток, що заблокований іншим агентом.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Наступні квитки було знехтувано тому що їх або заблоковано іншим агентом або ви не маєте дозволу на запис до цих квитків: %s',
        'The following tickets were locked: %s.' => 'Наступні квитки були заблоковані: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            '',
        'Address %s replaced with registered customer address.' => 'Адресу %s замінено на зареєстровану адресу клієнта.',
        'Customer user automatically added in Cc.' => 'Користувача-клієнта автоматично додано на копію.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Створена заявка «%s».',
        'No Subaction!' => 'Немає Піддії!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Не отримав TicketID!',
        'System Error!' => 'Системна помилка!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Наступний тиждень',
        'Ticket Escalation View' => 'Вид загостреної заявки',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => '',
        'Forwarded message from' => 'Переслане повідомлення від',
        'End forwarded message' => 'Кінець пересланого повідомлення',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Не можу показати історію - не наданий TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Не можу заблокувати Квиток - не наданий TicketID!',
        'Sorry, the current owner is %s!' => 'Вибачте, але зараз власником є %s!',
        'Please become the owner first.' => 'Спочатку станьте власником, будь ласка.',
        'Ticket (ID=%s) is locked by %s!' => 'Квиток (ID = %s) заблокований %s!',
        'Change the owner!' => 'Зміна власника!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Нове повідомлення',
        'Pending' => 'Відкладені',
        'Reminder Reached' => 'Нагадування',
        'My Locked Tickets' => 'Мої заблоковані заявки',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Неможливо об\'єднати квиток із собою!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Вам потрібно перемістити дозволи!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Чат не активний.',
        'No permission.' => 'Немає дозволу.',
        '%s has left the chat.' => '%s залишив чат.',
        'This chat has been closed and will be removed in %s hours.' => 'Цей чат закрито та буде вилучена за %s годин.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Заявка заблокована.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Немає ArticleID!',
        'This is not an email article.' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Неможливо прочитати просту статтю. Можливо немає простого поштового листа в сервері! Читайте повідомлення від сервера.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Потрібний TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Неможливо отримати ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'Не налаштовано Процес!',
        'The selected process is invalid!' => 'Обраний процес недійсний!',
        'Process %s is invalid!' => 'Процес %s не є чинним!',
        'Subaction is invalid!' => 'Піддія не є чинною!',
        'Parameter %s is missing in %s.' => 'Параметр %s пропущений в %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Не налаштовано Діалога Активності для %s в _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Не отримано Початкову ActivityEntityID  або Початкову ActivityDialogEntityID для процеса: %s в ',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Неможливо визначити квиток за TicketID: %s в ',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Не можу визначити ActivityEntityID. Динамічне поле або Налаштування не встановлене належним чином!',
        'Process::Default%s Config Value missing!' => 'Process::Default%s Config Value пропущено!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Неможливо визначити ProcessEntityID або TicketID та ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Неможливо отримати StartActivityDialog та StartActivityDialog для ',
        'Can\'t get Ticket "%s"!' => 'Неможливо отримати Квиток "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Неможливо отримати ProcessEntityID або ActivityEntityID для Квитка "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Неможливо отримати налаштування Активності для ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Неможливо отримати налаштування Діалогу Активності для ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Не можу отримати дані для поля "%s" Діалогу Активності "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'Час очікування може бути використаний якщо Стан, або StateID налаштовані на такий самий Діалог Активності. Діалог Активності: %s!',
        'Pending Date' => 'Наступна дата',
        'for pending* states' => ' для наступних станів* ',
        'ActivityDialogEntityID missing!' => 'Пропущено ActivityDialogEntityID!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Неможливо отримати налаштування для ',
        'Couldn\'t use CustomerID as an invisible field.' => 'Неможливо використати CustomerID у якості невидимого поля.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Пропущено ProcessEntityID, перевірте ',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Не налаштований Початковий Діалог Активності або Початковий Діалог Активності для Процесу "%s"!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Неможливо створити квиток для Процесу з ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Неможливо встановити ProcessEntityID "%s" в TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Неможливо встановити ActivityEntityID "%s" в TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Неможливо зберегти Діалог Активності, нечинний TicketID: %s!',
        'Invalid TicketID: %s!' => 'Нечинний ',
        'Missing ActivityEntityID in Ticket %s!' => 'Пропущено ActivityEntityID у Квитку %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Цей крок більше не належить до поточної активності в процесі для цього квитка \'%s%s%s\'! Інший користувач тим часом змінив цей квиток. Будь ласка закрийте це вікно та перезавантажте квиток.',
        'Missing ProcessEntityID in Ticket %s!' => 'Пропущено ProcessEntityID в Квитку %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Неможливо встановити Динамічне Поле для %s Квитка з ID "%s" в Діалозі Активності "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Неможливо встановити Час Очікування для Квитка з ID "%s" в Діалозі Активності "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Неправильне налаштування поля Діалогу Активності: %s не може бути Display => 1 / Показати поле (Будь ласка змініть налаштування так, щоб Display => 0 / Не показувати поле або Display => 2 /  Показати поле як обов\'язкове)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Не можу встановити %s для Квитка з ID "%s" в Діалозі Активності "%s"!',
        'Default Config for Process::Default%s missing!' => 'Пропущено типове налаштування для Process::Default%s!',
        'Default Config for Process::Default%s invalid!' => 'Нечинне типове налаштування для  Process::Default%s!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Доступні заявки',
        'including subqueues' => 'із підчергами',
        'excluding subqueues' => 'без підчерг',
        'QueueView' => 'Перегляд черги',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Мої відповідальні заявки',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'останній пошук',
        'Untitled' => 'Без назви',
        'Ticket Number' => 'Номер заявки',
        'Ticket' => 'Заявка',
        'printed by' => 'надруковане',
        'CustomerID (complex search)' => 'CustomerID (комплексний пошук)',
        'CustomerID (exact match)' => 'CustomerID (точний збіг)',
        'Invalid Users' => 'Нечинний Користувач',
        'Normal' => 'Звичайний',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'у понад ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Функцію не увімкнено!',
        'Service View' => 'Перегляд сервісу',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Перегляд статусу',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Мої спостережувані заявки',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Функція не активна',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Зв\'язок Вилучений',
        'Ticket Locked' => 'Квиток Заблоковано',
        'Pending Time Set' => 'Встановлення часу очікування',
        'Dynamic Field Updated' => 'Динамічне поле оновлено',
        'Outgoing Email (internal)' => 'Вихідна Пошта (внутрішня)',
        'Ticket Created' => 'Заявка створена',
        'Type Updated' => 'Тип оновлено',
        'Escalation Update Time In Effect' => 'Час Оновлення Підвищення задіяно',
        'Escalation Update Time Stopped' => 'Час Оновлення Підвищення Зупинено',
        'Escalation First Response Time Stopped' => 'Час Першої Відповіді Підвищення зупинено',
        'Customer Updated' => 'Клієнта оновлено',
        'Internal Chat' => 'Внутрішній Чат',
        'Automatic Follow-Up Sent' => 'Автоматичне Відстеження відправлене',
        'Note Added' => 'Нотатку додано',
        'Note Added (Customer)' => 'Нотатку додано (клієнт)',
        'SMS Added' => '',
        'SMS Added (Customer)' => '',
        'State Updated' => 'Стан оновлений',
        'Outgoing Answer' => 'Вихідна Відповідь',
        'Service Updated' => 'Служба Оновлена',
        'Link Added' => 'Зв\'язок доданий',
        'Incoming Customer Email' => 'Вхідний електронний лист від клієнта',
        'Incoming Web Request' => 'Вхідний Веб-запит',
        'Priority Updated' => 'Приоритет поновлено',
        'Ticket Unlocked' => 'Квиток разблоковано',
        'Outgoing Email' => 'Вихідне Поштове Повідомлення',
        'Title Updated' => 'Заголовок поновлено',
        'Ticket Merged' => 'Квиток Поєднано',
        'Outgoing Phone Call' => 'Вихідний Телефонний Виклик',
        'Forwarded Message' => 'Перенаправлене повідомлення',
        'Removed User Subscription' => 'Вилучений Опис Користувача',
        'Time Accounted' => 'Час Враховано',
        'Incoming Phone Call' => 'Вхідний Телефонний Виклик',
        'System Request.' => 'Системний Запит.',
        'Incoming Follow-Up' => 'Вхідне Відстеження',
        'Automatic Reply Sent' => 'Автоматичну Відповідь Відправлено',
        'Automatic Reject Sent' => 'Автоматичну Відмову Відправлено',
        'Escalation Solution Time In Effect' => 'Час Розв\'язання Підвищення задіяно',
        'Escalation Solution Time Stopped' => 'Час Розв\'язання Підвищення зупинено',
        'Escalation Response Time In Effect' => 'Час Відповіді Підвищення задіяно',
        'Escalation Response Time Stopped' => 'Час Відповіді на Підвищення зупинено',
        'SLA Updated' => 'SLA оновлено',
        'External Chat' => 'Зовнішній чат',
        'Queue Changed' => 'Чергу змінено',
        'Notification Was Sent' => 'Сповіщення надіслано',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            '',
        'Missing FormDraftID!' => '',
        'Can\'t get for ArticleID %s!' => 'Неможливо отримати для ArticleID %s!',
        'Article filter settings were saved.' => 'Налаштування фільтра статей було збережено.',
        'Event type filter settings were saved.' => 'Налаштування фільтру типів подій було збережено.',
        'Need ArticleID!' => 'Потрібний ArticleID!',
        'Invalid ArticleID!' => 'Нечинний ArticleID!',
        'Forward article via mail' => 'Переслати повідомлення електронною поштою',
        'Forward' => 'Переслати',
        'Fields with no group' => 'Поля, що не мають груп',
        'Invisible only' => '',
        'Visible only' => '',
        'Visible and invisible' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Статтю не можливо відкрити! Може вона на іншій сторінці статті?',
        'Show one article' => 'Відобразити одну заявку',
        'Show all articles' => 'Відобразити всі заявки',
        'Show Ticket Timeline View' => 'Показати Вид Лінії Часу Квитка',
        'Show Ticket Timeline View (%s)' => '',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => '',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => '',
        'No TicketID for ArticleID (%s)!' => 'Немає TicketID та ArticleID (%s)!',
        'HTML body attachment is missing!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'Потрібні FileID та ArticleID!',
        'No such attachment (%s)!' => 'Немає такого долучення (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Перевірте налаштування SysConfig для %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Перевірте налаштування SysConfig для %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Потрібний CustomerID!',
        'My Tickets' => 'Мої заявки',
        'Company Tickets' => 'Заявки компанії',
        'Untitled!' => 'Без назви!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Справжнє ім\'я клієнта',
        'Created within the last' => 'Створено протягом останніх ',
        'Created more than ... ago' => 'Створено понад ... тому',
        'Please remove the following words because they cannot be used for the search:' =>
            'Будь ласка, вилучіть наступні слова, тому що їх не можна використовувати для пошуку:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Неможливо перевідкрити квиток, неможливо для цієї черги!',
        'Create a new ticket!' => 'Створіть новий квиток!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'SecureMode активований!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Якщо вам треба перезапустити інсталятор, вимкніть SecureMode в SysConfig.',
        'Directory "%s" doesn\'t exist!' => 'Тека "%s" не існує!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Спочатку налаштуйте "Home" в Kernel/Config.pm!',
        'File "%s/Kernel/Config.pm" not found!' => 'Файл "%s/Kernel/Config.pm" не знайдено!',
        'Directory "%s" not found!' => 'Теку "%s" не знайдено!',
        'Install OTRS' => 'Встановити OTRS',
        'Intro' => 'Вступ',
        'Kernel/Config.pm isn\'t writable!' => 'Kernel/Config.pm не записний!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Якщо ви бажаєте використати інсталятор, встановіть Kernel/Config.pm записним для користувача webserver!',
        'Database Selection' => 'Вибір бази даних',
        'Unknown Check!' => 'Невідома Перевірка!',
        'The check "%s" doesn\'t exist!' => 'Перевірка "%s" не існує!',
        'Enter the password for the database user.' => 'Уведіть пароль користувача бази даних.',
        'Database %s' => 'База даний %s',
        'Configure MySQL' => 'Налаштувати MySQL',
        'Enter the password for the administrative database user.' => 'Уведіть пароль користувача-адміністратора бази даних.',
        'Configure PostgreSQL' => 'Налаштувати PostgreSQL',
        'Configure Oracle' => 'Налаштувати Oracle',
        'Unknown database type "%s".' => 'Невідомий тип бази даний "%s".',
        'Please go back.' => 'Будь ласка, поверніться.',
        'Create Database' => 'Створити базу даних',
        'Install OTRS - Error' => 'Встановлення OTRS - Помилка',
        'File "%s/%s.xml" not found!' => 'Файлу "%s/%s.xml" не знайдено!',
        'Contact your Admin!' => 'Зв\'яжіться з вашим Адміністратором!',
        'System Settings' => 'Системні налаштування',
        'Syslog' => 'Системний журнал',
        'Configure Mail' => 'Налаштувати пошту',
        'Mail Configuration' => 'Налаштування пошти',
        'Can\'t write Config file!' => 'Не можу записати до файлу Налаштування!',
        'Unknown Subaction %s!' => 'Невідома Піддія %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Неможливо під\'єднатися до бази даних, не встановлено Perl-модуль DBD::%s!',
        'Can\'t connect to database, read comment!' => 'Неможливо під\'єднатися до бази даних, читай коментар!',
        'Database already contains data - it should be empty!' => 'База даних уже містить дані — вона має бути пуста!',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Помилка: Будь ласка, переконайтеся в тому. що ваша база даних приймає пакунки розміром завбільшки %s МБ (в даний час приймаються пакунки за розміром до %s МБ). Будь ласка адаптуйте установку max_allowed_packet вашої бази даних, щоб уникнути помилок.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Помилка: Будь ласка, встановіть значення для innodb_log_file_size вашої бази даних, принаймні %s МБ (зараз: %s МБ, рекомендовано: %s МБ). Для отримання додаткової інформації, будь ласка, перегляньте %s.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            '',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'немає %s',
        'No such user!' => 'Відсутній такий користувач',
        'Invalid calendar!' => 'Хибний календар',
        'Invalid URL!' => 'Хибне посилання',
        'There was an error exporting the calendar!' => 'Сталась помилка під час експорту календаря',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Потрібне налаштування ',
        'Authentication failed from %s!' => 'Невдала автентифікація з %s!',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Переслати повідомлення на іншу електронну адресу',
        'Bounce' => 'Повернути',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Відповісти всім',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => '',
        'Resend' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => '',
        'Message Log' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Відповісти на нотатку',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Розділити цю статтю',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Переглянути джерело цієї Статті',
        'Plain Format' => 'Простий формат',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Роздрукувати це повідомлення',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => '',
        'Get Help' => '',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Позначити',
        'Unmark' => 'Зняти позначку',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => '',
        'Re-install Package' => '',
        'Upgrade' => 'Обновити',
        'Re-install' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Зашифровано',
        'Sent message encrypted to recipient!' => '',
        'Signed' => 'Підписано',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE" заголово знайдено, але він нечинний!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S/MIME SIGNED MESSAGE" заголовок знайдено, але він нечинний!',
        'Ticket decrypted before' => 'Попереднє розшифрування квитка',
        'Impossible to decrypt: private key for email was not found!' => 'Неможливо дешифрувати: не знайдено приватного ключа для адреси електронної пошти!',
        'Successful decryption' => 'Вдале дешифрування',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            '',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            '',
        'Encrypt' => '',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => '',
        'PGP sign' => '',
        'PGP sign and encrypt' => '',
        'PGP encrypt' => '',
        'SMIME sign' => '',
        'SMIME sign and encrypt' => '',
        'SMIME encrypt' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => '',
        'Cannot use revoked signing key: \'%s\'. ' => '',
        'There are no signing keys available for the addresses \'%s\'.' =>
            '',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            '',
        'Sign' => 'Підписати',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Показане',
        'Refresh (minutes)' => 'Оновлення (хвилини)',
        'off' => 'вимкнено',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Показані користувачі-клієнти',
        'Offline' => 'Офлайн',
        'User is currently offline.' => 'Наразі користувач не в мережі.',
        'User is currently active.' => 'Наразі користувач активний.',
        'Away' => 'Відсутній',
        'User was inactive for a while.' => 'Користувач деякий час неактивний.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'Початковий час квитка було встановлено після кінцевого!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => 'Не можу з\'єднатись з сервером новин OTRS!',
        'Can\'t get OTRS News from server!' => 'Неможливо отримати новини OTRS від сервера!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Неможливо з\'єднатись з сервером новин продукту!',
        'Can\'t get Product News from server!' => 'Неможливо отримати новини продукту з серверу!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Неможливо з\'єднатись із %s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Показувані заявки',
        'Shown Columns' => 'Показані колонки',
        'filter not active' => 'фільтр не активний',
        'filter active' => 'фільтр активний',
        'This ticket has no title or subject' => 'Цей квиток не має заголовка або теми',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Статистика за 7 днів',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'Користувач встановив свій статус як недосяжний.',
        'Unavailable' => 'Недоступний',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Стандарт',
        'The following tickets are not updated: %s.' => '',
        'h' => 'год.',
        'm' => 'хв.',
        'd' => 'д.',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            '',
        'This is a' => 'Це',
        'email' => 'email',
        'click here' => 'натисніть тут',
        'to open it in a new window.' => 'відкрити в новому вікні.',
        'Year' => 'Рік',
        'Hours' => 'Години',
        'Minutes' => 'Хвилини',
        'Check to activate this date' => 'Оберіть, щоб активувати цю дату',
        '%s TB' => '',
        '%s GB' => '',
        '%s MB' => '',
        '%s KB' => '',
        '%s B' => '',
        'No Permission!' => 'Немає прав!',
        'No Permission' => 'Немає прав доступу',
        'Show Tree Selection' => 'Показати дерево вибору',
        'Split Quote' => 'Разділити Цитату',
        'Remove Quote' => 'Вилучити лапки',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Пов\'язаний, як',
        'Search Result' => 'Результат Пошуку',
        'Linked' => 'Пов\'язаний',
        'Bulk' => 'Масово',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Полегшений',
        'Unread article(s) available' => 'Доступні непрочитані статті',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Подія',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Пошук в архіві',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => 'Ввімкніть хмарні сервіси щоб розкрити усі можливості OTRS!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s Оновіться до %s зараз! %s',
        'Please verify your license data!' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'Ліцензія для Вашого %s скоро закінчиться. Будь ласка, зв\'яжіться з %s, щоб поновити свій контракт!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Доступне оновлення для Вашого %s, але існує конфлікт з Вашою версією фреймворку Будь ласка, оновіть спершу свій фреймворк!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Агент онлайн: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Заявок з загостренням більше немає!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Клієнт онлайн: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => '',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRS Daemon не працює.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'У Вас ввімкнено «Не при справах», хочете вимкнути?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            '',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => '',
        'There is an error updating the system configuration!' => '',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Будь ласка, переконайтеся в тому, що ви вибрали принаймні один транспортний метод для обов\'язкових сповіщень.',
        'Preferences updated successfully!' => 'Налаштуваня успішно оновлені!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(В процесі)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Будь ласка виберіть кінцеву дату, що йде після початкової.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'Поточний пароль',
        'New password' => 'Новий пароль',
        'Verify password' => 'Повторіть пароль',
        'The current password is not correct. Please try again!' => 'Пароль неправильний. Будь ласка, спробуйте знову!',
        'Please supply your new password!' => 'Будь ласка вкажіть ваш новий пароль!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Неможливо оновити пароль. Нові паролі не збігаються. Будь ласка, спробуйте знову!',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            '',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Неможливо оновити пароль, тому що його довжина повинна бути не менше %s символів!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Неможливо оновити пароль, тому що він повинен містити не менше 1-ї цифри!',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'недійсний',
        'valid' => 'дійсний',
        'No (not supported)' => 'Ні (не підтримується)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Не вибрано величину завершеного минулого або поточного + відносного майбутнього часу.',
        'The selected time period is larger than the allowed time period.' =>
            'Вибраний період часу триваліший ніж це дозволено.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Немає значення масштабу часу для поточного обраного значення шкали часу на осі Х.',
        'The selected date is not valid.' => 'Вибрана дата нечинна.',
        'The selected end time is before the start time.' => 'Вибрана кінцева дата передує початковій.',
        'There is something wrong with your time selection.' => 'Щось не так із вашим вибором часу.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Будь ласка виберіть тільки один елемент або дозвольте зміну часу формування статистики.',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Будь ласка виберіть, принаймні, одне значення цього поля або дозвольте зміну часу формування статистики.',
        'Please select one element for the X-axis.' => 'Будь ласка, виберіть один елемент для Х-осі.',
        'You can only use one time element for the Y axis.' => 'Ви можете використати тільки один елемент для осі Y.',
        'You can only use one or two elements for the Y axis.' => 'Ви можете використати один або два елементи для осі Y.',
        'Please select at least one value of this field.' => 'Будь ласка оберіть, принаймні, одне значення для цього поля.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Будь ласка, вкажіть значення або дозвольте зміну часу формування статистики.',
        'Please select a time scale.' => 'Будь ласка, виберіть масштаб часу.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Період звітності занадто малий, будь ласка, вкажіть більший масштаб.',
        'second(s)' => 'секунд',
        'quarter(s)' => 'квартал(ів)',
        'half-year(s)' => 'півріччя',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Будь ласка. вилучіть наступні слова, тому що їх не можна використовувати для обмежень доступу квитків: %s',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => '',
        'Reset this setting to its default value.' => '',
        'Unable to load %s!' => '',
        'Content' => 'Зміст',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Розблокувати, щоб повернути у чергу',
        'Lock it to work on it' => 'Заблокувати, щоб працювати над цим',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Перестати спостерігати',
        'Remove from list of watched tickets' => 'Вилучити зі списку спостережуваних заявок',
        'Watch' => 'Спостерігати',
        'Add to list of watched tickets' => 'Додати до списку спостережуваних заявок',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Сортування',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'Інформація про заявку',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Блоковані заявки нові',
        'Locked Tickets Reminder Reached' => 'Блоковані заявки з нагадуванням',
        'Locked Tickets Total' => 'Блоковані заявки всі',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Відповідальні заявки нові',
        'Responsible Tickets Reminder Reached' => 'Відповідальні заявки з нагадуванням',
        'Responsible Tickets Total' => 'Відповідальні заявки всі',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Спостережувані заявки нові',
        'Watched Tickets Reminder Reached' => 'Спостережувані заявки з нагадуванням',
        'Watched Tickets Total' => 'Спостережувані заявки всі',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Динамічні Поля Квитка',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Не можу прочитати файл налаштувань ACL. Будь ласка, переконайтеся в чинності файлу.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Наразі неможливо увійти через заплановані технічні роботи в системі.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            'Ви перевищили кількість одночасних агентів - зверніться за адресою sales@otrs.com',
        'Please note that the session limit is almost reached.' => 'Зверніть увагу будь ласка, що обмеження сеансу майже досягнуто.',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            'У вході відмовлено! Ви перевищили максимальну кількість одночасно підключених Агентів! Негайно зверніться за адресою sales@otrs.com!',
        'Session limit reached! Please try again later.' => 'Перевищено ліміт сесій! Будь ласка, спробуйте пізніше.',
        'Session per user limit reached!' => 'Досягнуто максимальну кількість користувачів сесії!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Сесія недійсна. Будь ласка, увійдіть знову.',
        'Session has timed out. Please log in again.' => 'Сесія завершена. Будь ласка, увійдіть повторно.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Посилання на параметри налаштування',
        'This setting can not be changed.' => 'Це налаштування не може бути змінено.',
        'This setting is not active by default.' => 'Це налаштування типово не активне.',
        'This setting can not be deactivated.' => 'Це налаштування не може бути деактивоване.',
        'This setting is not visible.' => '',
        'This setting can be overridden in the user preferences.' => '',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'Клієнт "%s" вже існує.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Ця адреса поштової скриньки вже використана іншим клієнтом.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'до/після',
        'between' => 'між',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'наприклад Text або Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Пропустити це поле.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Це поле є обов\'язковим або',
        'The field content is too long!' => 'Значення поля занадто довге!',
        'Maximum size is %s characters.' => 'Максимальний розмір — %s символів.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Не можу прочитати файл налаштування Сповіщень. Будь ласка, переконайтесь у чинності файлу.',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'не встановлено',
        'installed' => 'встановлено',
        'Unable to parse repository index document.' => 'Не вдалося проаналізувати документ змісту репозиторію.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Не знайдено пакетів для Вашої версії фреймворку у цьому репозиторії, він містить лише пакети для інших версій фреймворку.',
        'File is not installed!' => 'Файл не встановлено!',
        'File is different!' => 'Файл інакший!',
        'Can\'t read file!' => 'Не можу прочитати файла!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'Процес "%s" та всі його дані вдало імпортовано!',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Неактивний',
        'FadeAway' => 'Заникання',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Не вдалося зв\'язатися з сервером реєстрації. Будь ласка, спробуйте пізніше.',
        'No content received from registration server. Please try again later.' =>
            'Не отримано вмісту від сервера реєстрації. Будь ласка, спробуйте пізніше.',
        'Can\'t get Token from sever' => 'Неможливо отримати Токен від сервера',
        'Username and password do not match. Please try again.' => 'Ім\'я користувача і пароль не співпадають. Будь ласка, спробуйте ще раз.',
        'Problems processing server result. Please try again later.' => 'Проблеми з обробкою результатів сервера. Будь ласка, спробуйте пізніше.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Сума',
        'week' => 'тиждень',
        'quarter' => 'квартал',
        'half-year' => 'півріччя',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Тип Стану',
        'Created Priority' => 'Пріоритет',
        'Created State' => 'Стан',
        'Create Time' => 'Час створення',
        'Pending until time' => '',
        'Close Time' => 'Час закриття',
        'Escalation' => 'Загострення',
        'Escalation - First Response Time' => 'Підвищення - Час Першої Відповіді',
        'Escalation - Update Time' => 'Підвищення - Час оновлення',
        'Escalation - Solution Time' => 'Підвищення - Час Розв\'язання',
        'Agent/Owner' => 'Агент (власник)',
        'Created by Agent/Owner' => 'Створене агентом (власником)',
        'Assigned to Customer User Login' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Заблоковане',
        'Ticket/Article Accounted Time' => 'Витрати робочого часу на заявку або повідомлення',
        'Ticket Create Time' => 'Час створення заявки',
        'Ticket Close Time' => 'Час закриття заявки',
        'Accounted time by Agent' => 'Витрати робочого часу по агентах',
        'Total Time' => 'Усього часу',
        'Ticket Average' => 'Середній час розгляду заявки',
        'Ticket Min Time' => 'Мін. час розгляду заявки',
        'Ticket Max Time' => 'Макс. час розгляду заявки',
        'Number of Tickets' => 'Кількість заявок',
        'Article Average' => 'Середній час між повідомленнями',
        'Article Min Time' => 'Мін. час між повідомленнями',
        'Article Max Time' => 'Макс. час між повідомленнями',
        'Number of Articles' => 'Кількість повідомлень',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'необмежений',
        'Attributes to be printed' => 'Атрибути для печатки',
        'Sort sequence' => 'Порядок сортування',
        'State Historic' => 'Історія Стану',
        'State Type Historic' => 'Історія Типу Стану',
        'Historic Time Range' => 'Межі часу історії',
        'Number' => 'Число',
        'Last Changed' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Середній час розв\'язання',
        'Solution Min Time' => 'Мінімальний час розв\'язання',
        'Solution Max Time' => 'Максимальний час розв\'язання',
        'Solution Average (affected by escalation configuration)' => 'Середній час розв\'язання (залежить від налаштування підвищення)',
        'Solution Min Time (affected by escalation configuration)' => 'Мінімальний час розв\'язання (залежить від налаштування підвищення)',
        'Solution Max Time (affected by escalation configuration)' => 'Максимальний час розв\'язання (залежить від налаштування підвищення)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Середній час роботи над розв\'язанням (залежить від налаштувань підвищення)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Мінімальний час роботи над розв\'язанням (залежить від налаштування підвищення)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Максимальний час роботи над розв\'язанням (залежить від налаштування підвищення)',
        'First Response Average (affected by escalation configuration)' =>
            'Середній час першої відповіді (залежить від налаштування підвищення)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Мінімальний час першої відповіді (залежить від налаштування підвищення)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Максимальний час першої відповіді (залежить від налаштування підвищення)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'Середній час роботи над першою відповіддю (залежить від налаштування підвищення)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'Мінімальний час роботи над першою відповіддю (залежить від налаштування підвищення)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'Максимальний час роботи над першою відповіддю (залежить від налаштування підвищення)',
        'Number of Tickets (affected by escalation configuration)' => 'Кількість квитків (залежить від налаштування підвищення)',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Дні',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => '',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Таблиця наявності',
        'Internal Error: Could not open file.' => 'Внутрішня помилка: неможливо відкрити файл',
        'Table Check' => 'Таблиця перевірки',
        'Internal Error: Could not read file.' => 'Внутрішня помилка: неможливо прочитати файл.',
        'Tables found which are not present in the database.' => 'Знайдено таблицю, якої немає в базі даних.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Розмір бази даних',
        'Could not determine database size.' => 'Не можу визначити розмір бази даних.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Версія бази даних',
        'Could not determine database version.' => 'Не можу визначити версію бази даних.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Набір символів клієнтського зв\'язку',
        'Setting character_set_client needs to be utf8.' => 'Налаштування character_set_client має бути utf8.',
        'Server Database Charset' => 'Набір символів бази даних сервера',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => '',
        'Table Charset' => 'Таблиця набору символів',
        'There were tables found which do not have \'utf8\' as charset.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Розмір файлу журналу InnoDB',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Налаштування innodb_log_file_size має бути, принаймні, 256 МБ.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => '',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Максимальний розмір вибірки',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Розмір кешу запиту',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Параметр \'query_cache_size\' повинен використовуватися (вище 10 МБ, але не більше 512 МБ).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Типове знаряддя зберігання даних',
        'Table Storage Engine' => 'Знараддя для зберігання таблиць',
        'Tables with a different storage engine than the default engine were found.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => '',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => '',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '',
        'Could not determine kernel version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => '',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            '',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => '',
        'Article Search Index Status' => '',
        'Indexed Articles' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => '',
        'Outgoing communications' => '',
        'Failed communications' => '',
        'Average processing time of communications (s)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => '',
        'No connections found.' => '',
        'ok' => '',
        'permanent connection errors' => '',
        'intermittent connection errors' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => '',
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => '',
        'Daemon is running.' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'Заявки',
        'Ticket History Entries' => '',
        'Articles' => '',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',
        'Open Tickets' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => '',
        'Emails queued for sending' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => '',
        'No legacy configuration backup files found.' => '',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            '',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => '',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => '',
        'OTRS time zone' => '',
        'OTRS time zone is not set.' => '',
        'User default time zone' => '',
        'User default time zone is not set.' => '',
        'Calendar time zone is not set.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => '',
        'Agents using custom main menu ordering' => '',
        'Agents using favourites for the admin overview' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => '',
        'Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => '',
        'Problem' => '',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => '',
        'Setting %s is not locked to this user!' => '',
        'Setting value is not valid!' => '',
        'Could not add modified setting!' => '',
        'Could not update modified setting!' => '',
        'Setting could not be unlocked!' => '',
        'Missing key %s!' => '',
        'Invalid setting: %s' => '',
        'Could not combine settings values into a perl hash.' => '',
        'Can not lock the deployment for UserID \'%s\'!' => '',
        'All Settings' => '',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Стандартна',
        'Value is not correct! Please, consider updating this field.' => '',
        'Value doesn\'t satisfy regex (%s).' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => '',
        'Disabled' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => '',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            '',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            '',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => '',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => '',
        'Chat Message Text' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Помилка входу! Ваше ім\'я користувача або пароль уведено неправильно.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => '',
        'Logout successful.' => '',
        'Feature not active!' => 'Функція неактивна!',
        'Sent password reset instructions. Please check your email.' => 'Надіслано інструкції зі скидання пароля. Будь ласка, перевірте електронну пошту.',
        'Invalid Token!' => 'Недійсний токен!',
        'Sent new password to %s. Please check your email.' => 'Надіслано новий пароль на %s. Будь ласка, перевірте електронну пошту.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            '',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Ця електронна адреса вже існує. Будь ласка, увійдіть або скиньте пароль.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Цю адреса електронної пошти не можна зареєструвати. Будь ласка, зв\'яжіться з підтримкою.',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Створено новий обліковий запис. Інформацію про вхід надіслано на %s. Будь ласка, перевірте свою електронну пошту.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'тимчасово недійсний',
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'new' => 'нова',
        'All new state types (default: viewable).' => '',
        'open' => 'відкриті',
        'All open state types (default: viewable).' => '',
        'closed' => 'закриті',
        'All closed state types (default: not viewable).' => '',
        'pending reminder' => 'відкладене нагадування',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'pending auto' => 'чекає на авто',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'removed' => 'вилучені',
        'All \'removed\' state types (default: not viewable).' => '',
        'merged' => 'об\'єднано',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'closed successful' => 'закрито успішно',
        'Ticket is closed successful.' => '',
        'closed unsuccessful' => 'закрито неуспішно',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'pending auto close+' => 'чекає на автозакриття+',
        'Ticket is pending for automatic close.' => '',
        'pending auto close-' => 'чекає на автозакриття-',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'possible' => 'імовірно',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'reject' => 'відхилити',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'auto reply' => 'автовідповідь',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'auto reject' => 'автовідхилення',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'auto follow up' => 'автослідування',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'auto reply/new ticket' => 'автовідповідь/нова заявка',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'auto remove' => 'автовилучення',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        '1 very low' => '1 найнижчий',
        '2 low' => '2 низький',
        '3 normal' => '3 звичайний',
        '4 high' => '4 високий',
        '5 very high' => '5 невідкладний',
        'unlock' => 'розблокована',
        'lock' => 'блокована',
        'tmp_lock' => '',
        'agent' => 'агент',
        'system' => 'система',
        'customer' => 'клієнт',
        'Ticket create notification' => '',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => '',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => '',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'Ticket lock timeout notification' => 'Повідомлення про закічнення строку блокування заявки',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => '',
        'Ticket responsible update notification' => '',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => '',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => 'Сповіщення заявок з загостренням',
        'Ticket escalation warning notification' => 'Сповіщення попереджень про загострення заявок',
        'Ticket service update notification' => '',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',
        'Appointment reminder notification' => 'повідомлення нагадування про Подію',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Ви будете отримувати повідомлення щоразу, як наставатиме визначений час (для Вашої Події)',
        'Ticket email delivery failure notification' => '',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => '',
        'This window must be called from compose window.' => '',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Додати всі',
        'An item with this name is already present.' => 'Елемент з таким іменем вже існує.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Цей елемент містить піделементи. Ви дійсно хочете вилучити цей елемент включно з його піделементами?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Більше',
        'Less' => 'Менше',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => '',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => '',
        'Deleting attachment...' => '',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            '',
        'Attachment was deleted successfully.' => '',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Ви насправді хочете видалити це динамічне поле? ВСІ асоційовані з ним дані буде ВТРАЧЕНО!',
        'Delete field' => 'Видалити поле',
        'Deleting the field and its data. This may take a while...' => 'Вилучення поля та його даних. Це може зайняти деякий час...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => '',
        'Remove selection' => 'Вилучити обране',
        'Do you really want to delete this generic agent job?' => '',
        'Delete this Event Trigger' => 'Вилучити цей тригер події',
        'Duplicate event.' => 'Подія-дублікат.',
        'This event is already attached to the job, Please use a different one.' =>
            'Ця подія вже прикріплена до цього завдання, будь ласка, використайте іншу.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Виникла помилка під час звязку',
        'Request Details' => 'Деталі запиту',
        'Request Details for Communication ID' => '',
        'Show or hide the content.' => 'Відобразити чи приховати контент',
        'Clear debug log' => 'Очистити лог відладки',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            '',
        'Delete this Invoker' => 'Вилучити цей активатор.',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => '',
        'Sorry, the only existing field can\'t be removed.' => '',
        'Delete conditions' => '',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => '',
        'Mapping for Key' => '',
        'Delete this Key Mapping' => 'Видалити цей Ключ Відображення',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Вилучити цю операцію',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Клонувати веб-службу',
        'Delete operation' => 'Вилучити операцію',
        'Delete invoker' => 'Вилучити активатор',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'УВАГА: При зміні назви групи \'admin\', перш ніж зробити відповідні зміни в  SysConfig, ви будете відключені від адміністративної панелі! Якщо це станеться, будь ласка, змініть ім\'я групи назад до admin за допомогою SQL ствердження.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => '',
        'Deleting the mail account and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Ви дійсно хочете вилучити цю мову сповіщення?',
        'Do you really want to delete this notification?' => 'Ви дійсно хочете вилучити це сповіщення?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => '',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            '',
        'A package upgrade was recently finished. Click here to see the results.' =>
            '',
        'No response from get package upgrade result.' => '',
        'Update all packages' => '',
        'Dismiss' => 'Відхилити',
        'Update All Packages' => '',
        'No response from package upgrade all.' => '',
        'Currently not possible' => '',
        'This is currently disabled because of an ongoing package upgrade.' =>
            '',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            '',
        'Are you sure you want to update all installed packages?' => '',
        'No response from get package upgrade run status.' => '',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => '',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Вилучити Об\'єкт з полотна',
        'No TransitionActions assigned.' => 'Не призначено Переходових Дій (TransitionActions)',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Жодного Діалогу ще не призначено. Просто виберіть діалог активності зі списку ліворуч та перетягніть його сюди.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Ця Активність не може бути вилучена тому що вона є Початковою Активністю',
        'Remove the Transition from this Process' => 'Вилучити Перехід з цього Процесу',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Як тільки ви використаєте цю кнопку або посилання, ви залишите цей екран та його поточний стан буде збережений автоматично. Ви хочете продовжити?',
        'Delete Entity' => 'Вилучити Об\'єкт',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Ця Активність вже використовується в Процесі. Ви не можете додати її двічі!',
        'Error during AJAX communication' => '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Непов\'язаний перехід вже розміщений на полотні. Будь ласка, спочатку з\'єднайте цей перехід перед встановленням іншого.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Цей Перехід вже використовується для цієї Активності. Ви не можете використати його двічі!',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ця Дія Переходу вже використовується в цьому Шляху. Ви не можете використовувати її двічі!',
        'Hide EntityIDs' => 'Приховати EntityIDs',
        'Edit Field Details' => 'Редагувати деталі полів',
        'Customer interface does not support articles not visible for customers.' =>
            '',
        'Sorry, the only existing parameter can\'t be removed.' => '',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => '',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Надсилання оновлення...',
        'Support Data information was successfully sent.' => 'Інформація Даних Підтримки була успішно відправлена.',
        'Was not possible to send Support Data information.' => 'Не було можливості передати Інформацію Даних Підтримки.',
        'Update Result' => 'Оновити Результат',
        'Generating...' => 'Створення...',
        'It was not possible to generate the Support Bundle.' => 'Не було можливості для створення В\'язки Підтримки.',
        'Generate Result' => 'Сформувати Результат',
        'Support Bundle' => 'В\'язка підтримки',
        'The mail could not be sent' => 'Пошта не може бути відправлена',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            '',
        'Cannot proceed' => '',
        'Update manually' => '',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            '',
        'Save and update automatically' => '',
        'Don\'t save, update manually' => '',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            '',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Завантаження...',
        'Search the System Configuration' => '',
        'Please enter at least one search word to find anything.' => '',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            '',
        'Deploy' => '',
        'The deployment is already running.' => '',
        'Deployment successful. You\'re being redirected...' => '',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            '',
        'Reset option is required!' => '',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            '',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            '',
        'Unlock setting.' => '',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Ви дійсно хочете вилучити це заплановане обслуговування системи?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => '',
        'Deleting the template and its data. This may take a while...' =>
            '',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Перейти',
        'Timeline Month' => 'Огляд місяця',
        'Timeline Week' => 'Огляд тижня',
        'Timeline Day' => 'Огляд дня',
        'Previous' => 'Попередній',
        'Resources' => '',
        'Su' => 'Нд',
        'Mo' => 'Пн',
        'Tu' => 'Бер.',
        'We' => 'ввімкнено',
        'Th' => 'по',
        'Fr' => 'Вт',
        'Sa' => 'Ср',
        'This is a repeating appointment' => 'Це повторювана подія',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Ви хочете змінити тільки цей випадок чи всі випадки?',
        'All occurrences' => 'Всі випадки',
        'Just this occurrence' => 'Лише цей випадок',
        'Too many active calendars' => 'Дуже багато активних календарів',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Будь ласка вимкніть деякі або збільшіть ліміт в конфігурації',
        'Restore default settings' => '',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Ви впевнені, що хочете видалити цю подію? Ця операція не може бути скасована',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            '',
        'Duplicated entry' => 'Дублювати запис',
        'It is going to be deleted from the field, please try again.' => 'Він буде вилучений з поля, будь ласка, спробуйте ще раз.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Будь ласка введіть будь-яке пошукове значення або * щоб знайти все.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'Інформація про демон OTRS',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Будь ласка, перевірте поля, що відмічені червоним, щодо коректного введення.',
        'month' => 'місяць',
        'Remove active filters for this widget.' => 'Скасувати активні фільтри для цього віджету.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => '',
        'Searching for linkable objects. This may take a while...' => '',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => '',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            '',
        'Do not show this warning again.' => '',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Вибачте, але ви не можете вимкнути всі методи для сповіщень, що позначені як обов\'язкові.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Вибачте, але ви не можете вимкнути всі методи для цих сповіщень.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            '',
        'An unknown error occurred. Please contact the administrator.' =>
            '',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Перемкнути до режиму робочого столу',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Будь ласка вилучіть наступні слова з вашого пошуку оскільки їх не можна знайти:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => '',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            '',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Ви справді бажаєте вилучити цю статистику?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => '',
        'Do you really want to continue?' => 'Ви справді маєте намір продовжити?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '',
        ' ...show less' => '',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => '',
        'Delete draft' => '',
        'There are no more drafts available.' => '',
        'It was not possible to delete this draft.' => '',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Фільтр статті',
        'Apply' => 'Застосувати',
        'Event Type Filter' => 'Фільтр Типу Події',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Посунути панель навігації',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Будь ласка вимкніть Режим Сумісності в Internet Explorer!',
        'Find out more' => '',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Перемкнути до мобільного режиму',

        # JS File: Core.App
        'Error: Browser Check failed!' => '',
        'Reload page' => 'Перезавантажити сторінку',
        'Reload page (%ss)' => '',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            '',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            '',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Виникла одна чи більше помилок!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Пошту успішно перевірено.',
        'Error in the mail settings. Please correct and try again.' => 'Помилка в налаштування пошти. Будь ласка виправте та спробуйте знову.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => '',
        'Please add values for all keys before saving the setting.' => '',
        'The key must not be empty.' => '',
        'A key with this name (\'%s\') already exists.' => '',
        'Do you really want to revert this setting to its historical value?' =>
            '',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Відкрити вибір дати',
        'Invalid date (need a future date)!' => 'Неправильна дата (треба вказати дату у майбутньому)!',
        'Invalid date (need a past date)!' => 'Неправильна дата (треба вказати дату у минулому)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Не доступно',
        'and %s more...' => 'та %s більше...',
        'Show current selection' => '',
        'Current selection' => '',
        'Clear all' => 'Очистити всі',
        'Filters' => 'Фільтри',
        'Clear search' => 'Очистити пошук',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Якщо ви залишите цю сторінку, всі спливні вікна будуть також зачинені!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Спливні цього екрану вже відкриті. Ви бажаєте закрити їх та натомість завантажити тільки його?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Не вдалося відкрити спливаюче вікно. Будь ласка, вимкніть всі блокувальники спливаючих вікон для цього додатка.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => '',
        'Descending sort applied, ' => '',
        'No sort applied, ' => '',
        'sorting is disabled' => '',
        'activate to apply an ascending sort' => '',
        'activate to apply a descending sort' => '',
        'activate to remove the sort' => '',

        # JS File: Core.UI.Table
        'Remove the filter' => '',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Наразі немає доступних для вибору елементів на формі.',

        # JS File: Core.UI
        'Please only select one file for upload.' => '',
        'Sorry, you can only upload one file here.' => '',
        'Sorry, you can only upload %s files.' => '',
        'Please only select at most %s files for upload.' => '',
        'The following files are not allowed to be uploaded: %s' => '',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            '',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            '',
        'No space left for the following files: %s' => '',
        'Available space %s of %s.' => '',
        'Upload information' => '',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            '',

        # JS File: Core.Language.UnitTest
        'yes' => 'так',
        'no' => 'ні',
        'This is %s' => '',
        'Complex %s with %s arguments' => '',

        # JS File: OTRSLineChart
        'No Data Available.' => 'Немає доступних даних.',

        # JS File: OTRSMultiBarChart
        'Grouped' => 'Згруповані',
        'Stacked' => 'У стеку',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'Потік',
        'Expanded' => 'Розгорнуто',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => '',
        ' 2 minutes' => '2 хвилини',
        ' 5 minutes' => '5 хвилин',
        ' 7 minutes' => '7 хвилин',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname Firstname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        '*** out of office until %s (%s d left) ***' => '',
        '0 - Disabled' => '',
        '1 - Available' => '',
        '1 - Enabled' => '',
        '10 Minutes' => '',
        '100 (Expert)' => '',
        '15 Minutes' => '',
        '2 - Enabled and required' => '',
        '2 - Enabled and shown by default' => '',
        '2 - Enabled by default' => '',
        '2 Minutes' => '',
        '200 (Advanced)' => '',
        '30 Minutes' => '',
        '300 (Beginner)' => '',
        '5 Minutes' => '',
        'A TicketWatcher Module.' => '',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer and customer user groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'ActivityID' => '',
        'Add a note to this ticket' => 'Додати нотатку до цієї заявки',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added %s time unit(s), for a total of %s time unit(s).' => '',
        'Added email. %s' => '',
        'Added follow-up to ticket [%s]. %s' => '',
        'Added link to ticket "%s".' => '',
        'Added note (%s).' => '',
        'Added phone call from customer.' => '',
        'Added phone call to customer.' => '',
        'Added subscription for user "%s".' => 'Додана підписка для користувача «%s».',
        'Added system request (%s).' => '',
        'Added web request from customer.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar.' => '',
        'Adds the one time vacation days.' => '',
        'Adds the permanent vacation days for the indicated calendar.' =>
            '',
        'Adds the permanent vacation days.' => '',
        'Admin' => 'Адміністрування',
        'Admin Area.' => '',
        'Admin Notification' => 'Повідомлення адміністратором',
        'Admin area navigation for the agent interface.' => '',
        'Admin modules overview.' => '',
        'Admin.' => 'Адміністратор',
        'Administration' => '',
        'Agent Customer Search' => '',
        'Agent Customer Search.' => '',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent Statistics.' => '',
        'Agent User Search' => '',
        'Agent User Search.' => '',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            '',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            '',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            '',
        'Agents ↔ Groups' => '',
        'Agents ↔ Roles' => '',
        'All CustomerIDs of a customer user.' => '',
        'All attachments (OTRS Business Solution™)' => '',
        'All customer users of a CustomerID' => '',
        'All escalated tickets' => 'Усі заявки з загостренням',
        'All new tickets, these tickets have not been worked on yet' => 'Усі відкриті заявки, над цими заявками ще не працювали',
        'All open tickets, these tickets have already been worked on.' =>
            '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Усі заявки з встановленим нагадуванням, що досягнуто дати нагадування',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
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
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows generic agent to execute custom command line scripts.' =>
            '',
        'Allows generic agent to execute custom modules.' => '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            '',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Always show RichText if available' => '',
        'Answer' => 'Відповісти',
        'Appointment Calendar overview page.' => 'Сторінка перегляду Подій календаря',
        'Appointment Notifications' => 'Повідомлення по події',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            'модуль подій календаря, який готує записи повідомлення для подій',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            'модуль подій календаря, який оновлює тікет з даними від подій заявки',
        'Appointment edit screen.' => 'Екран редагування подій',
        'Appointment list' => 'Перелік подій',
        'Appointment list.' => 'Перелік подій',
        'Appointment notifications' => 'Повідомлення по події',
        'Appointments' => 'Події',
        'Arabic (Saudi Arabia)' => '',
        'ArticleTree' => '',
        'Attachment Name' => 'Назва Додатка',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Avatar' => '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Повернуте «%s».',
        'Bulgarian' => '',
        'Bulk Action' => 'Масова дія',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'CSV Separator' => 'Роздільник CSV',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Calendar manage screen.' => 'Екран керування календарем',
        'Catalan' => '',
        'Change password' => 'Змінити пароль',
        'Change queue!' => '',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the owner for this ticket' => 'Змінити власника цієї заявки',
        'Change the priority for this ticket' => '',
        'Change the responsible for this ticket' => '',
        'Change your avatar image.' => '',
        'Change your password and more.' => '',
        'Changed SLA to "%s" (%s).' => '',
        'Changed archive state to "%s".' => '',
        'Changed customer to "%s".' => '',
        'Changed dynamic field %s from "%s" to "%s".' => '',
        'Changed owner to "%s" (%s).' => '',
        'Changed pending time to "%s".' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => '',
        'Changed queue to "%s" (%s) from "%s" (%s).' => '',
        'Changed responsible to "%s" (%s).' => '',
        'Changed service to "%s" (%s).' => '',
        'Changed state from "%s" to "%s".' => '',
        'Changed title from "%s" to "%s".' => '',
        'Changed type from "%s" (%s) to "%s" (%s).' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Chat communication channel.' => '',
        'Checkbox' => '',
        'Checks for articles that needs to be updated in the article search index.' =>
            '',
        'Checks for communication log entries to be deleted.' => '',
        'Checks for queued outgoing emails to be sent.' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Child' => 'Дочірній',
        'Chinese (Simplified)' => '',
        'Chinese (Traditional)' => '',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            'Вибрати який вид повідомлення про зміни події Ви хочете отримувати',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Choose which notifications you\'d like to receive.' => '',
        'Christmas Eve' => 'Переддень Різдва',
        'Close' => 'Закрити',
        'Close this ticket' => 'Закрити цю заявку',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Cloud Services' => '',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => '',
        'Communication' => '',
        'Communication & Notifications' => '',
        'Communication Log GUI' => '',
        'Communication log limit per page for Communication Log Overview.' =>
            '',
        'CommunicationLog Overview Limit' => '',
        'Company Status' => '',
        'Company Tickets.' => '',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Compose' => 'Створити',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Налаштуйте, який екран ви будете бачити після створення нової заявки',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket.' => '',
        'Create Ticket' => '',
        'Create a new calendar appointment linked to this ticket' => 'Створити новий календар подій повязаний з цією заявкою',
        'Create and manage Service Level Agreements (SLAs).' => '',
        'Create and manage agents.' => 'Створення й керування агентами.',
        'Create and manage appointment notifications.' => 'Створити і керувати повідомленнями про події',
        'Create and manage attachments.' => 'Створення й керування вкладеннями.',
        'Create and manage calendars.' => '',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Створення й керування клієнтами.',
        'Create and manage dynamic fields.' => '',
        'Create and manage groups.' => 'Створення й керування групами.',
        'Create and manage queues.' => 'Створення й керування чергами.',
        'Create and manage responses that are automatically sent.' => 'Створення й керування автовідповідями.',
        'Create and manage roles.' => 'Створення й керування ролями.',
        'Create and manage salutations.' => 'Створення й керування вітаннями.',
        'Create and manage services.' => 'Створення й керування сервісами.',
        'Create and manage signatures.' => 'Створення й керування підписами.',
        'Create and manage templates.' => '',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'Створення й керування пріоритетами заявок.',
        'Create and manage ticket states.' => 'Створення й керування станами заявок.',
        'Create and manage ticket types.' => 'Створення й керування типами заявок.',
        'Create and manage web services.' => '',
        'Create new Ticket.' => '',
        'Create new appointment.' => 'Створити нову подію',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => '',
        'Create new phone ticket (inbound).' => '',
        'Create new phone ticket.' => '',
        'Create new process ticket.' => '',
        'Create tickets.' => '',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            '',
        'Croatian' => '',
        'Custom RSS Feed' => '',
        'Custom RSS feed.' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '',
        'Customer Companies' => 'Компанії клієнта',
        'Customer IDs' => '',
        'Customer Information Center Search.' => '',
        'Customer Information Center search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User Administration' => '',
        'Customer User Information' => '',
        'Customer User Information Center Search.' => '',
        'Customer User Information Center search.' => '',
        'Customer User Information Center.' => '',
        'Customer Users ↔ Customers' => '',
        'Customer Users ↔ Groups' => '',
        'Customer Users ↔ Services' => '',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => '',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'CustomerUser' => '',
        'Customers ↔ Groups' => '',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'Danish' => '',
        'Dashboard overview.' => '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default agent name' => '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => '',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            '',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            '',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Задає які колонки будуть показані в повязааному віджеті подій(LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a permission context for customer to group assignment.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            'Визначає іконку з посиланням на сторінку карт Google з поточним місцезнаходженням у вікні редагування події',
        'Defines an overview module to show the address book view of a customer user list.' =>
            '',
        'Defines available article actions for Chat articles.' => '',
        'Defines available article actions for Email articles.' => '',
        'Defines available article actions for Internal articles.' => '',
        'Defines available article actions for Phone articles.' => '',
        'Defines available article actions for invalid articles.' => '',
        'Defines available groups for the admin overview screen.' => '',
        'Defines chat communication channel.' => '',
        'Defines default headers for outgoing emails.' => '',
        'Defines email communication channel.' => '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines groups for preferences items.' => '',
        'Defines how many deployments the system should keep.' => '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
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
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            '',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines internal communication channel.' => '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines phone communication channel.' => '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            '',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
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
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default queue for new tickets in the agent interface.' =>
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
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
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
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
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
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
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
        'Defines the default ticket type.' => '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the default visibility of the article to customer for this operation.' =>
            '',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            'Визначає типи обєктів подій, які будуть оброблятися за допомогою AdminAppointmentNotificationEvent',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            '',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
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
        'Defines the list of params that can be passed to ticket search function.' =>
            'Визнгачає перелік пораметрів які можуть бути в опціях пошуку по заявці',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Визначає модуль, що показує сповіщення в інтерфейсі агента, якщо агент увійшов у систему при ввімкненому статусі «Не при справах».',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            '',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
            '',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
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
        'Defines the name of the table where the user preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
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
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of days to keep the daemon log files.' => '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            '',
        'Defines the number of hours a successful communication will be stored.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
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
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            '',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            '',
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
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            '',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            '',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the ticket plugin for calendar appointments.' => '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            '',
        'Defines whether to index archived tickets for fulltext searches.' =>
            '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Delete expired ticket draft entries.' => '',
        'Delete expired upload cache hourly.' => '',
        'Delete this ticket' => 'Вилучити цю заявку',
        'Deleted link to ticket "%s".' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Detached' => '',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            '',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display communication log entries.' => '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            '',
        'Down' => 'Вниз',
        'Dropdown' => '',
        'Dutch' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'Dynamic fields limit per page for Dynamic Fields Overview.' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            '',
        'DynamicField' => '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => '',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit appointment' => 'Редагувати подію',
        'Edit customer company' => '',
        'Email Addresses' => 'Адреси email',
        'Email Outbound' => '',
        'Email Resend' => '',
        'Email communication channel.' => '',
        'Enable highlighting queues based on ticket age.' => '',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Enabled filters.' => '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket type feature.' => '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'English (Canada)' => '',
        'English (United Kingdom)' => '',
        'English (United States)' => '',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            '',
        'Escalated Tickets' => 'Заявки з загостренням',
        'Escalation view' => 'Ескальовані заявки',
        'EscalationTime' => '',
        'Estonian' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer company object name for dynamic fields.' =>
            '',
        'Event module that updates customer user object name for dynamic fields.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => '',
        'Example package autoload configuration.' => '',
        'Execute SQL statements.' => '',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'External' => '',
        'External Link' => '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => '',
        'Finnish' => '',
        'First Christmas Day' => 'Різдво',
        'First Queue' => '',
        'First response time' => 'Час першої відповіді',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'For these state types the ticket numbers are striked through in the link table.' =>
            '',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Переспрямоване «%s».',
        'Free Fields' => 'Вільні поля',
        'French' => '',
        'French (Canada)' => '',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend module registration for the public interface.' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'Galician' => '',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'Generic Info module.' => '',
        'GenericAgent' => '',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface ErrorHandling GUI' => '',
        'GenericInterface Invoker Event GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Web Service History GUI' => '',
        'GenericInterface Web Service Mapping GUI' => '',
        'GenericInterface module registration for an error handling module.' =>
            '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Global Search Module.' => '',
        'Go to dashboard!' => 'Перейти до панелі!',
        'Good PGP signature.' => '',
        'Google Authenticator' => '',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => '',
        'Hebrew' => '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            '',
        'High Contrast' => '',
        'High contrast skin for visually impaired users.' => '',
        'Hindi' => '',
        'Hungarian' => '',
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
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
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
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the cache data be held in memory.' => '',
        'If enabled, the cache data will be stored in cache backend.' => '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            '',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Import appointments screen.' => 'Імпортувати еркан подій',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            '',
        'Indonesian' => '',
        'Inline' => '',
        'Input' => '',
        'Interface language' => 'Мова інтерфейсу',
        'Internal communication channel.' => '',
        'International Workers\' Day' => 'Міжнародний день трудящих',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => '',
        'JavaScript function for the search frontend.' => '',
        'Korean' => '',
        'Language' => 'Мова',
        'Large' => 'Великий',
        'Last Screen Overview' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => '',
        'Lastname Firstname (UserLogin)' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'LastnameFirstname' => '',
        'Latvian' => '',
        'Left' => '',
        'Link Object' => 'Зв\'язати об\'єкт',
        'Link Object.' => '',
        'Link agents to groups.' => 'Зв\'язати агентів із групами.',
        'Link agents to roles.' => 'Зв\'язати агентів з ролями.',
        'Link customer users to customers.' => '',
        'Link customer users to groups.' => '',
        'Link customer users to services.' => '',
        'Link customers to groups.' => '',
        'Link queues to auto responses.' => '',
        'Link roles to groups.' => '',
        'Link templates to attachments.' => '',
        'Link templates to queues.' => '',
        'Link this ticket to other objects' => 'Зв\'язати заявку з іншими об\'єктами',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'Links appointments and tickets with a "Normal" type link.' => 'Повязати події і заявки з "Normal" типом звязку ',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all LinkObject events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all appointment events to be displayed in the GUI.' => 'Перелік всіх подій для відображаються в GUI',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all calendar events to be displayed in the GUI.' => 'Перелік всіх подій календаря для відображення в GUI',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lithuanian' => '',
        'Loader module registration for the agent interface.' => '',
        'Loader module registration for the customer interface.' => '',
        'Lock / unlock this ticket' => '',
        'Locked Tickets' => 'Заблоковані заявки',
        'Locked Tickets.' => '',
        'Locked ticket.' => 'Заблокована заявка.',
        'Logged in users.' => '',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Look into a ticket!' => 'Переглянути заявку!',
        'Loop protection: no auto-response sent to "%s".' => '',
        'Macedonian' => '',
        'Mail Accounts' => '',
        'MailQueue configuration settings.' => '',
        'Main menu item registration.' => '',
        'Main menu registration.' => '',
        'Makes the application block external content loading.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => 'Керування PGP ключами для шифрування поштових повідомлень.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Керування POP3 або IMAP обліковими записами для одержання поштових повідомлень.',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage System Configuration Deployments.' => '',
        'Manage different calendars.' => 'Керувати різнимим календарями',
        'Manage existing sessions.' => 'Керування активними сеансами.',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark as Spam!' => 'Позначити як спам!',
        'Mark this ticket as junk!' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Medium' => 'Середній',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket (%s/%s) to (%s/%s).' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Minute' => '',
        'Miscellaneous' => '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if a incoming e-mail message is bounce.' => '',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            '',
        'Module to encrypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            'Модуль для генерування статистики за часом відгуку та рішення заявки.',
        'Module to generate ticket statistics.' => 'Модуль для формування статистки за заявками.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            '',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Module used to detect if attachments are present.' => '',
        'Multiselect' => '',
        'My Queues' => 'Мої черги',
        'My Services' => 'Мої Сервіси',
        'My Tickets.' => '',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Ticket' => 'Нова заявка',
        'New Tickets' => 'Нові заявки',
        'New Window' => '',
        'New Year\'s Day' => 'Новий рік',
        'New Year\'s Eve' => 'Переддень Нового року',
        'New process ticket' => '',
        'News about OTRS releases!' => 'Новини про релізи OTRS!',
        'News about OTRS.' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => '',
        'Norwegian' => '',
        'Notification Settings' => 'Налаштування сповіщень',
        'Notified about response time escalation.' => '',
        'Notified about solution time escalation.' => '',
        'Notified about update time escalation.' => '',
        'Number of displayed tickets' => 'Кількість відображуваних заявок',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Number of tickets to be displayed in each page.' => '',
        'OTRS Group Services' => '',
        'OTRS News' => 'Новини OTRS',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            '',
        'Open an external link!' => '',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Other Customers' => '',
        'Out Of Office' => 'Не при справах',
        'Out Of Office Time' => 'Час «Не при справах»',
        'Out of Office users.' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Час оновлення швидкого огляду',
        'Overview of all Tickets per assigned Queue.' => '',
        'Overview of all appointments.' => 'Переглянути всі події',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'Перегляд усіх відкритих заявок.',
        'Overview of all open tickets.' => '',
        'Overview of customer tickets.' => '',
        'PGP Key' => 'PGP ключ',
        'PGP Key Management' => '',
        'PGP Keys' => 'PGP ключі',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            '',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Parent' => 'Батьківський',
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Pending time' => 'час, що залишився',
        'People' => '',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => '',
        'Phone Call Inbound' => 'Вхідний телефонний дзвінок',
        'Phone Call Outbound' => 'Вихідний телефонний дзвінок',
        'Phone Call.' => '',
        'Phone call' => 'Телефонний дзвінок',
        'Phone communication channel.' => '',
        'Phone-Ticket' => 'Заявка — телефонний дзвінок',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => '',
        'Plugin search' => 'Пошук утиліти',
        'Plugin search module for autocomplete.' => 'Утиліта пошуку модуля для автозаповнення',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Print this ticket' => 'Роздрукувати цю заявку',
        'Priorities' => 'Пріоритети',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Processes & Automation' => '',
        'Product News' => 'Новини про продукт',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue' =>
            '',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            '',
        'Public Calendar' => 'Публічний календар',
        'Public calendar.' => 'Публічний календар',
        'Queue view' => 'Перегляд черги',
        'Queues ↔ Auto Responses' => '',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            '',
        'Refresh interval' => 'Оновляти кожні',
        'Registers a log module, that can be used to log communication related information.' =>
            '',
        'Reminder Tickets' => 'Заявки з нагадуванням',
        'Removed subscription for user "%s".' => 'Вилучена підписка для користувача «%s».',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            '',
        'Removes old system configuration deployments (Sunday mornings).' =>
            '',
        'Removes old ticket number counters (each 10 minutes).' => '',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => '',
        'Reports (OTRS Business Solution™)' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the email resend screen in the agent interface.' =>
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
        'Resend Ticket Email.' => '',
        'Resent email to "%s".' => '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Resource Overview (OTRS Business Solution™)' => 'Перегляд ресурів (OTRS Business Solution™)',
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles ↔ Groups' => '',
        'Romanian' => '',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => '',
        'S/MIME Certificates' => 'S/MIME-сертифікати',
        'SMS' => '',
        'SMS (Short Message Service)' => '',
        'Salutations' => 'Привітання',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen after new ticket' => 'Розділ після створення нової заявки',
        'Search Customer' => 'Шукати клієнта',
        'Search Ticket.' => '',
        'Search Tickets.' => '',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => '',
        'Second Christmas Day' => 'Другий день Різдва',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Оберіть символ розділювача, що використовується у файлах CSV (статистика і пошук). Якщо не оберете розділювач тут, то використовуватиметься стандартний розділювач для Вашої мови.',
        'Select your frontend Theme.' => 'Тема інтерфейсу',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            '',
        'Select your preferred layout for the software.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'Відправити повідомлення користувачам.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            '',
        'Sent "%s" notification to "%s" via "%s".' => '',
        'Sent auto follow-up to "%s".' => '',
        'Sent auto reject to "%s".' => '',
        'Sent auto reply to "%s".' => '',
        'Sent email to "%s".' => '',
        'Sent email to customer.' => '',
        'Sent notification to "%s".' => '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service Level Agreements' => 'Угоди про рівень сервісу',
        'Service view' => '',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'Задати адреса відправника для цієї системи.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            '',
        'Set this ticket to pending' => 'Позначити цю заявку як «в очікуванні»',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Sets if queue must be selected by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if state must be selected by the agent.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets if ticket responsible must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            '',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
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
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of split tickets in the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
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
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the preferred digest to be used for PGP binary.' => '',
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
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            '',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the stats hook.' => '',
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
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            '',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            '',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Shared Secret' => '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show command line output.' => '',
        'Show queues even when only locked tickets are in.' => '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Show the ticket history' => 'Показати історію заявки',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all both ro and rw tickets in the service view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows information on how to start OTRS Daemon' => '',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows the article head information in the agent zoom view.' => '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
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
        'Shows the title field in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            '',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            '',
        'Signature data.' => '',
        'Signatures' => 'Підписи',
        'Simple' => '',
        'Skin' => 'Оболонка',
        'Slovak' => '',
        'Slovenian' => '',
        'Small' => 'Малий',
        'Software Package Manager.' => '',
        'Solution time' => 'Час вирішення',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
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
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Started response time escalation.' => '',
        'Started solution time escalation.' => '',
        'Started update time escalation.' => '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Звіт №',
        'States' => 'Стани',
        'Statistic Reports overview.' => '',
        'Statistics overview.' => '',
        'Status view' => 'Перегляд статусу',
        'Stopped response time escalation.' => '',
        'Stopped solution time escalation.' => '',
        'Stopped update time escalation.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Support Agent' => '',
        'Swahili' => '',
        'Swedish' => '',
        'System Address Display Name' => '',
        'System Configuration Deployment' => '',
        'System Configuration Group' => '',
        'System Maintenance' => '',
        'Templates ↔ Attachments' => '',
        'Templates ↔ Queues' => '',
        'Textarea' => '',
        'Thai' => '',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The daemon registration for the system configuration deployment sync manager.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            '',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'The value of the From field' => '',
        'Theme' => 'Тема',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            '',
        'This is a Description for Comment on Framework.' => '',
        'This is a Description for DynamicField on Framework.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is part of the admin area of OTRS.' => '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'This setting is deprecated. Set OTRSTimeZone instead.' => '',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            '',
        'This will allow the system to send text messages via SMS.' => '',
        'Ticket Close.' => '',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => '',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => '',
        'Ticket Lock.' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => '',
        'Ticket Notifications' => 'Сповіщення заявок',
        'Ticket Outbound Email.' => '',
        'Ticket Overview "Medium" Limit' => 'Ліміт заявок при «Середньому» перегляді',
        'Ticket Overview "Preview" Limit' => 'Ліміт заявок при «Попередньому» перегляді',
        'Ticket Overview "Small" Limit' => 'Ліміт заявок при «Малому» перегляді',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => '',
        'Ticket Responsible.' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom' => '',
        'Ticket Zoom.' => '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket limit per page for Ticket Overview "Medium".' => '',
        'Ticket limit per page for Ticket Overview "Preview".' => '',
        'Ticket limit per page for Ticket Overview "Small".' => '',
        'Ticket notifications' => 'Сповіщення заявок',
        'Ticket overview' => 'Перегляд заявки',
        'Ticket plain view of an email.' => '',
        'Ticket split dialog.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => '',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'To view HTML attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            '',
        'Tree view' => '',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            'Тригери для додавання чи автоматичного оновлення подій на основі певних часів тікету',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Tweak the system as you wish.' => '',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            '',
        'Ukrainian' => '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Розблоковує тікети, якщо додається нотатка і власник у статусі «не при справах».',
        'Unlocked ticket.' => 'Розблокована заявка.',
        'Up' => 'Вгору',
        'Upcoming Events' => 'Найближчі події',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update time' => 'Час оновлення',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'User Profile' => 'Профіль користувача',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Users, Groups & Roles' => '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => '',
        'View all attachments of the current ticket' => '',
        'View performance benchmark results.' => 'Перегляд результатів виміру продуктивності.',
        'Watch this ticket' => '',
        'Watched Tickets' => 'Спостережувані заявки',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => '',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            '',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            '',
        'Web Services' => 'Веб сервіси',
        'Web View' => '',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            '',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Ваш email з номером заявки «<OTRS_TICKET>» об\'єднаний з "<OTRS_MERGE_TO_TICKET>".',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'Zoom' => 'Докладно',
        'attachment' => '',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'normal' => 'звичайний',
        'notice' => '',
        'pending' => '',
        'phone' => 'дзвінок',
        'responsible' => '',
        'reverse' => 'повернути',
        'stats' => '',

    };

    $Self->{JavaScriptStrings} = [
        ' ...and %s more',
        ' ...show less',
        '%s B',
        '%s GB',
        '%s KB',
        '%s MB',
        '%s TB',
        '+%s more',
        'A key with this name (\'%s\') already exists.',
        'A package upgrade was recently finished. Click here to see the results.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.',
        'Add',
        'Add Event Trigger',
        'Add all',
        'Add entry',
        'Add key',
        'Add new draft',
        'Add new entry',
        'Add to favourites',
        'Agent',
        'All occurrences',
        'All-day',
        'An error occurred during communication.',
        'An error occurred! Please check the browser error log for more details!',
        'An item with this name is already present.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.',
        'An unknown error occurred. Please contact the administrator.',
        'Apply',
        'Appointment',
        'Apr',
        'April',
        'Are you sure you want to delete this appointment? This operation cannot be undone.',
        'Are you sure you want to update all installed packages?',
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.',
        'Article display',
        'Article filter',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?',
        'Ascending sort applied, ',
        'Attachment was deleted successfully.',
        'Attachments',
        'Aug',
        'August',
        'Available space %s of %s.',
        'Basic information',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?',
        'Calendar',
        'Cancel',
        'Cannot proceed',
        'Clear',
        'Clear all',
        'Clear debug log',
        'Clear search',
        'Click to delete this attachment.',
        'Click to select a file for upload.',
        'Click to select a file or just drop it here.',
        'Click to select files or just drop them here.',
        'Clone web service',
        'Close preview',
        'Close this dialog',
        'Complex %s with %s arguments',
        'Confirm',
        'Could not open popup window. Please disable any popup blockers for this application.',
        'Current selection',
        'Currently not possible',
        'Customer interface does not support articles not visible for customers.',
        'Data Protection',
        'Date/Time',
        'Day',
        'Dec',
        'December',
        'Delete',
        'Delete Entity',
        'Delete conditions',
        'Delete draft',
        'Delete error handling module',
        'Delete field',
        'Delete invoker',
        'Delete operation',
        'Delete this Attachment',
        'Delete this Event Trigger',
        'Delete this Invoker',
        'Delete this Key Mapping',
        'Delete this Mail Account',
        'Delete this Operation',
        'Delete this PostMasterFilter',
        'Delete this Template',
        'Delete web service',
        'Deleting attachment...',
        'Deleting the field and its data. This may take a while...',
        'Deleting the mail account and its data. This may take a while...',
        'Deleting the postmaster filter and its data. This may take a while...',
        'Deleting the template and its data. This may take a while...',
        'Deploy',
        'Deploy now',
        'Deploying, please wait...',
        'Deployment comment...',
        'Deployment successful. You\'re being redirected...',
        'Descending sort applied, ',
        'Description',
        'Dismiss',
        'Do not show this warning again.',
        'Do you really want to continue?',
        'Do you really want to delete "%s"?',
        'Do you really want to delete this certificate?',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!',
        'Do you really want to delete this generic agent job?',
        'Do you really want to delete this key?',
        'Do you really want to delete this link?',
        'Do you really want to delete this notification language?',
        'Do you really want to delete this notification?',
        'Do you really want to delete this scheduled system maintenance?',
        'Do you really want to delete this statistic?',
        'Do you really want to reset this setting to it\'s default value?',
        'Do you really want to revert this setting to its historical value?',
        'Don\'t save, update manually',
        'Draft title',
        'Duplicate event.',
        'Duplicated entry',
        'Edit Field Details',
        'Edit this setting',
        'Edit this transition',
        'End date',
        'Error',
        'Error during AJAX communication',
        'Error during AJAX communication. Status: %s, Error: %s',
        'Error in the mail settings. Please correct and try again.',
        'Error: Browser Check failed!',
        'Event Type Filter',
        'Expanded',
        'Feb',
        'February',
        'Filters',
        'Find out more',
        'Finished',
        'First select a customer user, then select a customer ID to assign to this ticket.',
        'Fr',
        'Fri',
        'Friday',
        'Generate',
        'Generate Result',
        'Generating...',
        'Grouped',
        'Help',
        'Hide EntityIDs',
        'If you now leave this page, all open popup windows will be closed, too!',
        'Import web service',
        'Information about the OTRS Daemon',
        'Invalid date (need a future date)!',
        'Invalid date (need a past date)!',
        'Invalid date!',
        'It is going to be deleted from the field, please try again.',
        'It is not possible to add a new event trigger because the event is not set.',
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.',
        'It was not possible to delete this draft.',
        'It was not possible to generate the Support Bundle.',
        'Jan',
        'January',
        'Jul',
        'July',
        'Jump',
        'Jun',
        'June',
        'Just this occurrence',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.',
        'Less',
        'Link',
        'Loading, please wait...',
        'Loading...',
        'Location',
        'Mail check successful.',
        'Mapping for Key',
        'Mapping for Key %s',
        'Mar',
        'March',
        'May',
        'May_long',
        'Mo',
        'Mon',
        'Monday',
        'Month',
        'More',
        'Name',
        'Namespace %s could not be initialized, because %s could not be found.',
        'Next',
        'No Data Available.',
        'No TransitionActions assigned.',
        'No data found.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.',
        'No matches found.',
        'No package information available.',
        'No response from get package upgrade result.',
        'No response from get package upgrade run status.',
        'No response from package upgrade all.',
        'No sort applied, ',
        'No space left for the following files: %s',
        'Not available',
        'Notice',
        'Notification',
        'Nov',
        'November',
        'OK',
        'Oct',
        'October',
        'One or more errors occurred!',
        'Open URL in new tab',
        'Open date selection',
        'Open this node in a new window',
        'Please add values for all keys before saving the setting.',
        'Please check the fields marked as red for valid inputs.',
        'Please either turn some off first or increase the limit in configuration.',
        'Please enter at least one search value or * to find anything.',
        'Please enter at least one search word to find anything.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.',
        'Please only select at most %s files for upload.',
        'Please only select one file for upload.',
        'Please remove the following words from your search as they cannot be searched for:',
        'Please see the documentation or ask your admin for further information.',
        'Please turn off Compatibility Mode in Internet Explorer!',
        'Please wait...',
        'Preparing to deploy, please wait...',
        'Press Ctrl+C (Cmd+C) to copy to clipboard',
        'Previous',
        'Process state',
        'Queues',
        'Reload page',
        'Reload page (%ss)',
        'Remove',
        'Remove Entity from canvas',
        'Remove active filters for this widget.',
        'Remove all user changes.',
        'Remove from favourites',
        'Remove selection',
        'Remove the Transition from this Process',
        'Remove the filter',
        'Remove this dynamic field',
        'Remove this entry',
        'Repeat',
        'Request Details',
        'Request Details for Communication ID',
        'Reset',
        'Reset globally',
        'Reset locally',
        'Reset option is required!',
        'Reset options',
        'Reset setting',
        'Reset setting on global level.',
        'Resource',
        'Resources',
        'Restore default settings',
        'Restore web service configuration',
        'Rule',
        'Running',
        'Sa',
        'Sat',
        'Saturday',
        'Save',
        'Save and update automatically',
        'Scale preview content',
        'Search',
        'Search attributes',
        'Search the System Configuration',
        'Searching for linkable objects. This may take a while...',
        'Select a customer ID to assign to this ticket',
        'Select a customer ID to assign to this ticket.',
        'Select all',
        'Sending Update...',
        'Sep',
        'September',
        'Setting a template will overwrite any text or attachment.',
        'Settings',
        'Show',
        'Show EntityIDs',
        'Show current selection',
        'Show or hide the content.',
        'Slide the navigation bar',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.',
        'Sorry, but you can\'t disable all methods for this notification.',
        'Sorry, the only existing condition can\'t be removed.',
        'Sorry, the only existing field can\'t be removed.',
        'Sorry, the only existing parameter can\'t be removed.',
        'Sorry, you can only upload %s files.',
        'Sorry, you can only upload one file here.',
        'Split',
        'Stacked',
        'Start date',
        'Status',
        'Stream',
        'Su',
        'Sun',
        'Sunday',
        'Support Bundle',
        'Support Data information was successfully sent.',
        'Switch to desktop mode',
        'Switch to mobile mode',
        'System Registration',
        'Team',
        'Th',
        'The browser you are using is too old.',
        'The deployment is already running.',
        'The following files are not allowed to be uploaded: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s',
        'The following files were already uploaded and have not been uploaded again: %s',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.',
        'The key must not be empty.',
        'The mail could not be sent',
        'There are currently no elements available to select from.',
        'There are no more drafts available.',
        'There is a package upgrade process running, click here to see status information about the upgrade progress.',
        'There was an error deleting the attachment. Please check the logs for more information.',
        'There was an error. Please save all settings you are editing and check the logs for more information.',
        'This Activity cannot be deleted because it is the Start Activity.',
        'This Activity is already used in the Process. You cannot add it twice!',
        'This Transition is already used for this Activity. You cannot use it twice!',
        'This TransitionAction is already used in this Path. You cannot use it twice!',
        'This address already exists on the address list.',
        'This element has children elements and can currently not be removed.',
        'This event is already attached to the job, Please use a different one.',
        'This feature is part of the %s. Please contact us at %s for an upgrade.',
        'This field can have no more than 250 characters.',
        'This field is required.',
        'This is %s',
        'This is a repeating appointment',
        'This is currently disabled because of an ongoing package upgrade.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?',
        'This option is currently disabled because the OTRS Daemon is not running.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.',
        'This window must be called from compose window.',
        'Thu',
        'Thursday',
        'Timeline Day',
        'Timeline Month',
        'Timeline Week',
        'Title',
        'Today',
        'Too many active calendars',
        'Try again',
        'Tu',
        'Tue',
        'Tuesday',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.',
        'Unknown',
        'Unlock setting.',
        'Update All Packages',
        'Update Result',
        'Update all packages',
        'Update manually',
        'Upload information',
        'Uploading...',
        'Use options below to narrow down for which tickets appointments will be automatically created.',
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.',
        'Warning',
        'Was not possible to send Support Data information.',
        'We',
        'Wed',
        'Wednesday',
        'Week',
        'Would you like to edit just this occurrence or all occurrences?',
        'Yes',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.',
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.',
        'You have undeployed settings, would you like to deploy them?',
        'activate to apply a descending sort',
        'activate to apply an ascending sort',
        'activate to remove the sort',
        'and %s more...',
        'day',
        'month',
        'more',
        'no',
        'none',
        'or',
        'sorting is disabled',
        'user(s) have modified this setting.',
        'week',
        'yes',
    ];

    # $$STOP$$
    return;
}

1;
