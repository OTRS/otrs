# --
# Kernel/Language/bg.pm - provides bg language translation
# Copyright (C) 2002 Vladimir Gerdjikov <gerdjikov at gerdjikovs.net>
# --
# $Id: bg.pm,v 1.22 2004-02-10 00:18:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::bg;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Feb 10 01:07:04 2004 by 

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Минути',
      ' 5 minutes' => ' 5 Минути',
      ' 7 minutes' => ' 7 Минути',
      '(Click here to add)' => '',
      '10 minutes' => '10 Минути',
      '15 minutes' => '15 Минути',
      'AddLink' => 'Добавяне на връзка',
      'Admin-Area' => 'Зона-Администратор',
      'agent' => '',
      'Agent-Area' => '',
      'all' => 'всички',
      'All' => 'Всички',
      'Attention' => 'Внимание',
      'before' => '',
      'Bug Report' => 'Отчет за грешка',
      'Cancel' => 'Отказ',
      'change' => 'променете',
      'Change' => 'Промяна',
      'change!' => 'променете!',
      'click here' => 'натиснете тук',
      'Comment' => 'Коментар',
      'Customer' => 'Потребител',
      'customer' => '',
      'Customer Info' => 'Потребителски данни',
      'day' => 'ден',
      'day(s)' => '',
      'days' => 'дни',
      'description' => 'описание',
      'Description' => 'Описание',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работете с UserID 1 (Системен акаунт)! Създайте нов потребители',
      'Done' => 'Готово.',
      'end' => 'Край',
      'Error' => 'Грешка',
      'Example' => 'Пример',
      'Examples' => 'Примери',
      'Facility' => 'Приспособление',
      'FAQ-Area' => '',
      'Feature not active!' => 'Функцията не е активна',
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
      'last' => '',
      'Line' => 'Линия',
      'Lite' => 'Лека',
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешно оторизиране! Вашето име или парола са некоректини!',
      'Logout successful. Thank you for using OTRS!' => 'Изходът е успешен. Благодарим Ви, че използвахте системата.',
      'Message' => 'Съобщение',
      'minute' => 'минута',
      'minutes' => 'минути',
      'Module' => 'Модул',
      'Modulefile' => 'Файл-модул',
      'month(s)' => '',
      'Name' => 'Име',
      'New Article' => '',
      'New message' => 'Ново съобщение',
      'New message!' => 'Ново съобщение!',
      'No' => 'Не',
      'no' => 'не',
      'No entry found!' => '',
      'No suggestions' => 'Няма предположения',
      'none' => 'няма',
      'none - answered' => 'няма - отговорен',
      'none!' => 'няма!',
      'Normal' => '',
      'Off' => 'Изключено',
      'off' => 'изключено',
      'On' => 'Включено',
      'on' => 'включено',
      'Password' => 'Парола',
      'Pending till' => 'В очакване до',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Моля, отговорете на този билет(и) за да се върнете в нормалния изглед на опашката!',
      'Please contact your admin' => 'Моля, свържете се с Вашият администратор',
      'please do not edit!' => 'моля, не редактирайте!',
      'Please go away!' => '',
      'possible' => 'възможен',
      'Preview' => '',
      'QueueView' => 'Преглед на опашката',
      'reject' => 'отхвърлен',
      'replace with' => 'замести с',
      'Reset' => 'Рестартирай',
      'Salutation' => 'Обръщение',
      'Session has timed out. Please log in again.' => '',
      'Show closed Tickets' => '',
      'Signature' => 'Подпис',
      'Sorry' => 'Съжаляваме',
      'Stats' => 'Статистики',
      'Subfunction' => 'Подфункция',
      'submit' => 'изпратете',
      'submit!' => 'изпратете!',
      'system' => '',
      'Take this User' => '',
      'Text' => 'Текст',
      'The recommended charset for your language is %s!' => 'Препоръчителният символен набор за Вашият език е %s',
      'Theme' => 'Тема',
      'There is no account with that login name.' => 'Няма потребител с това име.',
      'Timeover' => 'Край на времето',
      'To: (%s) replaced with database email!' => '',
      'top' => 'към началото',
      'update' => 'обновяване',
      'Update' => 'обновяване',
      'update!' => 'обновяване!',
      'User' => 'Потребител',
      'Username' => 'Потребителско име',
      'Valid' => 'Валиден',
      'Warning' => 'Предупреждение',
      'week(s)' => '',
      'Welcome to OTRS' => 'Добре дошли в OTRS',
      'Word' => 'Дума',
      'wrote' => 'записано',
      'year(s)' => '',
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
      'Closed Tickets' => '',
      'Custom Queue' => 'Потребителска опашка',
      'Follow up notification' => 'Известие за наличност на следене на отговорът',
      'Frontend' => 'Зона-потребител',
      'Mail Management' => 'Управление на пощата',
      'Max. shown Tickets a page in Overview.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Move notification' => 'Известие за преместване',
      'New ticket notification' => 'Напомняне за нов билет',
      'Other Options' => 'Други настройки',
      'PhoneView' => 'Преглед на телефоните',
      'Preferences updated successfully!' => 'Предпочитанията са обновени успешно',
      'QueueView refresh time' => 'Време за обновяване на изгледът на опашката',
      'Screen after new ticket' => '',
      'Select your default spelling dictionary.' => '',
      'Select your frontend Charset.' => 'Изберете Вашият символен набор.',
      'Select your frontend language.' => 'Изберете Вашият език.',
      'Select your frontend QueueView.' => 'Изберете език за визуализация съдържанието на опашката.',
      'Select your frontend Theme.' => 'Изберете Вашата потребителска тема',
      'Select your QueueView refresh time.' => 'Изберете Вашето време за обновяване за изгледа на опашката.',
      'Select your screen after creating a new ticket.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Изпратете ми известие, ако клиентът изпрати заявка за следене на отговора и аз съм собственик на билета',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Изпратете ми известие, ако билетът е преместен в някаква потребителска опашка.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Изпратете ми известие, ако билетът е отключен от системата.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Изпратете ми известие, ако има нов(и) билет в моята потребителска опашка.',
      'Show closed tickets.' => '',
      'Spelling Dictionary' => '',
      'Ticket lock timeout notification' => 'Известие за продължителността на заключване на билетът',
      'TicketZoom' => '',

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
      'lock' => '',
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
      'Ticket "%s" created!' => '',
      'To' => 'До',
      'to open it in a new window.' => 'да го отворите в нов прозорец',
      'unlock' => 'отключи',
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
      'Add' => '',
      'Attachment Management' => 'Управление на прикачен файл',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Добавяне на автоматичен отговор',
      'Auto Response From' => 'Автоматичен отговор от',
      'Auto Response Management' => 'Управление на автоматичният отговор',
      'Change auto response settings' => 'Промяна на настройките за автоматичният отговор',
      'Note' => 'Бележка',
      'Response' => 'Отговор',
      'to get the first 20 character of the subject' => 'за да получите първите 20 символа от поле "относно"',
      'to get the first 5 lines of the email' => 'за да получите първите 5 реда от писмото',
      'to get the from line of the email' => 'за да получите ред от писмото',
      'to get the realname of the sender (if given)' => 'за да получите истинското име на изпращача (ако е попълнено)',
      'to get the ticket id of the ticket' => '',
      'to get the ticket number of the ticket' => 'за да получите номера на билета',
      'Type' => 'Тип',
      'Useable options' => 'Използваеми опции',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Управление на клиент-потребители',
      'Customer user will be needed to to login via customer panels.' => 'Ще Ви е необходим предварително създаден потребител за достъп до потребителския панел',
      'Select source:' => '',
      'Source' => '',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Промяна на %s настройки',
      'Customer User <-> Group Management' => '',
      'Full read and write access to the tickets in this group/queue.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => '',
      'Read only access to the ticket in this group/queue.' => '',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => '',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Промяна на потребител <-> Настройки за група',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'еМейл от Admin',
      'Body' => 'Тяло на писмото',
      'OTRS-Admin Info!' => 'Информация от OTRS-Admin',
      'Recipents' => 'Получатели',
      'send' => '',

    # Template: AdminEmailSent
      'Message sent to' => 'Съобщението е изпратено до',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Направете нови групи за да управляване позволенията за различните групи от агенти (примерно агент за отдел "продажби", отдел "поддръжка" и т.н.)',
      'Group Management' => 'Управление на групи',
      'It\'s useful for ASP solutions.' => 'Това е подходящо за решения с ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Групата admin достъпва admin зоната, а stat групата достъпва stat зоната',

    # Template: AdminLog
      'System Log' => 'Системен журнал',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin еМейл',
      'Attachment <-> Response' => '',
      'Auto Response <-> Queue' => 'Автоматичен отговор <-> Опашки',
      'Auto Responses' => 'Автоматичен отговор',
      'Customer User' => 'Клиент потребител',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'еМейл адреси',
      'Groups' => 'Групи',
      'Logout' => 'Изход',
      'Misc' => 'Добавки',
      'Notifications' => '',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'PostMaster POP3 акаунт',
      'Responses' => 'Отговори',
      'Responses <-> Queue' => 'Отговори <-> Опашки',
      'Select Box' => 'Изберете кутия',
      'Session Management' => 'Управление на сесята',
      'Status' => '',
      'System' => 'Система',
      'User <-> Groups' => 'Потребител <-> Групи',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Всички входящи писма с един акаунт ще се разпределят в избраната опашка!',
      'Dispatching' => '',
      'Host' => 'Хост',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Ако Вашият акаунт е доверен, ще се използва хедър x-otrs (за приоритетност, и т.н.)!',
      'Login' => 'Вход',
      'POP3 Account Management' => 'Управление на POP3 анаунта',
      'Trusted' => 'Доверен',

    # Template: AdminPostMasterFilterForm
      'Match' => '',
      'PostMasterFilter Management' => '',
      'Set' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Опашка <-> Управление на автоматичният отговор',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = без ескалация',
      '0 = no unlock' => '0 = без отключване',
      'Customer Move Notify' => '',
      'Customer Owner Notify' => '',
      'Customer State Notify' => '',
      'Escalation time' => 'Време за ескалация (увеличаване на приоритетът)',
      'Follow up Option' => 'Параметри за автоматично проследяване',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ако билетът е затворен и потребителя изпрати заявка за проследяване, билетът ще бъде заключен за стария потребител',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Ако билетът не получи отговор в определеното време, ще се покаже само този билет',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ако агентът заключи билетът и той(или тя) не изпрати отговор в определеното време, билетър ще се отключи автоматично. Така билетър ще стане видим за всички други агенти',
      'Key' => 'Ключ',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'Queue Management' => 'Управление на опашка',
      'Sub-Queue of' => '',
      'Systemaddress' => 'Системен адрес',
      'The salutation for email answers.' => 'Обръщението за отговорите по еМейл',
      'The signature for email answers.' => 'Подписът за отговорите по еМейл',
      'Ticket lock after a follow up' => 'Заключване на билетът след автоматично известяване',
      'Unlock timeout' => 'Време за отключване',
      'Will be the sender address of this queue for email answers.' => 'Ще бъде адресът на изпраща за тази опашка при еМейл отговорите',

    # Template: AdminQueueResponsesChangeForm
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
      'Don\'t forget to add a new response a queue!' => 'Да не забравите да добавите новият отговор към дадена опашка!',
      'Next state' => '',
      'Response Management' => 'Управление на отговорът',
      'The current ticket state is' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'име на потребителя',
      'for agent firstname' => 'за агента - име',
      'for agent lastname' => 'за агента - фамилия',
      'for agent login' => '',
      'for agent user id' => '',
      'Salutation Management' => 'Управление на обръщението',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Максимален брой редове',

    # Template: AdminSelectBoxResult
      'Limit' => 'Лимит',
      'Select Box Result' => 'Кутия за избор на резултата',
      'SQL' => 'SQL',

    # Template: AdminSession
      'Agent' => '',
      'kill all sessions' => 'Затваряне на всички текущи сесии',
      'Overview' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Затваряне на единична сесия',
      'SessionID' => 'Идентификатор на сесия',

    # Template: AdminSignatureForm
      'Signature Management' => 'Управление на подписът',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => '',
      'System State Management' => 'Управление на системно състояние',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Всички входящи адреси от този еМейл (До:) ще се разпределят в избраната опашка',
      'Email' => 'еМейл',
      'Realname' => 'Истинско име',
      'System Email Addresses Management' => 'Управление на системния еМейл адрес',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Не забравяйте да добавите новият потребител в някаква група!',
      'Firstname' => 'Име',
      'Lastname' => 'Фамилия',
      'User Management' => 'Управление на потребители',
      'User will be needed to handle tickets.' => 'Ще е необходим потребител, за да може билетът да се обработи',

    # Template: AdminUserGroupChangeForm
      'create' => '',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'User <-> Group Management' => 'Потребител <-> Управление на група',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Отказвате се от всички промени и се връщате към екрана за създаване',
      'Return to the compose screen' => 'Връщате се към екрана за създаване',
      'Search' => '',
      'The message being composed has been closed.  Exiting.' => 'Съобщението, което създавахте е затворено. Изход.',
      'This window must be called from compose window' => 'Този прозорец трябва да бъде извикан от прозореца за създаване',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Съобщението трябва да има ДО: т.е. адресант!',
      'Bounce ticket' => 'Отказан билет',
      'Bounce to' => 'Отказ на',
      'Inform sender' => 'Да се информира изпращачът',
      'Next ticket state' => 'Следващо състояние за билетът',
      'Send mail!' => 'Изпратете еМейл!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Трябва да има валиден адрес в полето ДО: (примерно support@hebros.bg)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'еМеълът Ви с номер "<OTRS_TICKET>" е отхвърлен към "<OTRS_BOUNCE_TO>". Свържете се с този адрес за повече информация',

    # Template: AgentClose
      ' (work units)' => ' (работни единици)',
      'A message should have a body!' => '',
      'A message should have a subject!' => 'Съобщението трябва да има текст в поле "относно"!',
      'Close ticket' => 'Затворете бълетът',
      'Close type' => 'Тип затваряне',
      'Close!' => 'Затворете!',
      'Note Text' => 'Текст на билежката',
      'Note type' => 'Бележката е от тип',
      'Options' => 'Настройки',
      'Spell Check' => 'Проверка на правописа',
      'Time units' => 'Единици за времето',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => '',
      'Attach' => 'Прикачен файл',
      'Compose answer for ticket' => 'Създаване на отговор за този билет',
      'for pending* states' => 'за състояния в очакване* ',
      'Is the ticket answered' => 'Дали билетът е получил отговор',
      'Pending Date' => 'В очакване-дата',

    # Template: AgentCustomer
      'Back' => 'Назад',
      'Change customer of ticket' => 'Промяна на потребителят на билета',
      'CustomerID' => 'Потребителски индикатив',
      'Search Customer' => '',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'Хроника на потребителят',

    # Template: AgentCustomerMessage
      'Follow up' => 'Заявка за отговор',

    # Template: AgentCustomerView
      'Customer Data' => 'Данни за потребителя',

    # Template: AgentEmailNew
      'All Agents' => '',
      'Clear From' => '',
      'Compose Email' => '',
      'Lock Ticket' => '',
      'new ticket' => 'нов билет',

    # Template: AgentForward
      'Article type' => 'Клауза тип',
      'Date' => 'Дата',
      'End forwarded message' => 'Край на препратеното съобщение',
      'Forward article of ticket' => 'Препрати клаузата за този билет',
      'Forwarded message from' => 'Препратено съобщение от',
      'Reply-To' => 'Отговор на',

    # Template: AgentFreeText
      'Change free text of ticket' => '',
      'Value' => '',

    # Template: AgentHistoryForm
      'History of' => 'Хроника на',

    # Template: AgentMailboxNavBar
      'All messages' => 'Всички съобщения',
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
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'Move Ticket' => '',
      'New Owner' => '',
      'New Queue' => '',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Заключени билети',
      'new message' => 'ново съобщение',
      'Preferences' => 'Предпочитания',
      'Utilities' => 'Помощни средства',

    # Template: AgentNote
      'Add note to ticket' => 'Добавяне на бележка към билета',
      'Note!' => 'Бележка!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Промяна собственикън на билета',
      'Message for new Owner' => 'Съобщение за нов собственик',

    # Template: AgentPending
      'Pending date' => 'В очакване - дата',
      'Pending type' => 'В очакване - тип',
      'Pending!' => '',
      'Set Pending' => 'В очакване - задаване',

    # Template: AgentPhone
      'Customer called' => 'Извършено е тел.обаждане до потребителят',
      'Phone call' => 'Телефонно обаждане',
      'Phone call at %s' => 'Телефонно обаждане в %s',

    # Template: AgentPhoneNew

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

    # Template: AgentSpelling
      'Apply these changes' => 'Прилага се към тези промени',
      'Spell Checker' => 'Проверка на правописът',
      'spelling error(s)' => 'Правописна грешка(грешки)',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'на',
      'Site' => 'Място',
      'sort downward' => 'низходящо сортиране',
      'sort upward' => 'възходящо сортиране',
      'Ticket Status' => 'Състояние на билетът',
      'U' => 'U',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => '',
      'Link to' => '',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Билетът е заключен!',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint
      'by' => '',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Отброено време',
      'Escalation in' => 'Улеличение на приоритета в',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      'and' => '',
      'Customer User Login' => '',
      'Delete' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'No time settings.' => '',
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Search' => '',
      'TicketFreeText' => '',
      'Times' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Търсене в хрониката на клиента',
      'Customer history search (e. g. "ID342425").' => 'Търсене в хрониката на клиента (примерно "ID342425").',
      'No * possible!' => 'Не е възможно използване на символ *!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => '',
      'Results' => 'Резултат',
      'Search Result' => '',
      'Total hits' => 'Общ брой попадения',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => '',
      'All open tickets' => 'Всички отворени билети',
      'closed tickets' => '',
      'open tickets' => 'Отворени билети',
      'or' => '',
      'Provides an overview of all' => 'Осигурява общ преглед на всички',
      'So you see what is going on in your system.' => 'Какво става във Вашата система',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => '',
      'Your own Ticket' => '',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Създаване на отговор',
      'Contact customer' => 'Контакт с клиента',
      'phone call' => 'телефонно обаждане',

    # Template: AgentZoomArticle
      'Split' => '',

    # Template: AgentZoomBody
      'Change queue' => 'Промяна на опашката',

    # Template: AgentZoomHead
      'Free Fields' => '',
      'Print' => '',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Създаване на акаунт',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'Edit' => '',
      'FAQ History' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => '',
      'Keywords' => '',
      'Last update' => '',
      'Problem' => '',
      'Solution' => '',
      'Symptom' => '',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
      'Modified' => '',

    # Template: CustomerFAQOverview
      'FAQ Overview' => '',

    # Template: CustomerFAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => '',

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

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Създаване на нов билет',
      'FAQ' => 'Често задавани въпроси',
      'New Ticket' => 'Нов билет',
      'Ticket-Overview' => 'Билети-преглед',
      'Welcome %s' => 'Привет %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Моите билети',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Натиснете тук, за да изпратите отчет за грешката!',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'Comment (internal)' => '',
      'Filename' => '',
      'Short Description' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => '',

    # Template: Footer
      'Top of Page' => '',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => '',
      'Drop Database' => '',
      'Finished' => '',
      'System Settings' => '',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => '',
      'After doing so your OTRS is up and running.' => '',
      'Have a lot of fun!' => '',
      'Restart your webserver' => '',
      'Start page' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Your OTRS Team' => '',

    # Template: InstallerLicense
      'accept license' => '',
      'don\'t accept license' => '',
      'License' => '',

    # Template: InstallerStart
      'Create new database' => '',
      'DB Admin Password' => '',
      'DB Admin User' => '',
      'DB Host' => '',
      'DB Type' => '',
      'default \'hot\'' => '',
      'Delete old database' => '',
      'next step' => 'следваща стъпка',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => '(еМейл на системният администратор)',
      '(Full qualified domain name of your system)' => '(Пълно квалифицирано име (FQDN) на системата)',
      '(Logfile just needed for File-LogModule!)' => '(Журналният файл е необходим само за File-LogModule)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Идентифициране на системата. Всики номер на билет и всяка http сесия започва с този номер)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '(Изполван език по подразбиране)',
      '(Used log backend)' => '(Използван журнален изход)',
      '(Used ticket number format)' => '(Използван формат за номера на билетът)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Символен набор по подразбиране',
      'Default Language' => 'Език по подразбиране',
      'Logfile' => 'Журнален файл',
      'LogModule' => 'Журнален модул',
      'Organization' => 'Организация',
      'System FQDN' => 'Системно FQDN',
      'SystemID' => 'Системно ID',
      'Ticket Hook' => 'Прикачване на билетът',
      'Ticket Number Generator' => 'Генератор на номера на билети',
      'Use utf-8 it your database supports it!' => '',
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
      'printed by' => '',

    # Template: QueueView
      'All tickets' => 'Всички билети',
      'Page' => '',
      'Queues' => 'Опашки',
      'Tickets available' => 'Налични билети',
      'Tickets shown' => 'Показани билети',

    # Template: SystemStats
      'Graphs' => 'Графики',

    # Template: Test
      'OTRS Test Page' => 'Тестова страница на OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ескалация (увеличаване на приоритета) на билета!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Добавяне на бележка',

    # Template: Warning

    # Misc
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Идентификатор на билетът. Някои хора желаят да зададат стойности, като \'Ticket#\', \'Call#\' или \'MyTicket#\')',
      'A message should have a From: recipient!' => 'Съобщението трябва да има попълнено поле ОТ:',
      'AgentFrontend' => 'Зона-потребител',
      'Article free text' => 'Клауза свободен текст',
      'Backend' => 'Фонов',
      'BackendMessage' => 'Фоново съобщение',
      'Charset' => 'Символен набор',
      'Charsets' => 'Символен набор',
      'Create' => 'Създаване',
      'CustomerUser' => 'Клиент-потребител',
      'Fulltext search' => 'Текстово търсене',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Текстово търсене (примерно "Mar*in" или "Baue*" или "martin+hallo")',
      'Handle' => 'Манипулатор',
      'New state' => 'Ново състояние',
      'New ticket via call.' => 'Нов билет чрез обаждане',
      'New user' => 'Нов потребител',
      'Screen after new phone ticket' => '',
      'Search in' => 'Търсене в',
      'Select your screen after creating a new ticket via PhoneView.' => '',
      'Set customer id of a ticket' => 'Задаване на потребителски индикатив на билета',
      'Show all' => 'Показване на всички',
      'Status defs' => 'Дефиниции на състояния',
      'System Charset Management' => 'Управление на символният набор',
      'System Language Management' => 'Управление на езиковите настройки',
      'Ticket free text' => 'Билет свободен текст',
      'Ticket limit:' => 'Ограничение по време:',
      'Time till escalation' => 'Време до ескалация',
      'With State' => '',
      'You have to be in the admin group!' => 'Трябва да сте член на admin групата!',
      'You have to be in the stats group!' => 'Трябва да сте член на stat групата!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Трябва да имате еМейл адрес (примерно customer@example.com) в поле ОТ:',
      'auto responses set' => 'набор автоматични отговори',
      'search' => 'търсене',
      'search (e. g. 10*5155 or 105658*)' => 'търсене (примерно 10*5155 или 105658*)',
      'store' => 'съхранение',
      'tickets' => 'билети',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
