# --
# Kernel/Language/bg.pm - provides bg language translation
# Copyright (C) 2004 Vladimir Gerdjikov <gerdjikov at gerdjikovs.net>
# Copyright (C) 2007 Alex Kantchev <ak at otrs.org>
# --
# $Id: bg.pm,v 1.64 2007-10-02 10:45:42 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::bg;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.64 $) [1];

sub Data {
    my ( $Self, %Param ) = @_;

    # $$START$$
    # Last translation file sync: Tue May 29 15:07:15 2007

    # possible charsets
    $Self->{Charset} = [ 'cp1251', 'Windows-1251', ];

    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y - %T';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes'                 => 'Да',
        'No'                  => 'Не',
        'yes'                 => 'да',
        'no'                  => 'не',
        'Off'                 => 'Изключено',
        'off'                 => 'изключено',
        'On'                  => 'Включено',
        'on'                  => 'включено',
        'top'                 => 'към началото',
        'end'                 => 'Край',
        'Done'                => 'Готово.',
        'Cancel'              => 'Отказ',
        'Reset'               => 'Рестартирай',
        'last'                => 'последните',
        'before'              => 'преди',
        'day'                 => 'ден',
        'days'                => 'дни',
        'day(s)'              => 'ден/дни',
        'hour'                => 'час',
        'hours'               => 'часове',
        'hour(s)'             => 'час(ове)',
        'minute'              => 'минута',
        'minutes'             => 'минути',
        'minute(s)'           => 'минута(и)',
        'month'               => 'месец',
        'months'              => 'месеци',
        'month(s)'            => 'месец(и)',
        'week'                => 'седмица',
        'week(s)'             => 'седмица(и)',
        'year'                => 'година',
        'years'               => 'години',
        'year(s)'             => 'година(и)',
        'second(s)'           => 'секунда(и)',
        'seconds'             => 'секунди',
        'second'              => 'секунда',
        'wrote'               => 'записано',
        'Message'             => 'Съобщение',
        'Error'               => 'Грешка',
        'Bug Report'          => 'Отчет за грешка',
        'Attention'           => 'Внимание',
        'Warning'             => 'Предупреждение',
        'Module'              => 'Модул',
        'Modulefile'          => 'Файл-модул',
        'Subfunction'         => 'Подфункция',
        'Line'                => 'Линия',
        'Example'             => 'Пример',
        'Examples'            => 'Примери',
        'valid'               => 'валиден',
        'invalid'             => 'невалиден',
        '* invalid'           => '',
        'invalid-temporarily' => 'временно невалиден',
        ' 2 minutes'          => ' 2 Минути',
        ' 5 minutes'          => ' 5 Минути',
        ' 7 minutes'          => ' 7 Минути',
        '10 minutes'          => '10 Минути',
        '15 minutes'          => '15 Минути',
        'Mr.'                 => 'Г-н.',
        'Mrs.'                => 'Г-жа',
        'Next'                => 'Напред',
        'Back'                => 'Назад',
        'Next...'             => 'Напред...',
        '...Back'             => '...Назад',
        '-none-'              => '-няма-',
        'none'                => 'няма',
        'none!'               => 'няма!',
        'none - answered'     => 'няма - отговорен',
        'please do not edit!' => 'моля, не редактирайте!',
        'AddLink'             => 'Добавяне на връзка',
        'Link'                => 'Връзка',
        'Linked'              => 'Свързан',
        'Link (Normal)'       => 'Връзка (нормална)',
        'Link (Parent)'       => 'Връзка (родител)',
        'Link (Child)'        => 'Връзка (дете)',
        'Normal'              => 'Нормална',
        'Parent'              => 'Родител',
        'Child'               => 'Дете',
        'Hit'                 => 'Попадение',
        'Hits'                => 'Попадения',
        'Text'                => 'Текст',
        'Lite'                => 'Лека',
        'User'                => 'Потребител',
        'Username'            => 'Потребителско име',
        'Language'            => 'Език',
        'Languages'           => 'Езици',
        'Password'            => 'Парола',
        'Salutation'          => 'Обръщение',
        'Signature'           => 'Подпис',
        'Customer'            => 'Потребител',
        'CustomerID'          => 'Потребителски индикатив',
        'CustomerIDs'         => 'Портребителски индикативи',
        'customer'            => 'потребител',
        'agent'               => 'агент',
        'system'              => 'система',
        'Customer Info'       => 'Потребителски данни',
        'Customer Company'    => 'Компания',
        'Company'             => 'Компания',
        'go!'                 => 'ОК!',
        'go'                  => 'ОК',
        'All'                 => 'Всички',
        'all'                 => 'всички',
        'Sorry'               => 'Съжаляваме',
        'update!'             => 'обновяване!',
        'update'              => 'обновяване',
        'Update'              => 'Обновяване',
        'submit!'             => 'изпратете!',
        'submit'              => 'изпратете',
        'Submit'              => 'Изпратете',
        'change!'             => 'променете!',
        'Change'              => 'Промяна',
        'change'              => 'променете',
        'click here'          => 'натиснете тук',
        'Comment'             => 'Коментар',
        'Valid'               => 'Валиден',
        'Invalid Option!'     => 'Невалидна опция!',
        'Invalid time!'       => 'Невалидно време!',
        'Invalid date!'       => 'Невалидна дата!',
        'Name'                => 'Име',
        'Group'               => 'Група',
        'Description'         => 'Описание',
        'description'         => 'описание',
        'Theme'               => 'Тема',
        'Created'             => 'Създаден',
        'Created by'          => 'Създаден от',
        'Changed'             => 'Променен',
        'Changed by'          => 'Променен от',
        'Search'              => 'Търсене',
        'and'                 => 'и',
        'between'             => 'между',
        'Fulltext Search'     => 'Пълнотекстово търсене',
        'Data'                => 'Данни',
        'Options'             => 'Настройки',
        'Title'               => 'Заглавие',
        'Item'                => 'Елемент',
        'Delete'              => 'Изтриване',
        'Edit'                => 'Редакция',
        'View'                => 'Изглед',
        'Number'              => 'Номер',
        'System'              => 'Система',
        'Contact'             => 'Контакт',
        'Contacts'            => 'Контакти',
        'Export'              => 'Експортиране',
        'Up'                  => 'Нагоре',
        'Down'                => 'Надолу',
        'Add'                 => 'Добавяне',
        'Category'            => 'Категория',
        'Viewer'              => 'Viewer',
        'New message'         => 'Ново съобщение',
        'New message!'        => 'Ново съобщение!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Моля, отговорете на този билет(и) за да се върнете в нормалния изглед на опашката!',
        'You got new message!'            => 'Получихте ново съобщение!',
        'You have %s new message(s)!'     => 'Вие имате %s ново/нови съобщение/съобщения!',
        'You have %s reminder ticket(s)!' => 'Вие имате %s оставащ/оставащи билет/билети!',
        'The recommended charset for your language is %s!' =>
            'Препоръчителният символен набор за Вашият език е %s!',
        'Passwords doesn\'t match! Please try it again!' =>
            'Паролите не съвпадат! Опитайте отново!',
        'Password is already in use! Please use an other password!' =>
            'Паролата се използва! Моля опитайте отново!',
        'Password is already used! Please use an other password!' =>
            'Паролата вече е използвана. Моля опитайте отново!',
        'You need to activate %s first to use it!' =>
            'Първо трябва да активирате %s преди да се използва!',
        'No suggestions'                            => 'Няма предположения',
        'Word'                                      => 'Дума',
        'Ignore'                                    => 'Пренебрегване',
        'replace with'                              => 'замести с',
        'There is no account with that login name.' => 'Няма потребител с това име.',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Неуспешно оторизиране! Вашето име и/или парола са некоректини!',
        'Please contact your admin' => 'Моля, свържете се с Вашият администратор',
        'Logout successful. Thank you for using OTRS!' =>
            'Изходът е успешен. Благодарим Ви, че използвахте системата.',
        'Invalid SessionID!'  => 'Невалиден SessionID!',
        'Feature not active!' => 'Функцията не е активна',
        'Login is needed!'    => 'Логин-а е задължителен',
        'Password is needed!' => 'Паролата е задължителна',
        'License'             => 'Лиценз',
        'Take this Customer'  => 'Използвай този клиент',
        'Take this User'      => 'Изберете този потребител',
        'possible'            => 'възможен',
        'reject'              => 'отхвърлен',
        'reverse'             => 'обърнато',
        'Facility'            => 'Приспособление',
        'Timeover'            => 'Надхвърляне на времето',
        'Pending till'        => 'В очакване до',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'Не работете с UserID 1 (Системен акаунт)! Създайте нови потребители.',
        'Dispatching by email To: field.' => 'Разпределяне по поле To: от писмото.',
        'Dispatching by selected Queue.'  => 'Разпределение по избрана опашка.',
        'No entry found!'                 => 'Няма въдедена стойност!',
        'Session has timed out. Please log in again.' =>
            'Моля, оторизирайте се отново. Тази сесия вече е затворена.',
        'No Permission!' => 'Нямате позволение!',
        'To: (%s) replaced with database email!' =>
            'To: (%s) заменено с e-mail адреса от базата данни',
        'Cc: (%s) added database email!' => 'Cc: (%s) e-mail адреса добавен от базата данни',
        '(Click here to add)'            => '(Кликнете тук за добавяне)',
        'Preview'                        => 'Преглед',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'Софтуерния пакет не е коректно инсталиран. Пакета трябва да се инсталира отново',
        'Added User "%s"'     => 'Добавен портребител "%s" ',
        'Contract'            => 'Договор',
        'Online Customer: %s' => 'Клиент(и) онлайн: %s',
        'Online Agent: %s'    => 'Агент(и) онлайн: %s',
        'Calendar'            => 'Календар',
        'File'                => 'Файл',
        'Filename'            => 'Име на файл',
        'Type'                => 'Тип',
        'Size'                => 'Размер',
        'Upload'              => 'Качване',
        'Directory'           => 'Директория',
        'Signed'              => 'Подписано',
        'Sign'                => 'Подпиши',
        'Crypted'             => 'Кодирано',
        'Crypt'               => 'Кодирай',
        'Office'              => 'Офис',
        'Phone'               => 'Телефон',
        'Fax'                 => 'Факс',
        'Mobile'              => 'Мобилен телефон',
        'Zip'                 => 'Пощенски код',
        'City'                => 'Град',
        'Country'             => 'Държава',
        'installed'           => 'инсталирано',
        'uninstalled'         => 'деинсталирано',
        'Security Note: You should activate %s because application is already running!' =>
            'Съобщение: Трябва да активирате %s защото приложението вече работи!',
        'Unable to parse Online Repository index document!' =>
            'Неуспешен анализ на индексния документ на това Online repository!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!'
            => 'Няма пакети за този Framework в това Online Repository, но има пакети за други Frameworks',
        'No Packages or no new Packages in selected Online Repository!' =>
            'Няма (нови) пакети в избраното Online Repository',
        'printed at' => 'отпечатано в',

        # Template: AAAMonth
        'Jan'       => 'Яну',
        'Feb'       => 'Фев',
        'Mar'       => 'Мар',
        'Apr'       => 'Апр',
        'May'       => 'Май',
        'Jun'       => 'Юни',
        'Jul'       => 'Юли',
        'Aug'       => 'Авг',
        'Sep'       => 'Сеп',
        'Oct'       => 'Окт',
        'Nov'       => 'Ное',
        'Dec'       => 'Дек',
        'January'   => 'Януари',
        'February'  => 'Февруари',
        'March'     => 'Март',
        'April'     => 'Април',
        'June'      => 'Юни',
        'July'      => 'Юли',
        'August'    => 'Август',
        'September' => 'Септември',
        'October'   => 'Октомври',
        'November'  => 'Ноември',
        'December'  => 'Декември',

        # Template: AAANavBar
        'Admin-Area'                => 'Административна част',
        'Agent-Area'                => 'Агенти',
        'Ticket-Area'               => 'Билети',
        'Logout'                    => 'Изход',
        'Agent Preferences'         => 'Предпочитания на агент портребител',
        'Preferences'               => 'Предпочитания',
        'Agent Mailbox'             => 'Пощенска кутия',
        'Stats'                     => 'Статистики',
        'Stats-Area'                => 'Статистики',
        'Admin'                     => 'Администрация',
        'Customer Users'            => 'Клиент-потребители',
        'Customer Users <-> Groups' => 'Клиент-потребители <-> Групи',
        'Users <-> Groups'          => 'Агент потребители <-> Групи',
        'Roles'                     => 'Роли',
        'Roles <-> Users'           => 'Роли <-> Потребители',
        'Roles <-> Groups'          => 'Роли <-> Групи',
        'Salutations'               => 'Обръщения',
        'Signatures'                => 'Подписи',
        'Email Addresses'           => 'E-mail адреси',
        'Notifications'             => 'Уведомления',
        'Category Tree'             => 'Дърво на категориите',
        'Admin Notification'        => 'Административно уведомление',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Предпочитанията са обновени успешно',
        'Mail Management'                   => 'Управление на пощата',
        'Frontend'                          => 'Зона-потребител',
        'Other Options'                     => 'Други настройки',
        'Change Password'                   => 'Смяна на паролата',
        'New password'                      => 'Нова парола',
        'New password again'                => 'Нова парола (отново)',
        'Select your QueueView refresh time.' =>
            'Изберете Вашето време за обновяване за изгледа на опашката.',
        'Select your frontend language.' => 'Изберете Вашият език.',
        'Select your frontend Charset.'  => 'Изберете Вашият символен набор.',
        'Select your frontend Theme.'    => 'Изберете Вашата потребителска тема',
        'Select your frontend QueueView.' =>
            'Изберете език за визуализация съдържанието на опашката.',
        'Spelling Dictionary' => 'Речик за проверка на правописа',
        'Select your default spelling dictionary.' =>
            'Изберете Вашият речник за проверка на правописът',
        'Max. shown Tickets a page in Overview.' =>
            'Максимален брой Билети на страница (при преглед)',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' =>
            'Невъзможно актуализиране на паролата! Паролите не съвпадат! Моля опитайте отново!',
        'Can\'t update password, invalid characters!' =>
            'Невъзможно актуализиране на паролата! Невалидни символи!',
        'Can\'t update password, need min. 8 characters!' =>
            'Невъзможно актуализиране на паролата! Необходимо минимум 8 символа!',
        'Can\'t update password, need 2 lower and 2 upper characters!' =>
            'Невъзможно актуализиране на паролата! Необходими са 2 малки и 2 големи букви!',
        'Can\'t update password, need min. 1 digit!' =>
            'Невъзможно актуализиране на паролата! Необходимо е минимум 1 цифра!',
        'Can\'t update password, need min. 2 characters!' =>
            'Невъзможно актуализиране на паролата! Необходими са минимум 2 символа!',

        # Template: AAAStats
        'Stat'                                      => 'Статистика',
        'Please fill out the required fields!'      => 'Моля попълнете задължителните полета!',
        'Please select a file!'                     => 'Моля изберете файл!',
        'Please select an object!'                  => 'Моля изберете обект!',
        'Please select a graph size!'               => 'Моля изберете размер на графиката!',
        'Please select one element for the X-axis!' => 'Моля изберете един елемент за оста Х',
        'You have to select two or more attributes from the select field!' =>
            'Трябва да изберете два или повече атрибути от полето!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!'
            => 'Моля изберете само един елемент или включете \'Fixed\', където полето е маркирано!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Ако използвате отметка, трябва да изберете атрибути от полето!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Моля въведете стойност във избраното поле или изключете отметката \'Fixed\'!',
        'The selected end time is before the start time!' =>
            'Избрания краен момент от време е преди началния момент!',
        'You have to select one or more attributes from the select field!' =>
            'Трябва да изберете един или повече атрибути от полето!',
        'The selected Date isn\'t valid!' => 'Избраната дата не е валидна!',
        'Please select only one or two elements via the checkbox!' =>
            'Моля изберете един или два елемента посредством отметката!',
        'If you use a time scale element you can only select one element!' =>
            'Ако използвате времева скала може да изберете само един елемент!',
        'You have an error in your time selection!' =>
            'Имате грешка при избиране на времевия период!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Времевия интервал за справката е прекалено малък, моля използвайте по-голям интервал!',
        'The selected start time is before the allowed start time!' =>
            'Възможния начален момент от време е преди възможния краен момент от време!',
        'The selected end time is after the allowed end time!' =>
            'Възможния начален момент от време е след възможния краен момент от време!',
        'The selected time period is larger than the allowed time period!' =>
            'Избрания времеви интервал е по-голям от максимално възможния!',
        'Common Specification'   => 'Общи спецификации',
        'Xaxis'                  => 'Ос Х',
        'Value Series'           => 'Поредици за стойност',
        'Restrictions'           => 'Ограничения',
        'graph-lines'            => 'Графика-линии',
        'graph-bars'             => 'Графика-ленти',
        'graph-hbars'            => 'Графика-хоризонтални ленти',
        'graph-points'           => 'Графика-точки',
        'graph-lines-points'     => 'Графика-линии и точки',
        'graph-area'             => 'Място за графика',
        'graph-pie'              => 'Графика-кръгла',
        'extended'               => 'разширен',
        'Agent/Owner'            => 'Агент/Собственик',
        'Created by Agent/Owner' => 'Създадени от агент/собственик',
        'Created Priority'       => 'Създадени с приоритет',
        'Created State'          => 'Създадени в статус',
        'Create Time'            => 'Време на създаване',
        'CustomerUserLogin'      => 'Логин на клиент-потребител',
        'Close Time'             => 'Време на затваряне',

        # Template: AAATicket
        'Lock'               => 'Заключи',
        'Unlock'             => 'Отключи',
        'History'            => 'Хроника',
        'Zoom'               => 'Подробно',
        'Age'                => 'Възраст',
        'Bounce'             => 'Отхвърли',
        'Forward'            => 'Препратете',
        'From'               => 'От',
        'To'                 => 'До',
        'Cc'                 => 'Копие до',
        'Bcc'                => 'Скрито копие',
        'Subject'            => 'Относно',
        'Move'               => 'Преместване',
        'Queue'              => 'Опашка',
        'Priority'           => 'Приоритет',
        'State'              => 'Статус',
        'Compose'            => 'Създаване',
        'Pending'            => 'В очакване',
        'Owner'              => 'Собственик',
        'Owner Update'       => 'Обновяване на собственик',
        'Responsible'        => 'Отговорник',
        'Responsible Update' => 'Обноваеане на отговорника',
        'Sender'             => 'Изпращач',
        'Article'            => 'Клауза',
        'Ticket'             => 'Билет',
        'Createtime'         => 'време на създаване',
        'plain'              => 'обикновен',
        'Email'              => 'е-поща',
        'email'              => 'е-поща',
        'Close'              => 'Затваряне',
        'Action'             => 'Действие',
        'Attachment'         => 'Прикачен файл',
        'Attachments'        => 'Прикачени файлове',
        'This message was written in a character set other than your own.' =>
            'Това писмо е написано в символна подредба различна от тази, която използвате.',
        'If it is not displayed correctly,' => 'Ако не се вижда коректно,',
        'This is a'                         => 'Това е',
        'to open it in a new window.'       => 'да го отворите в нов прозорец',
        'This is a HTML email. Click here to show it.' =>
            'Това е поща в HTML формат. Натиснете тук, за да покажете коректно',
        'Free Fields'          => 'Полета',
        'Merge'                => 'Изравняване',
        'merged'               => 'изравнен',
        'closed successful'    => 'успешно затворен',
        'closed unsuccessful'  => 'неуспешно затворен',
        'new'                  => 'нов',
        'open'                 => 'отворен',
        'closed'               => 'затворен',
        'removed'              => 'премахнат',
        'pending reminder'     => 'очаква напомняне',
        'pending auto'         => 'очаква авроматично',
        'pending auto close+'  => 'очаква автоматично затваряне+',
        'pending auto close-'  => 'очаква автоматично затваряне-',
        'email-external'       => 'външна е-поща',
        'email-internal'       => 'вътрешна е-поща',
        'note-external'        => 'външна бележка',
        'note-internal'        => 'вътрешна бележка',
        'note-report'          => 'бележка отчет',
        'phone'                => 'телефон',
        'sms'                  => 'SMS',
        'webrequest'           => 'заявка по web',
        'lock'                 => 'заключи',
        'unlock'               => 'отключи',
        'very low'             => 'много нисък',
        'low'                  => 'нисък',
        'normal'               => 'нормален',
        'high'                 => 'висок',
        'very high'            => 'много висок',
        '1 very low'           => '1 много нисък',
        '2 low'                => '2 нисък',
        '3 normal'             => '3 нормален',
        '4 high'               => '4 висок',
        '5 very high'          => '5 много висок',
        'Ticket "%s" created!' => 'Билет "%s" създаден!',
        'Ticket Number'        => 'Номер на Билета',
        'Ticket Object'        => 'Обект от тип Билет',
        'No such Ticket Number "%s"! Can\'t link it!' =>
            'Несъществуващ номер на Билета "%s"! Връзката е невъзможна!',
        'Don\'t show closed Tickets'         => 'Затворените билети да не се показват',
        'Show closed Tickets'                => 'Затворените билети да се показват',
        'New Article'                        => 'Нов текст',
        'Email-Ticket'                       => 'Билет по е-поща',
        'Create new Email Ticket'            => 'Билет е-поща',
        'Phone-Ticket'                       => 'Билет телефонно обаждане',
        'Search Tickets'                     => 'Търсене на билети',
        'Edit Customer Users'                => 'Редакция на клиент-потребители',
        'Bulk-Action'                        => 'Събирателно действие',
        'Bulk Actions on Tickets'            => 'Събирателно действие върху билети',
        'Send Email and create a new Ticket' => 'Изпращане на е-поща и създаване на нов билет',
        'Create new Email Ticket and send this out (Outbound)' =>
            'Създаване на нов билет: е-поша и изпращане на този (Изходящ)',
        'Create new Phone Ticket (Inbound)'    => 'Създаване на билет: телефонно обаждане (Входящ)',
        'Overview of all open Tickets'         => 'Преглед на всички отворени билети',
        'Locked Tickets'                       => 'Заключени билети',
        'Watched Tickets'                      => 'Наблюдавани билети',
        'Watched'                              => 'Наблюдавани',
        'Subscribe'                            => 'Абонамент',
        'Unsubscribe'                          => 'Прекр. абонамент',
        'Lock it to work on it!'               => 'Заключете билета за да работите в/у него!',
        'Unlock to give it back to the queue!' => 'Отключете билета за да се върне в опашката!',
        'Shows the ticket history!'            => 'Показва историята на билета!',
        'Print this ticket!'                   => 'Печат на билета!',
        'Change the ticket priority!'          => 'Смяна на приоритета на билета!',
        'Change the ticket free fields!'       => 'Смяна на полетата на билета!',
        'Link this ticket to an other objects!' => 'Свързване на билета с други обекти!',
        'Change the ticket owner!'              => 'Смяна на собственика на билета!',
        'Change the ticket customer!'           => 'Смяна на клиент-потребителя на билета!',
        'Add a note to this ticket!'            => 'Добавяне на бележка към билета!',
        'Merge this ticket!'                    => 'Изравняване на билета!',
        'Set this ticket to pending!'           => 'Смяна на статуса на билета в очакван',
        'Close this ticket!'                    => 'Затваряне на билета!',
        'Look into a ticket!'                   => 'Подробен преглед на билета!',
        'Delete this ticket!'                   => 'Изтриване на този билет!',
        'Mark as Spam!'                         => 'Отбележи като спам',
        'My Queues'                             => 'Собствени опашки',
        'Shown Tickets'                         => 'Показани билети',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Вашето писмо с номер на билета "<OTRS_TICKET>" е изравнено с "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!'       => '',
        'Ticket %s: first response time will be over in %s!' => '',
        'Ticket %s: update time is over (%s)!'               => '',
        'Ticket %s: update time will be over in %s!'         => '',
        'Ticket %s: solution time is over (%s)!'             => '',
        'Ticket %s: solution time will be over in %s!'       => '',
        'There are more escalated tickets!'                  => '',
        'New ticket notification'                            => 'Напомняне за нов билет',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Изпратете уведомление ако има нов билет в "Собствени опашки".',
        'Follow up notification' => 'Известие за наличност на следене на отговорът',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'
            => 'Изпратете ми известие, ако клиентът изпрати заявка за следене на отговора и аз съм собственик на билета',
        'Ticket lock timeout notification' =>
            'Известие за продължителността на заключване на билетът',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Изпратете ми известие, ако билетът е отключен от системата.',
        'Move notification' => 'Известие за преместване',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Изпратете уведомление билет е преместен в "Собствени опашки".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.'
            => 'Вашия избор за предпочитани опашки. Вие ще получите уведомления за тези опашки ако сте го разрешили.',
        'Custom Queue'            => 'Потребителска опашка',
        'QueueView refresh time'  => 'Време за обновяване изгледът на опашката',
        'Screen after new ticket' => 'Екран след нов тикет',
        'Select your screen after creating a new ticket.' =>
            'Изберете екран след създаване на нов билет',
        'Closed Tickets'       => 'Затворени билети',
        'Show closed tickets.' => 'Покажете затворените билети',
        'Max. shown Tickets a page in QueueView.' =>
            'Максимален брой показани билети на страница в прегледа на опашката.',
        'CompanyTickets'            => 'Билети на компанията',
        'MyTickets'                 => 'Мои билети',
        'New Ticket'                => 'Нов билет',
        'Create new Ticket'         => 'Създаване на нов билет',
        'Customer called'           => 'Обаждане на клиент',
        'phone call'                => 'обаждане по телефон',
        'Responses'                 => 'Отговори',
        'Responses <-> Queue'       => 'Отговори <-> Опашки',
        'Auto Responses'            => 'Авто отговори',
        'Auto Responses <-> Queue'  => 'Авто отговори <-> Опашки',
        'Attachments <-> Responses' => 'Прикачени файлове <-> Опашки',
        'History::Move'             => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'History::TypeUpdate'       => 'Промяна на типа "%s".',
        'History::ServiceUpdate'    => 'Промяна на service "%s".',
        'History::SLAUpdate'        => 'Промяна на SLA "%s".',
        'History::NewTicket'        => 'Създаден нов билет [%s] (О=%s;П=%s;С=%s).',
        'History::FollowUp'         => 'Събщтение към [%s]. %s',
        'History::SendAutoReject'   => 'Авто отказ изпратен на "%s".',
        'History::SendAutoReply'    => 'Авто отговор изпратен на "%s".',
        'History::SendAutoFollowUp' => 'Авто отговор към тикет изпратен на "%s".',
        'History::Forward'          => 'Прехвърлен на "%s".',
        'History::Bounce'           => 'Отхвърлен към "%s".',
        'History::SendAnswer'       => 'Е-поща изпратена на "%s".',
        'History::SendAgentNotification'    => '"%s"-уведомление изпратено на "%s".',
        'History::SendCustomerNotification' => 'Уведомление изпратено на "%s".',
        'History::EmailAgent'               => 'Е-поща изпратена на клиент.',
        'History::EmailCustomer'            => 'Добавена е-поща. %s',
        'History::PhoneCallAgent'           => 'Обаждане на клиент от страна на агент.',
        'History::PhoneCallCustomer'        => 'Клиент ни се обади.',
        'History::AddNote'                  => 'Добавена бележка (%s)',
        'History::Lock'                     => 'Билета е заключен.',
        'History::Unlock'                   => 'Билета е отключен.',
        'History::TimeAccounting' =>
            '%s времеви единица(и) са отброени. Общо %s времеви единица(и).',
        'History::Remove'         => '%s',
        'History::CustomerUpdate' => 'Актуализирано: %s',
        'History::PriorityUpdate' => 'Смяна на приоритета на билета от "%s" (%s) към "%s" (%s).',
        'History::OwnerUpdate'    => 'Нов собствник е "%s" (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! Не е изпратен авто отговор на "%s".',
        'History::Misc'           => '%s',
        'History::SetPendingTime' => 'Актуализирано: %s',
        'History::StateUpdate'    => 'Стар: "%s" Нов: "%s"',
        'History::TicketFreeTextUpdate' => 'Актуализирано: %s=%s;%s=%s;',
        'History::WebRequestCustomer'   => 'Клиентска заявка по web.',
        'History::TicketLinkAdd'        => 'Добавена връзка към билет "%s".',
        'History::TicketLinkDelete'     => 'Изтрита връзка към билет "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Нед',
        'Mon' => 'Пон',
        'Tue' => 'Вто',
        'Wed' => 'Сря',
        'Thu' => 'Чет',
        'Fri' => 'Пет',
        'Sat' => 'Съб',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Управление на прикачен файл',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Управление на автоматичният отговор',
        'Response'                 => 'Отговор',
        'Auto Response From'       => 'Автоматичен отговор от',
        'Note'                     => 'Бележка',
        'Useable options'          => 'Използваеми опции',
        'To get the first 20 character of the subject.' =>
            'За да се вземат първите 20 символа от "Относно" полето',
        'To get the first 5 lines of the email.' =>
            'За да се вземат първите 5 реда от съобщението.',
        'To get the realname of the sender (if given).' =>
            'Да се вземе истинското име на изпращача (ако има)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).'
            => 'Да се вземат атрибути на билета/съобщението (Пример: (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' =>
            'Свойства на текущия клиент-потребител (Пример: <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' =>
            'Свойства на собственика на билета (Пример: <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' =>
            'Свойства на отговорника за билета (Пример: <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).'
            => 'Свойства на текущия потребител, който е изискал това действие (Пример: <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).'
            => 'Свойства на билета (Пример: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' =>
            'Свойства на системната конфигурация (Пример: <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Управление на клиент-фирма',
        'Add Customer Company'        => 'Добавяне на клиент-фирма',
        'Add a new Customer Company.' => 'Добавяне на нова клиент-фирма',
        'List'                        => 'Списък',
        'This values are required.'   => 'Тези стойности са задължителни.',
        'This values are read only.'  => 'Тези стойности са само за преглед. (read only)',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Управление на клиент-потребители',
        'Search for'               => 'Търсене',
        'Add Customer User'        => '',
        'Source'                   => 'Източник',
        'Create'                   => 'Създаване',
        'Customer user will be needed to have a customer history and to login via customer panel.'
            => 'Клиент-потребителя ще трябва да има история и ще може да влиза през клиентския потребителски интерфейс.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Управление на клиент-потребители <-> групи',
        'Change %s settings'                   => 'Промяна на %s настройки',
        'Select the user:group permissions.'   => 'Изберете позволения за потребител:група',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).'
            => 'Ако нищо не е избрано потребителя няма да има разрешения за тази група (няма да са видими билетите които са в тази група (тикетите които са в опашките на тази група))',
        'Permission' => 'Позволения',
        'ro'         => 'само за четене',
        'Read only access to the ticket in this group/queue.' =>
            'Достъп само за четене за билетите в тази група/опашка',
        'rw' => 'четене/запис',
        'Full read and write access to the tickets in this group/queue.' =>
            'Пълен достъп за билетите в тази група/опашка',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminEmail
        'Message sent to' => 'Съобщението е изпратено до',
        'Recipents'       => 'Получатели',
        'Body'            => 'Тяло на писмото',
        'Send'            => 'Изпращане',

        # Template: AdminGenericAgent
        'GenericAgent'  => 'GenericAgent',
        'Job-List'      => 'Списък от задачи',
        'Last run'      => 'Последно стартирана',
        'Run Now!'      => 'Стартирай сега!',
        'x'             => 'х',
        'Save Job as?'  => 'Съхраняване на задачата?',
        'Is Job Valid?' => 'Задачата валидна?',
        'Is Job Valid'  => 'Задачата валидна',
        'Schedule'      => 'Регулярно изпълнение',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' =>
            'Пълнотекстово търсене в билета (Пример: Mart*n или Baue*)',
        '(e. g. 10*5155 or 105658*)'          => '(Пример: 10*5155 или 105658)',
        '(e. g. 234321)'                      => '(Пример: 234321)',
        'Customer User Login'                 => 'Логин на клиент-потребител',
        '(e. g. U5150)'                       => '(Пример: U5150)',
        'Agent'                               => 'Агент',
        'Ticket Lock'                         => 'Заключване на билет',
        'TicketFreeFields'                    => 'Полета на билета',
        'Create Times'                        => 'Време на създаване',
        'No create time settings.'            => 'Няма настройки за време на създаване.',
        'Ticket created'                      => 'Билета е създаден',
        'Ticket created between'              => 'Билета е създаден между',
        'Pending Times'                       => 'Време на очакване',
        'No pending time settings.'           => 'Няма настройки за време на очакване',
        'Ticket pending time reached'         => 'Времето на очакване за билета достигнато',
        'Ticket pending time reached between' => 'Времето на очакване за билета достигнато между',
        'New Priority'                        => 'Нов приоритет',
        'New Queue'                           => 'Следваща опашка',
        'New State'                           => 'Нов статус',
        'New Agent'                           => 'Нов агент',
        'New Owner'                           => 'Нов собственик',
        'New Customer'                        => 'Нов клиент-потребител',
        'New Ticket Lock'                     => 'Нов тип заключване на билета',
        'CustomerUser'                        => 'Клиент-потребител',
        'New TicketFreeFields'                => 'Нови стойности на полетата на билета',
        'Add Note'                            => 'Добавяне на бележка',
        'CMD'                                 => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Тази команда ще бъде изпълнена. ARG[0] (първи аргумент) ще бъде номера на билета. ARG[1] (втори аргумент) ще бъде TiketID.',
        'Delete tickets' => 'Изтриване на билета',
        'Warning! This tickets will be removed from the database! This tickets are lost!' =>
            'Внимание! Тези билети ще бъдат изтрити от базата данни! Те ще бъдат загубени!',
        'Send Notification'     => 'Изпращане на уведомление',
        'Param 1'               => 'Параметър 1',
        'Param 2'               => 'Параметър 2',
        'Param 3'               => 'Параметър 3',
        'Param 4'               => 'Параметър 4',
        'Param 5'               => 'Параметър 5',
        'Param 6'               => 'Параметър 6',
        'Send no notifications' => 'Да не се изпращат уведомления',
        'Yes means, send no agent and customer notifications on changes.' =>
            'Да означава че няма да бъдат изпращани уведомления (тип: агент и тип: клиент) когато има промени.',
        'No means, send agent and customer notifications on changes.' =>
            'Не означава че ще бъдат изпращани уведомления (тип: агент и тип: клиент) когато има промени.',
        'Save' => 'Съхраняване',
        '%s Tickets affected! Do you really want to use this job?' =>
            '%s билета бяха засегнати! Сигурни ли сте че искате да използвате тази задача?',
        '"}' => '"}',

        # Template: AdminGroupForm
        'Group Management' => 'Управление на групи',
        'Add Group'        => 'Добавяне на група',
        'Add a new Group.' => 'Добавяне на нова група',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Групата admin достъпва администраторската зона, а stat групата достъпва зоната за статистики.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'
            => 'Направете нови групи за да управлявате позволенията за различните групи от агенти (примерно агент за отдел "продажби", отдел "поддръжка" и т.н.)',
        'It\'s useful for ASP solutions.' => 'Това е подходящо за ASP решения.',

        # Template: AdminLog
        'System Log' => 'Системен журнал',
        'Time'       => 'Време',

        # Template: AdminNavigationBar
        'Users'  => 'Потребители',
        'Groups' => 'Групи',
        'Misc'   => 'Добавки',

        # Template: AdminNotificationForm
        'Notification Management' => 'Управление на уведомленията',
        'Notification'            => 'Уведомление',
        'Notifications are sent to an agent or a customer.' =>
            'Уведомления се изпращат на агент или клиент-потребител',

        # Template: AdminPackageManager
        'Package Manager' => 'Управление на софтуерни пакети',
        'Uninstall'       => 'Деинсталиране',
        'Version'         => 'Версия',
        'Do you really want to uninstall this package?' =>
            'Сигурни ли сте че искате да деинсталирате този софтуерен пакет?',
        'Reinstall' => 'Реинсталиране',
        'Do you really want to reinstall this package (all manual changes get lost)?' =>
            'Сигурни ли сте че искате да реинсталирате този софтуерен пакет (всички допълнителни промени се губят)?',
        'Continue'                    => 'Продължаване',
        'Install'                     => 'Инсталиране',
        'Package'                     => 'Софтуерен пакет',
        'Online Repository'           => 'Online Repository',
        'Vendor'                      => 'Доставчик',
        'Upgrade'                     => 'Ъпгрейд',
        'Local Repository'            => 'Локално Repository',
        'Status'                      => 'Статус',
        'Overview'                    => 'Преглед',
        'Download'                    => 'Сваляне',
        'Rebuild'                     => 'Компилиране',
        'ChangeLog'                   => 'ChangeLog',
        'Date'                        => 'Дата',
        'Filelist'                    => 'Списък от файлове',
        'Download file from package!' => 'Сваляне на файла от пакета!',
        'Required'                    => 'Задължителен',
        'PrimaryKey'                  => 'Primary Key',
        'AutoIncrement'               => 'Auto Increment',
        'SQL'                         => 'SQL',
        'Diff'                        => 'Разлики',

        # Template: AdminPerformanceLog
        'Performance Log'          => 'Журнал на производителността',
        'This feature is enabled!' => 'Тази функционалност е пусната!',
        'Just use this feature if you want to log each request.' =>
            'Използвайте тази функционалност ако искате да се журналира всяка заявка.',
        'Of couse this feature will take some system performance it self!' =>
            'Тази фунционалност ще окаже влияние на производителността на системата!',
        'Disable it here!'          => 'Забраняване на фукционалността тук',
        'This feature is disabled!' => 'Тази функционалност е забранена',
        'Enable it here!'           => 'Разрешаване на фунционалността тук',
        'Logfile too large!'        => 'Журналния файл е прекалено голям!',
        'Logfile too large, you need to reset it!' =>
            'Журналния файл е прекалено голям, необходимо е презаписване на файла!',
        'Range'            => 'Диапазон',
        'Interface'        => 'Интерфейс',
        'Requests'         => 'Заявки',
        'Min Response'     => 'Минимално време за отговор',
        'Max Response'     => 'Максимално време за отговор',
        'Average Response' => 'Средно време за отговор',

        # Template: AdminPGPForm
        'PGP Management' => 'Управление на PGP',
        'Result'         => 'Резултат',
        'Identifier'     => 'Идентификатор',
        'Bit'            => 'Бит',
        'Key'            => 'Ключ',
        'Fingerprint'    => 'Fingerprint',
        'Expires'        => 'Expires',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'По този начин може директно да се редактира keyring-а който е конфигуриран в модула SysConfig.',

        # Template: AdminPOP3
        'POP3 Account Management' => 'Управление на POP3 акаунта',
        'Host'                    => 'Хост',
        'Trusted'                 => 'Доверен',
        'Dispatching'             => 'Разпределение',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Всички входящи писма с един акаунт ще се разпределят в избраната опашка!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.'
            => 'Ако Вашия акаунт е доверен съществуващите X-OTRS хедъри на e-mail-а ще бъдат използвани (Пример: X-OTRS-Priority - за приоритет). Филтъра на PostMaster обаче същто ще се приложи на тези съобщения.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Управление филтъра за е-поща',
        'Filtername'                   => 'Име на филтър',
        'Match'                        => 'Съвпадение',
        'Header'                       => 'Хедър',
        'Value'                        => 'Стойност',
        'Set'                          => 'Поставяне',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.'
            => 'Анализ на съобщенията на база на техните X-Хедъри! Регулярен израз е също възможен.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.'
            => 'Ако искате съвпадение само на e-mail адреса използвайте EMAILADDRESS:info@example.com в From, To или Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Ако използвате регулярен израз, може да използвате стойността на съвпадението от регулярния израз като [***] в \'Set\'.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Управление на опашка <-> Авто отговори',

        # Template: AdminQueueForm
        'Queue Management'                 => 'Управление на опашка',
        'Sub-Queue of'                     => 'Под-опашка на',
        'Unlock timeout'                   => 'Време за отключване',
        '0 = no unlock'                    => '0 = без отключване',
        'Escalation - First Response Time' => 'Ескалация - Време за първи отговор',
        '0 = no escalation'                => '0 = без ескалация',
        'Escalation - Update Time'         => 'Ескалация - Време за статус ъпдейт',
        'Escalation - Solution Time'       => 'Ескалация - Време за решаване',
        'Follow up Option'                 => 'Параметри за автоматично проследяване',
        'Ticket lock after a follow up'    => 'Заключване на билетът след автоматично известяване',
        'Systemaddress'                    => 'Системен адрес',
        'Customer Move Notify'             => 'Известяване при преместване на потребителя',
        'Customer State Notify'            => 'Известяване за състоянието на потребителя',
        'Customer Owner Notify'            => 'Известяване на потребителя',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'
            => 'Ако агентът заключи билетът и той(или тя) не изпрати отговор в определеното време, билетър ще се отключи автоматично. Така билетър ще стане видим за всички други агенти',
        'Escalation time' => 'Време за ескалация (увеличаване на приоритетът)',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' =>
            'Ако билетът не получи отговор в определеното време, ще се покаже само този билет',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'
            => 'Ако билетът е затворен и потребителя изпрати заявка за проследяване, билетът ще бъде заключен за стария потребител',
        'Will be the sender address of this queue for email answers.' =>
            'Ще бъде адресът на изпраща за тази опашка при еМейл отговорите',
        'The salutation for email answers.' => 'Обръщението за отговорите по еМейл',
        'The signature for email answers.'  => 'Подписът за отговорите по еМейл',
        'OTRS sends an notification email to the customer if the ticket is moved.' =>
            'OTRS изпраща известие по е-поща до клиента, ако билетът е преместен.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' =>
            'OTRS изпраща известие по е-поща до клиента, ако статусът на билетът е променен.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' =>
            'OTRS изпраща известие по е-поща до клиента, ако собственика на билета е променен.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Управление на отговори <-> опашки',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Отговор',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Управление на отговори <-> прикачени файлове',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Управление на отговорът',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Отговорът е текст по подразбиране, създанен предварително, с цел по-бърз отговор към клиента',
        'Don\'t forget to add a new response a queue!' =>
            'Не забравяйте да добавите новият отговор към дадена опашка!',
        'The current ticket state is' => 'Текущия статус на билета е',
        'Your email address is new'   => 'Вашия e-mail адрес е нов',

        # Template: AdminRoleForm
        'Role Management' => 'Управление на роли',
        'Add Role'        => 'Добавяне на роля',
        'Add a new Role.' => 'Добавяне на нова роля',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Създайте роля и добавете групи в нея. След това добавете ролята на потребителите.',
        'It\'s useful for a lot of users and groups.' =>
            'Полезно когато имате много потребители и групи.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Управление на роли <-> групи',
        'move_into'                   => 'Преместване',
        'Permissions to move tickets into this group/queue.' =>
            'Позволение за преместване на билет в тази група/опашка.',
        'create' => 'Създаване',
        'Permissions to create tickets in this group/queue.' =>
            'Позволение за създаване на билет в тази група/опашка.',
        'owner' => 'Собственик',
        'Permissions to change the ticket owner in this group/queue.' =>
            'Позволение за смяна собственика на билет в тази група/опашка.',
        'priority' => 'Приоритет',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Позволение за промяна на приоритета на билет в тази група/опашка.',

        # Template: AdminRoleGroupForm
        'Role' => 'Роля',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management'      => 'Управлнение на роли <-> потребители',
        'Active'                          => 'Активна',
        'Select the role:user relations.' => 'Изберете релация роля:потребител',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Управление на обръщението',
        'Add Salutation'        => 'Добавяне на обръщение',
        'Add a new Salutation.' => 'Добавяне на ново обръщение',

        # Template: AdminSelectBoxForm
        'Select Box'        => 'Кутия за SQL заявки',
        'Limit'             => 'Лимит',
        'Go'                => 'Продъпжавай',
        'Select Box Result' => 'Резултат от заявката изпълнена в SelectBox',

        # Template: AdminService
        'Service Management' => 'Управление на service',
        'Add Service'        => '',
        'Add a new Service.' => '',
        'Service'            => 'Service',
        'Sub-Service of'     => 'Sub-Service на',

        # Template: AdminSession
        'Session Management' => 'Управление на сесиите',
        'Sessions'           => 'Сессии',
        'Uniq'               => 'Уникална',
        'Kill all sessions'  => 'Спиране на всички сесии',
        'Session'            => 'Сесия',
        'Content'            => 'Съдържание',
        'kill session'       => 'Затваряне на единична сесия',

        # Template: AdminSignatureForm
        'Signature Management' => 'Управление на подпис',
        'Add Signature'        => 'Добавяне на подпис',
        'Add a new Signature.' => 'Добавяне на нов подпис',

        # Template: AdminSLA
        'SLA Management'      => 'Управление на SLA',
        'Add SLA'             => '',
        'Add a new SLA.'      => '',
        'SLA'                 => 'SLA',
        'First Response Time' => 'Време на първи отговор',
        'Update Time'         => 'Време на ъпдейт на статуса',
        'Solution Time'       => 'Време за решаване',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Управление на S/MIME (Secure MIME)',
        'Add Certificate'   => 'Добавяне на сертификат',
        'Add Private Key'   => 'Добавяне на частен ключ',
        'Secret'            => 'Парола',
        'Hash'              => 'Хеш',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'По този начин може да редактирате сертификати и частни ключове във файловата система.',

        # Template: AdminStateForm
        'State Management' => 'Управление на статус',
        'Add State'        => 'Добавяне на статус',
        'Add a new State.' => 'Добавяне на нов статус',
        'State Type'       => 'Тип състояние',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Не забравяйте да редактирате статусите по подразбиране в конфигурацията на системата!',
        'See also' => 'Вижте също',

        # Template: AdminSysConfig
        'SysConfig'                           => 'Системна конфигурация',
        'Group selection'                     => 'Избиране на група от конфигурационни параметри',
        'Show'                                => 'Покажи',
        'Download Settings'                   => 'Сваляне на настройките',
        'Download all system config changes.' => 'Сваляне на всички промени на конфигурацията.',
        'Load Settings'                       => 'Зареждане на настройки',
        'Subgroup'                            => 'Подгрупа',
        'Elements'                            => 'Елементи',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Конфигурационни опции',
        'Default'        => 'По подразбиране',
        'New'            => 'Нови',
        'New Group'      => 'Нова група от конфигурационни параметри',
        'Group Ro'       => 'Група (само четене)',
        'New Group Ro'   => 'Нова група (само четене)',
        'NavBarName'     => 'Име на навигационната лента',
        'NavBar'         => 'Навигационна лента',
        'Image'          => 'Картинка',
        'Prio'           => 'Приоритет',
        'Block'          => 'Блок',
        'AccessKey'      => 'Клавиш за кратък достъп',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Управление на системния еМейл адрес',
        'Add System Address'                => 'Добавяне на системен адрес',
        'Add a new System Address.'         => 'Добавяне на нов системен адрес.',
        'Realname'                          => 'Истинско име',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' =>
            'Всички входящи адреси от този еМейл (До:) ще се разпределят в избраната опашка.',

        # Template: AdminTypeForm
        'Type Management' => 'Управление на тип',
        'Add Type'        => 'Добавяне на тип',
        'Add a new Type.' => 'Добавяне на нов тип',

        # Template: AdminUserForm
        'User Management'  => 'Управление на потребители',
        'Add User'         => 'Добавяне',
        'Add a new Agent.' => 'Управление на нов агент',
        'Login as'         => 'Логин като',
        'Firstname'        => 'Име',
        'Lastname'         => 'Фамилия',
        'User will be needed to handle tickets.' =>
            'Ще е необходим агент потребител, за да може билетът да се обработи',
        'Don\'t forget to add a new user to groups and/or roles!' =>
            'Не забравяйте да добавите новия агент потребител към групи и/или роли!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Управление на Агент потребители <-> Групи',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book'                 => 'Адресна книга',
        'Return to the compose screen' => 'Връщате се към екрана за създаване',
        'Discard all changes and return to the compose screen' =>
            'Отказвате се от всички промени и се връщате към екрана за създаване',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Информация',

        # Template: AgentLinkObject
        'Link Object' => 'Обект за свързване',
        'Select'      => 'Избор',
        'Results'     => 'Резултат',
        'Total hits'  => 'Общ брой попадения',
        'Page'        => 'Страница',
        'Detail'      => 'Подробности',

        # Template: AgentLookup
        'Lookup' => 'Преглед',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker'       => 'Проверка на правописът',
        'spelling error(s)'   => 'Правописна грешка(грешки)',
        'or'                  => 'или',
        'Apply these changes' => 'Прилага се към тези промени',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' =>
            'Сигурни ли сте че искате да изтриете този обект?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' =>
            'Изберете ограничения които да характеризирад статистиката',
        'Fixed' => 'Fixed',
        'Please select only one element or turn of the button \'Fixed\'.' =>
            'Моля изберете само един елемент или изключете опцията \'Fixed\'.',
        'Absolut Period'  => 'Абсолютен интервал',
        'Between'         => 'Между',
        'Relative Period' => 'Относителен интервал',
        'The last'        => 'Последните',
        'Finish'          => 'Край',
        'Here you can make restrictions to your stat.' =>
            'Тук може да добавите ограничения на Вашата статистика.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.'
            => 'Ако махнете опцията \'Fixed\' агент потребителя който генерира статистиката ще може да променя съответния елемент.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Въвеждане на общи спецификации',
        'Permissions'                         => 'Разрешения',
        'Format'                              => 'Формат',
        'Graphsize'                           => 'Размер на графиката',
        'Sum rows'                            => 'Сума на редовете',
        'Sum columns'                         => 'Сума на колоните',
        'Cache'                               => 'Кеш',
        'Required Field'                      => 'Задължително поле',
        'Selection needed'                    => 'Необходим е избор',
        'Explanation'                         => 'Обяснение',
        'In this form you can select the basic specifications.' =>
            'В този формуляр може да въведете основни спецификации.',
        'Attribute'          => 'Атрибут',
        'Title of the stat.' => 'Заглавие на статистиката.',
        'Here you can insert a description of the stat.' =>
            'Тук може да въведете описание на статистиката.',
        'Dynamic-Object' => 'Динамичен обект',
        'Here you can select the dynamic object you want to use.' =>
            'Тук може да изберете какъв динамичен обект искате да се използва.',
        '(Note: It depends on your installation how many dynamic objects you can use)' =>
            '(Забележка: Броя на динамичните обекти зависи от типа на инсталация)',
        'Static-File' => 'Статичен файл',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'За сложни статистике е възможно да се сложи hardcoded файл.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.'
            => 'Ако е наличен нов hardcoded файл този атрибут ще бъде показан и ще може да бъде избран.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.'
            => 'Опции на разрешенията. Изберете една или повече групи за чиито агенти тази статистика ще е видима.',
        'Multiple selection of the output format.' => 'Множествен избор на изходния формат.',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Ако използвате графика за изходен формат ще е необходимо да се въведе размер на графиката.',
        'If you need the sum of every row select yes' =>
            'Ако искате да има колона със сумата на всеки ред изберете Да',
        'If you need the sum of every column select yes.' =>
            'Ако искате да има ред със сумата на всяка колона изберете Да',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'По голямата част от статисиките могат да се кешират. Това ще ускори генерирането на Вашата статистика.',
        '(Note: Useful for big databases and low performance server)' =>
            '(Забележка: Полезно е при големи бази данни или слабопроизводителен сървър)',
        'With an invalid stat it isn\'t feasible to generate a stat.' =>
            'Ако статистиката е невалидна нейното генериране ще е неосъществимо.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.'
            => 'Това е полезно ако искате никой да не види резултата от статистиката или статистиката не е конфигурирана напълно.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Изберете елементи за групите от стойности',
        'Scale'                                    => 'Мащаб',
        'minimal'                                  => 'минимален',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).'
            => 'Имайте предвид че мащаба на стойностите трябва да е по-голям от този на оста Х (Пример: X-Axis => Month, ValueSeries => Year).',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.'
            => 'Тук може да добавите групи стойности. Тук може да изберете един или два елемента. След това може да изберете атрибути на елементите. Всеки атрибут ще бъде показан като група от единични стойности. Ако не изберете атрибут, всички атрибути на елемента ще бъдат показане по време на генерирането на статистиката, както и всеки нов атрибут добавен при конфигурация на статистиката.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' =>
            'Изберете елемент който ще се използва за стойности на оста Х',
        'maximal period' => 'максимален период',
        'minimal scale'  => 'минимален мащаб',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.'
            => 'Тук може да дефинирате оста Х, може да изберете един елемент (посредством радио бутон). Тук може да изберете един или два елемента. След това може да изберете атрибути на елементите. Всеки атрибут ще бъде показан като група от единични стойности. Ако не изберете атрибут, всички атрибути на елемента ще бъдат показане по време на генерирането на статистиката, както и всеки нов атрибут добавен при конфигурация на статистиката.',

        # Template: AgentStatsImport
        'Import'                     => 'Импортиране',
        'File is not a Stats config' => 'Файла не е дефиниция на статистика',
        'No File selected'           => 'Не е избран файл',

        # Template: AgentStatsOverview
        'Object' => 'Обект',

        # Template: AgentStatsPrint
        'Print'                => 'Отпечатване',
        'No Element selected.' => 'Няма избран елемент',

        # Template: AgentStatsView
        'Export Config'                      => 'Експортиране на конфигурация',
        'Informations about the Stat'        => 'Информация относно статистиката',
        'Exchange Axis'                      => 'Размяна на осите',
        'Configurable params of static stat' => 'Конфигурируеми параметри на статичната статистика',
        'No element selected.'               => 'Няма избран елемент',
        'maximal period from'                => 'максимален период от',
        'to'                                 => 'до',
        'Start'                              => 'Старт',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.'
            => 'Със полета за въвеждане или избор може да конфигурирате статистиката според Вашите нужди. Броя на елементите подлежащи на редакция зависи от администратора който е конфигурирал тази статистика.',

        # Template: AgentTicketBounce
        'Bounce ticket'     => 'Отказан билет',
        'Ticket locked!'    => 'Билетът е заключен!',
        'Ticket unlock!'    => 'Билетът е отключен!',
        'Bounce to'         => 'Отказ на',
        'Next ticket state' => 'Следващо състояние за билетът',
        'Inform sender'     => 'Да се информира изпращачът',
        'Send mail!'        => 'Изпратете еМейл!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Събирателно действие',
        'Spell Check'        => 'Проверка на правописа',
        'Note type'          => 'Бележката е от тип',
        'Unlock Tickets'     => 'Отключване на билети',

        # Template: AgentTicketClose
        'Close ticket'           => 'Затваряне на билета',
        'Previous Owner'         => 'Предишен собственик',
        'Inform Agent'           => 'Информирай агента',
        'Optional'               => 'Опционално',
        'Inform involved Agents' => 'Информирай включените агенти',
        'Attach'                 => 'Прикачен файл',
        'Next state'             => 'Следващо състояние',
        'Pending date'           => 'В очакване - дата',
        'Time units'             => 'Мерни единици за времето',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Създаване на отговор за този билет',
        'Pending Date'              => 'В очакване-дата',
        'for pending* states'       => 'за състояния в очакване* ',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Промяна на потребителят на билета',
        'Set customer user and customer id of a ticket' =>
            'Задайте потребител и потребителски идентификатор за билета',
        'Customer User'         => 'Клиент-потребител',
        'Search Customer'       => 'Търсене на потребител',
        'Customer Data'         => 'Данни за потребителя',
        'Customer history'      => 'Хроника на потребителят',
        'All customer tickets.' => 'Всички билети на този потребител',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Заявка за отговор',

        # Template: AgentTicketEmail
        'Compose Email' => 'Създаване на e-mail',
        'new ticket'    => 'нов билет',
        'Refresh'       => 'Опресняване',
        'Clear To'      => 'Изчистване на полето: to',

        # Template: AgentTicketForward
        'Article type' => 'Тип на съобщението',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Променете текста на билета',

        # Template: AgentTicketHistory
        'History of' => 'Хроника на',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox'      => 'Пощенска кутия',
        'Tickets'      => 'Билети',
        'of'           => 'на',
        'Filter'       => 'Филтър',
        'New messages' => 'Нови съобщения',
        'Reminder'     => 'Напомняне',
        'Sort by'      => 'Сортиране по',
        'Order'        => 'Ред',
        'up'           => 'нагоре',
        'down'         => 'надолу',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Изравняване на билет',
        'Merge to'     => 'Изравняване с',

        # Template: AgentTicketMove
        'Move Ticket' => 'Преместване на билета',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Добавяне на бележка към билета',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Промяна собственикън на билета',

        # Template: AgentTicketPending
        'Set Pending' => 'В очакване - задаване',

        # Template: AgentTicketPhone
        'Phone call' => 'Телефонно обаждане',
        'Clear From' => 'Изчистете формата',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Обикновен',

        # Template: AgentTicketPrint
        'Ticket-Info'    => 'Информация за билета',
        'Accounted time' => 'Отброено време',
        'Escalation in'  => 'Улеличение на приоритета в',
        'Linked-Object'  => 'Свързан обект',
        'Parent-Object'  => 'Обект-родител',
        'Child-Object'   => 'Обект-дете',
        'by'             => 'от',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Промяна на приоритета на билета',

        # Template: AgentTicketQueue
        'Tickets shown'      => 'Показани билети',
        'Tickets available'  => 'Налични билети',
        'All tickets'        => 'Всички билети',
        'Queues'             => 'Опашки',
        'Ticket escalation!' => 'Ескалация (увеличаване на приоритета) на билета!',

        # Template: AgentTicketQueueTicketView
        'Service Time'      => 'Service Time',
        'Your own Ticket'   => 'Вашият собствен билет',
        'Compose Follow up' => 'Създаване проследяване на билетът',
        'Compose Answer'    => 'Създаване на отговор',
        'Contact customer'  => 'Контакт с клиента',
        'Change queue'      => 'Промяна на опашката',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Промяна на отговорника на билет',

        # Template: AgentTicketSearch
        'Ticket Search'                    => 'Търсене на билет',
        'Profile'                          => 'Профил',
        'Search-Template'                  => 'Шаблон',
        'TicketFreeText'                   => 'Полета на билета',
        'Created in Queue'                 => 'Създаден в опашка',
        'Result Form'                      => 'Формат на резултата',
        'Save Search-Profile as Template?' => 'Съхранение на профила като шаблон',
        'Yes, save it with name'           => 'Да, съхрани с името',

        # Template: AgentTicketSearchResult
        'Search Result'         => 'Резултат от търенето',
        'Change search options' => 'Редакция на търсенето',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort
        'U' => 'В',
        'D' => 'Н',

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Преглед на статуса',
        'Open Tickets'       => 'Отворени билети',
        'Locked'             => 'Заключен',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Проследяване',

        # Template: CustomerFooter
        'Powered by' => 'С помощта на',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login'                => 'Вход',
        'Lost your password?'  => 'Забравена парола',
        'Request new password' => 'Завка за нова парола',
        'Create Account'       => 'Създаване на акаунт',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Привет %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times'             => 'Време',
        'No time settings.' => 'Няма времеви интервал',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Натиснете тук, за да изпратите отчет за грешката!',

        # Template: Footer
        'Top of Page' => 'Начало на страницата',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer'         => 'Web инсталатор',
        'Accept license'        => 'Приемане на лиценза',
        'Don\'t accept license' => 'Отказване на лиценза',
        'Admin-User'            => 'Администратор',
        'Admin-Password'        => 'Парола на администратор',
        'your MySQL DB should have a root password! Default is empty!' =>
            'Вашата MySQL база данни трябва да има парола за root потребителя. По подразбиране е празна!',
        'Database-User'   => 'Потребител на СУБД',
        'default \'hot\'' => 'по подразбиране',
        'DB connect host' => 'Хост за връзка със СУБД',
        'Database'        => 'База данни',
        'false'           => 'false',
        'SystemID'        => 'Системно ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)'
            => '(Идентифициране на системата. Всики номер на билет и всяка http сесия започва с този номер)',
        'System FQDN' => 'Системно FQDN',
        '(Full qualified domain name of your system)' =>
            '(Пълно квалифицирано име (FQDN) на системата)',
        'AdminEmail'                  => 'Admin е-поща',
        '(Email of the system admin)' => '(еМейл на системният администратор)',
        'Organization'                => 'Организация',
        'Log'                         => 'Журнал',
        'LogModule'                   => 'Журнален модул',
        '(Used log backend)'          => '(Използван журнален изход)',
        'Logfile'                     => 'Журнален файл',
        '(Logfile just needed for File-LogModule!)' =>
            '(Журналният файл е необходим само за File-LogModule)',
        'Webfrontend'     => 'Web-зона',
        'Default Charset' => 'Символен набор по подразбиране',
        'Use utf-8 it your database supports it!' =>
            'Използваите UTF-8 ако вашето СУБД/база данни го поддържа',
        'Default Language'        => 'Език по подразбиране',
        '(Used default language)' => '(Изполван език по подразбиране)',
        'CheckMXRecord'           => 'CheckMXRecord (Проверка MX запис)',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)'
            => '(Проверете MX записите на адреса на писмата-отговори. Не използвайте CheckMXRecord, ако вашата OTRS машина е на комутируема линия! ',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.'
            => 'За да може да използвате OTRS, Вие трябва да въведете, като superuser root в командния ред (Terminal/Shell) следната команда',
        'Restart your webserver' => 'Рестарт на web сървъра',
        'After doing so your OTRS is up and running.' =>
            'След извършването на това, Вашият OTRS е напълно работоспособен.',
        'Start page'         => 'Начална страница',
        'Have a lot of fun!' => 'Приятна работа!',
        'Your OTRS Team'     => 'Вашият OTRS екип',

        # Template: Login
        'Welcome to %s' => 'Добре дошли в %s',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Нямате позволение',

        # Template: Notify
        'Important' => 'Важно',

        # Template: PrintFooter
        'URL' => 'Адрес',

        # Template: PrintHeader
        'printed by' => 'отпечатано от',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Тестова страница на OTRS',
        'Counter'        => 'Брояч',

        # Template: Warning
        # Misc
        'Edit Article'            => 'Редакция на текст',
        'Create Database'         => 'Създаване на база данни',
        'DB Host'                 => 'Хост на базата данни',
        'Ticket Number Generator' => 'Генератор на номера на билети',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')'
            => '(Идентификатор на билета. Примерно: \'Ticket#\', \'Call#\' or \'MyTicket#\')',
        'Create new Phone Ticket' => 'Създаване на нов билет на базата на телефонно обаждане',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' =>
            'По този начин може да редактирате keyring-а конфигуриран в Kernel/Config.pm.',
        'Symptom'                                => 'Симптом',
        'A message should have a To: recipient!' => 'Съобщението трябва да има ДО: т.е. адресант!',
        'Site'                                   => 'Място',
        'Customer history search (e. g. "ID342425").' =>
            'Търсене в хрониката на клиента (примерно "ID342425").',
        'for agent firstname' => 'за агент име',
        'Close!'              => 'Затворете!',
        'The message being composed has been closed.  Exiting.' =>
            'Съобщението, което създавахте е затворено. Изход.',
        'A web calendar' => 'Календар',
        'to get the realname of the sender (if given)' =>
            'за да получите истинското име на изпращача (ако е попълнено)',
        'OTRS DB Name'            => 'Име свързано към OTRS база данни',
        'Notification (Customer)' => 'Уведомления (клиент/клиент-потребител)',
        'Select Source (for add)' => 'Изберете източник (за добавяне)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)'
            => 'Свойства на билета (Пример: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>;, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Queue ID' => 'ID на опашка',
        'Home'     => 'Начало',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' =>
            'Конфигурационни параметри (Пример: <OTRS_CONFIG_HttpType>)',
        'System History'                   => 'Системна хроника',
        'customer realname'                => 'име на потребителя',
        'Pending messages'                 => 'Съобщения в очакване',
        'Port'                             => 'Порт',
        'Modules'                          => 'Модули',
        'for agent login'                  => 'за агент логически вход',
        'Keyword'                          => 'Ключова дума',
        'Close type'                       => 'Тип затваряне',
        'DB Admin User'                    => 'Потребител на базата данни',
        'for agent user id'                => 'за агент потребителски ID',
        'sort upward'                      => 'възходящо сортиране',
        'Change user <-> group settings'   => 'Промяна на потребител <-> Настройки за група',
        'Problem'                          => 'Проблем',
        'next step'                        => 'следваща стъпка',
        'Customer history search'          => 'Търсене в хрониката на клиента',
        'Admin-Email'                      => 'еМейл от Admin',
        'Stat#'                            => 'Статистика#',
        'Create new database'              => 'Създаване на нова база данни',
        'A message must be spell checked!' => 'Съобщението трябва да бъде проверено за грешки!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.'
            => 'Писмото Ви с номер "<OTRS_TICKET>" е отхвърлен към "<OTRS_BOUNCE_TO>". Свържете се с този адрес за повече информация',
        'Mail Account Management'       => 'Управление на e-mail акаунти',
        'ArticleID'                     => 'Идентификатор на клауза',
        'A message should have a body!' => 'Съобщението трябва да има текст',
        'All Agents'                    => 'Всички агенти',
        'Keywords'                      => 'Ключови думи',
        'No * possible!'                => 'Не е възможно използване на символ *!',
        'Options '                      => 'Опции',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)'
            => 'Свойства на текущия потребител който е изискал това действие (Пример: <OTRS_CURRENT_USERFIRSTNAME>).',
        'Message for new Owner'                 => 'Съобщение за нов собственик',
        'to get the first 5 lines of the email' => 'за да получите първите 5 реда от писмото',
        'OTRS DB Password'                      => 'Парола на OTRS база данни',
        'Last update'                           => 'Последно обновление',
        'to get the first 20 character of the subject' =>
            'за да получите първите 20 символа от поле "относно"',
        'DB Admin Password' => 'Парола на администратора на базата',
        'Advisory'          => 'Консултация',
        'Drop Database'     => 'Нулиране базата данни',
        'FileManager'       => 'Файлов менажер',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' =>
            'Свойства на текущия клиент-потребител (Пример: <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type'       => 'В очакване - тип',
        'Comment (internal)' => 'Коментар (вътрешен)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' =>
            'Свойства на собственика на билета (Пример: <OTRS_OWNER_USERFIRSTNAME>).',
        'This window must be called from compose window' =>
            'Този прозорец трябва да бъде извикан от прозореца за създаване',
        'You need min. one selected Ticket!' => 'Трябва да изберете най-малко един билет!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)'
            => 'Свойства на билета (Пример: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Използван формат за номера на билетът)',
        'Fulltext'                    => 'Пълнотекстово',
        'Incident'                    => 'Инцидент',
        'OTRS DB connect host'        => 'Хост свързан към OTRS база данни',
        'All Agent variables.'        => 'Всички променливи свързани с агента',
        ' (work units)'               => ' (работни единици)',
        'All Customer variables like defined in config option CustomerUser.' =>
            'Всички променливи подобни на тези в конфигурационния параметър CustomerUser',
        'accept license'     => 'Приемате лиценза',
        'for agent lastname' => 'за агент фамилия',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)'
            => 'Свойства на потребителя който е изискал това действие (Пример: <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages'                => 'Напомнящи съобщения',
        'A message should have a subject!' => 'Съобщението трябва да има текст в поле "относно"!',
        'Ticket Hook'                      => 'Прикачване на билетът',
        'IMAPS'                            => 'IMAPS',
        'Don\'t forget to add a new user to groups!' =>
            'Не забравяйте да добавите новият потребител в някаква група!',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'Трябва да има валиден адрес в полето ДО: (примерно support@hebros.bg)!',
        'You need to account time!' => 'Вие се нуждаете от отчет за времето',
        'System Settings'           => 'Системни настройки',
        'WebWatcher'                => 'WebWatcher',
        'Finished'                  => 'Приключено',
        'Account Type'              => 'Тип на акаунта',
        'Split'                     => 'Разцепване',
        'All messages'              => 'Всички съобщения',
        'System Status'             => 'Системен статус',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)'
            => 'Свойства на билета (Пример: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Artefact'                       => 'Артефакт',
        'A article should have a title!' => 'Съобщението трябва да има заглавие',
        'Event'                          => 'Събитие',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' =>
            'Конфигурационни параметри (Пример: <OTRS_CONFIG_HttpType>).',
        'don\'t accept license' => 'Не приемате лиценза',
        'A web mail client'     => 'Web-базиран e-mail клиент',
        'IMAP'                  => 'IMAP',
        'WebMail'               => 'WebMail',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' =>
            'Свойства на собственика на билета (Пример: <OTRS_OWNER_UserFirstname>)',
        'Name is required!'                 => 'Името е задължително',
        'DB Type'                           => 'Тип на базата данни',
        'Termin1'                           => 'Termin1',
        'kill all sessions'                 => 'Затваряне на всички текущи сесии',
        'to get the from line of the email' => 'за да получите ред от писмото',
        'Solution'                          => 'Решение',
        'QueueView'                         => 'Преглед на опашката',
        'Welcome to OTRS'                   => 'Добре дошли в OTRS',
        'tmp_lock'                          => 'временно заключване',
        'modified'                          => 'редактиран',
        'Delete old database'               => 'Изтриване на стара база данни',
        'sort downward'                     => 'низходящо сортиране',
        'You need to use a ticket number!'  => 'Необходимо е да използвате номер на билета',
        'A web file manager'                => 'Web-базиран файлов менаджер',
        'send'                              => 'изпрати',
        'Note Text'                         => 'Текст на билежката',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)'
            => 'Свойства на текущия клиент-потребител (Пример: <OTRS_CUSTOMER_DATA_USERFIRSTNAME>).',
        'System State Management'          => 'Управление на системно състояние',
        'OTRS DB User'                     => 'Потребител на OTRS база данни',
        'PhoneView'                        => 'Преглед на телефоните',
        'maximal period form'              => 'форма за максимален интервал',
        'Verion'                           => 'Версия',
        'TicketID'                         => 'Идентификатор на билет',
        'Management Summary'               => 'Обзор за мениджмънта',
        'POP3'                             => 'POP3',
        'POP3S'                            => 'POP3S',
        'Modified'                         => 'Редактиран',
        'Ticket selected for bulk action!' => 'Билета е маркиран за събирателно действие',
    };

    # $$STOP$$
    return;
}

1;
