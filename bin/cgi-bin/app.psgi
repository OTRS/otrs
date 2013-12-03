#!/usr/bin/perl
# --
# bin/cgi-bin/app.psgi - Plack startup file for OTRS
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)

use CGI;
use CGI::Emulate::PSGI;
use Module::Refresh;
use Plack::Builder;

# Workaround: some parts of OTRS use exit to interrupt the control flow.
#   This would kill the Plack server, so just use die instead.
BEGIN {
    *CORE::GLOBAL::exit = sub { die; };
}

print STDERR "PLEASE NOTE THAT PLACK SUPPORT IS CURRENTLY EXPERIMENTAL AND NOT SUPPORTED!\n";

my $App = CGI::Emulate::PSGI->handler(
    sub {

        # Cleanup values from previous requests.
        CGI::initialize_globals();

        # Populate SCRIPT_NAME as OTRS needs it in some places.
        ( $ENV{SCRIPT_NAME} ) = $ENV{PATH_INFO} =~ m{/([A-Za-z\-_]+\.pl)};

        # Fallback to agent login if we could not determine handle...
        if ( !defined $ENV{SCRIPT_NAME} || !-e "bin/cgi-bin/$ENV{SCRIPT_NAME}" ) {
            $ENV{SCRIPT_NAME} = 'index.pl';
        }

        eval {

            # Reload files in @INC that have changed since the last request.
            Module::Refresh->refresh();

            # Load the requested script
            do "bin/cgi-bin/$ENV{SCRIPT_NAME}";
        };
        }
);

# Small helper function to determine the path to a static file
my $StaticPath = sub {

    # Everything in otrs-web/js or otrs-web/skins is a static file.
    return 0 if $_ !~ m{-web/js/|-web/skins/};

    # Return only the relative path.
    $_ =~ s{^.*?-web/(js/.*|skins/.*)}{$1}smx;
    return $_;
};

# Create a Static middleware to serve static files directly without invoking the OTRS
#   application handler.
builder {
    enable "Static", path => $StaticPath, root => "$Bin/../../var/httpd/htdocs", pass_trough => 0;
    $App;
}
