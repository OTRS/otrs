
    # --------------------------------------------------- #
    # Ticket Core
    # --------------------------------------------------- #
    # Ticket::Hook
    # (To set the Ticket identifier. Some people want to
    # set this to e. g. 'Call#', 'MyTicket#' or 'Ticket#'.)
    $Self->{'Ticket::Hook'} = 'Ticket#';

    # Ticket::HookDivider
    # (the divider between TicketHook# and number)
#    $Self->{'TicketHookDivider'} = ': ';
    $Self->{'Ticket::HookDivider'} = '';

    # Ticket::SubjectMaxSize
    # (Max size of the subjects in a reply)
    $Self->{'Ticket::SubjectSize'} = 60;

    # Ticket::SubjectRe
    # (The text at the beginning of the subject in a reply)
    $Self->{'Ticket::SubjectRe'} = 'Re';

    # Ticket::SubjectCleanAllNumbers
    # (remove all ticket numbers, not just the current ticket number, from subject)
    $Self->{'Ticket::SubjectCleanAllNumbers'} = 0;

    # CustomQueue
    # (The name of custom queue.)
    $Self->{'Ticket::CustomQueue'} = 'My Queues';

    # Ticket::ForceNewStateAfterLock
    # (force a new ticket state after lock action)
#    $Self->{'Ticket::ForceNewStateAfterLock'} = {
#        'new' => 'open',
#    };

    # Ticket::ForceUnlockAfterMove
    # (force to unlock a ticket after move action)
    $Self->{'Ticket::ForceUnlockAfterMove'} = 0;

    # Ticket::ChangeOwnerToEveryone -> useful for ASP
    # (Possible to change owner of ticket ot everyone) [0|1]
    $Self->{'Ticket::ChangeOwnerToEveryone'} = 0;

    # Ticket::QueueViewAllPossibleTickets
    # (show all ro and rw queues - not just rw queues)
    $Self->{'Ticket::QueueViewAllPossibleTickets'} = 0;

    # Ticket::NewMessageMode
    # (mode of new message is counted)
    $Self->{'Ticket::NewMessageMode'} = 'ArticleLastSender';
#    $Self->{'Ticket::NewMessageMode'} = 'ArticleSeen';

    # --------------------------------------------------- #
    # TicketFreeText                                      #
    # (define free text options for frontend)             #
    # --------------------------------------------------- #
#    $Self->{"TicketFreeKey1"} = {
#        '' => '-',
#        'Product' => 'Product',
#    };
#    $Self->{"TicketFreeText1"} = {
#        '' => '-',
#        'PC' => 'PC',
#        'Notebook' => 'Notebook',
#        'LCD' => 'LCD',
#        'Phone' => 'Phone',
#    };
#    $Self->{"TicketFreeKey2"} = {
#        '' => '-',
#        'Support' => 'Support',
#    };

    # default selections (if wanted)
    # $Self->{"TicketFreeText1::DefaultSelection"} = 'Notebook';

    $Self->{"TicketFreeTimeKey1"} = 'Termin1';
    $Self->{"TicketFreeTimeDiff1"} = 0;
    $Self->{"TicketFreeTimeKey2"} = 'Termin2';
    $Self->{"TicketFreeTimeDiff2"} = 0;

    # --------------------------------------------------- #
    # Ticket::NumberGenerator                             #
    # --------------------------------------------------- #
    # Kernel::System::Ticket::Number::AutoIncrement (default) --> auto increment
    #   ticket numbers "SystemID.Counter" like 1010138 and 1010139.
    #
    # Kernel::System::Ticket::Number::Date --> ticket numbers with date
    #   "Year.Month.Day.SystemID.Counter" like 200206231010138 and 200206231010139.
    #
    # Kernel::System::Ticket::Number::DateChecksum --> ticket numbers with date and
    #   check sum and the counter will be rotated daily (my favorite)
    #   "Year.Month.Day.SystemID.Counter.CheckSum" like 2002070110101520 and 2002070110101535.
    #
    # Kernel::System::Ticket::Number::Random -->
    #   random ticket numbers "SystemID.Random" like 100057866352 and 103745394596.
#    $Self->{'Ticket::NumberGenerator'} = 'Kernel::System::Ticket::Number::Date';
#    $Self->{'Ticket::NumberGenerator'} = 'Kernel::System::Ticket::Number::DateChecksum';
#    $Self->{'Ticket::NumberGenerator'} = 'Kernel::System::Ticket::Number::Random';
#    $Self->{'Ticket::NumberGenerator'} = 'Kernel::System::Ticket::Number::AutoIncrement';

    $Self->{'Ticket::NumberGenerator'} = 'Kernel::System::Ticket::Number::DateChecksum';

    # further config option for Kernel::System::Ticket::Number::AutoIncrement
    # (min ticket counter size)
#    $Self->{'Ticket::NumberGenerator::MinCounterSize'} = 5;

    # Ticket::CounterLog
    # counter log
    $Self->{'Ticket::CounterLog'} = '<OTRS_CONFIG_Home>/var/log/TicketCounter.log';

    # --------------------------------------------------- #
    # Ticket::IndexAccelerator
    # --------------------------------------------------- #
    # choose your backend TicketViewAccelerator module

    # RuntimeDB
    # (generate each queue view on the fly from ticket table you will not
    # have performance trouble till ~ 60.000 tickets (till 6.000 open tickets)
    # in your system)
    $Self->{'Ticket::IndexModule'} = 'Kernel::System::Ticket::IndexAccelerator::RuntimeDB';

    # StaticDB
    # (the most powerfull module, it should be used over 80.000 (more the 6.000
    # open tickets) tickets in a system - use a extra ticket_index table, works
    # like a view - use bin/RebuildTicketIndex.pl for initial index update)
#    $Self->{'Ticket::IndexModule'} = 'Kernel::System::Ticket::IndexAccelerator::StaticDB';

    # --------------------------------------------------- #
    # Ticket::StorageModule
    # (Don't use it for big emails/attachments!)
    # --------------------------------------------------- #
    # (where attachments and co is stored - switch from fs -> db and
    # db -> fs is possible)
    $Self->{'Ticket::StorageModule'} = 'Kernel::System::Ticket::ArticleStorageDB';
    # FS is faster but webserver user should be the otrs user)
#    $Self->{'Ticket::StorageModule'} = 'Kernel::System::Ticket::ArticleStorageFS';
    # article fs dir
    $Self->{ArticleDir} = '<OTRS_CONFIG_Home>/var/article';

    # --------------------------------------------------- #
    # Ticket::CustomModule
    # --------------------------------------------------- #
    # (custom functions to redefine Kernel::System::Ticket functions)
#    $Self->{'Ticket::CustomModule'} = 'Kernel::System::Ticket::Custom';

    # --------------------------------------------------- #
    # add std responses when a new queue is created       #
    # --------------------------------------------------- #
    # array of std responses
    $Self->{StdResponse2QueueByCreating} = [
         'empty answer',
    ];
    # array of std response ids
    $Self->{StdResponseID2QueueByCreating} = [
#        1,
    ];

    # --------------------------------------------------- #
    # Ticket Frontend
    # --------------------------------------------------- #
    # Highligh*
    # (Set the age and the color for highlighting of old queue
    # in the QueueView.)
    # highlight age1 in min
    $Self->{HighlightAge1} = 1440;
    $Self->{HighlightColor1} = 'orange';
    # highlight age2 in min
    $Self->{HighlightAge2} = 2880;
    $Self->{HighlightColor2} = 'red';

    # Ticket::Frontend::PendingDiffTime
    # (Time in sec. which "pending date" shows per default) [default: 24*60*60 -=> 1d]
    $Self->{'Ticket::Frontend::PendingDiffTime'} = 24*60*60;

    # Ticket::Frontend::QueueListType
    # (show queues in system as tree or as list) [tree|list]
    $Self->{'Ticket::Frontend::QueueListType'} = 'tree';

    # Ticket::Frontend::StdResponsesMode
    # (should the standard responses selection be a form or links?) [Form|Link]
    $Self->{'Ticket::Frontend::StdResponsesMode'} = 'Link';

    # Ticket::Frontend::ZoomExpand
    # (show article expanded int ticket zoom)
    $Self->{'Ticket::Frontend::ZoomExpand'} = 0;

    # Ticket::Frontend::ZoomExpandSort
    # (show article normal or in reverse order) [normal|reverse]
