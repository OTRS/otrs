
package Mail::Mailer::testfile;
use vars qw(@ISA $VERSION %config);

require Mail::Mailer::rfc822;
@ISA = qw(Mail::Mailer::rfc822);
$VERSION = '0.02';

use Mail::Util qw/mailaddress/;

%config = (outfile => 'mailer.testfile');

sub can_cc { 0 }

my $num = 0;

sub exec {
    my($self, $exe, $args, $to) = @_;
    open F,'>>', $Mail::Mailer::testfile::config{outfile};
    print F "\n===\ntest ", ++$num, " ",
            (scalar localtime),
            "\nfrom: " . mailaddress(),
            "\nto: " . join(' ',@{$to}), "\n\n";
    close F;
    untie(*$self) if tied *$self;
    tie *$self, 'Mail::Mailer::testfile::pipe', $self;
    $self;
}

sub close { 1 }

package Mail::Mailer::testfile::pipe;

sub TIEHANDLE {
    my $pkg = shift;
    my $self = shift;
    return bless \$self;
}

sub PRINT {
    my $self = shift;
    open F, '>>', $Mail::Mailer::testfile::config{outfile};
    print F @_;
    close F;
}

1;
