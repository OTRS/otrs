#!/usr/bin/perl
# --
# bin/otrs.CheckCloudServices.pl - OTRS Cloud Services test check
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

use Net::SSLeay;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;

use Kernel::System::ObjectManager;

# get options
my %Opts;
getopt( 'h', \%Opts );

# display help
if ( $Opts{h} ) {
    print <<EOF;
$0 - checks OTRS Cloud Services connection
Copyright (C) 2001-2015 OTRS AG, http://otrs.com/

Usage: $0
EOF
    exit 1;
}

# set trace level
$Net::SSLeay::trace = 3;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.CheckCloudServices.pl',
    },
);

# print WebUserAgent settings if any
my $ConfigObject           = $Kernel::OM->Get('Kernel::Config');
my $Timeout                = $ConfigObject->Get('WebUserAgent::Timeout') || '';
my $Proxy                  = $ConfigObject->Get('WebUserAgent::Proxy') || '';
my $DisableSSLVerification = $ConfigObject->Get('WebUserAgent::DisableSSLVerification') || '';

# remove credentials if any
if ($Proxy) {
    $Proxy =~ s{\A.+?(http)}{$1};
}
if ( $Timeout || $Proxy || $DisableSSLVerification ) {

    print "Sending request with the following options:\n";

    if ( $Proxy =~ m{\A ( http(?: s)? :// (?: \d{1,3}\.){3}\d{1,3}) : (\d+) /\z}msx ) {
        print "  Proxy Address: $1\n";
        print "  Proxy Port: $2\n";
    }
    elsif ($Proxy) {
        print "  Proxy String: $Proxy\n";
    }

    if ($Timeout) {
        print "  Timeout: $Timeout second(s)\n";
    }

    if ($DisableSSLVerification) {
        print "  Disable SSL Verification: Yes\n"
    }
    print "\n";
}
else {
    print "Sending request...\n\n";
}

# prepare request data
my $RequestData = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
    Data => {
        Test => [
            {
                Operation => 'Test',
                Data      => {
                    Success => 1,
                },
            },
        ],
    },
);

# remember the time when the request is sent
my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
my $TimeStart  = $TimeObject->SystemTime();

# send request
my %Response = $Kernel::OM->Get('Kernel::System::WebUserAgent')->Request(
    Type => 'POST',
    URL  => 'https://cloud.otrs.com/otrs/public.pl',
    Data => {
        Action      => 'PublicCloudService',
        RequestData => $RequestData,
    },
);

# calculate and print the time spent in the request
my $TimeEnd  = $TimeObject->SystemTime();
my $TimeDiff = $TimeEnd - $TimeStart;
print "Response time:\n  $TimeDiff second(s)\n\n";

# dump the request response
my $Dump = $Kernel::OM->Get('Kernel::System::Main')->Dump(
    \%Response,
    'ascii',
);

# remove heading and tailing dump output
$Dump =~ s{\A \$VAR1 [ ] = [ ] \{\n\s}{}msx;
$Dump =~ s{\};\n\z}{}msx;

# print response
print "Response:\n $Dump\n";

# check for suggestions
my %Suggestions;

if ( $Proxy && $Proxy !~ m{/\z}msx ) {
    $Suggestions{WrongProxyEndLine} = 1;
}
if ( $Response{Status} =~ m{504}msx || $TimeDiff > $Timeout ) {
    $Suggestions{IncreseTimeout} = 1;
}

# print suggestions if any
if (%Suggestions) {
    print "Suggestions:\n";
    if ( $Suggestions{WrongProxyEndLine} ) {
        print
            "  The proxy string settings does not end with a '/', update your setting 'WebUserAgent::Proxy' as: $Proxy/\n";
    }
    if ( $Suggestions{IncreseTimeout} ) {
        print "  Please increase the time out setting 'WebUserAgent::Timeout' and try again\n";
    }
}

exit;
