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

use IO::File;
use File::stat;

use Kernel::System::MailAccount::POP3;
use Kernel::System::MailAccount::IMAP;
use Kernel::System::PostMaster;

use vars (qw($Self));

# The tests presented here try to ensure that the communication-log entries
#   keep the correct status after some predefined situations.
#   Some 'magic' techniques are used so we could fake an IMAP/POP3 client/server connection environment:
#       - localizing variables
#       - local overwriting of package methods
#       - definition of inline packages
#       - autoload handler ( when the called method doesn't exist )

# This hash represents the fake environment for the IMAP/POP3, think about %ENV,
#   it'll work more or less the same way.
my %FakeClientEnv = (
    'connect'         => 1,
    'emails'          => {},
    'fail_fetch'      => {},
    'fail_postmaster' => 0,
);

# This inline package is the base for the IMAP/POP3 fake clients
#   and as you can see it uses the %FakeClientEnv.
#   This package uses autoload to handle undefined methods, and when
#   that happen, it'll check if the FakeClientEnv has an attribute with the same
#   name and returns it, otherwise always returns True to ensure that the code
#   that will use this object continues as everything is ok.
package FakeClient {    ## no critic
    our $AUTOLOAD;

    sub new {
        my $Class = shift;
        return bless( {}, $Class, );
    }

    sub AUTOLOAD {
        my $Self = shift;
        my ($Method) = ( $AUTOLOAD =~ m/::([^:]+)$/i );
        if ( !$Method || $Method eq 'DESTROY' ) {
            return;
        }

        return 1 if !( exists $FakeClientEnv{$Method} );
        return $FakeClientEnv{$Method};
    }

    sub get {
        my ( $Self, $Idx ) = @_;

        if ( $FakeClientEnv{'fail_fetch'}->{Messages}->{$Idx} ) {
            my $FailType = $FakeClientEnv{'fail_fetch'}->{Type} || '';
            die 'dummy exception' if $FailType eq 'exception';
            return;
        }

        my $Filename = $FakeClientEnv{'emails'}->{$Idx};

        my $FH    = IO::File->new( $Filename, 'r', );
        my @Lines = <$FH>;

        return wantarray ? @Lines : \@Lines;
    }

    sub delete {
        my ( $Self, $Idx ) = @_;

        delete $FakeClientEnv{'emails'}->{$Idx};

        return 1;
    }
}

no strict 'refs';    ## no critic

# Overwrite the OTRS MailAccount::IMAP connect method to use our fake imap client,
#   but make this change local to the unit test scope, as you can see, it also
#   makes use of the %FakeClientEnv.
local *{'Kernel::System::MailAccount::IMAP::Connect'} = sub {

    package FakeIMAPClient {    ## no critic
                                # Make this object extend the 'FakeClient' object,
                                #   we aren't using 'use parent' because the 'FakeClient' is also a
                                #   package defined in this test file, there's no pm file.
                                #   Another possible solution would be "use parent -norequire, 'FakeClient'".
        our @ISA = ('FakeClient');

        sub select {
            my $Self = shift;

            return scalar( keys %{ $FakeClientEnv{'emails'} } );
        }
    }

    if ( !$FakeClientEnv{'connect'} ) {
        return (
            Successful => 0,
            Message    => "can't connect",
        );
    }

    return (
        Successful => 1,
        IMAPObject => FakeIMAPClient->new(),
        Type       => 'IMAP',
    );
};

# Overwrite the OTRS MailAccount::POP3 connect method to use our fake pop3 client,
#   but make this change local to the unit test scope, as you can see, it also
#   makes use of the %FakeClientEnv.
local *{'Kernel::System::MailAccount::POP3::Connect'} = sub {

    package FakePOPClient {    ## no critic
                               # Make this object extend the 'FakeClient' object,
                               #   we aren't using 'use parent' because the 'FakeClient' is also a
                               #   package defined in this test file, there's no pm file.
                               #   Another possible solution would be "use parent -norequire, 'FakeClient'".
        our @ISA = ('FakeClient');

        sub list {
            my $Self = shift;

            return {
                map { $_ => 1, } keys( %{ $FakeClientEnv{'emails'} } )
            };
        }
    }

    if ( !$FakeClientEnv{'connect'} ) {
        return (
            Successful => 0,
            Message    => "can't connect",
        );
    }

    return (
        Successful => 1,
        PopObject  => FakePOPClient->new(),
        Type       => 'POP3',
        NOM        => scalar( keys %{ $FakeClientEnv{'emails'} } ),
    );
};

