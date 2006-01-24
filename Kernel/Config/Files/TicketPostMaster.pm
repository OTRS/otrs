    # --------------------------------------------------- #
    #                                                     #
    #             Start of config options!!!              #
    #                 PostMaster stuff                    #
    #                                                     #
    # --------------------------------------------------- #

    # PostmasterMaxEmails
    # (Max post master daemon email to own email-address a day.
    # Loop-Protection!) [default: 40]
    $Self->{PostmasterMaxEmails} = 40;
    # PostMasterPOP3MaxSize
    # (max. email size)
    $Self->{PostMasterPOP3MaxEmailSize} = 1024 * 6;
    # PostMasterPOP3ReconnectMessage
    # (bin/PostMasterPOP3.pl will reconnect to pop3 host after n
    # messages)
    $Self->{PostMasterPOP3ReconnectMessage} = 20;
    # [Kernel::System::PostMaster::LoopProtection(FS|DB)] default is DB
    $Self->{LoopProtectionModule} = 'Kernel::System::PostMaster::LoopProtection::DB';
    # loop protection Log (just needed for FS module)
    $Self->{LoopProtectionLog} = '<OTRS_CONFIG_Home>/var/log/LoopProtection';

    # PostmasterAutoHTML2Text
    # (sould OTRS convert html email only to text?)
    $Self->{PostmasterAutoHTML2Text} = 1;

    # PostmasterFollowUpSearchInReferences
    # (If no ticket number in subject, otrs also looks in In-Reply-To
    # and References for follow up checks)
    $Self->{PostmasterFollowUpSearchInReferences} = 0;

    # PostmasterUserID
    # (The post master db-uid.) [default: 1]
    $Self->{PostmasterUserID} = 1;

    # PostmasterDefaultQueue
    # (The default queue of all.) [default: Raw]
    $Self->{PostmasterDefaultQueue} = 'Raw';

    # PostmasterDefaultPriority
    # (The default priority of new tickets.) [default: '3 normal']
    $Self->{PostmasterDefaultPriority} = '3 normal';

    # PostmasterDefaultState
    # (The default state of new tickets.) [default: new]
    $Self->{PostmasterDefaultState} = 'new';

    # PostmasterFollowUpState
    # (The state if a ticket got a follow up.) [default: open]
    $Self->{PostmasterFollowUpState} = 'open';

    # PostmasterFollowUpOnLockAgentNotifyOnlyToOwner
    # (Send agent follow up notification just to the owner if a
    # ticket is unlocked. Normally if a ticket is unlocked, the
    # agent follow up notification get to all agents) [default: 0]
    $Self->{PostmasterFollowUpOnUnlockAgentNotifyOnlyToOwner} = 0;

    # X-Header
    # (All scanned x-headers.)
    $Self->{'PostmasterX-Header'} = [
      'From',
      'To',
      'Cc',
      'Reply-To',
      'ReplyTo',
      'Subject',
      'Message-ID',
      'Message-Id',
      'Resent-To',
      'Resent-From',
      'Precedence',
      'Mailing-List',
      'List-Id',
      'List-Archive',
      'Errors-To',
      'References',
      'In-Reply-To',
      'X-Loop',
      'X-Spam-Flag',
      'X-Spam-Status',
      'X-Spam-Level',
      'X-No-Loop',
      'X-Priority',
      'Importance',
      'X-Mailer',
      'User-Agent',
      'Organization',
      'X-Original-To',
      'Delivered-To',
      'X-OTRS-Loop',
      'X-OTRS-Info',
      'X-OTRS-Priority',
      'X-OTRS-Queue',
      'X-OTRS-Ignore',
      'X-OTRS-State',
      'X-OTRS-CustomerNo',
      'X-OTRS-CustomerUser',
      'X-OTRS-ArticleKey1',
      'X-OTRS-ArticleKey2',
      'X-OTRS-ArticleKey3',
      'X-OTRS-ArticleValue1',
      'X-OTRS-ArticleValue2',
      'X-OTRS-ArticleValue3',
      'X-OTRS-SenderType',
      'X-OTRS-ArticleType',
      'X-OTRS-TicketKey1',
      'X-OTRS-TicketKey2',
      'X-OTRS-TicketKey3',
      'X-OTRS-TicketKey4',
      'X-OTRS-TicketKey5',
      'X-OTRS-TicketKey6',
      'X-OTRS-TicketKey7',
      'X-OTRS-TicketKey8',
      'X-OTRS-TicketValue1',
      'X-OTRS-TicketValue2',
      'X-OTRS-TicketValue3',
      'X-OTRS-TicketValue4',
      'X-OTRS-TicketValue5',
      'X-OTRS-TicketValue6',
      'X-OTRS-TicketValue7',
      'X-OTRS-TicketValue8',
    ];

    # --------------------------------------------------- #
    # PostMaster Filter Modules                           #
    # --------------------------------------------------- #
    # PostMaster::PreFilterModule
    # (filtering and manipulaiting of incoming emails)

    # Job Name: 1-Match
    # (block/ignore all spam email with From: noreply@)
