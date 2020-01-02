# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper                 = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
        my $TicketObject           = $Kernel::OM->Get('Kernel::System::Ticket');
        my $QueueObject            = $Kernel::OM->Get('Kernel::System::Queue');
        my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
        my $DBObject               = $Kernel::OM->Get('Kernel::System::DB');
        my $XMLObject              = $Kernel::OM->Get('Kernel::System::XML');

        # Disable check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $RandomID              = $Helper->GetRandomID();
        my $CustomerUserTableName = "ut_$RandomID";
        my $CustomerCompanyName   = "Co-$RandomID";
        my $EmailAddress          = $RandomID . '@example.com';
        my $Success;

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test queue.
        my $QueueID = $QueueObject->QueueAdd(
            Name            => "Queue-$RandomID",
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Some comment',
            UserID          => $TestUserID,
        );
        $Self->True(
            $QueueID,
            "QueueID $QueueID is created",
        );

        # Create test template.
        my $TemplateID = $StandardTemplateObject->StandardTemplateAdd(
            Name         => "Template-$RandomID",
            Template     => "Template $RandomID",
            ContentType  => 'text/plain; charset=utf-8',
            TemplateType => 'Answer',
            ValidID      => 1,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TemplateID,
            "TemplateID $TemplateID is created",
        );

        # Create queue-template relation.
        $Success = $QueueObject->QueueStandardTemplateMemberAdd(
            QueueID            => $QueueID,
            StandardTemplateID => $TemplateID,
            Active             => 1,
            UserID             => $TestUserID,
        );
        $Self->True(
            $Success,
            "TemplateID '$TemplateID' is assigned to QueueID '$QueueID'",
        );

        # Create test customer company.
        my $CustomerCompanyID = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyAdd(
            CustomerID          => $CustomerCompanyName,
            CustomerCompanyName => $CustomerCompanyName,
            ValidID             => 1,
            UserID              => $TestUserID,
        );
        $Self->True(
            $CustomerCompanyID,
            "CustomerCompanyID $CustomerCompanyID is created",
        );

        # Create another customer user table.
        {
            my $XMLTable = '<Table Name="' . $CustomerUserTableName . '">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
                <Column Name="login" Required="true" Size="200" Type="VARCHAR"/>
                <Column Name="email" Required="true" Size="150" Type="VARCHAR"/>
                <Column Name="customer_id" Required="true" Size="150" Type="VARCHAR"/>
                <Column Name="pw" Required="false" Size="64" Type="VARCHAR"/>
                <Column Name="title" Required="false" Size="50" Type="VARCHAR"/>
                <Column Name="first_name" Required="true" Size="100" Type="VARCHAR"/>
                <Column Name="last_name" Required="true" Size="100" Type="VARCHAR"/>
                <Column Name="userSMIMECertificate" Required="false" Type="LONGBLOB"/>
                <Column Name="valid_id" Required="true" Type="SMALLINT"/>
                <Column Name="create_time" Required="true" Type="DATE"/>
                <Column Name="create_by" Required="true" Type="INTEGER"/>
                <Column Name="change_time" Required="true" Type="DATE"/>
                <Column Name="change_by" Required="true" Type="INTEGER"/>
            </Table>';

            my @XMLARRAY = $XMLObject->XMLParse(
                String => $XMLTable,
            );
            my @SQL = $DBObject->SQLProcessor(
                Database => \@XMLARRAY,
            );
            my @SQLPost = $DBObject->SQLProcessorPost(
                Database => \@XMLARRAY,
            );

            for my $SQL ( @SQL, @SQLPost ) {
                $Self->True(
                    $DBObject->Do( SQL => $SQL ),
                    "Customer user table '$CustomerUserTableName' is created",
                );
            }
        }

        # Set config for default customer user table ('CustomerUser').
        my $CustomerUserConfig = $ConfigObject->Get('CustomerUser');
        $CustomerUserConfig->{CustomerUserEmailUniqCheck} = 0;
        $ConfigObject->Set(
            Key   => 'CustomerUser',
            Value => $CustomerUserConfig,
        );

        # Set config for new customer user table ('CustomerUser10').
        my %CustomerUserConfig10 = (
            Name   => 'Database Backend 10',
            Module => 'Kernel::System::CustomerUser::DB',
            Params => {
                Table => $CustomerUserTableName,
            },
            ReadOnly => 0,

            # customer unique id
            CustomerKey => 'login',

            # customer #
            CustomerID                         => 'customer_id',
            CustomerUserListFields             => [ 'first_name', 'last_name', 'email' ],
            CustomerUserSearchFields           => [ 'login', 'first_name', 'last_name', 'customer_id' ],
            CustomerUserSearchPrefix           => '*',
            CustomerUserSearchSuffix           => '*',
            CustomerUserSearchListLimit        => 250,
            CustomerUserPostMasterSearchFields => ['email'],
            CustomerUserNameFields             => [ 'title', 'first_name', 'last_name' ],
            CustomerUserEmailUniqCheck         => 0,

            # show now own tickets in customer panel, CompanyTickets
            CustomerUserExcludePrimaryCustomerID => 0,

            # admin can't change customer preferences
            AdminSetPreferences => 0,

            # cache time to live in sec. - cache any ldap queries
            CacheTTL => 120,
            Map      => [

                # note: Login, Email and CustomerID are mandatory!
                # if you need additional attributes from AD, just map them here.
                # var, frontend, storage, shown (1=always,2=lite), required, storage-type, http-link, readonly
                [ 'UserSalutation', 'Title or salutation', 'title',       1, 0, 'var', '', 0 ],
                [ 'UserFirstname',  'Firstname',           'first_name',  1, 1, 'var', '', 0 ],
                [ 'UserLastname',   'Lastname',            'last_name',   1, 1, 'var', '', 0 ],
                [ 'UserLogin',      'Username',            'login',       1, 1, 'var', '', 0 ],
                [ 'UserPassword',   'Password',            'pw',          0, 0, 'var', '', 0 ],
                [ 'UserEmail',      'Email',               'email',       1, 1, 'var', '', 0 ],
                [ 'UserCustomerID', 'CustomerID',          'customer_id', 0, 1, 'var', '', 0 ],
                [ 'ValidID',        'Valid',               'valid_id',    0, 1, 'int', '', 0 ],
            ],
        );
        $ConfigObject->Set(
            Key   => 'CustomerUser10',
            Value => \%CustomerUserConfig10,
        );

        my @CustomerUserConfigs = (
            {
                Source        => 'CustomerUser',
                UserFirstname => "Firstname1-$RandomID",
                UserLastname  => "Lastname1-$RandomID",
                UserLogin     => "Login1-$RandomID",
                UserPassword  => "Login1-$RandomID",
                UserEmail     => $EmailAddress,
            },
            {
                Source        => 'CustomerUser',
                UserFirstname => "Firstname2-$RandomID",
                UserLastname  => "Lastname2-$RandomID",
                UserLogin     => "Login2-$RandomID",
                UserPassword  => "Login2-$RandomID",
                UserEmail     => $EmailAddress,
            },
            {
                Source        => 'CustomerUser10',
                UserFirstname => "Firstname3-$RandomID",
                UserLastname  => "Lastname3-$RandomID",
                UserLogin     => "Login3-$RandomID",
                UserPassword  => "Login3-$RandomID",
                UserEmail     => $EmailAddress,
            },
            {
                Source        => 'CustomerUser10',
                UserFirstname => "Firstname4-$RandomID",
                UserLastname  => "Lastname4-$RandomID",
                UserLogin     => "Login4-$RandomID",
                UserPassword  => "Login4-$RandomID",
                UserEmail     => $EmailAddress,
            },
            {
                Source        => 'CustomerUser',
                UserFirstname => "Firstname5-$RandomID",
                UserLastname  => "Lastname5-$RandomID",
                UserLogin     => "Login5-$RandomID",
                UserPassword  => "Login5-$RandomID",
                UserEmail     => $RandomID . '@example123.com',    # different email address
            },
        );

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my @CustomerUsers;

        for my $Config (@CustomerUserConfigs) {
            my $CustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
                Source         => $Config->{Source},
                UserFirstname  => $Config->{UserFirstname},
                UserLastname   => $Config->{UserLastname},
                UserLogin      => $Config->{UserLogin},
                UserPassword   => $Config->{UserPassword},
                UserEmail      => $Config->{UserEmail},
                UserCustomerID => $CustomerCompanyID,
                ValidID        => 1,
                UserID         => $TestUserID,
            );
            $Self->True(
                $CustomerUserLogin,
                "CustomerUserLogin $CustomerUserLogin is created",
            );

            my %Data = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUserLogin,
            );
            $Data{IsFound} = $Config->{IsFound};
            push @CustomerUsers, \%Data;
        }

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium ticket',
            QueueID      => $QueueID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => $CustomerCompanyID,
            CustomerUser => $CustomerUsers[1]->{UserLogin},
            OwnerID      => 1,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        my @Tests = (
            {
                From    => $CustomerUsers[1]->{UserMailString},
                WaitFor => 1,
            },
            {
                From    => $CustomerUsers[1]->{UserMailString} . ', ' . $CustomerUsers[3]->{UserMailString},
                WaitFor => 1,
            },
            {
                From    => $CustomerUsers[1]->{UserMailString} . ', ' . $CustomerUsers[4]->{UserMailString},
                WaitFor => 2,
            },
            {
                From => $CustomerUsers[0]->{UserMailString} . ', '
                    . $CustomerUsers[2]->{UserMailString} . ', '
                    . $CustomerUsers[4]->{UserMailString},
                WaitFor => 2,
            },
        );

        my $ArticleBackendObject
            = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel( ChannelName => 'Phone' );

        for my $Test (@Tests) {

            # Create test article.
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                SenderType           => 'customer',
                From                 => $Test->{From},
                To                   => 'Customer To <customer-to@example.com>',
                Subject              => "Subject $RandomID",
                Body                 => "Body $RandomID",
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'AddNote',
                HistoryComment       => 'Comment',
                UserID               => $TestUserID,
                IsVisibleForCustomer => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleID $ArticleID is created",
            );

            # Navigate to AgentTicketCompose screen.
            $Selenium->VerifiedGet(
                "${ScriptAlias}index.pl?Action=AgentTicketCompose;TicketID=$TicketID;ArticleID=$ArticleID;ReplyAll=;ResponseID=$TemplateID"
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#TicketCustomerContentToCustomer .CustomerQueue').length == $Test->{WaitFor};"
            );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#TicketCustomerContentToCustomer .CustomerQueue[value*=\"$EmailAddress\"]').length;"
                ),
                1,
                "Only one customer user email address '$EmailAddress' is found"
            );
        }

        # Delete test ticket.
        $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );
        }
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        # Delete test customer users.
        for my $CustomerUser (@CustomerUsers) {
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$CustomerUser->{UserLogin} ],
            );
            $Self->True(
                $Success,
                "Customer user '$CustomerUser->{UserLogin}' is deleted",
            );
        }

        # Delete standard template.
        $Success = $StandardTemplateObject->StandardTemplateDelete(
            ID => $TemplateID,
        );
        $Self->True(
            $Success,
            "TemplateID $TemplateID is deleted",
        );

        # Delete test queue.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$QueueID ],
        );
        $Self->True(
            $Success,
            "QueueID $QueueID is deleted",
        );

        # Set configs to original values.
        $CustomerUserConfig->{CustomerUserEmailUniqCheck} = 1;
        $ConfigObject->Set(
            Key   => 'CustomerUser',
            Value => $CustomerUserConfig,
        );
        $ConfigObject->Set(
            Key   => 'CustomerUser10',
            Value => undef,
        );

        # Drop the table.
        my $XML = "<TableDrop Name='$CustomerUserTableName'/>";

        my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
        my @SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
        $Self->True(
            $SQL[0],
            'SQLProcessor() DROP TABLE',
        );

        for my $SQL (@SQL) {
            $Self->True(
                $DBObject->Do( SQL => $SQL ) || 0,
                "Do() DROP TABLE ($SQL)",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(Ticket CustomerUser CustomerCompany)) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