use strict 'refs';

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$HelperObject->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

$HelperObject->ConfigSettingChange(
    Key   => 'PostMasterReconnectMessage',
    Value => 100,
);

my $GetMailAcountLastCommunicationLog = sub {
    my %Param = @_;

    my $MailAccount = $Param{MailAccount};

    my $CommunicationLogDBObj = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog::DB',
    );
    my @MailAccountCommunicationLog = @{
        $CommunicationLogDBObj->CommunicationList(
            AccountType => $MailAccount->{Type},
            AccountID   => $MailAccount->{ID},
            )
            || []
    };

    @MailAccountCommunicationLog
        = sort { $b->{CommunicationID} <=> $a->{CommunicationID} } @MailAccountCommunicationLog;

    # Get all communication related objects.
    my $Objects = $CommunicationLogDBObj->ObjectLogList(
        CommunicationID => $MailAccountCommunicationLog[0]->{CommunicationID},
    );

    my $Connection = undef;
    my @Messages   = ();
    OBJECT:
    for my $Object ( @{$Objects} ) {

        if ( $Object->{ObjectLogType} eq 'Connection' ) {
            $Connection = $Object;
            next OBJECT;
        }

        push @Messages, $Object;
    }

    my %FailedMsgs = %{ $FakeClientEnv{'fail_fetch'}->{Messages} || {} };
    for my $Key ( sort keys %FailedMsgs ) {
        splice @Messages, $Key - 1, 0, undef;
    }

    return {
        Communication => $MailAccountCommunicationLog[0],
        Connection    => $Connection,
        Messages      => \@Messages,
    };

};

# Get postmaster sample emails.
my $OTRSDIR  = $Kernel::OM->Get('Kernel::Config')->Get('Home');
my @FileList = glob "${ OTRSDIR }/scripts/test/sample/PostMaster/*.box";
my %Emails   = ();

my $EmailIdx = 0;
for my $Item (@FileList) {
    $EmailIdx += 1;
    $Emails{$EmailIdx} = $Item;
}

# Type of emails accounts to test.
my @MailAccounts = (
    {
        Type => 'IMAP',
    },

    {
        Type => 'POP3',
    },
);

# Mail account base data.
my %MailAccountBaseData = (
    Login         => 'mail',
    Password      => 'SomePassword',
    Host          => 'mail.example.com',
    ValidID       => 1,
    Trusted       => 0,
    DispatchingBy => 'Queue',
    QueueID       => 1,
    UserID        => 1,
);