#    $Self->{'Ticket::Frontend::ZoomExpandSort'} = 'reverse';
    $Self->{'Ticket::Frontend::ZoomExpandSort'} = 'normal';

    # Ticket::Frontend::HistoryOrder
    # (show history order reverse) [normal|reverse]
    $Self->{'Ticket::Frontend::HistoryOrder'} = 'normal';
#    $Self->{'Ticket::Frontend::HistoryOrder'} = 'reverse';

    # Ticket::Frontend::TextAreaEmail
    # (width of compose email windows)
    $Self->{'Ticket::Frontend::TextAreaEmail'} = 78;

    # Ticket::Frontend::TextAreaNote
    # (width of compose note windows)
    $Self->{'Ticket::Frontend::TextAreaNote'} = 70;

    # Ticket::Frontend::CustomerInfo*
    # (show customer user info on Compose (Phone and Email), Zoom and Queue view)
    $Self->{'Ticket::Frontend::CustomerInfoCompose'} = 1;
    $Self->{'Ticket::Frontend::CustomerInfoZoom'} = 1;
    $Self->{'Ticket::Frontend::CustomerInfoQueue'} = 0;

    # Ticket::Frontend::CustomerInfo*MaxSize
    # (max size (in characters) of customer info table)
    $Self->{'Ticket::Frontend::CustomerInfoComposeMaxSize'} = 22;
    $Self->{'Ticket::Frontend::CustomerInfoZoomMaxSize'} = 22;
    $Self->{'Ticket::Frontend::CustomerInfoQueueMaxSize'} = 18;

    # --------------------------------------------------- #
    # Ticket Agent Interface
    # --------------------------------------------------- #
    # Ticket::Frontend::NoEscalationGroup
    # (don't show escalated tickets in frontend for agents who are writable
    # in this group)
    $Self->{'Ticket::Frontend::NoEscalationGroup'} = 'some_group';

    # Ticket::Frontend::QueueMaxShown
    # (max shown ticket in queue view)
    $Self->{'Ticket::Frontend::QueueMaxShown'} = 1200;

    # Ticket::Frontend::QueueSort
    # (sort a queue ascending or descending / after priority sort)
    #
    # assignment: QueueID -> Value
    # where value is one of:
    # 0: ascending (oldest on top, default)
    # 1: descending (youngest on top)
    #
#    $Self->{'Ticket::Frontend::QueueSort'} = {
#        7 => 1,
#        3 => 0,
#    };

    # Ticket::Frontend::AccountTime
    # (add time accounting)
    $Self->{'Ticket::Frontend::AccountTime'} = 1;

    # Ticket::Frontend::TimeUnits
    # (your choice of your used time units, minutes, hours, work units, ...)
#    $Self->{'Ticket::Frontend::TimeUnits'} = ' (minutes)';
#    $Self->{'Ticket::Frontend::TimeUnits'} = ' (hours)';
    $Self->{'Ticket::Frontend::TimeUnits'} = ' (work units)';

    # Ticket::Frontend::NeedAccountedTime
    # (time must be accounted)
    $Self->{'Ticket::Frontend::NeedAccountedTime'} = 0;

    # Ticket::Frontend::NeedSpellCheck
    # (compose message must be spell checked)
    $Self->{'Ticket::Frontend::NeedSpellCheck'} = 0;

    # Ticket::Frontend::BulkFeature
    # (a agent frontend feature to work on more then one ticket
    # at on time)
    $Self->{'Ticket::Frontend::BulkFeature'} = 1;

    # Ticket::Frontend::BulkFeatureJavaScriptAlert
    # (enable/disable java script popup if a bulk ticket is selected)
    $Self->{'Ticket::Frontend::BulkFeatureJavaScriptAlert'} = 1;

    # Ticket::Frontend::MoveType
    # (Show form drop down of show new page of new queues) [form|link]
    $Self->{'Ticket::Frontend::MoveType'} = 'form';

    # Ticket::Frontend::MoveSetState
    # (Set ticket state by move)
    $Self->{'Ticket::Frontend::MoveSetState'} = 1;

    # Ticket::DefaultNextMoveStateType
    # possible next states after a ticket is moved
    $Self->{'Ticket::DefaultNextMoveStateType'} = ['open', 'closed'];

    # Ticket::Frontend::QueueSortBy::Default
    # (Queue sort by default.)
    $Self->{"Ticket::Frontend::QueueSortBy::Default"} = 'Age';

    # Ticket::Frontend::QueueOrder::Default
    # (Queue order default.)
    $Self->{"Ticket::Frontend::QueueOrder::Default"} = 'Up';

    # Ticket::Frontend::MailboxSortBy::Default
    # (Mailbox sort by default.)
    $Self->{"Ticket::Frontend::MailboxSortBy::Default"} = 'Age';

    # Ticket::Frontend::MailboxOrder::Default
    # (Mailbox order default.)
    $Self->{"Ticket::Frontend::MailboxOrder::Default"} = 'Up';

    # Ticket::Frontend::StatusView
    # (shows all open tickets)
    $Self->{'Ticket::Frontend::StatusView::ViewableTicketsPage'} = 50;

    # Ticket::Frontend::SearchLimit
    # default limit for ticket search
    # [default: 5000]
    $Self->{'Ticket::Frontend::SearchLimit'} = 5000;

    # Ticket::Frontend::SearchPageShown
    # defaut of shown article a page
    # [default: 15]
    $Self->{'Ticket::Frontend::SearchPageShown'} = 40;

    # Ticket::Frontend::SearchViewableTicketLines
    # viewable ticket lines by search util
    # [default: 10]
    $Self->{'Ticket::Frontend::SearchViewableTicketLines'} = 10;

    # Ticket::Frontend::SortBy::Default
    # Search result sort by default.
    # (Age, Subject, Ticket, Queue, TicketFreeTime1-2, TicketFreeKey1-8, TicketFreeText1-8, ...)
    $Self->{'Ticket::Frontend::SortBy::Default'} = 'Age';

    # Ticket::Frontend::Order::Default
    # Search result order default.
    # (Down|Up)
    $Self->{'Ticket::Frontend::Order::Default'} = 'Down';

    # Ticket::Frontend::SearchArticleCSVTree
    # export also whole article tree in search result export
    # (take care of your performance!)
    # [default: 0]
    $Self->{'Ticket::Frontend::SearchArticleCSVTree'} = 0;

    # Ticket::Frontend::SearchCSVData
    # (used csv data)
    $Self->{'Ticket::Frontend::SearchCSVData'} = ['TicketNumber','Age','Created','State','Priority','Queue','Lock','Owner','UserFirstname','UserLastname','CustomerID','CustomerName','From','Subject','AccountedTime','TicketFreeKey1','TicketFreeText1','TicketFreeKey2','TicketFreeText2','TicketFreeKey3','TicketFreeText3','TicketFreeKey4','TicketFreeText4','TicketFreeKey5','TicketFreeText5','TicketFreeKey6','TicketFreeText6','TicketFreeKey7','TicketFreeText7','TicketFreeKey8','TicketFreeText8', 'TicketFreeTime1', 'TicketFreeTime2', 'ArticleTree',''];

    # Ticket::Frontend::Search::DB::*
    # (if you want to use a mirror database for agent ticket fulltext search)
