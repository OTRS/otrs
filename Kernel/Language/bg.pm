# --
# Kernel/Language/bg.pm - provides bg language translation
# Copyright (C) 2004 Vladimir Gerdjikov <gerdjikov at gerdjikovs.net>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::bg;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.29 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:07:54 2004 by 

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';
    $Self->{DateInputFormatLong} = '';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Минути',
      ' 5 minutes' => ' 5 Минути',
      ' 7 minutes' => ' 7 Минути',
      '(Click here to add)' => '',
      '...Back' => '',
      '10 minutes' => '10 Минути',
      '15 minutes' => '15 Минути',
      'Added User "%s"' => '',
      'AddLink' => 'Добавяне на връзка',
      'Admin-Area' => '',
      'agent' => 'агент',
      'Agent-Area' => '',
      'all' => 'всички',
      'All' => 'Всички',
      'Attention' => 'Внимание',
      'Back' => 'Назад',
      'before' => '',
      'Bug Report' => 'Отчет за грешка',
      'Calendar' => '',
      'Cancel' => 'Отказ',
      'change' => 'променете',
      'Change' => 'Промяна',
      'change!' => 'променете!',
      'click here' => 'натиснете тук',
      'Comment' => 'Коментар',
      'Contract' => '',
      'Crypt' => '',
      'Crypted' => '',
      'Customer' => 'Потребител',
      'customer' => 'потребител',
      'Customer Info' => 'Потребителски данни',
      'day' => 'ден',
      'day(s)' => '',
      'days' => 'дни',
      'description' => 'описание',
      'Description' => 'Описание',
      'Directory' => '',
      'Dispatching by email To: field.' => 'Разпределяне по поле To: от писмото.',
      'Dispatching by selected Queue.' => 'Разпределение по избрана опашка.',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работете с UserID 1 (Системен акаунт)! Създайте нови потребители.',
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
      'History::AddNote' => 'Added note (%s)',
      'History::Bounce' => 'Bounced to "%s".',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Lock' => 'Locked ticket.',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Unlock' => 'Unlocked ticket.',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::SystemRequest' => 'System Request (%s).',
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
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешно оторизиране! Вашето име и/или парола са некоректини!',
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
      'Next' => '',
      'Next...' => '',
      'No' => 'Не',
      'no' => 'не',
      'No entry found!' => 'Няма въдедена стойност!',
      'No Permission!' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'No suggestions' => 'Няма предположения',
      'none' => 'няма',
      'none - answered' => 'няма - отговорен',
      'none!' => 'няма!',
      'Normal' => '',
      'off' => 'изключено',
      'Off' => 'Изключено',
      'On' => 'Включено',
      'on' => 'включено',
      'Online Agent: %s' => '',
      'Online Customer: %s' => '',
      'Password' => 'Парола',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Pending till' => 'В очакване до',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Моля, отговорете на този билет(и) за да се върнете в нормалния изглед на опашката!',
      'Please contact your admin' => 'Моля, свържете се с Вашият администратор',
      'please do not edit!' => 'моля, не редактирайте!',
      'possible' => 'възможен',
      'Preview' => '',
      'QueueView' => 'Преглед на опашката',
      'reject' => 'отхвърлен',
      'replace with' => 'замести с',
      'Reset' => 'Рестартирай',
      'Salutation' => 'Обръщение',
      'Session has timed out. Please log in again.' => 'Моля, оторизирайте се отново. Тази сесия вече е затворена.',
      'Show closed Tickets' => '',
      'Sign' => '',
      'Signature' => 'Подпис',
      'Signed' => '',
      'Size' => '',
      'Sorry' => 'Съжаляваме',
      'Stats' => 'Статистики',
      'Subfunction' => 'Подфункция',
      'submit' => 'изпратете',
      'submit!' => 'изпратете!',
      'system' => 'система',
      'Take this Customer' => '',
      'Take this User' => 'Изберете този потребител',
      'Text' => 'Текст',
      'The recommended charset for your language is %s!' => 'Препоръчителният символен набор за Вашият език е %s',
      'Theme' => 'Тема',
      'There is no account with that login name.' => 'Няма потребител с това име.',
      'Ticket Number' => '',
      'Timeover' => 'Надхвърляне на времето',
      'To: (%s) replaced with database email!' => '',
      'top' => 'към началото',
      'Type' => 'Тип',
      'update' => 'обновяване',
      'Update' => '',
      'update!' => 'обновяване!',
      'Upload' => '',
      'User' => 'Потребител',
      'Username' => 'Потребителско име',
      'Valid' => 'Валиден',
      'Warning' => 'Предупреждение',
      'week(s)' => '',
      'Welcome to OTRS' => 'Добре дошли в OTRS',
      'Word' => 'Дума',
      'wrote' => 'записано',
      'year(s)' => '',
      'Yes' => 'Да',
      'yes' => 'да',
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
      'Closed Tickets' => 'Затворени билети',
      'CreateTicket' => '',
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
      'QueueView refresh time' => 'Време за обновяване изгледът на опашката',
      'Screen after new ticket' => '',
      'Select your default spelling dictionary.' => 'Изберете Вашият речник за проверка на правописът',
      'Select your frontend Charset.' => 'Изберете Вашият символен набор.',
      'Select your frontend language.' => 'Изберете Вашият език.',
      'Select your frontend QueueView.' => 'Изберете език за визуализация съдържанието на опашката.',
      'Select your frontend Theme.' => 'Изберете Вашата потребителска тема',
      'Select your QueueView refresh time.' => 'Изберете Вашето време за обновяване за изгледа на опашката.',
      'Select your screen after creating a new ticket.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Изпратете ми известие, ако клиентът изпрати заявка за следене на отговора и аз съм собственик на билета',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Send me a notification if a ticket is unlocked by the system.' => 'Изпратете ми известие, ако билетът е отключен от системата.',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Show closed tickets.' => 'Покажете затворените билети',
      'Spelling Dictionary' => 'Речик за проверка на правописа',
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
      'closed' => '',
      'closed successful' => 'успешно затворен',
      'closed unsuccessful' => 'неуспешно затворен',
      'Compose' => 'Създаване',
      'Created' => 'Създаден',
      'Createtime' => 'време на създаване',
      'email' => 'е-поща',
      'eMail' => 'е-поща',
      'email-external' => 'външна е-поща',
      'email-internal' => 'вътрешна е-поща',
      'Forward' => 'Препратете',
      'From' => 'От',
      'high' => 'висок',
      'History' => 'Хроника',
      'If it is not displayed correctly,' => 'Ако не се вижда коректно,',
      'lock' => 'заключи',
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
      'This is a HTML email. Click here to show it.' => 'Това е поща в HTML формат. Натиснете тук, за да покажете коректно',
      'This message was written in a character set other than your own.' => 'Това писмо е написано в символна подредба различна от тази, която използвате.',
      'Ticket' => 'Билет',
      'Ticket "%s" created!' => '',
      'To' => 'До',
      'to open it in a new window.' => 'да го отворите в нов прозорец',
      'Unlock' => 'Отключи',
      'unlock' => 'отключи',
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
      'Auto Response From' => 'Автоматичен отговор от',
      'Auto Response Management' => 'Управление на автоматичният отговор',
      'Note' => 'Бележка',
      'Response' => 'Отговор',
      'to get the first 20 character of the subject' => 'за да получите първите 20 символа от поле "относно"',
      'to get the first 5 lines of the email' => 'за да получите първите 5 реда от писмото',
      'to get the from line of the email' => 'за да получите ред от писмото',
      'to get the realname of the sender (if given)' => 'за да получите истинското име на изпращача (ако е попълнено)',
      'to get the ticket id of the ticket' => 'за да получите идентификатора на билета',
      'to get the ticket number of the ticket' => 'за да получите номера на билета',
      'Useable options' => 'Използваеми опции',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Управление на клиент-потребители',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',
      'Result' => '',
      'Search' => '',
      'Search for' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      'The message being composed has been closed.  Exiting.' => 'Съобщението, което създавахте е затворено. Изход.',
      'This values are read only.' => '',
      'This values are required.' => '',
      'This window must be called from compose window' => 'Този прозорец трябва да бъде извикан от прозореца за създаване',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Промяна на %s настройки',
      'Customer User <-> Group Management' => '',
      'Full read and write access to the tickets in this group/queue.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => 'Позволения',
      'Read only access to the ticket in this group/queue.' => '',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => '',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Промяна на потребител <-> Настройки за група',

    # Template: AdminEmail
      'Admin-Email' => 'еМейл от Admin',
      'Body' => 'Тяло на писмото',
      'OTRS-Admin Info!' => 'Информация от OTRS-Admin',
      'Recipents' => 'Получатели',
      'send' => 'изпрати',

    # Template: AdminEmailSent
      'Message sent to' => 'Съобщението е изпратено до',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      '-' => '',
      'Add Note' => 'Добавяне на бележка',
      'Agent' => '',
      'and' => '',
      'CMD' => '',
      'Customer User Login' => '',
      'CustomerID' => 'Потребителски индикатив',
      'CustomerUser' => 'Клиент-потребител',
      'Days' => '',
      'Delete' => '',
      'Delete tickets' => '',
      'Edit' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'GenericAgent' => '',
      'Hours' => '',
      'Job-List' => '',
      'Jobs' => '',
      'Last run' => '',
      'Minutes' => '',
      'Modules' => '',
      'New Agent' => '',
      'New Customer' => '',
      'New Owner' => '',
      'New Priority' => '',
      'New Queue' => 'Следваща опашка',
      'New State' => '',
      'New Ticket Lock' => '',
      'No time settings.' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',
      'Save Job as?' => '',
      'Schedule' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Lock' => '',
      'TicketFreeText' => '',
      'Times' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Направете нови групи за да управлявате позволенията за различните групи от агенти (примерно агент за отдел "продажби", отдел "поддръжка" и т.н.)',
      'Group Management' => 'Управление на групи',
      'It\'s useful for ASP solutions.' => 'Това е подходящо за решения с ASP.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Групата admin достъпва администраторската зона, а stat групата достъпва зоната за статистики.',

    # Template: AdminLog
      'System Log' => 'Системен журнал',
      'Time' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin е-поща',
      'Attachment <-> Response' => 'Прикачен файл<->Отговор',
      'Auto Response <-> Queue' => 'Автоматичен отговор <-> Опашки',
      'Auto Responses' => 'Автоматичен отговор',
      'Customer User' => 'Клиент-потребител',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'е-пощенски адреси',
      'Groups' => 'Групи',
      'Logout' => 'Изход',
      'Misc' => 'Добавки',
      'Notifications' => '',
      'PGP Keys' => '',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => '',
      'Responses' => 'Отговори',
      'Responses <-> Queue' => 'Отговори <-> Опашки',
      'Role' => '',
      'Role <-> Group' => '',
      'Role <-> User' => '',
      'Roles' => '',
      'Select Box' => 'Изберете кутия',
      'Session Management' => 'Управление на сесята',
      'SMIME Certificates' => '',
      'Status' => 'Статус',
      'System' => 'Система',
      'User <-> Groups' => 'Потребител <-> Групи',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => '',
      'File' => '',
      'Fingerprint' => '',
      'FIXME: WHAT IS PGP?' => '',
      'Identifier' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Key' => 'Ключ',
      'PGP Key Management' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Всички входящи писма с един акаунт ще се разпределят в избраната опашка!',
      'Dispatching' => 'Разпределение',
      'Host' => 'Хост',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',
      'POP3 Account Management' => 'Управление на POP3 анаунта',
      'Trusted' => 'Доверен',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'Filtername' => '',
      'Header' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',
      'Match' => '',
      'PostMaster Filter Management' => '',
      'Set' => '',
      'Value' => 'Стойност',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Опашка <-> Управление на автоматичният отговор',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = без ескалация',
      '0 = no unlock' => '0 = без отключване',
      'Customer Move Notify' => 'Известяване при премеместване на потребителя',
      'Customer Owner Notify' => 'Известяване на потребителя',
      'Customer State Notify' => 'Известяване за състоянието на потребителя',
      'Escalation time' => 'Време за ескалация (увеличаване на приоритетът)',
      'Follow up Option' => 'Параметри за автоматично проследяване',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ако билетът е затворен и потребителя изпрати заявка за проследяване, билетът ще бъде заключен за стария потребител',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Ако билетът не получи отговор в определеното време, ще се покаже само този билет',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ако агентът заключи билетът и той(или тя) не изпрати отговор в определеното време, билетър ще се отключи автоматично. Така билетър ще стане видим за всички други агенти',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS изпраща известие по е-поща до клиента, ако билетът е преместен.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS изпраща известие по е-поща до клиента, ако собственика на билета е променен.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS изпраща известие по е-поща до клиента, ако статусът на билетът е променен.',
      'Queue Management' => 'Управление на опашка',
      'Sub-Queue of' => 'Под-опашка на',
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

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Станд.отговори <-> Станд.управление на прикачените файлове',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Отговорът е текст по подразбиране, създанен предварително, с цел по-бърз отговор към клиента',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'Да не забравите да добавите новият отговор към дадена опашка!',
      'Next state' => 'Следващо състояние',
      'Response Management' => 'Управление на отговорът',
      'The current ticket state is' => '',
      'Your email address is new' => '',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',
      'Role Management' => '',

    # Template: AdminRoleGroupChangeForm
      'create' => 'създаване',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'Role <-> Group Management' => '',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => '',

    # Template: AdminRoleUserChangeForm
      'Active' => '',
      'Role <-> User Management' => '',
      'Select the role:user relations.' => '',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => '',

    # Template: AdminSMIMEForm
      'Add Certificate' => '',
      'Add Private Key' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'Secret' => '',
      'SMIME Certificate Management' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'име на потребителя',
      'for agent firstname' => 'за агент име',
      'for agent lastname' => 'за агент фамилия',
      'for agent login' => 'за агент логически вход',
      'for agent user id' => 'за агент потребителски ID',
      'Salutation Management' => 'Управление на обръщението',

    # Template: AdminSelectBoxForm
      'Limit' => 'Лимит',
      'SQL' => 'SQL',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Кутия за избор на резултата',

    # Template: AdminSession
      'kill all sessions' => 'Затваряне на всички текущи сесии',
      'kill session' => 'Затваряне на единична сесия',
      'Overview' => '',
      'Session' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSignatureForm
      'Signature Management' => 'Управление на подписът',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => 'Тип състояние',
      'System State Management' => 'Управление на системно състояние',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Всички входящи адреси от този еМейл (До:) ще се разпределят в избраната опашка.',
      'Email' => 'е-поща',
      'Realname' => 'Истинско име',
      'System Email Addresses Management' => 'Управление на системния еМейл адрес',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Не забравяйте да добавите новият потребител в някаква група!',
      'Firstname' => 'Име',
      'Lastname' => 'Фамилия',
      'User Management' => 'Управление на потребители',
      'User will be needed to handle tickets.' => 'Ще е необходим потребител, за да може билетът да се обработи',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Потребител <-> Управление на група',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Отказвате се от всички промени и се връщате към екрана за създаване',
      'Return to the compose screen' => 'Връщате се към екрана за създаване',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Съобщението трябва да има ДО: т.е. адресант!',
      'Bounce ticket' => 'Отказан билет',
      'Bounce to' => 'Отказ на',
      'Inform sender' => 'Да се информира изпращачът',
      'Next ticket state' => 'Следващо състояние за билетът',
      'Send mail!' => 'Изпратете еМейл!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Трябва да има валиден адрес в полето ДО: (примерно support@hebros.bg)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Писмото Ви с номер "<OTRS_TICKET>" е отхвърлен към "<OTRS_BOUNCE_TO>". Свържете се с този адрес за повече информация',

    # Template: AgentBulk
      '$Text{"Note!' => '',
      'A message should have a subject!' => 'Съобщението трябва да има текст в поле "относно"!',
      'Note type' => 'Бележката е от тип',
      'Note!' => 'Бележка!',
      'Options' => 'Настройки',
      'Spell Check' => 'Проверка на правописа',
      'Ticket Bulk Action' => '',

    # Template: AgentClose
      ' (work units)' => ' (работни единици)',
      'A message should have a body!' => '',
      'Close ticket' => 'Затворете бълетът',
      'Close type' => 'Тип затваряне',
      'Close!' => 'Затворете!',
      'Note Text' => 'Текст на билежката',
      'Time units' => 'Мерни единици за времето',
      'You need to account time!' => 'Вие се нуждаете от отчет за времето',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Съобщението трябва да бъде проверено за грешки!',
      'Attach' => 'Прикачен файл',
      'Compose answer for ticket' => 'Създаване на отговор за този билет',
      'for pending* states' => 'за състояния в очакване* ',
      'Is the ticket answered' => 'Дали билетът е получил отговор',
      'Pending Date' => 'В очакване-дата',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Промяна на потребителят на билета',
      'Search Customer' => 'Търсене на потребител',
      'Set customer user and customer id of a ticket' => 'Задайте потребител и потребителски идентификатор за билета',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'Хроника на потребителят',

    # Template: AgentCustomerMessage
      'Follow up' => 'Заявка за отговор',

    # Template: AgentCustomerView
      'Customer Data' => 'Данни за потребителя',

    # Template: AgentEmailNew
      'All Agents' => '',
      'Clear To' => '',
      'Compose Email' => '',
      'new ticket' => 'нов билет',

    # Template: AgentForward
      'Article type' => 'Клауза тип',
      'Date' => 'Дата',
      'End forwarded message' => 'Край на препратеното съобщение',
      'Forward article of ticket' => 'Препрати клаузата за този билет',
      'Forwarded message from' => 'Препратено съобщение от',
      'Reply-To' => 'Отговор на',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Променете текста на билета',

    # Template: AgentHistoryForm
      'History of' => 'Хроника на',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Информация',

    # Template: AgentLookup
      'Lookup' => '',

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
      'Add a note to this ticket!' => '',
      'Change the ticket customer!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket priority!' => '',
      'Close this ticket!' => '',
      'Shows the detail view of this ticket!' => '',
      'Unlock this ticket!' => '',

    # Template: AgentMove
      'Move Ticket' => 'Преместване на билета',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Agent Preferences' => '',
      'Bulk Action' => '',
      'Bulk Actions on Tickets' => '',
      'Create new Email Ticket' => '',
      'Create new Phone Ticket' => '',
      'Email-Ticket' => '',
      'Locked tickets' => 'Заключени билети',
      'new message' => 'ново съобщение',
      'Overview of all open Tickets' => '',
      'Phone-Ticket' => '',
      'Preferences' => 'Предпочитания',
      'Search Tickets' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

    # Template: AgentNote
      'Add note to ticket' => 'Добавяне на бележка към билета',

    # Template: AgentOwner
      'Change owner of ticket' => 'Промяна собственикън на билета',
      'Message for new Owner' => 'Съобщение за нов собственик',

    # Template: AgentPending
      'Pending date' => 'В очакване - дата',
      'Pending type' => 'В очакване - тип',
      'Set Pending' => 'В очакване - задаване',

    # Template: AgentPhone
      'Phone call' => 'Телефонно обаждане',

    # Template: AgentPhoneNew
      'Clear From' => 'Изчистете формата',

    # Template: AgentPlain
      'ArticleID' => 'Идентификатор на клауза',
      'Download' => '',
      'Plain' => 'Обикновен',
      'TicketID' => 'Идентификатор на билет',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => '',
      'You also get notified about this queues via email if enabled.' => '',
      'Your queue selection of your favorite queues.' => '',

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

    # Template: AgentTicketLink
      'Delete Link' => '',
      'Link' => '',
      'Link to' => '',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Билетът е заключен!',
      'Ticket unlock!' => 'Билетът е отключен!',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Отброено време',
      'Escalation in' => 'Улеличение на приоритета в',

    # Template: AgentUtilSearch
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket Search' => 'Търсене на билет',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Търсене в хрониката на клиента',
      'Customer history search (e. g. "ID342425").' => 'Търсене в хрониката на клиента (примерно "ID342425").',
      'No * possible!' => 'Не е възможно използване на символ *!',

    # Template: AgentUtilSearchResult
      'Change search options' => '',
      'Results' => 'Резултат',
      'Search Result' => '',
      'Total hits' => 'Общ брой попадения',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Всички приключени билети',
      'All open tickets' => 'Всички отворени билети',
      'closed tickets' => 'Затворени билети',
      'open tickets' => 'Отворени билети',
      'or' => 'или',
      'Provides an overview of all' => 'Осигурява общ преглед на всички',
      'So you see what is going on in your system.' => 'Какво става във Вашата система',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Създаване проследяване на билетът',
      'Your own Ticket' => 'Вашият собствен билет',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Създаване на отговор',
      'Contact customer' => 'Контакт с клиента',
      'phone call' => 'телефонно обаждане',

    # Template: AgentZoomArticle
      'Split' => 'Разцепване',

    # Template: AgentZoomBody
      'Change queue' => 'Промяна на опашката',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => '',
      'Free Fields' => 'Свободни полета',
      'Link this ticket to an other one!' => '',
      'Lock it to work on it!' => '',
      'Print' => 'Отпечатване',
      'Print this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Shows the ticket history!' => '',

    # Template: AgentZoomStatus
      '"}","18' => '',
      'Locked' => '',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'отпечатано от',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Създаване на акаунт',
      'Login' => 'Вход',

    # Template: CustomerError
      'Traceback' => 'Проследяване',

    # Template: CustomerFAQArticleHistory
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

    # Template: CustomerLostPassword
      'Lost your password?' => 'Забравена парола',
      'Request new password' => 'Завка за нова парола',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Създаване на нов билет',
      'FAQ' => 'Често задавани въпроси',
      'MyTickets' => '',
      'New Ticket' => 'Нов билет',
      'Welcome %s' => 'Привет %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Натиснете тук, за да изпратите отчет за грешката!',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'A article should have a title!' => '',
      'Comment (internal)' => '',
      'Filename' => '',
      'Title' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => '',
      'Name is required!' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => 'Начало на страницата',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => 'Създаване на база данни',
      'Drop Database' => 'Нулиране базата данни',
      'Finished' => 'Приключено',
      'System Settings' => 'Системни настройки',
      'Web-Installer' => 'Web инсталатор',

    # Template: InstallerFinish
      'Admin-User' => 'Администратор',
      'After doing so your OTRS is up and running.' => 'След извършването на това, Вашият OTRS е напълно работоспособен.',
      'Have a lot of fun!' => 'Приятна работа!',
      'Restart your webserver' => 'Рестарт на web сървърът',
      'Start page' => 'Начална страница',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'За да може да използвате OTRS, Вие трябва да въведете, като супер потребител root в командна линия (Terminal/Shell) следната команда',
      'Your OTRS Team' => 'Вашият OTRS екип',

    # Template: InstallerLicense
      'accept license' => 'Приемате лиценза',
      'don\'t accept license' => 'Не приемате лиценза',
      'License' => 'Лиценз',

    # Template: InstallerStart
      'Create new database' => 'Създаване на нова база данни',
      'DB Admin Password' => 'Парола на администратора на базата',
      'DB Admin User' => 'Потребител на базата данни',
      'DB Host' => 'Хост на базата данни',
      'DB Type' => 'Тип на базата данни',
      'default \'hot\'' => 'по подразбиране',
      'Delete old database' => 'Изтриване на стара база данни',
      'next step' => 'следваща стъпка',
      'OTRS DB connect host' => 'Хост свързан към OTRS база данни',
      'OTRS DB Name' => 'Име свързано към OTRS база данни',
      'OTRS DB Password' => 'Парола на OTRS база данни',
      'OTRS DB User' => 'Потребител на OTRS база данни',
      'your MySQL DB should have a root password! Default is empty!' => 'Вашата MYSQL база данни трябва да има парола за root потребителя. По подразбиране е празна!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Проверете MX записите на адреса на писмата-отговори. Не използвайте CheckMXRecord, ако вашата OTRS машина е на комутируема линия! ',
      '(Email of the system admin)' => '(еМейл на системният администратор)',
      '(Full qualified domain name of your system)' => '(Пълно квалифицирано име (FQDN) на системата)',
      '(Logfile just needed for File-LogModule!)' => '(Журналният файл е необходим само за File-LogModule)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Идентифициране на системата. Всики номер на билет и всяка http сесия започва с този номер)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Идентификатор на билета. Примерно: \'Ticket#\', \'Call#\' or \'MyTicket#\')',
      '(Used default language)' => '(Изполван език по подразбиране)',
      '(Used log backend)' => '(Използван журнален изход)',
      '(Used ticket number format)' => '(Използван формат за номера на билетът)',
      'CheckMXRecord' => 'CheckMXRecord (Проверка MX запис)',
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

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Нямате позволение',

    # Template: Notify

    # Template: PrintFooter
      'URL' => 'Адрес',

    # Template: QueueView
      'All tickets' => 'Всички билети',
      'Page' => '',
      'Queues' => 'Опашки',
      'Tickets available' => 'Налични билети',
      'Tickets shown' => 'Показани билети',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'Тестова страница на OTRS',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ескалация (увеличаване на приоритета) на билета!',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Начало',

    # Template: customer-css
      'Contact' => 'Контакт',
      'Online-Support' => 'На линия-поддръжка',
      'Products' => 'Продукти',
      'Support' => 'Поддръжка',

    # Misc
      '"}","15' => '',
      '"}","30' => '',
      '(Ticket identifier. Some people want to set this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Идентификатор на билетът. Някои хора желаят да зададат стойности, като \'Ticket#\', \'Call#\' или \'MyTicket#\')',
      'A message should have a From: recipient!' => 'Съобщението трябва да има попълнено поле ОТ:',
      'Add auto response' => 'Добавяне на автоматичен отговор',
      'Add user' => 'Добавяне на потребител',
      'AdminArea' => 'Зона-Администратор',
      'AgentFrontend' => 'Зона-потребител',
      'Article free text' => 'Клауза свободен текст',
      'BLZ' => '',
      'Backend' => 'Фонов',
      'BackendMessage' => 'Фоново съобщение',
      'Bank-Stammdaten' => '',
      'Change Response <-> Attachment settings' => 'Промяна на отговорътт <-> Настройки прикачени файлове',
      'Change answer <-> queue settings' => 'Промяна на отговорът <-> Настройки на опашката',
      'Change auto response settings' => 'Промяна на настройките за автоматичният отговор',
      'Charset' => 'Символен набор',
      'Charsets' => 'Символен набор',
      'Content Adresses' => '',
      'Create' => 'Създаване',
      'Customer called' => 'Извършено е тел.обаждане до потребителят',
      'Customer user will be needed to to login via customer panels.' => 'Ще Ви е необходим предварително създаден потребител за достъп до потребителския панел',
      'Declaration' => '',
      'Events' => '',
      'Fulltext search' => 'Текстово търсене',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Текстово търсене (примерно "Mar*in" или "Baue*" или "martin+hallo")',
      'Graphs' => 'Графики',
      'Handle' => 'Манипулатор',
      'Identifer' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Ако Вашият акаунт е доверен, ще се използва хедър x-otrs (за приоритетност, и т.н.)!',
      'Institut' => '',
      'Lock Ticket' => '',
      'Max Rows' => 'Максимален брой редове',
      'My Tickets' => 'Моите билети',
      'New state' => 'Ново състояние',
      'New ticket via call.' => 'Нов билет чрез обаждане',
      'New user' => 'Нов потребител',
      'POP3 Account' => 'POP3 акаунт',
      'Pending!' => 'В очакване',
      'Phone call at %s' => 'Телефонно обаждане в %s',
      'Please go away!' => '',
      'Search in' => 'Търсене в',
      'Select source:' => '',
      'Select your custom queues' => 'Изберете Вашата потребителска опашка',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Изпратете ми известие, ако билетът е преместен в някаква потребителска опашка.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Изпратете ми известие, ако има нов(и) билет в моята потребителска опашка.',
      'SessionID' => 'Идентификатор на сесия',
      'Set customer id of a ticket' => 'Задаване на потребителски индикатив на билета',
      'Short Description' => '',
      'Show all' => 'Показване на всички',
      'Specification' => '',
      'Status defs' => 'Дефиниции на състояния',
      'Teil#' => '',
      'Ticket free text' => 'Билет свободен текст',
      'Ticket limit:' => 'Ограничение по време:',
      'Ticket-Overview' => 'Билети-преглед',
      'Ticketview' => '',
      'Time till escalation' => 'Време до ескалация',
      'Utilities' => 'Помощни средства',
      'With State' => 'Със състояние',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Трябва да имате еМейл адрес (примерно customer@example.com) в поле ОТ:',
      'You need min. one selected Ticket.!' => '',
      'ZentralBank' => '',
      'ZentralBank#' => '',
      'auto responses set' => 'набор автоматични отговори',
      'by' => 'от',
      'search' => 'търсене',
      'search (e. g. 10*5155 or 105658*)' => 'търсене (примерно 10*5155 или 105658*)',
      'store' => 'съхранение',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;

}
# --
1;
