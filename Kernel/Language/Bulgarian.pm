# --
# Kernel/Language/Bulgarian.pm - provides Bulgarian languag translation
# Copyright (C) 2001-2002 Martin Edenhofe <martin+code@otrs.org>
# Translation made by: Vladimir Gerdjikov <gerdjikov@gerdjikovs.net>
# --
# $Id: Bulgarian.pm,v 1.1 2002-11-14 13:46:19 stefan Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::Bulgarian;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # --
    # some common words
    # --
    $Self->{Lock} = 'Заключи';
    $Self->{Unlock} = 'Отключи';
    $Self->{unlock} = 'отключи';
    $Self->{Zoom} = 'Подробно';
    $Self->{History} = 'Хроника';
    $Self->{'Add Note'} = 'Добавяне на бележка';
    $Self->{Bounce} = 'Отхвърлени';
    $Self->{Age} = 'Възраст';
    $Self->{Priority} = 'Приоритет';
    $Self->{State} = 'Статус';
    $Self->{From} = 'От';
    $Self->{To} = 'До';
    $Self->{Cc} = 'Копие до';
    $Self->{Subject} = 'Относно';
    $Self->{Move} = 'Преместване';
    $Self->{Queues} = 'Опашки';
    $Self->{Close} = 'Затваряне';
    $Self->{Compose} = 'Създаване';
    $Self->{Pending} = 'В очакване';
    $Self->{end} = 'Край';
    $Self->{top} = 'към началото';
    $Self->{day} = 'ден';
    $Self->{days} = 'дни';
    $Self->{hour} = 'час';
    $Self->{hours} = 'часове';
    $Self->{minute} = 'минута';
    $Self->{minutes} = 'минути';
    $Self->{Owner} = 'Собственик';
    $Self->{Sender} = 'Изпращач';
    $Self->{Article} = 'Клауза';
    $Self->{Ticket} = 'Билет';
    $Self->{Createtime} = 'време на създаване';
    $Self->{Created} = 'Създаден';
    $Self->{View} = 'Изглед';
    $Self->{plain} = 'обикновен';
    $Self->{Plain} = 'Обикновен';
    $Self->{Action} = 'Действие';
    $Self->{Attachment} = 'Прикачен файл';
    $Self->{User} = 'Потребител';
    $Self->{Username} = 'Потребителско име';
    $Self->{Password} = 'Парола';
    $Self->{Back} = 'Назад';
    $Self->{store} = 'съхранение';
    $Self->{phone} = 'телефон';
    $Self->{Phone} = 'Телефон';
    $Self->{email} = 'еМейл';
    $Self->{Email} = 'еМейл';
    $Self->{'Language'} = 'Език';
    $Self->{'Languages'} = 'Езици';
    $Self->{'Salutation'} = 'Обръщение';
    $Self->{'Signature'} = 'Подпис';
    $Self->{currently} = 'понастоящем';
    $Self->{Customer} = 'Потребител';
    $Self->{'Customer info'} = 'Потребителски данни';
    $Self->{'Set customer id of a ticket'} = 'Задаване на потребителски индикатив на билета';
    $Self->{'All tickets of this customer'} = 'Всички билети за даден потребител';
    $Self->{'New CustomerID'} = 'Нов потребителски индикатив';
    $Self->{'for ticket'} = 'за билет';
    $Self->{'new ticket'} = 'нов билет';
    $Self->{'New Ticket'} = 'Нов билет';
    $Self->{'Start work'} = 'Начало на работата';
    $Self->{'Stop work'} = 'Край на работата';
    $Self->{'CustomerID'} = 'Потребителски индикатив';
    $Self->{'Compose Answer'} = 'Създаване на отговор';
    $Self->{'Contact customer'} = 'Контакт с клиента';
    $Self->{'Change queue'} = 'Промяна на опашката';
    $Self->{'go!'} = 'ОК!';
    $Self->{'go'} = 'ОК';
    $Self->{'all'} = 'всички';
    $Self->{'All'} = 'Всички';
    $Self->{'Sorry'} = 'Съжаляваме';
    $Self->{'No'} = 'Не';
    $Self->{'no'} = 'не';
    $Self->{'Yes'} = 'Да';
    $Self->{'yes'} = 'да';
    $Self->{'Off'} = 'Изключено';
    $Self->{'off'} = 'изключено';
    $Self->{'On'} = 'Включено';
    $Self->{'on'} = 'включено';
    $Self->{'update!'} = 'обновяване!';
    $Self->{'update'} = 'обновяване';
    $Self->{'submit!'} = 'изпратете!';
    $Self->{'change!'} = 'променете!';
    $Self->{'change'} = 'променете';
    $Self->{'Change'} = 'Промяна';
    $Self->{'click here'} = 'натиснете тук';
    $Self->{'settings'} = 'настройки';
    $Self->{'Settings'} = 'Настройки';
    $Self->{'Comment'} = 'Коментар';
    $Self->{'Valid'} = 'Валиден';
    $Self->{'Forward'} = 'Препратете';
    $Self->{'Name'} = 'Име';
    $Self->{'Group'} = 'Група';
    $Self->{'Response'} = 'Отговор';
    $Self->{'Preferences'} = 'Предпочитания';
    $Self->{'Description'} = 'Описание';
    $Self->{'description'} = 'описание';
    $Self->{'Key'} = 'Ключ';
    $Self->{'top'} = 'към началото';
    $Self->{'Line'} = 'Линия';
    $Self->{'Subfunction'} = 'Подфункция';
    $Self->{'Module'} = 'Модул';
    $Self->{'Modulefile'} = 'Файл-модул';
    $Self->{'No Permission'} = 'Нямате позволение';
    $Self->{'You have to be in the admin group!'} = 'Трябва да сте член на admin групата!';
    $Self->{'You have to be in the stats group!'} = 'Трябва да сте член на stat групата!';
    $Self->{'Message'} = 'Съобщение';
    $Self->{'Error'} = 'Грешка';
    $Self->{'Bug Report'} = 'Отчет за грешка';
    $Self->{'Click here to report a bug!'} = 'Натиснете тук, за да изпратите отчет за грешката!';
    $Self->{'This is a HTML email. Click here to show it.'} = 'Това е поща в HTML формат. Натиснете тук, за да го покажете коректно';
    $Self->{'AgentFrontend'} = 'Зона-потребител';
    $Self->{'Attention'} = 'Внимание';
    $Self->{'Time till escalation'} = 'Време до ескалация';
    $Self->{'Groups'} = 'Групи';
    $Self->{'User'} = 'Потребител';
    $Self->{'none!'} = 'няма!';
    $Self->{'none'} = 'няма';
    $Self->{'none - answered'} = 'няма - отговорен';
    $Self->{'German'} = 'Германски';
    $Self->{'English'} = 'Английски';
    $Self->{'French'} = 'Френски';
    $Self->{'French'} = 'Френски';
    $Self->{'Chinese'} = 'Китайски';
    $Self->{'Czech'} = 'Чешски';
    $Self->{'Danish'} = 'Датски';
    $Self->{'Spanish'} = 'Испански';
    $Self->{'Greek'} = 'Гръцки';
    $Self->{'Italian'} = 'Италиански';
    $Self->{'Korean'} = 'Корейски';
    $Self->{'Dutch'} = 'Холандски';
    $Self->{'Polish'} = 'Полски';
    $Self->{'Brazilian'} = 'Бразилски';
    $Self->{'Russian'} = 'Руски';
    $Self->{'Swedish'} = 'Шведски';
    $Self->{'Lite'} = 'Олекотена';
    $Self->{'This message was written in a character set other than your own.'} = 
     'Това писмо е написано в символна подредба различна от тази, която имате.';
    $Self->{'If it is not displayed correctly,'} = 'Ако не се вижда коректно,';
    $Self->{'This is a'} = 'Това е';
    $Self->{'to open it in a new window.'} = 'да го отворите в нов прозорец';
    # --
    # admin interface
    # --
    # common adminwords
    $Self->{'Useable options'} = 'Използваеми опции';
    $Self->{'Example'} = 'Пример';
    $Self->{'Examples'} = 'Примери';
    # nav bar
    $Self->{'Admin Area'} = 'Зона-администратор';
    $Self->{'Auto Responses'} = 'Автоматичен отговор'; 
    $Self->{'Responses'} = 'Отговори';
    $Self->{'Responses <-> Queue'} = 'Отговори <-> Опашки';
    $Self->{'User <-> Groups'} = 'Потребител <-> Групи';
    $Self->{'Queue <-> Auto Response'} = 'Опашка <-> Автоматичен отговор';
    $Self->{'Auto Response <-> Queue'} = 'Автоматичен отговор <-> Опашки';
    $Self->{'Session Management'} = 'Управление на сесии';
    $Self->{'Email Addresses'} = 'еМейл адреси';
    # user
    $Self->{'User Management'} = 'Управление на потребители';
    $Self->{'Change user settings'} = 'Промяна на потребителските настройки';
    $Self->{'Add user'} = 'Добавяне на потребител';
    $Self->{'Update user'} = 'Обновяване на потребител';
    $Self->{'Firstname'} = 'Име';
    $Self->{'Lastname'} = 'Фамилия';
    $Self->{'(Click here to add a user)'} = '(Натиснете тук, за да добавите нов потребител)';
    $Self->{'User will be needed to handle tickets.'} = 'Ще е необходим потребител, за да може билетът да се обработи';
    $Self->{'Don\'t forget to add a new user to groups!'} = 'Не забравяйте да добавите новият потребител в някаква група!';
    # group
    $Self->{'Group Management'} = 'Управление на групи';
    $Self->{'Change group settings'} = 'Промяна на груповите настройки';
    $Self->{'Add group'} = 'Добавяне на група';
    $Self->{'Update group'} = 'Обновяване на група';
    $Self->{'(Click here to add a group)'} = '(Натиснете тук, за да добавите нова група)';
    $Self->{'The admin group is to get in the admin area and the stats group to get stats area.'} =
     'Групата admin достъпва admin зоната, а stat групата достъпва stat зоната';
    $Self->{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} =
     'Направете нови групи за да управляване позволенията за различните групи от агенти (примерно агент за отдел "продажби", отдел "поддръжка" и т.н.)';
    $Self->{'It\'s useful for ASP solutions.'} = 'Това е подходящо за решения с ASP.';
    # user <-> group
    $Self->{'User <-> Group Management'} = 'Потребител <-> Управление на група';
    $Self->{'Change user <-> group settings'} = 'Промяна на потребител <-> Настройки за група';
    # queue
    $Self->{'Queue Management'} = 'Управление на опашка';
    $Self->{'Add queue'} = 'Добавяне на опашка';
    $Self->{'Change queue settings'} = 'Промяна на настройките на опашката';
    $Self->{'Update queue'} = 'Обновяване на опашка';
    $Self->{'(Click here to add a queue)'} = '(Натиснете тук, за да добавите нова опашка)';
    $Self->{'Unlock timeout'} = 'Време за отключване';
    $Self->{'Escalation time'} = 'Време за ескалация (увеличаване на приоритетът)';
    # Response
    $Self->{'Response Management'} = 'Управление на отговорът';
    $Self->{'Add response'} = 'Добавяне на отговор';
    $Self->{'Change response settings'} = 'Промяна на настойките на отговорът';
    $Self->{'Update response'} = 'Обновяване на отговорът';
    $Self->{'(Click here to add a response)'} = '(Натиснете тук, за да добавите нов отговор)'; 
    $Self->{'A response is default text to write faster answer (with default text) to customers.'} =
     'Отговорът е текст по подразбиране, създанен предварително, с цел по-бърз отговор към клиента';
    $Self->{'Don\'t forget to add a new response a queue!'} = 'Да не забравите да добавите новият отговор към дадена опашка!';
    # Responses <-> Queue
    $Self->{'Std. Responses <-> Queue Management'} = 'Стандартни отговори <-> Управление на опашката';
    $Self->{'Standart Responses'} = 'Стандартни отговори';
    $Self->{'Change answer <-> queue settings'} = 'Промяна на отговорът <-> Настройки на опашката';
    # auto responses
    $Self->{'Auto Response Management'} = 'Управление на автоматичният отговор';
    $Self->{'Change auto response settings'} = 'Промяна на настройките за автоматичният отговор';
    $Self->{'Add auto response'} = 'Добавяне на автоматичен отговор';
    $Self->{'Update auto response'} = 'Обновяване на автоматичният отговор';
    $Self->{'(Click here to add an auto response)'} = '(Натиснете тук, за да добавите нов автоматичен отговор)';
    # salutation
    $Self->{'Salutation Management'} = 'Управление на обръщението';
    $Self->{'Add salutation'} = 'Добавяне на обръщение';
    $Self->{'Update salutation'} = 'Обновяване на обръщение';
    $Self->{'Change salutation settings'} = 'Промяна на настройките на обръщението';
    $Self->{'(Click here to add a salutation)'} = '(Натиснете тук, за да добавите ново обръщение)';
    $Self->{'customer realname'} = 'име на потребителя';
    # signature
    $Self->{'Signature Management'} = 'Управление на подписът';
    $Self->{'Add signature'} = 'Добавяне на подпис';
    $Self->{'Update signature'} = 'Обновяване на подпис';
    $Self->{'Change signature settings'} = 'Промяна на настройките на подписът';
    $Self->{'(Click here to add a signature)'} = '(Натиснете тук, за да добавите нов подпис)';
    $Self->{'for agent firstname'} = 'за агента - име';
    $Self->{'for agent lastname'} = 'за агента - фамилия';
    # queue <-> auto response
    $Self->{'Queue <-> Auto Response Management'} = 'Опашка <-> Управление на автоматичният отговор';
    $Self->{'auto responses set'} = 'набор автоматични отговори';
    # system email addesses
    $Self->{'System Email Addresses Management'} = 'Управление на системния еМейл адрес';
    $Self->{'Change system address setting'} = 'Промяна на настройките на системният адрес';
    $Self->{'Add system address'} = 'Добавяне на нов системен адрес';
    $Self->{'Update system address'} = 'Обновяване ан системният адрес';
    $Self->{'(Click here to add a system email address)'} = '(Натиснете тук, за да добавите нов системен адрес)';
    $Self->{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Всички входящи адреси от този еМейл (До:) ще се разпределят в избраната опашка';
    # charsets
    $Self->{'System Charset Management'} = 'Управление на символният набор';
    $Self->{'Change system charset setting'} = 'Промяна на системният символен набор';
    $Self->{'Add charset'} = 'Добавяне на символен набор';
    $Self->{'Update charset'} = 'Обновяване на символен набор';
    $Self->{'(Click here to add charset)'} = '(Натиснете тук, за да добавите нов символен набор)';
    # states
    $Self->{'System State Management'} = 'Управление на системно състояние';
    $Self->{'Change system state setting'} = 'Промяна на настройките за системно състояние';
    $Self->{'Add state'} = 'Добавяне на състояние';
    $Self->{'Update state'} = 'Обновяване на състояние';
    $Self->{'(Click here to add state)'} = '(Натиснете тук, за да добавите ново системно състояние )';
    # language
    $Self->{'System Language Management'} = 'Управление на езиковите настройки';
    $Self->{'Change system language setting'} = 'Промяна на настройките на системният език';
    $Self->{'Add language'} = 'Добавяне на език';
    $Self->{'Update language'} = 'Обновяване на език';
    $Self->{'(Click here to add language)'} = '(Натиснете тук, за да добавите нов език)';
    # session
    $Self->{'Session Management'} = 'Управление на сесята';
    $Self->{'kill all sessions'} = 'Затваряне на всички текущи сесии';
    $Self->{'kill session'} = 'Затваряне на единична сесия';
    # select box
    $Self->{'Max Rows'} = 'Максимален брой редове';

    # --
    # agent interface
    # --
    # nav bar
    $Self->{Logout} = 'Изход';
    $Self->{QueueView} = 'Преглед на опашката';
    $Self->{PhoneView} = 'Преглед на телефоните';
    $Self->{Utilities} = 'Помощни средства';
    $Self->{AdminArea} = 'Зона-Администратор';
    $Self->{Preferences} = 'Предпочитания';
    $Self->{'Locked tickets'} = 'Заключени билети';
    $Self->{'new message'} = 'ново съобщение';
    $Self->{'You got new message!'} = 'Вие получихте ново съобщение!';
    # ticket history
    $Self->{'History of Ticket'} = 'Хроника на билета';
    # ticket note
    $Self->{'Add note to ticket'} = 'Добавяне на бележка към билета';
    $Self->{'Note type'} = 'Бележката е от тип';
    # queue view
    $Self->{'Tickets shown'} = 'Показани билети';
    $Self->{'Ticket available'} = 'Налични билети';
    $Self->{'Show all'} = 'Показване на всички';
    $Self->{'tickets'} = 'билети';
    $Self->{'All tickets'} = 'Всички билети';
    $Self->{'Ticket escalation!'} = 'Ескалация (увеличаване на приоритета) на билета!';
    $Self->{'Please answer this ticket(s) to get back to the normal queue view!'} = 
     'Моля, отговорете на този билет(и) за да се върнете в нормалния изглед на опашката!';
    # locked tickets
    $Self->{'All locked Tickets'} = 'Всички заключени билети';
    $Self->{'New message'} = 'Ново съобщение';
    $Self->{'New message!'} = 'Ново съобщение!';
    # util
    $Self->{'Hit'} = 'Попадение';
    $Self->{'Total hits'} = 'Общ брой попадения';
    $Self->{'search'} = 'търсене';
    $Self->{'Search again'} = 'Повторно търсене';
    $Self->{'max viewable hits'} = 'максимален брой попадения';
    $Self->{'Utilities/Search'} = 'Помощни средства / Търсене';
    $Self->{'search (e. g. 10*5155 or 105658*)'} = 'търсене (примерно 10*5155 или 105658*)';
    $Self->{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Текстово търсене (примерно "Mar*in" или "Baue*" или "martin+hallo")';
    $Self->{'Customer history search'} = 'Търсене в хрониката на клиента';
    $Self->{'No * possible!'} = 'Не е възможно използване на символ *!';
    $Self->{'Fulltext search'} = 'Текстово търсене';
    $Self->{'Customer history search (e. g. "ID342425").'} = 'Търсене в хрониката на клиента (примерно "ID342425").';
    # compose
    $Self->{'Compose message'} = 'Създаване на съобщение';
    $Self->{'please do not edit!'} = 'моля, не редактирайте!';
    $Self->{'Send mail!'} = 'Изпратете еМейл!';
    $Self->{'wrote'} = 'записано';
    $Self->{'Compose answer for ticket'} = 'Създаване на отговор за този билет';
    $Self->{'Ticket locked!'} = 'Билетът е заключен!';
    $Self->{'A message should have a To: recipient!'} = 'Съобщението трябва да има ДО: т.е. адресант!';
    $Self->{'A message should have a subject!'} = 'Съобщението трябва да има текст в поле "относно"!';
    $Self->{'You need a email address (e. g. customer@example.com) in To:!'} = 'Трябва да има валиден адрес в полето ДО: (примерно support@hebros.bg)!';
    # forward
    $Self->{'Forward article of ticket'} = 'Препрати клаузата за този билет';
    $Self->{'Article type'} = 'Клауза тип';
    $Self->{'Next ticket state'} = 'Следващо състояние за билетът';

    # preferences
    $Self->{'User Preferences'} = 'Потребителски предпочитания';
    $Self->{'Change Password'} = 'Промяна на парола';
    $Self->{'New password'} = 'Нова парола';
    $Self->{'New password again'} = 'Въведете отново паролата';
    $Self->{'Select your custom queues'} = 'Изберете Вашата потребителска опашка';
    $Self->{'Select your QueueView refresh time.'} = 'Изберете Вашето време за обновяване за изгледа на опашката.';
    $Self->{'Select your frontend language.'} = 'Изберете Вашият език.';
    $Self->{'Select your frontend Charset.'} = 'Изберете Вашият символен набор.';
    $Self->{'Select your frontend Theme.'} = 'Anzeigeschema auswРґhlen.';
    $Self->{'Follow up notification'} = 'Известие за наличност на следене на отговорът';
    $Self->{'Send follow up notification'} = 'Изпратете известие за следене на отговорът';
    $Self->{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Изпратете ми известие, ако клиентът изпрати заявка за следене на отговора и аз съм собственик на билета';
    $Self->{'New ticket notification'} = 'Напомняне за нов билет';
    $Self->{'Send new ticket notification'} = 'Изпратете известие за наличност на нов билет';
    $Self->{'Send me a notification if there is a new ticket in my custom queues.'} = 'Изпратете ми известие, ако има нов(и) билет в моята потребителска опашка.';
    $Self->{'Ticket lock timeout notification'} = 'Известие за продължителността на заключване на билетът';
    $Self->{'Send ticket lock timeout notification'} = 'Изпратете известие за продължителността на заключване на билетът';
    $Self->{'Send me a notification if a ticket is unlocked by the system.'} = 'Изпратете ми известие, ако билетът е отключен от системата.';
  
    $Self->{'Frontend Language'} = 'Език';
    $Self->{' 2 minutes'} = ' 2 Минуту';
    $Self->{' 5 minutes'} = ' 5 Минути';
    $Self->{' 7 minutes'} = ' 7 Минути';
    $Self->{'10 minutes'} = '10 Минути';
    $Self->{'15 minutes'} = '15 Минути';
    $Self->{'Move notification'} = 'Известие за преместване';
    $Self->{'Send me a notification if a ticket is moved into a custom queue.'} = 'Изпратете ми известие, ако билетът е преместен в някаква потребителска опашка.';  
    $Self->{'Select your frontend QueueView.'} = 'Изберете език за визуализация съдържанието на опашката.';
    # change priority
    $Self->{'Change priority of ticket'} = 'Промяна на приоритета на билета';
    # some other words ...
    $Self->{'AddLink'} = 'Добавяне на връзка';
    $Self->{'Logout successful. Thank you for using OTRS!'} = 'Изходът е успешен. Благодарим Ви, че използвахте системата.';
#    $Self->{} = '';
#    $Self->{} = '';

    # stats
    $Self->{'Stats'} = 'Статистики';
    $Self->{'Status'} = 'Състояние';
    $Self->{'Graph'} = 'Графика';
    $Self->{'Graphs'} = 'Графики';

    # phone view
    $Self->{'Phone call'} = 'Телефонно обаждане';
    $Self->{'phone call'} = 'телефонно обаждане';
    $Self->{'Phone call at'} = 'Моля, обадете ми се по телефона';
    $Self->{'A message should have a From: recipient!'} = 'Съобщението трябва да има попълнено поле ОТ:';
    $Self->{'You need a email address (e. g. customer@example.com) in From:!'} = 'Трябва да имате еМейл адрес (примерно customer@example.com) в поле ОТ:';

    # states
    $Self->{'new'} = 'нов';
    $Self->{'open'} = 'отворен';
    $Self->{'closed succsessful'} = 'успешно затворен';
    $Self->{'closed unsuccsessful'} = 'неуспешно затворен';
    $Self->{'removed'} = 'премахнат';
    # article types
    $Self->{'email-external'} = 'външен еМейл';
    $Self->{'email-internal'} = 'вътрешен еМейл';
    $Self->{'note-internal'} = 'вътрешна бележка';
    $Self->{'note-external'} = 'външна бележка';
    $Self->{'note-report'} = 'бележка отчет';

    # priority
    $Self->{'very low'} = 'много нисък';
    $Self->{'low'} = 'нисък';
    $Self->{'normal'} = 'нормален';
    $Self->{'high'} = 'висок';
    $Self->{'very high'} = 'много висок';

    # --
    # customer panel
    # --
    $Self->{'My Tickets'} = 'Моите билети';
    $Self->{'Welcome'} = 'Добре дошли';

    return;
}
# --

1;

