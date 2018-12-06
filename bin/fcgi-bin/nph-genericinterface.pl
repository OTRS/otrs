#!/usr/bin/perl
# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

# use ../../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin/../../Kernel/cpan-lib";
use lib "$Bin/../../Custom";

# Imports the library; required line
use CGI::Fast;

# load generic interface
use Kernel::GenericInterface::Provider;
use Kernel::System::ObjectManager;

# response loop
while ( my $WebRequest = new CGI::Fast ) {

    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Web::Request' => {
            WebRequest => $WebRequest,
        }
    );
    my $Provider = Kernel::GenericInterface::Provider->new();

    $Provider->Run();
}
