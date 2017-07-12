# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
my $BackendObject      = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
my $TicketObject       = $Kernel::OM->Get('Kernel::System::Ticket');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

my @DynamicFieldsToAdd = (
    {
        Name       => 'Replace1' . $RandomID,
        Label      => 'a description',
        FieldOrder => 9998,
        FieldType  => 'Text',
        ObjectType => 'Ticket',
        Config     => {
            Name        => 'Replace1' . $RandomID,
            Description => 'Description for Dynamic Field.',
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    },
    {
        Name       => 'Replace2' . $RandomID,
        Label      => 'a description',
        FieldOrder => 9999,
        FieldType  => 'Dropdown',
        ObjectType => 'Ticket',
        Config     => {
            Name           => 'Replace2' . $RandomID,
            Description    => 'Description for Dynamic Field.',
            PossibleValues => {
                1 => 'A',
                2 => 'B',
                }
        },
        Reorder => 0,
        ValidID => 1,
        UserID  => 1,
    },
);

my %AddedDynamicFieldIds;
my %DynamicFieldConfigs;

for my $DynamicField (@DynamicFieldsToAdd) {

    my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
        %{$DynamicField},
    );
    $Self->IsNot(
        $DynamicFieldID,
        undef,
        'DynamicFieldAdd()',
    );

    # remember added DynamicFields
    $AddedDynamicFieldIds{$DynamicFieldID} = $DynamicField->{Name};

    my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
        Name => $DynamicField->{Name},
    );
    $Self->Is(
        ref $DynamicFieldConfig,
        'HASH',
        'DynamicFieldConfig must be a hash reference',
    );

    # remember the DF config
    $DynamicFieldConfigs{ $DynamicField->{FieldType} } = $DynamicFieldConfig;
}

# create template generator after the dynamic field are created as it gathers all DF in the
# constructor
my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

my $TestCustomerLogin = $Helper->TestCustomerUserCreate(
    Language => 'en',
);

my %TestCustomerData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
    User => $TestCustomerLogin,
);

my $TestUserLogin = $Helper->TestUserCreate(
    Language => 'en',
);

my %TestUser = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);

my $TestUser2Login = $Helper->TestUserCreate(
    Language => 'en',
);

my %TestUser2 = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);

my $TestUser3Login = $Helper->TestUserCreate(
    Language => 'en',
);

my %TestUser3 = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);

my $TestUser4Login = $Helper->TestUserCreate(
    Language => 'en',
);

my %TestUser4 = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);

my $TicketID = $TicketObject->TicketCreate(
    Title         => 'Some Ticket_Title',
    Queue         => 'Raw',
    Lock          => 'unlock',
    Priority      => '3 normal',
    State         => 'closed successful',
    CustomerNo    => '123465',
    CustomerUser  => $TestCustomerLogin,
    OwnerID       => $TestUser{UserID},
    ResponsibleID => $TestUser2{UserID},
    UserID        => $TestUser3{UserID},
);
$Self->IsNot(
    $TicketID,
    undef,
    'TicketCreate() TicketID',
);

my $Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfigs{Text},
    ObjectID           => $TicketID,
    Value              => 'otrs',
    UserID             => 1,
);
$Self->True(
    $Success,
    'DynamicField ValueSet() for Dynamic Field Text - with true',
);

$Success = $BackendObject->ValueSet(
    DynamicFieldConfig => $DynamicFieldConfigs{Dropdown},
    ObjectID           => $TicketID,
    Value              => 1,
    UserID             => 1,
);
$Self->True(
    $Success,
    'DynamicField ValueSet() Dynamic Field Dropdown - with true',
);

my $ArticleID = $TicketObject->ArticleCreate(
    TicketID       => $TicketID,
    ArticleType    => 'email-external',
    SenderType     => 'customer',
    Subject        => 'some short description',
    Body           => 'the message text',
    From           => $TestCustomerData{UserEmail},
    Charset        => 'ISO-8859-15',
    MimeType       => 'text/plain',
    HistoryType    => 'EmailCustomer',
    HistoryComment => 'Some free text!',
    UserID         => 1,
    NoAgentNotify  => 1,                              # if you don't want to send agent notifications
);
$Self->IsNot(
    $ArticleID,
    undef,
    'ArticleCreate() ArticleID',
);

