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
         access[ ]denied[.][ ]ip[ ]name[ ]lookup[ ]failed
        |access[ ]from[ ]ip[ ]address[ ].+[ ]blocked
        |all[ ]mail[ ]servers[ ]must[ ]have[ ]a[ ]ptr[ ]record[ ]with[ ]a[ ]valid[ ]reverse[ ]dns[ ]entry
        |bad[ ]sender[ ]ip[ ]address
        |banned[ ]sending[ ]ip  # Office365
        |blacklisted[ ]by
        |(?:blocked|refused)[ ]-[ ]see[ ]https?://
        |blocked[ ]using[ ]
        |can[']t[ ]determine[ ]purported[ ]responsible[ ]address
        |cannot[ ](?:
             find[ ]your[ ]hostname
            |resolve[ ]your[ ]address
            )
        |client[ ]host[ ](?:
             .+[ ]blocked[ ]using
            |rejected:[ ](?:
                 abus[ ]detecte[ ]gu_eib_0[24]      # SFR
                |cannot[ ]find[ ]your[ ]hostname    # Yahoo!
                |may[ ]not[ ]be[ ]mail[ ]exchanger
                |was[ ]not[ ]authenticated          # Microsoft
                )
            )
        |confirm[ ]this[ ]mail[ ]server
        |connection[ ](?:
            dropped
           |refused[ ]by
           |reset[ ]by[ ]peer
           |was[ ]dropped[ ]by[ ]remote[ ]host
           )
        |connections[ ](?:
             not[ ]accepted[ ]from[ ]ip[ ]addresses[ ]on[ ]spamhaus[ ]xbl
            |will[ ]not[ ]be[ ]accepted[ ]from[ ].+because[ ]the[ ]ip[ ]is[ ]in[ ]spamhaus's[ ]list
            )
        |currently[ ]sending[ ]spam[ ]see:[ ]
        |domain[ ](?:
             .+[ ]mismatches[ ]client[ ]ip
            |does[ ]not[ ]exist:
            )
        |dns[ ]lookup[ ]failure:[ ].+[ ]try[ ]again[ ]later
        |dnsbl:attrbl
        |dynamic/zombied/spam[ ]ips[ ]blocked
        |email[ ]blocked[ ]by[ ](?:.+[.]barracudacentral[.]org|spamhaus)
        |esmtp[ ]not[ ]accepting[ ]connections  # icloud.com
        |fix[ ]reverse[ ]dns[ ]for[ ].+
        |go[ ]away
        |helo[ ]command[ ]rejected:
        |host[ ].+[ ]refused[ ]to[ ]talk[ ]to[ ]me:[ ]\d+[ ]blocked
        |hosts[ ]with[ ]dynamic[ ]ip
        |http://(?:
             spf[.]pobox[.]com/why[.]html
            |www[.]spamcop[.]net/bl[.]
            )
        |invalid[ ]ip[ ]for[ ]sending[ ]mail[ ]of[ ]domain
        |ip[ ]\d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}[ ]is[ ]blocked[ ]by[ ]earthlink # Earthlink
        |ip[/]domain[ ]reputation[ ]problems
        |ips[ ]with[ ]missing[ ]ptr[ ]records
        |is[ ](?:
             in[ ]a[ ]black[ ]list[ ]at[ ].+[.]
            |in[ ]an[ ].*rbl[ ]on[ ].+
            |not[ ]allowed[ ]to[ ]send[ ](?:
                 mail[ ]from
                |from[ ].+[ ]per[ ]it's[ ]spf[ ]record
                )
            )
        |mail[ ]server[ ]at[ ].+[ ]is[ ]blocked
        |mail[ ]from[ ]\d+[.]\d+[.]\d+[.]\d[ ]refused:
        |message[ ]from[ ].+[ ]rejected[ ]based[ ]on[ ]blacklist
        |messages[ ]from[ ].+[ ]temporarily[ ]deferred[ ]due[ ]to[ ]user[ ]complaints   # Yahoo!
        |no[ ](?:
             access[ ]from[ ]mail[ ]server
            |ptr[ ]record[ ]found[.]
            )
        |not[ ]currently[ ]accepting[ ]mail[ ]from[ ]your[ ]ip  # Microsoft
        |part[ ]of[ ]their[ ]network[ ]is[ ]on[ ]our[ ]block[ ]list
        |please[ ](?:
             get[ ]a[ ]custom[ ]reverse[ ]dns[ ]name[ ]from[ ]your[ ]isp[ ]for[ ]your[ ]host
            |inspect[ ]your[ ]spf[ ]settings
            |use[ ]the[ ]smtp[ ]server[ ]of[ ]your[ ]isp
            )
        |ptr[ ]record[ ]setup
        |rejecting[ ]open[ ]proxy   # Sendmail(srvrsmtp.c)
        |reverse[ ]dns[ ](?:
              failed
             |required
             |lookup[ ]for[ ]host[ ].+[ ]failed[ ]permanently
             )
        |sender[ ]ip[ ](?:
             address[ ]rejected
            |reverse[ ]lookup[ ]rejected
            )
        |server[ ]access[ ](?:
             .+[ ]forbidden[ ]by[ ]invalid[ ]rdns[ ]record[ ]of[ ]your[ ]mail[ ]server
            |forbidden[ ]by[ ]your[ ]ip[ ]
            )
        |server[ ]ip[ ].+[ ]listed[ ]as[ ]abusive
        |service[ ]permits[ ]\d+[ ]unverifyable[ ]sending[ ]ips
        |smtp[ ]error[ ]from[ ]remote[ ]mail[ ]server[ ]after[ ]initial[ ]connection:   # Exim
        |sorry,[ ](?:
             that[ ]domain[ ]isn'?t[ ]in[ ]my[ ]list[ ]of[ ]allowed[ ]rcpthosts
            |your[ ]remotehost[ ]looks[ ]suspiciously[ ]like[ ]spammer
            )
        |spf[ ](?:
             .+[ ]domain[ ]authentication[ ]fail
            |record
            |check:[ ]fail
            )
        |spf:[ ].+[ ]is[ ]not[ ]allowed[ ]to[ ]send[ ]mail.+[a-z]{3}.+401
        |the[ ](?:email|domain|ip).+[ ]is[ ]blacklisted
        |this[ ]system[ ]will[ ]not[ ]accept[ ]messages[ ]from[ ]servers[/]devices[ ]with[ ]no[ ]reverse[ ]dns
        |too[ ]many[ ]spams[ ]from[ ]your[ ]ip  # free.fr
        |unresolvable[ ]relay[ ]host[ ]name
        |veuillez[ ]essayer[ ]plus[ ]tard.+[a-z]{3}.+(?:103|510)
        |your[ ](?:
             network[ ]is[ ]temporary[ ]blacklisted
            |sender's[ ]ip[ ]address[ ]is[ ]listed[ ]at[ ].+[.]abuseat[.]org
            |server[ ]requires[ ]confirmation
            )
        |was[ ]blocked[ ]by[ ].+
        |we[ ]do[ ]not[ ]accept[ ]mail[ ]from[ ](?: # @mail.ru
             dynamic[ ]ips
            |hosts[ ]with[ ]dynamic[ ]ip[ ]or[ ]generic[ ]dns[ ]ptr-records
            )
        |you[ ]are[ ](?:
             not[ ]allowed[ ]to[ ]connect
            |sending[ ]spam
            )
        |your[ ](?:
             access[ ]to[ ]submit[ ]messages[ ]to[ ]this[ ]e-mail[ ]system[ ]has[ ]been[ ]rejected
            |message[ ]was[ ]rejected[ ]for[ ]possible[ ]spam/virus[ ]content
            )
        )
    }x;

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

    return 1 if $argvs->reason eq 'blocked';
    return 1 if Sisimai::SMTP::Status->name($argvs->deliverystatus) eq 'blocked';
    return 1 if __PACKAGE__->match(lc $argvs->diagnosticcode);
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

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