#    $Self->{'Ticket::Frontend::Search::DB::DSN'} = "DBI:mysql:database=mirrordb;host=mirrordbhost";
#    $Self->{'Ticket::Frontend::Search::DB::User'} = "some_user";
#    $Self->{'Ticket::Frontend::Search::DB::Password'} = "some_password";

    # Ticket::AgentCanBeCustomer
    # (use this if an agent can also be a customer via the agent interface)
    $Self->{'Ticket::AgentCanBeCustomer'} = 0;

    # --------------------------------------------------- #
    # Ticket Frontend Phone stuff
    # --------------------------------------------------- #
    # default note type
    $Self->{'Ticket::Frontend::PhoneArticleType'} = 'phone';
    $Self->{'Ticket::Frontend::PhoneSenderType'} = 'agent';
    # default note subject
    $Self->{'Ticket::Frontend::PhoneSubject'} = '$Text{"Phone call at %s", "Time(DateFormatLong)"}';
    # default note text
    $Self->{'Ticket::Frontend::PhoneNote'} = '$Text{"Customer called"}';
    # next possible states after adding a phone note
    $Self->{'Ticket::PhoneDefaultNextStateType'} = ['open', 'pending auto', 'pending reminder', 'closed'];

    # default next state after adding a phone note
    $Self->{'Ticket::Frontend::PhoneNextState'} = 'closed successful';
    # default history type
    $Self->{'Ticket::Frontend::PhoneHistoryType'} = 'PhoneCallAgent';
    $Self->{'Ticket::Frontend::PhoneHistoryComment'} = '';

    # --------------------------------------------------- #
    # Ticket Frontend Phone Ticket stuff
    # --------------------------------------------------- #
    # default article type for a new phone ticket
    $Self->{'Ticket::Frontend::PhoneNewArticleType'} = 'phone';
    $Self->{'Ticket::Frontend::PhoneNewSenderType'} = 'customer';
    # default subject for a new phone ticket
#    $Self->{'Ticket::Frontend::PhoneNewSubject'} = '$Text{"Phone call at %s", "Time(DateFormatLong)"}';
    $Self->{'Ticket::Frontend::PhoneNewSubject'} = '';
    # default text for a new phone ticket
#    $Self->{'Ticket::Frontend::PhoneNewNote'} = 'New ticket via call.';
    $Self->{'Ticket::Frontend::PhoneNewNote'} = '';
    # default next state for a new phone ticket [default: open]
    $Self->{'Ticket::Frontend::PhoneNewNextState'} = 'open';
    # Max. shown customer history tickets in phone-ticket mask.
    $Self->{'Ticket::Frontend::PhoneNewShownCustomerTickets'} = 10;
    # default priority for a new phone ticket [default: 3 normal]
    $Self->{'Ticket::Frontend::PhonePriority'} = '3 normal';
    # default history type for a new phone ticket
    $Self->{'Ticket::Frontend::PhoneNewHistoryType'} = 'PhoneCallCustomer';
    $Self->{'Ticket::Frontend::PhoneNewHistoryComment'} = '';

    # Ticket::Frontend::NewOwnerSelection
    # (show owner selection in phone and email ticket
    $Self->{'Ticket::Frontend::NewOwnerSelection'} = 1;

    # Ticket::Frontend::NewQueueSelectionType
    # (To: section type. Queue => show all queues, SystemAddress => show all system
    # addresses;) [Queue|SystemAddress]
    $Self->{'Ticket::Frontend::NewQueueSelectionType'} = 'Queue';
#    $Self->{'Ticket::Frontend::NewQueueSelectionType'} = 'SystemAddress';

    # Ticket::Frontend::NewQueueSelectionString
    # (String for To: selection.)
    # use this for NewQueueSelectionType = Queue
#   $Self->{'Ticket::Frontend::NewQueueSelectionString'} = 'Queue: <Queue> - <QueueComment>';
   $Self->{'Ticket::Frontend::NewQueueSelectionString'} = '<Queue>';
    # use this for NewQueueSelectionType = SystemAddress
#    $Self->{'Ticket::Frontend::NewQueueSelectionString'} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';
#    $Self->{'Ticket::Frontend::NewQueueSelectionString'} = '<Realname> <<Email>> - Queue: <Queue>';

    # Ticket::Frontend::NewQueueOwnSelection
    # (If this is in use, "just this selection is valid" for the PhoneView.)
#    $Self->{'Ticket::Frontend::NewQueueOwnSelection'} = {
#        # QueueID => String
#        '1' => 'First Queue!',
#        '2' => 'Second Queue!',
#    };

    # --------------------------------------------------- #
    # Ticket Frontend Email Ticket stuff
    # --------------------------------------------------- #
    # Ticket::Frontend::EmailPriority
    # default priority for new email tickets [default: 3 normal]
    $Self->{'Ticket::Frontend::EmailPriority'} = '3 normal';

    # Ticket::Frontend::EmailNewArticleType
    # default article type for new email tickets
    $Self->{'Ticket::Frontend::EmailNewArticleType'} = 'email-external';
    # Ticket::Frontend::EmailNewSenderType
    # default sender type for new email tickets
    $Self->{'Ticket::Frontend::EmailNewSenderType'} = 'agent';

    # default history type for new email tickets
    $Self->{'Ticket::Frontend::EmailNewHistoryType'} = 'EmailAgent';

    # default history comment for new email tickets
    $Self->{'Ticket::Frontend::EmailNewHistoryComment'} = '';

    # default text for new email tickets
    $Self->{'Ticket::Frontend::EmailNewNote'} = '';

    # next possible states after an email ticket
    $Self->{'Ticket::EmailDefaultNextStateType'} = ['open', 'pending auto', 'pending reminder', 'closed'];

    # default next state after an email ticket
    $Self->{'Ticket::Frontend::EmailNewNextState'} = 'open';

    # Max. shown customer history tickets in email-ticket mask.
    $Self->{'Ticket::Frontend::EmailNewShownCustomerTickets'} = 10;

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Note stuff
    # --------------------------------------------------- #
    # Ticket::Frontend::NoteSetState
    # (possible to set ticket state via AgentTicketNote)
    $Self->{'Ticket::Frontend::NoteSetState'} = 0;

    # Ticket::Frontend::NoteInformInvolvedAgent
    # (show selection about involved agents)
    $Self->{'Ticket::Frontend::NoteInformInvolvedAgent'} = 0;

    # Ticket::Frontend::NoteInformAgent
    # (show selection about agents to inform)
    $Self->{'Ticket::Frontend::NoteInformAgent'} = 0;

    # Ticket::DefaultNextNoteStateType
    # (default nextstates after adding a note)
    $Self->{'Ticket::DefaultNextNoteStateType'} = ['new', 'open', 'closed'];

    # Ticket::Frontend::NoteType
    # (default note type)
    $Self->{'Ticket::Frontend::NoteType'} = 'note-internal';
    $Self->{'Ticket::Frontend::NoteTypes'} = {
        'note-internal' => 1,
        'note-external' => 0,
        'note-report' => 0,
    };

    # Ticket::Frontend::NoteSubject
    # (default note subject)
    $Self->{'Ticket::Frontend::NoteSubject'} = '$Text{"Note"}!';

    # Ticket::Frontend::NoteText
    # (default note text)
    $Self->{'Ticket::Frontend::NoteText'} = '';

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Owner stuff
    # --------------------------------------------------- #
    # Ticket::Frontend::OwnerSetState
    # (possible to set ticket state via AgentTicketOwner)
    $Self->{'Ticket::Frontend::OwnerSetState'} = 0;

    # Ticket::DefaultNextOwnerStateType
    # (default next states after new owner selection)
    $Self->{'Ticket::DefaultNextOwnerStateType'} = ['open', 'closed'];

    # Ticket::Frontend::OwnerSubject
    # (default owner subject)
    $Self->{'Ticket::Frontend::OwnerSubject'} = '$Text{"Owner Update"}';

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Pending stuff
    # --------------------------------------------------- #
    # Ticket::Frontend::PendingSubject
    $Self->{'Ticket::Frontend::PendingSubject'} = '$Text{"Pending"}!';
    # Ticket::Frontend::PendingText
    $Self->{'Ticket::Frontend::PendingText'} = '';
    # Ticket::Frontend::PendingState
    $Self->{'Ticket::Frontend::PendingState'} = 'pending reminder';
    # next possible states for pending screen
    $Self->{'Ticket::DefaultPendingNextStateType'} = ['pending reminder', 'pending auto'];
    # default note type for pending note
    $Self->{'Ticket::Frontend::PendingNoteType'} = 'note-internal';

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Close stuff
    # --------------------------------------------------- #
    # Ticket::Frontend::CloseNoteType
    $Self->{'Ticket::Frontend::CloseNoteType'} = 'note-internal';
    # Ticket::Frontend::CloseSubject
    $Self->{'Ticket::Frontend::CloseSubject'} = '$Text{"Close"}!';
    # Ticket::Frontend::CloseText
    $Self->{'Ticket::Frontend::CloseText'} = '';
    # Ticket::Frontend::CloseState
    $Self->{'Ticket::Frontend::CloseState'} = 'closed successful';
    # next possible states for close screen
    $Self->{'Ticket::DefaultCloseNextStateType'} = ['closed'];

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Compose stuff
    # --------------------------------------------------- #
    # default next state after a ticket is composed, answered, e.g.
    $Self->{'Ticket::DefaultNextComposeType'} = 'open';
    # next possible states after composing / answering a ticket
    $Self->{'Ticket::DefaultNextComposeStateType'} = ['open', 'closed', 'pending auto', 'pending reminder'];
    # unix_style
    $Self->{'Ticket::Frontend::ResponseFormat'} = '$Data{"Salutation"}
