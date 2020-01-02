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

use List::Util qw();
use vars (qw($Self));

use Kernel::System::Email::SMTP;

# The tests presented here try to ensure that the communication-log entries
#   keep the correct status after some predefined situations.
#   Some 'magic' techniques are used so we could fake an SMTP client/server connection environment:
#       - localizing variables
#       - local overwriting of package methods
#       - definition of inline packages
#       - autoload handler ( when the called method doesn't exist )

# This hash represents the fake environment for the SMTP, think about %ENV,
#   it'll work more or less the same way.
my %FakeSMTPEnv = (
    'message' => '',
    'code'    => 250,
    'data'    => 1,
    'connect' => 1,
);

no strict 'refs';    ## no critic

# Overwrite the OTRS Email::SMTP check method to use our fake smtp client,
#   but make this change local to the unit test scope, as you can see, it also
#   makes use of the %FakeSMTPEnv.
local *{'Kernel::System::Email::SMTP::Check'} = sub {
    my ( $Self, %Param ) = @_;

    # Define an inline package/class that will work as our fake SMTP client.
    #   This package uses autoload to handle undefined methods, and when
    #   that happen, it'll check if the FakeSMTPEnv has an attribute with the same
    #   name and returns it, otherwise always returns True to ensure that the code
    #   that will use this object continues as everything is ok.
    package FakeSMTP {    ## no critic
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

            if ( exists $FakeSMTPEnv{$Method} ) {
                my $Value    = $FakeSMTPEnv{$Method};
                my $ValueRef = ref $Value;

                if ( $ValueRef && $ValueRef eq 'CODE' ) {
                    return $Value->();
                }

                return $Value;
            }

            return 1;
        }
    }

    my $CommunicationLogObject = $Param{CommunicationLogObject};
    $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    if ( !$FakeSMTPEnv{'connect'} ) {
        $CommunicationLogObject->ObjectLogStop(
            ObjectLogType => 'Connection',
            Status        => 'Failed',
        );

        return (
            Success      => 0,
            ErrorMessage => $FakeSMTPEnv{'message'},
        );
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return (
        Success => 1,
        SMTP    => $Self->_GetSMTPSafeWrapper(
            SMTP => FakeSMTP->new(),
        ),
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
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::SMTP',
);

my $UserObject               = $Kernel::OM->Get('Kernel::System::User');
my $EmailObject              = $Kernel::OM->Get('Kernel::System::Email');
my $MailQueueObject          = $Kernel::OM->Get('Kernel::System::MailQueue');
my $MailQueueItemMaxAttempts = $Kernel::OM->Get('Kernel::Config')->Get('MailQueue')->{ItemMaxAttempts};

my ( $UserLogin, $UserID ) = $HelperObject->TestUserCreate(
    Groups => [ 'admin', 'users' ],
);

my $SendEmail = sub {
    my %Param = @_;

    # Generate the mail and queue it.
    $EmailObject->Send( %Param, );

    # Get last item in the queue.
    my $Items = $MailQueueObject->List();

    $Items = [ sort { $b->{ID} <=> $a->{ID} } @{$Items} ];
    my $LastItem = $Items->[0];

    return ( $LastItem, $MailQueueObject->Send( %{$LastItem} ) );
};

my $MailQueueSend = sub {

    # Send the queued emails.

    my @Processed = ();
    my $Items     = $MailQueueObject->List();

    for my $Item ( @{$Items} ) {
        $MailQueueObject->Send(
            %{$Item},
            Force => 1,
        );
        push @Processed, $Item;
    }

    return \@Processed;
};

my $CheckForQueueItem = sub {
    my %Param = @_;

    my $TestBaseMessage   = $Param{TestBaseMessage};
    my $SMTPErrorType     = $Param{SMTPErrorType};
    my $MailQueueItemSent = $Param{MailQueueItemSent};
    my $StillInQueue      = $Param{StillInQueue};

    # Check for the queue item.
    my $MailQueueItems = $MailQueueObject->List(
        ID => $MailQueueItemSent->{ID},
    );

    $Self->$StillInQueue(
        scalar @{$MailQueueItems},
        sprintf(
            '%s, %s in queue',
            $TestBaseMessage,
            $StillInQueue eq 'True' ? 'still' : 'not',
        ),
    );

    return;
};

my $CheckForCommunicationLog = sub {
    my %Param = @_;

    my $TestBaseMessage        = $Param{TestBaseMessage};
    my $MailQueueItemSent      = $Param{MailQueueItemSent};
    my $CommunicationLogStatus = $Param{CommunicationLogStatus};

    my $CommunicationLogDBObj = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog::DB',
    );

    my $ComLogLookupInfo = $CommunicationLogDBObj->ObjectLookupGet(
        ObjectLogType    => 'Message',
        TargetObjectType => 'MailQueueItem',
        TargetObjectID   => $MailQueueItemSent->{ID},
    );

    # Get the communication info.
    my $Communication = $CommunicationLogDBObj->CommunicationGet(
        CommunicationID => $ComLogLookupInfo->{CommunicationID},
    );

    # Get all the communication objects.
    my $CommunicationLogObjects = [
        reverse @{
            $CommunicationLogDBObj->ObjectLogList(
                CommunicationID => $ComLogLookupInfo->{CommunicationID},
            )
        }
    ];

    my $CommunicationLogConnection
        = List::Util::first { $_->{ObjectLogType} eq 'Connection' } @{$CommunicationLogObjects};
    $Self->True(
        $CommunicationLogConnection->{ObjectLogStatus} eq $CommunicationLogStatus->{Connection},
        $TestBaseMessage
            . sprintf( ", communication log connection with status '%s'", $CommunicationLogStatus->{Connection} ),
    );

    my $CommunicationLogMessage = List::Util::first {
        $_->{ObjectLogID} == $ComLogLookupInfo->{ObjectLogID}
    }
    @{$CommunicationLogObjects};

    $Self->True(
        $CommunicationLogMessage->{ObjectLogStatus} eq $CommunicationLogStatus->{Message},
        $TestBaseMessage
            . sprintf( ", communication log message with status '%s'", $CommunicationLogStatus->{Message} ),
    );

    $Self->True(
        $Communication->{Status} eq $CommunicationLogStatus->{Communication},
        $TestBaseMessage
            . sprintf( ", communication log with status '%s'", $CommunicationLogStatus->{Communication} ),
    );

    return;
};

