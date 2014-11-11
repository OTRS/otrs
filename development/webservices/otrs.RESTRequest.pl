#!/usr/bin/perl
# --
# otrs.RESTRequest.pl - sample to send a REST request to OTRS Generic Interface Ticket Connector
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use JSON;
use REST::Client;

# ---
# Variables to be defined

# This is the HOST for the web service the format is:
# <HTTP_TYPE>:://<OTRS_FQDN>/nph-genericinterface.pl
my $Host = 'http://localhost/otrs/nph-genericinterface.pl';

my $RestClient = REST::Client->new(
    {
        host => $Host,
    }
);

# This is the Controller and Request the format is:
# /Webservice/<WEB_SERVICE_NAME>/<RESOURCE>/<REQUEST_VALUE>
# or
# /WebserviceID/<WEB_SERVICE_ID>/<RESOURCE>/<REQUEST_VALUE>
# This example will retrieve the Ticket with the TicketID = 1 (<REQUEST_VALUE>)
my $ControllerAndRequest = '/Webservice/GenericTicketConnectorREST/Ticket/1';

my $Params = {
    UserLogin     => "some user login",       # to be filled with valid agent login
    Password      => "some user password",    # to be filled with valid agent password
    DynamicFields => 1,                       # optional, if set to 1,
                                              # ticket dynamic fields included in response
    AllArticles   => 1,                       # optional, if set to 1,
                                              # all ticket articles are included in response
                                              # more options to be found in
                                              # /Kernel/GenericInterface/Operation/Ticket/TicketGet.pm's
                                              # Run() subroutine documentation.
};

my @RequestParam;

# As sample web service configuration for TicketGet uses HTTP method GET all other parameters needs
# to be sent as URI query parameters

# ----
# For GET method
my $QueryParams = $RestClient->buildQuery( %{$Params} );

$ControllerAndRequest .= $QueryParams;

# The @RequestParam array on position 0 holds controller and request
@RequestParam = ($ControllerAndRequest);

$RestClient->GET(@RequestParam);

# ----

# # ----
# # For POST method
# my $JSONParams = encode_json $Params;

# # The @RequestParam array on position 0 holds controller and request
# # on position 1 it holds the JSON data string that gets posted
# @RequestParam = (
#   $ControllerAndRequest,
#   $JSONParams
# );

# $RestClient->POST(@RequestParam);
# # ----

# If the host isn't reachable, wrong configured or couldn't serve the requested page:
my $ResponseCode = $RestClient->responseCode();
if ( $ResponseCode ne '200' ) {
    print "Request failed, response code was: $ResponseCode\n";
    exit;
}

# If the request was answered correctly, we receive a JSON string here.
my $ResponseContent = $RestClient->responseContent();

my $Data = decode_json $ResponseContent;

# Just to print out the returned Data structure:
use Data::Dumper;
print "Response was:\n";
print Dumper($Data);