$Data{"OrigFrom"} $Text{"wrote"}:
$Data{"Body"}

$Data{"StdResponse"}

$Data{"Signature"}
';
    # ms_style
#    $Self->{'Ticket::Frontend::ResponseFormat'} = '$Data{"Salutation"}
#
#$Data{"StdResponse"}
#
#$Data{"Signature"}
#
#$Data{"OrigFrom"} $Text{"wrote"}:
#$Data{"Body"}
#';

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Bounce stuff
    # --------------------------------------------------- #
    # default next state after bouncing a ticket
    $Self->{'Ticket::Frontend::BounceState'} = 'closed successful';
    # next possible states when a ticket is bounced
    $Self->{'Ticket::DefaultNextBounceStateType'} = ['open', 'closed'];
    # default note text
    $Self->{'Ticket::Frontend::BounceText'} = 'Your email with ticket number "<OTRS_TICKET>" '.
      'is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.';

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Merge stuff
    # --------------------------------------------------- #
    $Self->{'Ticket::Frontend::MergeText'} = 'Your email with ticket number "<OTRS_TICKET>" '.
      'is merged to "<OTRS_MERGE_TO_TICKET>".';

    # --------------------------------------------------- #
    # Ticket Frontend Ticket Forward stuff
    # --------------------------------------------------- #
    # next possible states when forwarding a ticket
    $Self->{'Ticket::DefaultNextForwardStateType'} = ['open', 'closed'];
    # possible email type
    $Self->{'Ticket::Frontend::ForwardArticleTypes'} = [
        'email-external',
        'email-internal',
    ];
    $Self->{'Ticket::Frontend::ForwardArticleType'} = 'email-external';


    # --------------------------------------------------- #
    # Ticket stuff                                        #
    # (Viewable tickets in queue view)                    #
    # --------------------------------------------------- #
    # Ticket::ViewableSenderTypes
    #  default:  ["'customer'"]
    $Self->{'Ticket::ViewableSenderTypes'} = ["'customer'"];

    # Ticket::ViewableLocks
    # default: ["'unlock'", "'tmp_lock'"]
    $Self->{'Ticket::ViewableLocks'} = ["'unlock'", "'tmp_lock'"];

    # Ticket::ViewableStateType
    # (see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{'Ticket::ViewableStateType'} = ['new', 'open', 'pending reminder', 'pending auto'];

    # Ticket::UnlockStateType
    # (Tickets which can be unlocked by bin/UnlockTickets.pl
    # (see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{'Ticket::UnlockStateType'} = ['open', 'new'];

    # Ticket::PendingReminderStateType
    # (used for reminder notifications
    # see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{'Ticket::PendingReminderStateType'} = ['pending reminder'];

    # Ticket::PendingAutoStateType
    # (used for pending states which changed state after reached pending time
    # see http://yourhost/otrs/index.pl?Action=AdminState -> StateType)
    $Self->{'Ticket::PendingAutoStateType'} = ['pending auto'];

    # Ticket::StateAfterPending
    # (state after pending time has reached)
    $Self->{'Ticket::StateAfterPending'} = {
        'pending auto close+' => 'closed successful',
        'pending auto close-' => 'closed unsuccessful',
    };

    # --------------------------------------------------- #
    # external customer db settings                       #
    # --------------------------------------------------- #
#    $Self->{CustomerDBLink} = 'http://yourhost/customer.php?CID=$Data{"CustomerID"}';
    $Self->{CustomerDBLink} = '$Env{"CGIHandle"}?Action=AgentTicketCustomer&TicketID=$Data{"TicketID"}';
#    $Self->{CustomerDBLink} = '';
    $Self->{CustomerDBLinkTarget} = '';
