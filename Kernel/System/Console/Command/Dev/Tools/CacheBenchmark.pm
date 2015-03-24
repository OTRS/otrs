# --
# Kernel/System/Console/Command/Dev/Tools/CacheBenchmark.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Dev::Tools::CacheBenchmark;

use strict;
use warnings;

use Time::HiRes ();

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Main',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Runs a benchmark over the available cache backends.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get home directory
    my $HomeDir = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    # get all avaliable backend modules
    my @BackendModuleFiles = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
        Directory => $HomeDir . '/Kernel/System/Cache/',
        Filter    => '*.pm',
        Silent    => 1,
    );

    MODULEFILE:
    for my $ModuleFile (@BackendModuleFiles) {

        next MODULEFILE if !$ModuleFile;

        # extract module name
        my ($Module) = $ModuleFile =~ m{ \/+ ([a-zA-Z0-9]+) \.pm $ }xms;

        next MODULEFILE if !$Module;

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'Cache::Module',
            Value => "Kernel::System::Cache::$Module",
        );

        # Make sure we get a fresh instance
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Cache'],
        );
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        if ( !$CacheObject->{CacheObject}->isa("Kernel::System::Cache::$Module") ) {
            die "Could not create cache backend Kernel::System::Cache::$Module";
        }

        $CacheObject->Configure(
            CacheInMemory  => 0,
            CacheInBackend => 1,
        );

        # create unique ID for this session
        my @Dictionary = ( "A" .. "Z" );
        my $SID;
        $SID .= $Dictionary[ rand @Dictionary ] for 1 .. 8;

        my $Result;
        my $SetOK;
        my $GetOK;
        my $DelOK;

        print "Testing cache module $Module\n";

        # load cache initially with 100k 1kB items
        print "Preloading cache with 100k x 1kB items... ";
        $| = 1;
        my $Content1kB = '.' x 1024;
        for ( my $i = 0; $i < 100000; $i++ ) {
            $Result = $CacheObject->Set(
                Type => 'CacheTestInitContent' . $SID . ( $i % 10 ),
                Key => 'Test' . $i,
                Value => $Content1kB,
                TTL   => 60 * 24 * 60 * 60,
            );
        }
        print "done.\n";

        print "Cache module    Item Size[b] Operations Time[s]    Op/s  Set OK  Get OK  Del OK\n";
        print "--------------- ------------ ---------- ------- ------- ------- ------- -------\n";

        for my $ItemSize ( 64, 256, 512, 1024, 4096, 10240, 102400, 1048576, 4194304 ) {

            my $Content = ' ' x $ItemSize;
            my $OpCount = 10 + 50 * int( 7 - Log10($ItemSize) );

            printf( "%-15s %12d %10d ", $Module, $ItemSize, 100 * $OpCount );
            $| = 1;

            # start timer
            my $Start = Time::HiRes::time();

            $SetOK = 0;
            for ( my $i = 0; $i < $OpCount; $i++ ) {
                $Result = $CacheObject->Set(
                    Type => 'CacheTest' . $SID . ( $i % 10 ),
                    Key => 'Test' . $i,
                    Value => $Content,
                    TTL   => 60 * 24,
                );
                $SetOK++ if $Result;
            }

            $GetOK = 0;
            for ( my $j = 0; $j < 98; $j++ ) {
                for ( my $i = 0; $i < $OpCount; $i++ ) {
                    $Result = $CacheObject->Get(
                        Type => 'CacheTest' . $SID . ( $i % 10 ),
                        Key => 'Test' . $i,
                    );

                    $GetOK++ if ( $Result && ( $Result eq $Content ) );
                }
            }

            $DelOK = 0;
            for ( my $i = 0; $i < $OpCount; $i++ ) {
                $Result = $CacheObject->Delete(
                    Type => 'CacheTest' . $SID . ( $i % 10 ),
                    Key => 'Test' . $i,
                );
                $DelOK++ if $Result;
            }

            # end timer
            my $Stop = Time::HiRes::time();

            # report
            printf(
                "%7.2f %7.0f %6.2f%% %6.2f%% %6.2f%%\n",
                ( $Stop - $Start ),
                100 * $OpCount / ( $Stop - $Start ),
                100 * $SetOK /   ($OpCount),
                100 * $GetOK /   ( 98 * $OpCount ),
                100 * $DelOK /   ($OpCount)
            );
        }

        # cleanup initial cache
        print "Removing preloaded 100k x 1kB items... ";
        for ( my $i = 0; $i < 10; $i++ ) {
            $Result = $CacheObject->CleanUp(
                Type => 'CacheTestInitContent' . $SID . ( $i % 10 ),
            );
        }
        print "done.\n";

    }

    return $Self->ExitCodeOk();
}

sub Log10 {
    my $n = shift;
    return log($n) / log(10);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
