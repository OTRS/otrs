package Mail::Mailer::test;
use vars qw(@ISA);
require Mail::Mailer::rfc822;
@ISA = qw(Mail::Mailer::rfc822);

sub can_cc { 0 }

sub exec {
    my($self, $exe, $args, $to) = @_;
    print 'to: ' . join(' ',@{$to}) . "\n";
    untie(*$self) if tied *$self;
    tie *$self, 'Mail::Mailer::test::pipe', $self;
    $self;
}

sub close { 1 }

package Mail::Mailer::test::pipe;

sub TIEHANDLE {
    my $pkg = shift;
    my $self = shift;
    return bless \$self;
}

sub PRINT {
    my $self = shift;
    print @_;
}

1;
