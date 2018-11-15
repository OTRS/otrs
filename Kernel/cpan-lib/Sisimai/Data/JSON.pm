package Sisimai::Data::JSON;
use feature ':5.10';
use strict;
use warnings;
use JSON;

sub dump {
    # Data dumper(JSON)
    # @param    [Sisimai::Data] argvs   Object
    # @return   [String, Undef]         Dumped data or Undef if the argument is
    #                                   missing
    my $class = shift;
    my $argvs = shift // return undef;
    return undef unless ref $argvs eq 'Sisimai::Data';

    my $damneddata = undef;
    my $jsonstring = '';
    my $jsonparser = JSON->new;

    eval {
        $damneddata = $argvs->damn;
        $jsonparser->space_after(1);
        $jsonstring = $jsonparser->encode($damneddata);
    };
    warn sprintf(" ***warning: Something is wrong in JSON encoding: %s", $@) if $@;
    return $jsonstring;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Data::JSON - Dumps parsed data object as a JSON format

=head1 SYNOPSIS

    use Sisimai::Data;
    my $data = Sisimai::Data->make('data' => <Sisimai::Message> object);
    for my $e ( @$data ) {
        print $e->dump('json');
    }

=head1 DESCRIPTION

Sisimai::Data::JSON dumps parsed data object as a JSON format. This class and 
method should be called from the parent object "Sisimai::Data".

=head1 CLASS METHODS

=head2 C<B<dump(I<Sisimai::Data>)>>

C<dump> method returns Sisimai::Data object as a JSON formatted string.

    my $mail = Sisimai::Mail->new('/var/mail/root');
    while( my $r = $mail->read ) {
        my $mesg = Sisimai::Message->new('data' => $r);
        my $data = Sisimai::Data->make('data' => $mesg);
        for my $e ( @$data ) {
            print $e->dump('json');
        }
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
