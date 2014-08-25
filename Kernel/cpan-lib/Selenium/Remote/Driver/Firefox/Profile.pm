package Selenium::Remote::Driver::Firefox::Profile;
$Selenium::Remote::Driver::Firefox::Profile::VERSION = '0.2102';
# ABSTRACT: Use custom profiles with Selenium::Remote::Driver

use strict;
use warnings;

use Archive::Zip qw( :ERROR_CODES );
use Archive::Extract;
use Carp qw(croak);
use Cwd qw(abs_path);
use File::Copy qw(copy);
use File::Temp;
use MIME::Base64;
use Scalar::Util qw(looks_like_number);


sub new {
    my $class = shift;

    # TODO: add handling for a pre-existing profile folder passed into
    # the constructor

    # TODO: accept user prefs, boolean prefs, and extensions in
    # constructor
    my $self = {
        profile_dir => File::Temp->newdir(),
        user_prefs => {},
        extensions => []
      };
    bless $self, $class or die "Can't bless $class: $!";

    return $self;
}


sub set_preference {
    my ($self, %prefs) = @_;

    foreach (keys %prefs) {
        my $value = $prefs{$_};
        my $clean_value = '';

        if ($value =~ /^(['"]).*\1$/ or looks_like_number($value)) {
            # plain integers: 0, 1, 32768, or integers wrapped in strings:
            # "0", "1", "20140204". in either case, there's nothing for us
            # to do.
            $clean_value = $value;
        }
        else {
            # otherwise it's hopefully a string that we'll need to
            # quote on our own
            $clean_value = '"' . $value . '"';
        }

        $self->{user_prefs}->{$_} = $clean_value;
    }
}


sub set_boolean_preference {
    my ($self, %prefs) = @_;

    foreach (keys %prefs) {
        my $value = $prefs{$_};

        $self->{user_prefs}->{$_} = $value ? 'true' : 'false';
    }
}


sub get_preference {
    my ($self, $pref) = @_;

    return $self->{user_prefs}->{$pref};
}


sub add_extension {
    my ($self, $xpi) = @_;

    my $xpi_abs_path = abs_path($xpi);
    croak "$xpi_abs_path: extensions must be in .xpi format" unless $xpi_abs_path =~ /\.xpi$/;

    push (@{$self->{extensions}}, $xpi_abs_path);
}

sub _encode {
    my $self = shift;

    # The remote webdriver accepts the Firefox profile as a base64
    # encoded zip file
    $self->_layout_on_disk();

    my $zip = Archive::Zip->new();
    my $dir_member = $zip->addTree( $self->{profile_dir} );

    my $string = "";
    open (my $fh, ">", \$string);
    binmode($fh);
    unless ( $zip->writeToFileHandle($fh) == AZ_OK ) {
        die 'write error';
    }

    return encode_base64($string);
}

sub _layout_on_disk {
    my $self = shift;

    $self->_write_preferences();
    $self->_install_extensions();

    return $self->{profile_dir};
}

sub _write_preferences {
    my $self = shift;

    my $userjs = $self->{profile_dir} . "/user.js";
    open (my $fh, ">>", $userjs)
        or die "Cannot open $userjs for writing preferences: $!";

    foreach (keys %{$self->{user_prefs}}) {
        print $fh 'user_pref("' . $_ . '", ' . $self->get_preference($_) . ');' . "\n";
    }
    close ($fh);
}

sub _install_extensions {
    my $self = shift;
    my $extension_dir = $self->{profile_dir} . "/extensions/";
    mkdir $extension_dir unless -d $extension_dir;

    # TODO: handle extensions that need to be unpacked
    foreach (@{$self->{extensions}}) {
        # For Firefox to recognize the extension, we have to put the
        # .xpi in the /extensions/ folder and change the filename to
        # its id, which is found in the install.rdf in the root of the
        # zip.
        my $ae = Archive::Extract->new( archive => $_,
                                        type => "zip");

        my $tempDir = File::Temp->newdir();
        $ae->extract( to => $tempDir );
        my $install = $ae->extract_path();
        $install .= '/install.rdf';

        open (my $fh, "<", $install)
            or croak "No install.rdf inside $_: $!";
        my (@file) = <$fh>;
        close ($fh);

        my @name = grep { chomp; $_ =~ /<em:id>[^{]/ } @file;
        $name[0] =~ s/.*<em:id>(.*)<\/em:id>.*/$1/;

        my $xpi_dest = $extension_dir . $name[0] . ".xpi";
        copy($_, $xpi_dest)
            or croak "Error copying $_ to $xpi_dest : $!";
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Remote::Driver::Firefox::Profile - Use custom profiles with Selenium::Remote::Driver

=head1 VERSION

version 0.2102

=head1 DESCRIPTION

You can use this module to create a custom Firefox Profile for your
Selenium tests. Currently, you can set browser preferences and add
extensions to the profile before passing it in the constructor for a
new Selenium::Remote::Driver.

=head1 METHODS

=head2 set_preference

Set string and integer preferences on the profile object. You can set
multiple preferences at once. If you need to set a boolean preference,
see C<set_boolean_preference()>.

    $profile->set_preference("quoted.integer.pref" => '"20140314220517"');
    # user_pref("quoted.integer.pref", "20140314220517");

    $profile->set_preference("plain.integer.pref" => 9005);
    # user_pref("plain.integer.pref", 9005);

    $profile->set_preference("string.pref" => "sample string value");
    # user_pref("string.pref", "sample string value");

=head2 set_boolean_preference

Set preferences that require boolean values of 'true' or 'false'. You
can set multiple preferences at once. For string or integer
preferences, use C<set_preference()>.

    $profile->set_boolean_preference("false.pref" => 0);
    # user_pref("false.pref", false);

    $profile->set_boolean_preference("true.pref" => 1);
    # user_pref("true.pref", true);

=head2 get_preference

Retrieve the computed value of a preference. Strings will be double
quoted and boolean values will be single quoted as "true" or "false"
accordingly.

    $profile->set_boolean_preference("true.pref" => 1);
    print $profile->get_preference("true.pref") # true

    $profile->set_preference("string.pref" => "an extra set of quotes");
    print $profile->get_preference("string.pref") # "an extra set of quotes"

=head2 add_extension

Add an existing C<.xpi> to the profile by providing its path. This
only works with packaged C<.xpi> files, not plain/un-packed extension
directories.

    $profile->add_extension('t/www/redisplay.xpi');

=head1 SYNPOSIS

    use Selenium::Remote::Driver;
    use Selenium::Remote::Driver::Firefox::Profile;

    my $profile = Selenium::Remote::Driver::Firefox::Profile->new;
    $profile->set_preference(
        'browser.startup.homepage' => 'http://www.google.com',
        'browser.cache.disk.capacity' => 358400
    );

    $profile->set_boolean_preference(
        'browser.shell.checkDefaultBrowser' => 0
    );

    $profile->add_extension('t/www/redisplay.xpi');

    my $driver = Selenium::Remote::Driver->new(
        'firefox_profile' => $profile
    );

    $driver->get('http://www.google.com');
    print $driver->get_title();

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=item *

L<http://kb.mozillazine.org/About:config_entries|http://kb.mozillazine.org/About:config_entries>

=item *

L<https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/A_brief_guide_to_Mozilla_preferences|https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/A_brief_guide_to_Mozilla_preferences>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/gempesaw/Selenium-Remote-Driver/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHORS

=over 4

=item *

Aditya Ivaturi <ivaturi@gmail.com>

=item *

Daniel Gempesaw <gempesaw@gmail.com>

=item *

Luke Closs <cpan@5thplane.com>

=item *

Mark Stosberg <mark@stosberg.com>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Copyright (c) 2014 Daniel Gempesaw

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
