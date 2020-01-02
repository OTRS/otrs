# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::ImportFakeEmails;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

use POSIX qw(ceil);
use Time::HiRes qw();
use Kernel::System::PostMaster;
use Kernel::System::MailAccount::IMAP;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::MailAccount',
);

package MyIMAP {    ## no critic
    our $AUTOLOAD;

    sub new {
        my $Class = shift;
        my %Param = (
            @_,
            TotalProcessed => 0,
            Processed      => {},
        );

        my $Self = bless( \%Param, $Class, );

        $Self->{Email} = 'Return-Path: test@dummy.com
Received: from mail.dummy.com (LHLO mail.dummy.com) (62.146.52.73) by
mail.dummy.com with LMTP; Tue, 25 Jul 2017 15:08:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
by mail.dummy.com (Postfix) with ESMTP id D17ACAE1F8D
for <test@dummy.com>; Tue, 25 Jul 2017 15:08:45 +0000 (UTC)
X-Spam-Flag: NO
X-Spam-Score: -2.9
X-Spam-Level:
X-Spam-Status: No, score=-2.9 required=6.6 tests=[ALL_TRUSTED=-1,
BAYES_00=-1.9] autolearn=ham autolearn_force=no
Received: from mail.dummy.com ([127.0.0.1])
by localhost (mail.dummy.com [127.0.0.1]) (amavisd-new, port 10032)
with ESMTP id u-bcHVQKwYt4 for <test@dummy.com>;
Tue, 25 Jul 2017 15:08:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
by mail.dummy.com (Postfix) with ESMTP id E0437AE1F92
for <test@dummy.com>; Tue, 25 Jul 2017 15:08:44 +0000 (UTC)
X-Virus-Scanned: amavisd-new at mail.dummy.com
Received: from mail.dummy.com ([127.0.0.1])
by localhost (mail.dummy.com [127.0.0.1]) (amavisd-new, port 10026)
with ESMTP id hbGqcx4LIqJK for <test@dummy.com>;
Tue, 25 Jul 2017 15:08:44 +0000 (UTC)
Received: from dummy.lan (192.243.186.30.rev.dummy.pt [46.189.212.196])
by mail.dummy.com (Postfix) with ESMTPSA id A8E45AE1F8D
for <test@dummy.com>; Tue, 25 Jul 2017 15:08:44 +0000 (UTC)
From: =?utf-8?B?QW5kcsOpIEJyw6Fz?= <test@dummy.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: test
Message-Id: <A3586247-F0B4-4887-BCC4-C6587A7E176A-%s-%s@dummy.com>
Date: Tue, 25 Jul 2017 16:09:36 +0100
To: =?utf-8?B?QW5kcsOpIEJyw6Fz?= <test@dummy.com>
X-Mailer: Apple Mail (2.3273)

test %s';

        return $Self;
    }

    sub AUTOLOAD {
        my $Self = shift;

        my ($Method) = ( $AUTOLOAD =~ m/::([^:]+)$/i );
        if ( !$Method || $Method eq 'DESTROY' ) {
            return;
        }

        return 1;
    }

    sub get {
        my ( $Self, $Idx ) = @_;

        if ( !( defined $Self->{Processed}->{$Idx} ) ) {
            $Self->{TotalProcessed} += 1;
            $Self->{Processed}->{$Idx} = 1;
        }

        my ( $Seconds, $MSeconds ) = Time::HiRes::gettimeofday();
        my $Email = sprintf $Self->{Email}, $Seconds, $MSeconds, "$Seconds-$MSeconds";
        my @Lines = split "\n",             $Email;

        return wantarray ? @Lines : \@Lines;
    }

    sub select {
        my $Self = shift;

        return $Self->{Total} - $Self->{TotalProcessed};
    }

    sub nbr_of_processed { shift->{TotalProcessed}; }
};

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Insert fake emails/tickets to the system.');
    $Self->AddOption(
        Name        => 'total',
        Description => 'Total of emails to insert per account.',
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/,
    );

    $Self->AddOption(
        Name        => 'create-postmaster-accounts',
        Description => 'Create fake postmaster accounts.',
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name        => 'per-communication',
        Description => 'Number of emails per communication (defaults to 20).',
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/^\d+$/,
    );

    return;
}

sub Run {
    my ( $Self, %Param, ) = @_;

    my $CreatePMAccts    = $Self->GetOption('create-postmaster-accounts');
    my $PerCommunication = $Self->GetOption('per-communication') || 20;

    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'PostMasterReconnectMessage',
        Value => $PerCommunication,
    );

    # Get the current postmaster accounts
    my $PMAccounts = $Self->_GetPMAccounts();
    return if !$PMAccounts;

    # Create postmaster accounts if none exists.
    if ( !@{$PMAccounts} ) {
        $PMAccounts = $Self->_CreatePMAccounts();
    }

    # Import the emails
    $Self->_ImportEmails(
        PMAccounts => $PMAccounts,
    );

    return $Self->ExitCodeOk();
}

sub _CreatePMAccounts {
    my ( $Self, %Param, ) = @_;

    my $Total            = $Self->GetOption('total');
    my $PerCommunication = $Kernel::OM->Get('Kernel::Config')->Get('PostMasterReconnectMessage');
    my $LimitAccounts    = 5;
    my $NbrOfAccounts    = ceil( $Total / $PerCommunication );
    if ( $NbrOfAccounts > $LimitAccounts ) {
        $NbrOfAccounts = $LimitAccounts;
    }

    my @Accounts = ();
    for my $Idx ( 0 .. ( $NbrOfAccounts - 1 ) ) {
        my %Account = (
            Login         => "fake-mail-${ Idx }",
            Password      => 'SomePassword',
            Host          => "mail.fake-mail-${ Idx }.com",
            ValidID       => 1,
            Trusted       => 0,
            DispatchingBy => 'Queue',                         # Queue|From
            QueueID       => 1,
            UserID        => 1,
            Type          => 'IMAP',
        );

        my $ID = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountAdd(
            %Account,
        );

        if ( !$ID ) {
            return $Self->_Log(
                Message => 'Error while creating the postmaster mail account: %s - %s',
                Binds   => [
                    $Account{Login},
                    $Account{Host},
                ]
            );
        }

        push @Accounts,
            {
            %Account,
            ID => $ID,
            };
    }

    return \@Accounts;
}

sub _GetPMAccounts {
    my ( $Self, %Param, ) = @_;

    return [
        $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGetAll(),
    ];
}

sub _ImportEmails {
    my ( $Self, %Param, ) = @_;

    my $Accounts         = $Param{PMAccounts};
    my $Total            = $Self->GetOption('total');
    my $PerCommunication = $Kernel::OM->Get('Kernel::Config')->Get('PostMasterReconnectMessage');
    my $TotalProcessed   = 0;

    my $StartAt = $Kernel::OM->Create('Kernel::System::DateTime');
    my $FakeIMAPObject;

    # Redefine PostMaster::Run so we can fail some messages
    #   and keep this change local to the current scope
    no strict 'refs';    ## no critic

    local *{'Kernel::System::MailAccount::IMAP::Connect'} = sub {
        my ( $Self, %Param ) = @_;

        return (
            Successful => 1,
            IMAPObject => $FakeIMAPObject,
            Type       => 'IMAP',
        );
    };

    my $OriginalPostMasterRun = \&{'Kernel::System::PostMaster::Run'};
    local *{'Kernel::System::PostMaster::Run'} = sub {
        my $RandNbr = int rand( $FakeIMAPObject->nbr_of_processed() * 999 );
        if ( ( $RandNbr % 3 ) == 0 ) {
            die "dummy exception";
        }

        return $OriginalPostMasterRun->(@_);
    };

    use strict 'refs';

    TOTAL:
    while ( $TotalProcessed < $Total ) {
        for my $Account ( @{$Accounts} ) {
            my $ToProcess = $Total - $TotalProcessed;

            # Process the account emails
            # Create the IMAP object only for the current processing scope
            $FakeIMAPObject = MyIMAP->new(
                Total => $ToProcess > $PerCommunication ? $PerCommunication : $ToProcess,
            );
            $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountFetch(
                UserID => 1,
                %{$Account},
            );

            # Update the number of processed emails
            $TotalProcessed += $FakeIMAPObject->nbr_of_processed();

            $FakeIMAPObject = undef;

            # Stop if we reached the limit
            last TOTAL if $TotalProcessed >= $Total;
        }
    }

    print 'Insert completed, waiting for some tasks to complete', "\n";

    my $StopAt = $Kernel::OM->Create('Kernel::System::DateTime');

    $Self->_CleanSpoolFiles(
        StartAt => $StartAt,
        StopAt  => $StopAt,
    );

    return;
}

sub _CleanSpoolFiles {
    my ( $Self, %Param ) = @_;

    my $StartAt = $Param{StartAt};
    my $StopAt  = $Param{StopAt};

    my $OtrsDir = __FILE__;
    $OtrsDir =~ s/\/Kernel.*$//i;

    my @SpoolFilesFailedUnlink = ();
    my @SpoolFiles             = glob "${ OtrsDir }/var/spool/problem-email-*";
    for my $SpoolFile (@SpoolFiles) {
        my @FileStat = stat $SpoolFile;

        my $FileModifiedAt = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                Epoch => $FileStat[9],
            },
        );

        if ( $FileModifiedAt >= $StartAt && $FileModifiedAt <= $StopAt ) {
            if ( !( unlink $SpoolFile ) ) {
                push @SpoolFilesFailedUnlink, $SpoolFile;
            }
        }
    }

    return;
}

sub _Log {
    my ( $Self, %Param, ) = @_;

    my $Message = $Param{Message};
    my @Binds   = @{ $Param{Binds} || [] };

    $Message = sprintf $Message, @Binds;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Message  => $Message,
        Priority => $Param{'Priority'} || 'error',
    );

    return;
}

1;
