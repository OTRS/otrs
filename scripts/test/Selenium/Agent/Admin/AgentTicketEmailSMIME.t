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

        # Create directory for certificates and private keys.
        my $RandomID    = $Helper->GetRandomID();
        my $CertPath    = $ConfigObject->Get('Home') . "/var/tmp/certs$RandomID";
        my $PrivatePath = $ConfigObject->Get('Home') . "/var/tmp/private$RandomID";
        rmtree($CertPath);
        rmtree($PrivatePath);
        mkpath( [$CertPath],    0, 0770 );    ## no critic
        mkpath( [$PrivatePath], 0, 0770 );    ## no critic

        # Enable SMIME in config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME',
            Value => 1
        );

        # Set SMIME paths in sysConfig.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::CertPath',
            Value => $CertPath,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SMIME::PrivatePath',
            Value => $PrivatePath,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AdminSMIME screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSMIME");

        for my $Key ( 1 .. 3 ) {

            # Click 'Add certificate'.
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ShowAddCertificate' )]")->VerifiedClick();

            # Add certificate.
            my $CertLocation = $ConfigObject->Get('Home')
                . "/scripts/test/sample/SMIME/SMIMEtest3\@example.net-$Key.crt";

            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($CertLocation);
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

            # Click 'Add private key'.
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ShowAddPrivate' )]")->VerifiedClick();

            # Add private key.
            my $PrivateLocation = $ConfigObject->Get('Home')
                . "/scripts/test/sample/SMIME/SMIMEtest3\@example.net-$Key.key";

            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($PrivateLocation);
            $Selenium->find_element( "#Secret",     'css' )->send_keys("secret");
            $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();
        }

        my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
        my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

        # Add system address.
        my $SystemAddressEmail    = 'SMIMEtest3@example.net';
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

            # Set expired signing key as default.
            # See more information bug#14752.
            DefaultSignKey => 'SMIME::Detached::49e7495e.2',
            UserID         => 1,
        );

        $Self->True(
            $QueueID,
            "QueueAdd() - $QueueName, $QueueID",
        );

        # Navigate to AgentTicketEmail screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketEmail");

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#Dest").length;'
        );

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
                'return $("#EmailSecurityOptions").length && !$(".AJAXLoader:visible").length;'
        );

        # Select EmailSecurityOptions.
        $Selenium->InputFieldValueSet(
            Element => '#EmailSecurityOptions',
            Value   => "SMIME::Sign::-",
        );

        $Selenium->WaitFor(
            JavaScript =>
                'return $("#SignKeyID").length && !$(".AJAXLoader:visible").length;'
        );

        my @Options = (
            {
                Option   => 'WARNING: EXPIRED KEY',
                Selected => 0,
                Comment  => "expired, it is set as default in test queue",
            },
            {
                Option   => 'Feb 28 11:51:14 2030 GMT] SMIMEtest3@example.net',
                Selected => 0,
                Comment  => "valid, but not the longest valid certificate",
            },
            {
                Option   => 'Mar  7 11:52:01 2040 GMT] SMIMEtest3@example.net',
                Selected => 1,
                Comment  => "valid and the longest valid certificate",
            }
        );

        OPTION:
        for my $Option (@Options) {
            my $Text    = $Option->{Option};
            my $Comment = $Option->{Comment};

            $Self->True(
                $Selenium->execute_script(
                    "return \$('#SignKeyID option:contains(\"$Text\")').length;"
                ),
                "Found '$Text' - $Comment",
            );

            next OPTION if !$Option->{Selected};

            $Self->True(
                $Selenium->execute_script(
                    "return \$('#SignKeyID option:selected:contains(\"$Text\")').length;"
                ),
                "Selected key - '$Text' - $Comment",
            );
        }

        # Delete needed test directories.
        for my $Directory ( $CertPath, $PrivatePath ) {
            my $Success = File::Path::rmtree( [$Directory] );
            $Self->True(
                $Success,
                "Directory deleted - '$Directory'",
            );
        }
    }
);

1;
