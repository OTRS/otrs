# --
# Kernel/Language/bg.pm - provides bg language translation
# Copyright (C) 2002 Vladimir Gerdjikov <gerdjikov at gerdjikovs.net>
# --
# $Id: bg.pm,v 1.11 2003-01-18 09:11:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::bg;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Thu Jan  9 22:08:36 2003 by 

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Минути',
      ' 5 minutes' => ' 5 Минути',
      ' 7 minutes' => ' 7 Минути',
      '10 minutes' => '10 Минути',
      '15 minutes' => '15 Минути',
      'AddLink' => 'Добавяне на връзка',
      'AdminArea' => 'Зона-Администратор',
      'all' => 'всички',
      'All' => 'Всички',
      'Attention' => 'Внимание',
      'Bug Report' => 'Отчет за грешка',
      'Cancel' => 'Отказ',
      'Change' => 'Промяна',
      'change' => 'променете',
      'change!' => 'променете!',
      'click here' => 'натиснете тук',
      'Comment' => 'Коментар',
      'Customer' => 'Потребител',
      'Customer info' => 'Потребителски данни',
      'day' => 'ден',
      'days' => 'дни',
      'description' => 'описание',
      'Description' => 'Описание',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работете с UserID 1 (Системен акаунт)! Създайте нов потребители',
      'Done' => 'Готово.',
      'end' => 'Край',
      'Error' => 'Грешка',
      'Example' => 'Пример',
      'Examples' => 'Примери',
      'Facility' => 'Приспособление',
      'Feature not acitv!' => 'Функцията не е активна',
      'go' => 'ОК',
      'go!' => 'ОК!',
      'Group' => 'Група',
      'Hit' => 'Попадение',
      'Hits' => 'Попадения',
      'hour' => 'час',
      'hours' => 'часове',
      'Ignore' => 'Пренебрегване',
      'invalid' => 'невалиден',
      'Invalid SessionID!' => 'Невалиден SessionID!',
      'Language' => 'Език',
      'Languages' => 'Езици',
      'Line' => 'Линия',
      'Lite' => 'Лека',
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешно оторизиране! Вашето име или парола са некоректини!',
      'Logout successful. Thank you for using OTRS!' => 'Изходът е успешен. Благодарим Ви, че използвахте системата.',
      'Message' => 'Съобщение',
      'minute' => 'минута',
      'minutes' => 'минути',
      'Module' => 'Модул',
      'Modulefile' => 'Файл-модул',
      'Name' => 'Име',
      'New message' => 'Ново съобщение',
      'New message!' => 'Ново съобщение!',
      'No' => 'Не',
      'no' => 'не',
      'No suggestions' => 'Няма предположения',
      'none' => 'няма',
      'none - answered' => 'няма - отговорен',
      'none!' => 'няма!',
      'Off' => 'Изключено',
      'off' => 'изключено',
      'on' => 'включено',
      'On' => 'Включено',
      'Password' => 'Парола',
      'Pending till' => 'В очакване до',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Моля, отговорете на този билет(и) за да се върнете в нормалния изглед на опашката!',
      'Please contact your admin' => 'Моля, свържете се с Вашият администратор',
      'please do not edit!' => 'моля, не редактирайте!',
      'possible' => 'възможен',
      'QueueView' => 'Преглед на опашката',
      'reject' => 'отхвърлен',
      'replace with' => 'замести с',
      'Reset' => 'Рестартирай',
      'Salutation' => 'Обръщение',
      'Signature' => 'Подпис',
      'Sorry' => 'Съжаляваме',
      'Stats' => 'Статистики',
      'Subfunction' => 'Подфункция',
      'submit' => 'изпратете',
      'submit!' => 'изпратете!',
      'Text' => 'Текст',
      'The recommended charset for your language is %s!' => 'Препоръчителният символен набор за Вашият език е %s',
      'Theme' => 'Тема',
      'There is no account with that login name.' => 'Няма потребител с това име.',
      'Timeover' => 'Край на времето',
      'top' => 'към началото',
      'update' => 'обновяване',
      'update!' => 'обновяване!',
      'User' => 'Потребител',
      'Username' => 'Потребителско име',
      'Valid' => 'Валиден',
      'Warning' => 'Предупреждение',
      'Welcome to OTRS' => 'Добре дошли в OTRS',
      'Word' => 'Дума',
      'wrote' => 'записано',
      'yes' => 'да',
      'Yes' => 'Да',
      'You got new message!' => 'Получихте ново съобщение!',
      'You have %s new message(s)!' => 'Вие имате %s ново/нови съобщение/съобщения!',
      'You have %s reminder ticket(s)!' => 'Вие имате %s оставащ/оставащи билет/билети!',

    # Template: AAAMonth
      'Apr' => 'Апр',
      'Aug' => 'Авг',
      'Dec' => 'Дек',
      'Feb' => 'Фев',
      'Jan' => 'Яну',
      'Jul' => 'Юли',
      'Jun' => 'Юни',
      'Mar' => 'Мар',
      'May' => 'Май',
      'Nov' => 'Ное',
      'Oct' => 'Окт',
      'Sep' => 'Сеп',

    # Template: AAAPreferences
      'Custom Queue' => 'Потребителска опашка',
      'Follow up notification' => 'Известие за наличност на следене на отговорът',
      'Frontend' => 'Зона-потребител',
      'Mail Management' => 'Управление на пощата',
      'Move notification' => 'Известие за преместване',
      'New ticket notification' => 'Напомняне за нов билет',
      'Other Options' => 'Други настройки',
      'Preferences updated successfully!' => 'Предпочитанията са обновени успешно',
      'QueueView refresh time' => 'Време за обновяване на изгледът на опашката',
      'Select your frontend Charset.' => 'Изберете Вашият символен набор.',
      'Select your frontend language.' => 'Изберете Вашият език.',
      'Select your frontend QueueView.' => 'Изберете език за визуализация съдържанието на опашката.',
      'Select your frontend Theme.' => 'Изберете Вашата потребителска тема',
      'Select your QueueView refresh time.' => 'Изберете Вашето време за обновяване за изгледа на опашката.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Изпратете ми известие, ако клиентът изпрати заявка за следене на отговора и аз съм собственик на билета',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Изпратете ми известие, ако билетът е преместен в някаква потребителска опашка.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Изпратете ми известие, ако билетът е отключен от системата.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Изпратете ми известие, ако има нов(и) билет в моята потребителска опашка.',
      'Ticket lock timeout notification' => 'Известие за продължителността на заключване на билетът',

    # Template: AAATicket
      '1 very low' => '1 много нисък',
      '2 low' => '2 нисък',
      '3 normal' => '3 нормален',
      '4 high' => '4 висок',
      '5 very high' => '5 много висок',
      'Action' => 'Действие',
      'Age' => 'Възраст',
      'Article' => 'Клауза',
      'Attachment' => 'Прикачен файл',
      'Attachments' => 'Прикачени файлове',
      'Bcc' => 'Скрито копие',
      'Bounce' => 'Отхвърли',
      'Cc' => 'Копие до',
      'Close' => 'Затваряне',
      'closed successful' => 'успешно затворен',
      'closed unsuccessful' => 'неуспешно затворен',
      'Compose' => 'Създаване',
      'Created' => 'Създаден',
      'Createtime' => 'време на създаване',
      'email' => 'еМейл',
      'eMail' => 'еМейл',
      'email-external' => 'външен еМейл',
      'email-internal' => 'вътрешен еМейл',
      'Forward' => 'Препратете',
      'From' => 'От',
      'high' => 'висок',
      'History' => 'Хроника',
      'If it is not displayed correctly,' => 'Ако не се вижда коректно,',
      'Lock' => 'Заключи',
      'low' => 'нисък',
      'Move' => 'Преместване',
      'new' => 'нов',
      'normal' => 'нормален',
      'note-external' => 'външна бележка',
      'note-internal' => 'вътрешна бележка',
      'note-report' => 'бележка отчет',
      'open' => 'отворен',
      'Owner' => 'Собственик',
      'Pending' => 'В очакване',
      'pending auto close+' => 'очаква автоматично затваряне+',
      'pending auto close-' => 'очаква автоматично затваряне-',
      'pending reminder' => 'очаква напомняне',
      'phone' => 'телефон',
      'plain' => 'обикновен',
      'Priority' => 'Приоритет',
      'Queue' => 'Опашка',
      'removed' => 'премахнат',
      'Sender' => 'Изпращач',
      'sms' => 'sms',
      'State' => 'Статус',
      'Subject' => 'Относно',
      'This is a' => 'Това е',
      'This is a HTML email. Click here to show it.' => 'Това е поща в HTML формат. Натиснете тук, за да го покажете коректно',
      'This message was written in a character set other than your own.' => 'Това писмо е написано в символна подредба различна от тази, която имате.',
      'Ticket' => 'Билет',
      'To' => 'До',
      'to open it in a new window.' => 'да го отворите в нов прозорец',
      'Unlock' => 'Отключи',
      'very high' => 'много висок',
      'very low' => 'много нисък',
      'View' => 'Изглед',
      'webrequest' => 'заявка по web',
      'Zoom' => 'Подробно',

    # Template: AAAWeekDay
      'Fri' => 'Пет',
      'Mon' => 'Пон',
      'Sat' => 'Съб',
      'Sun' => 'Нед',
      'Thu' => 'Чет',
      'Tue' => 'Вто',
      'Wed' => 'Сря',

    # Template: AdminAttachmentForm
      'Add attachment' => 'Добавяне на прикачен файл',
      'Attachment Management' => 'Управление на прикачен файл',
      'Change attachment settings' => 'Промяна настойки за прикачени файлове',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Добавяне на автоматичен отговор',
      'Auto Response From' => 'Автоматичен отговор от',
      'Auto Response Management' => 'Управление на автоматичният отговор',
      'Change auto response settings' => 'Промяна на настройките за автоматичният отговор',
      'Charset' => 'Символен набор',
      'Note' => 'Бележка',
      'Response' => 'Отговор',
      'to get the first 20 character of the subject' => 'за да получите първите 20 символа от поле "относно"',
      'to get the first 5 lines of the email' => 'за да получите първите 5 реда от писмото',
      'to get the from line of the email' => 'за да получите ред от писмото',
      'to get the realname of the sender (if given)' => 'за да получите истинското име на изпращача (ако е попълнено)',
      'to get the ticket number of the ticket' => 'за да получите номера на билета',
      'Type' => 'Тип',
      'Useable options' => 'Използваеми опции',

    # Template: AdminCharsetForm
      'Add charset' => 'Добавяне на символен набор',
      'Change system charset setting' => 'Промяна на системният символен набор',
      'System Charset Management' => 'Управление на символният набор',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Добавете клиент-потребител',
      'Change customer user settings' => 'Смяна на клиент-потребителските настройки',
      'Customer User Management' => 'Управление на клиент-потребители',
      'Customer user will be needed to to login via customer panels.' => 'Ще Ви е необходим предварително създаден потребител за достъп до потребителския панел',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'еМейл от Admin',
      'Body' => 'Тяло на писмото',
      'OTRS-Admin Info!' => 'Информация от OTRS-Admin',
      'Recipents' => 'Получатели',

    # Template: AdminEmailSent
      'Message sent to' => 'Съобщението е изпратено до',

    # Template: AdminGroupForm
      'Add group' => 'Добавяне на група',
      'Change group settings' => 'Промяна на груповите настройки',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Направете нови групи за да управляване позволенията за различните групи от агенти (примерно агент за отдел "продажби", отдел "поддръжка" и т.н.)',
      'Group Management' => 'Управление на групи',
      'It\'s useful for ASP solutions.' => 'Това е подходящо за решения с ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Групата admin достъпва admin зоната, а stat групата достъпва stat зоната',

    # Template: AdminLanguageForm
      'Add language' => 'Добавяне на език',
      'Change system language setting' => 'Промяна на настройките на системният език',
      'System Language Management' => 'Управление на езиковите настройки',

    # Template: AdminLog
      'System Log' => 'Системен журнал',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin еМейл',
      'AgentFrontend' => 'Зона-потребител',
      'Auto Response <-> Queue' => 'Автоматичен отговор <-> Опашки',
      'Auto Responses' => 'Автоматичен отговор',
      'Charsets' => 'Символен набор',
      'Customer User' => 'Клиент потребител',
      'Email Addresses' => 'еМейл адреси',
      'Groups' => 'Групи',
      'Logout' => 'Изход',
      'Misc' => 'Добавки',
      'POP3 Account' => 'POP3 акаунт',
      'Responses' => 'Отговори',
      'Responses <-> Queue' => 'Отговори <-> Опашки',
      'Select Box' => 'Изберете кутия',
      'Session Management' => 'Управление на сесята',
      'Status defs' => 'Дефиниции на състояния',
      'System' => 'Система',
      'User <-> Groups' => 'Потребител <-> Групи',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Добавяне на POP3 акаунт',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Всички входящи писма с един акаунт ще се разпределят в избраната опашка!',
      'Change POP3 Account setting' => 'Променете POP3 настройките за акаунта',
      'Dispatching' => '',
      'Host' => 'Хост',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Ако Вашият акаунт е доверен, ще се използва хедър x-otrs (за приоритетност, и т.н.)!',
      'Login' => 'Вход',
      'POP3 Account Management' => 'Управление на POP3 анаунта',
      'Trusted' => 'Доверен',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Опашка <-> Управление на автоматичният отговор',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = без ескалация',
      '0 = no unlock' => '0 = без отключване',
      'Add queue' => 'Добавяне на опашка',
      'Change queue settings' => 'Промяна на настройките на опашката',
      'Escalation time' => 'Време за ескалация (увеличаване на приоритетът)',
      'Follow up Option' => 'Параметри за автоматично проследяване',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ако билетът е затворен и потребителя изпрати заявка за проследяване, билетът ще бъде заключен за стария потребител',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Ако билетът не получи отговор в определеното време, ще се покаже само този билет',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ако агентът заключи билетът и той(или тя) не изпрати отговор в определеното време, билетър ще се отключи автоматично. Така билетър ще стане видим за всички други агенти',
      'Key' => 'Ключ',
      'Queue Management' => 'Управление на опашка',
      'Systemaddress' => 'Системен адрес',
      'The salutation for email answers.' => 'Обръщението за отговорите по еМейл',
      'The signature for email answers.' => 'Подписът за отговорите по еМейл',
      'Ticket lock after a follow up' => 'Заключване на билетът след автоматично известяване',
      'Unlock timeout' => 'Време за отключване',
      'Will be the sender address of this queue for email answers.' => 'Ще бъде адресът на изпраща за тази опашка при еМейл отговорите',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Промяна на %s настройки',
      'Std. Responses <-> Queue Management' => 'Стандартни отговори <-> Управление на опашката',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Отговор',
      'Change answer <-> queue settings' => 'Промяна на отговорът <-> Настройки на опашката',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Станд.отговори <-> Станд.управление на прикачените файлове',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Промяна на отговорътт <-> Настройки прикачени файлове',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Отговорът е текст по подразбиране, създанен предварително, с цел по-бърз отговор към клиента',
      'Add response' => 'Добавяне на отговор',
      'Change response settings' => 'Промяна на настойките на отговорът',
      'Don\'t forget to add a new response a queue!' => 'Да не забравите да добавите новият отговор към дадена опашка!',
      'Response Management' => 'Управление на отговорът',

    # Template: AdminSalutationForm
      'Add salutation' => 'Добавяне на обръщение',
      'Change salutation settings' => 'Промяна на настройките на обръщението',
      'customer realname' => 'име на потребителя',
      'Salutation Management' => 'Управление на обръщението',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Максимален брой редове',

    # Template: AdminSelectBoxResult
      'Limit' => 'Лимит',
      'Select Box Result' => 'Кутия за избор на резултата',
      'SQL' => 'SQL',

    # Template: AdminSession
      'kill all sessions' => 'Затваряне на всички текущи сесии',

    # Template: AdminSessionTable
      'kill session' => 'Затваряне на единична сесия',
      'SessionID' => 'Идентификатор на сесия',

    # Template: AdminSignatureForm
      'Add signature' => 'Добавяне на подпис',
      'Change signature settings' => 'Промяна на настройките на подписът',
      'for agent firstname' => 'за агента - име',
      'for agent lastname' => 'за агента - фамилия',
      'Signature Management' => 'Управление на подписът',

    # Template: AdminStateForm
      'Add state' => 'Добавяне на състояние',
      'Change system state setting' => 'Промяна на настройките за системно състояние',
      'System State Management' => 'Управление на системно състояние',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Добавяне на нов системен адрес',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Всички входящи адреси от този еМейл (До:) ще се разпределят в избраната опашка',
      'Change system address setting' => 'Промяна на настройките на системният адрес',
      'Email' => 'еМейл',
      'Realname' => 'Истинско име',
      'System Email Addresses Management' => 'Управление на системния еМейл адрес',

    # Template: AdminUserForm
      'Add user' => 'Добавяне на потребител',
      'Change user settings' => 'Промяна на потребителските настройки',
      'Don\'t forget to add a new user to groups!' => 'Не забравяйте да добавите новият потребител в някаква група!',
      'Firstname' => 'Име',
      'Lastname' => 'Фамилия',
      'User Management' => 'Управление на потребители',
      'User will be needed to handle tickets.' => 'Ще е необходим потребител, за да може билетът да се обработи',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => 'Промяна на настройки',
      'User <-> Group Management' => 'Потребител <-> Управление на група',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Промяна на потребител <-> Настройки за група',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Съобщението трябва да има ДО: т.е. адресант!',
      'Bounce ticket' => 'Отказан билет',
      'Bounce to' => 'Отказ на',
      'Inform sender' => 'Да се информира изпращачът',
      'Next ticket state' => 'Следващо състояние за билетът',
      'Send mail!' => 'Изпратете еМейл!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Трябва да има валиден адрес в полето ДО: (примерно support@hebros.bg)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'еМеълът Ви с номер "<OTRS_TICKET>" е отхвърлен към "<OTRS_BOUNCE_TO>". Свържете се с този адрес за повече информация',

    # Template: AgentClose
      ' (work units)' => ' (работни единици)',
      'Close ticket' => 'Затворете бълетът',
      'Close type' => 'Тип затваряне',
      'Close!' => 'Затворете!',
      'Note Text' => 'Текст на билежката',
      'Note type' => 'Бележката е от тип',
      'store' => 'съхранение',
      'Time units' => 'Единици за времето',

    # Template: AgentCompose
      'A message should have a subject!' => 'Съобщението трябва да има текст в поле "относно"!',
      'Attach' => 'Прикачен файл',
      'Compose answer for ticket' => 'Създаване на отговор за този билет',
      'for pending* states' => 'за състояния в очакване* ',
      'Is the ticket answered' => 'Дали билетът е получил отговор',
      'Options' => 'Настройки',
      'Pending Date' => 'В очакване-дата',
      'Spell Check' => 'Проверка на правописа',

    # Template: AgentCustomer
      'Back' => 'Назад',
      'Change customer of ticket' => 'Промяна на потребителят на билета',
      'Set customer id of a ticket' => 'Задаване на потребителски индикатив на билета',

    # Template: AgentCustomerHistory
      'Customer history' => 'Хроника на потребителят',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => 'Данни за потребителя',

    # Template: AgentForward
      'Article type' => 'Клауза тип',
      'Date' => 'Дата',
      'End forwarded message' => 'Край на препратеното съобщение',
      'Forward article of ticket' => 'Препрати клаузата за този билет',
      'Forwarded message from' => 'Препратено съобщение от',
      'Reply-To' => 'Отговор на',

    # Template: AgentHistoryForm
      'History of' => 'Хроника на',

    # Template: AgentMailboxNavBar
      'All messages' => 'Всички съобщения',
      'CustomerID' => 'Потребителски индикатив',
      'down' => 'надолу',
      'Mailbox' => 'Пощенска кутия',
      'New' => 'Нови',
      'New messages' => 'Нови съобщения',
      'Open' => 'Отворени',
      'Open messages' => 'Отворени съобщения',
      'Order' => 'Ред',
      'Pending messages' => 'Съобщения в очакване',
      'Reminder' => 'Напомняне',
      'Reminder messages' => 'Напомнящи съобщения',
      'Sort by' => 'Сортиране по',
      'Tickets' => 'Билети',
      'up' => 'нагоре',

    # Template: AgentMailboxTicket
      'Add Note' => 'Добавяне на бележка',

    # Template: AgentNavigationBar
      'FAQ' => 'Често задавани въпроси',
      'Locked tickets' => 'Заключени билети',
      'new message' => 'ново съобщение',
      'PhoneView' => 'Преглед на телефоните',
      'Preferences' => 'Предпочитания',
      'Utilities' => 'Помощни средства',

    # Template: AgentNote
      'Add note to ticket' => 'Добавяне на бележка към билета',
      'Note!' => 'Бележка!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Промяна собственикън на билета',
      'Message for new Owner' => 'Съобщение за нов собственик',
      'New user' => 'Нов потребител',

    # Template: AgentPending
      'Pending date' => 'В очакване - дата',
      'Pending type' => 'В очакване - тип',
      'Set Pending' => 'В очакване - задаване',

    # Template: AgentPhone
      'Customer called' => 'Извършено е тел.обаждане до потребителят',
      'Phone call' => 'Телефонно обаждане',
      'Phone call at %s' => 'Телефонно обаждане в %s',

    # Template: AgentPhoneNew
      'new ticket' => 'нов билет',

    # Template: AgentPlain
      'ArticleID' => 'Идентификатор на клауза',
      'Plain' => 'Обикновен',
      'TicketID' => 'Идентификатор на билет',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Изберете Вашата потребителска опашка',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Промяна на парола',
      'New password' => 'Нова парола',
      'New password again' => 'Въведете отново паролата',

    # Template: AgentPriority
      'Change priority of ticket' => 'Промяна на приоритета на билета',
      'New state' => 'Ново състояние',

    # Template: AgentSpelling
      'Apply these changes' => 'Прилага се към тези промени',
      'Discard all changes and return to the compose screen' => 'Отказвате се от всички промени и се връщате към екрана за създаване',
      'Return to the compose screen' => 'Връщате се към екрана за създаване',
      'Spell Checker' => 'Проверка на правописът',
      'spelling error(s)' => 'Правописна грешка(грешки)',
      'The message being composed has been closed.  Exiting.' => 'Съобщението, което създавахте е затворено. Изход.',
      'This window must be called from compose window' => 'Този прозорец трябва да бъде извикан от прозореца за създаване',

    # Template: AgentStatusView
      'D' => 'D',
      'sort downward' => 'низходящо сортиране',
      'sort upward' => 'възходящо сортиране',
      'Ticket limit:' => 'Ограничение по време:',
      'Ticket Status' => 'Състояние на билетът',
      'U' => 'U',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Билетът е заключен!',
      'unlock' => 'отключи',

    # Template: AgentTicketPrint
      'by' => '',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Отброено време',
      'Escalation in' => 'Улеличение на приоритета в',
      'printed by' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Търсене в хрониката на клиента',
      'Customer history search (e. g. "ID342425").' => 'Търсене в хрониката на клиента (примерно "ID342425").',
      'No * possible!' => 'Не е възможно използване на символ *!',

    # Template: AgentUtilSearchByText
      'Article free text' => 'Клауза свободен текст',
      'Fulltext search' => 'Текстово търсене',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Текстово търсене (примерно "Mar*in" или "Baue*" или "martin+hallo")',
      'Search in' => 'Търсене в',
      'Ticket free text' => 'Билет свободен текст',
      'With State' => '',

    # Template: AgentUtilSearchByTicketNumber
      'search' => 'търсене',
      'search (e. g. 10*5155 or 105658*)' => 'търсене (примерно 10*5155 или 105658*)',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Резултат',
      'Site' => 'Място',
      'Total hits' => 'Общ брой попадения',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => 'Всички отворени билети',
      'open tickets' => 'Отворени билети',
      'Provides an overview of all' => 'Осигурява общ преглед на всички',
      'So you see what is going on in your system.' => 'Какво става във Вашата система',

    # Template: CustomerCreateAccount
      'Create' => 'Създаване',
      'Create Account' => 'Създаване на акаунт',

    # Template: CustomerError
      'Backend' => 'Фонов',
      'BackendMessage' => 'Фоново съобщение',
      'Click here to report a bug!' => 'Натиснете тук, за да изпратите отчет за грешката!',
      'Handle' => 'Манипулатор',

    # Template: CustomerFooter
      'Powered by' => 'С помощта на',

    # Template: CustomerHeader
      'Contact' => 'Контакт',
      'Home' => 'Начало',
      'Online-Support' => 'На линия-поддръжка',
      'Products' => 'Продукти',
      'Support' => 'Поддръжка',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Забравена парола',
      'Request new password' => 'Завка за нова парола',

    # Template: CustomerMessage
      'Follow up' => 'Заявка за отговор',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Създаване на нов билет',
      'My Tickets' => 'Моите билети',
      'New Ticket' => 'Нов билет',
      'Ticket-Overview' => 'Билети-преглед',
      'Welcome %s' => 'Привет %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => 'на',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => 'следваща стъпка',

    # Template: InstallerSystem
      '(Email of the system admin)' => '(еМейл на системният администратор)',
      '(Full qualified domain name of your system)' => '(Пълно квалифицирано име (FQDN) на системата)',
      '(Logfile just needed for File-LogModule!)' => '(Журналният файл е необходим само за File-LogModule)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Идентифициране на системата. Всики номер на билет и всяка http сесия започва с този номер)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '(Изполван език по подразбиране)',
      '(Used log backend)' => '(Използван журнален изход)',
      '(Used ticket number format)' => '(Използван формат за номера на билетът)',
      'Default Charset' => 'Символен набор по подразбиране',
      'Default Language' => 'Език по подразбиране',
      'Logfile' => 'Журнален файл',
      'LogModule' => 'Журнален модул',
      'Organization' => 'Организация',
      'System FQDN' => 'Системно FQDN',
      'SystemID' => 'Системно ID',
      'Ticket Hook' => 'Прикачване на билетът',
      'Ticket Number Generator' => 'Генератор на номера на билети',
      'Webfrontend' => 'Web-зона',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Нямате позволение',

    # Template: Notify
      'Info' => 'Информация',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'Print' => '',

    # Template: QueueView
      'All tickets' => 'Всички билети',
      'Queues' => 'Опашки',
      'Show all' => 'Показване на всички',
      'Ticket available' => 'Налични билети',
      'tickets' => 'билети',
      'Tickets shown' => 'Показани билети',

    # Template: SystemStats
      'Graphs' => 'Графики',

    # Template: Test
      'OTRS Test Page' => 'Тестова страница на OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ескалация (увеличаване на приоритета) на билета!',

    # Template: TicketView
      'Change queue' => 'Промяна на опашката',
      'Compose Answer' => 'Създаване на отговор',
      'Contact customer' => 'Контакт с клиента',
      'phone call' => 'телефонно обаждане',

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Натиснете тук, за да добавите нова група)',
      '(Click here to add a queue)' => '(Натиснете тук, за да добавите нова опашка)',
      '(Click here to add a response)' => '(Натиснете тук, за да добавите нов отговор)',
      '(Click here to add a salutation)' => '(Натиснете тук, за да добавите ново обръщение)',
      '(Click here to add a signature)' => '(Натиснете тук, за да добавите нов подпис)',
      '(Click here to add a system email address)' => '(Натиснете тук, за да добавите нов системен адрес)',
      '(Click here to add a user)' => '(Натиснете тук, за да добавите нов потребител)',
      '(Click here to add an auto response)' => '(Натиснете тук, за да добавите нов автоматичен отговор)',
      '(Click here to add charset)' => '(Натиснете тук, за да добавите нов символен набор)',
      '(Click here to add language)' => '(Натиснете тук, за да добавите нов език)',
      '(Click here to add state)' => '(Натиснете тук, за да добавите ново системно състояние )',
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Идентификатор на билетът. Някои хора желаят да зададат стойности, като \'Ticket#\', \'Call#\' или \'MyTicket#\')',
      'A message should have a From: recipient!' => 'Съобщението трябва да има попълнено поле ОТ:',
      'CustomerUser' => 'Клиент-потребител',
      'New ticket via call.' => 'Нов билет чрез обаждане',
      'Time till escalation' => 'Време до ескалация',
      'Update auto response' => 'Обновяване на автоматичният отговор',
      'Update charset' => 'Обновяване на символен набор',
      'Update group' => 'Обновяване на група',
      'Update language' => 'Обновяване на език',
      'Update queue' => 'Обновяване на опашка',
      'Update response' => 'Обновяване на отговорът',
      'Update salutation' => 'Обновяване на обръщение',
      'Update signature' => 'Обновяване на подпис',
      'Update state' => 'Обновяване на състояние',
      'Update system address' => 'Обновяване ан системният адрес',
      'Update user' => 'Обновяване на потребител',
      'You have to be in the admin group!' => 'Трябва да сте член на admin групата!',
      'You have to be in the stats group!' => 'Трябва да сте член на stat групата!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Трябва да имате еМейл адрес (примерно customer@example.com) в поле ОТ:',
      'auto responses set' => 'набор автоматични отговори',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;

}
# --
1;
