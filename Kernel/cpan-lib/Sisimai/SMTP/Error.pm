package Sisimai::SMTP::Error;
use feature ':5.10';
use strict;
use warnings;
use Sisimai::SMTP::Reply;
use Sisimai::SMTP::Status;

my $SoftOrHard = {
    'soft' => [qw|
        blocked contenterror exceedlimit expired filtered mailboxfull mailererror
        mesgtoobig networkerror norelaying policyviolation rejected securityerror
        spamdetected suspend syntaxerror systemerror systemfull toomanyconn virusdetected
    |],
    'hard' => [qw|hasmoved hostunknown userunknown|],
};

sub is_permanent {
    # Permanent error or not
    # @param    [String] argv1  String including SMTP Status code
    # @return   [Integer]       1:     Permanet error
    #                           0:     Temporary error
    #                           undef: is not an error
    # @since v4.17.3
    my $class = shift;
    my $argv1 = shift || return undef;

    my $statuscode   = Sisimai::SMTP::Status->find($argv1);
       $statuscode ||= Sisimai::SMTP::Reply->find($argv1);
    my $classvalue   = int(substr($statuscode, 0, 1) || 0);
    my $getchecked = undef;

    if( $classvalue > 0 ) {
        # 2, 4, or 5
        if( $classvalue == 5 ) {
            # Permanent error
            $getchecked = 1;

        } elsif( $classvalue == 4 ) {
            # Temporary error
            $getchecked = 0;

        } elsif( $classvalue == 2 ) {
            # Succeeded
            $getchecked = undef;
        }
    } else {
        # Check with regular expression
        my $v = lc $argv1;
        if( rindex($v, 'temporar') > -1 || rindex($v, 'persistent') > -1 ) {
            # Temporary failure
            $getchecked = 0;

        } elsif( rindex($v, 'permanent') > -1 ) {
            # Permanently failure
            $getchecked = 1;

        } else {
            # did not find information to decide that it is a soft bounce
            # or a hard bounce.
            $getchecked = undef;
        }
    }
    return $getchecked;
}

sub soft_or_hard {
    # Check softbounce or not
    # @param    [String] argv1  Detected bounce reason
    # @param    [String] argv2  String including SMTP Status code
    # @return   [String]        'soft': Soft bounce
    #                           'hard': Hard bounce
    #                           '':     May not be bounce ?
    # @since v4.17.3
    my $class = shift;
    my $argv1 = shift || return '';
    my $argv2 = shift || '';

    my $getchecked = undef;
    my $statuscode = undef;
    my $classvalue = undef;
    my $softorhard = undef;

    if( $argv1 eq 'deliverd' || $argv1 eq 'feedback' || $argv1 eq 'vacation' ) {
        # These are not dealt as a bounce reason
        $softorhard = '';

    } elsif( $argv1 eq 'onhold' || $argv1 eq 'undefined' ) {
        # It should be "soft" when a reason is "onhold" or "undefined"
        $softorhard = 'soft';

    } elsif( $argv1 eq 'notaccept' ) {
        # NotAccept: 5xx => hard bounce, 4xx => soft bounce
        if( $argv2 ) {
            # Get D.S.N. or SMTP reply code from The 2nd argument string
            $statuscode   = Sisimai::SMTP::Status->find($argv2);
            $statuscode ||= Sisimai::SMTP::Reply->find($argv2);
            $classvalue   = int(substr($statuscode, 0, 1) || 0);
            $softorhard   = $classvalue == 4 ? 'soft' : 'hard';

        } else {
            # "notaccept" is a hard bounce
            $softorhard = 'hard';
        }
    } else {
        # Check all the reasons defined at the above
        SOFT_OR_HARD: for my $e ('hard', 'soft') {
            # Soft or Hard?
            for my $f ( @{ $SoftOrHard->{ $e } } ) {
                # Hard bounce?
                next unless $argv1 eq $f;
                $softorhard = $e;
                last(SOFT_OR_HARD);
            }
        }
    }
    $softorhard //= '';
    return $softorhard;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::SMTP::Error - SMTP Errors related utilities

=head1 SYNOPSIS

    use Sisimai::SMTP::Error;
    print Sisimai::SMTP::Error->is_permanent('SMTP error message');
    print Sisimai::SMTP::Error->soft_or_hard('userunknown', 'SMTP error message');

=head1 DESCRIPTION

Sisimai::SMTP::Error provide method to check an SMTP errors.

=head1 CLASS METHODS

=head2 C<B<is_permanent(I<String>)>>

C<is_permanent()> checks the given string points an permanent error or not.

    print Sisimai::SMTP::Error->is_permanent('5.1.1 User unknown'); # 1
    print Sisimai::SMTP::Error->is_permanent('4.2.2 Mailbox Full'); # 0
    print Sisimai::SMTP::Error->is_permanent('2.1.5 Message Sent'); # undef

=head2 C<B<soft_or_hard(I<String>, I<String>)>>

C<soft_or_hard()> returns string 'soft' if given bounce reason is a soft bounce.
When the reason is a hard bounce, this method returns 'hard'. If the return
value is an empty string, it means that returned email may not be a bounce.

    print Sisimai::SMTP::Error->soft_or_hard('userunknown', '5.1.1 No such user');   # 'hard'
    print Sisimai::SMTP::Error->soft_or_hard('mailboxfull');                         # 'soft'
    print Sisimai::SMTP::Error->soft_or_hard('vacation');                            # ''

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

