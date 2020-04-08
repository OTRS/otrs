# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2010 Milorad Jovanovic <j.milorad at gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::sr_Cyrl;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # $$START$$
    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.9962749746021;

    # csv separator
    $Self->{Separator}         = ';';

    $Self->{DecimalSeparator}  = ',';
    $Self->{ThousandSeparator} = ' ';
    $Self->{Translation} = {

        # Template: AdminACL
        'ACL Management' => 'Управљање ACL',
        'Actions' => 'Акције',
        'Create New ACL' => 'Креирај нову ACL листу',
        'Deploy ACLs' => 'Распореди ACL листе',
        'Export ACLs' => 'Извези ACL листе',
        'Filter for ACLs' => 'Филтер за ACL',
        'Just start typing to filter...' => 'Почните са куцањем за филтер...',
        'Configuration Import' => 'Увоз конфигурације',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Овде можете послати конфигурациону датотеку за увоз ACL листа у ваш систем. Датотека мора бити у .yml формату ако се извози од стране ACL едитор модула.',
        'This field is required.' => 'Ово поље је обавезно.',
        'Overwrite existing ACLs?' => 'Препиши преко постојећих ACL листа?',
        'Upload ACL configuration' => 'Отпреми ACL конфигурацију',
        'Import ACL configuration(s)' => 'Увези ACL конфигурацију',
        'Description' => 'Опис',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Да бисте креирали нову ACL можете или увести ACL листе које су извезене из другог система или направити комплетно нову.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Промене на ACL листама овде само утичу на понашање система, уколико накнадно употребите све ACL податке.',
        'ACLs' => 'ACL листе',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Напомена: Ова табела представља редослед извршавања у ACL листама. Ако је потребно да промените редослед којим се извршавају ACL листе, молимо промените имена тих ACL листа.',
        'ACL name' => 'Назив ACL',
        'Comment' => 'Коментар',
        'Validity' => 'Важност',
        'Export' => 'Извоз',
        'Copy' => 'Копија',
        'No data found.' => 'Ништа није пронађено.',
        'No matches found.' => 'Ништа није пронађено.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Уреди ACL %s',
        'Edit ACL' => 'Уреди ACL',
        'Go to overview' => 'Иди на преглед',
        'Delete ACL' => 'Обриши ACL',
        'Delete Invalid ACL' => 'Обриши неважећу ACL',
        'Match settings' => 'Усклади подешавања',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Подесите усклађене критеријуме за ову ACL листу. Користите Properties тако да одговара постојећем приказу екрана или PropertiesDatabase да би одговарао атрибутима постојећег тикета који су у бази података.',
        'Change settings' => 'Промени подешавања',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Подесите оно што желите да мењате ако се критеријуми слажу. Имајте на уму да је \'Possible\' бела листа, \'PossibleNot\' црна листа.',
        'Check the official %sdocumentation%s.' => 'Прочитајте званичну %sдокументацију%s.',
        'Show or hide the content' => 'Покажи или сакриј садржај',
        'Edit ACL Information' => 'Уреди информације о ACL',
        'Name' => 'Назив',
        'Stop after match' => 'Заустави после поклапања',
        'Edit ACL Structure' => 'Уреди структуру ACL',
        'Save ACL' => 'Сачувај ACL',
        'Save' => 'Сачувај',
        'or' => 'или',
        'Save and finish' => 'Сачувај и заврши',
        'Cancel' => 'Откажи',
        'Do you really want to delete this ACL?' => 'Да ли стварно желите да обришете ову ACL листу?',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Креирајте нову ACL листу подношењем обрасца са подацима. Након креирања ACL листе, бићете у могућности да додате конфигурационе ставке у моду измене.',

        # Template: AdminAppointmentCalendarManage
        'Calendar Management' => 'Управљање календарима',
        'Add Calendar' => 'Додај календар',
        'Edit Calendar' => 'Измени календар',
        'Calendar Overview' => 'Преглед календара',
        'Add new Calendar' => 'Додај нови календар',
        'Import Appointments' => 'Увези термине',
        'Calendar Import' => 'Увоз календара',
        'Here you can upload a configuration file to import a calendar to your system. The file needs to be in .yml format as exported by calendar management module.' =>
            'Овде можете учитати конфигурациону датотеку за увоз календара у ваш систем. Датотека мора бити у .yml формату извезена од стране модула за управљање календарима.',
        'Overwrite existing entities' => 'Напиши преко постојећих ентитета',
        'Upload calendar configuration' => 'Учитај конфигурацију календара',
        'Import Calendar' => 'Увези календар',
        'Filter for Calendars' => 'Филтер за календаре',
        'Filter for calendars' => 'Филтер за календаре',
        'Depending on the group field, the system will allow users the access to the calendar according to their permission level.' =>
            'У зависности од поља групе, систем ће дозволити приступ календару оператерима према њиховом нивоу приступа.',
        'Read only: users can see and export all appointments in the calendar.' =>
            'RO: оператери могу прегледати и експортовати све термине у календару.',
        'Move into: users can modify appointments in the calendar, but without changing the calendar selection.' =>
            'Премести у: оператери могу модификовати термине у календару, али без промене ком календару припадају.',
        'Create: users can create and delete appointments in the calendar.' =>
            'Креирање: оператери могу креирати и брисати термине у календару.',
        'Read/write: users can manage the calendar itself.' => 'RW: оператери могу администрирати и сам календар.',
        'Group' => 'Група',
        'Changed' => 'Измењено',
        'Created' => 'Креирано',
        'Download' => 'Преузимање',
        'URL' => 'Адреса',
        'Export calendar' => 'Извези календар',
        'Download calendar' => 'Преузми календар',
        'Copy public calendar URL' => 'Ископирај јавну адресу календара (URL)',
        'Calendar' => 'Календар',
        'Calendar name' => 'Назив календара',
        'Calendar with same name already exists.' => 'Календар са истим називом већ постоји.',
        'Color' => 'Боја',
        'Permission group' => 'Група приступа',
        'Ticket Appointments' => 'Термини тикета',
        'Rule' => 'Правило',
        'Remove this entry' => 'Уклони овај унос',
        'Remove' => 'Уклони',
        'Start date' => 'Датум почетка',
        'End date' => 'Датум краја',
        'Use options below to narrow down for which tickets appointments will be automatically created.' =>
            'Користећи опције испод изаберите за које тикете ће термини бити аутоматски креирани.',
        'Queues' => 'Редови',
        'Please select a valid queue.' => 'Молимо да одаберете важећи ред.',
        'Search attributes' => 'Атрибути претраге',
        'Add entry' => 'Додај унос',
        'Add' => 'Додати',
        'Define rules for creating automatic appointments in this calendar based on ticket data.' =>
            'Дефинишите правила за креирање аутоматских термина у овом календару на основу тикета.',
        'Add Rule' => 'Додај правило',
        'Submit' => 'Пошаљи',

        # Template: AdminAppointmentImport
        'Appointment Import' => 'Увоз термина',
        'Go back' => 'Иди назад',
        'Uploaded file must be in valid iCal format (.ics).' => 'Послати фајл мора бити у исправном iCal формату (.ics).',
        'If desired Calendar is not listed here, please make sure that you have at least \'create\' permissions.' =>
            'Уколико жељени календар није излистан, проверите да ли имате ниво приступа \'креирање\' за групу календара.',
        'Upload' => 'Отпремање',
        'Update existing appointments?' => 'Освежи постојеће термине?',
        'All existing appointments in the calendar with same UniqueID will be overwritten.' =>
            'Сви постојећи термини у календару са истим UniqueID пољем ће бити пребрисани.',
        'Upload calendar' => 'Пошаљи календар',
        'Import appointments' => 'Увези термине',

        # Template: AdminAppointmentNotificationEvent
        'Appointment Notification Management' => 'Управљање обавештењима о терминима',
        'Add Notification' => 'Додај Обавештење',
        'Edit Notification' => 'Уреди обавештење',
        'Export Notifications' => 'Обавештења о извозу',
        'Filter for Notifications' => 'Филтер за обавештења',
        'Filter for notifications' => 'Филтер за обавештења',
        'Here you can upload a configuration file to import appointment notifications to your system. The file needs to be in .yml format as exported by the appointment notification module.' =>
            'Овде можете послати конфигурациону датотеку за увоз обавештења о термину у ваш систем. Датотека мора бити у истом .yml формату који је могуће добити извозом у екрану управљања обавештењима о терминима.',
        'Overwrite existing notifications?' => 'Препиши преко постојећих обавештења?',
        'Upload Notification configuration' => 'Отпреми конфигурацију обавештавања',
        'Import Notification configuration' => 'Увези конфигурацију обавештења',
        'List' => 'Листа',
        'Delete' => 'Избрисати',
        'Delete this notification' => 'Обриши ово обавештење',
        'Show in agent preferences' => 'Приказано у оператерским поставкама',
        'Agent preferences tooltip' => 'Порука за оператерска подешавања',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            'Ова порука ће бити приказана на екрану оператерских подешавања као испомоћ.',
        'Toggle this widget' => 'Преклопи овај додатак',
        'Events' => 'Догађаји',
        'Event' => 'Догађај',
        'Here you can choose which events will trigger this notification. An additional appointment filter can be applied below to only send for appointments with certain criteria.' =>
            'Овде можете изабрати који догађаји ће покренути обавештавање. Додатни филтер за термине може бити примењен ради слања само за термине по одређеном критеријуму.',
        'Appointment Filter' => 'Филтер термина',
        'Type' => 'Тип',
        'Title' => 'Наслов',
        'Location' => 'Локација',
        'Team' => 'Тим',
        'Resource' => 'Ресурс',
        'Recipients' => 'Примаоци',
        'Send to' => 'Пошаљи за',
        'Send to these agents' => 'Пошаљи овим оператерима',
        'Send to all group members (agents only)' => 'Пошаљи свим члановима групе (само оператерима)',
        'Send to all role members' => 'Пошаљи свим припадницима улоге',
        'Send on out of office' => 'Пошаљи и кад је ван канцеларије',
        'Also send if the user is currently out of office.' => 'Такође пошаљи и када је корисник ван канцеларије.',
        'Once per day' => 'Једном дневно',
        'Notify user just once per day about a single appointment using a selected transport.' =>
            'Обавести корисника само једном дневно о појединачном термину коришћењем изабраног транспорта.',
        'Notification Methods' => 'Методе обавештавања',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            'Ово су могуће методе које се могу користити за слање обавештења сваком примаоцу. Молимо вас да изаберете бар једну методу од понуђених.',
        'Enable this notification method' => 'Активирај овај метод обавештавања',
        'Transport' => 'Транспорт',
        'At least one method is needed per notification.' => 'Неопходан је најмање један метод по обавештењу.',
        'Active by default in agent preferences' => 'Подразумевано активно у оператерским поставкама',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            'Ово је подразумевана вредност за придружене оператере примаоце који за ово обавештење у својим поставкама нису још направили избор. Ако је бокс активиран, обавештење ће бити послато таквим оператерима.',
        'This feature is currently not available.' => 'Ово својство тренутно није доступно.',
        'Upgrade to %s' => 'Унапреди на %s',
        'Please activate this transport in order to use it.' => 'Молимо активирајте овај транспорт пре коришћења.',
        'No data found' => 'Ништа није пронађено',
        'No notification method found.' => 'Није пронађена метода обавештавања.',
        'Notification Text' => 'Текст обавештења',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Овај језик није присутан или укључен на систему. Ово обавештење може бити избрисано уколико више није неопходно.',
        'Remove Notification Language' => 'Уклони језик обавештења',
        'Subject' => 'Предмет',
        'Text' => 'Текст',
        'Message body' => 'Садржај поруке',
        'Add new notification language' => 'Уклони нови језик обавештења',
        'Save Changes' => 'Сачувај промене',
        'Tag Reference' => 'Референца ознаке',
        'Notifications are sent to an agent.' => 'Обавештење ће бити послато оператеру.',
        'You can use the following tags' => 'Можете користити следеће ознаке',
        'To get the first 20 character of the appointment title.' => 'Да видите првих 20 карактера наслова термина.',
        'To get the appointment attribute' => 'Да видите атрибуте термина',
        ' e. g.' => ' нпр.',
        'To get the calendar attribute' => 'Да видите атрибуте календара',
        'Attributes of the recipient user for the notification' => 'Атрибути корисника примаоца за обавештење',
        'Config options' => 'Конфигурационе опције',
        'Example notification' => 'Пример обавештења',

        # Template: AdminAppointmentNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Имејл адреса додатног примаоца',
        'This field must have less then 200 characters.' => 'Ово поље не сме бити дуже од 200 карактера.',
        'Article visible for customer' => 'Чланак видљив клијентима',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            'Чланак је креиран и обавештење послато клијенту или на другу имејл адресу.',
        'Email template' => 'Имејл шаблон',
        'Use this template to generate the complete email (only for HTML emails).' =>
            'Употребите овај шаблон за генерисање комплетног имејла (само за HTML имејлове).',
        'Enable email security' => 'Активирајте безбедност имејла',
        'Email security level' => 'Ниво безбедности имејла',
        'If signing key/certificate is missing' => 'Ако потписивање кључа/сертификата недостаје',
        'If encryption key/certificate is missing' => 'Ако кључа/сертификат за шифрирање недостаје',

        # Template: AdminAttachment
        'Attachment Management' => 'Управљање прилозима',
        'Add Attachment' => 'Додај прилог',
        'Edit Attachment' => 'Уреди прилог',
        'Filter for Attachments' => 'Филтер за прилоге',
        'Filter for attachments' => 'Филтер за прилоге',
        'Filename' => 'Назив датотеке',
        'Download file' => 'Преузми датотеку',
        'Delete this attachment' => 'Обриши овај прилог',
        'Do you really want to delete this attachment?' => 'Да ли стварно желите да обришете овај прилог?',
        'Attachment' => 'Прилог',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Управљање аутоматским одговорима',
        'Add Auto Response' => 'Додај Аутоматски Одговор',
        'Edit Auto Response' => 'Уреди Аутоматски Одговор',
        'Filter for Auto Responses' => 'Филтер за аутоматске одговоре',
        'Filter for auto responses' => 'Филтер за аутоматске одговоре',
        'Response' => 'Одговор',
        'Auto response from' => 'Аутоматски одговор од',
        'Reference' => 'Референца',
        'To get the first 20 character of the subject.' => 'Да видите првих 20 слова предмета.',
        'To get the first 5 lines of the email.' => 'Да видите првих 5 линија имејла.',
        'To get the name of the ticket\'s customer user (if given).' => 'Да прибавите назив клијента корисника за тикет (ако је дат).',
        'To get the article attribute' => 'Да видите атрибуте чланка',
        'Options of the current customer user data' => 'Опције података о актуелном клијенту кориснику',
        'Ticket owner options' => 'Опције власника тикета',
        'Ticket responsible options' => 'Опције одговорног за тикет',
        'Options of the current user who requested this action' => 'Опције актуелног корисника који је тражио ову акцију',
        'Options of the ticket data' => 'Опције података о тикету',
        'Options of ticket dynamic fields internal key values' => 'Опције за вредности интерних кључева динамичких поља тикета',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Опције за приказане вредности динамичких поља тикета, корисно за поља Dropdown и Multiselect',
        'Example response' => 'Пример одговора',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Управљање сервисима у облаку',
        'Support Data Collector' => 'Сакупљач података подршке',
        'Support data collector' => 'Сакупљач података подршке',
        'Hint' => 'Савет',
        'Currently support data is only shown in this system.' => 'Актуелни подаци подршке се приказују само на овом систему.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Препоручује се да ове податке пошаљете OTRS групи да би сте добили бољу подршку.',
        'Configuration' => 'Конфигурација',
        'Send support data' => 'Пошаљи податке за подршку',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Ово ће омогућити систему да пошаље додатне информације о подацима подршке OTRS групи.',
        'Update' => 'Ажурирање',
        'System Registration' => 'Регистрација система',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Да би сте омогућили слање података, молимо вас да региструјете ваш систем у OTRS групи или да ажурирате информације системске регистрације (будите сигурни да сте активирали опцију "Пошаљи податке за подршку")',
        'Register this System' => 'Региструј овај систем',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'Системска регистрације је деактивирана за ваш систем. Молимо да проверите вашу конфигурацију.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Регистрација система је услуга OTRS групе, која обезбеђује многе предности!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Напомињемо да коришћење OTRS сервиса у облаку захтевају да систем буде регистрован.',
        'Register this system' => 'Региструј овај систем',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Овде можете подесити да доступни сервиси у облаку користе сигурну комуникацију преко %s.',
        'Available Cloud Services' => 'Расположиви сервиси у облаку',

        # Template: AdminCommunicationLog
        'Communication Log' => 'Комуникациони лог',
        'Time Range' => 'Временски опсег',
        'Show only communication logs created in specific time range.' =>
            'Прикажи само комуникационе логове креиране у одређеном временском периоду.',
        'Filter for Communications' => 'Филтер за комуникације',
        'Filter for communications' => 'Филтер за комуникације',
        'In this screen you can see an overview about incoming and outgoing communications.' =>
            'У овом екрану можете прегледати све долазне и одлазне комуникације.',
        'You can change the sort and order of the columns by clicking on the column header.' =>
            'Можете изменити редослед сортирања колона кликом на наслове колона.',
        'If you click on the different entries, you will get redirected to a detailed screen about the message.' =>
            'Уколико кликнете на појединачне ставке, бићете редиректовани на екран детаља у вези поруке.',
        'Status for: %s' => 'Статус за: %s',
        'Failing accounts' => 'Налози са грешкама',
        'Some account problems' => 'Пар проблема са налозима',
        'No account problems' => 'Без проблема са налозима',
        'No account activity' => 'Без активности налога',
        'Number of accounts with problems: %s' => 'Број налога са проблемима: %s',
        'Number of accounts with warnings: %s' => 'Број налога са упозорењима: %s',
        'Failing communications' => 'Неуспеле комуникације',
        'No communication problems' => 'Без проблема са комуникацијама',
        'No communication logs' => 'Без комуникационих логова',
        'Number of reported problems: %s' => 'Број пријављених проблема: %s',
        'Open communications' => 'Отворене комуникације',
        'No active communications' => 'Без активних комуникација',
        'Number of open communications: %s' => 'Број отворених комуникација: %s',
        'Average processing time' => 'Просечно време обраде',
        'List of communications (%s)' => 'Листа комуникација (%s)',
        'Settings' => 'Подешавања',
        'Entries per page' => 'Уноса по страни',
        'No communications found.' => 'Нису пронађене комуникације.',
        '%s s' => '%s с',

        # Template: AdminCommunicationLogAccounts
        'Account Status' => 'Статус налога',
        'Back to overview' => 'Иди назад на преглед',
        'Filter for Accounts' => 'Филтер за налоге',
        'Filter for accounts' => 'Филтер за налоге',
        'You can change the sort and order of those columns by clicking on the column header.' =>
            'Можете изменити редослед сортирања колона кликом на наслове колона.',
        'Account status for: %s' => 'Статус налога за: %s',
        'Status' => 'Статус',
        'Account' => 'Налог',
        'Edit' => 'Уредити',
        'No accounts found.' => 'Нису пронађени налози.',
        'Communication Log Details (%s)' => 'Детаљи комуникационог лога (%s)',
        'Direction' => 'Смер',
        'Start Time' => 'Време почетка',
        'End Time' => 'Време завршетка',
        'No communication log entries found.' => 'Нису пронађене ставке комуникационог лога.',

        # Template: AdminCommunicationLogCommunications
        'Duration' => 'Трајање',

        # Template: AdminCommunicationLogObjectLog
        '#' => '#',
        'Priority' => 'Приоритет',
        'Module' => 'Модул',
        'Information' => 'Информација',
        'No log entries found.' => 'Нису пронађене ставке лога.',

        # Template: AdminCommunicationLogZoom
        'Detail view for %s communication started at %s' => 'Детаљни приказ за комуникацију %s започету у %s',
        'Filter for Log Entries' => 'Филтер за лог ставке',
        'Filter for log entries' => 'Филтер за лог ставке',
        'Show only entries with specific priority and higher:' => 'Прикажи само ставке са одговарајућим приоритетом и више:',
        'Communication Log Overview (%s)' => 'Преглед комуникационих логова (%s)',
        'No communication objects found.' => 'Нису пронађени комуникациони објекти.',
        'Communication Log Details' => 'Детаљи комуникационог лога',
        'Please select an entry from the list.' => 'Молимо изаберите ставку из листе.',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Управљање клијентима',
        'Add Customer' => 'Додај клијента',
        'Edit Customer' => 'Измени клијента',
        'Search' => 'Тражи',
        'Wildcards like \'*\' are allowed.' => 'Џокерски знаци као \'*\' су дозвољени.',
        'Select' => 'Изабери',
        'List (only %s shown - more available)' => 'Листа (само %s је приказано - расположиво више)',
        'total' => 'укупно',
        'Please enter a search term to look for customers.' => 'Молимо унесите појам претраге за проналажење клијената.',
        'Customer ID' => 'ID клијента',
        'Please note' => 'Напомињемо',
        'This customer backend is read only!' => 'Овај извор клијената се може само прегледати.',

        # Template: AdminCustomerGroup
        'Manage Customer-Group Relations' => 'Управљање релацијама клијент-група',
        'Notice' => 'Напомена',
        'This feature is disabled!' => 'Ова функција је искључена!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Употребите ову функцију ако желите да дефинишете групне дозволе за клијенте.',
        'Enable it here!' => 'Активирајте је овде!',
        'Edit Customer Default Groups' => 'Уреди подразумеване групе за клијента',
        'These groups are automatically assigned to all customers.' => 'Ове групе су аутоматски додељене свим клијентима.',
        'You can manage these groups via the configuration setting "CustomerGroupCompanyAlwaysGroups".' =>
            'Можете управљати овим групама преко конфигурационог подешавања CustomerGroupCompanyAlwaysGroups.',
        'Filter for Groups' => 'Филтер за групе',
        'Select the customer:group permissions.' => 'Изабери клијент:група дозволе.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Ако ништа није изабрано, онда нема дозвола у овој групи (тикети неће бити доступни клијенту).',
        'Search Results' => 'Резултат претраге',
        'Customers' => 'Клијенти',
        'Groups' => 'Групе',
        'Change Group Relations for Customer' => 'Промени везе са групама за клијента',
        'Change Customer Relations for Group' => 'Промени везе са клијентима за групу',
        'Toggle %s Permission for all' => 'Промени %s дозволе за све',
        'Toggle %s permission for %s' => 'Промени %s дозволе за %s',
        'Customer Default Groups:' => 'Подразумеване групе за клијента:',
        'No changes can be made to these groups.' => 'На овим групама промене нису могуће.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Приступ ограничен само на читање за тикете у овим групама/редовима.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Приступ без ограничења за тикете у овим групама/редовима.',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Управљање клијентима клијентима',
        'Add Customer User' => 'Додај клијента корисника',
        'Edit Customer User' => 'Уреди клијента корисника',
        'Back to search results' => 'Врати се на резултате претраге',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Клијент клијент треба да има клијентски историјат и да се пријави преко клијентског панела.',
        'List (%s total)' => 'Листа (%s укупно)',
        'Username' => 'Корисничко име',
        'Email' => 'Имејл',
        'Last Login' => 'Последња пријава',
        'Login as' => 'Пријави се као',
        'Switch to customer' => 'Пређи на клијента',
        'This customer backend is read only, but the customer user preferences can be changed!' =>
            'Овај извор клијената се може само прегледати, али клијентска подешавања се могу изменити!',
        'This field is required and needs to be a valid email address.' =>
            'Ово је обавезно поље и мора да буде исправна имејл адреса.',
        'This email address is not allowed due to the system configuration.' =>
            'Ова имејл адреса није дозвољена због системске конфигурације.',
        'This email address failed MX check.' => 'Ова имејл адреса не задовољава MX проверу.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS проблем, молимо проверите конфигурацију и грешке у логу.',
        'The syntax of this email address is incorrect.' => 'Синтакса ове имејл адресе је неисправна.',
        'This CustomerID is invalid.' => 'Овај ID клијента је неисправан.',
        'Effective Permissions for Customer User' => 'Ефективне дозволе за клијент корисника',
        'Group Permissions' => 'Дозволе за групу',
        'This customer user has no group permissions.' => 'Овај клијент корисник нема дозволе за групе.',
        'Table above shows effective group permissions for the customer user. The matrix takes into account all inherited permissions (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Табела изнад приказује ефективне дозволе за групе клијент корисника. Матрица узима у обзир све наслеђене дозволе (нпр. путем клијент група). Напомена: табела не узима у обзир измене на овој форми без слања исте.',
        'Customer Access' => 'Приступ клијенту',
        'Customer' => 'Клијент',
        'This customer user has no customer access.' => 'Овај клијент корисник нема приступ клијенту.',
        'Table above shows granted customer access for the customer user by permission context. The matrix takes into account all inherited access (e.g. via customer groups). Note: The table does not consider changes made to this form without submitting it.' =>
            'Табела изнад приказује додељени приступ клијенту за клијент корисника према контексту дозволе. Матрица узима у обзир сав наслеђени приступ (нпр. путем клијент група). Напомена: табела не узима у обзир измене на овој форми без слања исте.',

        # Template: AdminCustomerUserCustomer
        'Manage Customer User-Customer Relations' => 'Управљање релацијама клијент корисник-клијент',
        'Select the customer user:customer relations.' => 'Одаберите клијент корисник:клијент релације.',
        'Customer Users' => 'Клијенти корисници',
        'Change Customer Relations for Customer User' => 'Промени релације са клијентима за клијент корисника',
        'Change Customer User Relations for Customer' => 'Промени релације са клијент корисницима за клијента',
        'Toggle active state for all' => 'Промени активно стање за све',
        'Active' => 'Активно',
        'Toggle active state for %s' => 'Промени активно стање за %s',

        # Template: AdminCustomerUserGroup
        'Manage Customer User-Group Relations' => 'Управљање релацијама клијент корисник-група',
        'Just use this feature if you want to define group permissions for customer users.' =>
            'Употребите ову функцију ако желите да дефинишете групне дозволе за клијент кориснике.',
        'Edit Customer User Default Groups' => 'Уреди подразумеване групе за клијент кориснике',
        'These groups are automatically assigned to all customer users.' =>
            'Ове групе су аутоматски додељене свим клијент корисницима.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Можете управљати овим групама преко конфигурационих подешавања CustomerGroupAlwaysGroups.',
        'Filter for groups' => 'Филтер за групе',
        'Select the customer user - group permissions.' => 'Изабери клијент корисник:група дозволе.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer user).' =>
            'Ако ништа није изабрано, онда нема дозвола у овој групи (тикети неће бити доступни клијент кориснику).',
        'Customer User Default Groups:' => 'Подразумеване групе за клијент корисника:',

        # Template: AdminCustomerUserService
        'Manage Customer User-Service Relations' => 'Управљање релацијама клијент корисници-сервиси',
        'Edit default services' => 'Уреди подразумеване услуге',
        'Filter for Services' => 'Филтер за сервисе',
        'Filter for services' => 'Филтер за сервисе',
        'Services' => 'Услуге',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Управљање динамичким пољима',
        'Add new field for object' => 'Додај ново поље објекту',
        'Filter for Dynamic Fields' => 'Филтер за динамичка поља',
        'Filter for dynamic fields' => 'Филтер за динамичка поља',
        'More Business Fields' => 'Више пословних поља',
        'Would you like to benefit from additional dynamic field types for businesses? Upgrade to %s to get access to the following field types:' =>
            'Да ли желите могућност додатних пословних динамичких поља? Унапредите на %s за приступ следећим врстама поља:',
        'Database' => 'База података',
        'Use external databases as configurable data sources for this dynamic field.' =>
            'Користите екстерне базе података као извор података за ово динамичко поље.',
        'Web service' => 'Веб сервис',
        'External web services can be configured as data sources for this dynamic field.' =>
            'Екстерни веб сервиси се могу конфигурисати као извор података за ово динамичко поље.',
        'Contact with data' => 'Контакт са подацима',
        'This feature allows to add (multiple) contacts with data to tickets.' =>
            'Ова функција вам омогућава да додате (вишеструке) контакте са подацима тикетима.',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'За додавање новог поља изаберите тип поља из једне од листа објеката. Објект дефинише границе поља и после креирања поља се не може мењати.',
        'Dynamic Fields List' => 'Листа динамичких поља',
        'Dynamic fields per page' => 'Број динамичких поља по страни',
        'Label' => 'Ознака',
        'Order' => 'Сортирање',
        'Object' => 'Објекат',
        'Delete this field' => 'Обриши ово поље',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Динамичка поља',
        'Go back to overview' => 'Иди назад на преглед',
        'General' => 'Опште',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ово поље је обавезно и може садржати само од слова и бројеве.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Мора бити јединствено и прихвата само слова и бројеве.',
        'Changing this value will require manual changes in the system.' =>
            'Измена овог поља ће захтевати ручне промене у систему.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ово је назив који ће се приказивати на екранима где је поље активно.',
        'Field order' => 'Редослед поља',
        'This field is required and must be numeric.' => 'Ово поље је обавезно и мора бити нумеричко.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ово је редослед по ком ће поља бити приказана на екранима где су активна.',
        'Is not possible to invalidate this entry, all config settings have to be changed beforehand.' =>
            'Није могуће обележити ову ставку као неважећу, сва подешавања морају бити прво измењена.',
        'Field type' => 'Тип поља',
        'Object type' => 'Тип објекта',
        'Internal field' => 'Интерно поље',
        'This field is protected and can\'t be deleted.' => 'Ово поље је заштићено и не може бити обрисано.',
        'This dynamic field is used in the following config settings:' =>
            'Ово динамичко поље је употребљено у следећим поставкама:',
        'Field Settings' => 'Подешавање поља',
        'Default value' => 'Подразумевана вредност',
        'This is the default value for this field.' => 'Ово је подразумевана вредност за ово поље.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Подразумевана разлика датума',
        'This field must be numeric.' => 'Ово поље мора бити нумеричко.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Разлика (у секундама) од САДА, за израчунавање подразумеване вредности поља (нпр. 3600 или -60).',
        'Define years period' => 'Дефиниши период у годинама',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Активирајте ову опцију ради дефинисања фиксног опсега година (у будућност и прошлост) за приказ при избору година у пољу.',
        'Years in the past' => 'Године у прошлости',
        'Years in the past to display (default: 5 years).' => 'Године у прошлости за приказ (подразумевано је 5 година).',
        'Years in the future' => 'Године у будућности',
        'Years in the future to display (default: 5 years).' => 'Године у будућности за приказ (подразумевано је 5 година).',
        'Show link' => 'Покажи везу',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Овде можете да унесете опциону HTTP везу за вредност поља у екранима прегледа.',
        'If special characters (&, @, :, /, etc.) should not be encoded, use \'url\' instead of \'uri\' filter.' =>
            'Уколико специјални карактери (&, @, :, /, итд) не треба да буду енкодирани, користите \'url\' филтер уместо \'uri\'.',
        'Example' => 'Пример',
        'Link for preview' => 'Веза за преглед',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            'Ако је попуњено, овај URL ће се користити за преглед који се приказује када је показивач изнад везе у детаљима тикета. Узмите у обзир, да би ово радило, нормално URL поље изнад, мора такође да буде попуњено.',
        'Restrict entering of dates' => 'Ограничи унос датума',
        'Here you can restrict the entering of dates of tickets.' => 'Овде можете ограничити унос датума за тикете.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Могуће вредности',
        'Key' => 'Кључ',
        'Value' => 'Вредност',
        'Remove value' => 'Уклони вредност',
        'Add value' => 'Додај вредност',
        'Add Value' => 'Додај Вредност',
        'Add empty value' => 'Додај без вредности',
        'Activate this option to create an empty selectable value.' => 'Активирај ову опцију за креирање избора без вредности.',
        'Tree View' => 'Приказ у облику стабла',
        'Activate this option to display values as a tree.' => 'Активирај ову опцију за приказ вредности у облику стабла.',
        'Translatable values' => 'Преводљиве вредности',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Ако активирате ову опцију вредности ће бити преведене на изабрани језик.',
        'Note' => 'Напомена',
        'You need to add the translations manually into the language translation files.' =>
            'Ове преводе морате ручно додати у датотеке превода.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Број редова',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Унеси висину (у линијама) за ово поље у моду обраде.',
        'Number of cols' => 'Број колона',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Унеси ширину (у знаковима) за ово поље у моду уређивања.',
        'Check RegEx' => 'Провери регуларне изразе',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            'Овде можете да дефинишете регуларни израз за проверу вредности. Израз ће бити извршен са модификаторима за xms.',
        'RegEx' => 'Регуларни израз',
        'Invalid RegEx' => 'Неважећи регуларни израз',
        'Error Message' => 'Порука о грешци',
        'Add RegEx' => 'Додај регуларни израз',

        # Template: AdminEmail
        'Admin Message' => 'Административна порука',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Са овим модулом, администратори могу слати поруке оператерима, групама или припадницима улоге.',
        'Create Administrative Message' => 'Креирај административну поруку',
        'Your message was sent to' => 'Ваша порука је послата',
        'From' => 'Од',
        'Send message to users' => 'Пошаљи поруку корисницима',
        'Send message to group members' => 'Пошаљи поруку члановима групе',
        'Group members need to have permission' => 'Чланови групе треба да имају дозволу',
        'Send message to role members' => 'Пошаљи поруку припадницима улоге',
        'Also send to customers in groups' => 'Такође пошаљи клијентима у групама',
        'Body' => 'Садржај',
        'Send' => 'Шаљи',

        # Template: AdminGenericAgent
        'Generic Agent Job Management' => 'Управљање пословима генеричког оператера',
        'Edit Job' => 'Уреди посао',
        'Add Job' => 'Додај посао',
        'Run Job' => 'Покрени посао',
        'Filter for Jobs' => 'Филтер за послове',
        'Filter for jobs' => 'Филтер за послове',
        'Last run' => 'Последње покретање',
        'Run Now!' => 'Покрени сад!',
        'Delete this task' => 'Обриши овај посао',
        'Run this task' => 'Покрени овај посао',
        'Job Settings' => 'Подешавање посла',
        'Job name' => 'Назив посла',
        'The name you entered already exists.' => 'Назив које сте унели већ постоји.',
        'Automatic Execution (Multiple Tickets)' => 'Аутоматско извршење (вишеструки тикети)',
        'Execution Schedule' => 'Распоред извршења',
        'Schedule minutes' => 'Планирано минута',
        'Schedule hours' => 'Планирано сати',
        'Schedule days' => 'Планирано дана',
        'Automatic execution values are in the system timezone.' => 'Времена аутоматског извршавања су у системској временској зони.',
        'Currently this generic agent job will not run automatically.' =>
            'Тренутно овај посао генерички оператера неће бити извршен аутоматски.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Да бисте омогућили аутоматско извршавање изаберите бар једну вредност од минута, сати и дана!',
        'Event Based Execution (Single Ticket)' => 'Извршење засновано на догађају (појединачни тикет)',
        'Event Triggers' => 'Окидачи догађаја',
        'List of all configured events' => 'Листа свих конфигурисаних догађаја',
        'Delete this event' => 'Обриши овај догађај',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Додатно или алтернативно за периодично извршење, можете дефинисати догађаје тикета који ће покренути овај посао.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Уколико је догађај тикета отказао, биће примењен тикет филтер да потврди да ли тикет одговара. Само тада ће се посао на тикету покренути.',
        'Do you really want to delete this event trigger?' => 'Да ли стварно желите да обришете овај окидач догађаја?',
        'Add Event Trigger' => 'Додај окидач догађаја',
        'To add a new event select the event object and event name' => 'За додавање новог догађаја изаберите објекат и назив догађаја',
        'Select Tickets' => 'Изабери тикете',
        '(e. g. 10*5155 or 105658*)' => 'нпр. 10*5144 или 105658*',
        '(e. g. 234321)' => 'нпр. 234321',
        'Customer user ID' => 'ID клијента корисника',
        '(e. g. U5150)' => '(нпр. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Текстуална претрага у чланку (нпр. "Mar*in" или "Baue*").',
        'To' => 'За',
        'Cc' => 'Cc',
        'Service' => 'Услуга',
        'Service Level Agreement' => 'Споразум о нивоу услуге',
        'Queue' => 'Ред',
        'State' => 'Стање',
        'Agent' => 'Оператер',
        'Owner' => 'Власник',
        'Responsible' => 'Одговоран',
        'Ticket lock' => 'Тикет закључан',
        'Dynamic fields' => 'Динамичка поља',
        'Add dynamic field' => 'Додај динамичко поље',
        'Create times' => 'Времена отварања',
        'No create time settings.' => 'Нема подешавања времена отварања.',
        'Ticket created' => 'Тикет отворен',
        'Ticket created between' => 'Тикет отворен између',
        'and' => 'и',
        'Last changed times' => 'Време задње промене',
        'No last changed time settings.' => 'Није подешено време последње промене.',
        'Ticket last changed' => 'Време задње промене тикета',
        'Ticket last changed between' => 'Задња промена тикета између',
        'Change times' => 'Промена времена',
        'No change time settings.' => 'Нема промене времена.',
        'Ticket changed' => 'Промењен тикет',
        'Ticket changed between' => 'Тикет промењен између',
        'Last close times' => '',
        'No last close time settings.' => '',
        'Ticket last close' => '',
        'Ticket last close between' => '',
        'Close times' => 'Времена затварања',
        'No close time settings.' => 'Није подешено време затварања.',
        'Ticket closed' => 'Тикет затворен',
        'Ticket closed between' => 'Тикет затворен између',
        'Pending times' => 'Времена чекања',
        'No pending time settings.' => 'Нема подешавања времена чекања.',
        'Ticket pending time reached' => 'Достигнуто време чекања тикета',
        'Ticket pending time reached between' => 'Време чекања тикета достигнуто између',
        'Escalation times' => 'Времена ескалације',
        'No escalation time settings.' => 'Нема подешавања времена ескалације.',
        'Ticket escalation time reached' => 'Достигнуто време ескалације тикета',
        'Ticket escalation time reached between' => 'Време ескалације тикета достигнуто између',
        'Escalation - first response time' => 'Ескалација - време првог одзива',
        'Ticket first response time reached' => 'Достигнуто време првог одзива на тикет',
        'Ticket first response time reached between' => 'Време првог одзива на тикет достигнуто између',
        'Escalation - update time' => 'Ескалација - време ажурирања',
        'Ticket update time reached' => 'Достигнуто време ажурирања тикета',
        'Ticket update time reached between' => 'Време ажурирања тикета достигнуто између',
        'Escalation - solution time' => 'Ескалација - време решавања',
        'Ticket solution time reached' => 'Достигнуто време решавања тикета',
        'Ticket solution time reached between' => 'Време решавања тикета достигнуто између',
        'Archive search option' => 'Опције претраге архива',
        'Update/Add Ticket Attributes' => 'Ажурирај/Додај атрибуте тикета',
        'Set new service' => 'Постави нове услуге',
        'Set new Service Level Agreement' => 'Постави нови Споразум о нивоу услуга',
        'Set new priority' => 'Постави нови приоритет',
        'Set new queue' => 'Постави нови ред',
        'Set new state' => 'Постави ново стање',
        'Pending date' => 'Чекање до',
        'Set new agent' => 'Постави новог оператера',
        'new owner' => 'нови власник',
        'new responsible' => 'нови одговорни',
        'Set new ticket lock' => 'Постави ново закључавање тикета',
        'New customer user ID' => 'Нови ID клијент корисника',
        'New customer ID' => 'Нови ID клијента',
        'New title' => 'Нови наслов',
        'New type' => 'Нови тип',
        'Archive selected tickets' => 'Архивирај изабране тикете',
        'Add Note' => 'Додај напомену',
        'Visible for customer' => 'Видљиво клијенту',
        'Time units' => 'Временске јединице',
        'Execute Ticket Commands' => 'Изврши команде тикета',
        'Send agent/customer notifications on changes' => 'Пошаљи обавештења оператеру/клијенту при променама',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ова наредба ће бити извршена. ARG[0] је број тикета, а ARG[1] ID тикета.',
        'Delete tickets' => 'Обриши тикете',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'УПОЗОРЕЊЕ: Сви обухваћени тикети ће бити неповратно уклоњени из базе!',
        'Execute Custom Module' => 'Покрени извршавање посебног модула',
        'Param %s key' => 'Кључ параметра %s',
        'Param %s value' => 'Вредност параметра %s',
        'Results' => 'Резултати',
        '%s Tickets affected! What do you want to do?' => '%s тикета је обухваћено. Шта желите да урадите?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'УПОЗОРЕЊЕ: Употребили сте опцију за брисање. Сви обрисани тикети ће бити изгубљени!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            'Упозорење: Обухваћено је %s тикета али само %s може бити измењено током једног извршавања посла!',
        'Affected Tickets' => 'Обухваћени тикети',
        'Age' => 'Старост',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Web Service Management' => 'Управљање оштим интерфејсом веб сервиса',
        'Web Service Management' => 'Управљање веб сервисима',
        'Debugger' => 'Програм за отклањање грешака',
        'Go back to web service' => 'Иди назад на веб сервис',
        'Clear' => 'Очисти',
        'Do you really want to clear the debug log of this web service?' =>
            'Да ли стварно желите да очистите отклањање грешака у логу овог веб сервиса?',
        'Request List' => 'Листа захтева',
        'Time' => 'Време',
        'Communication ID' => 'ID комуникације',
        'Remote IP' => 'Удаљена IP адреса',
        'Loading' => 'Учитавање',
        'Select a single request to see its details.' => 'Изаберите један захтев да би видели његове детаље.',
        'Filter by type' => 'Филтер по типу',
        'Filter from' => 'Филтер од',
        'Filter to' => 'Филтер до',
        'Filter by remote IP' => 'Филтер по удаљеној IP адреси',
        'Limit' => 'Ограничење',
        'Refresh' => 'Освежавање',

        # Template: AdminGenericInterfaceErrorHandlingDefault
        'Add ErrorHandling' => 'Додај обраду грешке',
        'Edit ErrorHandling' => 'Уреди обраду грешке',
        'Do you really want to delete this error handling module?' => 'Да ли стварно желите да обришете овај модул за обраду грешке?',
        'All configuration data will be lost.' => 'Сви конфигурациони подаци ће бити изгубљени.',
        'General options' => 'Општа подешавања',
        'The name can be used to distinguish different error handling configurations.' =>
            'Назив се може користити за прављење разлике између појединачних конфигурација за обраду грешке.',
        'Please provide a unique name for this web service.' => 'Молимо да обезбедите јединствени назив за овај веб сервис.',
        'Error handling module backend' => 'Модул за обраду грешке',
        'This OTRS error handling backend module will be called internally to process the error handling mechanism.' =>
            'Овај модул за отклањање грешака ће бити позван интерно да обради грешку.',
        'Processing options' => 'Подешавања обраде',
        'Configure filters to control error handling module execution.' =>
            'Конфигуришите филтере за контролу модула за обраду грешке.',
        'Only requests matching all configured filters (if any) will trigger module execution.' =>
            'Само захтеви који одговарају подешеним филтерима (уколико их има) ће резултирати у позивању модула.',
        'Operation filter' => 'Филтер операције',
        'Only execute error handling module for selected operations.' => 'Изврши модул за обраду грешке само за одговарајуће операције.',
        'Note: Operation is undetermined for errors occuring while receiving incoming request data. Filters involving this error stage should not use operation filter.' =>
            'Напомена: операција за грешке приликом пријема захтева није дефинисана. Филтери за овај ниво обраде не би требало да користе филтер операције.',
        'Invoker filter' => 'Филтер позиваоца',
        'Only execute error handling module for selected invokers.' => 'Изврши модул за обраду грешке само за одговарајуће позиваоце.',
        'Error message content filter' => 'Филтер садржаја поруке о грешци',
        'Enter a regular expression to restrict which error messages should cause error handling module execution.' =>
            'Унесите регуларни израз за ограничење које поруке о грешци ће резултирати у позивању модула.',
        'Error message subject and data (as seen in the debugger error entry) will considered for a match.' =>
            'Наслов и садржај поруке о грешци (како су приказани у програму за отклањање грешака) који ће бити сматрани као задовољен услов.',
        'Example: Enter \'^.*401 Unauthorized.*\$\' to handle only authentication related errors.' =>
            'Пример: унесите \'^.*401 Unauthorized.*\$\' за обраду само грешака у вези аутентикације.',
        'Error stage filter' => 'Филтер грешке у одговарућој фази',
        'Only execute error handling module on errors that occur during specific processing stages.' =>
            'Изврши модул за обраду грешке само уколико се догоде током одговарајуће фазе у току захтева.',
        'Example: Handle only errors where mapping for outgoing data could not be applied.' =>
            'Пример: обради само грешке када није могуће било мапирати одлазне податке.',
        'Error code' => 'Код грешке',
        'An error identifier for this error handling module.' => 'Идентификатор овог модула за обраду грешака.',
        'This identifier will be available in XSLT-Mapping and shown in debugger output.' =>
            'Овај идентификатор ће бити доступан у XSLT мапирању и приказан у програму за отклањање грешака.',
        'Error message' => 'Порука о грешци',
        'An error explanation for this error handling module.' => 'Објашњење овог модула за обраду грешака.',
        'This message will be available in XSLT-Mapping and shown in debugger output.' =>
            'Ова порука ће бити доступна у XSLT мапирању и приказана у програму за отклањање грешака.',
        'Define if processing should be stopped after module was executed, skipping all remaining modules or only those of the same backend.' =>
            'Дефинише да ли процесирање треба да буде заустављено након што је модул извршен, приликом тока прескачући све остале модуле или само оне истог типа.',
        'Default behavior is to resume, processing the next module.' => 'Подразумевано понашање је да се настави процесирање следећег модула.',

        # Template: AdminGenericInterfaceErrorHandlingRequestRetry
        'This module allows to configure scheduled retries for failed requests.' =>
            'Овај модул омогућава конфигурацију планираних поновних покушаја за неуспеле захтеве.',
        'Default behavior of GenericInterface web services is to send each request exactly once and not to reschedule after errors.' =>
            'Подразумевано понашање веб сервиса је да пошаље сваки захтев само једанпут и да не планира поновно извршавање у случају грешке.',
        'If more than one module capable of scheduling a retry is executed for an individual request, the module executed last is authoritative and determines if a retry is scheduled.' =>
            'Уколико је више од једног модула способно да поново изврши појединачни захтев, само последњи модул ће бити узет у обзир и одредиће да ли ће бити поновног покушаја.',
        'Request retry options' => 'Подешавања поновних покушаја',
        'Retry options are applied when requests cause error handling module execution (based on processing options).' =>
            'Поновни покушаји ће бити планирани када се изврши модул за обраду грешке (на основу подешавања истих).',
        'Schedule retry' => 'Поновни покушај',
        'Should requests causing an error be triggered again at a later time?' =>
            'Да ли захтеви који резултују у грешкама треба да буду поново извршени?',
        'Initial retry interval' => 'Почетни интервал поновних покушаја',
        'Interval after which to trigger the first retry.' => 'Временски интервал након кога ће бити извршен први поновни покушај.',
        'Note: This and all further retry intervals are based on the error handling module execution time for the initial request.' =>
            'Напомена: овај и сви наредни интервали поновних покушаја су засновани на времену извршавања модула за обраду грешке почетног захтева.',
        'Factor for further retries' => 'Фактор интервала поновних покушаја',
        'If a request returns an error even after a first retry, define if subsequent retries are triggered using the same interval or in increasing intervals.' =>
            'Уколико захтев резултира грешком и после првог поновног покушаја, дефинише да ли су следећи покушаји извршени у истом или увећавајућем интервалу.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\' and retry factor at \'2\', retries would be triggered at 10:01 (1 minute), 10:03 (2*1=2 minutes), 10:07 (2*2=4 minutes), 10:15 (2*4=8 minutes), ...' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута и фактором интервала 2, поновни покушаји ће бити извршени у 10:01 (1 минут), 10:03 (2*1=2 минута), 10:07 (2*2=4 минута), 10:15 (2*4=8 минута), ...',
        'Maximum retry interval' => 'Максимални интервал поновних покушаја',
        'If a retry interval factor of \'1.5\' or \'2\' is selected, undesirably long intervals can be prevented by defining the largest interval allowed.' =>
            'Уколико је одабран фактор интервала поновних покушаја од 1.5 или 2, могуће је спречити исувише дуге интервале дефинисањем максимално дозвољеног интервала.',
        'Intervals calculated to exceed the maximum retry interval will then automatically be shortened accordingly.' =>
            'Интервал који прелази максимално дозвољени интервал ће аутоматски бити скраћен.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum interval at \'5 minutes\', retries would be triggered at 10:01 (1 minute), 10:03 (2 minutes), 10:07 (4 minutes), 10:12 (8=>5 minutes), 10:17, ...' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута, фактором интервала 2 и максималним интервалом од 5 минута, поновни покушаји ће бити извршени у 10:01 (1 минут), 10:03 (2*1=2 минута), 10:07 (2*2=4 минута), 10:12 (8=> 5 минута), 10:17, ...',
        'Maximum retry count' => 'Максимални број поновних покушаја',
        'Maximum number of retries before a failing request is discarded, not counting the initial request.' =>
            'Максимални дозвољени број поновних покушаја пре него што је неуспели захтево одбачен, не рачунајући почетни захтев.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry count at \'2\', retries would be triggered at 10:01 and 10:02 only.' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута, фактором интервала 2 и максималним бројем поновних покушаја 2, поновни покушаји ће бити извршени само у 10:01 и 10:03.',
        'Note: Maximum retry count might not be reached if a maximum retry period is configured as well and reached earlier.' =>
            'Напомена: максимални дозвољених број поновних покушаја не мора бити достигнут уколико је подешен максимални период поновних покушаја и достигнут раније.',
        'This field must be empty or contain a positive number.' => 'Ово поље мора да буде празно или позитиван број.',
        'Maximum retry period' => 'Максимални период поновних покушаја',
        'Maximum period of time for retries of failing requests before they are discarded (based on the error handling module execution time for the initial request).' =>
            'Максимални дозвољени временски период понових покушаја пре него што је неуспели захтев одбачен (заснован на времену извршавања модула за обраду грешке почетног захтева).',
        'Retries that would normally be triggered after maximum period is elapsed (according to retry interval calculation) will automatically be triggered at maximum period exactly.' =>
            'Поновни покушаји који би стандардно били извршени после максималног временског периода (на основу израчунатог интервала) ће аутоматски бити извршени тачно у максималном периоду.',
        'Example: If a request is initially triggered at 10:00 with initial interval at \'1 minute\', retry factor at \'2\' and maximum retry period at \'30 minutes\', retries would be triggered at 10:01, 10:03, 10:07, 10:15 and finally at 10:31=>10:30.' =>
            'Пример: уколико је захтев покренут у 10:00 са почетним интервалом од једног минута, фактором интервала 2 и максималним периодом од 30 минута, поновни покушаји ће бити извршени у 10:01, 10:03, 10:07, 10:15 и коначно у 10:31=>10:30.',
        'Note: Maximum retry period might not be reached if a maximum retry count is configured as well and reached earlier.' =>
            'Напомена: максимални дозвољени период не мора бити достигнут уколико је подешен максимални број поновних покушаја и достигнут раније.',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add Invoker' => 'Додај позиваоца',
        'Edit Invoker' => 'Уреди позиваоца',
        'Do you really want to delete this invoker?' => 'Да ли стварно желите да избришете овог позиваоца?',
        'Invoker Details' => 'Детаљи позиваоца',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Назив се обично користи за покретање операције удаљеног веб сервиса.',
        'Invoker backend' => 'Модул позиваоца',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Овај модул позиваоца биће позван да припреми податке за слање на удаљени систем и да обради податке његовог одговора.',
        'Mapping for outgoing request data' => 'Мапирање за излазне податке захтева',
        'Configure' => 'Подеси',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Подаци из OTRS позиваоца биће обрађени овим мапирањем, да би их трансформисали у типове података које удаљени систем очекује.',
        'Mapping for incoming response data' => 'Мапирање за улазне податке одговора',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Подаци одговора из OTRS позиваоца биће обрађени овим мапирањем, да би их трансформисали у типове података које удаљени систем очекује..',
        'Asynchronous' => 'Асинхрони',
        'Condition' => 'Услов',
        'Edit this event' => 'Уреди овај догађај',
        'This invoker will be triggered by the configured events.' => 'Овај позиваоц ће бити активиран преко подешених догађаја.',
        'Add Event' => 'Додај догађај',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'За додавање новог догађаја изаберите објекат и назив догађаја па кликните на "+" дугме',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            'Асинхроним окидачима догађаја управља планер OTRS системског сервиса у позадини (препоручено).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Синхрони окидачи догађаја биће обрађени директно током веб захтева.',

        # Template: AdminGenericInterfaceInvokerEvent
        'GenericInterface Invoker Event Settings for Web Service %s' => 'Подешавања позиваоца догађаја у општем интерфејсу за веб сервис %s',
        'Go back to' => 'Иди назад на',
        'Delete all conditions' => 'Избриши све услове',
        'Do you really want to delete all the conditions for this event?' =>
            'Да ли стварно желите да обришете све услове овог догађаја?',
        'General Settings' => 'Општа подешавања',
        'Event type' => 'Тип догађаја',
        'Conditions' => 'Услови',
        'Conditions can only operate on non-empty fields.' => 'Услови могу да се примене само са поља која нису празна.',
        'Type of Linking between Conditions' => 'Тип везе између услова',
        'Remove this Condition' => 'Уклони овај услов',
        'Type of Linking' => 'Тип везе',
        'Fields' => 'Поља',
        'Add a new Field' => 'Додај ново поље',
        'Remove this Field' => 'Уклони ово поље',
        'And can\'t be repeated on the same condition.' => 'И се не може поновити у истом услову.',
        'Add New Condition' => 'Додај нови услов',

        # Template: AdminGenericInterfaceMappingSimple
        'Mapping Simple' => 'Једноставно мапирање',
        'Default rule for unmapped keys' => 'Подразумевано правило за немапиране кључеве',
        'This rule will apply for all keys with no mapping rule.' => 'Ово правило ће се примењивати за све кључеве без правила мапирања.',
        'Default rule for unmapped values' => 'Подразумевано правило за немапиране вредности',
        'This rule will apply for all values with no mapping rule.' => 'Ово правило ће се примењивати за све вредности без правила мапирања.',
        'New key map' => 'Novo mapiranje ključa',
        'Add key mapping' => 'Додај мапирање кључа',
        'Mapping for Key ' => 'Мапирање за кључ ',
        'Remove key mapping' => 'Уклони мапирање кључа',
        'Key mapping' => 'Мапирање кључа',
        'Map key' => 'Мапирај кључ',
        'matching the' => 'Подударање са',
        'to new key' => 'на нови кључ',
        'Value mapping' => 'Вредносно мапирање',
        'Map value' => 'Мапирај вредност',
        'to new value' => 'на нову вредност',
        'Remove value mapping' => 'Уклони мапирање вредности',
        'New value map' => 'Ново мапирање вредности',
        'Add value mapping' => 'Додај мапирану вредност',
        'Do you really want to delete this key mapping?' => 'Да ли стварно желите да обришете ово мапирање кључа?',

        # Template: AdminGenericInterfaceMappingXSLT
        'General Shortcuts' => 'Опште пречице',
        'MacOS Shortcuts' => 'MacOS пречице',
        'Comment code' => 'Додај коментар кода',
        'Uncomment code' => 'Уклони коментар кода',
        'Auto format code' => 'Форматирај код аутоматски',
        'Expand/Collapse code block' => 'Прошири/смањи блок кода',
        'Find' => 'Пронађи',
        'Find next' => 'Пронађи следеће',
        'Find previous' => 'Пронађи претходно',
        'Find and replace' => 'Пронађи и замени',
        'Find and replace all' => 'Пронађи и замени све',
        'XSLT Mapping' => 'XSLT мапирање',
        'XSLT stylesheet' => 'XSLT опис стилова',
        'The entered data is not a valid XSLT style sheet.' => 'Унети подаци нису исправан XSLT опис стилова.',
        'Here you can add or modify your XSLT mapping code.' => 'Овде може додати и изменити код XSLT мапирања.',
        'The editing field allows you to use different functions like automatic formatting, window resize as well as tag- and bracket-completion.' =>
            'Поље за уређивање вам омогућава да користите функције као што су аутоматско форматирање, промена величине прозора и аутоматско допуњавање команди и заграда.',
        'Data includes' => 'Подаци укључују',
        'Select one or more sets of data that were created at earlier request/response stages to be included in mappable data.' =>
            'Одаберите један или више скупова података који су креирани у ранијој фази захтева/одговора за укључивање у податке за мапирање.',
        'These sets will appear in the data structure at \'/DataInclude/<DataSetName>\' (see debugger output of actual requests for details).' =>
            'Ови скупови ће бити укључени у структуру на путањи \'/DataInclude/<DataSetName>\' (видите програм за отклањање грешака за детаље).',
        'Data key regex filters (before mapping)' => 'Филтери регуларних израза (пре мапирања)',
        'Data key regex filters (after mapping)' => 'Филтери регуларних израза (после мапирања)',
        'Regular expressions' => 'Регуларни изрази',
        'Replace' => 'Замени',
        'Remove regex' => 'Уклони регуларни израз',
        'Add regex' => 'Додај регуларни израз',
        'These filters can be used to transform keys using regular expressions.' =>
            'Ови филтери се могу користи за трансформацију кључева коришћењем регуларних израза.',
        'The data structure will be traversed recursively and all configured regexes will be applied to all keys.' =>
            'Структура података ће бити процесирана рекурзивно и сви подешени регуларни изрази ће бити примењени на све кључеве.',
        'Use cases are e.g. removing key prefixes that are undesired or correcting keys that are invalid as XML element names.' =>
            'Примери коришћења су нпр. уклањањен непожељних префикса из кључева или исправљање кључева који су неисправни као XML називи.',
        'Example 1: Search = \'^jira:\' / Replace = \'\' turns \'jira:element\' into \'element\'.' =>
            'Пример 1: пронађи = \'^jira:\' / замени = \'\' претвара \'jira:element\' у \'element\'.',
        'Example 2: Search = \'^\' / Replace = \'_\' turns \'16x16\' into \'_16x16\'.' =>
            'Пример 2: пронађи = \'^\' / замени = \'_\' претвара \'16x16\' у \'_16x16\'.',
        'Example 3: Search = \'^(?<number>\d+) (?<text>.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' turns \'16 elementname\' into \'_elementname_16\'.' =>
            'Пример 3: Search = \'^(?\d+) (?.+?)\$\' / Replace = \'_\$+{text}_\$+{number}\' претвара \'16 elementname\' у \'_elementname_16\'.',
        'For information about regular expressions in Perl please see here:' =>
            'За информације о Perl регуларним изразима, молимо посетите:',
        'Perl regular expressions tutorial' => 'Приручних Perl регуларних израза',
        'If modifiers are desired they have to be specified within the regexes themselves.' =>
            'Уколико су вам неопходни модификатори, мораћете да их дефинишете у оквиру самих регуларних израза.',
        'Regular expressions defined here will be applied before the XSLT mapping.' =>
            'Регуларни изрази дефинисани овде биће примењени пре XSLT мапирања.',
        'Regular expressions defined here will be applied after the XSLT mapping.' =>
            'Регуларни изрази дефинисани овде биће примењени после XSLT мапирања.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add Operation' => 'Додај операцију',
        'Edit Operation' => 'Уреди операцију',
        'Do you really want to delete this operation?' => 'Да ли стварно желите да обришете ову операцију?',
        'Operation Details' => 'Детаљи операције',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Назив се обично користи за позивање операције веб сервиса из удаљеног система.',
        'Operation backend' => 'Модул операције',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Овај модул операције ће бити интерно позван да обради захтев, генерисањем података за одговор.',
        'Mapping for incoming request data' => 'Мапирање за долазне податке захтева',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Подаци захтева ће бити обрађени кроз мапирање, ради трансформације у облик који OTRS очекује.',
        'Mapping for outgoing response data' => 'Мапирање за излазне податке одговора',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Подаци одговора ће бити обрађени кроз ово мапирање, ради трансформације у облик који удаљени систем очекује.',
        'Include Ticket Data' => 'Укључи податке тикета',
        'Include ticket data in response.' => 'Укључи податке тикета у одговору.',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'Network Transport' => 'Мрежни транспорт',
        'Properties' => 'Својства',
        'Route mapping for Operation' => 'Мапирање руте за операцију',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            'Дефинише руту која ће бити мапирана на ову операцију. Променљиве обележене са \':\' ће бити мапиране за унети назив и прослеђене са осталима (нпр. /Ticket/:TicketID).',
        'Valid request methods for Operation' => 'Важеће методе захтева за операцију',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            'Ограничи ову опреацију на поједине методе захтева. Ако ни једна метода није изабрана сви захтеви ће бити прихваћени.',
        'Maximum message length' => 'Највећа дужина поруке',
        'This field should be an integer number.' => 'Ово поље треба да буде цео број.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Овде можете унети максималну величину (у бајтима) REST порука које ће OTRS да обради.',
        'Send Keep-Alive' => 'Пошаљи Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            'Конфигурација дефинише да ли долазна конекција треба да се затвори и одржава.',
        'Additional response headers' => 'Додатна заглавља у одговорима',
        'Add response header' => 'Додај заглавље у одговору',
        'Endpoint' => 'Крајња тачка',
        'URI to indicate specific location for accessing a web service.' =>
            'URI за идентификацију специфичне локације за приступ сервису.',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'нпр. https://www.otrs.com:10745/api/v1.0 (без косе црте на крају)',
        'Timeout' => 'Временско ограничење',
        'Timeout value for requests.' => 'Временско ограничење за захтеве.',
        'Authentication' => 'Аутентификација',
        'An optional authentication mechanism to access the remote system.' =>
            'Опциони механизам аутентификације за приступ удаљеном систему.',
        'BasicAuth User' => 'BasicAuth корисник',
        'The user name to be used to access the remote system.' => 'Корисничко име које ће бити коришћено за приступ удаљеном систему.',
        'BasicAuth Password' => 'BasicAuth лозинка',
        'The password for the privileged user.' => 'Лозинка за привилегованог корисника.',
        'Use Proxy Options' => 'Користи Proxy подешавања',
        'Show or hide Proxy options to connect to the remote system.' => 'Прикажи или сакриј Proxy опције за повезивање са удаљеним системом.',
        'Proxy Server' => 'Proxy сервер',
        'URI of a proxy server to be used (if needed).' => 'URI од proxy сервера да буде коришћен (ако је потребно).',
        'e.g. http://proxy_hostname:8080' => 'нпр. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy корисник',
        'The user name to be used to access the proxy server.' => 'Корисничко име које ће се користити за приступ proxy серверу.',
        'Proxy Password' => 'Proxy лозинка',
        'The password for the proxy user.' => 'Лозинка за proxy корисника.',
        'Skip Proxy' => 'Игнориши Proxy',
        'Skip proxy servers that might be configured globally?' => 'Да ли желите да игноришете Proxy сервере који су можда подешени глобално?',
        'Use SSL Options' => 'Користи SSL опције',
        'Show or hide SSL options to connect to the remote system.' => 'Прикажи или сакриј SSL опције за повезивање са удаљеним системом.',
        'Client Certificate' => 'Клијентски сертификат',
        'The full path and name of the SSL client certificate file (must be in PEM, DER or PKCS#12 format).' =>
            'Цела путања и назив за датотеку SSL сертификата (мора бити у PEM, DER или PKCS#12 формату).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.pem' => 'нпр. /opt/otrs/var/certificates/SOAP/certificate.pem',
        'Client Certificate Key' => 'Кључ клијентског сертификата',
        'The full path and name of the SSL client certificate key file (if not already included in certificate file).' =>
            'Цела путања и назив за датотеку кључа SSL сертификата (уколико није укључен у датотеку сертификата).',
        'e.g. /opt/otrs/var/certificates/SOAP/key.pem' => 'нпр. /opt/otrs/var/certificates/SOAP/key.pem',
        'Client Certificate Key Password' => 'Лозинка кључа клијентског сертификата',
        'The password to open the SSL certificate if the key is encrypted.' =>
            'Лозинка за отварање SSL сертификата уколико је кључ шифрован.',
        'Certification Authority (CA) Certificate' => 'Сертификат сертификационог тела (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Цела путања и назив сертификационог тела које провера исправност SSL сертификата.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'нпр. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Директоријум сертификационог тела (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Цела путања директоријума сертификационог тела где се складиште CA сертификати у систему датотека.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'нпр. /opt/otrs/var/certificates/SOAP/CA',
        'Controller mapping for Invoker' => 'Мапирање контролера за позиваоца',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            'Контролер коме ће позивалац прослеђивати захтеве. Променљиве обележене са \':\' ће бити замењене њиховим вредностима и прослеђене заједно са захтевом (нпр. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).',
        'Valid request command for Invoker' => 'Важећа команда захтева за позиваоца',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            'Специфична HTTP команда за примену на захтеве са овим позиваоцем (необавезно).',
        'Default command' => 'Подразумевана команда',
        'The default HTTP command to use for the requests.' => 'Подразумевена HTTP команда за захтеве.',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'e.g. https://local.otrs.com:8000/Webservice/Example' => 'нпр. https://local.otrs.com:8000/Webservice/Example',
        'Set SOAPAction' => 'Дефиниши SOAPAction',
        'Set to "Yes" in order to send a filled SOAPAction header.' => 'Изабери "Да" за слање попуњеног SOAPAction заглавља.',
        'Set to "No" in order to send an empty SOAPAction header.' => 'Изабери "Не" за слање празног SOAPAction заглавља.',
        'Set to "Yes" in order to check the received SOAPAction header (if not empty).' =>
            'Изабери "Да" за проверу примљеног SOAPAction заглавља (уколико није празно).',
        'Set to "No" in order to ignore the received SOAPAction header.' =>
            'Изабери "Не" за игнорисање примљеног SOAPAction заглавља.',
        'SOAPAction scheme' => 'SOAPAction шема',
        'Select how SOAPAction should be constructed.' => 'Изаберите како ће бити конструисан SOAPAction.',
        'Some web services require a specific construction.' => 'Поједини веб сервиси захтевају специфичну конструкцију.',
        'Some web services send a specific construction.' => 'Поједини веб сервиси шаљу специфичну конструкцију.',
        'SOAPAction separator' => 'Сепаратор SOAP акције',
        'Character to use as separator between name space and SOAP operation.' =>
            'Знак који ће се користити као сепаратор између заглавља и SOAP методе.',
        'Usually .Net web services use "/" as separator.' => '.Net веб сервиси обично користе "/" као сепаратор.',
        'SOAPAction free text' => 'SOAPAction слободан текст',
        'Text to be used to as SOAPAction.' => 'Текст који ће се користити као SOAPAction.',
        'Namespace' => 'Врста захтева',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI који даје контекст SOAP методама, смањује двосмислености.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'нпр. urn:otrs-com:soap:functions или http://www.otrs.com/GenericInterface/actions',
        'Request name scheme' => 'Захтев за шему назива',
        'Select how SOAP request function wrapper should be constructed.' =>
            'Изаберите како ће бити конструисан омотач функције SOAP захтева.',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '\'FunctionName\' се користи као пример за стваран назив позиваоца/операције.',
        '\'FreeText\' is used as example for actual configured value.' =>
            '\'FreeText\' се користи као пример за стварну подешену вредност.',
        'Request name free text' => 'Слободан текст назива захтева',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            'Текст који ће бити кориштен као наставак назива или замена омотача функције.',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            'Молимо да узмете у обзир XML оганичења именовања (нпр. немојте користити \'<\' и \'&\').',
        'Response name scheme' => 'Шема назива одговора',
        'Select how SOAP response function wrapper should be constructed.' =>
            'Изаберите како ће бити конструисан омотач функције SOAP одговора.',
        'Response name free text' => 'Слободан текст назива одговора',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Овде можете унети максималну величину (у бајтима) SOAP порука које ће OTRS да обради.',
        'Encoding' => 'Кодни распоред',
        'The character encoding for the SOAP message contents.' => 'Кодни распоред знакова за садржај SOAP поруке.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'нпр. utf-8, latin1, iso-8859-1, cp1250, ...',
        'Sort options' => 'Опције сортирања',
        'Add new first level element' => 'Додај нови елемент првог нивоа',
        'Element' => 'Елемент',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            'Одлазни редослед сортирања за XML поља (структура испод назива омотача функције) - погледајте документацију за SOAP транспорт.',

        # Template: AdminGenericInterfaceWebservice
        'Add Web Service' => 'Додај веб сервис',
        'Edit Web Service' => 'Уреди веб сервис',
        'Clone Web Service' => 'Клонирај веб сервис',
        'The name must be unique.' => 'Назив мора бити јединствен.',
        'Clone' => 'Клонирај',
        'Export Web Service' => 'Извези веб сервис',
        'Import web service' => 'Увези веб сервис',
        'Configuration File' => 'Конфигурациона датотека',
        'The file must be a valid web service configuration YAML file.' =>
            'Датотека мора да буде важећа YAML конфигурациона датотека веб сервиса.',
        'Here you can specify a name for the webservice. If this field is empty, the name of the configuration file is used as name.' =>
            'Овде можете дефинисати назив веб сервиса. Уколико је ово поље празно, биће коришћен назив конфигурационе датотеке.',
        'Import' => 'Увези',
        'Configuration History' => 'Историјат конфигурације',
        'Delete web service' => 'Обриши веб сервис',
        'Do you really want to delete this web service?' => 'Да ли стварно желите да обришете овај веб сервис?',
        'Ready2Adopt Web Services' => 'Ready2Adopt веб сервиси',
        'Here you can activate Ready2Adopt web services showcasing our best practices that are a part of %s.' =>
            'Овде можете активирати Ready2Adopt веб сервисе спремне за употребу који осликавају нашу најбољу праксу која је део %s.',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            'Молимо да имате на уму да веб сервиси могу да зависе од других модула који су доступни у оквиру одређених %s нивоа уговора (постоји обавешетење са додатним детаљима при увозу).',
        'Import Ready2Adopt web service' => 'Увези Ready2Adopt веб сервис',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated Ready2Adopt web services.' =>
            'Да ли желите да искористите веб сервисе креиране од стране експерата? Унапредите на %s да би могли да увезете софистициране Ready2Adopt веб сервисе спремне за употребу.',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Након снимања конфигурације бићете поново преусмерени на приказ екрана за уређивање.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Ако желите да се вратите на преглед, молимо да кликнете на дугме \'Иди на преглед\'.',
        'Remote system' => 'Удаљени систем',
        'Provider transport' => 'Транспорт провајдера',
        'Requester transport' => 'Транспорт потражиоца',
        'Debug threshold' => 'Праг уклањања грешака',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'У режиму провајдера, OTRS нуди веб сервисе који се користе од стране удаљених система.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'У режиму наручиоца, OTRS користи веб сервисе удаљених система.',
        'Network transport' => 'Мрежни транспорт',
        'Error Handling Modules' => 'Модули за обраду грешке',
        'Error handling modules are used to react in case of errors during the communication. Those modules are executed in a specific order, which can be changed by drag and drop.' =>
            'Модули за обраду грешке се користе за реакцију у случуја грешака у току комуникације. Ови модули се извршавају у одговарајућем редоследу, који може бити измењен превлачењем.',
        'Backend' => 'Модул',
        'Add error handling module' => 'Додај модул за обраду грешке',
        'Operations are individual system functions which remote systems can request.' =>
            'Операције су индивидуалне системске функције које удаљени системи могу да захтевају.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Позиваоци припремају податке за захтев на удаљеном wеб сервису и обрађују податке његових одговора.',
        'Controller' => 'Контролер',
        'Inbound mapping' => 'Улазно мапирање',
        'Outbound mapping' => 'Излазно мапирање',
        'Delete this action' => 'Обриши ову акцију',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Најмање један %s има контролер који или није активан или није присутан, молимо проверите регистрацију контролера или избришите %s',

        # Template: AdminGenericInterfaceWebserviceHistory
        'History' => 'Историја',
        'Go back to Web Service' => 'Вратите се на веб сервис',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Овде можете видети старије верзије конфигурације актуелног веб сервиса, експортовати их или их обновити.',
        'Configuration History List' => 'Листа - историјат конфигурације',
        'Version' => 'Верзија',
        'Create time' => 'Време креирања',
        'Select a single configuration version to see its details.' => 'Изабери само једну конфигурациону верзију за преглед њених детаља.',
        'Export web service configuration' => 'Извези конфигурацију веб сервиса',
        'Restore web service configuration' => 'Обнови конфигурацију веб сервиса',
        'Do you really want to restore this version of the web service configuration?' =>
            'Да ли стварно желите да вратите ову верзију конфигурације веб сервиса?',
        'Your current web service configuration will be overwritten.' => 'Актуелна конфигурација веб сервиса биће преписана.',

        # Template: AdminGroup
        'Group Management' => 'Управљање групама',
        'Add Group' => 'Додај групу',
        'Edit Group' => 'Уреди групу',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '\'admin\' група служи за приступ администрационом простору, а \'stats\' група статистикама.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Направи нове групе за руковање правима приступа разним групама оператера (нпр. одељење набавке, техничка подршка, продаја, ...). ',
        'It\'s useful for ASP solutions. ' => 'Корисно за ASP решења. ',

        # Template: AdminLog
        'System Log' => 'Системски дневник',
        'Here you will find log information about your system.' => 'Овде ћете наћи лог информације о вашем систему.',
        'Hide this message' => 'Сакриј ову поруку',
        'Recent Log Entries' => 'Последњи лог уноси',
        'Facility' => 'Инсталација',
        'Message' => 'Порука',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Управљање имејл налозима',
        'Add Mail Account' => 'Додај имејл налог',
        'Edit Mail Account for host' => 'Уреди имејл налог за сервер',
        'and user account' => 'и кориснички налог',
        'Filter for Mail Accounts' => 'Филтер за имејл налоге',
        'Filter for mail accounts' => 'Филтер за имејл налоге',
        'All incoming emails with one account will be dispatched in the selected queue.' =>
            'Све долазне поруке са једног имејл налога ће бити усмерене у изабрани ред.',
        'If your account is marked as trusted, the X-OTRS headers already existing at arrival time (for priority etc.) will be kept and used, for example in PostMaster filters.' =>
            'Ако је ваш налог од поверења, постојећа X-OTRS заглавља у тренутку пријема (за приоритет, итд.) ће бити сачувана коришћена, нпр. у PostMaster филтерима.',
        'Outgoing email can be configured via the Sendmail* settings in %s.' =>
            'Подешавања одлазећих имејл порука могу бити конфигурисана путем Sendmail* опција у %s.',
        'System Configuration' => 'Конфигурација система',
        'Host' => 'Домаћин',
        'Delete account' => 'Обриши налог',
        'Fetch mail' => 'Преузми пошту',
        'Do you really want to delete this mail account?' => 'Да ли стварно желите да обришете овај имејл налог?',
        'Password' => 'Лозинка',
        'Example: mail.example.com' => 'Пример: mail.example.com',
        'IMAP Folder' => 'IMAP фолдер',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Ово измените само ако је потребно примити пошту из другог фолдера, а не из INBOX-а.',
        'Trusted' => 'Од поверења',
        'Dispatching' => 'Отпрема',
        'Edit Mail Account' => 'Уреди имејл налог',

        # Template: AdminNavigationBar
        'Administration Overview' => 'Административни преглед',
        'Filter for Items' => 'Филтер за ставке',
        'Filter' => 'Филтер',
        'Favorites' => 'Омиљене',
        'You can add favorites by moving your cursor over items on the right side and clicking the star icon.' =>
            'Можете додати омиљене превлачењем курсора преко ставке са десне стране и кликом на иконицу звезде.',
        'Links' => 'Везе',
        'View the admin manual on Github' => 'Прегледајте упутство за администраторе на Github',
        'No Matches' => 'Ништа није пронађено',
        'Sorry, your search didn\'t match any items.' => 'Жао нам је, ваша претрага није вратила резултате.',
        'Set as favorite' => 'Стави у омиљене',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Управљање обавештењима о тикетима',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Овде можете послати конфигурациону датотеку за увоз обавештења о тикету у ваш систем. Датотека мора бити у .yml формату ако се извози од стране модула за обавештења о тикету.',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            'Овде можете изабрати који догађаји ће покренути обавештавање. Додатни филтер за тикете може бити примењен ради слања само за тикете по одређеном критеријуму.',
        'Ticket Filter' => 'Филтер тикета',
        'Lock' => 'Закључај',
        'SLA' => 'SLA',
        'Customer User ID' => 'ID клијента корисника',
        'Article Filter' => 'Филтер чланка',
        'Only for ArticleCreate and ArticleSend event' => 'Само за догађај креирање чланка и слање чланка',
        'Article sender type' => 'Тип пошиљаоца чланка',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Ако се користе догађаји креирање чланка и слање чланка, неопходно је дефинисати филтер чланка. Молим вас селектујте бар једно поље за филтер чланка.',
        'Customer visibility' => 'Видљиво клијентима',
        'Communication channel' => 'Комуникациони канал',
        'Include attachments to notification' => 'Укључи прилоге уз обавштење',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            'Обавети корисника само једном дневно о поједином тикету коришћењем изабраног транспорта.',
        'This field is required and must have less than 4000 characters.' =>
            'Ово поље је обавезно и не сме бити дуже од 4000 карактера.',
        'Notifications are sent to an agent or a customer.' => 'Обавештење послато оператеру или клијенту.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Да видите првих 20 слова предмета (последњег чланка оператера).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Да видите првих 5 линија поруке (последњег чланка оператера).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Да видите првих 20 слова предмета (последњег чланка клијента).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Да видите првих 5 линија поруке (последњег чланка клијента).',
        'Attributes of the current customer user data' => 'Атрибути података актуелног клијента корисника',
        'Attributes of the current ticket owner user data' => 'Атрибути података корисника власника актуелног тикета',
        'Attributes of the current ticket responsible user data' => 'Атрибути података одговорног корисника актуелног тикета',
        'Attributes of the current agent user who requested this action' =>
            'Атрибути актуелног корисника оператера који је тражио ову акцију',
        'Attributes of the ticket data' => 'Атрибути података тикета',
        'Ticket dynamic fields internal key values' => 'Вредности интерних кључева динамичких поља тикета',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Приказане вредности динамичких поља, корисно за падајућа и поља са вишеструким избором',

        # Template: AdminNotificationEventTransportEmailSettings
        'Use comma or semicolon to separate email addresses.' => 'Користите зарез или тачку-зарез за одвајање имејл адреса.',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            'Можете користити OTRS тагове као <OTRS_TICKET_DynamicField_...> за уметање вредности из тренутног тикета.',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Управљај са %s',
        'Downgrade to ((OTRS)) Community Edition' => 'Повратак на бесплатно издање ((OTRS))',
        'Read documentation' => 'Прочитај документацију',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s редовно се повезује са cloud.otrs.com за проверу доступних ажурирања и исправности интерних уговора.',
        'Unauthorized Usage Detected' => 'Детектована неовлаштена употреба',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Овај систем користи %s без адекватне лиценце! Молимо да контактирате %s за обнову или активацију вашег уговора!',
        '%s not Correctly Installed' => '%s није коректно инсталирана',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Ваш %s није коректно инсталиран. Молимо да реинсталирате путем дугмета испод.',
        'Reinstall %s' => 'Реинсталирај %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Ваш %s није коректно инсталиран, а и ажурирање је доступно.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Можете реинсталирати актуелну верзију или извршити ажурирање путем дугмета испод (препоручује се ажурирање).',
        'Update %s' => 'Ажурирај %s',
        '%s Not Yet Available' => '%s није још доступан',
        '%s will be available soon.' => '%s ће бити ускоро доступно.',
        '%s Update Available' => '%s доступно ажурирање',
        'An update for your %s is available! Please update at your earliest!' =>
            'Ажурирање за ваш %s је доступно! Молимо вас да ажурирате што пре!',
        '%s Correctly Deployed' => '%s коректно распоређено',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Честитамо, ваш %s је коректно инсталиран и ажуран!',

        # Template: AdminOTRSBusinessNotInstalled
        'Go to the OTRS customer portal' => 'Иди на OTRS кориснички портал',
        '%s will be available soon. Please check again in a few days.' =>
            '%s ће бити доступна ускоро. Молимо, проверите поново за неколико дана.',
        'Please have a look at %s for more information.' => 'Молимо да погледате %s за више информација.',
        'Your ((OTRS)) Community Edition is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            'Ваше бесплатно издање ((OTRS)) је основа за све будуће активности. Молимо вас да се региструјете пре него што наставите са процесом ажурирања на %s!',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            'Пре него вам %s буде користан, молимо да контактирате %s да бисте добили %s уговор.',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Конекција према cloud.otrs.com преко HTTPS није могла бити успостављена. Молимо осигурајте да ваш OTRS може да се повеже са cloud.otrs.com преко порта 443.',
        'Package installation requires patch level update of OTRS.' => 'Инсталација пакета захтева ажурирану верзију OTRS.',
        'Please visit our customer portal and file a request.' => 'Молимо посетите наш кориснички портал и поднесите захтев.',
        'Everything else will be done as part of your contract.' => 'Све остало ће бити урађено под вашим постојећим уговором.',
        'Your installed OTRS version is %s.' => 'Инсталирана OTRS верзија код вас је %s.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            'Да бисте инсталирали овај пакет, неопходно је да ажурирате ваш OTRS на верзију %s или више.',
        'To install this package, the Maximum OTRS Version is %s.' => 'За инсталацију овог пакета, највиша подржана верзија OTRS је %s.',
        'To install this package, the required Framework version is %s.' =>
            'За инсталацију овог пакета неопходна верзија OTRS је %s.',
        'Why should I keep OTRS up to date?' => 'Зашто би требало да OTRS увек буде ажуриран?',
        'You will receive updates about relevant security issues.' => 'Добићете ажурирања одговарајућих безбедносних издања.',
        'You will receive updates for all other relevant OTRS issues' => 'Добићете ажурирања свих релевантних OTRS издања',
        'With your existing contract you can only use a small part of the %s.' =>
            'Са вашим садашњим уговором можете користити само мали део од %s.',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            'Ако желите да искористите све предности %s потребно је да ажурирате ваш уговор! Контактирајте %s.',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Поништи повратак на стару верзију и врати се назад',
        'Go to OTRS Package Manager' => 'Иди на OTRS управљање пакетима',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Нажалост, тренутно не можете да се вратите на стару верзију због следећих пакета који зависе од %s:',
        'Vendor' => 'Продавац',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Молимо вас да прво деинсталирате пакете кроз управљач пакетима па да покушате поново.',
        'You are about to downgrade to ((OTRS)) Community Edition and will lose the following features and all data related to these:' =>
            'Враћањем на бесплатно издање ((OTRS)) изгубићете следећа својства и податке повезане са:',
        'Chat' => 'Ћаскање',
        'Report Generator' => 'Генератор извештаја',
        'Timeline view in ticket zoom' => 'Детаљни приказ тикета на временској линији',
        'DynamicField ContactWithData' => 'Динамичко поље "Контакт са подацима"',
        'DynamicField Database' => 'База података динамичких поља',
        'SLA Selection Dialog' => 'Дијалог избора SLA',
        'Ticket Attachment View' => 'Преглед прилога уз тикет',
        'The %s skin' => 'Изглед %s',

        # Template: AdminPGP
        'PGP Management' => 'Управљање PGP кључевима',
        'Add PGP Key' => 'Додај PGP кључ',
        'PGP support is disabled' => 'PGP подршка је онемогућена',
        'To be able to use PGP in OTRS, you have to enable it first.' => 'Да би могли да користите PGP у OTRS, морате га прво омогућити.',
        'Enable PGP support' => 'Омогући PGP подршку',
        'Faulty PGP configuration' => 'Неисправна PGP конфигурација',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'PGP подршка ја омогућена али релевантна конфигурација садржи грешке. Молимо да проверите конфигурацију притиском на дугме испод.',
        'Configure it here!' => 'Подесите то овде!',
        'Check PGP configuration' => 'Провери PGP конфигурацију',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'На овај начин можете директно уређивати комплет кључева подешен у SysConfig (системским конфигурацијама).',
        'Introduction to PGP' => 'Увод у PGP',
        'Identifier' => 'Идентификатор',
        'Bit' => 'Бит',
        'Fingerprint' => 'Отисак',
        'Expires' => 'Истиче',
        'Delete this key' => 'Обриши овај кључ',
        'PGP key' => 'PGP кључ',

        # Template: AdminPackageManager
        'Package Manager' => 'Управљање пакетима',
        'Uninstall Package' => 'Деинсталирај пакет',
        'Uninstall package' => 'Деинсталирај пакет',
        'Do you really want to uninstall this package?' => 'Да ли стварно желите да деинсталирате овај пакет?',
        'Reinstall package' => 'Инсталирај поново пакет',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Да ли стварно желите да поново инсталирате овај пакет? Све ручне промене ће бити изгубљене.',
        'Go to updating instructions' => 'Иди на упутство за ажурирање',
        'package information' => 'Информације о пакету',
        'Package installation requires a patch level update of OTRS.' => 'Инсталација пакета захтева ажурирану верзију OTRS.',
        'Package update requires a patch level update of OTRS.' => 'Ажурирање пакета захтева ажурирану верзију OTRS.',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            'Уколико сте корисник OTRS Business Solution™, молимо посетите наш кориснички портал и поднесите захтев.',
        'Please note that your installed OTRS version is %s.' => 'Тренутно инсталирана OTRS верзија је %s.',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            'Да бисте инсталирали овај пакет, неопходно је да ажурирате ваш OTRS на верзију %s или новију.',
        'This package can only be installed on OTRS version %s or older.' =>
            'Овај пакет се може инсталирати само на OTRS верзију%s или старију.',
        'This package can only be installed on OTRS version %s or newer.' =>
            'Овај пакет се може инсталирати само на OTRS верзију%s или новију.',
        'You will receive updates for all other relevant OTRS issues.' =>
            'Добићете ажурирања свих других релевантних OTRS издања.',
        'How can I do a patch level update if I don’t have a contract?' =>
            'Како могу да ажурирам верзију OTRS уколико немам уговор?',
        'Please find all relevant information within the updating instructions at %s.' =>
            'Молимо пронађите све релевантне информације у оквиру инструкција за ажурирање на %s.',
        'In case you would have further questions we would be glad to answer them.' =>
            'У случају да имате додтана питања, биће нам задовољство да одговоримо на њих.',
        'Install Package' => 'Инсталирај пакет',
        'Update Package' => 'Ажурирај пакет',
        'Continue' => 'Настави',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Молимо вас да будете сигурни да ваша база података прихвата пакете величине преко %s MB (тренутно прихвата само пакете до %s MB). Молимо вас да прилагодите подешавања \'max_allowed_packet\' на вашој бази података, да би сте избегли грешке.',
        'Install' => 'Инсталирај',
        'Update repository information' => 'Ажурирај информације о спремишту',
        'Cloud services are currently disabled.' => 'Сервиси у облаку су тренутно деактивирани.',
        'OTRS Verify™ can not continue!' => 'OTRS Verify™ не може да настави!',
        'Enable cloud services' => 'Активирај сервисе у облаку',
        'Update all installed packages' => 'Ажурирај све инсталиране пакете',
        'Online Repository' => 'Мрежно спремиште',
        'Action' => 'Акција',
        'Module documentation' => 'Документација модула',
        'Local Repository' => 'Локално спремиште',
        'This package is verified by OTRSverify (tm)' => 'Овај пакет је верификован од стране OTRSverify (tm)',
        'Uninstall' => 'Деинсталирај',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Пакет није коректно инсталиран! Инсталирајте га поново.',
        'Reinstall' => 'Инсталирај поново',
        'Features for %s customers only' => 'Својства само за %s клијенте',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            'Са %s можете имати користи од следећих опционих функција. Молимо да контактирате %s уколико су вам потребне додатне информације.',
        'Package Information' => 'Информације о пакету',
        'Download package' => 'Преузми пакет',
        'Rebuild package' => 'Обнови пакет(rebuild)',
        'Metadata' => 'Мета подаци',
        'Change Log' => 'Промени лог',
        'Date' => 'Датум',
        'List of Files' => 'Списак датотека',
        'Permission' => 'Дозвола',
        'Download file from package!' => 'Преузми датотеку из пакета!',
        'Required' => 'Обавезно',
        'Size' => 'Величина',
        'Primary Key' => 'Примарни кључ',
        'Auto Increment' => 'Ауто увећање',
        'SQL' => 'SQL',
        'File Differences for File %s' => 'Разлике за датотеку %s',
        'File differences for file %s' => 'Разлике за датотеку %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Перформанса лог-а',
        'Range' => 'Опсег',
        'last' => 'последње',
        'This feature is enabled!' => 'Ова функција је активна!',
        'Just use this feature if you want to log each request.' => 'Активирати ову могућност само ако желите да забележите сваки захтев.',
        'Activating this feature might affect your system performance!' =>
            'Активирање ове функције може утицати на перформансе система!',
        'Disable it here!' => 'Искључите је овде!',
        'Logfile too large!' => 'Лог датотека је превелика!',
        'The logfile is too large, you need to reset it' => 'Лог датотека је превелика, треба да је ресетујете',
        'Reset' => 'Поништи',
        'Overview' => 'Преглед',
        'Interface' => 'Интерфејс',
        'Requests' => 'Захтеви',
        'Min Response' => 'Мин одзив',
        'Max Response' => 'Макс одзив',
        'Average Response' => 'Просечан одзив',
        'Period' => 'Период',
        'minutes' => 'минути',
        'Min' => 'Мин',
        'Max' => 'Макс',
        'Average' => 'Просек',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Управљање PostMaster филтерима',
        'Add PostMaster Filter' => 'Додај PostMaster филтер',
        'Edit PostMaster Filter' => 'Уреди PostMaster филтер',
        'Filter for PostMaster Filters' => 'Филтер за PostMaster филтере',
        'Filter for PostMaster filters' => 'Филтер за PostMaster филтере',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Ради отпреме или филтрирања долазних имејлова на основу заглавља. Поклапање помоћу регуларних израза је такође могуће.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Уколико желите поклапање само са имејл адресом, користите EMAILADDRESS:info@example.com у From, To или Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Уколико користите регуларне изразе, такође можете користити и упатеру вредност у () као (***) у \'Set\' action.',
        'You can also use named captures %s and use the names in the \'Set\' action %s (e.g. Regexp: %s, Set action: %s). A matched EMAILADDRESS has the name \'%s\'.' =>
            'Можете користити и именоване скупове %s и референцирати називе у пољу \'на вредност\' %s (нпр. регуларни израз: %s, на вредност: %s). Препознате имејл адресе имају назив \'%s\'.',
        'Delete this filter' => 'Обриши овај филтер',
        'Do you really want to delete this postmaster filter?' => 'Да ли стварно желите да обришете овај postmaster филтер?',
        'A postmaster filter with this name already exists!' => 'PostMaster филтер са овим називом већ постоји!',
        'Filter Condition' => 'Услов филтрирања',
        'AND Condition' => 'AND услов',
        'Search header field' => 'Претражи заглавље имејла',
        'for value' => 'за вредност',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Ово поље треба да буде важећи регуларни израз или дословно реч.',
        'Negate' => 'Негирати',
        'Set Email Headers' => 'Подеси заглавља имејла',
        'Set email header' => 'Подеси заглавље имејла',
        'with value' => 'на вредност',
        'The field needs to be a literal word.' => 'Ово поље треба да буде дословно реч.',
        'Header' => 'Заглавље',

        # Template: AdminPriority
        'Priority Management' => 'Управљање приоритетима',
        'Add Priority' => 'Додај Приоритет',
        'Edit Priority' => 'Уреди Приоритет',
        'Filter for Priorities' => 'Филтер за приоритете',
        'Filter for priorities' => 'Филтер за приоритете',
        'This priority is present in a SysConfig setting, confirmation for updating settings to point to the new priority is needed!' =>
            'Овај приоритет се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност!',
        'This priority is used in the following config settings:' => 'Овај приоритет се користи у следећим системским подешавањима:',

        # Template: AdminProcessManagement
        'Process Management' => 'Управљање процесима',
        'Filter for Processes' => 'Филтер процеса',
        'Filter for processes' => 'Филтер процеса',
        'Create New Process' => 'Креирај нови процес',
        'Deploy All Processes' => 'Распореди све процесе',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Овде можете учитати конфигурациону датотеку за увоз процеса у ваш систем. Датотека мора бити у .yml формату извезена од стране модула за управљање процесом.',
        'Upload process configuration' => 'Учитај конфигурацију процеса',
        'Import process configuration' => 'Увези конфигурацију процеса',
        'Ready2Adopt Processes' => 'Ready2Adopt процеси',
        'Here you can activate Ready2Adopt processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            'Овде можете активирати Ready2Adopt процесе примера најбоље праксе који су спремни за употребу. Молимо обратите пажњу да је можда неопходна додатна конфигурација.',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated Ready2Adopt processes.' =>
            'Да ли желите да искористите процесе креиране од стране експерата? Унапредите на %s за увоз примера софистицираних Ready2Adopt процеса спремних за употребу.',
        'Import Ready2Adopt process' => 'Увези Ready2Adopt процес',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'За креирање новог процеса можете или увести процес који је извезен из другог система или креирати комплетно нов.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Промене у процесима једино утичу на понашање система, ако синхронизујете податке процеса. Синхронизовањем процеса, новонаправљене промене ће бити уписане у конфигурацију.',
        'Processes' => 'Процеси',
        'Process name' => 'Назив процеса',
        'Print' => 'Штампај',
        'Export Process Configuration' => 'Извези конфигурацију процеса',
        'Copy Process' => 'Копирај процес',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Поништи & затвори',
        'Go Back' => 'Врати се назад',
        'Please note, that changing this activity will affect the following processes' =>
            'Напомињемо да ће измене ове активности утицати на пратеће процесе',
        'Activity' => 'Активност',
        'Activity Name' => 'Назив активности',
        'Activity Dialogs' => 'Дијалози активности',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Дијалоге активности можете доделити овој активности превлачењем елемената мишем од леве листе до десне листе.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Мењање редоследа елемената унутар листе је, такође, могуће преврачењем елемената и пуштањем.',
        'Filter available Activity Dialogs' => 'Филтрирај слободне дијалоге активности',
        'Available Activity Dialogs' => 'Слободни дијалози активности',
        'Name: %s, EntityID: %s' => 'Назив: %s, ID ентитета: %s',
        'Create New Activity Dialog' => 'Креирај нов дијалог активности',
        'Assigned Activity Dialogs' => 'Додељени дијалози активности',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Напомињемо да ће промена овог дијалога активности утицати на пратеће активности',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Напомињемо да клијенти корисници нису у могућности да виде или користе следећа поља: Owner, Responsible, Lock, PendingTime и CustomerID.',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Поље у реду једино може бити коришћено од стране клијента када креирају нови тикет.',
        'Activity Dialog' => 'Дијалог активности',
        'Activity dialog Name' => 'Назив дијалога активности',
        'Available in' => 'Расположиво у',
        'Description (short)' => 'Опис (кратак)',
        'Description (long)' => 'Опис (дугачак)',
        'The selected permission does not exist.' => 'Изабрана овлашћења не постоје.',
        'Required Lock' => 'Обавезно закључај',
        'The selected required lock does not exist.' => 'Одабрано захтевано закључавање не постоји.',
        'Submit Advice Text' => 'Пошаљи текст савета',
        'Submit Button Text' => 'Пошаљи текст дугмета',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Поља можете доделити у овом дијалогу активности превлачењем елемената мишем из леве листе у десну листу.',
        'Filter available fields' => 'Филтрирај расположива поља',
        'Available Fields' => 'Расположива поља',
        'Assigned Fields' => 'Додељена поља',
        'Communication Channel' => 'Комуникациони канал',
        'Is visible for customer' => 'Видљиво клијенту',
        'Display' => 'Прикажи',

        # Template: AdminProcessManagementPath
        'Path' => 'Путања',
        'Edit this transition' => 'Уредите ову транзицију',
        'Transition Actions' => 'Транзиционе акције',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Можете доделити транзиционе активности у овој транзицији превлачењем елемената мишем из леве листе у десну листу.',
        'Filter available Transition Actions' => 'Филтрирај расположиве транзиционе активности',
        'Available Transition Actions' => 'Расположиве транзиционе акције',
        'Create New Transition Action' => 'Креирај нову транзициону активност',
        'Assigned Transition Actions' => 'Додељене транзиционе активности',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Активности',
        'Filter Activities...' => 'Филтрирај активности ...',
        'Create New Activity' => 'Креирај нову активност',
        'Filter Activity Dialogs...' => 'Филтрирај дијалоге активности ...',
        'Transitions' => 'Транзиције',
        'Filter Transitions...' => 'Филтрирај транзиције ...',
        'Create New Transition' => 'Креирај нову транзицију',
        'Filter Transition Actions...' => 'Филтрирај транзиционе активности ...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Уреди процес',
        'Print process information' => 'Штампај информације процеса',
        'Delete Process' => 'Избриши процес',
        'Delete Inactive Process' => 'Избриши неактиван процес',
        'Available Process Elements' => 'Расположиви елементи процеса',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Елементи, наведени горе у издвојеном одељку, могу да се померају по површини на десну страну коришћењем превуци и пусти технике.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Можете поставити активности на поврсину како би доделити ову активност процесу.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'За додељивање Дијалога Активности некој активности, превуците елемент дијалога активности из издвојеног дела, преко активности смештене на површини.',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Везу између две активности можете започети превлачењем елемента транзиције преко почетка активности везе. Након тога можете да преместите слободан крај стрелице до краја активности.',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Активност може бити додељена транзицији превлачењем елемента активности на ознаку транзиције.',
        'Edit Process Information' => 'Уреди информације о процесу',
        'Process Name' => 'Назив процеса',
        'The selected state does not exist.' => 'Одабрани статус не постоји.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Додај и уреди активости, дијалоге активности и транзиције',
        'Show EntityIDs' => 'Покажи ID ентитета',
        'Extend the width of the Canvas' => 'Прошири ширину простора',
        'Extend the height of the Canvas' => 'Продужи висину простора',
        'Remove the Activity from this Process' => 'Уклони активност из овог процеса',
        'Edit this Activity' => 'Уреди ову активност',
        'Save Activities, Activity Dialogs and Transitions' => 'Сачувај активости, дијалоге активности и транзиције',
        'Do you really want to delete this Process?' => 'Да ли стварно желите да обришете овај процес?',
        'Do you really want to delete this Activity?' => 'Да ли стварно желите да обришете ову активност?',
        'Do you really want to delete this Activity Dialog?' => 'Да ли стварно желите да обришете овај дијалог активности?',
        'Do you really want to delete this Transition?' => 'Да ли стварно желите да обришете ову транзицију?',
        'Do you really want to delete this Transition Action?' => 'Да ли стварно желите да обришете ову транзициону активност?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Да ли стварно желите да уклоните ову активност са површине? Ово једино може да се опозове уколико напустите екран, а да претходно не сачувате измене.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Да ли стварно желите да уклоните ову транзицију са површине? Ово једино може да се опозове уколико напустите екран, а да претходно не сачувате измене.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'У овом екрану можете креирати нови процес. Да би нови процес био доступан корисницима, молимо вас да поставите статус на \'Active\' и урадите синхронизацију након завршетка вашег рада.',

        # Template: AdminProcessManagementProcessPrint
        'cancel & close' => 'поништи & затвори',
        'Start Activity' => 'Почетак активности',
        'Contains %s dialog(s)' => 'Садржи %s дијалога',
        'Assigned dialogs' => 'Додељени дијалози',
        'Activities are not being used in this process.' => 'Активности се не користе у овом процесу.',
        'Assigned fields' => 'Додељена поља',
        'Activity dialogs are not being used in this process.' => 'Дијалози активности се не користе у овом процесу.',
        'Condition linking' => 'Услов повезивања',
        'Transitions are not being used in this process.' => 'Транзиције се не користе у овом процесу.',
        'Module name' => 'Назив модула',
        'Transition actions are not being used in this process.' => 'Транзиционе активности се не користе у овом процесу.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Напомињемо да би мењење ове транзиције утицало на пратеће процесе',
        'Transition' => 'Транзиција',
        'Transition Name' => 'Назив транзиције',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Напомињемо да би мењење ове транзиционе активности утицало на пратеће процесе',
        'Transition Action' => 'Транзициона активност',
        'Transition Action Name' => 'Назив транзиционе активности',
        'Transition Action Module' => 'Модул транзиционе активности',
        'Config Parameters' => 'Конфигурациони параметри',
        'Add a new Parameter' => 'Додај нови параметар',
        'Remove this Parameter' => 'Уклони овај параметар',

        # Template: AdminQueue
        'Queue Management' => 'Управљање редовима',
        'Add Queue' => 'Додај Ред',
        'Edit Queue' => 'Уреди Ред',
        'Filter for Queues' => 'Филтер за редове',
        'Filter for queues' => 'Филтер за редове',
        'A queue with this name already exists!' => 'Ред са овим називом већ постоји!',
        'This queue is present in a SysConfig setting, confirmation for updating settings to point to the new queue is needed!' =>
            'Овај ред се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност!',
        'Sub-queue of' => 'Под-ред од',
        'Unlock timeout' => 'Време до откључавања',
        '0 = no unlock' => '0 = нема откључавања',
        'hours' => 'сати',
        'Only business hours are counted.' => 'Рачуна се само радно време.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Ако оператер закључа тикет и не откључа га пре истека времена откључавања, тикет ће се откључати и постати доступан другим запосленима.',
        'Notify by' => 'Обавештен од',
        '0 = no escalation' => '0 = нема ескалације',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Ако контакт са клијентом, било спољашњи имејл или позив, није додат на нови тикет пре истицања дефинисаног времена, тикет ће ескалирати.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Ако постоји додат чланак, као нпр. наставак преко имејл поруке или клијентског портала, време ажурирања ескалације се ресетује. Ако не постоје контакт подаци о клијенту, било имејл или позив додати на тикет пре истицања овде дефинисаног времена, тикет ће ескалирати.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Ако се тикет не затвори пре овде дефинисаног времена, тикет ескалира.',
        'Follow up Option' => 'Опције наставка',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Дефинишите да ли наставак на затворени тикет поново отвара тикет или отвара нови.',
        'Ticket lock after a follow up' => 'Закључавање тикета после наставка',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Ако је тикет затворен, а клијент пошаље наставак, тикет ће бити закључан на старог власника.',
        'System address' => 'Системска адреса',
        'Will be the sender address of this queue for email answers.' => 'Биће адреса пошиљаоца за имејл одговоре из овог реда.',
        'Default sign key' => 'Подразумевани кључ потписа',
        'To use a sign key, PGP keys or S/MIME certificates need to be added with identifiers for selected queue system address.' =>
            'За коришћење својства потписивања, PGP кључеви или S/MIME сертификати идентитета морају бити додати за системску адресу одабраног реда.',
        'Salutation' => 'Поздрав',
        'The salutation for email answers.' => 'Поздрав за имејл одговоре.',
        'Signature' => 'Потпис',
        'The signature for email answers.' => 'Потпис за имејл одговоре.',
        'This queue is used in the following config settings:' => 'Овај ред се користи у следећим системским подешавањима:',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Управљање везама ред-аутоматски одговор',
        'Change Auto Response Relations for Queue' => 'Промени релације са аутоматским одговорима за ред',
        'This filter allow you to show queues without auto responses' => 'Овај филтер вам омогућава приказ редова без аутоматских одговора',
        'Queues without Auto Responses' => 'Редови без аутоматских одговора',
        'This filter allow you to show all queues' => 'Овај филтер вам омогућава приказ свих редова',
        'Show All Queues' => 'Прикажи све редове',
        'Auto Responses' => 'Аутоматски одговори',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Управљање односом шаблон-ред',
        'Filter for Templates' => 'Филтер за шаблоне',
        'Filter for templates' => 'Филтер за шаблоне',
        'Templates' => 'Шаблони',

        # Template: AdminRegistration
        'System Registration Management' => 'Управљање системом регистрације',
        'Edit System Registration' => 'Уреди регистрацију система',
        'System Registration Overview' => 'Преглед регистрације система',
        'Register System' => 'Региструј систем',
        'Validate OTRS-ID' => 'Провери важност OTRS-ID',
        'Deregister System' => 'Искључи систем из регистра',
        'Edit details' => 'Уреди детаље',
        'Show transmitted data' => 'Покажи послате податке',
        'Deregister system' => 'Одјави систем',
        'Overview of registered systems' => 'Преглед регистрованих система',
        'This system is registered with OTRS Group.' => 'Овај систем је регистрован у OTRS групи.',
        'System type' => 'Тип система',
        'Unique ID' => 'Јединствени ID',
        'Last communication with registration server' => 'Последња комуникација са регистрационим сервером',
        'System Registration not Possible' => 'Регистрација система није могућа',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Молимо да обратите пажњу да не можете регистровати ваш систем ако OTRS системски процес не ради коректно!',
        'Instructions' => 'Инструкције',
        'System Deregistration not Possible' => 'Одјава система није могућа',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Молимо да обратите пажњу да не можете дерегистровати ваш систем ако користите %s или имате важећи сервисни уговор.',
        'OTRS-ID Login' => 'OTRS-ID пријава',
        'Read more' => 'Прочитај више',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Потребно је да се пријавите са вашим OTRS-ID да региструјете ваш систем.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Ваш OTRS-ID је имејл адреса коју користите за пријаву на веб страну OTRS.com.',
        'Data Protection' => 'Заштита података',
        'What are the advantages of system registration?' => 'Које су предности регистрације система?',
        'You will receive updates about relevant security releases.' => 'Добићете ажурирања одговарајућих безбедносних издања.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Са регистрацијом система можемо побољшати наше услуге за вас, јер ми имамо доступне све релевантне информације.',
        'This is only the beginning!' => 'Ово је само почетак!',
        'We will inform you about our new services and offerings soon.' =>
            'Информисаћемо вас о нашим новим услугама и понудама ускоро!',
        'Can I use OTRS without being registered?' => 'Да ли могу да користим OTRS уколико нисам регистрован?',
        'System registration is optional.' => 'Регистрација система је опционална.',
        'You can download and use OTRS without being registered.' => 'Можете преузети OTRS и уколико нисте регистровани.',
        'Is it possible to deregister?' => 'Да ли је могућа одјава?',
        'You can deregister at any time.' => 'Можете се одјавити у било које доба.',
        'Which data is transfered when registering?' => 'Који подаци се преносе приликом регистрације?',
        'A registered system sends the following data to OTRS Group:' => 'Регистровани систем шаље следеће податке OTRS групи:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Пуно квалификовано име домена (FQDN), OTRS верзија, база података, оперативни систем и Perl верзија.',
        'Why do I have to provide a description for my system?' => 'Зашто морам да проследим опис мог система?',
        'The description of the system is optional.' => 'Опис система је опциони.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Наведени опис и тип система помажу вам да идентификујете и управљате детаљима регистрованог система.',
        'How often does my OTRS system send updates?' => 'Колико често ће мој OTRS систем слати ажурирања?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Ваш систем ће у редовним временским интервалима слати ажурирања регистрационом серверу.',
        'Typically this would be around once every three days.' => 'Обично је то једном у свака три дана.',
        'If you deregister your system, you will lose these benefits:' =>
            'Ако дерегиструјете ваш систем, изгубићете следеће олакшице:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Да би сте ођавили ваш систем, морате да се пријавите са вашим OTRS-ID',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Још увек немате OTRS-ID?',
        'Sign up now' => 'Региструјте се сада',
        'Forgot your password?' => 'Заборавили сте лозинку?',
        'Retrieve a new one' => 'Преузми нову',
        'Next' => 'Следеће',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Ови подаци ће бити послати OTRS групи када региструјете овај систем.',
        'Attribute' => 'Атрибут',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRS верзија',
        'Operating System' => 'Оперативни систем',
        'Perl Version' => 'Perl верзија',
        'Optional description of this system.' => 'Опциони опис овог система.',
        'Register' => 'Региструј',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Настављање овог корака ће одјавити систем из OTRS групе.',
        'Deregister' => 'Искључи из регистра',
        'You can modify registration settings here.' => 'Овде можете изменити регистрациона подешавања.',
        'Overview of Transmitted Data' => 'Преглед послатих података',
        'There is no data regularly sent from your system to %s.' => 'Нема података који су редовно слати са вашег система за %s.',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            'Следећи подаци су слати барем свака 3 дана са вашег система за %s.',
        'The data will be transferred in JSON format via a secure https connection.' =>
            'Подаци ће бити послати у JSON формату преко сигурне https везе. ',
        'System Registration Data' => 'Подаци о регистрацији система',
        'Support Data' => 'Подаци подршке',

        # Template: AdminRole
        'Role Management' => 'Управљање улогама',
        'Add Role' => 'Додај Улогу',
        'Edit Role' => 'Уреди Улогу',
        'Filter for Roles' => 'Филтер за улоге',
        'Filter for roles' => 'Филтер за улоге',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Направи улогу и додај групе у њу. Онда додај улогу корисницима.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Нема дефинисаних улога. употребите дугме \'Add\' за креирање нове улоге.',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Управљање везама улога-група',
        'Roles' => 'Улоге',
        'Select the role:group permissions.' => 'Изабери дозволе за улогу:групу',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Уколико ништа није изабрано, онда нема дозвола у овој групи (тикети неће бити доступни за ову улогу).',
        'Toggle %s permission for all' => 'Промени %s дозволе за све',
        'move_into' => 'премести у',
        'Permissions to move tickets into this group/queue.' => 'Дозволе да се тикети преместе у ову групу/ред.',
        'create' => 'креирај',
        'Permissions to create tickets in this group/queue.' => 'Дозвола да се тикет креира у ову групу/ред.',
        'note' => 'напомена',
        'Permissions to add notes to tickets in this group/queue.' => 'Дозволе за додавање напомена на тикете у овој групи/реду.',
        'owner' => 'власник',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Дозволе за промену власника тикета у овој групи/реду.',
        'priority' => 'приоритет',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Дозвола да се мења приоритет тикета у овој групи/реду.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Управљање везама оператер-улога',
        'Add Agent' => 'Додај Оператера',
        'Filter for Agents' => 'Филтер за оператере',
        'Filter for agents' => 'Филтер за оператере',
        'Agents' => 'Оператери',
        'Manage Role-Agent Relations' => 'Управљање релацијама улога-оператер',

        # Template: AdminSLA
        'SLA Management' => 'Управљање SLA',
        'Edit SLA' => 'Уреди SLA',
        'Add SLA' => 'Додај SLA',
        'Filter for SLAs' => 'Филтер за SLA',
        'Please write only numbers!' => 'Молимо пишите само бројеве!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME управљање',
        'Add Certificate' => 'Додај сертификат',
        'Add Private Key' => 'Додај приватни кључ',
        'SMIME support is disabled' => 'SMIME подршка је онемогућена',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            'Да би могли да користите SMIME у OTRS, морате је прво омогућити.',
        'Enable SMIME support' => 'Омогући SMIME подршку',
        'Faulty SMIME configuration' => 'Неисправна SMIME конфигурација',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            'SMIME подршка ја омогућена али релевантна конфигурација садржи грешке. Молимо да проверите конфигурацију притиском на дугме испод.',
        'Check SMIME configuration' => 'Провери SMIME конфигурацију',
        'Filter for Certificates' => 'Филтер за сертификате',
        'Filter for certificates' => 'Филтер за сертификате',
        'To show certificate details click on a certificate icon.' => 'За приказивање детаља сертификата кликни на иконицу сертификат.',
        'To manage private certificate relations click on a private key icon.' =>
            'За управљање везама приватног сертификата кликните на иконицу приватни кључ.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            'Овде можете додати везе на ваш приватни сертификат, што ће бити уграђено у S/MIME потпис сваки пут кад употребите овај сертификат за потпис имејла.',
        'See also' => 'Погледај још',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'На овај начин можете директно да уређујете сертификате и приватне кључеве у систему датотека.',
        'Hash' => 'Hash',
        'Create' => 'Креирај',
        'Handle related certificates' => 'Руковање повезаним сертификатима',
        'Read certificate' => 'Читај сертификат',
        'Delete this certificate' => 'Обриши овај сертификат',
        'File' => 'Датотека',
        'Secret' => 'Тајна',
        'Related Certificates for' => 'Повезани сертификати за',
        'Delete this relation' => 'Обриши ову везу',
        'Available Certificates' => 'Расположиви сертификати',
        'Filter for S/MIME certs' => 'Филтер за S/MIME сертификате',
        'Relate this certificate' => 'Повежи овај сертификат',

        # Template: AdminSMIMECertRead
        'S/MIME Certificate' => 'S/MIME сертификат',
        'Close this dialog' => 'Затвори овај дијалог',
        'Certificate Details' => 'Детаљи сертификата',

        # Template: AdminSalutation
        'Salutation Management' => 'Управљање поздравима',
        'Add Salutation' => 'Додај Поздрав',
        'Edit Salutation' => 'Уреди Поздрав',
        'Filter for Salutations' => 'Филтер за поздраве',
        'Filter for salutations' => 'Филтер за поздраве',
        'e. g.' => 'нпр.',
        'Example salutation' => 'Пример поздрава',

        # Template: AdminSecureMode
        'Secure Mode Needs to be Enabled!' => 'Потребно је да сигуран мод буде укључен!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Сигуран мод ће (уобичајено) бити подешен након иницијалне инсталације.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Уколико сигуран мод није активиран, покрените га кроз системску конфигурацију јер је ваша апликација већ покренута.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Бокс',
        'Filter for Results' => 'Филтер за резултате',
        'Filter for results' => 'Филтер за резултате',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Овде можете унети SQL команде и послати их директно апликационој бази података. Није могуће мењати садржај табела, дозвољен је једино \'select\' упит.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Овде можете унети SQL команде и послати их директно апликационој бази података.',
        'Options' => 'Опције',
        'Only select queries are allowed.' => 'Дозвољени су само \'select\' упити.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Постоји грешка у синтакси вашег SQL упита. Молимо проверите.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Најмање један параметар недостаје за повезивање. Молимо проверите.',
        'Result format' => 'Формат резултата',
        'Run Query' => 'Покрени упит',
        '%s Results' => '%s Резултати',
        'Query is executed.' => 'Упит је извршен.',

        # Template: AdminService
        'Service Management' => 'Управљање услугама',
        'Add Service' => 'Додај услугу',
        'Edit Service' => 'Уреди услугу',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            'Максимална дужина назива услуге је 200 карактера (са под-услугом).',
        'Sub-service of' => 'Под-услуга од',

        # Template: AdminSession
        'Session Management' => 'Управљање сесијама',
        'Detail Session View for %s (%s)' => 'Детаљни приказ сесије за %s (%s)',
        'All sessions' => 'Све сесије',
        'Agent sessions' => 'Сесије оператера',
        'Customer sessions' => 'Сесије клијената',
        'Unique agents' => 'Јединствени оператери',
        'Unique customers' => 'Јединствени клијенти',
        'Kill all sessions' => 'Угаси све сесије',
        'Kill this session' => 'Угаси ову сесију',
        'Filter for Sessions' => 'Филтер за сесије',
        'Filter for sessions' => 'Филтер за сесије',
        'Session' => 'Сесија',
        'User' => 'Корисник',
        'Kill' => 'Угаси',
        'Detail View for SessionID: %s - %s' => 'Детаљни преглед за ID сесије: %s - %s',

        # Template: AdminSignature
        'Signature Management' => 'Управљање потписима',
        'Add Signature' => 'Додај Потпис',
        'Edit Signature' => 'Уреди Потпис',
        'Filter for Signatures' => 'Филтер за потписе',
        'Filter for signatures' => 'Филтер за потписе',
        'Example signature' => 'Пример потписа',

        # Template: AdminState
        'State Management' => 'Управљање статусима',
        'Add State' => 'Додај Статус',
        'Edit State' => 'Уреди Статус',
        'Filter for States' => 'Филтер за стања',
        'Filter for states' => 'Филтер за стања',
        'Attention' => 'Пажња',
        'Please also update the states in SysConfig where needed.' => 'Молимо да ажурирате стаусе и у системској конфигурацији где је то потребно.',
        'This state is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Ово стање се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност! ',
        'State type' => 'Тип статуса',
        'It\'s not possible to invalidate this entry because there is no other merge states in system!' =>
            'Није могуће обележити ову ставку као неважећу јер не постоји више статуса спојених тикета у систему!',
        'This state is used in the following config settings:' => 'Ово стање се користи у следећим системским подешавањима: ',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => 'Слање података за подршку OTRS групи није могуће!',
        'Enable Cloud Services' => 'Активирај сервисе у облаку',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Ови подаци се шаљу OTRS групи у регуларном интервалу. Да зауставите слање ових података молимо вас да ажурирате регистрацију.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Можете мануелно активирати слање подржаних података притискањем овог дугмета:',
        'Send Update' => 'Пошаљи ажурирање',
        'Currently this data is only shown in this system.' => 'Тренутно су ови подаци приказани само у овом систему.',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            'Пакет за подршку (укључујући: информације о регистрацији система, податке за подршку, листу инсталираних пакета и свих локално модификованих датотека изворног кода) може бити генерисан притиском на ово дугме:',
        'Generate Support Bundle' => 'Генериши пакет подршке',
        'The Support Bundle has been Generated' => 'Пакет подршке је генерисан',
        'Please choose one of the following options.' => 'Молимо изаберите једну од понуђених опција.',
        'Send by Email' => 'Послато имејлом',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Пакет подршке је превелик за слање путем имејла, ова опција је онемогућена.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Имејл адреса овог корисника је неважећа, ова опција је искључена.',
        'Sending' => 'Слање',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'Пакет подршке ће бити аутоматски послат имејлом OTRS групи.',
        'Download File' => 'Преузми датотеку',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Датотека која садржи пакет за подршку ће бити преузета на локални рачунар. Молимо вас да сачувате датотеку и да је пошаљете на неки други начин OTRS групи.',
        'Error: Support data could not be collected (%s).' => 'Подржани подаци не могу бити прикупљени (%s).',
        'Details' => 'Детаљи',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Управљање системском имејл адресом',
        'Add System Email Address' => 'Додај системску имејл адресу',
        'Edit System Email Address' => 'Уреди системску имејл адресу',
        'Add System Address' => 'Додај системску адресу',
        'Filter for System Addresses' => 'Филтер за системске адресе',
        'Filter for system addresses' => 'Филтер за системске адресе',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Све долазне поруке са овом адресом у пољу To или Cc биће отпремљене у изабрани ред.',
        'Email address' => 'Имејл адреса',
        'Display name' => 'Прикажи назив',
        'This email address is already used as system email address.' => 'Ова имејл адреса је већ употребљена као системска имејл адреса.',
        'The display name and email address will be shown on mail you send.' =>
            'Приказано име и имејл адреса ће бити приказани на поруци коју сте послали.',
        'This system address cannot be set to invalid.' => 'Ова системска адреса се не може означити као неважећа.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).' =>
            'Ова системска адреса се не може означити као неважећа јер се користи у једном или више аутоматских одговора.',

        # Template: AdminSystemConfiguration
        'online administrator documentation' => 'приручника за администраторе',
        'System configuration' => 'Системска конфигурација',
        'Navigate through the available settings by using the tree in the navigation box on the left side.' =>
            'Прегледајте доступна подешавањеа коришћењем навигације са леве стране.',
        'Find certain settings by using the search field below or from search icon from the top navigation.' =>
            'Претражите одговарајућа подешавања коришћењем поља за претрагу испод или преко иконице за претрагу на горњој навигацији.',
        'Find out how to use the system configuration by reading the %s.' =>
            'Сазнајте како да користите системску конфигурацију читањем %s.',
        'Search in all settings...' => 'Претражите сва подешавања...',
        'There are currently no settings available. Please make sure to run \'otrs.Console.pl Maint::Config::Rebuild\' before using the software.' =>
            'Тренутно нема доступних подешавања. Молимо проверите да ли сте покренули скрипт \'otrs.Console.pl Maint::Config::Rebuild\' пре коришћења апликације.',

        # Template: AdminSystemConfigurationDeployment
        'Changes Deployment' => 'Распоред промена',
        'Help' => 'Помоћ',
        'This is an overview of all settings which will be part of the deployment if you start it now. You can compare each setting to its former state by clicking the icon on the top right.' =>
            'Ово је преглед свих подешавања која ће бити део распореда уколико га покренете. Моћете их упоредити са претходним стањем кликом на иконицу у горњем десном углу.',
        'To exclude certain settings from a deployment, click the checkbox on the header bar of a setting.' =>
            'За изузимање појединачних подешавања из распореда, активирајте кућицу у заглављу подешавања.',
        'By default, you will only deploy settings which you changed on your own. If you\'d like to deploy settings changed by other users, too, please click the link on top of the screen to enter the advanced deployment mode.' =>
            'Подразумевано, биће распоређена само подешавања која сте ви изменили. Уколико желите да распоредите и подешавања измењена од стране других корисника, молимо кликните на везу при врху екрана за приступ екрану напредног распореда.',
        'A deployment has just been restored, which means that all affected setting have been reverted to the state from the selected deployment.' =>
            'Распоред је обновљен, што значи да су сва подешавања постављена на вредности из одабраног распореда.',
        'Please review the changed settings and deploy afterwards.' => 'Молимо прегледајте измењена подешавања и распоредите их.',
        'An empty list of changes means that there are no differences between the restored and the current state of the affected settings.' =>
            'Празна листа промена значи да нема промена између обновљеног и тренутног стања вредности подешавања.',
        'Changes Overview' => 'Преглед промена',
        'There are %s changed settings which will be deployed in this run.' =>
            'Укупно %s промењених подешавања ће бити распоређено.',
        'Switch to basic mode to deploy settings only changed by you.' =>
            'Пређите на основни мод за распоред подешавања које сте само ви променили.',
        'You have %s changed settings which will be deployed in this run.' =>
            'Имате %s промењених подешавања која ће бити распоређена.',
        'Switch to advanced mode to deploy settings changed by other users, too.' =>
            'Пређите на напредни мод за распоред подешавања које су променили и остали корисници.',
        'There are no settings to be deployed.' => 'Нема подешавања која се могу распоредити.',
        'Switch to advanced mode to see deployable settings changed by other users.' =>
            'Прежите на напредни мод да видите која подешавања промењена од стране осталих корисника могу бити распоређена.',
        'Deploy selected changes' => 'Распореди означене промене',

        # Template: AdminSystemConfigurationGroup
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups.' =>
            'Ова категорија не садржи ниједно подешавање. Молимо пробајте неку од под-група.',

        # Template: AdminSystemConfigurationImportExport
        'Import & Export' => 'Увоз & извоз',
        'Upload a file to be imported to your system (.yml format as exported from the System Configuration module).' =>
            'Отпремите датотеку за увоз у ваш систем (.yml формат извезен из модула системске конфигурације).',
        'Upload system configuration' => 'Отпреми системску конфигурацију',
        'Import system configuration' => 'Увези системску конфигурацију',
        'Download current configuration settings of your system in a .yml file.' =>
            'Преузмите тренутну конфигурацију вашег система као .yml датотеку.',
        'Include user settings' => 'Укључи корисничка подешавања',
        'Export current configuration' => 'Извези тренутну конфигурацију',

        # Template: AdminSystemConfigurationSearch
        'Search for' => 'Тражи за',
        'Search for category' => 'Тражи за категорију',
        'Settings I\'m currently editing' => 'Подешавања која тренутно мењате',
        'Your search for "%s" in category "%s" did not return any results.' =>
            'Ваша претрага за "%s" у категорији "%s" није вратила резултате.',
        'Your search for "%s" in category "%s" returned one result.' => 'Ваша претрага за "%s" у категорији "%s" је вратила један резултат.',
        'Your search for "%s" in category "%s" returned %s results.' => 'Ваша претрага за "%s" у категорији "%s" је вратила %s резултат(a).',
        'You\'re currently not editing any settings.' => 'Тренутно не мењате ниједно подешавање.',
        'You\'re currently editing %s setting(s).' => 'Тренутно мењате %s подешавање/а.',

        # Template: AdminSystemConfigurationSearchDialog
        'Category' => 'Категорија',
        'Run search' => 'Покрени претрагу',

        # Template: AdminSystemConfigurationView
        'View a custom List of Settings' => 'Преглед листе подешавања',
        'View single Setting: %s' => 'Преглед појединачног подешавања: %s',
        'Go back to Deployment Details' => 'Назад на детаље распоређивања',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'Управљање системом одржавања',
        'Schedule New System Maintenance' => 'Планирај ново оржавање система.',
        'Filter for System Maintenances' => 'Филтер за одржавања система',
        'Filter for system maintenances' => 'Филтер за одржавања система',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            'Планирање периода одржавања система ради обавештавања оператера и клијената да је систем искључен у том периоду. ',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            'Неко време пре него отпочне одржавање система, корисници ће добити обавештење које најављује овај догађај на сваки екран.',
        'Stop date' => 'Датум завршетка',
        'Delete System Maintenance' => 'Обриши одржавање система',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance' => 'Уреди одржавање система',
        'Edit System Maintenance Information' => 'Уреди одржавање система',
        'Date invalid!' => 'Неисправан датум',
        'Login message' => 'Порука пријаве',
        'This field must have less then 250 characters.' => 'Ово поље не сме бити дуже од 250 карактера.',
        'Show login message' => 'Покажи поруку пријаве',
        'Notify message' => 'Порука обавештења',
        'Manage Sessions' => 'Управљање сесијама',
        'All Sessions' => 'Све сесије',
        'Agent Sessions' => 'Сесије оператера',
        'Customer Sessions' => 'Сесије клијената',
        'Kill all Sessions, except for your own' => 'Прекини све сесије, осим сопствене',

        # Template: AdminTemplate
        'Template Management' => 'Управљање шаблонима',
        'Add Template' => 'Додај Шаблон',
        'Edit Template' => 'Уреди Шаблон',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Шаблон је подразумевани текст који помаже вашим агентима да брже испишу тикете, одговоре или прослеђене поруке.',
        'Don\'t forget to add new templates to queues.' => 'Не заборавите да додате нови шаблон у реду.',
        'Attachments' => 'Прилози',
        'Delete this entry' => 'Обриши овај унос',
        'Do you really want to delete this template?' => 'Да ли стварно желите да обришете овај шаблон?',
        'A standard template with this name already exists!' => 'Стандардни шаблон са овим називом већ постоји!',
        'Template' => 'Шаблон',
        'To get the first 20 characters of the subject of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest agent article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 20 characters of the subject of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'To get the first 5 lines of the body of the current/latest article (current for Answer and Forward, latest for Note template type). This tag is not supported for other template types.' =>
            '',
        'Create type templates only supports this smart tags' => 'Креирај тип шаблона који подржавају само ове паметне ознаке.',
        'Example template' => 'Пример шаблона',
        'The current ticket state is' => 'Тренутни стаус тикета је',
        'Your email address is' => 'Ваша имејл адреса је',

        # Template: AdminTemplateAttachment
        'Manage Template-Attachment Relations' => 'Управљање релацијама шаблони-прилози',
        'Toggle active for all' => 'Промени стање у активан за све',
        'Link %s to selected %s' => 'Повежи %s са изабраним %s',

        # Template: AdminType
        'Type Management' => 'Управљање типовима',
        'Add Type' => 'Додај Тип ',
        'Edit Type' => 'Уреди Тип',
        'Filter for Types' => 'Филтер за типове',
        'Filter for types' => 'Филтер за типове',
        'A type with this name already exists!' => 'Тип са овим називом већ постоји!',
        'This type is present in a SysConfig setting, confirmation for updating settings to point to the new type is needed!' =>
            'Овај тип се користи у системској конфигурацији, неопходна је додатна потврда за промену подешавања на нову вредност!',
        'This type is used in the following config settings:' => 'Овај тип се користи у следећим системским подешавањима:',

        # Template: AdminUser
        'Agent Management' => 'Управљање оператерима',
        'Edit Agent' => 'Уреди Оператера',
        'Edit personal preferences for this agent' => 'Уредите лична подешавања за овог оператера',
        'Agents will be needed to handle tickets.' => 'Биће потребни оператери за обраду тикета.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Не заборавите да додате новог оператера у групе и/или улоге!',
        'Please enter a search term to look for agents.' => 'Молимо унесите појам за претрагу ради налажења оператера.',
        'Last login' => 'Претходна пријава',
        'Switch to agent' => 'Пређи на оператера',
        'Title or salutation' => 'Наслов поздрава',
        'Firstname' => 'Име',
        'Lastname' => 'Презиме',
        'A user with this username already exists!' => 'Ово корисничко име је већ употребљено!',
        'Will be auto-generated if left empty.' => 'Биће аутоматски генерисано ако се остави празно.',
        'Mobile' => 'Мобилни',
        'Effective Permissions for Agent' => 'Ефективне дозоле за оператера',
        'This agent has no group permissions.' => 'Овај оператер нема дозволе за групе.',
        'Table above shows effective group permissions for the agent. The matrix takes into account all inherited permissions (e.g. via roles).' =>
            'Табела изнад приказује ефективне дозволе за групе оператера. Матрица узима у обзир све наслеђене дозволе (нпр. путем улога).',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Управљање релацијама оператер-група',

        # Template: AgentAppointmentAgendaOverview
        'Agenda Overview' => 'Преглед дневног реда',
        'Manage Calendars' => 'Управљање календарима',
        'Add Appointment' => 'Додај термин',
        'Today' => 'Данас',
        'All-day' => 'Целодневно',
        'Repeat' => 'Понављање',
        'Notification' => 'Обавештење',
        'Yes' => 'Да',
        'No' => 'Не',
        'No calendars found. Please add a calendar first by using Manage Calendars page.' =>
            'Није пронађен ниједан календар. Молимо прво додајте календар коришћењем екрана Управљање календарима.',

        # Template: AgentAppointmentCalendarOverview
        'Add new Appointment' => 'Додај нови термин',
        'Calendars' => 'Календари',

        # Template: AgentAppointmentEdit
        'Basic information' => 'Основне информације',
        'Date/Time' => 'Датум/време',
        'Invalid date!' => 'Неважећи датум!',
        'Please set this to value before End date.' => 'Молимо поставите овај датум пре краја.',
        'Please set this to value after Start date.' => 'Молимо поставите овај датум после почетка.',
        'This an occurrence of a repeating appointment.' => 'Ово је термин који се понавља.',
        'Click here to see the parent appointment.' => 'Кликните овде за преглед матичног термина.',
        'Click here to edit the parent appointment.' => 'Кликните овде за измену матичног термина.',
        'Frequency' => 'Учесталост',
        'Every' => 'Сваког(е)',
        'day(s)' => 'дан(и)',
        'week(s)' => 'недеља(е)',
        'month(s)' => 'месец(и)',
        'year(s)' => 'година(е)',
        'On' => 'Укључено',
        'Monday' => 'понедељак',
        'Mon' => 'пон',
        'Tuesday' => 'уторак',
        'Tue' => 'уто',
        'Wednesday' => 'среда',
        'Wed' => 'сре',
        'Thursday' => 'четвртак',
        'Thu' => 'чет',
        'Friday' => 'петак',
        'Fri' => 'пет',
        'Saturday' => 'субота',
        'Sat' => 'суб',
        'Sunday' => 'недеља',
        'Sun' => 'нед',
        'January' => 'јануар',
        'Jan' => 'Јан',
        'February' => 'фебруар',
        'Feb' => 'Феб',
        'March' => 'март',
        'Mar' => 'Мар',
        'April' => 'април',
        'Apr' => 'Апр',
        'May_long' => 'мај',
        'May' => 'Мај',
        'June' => 'јун',
        'Jun' => 'Јун',
        'July' => 'јул',
        'Jul' => 'Јул',
        'August' => 'август',
        'Aug' => 'Авг',
        'September' => 'септембар',
        'Sep' => 'Сеп',
        'October' => 'октобар',
        'Oct' => 'Окт',
        'November' => 'новембар',
        'Nov' => 'Нов',
        'December' => 'децембар',
        'Dec' => 'Дец',
        'Relative point of time' => 'Релативно време',
        'Link' => 'Повежи',
        'Remove entry' => 'Уклони унос',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Клијентски информативни центар',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Клијент корисник',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Напомена: клијент је неважећи!',
        'Start chat' => 'Почни ћаскање',
        'Video call' => 'Видео позив',
        'Audio call' => 'Аудио позив',

        # Template: AgentCustomerUserAddressBook
        'Customer User Address Book' => 'Адресар клијент корисника',
        'Search for recipients and add the results as \'%s\'.' => 'Претражите за примаоце и додајте резултате као \'%s\'.',
        'Search template' => 'Шаблон претраге',
        'Create Template' => 'Направи шаблон',
        'Create New' => 'Направи нов',
        'Save changes in template' => 'Сачувај промене у шаблону',
        'Filters in use' => 'Филтери у употреби',
        'Additional filters' => 'Додатни филтери',
        'Add another attribute' => 'Додај још један атрибут',
        'The attributes with the identifier \'(Customer)\' are from the customer company.' =>
            'Атрибути са идентификатором \'(Customer)\' долазе из клијент фирми.',
        '(e. g. Term* or *Term*)' => '(нпр. Term* или *Term*)',

        # Template: AgentCustomerUserAddressBookOverview
        'Select all' => 'Изабери све',
        'The customer user is already selected in the ticket mask.' => 'Клијент корисник је већ одабран у форми тикета.',
        'Select this customer user' => 'Означи овог клијент корисника',
        'Add selected customer user to' => 'Додај означеног клијент корисника у',

        # Template: AgentCustomerUserAddressBookOverviewNavBar
        'Change search options' => 'Промени опције претраге',

        # Template: AgentCustomerUserInformationCenter
        'Customer User Information Center' => 'Клијент-кориснички информативни центар',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS сервис је системски процес који извршава асинхроне послове, нпр. окидање ескалација тикета, слање имејлова, итд.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'Покренут OTRS системски сервис је неопходан за исправно функционисање система.',
        'Starting the OTRS Daemon' => 'Покретање OTRS системског сервиса',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'Осигурава да датотека \'%s\' постоји (без .dist екстензије). Овај крон посао ће проверавати сваких 5 минута да ли OTRS системски сервис ради и покреће га ако је потребно.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'Извршите \'%s start\' да би били сигурни да су крон послови за OTRS корисника увек активни.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'После 5 минута, проверава да ли OTRS системски сервис функционише у систему (\'bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Командна табла',

        # Template: AgentDashboardAppointmentCalendar
        'New Appointment' => 'Нови термин',
        'Tomorrow' => 'Сутра',
        'Soon' => 'Ускоро',
        '5 days' => '5 дана',
        'Start' => 'Почетак',
        'none' => 'ни један',

        # Template: AgentDashboardCalendarOverview
        'in' => 'у',

        # Template: AgentDashboardCommon
        'Save settings' => 'Сачувај подешавања',
        'Close this widget' => 'Затвори овај додатак',
        'more' => 'још',
        'Available Columns' => 'Расположиве колоне',
        'Visible Columns (order by drag & drop)' => 'Видљиве колоне (редослед према превуци и пусти)',

        # Template: AgentDashboardCustomerIDList
        'Change Customer Relations' => 'Промени релације клијената',
        'Open' => 'Отворено',
        'Closed' => 'Затворени',
        '%s open ticket(s) of %s' => '%s отворених тикета од %s',
        '%s closed ticket(s) of %s' => '%s затворених тикета од %s',
        'Edit customer ID' => 'Уреди ID клијента',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Ескалирани тикети',
        'Open tickets' => 'Отворени тикети',
        'Closed tickets' => 'Затворени тикети',
        'All tickets' => 'Сви тикети',
        'Archived tickets' => 'Архивирани тикети',

        # Template: AgentDashboardCustomerUserInformation
        'Note: Customer User is invalid!' => 'Напомена: клијент корисник је неважећи!',

        # Template: AgentDashboardCustomerUserList
        'Customer user information' => 'Информације о клијент кориснику',
        'Phone ticket' => 'Тикет позива',
        'Email ticket' => 'Имејл тикет',
        'New phone ticket from %s' => 'Нови тикет позива од %s',
        'New email ticket to %s' => 'Нови имејл тикет од %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s је доступан!',
        'Please update now.' => 'Молимо ажурирајте сада.',
        'Release Note' => 'Напомена уз издање',
        'Level' => 'Ниво',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Послато пре %s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Конфигурација за овај статистички додатак садржи грешке, молимо проверите ваша подешавања.',
        'Download as SVG file' => 'Преузми као SVG датотеку',
        'Download as PNG file' => 'Преузми као PNG датотеку',
        'Download as CSV file' => 'Преузми као CSV датотеку',
        'Download as Excel file' => 'Преузми као Excel датотеку',
        'Download as PDF file' => 'Преузми као PDF датотеку',
        'Please select a valid graph output format in the configuration of this widget.' =>
            'Молимо да у конфигурацији овог додатка изаберете важећи излазни формат графикона.',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Садржај ове статистике се припрема за вас, молимо будите стрпљиви.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Ова статистика се тренутно не може користити зато што администратор статистике треба да коригује њену конфигурацију.',

        # Template: AgentDashboardTicketGeneric
        'Assigned to customer user' => 'Додељени клијент корисник',
        'Accessible for customer user' => 'Дозвољен приступ за клијент корисника',
        'My locked tickets' => 'Моји закључани тикети',
        'My watched tickets' => 'Моји праћени тикети',
        'My responsibilities' => 'Одговоран сам за',
        'Tickets in My Queues' => 'Тикети у мојим редовима',
        'Tickets in My Services' => 'Тикети у мојим услугама',
        'Service Time' => 'Време услуге',

        # Template: AgentDashboardTicketQueueOverview
        'Total' => 'Укупно',

        # Template: AgentDashboardUserOnline
        'out of office' => 'ван канцеларије',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'dok',

        # Template: AgentInfo
        'To accept some news, a license or some changes.' => 'Да би прихватили неке вести, дозволе или неке промене.',
        'Yes, accepted.' => 'Да, прихваћено.',

        # Template: AgentLinkObject
        'Manage links for %s' => 'Уреди везе за %s',
        'Create new links' => 'Направи нове везе',
        'Manage existing links' => 'Уреди постојеће везе',
        'Link with' => 'Повежи са',
        'Start search' => 'Започни претрагу',
        'There are currently no links. Please click \'Create new Links\' on the top to link this item to other objects.' =>
            'Тренутно нема веза. Молимо кликните на \'Додај нове везе\' при врху да бисте повезали овај објекат са осталим.',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => 'Детектована неовлаштена употреба %s',
        'If you decide to downgrade to ((OTRS)) Community Edition, you will lose all database tables and data related to %s.' =>
            'Ако одлучите да се вратите на бесплатно издање ((OTRS)), изгубићете све табеле и податке у бази података повезане са %s.',

        # Template: AgentPreferences
        'Edit your preferences' => 'Уреди личне поставке',
        'Personal Preferences' => 'Лична подешавања',
        'Preferences' => 'Подешавања',
        'Please note: you\'re currently editing the preferences of %s.' =>
            'Напомена: тренутно мењате подешавања од %s.',
        'Go back to editing this agent' => 'Назад на уређивање овог оператера',
        'Set up your personal preferences. Save each setting by clicking the checkmark on the right.' =>
            'Подесите своја лична подешавања. Сачувајте свако подешавање штиклирањем са десне стране.',
        'You can use the navigation tree below to only show settings from certain groups.' =>
            'Можете користити навигацију испод за приказ подешавања која припадају одређеним групама.',
        'Dynamic Actions' => 'Динамичке акције',
        'Filter settings...' => 'Изфилтрирајте подешавања...',
        'Filter for settings' => 'Филтер за подешавања',
        'Save all settings' => 'Сачувајте сва подешавања',
        'Avatars have been disabled by the system administrator. You\'ll see your initials instead.' =>
            'Приказ аватар сличице је онемогућен од стране систем администратора. Уместо сличице биће приказани ваши иницијали.',
        'You can change your avatar image by registering with your email address %s at %s. Please note that it can take some time until your new avatar becomes available because of caching.' =>
            'Вашу аватар сличицу можете променити регистрацијом ваше имејл адресе %s на %s. Молимо обратите пажњу да је због кеширања неопходно да прође неко време пре него што ваш нови аватар постане видљив.',
        'Off' => 'Искључено',
        'End' => 'Крај',
        'This setting can currently not be saved.' => 'Ово подешавање тренутно не може бити сачувано.',
        'This setting can currently not be saved' => 'Ово подешавање тренутно не може бити сачувано',
        'Save this setting' => 'Сачувај ово подешавање',
        'Did you know? You can help translating OTRS at %s.' => 'Да ли сте знали? Можете да помогнете у превођењу OTRS на %s.',

        # Template: SettingsList
        'Reset to default' => 'Поништи на подразумевану вредност',

        # Template: AgentPreferencesOverview
        'Choose from the groups on the right to find the settings you\'d wish to change.' =>
            'Изаберите групу са десне стране за приказ подешавања доступних за промене.',
        'Did you know?' => 'Да ли сте знали?',
        'You can change your avatar by registering with your email address %s on %s' =>
            'Вашу аватар сличицу можете променити регистрацијом ваше имејл адресе %s на %s',

        # Template: AgentSplitSelection
        'Target' => 'Циљ',
        'Process' => 'Процес',
        'Split' => 'Подели',

        # Template: AgentStatisticsAdd
        'Statistics Management' => 'Управљање статистикама',
        'Add Statistics' => 'Додај статистику',
        'Read more about statistics in OTRS' => 'Прочитајте више о статистикама у OTRS',
        'Dynamic Matrix' => 'Динамичка матрица',
        'Each cell contains a singular data point.' => 'Свака ћелија садржи појединачни податак.',
        'Dynamic List' => 'Динамичка листа',
        'Each row contains data of one entity.' => 'Сваки ред садржи податке појединачног објекта.',
        'Static' => 'Статички',
        'Non-configurable complex statistics.' => 'Комплексне статистике које није могуће конфигурисати.',
        'General Specification' => 'Општа спецификација',
        'Create Statistic' => 'Креирај статистику',

        # Template: AgentStatisticsEdit
        'Edit Statistics' => 'Уређивање статистика',
        'Run now' => 'Покрени сад',
        'Statistics Preview' => 'Преглед статистике',
        'Save Statistic' => 'Сачувај статистику',

        # Template: AgentStatisticsImport
        'Import Statistics' => 'Увоз статистика',
        'Import Statistics Configuration' => 'Увези конфигурацију статистике',

        # Template: AgentStatisticsOverview
        'Statistics' => 'Статистике',
        'Run' => 'Покрени',
        'Edit statistic "%s".' => 'Измени статистику "%s".',
        'Export statistic "%s"' => 'Извези статистику "%s"',
        'Export statistic %s' => 'Измени статистику %s',
        'Delete statistic "%s"' => 'Обриши статистику "%s"',
        'Delete statistic %s' => 'Обриши статистику %s',

        # Template: AgentStatisticsView
        'Statistics Overview' => 'Преглед статистика',
        'View Statistics' => 'Преглед статистика',
        'Statistics Information' => 'Информације о статистици',
        'Created by' => 'Креирао',
        'Changed by' => 'Изменио',
        'Sum rows' => 'Збир редова',
        'Sum columns' => 'Збир колона',
        'Show as dashboard widget' => 'Прикажи као додатак контролне табле',
        'Cache' => 'Кеш',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Ова статистика садржи конфигурационе грешке и сад се не може користити.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => 'Промени слободни текст за %s%s%s',
        'Change Owner of %s%s%s' => 'Промени власника за %s%s%s',
        'Close %s%s%s' => 'Затвори %s%s%s',
        'Add Note to %s%s%s' => 'Додај напомену %s%s%s',
        'Set Pending Time for %s%s%s' => 'Постави време чекања за %s%s%s',
        'Change Priority of %s%s%s' => 'Промени приоритет за %s%s%s',
        'Change Responsible of %s%s%s' => 'Промени одговорног за %s%s%s',
        'All fields marked with an asterisk (*) are mandatory.' => 'Сва поља означена звездицом (*) су обавезна.',
        'The ticket has been locked' => 'Тикет је закључан.',
        'Undo & close' => 'Одустани & затвори',
        'Ticket Settings' => 'Подешавање тикета',
        'Queue invalid.' => 'Неважећи ред.',
        'Service invalid.' => 'Неважећа услуга.',
        'SLA invalid.' => 'Неважећи SLA.',
        'New Owner' => 'Нови власник',
        'Please set a new owner!' => 'Молимо да одредите новог власника!',
        'Owner invalid.' => ' Неважећи власник.',
        'New Responsible' => 'Нови одговорни',
        'Please set a new responsible!' => 'Молимо да одредите новог одговорног!',
        'Responsible invalid.' => 'Неважећи одговоран.',
        'Next state' => 'Следећи статус',
        'State invalid.' => 'Неважеће стање.',
        'For all pending* states.' => 'За сва стања* чекања.',
        'Add Article' => 'Додај чланак',
        'Create an Article' => 'Креирај чланак',
        'Inform agents' => 'Обавести оператере',
        'Inform involved agents' => 'Обавести укључене оператере',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Овде можете изабрати додатне оператере који треба да примају обавештења у вези са новим чланком.',
        'Text will also be received by' => 'Текст ће такође примити и:',
        'Text Template' => 'Шаблон текста',
        'Setting a template will overwrite any text or attachment.' => 'Подешавање шаблона ће преписати сваки текст или прилог.',
        'Invalid time!' => 'Неважеће време!',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => 'Одбаци %s%s%s',
        'Bounce to' => 'Преусмери на',
        'You need a email address.' => 'Потребна вам је имејл адреса.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Исправна имејл адреса је неопходна, али не користите локалну адресу!',
        'Next ticket state' => 'Наредни статус тикета',
        'Inform sender' => 'Обавести пошиљаоца',
        'Send mail' => 'Пошаљи имејл!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Масовне акције на тикетима',
        'Send Email' => 'Пошаљи имејл',
        'Merge' => 'Споји',
        'Merge to' => 'Обједини са',
        'Invalid ticket identifier!' => 'Неважећи идентификатор тикета!',
        'Merge to oldest' => 'Обједини са најстаријом',
        'Link together' => 'Повежи заједно',
        'Link to parent' => 'Повежи са надређеним',
        'Unlock tickets' => 'Откључај тикете',
        'Execute Bulk Action' => 'Изврши масовну акцију',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => 'Напиши одговор за %s%s%s',
        'This address is registered as system address and cannot be used: %s' =>
            'Ова адреса је регистрована као системска и не може бити коришћена: %s',
        'Please include at least one recipient' => 'Молимо да укључите бар једног примаоца',
        'Select one or more recipients from the customer user address book.' =>
            'Одаберите једног или више примаоца из адресара клијент корисника.',
        'Customer user address book' => 'Адресар клијент корисника',
        'Remove Ticket Customer' => 'Уклони клијент са тикета **',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Молимо да уклоните овај унос и унесете нов са исправном вредношћу.',
        'This address already exists on the address list.' => 'Ова адреса већ постоји у листи.',
        'Remove Cc' => 'Уклони Cc',
        'Bcc' => 'Bcc',
        'Remove Bcc' => 'Уклони Bcc',
        'Date Invalid!' => 'Неисправан датум!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => 'Промени клијента за %s%s%s',
        'Customer Information' => 'Информације о клијенту',
        'Customer user' => 'Клијент корисник',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Отвори нови имејл тикет',
        'Example Template' => 'Пример шаблона',
        'From queue' => 'из реда',
        'To customer user' => 'За клијента корисника',
        'Please include at least one customer user for the ticket.' => 'Молимо вас укључите барем једног клијента корисника за тикет.',
        'Select this customer as the main customer.' => 'Означи овог клијента као главног клијента.',
        'Remove Ticket Customer User' => 'Уклони тикет клијента корисника **',
        'Get all' => 'Узми све',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => 'Одлазни имејл за %s%s%s',

        # Template: AgentTicketEmailResend
        'Resend Email for %s%s%s' => 'Пошаљи поново имејл за %s %s %s',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Тикет %s: време одзива је истекло (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Тикет %s: време одзива ће истећи за %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => 'Тикет %s: време ажурирања је преко (%s/%s)!',
        'Ticket %s: update time will be over in %s/%s!' => 'Тикет %s: време ажурирања истиче за %s/%s!',
        'Ticket %s: solution time is over (%s/%s)!' => 'Тикет %s: време решавања је истекло (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Тикет %s: време решавања истиче за %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => 'Проследи %s%s%s',

        # Template: AgentTicketHistory
        'History of %s%s%s' => 'Историјат од %s%s%s',
        'Filter for history items' => 'Филтер за ставке историјата',
        'Expand/collapse all' => 'Прошири/скупи све',
        'CreateTime' => 'Време креирања',
        'Article' => 'Чланак',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => 'Споји %s%s%s',
        'Merge Settings' => 'Подешавања спајања',
        'You need to use a ticket number!' => 'Молимо вас да користите број тикета!',
        'A valid ticket number is required.' => 'Неопходан је исправан број тикета.',
        'Try typing part of the ticket number or title in order to search by it.' =>
            'Унесите део броја или наслова тикета за претрагу.',
        'Limit the search to tickets with same Customer ID (%s).' => 'Ограничите претрагу на тикете са истим ID клијента (%s).',
        'Inform Sender' => 'Обавести пошиљаоца',
        'Need a valid email address.' => 'Потребна је исправна имејл адреса.',

        # Template: AgentTicketMove
        'Move %s%s%s' => 'Премести %s%s%s',
        'New Queue' => 'Нови Ред',
        'Move' => 'Премести',

        # Template: AgentTicketOverviewMedium
        'No ticket data found.' => 'Нису нађени подаци о тикету',
        'Open / Close ticket action menu' => 'Акциони мени Отварања / Затварања тикета',
        'Select this ticket' => 'Изаберите овај тикет',
        'Sender' => 'Пошиљаоц',
        'First Response Time' => 'Време првог одговора',
        'Update Time' => 'Време ажурирања',
        'Solution Time' => 'Време решавања',
        'Move ticket to a different queue' => 'Премести тикет у други ред',
        'Change queue' => 'Промени ред',

        # Template: AgentTicketOverviewNavBar
        'Remove active filters for this screen.' => 'Уклони активне филтере за овај екран.',
        'Tickets per page' => 'Тикета по страни',

        # Template: AgentTicketOverviewPreview
        'Missing channel' => 'Недостаје канал',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Поништи преглед',
        'Column Filters Form' => 'Форма филтера колона',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => 'Подели у нови тикет позива',
        'Save Chat Into New Phone Ticket' => 'Сачувај ћаскање у нови тикет позива',
        'Create New Phone Ticket' => 'Отвори нови тикет позива',
        'Please include at least one customer for the ticket.' => 'Молимо да укључите бар једног клијента за тикет.',
        'To queue' => 'У ред',
        'Chat protocol' => 'Протокол ћаскања',
        'The chat will be appended as a separate article.' => 'Ћаскање ће бити додато као посебан чланак.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => 'Позив за %s%s%s',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => 'Приказ имејла као обичан текст за %s%s%s',
        'Plain' => 'Неформатирано',
        'Download this email' => 'Preuzmi ovu poruku',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Направи нови процес тикет',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => 'Прикључи тикет процесу',

        # Template: AgentTicketSearch
        'Profile link' => 'Веза профила',
        'Output' => 'Преглед резултата',
        'Fulltext' => 'Текст',
        'Customer ID (complex search)' => 'ID клијента (сложена претрага)',
        '(e. g. 234*)' => '(нпр. 234*)',
        'Customer ID (exact match)' => 'ID клијента (тачно поклапање)',
        'Assigned to Customer User Login (complex search)' => 'Додељено клијент кориснику (сложена претрага)',
        '(e. g. U51*)' => '(нпр.  U51*)',
        'Assigned to Customer User Login (exact match)' => 'Додељено клијент кориснику (тачно поклапање)',
        'Accessible to Customer User Login (exact match)' => 'Видљиво клијент кориснику (тачно поклапање)',
        'Created in Queue' => 'Отворено у реду',
        'Lock state' => 'Стаус закључавања',
        'Watcher' => 'Праћење',
        'Article Create Time (before/after)' => 'Време креирања чланка (пре/после)',
        'Article Create Time (between)' => 'Време креирања чланка (између)',
        'Please set this to value before end date.' => 'Молимо поставите овај датум пре краја.',
        'Please set this to value after start date.' => 'Молимо поставите овај датум после почетка.',
        'Ticket Create Time (before/after)' => 'Време отварања тикета (пре/после)',
        'Ticket Create Time (between)' => 'Време отварања тикета (између)',
        'Ticket Change Time (before/after)' => 'Време промене тикета (пре/после)',
        'Ticket Change Time (between)' => 'Време промене тикета (између)',
        'Ticket Last Change Time (before/after)' => 'Време последње промене тикета (пре/после)',
        'Ticket Last Change Time (between)' => 'Време последње промене тикета (између)',
        'Ticket Pending Until Time (before/after)' => 'Време тикета на чекању (пре/после)',
        'Ticket Pending Until Time (between)' => 'Време тикета на чекању (између)',
        'Ticket Close Time (before/after)' => 'Време затварања тикета (пре/после)',
        'Ticket Close Time (between)' => 'Време затварања тикета (између)',
        'Ticket Escalation Time (before/after)' => 'Време ескалације тикета (пре/после)',
        'Ticket Escalation Time (between)' => 'Време ескалације тикета (између)',
        'Archive Search' => 'Претрага архива',

        # Template: AgentTicketZoom
        'Sender Type' => 'Тип пошиљаоца',
        'Save filter settings as default' => 'Сачувај подешавања филтера као подразумевана',
        'Event Type' => 'Тип догађаја',
        'Save as default' => 'Сачувај као подразумевано',
        'Drafts' => 'Нацрти',
        'by' => 'од',
        'Change Queue' => 'Промени Ред',
        'There are no dialogs available at this point in the process.' =>
            'У овом тренутку нема слободних дијалога у процесу.',
        'This item has no articles yet.' => 'Ова ставка још увек нема члканке.',
        'Ticket Timeline View' => 'Преглед тикета на временској линији',
        'Article Overview - %s Article(s)' => 'Преглед чланака - %s чланак(а)',
        'Page %s' => 'Страна %s',
        'Add Filter' => 'Додај Филтер',
        'Set' => 'Подеси',
        'Reset Filter' => 'Ресетуј Филтер',
        'No.' => 'Бр.',
        'Unread articles' => 'Непрочитани чланци',
        'Via' => 'Преко',
        'Important' => 'Важно',
        'Unread Article!' => 'Непрочитани Чланци!',
        'Incoming message' => 'Долазна порука',
        'Outgoing message' => 'Одлазна порука',
        'Internal message' => 'Интерна порука',
        'Sending of this message has failed.' => 'Слање ове поруке није успело.',
        'Resize' => 'Промена величине',
        'Mark this article as read' => 'Означи овај чланак као прочитан',
        'Show Full Text' => 'Прикажи цео текст',
        'Full Article Text' => 'Текст целог чланка',
        'No more events found. Please try changing the filter settings.' =>
            'Нема више догађаја. Покушајте да промените подешавања филтера.',

        # Template: Chat
        '#%s' => '#%s',
        'via %s' => 'преко %s',
        'by %s' => 'од стране %s',
        'Toggle article details' => 'Преклопи детаље чланка',

        # Template: MIMEBase
        'This message is being processed. Already tried to send %s time(s). Next try will be %s.' =>
            'Ова порука се процесира. Слање је покушано већ %s пут(а). Следећи покушај биће у %s.',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            'Да отворите везе у овом чланку, можда ћете морати да притиснете Ctrl или Cmd или Shift тастер док кликнете на везу (зависи од вашег прегледача и оперативног система). ',
        'Close this message' => 'Затвори ову поруку',
        'Image' => 'Слика',
        'PDF' => 'PDF',
        'Unknown' => 'Непознато',
        'View' => 'Преглед',

        # Template: LinkTable
        'Linked Objects' => 'Повезани објекти',

        # Template: TicketInformation
        'Archive' => 'Архивирај',
        'This ticket is archived.' => 'Овај тикет је архивиран',
        'Note: Type is invalid!' => 'Напомена: тип је неважећи!',
        'Pending till' => 'На чекању до',
        'Locked' => 'Закључано',
        '%s Ticket(s)' => '%s тикет(а)',
        'Accounted time' => 'Обрачунато време',

        # Template: Invalid
        'Preview of this article is not possible because %s channel is missing in the system.' =>
            'Преглед овог чланка није могућ јер %s канал недостаје у систему.',
        'This feature is part of the %s. Please contact us at %s for an upgrade.' =>
            'Ово својство је део %s. Молимо да нас контактирате на %s за ажурирање.',
        'Please re-install %s package in order to display this article.' =>
            'Молимо поново инсталирајте пакет %s за приказ овог чланка.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Да бисте заштитили своју приватност, удаљени садржај је блокиран.',
        'Load blocked content.' => 'Учитај блокирани садржај.',

        # Template: Breadcrumb
        'Home' => 'Почетна',
        'Back to admin overview' => 'Назан на администраторски преглед',

        # Template: CloudServicesDisabled
        'This Feature Requires Cloud Services' => 'Ова функција захтева сервисе у облаку',
        'You can' => 'Ви можете',
        'go back to the previous page' => 'иди на претходну страну',

        # Template: CustomerAccept
        'Dear Customer,' => 'Драги клијенте,',
        'thank you for using our services.' => 'хвала вам на коришћењу наших услуга.',
        'Yes, I accept your license.' => 'Да, прихватам вашу лиценцу.',

        # Template: TicketCustomerIDSelection
        'The customer ID is not changeable, no other customer ID can be assigned to this ticket.' =>
            'ID клијента не може бити промењен, ниједан други ID не може бити додељен овом тикету.',
        'First select a customer user, then you can select a customer ID to assign to this ticket.' =>
            'Прво одаберите клијент корисника, онда можете одабрати ID клијента за доделу овом тикету.',
        'Select a customer ID to assign to this ticket.' => 'Одаберите ID клијента за доделу овом тикету.',
        'From all Customer IDs' => 'Из листе свих ID клијента',
        'From assigned Customer IDs' => 'Из листе додељених ID клијента',

        # Template: CustomerError
        'An Error Occurred' => 'Догодила се грешка',
        'Error Details' => 'Детаљи грешке',
        'Traceback' => 'Испрати уназад',

        # Template: CustomerFooter
        '%s powered by %s™' => '%s се покреће од стране %s™',
        'Powered by %s™' => 'Покреће %s™',

        # Template: CustomerFooterJS
        '%s detected possible network issues. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '%s је детектовао могуће проблеме са вашом мрежном везом. Можете покушати да ручно освежите ову страницу или да сачекате да ваш прегледач сам поново успостави везу.',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            'Веза је поново успостављена након привременог прекида. Због тога, елементи на овој страници су могли да престану да коректно функционишу. Да би све елементе могли поново нормално да користите, препоручујемо обавезно освежавање ове странице. ',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript није доступан.',
        'In order to experience this software, you\'ll need to enable JavaScript in your browser.' =>
            'Како би сте користили апликацију, неопходно је да активирате JavaScript у вашем веб претраживачу.',
        'Browser Warning' => 'Упозорење веб претраживача',
        'The browser you are using is too old.' => 'Веб претраживач који користите је превише стар.',
        'This software runs with a huge lists of browsers, please upgrade to one of these.' =>
            'Ова апликација функционише на великом броју веб претраживача, молимо да инсталирате и користите један од ових.',
        'Please see the documentation or ask your admin for further information.' =>
            'Молимо да прегледате документацију или питате вашег администратора за додатне информације.',
        'One moment please, you are being redirected...' => 'Сачекајте моменат, бићете преусмерени...',
        'Login' => 'Пријављивање',
        'User name' => 'Корисничко име',
        'Your user name' => 'Ваше корисничко име',
        'Your password' => 'Ваша лозинка',
        'Forgot password?' => 'Заборавили сте лозинку?',
        '2 Factor Token' => 'Двофакторски токен',
        'Your 2 Factor Token' => 'Ваш двофакторски токен',
        'Log In' => 'Пријављивање',
        'Not yet registered?' => 'Нисте регистровани?',
        'Back' => 'Назад',
        'Request New Password' => 'Захтев за нову лозинку',
        'Your User Name' => 'Ваше корисничко име',
        'A new password will be sent to your email address.' => 'Нова лозинка ће бити послата на вашу имејл адресу.',
        'Create Account' => 'Креирајте налог',
        'Please fill out this form to receive login credentials.' => 'Молимо да попуните овај образац да би сте добили податке за пријаву.',
        'How we should address you' => 'Како да вас ословљавамо',
        'Your First Name' => 'Ваше име',
        'Your Last Name' => 'Ваше презиме',
        'Your email address (this will become your username)' => 'Ваша имејл адреса (то ће бити ваше корисничко име)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => 'Долазни захтеви за ћаскање',
        'Edit personal preferences' => 'Уреди личне поставке',
        'Logout %s' => 'Одјава %s',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Споразум о нивоу услуге',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Добродошли!',
        'Please click the button below to create your first ticket.' => 'Молимо да притиснете дугме испод за креирање вашег првог тикета.',
        'Create your first ticket' => 'Креирајте ваш први тикет',

        # Template: CustomerTicketSearch
        'Profile' => 'Профил',
        'e. g. 10*5155 or 105658*' => 'нпр. 10*5155 или 105658*',
        'CustomerID' => 'ID клијента',
        'Fulltext Search in Tickets (e. g. "John*n" or "Will*")' => 'Текстуално претраживање у тикетима (нпр. "John*n" или "Will*")',
        'Types' => 'Типови',
        'Time Restrictions' => 'Временска ограничења',
        'No time settings' => 'Нема подешавања времена',
        'All' => 'Све',
        'Specific date' => 'Одређени датум',
        'Only tickets created' => 'Само креирани тикети',
        'Date range' => 'Распон датума',
        'Only tickets created between' => 'Само тикети креирани између',
        'Ticket Archive System' => 'Систем за архивирање тикета',
        'Save Search as Template?' => 'Сачувај претрагу као шаблон?',
        'Save as Template?' => 'Сачувати као шаблон?',
        'Save as Template' => 'Сачувај као шаблон',
        'Template Name' => 'Назив шаблона',
        'Pick a profile name' => 'Изабери назив профила',
        'Output to' => 'Излаз на',

        # Template: CustomerTicketSearchResultShort
        'of' => 'од',
        'Page' => 'Страна',
        'Search Results for' => 'Резултати претраживања за',
        'Remove this Search Term.' => 'Уклони овај израз за претрагу.',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => 'Почни ћаскање из овог тикета',
        'Next Steps' => 'Следећи кораци',
        'Reply' => 'Одговори',

        # Template: Chat
        'Expand article' => 'Рашири чланак',

        # Template: CustomerWarning
        'Warning' => 'Упозорење',

        # Template: DashboardEventsTicketCalendar
        'Event Information' => 'Информације о догађају',
        'Ticket fields' => 'Поља тикета',

        # Template: Error
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            'Стварно грешка? 5 од 10 пријављених грешака су последица погрешне или некомплетне OTRS инсталације.',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            'Са %s, наши експерти ће се побринути за коректну инсталацију и обезбедити подршку и повремена сигурносна ажурирања.',
        'Contact our service team now.' => 'Контактирајте наш сервисним тим сада.',
        'Send a bugreport' => 'Пошаљи извештај о грешци',
        'Expand' => 'Прошири',

        # Template: AttachmentList
        'Click to delete this attachment.' => 'Кликните овде да обришете прилог.',

        # Template: DraftButtons
        'Update draft' => 'Aжурирај нацрт',
        'Save as new draft' => 'Сачувај као нови нацрт',

        # Template: DraftNotifications
        'You have loaded the draft "%s".' => 'Већ сте учитали нацрт "%s".',
        'You have loaded the draft "%s". You last changed it %s.' => 'Већ сте учитали нацрт "%s". Последњи пут сте га променили у %s.',
        'You have loaded the draft "%s". It was last changed %s by %s.' =>
            'Већ сте учитали нацрт "%s". Последњи пут је промењен у %s од стране %s.',
        'Please note that this draft is outdated because the ticket was modified since this draft was created.' =>
            'Молимо обратите пажњу да је овај нацрт застарео јер је тикет модификован од када је нацрт креиран.',

        # Template: Header
        'View notifications' => 'Преглед обавештења',
        'Notifications' => 'Обавештења',
        'Notifications (OTRS Business Solution™)' => 'Обавештења (OTRS Business Solution™)',
        'Personal preferences' => 'Лична подешавања',
        'Logout' => 'Одјава',
        'You are logged in as' => 'Пријављени сте као',

        # Template: Installer
        'JavaScript not available' => 'JavaScript nije dostupan.',
        'Step %s' => 'Корак %s',
        'License' => 'Лиценца',
        'Database Settings' => 'Подешавање базе података',
        'General Specifications and Mail Settings' => 'Опште спецификације и подешавање поште',
        'Finish' => 'Заврши',
        'Welcome to %s' => 'Добродошли у %s',
        'Germany' => 'Немачка',
        'Phone' => 'Позив',
        'United States' => 'Сједињене Америчке Државе',
        'Mexico' => 'Мексико',
        'Hungary' => 'Мађарска',
        'Brazil' => 'Бразил',
        'Singapore' => 'Сингапур',
        'Hong Kong' => 'Хонг Конг',
        'Web site' => 'Веб сајт',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Подешавање одлазне поште',
        'Outbound mail type' => 'Тип одлазне поште',
        'Select outbound mail type.' => 'Изаберите тип одлазне поште',
        'Outbound mail port' => 'Порт за одлазну пошту',
        'Select outbound mail port.' => 'Изаберите порт за одлазну пошту',
        'SMTP host' => 'SMTP сервер',
        'SMTP host.' => 'SMTP сервер.',
        'SMTP authentication' => 'SMTP аутентификација',
        'Does your SMTP host need authentication?' => 'Да ли ваш SMTP сервер захтева аутентификацију?',
        'SMTP auth user' => 'SMTP корисник',
        'Username for SMTP auth.' => 'Корисничко име за SMTP аутентификацију',
        'SMTP auth password' => 'Лозинка SMTP аутентификације',
        'Password for SMTP auth.' => 'Лозинка за SMTP аутентификацију',
        'Configure Inbound Mail' => 'Подешавање долазне поште',
        'Inbound mail type' => 'Тип долазне поште',
        'Select inbound mail type.' => 'Изабери тип долазне поште',
        'Inbound mail host' => 'Сервер долазне поште',
        'Inbound mail host.' => 'Сервер долазне поште.',
        'Inbound mail user' => 'Корисник долазне поште',
        'User for inbound mail.' => 'Корисник за долазну пошту.',
        'Inbound mail password' => 'Лозинка долазне поште',
        'Password for inbound mail.' => 'Лозинка за долазну пошту.',
        'Result of mail configuration check' => 'Резултат провере подешавања поште',
        'Check mail configuration' => 'Провери конфигурацију мејла',
        'Skip this step' => 'Прескочи овај корак',

        # Template: InstallerDBResult
        'Done' => 'Урађено',
        'Error' => 'Грешка',
        'Database setup successful!' => 'Успешно инсталирање базе',

        # Template: InstallerDBStart
        'Install Type' => 'Инсталирај тип',
        'Create a new database for OTRS' => 'Креирај нову базу података за OTRS',
        'Use an existing database for OTRS' => 'Користи постојећу базу података за OTRS',

        # Template: InstallerDBmssql
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Ако сте поставили рут лозинку за вашу базу података, она мора бити унета овде. Ако нисте, ово поље оставите празно.',
        'Database name' => 'Назив базе података',
        'Check database settings' => 'Проверите подешавања базе',
        'Result of database check' => 'Резултат провере базе података',
        'Database check successful.' => 'Успешна провера базе података.',
        'Database User' => 'Корисник базе података',
        'New' => 'Ново',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Нови корисник базе са ограниченим правима ће бити креиран за овај OTRS систем.',
        'Repeat Password' => 'Понови лозинку',
        'Generated password' => 'Генерисана лозинка',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Лозинке се не поклапају',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Порт',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Да би сте користили OTRS морате унети следеће у командну линију (Terminal/Shell) као root.',
        'Restart your webserver' => 'Поново покрените ваш веб сервер.',
        'After doing so your OTRS is up and running.' => 'После овога ваш OTRS је укључен и ради.',
        'Start page' => 'Početna strana',
        'Your OTRS Team' => 'Ваш OTRS тим',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Не прихватај лиценцу',
        'Accept license and continue' => 'Прихвати лиценцу и настави',

        # Template: InstallerSystem
        'SystemID' => 'Системски ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Системски идентификатор. Сваки број тикета и сваки ID HTTP сесије садржи овај број.',
        'System FQDN' => 'Sistemski FQDN',
        'Fully qualified domain name of your system.' => 'Пун назив домена вашег система',
        'AdminEmail' => 'Административни имејл',
        'Email address of the system administrator.' => 'Имејл адреса систем администратора.',
        'Organization' => 'Организација',
        'Log' => 'Лог',
        'LogModule' => 'Лог модул',
        'Log backend to use.' => 'Лог модул у употреби.',
        'LogFile' => 'Лог датотека',
        'Webfrontend' => 'Мрежни интерфејс',
        'Default language' => 'Подразумевани језик',
        'Default language.' => 'Подразумевани језик',
        'CheckMXRecord' => 'Провери MX податке',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Ручно унета имејл адреса се проверава помоћу MX податка пронађеног у DNS. Немојте користити ову опцију ако је ваш DNS спор или не може да разреши јавне адресе.',

        # Template: LinkObject
        'Delete link' => 'Обриши везу',
        'Delete Link' => 'Обриши везу',
        'Object#' => 'Објекат#',
        'Add links' => 'Додај везе',
        'Delete links' => 'Обриши везе',

        # Template: Login
        'Lost your password?' => 'Изгубили сте лозинку?',
        'Back to login' => 'Назад на пријављивање',

        # Template: MetaFloater
        'Scale preview content' => 'Скалирај садржај за приказ',
        'Open URL in new tab' => 'Отвори УРЛ у новом листу',
        'Close preview' => 'Затвори преглед',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            'Преглед ове веб странице није могућ јер она не дозвољава да буде уграђена.',

        # Template: MobileNotAvailableWidget
        'Feature not Available' => 'Својство није доступно',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'На жалост, ово својство моментално није доступно за мобилне уређаје. Ако желите да га користите, можете де вратити на десктоп мод или користити стандардни десктоп уређај.',

        # Template: Motd
        'Message of the Day' => 'Данашња порука',
        'This is the message of the day. You can edit this in %s.' => 'Ово је дневна порука. Можете је уредити у %s.',

        # Template: NoPermission
        'Insufficient Rights' => 'Недовољна овлаштења',
        'Back to the previous page' => 'Вратите се на претходну страну',

        # Template: Alert
        'Alert' => 'Упозорење',
        'Powered by' => 'Покреће',

        # Template: Pagination
        'Show first page' => 'Покажи прву страну',
        'Show previous pages' => 'Покажи претходне стране',
        'Show page %s' => 'Покажи страну %s',
        'Show next pages' => 'Покажи следеће стране',
        'Show last page' => 'Покажи последњу страну',

        # Template: PictureUpload
        'Need FormID!' => 'Неопходан FormID!',
        'No file found!' => 'Датотека није пронађена!',
        'The file is not an image that can be shown inline!' => 'Датотека није слика која се може непосредно приказати!',

        # Template: PreferencesNotificationEvent
        'No user configurable notifications found.' => 'Нису пронађена обавештења која корисник може да подеси.',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            'Примите поруке за обавештавање \'%s\' пренете путем \'%s\'.',

        # Template: ActivityDialogHeader
        'Process Information' => 'Информације о процесу',
        'Dialog' => 'Дијалог',

        # Template: Article
        'Inform Agent' => 'Обавести оператера',

        # Template: PublicDefault
        'Welcome' => 'Добродошли',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            'Ово је подразумевани јавни интерфејс за OTRS! Нема датих акционих параметара.',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            'Можете инсталирати додатни модул (видите управљање пакетима), нпр. FAQ, који има јавни интерфејс.',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Дозволе',
        'You can select one or more groups to define access for different agents.' =>
            'Можете изабрати једну или више група за дефинисање приступа за различите оператере.',
        'Result formats' => 'Формат резултата',
        'Time Zone' => 'Временска зона',
        'The selected time periods in the statistic are time zone neutral.' =>
            'Изабрани временски периоди у статистици су неутрални по питању временске зоне.',
        'Create summation row' => 'Креирај ред са збиром',
        'Generate an additional row containing sums for all data rows.' =>
            'Генериши додатни ред који садржи суме за све редове са подацима.',
        'Create summation column' => 'Креирај колону са збиром',
        'Generate an additional column containing sums for all data columns.' =>
            'Генериши додатну колону која садржи суме за све колоне са подацима.',
        'Cache results' => 'Кеширај резултате',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            'Чува резултате статистика у кешу за коришћење у следећим прегледима са истим подешавањима (захтева изабрано бар једно временско поље).',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Омогући статистику као додатак који опертатери могу активирати у својој контролној табли.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Напомињемо да ће омогућавање додатка кеширати ову статистику на контролној табли.',
        'If set to invalid end users can not generate the stat.' => 'Ако је подешено на неважеће, крајњи корисници не могу генерисати статистику.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Постоје неки проблеми у подешавању ове статистике:',
        'You may now configure the X-axis of your statistic.' => 'Сада можете подесити X осу ваше статистике.',
        'This statistic does not provide preview data.' => 'Ова статистика не омогућава привремени приказ.',
        'Preview format' => 'Формат приказа',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Напомињемо да приказ користи насумично изабране податке и не узима у обзир филтере података.',
        'Configure X-Axis' => 'Подеси X осу',
        'X-axis' => 'Х-оса',
        'Configure Y-Axis' => 'Подеси Y осу',
        'Y-axis' => 'Y-оса',
        'Configure Filter' => 'Подеси филтер',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Молимо да изаберете само један елемент или искључите дугме \'фиксирано\'!',
        'Absolute period' => 'Апсолутни период',
        'Between %s and %s' => 'Између %s и %s',
        'Relative period' => 'Релативни период',
        'The past complete %s and the current+upcoming complete %s %s' =>
            'Комплетна прошлост %s и комплетна тренутна+будућа %s %s',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Онемогући промене овог елемента при генерисању статистике.',

        # Template: StatsParamsWidget
        'Format' => 'Формат',
        'Exchange Axis' => 'Замени осе',
        'Configurable Params of Static Stat' => 'Подесиви параметри статичке статистике',
        'No element selected.' => 'Није изабран ни један елемент.',
        'Scale' => 'Скала',
        'show more' => 'прикажи више',
        'show less' => 'прикажи мање',

        # Template: D3
        'Download SVG' => 'Преузми SVG',
        'Download PNG' => 'Преузме PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'Одабрани временски период дефинише подразумеван временски оквир за прикупљање података статистике.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            'Дефинише временску јединицу која се користи за поделу изабраног временског периода у појединачне тачке на извештају.',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            'Молимо запамтите, да скала за Y-осу треба да буде већа од скале за Х-осу (нпр. Х-Оса => месец; Y-оса => година).',

        # Template: SettingsList
        'This setting is disabled.' => 'Ово подешавање је искључено.',
        'This setting is fixed but not deployed yet!' => 'Ово подешавање је статичко, али није још распоређено!',
        'This setting is currently being overridden in %s and can\'t thus be changed here!' =>
            'Ово подешавање је тренутно прегажено у %s и не може бити измењено овде!',
        'Changing this setting is only available in a higher config level!' =>
            'Промена овог подешавања је могућа само у напредном конфигурационом моду.',
        '%s (%s) is currently working on this setting.' => '%s (%s) тренутно ради на овом подешавању.',
        'Toggle advanced options for this setting' => 'Преклопи напредне опције за ово подешавање',
        'Disable this setting, so it is no longer effective' => 'Искључи ово подешавање, тако да више није ефективно',
        'Disable' => 'Искључи',
        'Enable this setting, so it becomes effective' => 'Укључи ово подешавање, тако да постане ефективно',
        'Enable' => 'Укључи',
        'Reset this setting to its default state' => 'Поништи ово подешавање на подразумевану вредност',
        'Reset setting' => 'Поништи подешавање',
        'Allow users to adapt this setting from within their personal preferences' =>
            'Омогући корисницима да мењају ово подешавање у њиховим личним подешавањима',
        'Allow users to update' => 'Дозволи корисницима да мењају',
        'Do not longer allow users to adapt this setting from within their personal preferences' =>
            'Онемогући корисницима да мењају ово подешавање у њиховим личним подешавањима',
        'Forbid users to update' => 'Забрани корисницима да мењају',
        'Show user specific changes for this setting' => 'Прикажи корисничке промене за ово подешавање',
        'Show user settings' => 'Прикажи корисничке промене',
        'Copy a direct link to this setting to your clipboard' => 'Копирај директну везу за ово подешавање',
        'Copy direct link' => 'Копирај директну везу',
        'Remove this setting from your favorites setting' => 'Уклони ово подешавање из омиљених',
        'Remove from favourites' => 'Уклони из омиљених',
        'Add this setting to your favorites' => 'Додај ово подешавање у омиљена',
        'Add to favourites' => 'Додај у омиљене',
        'Cancel editing this setting' => 'Одустани од промене овог подешавања',
        'Save changes on this setting' => 'Сачувај промене за ово подешавање',
        'Edit this setting' => 'Промени ово подешавање',
        'Enable this setting' => 'Укључи ово подешавање',
        'This group doesn\'t contain any settings. Please try navigating to one of its sub groups or another group.' =>
            'Ова група не садржи ниједно подешавање. Молимо пробајте неку од под-група или другу групу.',

        # Template: SettingsListCompare
        'Now' => 'Сад',
        'User modification' => 'Корисничке промене',
        'enabled' => 'укључено',
        'disabled' => 'искључено',
        'Setting state' => 'Вредност подешавања',

        # Template: Actions
        'Edit search' => 'Уреди претрагу',
        'Go back to admin: ' => 'Назад на admin:',
        'Deployment' => 'Распоред',
        'My favourite settings' => 'Моја омиљена подешавања',
        'Invalid settings' => 'Неважећа подешавања',

        # Template: DynamicActions
        'Filter visible settings...' => 'Изфилтрирај видљива подешавања...',
        'Enable edit mode for all settings' => 'Промени сва подешавања',
        'Save all edited settings' => 'Сними сва промењена подешавања',
        'Cancel editing for all settings' => 'Одустани од промене свих подешавања',
        'All actions from this widget apply to the visible settings on the right only.' =>
            'Све акције из овог додатка се односе на видљива подешавања са десне стране.',

        # Template: Help
        'Currently edited by me.' => 'Тренутно мењате ви.',
        'Modified but not yet deployed.' => 'Промењено али нераспоређено.',
        'Currently edited by another user.' => 'Тренутно мења други корисник.',
        'Different from its default value.' => 'Разликује се од подразумеване вредности.',
        'Save current setting.' => 'Сачувај тренутно подешавање.',
        'Cancel editing current setting.' => 'Одустани од промене тренутног подешавања.',

        # Template: Navigation
        'Navigation' => 'Навигација',

        # Template: OTRSBusinessTeaser
        'With %s, System Configuration supports versioning, rollback and user-specific configuration settings.' =>
            'Са %s, системска конфигурација подржава преглед промена, поновно распоређивање и корисничке промене подешавања.',

        # Template: Test
        'OTRS Test Page' => 'OTRS тест страна',
        'Unlock' => 'Откључај',
        'Welcome %s %s' => 'Добродошли %s %s',
        'Counter' => 'Бројач',

        # Template: Warning
        'Go back to the previous page' => 'Вратите се на претходну страну',

        # JS Template: CalendarSettingsDialog
        'Show' => 'Прикажи',

        # JS Template: FormDraftAddDialog
        'Draft title' => 'Наслов нацрта',

        # JS Template: ArticleViewSettingsDialog
        'Article display' => 'Приказ чланака',

        # JS Template: FormDraftDeleteDialog
        'Do you really want to delete "%s"?' => 'Да ли заиста желите да обришете "%s"?',
        'Confirm' => 'Потврди',

        # JS Template: WidgetLoading
        'Loading, please wait...' => 'Учитавање, молимо сачекајте...',

        # JS Template: UploadContainer
        'Click to select a file for upload.' => 'Кликните овде за отпремање датотеке.',
        'Click to select files or just drop them here.' => 'Кликните да одаберете датотеке или их једноставно превуците овде.',
        'Click to select a file or just drop it here.' => 'Кликните да одаберете датотеку или је једноставно превуците овде.',
        'Uploading...' => 'Отпремање...',

        # JS Template: InformationDialog
        'Process state' => 'Стање процеса',
        'Running' => 'У току',
        'Finished' => 'Завршено',
        'No package information available.' => 'Нема информација о пакету.',

        # JS Template: AddButton
        'Add new entry' => 'Додај нов унос',

        # JS Template: AddHashKey
        'Add key' => 'Додај кључ',

        # JS Template: DialogDeployment
        'Deployment comment...' => 'Коментар распоређувања...',
        'This field can have no more than 250 characters.' => 'Ово поље не може садржати више од 250 карактера.',
        'Deploying, please wait...' => 'Распоређивање у току, молимо сачекајте...',
        'Preparing to deploy, please wait...' => 'Припрема за распоређивање, молимо сачекајте...',
        'Deploy now' => 'Распореди сад',
        'Try again' => 'Покушајте поново',

        # JS Template: DialogReset
        'Reset options' => 'Поништи подешавања',
        'Reset setting on global level.' => 'Поништи подешавање на глобалном нивоу.',
        'Reset globally' => 'Поништи глобално',
        'Remove all user changes.' => 'Поништи све корисничке промене.',
        'Reset locally' => 'Поништи локално',
        'user(s) have modified this setting.' => 'корисник(а) је је променило ово подешавање.',
        'Do you really want to reset this setting to it\'s default value?' =>
            'Да ли стварно желите да поништите ово подешавање на његову подразумевану вредност?',

        # JS Template: HelpDialog
        'You can use the category selection to limit the navigation tree below to entries from the selected category. As soon as you select the category, the tree will be re-built.' =>
            'Можете одабрати категорију за ограничавање навигационих ставки испод. Чим одаберете категорију, навигација ће бити освежена.',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => 'База података',
        'CustomerIDs' => 'ID-еви клијента',
        'Fax' => 'Факс',
        'Street' => 'Улица',
        'Zip' => 'ПБ',
        'City' => 'Место',
        'Country' => 'Држава',
        'Valid' => 'Важећи',
        'Mr.' => 'Г-дин',
        'Mrs.' => 'Г-ђа',
        'Address' => 'Адреса',
        'View system log messages.' => 'Преглед порука системског лога.',
        'Edit the system configuration settings.' => 'Уреди подешавања системске конфигурације.',
        'Update and extend your system with software packages.' => 'Ажурирај и надогради систем софтверским пакетима.',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL информације из базе података нису синхронизоване са системском конфигурацијом, молимо вас да примените све ACL листе.',
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'ACL листе не могу да се увезу због непознате грешке, молимо да проверите OTRS логове за више информација',
        'The following ACLs have been added successfully: %s' => 'Следеће ACL листе су успешно додате: %s',
        'The following ACLs have been updated successfully: %s' => 'Следеће ACL листе су успешно ажуриране: %s',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            'Постоје грешке у додавању/ажурирању следећих ACL: %s. Молимо проверите лог датотеку за више информација.',
        'This field is required' => 'Ово поље је обавезно.',
        'There was an error creating the ACL' => 'Дошло је до грешке при креирању ACL',
        'Need ACLID!' => 'Неопходан ACLID!',
        'Could not get data for ACLID %s' => 'Не могу прибавити податке за ИД ACL листе %s',
        'There was an error updating the ACL' => 'Дошло је до грешке при ажурирању ACL',
        'There was an error setting the entity sync status.' => 'Дошло је до грешке приликом подешавања статуса синхронизације ентитета.',
        'There was an error synchronizing the ACLs.' => 'Дошло је до грешке при синхронизацији ACLs',
        'ACL %s could not be deleted' => 'ACL листу %s није могуће обрисати',
        'There was an error getting data for ACL with ID %s' => 'Дошло је до грешке приликом прибављања података за ACL листу са ИД %s',
        '%s (copy) %s' => '%s (копија) %s',
        'Please note that ACL restrictions will be ignored for the Superuser account (UserID 1).' =>
            'Молимо обратите пажњу да ће ACL рестрикције бити игнорисане за супер-администраторски налог (UserID 1).',
        'Exact match' => 'Тачно поклапање',
        'Negated exact match' => 'Негирано тачно поклапање',
        'Regular expression' => 'Регуларни израз',
        'Regular expression (ignore case)' => 'Регуларни израз (игнориши величину слова)',
        'Negated regular expression' => 'Негирани регуларни израз',
        'Negated regular expression (ignore case)' => 'Негирани регуларни израз (игнориши величину слова)',

        # Perl Module: Kernel/Modules/AdminAppointmentCalendarManage.pm
        'System was unable to create Calendar!' => 'Систем није успео да креира календар!',
        'Please contact the administrator.' => 'Молимо контактирајте администратора!',
        'No CalendarID!' => 'Нема CalendarID!',
        'You have no access to this calendar!' => 'Немате приступ овом календару!',
        'Error updating the calendar!' => 'Грешка приликом измене календара',
        'Couldn\'t read calendar configuration file.' => 'Учитавање конфигурације календара није било могуће.',
        'Please make sure your file is valid.' => 'Молимо вас да проверите да ли је ваш фајл исправан.',
        'Could not import the calendar!' => 'Није могућ увоз календара!',
        'Calendar imported!' => 'Календар је увезен!',
        'Need CalendarID!' => 'Неопходан CalendarID!',
        'Could not retrieve data for given CalendarID' => 'Не могу прибавити податке за дати CalendarID',
        'Successfully imported %s appointment(s) to calendar %s.' => 'Успешно увезено %s термин(а) у календар %s.',
        '+5 minutes' => '+5 минута',
        '+15 minutes' => '+15 минута',
        '+30 minutes' => '+30 минута',
        '+1 hour' => '+1 сат',

        # Perl Module: Kernel/Modules/AdminAppointmentImport.pm
        'No permissions' => 'Без дозволе',
        'System was unable to import file!' => 'Систем није успео да увезе фајл!',
        'Please check the log for more information.' => 'Молимо проверите лог за више информација.',

        # Perl Module: Kernel/Modules/AdminAppointmentNotificationEvent.pm
        'Notification name already exists!' => 'Обавештење са овим називом већ постоји!',
        'Notification added!' => 'Обавештење додато!',
        'There was an error getting data for Notification with ID:%s!' =>
            'Дошло је до грешке приликом прибављања података за ID обавештења:%s!',
        'Unknown Notification %s!' => 'Непознато обавештење %s!',
        '%s (copy)' => '%s (копија)',
        'There was an error creating the Notification' => 'Дошло је до грешке приликом креирања обавештења',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Обавештења не могу да се увезу због непознате грешке, молимо да проверите OTRS логове за више информација',
        'The following Notifications have been added successfully: %s' =>
            'Следећа обавештења су успешно додата: %s',
        'The following Notifications have been updated successfully: %s' =>
            'Следећа обавештења су успешно ажурирана: %s',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            'Постоје грешке у додавању/ажурирању следећих обавештења: %s. Молимо проверите лог датотеку за више информација.',
        'Notification updated!' => 'Обавештење ажурирано!',
        'Agent (resources), who are selected within the appointment' => 'Оператер (ресурс), који је изабран у термину',
        'All agents with (at least) read permission for the appointment (calendar)' =>
            'Сви оператери са (најмање) дозволом прегледа термина (календара)',
        'All agents with write permission for the appointment (calendar)' =>
            'Сви оператери са дозволом писања у термину (календару)',
        'Yes, but require at least one active notification method.' => 'Да, али тражи бар један активни метод обавештавања.',

        # Perl Module: Kernel/Modules/AdminAttachment.pm
        'Attachment added!' => 'Додат прилог!',

        # Perl Module: Kernel/Modules/AdminAutoResponse.pm
        'Auto Response added!' => 'Аутоматски одговор додат!',

        # Perl Module: Kernel/Modules/AdminCommunicationLog.pm
        'Invalid CommunicationID!' => 'Неважећи CommunicationID!',
        'All communications' => 'Све комуникације',
        'Last 1 hour' => 'Последњи 1 сат',
        'Last 3 hours' => 'Последња 3 сата',
        'Last 6 hours' => 'Последњих 6 сати',
        'Last 12 hours' => 'Последњих 12 сати',
        'Last 24 hours' => 'Последњих 24 сата',
        'Last week' => 'Прошла недеља',
        'Last month' => 'Прошли месец',
        'Invalid StartTime: %s!' => 'Неважећи StartTime: %s!',
        'Successful' => 'Успешно',
        'Processing' => 'У процесу',
        'Failed' => 'Неуспешно',
        'Invalid Filter: %s!' => 'Неважећи филтер: %s!',
        'Less than a second' => 'Краће од секунде',
        'sorted descending' => 'сортирано опадајуће',
        'sorted ascending' => 'сортирано растуће',
        'Trace' => 'Испитивање',
        'Debug' => 'Отклањање неисправности',
        'Info' => 'Инфо',
        'Warn' => 'Упозорење',
        'days' => 'дани',
        'day' => 'дан',
        'hour' => 'сат',
        'minute' => 'минут',
        'seconds' => 'секунде',
        'second' => 'секунда',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer company updated!' => 'Ажурирана фирма клијента!',
        'Dynamic field %s not found!' => 'Динамичко поље %s није пронађено!',
        'Unable to set value for dynamic field %s!' => 'Није могуће поставити вредност за динамичко поље %s!',
        'Customer Company %s already exists!' => 'Клијентска фирма %s већ постоји!',
        'Customer company added!' => 'Додата фирма клијента!',

        # Perl Module: Kernel/Modules/AdminCustomerGroup.pm
        'No configuration for \'CustomerGroupPermissionContext\' found!' =>
            'Конфигурација за \'CustomerGroupPermissionContext\' није пронађена!',
        'Please check system configuration.' => 'Молимо проверите системску конфигурацију.',
        'Invalid permission context configuration:' => 'Неважећа конфигурација контекста дозволе:',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'Customer updated!' => 'Ажуриран клијент!',
        'New phone ticket' => 'Нови тикет позива',
        'New email ticket' => 'Нови имејл тикет',
        'Customer %s added' => 'Додат клијент %s.',
        'Customer user updated!' => 'Ажуриран клијент корисник!',
        'Same Customer' => 'Исти клијент',
        'Direct' => 'Директно',
        'Indirect' => 'Индиректно',

        # Perl Module: Kernel/Modules/AdminCustomerUserGroup.pm
        'Change Customer User Relations for Group' => 'Промени релације са клијент корисницима за групу',
        'Change Group Relations for Customer User' => 'Промени релације са групама за клијент корисника',

        # Perl Module: Kernel/Modules/AdminCustomerUserService.pm
        'Allocate Customer Users to Service' => 'Придружи клијент кориснике сервису',
        'Allocate Services to Customer User' => 'Придружи сервисе клијент кориснику',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => 'Конфигурација поља је неважећа',
        'Objects configuration is not valid' => 'Конфигурација објекта је неважећа',
        'Database (%s)' => 'База података (%s)',
        'Web service (%s)' => 'Веб сервис (%s)',
        'Contact with data (%s)' => 'Контакт са подацима (%s)',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            'Није могуће поништити редослед динамичких поља, молимо да проверите OTRS логове за више информација.',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => 'Недефинисана субакција.',
        'Need %s' => 'Неопходан %s',
        'Add %s field' => 'Додај %s поље',
        'The field does not contain only ASCII letters and numbers.' => 'Поље не садржи само ASCII слова и бројеве.',
        'There is another field with the same name.' => 'Постоји друго поље са истим именом.',
        'The field must be numeric.' => 'Поље мора бити нумеричко.',
        'Need ValidID' => 'Неопходан ValidID',
        'Could not create the new field' => 'Није могуће креирати ново поље',
        'Need ID' => 'Неопходан ID',
        'Could not get data for dynamic field %s' => 'Не могу прибавити податке за динамичко поље %s',
        'Change %s field' => 'Измени %s поље',
        'The name for this field should not change.' => 'Назив овог поља није пожељно мењати.',
        'Could not update the field %s' => 'Није могуће ажурирати поље %s',
        'Currently' => 'Тренутно',
        'Unchecked' => 'Искључено',
        'Checked' => 'Укључено',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => 'Спречава унос датума у будућности',
        'Prevent entry of dates in the past' => 'Спречава унос датума у прошлости',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => 'Вредност овог поља је умножена.',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => 'Изаберите бар једног примаоца.',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'minute(s)' => 'минут(и)',
        'hour(s)' => 'сат(и)',
        'Time unit' => 'Јединица времена',
        'within the last ...' => 'у последњих ...',
        'within the next ...' => 'у следећих ...',
        'more than ... ago' => 'пре више од ...',
        'Unarchived tickets' => 'Неархивирани тикети',
        'archive tickets' => 'архивирај тикете',
        'restore tickets from archive' => 'врати тикете из архиве',
        'Need Profile!' => 'Неопходан Profile!',
        'Got no values to check.' => 'Нема вредности за проверу.',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            'Молимо да уклоните следеће речи јер се не могу користити за избор тикета:',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => 'Неопходан WebserviceID!',
        'Could not get data for WebserviceID %s' => 'Не могу прибавити податке за ID веб сервиса %s',
        'ascending' => 'растући',
        'descending' => 'опадајући',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingDefault.pm
        'Need communication type!' => 'Неопходан тип комуникације!',
        'Communication type needs to be \'Requester\' or \'Provider\'!' =>
            'Тип комуникације мора да буде \'Requester\' или \'Provider\'!',
        'Invalid Subaction!' => 'Неважећа субакција!',
        'Need ErrorHandlingType!' => 'Неопходан ErrorHandlingType!',
        'ErrorHandlingType %s is not registered' => 'ErrorHandlingType %s није регистрован',
        'Could not update web service' => 'Није могуће ажурирати веб сервис',
        'Need ErrorHandling' => 'Неопходан ErrorHandling',
        'Could not determine config for error handler %s' => 'Није могуће утврдити конфигурацију за обраду грешке %s',
        'Invoker processing outgoing request data' => 'Обрада излазних података захтева у позиваоцу',
        'Mapping outgoing request data' => 'Мапирање излазних података захтева',
        'Transport processing request into response' => 'Обрада захтева у одговор у транспорту',
        'Mapping incoming response data' => 'Мапирање долазних података одговора',
        'Invoker processing incoming response data' => 'Обрада долазних података одговара у позиваоцу',
        'Transport receiving incoming request data' => 'Примање долазних података захтева у транспорту',
        'Mapping incoming request data' => 'Мапирање долазних података захтева',
        'Operation processing incoming request data' => 'Обрада долазних података захтева у операцији',
        'Mapping outgoing response data' => 'Мапирање одлазних података одговора',
        'Transport sending outgoing response data' => 'Слање одлазних података одговора у транспорту',
        'skip same backend modules only' => 'прескочи само исте позадинске модуле',
        'skip all modules' => 'прескочи све модуле',
        'Operation deleted' => 'Операција обрисана',
        'Invoker deleted' => 'Позивалац обрисан',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceErrorHandlingRequestRetry.pm
        '0 seconds' => '0 секунди',
        '15 seconds' => '15 секунди',
        '30 seconds' => '30 секунди',
        '45 seconds' => '45 секунди',
        '1 minute' => '1 минут',
        '2 minutes' => '2 минута',
        '3 minutes' => '3 минута',
        '4 minutes' => '4 минута',
        '5 minutes' => '5 минута',
        '10 minutes' => '10 минута',
        '15 minutes' => '15 минута',
        '30 minutes' => '30 минута',
        '1 hour' => '1 сат',
        '2 hours' => '2 сата',
        '3 hours' => '3 сата',
        '4 hours' => '4 сата',
        '5 hours' => '5 сати',
        '6 hours' => '6 сати',
        '12 hours' => '12 сати',
        '18 hours' => '18 сати',
        '1 day' => '1 дан',
        '2 days' => '2 дана',
        '3 days' => '3 дана',
        '4 days' => '4 дана',
        '6 days' => '6 дана',
        '1 week' => '1 недеља',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Could not determine config for invoker %s' => 'Није могуће утврдити конфигурацију за позиваоца %s',
        'InvokerType %s is not registered' => 'Тип позиваоца %s није регистрован',
        'MappingType %s is not registered' => 'MappingType %s није регистрован',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerEvent.pm
        'Need Invoker!' => 'Неопходан позивалац!',
        'Need Event!' => 'Неопходан догађај!',
        'Could not get registered modules for Invoker' => 'Није могуће пронаћи регистровани модул позиваоца',
        'Could not get backend for Invoker %s' => 'Није могуће пронаћи модул за позиваоца %s',
        'The event %s is not valid.' => 'Догађај %s није важећи.',
        'Could not update configuration data for WebserviceID %s' => 'Не могу ажурирати конфигурационе податке за ID веб сервиса %s',
        'This sub-action is not valid' => 'Ова подакција је неважећа',
        'xor' => 'xor',
        'String' => 'Низ знакова',
        'Regexp' => 'Регуларни израз',
        'Validation Module' => 'Модул валидације',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Simple Mapping for Outgoing Data' => 'Једноставно мапирање излазних података',
        'Simple Mapping for Incoming Data' => 'Једноставно мапирање долазних података',
        'Could not get registered configuration for action type %s' => 'Не могу прибавити регистровану конфигурацију за тип акције %s',
        'Could not get backend for %s %s' => 'Није могуће пронаћи модул за %s %s',
        'Keep (leave unchanged)' => 'Задржи (остави непромењено)',
        'Ignore (drop key/value pair)' => 'Игнориши (одбаци пар кључ/вредност)',
        'Map to (use provided value as default)' => 'Мапирај на (употреби понуђену вредност као подразумевану)',
        'Exact value(s)' => 'Тачна вредност(и)',
        'Ignore (drop Value/value pair)' => 'Игнориши (одбаци пар вредност/вредност)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'XSLT Mapping for Outgoing Data' => 'XSLT мапирање одлазних података',
        'XSLT Mapping for Incoming Data' => 'XSLT мапирање долазних података',
        'Could not find required library %s' => 'Није могуће пронаћи потребну библиотеку %s',
        'Outgoing request data before processing (RequesterRequestInput)' =>
            'Подаци одлазећег захтева пре извршавања (RequesterRequestInput)',
        'Outgoing request data before mapping (RequesterRequestPrepareOutput)' =>
            'Подаци одлазећег захтева пре мапирања (RequesterRequestPrepareOutput)',
        'Outgoing request data after mapping (RequesterRequestMapOutput)' =>
            'Подаци примљеног захтева после мапирања (RequesterRequestMapOutput)',
        'Incoming response data before mapping (RequesterResponseInput)' =>
            'Подаци примљеног одговора пре мапирања (RequesterResponseInput)',
        'Outgoing error handler data after error handling (RequesterErrorHandlingOutput)' =>
            'Подаци о одлазећој грешци после обраде грешке (RequesterErrorHandlingOutput)',
        'Incoming request data before mapping (ProviderRequestInput)' => 'Подаци примљеног захтева пре мапирања (ProviderRequestInput)',
        'Incoming request data after mapping (ProviderRequestMapOutput)' =>
            'Подаци примљеног захтева после мапирања (ProviderRequestMapOutput)',
        'Outgoing response data before mapping (ProviderResponseInput)' =>
            'Подаци одлазећег одговора пре мапирања (ProviderResponseInput)',
        'Outgoing error handler data after error handling (ProviderErrorHandlingOutput)' =>
            'Подаци о одлазећој грешци после обраде грешке (ProviderErrorHandlingOutput)',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Could not determine config for operation %s' => 'Није могуће утврдити конфигурацију за операцију %s',
        'OperationType %s is not registered' => 'Тип операције %s није регистрован',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need valid Subaction!' => 'Неопходан важећи Subaction!',
        'This field should be an integer.' => 'Ово поље мора бити цео број.',
        'File or Directory not found.' => 'Датотека или директоријум нису пронађени.',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => 'Постоји други веб сервис са истим именом.',
        'There was an error updating the web service.' => 'Дошло је до грешке при ажурирању веб сервиса.',
        'There was an error creating the web service.' => 'Дошло је до грешке при креирању веб сервиса.',
        'Web service "%s" created!' => 'Веб сервис "%s" је креиран!',
        'Need Name!' => 'Неопходан Name!',
        'Need ExampleWebService!' => 'Неопходан ExampleWebService!',
        'Could not load %s.' => 'Није било могуће учитати %s.',
        'Could not read %s!' => 'Није могуће прочитати %s!',
        'Need a file to import!' => 'Неопходна датотека за увоз!',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            'Увезена датотека нема исправан YAML садржај! Молимо проверите OTRS лог за детаље',
        'Web service "%s" deleted!' => 'Веб сервис "%s" је обрисан!',
        'OTRS as provider' => 'OTRS као пружалац услуга',
        'Operations' => 'Операције',
        'OTRS as requester' => 'OTRS као наручилац',
        'Invokers' => 'Позиваоци',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => 'Нема WebserviceHistoryID!',
        'Could not get history data for WebserviceHistoryID %s' => 'Не могу прибавити податке историјата за ID веб сервиса %s',

        # Perl Module: Kernel/Modules/AdminGroup.pm
        'Group updated!' => 'Ажурирана група!',

        # Perl Module: Kernel/Modules/AdminMailAccount.pm
        'Mail account added!' => 'Додат имејл налог!',
        'Email account fetch already fetched by another process. Please try again later!' =>
            'Тренутно други процес преузима пошту имејл налога. Молимо покушајте касније.',
        'Dispatching by email To: field.' => 'Отпремање путем имејла За: поље.',
        'Dispatching by selected Queue.' => 'Отпремање путем изабраног реда.',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who created the ticket' => 'Оператер који је креирао тикет',
        'Agent who owns the ticket' => 'Оператер који је власник тикета',
        'Agent who is responsible for the ticket' => 'Оператер који је одговоран за тикет',
        'All agents watching the ticket' => 'Сви оператери који надзиру тикет',
        'All agents with write permission for the ticket' => 'Сви оператери са дозволом писања за тикет',
        'All agents subscribed to the ticket\'s queue' => 'Сви оператери претплаћени на ред тикета',
        'All agents subscribed to the ticket\'s service' => 'Сви оператери претплаћени на сервис тикета',
        'All agents subscribed to both the ticket\'s queue and service' =>
            'Сви оператери претплаћени и на ред и на сервис тикета',
        'Customer user of the ticket' => 'Клијент корисник тикета',
        'All recipients of the first article' => 'Сви примаоци првог чланка',
        'All recipients of the last article' => 'Сви примаоци последњег чланка',
        'Invisible to customer' => 'Невидљиво клијенту',
        'Visible to customer' => 'Видљиво клијенту',

        # Perl Module: Kernel/Modules/AdminOTRSBusiness.pm
        'Your system was successfully upgraded to %s.' => 'Ваш систем је успешно унапређен на %s.',
        'There was a problem during the upgrade to %s.' => 'Проблем током унапређивања на  %s.',
        '%s was correctly reinstalled.' => '%s је коректно реинсталирана.',
        'There was a problem reinstalling %s.' => 'Проблем при реинсталацији %s.',
        'Your %s was successfully updated.' => 'Ваша %s је успешно ажурирана.',
        'There was a problem during the upgrade of %s.' => 'Проблем током унапређивања %s.',
        '%s was correctly uninstalled.' => '%s је коректно деинсталирана.',
        'There was a problem uninstalling %s.' => 'Проблем при деинсталацији %s.',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            'PGP окружење не функционише. За више информација проверите лог.',
        'Need param Key to delete!' => 'Неопходан параметар Key за брисање!',
        'Key %s deleted!' => 'Кључ %s је обрисан!',
        'Need param Key to download!' => 'Неопходан параметар Key за преузимање!',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            'Жао нам је, али Apache::Reload је неопходан као PerlModule и PerlInitHandler у конфигурацији Apache-а. Молимо погледајте scripts/apache2-httpd.include.conf. Алтернативно, можете користити конзолну алатку bin/otrs.Console.pl за инсталацију пакета!',
        'No such package!' => 'Нема таквог пакета!',
        'No such file %s in package!' => 'Нема такве датотеке %s у пакету!',
        'No such file %s in local file system!' => 'Нема такве датотеке %s у локалном систему!',
        'Can\'t read %s!' => 'Немогуће читање %s!',
        'File is OK' => 'Датотека је у реду',
        'Package has locally modified files.' => 'Пакет садржи локално измењене датотеке.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Пакет није верификован од стране OTRS групе! Препоручује се да не користите овај пакет.',
        'Not Started' => 'Није покренуто',
        'Updated' => 'Ажурирано',
        'Already up-to-date' => 'Већ ажурно',
        'Installed' => 'Инсталирано',
        'Not correctly deployed' => 'Није коректно распоређено',
        'Package updated correctly' => 'Пакет успешно ажуриран',
        'Package was already updated' => 'Пакет је већ ажуран',
        'Dependency installed correctly' => 'Зависни пакети успешно инсталирани',
        'The package needs to be reinstalled' => 'Пакет мора бити реинсталиран.',
        'The package contains cyclic dependencies' => 'Пакет садржи цикличне зависности',
        'Not found in on-line repositories' => 'Није пронађен у мрежном спремишту',
        'Required version is higher than available' => 'Неопходна верзија је већа од тренутне',
        'Dependencies fail to upgrade or install' => 'Грешка прилико ажурирања или инсталације зависних пакета',
        'Package could not be installed' => 'Пакет није могао бити инсталиран',
        'Package could not be upgraded' => 'Пакет није могао бити ажуриран',
        'Repository List' => 'Листа спремишта',
        'No packages found in selected repository. Please check log for more info!' =>
            'У изабраном спремишту нема пакета. Молимо проверите лог за више информација.',
        'Package not verified due a communication issue with verification server!' =>
            'Пакет није верификован због комуникацијског проблема са верификационим сервером!',
        'Can\'t connect to OTRS Feature Add-on list server!' => 'Није могуће повезати се са OTRS Feature Add-on сервером!',
        'Can\'t get OTRS Feature Add-on list from server!' => 'Не могу прибавити OTRS Feature Add-on листу са сервера!',
        'Can\'t get OTRS Feature Add-on from server!' => 'Не могу прибавити OTRS Feature Add-on са сервера!',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => 'Нема таквог филтера: %s',

        # Perl Module: Kernel/Modules/AdminPriority.pm
        'Priority added!' => 'Додат приоритет!',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Обрађене информације из базе података нису синхронизоване са системском конфигурацијом, молимо вас да синхронизујете све процесе.',
        'Need ExampleProcesses!' => 'Неопходан ExampleProcesses!',
        'Need ProcessID!' => 'Неопходан ProcessID!',
        'Yes (mandatory)' => 'Да (обавезно)',
        'Unknown Process %s!' => 'Непознат процес %s!',
        'There was an error generating a new EntityID for this Process' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за овај процес',
        'The StateEntityID for state Inactive does not exists' => 'StateEntityID за неактивно стање не постоји',
        'There was an error creating the Process' => 'Дошло је до грешке приликом креирања Процеса',
        'There was an error setting the entity sync status for Process entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације за ентитет процеса: %s',
        'Could not get data for ProcessID %s' => 'Не могу прибавити податке за ID процеса %s',
        'There was an error updating the Process' => 'Дошло је до грешке приликом ажурирања Процеса',
        'Process: %s could not be deleted' => 'Процес: %s се не може обрисати',
        'There was an error synchronizing the processes.' => 'Дошло је до грешке при синхронизацији процеса.',
        'The %s:%s is still in use' => '%s:%s је још у употреби',
        'The %s:%s has a different EntityID' => '%s:%s има различит ID ентитета',
        'Could not delete %s:%s' => 'Није могуће обрисати %s:%s',
        'There was an error setting the entity sync status for %s entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за %s ентитет: %s',
        'Could not get %s' => 'Није могуће прибавити %s',
        'Need %s!' => 'Неопходан %s!',
        'Process: %s is not Inactive' => 'Процес: %s није неактиван',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за ову aктивност',
        'There was an error creating the Activity' => 'Дошло је до грешке приликом креирања Активности',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Активности: %s',
        'Need ActivityID!' => 'Неопходан ActivityID!',
        'Could not get data for ActivityID %s' => 'Не могу прибавити податке за ID активности %s',
        'There was an error updating the Activity' => 'Дошло је до грешке приликом ажурирања Активности',
        'Missing Parameter: Need Activity and ActivityDialog!' => 'Недостају параметри: неопходни Activity и ActivityDialog!',
        'Activity not found!' => 'Активност није пронађена!',
        'ActivityDialog not found!' => 'Дијалог активности није пронађен!',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            'Дијалог активности је већ додељен активности. Не можете додавати дијалог два пута.',
        'Error while saving the Activity to the database!' => 'Грешка при чувању активности у бази података!',
        'This subaction is not valid' => 'Ова подакција је неважећа',
        'Edit Activity "%s"' => 'Уреди активност "%s"',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за овај дијалог активности',
        'There was an error creating the ActivityDialog' => 'Дошло је до грешке приликом креирања Дијалога активности',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Диајлога активности: %s',
        'Need ActivityDialogID!' => 'Неопходан ActivityDialogID!',
        'Could not get data for ActivityDialogID %s' => 'Не могу прибавити податке за ID дијалога активности %s',
        'There was an error updating the ActivityDialog' => 'Дошло је до грешке приликом ажурирања Дијалога ктивности',
        'Edit Activity Dialog "%s"' => 'Уреди дијалог активности "%s"',
        'Agent Interface' => 'Оператерски интерфејс',
        'Customer Interface' => 'Клијентски интерфејс',
        'Agent and Customer Interface' => 'Оператерски и клијентски интерфејс',
        'Do not show Field' => 'Не приказуј ово поље',
        'Show Field' => 'Прикажи поље',
        'Show Field As Mandatory' => 'Прикажи поље као обавезно',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => 'Уреди путању',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за ову транзицију',
        'There was an error creating the Transition' => 'Дошло је до грешке приликом креирања Транзиције',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Транзиције: %s',
        'Need TransitionID!' => 'Неопходан TransitionID!',
        'Could not get data for TransitionID %s' => 'Не могу прибавити податке за ID транзиције %s',
        'There was an error updating the Transition' => 'Дошло је до грешке приликом ажурирања Транзиције',
        'Edit Transition "%s"' => 'Уреди транзицију "%s"',
        'Transition validation module' => 'Модул валидације транзиције',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => 'Неопходан је бар један валидан конфигурациони параметар.',
        'There was an error generating a new EntityID for this TransitionAction' =>
            'Дошло је до грешке приликом креирања новог ID ентитета за ову транзициону акцију',
        'There was an error creating the TransitionAction' => 'Дошло је до грешке приликом креирања Транзиционе акције',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            'Дошло је до грешке приликом подешавања статуса синхронизације ентитета за  ентитет Транзиционе акције: %s',
        'Need TransitionActionID!' => 'Неопходан TransitionActionID!',
        'Could not get data for TransitionActionID %s' => 'Не могу прибавити податке за ID транзиционе акције %s',
        'There was an error updating the TransitionAction' => 'Дошло је до грешке приликом ажурирања Транзиционе акције',
        'Edit Transition Action "%s"' => 'Уреди транзициону акцију "%s"',
        'Error: Not all keys seem to have values or vice versa.' => 'Грешка: Сви кључеви немају вредност или обрнуто.',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Queue updated!' => 'Ажуриран ред!',
        'Don\'t use :: in queue name!' => 'Немојте користити :: у називу реда!',
        'Click back and change it!' => 'Кликните на назад и промените то!',
        '-none-' => '-ни један-',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => 'Редови (без аутоматских одговора)',

        # Perl Module: Kernel/Modules/AdminQueueTemplates.pm
        'Change Queue Relations for Template' => 'Промени релације са редовима за шаблон',
        'Change Template Relations for Queue' => 'Промени релације са шаблонима за ред',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Продукција',
        'Test' => 'Тест',
        'Training' => 'Тренинг',
        'Development' => 'Развој',

        # Perl Module: Kernel/Modules/AdminRole.pm
        'Role updated!' => 'Ажурирана улога!',
        'Role added!' => 'Додата улога!',

        # Perl Module: Kernel/Modules/AdminRoleGroup.pm
        'Change Group Relations for Role' => 'Промени релација са групама за улогу',
        'Change Role Relations for Group' => 'Промени релације са улогама за групу',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => 'Улога',
        'Change Role Relations for Agent' => 'Промени релације са улогама за оператера',
        'Change Agent Relations for Role' => 'Промени релације са оператерима за улогу',

        # Perl Module: Kernel/Modules/AdminSLA.pm
        'Please activate %s first!' => 'Молимо, прво активирајте %s.',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            'S/MIME окружење не функционише. За више информација проверите лог.',
        'Need param Filename to delete!' => 'Неопходан параметар Filename за брисање!',
        'Need param Filename to download!' => 'Неопходан параметар Filename за преузимање!',
        'Needed CertFingerprint and CAFingerprint!' => 'Неопходан CertFingerprint и CAFingerprint!',
        'CAFingerprint must be different than CertFingerprint' => 'CAFingerprint мора бити другачији од CertFingerprint',
        'Relation exists!' => 'Веза постоји!',
        'Relation added!' => 'Додата веза!',
        'Impossible to add relation!' => 'Немогуће додавање везе!',
        'Relation doesn\'t exists' => 'Веза не постоји',
        'Relation deleted!' => 'Веза обрисана!',
        'Impossible to delete relation!' => 'Немогуће брисање везе!',
        'Certificate %s could not be read!' => 'Сертификат %s није могуће прочитати!',
        'Needed Fingerprint' => 'Неопходан Fingerprint',
        'Handle Private Certificate Relations' => 'Руковање везама приватних сертификата',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation added!' => 'Поздрав додат!',

        # Perl Module: Kernel/Modules/AdminSignature.pm
        'Signature updated!' => 'Ажуриран потпис!',
        'Signature added!' => 'Додат потпис!',

        # Perl Module: Kernel/Modules/AdminState.pm
        'State added!' => 'Додат статус!',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => 'Датотеку %s није могуће прочитати!',

        # Perl Module: Kernel/Modules/AdminSystemAddress.pm
        'System e-mail address added!' => 'Додата системска имејл адреса!',

        # Perl Module: Kernel/Modules/AdminSystemConfiguration.pm
        'Invalid Settings' => 'Неважећа подешавања',
        'There are no invalid settings active at this time.' => 'У овом тренутку нема неважећих подешавања.',
        'You currently don\'t have any favourite settings.' => 'Тренутно немате ниједно омиљено подешавање.',
        'The following settings could not be found: %s' => 'Следећа подешавања нису могла бити пронађена: %s',
        'Import not allowed!' => 'Увоз није дозвољен!',
        'System Configuration could not be imported due to an unknown error, please check OTRS logs for more information.' =>
            'Системска конфигурација није могла бити увежена звог непознате грешке, молико проверите OTRS логове за више информација.',
        'Category Search' => 'Претрага категорија',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationDeployment.pm
        'Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information.' =>
            'Нека увезена подешавања нису присутна у тренутној конфигурацији или није било могуће ажурирати их. Молимо проверите OTRS лог за више информација.',

        # Perl Module: Kernel/Modules/AdminSystemConfigurationGroup.pm
        'You need to enable the setting before locking!' => 'Морате укључити подешавање пре закључавања!',
        'You can\'t work on this setting because %s (%s) is currently working on it.' =>
            'Не можете уредити ово подешавање зато што %s (%s) тренутно ради на њему.',
        'Missing setting name!' => 'Недостаје назив подешавања!',
        'Missing ResetOptions!' => 'Недостаје ResetOptions!',
        'Setting is locked by another user!' => 'Подешавање је закључано од стране другог корисника!',
        'System was not able to lock the setting!' => 'Систем није успео да закључа подешавање!',
        'System was not able to reset the setting!' => 'Систем није успео да поништи подешавање!',
        'System was unable to update setting!' => 'Систем није успео да сачува подешавање!',
        'Missing setting name.' => 'Недостаје назив подешавања.',
        'Setting not found.' => 'Подешавање није пронађено.',
        'Missing Settings!' => 'Недостаје Settings!',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => 'Датум почетка не би требало одредити после датума завршетка!',
        'There was an error creating the System Maintenance' => 'Дошло је до грешке приликом креирања Одржавања система',
        'Need SystemMaintenanceID!' => 'Неопходан SystemMaintenanceID!',
        'Could not get data for SystemMaintenanceID %s' => 'Не могу прибавити податке за системско одржавање %s',
        'System Maintenance was added successfully!' => 'Системско одржавање је успешно додато!',
        'System Maintenance was updated successfully!' => 'Системско одржавање је успешно ажурирано!',
        'Session has been killed!' => 'Сесија је прекинута!',
        'All sessions have been killed, except for your own.' => 'Све сесије су прекинуте, осим сопствене.',
        'There was an error updating the System Maintenance' => 'Дошло је до грешке приликом ажурирања Одржавања система',
        'Was not possible to delete the SystemMaintenance entry: %s!' => 'Није било могуће обрисати унос за системско одржавање: %s!',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => 'Шаблон ажуриран!',
        'Template added!' => 'Шаблон додат!',

        # Perl Module: Kernel/Modules/AdminTemplateAttachment.pm
        'Change Attachment Relations for Template' => 'Промени релације са прилозима за шаблон',
        'Change Template Relations for Attachment' => 'Промени релације са шаблонима за прилог',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => 'Неопходан Type!',
        'Type added!' => 'Додат тип!',

        # Perl Module: Kernel/Modules/AdminUser.pm
        'Agent updated!' => 'Ажуриран оператер!',

        # Perl Module: Kernel/Modules/AdminUserGroup.pm
        'Change Group Relations for Agent' => 'Промени везе са групом за оператера',
        'Change Agent Relations for Group' => 'Промени везе са оператером за групу',

        # Perl Module: Kernel/Modules/AgentAppointmentAgendaOverview.pm
        'Month' => 'Месец',
        'Week' => 'Седмица',
        'Day' => 'Дан',

        # Perl Module: Kernel/Modules/AgentAppointmentCalendarOverview.pm
        'All appointments' => 'Сви термини',
        'Appointments assigned to me' => 'Термини додељени мени',
        'Showing only appointments assigned to you! Change settings' => 'Приказ само термина додељених вама! Измените подешавања',

        # Perl Module: Kernel/Modules/AgentAppointmentEdit.pm
        'Appointment not found!' => 'Термин није пронађен!',
        'Never' => 'Никада',
        'Every Day' => 'Сваки дан',
        'Every Week' => 'Сваке седмице',
        'Every Month' => 'Сваког месеца',
        'Every Year' => 'Сваке године',
        'Custom' => 'Прилагођено',
        'Daily' => 'Дневно',
        'Weekly' => 'Седмично',
        'Monthly' => 'Месечно',
        'Yearly' => 'Годишње',
        'every' => 'сваког(е)',
        'for %s time(s)' => 'укупно %s пут(а)',
        'until ...' => 'до ...',
        'for ... time(s)' => 'укупно ... пут(а)',
        'until %s' => 'до %s',
        'No notification' => 'Без обавештења',
        '%s minute(s) before' => '%s минут(а) пре',
        '%s hour(s) before' => '%s сат(а) пре',
        '%s day(s) before' => '%s дан(а) пре',
        '%s week before' => '%s недеља пре',
        'before the appointment starts' => 'пре него што термин започне',
        'after the appointment has been started' => 'пошто термин започне',
        'before the appointment ends' => 'пре него што се термин заврши',
        'after the appointment has been ended' => 'пошто се термин заврши',
        'No permission!' => 'Без дозволе!',
        'Cannot delete ticket appointment!' => 'Није могуће обрисати термин тикета!',
        'No permissions!' => 'Без дозволе!',

        # Perl Module: Kernel/Modules/AgentAppointmentList.pm
        '+%s more' => '+%s више',

        # Perl Module: Kernel/Modules/AgentCustomerSearch.pm
        'Customer History' => 'Историјат клијента',

        # Perl Module: Kernel/Modules/AgentCustomerUserAddressBook.pm
        'No RecipientField is given!' => 'Није дат RecipientField!',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => 'Нема такве конфигурације за %s',
        'Statistic' => 'Статистика',
        'No preferences for %s!' => 'Нема поставки за %s!',
        'Can\'t get element data of %s!' => 'Не могу прибавити податке елемента за %s!',
        'Can\'t get filter content data of %s!' => 'Не могу прибавити податке садржаја филтера за %s!',
        'Customer Name' => 'Назив клијента',
        'Customer User Name' => 'Назив клијент корисника',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => 'Неопходни SourceObject и SourceKey!',
        'You need ro permission!' => 'Неопходна вам је ro дозвола!',
        'Can not delete link with %s!' => 'Не може се обрисати веза са %s!',
        '%s Link(s) deleted successfully.' => '%sвеза(е) успешно обрисана(е).',
        'Can not create link with %s! Object already linked as %s.' => 'Не може се креирати веза са %s! Објект је већ повезан као %s.',
        'Can not create link with %s!' => 'Не може се креирати веза са %s!',
        '%s links added successfully.' => '%sвеза(е) успешно додата(е).',
        'The object %s cannot link with other object!' => 'Објект %s се не може повезати са другим објектом!',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => 'Неопходан параметар групе! ',
        'Updated user preferences' => 'Ажуриране корисничке поставке',
        'System was unable to deploy your changes.' => 'Систем није успео да распореди ваше промене.',
        'Setting not found!' => 'Подешавање није пронађено!',
        'System was unable to reset the setting!' => 'Систем није успео да поништи подешавање!',

        # Perl Module: Kernel/Modules/AgentSplitSelection.pm
        'Process ticket' => 'Процес тикет',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => 'Недостаје параметар %s.',
        'Invalid Subaction.' => 'Неважећа субакција.',
        'Statistic could not be imported.' => 'Статистика се не може увести.',
        'Please upload a valid statistic file.' => 'Молимо да учитате исправну датотеку статистике.',
        'Export: Need StatID!' => 'Извоз: неопходан StatID!',
        'Delete: Get no StatID!' => 'Delete: нема StatID!',
        'Need StatID!' => 'Неопходан StatID!',
        'Could not load stat.' => 'Није могуће учитавање статистике.',
        'Add New Statistic' => 'Додај нову статистику',
        'Could not create statistic.' => 'Није могуће креирање статистике.',
        'Run: Get no %s!' => 'Run: Нема %s!',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => 'Није дат TicketID!',
        'You need %s permissions!' => 'Неопходне су вам %s дозволе!',
        'Loading draft failed!' => 'Учитавање нацрта неуспело!',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'На жалост, морате бити власник тикета за ову акцију.',
        'Please change the owner first.' => 'Молимо прво промените власника.',
        'FormDraft functionality disabled!' => 'Својство FormDraft искључено!',
        'Draft name is required!' => 'Назив нацрта је обавезан!',
        'FormDraft name %s is already in use!' => 'Нацрта под називом %s већ постоји!',
        'Could not perform validation on field %s!' => 'Није могуће обавити валидацију за поље %s!',
        'No subject' => 'Нема предмет',
        'Could not delete draft!' => 'Није могуће обрисати нацрт!',
        'Previous Owner' => 'Претходни власник',
        'wrote' => 'написао/ла',
        'Message from' => 'Порука од',
        'End message' => 'Крај поруке',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '%s је неопходно!',
        'Plain article not found for article %s!' => 'Није пронађен обичан чланак за чланак %s!',
        'Article does not belong to ticket %s!' => 'Чланак не припада тикету %s!',
        'Can\'t bounce email!' => 'Не могу одбацити имејл!',
        'Can\'t send email!' => 'Не могу послати имејл!',
        'Wrong Subaction!' => 'Погрешна субакција!',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => 'Тикети се не могу закључати, није дат TicketIDs!',
        'Ticket (%s) is not unlocked!' => 'Тикет (%s) није откључан!',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to tickets: %s.' =>
            'Следећи тикети су били игнорисани зато што су закључани од стране другог оператера или зато што немате право уписа у њих: %s.',
        'The following ticket was ignored because it is locked by another agent or you don\'t have write access to ticket: %s.' =>
            'Следећи тикет је игнорисан зато што је закључан од стране другог оператера или зато што немате право уписа у исти: %s.',
        'You need to select at least one ticket.' => 'Неопходно је да изаберете бар један тикет.',
        'Bulk feature is not enabled!' => 'Масовна функција није активирана!',
        'No selectable TicketID is given!' => 'Није дат TicketID који се може изабрати!',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            'Нисте селектовали ни један тикет или само тикете које су закључали други оператери.',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            'Следећи тикети су били игнорисани зато што су закључани од стране другог оператера или зато што немате право уписа у њих: %s.',
        'The following tickets were locked: %s.' => 'Следећи тикети су били закључани: %s.',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Article subject will be empty if the subject contains only the ticket hook!' =>
            'Наслов чланка ће бити празан уколико предмет садржи само прикључак тикета!',
        'Address %s replaced with registered customer address.' => 'Адреса %s је замењена регистровном адресом клијента.',
        'Customer user automatically added in Cc.' => 'Клијент клијент се аутоматски додаје у Cc.',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'Ticket "%s" created!' => 'Тикет "%s" је креиран!',
        'No Subaction!' => 'Нема субакције!',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => 'Нема TicketID!',
        'System Error!' => 'Системска грешка!',

        # Perl Module: Kernel/Modules/AgentTicketEmailResend.pm
        'No ArticleID is given!' => 'Није дат ArticleID!',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Next week' => 'Следеће недеље',
        'Ticket Escalation View' => 'Ескалациони преглед тикета',

        # Perl Module: Kernel/Modules/AgentTicketForward.pm
        'Article %s could not be found!' => 'Чланак %s није пронађен!',
        'Forwarded message from' => 'Прослеђена порука од',
        'End forwarded message' => 'Крај прослеђене поруке',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => 'Не може се приказати историјат, није дат TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => 'Тикет се не може закључати, није дат TicketID!',
        'Sorry, the current owner is %s!' => 'На жалост, актуелни власник је %s!',
        'Please become the owner first.' => 'Молимо прво преузмите власништво.',
        'Ticket (ID=%s) is locked by %s!' => 'Тикет (ID=%s) је закључан од стране %s!',
        'Change the owner!' => 'Промени власника!',

        # Perl Module: Kernel/Modules/AgentTicketLockedView.pm
        'New Article' => 'Нови чланак',
        'Pending' => 'На чекању',
        'Reminder Reached' => 'Достигнут подсетник',
        'My Locked Tickets' => 'Моји закључани тикети',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => 'Тикет се не може повезати са собом!',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => 'Неопходна вам је дозвола за премештање!',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => 'Ћаскање није активно.',
        'No permission.' => 'Нема дозволе.',
        '%s has left the chat.' => '%s је напустио ћаскање.',
        'This chat has been closed and will be removed in %s hours.' => 'Ово ћаскање је затворено и биће уклоњено за %s сати.',

        # Perl Module: Kernel/Modules/AgentTicketPhoneCommon.pm
        'Ticket locked.' => 'Закључан тикет.',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => 'Нема ArticleID!',
        'This is not an email article.' => 'Ово није имејл чланак.',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            'Немогуће читање неформатираног чланка! Можда не постоји неформатирана порука у спремишту! Прочитајте поруку из приказа.',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => 'Неопходан TicketID!',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => 'Не могу прибавити ActivityDialogEntityID "%s"!',
        'No Process configured!' => 'Нема конфигурисаног процеса!',
        'The selected process is invalid!' => 'Означени процес је неважећи!',
        'Process %s is invalid!' => 'Процес %s је неважећи!',
        'Subaction is invalid!' => 'Субакција је неважећа!',
        'Parameter %s is missing in %s.' => 'Недостаје параметар %s у %s.',
        'No ActivityDialog configured for %s in _RenderAjax!' => 'Ниједан ActivityDialog није конфигурисан за %s у _RenderAjax!',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            'Нема Start ActivityEntityID или Start ActivityDialogEntityID за процес %s у _GetParam!',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => 'Нема тикета за TicketID: %s у _GetParam!',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            'Не може се утврдити ActivityEntityID. DynamicField или Config нису правилно подешени!',
        'Process::Default%s Config Value missing!' => 'Вредност конфигурације за Process::Default%s недостаје!',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            'Нема ProcessEntityID или TicketID и ActivityDialogEntityID!',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            'Не могу прибавити StartActivityDialog и StartActivityDialog за ProcessEntityID "%s"!',
        'Can\'t get Ticket "%s"!' => 'Не могу прибавити тикет "%s"!',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            'Не могу прибавити ProcessEntityID или ActivityEntityID за тикет "%s"!',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            'Не могу прибавити конфигурацију Activity за ActivityEntityID "%s"!',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            'Не могу прибавити конфигурацију ActivityDialog за ActivityDialogEntityID "%s"!',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => 'Не могу прибавити податке за поље "%s" од ActivityDialog "%s"!',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            'Време чекања тикета може бити коришћено ако су State или StateID подешени за исти дијалог активности. ActivityDialog: %s!',
        'Pending Date' => 'Датум чекања',
        'for pending* states' => 'за стања* чекања',
        'ActivityDialogEntityID missing!' => 'Недостаје ActivityDialogEntityID!',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => 'Не могу прибавити конфигурацију за ActivityDialogEntityID "%s"!',
        'Couldn\'t use CustomerID as an invisible field.' => 'CustomerID се не може користити као невидљиво поље.',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            'Нема ProcessEntityID, проверите ваш ActivityDialogHeader.tt!',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            'Нема StartActivityDialog или StartActivityDialog за процес "%s"!',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            'Не могу креирати тикет за процес са ProcessEntityID "%s"!',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => 'Не могу поставити ProcessEntityID "%s" за TicketID "%s"!',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => 'Не могу поставити ActivityEntityID "%s" за TicketID "%s"!',
        'Could not store ActivityDialog, invalid TicketID: %s!' => 'Не могу снимити дијалог активности, неважећи TicketID: %s!',
        'Invalid TicketID: %s!' => 'Неважећи TicketID: %s!',
        'Missing ActivityEntityID in Ticket %s!' => 'Недостаје ActivityEntityID у тикету %s!',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            'Овај корак не припада више тренутној активности процеса за тикет \'%s%s%s\'! Други корисник је у међувремену променио овај тикет. Молимо да затворите овај прозор и поново учитате тикет.',
        'Missing ProcessEntityID in Ticket %s!' => 'Недостаје ProcessEntityID у тикету %s!',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Не могу поставити вредност динамичког поља за %s за TicketID "%s" у ActivityDialog "%s"!',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Не могу поставити време чекања тикета за тикет "%s" у ActivityDialog "%s"!',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            'Погрешна конфигурација поља у дијалогу активности: %s не може бити Display => 1 / приказано. (Молимо подесите конфигурацију да буде Display => 0 / није приказано или Display => 2 / прикажи као обавезно)!',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            'Не могу поставити %s за тикет "%s" у ActivityDialog "%s"!',
        'Default Config for Process::Default%s missing!' => 'Подразумевано подешавање за Process::Default%s недостаје!',
        'Default Config for Process::Default%s invalid!' => 'Подразумевано подешавање за Process::Default%s је неважеће!',

        # Perl Module: Kernel/Modules/AgentTicketQueue.pm
        'Available tickets' => 'Слободни тикети',
        'including subqueues' => 'укључујући подредове',
        'excluding subqueues' => 'искључујући подредове',
        'QueueView' => 'Преглед реда',

        # Perl Module: Kernel/Modules/AgentTicketResponsibleView.pm
        'My Responsible Tickets' => 'Тикети за које сам одговоран',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'last-search' => 'последња претрага',
        'Untitled' => 'Нема наслов',
        'Ticket Number' => 'Број тикета',
        'Ticket' => 'Тикет',
        'printed by' => 'штампао',
        'CustomerID (complex search)' => 'ID клијента (сложена претрага)',
        'CustomerID (exact match)' => 'ID клијента (тачно поклапање)',
        'Invalid Users' => 'Погрешни корисници',
        'Normal' => 'Normal',
        'CSV' => 'CSV',
        'Excel' => 'Excel',
        'in more than ...' => 'у више од ...',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => 'Функција није активирана!',
        'Service View' => 'Преглед услуге',

        # Perl Module: Kernel/Modules/AgentTicketStatusView.pm
        'Status View' => 'Преглед статуса',

        # Perl Module: Kernel/Modules/AgentTicketWatchView.pm
        'My Watched Tickets' => 'Моји надзирани тикети',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => 'Функција није активна',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Обрисана веза',
        'Ticket Locked' => 'Закључан тикет',
        'Pending Time Set' => 'Времена чекања је подешено',
        'Dynamic Field Updated' => 'Ажурирано динамичко поље',
        'Outgoing Email (internal)' => 'Одлазни имејл (интерни)',
        'Ticket Created' => 'Креиран тикет',
        'Type Updated' => 'Ажуриран тип',
        'Escalation Update Time In Effect' => 'Актуелно време ажурирања ескалације',
        'Escalation Update Time Stopped' => 'Време ажурирања ескалације је заустављено',
        'Escalation First Response Time Stopped' => 'Време првог одзива ескалације је заустављено',
        'Customer Updated' => 'Ажуриран клијент',
        'Internal Chat' => 'Интерно ћаскање',
        'Automatic Follow-Up Sent' => 'Послат аутоматски наставак',
        'Note Added' => 'Додата напомена',
        'Note Added (Customer)' => 'Додата напомена (клијент)',
        'SMS Added' => 'Додат SMS',
        'SMS Added (Customer)' => 'Додат SMS (клијент)',
        'State Updated' => 'Ажурирано стање',
        'Outgoing Answer' => 'Одлазни одговор',
        'Service Updated' => 'Ажуриран сервис',
        'Link Added' => 'Додата веза',
        'Incoming Customer Email' => 'Долазни имејл клијента',
        'Incoming Web Request' => 'Долазни веб захтев',
        'Priority Updated' => 'Ажуриран приоритет',
        'Ticket Unlocked' => 'Откључан тикет',
        'Outgoing Email' => 'Одлазни имејл',
        'Title Updated' => 'Ажуриран наслов',
        'Ticket Merged' => 'Спојен тикет',
        'Outgoing Phone Call' => 'Одлазни позив',
        'Forwarded Message' => 'Прослеђена порука',
        'Removed User Subscription' => 'Уклоњена претплата за корисника',
        'Time Accounted' => 'Време је обрачунато',
        'Incoming Phone Call' => 'Долазни позив',
        'System Request.' => 'Системски захтев.',
        'Incoming Follow-Up' => 'Долазни наставак',
        'Automatic Reply Sent' => 'Послат аутоматски одговор',
        'Automatic Reject Sent' => 'Послато аутоматско одбијање',
        'Escalation Solution Time In Effect' => 'Актуелно време решавања ескалације',
        'Escalation Solution Time Stopped' => 'Време решења ескалације је заустављено',
        'Escalation Response Time In Effect' => 'Актуелно време одговора на ескалацију',
        'Escalation Response Time Stopped' => 'Време одзива ескалације је заустављено',
        'SLA Updated' => 'SLA је ажуриран',
        'External Chat' => 'Екстерно ћаскање',
        'Queue Changed' => 'Промењен ред',
        'Notification Was Sent' => 'Обавештење је послато',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state.' =>
            'Овај тикет више не постоји, или тренутно немате дозволу за приступ истом.',
        'Missing FormDraftID!' => 'Недостаје FormDraftID!',
        'Can\'t get for ArticleID %s!' => 'Не могу прибавити ArticleID %s!',
        'Article filter settings were saved.' => 'Подешавања филтера чланка су сачувана.',
        'Event type filter settings were saved.' => 'Подешавања филтера типа догађаја су сачувана.',
        'Need ArticleID!' => 'Неопходан ArticleID!',
        'Invalid ArticleID!' => 'Неважећи ArticleID!',
        'Forward article via mail' => 'Проследи чланак путем мејла',
        'Forward' => 'Проследи',
        'Fields with no group' => 'Поља без групе',
        'Invisible only' => 'Само невидљиви',
        'Visible only' => 'Само видљиви',
        'Visible and invisible' => 'Видљиви и невидљиви',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Чланак се не може отворити! Могуће је да је на другој страници?',
        'Show one article' => 'Прикажи један чланак',
        'Show all articles' => 'Прикажи све чланке',
        'Show Ticket Timeline View' => 'Прикажи тикете на временској линији',
        'Show Ticket Timeline View (%s)' => 'Прикажи тикете на временској линији (%s)',

        # Perl Module: Kernel/Modules/AjaxAttachment.pm
        'Got no FormID.' => 'Није дат FormID.',
        'Error: the file could not be deleted properly. Please contact your administrator (missing FileID).' =>
            'Грешка: датотека није могла бити обрисана. Молимо контактирајте вашег администратора (недостаје FileID).',

        # Perl Module: Kernel/Modules/CustomerTicketArticleContent.pm
        'ArticleID is needed!' => 'Неопходан ArticleID!',
        'No TicketID for ArticleID (%s)!' => 'Нема TicketID за овај ArticleID (%s)!',
        'HTML body attachment is missing!' => 'Прилог са HTML садржајем недостаје!',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => 'Неопходни FileID и ArticleID!',
        'No such attachment (%s)!' => 'Нема таквог прилога (%s)!',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => 'Проверите подешавања за %s::QueueDefault.',
        'Check SysConfig setting for %s::TicketTypeDefault.' => 'Проверите подешавања за %s::TicketTypeDefault.',
        'You don\'t have sufficient permissions for ticket creation in default queue.' =>
            'Немаш одговарајуће дозволе за креирање тикета у подразумеваном реду.',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => 'Неопходан CustomerID!',
        'My Tickets' => 'Моји тикети',
        'Company Tickets' => 'Тикети фирми',
        'Untitled!' => 'Нема наслов!',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Customer Realname' => 'Право име клијента',
        'Created within the last' => 'Креирано у последњих',
        'Created more than ... ago' => 'Креирано пре више од ...',
        'Please remove the following words because they cannot be used for the search:' =>
            'Молимо да уклоните следеће речи  јер се не могу користити за претрагу:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => 'Тикет се не може поново отворити, није могуће у овом реду!',
        'Create a new ticket!' => 'Отвори нови тикет!',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => 'Сигуран режим је активан!',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            'Уколико желите да поново покренете инсталацију, онемогућите SecureMode у подешавањима.',
        'Directory "%s" doesn\'t exist!' => 'Директоријум "%s" не постоји!',
        'Configure "Home" in Kernel/Config.pm first!' => 'Прво подесите "Home" у Kernel/Config.pm!',
        'File "%s/Kernel/Config.pm" not found!' => 'Датотека "%s/Kernel/Config.pm" није пронађена!',
        'Directory "%s" not found!' => 'Директоријум "%s" није пронађен!',
        'Install OTRS' => 'Инсталирај OTRS',
        'Intro' => 'Увод',
        'Kernel/Config.pm isn\'t writable!' => 'Немогућ упис у %s/Kernel/Config.pm!',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            'Ако желите да користите инсталациони програм, подесите дозволу писања у Kernel/Config.pm за веб сервер корисника!',
        'Database Selection' => 'Селекција базе података',
        'Unknown Check!' => 'Непозната провера!',
        'The check "%s" doesn\'t exist!' => 'Провера "%s" не постоји!',
        'Enter the password for the database user.' => 'Унеси лозинку за корисника базе података.',
        'Database %s' => 'База података %s',
        'Configure MySQL' => 'Подеси MySQL',
        'Enter the password for the administrative database user.' => 'Унеси лозинку за корисника административне базе података.',
        'Configure PostgreSQL' => 'Подеси PostgreSQL',
        'Configure Oracle' => 'Подеси Oracle',
        'Unknown database type "%s".' => 'Непознат тип базе података "%s".',
        'Please go back.' => 'Молимо идите назад.',
        'Create Database' => 'Креирај базу података',
        'Install OTRS - Error' => 'Инсталирање OTRS - грешка',
        'File "%s/%s.xml" not found!' => 'Датотека "%s/%s.xml" није пронађена!',
        'Contact your Admin!' => 'Контактирајте вашег администратора!',
        'System Settings' => 'Системска подешавања',
        'Syslog' => 'Системски лог',
        'Configure Mail' => 'Подеси имејл',
        'Mail Configuration' => 'Подешавање имејла',
        'Can\'t write Config file!' => 'Не могу да упишем конфигурациону датотеку!',
        'Unknown Subaction %s!' => 'Непозната субакција %s!',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            'Не могу се повезати на базу података, Перл модул DBD::%s није инсталиран!',
        'Can\'t connect to database, read comment!' => 'Не могу се повезати на базу података, прочитајте коментар!',
        'Database already contains data - it should be empty!' => 'База података већ садржи податке - требало би да буде празна.',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Грешка: Молимо да проверите да ваша база података прихвата пакете по величини веће од %s MB  (тренутно прихвата пакете величине до %s MB). Молимо да прилагодите параметар max_allowed_packet подешавање у вашој бази података како би избегли грешке.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Грешка: Молимо да подесете вредност за innodb_log_file_size у вашој бази података на најмање %s MB (тренутно: %s MB, препоручено: %s MB). За више информација, молимо погледајте на %s.',
        'Wrong database collation (%s is %s, but it needs to be utf8).' =>
            'Неисправно подешена база података (%s је %s, а требало би да буде utf8).',

        # Perl Module: Kernel/Modules/PublicCalendar.pm
        'No %s!' => 'Без %s!',
        'No such user!' => 'Непознат корисник!',
        'Invalid calendar!' => 'Неисправан календар!',
        'Invalid URL!' => 'Неисправна адреса!',
        'There was an error exporting the calendar!' => 'Грешка приликом експортовања календара!',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => 'Неопходна конфигурација Package::RepositoryAccessRegExp',
        'Authentication failed from %s!' => 'Аутентификација није успела од %s!',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketBounce.pm
        'Bounce Article to a different mail address' => 'Преусмеравање чланка на другу имејл адресу',
        'Bounce' => 'Преусмери',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketCompose.pm
        'Reply All' => 'Одговори на све',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketEmailResend.pm
        'Resend this article' => 'Пошаљи поново овај чланак',
        'Resend' => 'Пошаљи поново',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketMessageLog.pm
        'View message log details for this article' => 'Преглед лога поруке за овај чланак',
        'Message Log' => 'Лог поруке',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketNote.pm
        'Reply to note' => 'Одговори на напомену',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPhone.pm
        'Split this article' => 'Подели овај чланак',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPlain.pm
        'View the source for this Article' => 'Погледај извор овог Чланка',
        'Plain Format' => 'Неформатиран формат',

        # Perl Module: Kernel/Output/HTML/ArticleAction/AgentTicketPrint.pm
        'Print this article' => 'Одштампај овај чланак',

        # Perl Module: Kernel/Output/HTML/ArticleAction/GetHelpLink.pm
        'Contact us at sales@otrs.com' => 'Контактирајте нас на sales@otrs.com',
        'Get Help' => 'Тражи помоћ',

        # Perl Module: Kernel/Output/HTML/ArticleAction/MarkAsImportant.pm
        'Mark' => 'Означено',
        'Unmark' => 'Неозначено',

        # Perl Module: Kernel/Output/HTML/ArticleAction/ReinstallPackageLink.pm
        'Upgrade to OTRS Business Solution™' => 'Унапредите на OTRS Business Solution™',
        'Re-install Package' => 'Инсталирај поново пакет',
        'Upgrade' => 'Ажурирање',
        'Re-install' => 'Инсталирај поново',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Crypted' => 'Шифровано',
        'Sent message encrypted to recipient!' => 'Послата шифрована порука примаоцу!',
        'Signed' => 'Потписано',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '"PGP SIGNED MESSAGE" заглавље пронађено, али је неисправно!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '"S/MIME SIGNED MESSAGE" заглавље пронађено, али је неисправно!',
        'Ticket decrypted before' => 'Тикет је дешифрован пре',
        'Impossible to decrypt: private key for email was not found!' => 'Немогуће дешифровање: приватни кључ за ову адресу није пронађен!',
        'Successful decryption' => 'Успешно дешифровање',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Crypt.pm
        'There are no encryption keys available for the addresses: \'%s\'. ' =>
            'Нису пронађени кључеви за шифровање за адресу: \'%s\'.',
        'There are no selected encryption keys for the addresses: \'%s\'. ' =>
            'Нису одабрани кључеви за шифровање за адресу: \'%s\'.',
        'Cannot use expired encryption keys for the addresses: \'%s\'. ' =>
            'Није могуће користити истекао кључ за шифровање за адресе: \'%s\'.',
        'Cannot use revoked encryption keys for the addresses: \'%s\'. ' =>
            'Није могуће користити повучен кључ за шифровање за адресе: \'%s\'.',
        'Encrypt' => 'Шифровање',
        'Keys/certificates will only be shown for recipients with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Кључеви/сертификати ће бити приказани само за примаоце са више од једног кључева/сертификата. Први пронађени кључ/сертификат ће бити аутоматски одабран. Молимо проверите да ли је одабран исправан.',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Security.pm
        'Email security' => 'Имејл безбедност',
        'PGP sign' => 'PGP потписивање',
        'PGP sign and encrypt' => 'PGP потпис и шифровање',
        'PGP encrypt' => 'PGP шифровање',
        'SMIME sign' => 'SMIME потписивање',
        'SMIME sign and encrypt' => 'SMIME потпис и шифровање',
        'SMIME encrypt' => 'SMIME шифровање',

        # Perl Module: Kernel/Output/HTML/ArticleCompose/Sign.pm
        'Cannot use expired signing key: \'%s\'. ' => 'Није могуће користити истекао кључ за потписивање: \'%s\'.',
        'Cannot use revoked signing key: \'%s\'. ' => 'Није могуће користити повучен кључ за потписивање: \'%s\'.',
        'There are no signing keys available for the addresses \'%s\'.' =>
            'Нема кључева за потписивање за адресе \'%s\'.',
        'There are no selected signing keys for the addresses \'%s\'.' =>
            'Нема одабраних кључева за потписивање за адресе \'%s\'.',
        'Sign' => 'Потпис',
        'Keys/certificates will only be shown for a sender with more than one key/certificate. The first found key/certificate will be pre-selected. Please make sure to select the correct one.' =>
            'Кључеви/сертификати ће бити приказани само за пошиљаоце са више од једног кључева/сертификата. Први пронађени кључ/сертификат ће бити аутоматски одабран. Молимо проверите да ли је одабран исправан.',

        # Perl Module: Kernel/Output/HTML/Dashboard/AppointmentCalendar.pm
        'Shown' => 'Приказан',
        'Refresh (minutes)' => 'Освежи (минута)',
        'off' => 'искључено',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerIDList.pm
        'Shown customer ids' => 'Приказани клијент ID',

        # Perl Module: Kernel/Output/HTML/Dashboard/CustomerUserList.pm
        'Shown customer users' => 'Приказани клијенти корисници',
        'Offline' => 'Није на вези',
        'User is currently offline.' => 'Корисник тренутно није на вези.',
        'User is currently active.' => 'Корисник је тренутно активан.',
        'Away' => 'Одсутан',
        'User was inactive for a while.' => 'Корисник није био активан неко време.',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => 'Време почетка тикета је подешено после времена завршетка!',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => 'Није могуће повезати се са OTRS News сервером!',
        'Can\'t get OTRS News from server!' => 'Не могу прибавити OTRS News са сервера!',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => 'Није могуће повезази се са Product News сервером!',
        'Can\'t get Product News from server!' => 'Не могу прибавити Product News са сервера!',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => 'Није могуће повезати се са %s!',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'Shown Tickets' => 'Приказани тикети',
        'Shown Columns' => 'Приказане колоне',
        'filter not active' => 'филтер није активан',
        'filter active' => 'филтер је активан',
        'This ticket has no title or subject' => 'Овај тикет нема наслов или предмет',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketStatsGeneric.pm
        '7 Day Stats' => 'Седмодневна статистика',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'User set their status to unavailable.' => 'Корисник је недоступан.',
        'Unavailable' => 'Недоступно',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'Standard' => 'Стандардан',
        'The following tickets are not updated: %s.' => 'Следећи тикети нису ажурирани: %s.',
        'h' => 'ч',
        'm' => 'м',
        'd' => 'д',
        'This ticket does not exist, or you don\'t have permissions to access it in its current state. You can take one of the following actions:' =>
            'Овај тикет више не постоји, или тренутно немате дозволу за приступ истом. Можете предузети једну од следећих акција:',
        'This is a' => 'Ово је',
        'email' => 'имејл',
        'click here' => 'кликните овде',
        'to open it in a new window.' => 'за отварање у новом прозору.',
        'Year' => 'Година',
        'Hours' => 'Сати',
        'Minutes' => 'Минути',
        'Check to activate this date' => 'Проверите за активирање овог датума',
        '%s TB' => '%s TB',
        '%s GB' => '%s GB',
        '%s MB' => '%s MB',
        '%s KB' => '%s KB',
        '%s B' => '%s B',
        'No Permission!' => 'Немате дозволу!',
        'No Permission' => 'Нема дозволе',
        'Show Tree Selection' => 'Прикажи дрво избора',
        'Split Quote' => 'Подели квоту',
        'Remove Quote' => 'Уклони квоту.',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => 'Повезано као',
        'Search Result' => 'Резултат претраге',
        'Linked' => 'Повезано',
        'Bulk' => 'Масовно',

        # Perl Module: Kernel/Output/HTML/Layout/Ticket.pm
        'Lite' => 'Једноставан',
        'Unread article(s) available' => 'Располиживи непрочитани чланци',

        # Perl Module: Kernel/Output/HTML/LinkObject/Appointment.pm
        'Appointment' => 'Термин',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => 'Претрага архиве',

        # Perl Module: Kernel/Output/HTML/Notification/AgentCloudServicesDisabled.pm
        'Enable cloud services to unleash all OTRS features!' => 'Активирајте сервисе у облаку да би омогућили све OTRS функције!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s Унапредите на %s сада! %s',
        'Please verify your license data!' => 'Молимо проверите податке ваше лиценце!',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'Лиценца за ваш %s истиче ускоро. Молимо да контактирате %s ради обнове уговора!',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'Ажурирање за ваш %s је доступно, али постоји неусаглашеност са верзијом вашег система! Молимо вас да прво ажурирате верзију вашег система!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOnline.pm
        'Online Agent: %s' => 'Оператер на вези: %s',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTicketEscalation.pm
        'There are more escalated tickets!' => 'Има још ескалиралих тикета!',

        # Perl Module: Kernel/Output/HTML/Notification/AgentTimeZoneCheck.pm
        'Please select a time zone in your preferences and confirm it by clicking the save button.' =>
            'Молимо одаберите временску зону у личним подешавањима и потврдите кликом на дугме за чување.',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerOnline.pm
        'Online Customer: %s' => 'Клијент на вези: %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'System maintenance is active!' => 'Одржавање система је активно!',
        'A system maintenance period will start at: %s and is expected to stop at: %s' =>
            'Период одржавања система ће отпочети у: %s и очекивано је да се заврши у: %s',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'OTRS Daemon is not running.' => 'OTRS системски сервис не ради.',

        # Perl Module: Kernel/Output/HTML/Notification/OutofOfficeCheck.pm
        'You have Out of Office enabled, would you like to disable it?' =>
            'Активирана је опција ван канцеларије, желите ли да је искључите?',

        # Perl Module: Kernel/Output/HTML/Notification/PackageManagerCheckNotVerifiedPackages.pm
        'The installation of packages which are not verified by the OTRS Group is activated. These packages could threaten your whole system! It is recommended not to use unverified packages.' =>
            'Могућност инсталације пакета који нису верификоване од стране OTRS групе је укључена. Ови пакети могу угрозити ваш цео систем. Препоручујемо да не користите неверификоване пакете.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationInvalidCheck.pm
        'You have %s invalid setting(s) deployed. Click here to show invalid settings.' =>
            'Имате %s распоређено(а) неважеће(а) подешавање(а). Кликните овде за приказ неважећих подешавања.',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationIsDirtyCheck.pm
        'You have undeployed settings, would you like to deploy them?' =>
            'Имате нераспоређених подешавања, да ли желите да их распоредите?',

        # Perl Module: Kernel/Output/HTML/Notification/SystemConfigurationOutOfSyncCheck.pm
        'The configuration is being updated, please be patient...' => 'Конфигурација се освежава, молимо сачекајте...',
        'There is an error updating the system configuration!' => 'Грешка приликом освежавања системске конфигурације!',

        # Perl Module: Kernel/Output/HTML/Notification/UIDCheck.pm
        'Don\'t use the Superuser account to work with %s! Create new Agents and work with these accounts instead.' =>
            'Не користите суперкориснички налог за рад са %s! Направите нове налоге за оператере и користите њих.',

        # Perl Module: Kernel/Output/HTML/Preferences/AppointmentNotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            'Молимо вас да проверите да сте изабрали бар један метод транспорта за обавезна обавештења.',
        'Preferences updated successfully!' => 'Поставке су успешно ажуриране!',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '(у току)',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Молимо да одредите датум завршетка који је после датума почетка.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Current password' => 'Садашња лозинка',
        'New password' => 'Нова лозинка',
        'Verify password' => 'Потврди лозинку',
        'The current password is not correct. Please try again!' => 'Актуелна лозинка је нетачна. Молимо покушајте поново!',
        'Please supply your new password!' => 'Молимо да обезбедите нову лозинку!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Лозинка не може бити ажурирана, нови уноси су различити. Молимо покушајте поново!',
        'This password is forbidden by the current system configuration. Please contact the administrator if you have additional questions.' =>
            'Ова лозинка је забрањена тренутном системском конфигурацијом. Молимо контактирајте админстратора за додатна питања.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Лозинка не може бити ажурирана. Минимална дужина лозинке је %s знакова.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase letter characters!' =>
            'Лозинка не може бити ажурирана, мора садржати најмање 2 мала и 2 велика слова!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Лозинка не може бити ажурирана. Мора да садржи најнмање једну бројку.',
        'Can\'t update password, it must contain at least 2 letter characters!' =>
            'Лозинка не може бити ажурирана, мора садржати најмање 2 слова!',

        # Perl Module: Kernel/Output/HTML/Preferences/TimeZone.pm
        'Time zone updated successfully!' => 'Временска зона успешно ажурирана!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'invalid' => 'неважећи',
        'valid' => 'важећи',
        'No (not supported)' => 'Не (није подржано)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            'Није одабрана временска вредност са комплетном прошлошћу или комплетним тренутним и будућим релативним периодом.',
        'The selected time period is larger than the allowed time period.' =>
            'Изабрани временски период је дужи од дозвољеног.',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            'Нема доступног временског опсега за актуелну изабрану вредност опсега на X оси.',
        'The selected date is not valid.' => 'Изабрани датум није важећи.',
        'The selected end time is before the start time.' => 'Изабрано време завршетка је пре времена почетка.',
        'There is something wrong with your time selection.' => 'Нешто није у реду са вашим избором времена.',
        'Please select only one element or allow modification at stat generation time.' =>
            'Молимо да изаберете само један елемент или дозволите измене у време генерисања старта!',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            'Молимо да изаберете барем једну вредност овог поља или дозволите измену у време генерисања статистике.',
        'Please select one element for the X-axis.' => 'Молимо да изаберете један елемент за X-осу.',
        'You can only use one time element for the Y axis.' => 'Можете користити само један временски елемент за Y осу.',
        'You can only use one or two elements for the Y axis.' => 'Можете да користите само један или два елемента за Y осу.',
        'Please select at least one value of this field.' => 'Молимо да изаберете бар једну вредност за ово поље.',
        'Please provide a value or allow modification at stat generation time.' =>
            'Молимо да обезбедите вредност или дозволите измене у време генерисања старта.',
        'Please select a time scale.' => 'Молимо да одаберете временски опсег.',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            'Ваш интервал извештавања је прекратак, молимо употребите већи распон времена.',
        'second(s)' => 'секунде(е)',
        'quarter(s)' => 'тромесечје(а)',
        'half-year(s)' => 'полугодиште(а)',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            'Молимо да уклоните следеће речи јер се не могу користити због ограничења тикета: %s.',

        # Perl Module: Kernel/Output/HTML/SysConfig.pm
        'Cancel editing and unlock this setting' => 'Одустани од промене и откључај ово подешавање',
        'Reset this setting to its default value.' => 'Поништи ово подешавање на подразумевану вредност',
        'Unable to load %s!' => 'Није могуће учитати %s!',
        'Content' => 'Садржај',

        # Perl Module: Kernel/Output/HTML/TicketMenu/Lock.pm
        'Unlock to give it back to the queue' => 'Откључајте за враћање у ред',
        'Lock it to work on it' => 'Закључајте за рад на тикету',

        # Perl Module: Kernel/Output/HTML/TicketMenu/TicketWatcher.pm
        'Unwatch' => 'Прекини надзор',
        'Remove from list of watched tickets' => 'Уклони са листе праћених тикета',
        'Watch' => 'Посматрај',
        'Add to list of watched tickets' => 'Додај на листу праћених тикета',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Сортирај по',

        # Perl Module: Kernel/Output/HTML/TicketZoom/TicketInformation.pm
        'Ticket Information' => 'Информације о тикету',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketLocked.pm
        'Locked Tickets New' => 'Нови закључани тикети',
        'Locked Tickets Reminder Reached' => 'Достигнут подсетник закључаних тикета',
        'Locked Tickets Total' => 'Укупно закључних тикета',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketResponsible.pm
        'Responsible Tickets New' => 'Нови одговорни тикети',
        'Responsible Tickets Reminder Reached' => 'Достигнут подсетник одговорних тикета',
        'Responsible Tickets Total' => 'Укупно одговорних тикета',

        # Perl Module: Kernel/Output/HTML/ToolBar/TicketWatcher.pm
        'Watched Tickets New' => 'Нови праћени тикети',
        'Watched Tickets Reminder Reached' => 'Достигнут подсетник праћених тикета',
        'Watched Tickets Total' => 'Укупно праћених тикета',

        # Perl Module: Kernel/Output/PDF/Ticket.pm
        'Ticket Dynamic Fields' => 'Динамичка поља тикета',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            'Учитавање ACL конфигурације није било могуће. Молимо проверите да ли је фајл исправан.',

        # Perl Module: Kernel/System/Auth.pm
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Пријава тренутно није могућа због планираног одржавања система.',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            'Прекорачили сте број истовремено пријављених оператера - контактирајте sales@otrs.com.',
        'Please note that the session limit is almost reached.' => 'Имајте у виду да је ограничење сесија скоро достигнуто.',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            'Пријава одбијена! Прекорачили сте дозвољени број истовремено пријављених оператера! Под хитно контактирајте sales@otrs.com!',
        'Session limit reached! Please try again later.' => 'Сесија је истекла! Молимо покушајте касније!',
        'Session per user limit reached!' => 'Достигнуто ограничење броја сесија по кориснику!',

        # Perl Module: Kernel/System/AuthSession/DB.pm
        'Session invalid. Please log in again.' => 'Сесија је неважећа. Молимо пријавите се поново.',
        'Session has timed out. Please log in again.' => 'Време сесије је истекло. Молимо пријавите се поново.',

        # Perl Module: Kernel/System/Calendar/Event/Transport/Email.pm
        'PGP sign only' => 'Само PGP потпис',
        'PGP encrypt only' => 'Само PGP шифровање',
        'SMIME sign only' => 'Само SMIME потпис',
        'SMIME encrypt only' => 'Само SMIME шифровање',
        'PGP and SMIME not enabled.' => 'PGP и SMIME нису омогућени!',
        'Skip notification delivery' => 'Прескочи доставу обавештења',
        'Send unsigned notification' => 'Пошаљи непотписано обавештење',
        'Send unencrypted notification' => 'Пошаљи нешифовано обавештење',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => 'Референтни списак конфигурационих опција',
        'This setting can not be changed.' => 'Ово подешавање се не може мењати.',
        'This setting is not active by default.' => 'Ово подешавање није подразумевано активно.',
        'This setting can not be deactivated.' => 'Ово подешавање се не може деактивирати.',
        'This setting is not visible.' => 'Ово подешавање није видљиво.',
        'This setting can be overridden in the user preferences.' => 'Ово подешавање може бити прегажено у личним подешавањима корисника.',
        'This setting can be overridden in the user preferences, but is not active by default.' =>
            'Ово подешавање може бити прегажено у личним подешавањима корисника, али није подразумевано активно.',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => 'Клијент корисник "%s" већ постоји.',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            'Ова адреса електронске поште је већ искоришћена за другог клијент корисника.',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseDateTime.pm
        'before/after' => 'пре/после',
        'between' => 'између',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => 'нпр. Text или Te*t',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => 'Игнориши ово поље.',

        # Perl Module: Kernel/System/DynamicField/Driver/TextArea.pm
        'This field is required or' => 'Ово поље је обавезно или',
        'The field content is too long!' => 'Садржај поља је предугачак!',
        'Maximum size is %s characters.' => 'Максимална величина је %s карактера.',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            'Учитавање конфигурације обавештења није било могуће. Молимо проверите да ли је фајл исправан.',
        'Imported notification has body text with more than 4000 characters.' =>
            'Текст садржаја увезеног обавештења има више од 4000 карактера.',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => 'није инсталирано',
        'installed' => 'инсталирано',
        'Unable to parse repository index document.' => 'Није могуће рашчланити спремиште индекса документа.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Нема пакета за верзију вашег система, у спремишту су само пакети за друге верзије.',
        'File is not installed!' => 'Датотека није инсталирана!',
        'File is different!' => 'Датотека је различита!',
        'Can\'t read file!' => 'Немогуће читање датотеке!',
        '<p>If you continue to install this package, the following issues may occur:</p><ul><li>Security problems</li><li>Stability problems</li><li>Performance problems</li></ul><p>Please note that issues that are caused by working with this package are not covered by OTRS service contracts.</p>' =>
            '<p>Ако наставите са инсталацијом овог пакета, могу се јавити следећи проблеми:</p><ul><li>Безбедносни проблеми</li><li>Проблеми стабилности</li><li>Проблеми у перформансама</li></ul><p>Напомињемо да проблеми настали услед рада са овим пакетом нису покривени OTRS сервисним уговором.</p>',
        '<p>The installation of packages which are not verified by the OTRS Group is not possible by default. You can activate the installation of not verified packages via the "AllowNotVerifiedPackages" system configuration setting.</p>' =>
            '<p>Инсталација пакета који нису верификовани од стране OTRS групе није подразумевано омогућена. Можете активирати инсталацију неверификованих пакета путем "AllowNotVerifiedPackages" опције у системској конфигурацији.</p>',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            'Процес "%s" и све информације везане за њега су успешно увезени.',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Неактивно',
        'FadeAway' => 'У гашењу',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t contact registration server. Please try again later.' => 'Не можете да контактирате сервер за регистрацију. Молимо покушајте поново касније.',
        'No content received from registration server. Please try again later.' =>
            'Садржај није примљен од сервера за регистрацију. Молимо покушајте поново касније.',
        'Can\'t get Token from sever' => 'Не могу прибавити токен од сервера',
        'Username and password do not match. Please try again.' => 'Корисничко име и лозинка се не поклапају. Молимо покушајте поново.',
        'Problems processing server result. Please try again later.' => 'Проблеми у обради резултата сервера. Молимо покушајте поново касније.',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Збир',
        'week' => 'недеља',
        'quarter' => 'тромесечје',
        'half-year' => 'полугодиште',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Тип статуса',
        'Created Priority' => 'Направљени приоритети',
        'Created State' => 'Креирани статус',
        'Create Time' => 'Време креирања',
        'Pending until time' => 'Време чекања',
        'Close Time' => 'Време затварања',
        'Escalation' => 'Ескалација',
        'Escalation - First Response Time' => 'Ескалација - време првог одзива',
        'Escalation - Update Time' => 'Ескалација - време ажурирања',
        'Escalation - Solution Time' => 'Ескалација - време решавања',
        'Agent/Owner' => 'Оператер/Власник',
        'Created by Agent/Owner' => 'Креирао Оператер/Власник',
        'Assigned to Customer User Login' => 'Додељени клијент корисник',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Проценио',
        'Ticket/Article Accounted Time' => 'Обрачунато време',
        'Ticket Create Time' => 'Време отварања тикета',
        'Ticket Close Time' => 'Време затварања тикета',
        'Accounted time by Agent' => 'Обрачунато време по оператеру',
        'Total Time' => 'Укупно време',
        'Ticket Average' => 'Просечно време по тикету',
        'Ticket Min Time' => 'Минимално време тикета',
        'Ticket Max Time' => 'Максимално време тикета',
        'Number of Tickets' => 'Број тикета',
        'Article Average' => 'Просечно време по чланку',
        'Article Min Time' => 'Минимално време чланка',
        'Article Max Time' => 'Максимално време чланка',
        'Number of Articles' => 'Број чланака',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => 'неограничено',
        'Attributes to be printed' => 'Атрибути за штампу',
        'Sort sequence' => 'Редослед сортирања',
        'State Historic' => 'Историјат статуса',
        'State Type Historic' => 'Историјат типа статуса',
        'Historic Time Range' => 'Временски опсег историјата',
        'Number' => 'Број',
        'Last Changed' => 'Последни пут промењено',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => 'Просечно време решења',
        'Solution Min Time' => 'Минимално време решења',
        'Solution Max Time' => 'Максимално време решења',
        'Solution Average (affected by escalation configuration)' => 'Просечно време решења (под утицајем поставки ескалације)',
        'Solution Min Time (affected by escalation configuration)' => 'Минимално време решења (под утицајем поставки ескалације)',
        'Solution Max Time (affected by escalation configuration)' => 'Максимално време решења (под утицајем поставки ескалације)',
        'Solution Working Time Average (affected by escalation configuration)' =>
            'Просечно радно време решења (под утицајем поставки ескалације)',
        'Solution Min Working Time (affected by escalation configuration)' =>
            'Минимално радно време решења (под утицајем поставки ескалације)',
        'Solution Max Working Time (affected by escalation configuration)' =>
            'Максимално радно време решења (под утицајем поставки ескалације)',
        'First Response Average (affected by escalation configuration)' =>
            'Просечно време првог одговора (под утицајем поставки ескалације)',
        'First Response Min Time (affected by escalation configuration)' =>
            'Минимално време првог одговора (под утицајем поставки ескалације)',
        'First Response Max Time (affected by escalation configuration)' =>
            'Максимално време првог одговора (под утицајем поставки ескалације)',
        'First Response Working Time Average (affected by escalation configuration)' =>
            'Просечно радно време првог одговора (под утицајем поставки ескалације)',
        'First Response Min Working Time (affected by escalation configuration)' =>
            'Минимално радно време првог одговора (под утицајем поставки ескалације)',
        'First Response Max Working Time (affected by escalation configuration)' =>
            'Максимално радно време првог одговора (под утицајем поставки ескалације)',
        'Number of Tickets (affected by escalation configuration)' => 'Број тикета (под утицајем поставки ескалације)',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Дани',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/OutdatedTables.pm
        'Outdated Tables' => 'Застареле табеле',
        'Outdated tables were found in the database. These can be removed if empty.' =>
            'У бази података су пронађене застареле табеле. Уколико су празне, табеле могу бити слободно уклоњене.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Присуство табеле',
        'Internal Error: Could not open file.' => 'Интерна грешка: Није могуће отворити датотеку.',
        'Table Check' => 'Провера табеле',
        'Internal Error: Could not read file.' => 'Интерна грешка: Није могуће прочитати датотеку.',
        'Tables found which are not present in the database.' => 'Пронађене табеле које нису присутне у бази података.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Величина базе података',
        'Could not determine database size.' => 'Није могуће утврдити величину базе података.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Верзија базе података',
        'Could not determine database version.' => 'Није могуће утврдити верзију базе података',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Карактерсет за повезивање клијента',
        'Setting character_set_client needs to be utf8.' => 'Подешавање character_set_client мора бити utf8.',
        'Server Database Charset' => 'Karakterset serverske baze podataka',
        'This character set is not yet supported, please see https://bugs.otrs.org/show_bug.cgi?id=12361. Please convert your database to the character set \'utf8\'.' =>
            '',
        'The setting character_set_database needs to be \'utf8\'.' => 'Подешавање character_set_database мора бити \'utf8\'.',
        'Table Charset' => 'Табела карактерсета',
        'There were tables found which do not have \'utf8\' as charset.' =>
            'Пронађене су табеле које немају \'utf8\' као карактерсет.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'Величина InnoDB лог датотеке',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Подешавање innodb_log_file_size мора бити барем 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InvalidDefaultValues.pm
        'Invalid Default Values' => 'Неисправне подразумеване вредности',
        'Tables with invalid default values were found. In order to fix it automatically, please run: bin/otrs.Console.pl Maint::Database::Check --repair' =>
            'Пронађене су табеле са неисправним подразумеваним вредностима. Да бисте их аутоматски исправили, молимо покрените bin/otrs.Console.pl Maint::Database::Check --repair',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Максимална величина упита',
        'The setting \'max_allowed_packet\' must be higher than 64 MB.' =>
            'Подешавање \'max_allowed_packet\' мора бити више од 64 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Величина кеш упита',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Подешавање \'query_cache_size\' мора бити коришћено (веће од 10 MB, али не више од 512 MB)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Подразумевани механизам за складиштење',
        'Table Storage Engine' => 'Механизам за складиштење табеле',
        'Tables with a different storage engine than the default engine were found.' =>
            'Пронађене су табеле са различитим механизмом за складиштење него што је предефинисани механизам.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'Неопходан је MySQL 5.x или више.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => 'NLS_LANG подешавање',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            'NLS_LANG мора бити подешен на al32utf8 (нпр. GERMAN_GERMANY.AL32UTF8).',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT подешавање',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT мора бити подешен на \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL провера NLS_DATE_FORMAT подешавања',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/PrimaryKeySequencesAndTriggers.pm
        'Primary Key Sequences and Triggers' => 'Секвенце и окидачи примарних кључева',
        'The following sequences and/or triggers with possible wrong names have been found. Please rename them manually.' =>
            'Пронађене су секвенце и/или окидачи са могућим погрешним називима. Молимо вас да им ручно промените називе.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Подешавање client_encoding мора бити UNICODE или UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Подешавање server_encoding мора бити UNICODE или UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Формат датума',
        'Setting DateStyle needs to be ISO.' => 'Подешавање DateStyle мора бити ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/PrimaryKeySequences.pm
        'Primary Key Sequences' => 'Секвенце примарних кључева',
        'The following sequences with possible wrong names have been found. Please rename them manually.' =>
            'Пронађене су секвенце са могућим погрешним називима. Молимо вас да им ручно промените називе.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 9.2 or higher is required.' => 'Неопходан је PostgreSQL 9.2 или више.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS партиција на диску',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Коришћење диска',
        'The partition where OTRS is located is almost full.' => 'Партиција на којој је смештен ОТРС је скоро пуна.',
        'The partition where OTRS is located has no disk space problems.' =>
            'Партиција на којој је смештен ОТРС нема проблеме са простором.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => 'Коришћење партиције на диску',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Расподела',
        'Could not determine distribution.' => 'Није могуће утврдити расподелу.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Кернел верзија',
        'Could not determine kernel version.' => 'Није могуће утврдити кернел верзију',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'Оптерећење система',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'Оптерећење система може бити највише број процесора које систем поседује (нпр. оптерећење од 8 или мање на систему са 8 језгара је у реду).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl модули',
        'Not all required Perl modules are correctly installed.' => 'Сви захтевани Perl модули нису коректно инсталирани.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModulesAudit.pm
        'Perl Modules Audit' => 'Сигурносна провера Perl модула',
        'CPAN::Audit reported that one or more installed Perl modules have known vulnerabilities. Please note that there might be false positives for distributions patching Perl modules without changing their version number.' =>
            'CPAN::Audit је детектовао један или више рањивих Perl модула инсталираних на систему. Молимо обратите пажњу да су могући лажно позитивни резултати за дистрибуције које освежавају Perl модуле без промене њихове верзије.',
        'CPAN::Audit did not report any known vulnerabilities in the installed Perl modules.' =>
            'CPAN::Audit није детектовао рањиве Perl модуле инсталиране на систему.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Слободни Swap простор (%)',
        'No swap enabled.' => 'Размењивање није активирано.',
        'Used Swap Space (MB)' => 'Употребљен Swap простор (MB)',
        'There should be more than 60% free swap space.' => 'Мора постојати више од 60 % слободног swap простора',
        'There should be no more than 200 MB swap space used.' => 'Не треба да буде више од 200 MB употребљеног Swap простора.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticleSearchIndexStatus.pm
        'OTRS' => 'OTRS',
        'Article Search Index Status' => 'Стање индекса претраге чланака',
        'Indexed Articles' => 'Индексираних чланака',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ArticlesPerCommunicationChannel.pm
        'Articles Per Communication Channel' => 'Чланака по комуникационом каналу',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLog.pm
        'Incoming communications' => 'Долазне комуникације',
        'Outgoing communications' => 'Одлазне комуникације',
        'Failed communications' => 'Неуспеле комуникације',
        'Average processing time of communications (s)' => 'Просечно време трајања комуникација (с)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/CommunicationLogAccountStatus.pm
        'Communication Log Account Status (last 24 hours)' => 'Стање налога комуникационог лога (последњих 24 сата)',
        'No connections found.' => 'Нису пронађене конекције.',
        'ok' => 'у реду',
        'permanent connection errors' => 'трајне грешке у конекцији',
        'intermittent connection errors' => 'повремене грешке у конекцији',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'Config Settings' => 'Подешавања конфигурације',
        'Could not determine value.' => 'Није могуће утврдити вредност.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Системски сервис',
        'Daemon is running.' => 'Сервис ради.',
        'Daemon is not running.' => 'Сервис не ради.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => 'Записи у бази података',
        'Tickets' => 'Тикети',
        'Ticket History Entries' => 'Историја уноса тикета',
        'Articles' => 'Чланци',
        'Attachments (DB, Without HTML)' => 'Прилози (база података, без HTML)',
        'Customers With At Least One Ticket' => 'Клијенти са бар једним тикетом',
        'Dynamic Field Values' => 'Вредности динамичког поља',
        'Invalid Dynamic Fields' => 'Неважећа динамичка поља.',
        'Invalid Dynamic Field Values' => 'Неважеће вредности динамичких поља.',
        'GenericInterface Webservices' => 'GenericInterface веб сервис',
        'Process Tickets' => 'Процес тикети',
        'Months Between First And Last Ticket' => 'Месеци између првог и последњег тикета',
        'Tickets Per Month (avg)' => 'Тикети месечно (просечно)',
        'Open Tickets' => 'Отворени тикети',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => 'Подразумевано SOAP корисничко име и лозинка',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Сигурносни ризик: користите подразумевана подешавања за SOAP::User i SOAP::Password. Молимо промените га.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => 'Предефинисана лозинка администратора',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Сигурносни ризик: агент налог root@localhost још увек има предефинисану лозинку. Молимо промените је или деактивирајте налог.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/EmailQueue.pm
        'Email Sending Queue' => 'Ред за слање имејлова',
        'Emails queued for sending' => 'Број имејлова заказаних за слање',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (назив домена)',
        'Please configure your FQDN setting.' => 'Молимо да конфигуришете FQDN подешавање.',
        'Domain Name' => 'Назив домена',
        'Your FQDN setting is invalid.' => 'Ваша FQDN подешавања су неважећа.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'Омогућено писање у систем датотека.',
        'The file system on your OTRS partition is not writable.' => 'Није могуће писање у систем датотека на вашој OTRS партицији.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/LegacyConfigBackups.pm
        'Legacy Configuration Backups' => 'Резервне копије прошлих конфигурација',
        'No legacy configuration backup files found.' => 'Нису пронађене резервне копије прошлих конфигурација.',
        'Legacy configuration backup files found in Kernel/Config/Backups folder, but they might still be required by some packages.' =>
            'Пронађене су резервне копије прошлих конфигурација у Kernel/Config/Backups, међутим могу бити неопходне за рад инсталираних пакета.',
        'Legacy configuration backup files are no longer needed for the installed packages, please remove them from Kernel/Config/Backups folder.' =>
            'Резервне копије прошлих конфигурација више нису неопходне за рад инсталираних пакета, молимо уклоните их из Kernel/Config/Backups.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => 'Статус инсталације пакета',
        'Some packages have locally modified files.' => 'Неки пакети садрже локално измењене датотеке.',
        'Some packages are not correctly installed.' => 'Неки пакети нису исправно инсталирани.',
        'Package Verification Status' => 'Статус верификације пакета',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            'Неки пакети нису верификовани од стране OTRS групе! Препоручује се да не користите ове пакете.',
        'Package Framework Version Status' => 'Статус пакета за верзију система',
        'Some packages are not allowed for the current framework version.' =>
            'Неки пакети нису дозвољени за верзију вашег система. ',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'Листа пакета',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => 'Подешавања сесија',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => 'Имејлови у реду чекања',
        'There are emails in var/spool that OTRS could not process.' => 'Постоје имејлови у var/spool које OTRS не може да обради.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Ваша подешавање SystemID је неважеће, треба да садржи само цифре.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => 'Подразумевани тип тикета',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            'Подешени подразумевани тип тикета је неважећи или недостаје. Молимо промените подешавање Ticket::Type::Default и изаберите важећи тип тикета.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => 'Тикет индекс модул',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Имате више од 60.000 тикета и треба да користите StaticDB модул. Погледајте администраторско упутство (Подешавање перформанси) за више информација.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => 'Неисправни корисници са закључаним тикетима',
        'There are invalid users with locked tickets.' => 'Постоје неисправни корисници са закључаним тикетима.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'You should not have more than 8,000 open tickets in your system.' =>
            'Не би требало да имате више од 8.000 отворених тикета у систему.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => 'Модул за индексну претрагу тикета',
        'The indexing process forces the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Процес индексирања ће укључити спремање оригиналног текста чланка у индексу претраге, без извршавања филтера или уклањања зауставних речи. Ово ће увећати величину индекса претраге и може успорити текстуалну претрагу.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => 'Напуштени записи у ticket_lock_index табели',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Табела ticket_lock_index садржи неповезане записе. Молимо да покренете bin/otrs.Console.pl Maint::Ticket::QueueIndexCleanup да би очистили StaticDB индекс.',
        'Orphaned Records In ticket_index Table' => 'Напуштени записи у ticket_index табели',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            'Табела ticket_lindex садржи неповезане записе. Молимо да покренете bin/otrs.Console.pl Maint::Ticket::QueueIndexCleanup да би очистили StaticDB индекс.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => 'Подешавања времена',
        'Server time zone' => 'Временска зона сервера',
        'OTRS time zone' => 'OTRS временска зона',
        'OTRS time zone is not set.' => 'OTRS временска зона није подешена.',
        'User default time zone' => 'Подразумевана временска зона корисника',
        'User default time zone is not set.' => 'Подразумевана временска зона корисника није подешена.',
        'Calendar time zone is not set.' => 'Временска зона календара није подешена.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => 'UI - изгледи интерфејса оператера у коришћењу',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => 'UI - теме интерфејса оператера у коришћењу',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/SpecialStats.pm
        'UI - Special Statistics' => 'UI - посебне статистике',
        'Agents using custom main menu ordering' => 'Оператери са прилагођеним редоследом главног менија',
        'Agents using favourites for the admin overview' => 'Оператери са омиљеним ставкама за администраторски преглед',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Веб сервер',
        'Loaded Apache Modules' => 'Учитани Apache модули',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => 'MPM модел',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS захтева да Apache буде покренут са \'prefork\' MPM моделом.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => 'Употреба CGI Accelerator',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'За повећање перформанси треба да користите FastCGI или mod_perl.',
        'mod_deflate Usage' => 'Употреба mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Молимо инсталирајте mod_deflate за убрзавање графичког интерфејса.',
        'mod_filter Usage' => 'Коришћење mod_filter',
        'Please install mod_filter if mod_deflate is used.' => 'Молимо да инсталирате mod_filter ако је mod_deflate употребљен.',
        'mod_headers Usage' => 'Употреба mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Молимо инсталирајте mod_headers за убрзавање графичког интерфејса.',
        'Apache::Reload Usage' => 'Употреба Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ili Apache2::Reload се користе као Perl модул и PerlInitHandler ради заштите од рестартовања веб сервера током инсталирања или надоградње модула.',
        'Apache2::DBI Usage' => 'Употреба Apache2::DBI',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache2::DBI би требало користити за боље перформансе са унапред успостављеним везама са базом података.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Environment Variables' => 'Променљиве за окружење',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => 'Сакупљање података подршке',
        'Support data could not be collected from the web server.' => 'Подаци подршке не могу бити прикупљени са веб сервера.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Веб сервер верзија',
        'Could not determine webserver version.' => 'Не може да препозна веб сервер верзију.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => 'Детаљи истовремених корисника',
        'Concurrent Users' => 'Истовремени корисници',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'OK' => 'У реду',
        'Problem' => 'Проблем',

        # Perl Module: Kernel/System/SysConfig.pm
        'Setting %s does not exists!' => 'Подешавање %s не постоји!',
        'Setting %s is not locked to this user!' => 'Подешавање %s није закључано на овог корисника!',
        'Setting value is not valid!' => 'Вредност подешавања је неважећа!',
        'Could not add modified setting!' => 'Није могуће додати промењено подешавање!',
        'Could not update modified setting!' => 'Није могуће ажурирати промењено подешавање!',
        'Setting could not be unlocked!' => 'Није могуће откључати подешавање!',
        'Missing key %s!' => 'Недостаје кључ %s!',
        'Invalid setting: %s' => 'Неважеће подешавање: %s',
        'Could not combine settings values into a perl hash.' => 'Није било могуће искомбиновати вредност подешавања у perl мапу.',
        'Can not lock the deployment for UserID \'%s\'!' => 'Није било могуће обезбедити распоређивање за UserID \'%s\'!',
        'All Settings' => 'Сва подешавања',

        # Perl Module: Kernel/System/SysConfig/BaseValueType.pm
        'Default' => 'Подразумевано',
        'Value is not correct! Please, consider updating this field.' => 'Вредност није исправна! Молимо освежите ово поље.',
        'Value doesn\'t satisfy regex (%s).' => 'Вредност не задовољава регуларни израз (%s).',

        # Perl Module: Kernel/System/SysConfig/ValueType/Checkbox.pm
        'Enabled' => 'Омогућен',
        'Disabled' => 'Онемогућен',

        # Perl Module: Kernel/System/SysConfig/ValueType/Date.pm
        'System was not able to calculate user Date in OTRSTimeZone!' => 'Систем није успео да израчуна кориснички Date у OTRSTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/DateTime.pm
        'System was not able to calculate user DateTime in OTRSTimeZone!' =>
            'Систем није успео да израчуна кориснички DateTime у OTRSTimeZone!',

        # Perl Module: Kernel/System/SysConfig/ValueType/FrontendNavigation.pm
        'Value is not correct! Please, consider updating this module.' =>
            'Вредност није исправна! Молимо освежите овај модул.',

        # Perl Module: Kernel/System/SysConfig/ValueType/VacationDays.pm
        'Value is not correct! Please, consider updating this setting.' =>
            'Вредност није исправна! Молимо освежите ово подешавање.',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Поништавање времена откључавања.',

        # Perl Module: Kernel/System/Ticket/Article/Backend/Chat.pm
        'Chat Participant' => 'Учесник ћаскања',
        'Chat Message Text' => 'Порука ћаскања',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Неуспешна пријава! Нетачно је унето ваше корисничко име или лозинка.',
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            'Аутентификација је успела, али подаци о клијенту нису пронађени у бази. Молимо контактирајте администратора.',
        'Can`t remove SessionID.' => 'SessionID се не може уклонити.',
        'Logout successful.' => 'Успешна одјава.',
        'Feature not active!' => 'Функција није активна!',
        'Sent password reset instructions. Please check your email.' => 'Упутство за ресет лозинке је послато. Молимо проверите ваше имејлове.',
        'Invalid Token!' => 'Неважећи Токен!',
        'Sent new password to %s. Please check your email.' => 'Послата нова лозинка за %s. Молимо проверите ваше имејлове.',
        'Error: invalid session.' => 'Грешка: неважећа сесија.',
        'No Permission to use this frontend module!' => 'Немате дозволу за  употребу овог корисничког модула!',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Аутентификација је успела, али подаци о клијенту нису пронађени у извору клијената. Молимо контактирајте администратора.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            'Поништавање лозинке није успело. Молимо контактирајте администратора',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Ова имејл адреса већ постоји. Молимо, пријавите се или ресетујте вашу лозинку.',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Регистрација ове имејл адресе није дозвољено. Молимо да контактирате подршку.',
        'Added via Customer Panel (%s)' => 'Додато преко клијентског панела (%s)',
        'Customer user can\'t be added!' => 'Не може се додати клијент корисник!',
        'Can\'t send account info!' => 'Не могу послати инфо о налогу!',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Креиран је нови налог. Подаци за пријаву послати %с. Молимо проверите ваш имејл.',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => 'Акција "%s" није пронађена!',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'invalid-temporarily' => 'неважећи-привремено',
        'Group for default access.' => 'Група за подразумеван приступ.',
        'Group of all administrators.' => 'Група свих администратора.',
        'Group for statistics access.' => 'Група за приступ статистици.',
        'new' => 'ново',
        'All new state types (default: viewable).' => 'Сви нови типови стања (подразумевано: видљиво).',
        'open' => 'отворени',
        'All open state types (default: viewable).' => 'Сви отворени типови стања (подразумевано: видљиво).',
        'closed' => 'затворени',
        'All closed state types (default: not viewable).' => 'Сви затворени типови стања (подразумевано: видљиво).',
        'pending reminder' => 'подсетник чекања',
        'All \'pending reminder\' state types (default: viewable).' => 'Сви типови стања "подсетник на чекању" (подразумевано: видљиво).',
        'pending auto' => 'аутоматско чекање',
        'All \'pending auto *\' state types (default: viewable).' => 'Сви типови стања "подсетник аутоматски *" (подразумевано: видљиво).',
        'removed' => 'уклоњени',
        'All \'removed\' state types (default: not viewable).' => 'Сви типови стања "уклоњено" (подразумевано: видљиво).',
        'merged' => 'спојено',
        'State type for merged tickets (default: not viewable).' => 'Тип стања за спојене тикете (подразумевано: није видљиво).',
        'New ticket created by customer.' => 'Нови тикет који је отворио клијент.',
        'closed successful' => 'затворено успешно',
        'Ticket is closed successful.' => 'Тикет је затворен успешно.',
        'closed unsuccessful' => 'затворено неуспешно',
        'Ticket is closed unsuccessful.' => 'Тикет је затворен неуспешно.',
        'Open tickets.' => 'Отворени тикети.',
        'Customer removed ticket.' => 'Клијент је уклонио тикет.',
        'Ticket is pending for agent reminder.' => 'Тикет је на чекању за оператерски подсетник.',
        'pending auto close+' => 'чекање на аутоматско затварање+',
        'Ticket is pending for automatic close.' => 'Тикет је на чекању за аутоматско затварање.',
        'pending auto close-' => 'чекање на аутоматско затварање-',
        'State for merged tickets.' => 'Статус за спојене тикете.',
        'system standard salutation (en)' => 'стандардни системски поздрав (en)',
        'Standard Salutation.' => 'Стандардни Поздрав',
        'system standard signature (en)' => 'стандардни системски потпис (en)',
        'Standard Signature.' => 'Стандардни потпис.',
        'Standard Address.' => 'Стандардна адреса.',
        'possible' => 'могуће',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            'Настављање на затворене тикете је могуће. Тикети ће бити поново отворени.',
        'reject' => 'одбаци',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            'Настављање на затворене тикете није могуће. Нови тикет неће бити креиран.',
        'new ticket' => 'нови тикет',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
            'Настављање на затворене тикете није могуће. Нови тикет ће бити креиран.',
        'Postmaster queue.' => 'Postmaster ред.',
        'All default incoming tickets.' => ' Сви подразумевани долазни тикети.',
        'All junk tickets.' => 'Сви бесмислени тикети junk.',
        'All misc tickets.' => 'Сви други тикети.',
        'auto reply' => 'аутоматски одговор',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            'Аутоматски одговор који ће бити послат после креирања новог тикета.',
        'auto reject' => 'аутоматско одбацивање',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            'Аутоматска порука која ће бити послата након одбацивања наставка (у случају да је опција наставка за ред постављена на "одбаци").',
        'auto follow up' => 'аутоматско праћење',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            'Аутоматска потврда која ће бити послата након примања наставка у тикету (у случају да је опција наставка за ред постављена на "могуће").',
        'auto reply/new ticket' => 'аутоматски одговор/нови тикет',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            'Аутоматски одговор који ће бити послат након одбацивања наставка и креирања новог тикета (у случају да је опција наставка за ред постављена на "нови тикет").',
        'auto remove' => 'аутоматско уклањање',
        'Auto remove will be sent out after a customer removed the request.' =>
            'Аутоматско уклањање ће бити послато кад клијент уклони захтев.',
        'default reply (after new ticket has been created)' => 'подразумевани одговор (после креирања новог тикета)',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            'подразумевано одбацивање (после настављања и одбацивања затвореног тикета)',
        'default follow-up (after a ticket follow-up has been added)' => 'подразумевано наствљање (после додавања настављања на тикет)',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            'подразумевано одбацивање/креиран нови тикет (после затвореног настављања са креирањем новог тикета)',
        'Unclassified' => 'Неразврстано',
        '1 very low' => '1 врло низак',
        '2 low' => '2 низак',
        '3 normal' => '3 нормалан',
        '4 high' => '4 висок',
        '5 very high' => '5 врло висок',
        'unlock' => 'откључан',
        'lock' => 'закључан',
        'tmp_lock' => 'tmp_lock',
        'agent' => 'оператер',
        'system' => 'систем',
        'customer' => 'клијент',
        'Ticket create notification' => 'Обавештење о креирању тикета',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            'Добићете обавештење сваки пут кад се креира нови тикет у једном од ваших "Моји редови" или "Моји сервиси".',
        'Ticket follow-up notification (unlocked)' => 'Обавештење о настављању тикета (откључано)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            'Добићете обавештење када корисник пошаље наставак у откључаном тикету који се налази у "Моји редови" или "Моје услуге".',
        'Ticket follow-up notification (locked)' => 'Обавештење о настављању тикета (закључано)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            'Добићете обавештење када корисник пошаље наставак у закључаном тикету чији сте власник или одговорни.',
        'Ticket lock timeout notification' => 'Обавештење о истицању закључавања тикета',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            'Добићете обавештење одмах након аутоматског откључавања тикета чији сте власник.',
        'Ticket owner update notification' => 'Обавештење о ажурирању власника тикета',
        'Ticket responsible update notification' => 'Обавештење о ажурирању одговорног за тикет',
        'Ticket new note notification' => 'Обавештење о новој напомени тикета',
        'Ticket queue update notification' => 'Обавештење о ажурирању реда тикета',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            'Добићете обавештење ако се тикет премести у један од ваших "Моји редови".',
        'Ticket pending reminder notification (locked)' => 'Обавештење - подсетник тикета на чекању (закључано)',
        'Ticket pending reminder notification (unlocked)' => 'Обавештење - подсетник тикета на чекању (откључано)',
        'Ticket escalation notification' => 'Обавештење о ескалацији тикета',
        'Ticket escalation warning notification' => 'Обавештење о упозорењу на ескалацију тикета',
        'Ticket service update notification' => 'Обавештење о ажурирању услуге тикета',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            'Добићете обавештење ако се сервис тикета промени у један од ваших "Моји сервиси".',
        'Appointment reminder notification' => 'Обавештење подсетника о термину',
        'You will receive a notification each time a reminder time is reached for one of your appointments.' =>
            'Добићете обавештење сваки пут кадa дође до времена подсетника за неки од ваших термина.',
        'Ticket email delivery failure notification' => 'Обавештење о неуспелом слању имејла тикета',

        # JS File: Core.AJAX
        'Error during AJAX communication. Status: %s, Error: %s' => 'Грешка приликом AJAX комуникације. Статус: %s, грешка %s',
        'This window must be called from compose window.' => 'Овај прозор мора бити позван од стране прозора за писање.',

        # JS File: Core.Agent.Admin.ACL
        'Add all' => 'Додај све',
        'An item with this name is already present.' => 'Већ је присутна тавка под овим именом.',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Ова ставка и даље садржи подставке. Да ли сте сигурни да желите да уклоните ову ставку укључујући и њене подставке?',

        # JS File: Core.Agent.Admin.AppointmentCalendar.Manage
        'More' => 'Више',
        'Less' => 'Мање',
        'Press Ctrl+C (Cmd+C) to copy to clipboard' => 'Притисните Ctrl+C (Cmd+C) за копирање',

        # JS File: Core.Agent.Admin.Attachment
        'Delete this Attachment' => 'Обриши овај прилог',
        'Deleting attachment...' => 'Брисање прилога...',
        'There was an error deleting the attachment. Please check the logs for more information.' =>
            'Грешка приликом брисања прилога. Молимо проверите лог датотеку за више информација.',
        'Attachment was deleted successfully.' => 'Прилог је успешно обрисан.',

        # JS File: Core.Agent.Admin.DynamicField
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Да ли стварно желите да обришете ово динамичко поље? Сви повезани подаци ће бити ИЗГУБЉЕНИ!',
        'Delete field' => 'Обриши поље',
        'Deleting the field and its data. This may take a while...' => 'Брисање поља и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.Admin.GenericAgent
        'Remove this dynamic field' => 'Уклони ово динамичко поље',
        'Remove selection' => 'Уклони избор',
        'Do you really want to delete this generic agent job?' => 'Да ли стварно желите да обришете овај посао генеричког оператера?',
        'Delete this Event Trigger' => 'Obriši ovaj okidač događaja',
        'Duplicate event.' => 'Направи дупликат догађаја.',
        'This event is already attached to the job, Please use a different one.' =>
            'Овај догађај је приложен послу. Молимо користите неки други.',

        # JS File: Core.Agent.Admin.GenericInterfaceDebugger
        'An error occurred during communication.' => 'Дошло је до грешке приликом комуникације.',
        'Request Details' => 'Детаљи захтева',
        'Request Details for Communication ID' => 'Детаљи захтева за ID комуникације',
        'Show or hide the content.' => 'Покажи или сакриј садржај.',
        'Clear debug log' => 'Очисти отклањање грешака у логу',

        # JS File: Core.Agent.Admin.GenericInterfaceErrorHandling
        'Delete error handling module' => 'Обриши модул за обраду грешке',

        # JS File: Core.Agent.Admin.GenericInterfaceInvoker
        'It is not possible to add a new event trigger because the event is not set.' =>
            'Није могуће додати нови окидач догађаја зато што догађај још увек није дефинисан.',
        'Delete this Invoker' => 'Обриши овог позиваоца',

        # JS File: Core.Agent.Admin.GenericInterfaceInvokerEvent
        'Sorry, the only existing condition can\'t be removed.' => 'Жао нам је, последњи услов не може бити уклоњен.',
        'Sorry, the only existing field can\'t be removed.' => 'Жао нам је, последње поље не може бити уклоњено.',
        'Delete conditions' => 'Обриши услове',

        # JS File: Core.Agent.Admin.GenericInterfaceMapping
        'Mapping for Key %s' => 'Мапирање за кључ %s',
        'Mapping for Key' => 'Мапирање за кључ',
        'Delete this Key Mapping' => 'Обриши мапирање за овај кључ',

        # JS File: Core.Agent.Admin.GenericInterfaceOperation
        'Delete this Operation' => 'Обриши ову операцију',

        # JS File: Core.Agent.Admin.GenericInterfaceWebservice
        'Clone web service' => 'Клонирај веб сервис',
        'Delete operation' => 'Обриши операцију',
        'Delete invoker' => 'Обриши позиваоца',

        # JS File: Core.Agent.Admin.Group
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'УПОЗОРЕЊЕ: Ако промените назив групе \'admin\' пре адекватног подешавања у системској конфигурацији, изгубићете приступ административном панелу! Уколико се то деси, вратите назив групи у admin помоћу SQL команде.',

        # JS File: Core.Agent.Admin.MailAccount
        'Delete this Mail Account' => 'Обриши овај имејл налог',
        'Deleting the mail account and its data. This may take a while...' =>
            'Брисање имејл налога и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.Admin.NotificationEvent
        'Do you really want to delete this notification language?' => 'Да ли стварно желите да избришете овај језик за обавештења?',
        'Do you really want to delete this notification?' => 'Да ли стварно желите да обришете ово обавештење?',

        # JS File: Core.Agent.Admin.PGP
        'Do you really want to delete this key?' => 'Да ли заиста желите да обришете овај кључ?',

        # JS File: Core.Agent.Admin.PackageManager
        'There is a package upgrade process running, click here to see status information about the upgrade progress.' =>
            'Ажурирање пакета је у току, кликните овде за статус напредовања.',
        'A package upgrade was recently finished. Click here to see the results.' =>
            'Ажурирање пакета је завршено. Кликните овде за резултате.',
        'No response from get package upgrade result.' => 'Без одговора од команде за унапређење пакета.',
        'Update all packages' => 'Ажурирај све пакете',
        'Dismiss' => 'Поништи',
        'Update All Packages' => 'Ажурирај све пакете',
        'No response from package upgrade all.' => 'Без одговора од команде за унапређење свих пакета.',
        'Currently not possible' => 'Тренутно није могуће',
        'This is currently disabled because of an ongoing package upgrade.' =>
            'Ова функција је тренутно искључена због ажурирања пакета у току.',
        'This option is currently disabled because the OTRS Daemon is not running.' =>
            'Ова функција је тренутно искључена зато што OTRS сервис не ради.',
        'Are you sure you want to update all installed packages?' => 'Да ли сте сигурни да желите да унапредите све инсталиране пакете?',
        'No response from get package upgrade run status.' => 'Без одговора од команде за статус унапређења пакета.',

        # JS File: Core.Agent.Admin.PostMasterFilter
        'Delete this PostMasterFilter' => 'Обриши овај PostMaster филтер',
        'Deleting the postmaster filter and its data. This may take a while...' =>
            'Брисање PostMaster филтера и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.Admin.ProcessManagement.Canvas
        'Remove Entity from canvas' => 'Уклони објекат са површине',
        'No TransitionActions assigned.' => 'Нема додељених транзиционих активности.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Још увек нема додељених дијалога. Само изаберите један дијалог активности из листе са леве стране и превуците га овде.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Ова активност се не може брисати, зато што је то почетак активности.',
        'Remove the Transition from this Process' => 'Уклони транзицију из овог процеса',

        # JS File: Core.Agent.Admin.ProcessManagement
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Уколико користите ово дугме или везу, напустићете екран и његов тренутни садржај ће бити аутоматски сачуван. Желите ли да наставите?',
        'Delete Entity' => 'Избриши објекат',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Ова активност је већ коришћена у процесу. Не можете је додавати два пута.',
        'Error during AJAX communication' => 'Грешка приликом AJAX комуникације',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Неповезана транзиција је већ постављена на површину. Молимо повежите прву транзицију пре него што поставите другу транзицију.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Ова транзиција је већ коришћена за ову активност. Не можете је користити два пута.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ова транзициона тктивност је већ коришћена у овој путањи. Не можете је користити два пута.',
        'Hide EntityIDs' => 'Сакриј EntityIDs',
        'Edit Field Details' => 'Уреди детаље поља',
        'Customer interface does not support articles not visible for customers.' =>
            'Клијентски интерфејс не подржава чланке који нису видљиви клијентима.',
        'Sorry, the only existing parameter can\'t be removed.' => 'Жао нам је, последњи параметар не може бити уклоњен.',

        # JS File: Core.Agent.Admin.SMIME
        'Do you really want to delete this certificate?' => 'Да ли стварно желите да обришете овај сертификат?',

        # JS File: Core.Agent.Admin.SupportDataCollector
        'Sending Update...' => 'Слање ажурирања...',
        'Support Data information was successfully sent.' => 'Информације подржаних података су успешно послате.',
        'Was not possible to send Support Data information.' => 'Није могуће послати информације подржаних података.',
        'Update Result' => 'Резултат ажурирања',
        'Generating...' => 'Генерисање...',
        'It was not possible to generate the Support Bundle.' => 'Није могуће генерисати Пакет подршке.',
        'Generate Result' => 'Генериши резултат',
        'Support Bundle' => 'Пакет подршке',
        'The mail could not be sent' => 'Имејл се не може послати',

        # JS File: Core.Agent.Admin.SysConfig.Entity
        'It is not possible to set this entry to invalid. All affected configuration settings have to be changed beforehand.' =>
            'Није могуће обележити ову ставку као неважећу. Сва зависна подешавања у конфигурацији морају бити прво измењена.',
        'Cannot proceed' => 'Није могуће наставити',
        'Update manually' => 'Ажурирај ручно',
        'You can either have the affected settings updated automatically to reflect the changes you just made or do it on your own by pressing \'update manually\'.' =>
            'Можете или ажурирати сва зависна подешавања аутоматски на промене које сте направили или да то одрадите ручно кликом на \'Aжурирај ручно\'.',
        'Save and update automatically' => 'Сачувај и ажурирај аутоматски',
        'Don\'t save, update manually' => 'Одустани и ажурирај ручно',
        'The item you\'re currently viewing is part of a not-yet-deployed configuration setting, which makes it impossible to edit it in its current state. Please wait until the setting has been deployed. If you\'re unsure what to do next, please contact your system administrator.' =>
            'Ставка коју тренутно гледате је део нераспоређене конфигурације, и није могуће уредити је у тренутном стању. Молимо сачекајте док подешавање не буде распоређено. Уколико нисте сигурни како да наставите, молимо контактирајте вашег администратора.',

        # JS File: Core.Agent.Admin.SystemConfiguration
        'Loading...' => 'Учитавање...',
        'Search the System Configuration' => 'Претрага системске конфигурације',
        'Please enter at least one search word to find anything.' => 'Молимо унесите барем једну кључну реч да би сте нешто пронашли.',
        'Unfortunately deploying is currently not possible, maybe because another agent is already deploying. Please try again later.' =>
            'Нажалост, распоређивање тренутно није могуће, вероватно зато што други корисник већ распоређује. Молимо покушајте касније.',
        'Deploy' => 'Распореди',
        'The deployment is already running.' => 'Распоређивање је већ у току.',
        'Deployment successful. You\'re being redirected...' => 'Распоређивање успешно, бићете преусмерени...',
        'There was an error. Please save all settings you are editing and check the logs for more information.' =>
            'Догодила се грешка. Молимо сачувајте сва подешавања која уређујете и проверите лог датотеку за више информација.',
        'Reset option is required!' => 'Поништавање је обавезно!',
        'By restoring this deployment all settings will be reverted to the value they had at the time of the deployment. Do you really want to continue?' =>
            'Обнављањем овог распореда сва подешавања ће бити враћена на вредност коју су имала у време распореда. Да ли стварно желите да наставите?',
        'Keys with values can\'t be renamed. Please remove this key/value pair instead and re-add it afterwards.' =>
            'Кључеви са вредностима не могу бити промењени. Молимо уклоните овај пар кључ/вредност и додајте га поново.',
        'Unlock setting.' => 'Откључај подешавање.',

        # JS File: Core.Agent.Admin.SystemMaintenance
        'Do you really want to delete this scheduled system maintenance?' =>
            'Да ли стварно желите да обришете ово планирано оржавање система?',

        # JS File: Core.Agent.Admin.Template
        'Delete this Template' => 'Обриши овај шаблон',
        'Deleting the template and its data. This may take a while...' =>
            'Брисање шаблона и конфигурације. Ово може мало потрајати...',

        # JS File: Core.Agent.AppointmentCalendar
        'Jump' => 'Скочи',
        'Timeline Month' => 'Месечна оса',
        'Timeline Week' => 'Седмична оса',
        'Timeline Day' => 'Дневна оса',
        'Previous' => 'Назад',
        'Resources' => 'Ресурси',
        'Su' => 'не',
        'Mo' => 'по',
        'Tu' => 'ут',
        'We' => 'ср',
        'Th' => 'че',
        'Fr' => 'пе',
        'Sa' => 'су',
        'This is a repeating appointment' => 'Овај термин се понавља',
        'Would you like to edit just this occurrence or all occurrences?' =>
            'Да ли желите да измени само ово или сва понављања?',
        'All occurrences' => 'Сва понављања',
        'Just this occurrence' => 'Само ово понављање',
        'Too many active calendars' => 'Превише активних календара',
        'Please either turn some off first or increase the limit in configuration.' =>
            'Или прво искључите приказ неког календара или повећајте лимит у конфигурацији.',
        'Restore default settings' => 'Вратите подразумевана подешавања',
        'Are you sure you want to delete this appointment? This operation cannot be undone.' =>
            'Да ли сте сигурни да желите да избришете овај термин? Ову операцију није могуће опозвати.',

        # JS File: Core.Agent.CustomerSearch
        'First select a customer user, then select a customer ID to assign to this ticket.' =>
            'Прво одаберите клијент корисника, онда можете одабрати ID клијента за доделу овом тикету.',
        'Duplicated entry' => 'Двоструки унос',
        'It is going to be deleted from the field, please try again.' => 'Биће обрисано из поља, молимо покушајте поново.',

        # JS File: Core.Agent.CustomerUserAddressBook
        'Please enter at least one search value or * to find anything.' =>
            'Молимо унесите барем једну вредност претраге или * да би сте нешто пронашли.',

        # JS File: Core.Agent.Daemon
        'Information about the OTRS Daemon' => 'Информације о OTRS системском сервису',

        # JS File: Core.Agent.Dashboard
        'Please check the fields marked as red for valid inputs.' => 'Молимо проверите поља означена црвеним за важеће уносе.',
        'month' => 'месец',
        'Remove active filters for this widget.' => 'Уклони активне филтере за овај додатак.',

        # JS File: Core.Agent.LinkObject.SearchForm
        'Please wait...' => 'Молимо сачекајте...',
        'Searching for linkable objects. This may take a while...' => 'Претрага објеката за повезивање. Ово може мало потрајати...',

        # JS File: Core.Agent.LinkObject
        'Do you really want to delete this link?' => 'Да ли заиста желите да обришете ову везу?',

        # JS File: Core.Agent.Login
        'Are you using a browser plugin like AdBlock or AdBlockPlus? This can cause several issues and we highly recommend you to add an exception for this domain.' =>
            'Да ли користите додатак за претраживач као што су AdBlock или AdBlockPlus? Ово може резултирати у неколико проблема и топло препоручујемо да додате изузетак за ову страну.',
        'Do not show this warning again.' => 'Не приказуј поново ово упозорење.',

        # JS File: Core.Agent.Preferences
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            'Извините али не можете искључити све методе за обавештења означена као обавезна.',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            'Извините али не можете искључити све методе за ово обавештење.',
        'Please note that at least one of the settings you have changed requires a page reload. Click here to reload the current screen.' =>
            'Напомињемо да најмање једно подешавање које сте изменили захтева поновно учитавање странице. Кликните овде за поновно учитавање екрана.',
        'An unknown error occurred. Please contact the administrator.' =>
            'Догодила се непозната грешка. Молимо контактирајте администратора.',

        # JS File: Core.Agent.Responsive
        'Switch to desktop mode' => 'Пређи на десктоп мод',

        # JS File: Core.Agent.Search
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Молимо да уклоните следеће речи из ваше претраге јер се не могу тражити:',

        # JS File: Core.Agent.SharedSecretGenerator
        'Generate' => 'Генериши',

        # JS File: Core.Agent.SortedTree
        'This element has children elements and can currently not be removed.' =>
            'Овај елемент има децу и тренутно не може бити уклоњен.',

        # JS File: Core.Agent.Statistics
        'Do you really want to delete this statistic?' => 'Да ли стварно желите да обришете ову статистику?',

        # JS File: Core.Agent.TicketAction
        'Select a customer ID to assign to this ticket' => 'Одаберите ID клијента за доделу овом тикету',
        'Do you really want to continue?' => 'Да ли стварно желите да наставите?',

        # JS File: Core.Agent.TicketBulk
        ' ...and %s more' => '...и још %s',
        ' ...show less' => '...прикажи мање',

        # JS File: Core.Agent.TicketFormDraft
        'Add new draft' => 'Додај нови нацрт',
        'Delete draft' => 'Обриши нацрт',
        'There are no more drafts available.' => 'Тренутно нема више нацрта.',
        'It was not possible to delete this draft.' => 'Није било могуће обрисати овај нацрт.',

        # JS File: Core.Agent.TicketZoom
        'Article filter' => 'Филтер за чланке',
        'Apply' => 'Примени',
        'Event Type Filter' => 'Филтер типа догађаја',

        # JS File: Core.Agent
        'Slide the navigation bar' => 'Померите навигациону траку',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Молимо да искључите мод компатибилности у Интернет експлореру!',
        'Find out more' => 'Сазнај више',

        # JS File: Core.App.Responsive
        'Switch to mobile mode' => 'Пређи на мобилни мод',

        # JS File: Core.App
        'Error: Browser Check failed!' => 'Грешка: провера претраживача није успела!',
        'Reload page' => 'Освежи страницу',
        'Reload page (%ss)' => 'Освежи страницу (%sс)',

        # JS File: Core.Debug
        'Namespace %s could not be initialized, because %s could not be found.' =>
            'Скрипт %s није било могуће иницијализовати, јер %s није пронађен.',

        # JS File: Core.Exception
        'An error occurred! Please check the browser error log for more details!' =>
            'Догодила се грешка! Молимо проверите лог претраживача за више информација!',

        # JS File: Core.Form.Validate
        'One or more errors occurred!' => 'Дошло је до једне или више грешака!',

        # JS File: Core.Installer
        'Mail check successful.' => 'Успешна провера имејл подешавања.',
        'Error in the mail settings. Please correct and try again.' => 'Грешка у подешавању имејла. Молимо исправите и покушајте поново.',

        # JS File: Core.SystemConfiguration
        'Open this node in a new window' => 'Отвори ову ставку у новом прозору',
        'Please add values for all keys before saving the setting.' => 'Молимо унесите вредности за све кључеве пре него што сачувате подешавање.',
        'The key must not be empty.' => 'Кључ не сме бити празан.',
        'A key with this name (\'%s\') already exists.' => 'Кључ са овим називом (\'%s\') већ постоји.',
        'Do you really want to revert this setting to its historical value?' =>
            'Да ли стварно желите да поништите ово подешавање на његову претходну вредност?',

        # JS File: Core.UI.Datepicker
        'Open date selection' => 'Отвори избор датума',
        'Invalid date (need a future date)!' => 'Неисправан датум (неопходан датум у будућности)!',
        'Invalid date (need a past date)!' => 'Неисправан датум (неопходан датум у прошлости)!',

        # JS File: Core.UI.InputFields
        'Not available' => 'Није доступно',
        'and %s more...' => 'и %s више...',
        'Show current selection' => 'Прикажи тренутни избор',
        'Current selection' => 'Тренутни избор',
        'Clear all' => 'Очисти све',
        'Filters' => 'Филтери',
        'Clear search' => 'Очисти претрагу',

        # JS File: Core.UI.Popup
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Ако напустите ову страницу, сви отворени прозори ће бити затворени!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Приказ овог екрана је већ отворен. Желите ли да га затворите и учитате овај уместо њега?',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Није могуће отворити искачући прозор. Молимо да искључите блокаду искачућих прозора за ову апликацију.',

        # JS File: Core.UI.Table.Sort
        'Ascending sort applied, ' => 'Растуће сортирање,',
        'Descending sort applied, ' => 'Опадајуће сортирање,',
        'No sort applied, ' => 'Без сортирања,',
        'sorting is disabled' => 'сортирање је искључено',
        'activate to apply an ascending sort' => 'сортирај растуће',
        'activate to apply a descending sort' => 'сортирај опадајуће',
        'activate to remove the sort' => 'искључи сортирање',

        # JS File: Core.UI.Table
        'Remove the filter' => 'Уклони филтер',

        # JS File: Core.UI.TreeSelection
        'There are currently no elements available to select from.' => 'Тренутно нема слободних елемената за одабир.',

        # JS File: Core.UI
        'Please only select one file for upload.' => 'Молимо да изаберете само једну датотеку за отпремање.',
        'Sorry, you can only upload one file here.' => 'Жао нам је, овде можете отпремити само једну датотеку.',
        'Sorry, you can only upload %s files.' => 'Жао намо је, можете отпремити само %s датотеке(а).',
        'Please only select at most %s files for upload.' => 'Молимо да изаберете највише %s датотеке(а) за отпремање.',
        'The following files are not allowed to be uploaded: %s' => 'Није дозвољено отпремање следећих датотека: %s',
        'The following files exceed the maximum allowed size per file of %s and were not uploaded: %s' =>
            'Следеће датотеке премашују највећу дозвољену величину од %s и нису биле отпремљене: %s',
        'The following files were already uploaded and have not been uploaded again: %s' =>
            'Следеће датотеке су већ биле отпремљене и нису додате поново: %s',
        'No space left for the following files: %s' => 'За следеће датотеке нема више места: %s',
        'Available space %s of %s.' => 'Расположив простор %s од %s.',
        'Upload information' => 'Информације о отпремању',
        'An unknown error occurred when deleting the attachment. Please try again. If the error persists, please contact your system administrator.' =>
            'Догодила се непозната грешка приликом брисања прилога. Молимо покушајте поново. Ако се грешка поново, молимо контактирајте вашег администратора.',

        # JS File: Core.Language.UnitTest
        'yes' => 'да',
        'no' => 'не',
        'This is %s' => 'Ово је %s',
        'Complex %s with %s arguments' => 'Комплексан %s са %s аргумената',

        # JS File: OTRSLineChart
        'No Data Available.' => 'Нема информација.',

        # JS File: OTRSMultiBarChart
        'Grouped' => 'Груписано',
        'Stacked' => 'Наслагано',

        # JS File: OTRSStackedAreaChart
        'Stream' => 'Проток',
        'Expanded' => 'Проширено',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '
Поштовани,

На жалост не можемо пронаћи важећи број тикета
у вашем предмету, па овај имејл не може бити обрађен.

Молимо Вас да преко клијентског панела креирате нови тикет.

Хвала на вашој помоћи!

Ваша техничка подршка
',
        ' (work units)' => '(радне јединице)',
        ' 2 minutes' => ' 2 минута',
        ' 5 minutes' => ' 5 минута',
        ' 7 minutes' => ' 7 минута',
        '"Slim" skin which tries to save screen space for power users.' =>
            '"Упрошћени" изглед који покушава да уштеди место за напредне кориснике.',
        '%s' => '%s',
        '(UserLogin) Firstname Lastname' => '(Корисничко име) Име Презиме',
        '(UserLogin) Lastname Firstname' => '(Корисничко име) Презиме Име',
        '(UserLogin) Lastname, Firstname' => '(Корисничко име) Презиме, Име',
        '*** out of office until %s (%s d left) ***' => '*** ван канцеларије до %s (преостало %s д) ***',
        '0 - Disabled' => '0 - Искључено',
        '1 - Available' => '1 - Укључено',
        '1 - Enabled' => '1 - Укључено',
        '10 Minutes' => '10 минута',
        '100 (Expert)' => '100 (Експерт)',
        '15 Minutes' => '15 минута',
        '2 - Enabled and required' => '2 - Укључено и обавезно',
        '2 - Enabled and shown by default' => '2 - Укључено и подразумевано приказано',
        '2 - Enabled by default' => '2 - Подразумевано укључено',
        '2 Minutes' => '2 минута',
        '200 (Advanced)' => '200 (Напредни)',
        '30 Minutes' => '30 минута',
        '300 (Beginner)' => '300 (Почетник)',
        '5 Minutes' => '5 минута',
        'A TicketWatcher Module.' => 'Модул надзора тикета.',
        'A Website' => 'Вебсајт',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            'Листа динамичких поља која су споајена у главни тикет током операције спајања. Биће подешена само динамичка поља која су празна у главном тикету.',
        'A picture' => 'Слика',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL модул који дозвољава да надређени тикети буду затворени само ако су већ затворени сви подређени тикети ("State" показује која стања нису доступна за надређени тикет док се не затворе сви подређени тикети).',
        'Access Control Lists (ACL)' => 'Листе за контролу приступа (ACL)',
        'AccountedTime' => 'Обрачунато време',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Активира механизам трептања реда који саржи најстарији тикет.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Активира опцију изгубљене лозинке за оператере, на интерфејсу за њих.',
        'Activates lost password feature for customers.' => 'Активира својство изгубљене лозинке за клијенте.',
        'Activates support for customer and customer user groups.' => 'Активира подршку за клијентске и клијент корисничке групе.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Активира филтер за чланке у проширеном прегледу ради дефинисања који чланци треба да буду приказани.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Активира расположиве теме - шаблоне у систему. Вредност 1 значи активно, 0 значи неактивно.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Активира могућност претраживања архиве тикета у клијентском интерфејсу.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Активира архивски систем ради убрзања рада, тако што ћете неке тикете уклонити ван дневног праћења. Да бисте пронашли ове тикете, маркер архиве мора бити омогућен за претрагу тикета.',
        'Activates time accounting.' => 'Активира мерење времена.',
        'ActivityID' => 'ID активности',
        'Add a note to this ticket' => 'Додај напомену овом тикету',
        'Add an inbound phone call to this ticket' => 'Додај долазни позив овом тикету.',
        'Add an outbound phone call to this ticket' => 'Додај одлазни позив овом тикету.',
        'Added %s time unit(s), for a total of %s time unit(s).' => 'Додато %s јединице(а), за укупно %s временске(их) јединице(а).',
        'Added email. %s' => 'Додат имејл. %s',
        'Added follow-up to ticket [%s]. %s' => 'Додат наставак у тикет [%s]. %s',
        'Added link to ticket "%s".' => 'Веза на тикет "%s" је постављена.',
        'Added note (%s).' => 'Додата напомена (%s).',
        'Added phone call from customer.' => 'Додат долазни позив од клијента.',
        'Added phone call to customer.' => 'Додат одлазни позив клијенту.',
        'Added subscription for user "%s".' => 'Претплата за корисника "%s" је укључена.',
        'Added system request (%s).' => 'Додат системски захтев (%s).',
        'Added web request from customer.' => 'Додат веб захтев од клијента.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Додаје текућу годину и месец као суфикс у OTRS лог датотеку. Биће креирана лог датотека за сваки месец.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Додавање имејл адреса клијената, примаоцима у тикету на приказу екрана за отварање тикета у интерфејсу оператера. Имејл адресе клијената неће бити додате, уколико је тип артикла имејл-интерни.',
        'Adds the one time vacation days for the indicated calendar.' => 'Једнократно додаје нерадне дане за изабрани календар.',
        'Adds the one time vacation days.' => 'Једнократно додаје нерадне дане.',
        'Adds the permanent vacation days for the indicated calendar.' =>
            'Трајно додаје нерадне дане за изабрани календар.',
        'Adds the permanent vacation days.' => 'Трајно додаје нерадне дане.',
        'Admin' => 'Админ',
        'Admin Area.' => 'Административни простор.',
        'Admin Notification' => 'Администраторска обавештења',
        'Admin area navigation for the agent interface.' => 'Администраторска навигација за интефејс оператера.',
        'Admin modules overview.' => 'Преглед администраторских модула.',
        'Admin.' => 'Админ.',
        'Administration' => 'Администрација',
        'Agent Customer Search' => 'Претрага клијената за оператере',
        'Agent Customer Search.' => 'Претрага клијената за оператере.',
        'Agent Name' => 'Име оператера',
        'Agent Name + FromSeparator + System Address Display Name' => 'Назив оператера + сепаратор "oд" + системска адреса за приказ',
        'Agent Preferences.' => 'Оператерска подешавања.',
        'Agent Statistics.' => 'Статистике за интерфејс оператера.',
        'Agent User Search' => 'Претрага корисника за оператере',
        'Agent User Search.' => 'Претрага корисника за оператере.',
        'Agent interface article notification module to check PGP.' => 'Модул интерфејса оператера за обавештавања о чланку за проверу PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Модул интерфејса оператера за обавештавања о чланку, провера S/MIME',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Модул интерфејса оператера за приступ CIC претрази преко линије за навигацију. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Модул интерфејса оператера за приступ текстуалној претрази преко линије за навигацију. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Модул интерфејса оператера за приступ профилима претраживања преко линије за навигацију. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Модул интерфејса оператера за проверу долазних порука у детаљном прегледу тикета ако S/MIME-кључ постоји и доступан је.',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Модул интерфејса оператера за приказ броја закључаних тикета. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Модул интерфејса оператера за приказ броја тикета за које је оператер одговоран. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Модул интерфејса оператера за приказ броја тикета у Мојим услугама. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Модул интерфејса оператера за приказ броја праћених тикета. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'AgentTicketZoom widget that displays a table of objects linked to the ticket.' =>
            'Додатак за AgentTicketZoom екран који приказује табелу објеката повезаних са тикетом.',
        'AgentTicketZoom widget that displays customer information for the ticket in the side bar.' =>
            'Додатак за AgentTicketZoom екран који приказује информације о клијенту тикета са десне стране.',
        'AgentTicketZoom widget that displays ticket data in the side bar.' =>
            'Додатак за AgentTicketZoom екран који приказује информације о тикету са десне стране.',
        'Agents ↔ Groups' => 'Оператери ↔ групе',
        'Agents ↔ Roles' => 'Оператери ↔ улоге',
        'All CustomerIDs of a customer user.' => 'Сви клијент ID клијент корисника.',
        'All attachments (OTRS Business Solution™)' => 'Сви прилози (OTRS Business Solution™)',
        'All customer users of a CustomerID' => 'Сви клијенти корисници за CustomerID',
        'All escalated tickets' => 'Сви ескалирани тикети',
        'All new tickets, these tickets have not been worked on yet' => 'Сви нови тикети, на њима још није ништа рађено',
        'All open tickets, these tickets have already been worked on.' =>
            'Сви отворени тикети на којима је већ рађено.',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Сви тикети са подешеним подсетником, а датум подсетника је достигнут',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Дозвољава додавање напомена на екрану затварања тикета интерфејса оператера. Ticket::Frontend::NeedAccountedTime је може преписати.',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Дозвољава додавање напомена на екрану слободног текста тикета интерфејса оператера. Ticket::Frontend::NeedAccountedTime је може преписати.',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Дозвољава додавање напомена на екрану напомене тикета интерфејса оператера. Ticket::Frontend::NeedAccountedTime је може преписати.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Дозвољава додавање напомена на екрану власника тикета интерфејса оператера. Ticket::Frontend::NeedAccountedTime је може преписати.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Дозвољава додавање напомена на екрану тикета на чекању интерфејса оператера. Ticket::Frontend::NeedAccountedTime је може преписати.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Дозвољава додавање напомена на екрану приоритета детаљног приказа тикета интерфејса оператера. Ticket::Frontend::NeedAccountedTime је може преписати.',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Дозвољава додавање напомена на екрану одговорног за тикет интерфејса оператера. Ticket::Frontend::NeedAccountedTime је може преписати.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Дозвољава оператерима да замене осе на статистици ако је генеришу.',
        'Allows agents to generate individual-related stats.' => 'Дозвољава оператерима да генеришу индивидуалну статистику.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Дозвољава избор између приказа прилога у претраживачу (непосредно) или само омогућавања његовог преузимања (прилог).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Дозвољава избор следећег стања за клијентске тикете у клијентском интерфејсу.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Дозвољава клијентима да промене приоритет тикета у клијентском интерфејсу.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Дозвољава клијентима да подесе SLA за тикет у клијентском интерфејсу.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Дозвољава клијентима да подесе приоритет тикета у клијентском интерфејсу.',
        'Allows customers to set the ticket queue in the customer interface. If this is not enabled, QueueDefault should be configured.' =>
            'Дозвољава клијентима да подесе ред тикета у корисничком интерфејсу. Ако је искључено, онда треба подесити QueueDefault.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Дозвољава клијентима да подесе услугу за тикет у корисничком интерфејсу.',
        'Allows customers to set the ticket type in the customer interface. If this is not enabled, TicketTypeDefault should be configured.' =>
            'Дозвољава клијентима да подесе тип тикета у интерфејсу корисника. Уколико је искључено, треба конфигурисати TicketTypeDefault.',
        'Allows default services to be selected also for non existing customers.' =>
            'Дозвољава да подразумеване услуге буду изабране и за непостојеће клијенте.',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Дозвољава дефинисање услуге и СЛА за тикете (нпр. имејл, радна површина, мрежа, ...), и ескалационе атрибуте за СЛА (ако је активирана функција услуга/СЛА за тикет).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Омогућава напредне услове претраге тикета у интерфејсу оператера. Са овом опцијом моћете претраживати нпр. наслов тикета са условима као "(*key1*&&*key2*)" или "(*key1*||*key2*)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Омогућава напредне услове претраге тикета у интерфејсу корисника. Са овом опцијом моћете претраживати нпр. наслов тикета са условима као "(*key1*&&*key2*)" или "(*key1*||*key2*)".',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Дозвољава проширене услове претраге у претрази тикета на интерфејсу генеричког оператера. Помоћу ове функције можете вршити претраге нпр. наслов тикета са врстом услова као што су "(*key1*&&*key2*)" или "(*key1*||*key2*)".',
        'Allows generic agent to execute custom command line scripts.' =>
            'Омогућава генеричком оператеру да извршава командне скрипте.',
        'Allows generic agent to execute custom modules.' => 'Омогућава генеричком оператеру да извршава додатне модуле.',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Дозвољава поседовање средњег формата прегледа тикета ( CustomerInfo => 1 - такође приказује информације о клијенту).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Дозвољава поседовање малог формата прегледа тикета ( CustomerInfo => 1  - такође приказује информације о клијенту).',
        'Allows invalid agents to generate individual-related stats.' => 'Дозвољава неважећим оператерима да генеришу индивидуално повезане статистике.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Дозвољава администраторима да приступе као други клијенти, кроз административни панел клијента корисника.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Дозвољава администраторима да приступе као други корисници, кроз административни панел.',
        'Allows to save current work as draft in the close ticket screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану затварања тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the email outbound screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану одлазних имејлова тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket compose screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану за писање одговора тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket forward screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану прослеђивања тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket free text screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану слободног текста тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket move screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану померања тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket note screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану напомена тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket owner screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану власника тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket pending screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану тикета на чекању у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket phone inbound screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану долазних позива тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket phone outbound screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану одлазних позива тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket priority screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану приоритета тикета у интерфејсу оператера.',
        'Allows to save current work as draft in the ticket responsible screen of the agent interface.' =>
            'Дозвољава чување тренутне форме као нацрта у екрану одговорног тикета у интерфејсу оператера.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Дозвољава подешавање статуса новог тикета на приказаном екрану помереног тикета у интерфејсу оператера.',
        'Always show RichText if available' => 'Увек прикажи RichText ако је доступан',
        'Answer' => 'Одговор',
        'Appointment Calendar overview page.' => 'Страница за преглед календара.',
        'Appointment Notifications' => 'Обавештења о термину',
        'Appointment calendar event module that prepares notification entries for appointments.' =>
            'Модул догађаја календара за припрему обавештења о терминима.',
        'Appointment calendar event module that updates the ticket with data from ticket appointment.' =>
            'Модул догађаја календара за освежавање тикета подацима из термина.',
        'Appointment edit screen.' => 'Страница за измену календара.',
        'Appointment list' => 'Листа термина',
        'Appointment list.' => 'Листа термина.',
        'Appointment notifications' => 'Обавештења о термину',
        'Appointments' => 'Термини',
        'Arabic (Saudi Arabia)' => 'Арапски (Саудијска арабија)',
        'ArticleTree' => 'Чланак у облику дрвета',
        'Attachment Name' => 'Назив прилога',
        'Automated line break in text messages after x number of chars.' =>
            'Аутоматски крај реда у текстуалним порукама после х карактера.',
        'Automatically change the state of a ticket with an invalid owner once it is unlocked. Maps from a state type to a new ticket state.' =>
            'Аутоматски промени стање тикета са неважећим власником када се откључа. Мапирајте тип стања на ново стање тикета.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            'Аутоматско закључавање и подешавање власника на актуелног оператера после отварања прозора за премештање тикета у интерфејсу оператера.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Аутоматско закључавање и подешавање власника на актуелног оператера после избора масовне акције.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            'Аутоматски подешава власника тикета као одговорног за њега (ако је фунција одговорног за тикет активирана). Ово фунционише само у ручним акцијама пријавњеног корисника. не важи за аутоматске акције, нпр. генеричког оператера, Postmaster и генеричког интерфејса.',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Аутоматско подешавање одговорног за тикет (ако није до сада подешено) после првог ажурирања.',
        'Avatar' => 'Аватар сличица',
        'Balanced white skin by Felix Niklas (slim version).' => 'Избалансирани бели изглед, Феликс Никлас (танка верзија).',
        'Balanced white skin by Felix Niklas.' => 'Избалансирани бели изглед, Феликс Никлас.',
        'Based on global RichText setting' => 'Базирано на глобалним RichText поставкама',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild" in order to generate a new index.' =>
            'Основно подешавање индекса целог текста. Покрените "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild --rebuild" како би се генерисао нови индекс.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Блокира све долазне емаил-ове који немају исправан број тикета у предмету са Од: @example.com адресе.',
        'Bounced to "%s".' => 'Одбијено на "%s".',
        'Bulgarian' => 'Бугарски',
        'Bulk Action' => 'Масовна акција',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Пример подешавања CMD. Игнорише имејлове када екстерни CMD врати неке излазе на STDOUT (имејл ће бити каналисан у STDIN од some.bin).',
        'CSV Separator' => 'CSV сепаратор',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Време кеширања у секундама за аутентификације оператера у генеричком интерфејсу.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Време кеширања у секундама за аутентификацију клијента у генеричком интерфејсу.',
        'Cache time in seconds for the DB ACL backend.' => 'Време кеширања у секундама за ACL модул базе података.',
        'Cache time in seconds for the DB process backend.' => 'Време кеширања у секундама за процесни модул базе података.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Време кеширања у секундама за „SSL” сертификоване атрибуте.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Време кеширања у секундама за излазни модул навигационе траке процеса тикета.',
        'Cache time in seconds for the web service config backend.' => 'Време кеширања у секундама за веб сервис модул конфигурације.',
        'Calendar manage screen.' => 'Страница за управљање календарима.',
        'Catalan' => 'Каталонски',
        'Change password' => 'Промена лозинке',
        'Change queue!' => 'Промена реда!',
        'Change the customer for this ticket' => 'Промени клијента за овај тикет',
        'Change the free fields for this ticket' => 'Промени слободна поља овог тикета',
        'Change the owner for this ticket' => 'Промени власника овог тикета',
        'Change the priority for this ticket' => 'Промени приоритете за овај тикет.',
        'Change the responsible for this ticket' => 'Промени одговорног за овај тикет',
        'Change your avatar image.' => 'Промените вашу аватар сличицу.',
        'Change your password and more.' => 'Промените лозинку и слично.',
        'Changed SLA to "%s" (%s).' => 'Промењен SLA на "%s" (%s).',
        'Changed archive state to "%s".' => 'Промењено стање архивирања на "%s".',
        'Changed customer to "%s".' => 'Промењен клијент на "%s".',
        'Changed dynamic field %s from "%s" to "%s".' => 'Промењено динамичко поље %s са "%s" на "%s".',
        'Changed owner to "%s" (%s).' => 'Промењен власник на "%s" (%s).',
        'Changed pending time to "%s".' => 'Промењено време чекања на "%s".',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Ажуриран приоритет са "%s" (%s) на "%s" (%s).',
        'Changed queue to "%s" (%s) from "%s" (%s).' => 'Промењен ред на "%s" (%s) са "%s" (%s).',
        'Changed responsible to "%s" (%s).' => 'Промењен одговорни на "%s" (%s).',
        'Changed service to "%s" (%s).' => 'Промењен сервис на "%s" (%s).',
        'Changed state from "%s" to "%s".' => 'Промењено стање са "%s" на "%s".',
        'Changed title from "%s" to "%s".' => 'Промењен наслов са "%s" на "%s".',
        'Changed type from "%s" (%s) to "%s" (%s).' => 'Промењен тип са "%s" (%s) на "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Промени власника тикета за све (корисно за ASP). Обично се показује само агент са дозвлама за читање/писање у реду тикета.',
        'Chat communication channel.' => 'Комуникациони канал ћаскања.',
        'Checkbox' => 'Поље за потврду',
        'Checks for articles that needs to be updated in the article search index.' =>
            'Проверава чланке које треба освежити у индексу претраге.',
        'Checks for communication log entries to be deleted.' => 'Проверава ставке комуникационог лога за брисање.',
        'Checks for queued outgoing emails to be sent.' => 'Проверава заказане имејлове за слање.',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            'Проверава да ли је имејл настављање на постојећи тикет претрагом предмета важећих бројева тикета.',
        'Checks if an email is a follow-up to an existing ticket with external ticket number which can be found by ExternalTicketNumberRecognition filter module.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups. If not enabled, SystemID will be changed after using the system.' =>
            'Проверава SystemID у детекцији броја тикета за настављања. Ако је искључено, SystemID ће бити промењен након коришћења система.',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            'Проверава доступност OTRS Business Solution™ за овај систем.',
        'Checks the entitlement status of OTRS Business Solution™.' => 'Проверава статус права коришћења OTRS Business Solution™.',
        'Child' => 'Child',
        'Chinese (Simplified)' => 'Кинески (упрошћено)',
        'Chinese (Traditional)' => 'Кинески (традиционално)',
        'Choose for which kind of appointment changes you want to receive notifications.' =>
            'Изабери за какве промене термина желиш да примиш обавештења.',
        'Choose for which kind of ticket changes you want to receive notifications. Please note that you can\'t completely disable notifications marked as mandatory.' =>
            'Изаберите за какве промене тикета желите да примате обавештења. Молимо обратите пажњу да не можете у потпуности да искључите обавештења која су означена као обавезна.',
        'Choose which notifications you\'d like to receive.' => 'Изаберите која обавештења желите да примате.',
        'Christmas Eve' => 'Бадње вече',
        'Close' => 'Затвори',
        'Close this ticket' => 'Затвори овај тикет',
        'Closed tickets (customer user)' => 'Затворени тикети (клијент корисник)',
        'Closed tickets (customer)' => 'Затворени тикети (клијент)',
        'Cloud Services' => 'Сервиси у облаку',
        'Cloud service admin module registration for the transport layer.' =>
            'Регистрација админ модула сервиса у облаку за транспортни слој.',
        'Collect support data for asynchronous plug-in modules.' => 'Прикупи податке подршке за асинхдоне прикључне модуле.',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Филтери колона тикета за прегледе тикета типа "мало".',
        'Columns that can be filtered in the escalation view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране у приказу ескалација у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Columns that can be filtered in the locked view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране на приказу закључавања у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Columns that can be filtered in the queue view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране на приказу реда у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Columns that can be filtered in the responsible view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране на приказу одговорности у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Columns that can be filtered in the service view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране на приказу сервиса у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Columns that can be filtered in the status view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране на приказу статуса у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Columns that can be filtered in the ticket search result view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране на приказу резултата претраге у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Columns that can be filtered in the watch view of the agent interface. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            'Колоне које могу бити филтриране на приказу надзора у интерфејсу оператера. Напомена: дозвољени су само тикет атрибути, динамичка поља (DynamicField_NameX) и клијент атрибути (нпр. CustomerUserPhone, CustomerCompanyName).',
        'Comment for new history entries in the customer interface.' => 'Коментар за нове ставке историје у клијентском интерфејсу.',
        'Comment2' => 'Коментар 2',
        'Communication' => 'Комуникација',
        'Communication & Notifications' => 'Комуникација & обавештења',
        'Communication Log GUI' => 'Графички интерфеј комуникационог лога',
        'Communication log limit per page for Communication Log Overview.' =>
            'Ограничење броја логова по страни за преглед комуникационих логова.',
        'CommunicationLog Overview Limit' => 'Ограничење прегледа комуникационих логова',
        'Company Status' => 'Статус фирме',
        'Company Tickets.' => 'Тикети фирми.',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Назив фирме који ће бити укључен у одлазне имејлове као X-Заглавље.',
        'Compat module for AgentZoom to AgentTicketZoom.' => 'Модул компатибилности за AgentZoom у AgentTicketZoom.',
        'Complex' => 'Сложено',
        'Compose' => 'Напиши',
        'Configure Processes.' => 'Конфигуриши процесе.',
        'Configure and manage ACLs.' => 'Конфигуриши и управљај ACL листама.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            'Конфигурише било коју додатну пресликану базу података, коју желите да користите, само за читање.',
        'Configure sending of support data to OTRS Group for improved support.' =>
            'Подешавање слања података за подршку OTRS групи ради унапређења подршке.',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Конфигурише који екран би требало приказати након креирања новог тикета.',
        'Configure your own log text for PGP.' => 'Конфигуриши сопствени лог текст за PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (https://doc.otrs.com/doc/), chapter "Ticket Event Module".' =>
            'Конфигурише подразумевану вредност TicketDynamicField подешавања. "Name" дефинише динамичко поље које би се требало користити, "Value је вредност коју треба подесити и "Event" дефинише модул догађаја. Молимо проверите упутство за програмере (https://doc.otrs.com/doc/), поглавље "Ticket Event Module".',
        'Controls how to display the ticket history entries as readable values.' =>
            'Контролише начин приказа историјских уноса тикета као читљивих вредности. ',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            'Контролише да ли се ИД клијента аутоматски копира из адресе пошиљаоца за непознате кориснике.',
        'Controls if CustomerID is read-only in the agent interface.' => 'Контролише да ли се ID клијента може само прегледати у интерфејсу оператера.',
        'Controls if customers have the ability to sort their tickets.' =>
            'Контролише да ли клијенти имају могућност да сортирају своје тикете.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Контролише да ли више од једног пошиљаоца може бити подешено у новом тикету позива у интерфејсу оператера.',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            'Контролише да ли је администратору дозвољено да увезе сачувану системску конфигурацију у „SysConfig”.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            'Контролише да ли је администратору дозвољено да направи иземене у бази података преко Административног оквира за избор.',
        'Controls if the autocomplete field will be used for the customer ID selection in the AdminCustomerUser interface.' =>
            'Контролише да ли ће бити приказано поље за аутоматско допуњавање ID клијента у интерфејсу AdminCustomerUser.',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Контролише да ли су заставицом обележени тикет и чланак уклоњени када је тикет архивиран.',
        'Converts HTML mails into text messages.' => 'Конвертује HTML поруке у текстуалне поруке.',
        'Create New process ticket.' => 'Креирај нови процес тикет',
        'Create Ticket' => 'Креирај тикет',
        'Create a new calendar appointment linked to this ticket' => 'Креира нови термин у календару повезан са овим тикетом',
        'Create and manage Service Level Agreements (SLAs).' => 'Креира и управља Споразуме о нивоу услуга (СЛА)',
        'Create and manage agents.' => 'Креирање и управљање оператерима.',
        'Create and manage appointment notifications.' => 'Креирање и управљање обавештењима за термине.',
        'Create and manage attachments.' => 'Креирање и управљање прилозима.',
        'Create and manage calendars.' => 'Креирање и управљање календарима.',
        'Create and manage customer users.' => 'Креирање и управљање клијентима корисницима.',
        'Create and manage customers.' => 'Креирање и управљање клијентима.',
        'Create and manage dynamic fields.' => 'Креирање и управљање динамичким пољима.',
        'Create and manage groups.' => 'Креирање и управљање групама.',
        'Create and manage queues.' => 'Креирање и управљање редовима.',
        'Create and manage responses that are automatically sent.' => 'Креирање и управљање аутоматским одговорима.',
        'Create and manage roles.' => 'Креирање и управљање улогама.',
        'Create and manage salutations.' => 'Креирање и управљање поздравима.',
        'Create and manage services.' => 'Креирање и управљање услугама.',
        'Create and manage signatures.' => 'Креирање и управљање потписима.',
        'Create and manage templates.' => 'Креирање и управљање шаблонима.',
        'Create and manage ticket notifications.' => 'Креирање и управљање обавештењима за тикете.',
        'Create and manage ticket priorities.' => 'Креирање и управљање приоритетима тикета.',
        'Create and manage ticket states.' => 'Креирање и управљање статусима тикета.',
        'Create and manage ticket types.' => 'Креирање и управљање типовима тикета.',
        'Create and manage web services.' => 'Креирање и управљање веб сервисима.',
        'Create new Ticket.' => 'Креирање новог тикета.',
        'Create new appointment.' => 'Креира нови термин.',
        'Create new email ticket and send this out (outbound).' => 'Отвори нови имејл тикет и пошаљи (одлазну) поруку.',
        'Create new email ticket.' => 'Креирање новог имејл тикета.',
        'Create new phone ticket (inbound).' => 'Креирај нови тикет (долазног) позива.',
        'Create new phone ticket.' => 'Креирање новог тикета позива.',
        'Create new process ticket.' => 'Креирај нови процес тикет.',
        'Create tickets.' => 'Креирање тикета.',
        'Created ticket [%s] in "%s" with priority "%s" and state "%s".' =>
            'Креиран тикет [%s] у "%s" са приоритетом "%s" и стањем "%s".',
        'Croatian' => 'Хрватски',
        'Custom RSS Feed' => 'Прилагођени RSS извор',
        'Custom RSS feed.' => 'Прилагођени RSS извор.',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            'Прилагођен текст за страницу која се приказује клијентима који још увек немају тикете (ако вам је тај текст потребан на другом језику, додајте га у прилагођен модул за преводе).',
        'Customer Administration' => 'Администрација клијената',
        'Customer Companies' => 'Фирме клијенти',
        'Customer IDs' => 'ID клијента',
        'Customer Information Center Search.' => 'Претрага клијентског информативног центра.',
        'Customer Information Center search.' => 'Претрага клијентског информативног центра.',
        'Customer Information Center.' => 'Клијентски информативни центар.',
        'Customer Ticket Print Module.' => 'Модул за штампу тикета у интерфејсу клијента.',
        'Customer User Administration' => 'Администрација клијента корисника',
        'Customer User Information' => 'Информације о клијент кориснику',
        'Customer User Information Center Search.' => 'Претрага клијент корисничког информативног центра.',
        'Customer User Information Center search.' => 'Претрага клијент корисничког информативног центра.',
        'Customer User Information Center.' => 'Клијент-кориснички информативни центар.',
        'Customer Users ↔ Customers' => 'Клијент корисници ↔ клијенти',
        'Customer Users ↔ Groups' => 'Клијенти корисници ↔ Групе',
        'Customer Users ↔ Services' => 'Клијент корисници ↔ сервиси',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Клијент иконица која показује затворене тикете овог клијента као инфо блок. Подешавање CustomerUserLogin на 1 претражује тикете на основу корисничког назива уместо CustomerID.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Клијент иконица која показује отворене тикете овог клијента као инфо блок. Подешавање CustomerUserLogin на 1 претражује тикете на основу корисничког назива уместо CustomerID.',
        'Customer preferences.' => 'Клијентске поставке.',
        'Customer ticket overview' => 'Клијентски преглед тикета',
        'Customer ticket search.' => 'Клијентска претрага тикета.',
        'Customer ticket zoom' => 'Клијентски детаљни преглед тикета',
        'Customer user search' => 'Претрага клијената корисника',
        'CustomerID search' => 'Претрага ID клијената',
        'CustomerName' => 'Назив клијента',
        'CustomerUser' => 'Клијент корисник',
        'Customers ↔ Groups' => 'Клијенти ↔ групе',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            'Подесиве зауставне речи за индекс комплетног текста. Ове речи ће бити уклоњене из индекса претраге.',
        'Czech' => 'Чешки',
        'Danish' => 'Дански',
        'Dashboard overview.' => 'Преглед командне табле.',
        'Data used to export the search result in CSV format.' => 'Подаци употребљени за ивоз резултата претраживања у CSV формату.',
        'Date / Time' => 'Датум / Време',
        'Default (Slim)' => 'Подразумевано (упрошћено)',
        'Default ACL values for ticket actions.' => 'Подразумеване ACL вредности за акције тикета.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Подразумевани префикси објекта за управљање процесом за ИЂеве објекта који су аутоматски генерисани.',
        'Default agent name' => 'Подразумевано име оператера',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Подразумевани подаци за коришћење на атрибутима за приказ претраге тикета. Пример: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Подразумевани подаци за коришћење на атрибутима за приказ претраге тикета. Пример: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Подразумевани тип приказа за имена примаоца (To,Cc) на детаљном приказу тикета у интерфејсу оператара и клијента.',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            'Подразумевани тип приказа за имена (Од) пошиљаоца на детаљном приказу тикета у интерфејсу оператера и клијента.',
        'Default loop protection module.' => 'Подразумевани модул заштите од петље.',
        'Default queue ID used by the system in the agent interface.' => 'Подразумевани ID реда који користи систем у интерфејсу оператера.',
        'Default skin for the agent interface (slim version).' => 'Подразумевани изглед окружења за интерфејс оператера (слаба верзија).',
        'Default skin for the agent interface.' => 'Подразумевани изглед окружења за интерфејс оператера.',
        'Default skin for the customer interface.' => 'Подразумевани изглед окружења за интерфејс клијента.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Подразумевани ID тикета који користи систем у интерфејсу оператера.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Подразумевани ID тикета који користи систем у клијентском интерфејсу.',
        'Default value for NameX' => 'Подразумевана вредност за NameX',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            'Дефинише акције на којима је омогућен приказ дугмета за подешавање у апликативном додатку линкованих објеката (LinkObject::ViewMode = "complex"). Напомињемо да ове акције морају имати регистроване следеће JS и CSS датотеке: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Дефиниши филтер за html излаз да би додали везе иза дефинисаног низа знакова. Елемент Image дозвољава два начина улаза. У једном назив слике (нпр. faq.png). У том случају биће коришћена OTRS путања слике. Други начин је уношење везе до слике.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser setting.' =>
            'Дефинисање мапирања између променљивих података клијента корисника (кључеви) и динамичких поља тикета (вредности). Циљ је да се сачувају подаци клијента корисника у динамичком пољу тикета. Динамичка поља морају бити присутна у систему и треба да буду омогућена за AgentTicketFreeText, тако да могу да буду мануелно подешена/ажурирана од стране оператера. Она не смеју бити омогућена за AgentTicketPhone, AgentTicketEmail и AgentTicketCustomer. Да су била, имала би предност над аутоматски постављеним вредностима. За коришћење овог мапирања треба, такође, да активирате подешавање Ticket::EventModulePost###4100-DynamicFieldFromCustomerUser.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Дефинишe назив динамичког поља за крајње време. Ово поље мора бити мануелно додато систему као тикет: "Датум / Време" и мора бити активиранo у екранима за креирање тикета и/или у било ком другом екрану са тикет акцијама.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Дефинише назив динамичког поља за почетно време. Ово поље мора бити мануелно додато систему као тикет: "Датум / Време" и мора бити активирано у екранима за креирање тикета и/или у било ком другом екрану са тикет акцијама.',
        'Define the max depth of queues.' => 'Дефиниши максималну дубину за редове.',
        'Define the queue comment 2.' => 'Дефинише коментар реда 2.',
        'Define the service comment 2.' => 'Дефинише сервисни коментар 2.',
        'Define the sla comment 2.' => 'Дефинише sla коментар 2.',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            'Дефиниши први дан у недељи за избор датума за наведени календар.',
        'Define the start day of the week for the date picker.' => 'Дефиниши први дан у недељи за избор датума.',
        'Define which avatar default image should be used for the article view if no gravatar is assigned to the mail address. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Одређује која сличица ће бити приказана у прегледу чланака уколико оператер нема одговарајућу повезану са имејл адресом. Погледајте https://gravatar.com/site/implement/images/ за више информација.',
        'Define which avatar default image should be used for the current agent if no gravatar is assigned to the mail address of the agent. Check https://gravatar.com/site/implement/images/ for further information.' =>
            'Одређује која сличица ће бити приказана као подразумевана уколико оператер нема одговарајућу повезану са имејл адресом. Погледајте https://gravatar.com/site/implement/images/ за више информација.',
        'Define which avatar engine should be used for the agent avatar on the header and the sender images in AgentTicketZoom. If \'None\' is selected, initials will be displayed instead. Please note that selecting anything other than \'None\' will transfer the encrypted email address of the particular user to an external service.' =>
            'Дефинише који сервис ће бити коришћен за аватар сличице оператера у заглављу и детаљном приказу тикета. Ако је одабран \'Ни један\', биће приказани иницијали оператера. Молимо обратите пажњу да ће одабиром једне од опција, шифрована имејл адреса корисника бити прослеђена екстерном сервису.',
        'Define which columns are shown in the linked appointment widget (LinkObject::ViewMode = "complex"). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Дефинише које колоне ће бити приказане у додатку линкованих термина (LinkObject::ViewMode = "сложено"). Могућа подешавања: 0 = искључено, 1 = укључено, 2 = подразумевано укључено.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Дефинише које колоне ће бити приказане у додатку повезаних тикета (LinkObject::ViewMode = "сложено"). Напомена: само атрибути тикета и динамичка поља (DynamicField_NameX) су дозвољена за DefaultColumns.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Дефиниши ставку клијента, која генерише LinkedIn икону на крају инфо блока клијента.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Дефинишие ставку клијента, која генерише XING икону на крају инфо блока клијента.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Дефинише ставку која генерише Google иконицу на крају инфо блока клијента.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Дефинише ставку која генерише Google Maps иконицу на крају инфо блока клијента.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Дефинише филтер за html излаз да би сте додали везе иза CVE бројева. Елемент Image дозвољава два начина улаза. У једном назив слике (нпр. faq.png). И том случају биће коришћена OTRS путања слике. Други начин је уношење везе до слике.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Дефинише филтер за html излаз да би сте додали везе иза MSBulletin бројева. Елемент Image дозвољава два начина улаза. У једном назив слике (нпр. faq.png). И том случају биће коришћена OTRS путања слике. Други начин је уношење везе до слике.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Дефинише филтер за html излаз да би сте додали везе иза дефинисаног низа знакова. Елемент Image дозвољава два начина улаза. У једном назив слике (нпр. faq.png). И том случају биће коришћена OTRS путања слике. Други начин је уношење везе до слике.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Дефинише филтер за HTML излаз да би сте додали везе иза bugtraq бројева. Елемент Image дозвољава два начина улаза. У једном назив слике (нпр. faq.png). И том случају биће коришћена OTRS путања слике. Други начин је уношење путање до слике.',
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
            'Дефинише филтер за прикупљање CVE бројева из текста чланка у AgentTicketZoom. Резултати ће бити приказани у прозорчету поред чланка. Подесите URLPreview уколико желите да видите приказ стране приликом преласка курсором преко елемента везе. Ова адреса може бити иста као и за URL, али и другачија. Напомињемо да неке локације одбијају да буду приказане у IFRAME (нпр. Гугл) и зато приказ неће радити.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Дефинише филтер за обраду текста у чланцима, да би се истакле унапред дефинисане кључне речи.',
        'Defines a permission context for customer to group assignment.' =>
            'Дефинише контекст дозвола за доделу клијената групама.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Дефинише регуларни израз који искључује неке адресе из провере синтаксе (ако је „CheckEmailAddresses” постављена на „Да”). Молимо вас унесите регуларни израз у ово поље за имејл адресе, које нису синтаксно исправне, али су неопходне за систем (нпр. „root@localhost”).',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Дефинише регуларни израз који филтрира све имејл адресе које неби требало користити у апликацији.',
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            'Дефинише време спавања у микросекундама између тикета док се обрађују од стране посла.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Дефинише користан модул за учитавање одређених корисничких опција или за приказивање новости.',
        'Defines all the X-headers that should be scanned.' => 'Дефинише сва Х-заглавља која треба скенирати.',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            'Дефинише све језике који су доступни апликацији. Овде унесите имена језика само на енглеском.',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            'Дефинише све језике који су доступни апликацији. Овде унесите имена језика само на матичном језику.',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Дефинише све параметре за RefreshTime објекат у поставкама у интерфејсу клијента.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Дефинише све параметре за ShownTickets објекат у поставкама интерфејсу клијента.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Дефинише све параметре за ову ставку у подешавањима клијента.',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            'Дефинише све параметре за ову ставку у подешавањима клијента. PasswordRegExp омогућава проверу лозинке путем регуларног израза. Дефинишите минимални број карактера путем PasswordMinSize. Дефинишите најмање 2 мала и 2 велика слова тако што ћете подесити одговарајућу опцију на 1. PasswordMin2Characters дефинише да ли лозинка мора да садржи најмање два слова (0 или 1). PasswordNeedDigit контролише потребу за најмање једном цифром (0 или 1).',
        'Defines all the parameters for this notification transport.' => 'Дефинише све параметре за овај транспорт обавештења.',
        'Defines all the possible stats output formats.' => 'Дефинише све могуће излазне формате статистике.',
        'Defines an alternate URL, where the login link refers to.' => 'Дефинише алтернативну URL адресу, на коју указује веза за пријављивање.',
        'Defines an alternate URL, where the logout link refers to.' => 'Одређује алтернативну URL адресу, на коју указује веза за одављивање.',
        'Defines an alternate login URL for the customer panel..' => 'Одређује алтернативну URL адресу пријављивања за клијентски панел.',
        'Defines an alternate logout URL for the customer panel.' => 'Одређује алтернативну URL адресу одјављивања за клијентски панел.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            'Одређује спољашњу везу за базу података клијента (нпр. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' или \'\').',
        'Defines an icon with link to the google map page of the current location in appointment edit screen.' =>
            'Дефинише икону са линком на Google мапу тренутне локације у екрану за измену термина.',
        'Defines an overview module to show the address book view of a customer user list.' =>
            'Дефинише модул прегледа за приказ адресара клијент корисника.',
        'Defines available article actions for Chat articles.' => 'Дефинише омогућене акције за чланке ћаскања.',
        'Defines available article actions for Email articles.' => 'Дефинише омогућене акције за чланке имејлова.',
        'Defines available article actions for Internal articles.' => 'Дефинише омогућене акције за интерне чланке.',
        'Defines available article actions for Phone articles.' => 'Дефинише омогућене акције за чланке позива.',
        'Defines available article actions for invalid articles.' => 'Дефинише омогућене акције за неважеће чланке.',
        'Defines available groups for the admin overview screen.' => 'Дефинише доступне категорије за екран администраторског прегледа.',
        'Defines chat communication channel.' => 'Дефинише комуникациони канал ћаскања.',
        'Defines default headers for outgoing emails.' => 'Дефинише подразумевана заглавља одлазних имејлова.',
        'Defines email communication channel.' => 'Дефинише комуникациони канал имејла.',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Дефинише из ког атрибута тикета оператер може да изабере редослед резултата.',
        'Defines groups for preferences items.' => 'Дефинише категорије за лична подешавања.',
        'Defines how many deployments the system should keep.' => 'Дефинише колико распореда ће систем чувати.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Дефинише како поље Од у имејл порукама (послато из одговора и имејл тикета) треба да изгледа.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Одређује ако претходно сортирање по приоритету треба да се уради у приказу реда.',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            'Одређује да ли претходно сортирање по приоритету треба да се уради у сервисном приказу.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану затварања тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Дефинише да ли је потребно закључати тикет у екрану одлазних имејлова тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the email resend screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Дефинише да ли је потребно закључати тикет у екрану поновног слања имејлова у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану за преусмерење тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану слања одговора тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану прослеђивања тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану слободног текста тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану спајања тикета у детаљном прегледу тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује ако је потребно закључати тикет у екрану напомене тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану власника тикета у детаљном прегледу тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану тикета на чекању у детаљном прегледу тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану долазних позива тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану одлазних позива тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану приоритета тикета у детаљном прегледу тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану одговорног тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Одређује да ли је потребно закључати тикет у екрану промене клијента тикета у интерфејсу оператера (ако тикет још увек није закључан, тикет ће бити закључан и тренутни оператер ће бити аутоматски постављен као власник).',
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Дефинише да ли ће оператерима бити дозвољена пријава на систем уколико немају подешен дељени тајни кључ и тиме не користе двофакторски модул за идентификацију.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            'Дефинише да ли ће клијентима бити дозвољена пријава на систем уколико немају подешен дељени тајни кључ па због тога не користе двофакторски модул за идентификацију.',
        'Defines if the communication between this system and OTRS Group servers that provide cloud services is possible. If set to \'Disable cloud services\', some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            'Дефинише да ли је могућа комуникација између овог система и сервера OTRS групе који обезбеђују сервисе у облаку. Ако је подешено на \'Онемогући сервисе у облаку\' неке функционалности неће радити, а то су регистрација система, слање података подршке, унапређење на OTRS Business Solution™, OTRS верификација, OTRS новости и новости о производу у додацима на контролној табли, између осталих.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            'Дефинише да ли ће се користити побољшани режим (омогућава коришћење табела, замене, индексирања, експонирања, уметања из Word-a, итд) у интерфејсу клијента.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Određuje da li treba da se koristi poboljšani režim (omogućava korišćenje tabele, zamene, indeksiranja, eksponiranja, umetanja iz Word-a, itd.).',
        'Defines if the first article should be displayed as expanded, that is visible for the related customer. If nothing defined, latest article will be expanded.' =>
            'Дефинише да ли ће први чланак видљив за клијента бити приказан као проширен. Ако ништа није дефинисано, последњи чланак ће бити проширен.',
        'Defines if the message in the email outbound screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану одлазног имејла тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the message in the email resend screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану поновног слања имејла тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the message in the ticket compose screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану слања одговора тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the message in the ticket forward screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану прослеђивања тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the close ticket screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану затварања тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the ticket bulk screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану масовне акције тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the ticket free text screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану слободног текста тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the ticket note screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану напомене тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the ticket owner screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану власника тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the ticket pending screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану тикета на чекању у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the ticket priority screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану приоритета тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the note in the ticket responsible screen of the agent interface is visible for the customer by default.' =>
            'Дефинише да ли је порука у екрану одговорног тикета у интерфејсу оператера подразумевано видљива за клијента.',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            'Одређује да ли за аутентификацију треба да буде прихваћен токен који је раније био важећи. Ово је мало мање безбедно али кориснику даје 30 секунди више времена да унесе своју једнократну лозинку.',
        'Defines if the values for filters should be retrieved from all available tickets. If enabled, only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            'Дефинише да ли ће вредности филтера бити прибављене од свих доступних тикета. Уколико је укључено, само вредности које се иначе користе у било ком тикету ће бити доступне као филтер. Напомињемо да ће листа корисника увек бити приказана на овај начин.',
        'Defines if time accounting is mandatory in the agent interface. If enabled, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            'Дефинише да ли је обрачун времена обавезан у интерфејсу оператера. Ако је укључено, за све акције на тикетима се мора унети напомена (без обзира да ли је сама напомена конфигурисана као активна или је иначе обавезна на екрану индивидуалне акције на тикету).',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Одређује да ли обрачун времена мора бити подешен на свим тикетима у масовним акцијама.',
        'Defines internal communication channel.' => 'Дефинише интерни комуникациони канал.',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            'Дефинише шаблон поруке ван канцеларије. Два параметра знаковних низова (%s) су расположива: датум завршетка и број преосталих дана.',
        'Defines phone communication channel.' => 'Дефинише комуникациони канал телефона.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Дефинише редове које користе тикети за приказивање у виду календарских догађаја.',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            'Дефинише HTTP хост за слање података подршке преко јавног модуле \'PublicSupportDataCollector\' (нпр. од стране OTRS системског сервиса).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Дефинише регуларни израз за IP адресу за приступ локалном спремишту. Потребно је да им омогућите приступ вашем локалном спремишту и паковању: :RepositoryList се захтева на удаљеном host-у',
        'Defines the PostMaster header to be used on the filter for keeping the current state of the ticket.' =>
            'Дефинише које „PostMaster” заглавље ће бити коришћено у филтеру за чување тренутног стања тикета.',
        'Defines the URL CSS path.' => 'Дефинише URL CSS путању.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Дефинише URL основну путању за иконе, CSS и Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Дефинише URL путању до слика за навигационе иконе.',
        'Defines the URL java script path.' => 'Дефинише URL путању java скриптова.',
        'Defines the URL rich text editor path.' => 'Дефинише URL Reach Text Editor путању.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Дефинише адресе наменског „DNS” сервера, уколико је потребно, за „CheckMXRecord” претраге.',
        'Defines the agent preferences key where the shared secret key is stored.' =>
            'Одређује кључ оператерских подешавања где се смешта дељени тајни кључ.',
        'Defines the available steps in time selections. Select "Minute" to be able to select all minutes of one hour from 1-59. Select "30 Minutes" to only make full and half hours available.' =>
            'Дефинише доступне кораке у временској селекцији. Изаберите "минут" за могућност одабира свих минута у једном сату од 1-59. Изаберите "30 минута" за доступност пуног и пола сата.',
        'Defines the body text for notification mails sent to agents, about new password.' =>
            'Дефинише садржај текста обавештења за слање оператерима о новој лозинки.',
        'Defines the body text for notification mails sent to agents, with token about new requested password.' =>
            'Дефинише садржај текста обавештења за слање оператерима са токеном за нову захтевану лозинку.',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Одређује садржај текста за обавештења послата клијентима путем имејлова, о новом налогу.',
        'Defines the body text for notification mails sent to customers, about new password.' =>
            'Одређује садржај текста обавештења за слање клијентима о новој лозинки.',
        'Defines the body text for notification mails sent to customers, with token about new requested password.' =>
            'Дефинише садржај текста обавештења за слање клијентима са токеном за нову захтевану лозинку.',
        'Defines the body text for rejected emails.' => 'Дефинише садржај текста за одбачене поруке.',
        'Defines the calendar width in percent. Default is 95%.' => 'Дефинише ширину календара у процентима. Подразумевано је 95%.',
        'Defines the column to store the keys for the preferences table.' =>
            'Дефинише колону за чување кључева табеле подешавања.',
        'Defines the config options for the autocompletion feature.' => 'Дефинише конфигурационе опције за функцију аутоматског довршавања.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Дефинише конфигурационе параметре за ову ставку, да буду приказани у приказу подешавања.',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Одређује све параметре за ову ставку у екрану подешавања. PasswordRegExp омогућава проверу лозинке путем регуларног израза. Дефинишите минимални број карактера путем PasswordMinSize. Дефинишите најмање 2 мала и 2 велика слова тако што ћете подесити одговарајућу опцију на 1. PasswordMin2Characters дефинише да ли лозинка мора да садржи најмање два слова (0 или 1). PasswordNeedDigit контролише потребу за најмање једном цифром (0 или 1). PasswordMaxLoginFailed дозвољава аутоматско проглашавање статуса оператера као неважећи-привремено, уколико је достигнут максимални број неуспешних логовања. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Defines the config parameters of this item, to be shown in the preferences view. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Дефинише конфигурационе параметре ове ставке за приказ у екрану подешавања. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Defines the connections for http/ftp, via a proxy.' => 'Дефинише конекције за http/ftp преко посредника.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            'Одређује кључ клијентских подешавања где се смешта дељени тајни кључ.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Дефинише форноса датума у формуларе (опционо или поља за унос).',
        'Defines the default CSS used in rich text editors.' => 'Дефинише подразумевани CSS употребљен у RTF уређивању.',
        'Defines the default agent name in the ticket zoom view of the customer interface.' =>
            'Одређује подразумевано име оператера у детаљном приказу тикета у интерфејсу клијента.',
        'Defines the default auto response type of the article for this operation.' =>
            'Дефинише подразумевани тип аутоматског одговора чланка за ову операцију.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Дефинише тело напомене на приказу екрана слободног текста тикета у интерфејсу оператера.',
        'Defines the default filter fields in the customer user address book search (CustomerUser or CustomerCompany). For the CustomerCompany fields a prefix \'CustomerCompany_\' must be added.' =>
            'Дефинише подразумевана филтер поља у претрази адресара клијент корисника (CustomerUser или CustomerCompany). За CustomerCompany поља, морате додати префикс \'CustomerCompany_\'.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at https://doc.otrs.com/doc/.' =>
            'Одређује подразумевану тему главног интерфејса (HTML) која ће бити коришћена од стране оператера или клијената. Уколико желите можете додати вашу личну тему. Молимо вас да погледате упутство за администратора, које се налази на https://doc.otrs.com/doc/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Дефинише подразумевани језик главног корисничког дела. Све могуће вредности су одређене у расположивим језичким датотекама у систему (погледајте следећа подешавања).',
        'Defines the default history type in the customer interface.' => 'Одређује подразумевани тип историје у интерфејсу клијента.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Дефинише подразумевани максимални број атрибута на Х-оси временске скале.',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            'Дефинише подразумевани максимални број резултата статистике по страни на екрану прегледа.',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
            'Дефинише подразумевани следећи статус тикета након клијентовог настављања тикета у интерфејсу клијента.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у приказу екрана затвореног тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у приказу екрана тикета слободног текста у интерфејсу оператера.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у приказу екрана напомене тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у екрану власника тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у екрану тикета на чекању у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у екрану приоритета тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у приказу екрана одговорног тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у приказу екрана за повраћај тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања напомене у приказу екрана за прослеђивање тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после слања поруке, на екрану одлазних имејлова у интерфејсу оператера.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета уколико је састављено / одговорено у приказу екрана за отварање тикета у интерфејсу оператера.',
        'Defines the default next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета у приказу екрана масовних тикета у интерфејсу оператера.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета позива у приказу екрана за долазне позиве у интерфејсу оператера.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета позива у приказу екрана за одлазне позиве у интерфејсу оператера.',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Дефинише подразумевани приоритет тикета клијента за настављање на екрану детаљног приказа тикета у интерфејсу  клијента.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Одређује подразумевани приоритет за нове клијентске тикете у интерфејсу клијента.',
        'Defines the default priority of new tickets.' => 'Одређује подразумевани приоритет за нове тикете.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Одређује подразумевани ред за нове клијентске тикете у интерфејсу клијента.',
        'Defines the default queue for new tickets in the agent interface.' =>
            'Дефинише подразумевани ред за нове тикете у интерфејсу оератера.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Дефинише подразумевани избор из падајућег менија за динамичке објекте (Од: Заједничка спецификација).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Дефинише подразумевани избор из падајућег менија за дозволе (Од: Заједничка спецификација).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Дефинише подразумевани избор из падајућег менија за статус формата (Од: Заједничка спецификација). Молимо вас да убаците кључ формата (види статистика :: Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Дефинише подразумевани тип пошиљаоца за тикете позива на приказу екрана за долазне позиве у интерфејсу оператера.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Дефинише подразумевани тип пошиљаоца за тикете позива на приказу екрана за одлазне позиве у интерфејсу оператера.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Одређује подразумевани тип пошиљаоца за тикете на детаљном приказу екрана тикета у интерфејсу клијента.',
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
            'Дефинише подразумевани приказ претраге атрибута тикета за приказ екрана претраге тикета (Сви тикети/Архивирани тикети/Неархивирани тикети).',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Дефинише подразумевани приказ претраге атрибута тикета за приказ екрана претраге тикета.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Дефинише подразумевани приказ претраге атрибута тикета за приказ екрана претраге тикета. Пример: "Key" мора имати назив динамичког поља, у овом случају \'X\', "Content" мора имати вредност динамичког поља у зависности од типа динамичког поља, Текст: \'a text\', Падајући: \'1\', Датум/Време: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' и/или \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Одређује подразумевани критеријум сортирања за све редове приказане у прегледу реда.',
        'Defines the default sort criteria for all services displayed in the service view.' =>
            'Дефинише подразумевани критеријум сортирања за све сервисе приказане у сервисном прегледу.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Одређује подразумевани редослед сортирања за све редове приказане у приказу реда, након сортирања по приоритету.',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            'Дефинише подразумевани критеријум сортирања за све сервисе у сервисном прегледу, после  сортирања по приориту.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Одређује подразумевани статус тикета новог клијента у интерфејсу клијента.',
        'Defines the default state of new tickets.' => 'Одређује подразумевани статус нових тикета.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Дефинише подразумевани предмет за тикете позива на приказу екрана за долазне позиве у интерфејсу оператера.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Дефинише подразумевани предмет за тикете позива на приказу екрана за одлазне позиве у интерфејсу оператера.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Дефинише подразумевани предмет напомене за приказ екрана тикета слободног текста у интерфејсу оператера.',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            'Дефинише подразумевани број секунди (од садашњег момента) до поновног распореда неуспешног посла у генеричком интерфејсу.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Одређује подразумевани атрибут тикета за сортирање тикета у претрази тикета у интерфејсу клијента.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Дефинише подразумевани атрибут тикета за сортирање тикета у ескалационом прегледу интерфејса оператера.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Дефинише подразумевани атрибут тикета за сортирање тикета у прегледу закључаног тикета интерфејса оператера.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Дефинише подразумевани атрибут тикета за сортирање тикета у одговорном прегледу интерфејса оператера.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Дефинише подразумевани атрибут тикета за сортирање тикета у прегледу статуса интерфејса оператера.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Дефинише подразумевани атрибут тикета за сортирање тикета у посматраном прегледу интерфејса оператера.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Дефинише подразумевани атрибут тикета за сортирање тикета у резултату претраге тикета интерфејса оператера.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Дефинише подразумевани атрибут тикета за сортирање тикета у резултату претраге тикета у овој операцији.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Одређује подразумевану напомену повратног тикета за  клијента/пошиљаоца на приказу екрана за повраћај тикета у интерфејсу оператера.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања позива на приказу екрана за долазне позиве у интерфејсу оператера.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Дефинише подразумевани следећи статус тикета после додавања позива на приказу екрана за одлазне позиве у интерфејсу оператера.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Дефинише подразумевани редослед тикета (после сортирања по приоритету) у ескалационом прегледу у интерфејсу опрератера. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Дефинише подразумевани редослед тикета (после сортирања по приоритету) у прегледу статуса у интерфејсу опрератера. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Дефинише подразумевани редослед тикета (после сортирања по приоритету) у одговорном прегледу у интерфејсу опрератера. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Дефинише подразумевани редослед тикета (после сортирања по приоритету) у прегледу закључаних тикета у интерфејсу опрератера. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Дефинише подразумевани редослед тикета (после сортирања по приоритету) у прегледу претраге тикета у интерфејсу опрератера. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Дефинише подразумевани редослед тикета у прегледу претраге тикета у овој операцији. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Дефинише подразумевани редослед тикета у посматраном прегледу интерфејса оператера. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Одређује подразумевани редослед тикета у прегледу претраге резултата у интерфејсу клијента. Горе: Најстарији на врху. Доле: Најновије на врху.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Одређује подразумевани приоритет тикета на приказу екрана затвореног тикета у интерфејсу оператера.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Одређује подразумевани приоритет тикета на приказу екрана масовних тикета у интерфејсу оператера.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Одређује подразумевани приоритет тикета на приказу екрана тикета слободног текста у интерфејсу оператера.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Одређује подразумевани приоритет тикета на приказу екрана напомене тикета у интерфејсу оператера.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Одређује подразумевани приоритет тикета у екрану власника тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Одређује подразумевани приоритет тикета у екрану тикета на чекању у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Одређује подразумевани приоритет тикета у екрану приоритета тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Одређује подразумевани приоритет тикета на приказу екрана одговорног тикета интерфејса оператера.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Одређује подразумевани тип тикета за тикете новог клијента у интерфејсу клијента.',
        'Defines the default ticket type.' => 'Одређује подразумевани тип тикета.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Дефинише подразумевани употребљени модул корисничког дела, ако акциони параметар није дат у url на инерфејсу оператера.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Одређује подразумевани употребљени модул корисничког дела, ако акциони параметар није дат у url на инерфејсу клијента.**',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Дефинише подрезумевану вредност за акциони параметар за јавни кориснички део. Акциони параметар је коришћен у скриптама система.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Одређује подразумевани тип видљивог пошиљаоца тикета (подразмевано: клијент).',
        'Defines the default visibility of the article to customer for this operation.' =>
            'Дефинише видљивост чланка клијенту за ову операцију.',
        'Defines the displayed style of the From field in notes that are visible for customers. A default agent name can be defined in Ticket::Frontend::CustomerTicketZoom###DefaultAgentName setting.' =>
            'Дефинише подразумеван формат From поља напомена који су видљиви клијентима. Подразумевано име оператера може бити дефинисано у путем Ticket::Frontend::CustomerTicketZoom###DefaultAgentName.',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Дефинише динамичка поља која се користе за приказивање на календару догађаја.',
        'Defines the event object types that will be handled via AdminAppointmentNotificationEvent.' =>
            'Дефинише типове објекта догађаја који ће бити процесирани путем AdminAppointmentNotificationEvent.',
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            'Дефинише резервну путању за „fetchmail” програм. Напомена: назив програма мора бити „fetchmail”, уколико је другачији молимо користите симболичку везу.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Дефинише филтер који обрађује текст у чланцима, да би се истакле URL адресе.',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            'Дефинише формат одговора у приказу екрана за креирање тикета интерфејса оператера ([% Data.OrigFrom | html %]  је Од у оригиналном облику, [% Data.OrigFromName | html %] је само право име из Од).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Дефинише потпуно квалификовано име домена система. Ово подешавање се користи као променљива OTRS_CONFIG_FQDN, која се налази у свим формама порука и користи од стране апликације, за грађење веза до тикета унутар вашег система.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer user for these groups).' =>
            'Дефинише подразумеване групе за клијент кориснике (уколико је CustomerGroupSupport укључен и не желите да управљате групама појединачних клијент корисника).',
        'Defines the groups every customer will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every customer for these groups).' =>
            'Дефинише подразумеване групе за клијенте (уколико је CustomerGroupSupport укључен и не желите да управљате групама појединачних клијената).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Одређује висину за компоненту Rich Text Editor за овај приказ екрана. Унеси број (пиксели) или процентуалну вредност (релативну).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Одређује висину за компоненту Rich Text Editor. Унеси број (пиксели) или процентуалну вредност (релативну).',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за приказ екрана активности затвореног тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за приказ екрана активности имејл тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар за акцију тикета позива, који се користи за историјат тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Дефинише коментар историје за приказ екрана активности тикета слебодног текста, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за приказ екрана активности напомене тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за приказ екрана активности власника тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за приказ екрана активности тикета на чекању, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар за акцију долазних позива тикета, који се користи за историјат тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар за акцију одлазних позива тикета, који се користи за историјат тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за приказ екрана активности приоритетних тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за приказ екрана активности одговорних тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Одређује коментар историје за приказ екрана активности тикета детаљног приказа, који се користи за историју тикета у интерфејсу клијента.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Дефинише коментар историје за ову операцију, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за приказ екрана активности затвореног тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за приказ екрана активности имејл тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип за акцију тикета позива, који се користи за историјат тикета у интерфејсу оператера.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Дефинише тип историје за приказ екрана активности тикета слободног текста, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за приказ екрана активности напомене тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за приказ екрана активности власника тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за приказ екрана активности тикета на чекању, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип за акцију долазних позива тикета, који се користи за историјат тикета у интерфејсу оператера.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип за акцију одлазних позива тикета, који се користи за историјат тикета у интерфејсу оператера.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за приказ екрана активности приоритетног тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за приказ екрана активности одговорног тикета, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Одређује тип историје за приказ екрана активности детаљног приказа тикета, који се користи за историју тикета у интерфејсу клијента.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Дефинише тип историје за ову операцију, који се користи за историју тикета у интерфејсу оператера.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Одређује сате и дане у недељи у назначеном календару, ради рачунања радног времена.',
        'Defines the hours and week days to count the working time.' => 'Одређује сате и дане у недељи у назначеном календару, ради рачунања радног времена.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Дефинише кључ који треба проверити са модулом Kernel::Modules::AgentInfo. Ако је овај кориснички параметар кључа тачан, порука ће бити прихваћена од стране система.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Одређује кључ који треба проверити са CustomerAccept (прихватање корисника). Ако је овај кориснички параметар кључа тачан, порука ће бити прихваћена од стране система.',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Дефинише тип везе \'Normal\'. Ако назив извора и назив циља садрже исте вредности, добијена веза се сматра неусмереном; у супротном се као резултат добија усмерена веза. ',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Дефинише тип везе надређени-подређени. Ако назив извора и назив циља садрже исте вредности, добијена веза се сматра неусмереном; у супротном се као резултат добија усмерена веза. ',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Дефинише тип везе група. Типови везе исте групе поништавају једни друге. Пример: Ако је тикет А везан преко \'Normal\' везе са тикетом Б, онда ови тикети не могу бити додатно везани везом надређени-подређени.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Дефинише листу online спремишта. Још инсталација може да се користи као спремиште, на пример: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" и Content="Some Name".',
        'Defines the list of params that can be passed to ticket search function.' =>
            'Дефинише листу параметара који могу бити прослеђени функцији претраге тикета.',
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
            'Дефинише листу могућих следећих акција на приказу екрана са грешком, комплетна путања је обавезна, након чега је могуће додати спољашње везе ако је потребно.',
        'Defines the list of types for templates.' => 'Дефинише листу типова шаблона.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Дефинише локацију за добијање списка online спремишта за додатне пакете. Први расположиви резултат ће бити коришћен.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Дефинише лог модул за систем. "File" пише све поруке у датој лог датотеци, "SysLog" користи системски лог сервис, нпр. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Дефинише максималну величину (у бајтовима) за слање датотеке преко претраживача. Упозорење: Подешавање ове опције на сувише малу вредност може узроковати да многе маске у вашој OTRS инстанци престану са радом (вероватно свака маска која има улаз од корисника).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Дефинише максимално време важења (у секундама) за ID сесије.',
        'Defines the maximum number of affected tickets per job.' => 'Дефинише максимални број обухваћених тикета по послу.',
        'Defines the maximum number of pages per PDF file.' => 'Дефинише максимални број страна по PDF датотеци.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            'Дефинише максимални број цитираних линија за додавање у одговоре.',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            'Дефинише максимални број послова који ће се извршавати у исто време.',
        'Defines the maximum size (in MB) of the log file.' => 'Дефинише максималну величину лог датотеке (у мегабајтима).',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            'Дефинише максималну величину у килобајтима за одговоре Генеричког интерфејса који се бележе у gi_debugger_entry_content табелу.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Дефинише модул који приказује генеричку напомену у интерфејсу оператера. Биће приказан или "Text" (ако је конфигурисан) или садржај "File".',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Дефинише модул који приказује све тренутно пријављене оператере у интерфејсу оператера.',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            'Дефинише модул који приказује све тренутно пријављене клијенте у интерфејсу оператера.',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            'Дефинише модул који приказује све тренутно пријављене оператере у интерфејсу клијента.',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            'Дефинише модул који приказује све тренутно пријављене клијенте у интерфејсу клијента.',
        'Defines the module to authenticate customers.' => 'Одређује модул за аутентификацију клијената.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            'Дефинише модул за приказивање обавештења ако су сервиси у облаку онемогућени.',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            'Одређује модул за приказ обавештења у разним интерфејсима у различитим приликама за OTRS Business Solution™.',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            'Одређује модул за приказ обавештења у интерфејсу оператера ако OTRS системски сервис не ради.',
        'Defines the module to display a notification in the agent interface if the system configuration is out of sync.' =>
            'Дефинише модул за приказивање обавештења у интерфејсу оператера ако је системска конфигурација несинхронизована.',
        'Defines the module to display a notification in the agent interface, if the agent has not yet selected a time zone.' =>
            'Дефинише модул за приказ обавештења у интерфејсу оператера, ако оператер још није подесио временску зону.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Дефинише модул за приказивање обавештења у интерфејсу оператера ако је оператер пријављен на систем док је опција ван канцеларије активна.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            'Одређује модул за приказ обавештења у интерфејсу оператера, ако је оператер пријављен на систем док је активно одржавање система.',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
            'Одређује модул за приказ обавештења у интерфејсу оператера ако .је достигнут лимит сесија оператера.',
        'Defines the module to display a notification in the agent interface, if the installation of not verified packages is activated (only shown to admins).' =>
            'Дефинише модул за приказивање обавештења у интерфејсу оператера, уколико је инсталација неверификованих пакета укључена (приказ само за администраторе).',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Дефинише модул за приказивање обавештења у интерфејсу оператера ако се систем користи од стране админ корисника (нормално не треба да раде као администратор).',
        'Defines the module to display a notification in the agent interface, if there are invalid sysconfig settings deployed.' =>
            'Дефинише модул за приказ обавештења у интерфејсу оператера, ако су распоређена неважећа подешавања у системској конфигурацији.',
        'Defines the module to display a notification in the agent interface, if there are modified sysconfig settings that are not deployed yet.' =>
            'Дефинише модул за приказ обавештења у интерфејсу оператера, ако постоје промењена али нераспоређена подешавања у системској конфигурацији.',
        'Defines the module to display a notification in the customer interface, if the customer is logged in while having system maintenance active.' =>
            'Дефинише модул за приказ обавештења у интерфејсу клијента, ако је клијент пријављен на систем док је активно одржавање система.',
        'Defines the module to display a notification in the customer interface, if the customer user has not yet selected a time zone.' =>
            'Дефинише модул за приказ обавештења у интерфејсу оператера, ако клијент корисник још није подесио временску зону.',
        'Defines the module to generate code for periodic page reloads.' =>
            'Дефинише модул за генерисање кода за периодично учитавање страница.',
        'Defines the module to send emails. "DoNotSendEmail" doesn\'t send emails at all. Any of the "SMTP" mechanisms use a specified (external) mailserver. "Sendmail" directly uses the sendmail binary of your operating system. "Test" doesn\'t send emails, but writes them to $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ for testing purposes.' =>
            'Дефинише модул за слање имејлова. "DoNotSendEmail" не шаље имејлове уопште. Сваки од SMTP механизама користи специфични (екстерни) мејл сервер.  "Sendmail" директно користи sendmail програм вашег оперативног система. "Test" не шаље имејлове, али их чува у $OTRS_HOME/var/tmp/CacheFileStorable/EmailTest/ у сврху тестирања.',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Дефинише модул који се користи за складиштење података сесије. Са "DB" приступни сервер може бити одвојен од сервера базе података. "FS" је бржи.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Дефинише назив апликације, који се приказује у веб интерфејсу, картицама и насловној траци веб претраживача.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Дефинише назив колоне за складиштење података у табели параметара.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Дефинише назив колоне за складиштење идентификације корисника у табели параметара.',
        'Defines the name of the indicated calendar.' => 'Дефинише назив назначеног календара.',
        'Defines the name of the key for customer sessions.' => 'Одређује назив кључа за клијентске сесије.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Дефинише назив кључа сесије. Нпр. Session, SessionID или OTRS”',
        'Defines the name of the table where the user preferences are stored.' =>
            'Одређује назив табеле где се смештају подешавања корисника.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Дефинише следеће могуће статусе након отварања / одговарања тикета у приказу екрана за отварање тикета интерфејса оператера.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Дефинише следеће могуће статусе након прослеђивања тикета у приказу екрана за прослеђивање тикета интерфејса оператера.',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
            'Дефинише следеће могуће статусе након слања поруке у приказу екрана одлазних имејлова интерфејса оператера.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Одређује следеће могуће статусе за тикете клијената у интерфејсу клијента.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Дефинише следећи статус тикета након додавања напомене у приказу екрана затвореног тикета интерфејса оператера.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Дефинише следећи статус тикета након додавања напомене у приказу екрана тикета слободног текста интерфејса оператера.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Дефинише следећи статус тикета након додавања напомене у приказу екрана напомене тикета интерфејса оператера.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Дефинише следећи статус тикета након додавања напомене у екрану власника тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Дефинише следећи статус тикета након додавања напомене у екрану тикета на чекању у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Дефинише следећи статус тикета након додавања напомене у екрану приоритета тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Дефинише следећи статус тикета након додавања напомене у приказу екрана одговорног тикета у интерфејсу оператера.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Дефинише следећи статус тикета након враћања, у приказу екрана за повраћај тикета интерфејса оператера.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Дефинише следећи статус тикета након што је померен у други ред у приказу екрана помереног тикета интерфејса оператера.',
        'Defines the next state of a ticket, in the ticket bulk screen of the agent interface.' =>
            'Дефинише следећи статус тикета у приказу екрана масовних тикета у интерфејсу оператера.',
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            'Одређује број знакова по линији који се користе у случају замене за преглед HTML чланка у генератору шаблона за обавештења о догађајима.',
        'Defines the number of days to keep the daemon log files.' => 'Одређује колико дана ће се чувати датотеке историјата рада системског сервиса',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            'Одеређује број поља заглавља у приступним модулима за додавање и ажурирање главних имејл филтера. Може их бити до 99.',
        'Defines the number of hours a communication will be stored, whichever its status.' =>
            'Дефинише колико ће дуго у часовима комуникација бити чувана, без обзира на њен статус.',
        'Defines the number of hours a successful communication will be stored.' =>
            'Дефинише колико ће дуго у часовима комуникација бити чувана.',
        'Defines the parameters for the customer preferences table.' => 'Одређује параметре за табелу подешавања клијената.',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Дефинише параметре за додатак командне табле. "Cmd" се користи за командне параметре. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTL" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Дефинише параметре за додатак контролне табле. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTL" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Дефинише параметре за додатак контролне табле. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Дефинише параметре за додатак контролне табле. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTL" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Дефинише параметре за додатак контролне табле. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Дефинише лозинку за приступ SOAP руковању (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Дефинише путању и TTF датотеку подебљаног непропорционалног фонта у курзиву у PDF документима.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Дефинише путању и TTF датотеку подебљаног пропорционалног фонта у курзиву у PDF документима.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Дефинише путању и TTF датотеку подебљаног непропорционалног фонта у PDF документима.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Дефинише путању и TTF датотеку подебљаног пропорционалног фонта у PDF документима.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Дефинише путању и TTF датотеку непропорционалног фонта у курзиву у PDF документима.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Дефинише путању и TTF датотеку пропорционалног фонта у курзиву у PDF документима.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Дефинише путању и TTF датотеку непропорционалног фонта у PDF документима.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Дефинише путању и TTF датотеку пропорционалног фонта у PDF документима.',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            'Дефинише путању приказаног инфо фајла који је лоциран под Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.',
        'Defines the path to PGP binary.' => 'Одређује путању до PGP апликације.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Одређује путању до „open ssl” програма. Може бити потребно HOME Env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the period of time (in minutes) before agent is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Дефинише временски период (у минутима) после ког ће оператер бити означен као "одсутан" због неактивности (нпр. у додатку "Пријављени корисници" или за ћаскања).',
        'Defines the period of time (in minutes) before customer is marked as "away" due to inactivity (e.g. in the "Logged-In Users" widget or for the chat).' =>
            'Дефинише временски период (у минутима) после ког ће клијент бити означен као "одсутан" због неактивности (нпр. у додатку "Пријављени корисници" или за ћаскања).',
        'Defines the postmaster default queue.' => 'Дефинише подразумевани ред постмастера.',
        'Defines the priority in which the information is logged and presented.' =>
            'Дефинише приоритет по ком се информације бележе и приказују.',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            'Одређује циљног примаоца тикета позива и пошиљаоца имејл тикета ("Ред" приказује све редове, "Системска адреса" приказује све системске адресе) у интерфејсу оператера.',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            'Одређује циљног примаоца тикета ("Ред" приказује све редове, "Системска адреса" приказује само редове који су додељени системским адресама) у интерфејсу клијента.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Дефинише захтевану дозволу за приказ тикета у ескалационом прегледу интерфејса оператера.',
        'Defines the search limit for the stats.' => 'Дефинише границу претраге за статистике.',
        'Defines the search parameters for the AgentCustomerUserAddressBook screen. With the setting \'CustomerTicketTextField\' the values for the recipient field can be specified.' =>
            'Дефинише појмове претраге за екран адресара клијент корисника. Поље за примаоца моћете подесити путем подешавања \'CustomerTicketTextField\'.',
        'Defines the sender for rejected emails.' => 'Дефинише пошиљаоца одбијених имејл порука.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Одређује сепаратор између правог имена оператера и емаил адресе додељене реду.',
        'Defines the shown columns and the position in the AgentCustomerUserAddressBook result screen.' =>
            'Дефинише приказане колоне и њихов редослед у екрану резултата претраге адресара клијент корисника.',
        'Defines the shown links in the footer area of the customer and public interface of this OTRS system. The value in "Key" is the external URL, the value in "Content" is the shown label.' =>
            'Одређује приказане везе у доњем делу клијентског и јавног интерфејса овог OTRS система. Вредност поља "Key" је екстерна адреса (URL), а вредност поља "Content" је приказан назив.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Одређује стандардне дозволе расположиве за кориснике у апликацији. Уколико је потребно више дозвола, можете их унети овде. Да би биле ефективне, дозволе морају бити непроменљиве. Молимо проверите када додајете било коју од горе наведених дозвола, да "rw" дозвола остане последња.',
        'Defines the standard size of PDF pages.' => 'Дефинише стандардну величину PDF страница.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Дефинише стање тикета уколико добије наставак, а тикет је већ затвоен.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Дефинише стање тикета уколико добије наставак',
        'Defines the state type of the reminder for pending tickets.' => 'Дефинише дип статуса подсетника за тикете на чекању.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Дефинише предмет за имејл поруке обавештења послата оператерима, о новој лозинки.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Дефинише предмет за имејл поруке обавештења послата оператерима, са токеном о новој захтеваној лозинки.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Одређује предмет за имејл поруке обавештења послата клијентима, о новом налогу.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Одређује предмет за имејл поруке обавештења послата клијентима, о новој лозинки.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Одређује предмет за имејл поруке обавештења послата клијентима, са токеном о новој захтеваној лозинки.',
        'Defines the subject for rejected emails.' => 'Дефинише предмет за одбачене поруке.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Дефинише имејл адресу систем администратора. Она ће бити приказана на екранима за грешке у апликацији.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Дефинише идентификатор система. Сваки број тикета и низ знакова „http” сесије садрши овај ИД. Ово осигурава да ће само тикети који припадају вашем систему бити обрађени као операције праћења (корисно када се одвија комуникација између две „OTRS” инстанце).',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Одређује циљни атрибут у вези са екстерном базом података клијента. Нпр. \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Одређује циљни атрибут у вези са екстерном базом података клијента. Нпр. \'target="cdb"\'.',
        'Defines the ticket appointment type backend for ticket dynamic field date time.' =>
            'Дефинише модул термина тикета за динамичко поље датума.',
        'Defines the ticket appointment type backend for ticket escalation time.' =>
            'Дефинише модул термина тикета за време ескалације.',
        'Defines the ticket appointment type backend for ticket pending time.' =>
            'Дефинише модул термина тикета за време чекања.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Дефинише поља тикета која ће бити приказана у календару догађаја. "Кључ" дефинише поље или атрибут тикета, а "Садржај" дефинише приказан назив.',
        'Defines the ticket plugin for calendar appointments.' => 'Дефинише додатни модул тикета за календарске термине.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Дефинише временску зону назначеног календара, која касније може бити додељена одређеном реду.',
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            'Дефинише предвиђено време (у секундама, минимум је 20 секунди) за прикупљање података подршке путем модула јавог интерфејса \'PublicSupportDataCollector\' (нпр. кад се користи путем OTRS системског сервиса).',
        'Defines the two-factor module to authenticate agents.' => 'Одређује двофакторски модул за идентификацију оператера.',
        'Defines the two-factor module to authenticate customers.' => 'Одређује двофакторски модул за идентификацију клијената.',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Дефинише тип протокола коришћеног од стране веб сервера, за потребе апликације. Ако се користи https протокол уместо plain http, мора бити овде назначено. Пошто ово нема утицаја на подешавања или понашање веб сервера, неће променити начин приступа апликацији и, ако је то погрешно, неће вас спречити да се пријавите у апликацију. Ово подешавање се користи само као променљива, OTRS_CONFIG_HttpType која се налази у свим облицима порука коришћених од стране апликације, да изграде везе са тикетима у вашем систему.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Дефинише коришћене карактере за plaintext имејл наводе у приказу екрана отвореног тикета интерфејса оператера. Уколико је ово празно или неактивно, оригинални имејлови неће бити наведени, него додати одговору.',
        'Defines the user identifier for the customer panel.' => 'Одређује идентификатор клијента за клијентски панел.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Дефинише корисничко име за приступ SOAP руковању (bin/cgi-bin/rpc.pl).',
        'Defines the users avatar. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Дефинише корисникову аватар сличицу. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Defines the valid state types for a ticket. If a ticket is in a state which have any state type from this setting, this ticket will be considered as open, otherwise as closed.' =>
            'Дефинише исправне типове стања тикета. Ако је тикет у стању који садржи било који тип стања из овог подешавања, овај тикет ће се сматрати отвореним, у супротном као затворен.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            'Одређује важеће статусе за откључане тикете. За откључавање тикета може се користити скрипт "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout".',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
            'Дефинише',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Одређује ширину за компоненту rich text editor за овај приказ екрана. Унеси број (пиксели) или процентуалну вредност (релативну).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Одређује ширину за компоненту rich text editor. Унеси број (пиксели) или процентуалну вредност (релативну).',
        'Defines time in minutes since last modification for drafts of specified type before they are considered expired.' =>
            'Дефинише време у минутима од последње промене одређеног типа нацрта пре него што се сматрају застарелим.',
        'Defines whether to index archived tickets for fulltext searches.' =>
            'Дефинише да ли ће архивирани тикети бити индексирани за текстуалну претрагу.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Дефинише који типови пошиљаоца артикла треба да буду показани у приказу тикета.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Дефинише које су ставке слободне за \'Action\' у трећем нивоу ACL структуре.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Дефинише које су ставке слободне у првом нивоу ACL структуре.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Дефинише које су ставке слободне у другом нивоу ACL структуре',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Дефинише који статуси треба да буду аутоматски подешени (Садржај), након достизања времена чекања статуса (Кључ).',
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            'Дефинише, који тикети од којих типова статуса тикета не треба да буду приказани у листи повезаних тикета.',
        'Delete expired cache from core modules.' => 'Брисање истеклог кеша из основних модула.',
        'Delete expired loader cache weekly (Sunday mornings).' => 'Брише истекли кеш учитавања седмично (недељом ујутро).',
        'Delete expired sessions.' => 'Брише истекле сесије',
        'Delete expired ticket draft entries.' => 'Брише застареле нацрте тикета.',
        'Delete expired upload cache hourly.' => 'Брише застареле отпремљене датотеке сваког сата.',
        'Delete this ticket' => 'Обришите овај тикет',
        'Deleted link to ticket "%s".' => 'Веза на тикет "%s" је обрисана.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Брише сесију уколико је ID сесије коришћен преко неважеће удаљене IP адресе.',
        'Deletes requested sessions if they have timed out.' => 'Брише захтевану сесију ако је истекло време.',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            'Омогућава прибављање додатних информација о грешкама у интерфејсу, у случају проблема са AJAX методом.',
        'Deploy and manage OTRS Business Solution™.' => 'Примени и управљај OTRS Business Solution™.',
        'Detached' => 'Одвојено',
        'Determines if a button to delete a link should be displayed next to each link in each zoom mask.' =>
            'Одређује да ли се приказује дугме за брисање поред сваке везе у детаљном прегледу тикета.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Одређује да ли листа могућих редова за премештање у тикет треба да буде приказана у падајућој листи или у новом прозору у интерфејсу оператера. Ако је подешен "Нови прозор" можете додавати напомене о премештању у тикет.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Одређује да ли модул статистике може генерисати листе тикета.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Одређује следећи могући статус тикета, након креирања новог имејл тикета у интерфејсу оператера.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Одређује следећи могући статус тикета, након креирања новог тикета позива у интерфејсу оператера.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Одређује следећи могући статус тикета, за тикете процеса у интерфејсу оператера.',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            'Одређује следећи могући статус тикета, за тикете процеса у интерфејсу клијента.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Одређује следећи приказ екрана, након тикета новог клијента у интерфејсу клијента.',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            'Одређује следећи екрана, након наредног екрана детаљног приказа тикета у интерфејсу клијента.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Одређује следећи приказ екрана, након премештања тикета. LastScreenOverview ће вратити последнји преглед екрана (нпр. резултати претраге, преглед редова, контролна табла). TicketZoom ће вратити на увећање тикета.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Одређује могући статус за тикете на чекању који мењају статус након достизања временског лимита.',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Одређује фразу које ће бити приказана као прималац (То:) тикета позива и као пошиљалац (From:) имејл тикета у интерфејсу оператера. За ред као NewQueueSelectionType "<Queue>" приказује називе редова, а за системску адресу "<Realname> <<Email>>" приказује име и имејл примаоца.',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            'Одређује фразу која ће бити приказана као прималац (To:) тикет у интерфејсу клијента. За ред као CustomerPanelSelectionType "<Queue>" приказује имена редова и за системску адресу "<Realname> <<Email>>" приказује име и имејл примаоца.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Одређује начин на који се повезани објекти приказују у сваком детаљном прегледу.',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Одређује које опције ће бити важеће за примаоца (тикет позива) и пошиљаоца (имејл тикет) у интерфејсу оператера.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Одређује који ће редови бити важећи за тикете примаоца у интерфејсу клијента.',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Онемогућава HTTP заглавље "Content-Security-Policy" ради учитавања екстерних скриптова. Онемогућавање овог HTTP заглавља сноси сигурносни ризик! Искључите га само ако знате шта радите!',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            'Онемогућава HTTP заглавље "X-Frame-Options: SAMEORIGIN" ради учитавања OTRS у оквиру IFRAME на другим странама. Онемогућавање овог HTTP заглавља сноси сигурносни ризик! Искључите га само ако знате шта радите!',
        'Disable autocomplete in the login screen.' => '',
        'Disable cloud services' => 'Онемогући сервисе у облаку',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be enabled).' =>
            'Онемогућује слање обавештења подсетника одговорном оператеру тикета (Ticket::Responsible мора бити укључено).',
        'Disables the redirection to the last screen overview / dashboard after a ticket is closed.' =>
            'Онемогућује преусмеравање на последњи екран прегледа / контролну таблу пошто је тикет затворен.',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If not enabled, the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If enabled, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'Онемогућује приступ инсталационом екрану (http://yourhost.example.com/otrs/installer.pl) у сврху заштите система од недозвољеног преузимања. Ако је искључено, систем може бити поново инсталиран и тренутна основна конфигурација ће бити коришћена да унапред попуни питања унутар инсталационог екрана. Уколико није укључено, такође се онемогућују GenericAgent, PackageManager и SQL Box.',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            'Прикажи упозорење и онемогући претрагу ако су употребљене зауставне речи у претрази комплетног текста.',
        'Display communication log entries.' => 'Приказује ставке комуникационих логова.',
        'Display settings to override defaults for Process Tickets.' => 'Прикажи подешавања да би сте заменили подразумевана за тикете процеса.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Приказује обрачунато време за један чланак у детаљном прегледу тикета.',
        'Displays the number of all tickets with the same CustomerID as current ticket in the ticket zoom view.' =>
            'Приказује број свих тикета са истим ID клијента као тренутни тикет у детаљном прегледу тикета.',
        'Down' => 'Доле',
        'Dropdown' => 'Падајући',
        'Dutch' => 'Холандски',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            'Холандске зауставне речи за индекс претраге комплетног текста. Ове речи ће бити уклоњене из индекса претраге.',
        'Dynamic Fields Checkbox Backend GUI' => 'Графички интерфејс динамичког поља за потврду',
        'Dynamic Fields Date Time Backend GUI' => 'Графички интерфејс динамичког поља за датум и време',
        'Dynamic Fields Drop-down Backend GUI' => 'Графички интерфејс падајућег динамичког поља',
        'Dynamic Fields GUI' => 'Графички интерфејс динамичких поља',
        'Dynamic Fields Multiselect Backend GUI' => 'Графички интерфејс динамичког поља са вишеструким избором',
        'Dynamic Fields Overview Limit' => 'Ограничен преглед динамичких поља',
        'Dynamic Fields Text Backend GUI' => 'Графички интерфејс текстуалног динамичког поља',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Динамичка поља коришћена за извоз резултата претраге у CSV формат.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Групе динамичких поља за процесни додатак. Кључ је назив групе, вредност садржи поље које ће бити приказано. Пример: \'Key => My Group\', \'Content: Name_X, NameY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview.' => 'Ограничење динамичких поља по страни за приказ динамичких поља.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Опције динамичких поља приказаних у екрану отварања тикета у интерфејсу клијента. Напомена: уколико желите да прикажете ова поља и у детаљном прегледу тикета, морате их укључити у CustomerTicketZoom###DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface.' =>
            'Опције динамичких поља приказаних у одељку одговора тикета у детаљном прегледу тикета у интерфејсу клијента.',
        'Dynamic fields shown in the email outbound screen of the agent interface.' =>
            'Динамичка поља приказана у екрану одлазних имејлова у интерфејсу оператера.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface.' =>
            'Динамичка поља приказана у додатку процеса у детаљном прегледу тикета у интерфејсу оператера.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface.' =>
            'Динамичка поља приказана са десне стране у детаљном прегледу тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket close screen of the agent interface.' =>
            'Динамичка поља приказана у екрану затварања тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket compose screen of the agent interface.' =>
            'Динамичка поља приказана у екрану писања одговора тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket email screen of the agent interface.' =>
            'Динамичка поља приказана у екрану имејл тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket forward screen of the agent interface.' =>
            'Динамичка поља приказана у екрану прослеђивања тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket free text screen of the agent interface.' =>
            'Динамичка поља приказана у екрану слободног текста тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface.' =>
            'Динамичка поља приказана у прегледу тикета средњег формата у интерфејсу оператера.',
        'Dynamic fields shown in the ticket move screen of the agent interface.' =>
            'Динамичка поља приказана у екрану померања тикета у интерфејсу оператера. ',
        'Dynamic fields shown in the ticket note screen of the agent interface.' =>
            'Динамичка поља приказана у екрану напомене тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket overview screen of the customer interface.' =>
            'Динамичка поља приказана у прегледу тикета у интерфејсу клијента.',
        'Dynamic fields shown in the ticket owner screen of the agent interface.' =>
            'Динамичка поља приказана у екрану власника тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket pending screen of the agent interface.' =>
            'Динамичка поља приказана у екрану тикета на чекању у интерфејсу оператера.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface.' =>
            'Динамичка поља приказана у екрану долазних позива тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface.' =>
            'Динамичка поља приказана у екрану одлазних позива тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket phone screen of the agent interface.' =>
            'Динамичка поља приказана у екрану тикета позива у интерфејсу оператера.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface.' =>
            'Динамичка поља приказана у прегледу тикета формата приказа у интерфејсу оператера.',
        'Dynamic fields shown in the ticket print screen of the agent interface.' =>
            'Динамичка поља приказана у екрану штампе тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket print screen of the customer interface.' =>
            'Динамичка поља приказана у екрану штампе тикета у интерфејсу клијента.',
        'Dynamic fields shown in the ticket priority screen of the agent interface.' =>
            'Динамичка поља приказана у екрану приоритета тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface.' =>
            'Динамичка поља приказана у екрану одговорног тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface.' =>
            'Динамичка поља приказана у екрану резултата претраге тикета у интерфејсу клијента.',
        'Dynamic fields shown in the ticket search screen of the agent interface.' =>
            'Динамичка поља приказана у екрану претраге тикета у интерфејсу оператера.',
        'Dynamic fields shown in the ticket search screen of the customer interface.' =>
            'Динамичка поља приказана у екрану претраге тикета у интерфејсу клијента.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface.' =>
            'Динамичка поља приказана у прегледу тикета малог формата у интерфејсу оператера.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface.' =>
            'Динамичка поља приказана у детаљном прегледу тикета у интерфејсу клијента.',
        'DynamicField' => 'Динамичко поље',
        'DynamicField backend registration.' => 'Регистрација модула динамичких поља.',
        'DynamicField object registration.' => 'Регистарција објекта динамичких поља.',
        'DynamicField_%s' => 'DynamicField_%s',
        'E-Mail Outbound' => 'Одлазни имејл',
        'Edit Customer Companies.' => 'Измена фирми клијента.',
        'Edit Customer Users.' => 'Уреди клијенте кориснике.',
        'Edit appointment' => 'Измена термина',
        'Edit customer company' => 'Измени фирму клијента',
        'Email Addresses' => 'Имејл адресе',
        'Email Outbound' => 'Одлазни имејл',
        'Email Resend' => 'Пошаљи поново имејл',
        'Email communication channel.' => 'Комуникациони канал имејла.',
        'Enable highlighting queues based on ticket age.' => 'Омогући обележавање редова на основу старости тикета.',
        'Enable keep-alive connection header for SOAP responses.' => 'Омогући заглавље за одржање активне конекције за SOAP одговоре.',
        'Enable this if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            'Укључите ову опцију ако верујете у све ваше јавне и приватне PGP кључеве, чак и ако нису потврђени поузданим потписом.',
        'Enabled filters.' => 'Омогућени филтери.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Обезбеђује „PGP” подршку. Када је „PGP” подршка омогућена за потписивање и енкрипровање мејла, строго се препоручује да веб сервер ради као „OTRS” корисник. У супротном, биће проблема са привилегијама приликом приступа „.gnupg” директоријуму.',
        'Enables S/MIME support.' => 'Омогућава „S/MIME” подршку.',
        'Enables customers to create their own accounts.' => 'Омогућава клијентима да креирају сопствене налоге.',
        'Enables fetch S/MIME from CustomerUser backend support.' => 'Омогућава подршку за прибављање „S/MIME” из подршке позадинског система клијента корисника.',
        'Enables file upload in the package manager frontend.' => 'Омогућава слање датотека у управљачу пакетима приступног система.',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            'Активира или деактивира кеширање за шаблоне. УПОЗОРЕЊЕ: НЕМОЈТЕ искључивати кеширање шаблона на системима у раду јер ће то довести до огромног пада перформанси. Ово подешавање треба користити само у циљу налажења и отклањања грешака!',
        'Enables or disables the debug mode over frontend interface.' => 'Укључује или искључује мод тражења грешака преко приступног интерфејса.',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            'Активира или искључује могућност надзора тикета, ради праћења тикета без власника или одговорне особе.',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            'Омогућује логовање перформанси (време извршавања стране). Утиче на перформансе система. Опција Frontend::Module###AdminPerformanceLog мора бити омогућена.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            'Активира минималну величину бројача тикета (ако је изабран "Датум" као генератор броја тикета).',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            'Активира функцију масовне акције на тикетима за оператерски приступни систем на више тикета истовремено.',
        'Enables ticket bulk action feature only for the listed groups.' =>
            'Активира функцију масовне акције на тикетима само за излистане групе.',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            'Активира функцију одговорног за тикет ради евидентирања специфичног тикета',
        'Enables ticket type feature.' => 'Укључује својство типа тикета.',
        'Enables ticket watcher feature only for the listed groups.' => 'Активира функцију надзора тикета само за излистане групе.',
        'English (Canada)' => 'Енглески (Канада)',
        'English (United Kingdom)' => 'Енглески (Уједињено Краљевство)',
        'English (United States)' => 'Енглески (Сједињене Државе)',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            'Енглеске зауставне речи за индекс претраге комплетног текста. Ове речи ће бити уклоњене из индекса претраге.',
        'Enroll process for this ticket' => 'Упиши процес за овај тикет',
        'Enter your shared secret to enable two factor authentication. WARNING: Make sure that you add the shared secret to your generator application and the application works well. Otherwise you will be not able to login anymore without the two factor token.' =>
            'Унесите свој дељени тајни кључ за двофакторски модул за идентификацију. УПОЗОРЕЊЕ: обратите пажњу да морате правилно унети тајни кључ у вашу апликацију за идентификацију и да апликација функционише исправно. У супротном, нећете бити у могућности да се пријавите у систем без двофакторског токена.',
        'Escalated Tickets' => 'Ескалирани тикети',
        'Escalation view' => 'Преглед ескалација',
        'EscalationTime' => 'Време ескалације',
        'Estonian' => 'Естонски',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            'Регистрација модула догађаја. За бољи учинак можете дефинисати догађај окидач (нпр Догађај => КреирањеТикета).',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            'Регистрација модула догађаја. За бољи учинак можете дефинисати догађај окидач (нпр Догађај => КреирањеТикета). Ово је могуће само ако свим динамичким пољима тикета треба исти догађај.',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            'Модул догађаја који извршава ажурирање на индексу тикета ради промене назива реда ако је потребно и ако је стварно употребљена статичка база података.',
        'Event module that updates customer company object name for dynamic fields.' =>
            'Модул догађаја који ажурира назив клијент фирме за динамичка поља.',
        'Event module that updates customer user object name for dynamic fields.' =>
            'Модул догађаја који ажурира назив објекта клијента корисника за динамичка поља.',
        'Event module that updates customer user search profiles if login changes.' =>
            'Модул догaђаја који ажурира профиле претраге клијент корисника ако се промени пријава.',
        'Event module that updates customer user service membership if login changes.' =>
            'Модул догађаја који ажурира сервисно чланство клијента корисника ако се промени пријава.',
        'Event module that updates customer users after an update of the Customer.' =>
            'Модул догађаја који ажурира клијента корисника после ажурирања клијента.',
        'Event module that updates tickets after an update of the Customer User.' =>
            'Модул догађаја који ажурира тикете после ажурирања клијента корисника.',
        'Event module that updates tickets after an update of the Customer.' =>
            'Модул догађаја који ажурира тикете после ажурирања корисника.',
        'Events Ticket Calendar' => 'Календар догађаја тикета',
        'Example package autoload configuration.' => 'Пример аутоматског учитавања пакетне конфигурације.',
        'Execute SQL statements.' => 'Изврши SQL наредбе.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            'Извршава прилагођену команду или модул. Напомена: ако је употребљен модул, функција је неопходна.',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            'Извршава провере за наставак тикета на „In-Reply-To” или „References” заглављима имејла који немају број тикета у предмету.',
        'Executes follow-up checks on OTRS Header \'X-OTRS-Bounce\'.' => 'Извршава провере наставка на „OTRS” заглављу „X-OTRS-Bounce”.',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            'Извршава проверу настављања у садржају прилога за имејлове који немају број тикета у предмету.',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            'Извршава проверу настављања у садржају имејла за поруке које немају број тикета у предмету.',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            'Извршава проверу настављања у сировом извору имејла за имејлове који немају број тикета у предмету.',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            'Извози цело стабло чланака у резултат претраге (може озбиљно да утиче на перформансе система).',
        'External' => 'Екстерно',
        'External Link' => 'Екстерна веза',
        'Fetch emails via fetchmail (using SSL).' => 'Преузима имејлове преко fetchmail програма (путем SSL).',
        'Fetch emails via fetchmail.' => 'Преузима имејлове преко fetchmail програма.',
        'Fetch incoming emails from configured mail accounts.' => 'Преузимање ',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            'Преузима пакете преко proxy сервера. Преиначује опцију "WebUserAgent::Proxy".',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            'Датотека за приказ у модулу Kernel::Modules::AgentInfo, уколико је снимљена под Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Филтер за отклањање грешака у ACL листама. Напомена: атрибути тикета могу бити додати у формату <OTRS_TICKET_Attribute> нпр. <OTRS_TICKET_Priority>.',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            'Филтер за отклањање грешака код транзиција. Напомена: филтери могу бити додати у формату <OTRS_TICKET_Attribute> нпр. <OTRS_TICKET_Priority>.',
        'Filter incoming emails.' => 'Филтрирање долазних порука.',
        'Finnish' => 'Фински',
        'First Christmas Day' => 'Први дан Божића',
        'First Queue' => 'Први ред',
        'First response time' => 'Време првог одговора',
        'FirstLock' => 'FirstLock',
        'FirstResponse' => 'FirstResponse',
        'FirstResponseDiffInMin' => 'FirstResponseDiffInMin',
        'FirstResponseInMin' => 'FirstResponseInMin',
        'Firstname Lastname' => 'Име Презиме',
        'Firstname Lastname (UserLogin)' => 'Име Презиме (Корисничко име)',
        'For these state types the ticket numbers are striked through in the link table.' =>
            'За ове типове стања бројеви тикета ће бити прецртани у табели веза.',
        'Force the storage of the original article text in the article search index, without executing filters or applying stop word lists. This will increase the size of the search index and thus may slow down fulltext searches.' =>
            'Укључује спремање оригиналног текста чланка у индексу претраге, без извршавања филтера или уклањања зауставних речи. Ово ће увећати величину индекса претраге и може успорити текстуалну претрагу.',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            'Намеће шифрирање одлазних имејлова (7bit|8bit|quoted-printable|base64).',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            'Намеће избор различитог стања тикета (од актуелног) после акције закључавања. Дефинише актуелно стање као кључ, а следеће стање после закључавања као садржај.',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Принудно откључава тикете после премештања у други ред.',
        'Forwarded to "%s".' => 'Прослеђено "%s".',
        'Free Fields' => 'Слободна поља',
        'French' => 'Француски',
        'French (Canada)' => 'Француски (Канада)',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            'Француске зауставне речи за индекс претраге комплетног текста. Ове речи ће бити уклоњене из индекса претраге.',
        'Frontend' => 'Интерфејс',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            'Регистрација модула приступа (онемогућује везу AgentTicketService ако се не користи тикет сервис).',
        'Frontend module registration (disable company link if no company feature is used).' =>
            'Регистрација модула приступа (онемогућује везу клијент ако се не користи својство клијената).',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            'Регистрација модула приступа (онемогућите екран процеса тикета ако процес није расположив) за Клијента.',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            'Регистрација модула приступа (онемогућите екран процеса тикета ако процес није расположив).',
        'Frontend module registration (show personal favorites as sub navigation items of \'Admin\').' =>
            'Регистрација модула интерфејса (приказ личних омиљених као поднавигација администраторског менија).',
        'Frontend module registration for the agent interface.' => 'Регистрација модула приступа за интерфејс оператера.',
        'Frontend module registration for the customer interface.' => 'Регистрација модула приступа за интерфејс клијента.',
        'Frontend module registration for the public interface.' => 'Регистрација приступног модула за јавни интерфејс.',
        'Full value' => 'Цела вредност',
        'Fulltext index regex filters to remove parts of the text.' => 'Текст индекс филтери (регуларни изрази) за уклањање делова текста.',
        'Fulltext search' => 'Текст за претрагу',
        'Galician' => 'Галицијски',
        'General ticket data shown in the ticket overviews (fall-back). Note that TicketNumber can not be disabled, because it is necessary.' =>
            'Општи подаци тикета приказани у прегледима тикета (резерва). Напомињемо да TicketNumber не може бити искључен, јер је неопходан.',
        'Generate dashboard statistics.' => 'Генериши статистике контролне табле.',
        'Generic Info module.' => 'Генерички информациони модул',
        'GenericAgent' => 'Генерички оператер',
        'GenericInterface Debugger GUI' => 'Генерички интерфејс - отклањање грешака',
        'GenericInterface ErrorHandling GUI' => 'Генерички интерфејс - отклањање грешака',
        'GenericInterface Invoker Event GUI' => 'Генерички интерфејс - догађаји позиваоца',
        'GenericInterface Invoker GUI' => 'Генерички интерфејс - позивалац',
        'GenericInterface Operation GUI' => 'Генерички интерфејс - операција',
        'GenericInterface TransportHTTPREST GUI' => 'Генерички интерфејс -  HTTP REST транспорт',
        'GenericInterface TransportHTTPSOAP GUI' => 'Генерички интерфејс -  HTTP SOAP транспорт',
        'GenericInterface Web Service GUI' => 'Генерички интерфејс - веб сервис',
        'GenericInterface Web Service History GUI' => 'Генерички интерфејс - историјат веб сервиса',
        'GenericInterface Web Service Mapping GUI' => 'Генерички интерфејс - мапирање веб сервиса',
        'GenericInterface module registration for an error handling module.' =>
            'Регистрација модула генеричког интерфејса за отклањање грешака.',
        'GenericInterface module registration for the invoker layer.' => 'Регистрација модула генеричког интерфејса за слој позиваоца.',
        'GenericInterface module registration for the mapping layer.' => 'Регистрација модула генеричког интерфејса за слој мапирања.',
        'GenericInterface module registration for the operation layer.' =>
            'Регистрација модула генеричког интерфејса за оперативни слој.',
        'GenericInterface module registration for the transport layer.' =>
            'Регистрација модула генеричког интерфејса за транспортни слој.',
        'German' => 'Немачки',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            'Немачке зауставне речи за индекс претрагу комплетног текста. Ове речи ће бити уклоњене из индекса претраге.',
        'Gives customer users group based access to tickets from customer users of the same customer (ticket CustomerID is a CustomerID of the customer user).' =>
            'Дозвољава приступ клијент корисницима тикетима истог клијента на основу група (клијент тикета је исти као клијент корисника).',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Омогућава крајњим корисницима да замене сепаратор за CSV датотеке, дефинисан у датотекама превода. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Global Search Module.' => 'Модул опште претраге',
        'Go to dashboard!' => 'Иди на командну таблу!',
        'Good PGP signature.' => '',
        'Google Authenticator' => 'Гугл аутентификација',
        'Graph: Bar Chart' => 'График: Тракасти графикон',
        'Graph: Line Chart' => 'График: Линијски графикон',
        'Graph: Stacked Area Chart' => 'График: Наслагани просторни графикон',
        'Greek' => 'Грчки',
        'Hebrew' => 'Хебрејски',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). It will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndex --rebuild".' =>
            'Омогућује проширену текстуалну претрагу ваших чланака (претрага по пољима From, To, Cc, Subject и Body). Сви постојећи чланци ће бити реиндексирани, нови додати у индекс претраге по креирању, тиме убрзавајући текстуалну претрагу за око 50%. За креирање почетног индекса користите "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild --rebuild".',
        'High Contrast' => 'Високи контраст',
        'High contrast skin for visually impaired users.' => 'Високо контрастни изглед за особе слабијег вида.',
        'Hindi' => 'Хинди',
        'Hungarian' => 'Мађарски',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Уколико је изабрано „DB” за „Customer::AuthModule”, могуће је подесити драјвер базе података (обично се користи аутоматско препознавање).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Уколико је изабрано „DB” за „Customer::AuthModule”, могуће је подесити лозинку за табелу клиената.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Уколико је изабрано „DB” за „Customer::AuthModule”, могуће је подесити корисничко име за повезивање са табелом клијената.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Уколико је изабрано „DB” за „Customer::AuthModule”, неопходно је подесити „DSN” за конекцију ка табели клијената.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Уколико је изабрано „DB” за „Customer::AuthModule”, неопходно је подесити назив колоне за „CustomerPassword” у табели клијената.',
        'If "DB" was selected for Customer::AuthModule, the encryption type of passwords must be specified.' =>
            'Уколико је одабран "DB" за Customer::AuthModule, неопходно је подесити тип шифровања за лозинке.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Уколико је изабрано „DB” за „Customer::AuthModule”, неопходно је подесити назив колоне за „CustomerKey” у табели корисника.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Уколико је изабрано „DB” за „Customer::AuthModule”, неопходно је подесити назив табеле где ће подаци о клијентима бити чувани.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Уколико је изабрано "DB" за SessionModule, неопходно је подесити назив табеле где ће се чувати подаци сесија.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Уколико је изабрано "FS" за SessionModule, неопходно је подесити назив директоријума где ће се чувати подаци сесија.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            'Уколико је подешен „HTTPBasicAuth” за „Customer::AuthModule”, можете подесити (путем RegExp) уклањање делова „REMOTE_USER” вредности (нпр. ради уклањања додатних домена). Напомена: $1 ће бити нова Пријава.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Уколико је подешен HTTPBasicAuth за Customer::AuthModule, можете подесити уклањање делова корисничких имена (нпр. за домене као example_domain\user у user).',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule” и желите да додате суфикс сваком корисничком имену, дефинишите га овде, нпр. желите само user за корисничко име, али у вашем LDAP директоријуму постоји user@domain.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule” и неопходни су специјални параметри за „Net::LDAP” перл модул, можете их подесити овде. Погледајте „perldoc Net::LDAP” за више информација о параметрима.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule” и ваши корисници имају само анонимни приступ директоријуму, али желите да претражујете податке, можете подесити корисника који има приступ „LDAP” директоријуму. Лозинку за овог корисника можете подесити овде.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule” и ваши корисници имају само анонимни приступ директоријуму, али желите да претражујете податке, можете подесити корисника који има приступ „LDAP” директоријуму. Корисничко име овог корисника можете подесити овде.',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, „BaseDN” мора бити дефинисан.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, адреса „LDAP” сервера мора бити наведена.',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, кориснички идентификатор мора бити наведен.',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, кориснички атрибути морају бити наведени. За „LDAP posixGroups” користите UID, за остале користите комплетан кориснички DN.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, овде можете дефинисати приступне параметре.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, можете дефинисати да ли ће апликација престати са радом уколико нпр. конекција са сервером не може бити остварена због проблема са мрежом.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, можете проверити да ли је кориснику омогућена аутентикација ако припада „posixGroup”, нпр. корисник мора да припада групи xyz да би могао да користи „OTRS”. Дефинишите групу са приступом систему.',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Уколико је подешен „LDAP” за „Customer::AuthModule”, можете додати филтер сваком „LDAP” захтеву, нпр. (mail=*), (objectclass=user) или (!objectclass=computer).',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Уколико је подешен „Radius” за „Customer::AuthModule”, морате дефинисати лозинку за приступ „Radius” серверу.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Уколико је подешен „Radius” за „Customer::AuthModule”, адреса „Radius” сервера мора бити дефинисана.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Уколико је подешен „Radius” за „Customer::AuthModule”, можете дефинисати да ли ће апликација престати са радом уколико нпр. конекција са сервером не може бити остварена због проблема са мрежом.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Уколико је подешен Sendmail за SendmailModule, морате дефинисати локацију апликације sendmail и неопходне опције.',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            'Уколико је подешен SysLog за LogModule, може бити дефинисана посебна лог секција.',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            'Уколико је подешен SysLog за LogModule, може бити дефинисан карактерсет за логовање.',
        'If "bcrypt" was selected for CryptType, use cost specified here for bcrypt hashing. Currently max. supported cost value is 31.' =>
            'Уколико је подешен „bcrypt” за „CryptType”, овде можете дефинисати „cost" параметар за шифровање. Тренутно је највиша подржана вредност 31.',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            'Уколико је подешен File за LogModule, мора бити дефинисана локација лог датотеке. Уколико датотека не постоји, биће креирана од стране система.',
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            'Ако је активно, ни један регуларни израз se не може поклопити са корисниковом имејл адресом да би дозволио регистрацију.',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            'Ако је активно, један регуларни израз se мора поклопити са корисниковом имејл адресом да би дозволио регистрацију.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            'Ако је као модул за слање имејла изабран било који од "SMTP" механизама, а неопходна је аутентификација на имејл сервер, лозинка мора да буде наведена.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Ако је као модул за слање имејла изабран било који од "SMTP" механизама, а неопходна је аутентификација на имејл сервер, корисничко име мора да буде наведено.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Ако је као модул за слање имејла изабран било који од "SMTP" механизама, уређај који  шаље имејлове мора да буде наведен.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Ако је као модул за слање имејла изабран било који од "SMTP" механизама, порт на ком ваш имеј сервер слуша мора да буде наведен.',
        'If enabled debugging information for ACLs is logged.' => 'Ако је активирано, исправљање грешака за ACL се бележи.',
        'If enabled debugging information for transitions is logged.' => 'Ако је активирано, исправљање грешака за транзиције се бележи.',
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            'Ако је активирано, сервис ће преусмерити стандардни ток грешке у лог датотеку.',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            'Ако је активирано, сервис ће преусмерити стандардни излазни ток у лог датотеку.',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            'Уколико је омогућено, системски сервис ће користити овај директоријум за снимање процесних (PID) датотека. Напомена: молимо стопирајте системски сервис пре измене овог подешавања и користите га само у случају кад је <$OTRSHome>/var/run/ недоступан.',
        'If enabled, OTRS will deliver all CSS files in minified form.' =>
            'Уколико је укључено, OTRS ће испоручити све CSS датотеке у смањеној форми.',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Уколико је укључено, OTRS ће испоручити све JavaScript датотеке у смањеној форми.',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Ако је активирано, тикети позива и имејл тикети ће бити отворени у новом прозору.',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            'Ако је активирано, ознака OTRS верзије ће бити уклоњена из веб интерфејса, HTTP заглавља и X-Headers у одлазним имејл порукама. НАПОМЕНА: ако мењате ову опцију, молимо да осигурате брисање кеша.',
        'If enabled, the cache data be held in memory.' => 'Ако је актибирано, кеширани подаци ће се чувати у меморији.',
        'If enabled, the cache data will be stored in cache backend.' => 'Ако је активирано, кеширани подаци ће се чувати у кешу система у позадини.',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            'Ако је активирано, клијент може претраживати тикете у свим сервисима (без обзира на то који сервиси су додељени клијенту).',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Ако је активиринао, различити прегледи (контролна табла, закључавање, редови) ће се аутоматски освежити после задатог времена.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            'Ако је активирано, први ниво главног менија се отвара на прелаз миша (уместо само на клик).',
        'If enabled, users that haven\'t selected a time zone yet will be notified to do so. Note: Notification will not be shown if (1) user has not yet selected a time zone and (2) OTRSTimeZone and UserDefaultTimeZone do match and (3) are not set to UTC.' =>
            'Уколико је укључено, корисници који још нису одабрали временску зону биће обавештени о томе. Напомена: обавештење неће бити приказано уколико (1) корисник још није одабрао временску зону и (2) OTRSTimeZone и UserDefaultTimeZone се подударају и (3) нису постављена на UTC.',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            'Ако SendmailNotificationEnvelopeFrom није наведен, ова поставка омогућава коришћење адересе пошињаоца имејлова  уместо празног оквира заглавља (обавезно у поставкама неких имејл сервера).',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            'Ако је подешено ова адреса се користи као оквир заглавља пошиљаоца у одлазним обавештењима. Ако адреса није унета, оквир заглавља пошиљаоца је празан (осим ако је SendmailNotificationEnvelopeFrom::FallbackToEmailFrom подешен).',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            'Ако је подешено ова адреса се користи као оквир заглавља пошиљаоца у одлазним порукама (не за обавештења - види ниже). Ако адреса није унета, оквир заглавља пошиљаоца је једнак имејл адреси реда.',
        'If this option is enabled, tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is not enabled, no autoresponses will be sent.' =>
            'Уколико је ова опција укључена, тикети креирани преко веб интерфејса од стране клијената или оператера, ће добити аутоматски одговор уколико је подешен. Ако је ова опција искључена, аутоматски одговори неће бити слати.',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Ако се овај израз поклапа, аутоматски одговарач неће послати ниједну поруку.',
        'If this setting is enabled, it is possible to install packages which are not verified by OTRS Group. These packages could threaten your whole system!' =>
            'Уколико је подешавање омогућено, могућа је инсталација пакета који нису верификовани од стране OTRS групе. Ови пакети могу угрозити ваш цео систем!',
        'If this setting is enabled, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            'Уколико је ово подешавање укључено, локалне измене неће бити приказане као грешке у управљачу пакетима и сакупљачу података подршке.',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            'Уколико ћете бити ван канцеларије, можда ћете желети да обавестите друге кориснике постављањем тачних датума вашег изостанка.',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            'Игнорише врсту пошиљаоца чланака (нпр. аутоматски одговори или имејл обавештења) приликом приказа непрочитаних чланака у детаљном прегледу тикета или аутоматског проширивања у великом екрану прегледа.',
        'Import appointments screen.' => 'Екран за увоз термина.',
        'Include tickets of subqueues per default when selecting a queue.' =>
            'Код избора реда, подразумевано укључи и тикете подредова.',
        'Include unknown customers in ticket filter.' => 'Укључите непознате клијенте у филтер тикета.',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Укључује времена креирања тикета у претрагу на оператерском интерфејсу.',
        'Incoming Phone Call.' => 'Долазни позив.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            'Убрзивач индексирања: за одабир TicketViewAccelerator модула. "RuntimeDB" генерише сваки преглед реда у ходу из табеле тикета (нема утицаја на перформансе до око 60.000 тикета укупно и 6.000 отворених тикета у систему). "StaticDB" је најмоћнији модул, користи додатну тикет индекс табелу која ради као преглед (препоручује се за више од 80.000 и 6.000 отворених тикета у систему). Коришћењем команде "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" можете креирати почетни индекс.',
        'Indicates if a bounce e-mail should always be treated as normal follow-up.' =>
            'Одређује да ли ће преусмерени имејл увек бити третиран као обичан наставак.',
        'Indonesian' => 'Индонежански',
        'Inline' => 'Непосредно',
        'Input' => 'Унос',
        'Interface language' => 'Jezik interfejsa',
        'Internal communication channel.' => 'Интерни комуникациони канал.',
        'International Workers\' Day' => 'Међународни празник рада',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Могуће је подесити различите изгледе за различите оператере, који се користе на нивоу домена у апликацији. Коришћењем регуларног израза (regex), можете подесити пар кључ/вредност за препознавање домена. Вредност у Key би требало да препозна домен, а вредност у Content би требало да буде важећи изглед у систему. Молимо консултујте примере за исправан облик регуларног израза.',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            'Могуће је подесити различите изгледе за различите кориснике, који се користе на нивоу домена у апликацији. Коришћењем регуларног израза (regex), можете подесити пар кључ/вредност за препознавање домена. Вредност у Key би требало да препозна домен, а вредност у Content би требало да буде важећи изглед у систему. Молимо консултујте примере за исправан облик регуларног израза.',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            'Могуће је подесити различите теме за различите оператере и кориснике, који се користе на нивоу домена у апликацији. Коришћењем регуларног израза (regex), можете подесити пар кључ/вредност за препознавање домена. Вредност у Key би требало да препозна домен, а вредност у Content би требало да буде важећа тема у систему. Молимо консултујте примере за исправан облик регуларног израза.',
        'It was not possible to check the PGP signature, this may be caused by a missing public key or an unsupported algorithm.' =>
            '',
        'Italian' => 'Италијански',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            'Италијанске зауставне речи за индекс претраге комплетног текста. Ове речи ће бити уклоњене из индекса претраге.',
        'Ivory' => 'Слоновача',
        'Ivory (Slim)' => 'Слоновача (упрошћено)',
        'Japanese' => 'Јапански',
        'JavaScript function for the search frontend.' => 'JavaScript функција за модул претраге.',
        'Korean' => 'Корејски',
        'Language' => 'Језик',
        'Large' => 'Велико',
        'Last Screen Overview' => 'Преглед последњег екрана',
        'Last customer subject' => 'Последњи предмет поруке клијента',
        'Lastname Firstname' => 'Презиме, Име',
        'Lastname Firstname (UserLogin)' => 'Презиме, Име (Корисничко име)',
        'Lastname, Firstname' => 'Презиме, Име',
        'Lastname, Firstname (UserLogin)' => 'Презиме, Име (Корисничко име)',
        'LastnameFirstname' => 'ПрезимеИме',
        'Latvian' => 'Летонски',
        'Left' => 'Лево',
        'Link Object' => 'Повежи објекат',
        'Link Object.' => 'Повежи објекат.',
        'Link agents to groups.' => 'Повежи оператере са гупама.',
        'Link agents to roles.' => 'Повежи оператере са улогама.',
        'Link customer users to customers.' => 'Повежи клијент кориснике са клијентима.',
        'Link customer users to groups.' => 'Повеђу клијент кориснике са групама.',
        'Link customer users to services.' => 'Повежи клијент кориснике са сервисима.',
        'Link customers to groups.' => 'Повежи клијенте са групама.',
        'Link queues to auto responses.' => 'Повежи редове са аутоматским одговорима.',
        'Link roles to groups.' => 'Повежи улоге са групама.',
        'Link templates to attachments.' => 'Повезивање шаблона са прилозима.',
        'Link templates to queues.' => 'Повежи шаблоне са редовима',
        'Link this ticket to other objects' => 'Увежи овај тикет са другим објектом',
        'Links 2 tickets with a "Normal" type link.' => 'Повезује 2 тикета типом везе "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Повезује 2 тикета типом везе "ParentChild".',
        'Links appointments and tickets with a "Normal" type link.' => 'Повезује термине и тикете "Нормалним" врстама веза.',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Листа CSS директоријума увек учитаних за интерфејс оператера.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Листа CSS датотека које се увек учитавају за интерфејс клијента.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Листа JS директоријума увек учитаних за интерфејс оператера.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Листа JS датотека које се увек учитавају за интерфејс клијента.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            'Листа свих догађаја на клијент фирмама за приказ у графичком интерфејсу.',
        'List of all CustomerUser events to be displayed in the GUI.' => 'Листа свих догађаја на клијент корисницима за приказ у графичком интерфејсу.',
        'List of all DynamicField events to be displayed in the GUI.' => 'Листа свих догађаја на динамичким пољима за приказ у графичком интерфејсу.',
        'List of all LinkObject events to be displayed in the GUI.' => 'Листа свих LinkObject догађаја за приказ у графичком интерфејсу.',
        'List of all Package events to be displayed in the GUI.' => 'Листа свих догађаја на пакетима за приказ у графичком интерфејсу.',
        'List of all appointment events to be displayed in the GUI.' => 'Листа свих обавештења о терминима за приказ у графичком интерфејсу.',
        'List of all article events to be displayed in the GUI.' => 'Листа свих догађаја на чланцима за приказ у графичком интерфејсу.',
        'List of all calendar events to be displayed in the GUI.' => 'Листа свих догађаја на календарима која ће бити приказана у графичком интерфејсу.',
        'List of all queue events to be displayed in the GUI.' => 'Листа свих догађаја на редовима за приказ у графичком интерфејсу.',
        'List of all ticket events to be displayed in the GUI.' => 'Листа свих догађаја на тикетима за приказ у графичком интерфејсу.',
        'List of colors in hexadecimal RGB which will be available for selection during calendar creation. Make sure the colors are dark enough so white text can be overlayed on them.' =>
            'Листа боја у хексадецималном RGB запису које ће бити доступне за избор приликом прављења календара. Обратите пажњу да су боје довољно тамне тако да бели текст може бити исписан на њима.',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            'Листа подразумеваних стандардних шаблона који се аутоматски додељију новом Реду након креирања.',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            'Листа прилагодљивих CSS датотека увек учитаних за интерфејс оператера.',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            'Листа прилагодљивих CSS датотека увек учитаних за интерфејс клијента.',
        'List view' => 'Преглед листе',
        'Lithuanian' => 'Литвански',
        'Loader module registration for the agent interface.' => 'Регистрација модула за учитавање за интерфејс оператера.',
        'Loader module registration for the customer interface.' => 'Регистрација модула за учитавање за интерфејс клијента.',
        'Lock / unlock this ticket' => 'Закључај / откључај овај тикет',
        'Locked Tickets' => 'Закључани тикети',
        'Locked Tickets.' => 'Закључани тикети.',
        'Locked ticket.' => 'Закључан тикет.',
        'Logged in users.' => 'Пријављени корисници.',
        'Logged-In Users' => 'Пријављени корисници',
        'Logout of customer panel.' => 'Одјава са клијентског панела.',
        'Look into a ticket!' => 'Погледај садржај тикета!',
        'Loop protection: no auto-response sent to "%s".' => 'Заштита од петље: без аутоматског одговора на "%s".',
        'Macedonian' => 'Македонски',
        'Mail Accounts' => 'Имејл налози',
        'MailQueue configuration settings.' => 'Подешавање заказаних имејлова за слање.',
        'Main menu item registration.' => 'Регистрација ставке главног менија.',
        'Main menu registration.' => 'Регистрација главног менија.',
        'Makes the application block external content loading.' => 'Приморава апликацију да блокира учитавање екстерног садржаја.',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Проверава „MX” запис имејл адресе пре слања поруке или телефонских или имејл тикета.',
        'Makes the application check the syntax of email addresses.' => 'Приморава апликацију да проверава синтаксу имејл адереса.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Одређује да ли сесије користе HTML колачиће. Уколико су колачићи искључени или клијентски претраживач их не подржава, систем ће радити уобичајено и додаваће ID сесије у свим везама.',
        'Malay' => 'Малајски',
        'Manage OTRS Group cloud services.' => 'Управља услугама у облаку OTRS групе.',
        'Manage PGP keys for email encryption.' => 'Управља PGP кључевима за имејл шифровање.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Управљање ПОП3 или ИМАП налозима за преузимање емаил-а од.',
        'Manage S/MIME certificates for email encryption.' => 'Управљај S/MIME сертификатима за имеј енкрипцију.',
        'Manage System Configuration Deployments.' => 'Управљање распоредима системске конфигурације.',
        'Manage different calendars.' => 'Управљање различитим календарима.',
        'Manage existing sessions.' => 'Управљање постојећим сесијама.',
        'Manage support data.' => 'Управљање подацима подршке.',
        'Manage system registration.' => 'Управљање систем регистрацијом.',
        'Manage tasks triggered by event or time based execution.' => 'Управља задацима покренутим од догађаја или на основу временског извршавања.',
        'Mark as Spam!' => 'Означи као Спам!',
        'Mark this ticket as junk!' => 'Означи овај тикет као бесмислен junk!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Максимална дужина (у знацима) клијентске инфо табеле (телефон и имејл) на екрану писања имејла.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            'Максимална величина (у редовима) оквира информисаних оператера у оператерском интерфејсу.',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            'Максимална величина (у редовима) оквира укључених оператера у оператерском интерфејсу.',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            'Максимална величина предмета у имејл одговору и неким екранима прегледа.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Максимум аутоматских имејл одговора дневно на сопствену адресу (Заштита од петље)',
        'Maximal auto email responses to own email-address a day, configurable by email address (Loop-Protection).' =>
            'Максимални број аутоматских имејл одговора дневно на сопствену адресу, подесив по имејл адреси (заштита од петље).',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Максимална величина у килобајтима за имејлове који могу бити преузети преко POP3/POP3S/IMAP/IMAPS (KBytes).',
        'Maximum Number of a calendar shown in a dropdown.' => 'Максимални број календара приказан у листи.',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            'Максимална дужина (у знацима) динамичког поља у чланку на детаљном прегледу тикета.',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            'Максимална дужина (у знацима) динамичког поља у бочној траци на детаљном прегледу тикета.',
        'Maximum number of active calendars in overview screens. Please note that large number of active calendars can have a performance impact on your server by making too much simultaneous calls.' =>
            'Максимални број активних календара у екранима за преглед. Обратите пажњу да велики број активних календара може имати утицај на перформансе вашег сервера прављењем превише симултаних захтева.',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Максимални број тикета који ће бити приказани у резултату претраге у интерфејсу оператера.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Максимални број тикета који ће бити приказани у резултату претраге у интерфејсу клијента.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Максимални број тикета који ће бити приказани у резултату ове операције.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Максимална дужина (у знацима) клијентске инфо табеле на детаљном прегледу тикета.',
        'Medium' => 'Средње',
        'Merge this ticket and all articles into another ticket' => 'Споји овај тикет и све чланке у други тикет',
        'Merged Ticket (%s/%s) to (%s/%s).' => 'Спојен тикет (%s/%s) у (%s/%s)',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'Тикет <OTRS_TICKET> спојен у <OTRS_MERGE_TO_TICKET>.',
        'Minute' => 'Минут',
        'Miscellaneous' => 'Разно',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Модул за избор примаоца (За:) у приказу новог тикета у интерфејсу клијента.',
        'Module to check if a incoming e-mail message is bounce.' => 'Модул за проверу да ли је долазна имејл порука одбијена.',
        'Module to check if arrived emails should be marked as internal (because of original forwarded internal email). IsVisibleForCustomer and SenderType define the values for the arrived email/article.' =>
            'Модул за проверу да ли пристигли имејлови треба да буду означени као интерни (на основу оригиналног прослеђеног интерног имејла). „IsVisibleForCustomer” и „SenderType” дефиниишу вредности за пристигли имејл/чланак.',
        'Module to check the group permissions for customer access to tickets.' =>
            'Модул за проверу групних дозвола за клијентски приступ тикетима.',
        'Module to check the group permissions for the access to tickets.' =>
            'Модул за проверу групних дозвола за приступ тикетима.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Модул за израду потписане поруке (PGP или S/MIME).',
        'Module to define the email security options to use (PGP or S/MIME).' =>
            'Модул за избор имејл безбедности у употреби (PGP или S/MIME).',
        'Module to encrypt composed messages (PGP or S/MIME).' => 'Модул за шифровање порука за слање (PGP or S/MIME).',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            'Модул за извлачење корисничких SMIME сертификата из долазних порука.',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Модул за филтрирање и руковање долазним порукама. Блокирање/игнорисање свих непожељних имејлова са From: noreply@ адресе.',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            'Модул за филтрирање и руковање долазним порукама. Узмите број са 4 цифре за слободни текст тикета, употребите регуларни израз за поклапање, нпр Од: => \'(.+?)@.+?\', и употребите () као [***] у Постави =>.',
        'Module to filter encrypted bodies of incoming messages.' => 'Модул за филтрирање шифрираног садржаја долазних порука.',
        'Module to generate accounted time ticket statistics.' => 'Модул за генерисање статистике обрачунатог времена тикета.',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            'Модул за генерисање HTML OpenSearch профила за кратку претрагу тикета у профилу оператера.',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            'Модул за генерисање HTML OpenSearch профила за кратку претрагу тикета у профилу клијента.',
        'Module to generate ticket solution and response time statistics.' =>
            'Модул за генерисање статистике решавања тикета и времена одговора.',
        'Module to generate ticket statistics.' => 'Модул за генерисање статистике тикета.',
        'Module to grant access if the CustomerID of the customer has necessary group permissions.' =>
            'Модул за доделу приступа уколико ID клијента поседује одговарајуће групне дозволе.',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            'Модул за доделу приступа ако се ID клијента тикета поклапа са ID клијента.',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            'Модул за доделу приступа ако се ID клијента корисника тикета поклапа са ID клијент корисника.',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            'Модул за доделу приступа било ком оператеру ангажованом на тикету у прошлости (базирано на ставкама историјата тикета).',
        'Module to grant access to the agent responsible of a ticket.' =>
            'Модул за доделу приступа тикету за одговорног оператера.',
        'Module to grant access to the creator of a ticket.' => 'Модул за доделу приступа тикету за креатора тикета.',
        'Module to grant access to the owner of a ticket.' => 'Модул за доделу приступа тикету за власника.',
        'Module to grant access to the watcher agents of a ticket.' => 'Модул за доделу приступа тикету за надзорног оператера.',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            'Модул за приказ обавештења и ескалација (ShownMax: највећи приказан број ексалација, EscalationInMinutes: приказ тикета који ће ескалирати, CacheTime: кеш израчунатих ескалација у секундама).',
        'Module to use database filter storage.' => 'Модул за смештај филтера у базу података.',
        'Module used to detect if attachments are present.' => 'Модул за детекцију да ли су присутни прилози.',
        'Multiselect' => 'Вишеструки избор',
        'My Queues' => 'Моји редови',
        'My Services' => 'Моје услуге',
        'My Tickets.' => 'Моји тикети.',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            'Назив наменског реда. Наменски ред је избор редова по вашој жељи и може се изабрати у подешавањима.',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            'Назив наменске услуге. Наменска услуга је избор услуга по вашој жељи и може се изабрати у подешавањима.',
        'NameX' => 'NameX',
        'New Ticket' => 'Нови тикет',
        'New Tickets' => 'Нови тикети',
        'New Window' => 'Нови прозор',
        'New Year\'s Day' => 'Нова година',
        'New Year\'s Eve' => 'Дочек нове године',
        'New process ticket' => 'Нови тикет процеса',
        'News about OTRS releases!' => 'Вести о OTRS издањима!',
        'News about OTRS.' => 'Новости о OTRS.',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Следећи могући статус тикета након додавања позива у екрану долазних позива тикета у интерфејсу оператера.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Следећи могући статус тикета након додавања позива у екрану одлазних позива тикета у интерфејсу оператера.',
        'No public key found.' => '',
        'No valid OpenPGP data found.' => '',
        'None' => 'Ни један',
        'Norwegian' => 'Норвешки',
        'Notification Settings' => 'Подешавања обавештења',
        'Notified about response time escalation.' => 'Обавештење о ескалацији времена одговора.',
        'Notified about solution time escalation.' => 'Обавештење о ескалацији времена решавања.',
        'Notified about update time escalation.' => 'Обавештење о ескалацији времена ажурирања.',
        'Number of displayed tickets' => 'Број приказаних тикета',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Број линија (по тикету) приказаних према услужној претрази у интерфејсу оператера.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Број тикета који ће бити приказани на свакој страни резултата претраге у интерфејсу оператера.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Број тикета који ће бити приказани на свакој страни резултата претраге у интерфејсу клијента.',
        'Number of tickets to be displayed in each page.' => 'Број тикета који ће бити приказани на свакој страни.',
        'OTRS Group Services' => 'Сервиси OTRS групе',
        'OTRS News' => 'OTRS новости',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '„OTRS” може да користи једну или више пресликаних база података за скупе операције као што су претрага текста или генерисање статистика. Овде можете дефинисати DSN за прву пресликану базу података.',
        'OTRS doesn\'t support recurring Appointments without end date or number of iterations. During import process, it might happen that ICS file contains such Appointments. Instead, system creates all Appointments in the past, plus Appointments for the next N months (120 months/10 years by default).' =>
            'OTRS не подржава термине који се понављају без крајњег датума или броја итерација. Приликом увоза календара, може се догодити да ICS датотека садржи такве \'бесконачне\' термине. Уместо таквог понашања, систем ће креирати све термине из прошлости, као и термине за следећи n број месеци (подразумевано 120 месеци/10 година).',
        'Open an external link!' => 'Отвори екстерну везу!',
        'Open tickets (customer user)' => 'Отворени тикети (клијент корисник)',
        'Open tickets (customer)' => 'Отворени тикети (клијент)',
        'Option' => 'Опција',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Опционо ограничење приступа редовима за CreatorCheck модул пермисија. Уколико је подешено, приступ ће бити дозвољен само за тикете у дефинисаним редовима.',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Опционо ограничење приступа редовима за InvolvedCheck модул пермисија. Уколико је подешено, приступ ће бити дозвољен само за тикете у дефинисаним редовима.',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Опционо ограничење приступа редовима за OwnerCheck модул пермисија. Уколико је подешено, приступ ће бити дозвољен само за тикете у дефинисаним редовима.',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            'Опционо ограничење приступа редовима за ResponsibleCheck модул пермисија. Уколико је подешено, приступ ће бити дозвољен само за тикете у дефинисаним редовима.',
        'Other Customers' => 'Други клијенти',
        'Out Of Office' => 'Ван канцеларије',
        'Out Of Office Time' => 'Време ван канцеларије',
        'Out of Office users.' => 'Корисници ван канцеларије.',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Преоптерећује (редефинисано) постојеће фуцкције у Kernel::System::Ticket. Користи се за лако додавање прилагођавања.',
        'Overview Escalated Tickets.' => 'Преглед ескалираних тикета.',
        'Overview Refresh Time' => 'Преглед времена освежавања',
        'Overview of all Tickets per assigned Queue.' => 'Преглед свих тикета по додељеним редовима.',
        'Overview of all appointments.' => 'Преглед свих термина.',
        'Overview of all escalated tickets.' => 'Преглед свих ескалираних тикета.',
        'Overview of all open Tickets.' => 'Преглед свих отворених тикета.',
        'Overview of all open tickets.' => 'Преглед свих отворених тикета.',
        'Overview of customer tickets.' => 'Преглед клијентских тикета.',
        'PGP Key' => 'PGP кључ',
        'PGP Key Management' => 'Управљање PGP кључем',
        'PGP Keys' => 'PGP кључеви',
        'Package event module file a scheduler task for update registration.' =>
            'Датотека пакета модула догађаја за посао планера за ажурирање регистрације.',
        'Parameters for the CreateNextMask object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри за CreateNextMask објекат у приказу подешавања у интерфејсу оператера. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Parameters for the CustomQueue object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри за CustomQueue објекат у приказу подешавања у интерфејсу оператера. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Parameters for the CustomService object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри за CustomService објекат у приказу подешавања у интерфејсу оператера. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Parameters for the RefreshTime object in the preference view of the agent interface. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри за RefreshTime објекат у приказу подешавања у интерфејсу оператера. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Parameters for the column filters of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри за филтер колона у умањеном прегледу тикета. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана. ',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметри за додатак фирме клијента контролне табле у интефејсу оператера. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је подразумевано активиран или да је потребно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеш додатка. ',
        'Parameters for the dashboard backend of the customer id list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметри за додатак листе клијената контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка.',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметри за додатак статуса ID клијента контролне табле у интерфејсу оператера. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је подразумевано активиран или да је потребно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеш додатка.',
        'Parameters for the dashboard backend of the customer user information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметри за додатак информација о клијент корисницима контролне табле у интерфејсу оператера. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка.',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            'Параметри за додатак листе клијент корисника контролне табле у интерфејсу оператера. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је подразумевано активиран или да је потребно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеш додатка.',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе нових тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе нових тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе отворених тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе отворених тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Параметри за додатак листе редова контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "QueuePermissionGroup" није неопходан, ако га дефинишете редови ће бити излистани само ако припадају овој групи дозвола. "States" је листа стања, кључ је редослед сортирања стања у додатку. "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Параметри за додатак листе процес тикета у току контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе ескалираних тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе ескалираних тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе ескалираних тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Параметри за додатак календара догађаја тикета у контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе тикета на чекању контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе тикета на чекању контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns.' =>
            'Параметри за додатак листе тикета на чекању контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. Напомена: за DefaultColumns су дозвољени само атрибути тикета и динамичка поља (DynamicField_NameX).',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Параметри за додатак статистика тикета контролне табле у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Параметри за додатак предстојећих догађаја у интерфејсу оператера. "Limit" дефинише подразумевани број приказаних ставки. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "CacheTTLLocal" је време у минутима за кеширање додатка. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Parameters for the pages (in which the communication log entries are shown) of the communication log overview.' =>
            'Параметри страница (на којима су видљиве ставке комуникационих логова) у прегледу комуникационих логова.',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри страница (на којима су динамичка поља видљива) прегледа динамичких поља. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри страница (на којима су тикети видљиви) средњег прегледа тикета. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана. ',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри страница (на којима су тикети видљиви) умањеног прегледа тикета. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана. ',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Параметри страница (на којима су тикети видљиви) прегледа тикета. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана. ',
        'Parameters of the example SLA attribute Comment2.' => 'Параметри за пример атрибута SLA коментара 2.',
        'Parameters of the example queue attribute Comment2.' => 'Параметри за пример атрибута ред коментара 2.',
        'Parameters of the example service attribute Comment2.' => 'Параметри за пример атрибута сервис коментара 2.',
        'Parent' => 'Parent',
        'ParentChild' => 'ParentChild',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            'Путања до лог датотеке (важи једино ако је за LoopProtectionModule изабрано "FS" и постављено као обавезно).',
        'Pending time' => 'Време чекања',
        'People' => 'Особе',
        'Performs the configured action for each event (as an Invoker) for each configured web service.' =>
            'Извршава подешену акцију за сваки догађај (као позивалац) за сваки конфигурисан веб сервис.',
        'Permitted width for compose email windows.' => 'Дозвољена ширина прозора за писање поруке.',
        'Permitted width for compose note windows.' => 'Дозвољена ширина прозора за писање напомене.',
        'Persian' => 'Персијски',
        'Phone Call Inbound' => 'Долазни позив',
        'Phone Call Outbound' => 'Одлазни позив',
        'Phone Call.' => 'Позив.',
        'Phone call' => 'Позив',
        'Phone communication channel.' => 'Комуникациони канал позива.',
        'Phone-Ticket' => 'Тикет позива',
        'Picture Upload' => 'Отпремање слике',
        'Picture upload module.' => 'Модул за отпремање слике.',
        'Picture-Upload' => 'Отпремање слике',
        'Plugin search' => 'Модул претраге',
        'Plugin search module for autocomplete.' => 'Модул претраге за аутоматско допуњавање.',
        'Polish' => 'Пољски',
        'Portuguese' => 'Португалски',
        'Portuguese (Brasil)' => 'Португалски (Бразил)',
        'PostMaster Filters' => 'PostMaster филтери',
        'PostMaster Mail Accounts' => 'PostMaster мејл налози',
        'Print this ticket' => 'Одштампај овај тикет',
        'Priorities' => 'Приоритети',
        'Process Management Activity Dialog GUI' => 'Графички интерфејс дијалога активности у процесима',
        'Process Management Activity GUI' => 'Графички интерфејс активности у процесима',
        'Process Management Path GUI' => 'Графички интерфејс путање у процесима',
        'Process Management Transition Action GUI' => 'Графички интерфејс транзиционе акције у процесима',
        'Process Management Transition GUI' => 'Графички интерфејс транзиције у процесима',
        'Process Ticket.' => 'Процес тикет.',
        'Process pending tickets.' => 'Процес тикет на чекању.',
        'ProcessID' => 'ID процеса',
        'Processes & Automation' => 'Процеси & аутоматизација',
        'Product News' => 'Новости о производу',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see https://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            'Заштита од CSRF експлоатације (Cross Site Request Forgery, за више информација погледајте https://en.wikipedia.org/wiki/Cross-site_request_forgery).',
        'Provides a matrix overview of the tickets per state per queue' =>
            'Приказује матрицу прегледа тикета по њиховом стању по редовима',
        'Provides customer users access to tickets even if the tickets are not assigned to a customer user of the same customer ID(s), based on permission groups.' =>
            'Дозвољава приступ клијент корисницима тикетима чак иако тикети немају додељеног клијент корисника истог клијента, а на основу групних дозвола.',
        'Public Calendar' => 'Јавни календар',
        'Public calendar.' => 'Јавни календар.',
        'Queue view' => 'Преглед реда',
        'Queues ↔ Auto Responses' => 'Редови ↔ аутоматски одговори',
        'Rebuild the ticket index for AgentTicketQueue.' => 'Поново изради индекс тикета за оператерски ред тикета.',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number. Note: the first capturing group from the \'NumberRegExp\' expression will be used as the ticket number value.' =>
            'Препознаје да ли је тикет наставак постојећег тикета коришћењем екстерног броја тикета. Напомена: прва RegEx група из \'NumberRegExp\' израза ће бити искоришћена као вредност броја тикета.',
        'Refresh interval' => 'Интервал освежавања',
        'Registers a log module, that can be used to log communication related information.' =>
            'Региструје лог модул за чување информација у вези комуникација.',
        'Reminder Tickets' => 'Тикети подсетника',
        'Removed subscription for user "%s".' => 'Претплата за корисника "%s" je искључена.',
        'Removes old generic interface debug log entries created before the specified amount of days.' =>
            'Уклања старе логове отклањања грешака генеричког интерфејса који су креирани пре дефинисаног броја дана.',
        'Removes old system configuration deployments (Sunday mornings).' =>
            'Уклања старе распореде системске конфигурације (недељом ујутру).',
        'Removes old ticket number counters (each 10 minutes).' => 'Уклања старе бројаче тикета (сваких 10 минута).',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Уклања информације посматрача тикета када се тикет архивира.',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be enabled in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            'Обнавља постојеће SMIME сертификате из извора клијената. Напомена: SMIME и SMIME::FetchFromCustomer морају бити укључени у конфигурацији и извор клијената мора бити подешен за преузимање UserSMIMECertificate атрибута.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Замењује оригиналног пошиљаоца са имејл адресом актуелног клијента при креирању одговора у прозору за писање одговора интерфејса оператера.',
        'Reports' => 'Извештаји',
        'Reports (OTRS Business Solution™)' => 'Извештаји (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            'Поново обради имејлове из директоријума реда чекања који први пут нису могли бити увезени.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Неопходне дозволе за промену клијента тикета у интерфејсу оператера.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана затварања тикета у интерфејсу оператера.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана одлазних имејлова у интерфејсу оператера.',
        'Required permissions to use the email resend screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана за поновно слање имејлова у интерфејсу оператера.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана преусмерења тикета у интерфејсу оператера.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана слања одговора тикета у интерфејсу оператера.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана прослеђивања тикета у интерфејсу оператера.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана слободног текста тикета у интерфејсу оператера.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Неопходне дозволе за употребу екрана спајања тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана напомена тикета у интерфејсу оператера.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Неопходне дозволе за употребу екрана власника тикета у детаљном прегледу тикета у интерфејсу оператера.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Неопходне дозволе за употребу екрана тикета на чекању у детаљном прегледу тикета у интерфејсу оператера.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана долазних позива тикета у интерфејсу оператера.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана одлазних позива тикета у интерфејсу оператера.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Неопходне дозволе за употребу екрана приоритета тикета у детаљном прегледу тикета тикета у интерфејсу оператера.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Неопходне дозволе за употребу екрана одговорног тикета у интерфејсу оператера.',
        'Resend Ticket Email.' => 'Пошаљи поново имејл.',
        'Resent email to "%s".' => 'Поново послат имејл на "%s".',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Ресетује и откључава власника ако је тикета премештен у други ред.',
        'Resource Overview (OTRS Business Solution™)' => 'Преглед ресурса (OTRS Business Solution™)',
        'Responsible Tickets' => 'Одговорни тикети',
        'Responsible Tickets.' => 'Одговорни тикети.',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            'Враћа тикет из архиве (само ако је догађај промена стања на било које доступно отворено стање).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            'Задржи све сервисе у листи чак иако су деца неважећих елемената.',
        'Right' => 'Десно',
        'Roles ↔ Groups' => 'Улоге ↔ групе',
        'Romanian' => 'Румунски',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            'Покреће послове генеричког оператера базиране на датотекама (Напомена: назив модула мора бити дефинисан у конфигурацији параметара модула, нпр. "Kernel::System::GenericAgent").',
        'Running Process Tickets' => 'Активни процес тикети',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            'Покреће иницијалну џокер претрагу постојећих фирми клијената при приступу модулу AdminCustomerCompany.',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            'Покреће иницијалну џокер претрагу постојећих корисника при приступу модулу AdminCustomerUser.',
        'Runs the system in "Demo" mode. If enabled, agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            'Покреће систем у демо моду. Уколико је укључено, оператери могу променити своја подешавања као што су избор језика и теме у интерфејсу оператера. Ове промене ће важити само за тренутну сесију. Оператерима неће бити омогућено да промене своје лозинке.',
        'Russian' => 'Руски',
        'S/MIME Certificates' => 'S/MIME сертификати',
        'SMS' => 'СМС',
        'SMS (Short Message Service)' => 'SMS (сервис кратких порука)',
        'Salutations' => 'Поздрави',
        'Sample command output' => 'Пример командног излаза',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            'Чува прилоге у чланцима. „DB” снима све прилоге у бази података (није препоручљиво за чување великих прилога). „FS” снима прилоге у систему датотека; ово је бржа опција, али веб сервер мора бити покренут под „OTRS” системским корисником. Дозвољена је промена модула чак и на продукцијским системима без било каквог губитка података. Напомена: претрага прилога по називу није могућа када је „FS” у функцији.',
        'Schedule a maintenance period.' => 'Планирање периода одржавања.',
        'Screen after new ticket' => 'Приказ екрана после отварања новог тикета',
        'Search Customer' => 'Тражи клијента',
        'Search Ticket.' => 'Тражи тикет.',
        'Search Tickets.' => 'Претражи тикете.',
        'Search User' => 'Тражи корисника',
        'Search backend default router.' => 'Подразумевани рутер модул претраге.',
        'Search backend router.' => 'Рутер модул претраге.',
        'Search.' => 'Претрага.',
        'Second Christmas Day' => 'Други дан Божића',
        'Second Queue' => 'Други Ред',
        'Select after which period ticket overviews should refresh automatically.' =>
            'Изаберите после ког периода ће прегледи тикета бити аутоматски освежени.',
        'Select how many tickets should be shown in overviews by default.' =>
            'Изаберите који број тикета ће бити подразумевано приказан у прегледима.',
        'Select the main interface language.' => 'Изаберите главни језик интерфејса.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Изаберите сепаратор који ће се користи у CSV датотекама (статистика и претраге). Ако овде не изаберете сепаратор, користиће се подразумевани сепаратор за ваш језик',
        'Select your frontend Theme.' => 'Изаберите тему интерфејса.',
        'Select your personal time zone. All times will be displayed relative to this time zone.' =>
            'Изаберите вашу личну временску зону. Сва времена ће бити приказана у њој.',
        'Select your preferred layout for the software.' => 'Изаберите изглед апликације по вашој жељи.',
        'Select your preferred theme for OTRS.' => 'Изаберите тему за OTRS по вашој жељи.',
        'Selects the cache backend to use.' => 'Модул кеша који ће користити систем.',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Бира модул за руковање пренешеним датотекама преко веб интерфејса. "DB" складишти све пренешене датотеке у базу података, "FS" користи систем датотека.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535).' =>
            'Бира модул за генерисање броја тикета. "AutoIncrement" увећава број тикета, ID система и бројач се користе у облику SystemID.бројач (нпр. 1010138, 1010139). Са "Date" бројеви тикета ће бити генерисани на основу тренутног датума, ID система и бројача. Облик је година.месец.дан.SystemID.бројач (нпр. 2002070110101520, 2002070110101535). Са "DateChecksum" бројач ће бити додат као контролни збир низу сачињеном од датума и ID система. Контролни збир ће се смењивати на дневном нивоу. Формат изгледа овако: година.месец.дан.SystemID.бројач.контролни збир (нпр. 2002070110101520, 2002070110101535).',
        'Send new outgoing mail from this ticket' => 'Пошаљи нови одлазни имејл из овог тикета',
        'Send notifications to users.' => 'Пошаљи обавештења корисницима.',
        'Sender type for new tickets from the customer inteface.' => 'Тип пошиљаоца за нове тикете из интерфејса клијента.',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Шаље обавештење о наставку само оператеру власнику, ако је тикет откључан (подразумевано је да шаље свим оператерима).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Шаље све одлазне имејлове као невидљиве копије (bcc) на одређену адресу. Молимо да ово користите само за резервне копије.',
        'Sends customer notifications just to the mapped customer.' => 'Шаље клијентска обавештења само мапираном клијенту.',
        'Sends registration information to OTRS group.' => 'Шаље регистрационе информације OTRS групи.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Шаље обавештење за потсећање о откључаном тикету кад се достигне датум подсетника (шаље само власнику тикета).',
        'Sends the notifications which are configured in the admin interface under "Ticket Notifications".' =>
            'Шаље обавештења која су у административном интерфејсу конфигурисана под "Обавештења о тикетима".',
        'Sent "%s" notification to "%s" via "%s".' => 'Послато обавештење "%s" на "%s" преко "%s".',
        'Sent auto follow-up to "%s".' => 'Послат аутоматски наставак на "%s".',
        'Sent auto reject to "%s".' => 'Послато аутоматско одбијање на "%s".',
        'Sent auto reply to "%s".' => 'Послат аутоматски одговор на "%s".',
        'Sent email to "%s".' => 'Послат имејл на "%s".',
        'Sent email to customer.' => 'Послат имејл клијенту.',
        'Sent notification to "%s".' => 'Послато обавештење на "%s".',
        'Serbian Cyrillic' => 'Српски ћирилица',
        'Serbian Latin' => 'Српски латиница',
        'Service Level Agreements' => 'Споразуми о нивоу услуга',
        'Service view' => 'Преглед услуге',
        'ServiceView' => 'ServiceView',
        'Set a new password by filling in your current password and a new one.' =>
            'Подесите нову лозинку укуцавањем ваше тренутне и нове.',
        'Set sender email addresses for this system.' => 'Подеси системску адресу пошиљаоца.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Подешава подразумевану висину (у пикселима) непосредних HTML чланака у AgentTicketZoom.',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            'Поставља ограничење колико ће тикета бити извршено у једном извршавању посла генеричког оператера.',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            'Подешава максималну висину (у пикселима) непосредних HTML чланака у AgentTicketZoom.',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
            'Одредите најнижи ниво логовања. Уколико изаберете \'error\', биће логоване само грешке. Са \'debug\' добићете све поруке у логовима. Редослед нивоа логовања је: \'debug\', \'info\', \'notice\' и \'error\'.',
        'Set this ticket to pending' => 'Постави овај тикет у статус чекања',
        'Sets if SLA must be selected by the agent.' => 'Подешава ако SLA мора бити изабран од стране оператера.',
        'Sets if SLA must be selected by the customer.' => 'Подешава ако SLA мора бити изабран од стране клијента.',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            'Одређује да ли напомена мора бити попуњена од стране оператера. Ово понашање је могуће преиначити путем Ticket::Frontend::NeedAccountedTime.',
        'Sets if queue must be selected by the agent.' => 'Дефинише да ли оператер мора да одабере ред.',
        'Sets if service must be selected by the agent.' => 'Подешава да ли услуга мора бити изабрана од стране оператера.',
        'Sets if service must be selected by the customer.' => 'Подешава да ли услуга мора бити изабрана од стране клијента.',
        'Sets if state must be selected by the agent.' => 'Дефинише да ли оператер мора да одабере стање.',
        'Sets if ticket owner must be selected by the agent.' => 'Подешава ако власник тикета мора бити изабран од стране оператера.',
        'Sets if ticket responsible must be selected by the agent.' => 'Дефинише да ли оператер мора да одабере одговорног тикета.',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            'Подешава време чекања тикета на 0 ако је стање промењено на стање које није чекање.',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            'Постави време у минутама (први ниво) за наглашавање редова који садрже нетакнуте тикете.',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            'Постави време у минутама (други ниво) за наглашавање редова који садрже нетакнуте тикете.',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            'Постави конфигурациони ниво за администратора. У зависности од конфигурационог нивоа, неке системске опције неће бити приказане. Конфигурациони нивои поређани растуће: Експерт, Напредни, Почетни. Што је виши ниво (нпр Почетни је највиши), мања је вероватноћа да корисник може да конфигурише систем тако да више није употребљив.',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            'Подешава броја чланака видљивих у моду приказа прегледа тикета.',
        'Sets the default article customer visibility for new email tickets in the agent interface.' =>
            'Дефинише подразумевану видљивост чланка клијенту за нове имејл тикете у интерфејсу оператера.',
        'Sets the default article customer visibility for new phone tickets in the agent interface.' =>
            'Дефинише подразумевану видљивост чланака клијенту за нове тикете позива у интерфејсу оператера.',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            'Поставља подразумевани садржај за напомене додате на екрану затварања тикета у интерфејсу оператера.',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            'Поставља подразумевани садржај за напомене додате на екрану померања тикета у интерфејсу оператера.',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            'Поставља подразумевани садржај за напомене додате на екрану напомене тикета у интерфејсу оператера.',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Поставља подразумевани садржај за напомене додате на екрану власника тикета у интерфејсу оператера.',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Поставља подразумевани садржај за напомене додате на екрану тикета на чекању на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Поставља подразумевани садржај за напомене додате на екрану приоритета тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            'Поставља подразумевани садржај за напомене додате на екрану одговорног за тикет у интерфејсу оператера.',
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Поставља подразумевану поруку грешке за пријавни екран у интерфејсу оператера и клијента, приказује се током активног периода одржавања.',
        'Sets the default link type of split tickets in the agent interface.' =>
            'Дефинише подразумевани тип везе за подељене тикете у интерфејсу оператера.',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            'Поставља подразумевани тип везе за подељене тикете у интерфејсу оператера.',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            'Поставља подразумевану поруку за пријавни екран у интерфејсу оператера и клијента, приказује се током активног периода одржавања.',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
            'Одређује подразумевану поруку за обавештење које се види током периода одржавања.',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            'Одређује подразумевани следећи статус за нове тикете позива у интерфејсу оператера.',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            'Одређује подразумевани следећи статус тикета, након креирања имејл тикета у интерфејсу оператера.',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            'Поставља подразумевани текст напомене за нове тикете позива. Нпр. \'Нови тикет путем позива\' у интерфејсу оператера.',
        'Sets the default priority for new email tickets in the agent interface.' =>
            'Одређује подразумевани приоритет новог имејл тикета а у интерфејсу оператера.',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            'Одређује подразумевани приоритет новог тикета позива у интерфејсу оператера.',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            'Поставља подразумевани тип пошиљаоца за нове имејл тикете у интерфејсу оператера.',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            'Поставља подразумевани тип пошиљаоца за нове тикете позива у интерфејсу оператера.',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            'Одређује подразумевани предмет за нове имејл тикете (нпр. \'одлазни имејл\') у интерфејсу оператера.',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            'Одређује подразумевани предмет за нове тикете позива (нпр. \'Позив\') у интерфејсу оператера.',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            'Одређује подразумевани предмет за напомене додате на приказу екрана затвореног тикета у интерфејсу оператера.',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            'Одређује подразумевани предмет за напомене додате на приказу екрана померања тикета у интерфејсу оператера.',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            'Одређује подразумевани предмет за напомене додате на приказу екрана напомена тикета у интерфејсу оператера.',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Одређује подразумевани предмет за напомене додате на детаљном приказу екрана власника тикета у интерфејсу оператера.',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Одређује подразумевани предмет за напомене додате на детаљном приказу екрана тикета на чекању у интерфејсу оператера.',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Одређује подразумевани предмет за напомене додате на детаљном приказу екрана приоритета тикета у интерфејсу оператера.',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            'Одређује подразумевани предмет за напомене додате на приказу екрана одговорног за тикет у интерфејсу оператера.',
        'Sets the default text for new email tickets in the agent interface.' =>
            'Одређује подразумевани текст новог имејл тикета а у интерфејсу оператера.',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            'Одређује време без активности (у секундама) пре него што сесија буде угашена а корисник одјављен.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            'Поставља максимални број активних оператера у временском распону дефинисаном у SessionMaxIdleTime пре него што обавештење буде видљиво за пријављене оператере.',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            'Поставља максимални број активних оператера у временском распону дефинисаном у SessionMaxIdleTime.',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            'Поставља максимални број активних клијента у временском распону дефинисаном у SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            'Поставља максимални број активних сесија по оператеру у временском распону дефинисаном у SessionMaxIdleTime.',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            'Поставља максимални број активних сесија по кориснику у временском распону дефинисаном у SessionMaxIdleTime.',
        'Sets the method PGP will use to sing and encrypt emails. Note Inline method is not compatible with RichText messages.' =>
            'Дефинише метод који ће „PGP” да користи приликом потписивања и шифровања имејлова. Напомена: метод "непосредно" није компатибилан са „RichText” порукама.',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
            'Дефинише минималну величину бројача тикета уколико је изабран "AutoIncrement" као TicketNumberGenerator. Подразумевано је 5, што значи да бројач почиње од 10000.',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
            'Одређује број минута трајања приказа обавештења о предсојећем периоду одржавања.',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            'Подешава број линија приказаних у текстуалним порукама (нпр број линија у детаљном прегледу реда).',
        'Sets the options for PGP binary.' => 'Одређује опције за PGP апликацију.',
        'Sets the password for private PGP key.' => 'Подеси лозинку за приватни PGP кључ.',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            'Подеси приоритетне временске јединице (нпр јединице посла, сате, минуте)',
        'Sets the preferred digest to be used for PGP binary.' => 'Дефинише мод шифровања PGP апликације.',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            'Дефинише путању фолдера са скриптама на серверу, према подешавању веб сервера. Ова опција се користи као променљива OTRS_CONFIG_ScriptAlias у свим облицима комуникације широм система, ради генерисања веза ка тикетима.',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            'Поставља ред на прозору затварања тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            'Поставља ред на прозору слободног текста тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            'Поставља ред на прозору напомене тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Поставља ред на прозору власника тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Поставља ред на прозору тикета на чекању на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Поставља ред на прозору приоритета тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            'Поставља ред на прозору одговорног за тикет на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            'Поставља одговорног оператера за тикет на прозору затварања тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            'Поставља одговорног оператера за тикет на прозору масовних акција тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            'Поставља одговорног оператера за тикет на прозору слободног текста тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            'Поставља одговорног оператера за тикет на прозору напомене тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Поставља одговорног оператера за тикет у прозору власника тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Поставља одговорног оператера за тикет у прозору тикета на чекању на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Поставља одговорног оператера за тикет у прозору приоритета тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            'Поставља одговорног оператера за тикет у прозору одговорног за тикет у интерфејсу оператера.',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Подешава сервис на екрану затварања тикета у интерфејсу оператера (Ticket::Service треба да буде активиран).',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Подешава сервис на екрану слободног текста тикета у интерфејсу оператера (Ticket::Service треба да буде активиран).',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Подешава сервис на екрану напомене тикета у интерфејсу оператера (Ticket::Service треба да буде активиран).',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Подешава сервис на екрану власника тикета на детаљном прегледу тикета у интерфејсу оператера (Ticket::Service треба да буде активиран).',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Подешава сервис на екрану тикета на чекању на детаљном прегледу тикета у интерфејсу оператера (Ticket::Service треба да буде активиран).',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be enabled).' =>
            'Подешава сервис на екрану приоритета тикета на детаљном прегледу тикета у интерфејсу оператера (Ticket::Service треба да буде активиран).',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be enabled).' =>
            'Подешава сервис на екрану одговорног за тикет у интерфејсу оператера (неопходно је укључити Ticket::Service).',
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            'Поставља статус тикета у екрану затварања тикета у интерфејсу оператера.',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            'Поставља статус тикета у екрану масовних акција у интерфејсу оператера.',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            'Поставља статус тикета у екрану слободног текста у интерфејсу оператера.',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            'Поставља статус тикета у екрану напомене у интерфејсу оператера.',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            'Поставља статус тикета у екрану одговорног у интерфејсу оператера.',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Поставља статус тикета у екрану власника у интерфејсу оператера.',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Поставља статус тикета у екрану чекања у интерфејсу оператера.',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Поставља статус тикета у екрану приоритета у интерфејсу оператера.',
        'Sets the stats hook.' => 'Дефинише ознаку за статистике.',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            'Поставља власника тикета у прозору затварања тикета у интерфејсу оператера.',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            'Поставља власника тикета у прозору масовних акција тикета у интерфејсу оператера.',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            'Поставља власника тикета у прозору слободног текста тикета у интерфејсу оператера.',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            'Поставља власника тикета у прозору напомене тикета у интерфејсу оператера.',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Одређује власника тикета на екрану власништва тикета у детаљном приказу тикета интерфејса оператера.',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Одређује власника тикета на екрану тикета на чекању у детаљном приказу тикета интерфејса оператера.',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Одређује власника тикета на екрану приоритета тикета у детаљном приказу тикета интерфејса оператера.',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            'Одређује власника тикета на екрану одговорности за тикет у интерфејсу оператера.',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Одређује тип тикета на екрану затварања тикета у интерфејсу оператера (Ticket::Type мора бити укључено).',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            'Одређује тип тикета на екрану масовне акције тикета у интерфејсу оператера.',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Одређује тип тикета на екрану слободног текста тикета у интерфејсу оператера (Ticket::Type мора бити укључено).',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Одређује тип тикета на екрану напомене тикета у интерфејсу оператера (Ticket::Type мора бити укључено).',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Одређује тип тикета на екрану власника тикета у интерфејсу оператера (Ticket::Type мора бити укључено).',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Одређује тип тикета на екрану тикета на чекању у интерфејсу оператера (Ticket::Type мора бити укључено).',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be enabled).' =>
            'Одређује тип тикета на екрану приоритета тикета у интерфејсу оператера (Ticket::Type мора бити укључено).',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be enabled).' =>
            'Одређује тип тикета на екрану одговорног тикета у интерфејсу оператера (Ticket::Type мора бити укључено).',
        'Sets the time zone being used internally by OTRS to e. g. store dates and times in the database. WARNING: This setting must not be changed once set and tickets or any other data containing date/time have been created.' =>
            'Подешава интерну временску зону OTRS за нпр. чување датума и времена у бази података. Упозорење: ово подешавање не смете мењати једном када га подесите и ако су креирани тикети или било који други подаци са временом.',
        'Sets the time zone that will be assigned to newly created users and will be used for users that haven\'t yet set a time zone. This is the time zone being used as default to convert date and time between the OTRS time zone and the user\'s time zone.' =>
            'Подешава временску зону која ће бити додељена ново-креираним корисницима и која ће бити коришћена за оне који још нису подесили временску зону. Ово је подразумевана временска зона за конверзију датума и времена између интерне OTRS временске зоне и временске зоне корисника.',
        'Sets the timeout (in seconds) for http/ftp downloads.' => 'Поставља временско одлагање (у секундама) за http/ftp преузимања.',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            'Дефинише истицање (у секундама) за функцију преузимања пакета. Преиначује опцију "WebUserAgent::Timeout".',
        'Shared Secret' => 'Дељена тајна',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            'Прикажи избор одговорног у тикетима позива и имејл тикетима у интерфејсу оператера.',
        'Show article as rich text even if rich text writing is disabled.' =>
            'Прикажи чланак као обогаћени текст чак и кад је писање обогаћеног текста деактивирано.',
        'Show command line output.' => 'Приказ командног излаза.',
        'Show queues even when only locked tickets are in.' => 'Прикажи редове чак и кад садрже само закључане тикете.',
        'Show the current owner in the customer interface.' => 'Приказује актуелног власника у клијентском интерфејсу.',
        'Show the current queue in the customer interface.' => 'Приказује актуелни ред у клијентском интерфејсу.',
        'Show the history for this ticket' => 'Прикажи историјат за овај тикет',
        'Show the ticket history' => 'Прикажи историју тикета',
        'Shows a count of attachments in the ticket zoom, if the article has attachments.' =>
            'Приказује број прилога у детаљном приказу тикета, ако чланак има прилоге.',
        'Shows a link in the menu for creating a calendar appointment linked to the ticket directly from the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију тикета за креирање термина у календару повезаног са тим тикетом. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за пријаву / одјаву на тикет у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију која омогућава повезивање тикета са другим објектом у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију која омогућава спајање тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за приступ историјату тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за додавање поља слободног текста у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за додавање напомене у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            'У менију приказује везу за додавање напомене на тикет у сваки преглед тикета у интерфејсу оператера.',
        'Shows a link in the menu to add a phone call inbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за додавање долазног позива тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to add a phone call outbound in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за додавање одлазног позива тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to change the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за промену клијента на кога се води тикет у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to change the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за промену власника тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to change the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за промену одговорног тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            'У менију приказује везу за затварање тикета у сваки преглед тикета у интерфејсу оператера.',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за затварање тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Приказује везу у менију за брисање тикета у свим прегледима у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за брисање тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            'У менију приказује везу за прикључивање тикета процесу у детаљном прегледу у интерфејсу оператера.',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за повратак у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            'У менију приказује везу за закључавање / откључавање тикета у прегледе тикета у интерфејсу оператера.',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за закључавање/откључавање тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            'У менију приказује везу за померање тикета у сваки преглед тикета у интерфејсу оператера.',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за штампу тикета или чланка у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            'У менију приказује везу за гледање историјата тикета у сваки преглед тикета у интерфејсу оператера.',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за контролу приоритета тикета у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за слање одлазне имејл поруке у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Приказује везу у менију за означавање тикета као бесмисленог junk у свим прегледима у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за постављање тикета у чекање у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            'У менију приказује везу за подешавање приоритета тикета у сваки преглед тикета у интерфејсу оператера.',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            'У менију приказује везу за детаљни приказ тикета у прегледе тикета у интерфејсу оператера.',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            'У менију приказује везу за приступ прилозима чланка преко html прегледа у детаљном прегледу чланка у интерфејсу оператера.',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            'У менију приказује везу за преузимање прилога чланка у детаљном прегледу чланка у интерфејсу оператера',
        'Shows a link to see a zoomed email ticket in plain text.' => 'Приказује везу за приказ детаљног прегледа тикета као обичан текст.',
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            'Приказује везу у менију за означавање тикета као бесмисленог „junk” у детаљном прегледу у интерфејсу оператера. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2". За здруживање веза у менију подесите кључ "ClusterName" са садржајем који ће бити назив који желите да видите у интерфејсу. Користите кључ "ClusterPriority" за измену редоследа група у менију.',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            'Приказује листу свих укључених оператера за овај тикет, на екрану затварања тикета у оператерском интерфејсу.',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            'Приказује листу свих укључених оператера за овај тикет, на екрану слободног текста тикета у оператерском интерфејсу.',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            'Приказује листу свих укључених оператера за овај тикет, на екрану напомене тикета у оператерском интерфејсу.',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Приказује листу свих укључених оператера за овај тикет, на екрану власника тикета на детаљном приказу тикета у оператерском интерфејсу.',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Приказује листу свих укључених оператера за овај тикет, на екрану тикета на чекању на детаљном приказу тикета у оператерском интерфејсу.',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Приказује листу свих укључених оператера за овај тикет, на екрану приоритета тикета на детаљном приказу тикета у оператерском интерфејсу.',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            'Приказује листу свих укључених оператера за овај тикет, на екрану одговорног за тикет у оператерском интерфејсу.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на екрану затварања тикета у интерфејсу оператера.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на екрану слободног текста тикета у интерфејсу оператера.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на екрану напомене тикета у интерфејсу оператера.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на екрану власништва тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на екрану тикета на чекању на детаљном приказу тикета у интерфејсу оператера.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на екрану приоритета тикета на детаљном приказу тикета у интерфејсу оператера.',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            'Приказује листу свих могућих оператера (сви оператери са дозволом за напомену за ред/тикет) ради утврђивања ко треба да буде информисан о овој напомени, на екрану одговорности за тикет у интерфејсу оператера.',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            'Приказује прегледа тикета (Инфо клијента => 1 - показује и податке о клијенту, Максимална величина приказа података о клијенту у карактерима).',
        'Shows a teaser link in the menu for the ticket attachment view of OTRS Business Solution™.' =>
            'Приказује рекламну везу у менију за преглед прилога тикета из OTRS Business Solution™.',
        'Shows all both ro and rw queues in the queue view.' => 'Приказује све, и ro и rw редове на прегледу редова.',
        'Shows all both ro and rw tickets in the service view.' => 'Приказује све, и ro и rw тикете на прегледу услуга.',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            'Приказује све отворене тикете (чак иако су закључани) на ескалационом прегледу у интерфејсу оператера.',
        'Shows all the articles of the ticket (expanded) in the agent zoom view.' =>
            'Приказује све чланке тикета (детаљно) на детаљном прегледу.',
        'Shows all the articles of the ticket (expanded) in the customer zoom view.' =>
            'Приказује све чланке тикета (детаљно) на детаљном прегледу у интерфејсу корисника.',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Приказује све клијентске идентификаторе у пољу вишеструког избора (није корисно ако имате много клијентских идентификатора).',
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
            'Приказује све клијентске идентификаторе у пољу вишеструког избора (није корисно ако имате много клијентских идентификатора).',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Приказује избор власника за тикете позива и имејл тикете у интерфејсу оператера.',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Приказује историјат тикета клијента у AgentTicketPhone, AgentTicketEmail и AgentTicketCustomer.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Приказује предмет задњег клијентовог чланка или наслов тикета у прекледу малог формата.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Приказује постојеће листе редова надређени-подређени у систему у форми стабла или листе.',
        'Shows information on how to start OTRS Daemon' => 'Приказује информације како покренути OTRS системски сервис',
        'Shows link to external page in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Приказује везу на екстерну страну у детаљном прегледу тикета у интерфејсу оператера. ДОдатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Shows the article head information in the agent zoom view.' => 'Увек приказује све детаљне информације чланка тикета у детаљном прегледу оператера.',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Приказује чланке сортирано нормално или обрнуто, на детаљном приказу тикета у интерфејсу оператера.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Приказује податке о клијенту кориснику (број телефона и имејл) на екрану писања одговора.',
        'Shows the enabled ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Приказује атрибуте активираних тикета у интерфејсу клијента (0 = искључено, 1 = укључено).',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "Mandatory" determines if the plugin is always shown and can not be removed by agents.' =>
            'Приказује данашњу поруку на контролној табли у интерфејсу оператера. "Group" се користи да ограничи приступ додатку (нпр. Group: admin;group1;group2;). "Default" одређује да ли је додатак подразумевано активиран или да је неопходно да га корисник мануелно активира. "Mandatory" одређује да ли је додатак увек приказан и не може бити искључен од стране оператера.',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Приказује дневну поруку на екрану за пријаву у интерфејсу оператера.',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Приказује историјат тикета (обрнут редослед) у интерфејсу оператера.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Приказује опције приоритета тикета на екрану затвореног тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Приказује опције приоритета тикета на екрану померања тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Приказује опције приоритета тикета на екрану масовних тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Приказује опције приоритета тикета на екрану слободног текста тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Приказује опције приоритета тикета на екрану напомене тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Приказује опције приоритета тикета на екрану власника на детаљном приказу тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Приказује опције приоритета тикета на екрану приказа  чекања на детаљном приказу тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Приказује опције приоритета тикета на екрану приоритета на детаљном приказу тикета у интерфејсу оператера.',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            'Приказује опције приоритета тикета на екрану о одговорности на детаљном приказу тикета у интерфејсу оператера.',
        'Shows the title field in the close ticket screen of the agent interface.' =>
            'Приказује поље наслова у екрану затварања тикета у интерфејсу оператера.',
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            'Приказује поље наслова наекрану слободног текста тикета у интерфејсу оператера.',
        'Shows the title field in the ticket note screen of the agent interface.' =>
            'Приказује поље наслова у екрану напомене тикета у интерфејсу оператера.',
        'Shows the title field in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Приказује поље наслова у екрану власника тикета у интерфејсу оператера.',
        'Shows the title field in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Приказује поље наслова у екрану тикета на чекању у интерфејсу оператера.',
        'Shows the title field in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Приказује поље наслова у екрану приоритета тикета у интерфејсу оператера.',
        'Shows the title field in the ticket responsible screen of the agent interface.' =>
            'Приказује поље наслова у екрану одговорног тикета у интерфејсу оператера.',
        'Shows time in long format (days, hours, minutes), if enabled; or in short format (days, hours), if not enabled.' =>
            'Приказује време у дужем формату (дани, сати, минути), уколико је укључено; или у краћем формату (дани, сати), уколико је искључено.',
        'Shows time use complete description (days, hours, minutes), if enabled; or just first letter (d, h, m), if not enabled.' =>
            'Приказује потпун опис у времену (дани, сати, минути), уколико је укључено; или само прво слово (д, ч, м), уколико је искључено. ',
        'Signature data.' => '',
        'Signatures' => 'Потписи',
        'Simple' => 'Једноставно',
        'Skin' => 'Изглед',
        'Slovak' => 'Словачки',
        'Slovenian' => 'Словеначки',
        'Small' => 'Мало',
        'Software Package Manager.' => 'Управљање програмским пакетима.',
        'Solution time' => 'Време решавања',
        'SolutionDiffInMin' => 'SolutionDiffInMin',
        'SolutionInMin' => 'SolutionInMin',
        'Some description!' => 'Неки опис!',
        'Some picture description!' => 'Неки опис слике!',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Сортирање тикета (растуће или опадајуће) када се изабере један ред из прегледа редова после сортирања тикета по приоритету. Вредности: 0 = растуће (најстарије на врху, подразумевано), 1 = опадајуће (најновије на врху). Користи ID реда за кључ и 0 или 1 за вредност.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            'Сортирање тикета (растуће или опадајуће) када се изабере један ред из прегледа услуге после сортирања тикета по приоритету. Вредности: 0 = растуће (најстарије на врху, подразумевано), 1 = опадајуће (најновије на врху). Користи ID услуге за кључ и 0 или 1 за вредност.',
        'Spam' => 'Spam',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Пример подешавања за Spam Assassin. Игнорише имејлове које је означио Spam Assassin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Пример подешавања за Spam Assassin. Премешта означене имејлове у ред за непожељне.',
        'Spanish' => 'Шпански',
        'Spanish (Colombia)' => 'Шпански (Колумбија)',
        'Spanish (Mexico)' => 'Шпански (Мексико)',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            'Шпанске зауставне речи за индекс претрагу комплетног текста. Ове речи ће бити уклоњене из индекса претраге.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Дефинише да ли оператер треба да добије имејл обавештење за своје акције.',
        'Specifies the directory to store the data in, if "FS" was selected for ArticleStorage.' =>
            'Одређује директоријум за складиштење података ако је "FS" изабран за складиште чланака.',
        'Specifies the directory where SSL certificates are stored.' => 'Одређује директоријум где се „SSL” сертификати складиште.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Одређује директоријум где се приватни „SSL” сертификати складиште.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            'Дефинише имејл адресу коју ће апликација користити приликом слања обавештења. Имејл адреса се користи у називу пошиљаоца обавештења (нпр. "OTRS Notifications" otrs@your.example.com). Можете користити променљиву OTRS_CONFIG_FQDN из ваше конфигурације, или одредите другу имејл адресу.',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            'Одреди имејл адресу која ће добијати поруке обавештења од послова планера.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Одређује групу где су кориснику потребне rw дозволе како би могли приступити својству "SwitchToCustomer".',
        'Specifies the group where the user needs rw permissions so that they can edit other users preferences.' =>
            'Одређује групу где су кориснику потребне rw дозволе како би могли да уређују лична подешавања других корисника.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
            'Дефинише назив које ће апликација користити приликом слања обавештења. Назив се користи у називу пошиљаоца обавештења (нпр. "OTRS Notifications" otrs@your.example.com).',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Одређује облик у коме ће бити приказано име и презиме оператера.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Одређује путању датотеке логоа у заглављу стране (gif|jpg|png, 700 x 100 pixel).',
        'Specifies the path of the file for the performance log.' => 'Одређује путању датотеке за перформансу лог-а.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Одређује путању конвертора који дозвољава преглед Microsoft Excel датотека у веб интерфејсу.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Одређује путању конвертора који дозвољава преглед Microsoft Word датотека у веб интерфејсу.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Одређује путању конвертора који дозвољава преглед PDF докумената у веб интерфе',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Одређује путању конвертора који дозвољава преглед XML датотека у веб интерфе',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Одређује текст који треба да се појави у лог датотеци да означи улазак CGI скрипте.',
        'Specifies user id of the postmaster data base.' => 'Одређује ИД корисника „postmaster” базе података.',
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            'Дефинише да ли ће бити прегледани сви позадински модули приликом претраге прилога. Ово је неопходно само на системима где су неки прилози у систему датотека, а други у бази података.',
        'Specifies whether the (MIMEBase) article attachments will be indexed and searchable.' =>
            'Одређује да ли ће прилози (MIMEBase) чланака бити индексирани за претрагу.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Навођење колико нивоа поддиректоријума да користи приликом креирања кеш датотека. То би требало да спречи превише кеш датотека у једном директоријуму.',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            'Дефинише канал за ажурирање OTRS Business Solution™. Упозорење: бета издања могу бити некомплетна, ваш систем може добити непоправљиве грешке и, у екстремним случајевима, престати да реагује.',
        'Specify the password to authenticate for the first mirror database.' =>
            'Наведи лозинку за ауторизацију на прву пресликану базу података.',
        'Specify the username to authenticate for the first mirror database.' =>
            'Наведи корисничко име за ауторизацију на прву пресликану базу података.',
        'Stable' => ' Стабилно',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Стандардне расположиве дозволе за оператере унутар апликације. Уколико је потребно више дозвола они могу унети овде. Дозволе морају бити дефинисане да буду ефективне. Неке друге дозволе су такође обезбеђене уграђивањем у: напомену, затвори, на чекању, клијент, слободан текст, помери, отвори, одговоран, проследи и поврати. Обезбедите да "rw" увек буде последња регистрована дозвола.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Почетни број за бројанје статистика. Свака нова статистика повећава овај број.',
        'Started response time escalation.' => 'Започета ескалација времена одговора.',
        'Started solution time escalation.' => 'Започета ескалација времена решавања.',
        'Started update time escalation.' => 'Започета ескалација времена ажурирања.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Почиње џокер претрагу активног објекта након покретања везе маске објекта.',
        'Stat#' => 'Статистика#',
        'States' => 'Стања',
        'Statistic Reports overview.' => 'Преглед статистичких извештаја.',
        'Statistics overview.' => 'Преглед статистика.',
        'Status view' => 'Преглед статуса',
        'Stopped response time escalation.' => 'Обустављена ескалација времена одговора.',
        'Stopped solution time escalation.' => 'Обустављена ескалација времена решавања.',
        'Stopped update time escalation.' => 'Започета ескалација времена ажурирања.',
        'Stores cookies after the browser has been closed.' => 'Чува колачиће након затварања претраживача.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Уклања празне линије у приказу тикета на прегледу реда.',
        'Strips empty lines on the ticket preview in the service view.' =>
            'Уклања празне линије у приказу тикета на прегледу услуга.',
        'Support Agent' => 'Оператер подршке',
        'Swahili' => 'Свахили',
        'Swedish' => 'Шведски',
        'System Address Display Name' => 'Назив за приказ системске адресе',
        'System Configuration Deployment' => 'Распоређивање системске конфигурације',
        'System Configuration Group' => 'Категорија системске конфигурације',
        'System Maintenance' => 'Одржавање система',
        'Templates ↔ Attachments' => 'Шаблони ↔ прилози',
        'Templates ↔ Queues' => 'Шаблони ↔ редови',
        'Textarea' => 'Област текста',
        'Thai' => 'Тајландски',
        'The PGP signature is expired.' => '',
        'The PGP signature was made by a revoked key, this could mean that the signature is forged.' =>
            '',
        'The PGP signature was made by an expired key.' => '',
        'The PGP signature with the keyid has not been verified successfully.' =>
            '',
        'The PGP signature with the keyid is good.' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            'Излед који ће се користити у интерфејсу оператера. Молимо проверите доступне изгледе у Frontend::Agent::Skins.',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            'Излед који ће се користити у интерфејсу корисника. Молимо проверите доступне изгледе у Frontend::Customer::Skins.',
        'The daemon registration for the scheduler cron task manager.' =>
            'Регистрација модула сервиса за планиране послове.',
        'The daemon registration for the scheduler future task manager.' =>
            'Регистрација модула сервиса за будуће послове.',
        'The daemon registration for the scheduler generic agent task manager.' =>
            'Регистрација модула сервиса за послове генеричког оператера.',
        'The daemon registration for the scheduler task worker.' => 'Регистрација модула сервиса за радне послове.',
        'The daemon registration for the system configuration deployment sync manager.' =>
            'Регистрација модула сервиса за синхронизацију распореда системске конфигурације.',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Делилац између прикључка и броја тикета, нпр. \': \'.',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            'Време у минутима после емитовања догађаја, у ком су ново обавештење о ескалацији и старту догађаја прикривени.',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            'Формат поља предмета. \'Left\' значи \'[TicketHook#:12345] Неки наслов\', \'Right\' значи \'Неки наслов [TicketHook#:12345]\', \'None\' значи \'Неки наслов\' и без броја тикета. У последњем случају, обавезно проверите да ли је подешавање PostMaster::CheckFollowUpModule###0200-References активирано за препознавање наставака на основу заглавља имејл порука.',
        'The headline shown in the customer interface.' => 'Наслов приказан у клијентском интерфејсу.',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Идентификатор тикета, нпр. Ticket#, Call#, MyTicket#. Подразумевано је Ticket#.',
        'The logo shown in the header of the agent interface for the skin "High Contrast". See "AgentLogo" for further description.' =>
            'Лого приказан у заглављу интерфејса оператера за изглед "High Contrast". Погледајте "AgentLogo" за детаљнији опис.',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            'Лого приказан у заглављу интерфејса оператера за изглед "подразумевани". Погледајте "AgentLogo" за детаљнији опис.',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            'Лого приказан у заглављу интерфејса оператера за изглед Слоновача. Погледајте AgentLogo за детаљнији опис.',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            'Лого приказан у заглављу интерфејса оператера за изглед Слоновача (упрошћено). Погледајте AgentLogo за детаљнији опис.',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            'Лого приказан у заглављу интерфејса оператера за "упрошћени" изглед. Погледајте "AgentLogo" за детаљнији опис.',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Лого приказан у заглављу оператерског интерфејса. URL до слике може бити релативан у односу на директоријум са сликама или апсолутан до удаљеног сервера.',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Лого приказан у заглављу клијентског интерфејса. URL до слике може бити релативан у односу на директоријум са сликама или апсолутан до удаљеног сервера.',
        'The logo shown on top of the login box of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            'Лого приказан у заглављу интерфејса оператера. URL до слике може бити релативан у односу на директоријум са сликама или апсолутан до удаљеног сервера.',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            'Максимални број чланака раширених на једној страни на детаљном приказу тикета у интерфејсу оператера.',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            'Максимални број чланака за приказ на једној страни на детаљном приказу тикета у интерфејсу оператера.',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
            'Максимални број имејлова преузетих одједном пре поновне конекције на сервер.',
        'The secret you supplied is invalid. The secret must only contain letters (A-Z, uppercase) and numbers (2-7) and must consist of 16 characters.' =>
            'Тајна коју сте унели је неважећа. Тајна мора садржати само велика слова (A-Z) и цифре (2-7) и мора имати тачно 16 карактера.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Текст на почетку предмета у одговору на имејл, нпр. RE, AW или AS.',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Текст на почетку предмета када се имејл прослеђује, нпр. FW, Fwd, или WG.',
        'The value of the From field' => 'Вредност From поља',
        'Theme' => 'Тема',
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see DynamicFieldFromCustomerUser::Mapping setting for how to configure the mapping.' =>
            'Овај модул догађаја чува атрибуте корисника као динамичка поља тикета. Погледајте опцију DynamicFieldFromCustomerUser::Mapping за подешавање мапирања.',
        'This is a Description for Comment on Framework.' => 'Ово је опис за коментар у систему.',
        'This is a Description for DynamicField on Framework.' => 'Ово је опис за динамичко поље у систему.',
        'This is the default orange - black skin for the customer interface.' =>
            'Ово је подразумевани наранџасто-црни изглед клијентског интерфејса.',
        'This is the default orange - black skin.' => 'Ово је подразумевани наранџасто-црни изглед.',
        'This key is not certified with a trusted signature!' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Уколико је укључен, овај модул и његова PreRun() функција биће  извршени приликом сваког захтева. Користи се за проверу опција корисника и приказ вести о апликацији.',
        'This module is part of the admin area of OTRS.' => 'Овај модул је део OTRS административног простора.',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            'Ова опција одређује динамичко поље у које се смешта ID ентитета активности управљања процесима.',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            'Ова опција одређује динамичко поље у које се смешта ID ентитета активности управљања процесима.',
        'This option defines the process tickets default lock.' => 'Ова опција одређује подразумевано закључавање тикета у обради.',
        'This option defines the process tickets default priority.' => 'Ова опција одређује подразумевани приоритет тикета у обради.',
        'This option defines the process tickets default queue.' => 'Ова опција одређује подразумевани ред тикета у обради.',
        'This option defines the process tickets default state.' => 'Ова опција одређује подразумевани статус тикета у обради.',
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            'Ова опција ће одбити приступ тикетима клијентове фирме, ако их  није  креирао клијент корисник .',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            'Ова опција вам дозвољава да уграђену листу држава замените својом. Ово је посбно корисно ако у селекцији желите да користите само мали број држава.',
        'This setting is deprecated. Set OTRSTimeZone instead.' => 'Ово подешавање је застарело. Подесите OTRSTimeZone уместо њега.',
        'This setting shows the sorting attributes in all overview screen, not only in queue view.' =>
            'Ово подешавање приказује атрибуте сортирања у свим екранима прегледа, не само у приказу редова.',
        'This will allow the system to send text messages via SMS.' => 'Ово ће дозволити систему да шаље текстуалне поруке преко СМС.',
        'Ticket Close.' => 'Затварање тикета.',
        'Ticket Compose Bounce Email.' => 'Преусмеравање имејл поруке у тикету.',
        'Ticket Compose email Answer.' => 'Писање имејл поруке у тикету.',
        'Ticket Customer.' => 'Корисник тикета.',
        'Ticket Forward Email.' => 'Прослеђивање имејл поруке у тикету.',
        'Ticket FreeText.' => 'Слободни текст тикета.',
        'Ticket History.' => 'Историјат тикета.',
        'Ticket Lock.' => 'Закључавање тикета',
        'Ticket Merge.' => 'Спајање тикета.',
        'Ticket Move.' => 'Померање тикета.',
        'Ticket Note.' => 'Напомена тикета.',
        'Ticket Notifications' => 'Обавештења о тикету',
        'Ticket Outbound Email.' => 'Слање одлазне имејл поруке у тикету.',
        'Ticket Overview "Medium" Limit' => 'Ограничење прегледа тикета "средње"',
        'Ticket Overview "Preview" Limit' => 'Ограничење прегледа тикета "приказ"',
        'Ticket Overview "Small" Limit' => 'Ограничење прегледа тикета "мало"',
        'Ticket Owner.' => 'Власник тикета.',
        'Ticket Pending.' => 'Постављање тикета у чекање.',
        'Ticket Print.' => 'Штампа тикета.',
        'Ticket Priority.' => 'Приоритет тикета.',
        'Ticket Queue Overview' => 'Преглед реда тикета',
        'Ticket Responsible.' => 'Одговоран за тикет.',
        'Ticket Watcher' => 'Праћење тикета.',
        'Ticket Zoom' => 'Детаљи тикета',
        'Ticket Zoom.' => 'Детаљи тикета.',
        'Ticket bulk module.' => 'Модул масовне акције на тикетима.',
        'Ticket event module that triggers the escalation stop events.' =>
            'Модул догађаја тикета који окида догађаје заустављања ескалације.',
        'Ticket limit per page for Ticket Overview "Medium".' => 'Ограничење тикета по страни за преглед типа "средње".',
        'Ticket limit per page for Ticket Overview "Preview".' => 'Ограничење тикета по страни за преглед типа "приказ".',
        'Ticket limit per page for Ticket Overview "Small".' => 'Ограничење тикета по страни за преглед типа "мало".',
        'Ticket notifications' => 'Обавештења о тикету',
        'Ticket overview' => 'Pregled tiketa',
        'Ticket plain view of an email.' => 'Приказ неформатиране имејл поруке у тикету.',
        'Ticket split dialog.' => 'Дијалог за поделу тикета.',
        'Ticket title' => 'Наслов тикета',
        'Ticket zoom view.' => 'Детаљни преглед тикета.',
        'TicketNumber' => 'Број тикета',
        'Tickets.' => 'Тикети.',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            'Време у секундама које се додаје на тренутно време ако се поставља статус на чекању (подразумевано: 86400 = 1 дан).',
        'To accept login information, such as an EULA or license.' => 'Прихватање информација приликом пријављивања, нпр. EULA изјава или лиценца.',
        'To download attachments.' => 'За преузимање прилога.',
        'To view HTML attachments.' => 'За преглед HTML прилога.',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            'Искључује/укључује приказ листе пакета за проширење могућности у екрану за управљање пакетима.',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            'Ставка алатне линије за пречицу. Додатна контрола приказа ове везе може се постићи коришћењем кључа "Group" са садржајем "rw:group1;move_into:group2".',
        'Transport selection for appointment notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Избор транспорта за обавештења о термину. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана.',
        'Transport selection for ticket notifications. Please note: setting \'Active\' to 0 will only prevent agents from editing settings of this group in their personal preferences, but will still allow administrators to edit the settings of another user\'s behalf. Use \'PreferenceGroup\' to control in which area these settings should be shown in the user interface.' =>
            'Избор транспорта за обавештења о тикетима. Напомена: подешавање \'Active\' на 0 ће само онемогућити оператерима да мењају своја лична подешавања из ове групе, али ће администратори и даље моћи да их мењају у њихово име. Подесите \'PreferenceGroup\' да бисте одредили у ком делу интерфејса ова подешавања треба да буду приказана. ',
        'Tree view' => 'Приказ у облику стабла',
        'Triggers add or update of automatic calendar appointments based on certain ticket times.' =>
            'Активира додавање или освежавање аутоматских термина на основу времена тикета.',
        'Triggers ticket escalation events and notification events for escalation.' =>
            'Активира ескалационе догађаје тикета и догађаје обавештења за ескалације.',
        'Turkish' => 'Турски',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            'Искључује проверу важности SSL сертификата, нпр. уколико користите транспарентан HTTPS прокси. Користите на сопствену одговорност!',
        'Turns on drag and drop for the main navigation.' => 'Активира превуци и отпусти у главној навигацији.',
        'Turns on the remote ip address check. It should not be enabled if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Укључује проверу удаљене IP адресе. Треба бити искључено ако се апликација користи, на пример, преко proxy фарме или dialup конекције, зато што је удаљена IP адреса углавном другачија за сваки захтев.',
        'Tweak the system as you wish.' => 'Прилагодите систем својим потребама.',
        'Type of daemon log rotation to use: Choose \'OTRS\' to let OTRS system to handle the file rotation, or choose \'External\' to use a 3rd party rotation mechanism (i.e. logrotate). Note: External rotation mechanism requires its own and independent configuration.' =>
            'Врста ротације сервисног лога: изаберите \'OTRS\' да допустите OTRS систему да ротира логове, или \'Екстерно\' за други механизам ротације (нпр. logrotate). Напомена: ектерни ротациони механизми захтевају сопствену и независну конфигурацију.',
        'Ukrainian' => 'Украјински',
        'Unlock tickets that are past their unlock timeout.' => 'Откључај тикете којима је истекло време одлагања за откључавање.',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            'Откључавање тикета кад год се дода напомена и власник је ван канцеларије.',
        'Unlocked ticket.' => 'Откључано',
        'Up' => 'Горе',
        'Upcoming Events' => 'Предстојећи догађаји',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Ажурирај ознаку виђених тикета ако су сви прегледани или је креиран нови чланак.',
        'Update time' => 'Време ажурирања',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Ажурирај индекс ескалације тикета после ажурирања атрибута тикета.',
        'Updates the ticket index accelerator.' => 'Ажурирај акцелератор индекса тикета.',
        'Upload your PGP key.' => 'Пошаљите свој PGP кључ.',
        'Upload your S/MIME certificate.' => 'Пошаљите ваш S/MIME сертификат.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            'Користите нови тип поља за избор и аутоматско довршавање у интерфејсу оператера где је то могуће (поља за унос).',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            'Користите нови тип поља за избор и аутоматско довршавање у интерфејсу клијента где је то могуће (поља за унос).',
        'User Profile' => 'Кориснички профил',
        'UserFirstname' => 'Име корисника',
        'UserLastname' => 'Презиме корисника',
        'Users, Groups & Roles' => 'Оператери, групе & улоге',
        'Uses richtext for viewing and editing ticket notification.' => 'Користи richtext формат за преглед и уређивање обавештења о тикетима.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Користи richtekt формат за преглед и уређивање: чланака, поздрава, потписа, стандардних шаблона, аутоматских одговора и обавештења.',
        'Vietnam' => 'Вијетнамски',
        'View all attachments of the current ticket' => 'Приказ свих прилога тикета',
        'View performance benchmark results.' => 'Преглед резултата провере перформанси.',
        'Watch this ticket' => 'Надгледај овај тикет',
        'Watched Tickets' => 'Посматрани тикет',
        'Watched Tickets.' => 'Надгледани тикети.',
        'We are performing scheduled maintenance.' => 'Извршавамо планирано одржавање.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Извршавамо планирано одржавање. Пријава привремено није могућа.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Извршавамо планирано одржавање. ускоро ћемо бити поново активни.',
        'Web Services' => 'Веб сервиси',
        'Web View' => 'Веб преглед',
        'When agent creates a ticket, whether or not the ticket is automatically locked to the agent.' =>
            'Одређује да ли ће тикет бити аутоматски закључан на оператера, када га исти креира.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Када су тикети спојени, напомена ће бити аутоматски додата тикету који није више активан. Овде можете дефинисати тело ове напомене (овај текст се не може променити од стране оператера).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Када су тикети спојени, напомена ће бити аутоматски додата тикету који није више активан. Овде можете дефинисати предмет ове напомене (овај предмет се не може променити од стране оператера).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Када су тикети спојени, клијент може бити информисан имејлом постављањем поља за потврду "Обавести пошиљаоца". У простору за текст, можете дефинисати унапред форматирани текст који касније бити модификован од стране оператера.',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            'Дефинише да ли ће бити прикупљане информације из чланака коришћењем филтера дефинисаним у Ticket::Frontend::ZoomCollectMetaFilters.',
        'Whether to force redirect all requests from http to https protocol. Please check that your web server is configured correctly for https protocol before enable this option.' =>
            'Одређује да ли ће сви захтеви са http бити преусмерени на https протокол. Молимо проверите да ли је ваш веб сервер правилно подешен за https протокол пре укључивања ове опције.',
        'Yes, but hide archived tickets' => 'Да, али склони архивиране тикете',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Ваш имејл са бројем тикета "<OTRS_TICKET>" је преусмерен на тикет "<OTRS_BOUNCE_TO>"!',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Ваш имејл са бројем тикета "<OTRS_TICKET>" је припојен тикету "<OTRS_MERGE_TO_TICKET>"!',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            'Избор редова по вашој жељи. Уколико је укључено, добијаћете и обавештења о овим редовима путем имејла.',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            'Избор услуга по вашој жељи. Уколико је укључено, добијаћете и обавештења о овим услугама путем имејла.',
        'Zoom' => 'Увећај',
        'attachment' => 'прилог',
        'bounce' => 'преусмери',
        'compose' => 'састави',
        'debug' => 'отклањање неисправности',
        'error' => 'грешка',
        'forward' => 'проследи',
        'info' => 'инфо',
        'inline' => 'непосредно',
        'normal' => 'нормалан',
        'notice' => 'напомена',
        'pending' => 'на чекању',
        'phone' => 'позив',
        'responsible' => 'одговорност',
        'reverse' => 'обрнуто',
        'stats' => 'статистика',

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