#    $Self->{'PostMaster::PreFilterModule'}->{'1-Match'} = {
#        Module => 'Kernel::System::PostMaster::Filter::Match',
#        Match => {
#            From => 'noreply@',
#        },
#        Set => {
#            'X-OTRS-Ignore' => 'yes',
#        },
#    };
    # Job Name: 2-Match
    # (get a 4 digit number to ticket free text, use regex in Match
    # e. g. From => '(.+?)@.+?', and use () as [***] in Set =>)
#    $Self->{'PostMaster::PreFilterModule'}->{'2-Match'} = {
#        Module => 'Kernel::System::PostMaster::Filter::Match',
#        Match => {
#            Subject => 'SomeNumber:(\d\d\d\d)',
#        },
#        Set => {
#            'X-OTRS-TicketKey-1' => 'SomeNumber',
#            'X-OTRS-TicketValue-1' => '[***]',
#        },
#    };
    # Job Name: 5-SpamAssassin
    # (SpamAssassin example setup, ignore spam emails)
#    $Self->{'PostMaster::PreFilterModule'}->{'5-SpamAssassin'} = {
#        Module => 'Kernel::System::PostMaster::Filter::CMD',
#        CMD => '/usr/bin/spamassassin | grep -i "X-Spam-Status: yes"',
#        Set => {
#            'X-OTRS-Ignore' => 'yes',
#        },
#    };
    # (SpamAssassin example setup, move it to spam queue)
#    $Self->{'PostMaster::PreFilterModule'}->{'5-SpamAssassin'} = {
#        Module => 'Kernel::System::PostMaster::Filter::CMD',
#        CMD => '/usr/bin/spamassassin | grep -i "X-Spam-Status: yes"',
#        Set => {
#            'X-OTRS-Queue' => 'spam',
#        },
#    };
    # module to use database filter storage (use it at first)
    $Self->{'PostMaster::PreFilterModule'}->{'000-MatchDBSource'} = {
        Module => 'Kernel::System::PostMaster::Filter::MatchDBSource',
    };

    # Job Name: 6-AgentInterface
    # (a email agent interface)
#    $Self->{'PostMaster::PreFilterModule'}->{'999-AgentInterface'} = {
#        Module => 'Kernel::System::PostMaster::Filter::AgentInterface',
#        AgentInterfaceAddress => 'otrs-agent@example.org',
#    };
    # --------------------------------------------------- #
    # Auto Response                                       #
    # --------------------------------------------------- #

    # SendNoAutoResponseRegExp
    # (if this regexp is matching on senders From or ReplyTo, no
    # auto response will be sent)
    $Self->{SendNoAutoResponseRegExp} = '(MAILER-DAEMON|postmaster|abuse)@.+?\..+?';

1;
