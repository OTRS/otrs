#!/bin/bash
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

set -ev

if [ $DB = 'postgresql' ]; then
    # PostgreSQL data is on a small ramdisk in Travis; make sure that it stays small by always performing VACUUM FULL.
    perl bin/otrs.Console.pl Dev::UnitTest::Run --post-test-script 'psql -U postgres otrs -c "VACUUM FULL"'
else
    perl bin/otrs.Console.pl Dev::UnitTest::Run
fi