#    $Self->{CustomerDBLinkTarget} = 'target="cdb"';

    # --------------------------------------------------- #
    # Ticket Stats
    # --------------------------------------------------- #
    # SystemStats
    $Self->{SystemStatsMap}->{"Ticket::Stats1"} = {
        Name => 'New Tickets',
        Module => 'Kernel::System::Stats::NewTickets',
        Desc => 'New created tickets for each queue in selected month.',
        SumCol => 1,
        SumRow => 1,
#        UseResultCache => 1,
#        Output => ['Print', 'CSV', 'GraphLine', 'GraphBars', 'GraphPie'],
        Output => ['Print', 'CSV', 'Graph'],
        OutputDefault => 'Print',
    };
    $Self->{SystemStatsMap}->{"Ticket::Stats2"} = {
        Name => 'Ticket Overview',
        Module => 'Kernel::System::Stats::TicketOverview',
        Desc => 'Overview of the tickets in queue at the end of this month.',
        SumCol => 1,
        SumRow => 1,
        UseResultCache => 1,
#        Output => ['Print', 'CSV', 'GraphLine', 'GraphBars', 'GraphPie'],
        Output => ['Print', 'CSV', 'Graph'],
        OutputDefault => 'Print',
    };
    $Self->{SystemStatsMap}->{"Ticket::Stats4"} = {
        Name => 'State Action Overview',
        Module => 'Kernel::System::Stats::StateAction',
        Desc => 'Trace system activities (Replacement of old bin/mkStats.pl).',
        SumCol => 1,
        SumRow => 1,
#        UseResultCache => 1,
#        Output => ['Print', 'CSV', 'GraphLine', 'GraphBars', 'GraphPie'],
        Output => ['Print', 'CSV', 'Graph'],
        OutputDefault => 'Graph',
    };

    $Self->{SystemStatsMap}->{"Ticket::Stats5"} = {
        Name => 'Time Accounting',
        Module => 'Kernel::System::Stats::AccountedTime',
        Desc => 'A list about accounted time per customer.',
#        UseResultCache => 1,
        Output => ['Print', 'CSV'],
        OutputDefault => 'Print',
    };

    # --------------------------------------------------- #
    # link object settings                                #
    # what objects are known by the system                #
    # --------------------------------------------------- #
    $Self->{'LinkObject'}->{'Ticket'} = {
        Name => 'Ticket Object',
        Type => 'Object',
        LinkObjects => ['Ticket', 'FAQ'],
    };

    # --------------------------------------------------- #
    # Framework NavBar Modules
    # --------------------------------------------------- #
    # agent interface notification module to check the used charset
    $Self->{'Frontend::NavBarModule'}->{'1-Ticket::LockedTickets'} = {
        Module => 'Kernel::Output::HTML::NavBarLockedTickets',
    };

    # agent interface notification module for bulk action
    $Self->{'Frontend::NavBarModule'}->{'2-Ticket::BulkAction'} = {
        Module => 'Kernel::Output::HTML::NavBarTicketBulkAction',
    };

    # --------------------------------------------------- #
    # Framework Notification Modules
    # --------------------------------------------------- #
    # agent interface set ticket to seen
    $Self->{'Frontend::NotifyModule'}->{'3-Ticket::AgentTicketSeen'} = {
        Module => 'Kernel::Output::HTML::NotificationAgentTicketSeen',
    };

    # agent interface notification module to show important agent tickets
    $Self->{'Frontend::NotifyModule'}->{'4-Ticket::TicketNotify'} = {
        Module => 'Kernel::Output::HTML::NotificationAgentTicket',
    };

    # --------------------------------------------------- #
    # Ticket::Frontend::Article View Modules
    # --------------------------------------------------- #
    # agent interface article notification module to check gpg
    $Self->{'Ticket::Frontend::ArticleViewModule'}->{'1-PGP'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckPGP',
    };
    # agent interface article notification module to check smime
    $Self->{'Ticket::Frontend::ArticleViewModule'}->{'1-SMIME'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckSMIME',
    };

    # --------------------------------------------------- #
    # Ticket::Frontend::Article PreView Modules
    # --------------------------------------------------- #
    # agent interface article notification module to check pgp
    $Self->{'Ticket::Frontend::ArticlePreViewModule'}->{'1-PGP'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckPGP',
    };
    # agent interface article notification module to check smime
    $Self->{'Ticket::Frontend::ArticlePreViewModule'}->{'1-SMIME'} = {
        Module => 'Kernel::Output::HTML::ArticleCheckSMIME',
    };

    # --------------------------------------------------- #
    # Ticket::Frontend::Article Compose Modules
    # --------------------------------------------------- #
    $Self->{'Ticket::Frontend::ArticleComposeModule'}->{'1-SignEmail'} = {
        Module => 'Kernel::Output::HTML::ArticleComposeSign',
    };
    $Self->{'Ticket::Frontend::ArticleComposeModule'}->{'2-CryptEmail'} = {
        Module => 'Kernel::Output::HTML::ArticleComposeCrypt',
    };

    # --------------------------------------------------- #
    # Ticket::Frontend::Article Attachment Modules
    # --------------------------------------------------- #
    # links in agent zoom for attachments to download
    $Self->{'Ticket::Frontend::ArticleAttachmentModule'}->{'1-Download'} = {
        Module => 'Kernel::Output::HTML::ArticleAttachmentDownload',
    };
    # links in agent zoom for attachments html online viewer
    $Self->{'Ticket::Frontend::ArticleAttachmentModule'}->{'2-HTML-Viewer'} = {
        Module => 'Kernel::Output::HTML::ArticleAttachmentHTMLViewer',
    };

    # --------------------------------------------------- #
    # Ticket::Frontend::Menu Modules
    # --------------------------------------------------- #
    # show back link
    $Self->{'Ticket::Frontend::MenuModule'}->{'000-Back'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Back',
        Description => 'Back',
        Action => '',
        Link => '$Env{"LastScreenOverview"}&TicketID=$QData{"TicketID"}',
    };
    # show lock/unlock link
    $Self->{'Ticket::Frontend::MenuModule'}->{'100-Lock'} = {
        Module => 'Kernel::Output::HTML::TicketMenuLock',
        Name => 'Lock',
        Action => 'AgentTicketLock',
    };
    # show history link
    $Self->{'Ticket::Frontend::MenuModule'}->{'200-History'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'History',
        Action => 'AgentTicketHistory',
        Description => 'Shows the ticket history!',
        Link => 'Action=AgentTicketHistory&TicketID=$QData{"TicketID"}',
    };
    # show print link
    $Self->{'Ticket::Frontend::MenuModule'}->{'210-Print'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Print',
        Action => 'AgentTicketPrint',
        Description => 'Print this ticket!',
        Link => 'Action=AgentTicketPrint&TicketID=$QData{"TicketID"}',
        LinkParam => 'target="print"',
    };
    # show priority link
    $Self->{'Ticket::Frontend::MenuModule'}->{'300-Priority'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Priority',
        Action => 'AgentTicketPriority',
        Description => 'Change the ticket priority!',
        Link => 'Action=AgentTicketPriority&TicketID=$QData{"TicketID"}',
    };
    # show free text link
    $Self->{'Ticket::Frontend::MenuModule'}->{'310-FreeText'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Free Fields',
        Action => 'AgentTicketFreeText',
        Description => 'Change the ticket free fields!',
        Link => 'Action=AgentTicketFreeText&TicketID=$QData{"TicketID"}',
    };
    # show link link
    $Self->{'Ticket::Frontend::MenuModule'}->{'320-Link'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Link',
        Action => 'AgentLinkObject',
        Description => 'Link this ticket to an other objects!',
        Link => 'Action=AgentLinkObject&SourceObject=Ticket&SourceID=$QData{"TicketID"}',
    };
    # show owner link
    $Self->{'Ticket::Frontend::MenuModule'}->{'400-Owner'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Owner',
        Action => 'AgentTicketOwner',
        Description => 'Change the ticket owner!',
        Link => 'Action=AgentTicketOwner&TicketID=$QData{"TicketID"}',
    };
    # show customer link
    $Self->{'Ticket::Frontend::MenuModule'}->{'410-Customer'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Customer',
        Action => 'AgentTicketCustomer',
        Description => 'Change the ticket customer!',
        Link => 'Action=AgentTicketCustomer&TicketID=$QData{"TicketID"}',
    };
    # show note link
    $Self->{'Ticket::Frontend::MenuModule'}->{'420-Note'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Note',
        Action => 'AgentTicketNote',
        Description => 'Add a note to this ticket!',
        Link => 'Action=AgentTicketNote&TicketID=$QData{"TicketID"}',
    };
    # show merge link
    $Self->{'Ticket::Frontend::MenuModule'}->{'430-Merge'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Merge',
        Action => 'AgentTicketMerge',
        Description => 'Merge this ticket!',
        Link => 'Action=AgentTicketMerge&TicketID=$QData{"TicketID"}',
    };
    # show pending link
    $Self->{'Ticket::Frontend::MenuModule'}->{'440-Pending'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Pending',
        Action => 'AgentTicketPending',
        Description => 'Set this ticket to pending!',
        Link => 'Action=AgentTicketPending&TicketID=$QData{"TicketID"}',
    };
    # show close link
    $Self->{'Ticket::Frontend::MenuModule'}->{'450-Close'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Close',
        Action => 'AgentTicketClose',
        Description => 'Close this ticket!',
        Link => 'Action=AgentTicketClose&TicketID=$QData{"TicketID"}',
    };

    # --------------------------------------------------- #
    # Ticket::Frontend::PreMenu Modules
    # --------------------------------------------------- #
    # show lock/unlock link
    $Self->{'Ticket::Frontend::PreMenuModule'}->{'100-Lock'} = {
        Module => 'Kernel::Output::HTML::TicketMenuLock',
        Name => 'Lock',
        Action => 'AgentTicketLock',
    };
    # show zoom link
    $Self->{'Ticket::Frontend::PreMenuModule'}->{'200-Zoom'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Zoom',
        Action => 'AgentTicketZoom',
        Description => 'Look into a ticket!',
        Link => 'Action=AgentTicketZoom&TicketID=$QData{"TicketID"}',
    };
    # show history link
    $Self->{'Ticket::Frontend::PreMenuModule'}->{'210-History'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'History',
        Action => 'AgentTicketHistory',
        Description => 'Shows the ticket history!',
        Link => 'Action=AgentTicketHistory&TicketID=$QData{"TicketID"}',
    };
    # show priority link
    $Self->{'Ticket::Frontend::PreMenuModule'}->{'300-Priority'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Priority',
        Action => 'AgentTicketPriority',
        Description => 'Change the ticket priority!',
        Link => 'Action=AgentTicketPriority&TicketID=$QData{"TicketID"}',
    };
    # show note link
    $Self->{'Ticket::Frontend::PreMenuModule'}->{'420-Note'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Note',
        Action => 'AgentTicketNote',
        Description => 'Add a note to this ticket!',
        Link => 'Action=AgentTicketNote&TicketID=$QData{"TicketID"}',
    };
    # show close link
    $Self->{'Ticket::Frontend::PreMenuModule'}->{'440-Close'} = {
        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
        Name => 'Close',
        Action => 'AgentTicketClose',
        Description => 'Close this ticket!',
        Link => 'Action=AgentTicketClose&TicketID=$QData{"TicketID"}',
    };
    # show delete link
