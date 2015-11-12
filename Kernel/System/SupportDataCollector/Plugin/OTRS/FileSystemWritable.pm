# --
# Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm - system data collector plugin
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::OTRS::FileSystemWritable;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub GetDisplayPath {
    return 'OTRS';
}

sub Run {
    my $Self = shift;

    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my @TestDirectories = qw(
        /bin/
        /Kernel/
        /Kernel/System/
        /Kernel/Output/
        /Kernel/Output/HTML/
        /Kernel/Modules/
    );

    my @ReadonlyDirectories;

    for my $TestDirectory (@TestDirectories) {
        my $File = "$Home/$TestDirectory/check_permissons.$$";
        if ( open( my $FH, '>', "$File" ) ) {    ## no critic
            print $FH "test";
            close($FH);
            unlink $File;
        }
        else {
            push @ReadonlyDirectories, $TestDirectory;
        }
    }

    if (@ReadonlyDirectories) {
        $Self->AddResultProblem(
            Label   => 'File System Writable',
            Value   => join( ', ', @ReadonlyDirectories ),
            Message => 'The file system on your OTRS partition is not writable.',
        );
    }
    else {
        $Self->AddResultOk(
            Label => 'File System Writable',
            Value => '',
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
