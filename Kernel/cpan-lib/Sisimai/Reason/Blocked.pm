package Sisimai::Reason::Blocked;
use feature ':5.10';
use strict;
use warnings;

sub text { 'blocked' }
sub description { 'Email rejected due to client IP address or a hostname' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $regex = qr{(?>
         access[ ]denied[.][ ]IP[ ]name[ ]lookup[ ]failed
        |access[ ]from[ ]ip[ ]address[ ].+[ ]blocked
        |blacklisted[ ]by
        |Blocked[ ]-[ ]see[ ]https://support[.]proofpoint[.]com/dnsbl-lookup[.]cgi[?]ip=.+
        |can[']t[ ]determine[ ]Purported[ ]Responsible[ ]Address
        |cannot[ ]resolve[ ]your[ ]address
        |client[ ]host[ ].+[ ]blocked[ ]using
        |client[ ]host[ ]rejected:[ ](?:
             may[ ]not[ ]be[ ]mail[ ]exchanger
            |cannot[ ]find[ ]your[ ]hostname    # Yahoo!
            |was[ ]not[ ]authenticated          # Microsoft
            )
        |confirm[ ]this[ ]mail[ ]server
        |connection[ ](?:
            dropped
           |refused[ ]by
           |reset[ ]by[ ]peer
           |was[ ]dropped[ ]by[ ]remote[ ]host
           )
        |domain[ ]does[ ]not[ ]exist:
        |domain[ ].+[ ]mismatches[ ]client[ ]ip
        |dns[ ]lookup[ ]failure:[ ].+[ ]try[ ]again[ ]later
        |DNSBL:ATTRBL
        |Go[ ]away
        |hosts[ ]with[ ]dynamic[ ]ip
        |IP[ ]\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}[ ]is[ ]blocked[ ]by[ ]EarthLink # Earthlink
        |IP[/]domain[ ]reputation[ ]problems
        |is[ ]not[ ]allowed[ ]to[ ]send[ ]mail[ ]from
        |mail[ ]server[ ]at[ ].+[ ]is[ ]blocked
        |Messages[ ]from[ ].+[ ]temporarily[ ]deferred[ ]due[ ]to[ ]user[ ]complaints   # Yahoo!
        |no[ ]access[ ]from[ ]mail[ ]server
        |Not[ ]currently[ ]accepting[ ]mail[ ]from[ ]your[ ]ip  # Microsoft
        |Please[ ]get[ ]a[ ]custom[ ]reverse[ ]DNS[ ]name[ ]from[ ]your[ ]ISP[ ]for[ ]your[ ]host
        |please[ ]use[ ]the[ ]smtp[ ]server[ ]of[ ]your[ ]ISP
        |Rejecting[ ]open[ ]proxy   # Sendmail(srvrsmtp.c)
        |sorry,[ ](?:
             that[ ]domain[ ]isn'?t[ ]in[ ]my[ ]list[ ]of[ ]allowed[ ]rcpthosts
            |your[ ]remotehost[ ]looks[ ]suspiciously[ ]like[ ]spammer
            )
        |SPF[ ]record
        |the[ ](?:email|domain|ip).+[ ]is[ ]blacklisted
        |unresolvable[ ]relay[ ]host[ ]name
        |your[ ](?:
             network[ ]is[ ]temporary[ ]blacklisted
            |server[ ]requires[ ]confirmation
            )
        |was[ ]blocked[ ]by[ ].+
        |we[ ]do[ ]not[ ]accept[ ]mail[ ]from[ ](?: # @mail.ru
             hosts[ ]with[ ]dynamic[ ]IP[ ]or[ ]generic[ ]dns[ ]PTR-records
            |dynamic[ ]ips
            )
        |http://www[.]spamcop[.]net/bl[.]
        )
    }xi;

    return 1 if $argv1 =~ $regex;
    return 0;
}

sub true {
    # Rejected due to client IP address or hostname
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is blocked
    #           [Integer]               0: is not blocked by the client
    # @see      http://www.ietf.org/rfc/rfc2822.txt
    # @since v4.0.0
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    return 1 if $argvs->reason eq __PACKAGE__->text;

    require Sisimai::SMTP::Status;
    my $statuscode = $argvs->deliverystatus // '';
    my $diagnostic = $argvs->diagnosticcode // '';
    my $tempreason = Sisimai::SMTP::Status->name($statuscode);
    my $reasontext = __PACKAGE__->text;
    my $v = 0;

    if( $tempreason eq $reasontext ) {
        # Delivery status code points "blocked".
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

Sisimai::Reason::Blocked - Bounce reason is "blocked" or not.

=head1 SYNOPSIS

    use Sisimai::Reason::Blocked;
    print Sisimai::Reason::Blocked->match('Access from ip address 192.0.2.1 blocked'); # 1

=head1 DESCRIPTION

Sisimai::Reason::Blocked checks the bounce reason is "blocked" or not. This
class is called only Sisimai::Reason class.

This is the error that SMTP connection was rejected due to a client IP address
or a hostname, or the parameter of "HELO/EHLO" command. This reason has added
in Sisimai 4.0.0 and does not exist in any version of bounceHammer.

    <kijitora@example.net>: 
    Connected to 192.0.2.112 but my name was rejected. 
    Remote host said: 501 5.0.0 Invalid domain name 

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: "blocked".

    print Sisimai::Reason::Blocked->text;  # blocked

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::Blocked->match('Access from ip address 192.0.2.1 blocked');  # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is "blocked". The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2017 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
