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
$VERSION = '$Revision: 1.47 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Oct  5 06:03:42 2006

    # possible charsets
    $Self->{Charset} = ['cp1251', 'Windows-1251', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateFormatShort} = '%D.%M.%Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Да',
      'No' => 'Не',
      'yes' => 'да',
      'no' => 'не',
      'Off' => 'Изключено',
      'off' => 'изключено',
      'On' => 'Включено',
      'on' => 'включено',
      'top' => 'към началото',
      'end' => 'Край',
      'Done' => 'Готово.',
      'Cancel' => 'Отказ',
      'Reset' => 'Рестартирай',
      'last' => '',
      'before' => '',
      'day' => 'ден',
      'days' => 'дни',
      'day(s)' => '',
      'hour' => 'час',
      'hours' => 'часове',
      'hour(s)' => '',
      'minute' => 'минута',
      'minutes' => 'минути',
      'minute(s)' => '',
      'month' => '',
      'months' => '',
      'month(s)' => '',
      'week' => '',
      'week(s)' => '',
      'year' => '',
      'years' => '',
      'year(s)' => '',
      'second(s)' => '',
      'seconds' => '',
      'second' => '',
      'wrote' => 'записано',
      'Message' => 'Съобщение',
      'Error' => 'Грешка',
      'Bug Report' => 'Отчет за грешка',
      'Attention' => 'Внимание',
      'Warning' => 'Предупреждение',
      'Module' => 'Модул',
      'Modulefile' => 'Файл-модул',
      'Subfunction' => 'Подфункция',
      'Line' => 'Линия',
      'Example' => 'Пример',
      'Examples' => 'Примери',
      'valid' => '',
      'invalid' => 'невалиден',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 Минути',
      ' 5 minutes' => ' 5 Минути',
      ' 7 minutes' => ' 7 Минути',
      '10 minutes' => '10 Минути',
      '15 minutes' => '15 Минути',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => '',
      'Back' => 'Назад',
      'Next...' => '',
      '...Back' => '',
      '-none-' => '',
      'none' => 'няма',
      'none!' => 'няма!',
      'none - answered' => 'няма - отговорен',
      'please do not edit!' => 'моля, не редактирайте!',
      'AddLink' => 'Добавяне на връзка',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => '',
      'Parent' => '',
      'Child' => '',
      'Hit' => 'Попадение',
      'Hits' => 'Попадения',
      'Text' => 'Текст',
      'Lite' => 'Лека',
      'User' => 'Потребител',
      'Username' => 'Потребителско име',
      'Language' => 'Език',
      'Languages' => 'Езици',
      'Password' => 'Парола',
      'Salutation' => 'Обръщение',
      'Signature' => 'Подпис',
      'Customer' => 'Потребител',
      'CustomerID' => 'Потребителски индикатив',
      'CustomerIDs' => '',
      'customer' => 'потребител',
      'agent' => 'агент',
      'system' => 'система',
      'Customer Info' => 'Потребителски данни',
      'go!' => 'ОК!',
      'go' => 'ОК',
      'All' => 'Всички',
      'all' => 'всички',
      'Sorry' => 'Съжаляваме',
      'update!' => 'обновяване!',
      'update' => 'обновяване',
      'Update' => '',
      'submit!' => 'изпратете!',
      'submit' => 'изпратете',
      'Submit' => '',
      'change!' => 'променете!',
      'Change' => 'Промяна',
      'change' => 'променете',
      'click here' => 'натиснете тук',
      'Comment' => 'Коментар',
      'Valid' => 'Валиден',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => 'Име',
      'Group' => 'Група',
      'Description' => 'Описание',
      'description' => 'описание',
      'Theme' => 'Тема',
      'Created' => 'Създаден',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => '',
      'and' => '',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => 'Настройки',
      'Title' => '',
      'Item' => '',
      'Delete' => '',
      'Edit' => '',
      'View' => 'Изглед',
      'Number' => '',
      'System' => 'Система',
      'Contact' => 'Контакт',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => '',
      'Category' => '',
      'Viewer' => '',
      'New message' => 'Ново съобщение',
      'New message!' => 'Ново съобщение!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Моля, отговорете на този билет(и) за да се върнете в нормалния изглед на опашката!',
      'You got new message!' => 'Получихте ново съобщение!',
      'You have %s new message(s)!' => 'Вие имате %s ново/нови съобщение/съобщения!',
      'You have %s reminder ticket(s)!' => 'Вие имате %s оставащ/оставащи билет/билети!',
      'The recommended charset for your language is %s!' => 'Препоръчителният символен набор за Вашият език е %s',
      'Passwords doesn\'t match! Please try it again!' => '',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Няма предположения',
      'Word' => 'Дума',
      'Ignore' => 'Пренебрегване',
      'replace with' => 'замести с',
      'Welcome to OTRS' => '',
      'There is no account with that login name.' => 'Няма потребител с това име.',
      'Login failed! Your username or password was entered incorrectly.' => 'Неуспешно оторизиране! Вашето име и/или парола са некоректини!',
      'Please contact your admin' => 'Моля, свържете се с Вашият администратор',
      'Logout successful. Thank you for using OTRS!' => 'Изходът е успешен. Благодарим Ви, че използвахте системата.',
      'Invalid SessionID!' => 'Невалиден SessionID!',
      'Feature not active!' => 'Функцията не е активна',
      'License' => 'Лиценз',
      'Take this Customer' => '',
      'Take this User' => 'Изберете този потребител',
      'possible' => 'възможен',
      'reject' => 'отхвърлен',
      'reverse' => '',
      'Facility' => 'Приспособление',
      'Timeover' => 'Надхвърляне на времето',
      'Pending till' => 'В очакване до',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Не работете с UserID 1 (Системен акаунт)! Създайте нови потребители.',
      'Dispatching by email To: field.' => 'Разпределяне по поле To: от писмото.',
      'Dispatching by selected Queue.' => 'Разпределение по избрана опашка.',
      'No entry found!' => 'Няма въдедена стойност!',
      'Session has timed out. Please log in again.' => 'Моля, оторизирайте се отново. Тази сесия вече е затворена.',
      'No Permission!' => '',
      'To: (%s) replaced with database email!' => '',
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '',
      'Preview' => '',
      'Package not correctly deployed! You should reinstall the Package again!' => '',
      'Added User "%s"' => '',
      'Contract' => '',
      'Online Customer: %s' => '',
      'Online Agent: %s' => '',
      'Calendar' => '',
      'File' => '',
      'Filename' => '',
      'Type' => 'Тип',
      'Size' => '',
      'Upload' => '',
      'Directory' => '',
      'Signed' => '',
      'Sign' => '',
      'Crypted' => '',
      'Crypt' => '',
      'Office' => '',
      'Phone' => '',
      'Fax' => '',
      'Mobile' => '',
      'Zip' => '',
      'City' => '',
      'Country' => '',
      'installed' => '',
      'uninstalled' => '',
      'printed at' => '',

      # Template: AAAMonth
      'Jan' => 'Яну',
      'Feb' => 'Фев',
      'Mar' => 'Мар',
      'Apr' => 'Апр',
      'May' => 'Май',
      'Jun' => 'Юни',
      'Jul' => 'Юли',
      'Aug' => 'Авг',
      'Sep' => 'Сеп',
      'Oct' => 'Окт',
      'Nov' => 'Ное',
      'Dec' => 'Дек',
      'January' => '',
      'February' => '',
      'March' => '',
      'April' => '',
      'June' => '',
      'July' => '',
      'August' => '',
      'September' => '',
      'October' => '',
      'November' => '',
      'December' => '',

      # Template: AAANavBar
      'Admin-Area' => '',
      'Agent-Area' => '',
      'Ticket-Area' => '',
      'Logout' => 'Изход',
      'Agent Preferences' => '',
      'Preferences' => 'Предпочитания',
      'Agent Mailbox' => '',
      'Stats' => 'Статистики',
      'Stats-Area' => '',
      'Admin' => '',
      'A web calendar' => '',
      'WebMail' => '',
      'A web mail client' => '',
      'FileManager' => '',
      'A web file manager' => '',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',
      'Customer Users' => '',
      'Customer Users <-> Groups' => '',
      'Users <-> Groups' => '',
      'Roles' => '',
      'Roles <-> Users' => '',
      'Roles <-> Groups' => '',
      'Salutations' => '',
      'Signatures' => '',
      'Email Addresses' => '',
      'Notifications' => '',
      'Category Tree' => '',
      'Admin Notification' => '',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Предпочитанията са обновени успешно',
      'Mail Management' => 'Управление на пощата',
      'Frontend' => 'Зона-потребител',
      'Other Options' => 'Други настройки',
      'Change Password' => '',
      'New password' => '',
      'New password again' => '',
      'Select your QueueView refresh time.' => 'Изберете Вашето време за обновяване за изгледа на опашката.',
      'Select your frontend language.' => 'Изберете Вашият език.',
      'Select your frontend Charset.' => 'Изберете Вашият символен набор.',
      'Select your frontend Theme.' => 'Изберете Вашата потребителска тема',
      'Select your frontend QueueView.' => 'Изберете език за визуализация съдържанието на опашката.',
      'Spelling Dictionary' => 'Речик за проверка на правописа',
      'Select your default spelling dictionary.' => 'Изберете Вашият речник за проверка на правописът',
      'Max. shown Tickets a page in Overview.' => '',
      'Can\'t update password, passwords doesn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

      # Template: AAAStats
      'Stat' => '',
      'Please fill out the required fields!' => '',
      'Please select a file!' => '',
      'Please select an object!' => '',
      'Please select a graph size!' => '',
      'Please select one element for the X-axis!' => '',
      'You have to select two or more attributes from the select field!' => '',
      'Please select only one element or turn of the button \'Fixed\' where the select field is marked!' => '',
      'If you use a checkbox you have to select some attributes of the select field!' => '',
      'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
      'The selected end time is before the start time!' => '',
      'You have to select one or more attributes from the select field!' => '',
      'The selected Date isn\'t valid!' => '',
      'Please select only one or two elements via the checkbox!' => '',
      'If you use a time scale element you can only select one element!' => '',
      'You have an error in your time selection!' => '',
      'Your reporting time interval is to small, please use a larger time scale!' => '',
      'The selected start time is before the allowed start time!' => '',
      'The selected end time is after the allowed end time!' => '',
      'The selected time period is larger than the allowed time period!' => '',
      'Common Specification' => '',
      'Xaxis' => '',
      'Value Series' => '',
      'Restrictions' => '',
      'graph-lines' => '',
      'graph-bars' => '',
      'graph-hbars' => '',
      'graph-points' => '',
      'graph-lines-points' => '',
      'graph-area' => '',
      'graph-pie' => '',
      'extended' => '',
      'Agent/Owner' => '',
      'Created by Agent/Owner' => '',
      'Created Priority' => '',
      'Created State' => '',
      'Create Time' => '',
      'CustomerUserLogin' => '',
      'Close Time' => '',

      # Template: AAATicket
      'Lock' => 'Заключи',
      'Unlock' => 'Отключи',
      'History' => 'Хроника',
      'Zoom' => 'Подробно',
      'Age' => 'Възраст',
      'Bounce' => 'Отхвърли',
      'Forward' => 'Препратете',
      'From' => 'От',
      'To' => 'До',
      'Cc' => 'Копие до',
      'Bcc' => 'Скрито копие',
      'Subject' => 'Относно',
      'Move' => 'Преместване',
      'Queue' => 'Опашка',
      'Priority' => 'Приоритет',
      'State' => 'Статус',
      'Compose' => 'Създаване',
      'Pending' => 'В очакване',
      'Owner' => 'Собственик',
      'Owner Update' => '',
      'Responsible' => '',
      'Responsible Update' => '',
      'Sender' => 'Изпращач',
      'Article' => 'Клауза',
      'Ticket' => 'Билет',
      'Createtime' => 'време на създаване',
      'plain' => 'обикновен',
      'Email' => 'е-поща',
      'email' => 'е-поща',
      'Close' => 'Затваряне',
      'Action' => 'Действие',
      'Attachment' => 'Прикачен файл',
      'Attachments' => 'Прикачени файлове',
      'This message was written in a character set other than your own.' => 'Това писмо е написано в символна подредба различна от тази, която използвате.',
      'If it is not displayed correctly,' => 'Ако не се вижда коректно,',
      'This is a' => 'Това е',
      'to open it in a new window.' => 'да го отворите в нов прозорец',
      'This is a HTML email. Click here to show it.' => 'Това е поща в HTML формат. Натиснете тук, за да покажете коректно',
      'Free Fields' => '',
      'Merge' => '',
      'closed successful' => 'успешно затворен',
      'closed unsuccessful' => 'неуспешно затворен',
      'new' => 'нов',
      'open' => 'отворен',
      'closed' => '',
      'removed' => 'премахнат',
      'pending reminder' => 'очаква напомняне',
      'pending auto close+' => 'очаква автоматично затваряне+',
      'pending auto close-' => 'очаква автоматично затваряне-',
      'email-external' => 'външна е-поща',
      'email-internal' => 'вътрешна е-поща',
      'note-external' => 'външна бележка',
      'note-internal' => 'вътрешна бележка',
      'note-report' => 'бележка отчет',
      'phone' => 'телефон',
      'sms' => '',
      'webrequest' => 'заявка по web',
      'lock' => 'заключи',
      'unlock' => 'отключи',
      'very low' => 'много нисък',
      'low' => 'нисък',
      'normal' => 'нормален',
      'high' => 'висок',
      'very high' => 'много висок',
      '1 very low' => '1 много нисък',
      '2 low' => '2 нисък',
      '3 normal' => '3 нормален',
      '4 high' => '4 висок',
      '5 very high' => '5 много висок',
      'Ticket "%s" created!' => '',
      'Ticket Number' => '',
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'Don\'t show closed Tickets' => '',
      'Show closed Tickets' => '',
      'Email-Ticket' => '',
      'Create new Email Ticket' => '',
      'Phone-Ticket' => '',
      'Create new Phone Ticket' => '',
      'Search Tickets' => '',
      'Edit Customer Users' => '',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => '',
      'Overview of all open Tickets' => '',
      'Locked Tickets' => '',
      'Lock it to work on it!' => '',
      'Unlock to give it back to the queue!' => '',
      'Shows the ticket history!' => '',
      'Print this ticket!' => '',
      'Change the ticket priority!' => '',
      'Change the ticket free fields!' => '',
      'Link this ticket to an other objects!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket customer!' => '',
      'Add a note to this ticket!' => '',
      'Merge this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Close this ticket!' => '',
      'Look into a ticket!' => '',
      'Delete this ticket!' => '',
      'Mark as Spam!' => '',
      'My Queues' => '',
      'Shown Tickets' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',
      'New ticket notification' => 'Напомняне за нов билет',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Follow up notification' => 'Известие за наличност на следене на отговорът',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Изпратете ми известие, ако клиентът изпрати заявка за следене на отговора и аз съм собственик на билета',
      'Ticket lock timeout notification' => 'Известие за продължителността на заключване на билетът',
      'Send me a notification if a ticket is unlocked by the system.' => 'Изпратете ми известие, ако билетът е отключен от системата.',
      'Move notification' => 'Известие за преместване',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '',
      'Custom Queue' => 'Потребителска опашка',
      'QueueView refresh time' => 'Време за обновяване изгледът на опашката',
      'Screen after new ticket' => '',
      'Select your screen after creating a new ticket.' => '',
      'Closed Tickets' => 'Затворени билети',
      'Show closed tickets.' => 'Покажете затворените билети',
      'Max. shown Tickets a page in QueueView.' => '',
      'CompanyTickets' => '',
      'MyTickets' => '',
      'New Ticket' => '',
      'Create new Ticket' => '',
      'Customer called' => '',
      'phone call' => '',
      'Responses' => 'Отговори',
      'Responses <-> Queue' => '',
      'Auto Responses' => '',
      'Auto Responses <-> Queue' => '',
      'Attachments <-> Responses' => '',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Bounce' => 'Bounced to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::AddNote' => 'Added note (%s)',
      'History::Lock' => 'Locked ticket.',
      'History::Unlock' => 'Unlocked ticket.',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Remove' => '%s',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',

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
      'Response' => 'Отговор',
      'Auto Response From' => 'Автоматичен отговор от',
      'Note' => 'Бележка',
      'Useable options' => 'Използваеми опции',
      'to get the first 20 character of the subject' => 'за да получите първите 20 символа от поле "относно"',
      'to get the first 5 lines of the email' => 'за да получите първите 5 реда от писмото',
      'to get the from line of the email' => 'за да получите ред от писмото',
      'to get the realname of the sender (if given)' => 'за да получите истинското име на изпращача (ако е попълнено)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Съобщението, което създавахте е затворено. Изход.',
      'This window must be called from compose window' => 'Този прозорец трябва да бъде извикан от прозореца за създаване',
      'Customer User Management' => 'Управление на клиент-потребители',
      'Search for' => '',
      'Result' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      'This values are read only.' => '',
      'This values are required.' => '',
      'Customer user will be needed to have a customer history and to login via customer panel.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => '',
      'Change %s settings' => 'Промяна на %s настройки',
      'Select the user:group permissions.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => 'Позволения',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => '',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => '',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Съобщението е изпратено до',
      'Recipents' => 'Получатели',
      'Body' => 'Тяло на писмото',
      'send' => 'изпрати',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      'Customer User Login' => '',
      '(e. g. U5150)' => '',
      'Agent' => '',
      'Ticket Lock' => '',
      'TicketFreeFields' => '',
      'Times' => '',
      'No time settings.' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'New Priority' => '',
      'New Queue' => 'Следваща опашка',
      'New State' => '',
      'New Agent' => '',
      'New Owner' => '',
      'New Customer' => '',
      'New Ticket Lock' => '',
      'CustomerUser' => 'Клиент-потребител',
      'New TicketFreeFields' => '',
      'Add Note' => 'Добавяне на бележка',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
      'Send Notification' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Send no notifications' => '',
      'Yes means, send no agent and customer notifications on changes.' => '',
      'No means, send agent and customer notifications on changes.' => '',
      'Save' => '',
      '%s Tickets affected! Do you really want to use this job?' => '',

      # Template: AdminGroupForm
      'Group Management' => 'Управление на групи',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Групата admin достъпва администраторската зона, а stat групата достъпва зоната за статистики.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Направете нови групи за да управлявате позволенията за различните групи от агенти (примерно агент за отдел "продажби", отдел "поддръжка" и т.н.)',
      'It\'s useful for ASP solutions.' => 'Това е подходящо за решения с ASP.',

      # Template: AdminLog
      'System Log' => 'Системен журнал',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => 'Групи',
      'Misc' => 'Добавки',

      # Template: AdminNotificationForm
      'Notification Management' => '',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminPackageManager
      'Package Manager' => '',
      'Uninstall' => '',
      'Version' => '',
      'Do you really want to uninstall this package?' => '',
      'Reinstall' => '',
      'Do you really want to reinstall this package (all manual changes get lost)?' => '',
      'Install' => '',
      'Package' => '',
      'Online Repository' => '',
      'Vendor' => '',
      'Upgrade' => '',
      'Local Repository' => '',
      'Status' => 'Статус',
      'Package not correctly deployed, you need to deploy it again!' => '',
      'Overview' => '',
      'Download' => '',
      'Rebuild' => '',
      'Download file from package!' => '',
      'Required' => '',
      'PrimaryKey' => '',
      'AutoIncrement' => '',
      'SQL' => '',
      'Diff' => '',

      # Template: AdminPerformanceLog
      'Performance Log' => '',
      'Logfile too large!' => '',
      'Logfile too large, you need to reset it!' => '',
      'Range' => '',
      'Interface' => '',
      'Requests' => '',
      'Min Response' => '',
      'Max Response' => '',
      'Average Response' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => 'Ключ',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3
      'POP3 Account Management' => 'Управление на POP3 анаунта',
      'Host' => 'Хост',
      'List' => '',
      'Trusted' => 'Доверен',
      'Dispatching' => 'Разпределение',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Всички входящи писма с един акаунт ще се разпределят в избраната опашка!',
      'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => '',
      'Match' => '',
      'Header' => '',
      'Value' => 'Стойност',
      'Set' => '',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => '',

      # Template: AdminQueueForm
      'Queue Management' => 'Управление на опашка',
      'Sub-Queue of' => 'Под-опашка на',
      'Unlock timeout' => 'Време за отключване',
      '0 = no unlock' => '0 = без отключване',
      'Escalation time' => 'Време за ескалация (увеличаване на приоритетът)',
      '0 = no escalation' => '0 = без ескалация',
      'Follow up Option' => 'Параметри за автоматично проследяване',
      'Ticket lock after a follow up' => 'Заключване на билетът след автоматично известяване',
      'Systemaddress' => 'Системен адрес',
      'Customer Move Notify' => 'Известяване при премеместване на потребителя',
      'Customer State Notify' => 'Известяване за състоянието на потребителя',
      'Customer Owner Notify' => 'Известяване на потребителя',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ако агентът заключи билетът и той(или тя) не изпрати отговор в определеното време, билетър ще се отключи автоматично. Така билетър ще стане видим за всички други агенти',
      'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Ако билетът не получи отговор в определеното време, ще се покаже само този билет',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ако билетът е затворен и потребителя изпрати заявка за проследяване, билетът ще бъде заключен за стария потребител',
      'Will be the sender address of this queue for email answers.' => 'Ще бъде адресът на изпраща за тази опашка при еМейл отговорите',
      'The salutation for email answers.' => 'Обръщението за отговорите по еМейл',
      'The signature for email answers.' => 'Подписът за отговорите по еМейл',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS изпраща известие по е-поща до клиента, ако билетът е преместен.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS изпраща известие по е-поща до клиента, ако статусът на билетът е променен.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS изпраща известие по е-поща до клиента, ако собственика на билета е променен.',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => '',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Отговор',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => '',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Управление на отговорът',
      'A response is default text to write faster answer (with default text) to customers.' => 'Отговорът е текст по подразбиране, създанен предварително, с цел по-бърз отговор към клиента',
      'Don\'t forget to add a new response a queue!' => 'Да не забравите да добавите новият отговор към дадена опашка!',
      'Next state' => 'Следващо състояние',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => '',
      'Your email address is new' => '',

      # Template: AdminRoleForm
      'Role Management' => '',
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => '',
      'move_into' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'create' => 'създаване',
      'Permissions to create tickets in this group/queue.' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'priority' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',

      # Template: AdminRoleGroupForm
      'Role' => '',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Управление на обръщението',
      'customer realname' => 'име на потребителя',
      'All Agent variables.' => '',
      'for agent firstname' => 'за агент име',
      'for agent lastname' => 'за агент фамилия',
      'for agent user id' => 'за агент потребителски ID',
      'for agent login' => 'за агент логически вход',

      # Template: AdminSelectBoxForm
      'Select Box' => 'Изберете кутия',
      'Limit' => 'Лимит',
      'Select Box Result' => 'Кутия за избор на резултата',

      # Template: AdminSession
      'Session Management' => 'Управление на сесята',
      'Sessions' => '',
      'Uniq' => '',
      'kill all sessions' => 'Затваряне на всички текущи сесии',
      'Session' => '',
      'Content' => '',
      'kill session' => 'Затваряне на единична сесия',

      # Template: AdminSignatureForm
      'Signature Management' => 'Управление на подписът',

      # Template: AdminSMIMEForm
      'S/MIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Управление на системно състояние',
      'State Type' => 'Тип състояние',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',
      'See also' => '',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => '',
      'Show' => '',
      'Download Settings' => '',
      'Download all system config changes.' => '',
      'Load Settings' => '',
      'Subgroup' => '',
      'Elements' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Default' => '',
      'New' => 'Нови',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'NavBar' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Управление на системния еМейл адрес',
      'Realname' => 'Истинско име',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Всички входящи адреси от този еМейл (До:) ще се разпределят в избраната опашка.',

      # Template: AdminUserForm
      'User Management' => 'Управление на потребители',
      'Login as' => '',
      'Firstname' => 'Име',
      'Lastname' => 'Фамилия',
      'User will be needed to handle tickets.' => 'Ще е необходим потребител, за да може билетът да се обработи',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => '',
      'Return to the compose screen' => 'Връщате се към екрана за създаване',
      'Discard all changes and return to the compose screen' => 'Отказвате се от всички промени и се връщате към екрана за създаване',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => 'Информация',

      # Template: AgentLinkObject
      'Link Object' => '',
      'Select' => '',
      'Results' => 'Резултат',
      'Total hits' => 'Общ брой попадения',
      'Page' => '',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Проверка на правописът',
      'spelling error(s)' => 'Правописна грешка(грешки)',
      'or' => 'или',
      'Apply these changes' => 'Прилага се към тези промени',

      # Template: AgentStatsDelete
      'Do you really want to delete this Object?' => '',

      # Template: AgentStatsEditRestrictions
      'Select the restrictions to characterise the stat' => '',
      'Fixed' => '',
      'Please select only one Element or turn of the button \'Fixed\'.' => '',
      'Absolut Period' => '',
      'Between' => '',
      'Relative Period' => '',
      'The last' => '',
      'Finish' => '',
      'Here you can make restrictions to your stat.' => '',
      'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributs of the corresponding element.' => '',

      # Template: AgentStatsEditSpecification
      'Insert of the common specifications' => '',
      'Permissions' => '',
      'Format' => '',
      'Graphsize' => '',
      'Sum rows' => '',
      'Sum columns' => '',
      'Cache' => '',
      'Required Field' => '',
      'Selection needed' => '',
      'Explanation' => '',
      'In this form you can select the basic specifications.' => '',
      'Attribute' => '',
      'Title of the stat.' => '',
      'Here you can insert a description of the stat.' => '',
      'Dynamic-Object' => '',
      'Here you can select the dynamic object you want to use.' => '',
      '(Note: It depends on your installation how many dynamic objects you can use)' => '',
      'Static-File' => '',
      'For very complex stats it is possible to include a hardcoded file.' => '',
      'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
      'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
      'Multiple selection of the output format.' => '',
      'If you use a graph as output format you have to select at least one graph size.' => '',
      'If you need the sum of every row select yes' => '',
      'If you need the sum of every column select yes.' => '',
      'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
      '(Note: Useful for big databases and low performance server)' => '',
      'With an invalid stat it isn\'t feasible to generate a stat.' => '',
      'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

      # Template: AgentStatsEditValueSeries
      'Select the elements for the value series' => '',
      'Scale' => '',
      'minimal' => '',
      'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
      'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

      # Template: AgentStatsEditXaxis
      'Select the element, which will be used at the X-axis' => '',
      'maximal period' => '',
      'minimal scale' => '',
      'Here you can define the x-axis. You can select one element via the radio button. Than you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

      # Template: AgentStatsImport
      'Import' => '',
      'File is not a Stats config' => '',
      'No File selected' => '',

      # Template: AgentStatsOverview
      'Object' => '',

      # Template: AgentStatsPrint
      'Print' => 'Отпечатване',
      'No Element selected.' => '',

      # Template: AgentStatsView
      'Export Config' => '',
      'Informations about the Stat' => '',
      'Exchange Axis' => '',
      'Configurable params of static stat' => '',
      'No element selected.' => '',
      'maximal period form' => '',
      'to' => '',
      'Start' => '',
      'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Съобщението трябва да има ДО: т.е. адресант!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Трябва да има валиден адрес в полето ДО: (примерно support@hebros.bg)!',
      'Bounce ticket' => 'Отказан билет',
      'Bounce to' => 'Отказ на',
      'Next ticket state' => 'Следващо състояние за билетът',
      'Inform sender' => 'Да се информира изпращачът',
      'Send mail!' => 'Изпратете еМейл!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Съобщението трябва да има текст в поле "относно"!',
      'Ticket Bulk Action' => '',
      'Spell Check' => 'Проверка на правописа',
      'Note type' => 'Бележката е от тип',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => '',
      'You need to account time!' => 'Вие се нуждаете от отчет за времето',
      'Close ticket' => 'Затворете бълетът',
      'Ticket locked!' => 'Билетът е заключен!',
      'Ticket unlock!' => 'Билетът е отключен!',
      'Previous Owner' => '',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',
      'Attach' => 'Прикачен файл',
      'Pending date' => 'В очакване - дата',
      'Time units' => 'Мерни единици за времето',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Съобщението трябва да бъде проверено за грешки!',
      'Compose answer for ticket' => 'Създаване на отговор за този билет',
      'Pending Date' => 'В очакване-дата',
      'for pending* states' => 'за състояния в очакване* ',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Промяна на потребителят на билета',
      'Set customer user and customer id of a ticket' => 'Задайте потребител и потребителски идентификатор за билета',
      'Customer User' => 'Клиент-потребител',
      'Search Customer' => 'Търсене на потребител',
      'Customer Data' => 'Данни за потребителя',
      'Customer history' => 'Хроника на потребителят',
      'All customer tickets.' => '',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Заявка за отговор',

      # Template: AgentTicketEmail
      'Compose Email' => '',
      'new ticket' => 'нов билет',
      'Refresh' => '',
      'Clear To' => '',
      'All Agents' => '',

      # Template: AgentTicketForward
      'Article type' => 'Клауза тип',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Променете текста на билета',

      # Template: AgentTicketHistory
      'History of' => 'Хроника на',

      # Template: AgentTicketLocked

      # Template: AgentTicketMailbox
      'Mailbox' => 'Пощенска кутия',
      'Tickets' => 'Билети',
      'of' => 'на',
      'Filter' => '',
      'All messages' => 'Всички съобщения',
      'New messages' => 'Нови съобщения',
      'Pending messages' => 'Съобщения в очакване',
      'Reminder messages' => 'Напомнящи съобщения',
      'Reminder' => 'Напомняне',
      'Sort by' => 'Сортиране по',
      'Order' => 'Ред',
      'up' => 'нагоре',
      'down' => 'надолу',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',

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
      'Create' => '',

      # Template: AgentTicketPhoneOutbound

      # Template: AgentTicketPlain
      'Plain' => 'Обикновен',
      'TicketID' => 'Идентификатор на билет',
      'ArticleID' => 'Идентификатор на клауза',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Отброено време',
      'Escalation in' => 'Улеличение на приоритета в',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => 'от',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Промяна на приоритета на билета',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Показани билети',
      'Tickets available' => 'Налични билети',
      'All tickets' => 'Всички билети',
      'Queues' => 'Опашки',
      'Ticket escalation!' => 'Ескалация (увеличаване на приоритета) на билета!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Вашият собствен билет',
      'Compose Follow up' => 'Създаване проследяване на билетът',
      'Compose Answer' => 'Създаване на отговор',
      'Contact customer' => 'Контакт с клиента',
      'Change queue' => 'Промяна на опашката',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketResponsible
      'Change responsible of ticket' => '',

      # Template: AgentTicketSearch
      'Ticket Search' => 'Търсене на билет',
      'Profile' => '',
      'Search-Template' => '',
      'TicketFreeText' => '',
      'Created in Queue' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Yes, save it with name' => '',

      # Template: AgentTicketSearchResult
      'Search Result' => '',
      'Change search options' => '',

      # Template: AgentTicketSearchResultPrint

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'възходящо сортиране',
      'U' => '',
      'sort downward' => 'низходящо сортиране',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      'Locked' => '',
      'Split' => 'Разцепване',

      # Template: AgentWindowTab

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

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
      'Login' => 'Вход',
      'Lost your password?' => 'Забравена парола',
      'Request new password' => 'Завка за нова парола',
      'Create Account' => 'Създаване на акаунт',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Привет %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView

      # Template: CustomerTicketMessage

      # Template: CustomerTicketSearch

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
      'Home' => 'Начало',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Web инсталатор',
      'accept license' => 'Приемате лиценза',
      'don\'t accept license' => 'Не приемате лиценза',
      'Admin-User' => 'Администратор',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'Вашата MYSQL база данни трябва да има парола за root потребителя. По подразбиране е празна!',
      'Database-User' => '',
      'default \'hot\'' => 'по подразбиране',
      'DB connect host' => '',
      'Database' => '',
      'false' => '',
      'SystemID' => 'Системно ID',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Идентифициране на системата. Всики номер на билет и всяка http сесия започва с този номер)',
      'System FQDN' => 'Системно FQDN',
      '(Full qualified domain name of your system)' => '(Пълно квалифицирано име (FQDN) на системата)',
      'AdminEmail' => 'Admin е-поща',
      '(Email of the system admin)' => '(еМейл на системният администратор)',
      'Organization' => 'Организация',
      'Log' => '',
      'LogModule' => 'Журнален модул',
      '(Used log backend)' => '(Използван журнален изход)',
      'Logfile' => 'Журнален файл',
      '(Logfile just needed for File-LogModule!)' => '(Журналният файл е необходим само за File-LogModule)',
      'Webfrontend' => 'Web-зона',
      'Default Charset' => 'Символен набор по подразбиране',
      'Use utf-8 it your database supports it!' => '',
      'Default Language' => 'Език по подразбиране',
      '(Used default language)' => '(Изполван език по подразбиране)',
      'CheckMXRecord' => 'CheckMXRecord (Проверка MX запис)',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Проверете MX записите на адреса на писмата-отговори. Не използвайте CheckMXRecord, ако вашата OTRS машина е на комутируема линия! ',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'За да може да използвате OTRS, Вие трябва да въведете, като супер потребител root в командна линия (Terminal/Shell) следната команда',
      'Restart your webserver' => 'Рестарт на web сървърът',
      'After doing so your OTRS is up and running.' => 'След извършването на това, Вашият OTRS е напълно работоспособен.',
      'Start page' => 'Начална страница',
      'Have a lot of fun!' => 'Приятна работа!',
      'Your OTRS Team' => 'Вашият OTRS екип',

      # Template: Login
      'Welcome to %s' => 'Добре дошли в %s',

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Нямате позволение',

      # Template: Notify
      'Important' => '',

      # Template: PrintFooter
      'URL' => 'Адрес',

      # Template: PrintHeader
      'printed by' => 'отпечатано от',

      # Template: Redirect

      # Template: Test
      'OTRS Test Page' => 'Тестова страница на OTRS',
      'Counter' => '',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => 'Хост свързан към OTRS база данни',
      'Create Database' => 'Създаване на база данни',
      ' (work units)' => ' (работни единици)',
      'DB Host' => 'Хост на базата данни',
      'Ticket Number Generator' => 'Генератор на номера на билети',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Идентификатор на билета. Примерно: \'Ticket#\', \'Call#\' or \'MyTicket#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Symptom' => '',
      'Site' => 'Място',
      'Customer history search (e. g. "ID342425").' => 'Търсене в хрониката на клиента (примерно "ID342425").',
      'Ticket Hook' => 'Прикачване на билетът',
      'Close!' => 'Затворете!',
      'Don\'t forget to add a new user to groups!' => 'Не забравяйте да добавите новият потребител в някаква група!',
      'OTRS DB Name' => 'Име свързано към OTRS база данни',
      'System Settings' => 'Системни настройки',
      'Finished' => 'Приключено',
      'Queue ID' => '',
      'A article should have a title!' => '',
      'System History' => '',
      'Modules' => '',
      'Keyword' => '',
      'Close type' => 'Тип затваряне',
      'DB Admin User' => 'Потребител на базата данни',
      'Change user <-> group settings' => 'Промяна на потребител <-> Настройки за група',
      'Name is required!' => '',
      'Problem' => '',
      'DB Type' => 'Тип на базата данни',
      'next step' => 'следваща стъпка',
      'Termin1' => '',
      'Customer history search' => 'Търсене в хрониката на клиента',
      'Solution' => '',
      'Admin-Email' => 'еМейл от Admin',
      'QueueView' => 'Преглед на опашката',
      'Create new database' => 'Създаване на нова база данни',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Писмото Ви с номер "<OTRS_TICKET>" е отхвърлен към "<OTRS_BOUNCE_TO>". Свържете се с този адрес за повече информация',
      'modified' => '',
      'Delete old database' => 'Изтриване на стара база данни',
      'Keywords' => '',
      'Note Text' => 'Текст на билежката',
      'No * possible!' => 'Не е възможно използване на символ *!',
      'OTRS DB User' => 'Потребител на OTRS база данни',
      'Options ' => '',
      'PhoneView' => 'Преглед на телефоните',
      'Verion' => '',
      'Message for new Owner' => 'Съобщение за нов собственик',
      'OTRS DB Password' => 'Парола на OTRS база данни',
      'Last update' => '',
      'DB Admin Password' => 'Парола на администратора на базата',
      'Drop Database' => 'Нулиране базата данни',
      'Pending type' => 'В очакване - тип',
      'Comment (internal)' => '',
      '(Used ticket number format)' => '(Използван формат за номера на билетът)',
      'Fulltext' => '',
      'Modified' => '',
      'Watched Tickets' => '',
      'Watched' => '',
      'Subscribe' => '',
      'Unsubscribe' => '',
    };
    # $$STOP$$
}

1;
