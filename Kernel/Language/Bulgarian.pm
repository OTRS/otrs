# --
# Kernel/Language/Bulgarian.pm - provides Bulgarian language translation
# Copyright (C) 2002 Vladimir Gerdjikov <gerdjikov at gerdjikovs.net>
# --
# $Id: Bulgarian.pm,v 1.2 2002-11-21 22:17:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::Bulgarian;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # possible charsets
    $Self->{Charset} = ['koi8-r'];

    # Template: AAABasics
    $Hash{' 2 minutes'} = ' 2 Минуту';
    $Hash{' 5 minutes'} = ' 5 Минути';
    $Hash{' 7 minutes'} = ' 7 Минути';
    $Hash{'10 minutes'} = '10 Минути';
    $Hash{'15 minutes'} = '15 Минути';
    $Hash{'AddLink'} = 'Добавяне на връзка';
    $Hash{'AdminArea'} = 'Зона-Администратор';
    $Hash{'all'} = 'всички';
    $Hash{'All'} = 'Всички';
    $Hash{'Attention'} = 'Внимание';
    $Hash{'Bug Report'} = 'Отчет за грешка';
    $Hash{'Cancel'} = '';
    $Hash{'change'} = 'променете';
    $Hash{'Change'} = 'Промяна';
    $Hash{'change!'} = 'променете!';
    $Hash{'click here'} = 'натиснете тук';
    $Hash{'Comment'} = 'Коментар';
    $Hash{'Customer'} = 'Потребител';
    $Hash{'Customer info'} = 'Потребителски данни';
    $Hash{'day'} = 'ден';
    $Hash{'days'} = 'дни';
    $Hash{'Description'} = 'Описание';
    $Hash{'description'} = 'описание';
    $Hash{'Done'} = '';
    $Hash{'end'} = 'Край';
    $Hash{'Error'} = 'Грешка';
    $Hash{'Example'} = 'Пример';
    $Hash{'Examples'} = 'Примери';
    $Hash{'go'} = 'ОК';
    $Hash{'go!'} = 'ОК!';
    $Hash{'Group'} = 'Група';
    $Hash{'Hit'} = 'Попадение';
    $Hash{'Hits'} = '';
    $Hash{'hour'} = 'час';
    $Hash{'hours'} = 'часове';
    $Hash{'Ignore'} = '';
    $Hash{'Language'} = 'Език';
    $Hash{'Languages'} = 'Езици';
    $Hash{'Line'} = 'Линия';
    $Hash{'Logout successful. Thank you for using OTRS!'} = 'Изходът е успешен. Благодарим Ви, че използвахте системата.';
    $Hash{'Message'} = 'Съобщение';
    $Hash{'minute'} = 'минута';
    $Hash{'minutes'} = 'минути';
    $Hash{'Module'} = 'Модул';
    $Hash{'Modulefile'} = 'Файл-модул';
    $Hash{'Name'} = 'Име';
    $Hash{'New message'} = 'Ново съобщение';
    $Hash{'New message!'} = 'Ново съобщение!';
    $Hash{'no'} = 'не';
    $Hash{'No'} = 'Не';
    $Hash{'No suggestions'} = '';
    $Hash{'none'} = 'няма';
    $Hash{'none - answered'} = 'няма - отговорен';
    $Hash{'none!'} = 'няма!';
    $Hash{'off'} = 'изключено';
    $Hash{'Off'} = 'Изключено';
    $Hash{'On'} = 'Включено';
    $Hash{'on'} = 'включено';
    $Hash{'Password'} = 'Парола';
    $Hash{'Please answer this ticket(s) to get back to the normal queue view!'} = 'Моля, отговорете на този билет(и) за да се върнете в нормалния изглед на опашката!';
    $Hash{'please do not edit!'} = 'моля, не редактирайте!';
    $Hash{'QueueView'} = 'Преглед на опашката';
    $Hash{'replace with'} = '';
    $Hash{'Reset'} = '';
    $Hash{'Salutation'} = 'Обръщение';
    $Hash{'Signature'} = 'Подпис';
    $Hash{'Sorry'} = 'Съжаляваме';
    $Hash{'Stats'} = 'Статистики';
    $Hash{'Subfunction'} = 'Подфункция';
    $Hash{'submit'} = '';
    $Hash{'submit!'} = 'изпратете!';
    $Hash{'Text'} = '';
    $Hash{'The recommended charset for your language is %s!'} = '';
    $Hash{'Theme'} = '';
    $Hash{'top'} = 'към началото';
    $Hash{'update'} = 'обновяване';
    $Hash{'update!'} = 'обновяване!';
    $Hash{'User'} = 'Потребител';
    $Hash{'Username'} = 'Потребителско име';
    $Hash{'Valid'} = 'Валиден';
    $Hash{'Warning'} = '';
    $Hash{'Welcome to OTRS'} = '';
    $Hash{'Word'} = '';
    $Hash{'wrote'} = 'записано';
    $Hash{'yes'} = 'да';
    $Hash{'Yes'} = 'Да';
    $Hash{'You got new message!'} = 'Вие получихте ново съобщение!';

    # Template: AAALanguage
    $Hash{'Brazilian'} = 'Бразилски';
    $Hash{'Chinese'} = 'Китайски';
    $Hash{'Czech'} = 'Чешски';
    $Hash{'Danish'} = 'Датски';
    $Hash{'Dutch'} = 'Холандски';
    $Hash{'English'} = 'Английски';
    $Hash{'French'} = 'Френски';
    $Hash{'German'} = 'Германски';
    $Hash{'Greek'} = 'Гръцки';
    $Hash{'Italian'} = 'Италиански';
    $Hash{'Korean'} = 'Корейски';
    $Hash{'Polish'} = 'Полски';
    $Hash{'Russian'} = 'Руски';
    $Hash{'Spanish'} = 'Испански';
    $Hash{'Swedish'} = 'Шведски';

    # Template: AAAPreferences
    $Hash{'Custom Queue'} = '';
    $Hash{'Follow up notification'} = 'Известие за наличност на следене на отговорът';
    $Hash{'Frontend'} = '';
    $Hash{'Mail Management'} = '';
    $Hash{'Move notification'} = 'Известие за преместване';
    $Hash{'New ticket notification'} = 'Напомняне за нов билет';
    $Hash{'Other Options'} = '';
    $Hash{'Preferences updated successfully!'} = '';
    $Hash{'QueueView refresh time'} = '';
    $Hash{'Select your frontend Charset.'} = 'Изберете Вашият символен набор.';
    $Hash{'Select your frontend language.'} = 'Изберете Вашият език.';
    $Hash{'Select your frontend QueueView.'} = 'Изберете език за визуализация съдържанието на опашката.';
    $Hash{'Select your frontend Theme.'} = '';
    $Hash{'Select your QueueView refresh time.'} = 'Изберете Вашето време за обновяване за изгледа на опашката.';
    $Hash{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Изпратете ми известие, ако клиентът изпрати заявка за следене на отговора и аз съм собственик на билета';
    $Hash{'Send me a notification if a ticket is moved into a custom queue.'} = 'Изпратете ми известие, ако билетът е преместен в някаква потребителска опашка.';
    $Hash{'Send me a notification if a ticket is unlocked by the system.'} = 'Изпратете ми известие, ако билетът е отключен от системата.';
    $Hash{'Send me a notification if there is a new ticket in my custom queues.'} = 'Изпратете ми известие, ако има нов(и) билет в моята потребителска опашка.';
    $Hash{'Ticket lock timeout notification'} = 'Известие за продължителността на заключване на билетът';

    # Template: AAATicket
    $Hash{'Action'} = 'Действие';
    $Hash{'Age'} = 'Възраст';
    $Hash{'Article'} = 'Клауза';
    $Hash{'Attachment'} = 'Прикачен файл';
    $Hash{'Attachments'} = '';
    $Hash{'Bcc'} = '';
    $Hash{'Bounce'} = 'Отхвърлени';
    $Hash{'Cc'} = 'Копие до';
    $Hash{'Close'} = 'Затваряне';
    $Hash{'closed succsessful'} = 'успешно затворен';
    $Hash{'closed unsuccsessful'} = 'неуспешно затворен';
    $Hash{'Compose'} = 'Създаване';
    $Hash{'Created'} = 'Създаден';
    $Hash{'Createtime'} = 'време на създаване';
    $Hash{'eMail'} = '';
    $Hash{'email'} = 'еМейл';
    $Hash{'email-external'} = 'външен еМейл';
    $Hash{'email-internal'} = 'вътрешен еМейл';
    $Hash{'Forward'} = 'Препратете';
    $Hash{'From'} = 'От';
    $Hash{'high'} = 'висок';
    $Hash{'History'} = 'Хроника';
    $Hash{'If it is not displayed correctly,'} = 'Ако не се вижда коректно,';
    $Hash{'Lock'} = 'Заключи';
    $Hash{'low'} = 'нисък';
    $Hash{'Move'} = 'Преместване';
    $Hash{'new'} = 'нов';
    $Hash{'normal'} = 'нормален';
    $Hash{'note-external'} = 'външна бележка';
    $Hash{'note-internal'} = 'вътрешна бележка';
    $Hash{'note-report'} = 'бележка отчет';
    $Hash{'open'} = 'отворен';
    $Hash{'Owner'} = 'Собственик';
    $Hash{'Pending'} = 'В очакване';
    $Hash{'phone'} = 'телефон';
    $Hash{'plain'} = 'обикновен';
    $Hash{'Priority'} = 'Приоритет';
    $Hash{'Queue'} = '';
    $Hash{'removed'} = 'премахнат';
    $Hash{'Sender'} = 'Изпращач';
    $Hash{'sms'} = '';
    $Hash{'State'} = 'Статус';
    $Hash{'Subject'} = 'Относно';
    $Hash{'This is a'} = 'Това е';
    $Hash{'This is a HTML email. Click here to show it.'} = 'Това е поща в HTML формат. Натиснете тук, за да го покажете коректно';
    $Hash{'This message was written in a character set other than your own.'} = 'Това писмо е написано в символна подредба различна от тази, която имате.';
    $Hash{'Ticket'} = 'Билет';
    $Hash{'To'} = 'До';
    $Hash{'to open it in a new window.'} = 'да го отворите в нов прозорец';
    $Hash{'Unlock'} = 'Отключи';
    $Hash{'very high'} = 'много висок';
    $Hash{'very low'} = 'много нисък';
    $Hash{'View'} = 'Изглед';
    $Hash{'webrequest'} = '';
    $Hash{'Zoom'} = 'Подробно';

    # Template: AdminAutoResponseForm
    $Hash{'Add auto response'} = 'Добавяне на автоматичен отговор';
    $Hash{'Auto Response From'} = '';
    $Hash{'Auto Response Management'} = 'Управление на автоматичният отговор';
    $Hash{'Change auto response settings'} = 'Промяна на настройките за автоматичният отговор';
    $Hash{'Charset'} = '';
    $Hash{'Note'} = '';
    $Hash{'Response'} = 'Отговор';
    $Hash{'to get the first 20 character of the subject'} = '';
    $Hash{'to get the first 5 lines of the email'} = '';
    $Hash{'Type'} = '';
    $Hash{'Useable options'} = 'Използваеми опции';

    # Template: AdminCharsetForm
    $Hash{'Add charset'} = 'Добавяне на символен набор';
    $Hash{'Change system charset setting'} = 'Промяна на системният символен набор';
    $Hash{'System Charset Management'} = 'Управление на символният набор';

    # Template: AdminCustomerUserForm
    $Hash{'Add customer user'} = '';
    $Hash{'Change customer user settings'} = '';
    $Hash{'Customer User Management'} = '';
    $Hash{'Customer user will be needed to to login via customer panels.'} = '';
    $Hash{'CustomerID'} = 'Потребителски индикатив';
    $Hash{'Email'} = 'еМейл';
    $Hash{'Firstname'} = 'Име';
    $Hash{'Lastname'} = 'Фамилия';
    $Hash{'Login'} = '';

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
    $Hash{'Admin-Email'} = '';
    $Hash{'Body'} = '';
    $Hash{'OTRS-Admin Info!'} = '';
    $Hash{'Recipents'} = '';

    # Template: AdminEmailSent
    $Hash{'Message sent to'} = '';

    # Template: AdminGroupForm
    $Hash{'Add group'} = 'Добавяне на група';
    $Hash{'Change group settings'} = 'Промяна на груповите настройки';
    $Hash{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} = 'Направете нови групи за да управляване позволенията за различните групи от агенти (примерно агент за отдел "продажби", отдел "поддръжка" и т.н.)';
    $Hash{'Group Management'} = 'Управление на групи';
    $Hash{'It\'s useful for ASP solutions.'} = 'Това е подходящо за решения с ASP.';
    $Hash{'The admin group is to get in the admin area and the stats group to get stats area.'} = 'Групата admin достъпва admin зоната, а stat групата достъпва stat зоната';

    # Template: AdminLanguageForm
    $Hash{'Add language'} = 'Добавяне на език';
    $Hash{'Change system language setting'} = 'Промяна на настройките на системният език';
    $Hash{'System Language Management'} = 'Управление на езиковите настройки';

    # Template: AdminNavigationBar
    $Hash{'AdminEmail'} = '';
    $Hash{'AgentFrontend'} = 'Зона-потребител';
    $Hash{'Auto Response <-> Queue'} = 'Автоматичен отговор <-> Опашки';
    $Hash{'Auto Responses'} = 'Автоматичен отговор';
    $Hash{'Charsets'} = '';
    $Hash{'CustomerUser'} = '';
    $Hash{'Email Addresses'} = 'еМейл адреси';
    $Hash{'Groups'} = 'Групи';
    $Hash{'Logout'} = 'Изход';
    $Hash{'Responses'} = 'Отговори';
    $Hash{'Responses <-> Queue'} = 'Отговори <-> Опашки';
    $Hash{'Select Box'} = '';
    $Hash{'Session Management'} = 'Управление на сесята';
    $Hash{'Status defs'} = '';
    $Hash{'User <-> Groups'} = 'Потребител <-> Групи';

    # Template: AdminQueueAutoResponseForm
    $Hash{'Queue <-> Auto Response Management'} = 'Опашка <-> Управление на автоматичният отговор';

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
    $Hash{'0 = no escalation'} = '';
    $Hash{'0 = no unlock'} = '';
    $Hash{'Add queue'} = 'Добавяне на опашка';
    $Hash{'Change queue settings'} = 'Промяна на настройките на опашката';
    $Hash{'Escalation time'} = 'Време за ескалация (увеличаване на приоритетът)';
    $Hash{'Follow up Option'} = '';
    $Hash{'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'} = '';
    $Hash{'If a ticket will not be answered in thos time, just only this ticket will be shown.'} = '';
    $Hash{'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'} = '';
    $Hash{'Key'} = 'Ключ';
    $Hash{'Queue Management'} = 'Управление на опашка';
    $Hash{'Systemaddress'} = '';
    $Hash{'The salutation for email answers.'} = '';
    $Hash{'The signature for email answers.'} = '';
    $Hash{'Ticket lock after a follow up'} = '';
    $Hash{'Unlock timeout'} = 'Време за отключване';
    $Hash{'Will be the sender address of this queue for email answers.'} = '';

    # Template: AdminQueueResponsesChangeForm
    $Hash{'Change %s settings'} = '';
    $Hash{'Std. Responses <-> Queue Management'} = 'Стандартни отговори <-> Управление на опашката';

    # Template: AdminQueueResponsesForm
    $Hash{'Answer'} = '';
    $Hash{'Change answer <-> queue settings'} = 'Промяна на отговорът <-> Настройки на опашката';

    # Template: AdminResponseForm
    $Hash{'A response is default text to write faster answer (with default text) to customers.'} = 'Отговорът е текст по подразбиране, създанен предварително, с цел по-бърз отговор към клиента';
    $Hash{'Add response'} = 'Добавяне на отговор';
    $Hash{'Change response settings'} = 'Промяна на настойките на отговорът';
    $Hash{'Don\'t forget to add a new response a queue!'} = 'Да не забравите да добавите новият отговор към дадена опашка!';
    $Hash{'Response Management'} = 'Управление на отговорът';

    # Template: AdminSalutationForm
    $Hash{'Add salutation'} = 'Добавяне на обръщение';
    $Hash{'Change salutation settings'} = 'Промяна на настройките на обръщението';
    $Hash{'customer realname'} = 'име на потребителя';
    $Hash{'Salutation Management'} = 'Управление на обръщението';

    # Template: AdminSelectBoxForm
    $Hash{'Max Rows'} = 'Максимален брой редове';

    # Template: AdminSelectBoxResult
    $Hash{'Limit'} = '';
    $Hash{'Select Box Result'} = '';
    $Hash{'SQL'} = '';

    # Template: AdminSession
    $Hash{'kill all sessions'} = 'Затваряне на всички текущи сесии';

    # Template: AdminSessionTable
    $Hash{'kill session'} = 'Затваряне на единична сесия';
    $Hash{'SessionID'} = '';

    # Template: AdminSignatureForm
    $Hash{'Add signature'} = 'Добавяне на подпис';
    $Hash{'Change signature settings'} = 'Промяна на настройките на подписът';
    $Hash{'for agent firstname'} = 'за агента - име';
    $Hash{'for agent lastname'} = 'за агента - фамилия';
    $Hash{'Signature Management'} = 'Управление на подписът';

    # Template: AdminStateForm
    $Hash{'Add state'} = 'Добавяне на състояние';
    $Hash{'Change system state setting'} = 'Промяна на настройките за системно състояние';
    $Hash{'System State Management'} = 'Управление на системно състояние';

    # Template: AdminSystemAddressForm
    $Hash{'Add system address'} = 'Добавяне на нов системен адрес';
    $Hash{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Всички входящи адреси от този еМейл (До:) ще се разпределят в избраната опашка';
    $Hash{'Change system address setting'} = 'Промяна на настройките на системният адрес';
    $Hash{'Realname'} = '';
    $Hash{'System Email Addresses Management'} = 'Управление на системния еМейл адрес';

    # Template: AdminUserForm
    $Hash{'Add user'} = 'Добавяне на потребител';
    $Hash{'Change user settings'} = 'Промяна на потребителските настройки';
    $Hash{'Don\'t forget to add a new user to groups!'} = 'Не забравяйте да добавите новият потребител в някаква група!';
    $Hash{'User Management'} = 'Управление на потребители';
    $Hash{'User will be needed to handle tickets.'} = 'Ще е необходим потребител, за да може билетът да се обработи';

    # Template: AdminUserGroupChangeForm
    $Hash{'Change  settings'} = '';
    $Hash{'User <-> Group Management'} = 'Потребител <-> Управление на група';

    # Template: AdminUserGroupForm
    $Hash{'Change user <-> group settings'} = 'Промяна на потребител <-> Настройки за група';

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
    $Hash{'A message should have a To: recipient!'} = 'Съобщението трябва да има ДО: т.е. адресант!';
    $Hash{'Bounce ticket'} = '';
    $Hash{'Bounce to'} = '';
    $Hash{'Inform sender'} = '';
    $Hash{'Next ticket state'} = 'Следващо състояние за билетът';
    $Hash{'Send mail!'} = 'Изпратете еМейл!';
    $Hash{'You need a email address (e. g. customer@example.com) in To:!'} = 'Трябва да има валиден адрес в полето ДО: (примерно support@hebros.bg)!';
    $Hash{'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.'} = '';

    # Template: AgentClose
    $Hash{' (work units)'} = '';
    $Hash{'Close ticket'} = '';
    $Hash{'Close type'} = '';
    $Hash{'Close!'} = '';
    $Hash{'Note Text'} = '';
    $Hash{'Note type'} = 'Бележката е от тип';
    $Hash{'store'} = 'съхранение';
    $Hash{'Time units'} = '';

    # Template: AgentCompose
    $Hash{'A message should have a subject!'} = 'Съобщението трябва да има текст в поле "относно"!';
    $Hash{'Attach'} = '';
    $Hash{'Compose answer for ticket'} = 'Създаване на отговор за този билет';
    $Hash{'Is the ticket answered'} = '';
    $Hash{'Options'} = '';
    $Hash{'Spell Check'} = '';

    # Template: AgentCustomer
    $Hash{'Back'} = 'Назад';
    $Hash{'Change customer of ticket'} = '';
    $Hash{'Set customer id of a ticket'} = 'Задаване на потребителски индикатив на билета';

    # Template: AgentCustomerHistory
    $Hash{'Customer history'} = '';

    # Template: AgentCustomerHistoryTable

    # Template: AgentForward
    $Hash{'Article type'} = 'Клауза тип';
    $Hash{'Date'} = '';
    $Hash{'End forwarded message'} = '';
    $Hash{'Forward article of ticket'} = 'Препрати клаузата за този билет';
    $Hash{'Forwarded message from'} = '';
    $Hash{'Reply-To'} = '';

    # Template: AgentHistoryForm
    $Hash{'History of'} = '';

    # Template: AgentMailboxTicket
    $Hash{'Add Note'} = 'Добавяне на бележка';

    # Template: AgentNavigationBar
    $Hash{'FAQ'} = '';
    $Hash{'Locked tickets'} = 'Заключени билети';
    $Hash{'new message'} = 'ново съобщение';
    $Hash{'PhoneView'} = 'Преглед на телефоните';
    $Hash{'Preferences'} = 'Предпочитания';
    $Hash{'Utilities'} = 'Помощни средства';

    # Template: AgentNote
    $Hash{'Add note to ticket'} = 'Добавяне на бележка към билета';
    $Hash{'Note!'} = '';

    # Template: AgentOwner
    $Hash{'Change owner of ticket'} = '';
    $Hash{'Message for new Owner'} = '';
    $Hash{'New user'} = '';

    # Template: AgentPhone
    $Hash{'Customer called'} = '';
    $Hash{'Phone call'} = 'Телефонно обаждане';
    $Hash{'Phone call at %s'} = '';

    # Template: AgentPhoneNew
    $Hash{'A message should have a From: recipient!'} = 'Съобщението трябва да има попълнено поле ОТ:';
    $Hash{'new ticket'} = 'нов билет';
    $Hash{'New ticket via call.'} = '';
    $Hash{'You need a email address (e. g. customer@example.com) in From:!'} = 'Трябва да имате еМейл адрес (примерно customer@example.com) в поле ОТ:';

    # Template: AgentPlain
    $Hash{'ArticleID'} = '';
    $Hash{'Plain'} = 'Обикновен';
    $Hash{'TicketID'} = '';

    # Template: AgentPreferencesCustomQueue
    $Hash{'Select your custom queues'} = 'Изберете Вашата потребителска опашка';

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
    $Hash{'Change Password'} = 'Промяна на парола';
    $Hash{'New password'} = 'Нова парола';
    $Hash{'New password again'} = 'Въведете отново паролата';

    # Template: AgentPriority
    $Hash{'Change priority of ticket'} = 'Промяна на приоритета на билета';
    $Hash{'New state'} = '';

    # Template: AgentSpelling
    $Hash{'Apply these changes'} = '';
    $Hash{'Discard all changes and return to the compose screen'} = '';
    $Hash{'Return to the compose screen'} = '';
    $Hash{'Spell Checker'} = '';
    $Hash{'spelling error(s)'} = '';
    $Hash{'The message being composed has been closed.  Exiting.'} = '';
    $Hash{'This window must be called from compose window'} = '';

    # Template: AgentStatusView
    $Hash{'D'} = '';
    $Hash{'sort downward'} = '';
    $Hash{'sort upward'} = '';
    $Hash{'Ticket limit:'} = '';
    $Hash{'Ticket Status'} = '';
    $Hash{'U'} = '';

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
    $Hash{'Ticket locked!'} = 'Билетът е заключен!';
    $Hash{'unlock'} = 'отключи';

    # Template: AgentUtilSearchByCustomerID
    $Hash{'Customer history search'} = 'Търсене в хрониката на клиента';
    $Hash{'Customer history search (e. g. "ID342425").'} = 'Търсене в хрониката на клиента (примерно "ID342425").';
    $Hash{'No * possible!'} = 'Не е възможно използване на символ *!';

    # Template: AgentUtilSearchByText
    $Hash{'Article free text'} = '';
    $Hash{'Fulltext search'} = 'Текстово търсене';
    $Hash{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Текстово търсене (примерно "Mar*in" или "Baue*" или "martin+hallo")';
    $Hash{'Search in'} = '';
    $Hash{'Ticket free text'} = '';

    # Template: AgentUtilSearchByTicketNumber
    $Hash{'search'} = 'търсене';
    $Hash{'search (e. g. 10*5155 or 105658*)'} = 'търсене (примерно 10*5155 или 105658*)';

    # Template: AgentUtilSearchNavBar
    $Hash{'Results'} = '';
    $Hash{'Site'} = '';
    $Hash{'Total hits'} = 'Общ брой попадения';

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
    $Hash{'All open tickets'} = '';
    $Hash{'open tickets'} = '';
    $Hash{'Provides an overview of all'} = '';
    $Hash{'So you see what is going on in your system.'} = '';

    # Template: CustomerCreateAccount
    $Hash{'Create'} = '';
    $Hash{'Create Account'} = '';

    # Template: CustomerError
    $Hash{'Backend'} = '';
    $Hash{'BackendMessage'} = '';
    $Hash{'Click here to report a bug!'} = 'Натиснете тук, за да изпратите отчет за грешката!';
    $Hash{'Handle'} = '';

    # Template: CustomerFooter
    $Hash{'Powered by'} = '';

    # Template: CustomerHeader

    # Template: CustomerLogin

    # Template: CustomerLostPassword
    $Hash{'Lost your password?'} = '';
    $Hash{'Request new password'} = '';

    # Template: CustomerMessage
    $Hash{'Follow up'} = '';

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
    $Hash{'Create new Ticket'} = '';
    $Hash{'My Tickets'} = 'Моите билети';
    $Hash{'New Ticket'} = 'Нов билет';
    $Hash{'Ticket-Overview'} = '';
    $Hash{'Welcome %s'} = '';

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
    $Hash{'Accounted time'} = '';

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header
    $Hash{'Home'} = '';

    # Template: InstallerStart
    $Hash{'next step'} = '';

    # Template: InstallerSystem

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
    $Hash{'No Permission'} = 'Нямате позволение';

    # Template: Notify
    $Hash{'Info'} = '';

    # Template: QueueView
    $Hash{'All tickets'} = 'Всички билети';
    $Hash{'Queues'} = 'Опашки';
    $Hash{'Show all'} = 'Показване на всички';
    $Hash{'Ticket available'} = 'Налични билети';
    $Hash{'tickets'} = 'билети';
    $Hash{'Tickets shown'} = 'Показани билети';

    # Template: SystemStats
    $Hash{'Graphs'} = 'Графики';
    $Hash{'Tickets'} = '';

    # Template: Test
    $Hash{'OTRS Test Page'} = '';

    # Template: TicketEscalation
    $Hash{'Ticket escalation!'} = 'Ескалация (увеличаване на приоритета) на билета!';

    # Template: TicketView
    $Hash{'Change queue'} = 'Промяна на опашката';
    $Hash{'Compose Answer'} = 'Създаване на отговор';
    $Hash{'Contact customer'} = 'Контакт с клиента';
    $Hash{'phone call'} = 'телефонно обаждане';
    $Hash{'Time till escalation'} = 'Време до ескалация';

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
    $Hash{'(Click here to add a group)'} = '(Натиснете тук, за да добавите нова група)';
    $Hash{'(Click here to add a queue)'} = '(Натиснете тук, за да добавите нова опашка)';
    $Hash{'(Click here to add a response)'} = '(Натиснете тук, за да добавите нов отговор)';
    $Hash{'(Click here to add a salutation)'} = '(Натиснете тук, за да добавите ново обръщение)';
    $Hash{'(Click here to add a signature)'} = '(Натиснете тук, за да добавите нов подпис)';
    $Hash{'(Click here to add a system email address)'} = '(Натиснете тук, за да добавите нов системен адрес)';
    $Hash{'(Click here to add a user)'} = '(Натиснете тук, за да добавите нов потребител)';
    $Hash{'(Click here to add an auto response)'} = '(Натиснете тук, за да добавите нов автоматичен отговор)';
    $Hash{'(Click here to add charset)'} = '(Натиснете тук, за да добавите нов символен набор)';
    $Hash{'(Click here to add language)'} = '(Натиснете тук, за да добавите нов език)';
    $Hash{'(Click here to add state)'} = '(Натиснете тук, за да добавите ново системно състояние )';
    $Hash{'Update auto response'} = 'Обновяване на автоматичният отговор';
    $Hash{'Update charset'} = 'Обновяване на символен набор';
    $Hash{'Update group'} = 'Обновяване на група';
    $Hash{'Update language'} = 'Обновяване на език';
    $Hash{'Update queue'} = 'Обновяване на опашка';
    $Hash{'Update response'} = 'Обновяване на отговорът';
    $Hash{'Update salutation'} = 'Обновяване на обръщение';
    $Hash{'Update signature'} = 'Обновяване на подпис';
    $Hash{'Update state'} = 'Обновяване на състояние';
    $Hash{'Update system address'} = 'Обновяване ан системният адрес';
    $Hash{'Update user'} = 'Обновяване на потребител';
    $Hash{'You have to be in the admin group!'} = 'Трябва да сте член на admin групата!';
    $Hash{'You have to be in the stats group!'} = 'Трябва да сте член на stat групата!';
    $Hash{'auto responses set'} = 'набор автоматични отговори';

    $Self->{Translation} = \%Hash;

}
# --
1;
