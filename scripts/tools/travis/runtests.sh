#!/bin/bash
set -ev

if [ $DB = 'postgresql' ]; then
    # PostgreSQL data is on a small ramdisk in Travis; make sure that it stays small by always performing VACUUM FULL.
    perl bin/otrs.Console.pl Dev::UnitTest::Run --post-test-script 'psql -U postgres -c "VACUUM FULL"'
else
    perl bin/otrs.Console.pl Dev::UnitTest::Run
fi
