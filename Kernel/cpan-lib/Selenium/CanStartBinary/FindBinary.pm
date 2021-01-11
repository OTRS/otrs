package Selenium::CanStartBinary::FindBinary;
$Selenium::CanStartBinary::FindBinary::VERSION = '1.39';
use strict;
use warnings;

# ABSTRACT: Coercions for finding webdriver binaries on your system
use Cwd qw/abs_path/;
use File::Which qw/which/;
use IO::Socket::INET;
use Selenium::Firefox::Binary qw/firefox_path/;

require Exporter;
our @ISA       = qw/Exporter/;
our @EXPORT_OK = qw/coerce_simple_binary coerce_firefox_binary/;

use constant IS_WIN => $^O eq 'MSWin32';


sub coerce_simple_binary {
    my ($executable) = @_;

    my $manual_binary = _validate_manual_binary($executable);
    if ($manual_binary) {
        return $manual_binary;
    }
    else {
        return _naive_find_binary($executable);
    }
}

sub coerce_firefox_binary {
    my ($executable) = @_;

    my $manual_binary = _validate_manual_binary($executable);
    if ($manual_binary) {
        return $manual_binary;
    }
    else {
        return firefox_path();
    }
}

sub _validate_manual_binary {
    my ($executable) = @_;

    my $abs_executable = eval {
        my $path = abs_path($executable);
        die unless -e $path;
        $path;
    };

    if ($abs_executable) {
        if ( -x $abs_executable || IS_WIN ) {
            return $abs_executable;
        }
        else {
            die 'The binary at '
              . $executable
              . ' is not executable. Choose the correct file or chmod +x it as needed.';
        }
    }
}

sub _naive_find_binary {
    my ($executable) = @_;

    my $naive_binary = which($executable);
    if ( defined $naive_binary ) {
        return $naive_binary;
    }
    else {
        warn qq(Unable to find the $executable binary in your \$PATH.);
        return;
    }
}

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::CanStartBinary::FindBinary - Coercions for finding webdriver binaries on your system

=head1 VERSION

version 1.39

=for Pod::Coverage *EVERYTHING*

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://github.com/teodesian/Selenium-Remote-Driver/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHORS

Current Maintainers:

=over 4

=item *

Daniel Gempesaw <gempesaw@gmail.com>

=item *

Emmanuel Peroumalnaïk <peroumalnaik.emmanuel@gmail.com>

=back

Previous maintainers:

=over 4

=item *

Luke Closs <cpan@5thplane.com>

=item *

Mark Stosberg <mark@stosberg.com>

=back

Original authors:

=over 4

=item *

Aditya Ivaturi <ivaturi@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Copyright (c) 2014-2017 Daniel Gempesaw

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut
