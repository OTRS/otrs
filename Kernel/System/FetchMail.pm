# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::FetchMail;

use strict;
use warnings;

use IPC::Open3;
use Symbol;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Config',
);

=head1 NAME

Kernel::System::FetchMail - FetchMail wrapper functions

=head1 SYNOPSIS

Functions for email fetch.

=over 4

=cut

=item new()

create a FetchMail object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $FetchMailObject = $Kernel::OM->Get('Kernel::System::FetchMail');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Fetch()

Retrieves messages from an email server using fetchmail backend.

    my $Success = $FetchMailObject->Fetch(

        # General Options:
        Check        => 1,                          # Optional, check for messages without fetching
        Silent       => 1,                          # Optional, work silently
        Verbose      => 1,                          # Optional, work noisily (diagnostic output)
        NoSoftBounce => 1,                          # Optional, fetchmail deletes permanently undeliverable messages.
        SoftBounce   => 1,                          # Optional, keep permanently undeliverable messages on server (default).

        # Disposal Options:
        Keep       => 1,                            # Optional, save new messages after retrieval
        NoKeep     => 1,                            # Optional, delete new messages after retrieval
        Flush      => 1,                            # Optional, delete old messages from server
        LimitFlush => 1,                            # Optional, delete oversized messages

        # Protocol and Query Options:
        Protocol       => 'imap',                   # Optional, (auto || pop2 || pop3 || apop || rpop || kpop || sdps
                                                    #   || imap || etrn || odmr) specify retrieval protocol
        UIDL           => 1,                        # Optional, force the use of UIDLs (pop3 only)
        Service        => 123,                      # Optional, TCP service to connect to (can be numeric TCP port)
        Principal      => 'SomePrincipal',          # Optional, mail service principal
        Timeout        => 123,                      # Optional, server nonresponse timeout
        Plugin         => 'SomeCommand',            # Optional, specify external command to open connection
        Plugout        => 'SomeCommand',            # Optional, specify external command to open smtp connection
        Folder         => 'SomeForlder',            # Optional, specify remote folder name
        TracePolls     => 1,                        # Optional, add poll-tracing information to Received header
        SSL            => 1,                        # Optional, enable ssl encrypted session
        SSLCert        => 'SomeCertName',           # Optional, ssl client certificate
        SSLKey         => 'SomeKeyName',            # Optional, ssl private key file
        SSLProto       => 'SSL2',                   # Optional, (SSL2 || SSL3 || TLS1) force ssl protocol
        SSLCertCheck   => 1,                        # Optional, do strict server certificate check (recommended)
        SSLCertFile    => 'SomeCerName',            # Optional, path to trusted-CA ssl certificate file
        SSLCertPath    => 'SomeCertPath',           # Optional, path to trusted-CA ssl certificate directory
        SSLFingerprint => 'SomeFingerprint',        # Optional, fingerprint that must match that of the server's cert.

        # Delivery Control Options:
        SMTPHost     => 'SomeHosts',                # Optional, set SMTP forwarding host
        FetchDomains => 'SomeDomains',              # Optional, fetch mail for specified domains
        SMTPAddress  => 'SomeAddress',              # Optional, set SMTP delivery domain to use
        SMTPName     => 'some@example.com',         # Optional, set SMTP full name username@domain
        AntiSpam     => '123,456',                  # Optional, set antispam response values
        MDA          => 'SomeCommand',              # Optional, set MDA to use for forwarding
        LMTP         => 1,                          # Optional, use LMTP (RFC2033) for delivery
        BSMTP        => 'SomeFile',                 # Optional, set output BSMTP file
        BadHeader    => 'reject',                   # Optional, (reject || accept), specify policy for handling messages with bad headers

        # Resource Limit Control Options
        Limit          => 123,                      # Optional, don't fetch messages over given size
        Warnings       => 123,                      # Optional, interval between warning mail notification
        BatchLimit     => 123,                      # Optional, set batch limit for SMTP connections
        FetchLimit     => 123,                      # Optional, set fetch limit for server connections
        FetchSizeLimit => 123,                      # Optional, set fetch message size limit
        FastUIDL       => 123,                      # Optional, do a binary search for UIDLs
        Expunge        => 123,                      # Optional, set max deletions between expunges

        # Authentication Options:
        Username => 'SomeUserName',                 # Optional, specify users's login on server
        Auth     => 'ssh',                          # Optional, (password || kerberos || ssh || otp) authentication type

        # Miscellaneous Options:
        FetchMailrc => 'SomeFile',                  # Optional, specify alternate run control file
        IDFile      => 'SomeFile',                  # Optional, specify alternate UIDs file
        NoRewrite   =>  1,                          # Optional, don't rewrite header addresses
        Envelope    => 'SomeXHeader',               # Optional, envelope address header
        QVirtual    => 'SomePrefix',                # Optional, prefix to remove from local user id

        # Administrative Options:
        Postmaster  => 'SomeName',                  # Optional, specify recipient of last resort
        NoBouce     => 1,                           # Optional, redirect bounces from user to postmaster.
    );

Returns:
    $Success = 1,       # or false in case of an error

Note:
To get more information about the parameters please check fetchmail man pages for the corresponding option

=cut

