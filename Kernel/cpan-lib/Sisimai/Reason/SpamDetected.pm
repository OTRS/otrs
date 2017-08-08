package Sisimai::Reason::SpamDetected;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'spamdetected' }
sub description { 'Email rejected by spam filter running on the remote host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.19
    my $class = shift;
    my $argv1 = shift // return undef;
    my $regex = qr{(?>
         ["]The[ ]mail[ ]server[ ]detected[ ]your[ ]message[ ]as[ ]spam[ ]and[ ]
            has[ ]prevented[ ]delivery[.]["]    # CPanel/Exim with SA rejections on
        |(?:\d[.]\d[.]\d|\d{3})[ ]spam\z
        |appears[ ]to[ ]be[ ]unsolicited
        |Blacklisted[ ]URL[ ]in[ ]message
        |block[ ]for[ ]spam
        |blocked[ ]by[ ](?:
             policy:[ ]no[ ]spam[ ]please
            |spamAssassin                   # rejected by SpamAssassin
            )
        |blocked[ ]for[ ]abuse[.][ ]see[ ]http://att[.]net/blocks   # AT&T
        |bulk[ ]email
        |content[ ]filter[ ]rejection
        |cyberoam[ ]anti[ ]spam[ ]engine[ ]has[ ]identified[ ]this[ ]email[ ]as[ ]a[ ]bulk[ ]email
        |denied[ ]due[ ]to[ ]spam[ ]list
        |dt:spm[ ]mx.+[ ]http://mail[.]163[.]com/help/help_spam_16[.]htm
        |greylisted.?.[ ]please[ ]try[ ]again[ ]in
        |http://(?:
             www[.]spamhaus[.]org
            |dsbl[.]org
            |www[.]sorbs[.]net
            )
        |listed[ ]in[ ]work[.]drbl[.]imedia[.]ru
        |mail[ ](?:
             appears[ ]to[ ]be[ ]unsolicited    # rejected due to spam
            |content[ ]denied   # http://service.mail.qq.com/cgi-bin/help?subtype=1&&id=20022&&no=1000726
            )
        |may[ ]consider[ ]spam
        |message[ ](?:
             content[ ]rejected
            |filtered
            |filtered[.][ ]please[ ]see[ ]the[ ]faqs[ ]section[ ]on[ ]spam
            |filtered[.][ ]Refer[ ]to[ ]the[ ]Troubleshooting[ ]page[ ]at[ ]
            |looks[ ]like[ ]spam
            |not[ ]accepted[ ]for[ ]policy[ ]reasons[.][ ]See[ ]http:   # Yahoo!
            |refused[ ]by[ ]mailmarshal[ ]spamprofiler
            |rejected[ ]as[ ]spam
            |rejected[ ]as[ ]spam[ ]by[ ]Content[ ]Filtering
            |rejected[ ]due[ ]to[ ]suspected[ ]spam[ ]content
            |rejected[ ]for[ ]policy[ ]reasons
            )
        |our[ ]email[ ]server[ ]thinks[ ]this[ ]email[ ]is[ ]spam
        |our[ ]filters[ ]rate[ ]at[ ]and[ ]above[ ].+[ ]percent[ ]probability[ ]of[ ]being[ ]spam
        |our[ ]system[ ]has[ ]detected[ ]that[ ]this[ ]message[ ]is
        |probable[ ]spam
        |rejected(?:
             :[ ]spamassassin[ ]score[ ]
            |[ ]by[ ].+[ ][(]spam[)]
            |[ ]due[ ]to[ ]spam[ ]content
            )
        |rejecting[ ]banned[ ]content 
        |related[ ]to[ ]content[ ]with[ ]spam[-]like[ ]characteristics
        |rule[ ]imposed[ ]as[ ].+is[ ]blacklisted[ ]on              # Mailmarshal RBLs
        |sending[ ]address[ ]not[ ]accepted[ ]due[ ]to[ ]spam[ ]filter
        |spam[ ](?:
             .+[ ]exceeded
            |blocked
            |check
            |content[ ]matched
            |detected
            |email
            |email[ ]not[ ]accepted
            |message[ ]rejected[.]       # mail.ru
            |not[ ]accepted
            |refused
            |rejection
            |Reporting[ ]Address    # SendGrid|a message to an address has previously been marked as Spam by the recipient.
            |score[ ]
            )
        |spambouncer[ ]identified[ ]spam    # SpamBouncer identified SPAM
        |spamming[ ]not[ ]allowed
        |Too[ ]much[ ]spam[.]               # Earthlink
        |the[ ]message[ ]was[ ]rejected[ ]due[ ]to[ ]classification[ ]as[ ]bulk[ ]mail
        |The[ ]content[ ]of[ ]this[ ]message[ ]looked[ ]like[ ]spam # SendGrid
        |this[ ]message[ ](?:
             appears[ ]to[ ]be[ ]spam
            |has[ ]been[ ]identified[ ]as[ ]spam
            |scored[ ].+[ ]spam[ ]points
            |was[ ]classified[ ]as[ ]spam
            )
        |transaction[ ]failed[ ]spam[ ]message[ ]not[ ]queued       # SendGrid
        |we[ ]dont[ ]accept[ ]spam
        |you're[ ]using[ ]a[ ]mass[ ]mailer
        |your[ ](?:
             email[ ](?:
                 appears[ ]similar[ ]to[ ]spam[ ]we[ ]have[ ]received[ ]before
                |breaches[ ]local[ ]URIBL[ ]policy
                |had[ ]spam[-]like[ ]
                |is[ ]considered[ ]spam
                |is[ ]probably[ ]spam
                |was[ ]detected[ ]as[ ]spam
                )
            |message[ ](?:
                 has[ ]been[ ](?:
                     temporarily[ ]blocked[ ]by[ ]our[ ]filter
                    |rejected[ ]because[ ]it[ ]appears[ ]to[ ]be[ ]SPAM
                    )
                |has[ ]triggered[ ]a[ ]SPAM[ ]block
                |may[ ]contain[ ]the[ ]spam[ ]contents
                |failed[ ]several[ ]antispam[ ]checks
                )
            )
        )
    }xi;

    return 1 if $argv1 =~ $regex;
    return 0;
}

sub true {
    # Rejected due to spam content in the message
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: rejected due to spam
    #                                   0: is not rejected due to spam
    # @since v4.1.19
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    my $statuscode = $argvs->deliverystatus // '';
    my $reasontext = __PACKAGE__->text;

    return undef unless length $statuscode;
    return 1 if $argvs->reason eq $reasontext;

    require Sisimai::SMTP::Status;
    my $diagnostic = $argvs->diagnosticcode // '';
    my $v = 0;

    if( Sisimai::SMTP::Status->name($statuscode) eq $reasontext ) {
        # Delivery status code points "spamdetected".
        $v = 1;

    } else {
        # Matched with a pattern in this class
        $v = 1 if __PACKAGE__->match($diagnostic);
    }

    return $v;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SpamDetected - Bounce reason is C<spamdetected> due to Spam 
content in the message or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SpamDetected;
    print Sisimai::Reason::SpamDetected->match('550 spam detected');   # 1

=head1 DESCRIPTION

Sisimai::Reason::SpamDetected checks the bounce reason is C<spamdetected> due to 
Spam content in the message or not. This class is called only Sisimai::Reason 
class.

This is the error that the message you sent was rejected by C<spam> filter which
is running on the remote host. This reason has added in Sisimai 4.1.25 and does
not exist in any version of bounceHammer.

    Action: failed
    Status: 5.7.1
    Diagnostic-Code: smtp; 550 5.7.1 Message content rejected, UBE, id=00000-00-000
    Last-Attempt-Date: Thu, 9 Apr 2008 23:34:45 +0900 (JST)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<spamdetected>.

    print Sisimai::Reason::SpamDetected->text;  # spamdetected

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::SpamDetected->match('550 Spam detected');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<rejected> due to Spam content in 
the message. The argument must be Sisimai::Data object and this method is called
only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