# Tests definition.
my @Tests = (

    {
        Name          => "Couldn't connect to server",
        FakeClientEnv => {
            'connect' => 0,
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Failed',
        },
    },

    {
        Name          => 'Some messages failed fetching',
        FakeClientEnv => {
            'connect'    => 1,
            'fail_fetch' => {
                Messages => {
                    10 => 1,
                    20 => 1,
                },
            },
            'emails' => {%Emails},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Failed',
            Message       => {
                -1 => 'Successful',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Some messages failed fetching with exception',
        FakeClientEnv => {
            'connect'    => 1,
            'fail_fetch' => {
                Type     => 'exception',
                Messages => {
                    5  => 1,
                    17 => 1,
                },
            },
            'emails' => {%Emails},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Failed',
            Message       => {
                -1 => 'Successful',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Messages failed processing',
        FakeClientEnv => {
            'connect'         => 1,
            'fail_postmaster' => 'error',
            'emails'          => {%Emails},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Successful',
            Message       => {
                -1 => 'Failed',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Messages process throw exception',
        FakeClientEnv => {
            'connect'         => 1,
            'fail_postmaster' => 'exception',
            'emails'          => {%Emails},
        },
        CommunicationLogStatus => {
            Communication => 'Failed',
            Connection    => 'Successful',
            Message       => {
                -1 => 'Failed',    # expected status for all messages
            },
        },
    },

    {
        Name          => 'Everything successfull',
        FakeClientEnv => {
            'connect' => 1,
            'emails'  => {%Emails},
        },
        CommunicationLogStatus => {
            Communication => 'Successful',
            Connection    => 'Successful',
            Message       => {
                -1 => 'Successful',    # expected status for all messages
            },
        },
    },
);

my $TestsStartedAt = $Kernel::OM->Create('Kernel::System::DateTime');
my $MaxChilds      = 1;
my $Childs         = 0;
for my $MailAccount (@MailAccounts) {

    # Set full mail-account data and create it in the database.
    for my $Key ( sort keys %MailAccountBaseData ) {
        $MailAccount->{$Key} = $MailAccountBaseData{$Key};
    }

    $MailAccount->{ID} = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountAdd(
        %{$MailAccount},
    );

    # Run the tests.
    TEST:
    for my $Test (@Tests) {
        my $TestBaseMessage = sprintf( '[%s], %s', $MailAccount->{Type}, $Test->{Name}, );

        # Set fake email type environment.
        my %TestFakeClientEnv = (
            %FakeClientEnv,
            %{ $Test->{FakeClientEnv} || {} },
        );

        # Because the test is run per email account type, and the email stack is changed during
        #   the run, we want to use a copy and not the original.
        my %TestEmails = %{ $TestFakeClientEnv{'emails'} };

        # Change the client environment according to the test,
        #   these changes are local to the current scope (the for).
        local $FakeClientEnv{'connect'}         = $TestFakeClientEnv{'connect'};
        local $FakeClientEnv{'emails'}          = \%TestEmails;
        local $FakeClientEnv{'fail_fetch'}      = $TestFakeClientEnv{'fail_fetch'};
        local $FakeClientEnv{'fail_postmaster'} = $TestFakeClientEnv{'fail_postmaster'};

        no strict 'refs';    ## no critic

        # Postfix if is required in next line to ensure right scope of function override.
        local *{'Kernel::System::PostMaster::Run'} = sub {
            if ( $TestFakeClientEnv{'fail_postmaster'} eq 'exception' ) {
                die "dummy exception";
            }

            return;
            }
            if $TestFakeClientEnv{'fail_postmaster'};
        use strict 'refs';

        # Run mail-account-fetch.
        my $Result = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountFetch( %{$MailAccount} );

        # Get last communication log for the mail-account.
        my $CommunicationLogData = $GetMailAcountLastCommunicationLog->(
            MailAccount => $MailAccount,
        );

        my %CommunicationLogStatus = %{ $Test->{CommunicationLogStatus} };

        $Self->True(
            $CommunicationLogData->{Communication}->{Status} eq $CommunicationLogStatus{Communication},
            sprintf( '%s, communication %s', $TestBaseMessage, $CommunicationLogStatus{Communication}, ),
        );
        $Self->True(
            $CommunicationLogData->{Connection}->{ObjectLogStatus} eq $CommunicationLogStatus{Connection},
            sprintf( '%s, connection %s', $TestBaseMessage, $CommunicationLogStatus{Connection}, ),
        );

        next TEST if !$CommunicationLogStatus{Message};

        # Check the messages status.

        my $MessageIdx = 0;
        MESSAGE:
        for my $Message ( @{ $CommunicationLogData->{Messages} } ) {
            $MessageIdx += 1;
            next MESSAGE if !$Message;

            my $ExpectedStatus = $CommunicationLogStatus{Message}->{-1};
            if ( $CommunicationLogStatus{Message}->{$MessageIdx} ) {
                $ExpectedStatus = $CommunicationLogStatus{Message}->{$MessageIdx};
            }

            $Self->True(
                $Message->{ObjectLogStatus} eq $ExpectedStatus,
                sprintf( '%s, message-%s %s', $TestBaseMessage, $MessageIdx, $ExpectedStatus, ),
            );
        }
    }
}

my $TestsStoppedAt = $Kernel::OM->Create('Kernel::System::DateTime');

# Delete spool files generated during the tests run.
my @SpoolFilesFailedUnlink = ();
my @SpoolFiles             = glob "${ OTRSDIR }/var/spool/problem-email-*";
for my $SpoolFile (@SpoolFiles) {
    my $FileStat       = stat $SpoolFile;
    my $FileModifiedAt = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            Epoch => $FileStat->mtime(),
        },
    );

    if ( $FileModifiedAt >= $TestsStartedAt && $FileModifiedAt <= $TestsStoppedAt ) {
        if ( !( unlink $SpoolFile ) ) {
            push @SpoolFilesFailedUnlink, $SpoolFile;
        }
    }
}

if (@SpoolFilesFailedUnlink) {
    $Self->True(
        0,
        'Failed to clean some spool files: ' . ( join "\n", @SpoolFilesFailedUnlink )
    );
}
else {
    $Self->True(
        1,
        'Cleaned spool files',
    );
}

# restore to the previous state is done by RestoreDatabase

1;
