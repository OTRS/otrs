# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBar::ModuleAdmin;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get UserID param
    $Self->{UserID} = $Param{UserID} || die "Got no UserID!";

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # only show it on admin start screen
    return '' if $LayoutObject->{Action} ne 'Admin';

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # generate manual link
    my $ManualVersion = $ConfigObject->Get('Version');
    $ManualVersion =~ m{^(\d{1,2}).+};
    $ManualVersion = $1;

    $LayoutObject->Block(
        Name => 'AdminNavBar',
        Data => {
            ManualVersion => $ManualVersion,
        },
    );

    # get all Frontend::Module
    my %NavBarModule;
    my $FrontendModuleConfig = $ConfigObject->Get('Frontend::Module');
    MODULE:
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {
        my %Hash = %{ $FrontendModuleConfig->{$Module} };
        if (
            $Hash{NavBarModule}
            && $Hash{NavBarModule}->{Module} eq 'Kernel::Output::HTML::NavBar::ModuleAdmin'
            )
        {

            # check permissions (only show accessable modules)
            my $Shown = 0;
            for my $Permission (qw(GroupRo Group)) {

                # array access restriction
                if ( $Hash{$Permission} && ref $Hash{$Permission} eq 'ARRAY' ) {
                    for ( @{ $Hash{$Permission} } ) {
                        my $Key = 'UserIs' . $Permission . '[' . $_ . ']';
                        if (
                            $LayoutObject->{$Key}
                            && $LayoutObject->{$Key} eq 'Yes'
                            )
                        {
                            $Shown = 1;
                        }

                    }
                }

                # scalar access restriction
                elsif ( $Hash{$Permission} ) {
                    my $Key = 'UserIs' . $Permission . '[' . $Hash{$Permission} . ']';
                    if ( $LayoutObject->{$Key} && $LayoutObject->{$Key} eq 'Yes' ) {
                        $Shown = 1;
                    }
                }

                # no access restriction
                elsif ( !$Hash{GroupRo} && !$Hash{Group} ) {
                    $Shown = 1;
                }

            }
            next MODULE if !$Shown;

            my $Key = sprintf( "%07d", $Hash{NavBarModule}->{Prio} || 0 );
            COUNT:
            for ( 1 .. 51 ) {
                if ( $NavBarModule{$Key} ) {
                    $Hash{NavBarModule}->{Prio}++;
                    $Key = sprintf( "%07d", $Hash{NavBarModule}->{Prio} );
                }
                if ( !$NavBarModule{$Key} ) {
                    last COUNT;
                }
            }
            $NavBarModule{$Key} = {
                'Frontend::Module' => $Module,
                %Hash,
                %{ $Hash{NavBarModule} },
            };

        }
    }
    my %Count;
    for my $Module ( sort keys %NavBarModule ) {
        my $BlockName = $NavBarModule{$Module}->{NavBarModule}->{Block} || 'Item';
        $LayoutObject->Block(
            Name => $BlockName,
            Data => $NavBarModule{$Module},
        );
        if ( $Count{$BlockName}++ % 2 ) {
            $LayoutObject->Block( Name => $BlockName . 'Clear' );
        }
    }

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AdminNavigationBar',
        Data         => \%Param,
    );

    return $Output;
}

1;