sub Fetch {
    my ( $Self, %Param ) = @_;

    # set possible locations for fetchmail bin
    my @PossibleLocations = (
        '/usr/bin/fetchmail',
        '/usr/sbin/fetchmail',
        '/usr/local/bin/fetchmail',
        '/opt/local/bin/fetchmail',
    );

    # get SysConfig setting as a fall-back
    my $ConfigLocation = $Kernel::OM->Get('Kernel::Config')->Get('Fetchmail::Bin') || '';

    # check if setting is defined and valid
    if ( $ConfigLocation && $ConfigLocation =~ m{[/|\w]+ fetchmail\z}msx ) {
        push @PossibleLocations, $ConfigLocation;
    }

    my $FetchMailBin;

    # set FetMail bin
    LOCATION:
    for my $Location (@PossibleLocations) {
        if ( -e $Location ) {
            $FetchMailBin = $Location;
            last LOCATION
        }
    }

    if ( !$FetchMailBin ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "FetchMail bin was not found",
        );
        return
    }

    my %ParamLookup = (

        # General Options:
        Check        => '--check',
        Silent       => '--silent',
        Verbose      => '--verbose',
        NoSoftBounce => '--nosoftbounce',
        SoftBounce   => '--softbounce',

        # Disposal Options:
        Keep       => '--keep',
        NoKeep     => '--nokeep',
        Flush      => '--flush',
        LimitFlush => '--limitflush',

        # Protocol and Query Options:
        UIDL        => '--uidl',
        TracePolls  => '--tracepolls',
        SSL         => '--ssl',
        SSLCertCeck => '--sslcertck',

        # Delivery Control Options:
        LMTP => '--lmtp',

        # Miscellaneous Options:
        NoRewrite => '--norewrite',

        # Administrative Options:
        NoBouce => '--nobounce',
    );

    my %HasValueParamLookup = (

        # Protocol and Query Options:
        Protocol       => '--protocol',
        Service        => '--service',
        Principal      => '--principal',
        Timeout        => '--timeout',
        Plugin         => '--plugin',
        Plugout        => '--plugout',
        Folder         => '--folder',
        SSLCert        => '--sslcert',
        SSLKey         => '--sslkey',
        SSLProto       => '--sslproto',
        SSLCertFile    => '--sslcertfile',
        SSLCertPath    => '--sslcertpath',
        SSLFingerprint => '--sslfingerprint',

        # Delivery Control Options:
        SMTPHost     => '--smtphost',
        FetchDomains => '--fetchdomains',
        SMTPAddress  => '--smtpaddress',
        SMTPName     => '--smtpname',
        AntiSpam     => '--antispam',
        MDA          => '--mda',
        BSMTP        => '--bsmtp',
        BadHeader    => '--bad-header',

        # Resource Limit Control Options
        Limit          => '--limit',
        Warnings       => '--warnings',
        BatchLimit     => '--batchlimit',
        FetchLimit     => '--fetchlimit',
        FetchSizeLimit => '--fetchsizelimit',
        FastUIDL       => '--fastuidl',
        Expunge        => '--expunge',

        # Authentication Options:
        Username => '--username',
        Auth     => '--auth',

        # Miscellaneous Options:
        FetchMailrc => '--fetchmailrc',
        IDFile      => '--idfile',
        Envelope    => '--envelope',
        QVirtual    => '--qvirtual',

        # Administrative Options:
        Postmaster => '--postmaster',
    );

    # define base command
    my $Command = "$FetchMailBin -a";

    OPTION:
    for my $Option ( sort keys %Param ) {

        next OPTION if !$Param{$Option};

        # check params without value
        if ( $ParamLookup{$Option} ) {
            $Command .= " $ParamLookup{$Option}";
        }

        # check params with values
        elsif ( $HasValueParamLookup{$Option} ) {
            $Command .= " $HasValueParamLookup{$Option} $Param{$Option}";
        }
    }

    # to capture standard in, out and error
    my ( $INFH, $OUTFH, $ERRFH );

    # create a symbol for the error file handle
    $ERRFH = gensym();

    # call the command, capturing output and error
    my $ProcessID;
    eval {
        $ProcessID = open3( $INFH, $OUTFH, $ERRFH, $Command );
    };

    my $ErrorMessage;
    my $ExitCode;

    if ($ProcessID) {

        while (<$ERRFH>) {
            $ErrorMessage .= $_;
        }
        waitpid( $ProcessID, 0 );
        $ExitCode = $? >> 8;
    }
    else {
        $ErrorMessage = $@;
    }

    my $Success = 1;

    # fetchmail ExitCode 1 means no mails to retrieve (this is OK)
    if ( $ExitCode == 1 ) {
        $ExitCode = 0;
    }

    # fetchmail ExitCode 13 means early termination due to limit (this is OK)
    elsif ( $ExitCode == 13 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "fetchmail: Poll terminated by a fetch limit",
        );
        $ExitCode = 0;
    }

    # check if there are errors
    if ( $ErrorMessage || $ExitCode ) {

        $ErrorMessage //= '';

        my %ErrorMessageLookup = (
            2  => 'Error opening a socket to retrieve mail.',
            3  => 'User authentication step failed.',
            4  => 'Fatal protocol error.',
            5  => 'There was a syntax error in the arguments to fetchmail',
            6  => 'The run control file had bad permissions.',
            7  => 'There was an error condition reported by the server.',
            8  => 'Fetchmail is already running',
            9  => 'User authentication step failed because the server responded "lock  busy", try again later.',
            10 => 'Fetchmail run failed while trying to do an SMTP port open or transaction.',
            11 =>
                'Fatal DNS error. Fetchmail encountered an error while performing a DNS lookup at startup and could not proceed.',
            12 => 'BSMTP batch file could not be opened.',
            14 => 'Server busy indication.',
            23 => 'Internal error.',
        );

        if ( $ExitCode && !$ErrorMessage ) {
            $ErrorMessage = $ErrorMessageLookup{$ExitCode} || 'Unknown';
        }

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "There was an error executing $Command: $ErrorMessage",
        );

        $Success = 0;
    }

    return $Success;

}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