my @Tests = (
    {
        Name => 'Simple replace',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_From>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'Simple replace, case insensitive',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_FROM>',
        Result   => 'Test test@home.com',
    },
    {
        Name => 'remove unknown tags',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_INVALID_TAG>',
        Result   => 'Test -',
    },
    {
        Name => 'OTRS customer subject',    # <OTRS_CUSTOMER_SUBJECT>
        Data => {
            From    => 'test@home.com',
            Subject => 'otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS customer subject 3 letters',    # <OTRS_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT[3]>',
        Result   => 'Test otr [...]',
    },
    {
        Name => 'OTRS customer subject 20 letters + garbarge',    # <OTRS_CUSTOMER_SUBJECT[20]>
        Data => {
            From    => 'test@home.com',
            Subject => 'RE: otrs',
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_SUBJECT[20]>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS responsible firstname',                     # <OTRS_RESPONSIBLE_UserFirstname>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_RESPONSIBLE_UserFirstname> <OTRS_RESPONSIBLE_nonexisting>',
        Result   => "Test $TestUser2{UserFirstname} -",
    },
    {
        Name => 'OTRS_TICKET_RESPONSIBLE firstname',              # <OTRS_RESPONSIBLE_UserFirstname>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_RESPONSIBLE_UserFirstname> <OTRS_TICKET_RESPONSIBLE_nonexisting>',
        Result   => "Test $TestUser2{UserFirstname} -",
    },
    {
        Name => 'OTRS owner firstname',                           # <OTRS_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_OWNER_UserFirstname> <OTRS_OWNER_nonexisting>',
        Result   => "Test $TestUser{UserFirstname} -",
    },
    {
        Name => 'OTRS_TICKET_OWNER firstname',                    # <OTRS_OWNER_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_OWNER_UserFirstname> <OTRS_TICKET_OWNER_nonexisting>',
        Result   => "Test $TestUser{UserFirstname} -",
    },
    {
        Name => 'OTRS current firstname',                         # <OTRS_CURRENT_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_nonexisting>',
        Result   => "Test $TestUser3{UserFirstname} -",
    },
    {
        Name => 'OTRS ticket ticketid',                           # <OTRS_TICKET_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_TicketID>',
        Result   => 'Test ' . $TicketID,
    },
    {
        Name => 'OTRS dynamic field (text)',                      # <OTRS_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace1' . $RandomID . '>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS dynamic field value (text)',                # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace1' . $RandomID . '_Value>',
        Result   => 'Test otrs',
    },
    {
        Name => 'OTRS dynamic field (Dropdown)',                  # <OTRS_TICKET_DynamicField_*>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace2' . $RandomID . '>',
        Result   => 'Test 1',
    },
    {
        Name => 'OTRS dynamic field value (Dropdown)',            # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_TICKET_DynamicField_Replace2' . $RandomID . '_Value>',
        Result   => 'Test A',
    },
    {
        Name     => 'OTRS config value',                          # <OTRS_CONFIG_*>
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CONFIG_DefaultTheme>',
        Result   => 'Test Standard',
    },
    {
        Name     => 'OTRS secret config values, must be masked (even unknown settings)',
        Data     => {},
        RichText => 0,
        Template =>
            'Test <OTRS_CONFIG_DatabasePw> <OTRS_CONFIG_Core::MirrorDB::Password> <OTRS_CONFIG_SomeOtherValue::Password> <OTRS_CONFIG_SomeOtherValue::Pw>',
        Result => 'Test xxx xxx xxx xxx',
    },
    {
        Name     => 'OTRS secret config value and normal config value',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CONFIG_DatabasePw> and <OTRS_CONFIG_DefaultTheme>',
        Result   => 'Test xxx and Standard',
    },
    {
        Name     => 'OTRS secret config values with numbers',
        Data     => {},
        RichText => 0,
        Template =>
            'Test <OTRS_CONFIG_AuthModule::LDAP::SearchUserPw1> and <OTRS_CONFIG_AuthModule::LDAP::SearchUserPassword1>',
        Result => 'Test xxx and xxx',
    },
    {
        Name => 'mailto-Links RichText enabled',
        Data => {
            From => 'test@home.com',
        },
        RichText => 1,
        Template =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E&amp;body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Body</a><br />',
        Result =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com&amp;body=From%3A%20test%40home.com">E-Mail mit Subject und Body</a><br /><br />mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com">E-Mail mit Subject</a><br /><br />mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20test%40home.com">E-Mail mit Body</a><br />',
    },
    {
        Name => 'mailto-Links',
        Data => {
            From => 'test@home.com',
        },
        RichText => 0,
        Template =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E&amp;body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20%3COTRS_CUSTOMER_From%3E">E-Mail mit Body</a><br />',
        Result =>
            'mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com&amp;body=From%3A%20test%40home.com">E-Mail mit Subject und Body</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?subject=From%3A%20test%40home.com">E-Mail mit Subject</a><br />
<br />
mailto-Link <a href="mailto:skywalker@otrs.org?body=From%3A%20test%40home.com">E-Mail mit Body</a><br />',
    },
    {
        Name => 'OTRS AGENT + CUSTOMER FROM',    # <OTRS_TICKET_DynamicField_*_Value>
        Data => {
            From => 'testcustomer@home.com',
        },
        DataAgent => {
            From => 'testagent@home.com',
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_From> - <OTRS_CUSTOMER_From>',
        Result   => 'Test testagent@home.com - testcustomer@home.com',
    },
    {
        Name =>
            'OTRS AGENT + CUSTOMER BODY',   # this is an special case, it sets the Body as it is since is the Data param
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_BODY> - <OTRS_CUSTOMER_BODY>',
        Result   => "Test Line1\nLine2\nLine3 - Line1\nLine2\nLine3",
    },
    {
        Name =>
            'OTRS AGENT + CUSTOMER BODY With RichText enabled'
        ,    # this is an special case, it sets the Body as it is since is the Data param
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 1,
        Template => 'Test &lt;OTRS_AGENT_BODY&gt; - &lt;OTRS_CUSTOMER_BODY&gt;',
        Result   => "Test Line1<br/>
Line2<br/>
Line3 - Line1<br/>
Line2<br/>
Line3",
    },
    {
        Name => 'OTRS AGENT + CUSTOMER BODY[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_BODY[2]> - <OTRS_CUSTOMER_BODY[2]>',
        Result   => "Test > Line1\n> Line2 - > Line1\n> Line2",
    },
    {
        Name => 'OTRS AGENT + CUSTOMER BODY[7] with RichText enabled',
        Data => {
            Body => "Line1\nLine2\nLine3\nLine4\nLine5\nLine6\nLine7\nLine8\nLine9",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3\nLine4\nLine5\nLine6\nLine7\nLine8\nLine9",
        },
        RichText => 1,
        Template => 'Test &lt;OTRS_AGENT_BODY[7]&gt; - &lt;OTRS_CUSTOMER_BODY[7]&gt;',
        Result =>
            'Test <div  type="cite" style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Line1<br/>
Line2<br/>
Line3<br/>
Line4<br/>
Line5<br/>
Line6<br/>
Line7</div> - <div  type="cite" style="border:none;border-left:solid blue 1.5pt;padding:0cm 0cm 0cm 4.0pt">Line1<br/>
Line2<br/>
Line3<br/>
Line4<br/>
Line5<br/>
Line6<br/>
Line7</div>',
    },
    {
        Name => 'OTRS AGENT + CUSTOMER EMAIL',    # EMAIL without [ ] does not exists
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_EMAIL> - <OTRS_CUSTOMER_EMAIL>',
        Result   => "Test - - -",
    },
    {
        Name => 'OTRS AGENT + CUSTOMER EMAIL[2]',
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        DataAgent => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_EMAIL[2]> - <OTRS_CUSTOMER_EMAIL[2]>',
        Result   => "Test > Line1\n> Line2 - > Line1\n> Line2",
    },
    {
        Name => 'OTRS COMMENT',    # EMAIL without [ ] does not exists
        Data => {
            Body => "Line1\nLine2\nLine3",
        },
        RichText => 0,
        Template => 'Test <OTRS_COMMENT>',
        Result   => "Test > Line1\n> Line2\n> Line3",
    },

    {
        Name => 'OTRS AGENT + CUSTOMER SUBJECT[2]',
        Data => {
            Subject => '0123456789'
        },
        DataAgent => {
            Subject => '987654321'
        },
        RichText => 0,
        Template => 'Test <OTRS_AGENT_SUBJECT[2]> - <OTRS_CUSTOMER_SUBJECT[2]>',
        Result   => "Test 98 [...] - 01 [...]",
    },
    {
        Name => 'OTRS CUSTOMER REALNAME',
        Data => {
            From => $TestCustomerData{UserEmail},
        },
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_REALNAME>',
        Result   => "Test $TestCustomerLogin $TestCustomerLogin",
    },
    {
        Name     => 'OTRS CUSTOMER DATA UserFirstname',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_CUSTOMER_DATA_UserFirstname>',
        Result   => "Test $TestCustomerLogin",
    },
    {
        Name     => 'OTRS <OTRS_NOTIFICATION_RECIPIENT_UserFullname>',
        Data     => {},
        RichText => 0,
        Template => 'Test <OTRS_NOTIFICATION_RECIPIENT_UserFullname> <OTRS_NOTIFICATION_RECIPIENT_nonexisting>',
        Result   => "Test $TestUser4{UserFullname} -",
    },
);

for my $Test (@Tests) {
    my $Result = $TemplateGeneratorObject->_Replace(
        Text        => $Test->{Template},
        Data        => $Test->{Data},
        DataAgent   => $Test->{DataAgent},
        RichText    => $Test->{RichText},
        TicketID    => $TicketID,
        UserID      => $TestUser3{UserID},
        RecipientID => $TestUser4{UserID},
    );
    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - _Replace()",
    );
}

# Cleanup is done by RestoreDatabase.

1;
