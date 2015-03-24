# --
# Kernel/System/Console/Command/Admin/Package/RepositoryList.pm - console command
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::Package::RepositoryList;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Package',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List all known OTRS package repsitories.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Listing OTRS package repositories...</yellow>\n");

    my $Count = 0;
    my %List;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Package::RepositoryList') ) {
        %List = %{ $Kernel::OM->Get('Kernel::Config')->Get('Package::RepositoryList') };
    }
    %List = ( %List, $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineRepositories() );

    if ( !%List ) {
        $Self->PrintError("No package repositories configured.");
        return $Self->ExitCodeError();
    }

    for my $URL ( sort { $List{$a} cmp $List{$b} } keys %List ) {
        $Count++;
        print "+----------------------------------------------------------------------------+\n";
        print "| $Count) Name: $List{$URL}\n";
        print "|    URL:  $URL\n";
    }
    print "+----------------------------------------------------------------------------+\n";
    print "\n";

    $Self->Print("<yellow>Listing OTRS package repository contents...</yellow>\n");

    for my $URL ( sort { $List{$a} cmp $List{$b} } keys %List ) {
        print
            "+----------------------------------------------------------------------------+\n";
        print "| Package Overview for Repository $List{$URL}:\n";
        my @Packages = $Kernel::OM->Get('Kernel::System::Package')->PackageOnlineList(
            URL  => $URL,
            Lang => $Kernel::OM->Get('Kernel::Config')->Get('DefaultLanguage'),
        );
        my $PackageCount = 0;
        PACKAGE:
        for my $Package (@Packages) {

            # just shown in list if PackageIsVisible flag is enable
            if (
                defined $Package->{PackageIsVisible}
                && !$Package->{PackageIsVisible}->{Content}
                )
            {
                next PACKAGE;
            }
            $PackageCount++;
            print
                "+----------------------------------------------------------------------------+\n";
            print "| $PackageCount) Name:        $Package->{Name}\n";
            print "|    Version:     $Package->{Version}\n";
            print "|    Vendor:      $Package->{Vendor}\n";
            print "|    URL:         $Package->{URL}\n";
            print "|    License:     $Package->{License}\n";
            print "|    Description: $Package->{Description}\n";
            print "|    Install:     $URL:$Package->{File}\n";
        }
        print
            "+----------------------------------------------------------------------------+\n";
        print "\n";
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