#    $Self->{'Ticket::Frontend::PreMenuModule'}->{'450-Delete'} = {
#        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
#        Name => 'Delete',
#        Action => 'AgentTicketMove',
#        Description => 'Delete this ticket!',
#        Link => 'Action=AgentTicketMove&TicketID=$Data{"TicketID"}&DestQueue=Delete',
#    };
    # show spam link
#    $Self->{'Ticket::Frontend::PreMenuModule'}->{'460-Spam'} = {
#        Module => 'Kernel::Output::HTML::TicketMenuGeneric',
#        Name => 'Spam',
#        Action => 'AgentTicketMove',
#        Description => 'Marks as Spam!',
#        Link => 'Action=AgentTicketMove&TicketID=$Data{"TicketID"}&DestQueue=Spam',
#    };

    # --------------------------------------------------- #
    # Framework System Permissions
    # --------------------------------------------------- #
    $Self->{'System::Permission'} = ['ro', 'move_into', 'create', 'owner', 'priority', 'rw'];
#    $Self->{'System::Permission'} = ['ro', 'move_into', 'create', 'note', 'close', 'pending', 'owner', 'priority', 'customer', 'freetext', 'forward', 'bounce', 'move', 'rw'];

    # --------------------------------------------------- #
    # Ticket Agent Permissions
    # --------------------------------------------------- #
    # Module Name: 1-OwnerCheck
    # (if the current owner is already the user, grant access)
    $Self->{'Ticket::Permission'}->{'1-OwnerCheck'} = {
        Module => 'Kernel::System::Ticket::Permission::OwnerCheck',
        # if this check is needed
        Required => 0,
        # if this check is true, don't do more checks
        Granted => 0,
    };
    # Module Name: 2-GroupCheck
    # (if the user is in this group with type ro|rw|..., grant access)
    $Self->{'Ticket::Permission'}->{'2-GroupCheck'} = {
        Module => 'Kernel::System::Ticket::Permission::GroupCheck',
        # if this check is needed
        Required => 0,
        # if this check is true, don't do more checks
        Granted => 0,
    };

    # --------------------------------------------------- #
    # Ticket Customer Permissions
    # --------------------------------------------------- #
    # Module Name: 1-CustomerIDGroupCheck
    # (grant access, if customer id is the same and group is accessable)
    $Self->{'CustomerTicket::Permission'}->{'1-CustomerUserIDCheck'} = {
        Module => 'Kernel::System::Ticket::CustomerPermission::CustomerUserIDCheck',
        # if this check is needed
        Required => 0,
        # if this check is true, don't do more checks
        Granted => 1,
    };
    $Self->{'CustomerTicket::Permission'}->{'2-CustomerIDCheck'} = {
        Module => 'Kernel::System::Ticket::CustomerPermission::CustomerIDCheck',
        # if this check is needed
        Required => 1,
        # if this check is true, don't do more checks
        Granted => 0,
    };
    $Self->{'CustomerTicket::Permission'}->{'3-GroupCheck'} = {
        Module => 'Kernel::System::Ticket::CustomerPermission::GroupCheck',
        # if this check is needed
        Required => 1,
        # if this check is true, don't do more checks
        Granted => 0,
    };

    # --------------------------------------------------- #
    # Agent Preferences
    # --------------------------------------------------- #
    $Self->{PreferencesGroups}->{NewTicketNotify} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Mail Management',
        Label => 'New ticket notification',
        Desc => 'Send me a notification if there is a new ticket in "My Queues".',
        Data => {
            1 => 'Yes',
            0 => 'No',
        },
        PrefKey => 'UserSendNewTicketNotification',
        Prio => 1000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{FollowUpNotify} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Mail Management',
        Label => 'Follow up notification',
        Desc => "Send me a notification if a customer sends a follow up and I'm the owner of this ticket.",
        Data => {
#            2 => 'Always',
            1 => 'Yes',
            0 => 'No',
        },
        PrefKey => 'UserSendFollowUpNotification',
        Prio => 2000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{LockTimeoutNotify} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Mail Management',
        Label => 'Ticket lock timeout notification',
        Desc => 'Send me a notification if a ticket is unlocked by the system.',
        Data => {
            1 => 'Yes',
            0 => 'No',
        },
        Data => {
            1 => 'Yes',
            0 => 'No',
        },
        PrefKey => 'UserSendLockTimeoutNotification',
        Prio => 3000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{MoveNotify} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Mail Management',
        Label => 'Move notification',
        Desc => 'Send me a notification if a ticket is moved into one of "My Queues".',
        Data => {
            1 => 'Yes',
            0 => 'No',
        },
        PrefKey => 'UserSendMoveNotification',
        Prio => 4000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{CustomQueue} = {
        Module => 'Kernel::Output::HTML::PreferencesCustomQueue',
        Colum => 'Other Options',
        Label => 'My Queues',
        Desc => 'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.',
        Prio => 2000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{RefreshTime} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Frontend',
        Label => 'QueueView refresh time',
        Desc => 'Select your QueueView refresh time.',
        Data => {
            '' => 'off',
            2 => ' 2 minutes',
            5 => ' 5 minutes',
            7 => ' 7 minutes',
            10 => '10 minutes',
            15 => '15 minutes',
        },
        PrefKey => 'UserRefreshTime',
        Prio => 3000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{QueueView} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Frontend',
        Label => 'QueueView',
        Desc => 'Select your frontend QueueView.',
        Data => {
            AgentTicketQueueTicketView => 'Standard',
            AgentTicketQueueTicketViewLite => 'Lite',
        },
        DataSelected => 'AgentTicketQueueTicketView',
        Prio => 3000,
        PrefKey => 'UserQueueView',
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{QueueViewShownTickets} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Frontend',
        Label => 'Shown Tickets',
        Desc => 'Max. shown Tickets a page in QueueView.',
        Data => {
            10 => 10,
            15 => 15,
            20 => 20,
            25 => 25,
        },
        DataSelected => 15,
        PrefKey => 'UserQueueViewShowTickets',
        Prio => 4000,
        Activ => 1,
    };
    $Self->{PreferencesGroups}->{CreateNextMask} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Frontend',
        Label => 'Screen after new ticket',
        Desc => 'Select your screen after creating a new ticket.',
        Data => {
            '' => 'CreateTicket',
            AgentTicketZoom => 'TicketZoom',
        },
        DataSelected => '',
