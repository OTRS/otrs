package Sisimai::Data::YAML;
use feature ':5.10';
use strict;
use warnings;

sub dump {
    # Data dumper(YAML)
    # @param    [Sisimai::Data] argvs   Object
    # @return   [String, Undef]         Dumped data or Undef if the argument is
    #                                   missing
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    my $damneddata = undef;
    my $yamlstring = undef;
    my $modulename = undef;

    eval {
        require YAML;
        $modulename = 'YAML';
    };
    if( $@ ) {
        # Try to load YAML::Syck
        eval { 
            require YAML::Syck;
            $modulename = 'YAML::Syck';
        };
        die ' ***error: Neither "YAML" nor "YAML::Syck" module is installed' if $@;
    }

    $damneddata = $argvs->damn;
    if( $modulename eq 'YAML' ) {
        # Use YAML module
        $YAML::SortKeys       = 1;
        $YAML::Stringify      = 0;
        $YAML::UseHeader      = 1;
        $YAML::UseBlock       = 0;
        $YAML::CompressSeries = 0;
        $yamlstring = YAML::Dump($damneddata);

    } elsif( $modulename eq 'YAML::Syck' ) {
        # Use YAML::Syck module instead of YAML module.
        $YAML::Syck::ImplicitTyping  = 1;
        $YAML::Syck::Headless        = 0;
        $YAML::Syck::ImplicitUnicode = 1;
        $YAML::Syck::SingleQuote     = 0;
        $YAML::Syck::SortKeys        = 1;
        $yamlstring = YAML::Syck::Dump($damneddata);
    }

    return $yamlstring;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Data::YAML - Dumps parsed data object as a YAML format

=head1 SYNOPSIS

    use Sisimai::Data;
    my $data = Sisimai::Data->make('data' => <Sisimai::Message> object);
    for my $e ( @$data ) {
        print $e->dump('yaml');
    }

=head1 DESCRIPTION

Sisimai::Data::YAML dumps parsed data object as a YAML format. This class and 
method should be called from the parent object "Sisimai::Data".

=head1 CLASS METHODS

=head2 C<B<dump(I<Sisimai::Data>)>>

C<dump> method returns Sisimai::Data object as a YAML formatted string.

    my $mail = Sisimai::Mail->new('/var/mail/root');
    while( my $r = $mail->read ) {
        my $mesg = Sisimai::Message->new('data' => $r);
        my $data = Sisimai::Data->make('data' => $mesg);
        for my $e ( @$data ) {
            print $e->dump('yaml');
        }
    }

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
