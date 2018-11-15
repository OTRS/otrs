package Sisimai::MDA;
use feature ':5.10';
use strict;
use warnings;

my $AgentNames = {
    # dovecot/src/deliver/deliver.c
    # 11: #define DEFAULT_MAIL_REJECTION_HUMAN_REASON \
    # 12: "Your message to <%t> was automatically rejected:%n%r"
    'dovecot'    => qr/\AYour message to .+ was automatically rejected:\z/,
    'mail.local' => qr/\Amail[.]local: /,
    'procmail'   => qr/\Aprocmail: /,
    'maildrop'   => qr/\Amaildrop: /,
    'vpopmail'   => qr/\Avdelivermail: /,
    'vmailmgr'   => qr/\Avdeliver: /,
};
my $MarkingsOf = {
    'message' => qr{\A(?>
                     Your[ ]message[ ]to[ ].+[ ]was[ ]automatically[ ]rejected:\z
                    |(?:mail[.]local|procmail|maildrop|vdelivermail|vdeliver):[ ]
                    )
                 }x,
};

# dovecot/src/deliver/mail-send.c:94
my $MessagesOf = {
    'dovecot' => {
        'userunknown' => ["mailbox doesn't exist: "],
        'mailboxfull' => [
            'quota exceeded',   # Dovecot 1.2 dovecot/src/plugins/quota/quota.c
            'quota exceeded (mailbox for user is full)',    # dovecot/src/plugins/quota/quota.c
            'not enough disk space',
        ],
    },
    'mail.local' => {
        'userunknown' => [
            ': unknown user:',
            ': user unknown',
            ': invalid mailbox path',
            ': user missing home directory',
        ],
        'mailboxfull' => [
            'disc quota exceeded',
            'mailbox full or quota exceeded',
        ],
        'systemerror' => ['temporary file write error'],
    },
    'procmail' => {
        'mailboxfull' => ['quota exceeded while writing'],
        'systemfull'  => ['no space left to finish writing'],
    },
    'maildrop' => {
        'userunknown' => [
            'invalid user specified.',
            'cannot find system user',
        ],
        'mailboxfull' => ['maildir over quota.'],
    },
    'vpopmail' => {
        'userunknown' => ['sorry, no mailbox here by that name.'],
        'filtered'    => [
            'account is locked email bounced',
            'user does not exist, but will deliver to '
        ],
        'mailboxfull' => [
            'domain is over quota',
            'user is over quota',
        ],
    },
    'vmailmgr' => {
        'userunknown' => [
            'invalid or unknown base user or domain',
            'invalid or unknown virtual user',
            'user name does not refer to a virtual user'
        ],
        'mailboxfull' => ['delivery failed due to system quota violation'],
    },
};

sub scan { 
    # Parse message body and return reason and text
    # @param         [Hash] mhead       Message header of a bounce email
    # @options mhead [String] from      From header
    # @options mhead [String] date      Date header
    # @options mhead [String] subject   Subject header
    # @options mhead [Array]  received  Received headers
    # @options mhead [String] others    Other required headers
    # @param         [String] mbody     Message body of a bounce email
    # @return        [Hash, Undef]      Bounce data list and message/rfc822 part
    #                                   or Undef if it failed to parse or the
    #                                   arguments are missing
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless ref($mhead) eq 'HASH';
    return undef unless lc($mhead->{'from'}) =~ /\A(?:mail delivery subsystem|mailer-daemon|postmaster)/;
    return undef unless ref($mbody) eq 'SCALAR';
    return undef unless $$mbody;

    my $agentname0 = '';    # [String] MDA name
    my $reasonname = '';    # [String] Error reason
    my $bouncemesg = '';    # [String] Error message
    my @hasdivided = split("\n", $$mbody);
    my @linebuffer = ();

    for my $e ( @hasdivided ) {
        # Check each line with each MDA's symbol regular expression.
        if( $agentname0 eq '' ) {
            # Try to match with each regular expression
            next unless $e;
            next unless $e =~ $MarkingsOf->{'message'};

            for my $f ( keys %$AgentNames ) {
                # Detect the agent name from the line
                next unless $e =~ $AgentNames->{ $f };
                $agentname0 = $f;
                last;
            }
        }

        # Append error message lines to @linebuffer
        push @linebuffer, $e;
        last unless length $e;
    }
    return undef unless $agentname0;
    return undef unless scalar @linebuffer;

    for my $e ( keys %{ $MessagesOf->{ $agentname0 } } ) {
        # Detect an error reason from message patterns of the MDA.
        for my $f ( @linebuffer ) {
            # Whether the error message include each message defined in $MessagesOf
            my $g = lc $f;
            next unless grep { index($g, $_) > -1 } @{ $MessagesOf->{ $agentname0 }->{ $e } };
            $reasonname = $e;
            $bouncemesg = $f;
            last;
        }
        last if $bouncemesg && $reasonname;
    }

    return { 
        'mda'     => $agentname0, 
        'reason'  => $reasonname // '', 
        'message' => $bouncemesg // '',
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::MDA - Error message parser for MDA

=head1 SYNOPSIS

    use Sisimai::MDA;
    my $header = { 'from' => 'mailer-daemon@example.jp' };
    my $string = 'mail.local: Disc quota exceeded';
    my $return = Sisimai::MDA->scan($header, \$string);

=head1 DESCRIPTION

Sisimai::MDA parse bounced email which created by some MDA, such as C<dovecot>,
C<mail.local>, C<procmail>, and so on. 
This class is called from Sisimai::Message only.

=head1 CLASS METHODS

=head2 C<B<scan(I<Header>, I<Reference to message body>)>>

C<scan()> is a parser for detecting an error from mail delivery agent.

    my $header = { 'from' => 'mailer-daemon@example.jp' };
    my $string = 'mail.local: Disc quota exceeded';
    my $return = Sisimai::MDA->scan($header, \$string);
    warn Dumper $return;
    $VAR1 = {
        'mda' => 'mail.local',
        'reason' => 'mailboxfull',
        'message' => 'mail.local: Disc quota exceeded'
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