my $CheckForQueueNotifications = sub {
    my %Param = @_;

    my $ArticleID = $Param{ArticleID};

    # Get all the queue items that aren't related to an article.
    my $MailQueueItems = $MailQueueObject->List();
    my @Notifications  = grep { !$_->{ArticleID} } @$MailQueueItems;

    $Self->True(
        scalar @Notifications,
        'Notifications were queued.',
    );

    return;
};

my @Tests = (
    {
        Name        => 'Email with invalid recipient rejected (SMTP %s)',
        FakeSMTPEnv => {
            'data'    => 0,
            'code'    => 513,               # SMTP permanent error.
            'message' => 'bad recipient',
        },
        Type                   => 'Simple',
        ExpectedSendStatus     => 'Failed',
        CommunicationLogStatus => {
            Message       => 'Failed',
            Communication => 'Failed',
            Connection    => 'Successful',
        },
        StillInQueue => 'False',
    },

    {
        Name        => 'Email with invalid recipient rejected (SMTP %s)',
        FakeSMTPEnv => {
            'data'    => 0,
            'code'    => 451,                                                     # SMTP temporary error.
            'message' => 'Requested action aborted: local error in processing',
        },
        Type                   => 'Simple',
        ExpectedSendStatus     => 'Failed',
        CommunicationLogStatus => {
            Message       => 'Processing',
            Communication => 'Processing',
            Connection    => 'Successful',
        },
        StillInQueue => 'True',
    },

    {
        Name        => 'Article with invalid recipient rejected (SMTP %s)',
        FakeSMTPEnv => {
            'data'    => 0,
            'code'    => 513,               # SMTP permanent error.
            'message' => 'bad recipient',
        },
        Type                   => 'Article',
        TransmissionError      => 'True',
        CommunicationLogStatus => {
            Message       => 'Failed',
            Communication => 'Failed',
            Connection    => 'Successful',
        },
        StillInQueue => 'False',
    },

    {
        Name        => 'Article with invalid recipient rejected (SMTP %s)',
        FakeSMTPEnv => {
            'data'    => 0,
            'code'    => 451,                                                     # SMTP temporary error.
            'message' => 'Requested action aborted: local error in processing',
        },
        Type                   => 'Article',
        TransmissionError      => 'False',
        CommunicationLogStatus => {
            Message       => 'Processing',
            Communication => 'Processing',
            Connection    => 'Successful',
        },
        StillInQueue => 'True',
    },

    {
        Name        => 'Simple Email, Connection to smtp server failed (SMTP %s)',
        FakeSMTPEnv => {
            'connect' => 0,
            'message' => 'couldnt connect to the smtp server',
        },
        Type                   => 'Simple',
        ExpectedSendStatus     => 'Failed',
        CommunicationLogStatus => {
            Message       => 'Processing',
            Communication => 'Processing',
            Connection    => 'Failed',
        },
        StillInQueue => 'True',
    },

    {
        Name        => 'Article, Connection to smtp server failed (SMTP %s)',
        FakeSMTPEnv => {
            'connect' => 0,
            'message' => 'couldnt connect to the smtp server',
        },
        Type                   => 'Article',
        TransmissionError      => 'False',
        CommunicationLogStatus => {
            Message       => 'Processing',
            Communication => 'Processing',
            Connection    => 'Failed',
        },
        StillInQueue => 'True',
    },

    {
        Name        => 'Article, Connection to smtp server failed (SMTP %s)',
        FakeSMTPEnv => {
            'connect' => 0,
            'message' => 'couldnt connect to the smtp server',
        },
        Type                     => 'Article',
        TransmissionError        => 'False',
        TransmissionErrorAttempt => {
            $MailQueueItemMaxAttempts => 'True',
        },
        CommunicationLogStatus => {
            Message       => 'Processing',
            Communication => 'Processing',
            Connection    => 'Failed',

            $MailQueueItemMaxAttempts => {
                Message       => 'Failed',
                Communication => 'Failed',
                Connection    => 'Failed',
            },
        },
        Attempts            => $MailQueueItemMaxAttempts,
        StillInQueue        => 'True',
        StillInQueueAttempt => {
            $MailQueueItemMaxAttempts => 'False',
        },
    },

    {
        Name        => 'Email send throw exception',
        FakeSMTPEnv => {
            'data' => sub { die 'dummy exception'; },
        },
        Type                   => 'Simple',
        ExpectedSendStatus     => 'Failed',
        CommunicationLogStatus => {
            Message       => 'Processing',
            Communication => 'Processing',
            Connection    => 'Successful',
        },
        StillInQueue => 'True',
    },

    {
        Name                   => 'Email successfully sent',
        Type                   => 'Simple',
        ExpectedSendStatus     => 'Success',
        CommunicationLogStatus => {
            Message       => 'Successful',
            Communication => 'Successful',
            Connection    => 'Successful',
        },
        StillInQueue => 'False',
    },

    {
        Name                   => 'Article successfully sent',
        Type                   => 'Article',
        ExpectedSendStatus     => 'Success',
        CommunicationLogStatus => {
            Message       => 'Successful',
            Communication => 'Successful',
            Connection    => 'Successful',
        },
        StillInQueue      => 'False',
        TransmissionError => 'False',
    },
);

