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

use File::Path qw(mkpath rmtree);

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create test PGP path and set it in sysConfig.
        my $RandomID = $Helper->GetRandomID();
        my $PGPPath  = $ConfigObject->Get('Home') . "/var/tmp/pgp" . $RandomID;
        mkpath( [$PGPPath], 0, 0770 );    ## no critic

        # Enable PGP in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP',
            Value => 1,
        );

        # Set PGP path in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP::Options',
            Value => "--homedir $PGPPath --batch --no-tty --yes",
        );

        # Create test user and login.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminPGP screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPGP");

        for my $Key ( 4, 5 ) {

            # Add test PGP key.
            $Selenium->find_element("//a[contains(\@href, \'Action=AdminPGP;Subaction=Add' )]")->VerifiedClick();
            my $Location = $ConfigObject->Get('Home')
                . "/scripts/test/sample/Crypt/PGPPrivateKey-$Key.asc";

            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
        }

        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

        # Add system address.
        my $SystemAddressEmail    = 'pgptest@example.com';
        my $SystemAddressRealname = "$SystemAddressEmail, $RandomID";

        my %List = $SystemAddressObject->SystemAddressList(
            Valid => 0,
        );
        my $SystemAddressID;
        my $SystemAddressAdded = 0;
        if ( !grep { $_ =~ m/^$SystemAddressEmail$/ } values %List ) {

            $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
                Name     => $SystemAddressEmail,
                Realname => $SystemAddressRealname,
                ValidID  => 1,
                QueueID  => 1,
                Comment  => 'Some Comment',
                UserID   => 1,
            );
            $Self->True(
                $SystemAddressID,
                'SystemAddressAdd()',
            ) || die;
            $SystemAddressAdded = 1;
        }
        else {
            %List            = reverse %List;
            $SystemAddressID = $List{$SystemAddressEmail};
        }

        my $QueueName = 'TestQueue' . $RandomID;

        # Add new queue.
        my $QueueID = $QueueObject->QueueAdd(
            Name                => $QueueName,
            ValidID             => 1,
            GroupID             => 1,
            FirstResponseTime   => 0,
            FirstResponseNotify => 0,
            UpdateTime          => 0,
            UpdateNotify        => 0,
            SolutionTime        => 0,
            SolutionNotify      => 0,
            SystemAddressID     => $SystemAddressID,
            SalutationID        => 1,
            SignatureID         => 1,
            Comment             => 'Some Comment',
            UserID              => 1,
        );

        $Self->True(
            $QueueID,
            "QueueAdd() - $QueueName, $QueueID",
        );

        # Navigate to AgentTicketEmail screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        # Select test queue.
        my $Option = $Selenium->execute_script(
            "return \$('#Dest option').filter(function () { return \$(this).html() == '$QueueName'; }).val();"
        );
        $Selenium->InputFieldValueSet(
            Element => '#Dest',
            Value   => $Option,
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#EmailSecurityOptions").length && !$(".AJAXLoader:visible").length'
        );

        # Select
        $Selenium->InputFieldValueSet(
            Element => '#EmailSecurityOptions',
            Value   => "PGP::Sign::-",
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#SignKeyID").length && !$(".AJAXLoader:visible").length'
        );

        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#SignKeyID option:selected').text();"
        );

        $Option = $Selenium->execute_script(
            "return \$('#SignKeyID option:selected').text();"
        );

        $Self->False(
            index( $Option, 'WARNING: EXPIRED KEY' ) > -1,
            "Selected signing key is not expired",
        );

        $Option = $Selenium->execute_script(
            "return \$('#SignKeyID option:eq(2)').text();"
        );

        $Self->True(
            index( $Option, 'WARNING: EXPIRED KEY' ) > -1,
            "There is another signing, that is expired",
        );

        my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        # create ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Ticket One Title',
            QueueID      => $QueueID,
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'example.com',
            CustomerUser => 'customerOne@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );

        # sanity check
        $Self->True(
            $TicketID,
            "TicketCreate() successful for Ticket ID $TicketID",
        );

        my $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 1,
            SenderType           => 'customer',
            From                 => 'customerOne@example.com',
            To                   => 'Some Agent A <agent-a@example.com>',
            Subject              => 'some short description',
            Body                 => 'the message text',
            Charset              => 'utf8',
            MimeType             => 'text/plain',
            HistoryType          => 'OwnerUpdate',
            HistoryComment       => 'Some free text!',
            UserID               => $TestUserID,
        );

        # sanity check
        $Self->True(
            $ArticleID,
            "ArticleCreate() successful for Article ID $ArticleID",
        );

        my $CheckEmailSecurityOptions = sub {
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#EmailSecurityOptions").length && !$(".AJAXLoader:visible").length'
            );

            # Select EmailSecurityOptions
            $Selenium->InputFieldValueSet(
                Element => '#EmailSecurityOptions',
                Value   => "PGP::Sign::-",
            );

            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#SignKeyID").length && !$(".AJAXLoader:visible").length'
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return \$('#SignKeyID option:selected').text();"
            );

            $Option = $Selenium->execute_script(
                "return \$('#SignKeyID option:selected').text();"
            );

            $Self->True(
                index( $Option, $SystemAddressEmail ) > -1,
                "Signing key is selected",
            );
            return;
        };

        # Check EmailSecurityOptions, see bug#14963 for more information.
        # Navigate to AgentTicketForward screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketForward;TicketID=$TicketID;ArticleID=$ArticleID"
        );
        $CheckEmailSecurityOptions->();

        # Navigate to AgentTicketEmailOutbound screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmailOutbound;TicketID=$TicketID");
        $CheckEmailSecurityOptions->();

        # Navigate to AgentTicketCompose screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketCompose;TicketID=$TicketID;ArticleID=$ArticleID;ResponseID=1"
        );
        $CheckEmailSecurityOptions->();

        # Select EmailSecurityOptions
        $Selenium->InputFieldValueSet(
            Element => '#EmailSecurityOptions',
            Value   => "PGP::Sign::-",
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#SignKeyID").length && !$(".AJAXLoader:visible").length'
        );

        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#SignKeyID option:selected').text();"
        );

        $Option = $Selenium->execute_script(
            "return \$('#SignKeyID option:selected').text();"
        );

        $Self->True(
            index( $Option, $SystemAddressEmail ) > -1,
            "Signing key is selected",
        );

        # Navigate to AdminPGP screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPGP");

        # Delete test PGP keys.
        for my $Count ( 1 .. 2 ) {
            my @Keys = $Kernel::OM->Get('Kernel::System::Crypt::PGP')->KeySearch(
                Search => $SystemAddressEmail,
            );

            for my $Key (@Keys) {

                # Secure key should be deleted first.
                if ( $Key->{Type} eq 'sec' ) {

                    # Click on delete secure key and public key.
                    for my $Type (qw( sec pub )) {

                        $Selenium->find_element(
                            "//a[contains(\@href, \'Subaction=Delete;Type=$Type;Key=$Key->{FingerprintShort}' )]"
                        )->click();
                        sleep 1;

                        $Selenium->WaitFor( AlertPresent => 1 );
                        $Selenium->accept_alert();

                        $Selenium->WaitFor(
                            JavaScript =>
                                "return typeof(\$) === 'function' && \$('a[href*=\"Delete;Type=$Type;Key=$Key->{FingerprintShort}\"]').length == 0;"
                        );
                        $Selenium->VerifiedRefresh();

                        # Check if PGP key is deleted.
                        $Self->False(
                            $Selenium->execute_script(
                                "return \$('a[href*=\"Delete;Type=$Type;Key=$Key->{FingerprintShort}\"]').length;"
                            ),
                            "PGPKey $Type - $Key->{Identifier} deleted",
                        );

                    }
                }
            }
        }

        # Remove test PGP path.
        my $Success = rmtree( [$PGPPath] );
        $Self->True(
            $Success,
            "Directory deleted - '$PGPPath'",
        );

        # Clean up test data from the DB.
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
            "Ticket is deleted - ID $TicketID"
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$QueueID ],
        );
        $Self->True(
            $Success,
            "QueueID $QueueID is deleted",
        );

        if ($SystemAddressAdded) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM system_address WHERE id= $SystemAddressID",
            );
            $Self->True(
                $Success,
                "Deleted SystemAddress - $SystemAddressID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
    }

);

1;
