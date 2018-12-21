# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Disable PGP in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'PGP',
            Value => 0,
        );

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Create test PGP path and set it in sysConfig.
        my $PGPPath = $ConfigObject->Get('Home') . "/var/tmp/pgp";
        mkpath( [$PGPPath], 0, 0770 );    ## no critic

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminPGP screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPGP");

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Check widget sidebar when PGP sysconfig is disabled.
        $Self->True(
            $Selenium->find_element( 'h3 span.Warning', 'css' ),
            "Widget sidebar with warning message is displayed.",
        );
        $Self->True(
            $Selenium->find_element("//button[\@value='Enable it here!']"),
            "Button 'Enable it here!' to the PGP SysConfig is displayed.",
        );

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

        # Refresh AdminSPGP screen.
        $Selenium->VerifiedRefresh();

        for my $Key ( 4, 5 ) {

            # Add test PGP key.
            $Selenium->find_element("//a[contains(\@href, \'Action=AdminPGP;Subaction=Add' )]")->VerifiedClick();
            my $Location = $ConfigObject->Get('Home')
                . "/scripts/test/sample/Crypt/PGPPrivateKey-$Key.asc";

            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
        }

        # Check if test PGP keys show on AdminPGP screen.
        my $PGPIdentifier = 'pgptest@example.com';
        $Self->True(
            index( $Selenium->get_page_source(), $PGPIdentifier ) > -1,
            "Test PGP key found on page",
        ) || die;

        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

        # Add system address.
        my $RandomID              = $Helper->GetRandomID();
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

        $Self->True(
            $Option =~ m/WARNING: EXPIRED KEY/,
            "Selected signing key is expired",
        );

        # Set test PGP in config so we can delete them.
        $Helper->ConfigSettingChange(
            Key   => 'PGP',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Key   => 'PGP::Options',
            Value => "--homedir $PGPPath --batch --no-tty --yes",
        );

        # Navigate to AdminPGP screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPGP");

        # Delete test PGP keys.
        for my $Count ( 1 .. 2 ) {
            my @Keys = $Kernel::OM->Get('Kernel::System::Crypt::PGP')->KeySearch(
                Search => $PGPIdentifier,
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
    }

);

1;