TEST:
for my $Test (@Tests) {

    # Ensure mail queue is empty.
    $MailQueueObject->Delete();

    # Set fake smtp environment.
    my %TestFakeSMTPEnv = (
        %FakeSMTPEnv,
        %{ $Test->{FakeSMTPEnv} || {} },
    );

    # Change the client environment according to the test,
    #   these changes are local to the current scope (the for).
    local $FakeSMTPEnv{'data'}    = $TestFakeSMTPEnv{'data'};
    local $FakeSMTPEnv{'code'}    = $TestFakeSMTPEnv{'code'};
    local $FakeSMTPEnv{'message'} = $TestFakeSMTPEnv{'message'};
    local $FakeSMTPEnv{'connect'} = $TestFakeSMTPEnv{'connect'};

    # SMTP permanent / temporary label.
    my $FakeSMTPCode  = $Test->{FakeSMTPEnv}->{'code'};
    my $SMTPErrorType = $FakeSMTPCode && $FakeSMTPCode =~ m/^5/i ? 'permanent' : 'temporary';

    # Build the full test base name.
    my $TestBaseMessage = sprintf $Test->{Name}, $SMTPErrorType;

    if ( $Test->{Type} eq 'Simple' ) {

        # Just try to send a simple mail.
        my ( $ItemSent, $SendResult ) = $SendEmail->(
            From     => 'john.smith@example.com',
            To       => 'john.smith2@example.com',
            Subject  => 'some subject',
            Body     => 'Some Body',
            MimeType => 'text/html',
            Charset  => 'utf8',
        );

        $Self->True(
            $SendResult->{Status} eq $Test->{ExpectedSendStatus},
            $TestBaseMessage,
        );

        $CheckForQueueItem->(
            TestBaseMessage   => $TestBaseMessage,
            SMTPErrorType     => $SMTPErrorType,
            StillInQueue      => $Test->{StillInQueue},
            MailQueueItemSent => $ItemSent,
        );

        # Test the communication log.
        $CheckForCommunicationLog->(
            TestBaseMessage        => $TestBaseMessage,
            MailQueueItemSent      => $ItemSent,
            CommunicationLogStatus => $Test->{CommunicationLogStatus},
        );

        next TEST;
    }

    # Try to send an article.

    my $ArticleData = $Test->{Article};
    my $TicketData  = delete $ArticleData->{Ticket};

    my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');

    # Create the ticket.
    my $TicketID = $TicketObject->TicketCreate(
        Title        => 'Some Ticket_Title',
        Queue        => 'Raw',
        Lock         => 'unlock',
        Priority     => '3 normal',
        State        => 'closed successful',
        CustomerNo   => '123465',
        CustomerUser => 'customer@example.com',
        OwnerID      => $UserID,
        UserID       => 1,
    );

    # Create the article.
    my $ArticleID = $ArticleBackendObject->ArticleSend(
        Body                 => 'Simple string',
        MimeType             => 'text/plain',
        From                 => 'unittest@example.org',
        To                   => 'unittest@example.org',
        SenderType           => 'customer',
        IsVisibleForCustomer => 1,
        HistoryType          => 'AddNote',
        HistoryComment       => 'note',
        Subject              => 'Unittest data',
        Charset              => 'utf-8',
        UserID               => 1,
        TicketID             => $TicketID,
    );

    my $Attempts = $Test->{Attempts} || 1;
    if ( $Attempts > 1 ) {
        $TestBaseMessage = "[Attempt %s] " . $TestBaseMessage;
    }

    for my $Attempt ( 1 .. $Attempts ) {
        my $AttemptBaseMessage            = sprintf $TestBaseMessage, $Attempt;
        my $AttemptCommunicationLogStatus = $Test->{CommunicationLogStatus};
        if ( $AttemptCommunicationLogStatus->{$Attempt} ) {
            $AttemptCommunicationLogStatus = $AttemptCommunicationLogStatus->{$Attempt};
        }

        my $AttemptTransmissionError = $Test->{TransmissionError};
        if ( $Test->{TransmissionErrorAttempt} && $Test->{TransmissionErrorAttempt}->{$Attempt} ) {
            $AttemptTransmissionError = $Test->{TransmissionErrorAttempt}->{$Attempt};
        }

        my $AttemptStillInQueue = $Test->{StillInQueue};
        if ( $Test->{StillInQueueAttempt} && $Test->{StillInQueueAttempt}->{$Attempt} ) {
            $AttemptStillInQueue = $Test->{StillInQueueAttempt}->{$Attempt};
        }

        # Send the queued emails.
        my $MailQueueItemsSent = $MailQueueSend->();

        # Test transmission error for the article.
        my $ArticleTransmissionError = $ArticleBackendObject->ArticleGetTransmissionError(
            ArticleID => $ArticleID,
        );

        $Self->$AttemptTransmissionError(
            $ArticleTransmissionError,
            sprintf(
                '%s, transmission error%sfound',
                $AttemptBaseMessage,
                $AttemptTransmissionError eq 'True' ? ' ' : ' not ',
            ),
        );

        # Test the queue item.
        $CheckForQueueItem->(
            TestBaseMessage   => $AttemptBaseMessage,
            SMTPErrorType     => $SMTPErrorType,
            MailQueueItemSent => $MailQueueItemsSent->[0],
            StillInQueue      => $AttemptStillInQueue,
        );

        # Test the communication log.
        $CheckForCommunicationLog->(
            TestBaseMessage        => $AttemptBaseMessage,
            MailQueueItemSent      => $MailQueueItemsSent->[0],
            CommunicationLogStatus => $AttemptCommunicationLogStatus,
        );

        # Article Email Notifications Events.
        if ( $ArticleTransmissionError->{Status} eq 'Failed' ) {
            $CheckForQueueNotifications->(
                ArticleID => $ArticleID,
            );
        }
    }
}

# restore to the previous state is done by RestoreDatabase

1;