#        DataSelected => 'AgentTicketZoom',
        PrefKey => 'UserCreateNextMask',
        Prio => 5000,
        Activ => 1,
    };

    # --------------------------------------------------- #
    # Customer Frontend
    # --------------------------------------------------- #
    # CustomerNotifyJustToRealCustomer
    # (Send customer notifications just to mapped customer. Normally
    # if no customer is mapped, the latest customer sender gets the
    # notification.)
    $Self->{CustomerNotifyJustToRealCustomer} = 0;

    # CustomerPriority
    # (If the customer can set the ticket priority)
    $Self->{CustomerPriority} = 1;
    # CustomerDefaultPriority
    # (default priority of new customer tickets)
    $Self->{CustomerDefaultPriority} = '3 normal';

    # CustomerDefaultState
    # (default state of new customer tickets)
    $Self->{CustomerDefaultState} = 'new';

    # CustomerNextScreenAfterNewTicket
#    $Self->{CustomerNextScreenAfterNewTicket} = 'CustomerTicketZoom';
    $Self->{CustomerNextScreenAfterNewTicket} = 'CustomerTicketOverView';

    # --------------------------------------------------- #
    # customer message settings                           #
    # --------------------------------------------------- #
    # default note type
    $Self->{CustomerPanelArticleType} = 'webrequest';
    $Self->{CustomerPanelSenderType} = 'customer';
    # default history type
    $Self->{CustomerPanelHistoryType} = 'FollowUp';
    $Self->{CustomerPanelHistoryComment} = '';

    # default compose follow up next state
    $Self->{CustomerPanelDefaultNextComposeType} = 'open';
    $Self->{CustomerPanelNextComposeState} = 1;
    # next possible states for compose message
    $Self->{'Ticket::CustomerPanelDefaultNextComposeStateType'} = ['open', 'closed'];

    # default article type
    $Self->{CustomerPanelNewArticleType} = 'webrequest';
    $Self->{CustomerPanelNewSenderType} = 'customer';
    # default history type
    $Self->{CustomerPanelNewHistoryType} = 'WebRequestCustomer';
    $Self->{CustomerPanelNewHistoryComment} = '';

    # CustomerPanelSelectionType
    # (To: seection type. Queue => show all queues, SystemAddress => show all system
    # addresses;) [Queue|SystemAddress]
    $Self->{CustomerPanelSelectionType} = 'Queue';
#    $Self->{CustomerPanelSelectionType} = 'SystemAddress';

    # CustomerPanelSelectionString
    # (String for To: selection.)
    # use this for CustomerPanelSelectionType = Queue
#    $Self->{CustomerPanelSelectionString} = 'Queue: <Queue> - <QueueComment>';
    $Self->{CustomerPanelSelectionString} = '<Queue>';
    # use this for CustomerPanelSelectionType = SystemAddress
#    $Self->{CustomerPanelSelectionString} = '<Realname> <<Email>> - Queue: <Queue> - <QueueComment>';

    # CustomerPanelOwnSelection
    # (If this is in use, "just this selection is valid" for the CustomMessage.)
#    $Self->{CustomerPanelOwnSelection} = {
#        # Queue => Frontend-Name
#        'Junk' => 'First Queue!',
#        'Misc' => 'Second Queue!',
#        # QueueID => Frontend-Name (or optional with QueueID)
##        '1' => 'First Queue!',
##        '2' => 'Second Queue!',
#    };

    # CustomerPanel::NewTicketQueueSelectionModule
    # (own module layer for to selection in new ticket screen)
    $Self->{'CustomerPanel::NewTicketQueueSelectionModule'} = 'Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric';

    # Ticket::CustomerTicketSearch::SearchLimit
    # default limit for ticket search
    # [default: 5000]
    $Self->{'Ticket::CustomerTicketSearch::SearchLimit'} = 5000;

    # Ticket::CustomerTicketSearch::SearchPageShown
    # defaut of shown article a page
    # [default: 15]
    $Self->{'Ticket::CustomerTicketSearch::SearchPageShown'} = 40;

    # Ticket::CustomerTicketSearch::SortBy::Default
    # Search result sort by default.
    # (Age, Subject, Ticket, Queue, TicketFreeTime1-2, TicketFreeKey1-8, TicketFreeText1-8, ...)
    $Self->{'Ticket::CustomerTicketSearch::SortBy::Default'} = 'Age';

    # Ticket::CustomerTicketSearch::Order::Default
    # Search result order default.
    # (Down|Up)
    $Self->{'Ticket::CustomerTicketSearch::Order::Default'} = 'Down';


    # --------------------------------------------------- #
    # Customer Preferences
    # --------------------------------------------------- #
    $Self->{CustomerPreferencesGroups}->{ClosedTickets} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Other Options',
        Label => 'Closed Tickets',
        Desc => 'Show closed tickets.',
        Data => {
            1 => 'Yes',
            0 => 'No',
        },
        DataSelected => 1,
        PrefKey => 'UserShowClosedTickets',
        Prio => 2000,
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{ShownTickets} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Frontend',
        Label => 'Shown Tickets',
        Desc => 'Max. shown Tickets a page in Overview.',
        Data => {
            15 => 15,
            20 => 20,
            25 => 25,
            30 => 30,
        },
        DataSelected => 25,
        PrefKey => 'UserShowTickets',
        Prio => 4000,
        Activ => 1,
    };
    $Self->{CustomerPreferencesGroups}->{RefreshTime} = {
        Module => 'Kernel::Output::HTML::PreferencesGeneric',
        Colum => 'Frontend',
        Label => 'QueueView refresh time',
        Desc => 'Select your QueueView refresh time.',
        Data => {
            '' => 'off',
            2 => ' 2 minutes',
            5 => ' 5 minutes',
            7 => ' 7 minutes',
            10 => '10 minutes',
            15 => '15 minutes',
        },
        PrefKey => 'UserRefreshTime',
        Prio => 3000,
        Activ => 1,
    };

    # --------------------------------------------------- #
    # default core objects and params in frontend
    # --------------------------------------------------- #
    # key => module
    $Self->{'Frontend::CommonObject'}->{QueueObject} = 'Kernel::System::Queue';
    $Self->{'Frontend::CommonObject'}->{TicketObject} = 'Kernel::System::Ticket';
    # param => default value
    $Self->{'Frontend::CommonParam'}->{Action} = 'AgentTicketQueue';
    $Self->{'Frontend::CommonParam'}->{QueueID} = 0;
    $Self->{'Frontend::CommonParam'}->{TicketID} = '';

    # --------------------------------------------------- #
    # default core objects and params in customer frontend
    # --------------------------------------------------- #
    # key => module
    $Self->{'CustomerFrontend::CommonObject'}->{QueueObject} = 'Kernel::System::Queue';
    $Self->{'CustomerFrontend::CommonObject'}->{TicketObject} = 'Kernel::System::Ticket';
    # param => default value
    $Self->{'CustomerFrontend::CommonParam'}->{Action} = 'CustomerTicketOverView';
    $Self->{'CustomerFrontend::CommonParam'}->{QueueID} = 0;
    $Self->{'CustomerFrontend::CommonParam'}->{TicketID} = '';

    # --------------------------------------------------- #
    # Frontend Module Registry
    # --------------------------------------------------- #
    $Self->{'Frontend::Module'}->{'AgentTicketQueue'} = {
        Description => 'Overview of all open Tickets',
        Title => 'QueueView',
        NavBarName => 'Ticket',
        NavBar => [
          {
            Description => 'Overview of all open Tickets',
            Name => 'QueueView',
            Image => 'overview.png',
            Link => 'Action=AgentTicketQueue',
            NavBar => 'Ticket',
            Prio => 100,
            AccessKey => 'o',
          },
          {
            Description => 'Ticket-Area',
            Type => 'Menu',
            Block => 'ItemArea',
            Name => 'Ticket',
            Image => 'desktop.png',
            Link => 'Action=AgentTicketQueue',
            NavBar => 'Ticket',
            Prio => 200,
            AccessKey => 't',
          },
        ],
    };
    $Self->{'Frontend::Module'}->{'AgentTicketPhone'} = {
        Description => 'Create new Phone Ticket',
        Title => 'Phone-Ticket',
        NavBarName => 'Ticket',
        NavBar => [
          {
            Description => 'Create new Phone Ticket',
            Name => 'Phone-Ticket',
            Image => 'phone-new.png',
            Link => 'Action=AgentTicketPhone',
            NavBar => 'Ticket',
            Prio => 200,
            AccessKey => 'n',
          },
        ],
    };
    $Self->{'Frontend::Module'}->{'AgentTicketEmail'} = {
        Description => 'Create new Email Ticket',
        Title => 'Email-Ticket',
        NavBarName => 'Ticket',
        NavBar => [
          {
#            Description => 'Create new Email Ticket',
            Description => 'Send Email and create a new Ticket',
            Name => 'Email-Ticket',
            Image => 'mail_new.png',
            Link => 'Action=AgentTicketEmail',
            NavBar => 'Ticket',
            Prio => 210,
            AccessKey => 'e',
          },
        ],
    };
    $Self->{'Frontend::Module'}->{'AgentTicketSearch'} = {
        Description => 'Search Tickets',
        Title => 'Search',
        NavBarName => 'Ticket',
        NavBar => [
          {
            Description => 'Search Tickets',
            Name => 'Search',
            Image => 'search.png',
            Link => 'Action=AgentTicketSearch',
            NavBar => 'Ticket',
            Prio => 300,
            AccessKey => 's',
         },
       ],
    };
