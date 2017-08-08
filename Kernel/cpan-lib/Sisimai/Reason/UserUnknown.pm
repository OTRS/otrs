package Sisimai::Reason::UserUnknown;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'userunknown' }
sub description { "Email rejected due to a local part of a recipient's email address does not exist" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $regex = qr{(?>
         .+[ ]user[ ]unknown
        |[#]5[.]1[.]1[ ]bad[ ]address
        |[<].+[>][ ]not[ ]found
        |address[ ]does[ ]not[ ]exist
        |address[ ]unknown
        |archived[ ]recipient
        |BAD[-_ \t]RECIPIENT
        |can[']t[ ]accept[ ]user
        |destination[ ]addresses[ ]were[ ]unknown
        |destination[ ]server[ ]rejected[ ]recipients
        |email[ ]address[ ]does[ ]not[ ]exist
        |invalid[ ](?:
             address
            |mailbox[ ]path
            |recipient                 # Linkedin
            )
        |is[ ]not[ ](?:
             a[ ]known[ ]user
            |an[ ]active[ ]address[ ]at[ ]this[ ]host
            )
        |mailbox[ ](?:
             not[ ]present
            |not[ ]found
            |unavailable
            )
        |no[ ](?:
             account[ ]by[ ]that[ ]name[ ]here
            |mail[ ]box[ ]available[ ]for[ ]this[ ]user
            |mailbox[ ]found
            |matches[ ]to[ ]nameserver[ ]query
            |such[ ](?:
                 mailbox
                |person[ ]at[ ]this[ ]address
                |recipient
                |user(?:[ ]here)?
                )
            |[ ].+[ ]in[ ]name[ ]directory
            |valid[ ]recipients[,][ ]bye    # Microsoft
            )
        |non[- ]?existent[ ]user
        |not[ ](?:
             a[ ]valid[ ]user[ ]here
            |a[ ]local[ ]address
            )
        |rcpt[ ][<].+[>][ ]does[ ]not[ ]exist
        |recipient[ ](?:
             .+[ ]was[ ]not[ ]found[ ]in
            |address[ ]rejected:[ ](?:
                 invalid[ ]user
                |user[ ].+[ ]does[ ]not[ ]exist
                |user[ ]unknown[ ]in[ ].+[ ]table
                |unknown[ ]user
                )
            |does[ ]not[ ]exist(?:[ ]on[ ]this[ ]system)?
            |is[ ]not[ ]local
            |not[ ]found
            |not[ ]OK
            |unknown
            )
        |requested[ ]action[ ]not[ ]taken:[ ]mailbox[ ]unavailable
        |RESOLVER[.]ADR[.]RecipNotFound # Microsoft
        |said:[ ]550[-[ ]]5[.]1[.]1[ ].+[ ]user[ ]unknown[ ]
        |sorry,[ ](?:
             user[ ]unknown
            |badrcptto
            |no[ ]mailbox[ ]here[ ]by[ ]that[ ]name
            )
        |the[ ](?:
             email[ ]account[ ]that[ ]you[ ]tried[ ]to[ ]reach[ ]does[ ]not[ ]exist
            |following[ ]recipients[ ]was[ ]undeliverable
            |user[']s[ ]email[ ]name[ ]is[ ]not[ ]found
            )
        |this[ ](?:
             address[ ]no[ ]longer[ ]accepts[ ]mail
            |email[ ]address[ ]is[ ]wrong[ ]or[ ]no[ ]longer[ ]valid
            |user[ ]doesn[']?t[ ]have[ ]a[ ].+[ ]account
            )
        |unknown[ ](?:
             e[-]?mail[ ]address
            |local[- ]part
            |mailbox
            |recipient
            |user
            )
        |user[ ](?:
             .+[ ]was[ ]not[ ]found
            |.+[ ]does[ ]not[ ]exist
            |does[ ]not[ ]exist
            |missing[ ]home[ ]directory
            |not[ ]found     # 550 User not found. See http://mail.bigmir.net/err/2/
            |not[ ]known
            |unknown
            )
        |vdeliver:[ ]invalid[ ]or[ ]unknown[ ]virtual[ ]user
        )
    }xi;

    return 1 if $argv1 =~ $regex;
    return 0;
}

sub true {
    # Whether the address is "userunknown" or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is unknown user
    #                                   0: is not unknown user.
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    return 1 if $argvs->reason eq __PACKAGE__->text;

    require Sisimai::SMTP::Status;
    my $prematches = ['NoRelaying', 'Blocked', 'MailboxFull', 'HasMoved'];
    my $matchother = 0;
    my $statuscode = $argvs->deliverystatus // '';
    my $diagnostic = $argvs->diagnosticcode // '';
    my $tempreason = Sisimai::SMTP::Status->name($statuscode);
    my $reasontext = __PACKAGE__->text;
    my $v = 0;

    return 0 if $tempreason eq 'suspend';

    if( $tempreason eq $reasontext ) {
        # *.1.1 = 'Bad destination mailbox address'
        #   Status: 5.1.1
        #   Diagnostic-Code: SMTP; 550 5.1.1 <***@example.jp>:
        #     Recipient address rejected: User unknown in local recipient table
        require Module::Load;
        for my $e ( @$prematches ) {
            # Check the value of "Diagnostic-Code" with other error patterns.
            my $p = 'Sisimai::Reason::'.$e;
            Module::Load::load($p);

            if( $p->match($diagnostic) ) {
                # Match with reason defined in Sisimai::Reason::* Except 
                # UserUnknown.
                $matchother = 1;
                last;
            }
        }

        # Did not match with other message patterns
        $v = 1 if $matchother == 0;

    } else {
        # Check the last SMTP command of the session. 
        if( $argvs->smtpcommand eq 'RCPT' ) {
            # When the SMTP command is not "RCPT", the session rejected by other
            # reason, maybe.
            $v = 1 if __PACKAGE__->match($diagnostic);
        }
    }

    return $v;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::UserUnknown - Bounce reason is C<userunknown> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::UserUnknown;
    print Sisimai::Reason::UserUnknown->match('550 5.1.1 Unknown User');   # 1

=head1 DESCRIPTION

Sisimai::Reason::UserUnknown checks the bounce reason is C<userunknown> or not.
This class is called only Sisimai::Reason class.

This is the error that a local part (Left hand side of @ sign) of a recipient's
email address does not exist. In many case, a user has changed internet service
provider, or has quit company, or the local part is misspelled. Sisimai will set
C<userunknown> to the reason of email bounce if the value of Status: field in a
bounce email is C<5.1.1>, or connection was refused at SMTP RCPT command, or the
contents of Diagnostic-Code: field represents that it is unknown user.

    <kijitora@example.co.jp>: host mx01.example.co.jp[192.0.2.8] said:
      550 5.1.1 Address rejected kijitora@example.co.jp (in reply to
      RCPT TO command)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<userunknown>.

    print Sisimai::Reason::UserUnknown->text;  # userunknown

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::UserUnknown->match('550 5.1.1 Unknown User');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<userunknown>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2017 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