#    $Self->{'Frontend::Module'}->{'AgentTicketStatusView'} = {
#         Description => 'Overview of all open tickets',
#         Title => 'Status View',
#         NavBarName => 'Ticket',
#    };
    $Self->{'Frontend::Module'}->{'AgentTicketMailbox'} = {
        Description => 'Agent Mailbox',
        Title => 'Locked Tickets',
        NavBarName => 'Ticket',
    };
#    $Self->{'Frontend::Module'}->{'AgentTicketStatusView'} = {
#        Description => 'Overview of all open tickets',
#        Title => 'Status View',
#        NavBarName => 'Ticket',
#    };
    $Self->{'Frontend::Module'}->{'AgentZoom'} = {
        Description => 'compat module for Ticket Zoom',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketZoom'} = {
        Description => 'Ticket Zoom',
        Title => 'Zoom',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketAttachment'} = {
        Description => 'To download attachments',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketPlain'} = {
        Description => 'Ticket plain view of an email',
        Title => 'Plain',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketNote'} = {
        Description => 'Ticket Note',
        Title => 'Note',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketMerge'} = {
        Description => 'Ticket Merge',
        Title => 'Merge',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketPending'} = {
        Description => 'Ticket Pending',
        Title => 'Pending',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketPriority'} = {
        Description => 'Ticket Priority',
        Title => 'Priority',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketLock'} = {
        Description => 'Ticket Lock',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketMove'} = {
        Description => 'Ticket Move',
        Title => 'Move',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketHistory'} = {
        Description => 'Ticket History',
        Title => 'History',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketOwner'} = {
        Description => 'Ticket Owner',
        Title => 'Owner',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketCompose'} = {
        Description => 'Ticket Compose Email Answer',
        Title => 'Compose',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketCustomerFollowUp'} = {
        Description => 'Used if a agent can also be a customer',
        Title => 'Compose Follow up',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketBounce'} = {
        Description => 'Ticket Compose Bounce Email',
        Title => 'Bounce',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketForward'} = {
        Description => 'Ticket Forward Email',
        Title => 'Forward',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketCustomer'} = {
        Description => 'Ticket Customer',
        Title => 'Customer',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketClose'} = {
        Description => 'Ticket Close',
        Title => 'Close',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketFreeText'} = {
        Description => 'Ticket FreeText',
        Title => 'Free Fields',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketPrint'} = {
        Description => 'Ticket Print',
        Title => 'Print',
        NavBarName => 'Ticket',
    };
    $Self->{'Frontend::Module'}->{'AgentTicketBulk'} = {
        Description => 'Ticket bulk module',
        Title => 'Bulk-Action',
        NavBarName => 'Ticket',
    };

    $Self->{'Frontend::Module'}->{'AdminQueue'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Queue',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Queue',
            Block => 'Block2',
            Prio => 100,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminResponse'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Response',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Responses',
            Block => 'Block2',
            Prio => 200,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminQueueResponses'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Responses <-> Queue',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Responses <-> Queue',
            Block => 'Block2',
            Prio => 300,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminAutoResponse'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Auto Responses',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Auto Responses',
            Block => 'Block2',
            Prio => 400,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminQueueAutoResponse'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Auto Responses <-> Queue',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Auto Responses <-> Queue',
            Block => 'Block2',
            Prio => 500,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminAttachment'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Attachment',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Attachments',
            Block => 'Block2',
            Prio => 600,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminResponseAttachment'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Response <-> Queue',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Attachments <-> Responses',
            Block => 'Block2',
            Prio => 700,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminSalutation'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Salutation',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Salutations',
            Block => 'Block3',
            Prio => 100,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminSignature'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Signature',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Signatures',
            Block => 'Block3',
            Prio => 200,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminSystemAddress'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'System address',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Email Addresses',
            Block => 'Block3',
            Prio => 300,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminNotification'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'Notification',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Notifications',
            Block => 'Block3',
            Prio => 400,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminState'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'State',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'Status',
            Block => 'Block3',
            Prio => 700,
        },
    };
    $Self->{'Frontend::Module'}->{'AdminGenericAgent'} = {
        Group => ['admin'],
        Description => 'Admin',
        Title => 'GenericAgent',
        NavBarName => 'Admin',
        NavBarModule => {
            Module => 'Kernel::Output::HTML::NavBarModuleAdmin',
            Name => 'GenericAgent',
            Block => 'Block4',
            Prio => 300,
        },
    };

    # customer panel
    $Self->{'CustomerFrontend::Module'}->{'CustomerTicketOverView'} = {
        Description => 'Overview of customer tickets.',
        NavBarName => 'Ticket',
        Title => 'Overview',
        NavBar => [
          {
            Description => 'MyTickets',
            Name => 'MyTickets',
            Image => 'ticket.png',
            Link => 'Action=CustomerTicketOverView&Type=MyTickets',
            Prio => 110,
            AccessKey => 'm',
          },
          {
            Description => 'CompanyTickets',
            Name => 'CompanyTickets',
            Image => 'tickets.png',
            Link => 'Action=CustomerTicketOverView&Type=CompanyTickets',
            Prio => 120,
            AccessKey => 'c',
          },
        ],
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerTicketMessage'} = {
        Description => 'Create and updated tickets.',
        NavBarName => 'Ticket',
        Title => 'Message',
        NavBar => [
          {
            Description => 'Create new Ticket',
            Name => 'New Ticket',
            Image => 'new.png',
            Link => 'Action=CustomerTicketMessage',
            Prio => 100,
            AccessKey => 'n',
          },
        ],
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerTicketZoom'} = {
        Description => 'Ticket zoom view',
        NavBarName => 'Ticket',
        Title => 'Zoom',
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerZoom'} = {
        Description => 'compat mod',
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerTicketAttachment'} = {
        Description => 'To download attachments',
    };
    $Self->{'CustomerFrontend::Module'}->{'CustomerTicketSearch'} = {
        Description => 'Customer ticket search.',
        NavBarName => 'Ticket',
        Title => 'Search',
        NavBar => [
          {
            Description => 'Search',
            Name => 'Search',
            Image => 'search.png',
            Link => 'Action=CustomerTicketSearch',
            Prio => 300,
            AccessKey => 's',
          },
        ],
    };

    # Default Ticket Action ACL
    $Self->{'TicketACL::Default::Action'} = {};

1;
