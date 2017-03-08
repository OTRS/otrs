# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBar::ModuleAdmin;

use base 'Kernel::Output::HTML::Base';

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Group',
    'Kernel::System::JSON',
    'Kernel::System::User',
);

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

    # get all Frontend::Module
    my %NavBarModule;
    my $FrontendModuleConfig = $ConfigObject->Get('Frontend::Module');
    MODULE:
    for my $Module ( sort keys %{$FrontendModuleConfig} ) {

        my %Hash = %{ $FrontendModuleConfig->{$Module} };

        next MODULE if !$Hash{NavBarModule}->{Name};

        if (
            $Hash{NavBarModule}
            && $Hash{NavBarModule}->{Module} eq 'Kernel::Output::HTML::NavBar::ModuleAdmin'
            )
        {

            # check permissions (only show accessable modules)
            my $Shown       = 0;
            my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

            for my $Permission (qw(GroupRo Group)) {

                # array access restriction
                if ( $Hash{$Permission} && ref $Hash{$Permission} eq 'ARRAY' ) {
                    for my $Group ( @{ $Hash{$Permission} } ) {
                        my $HasPermission = $GroupObject->PermissionCheck(
                            UserID    => $Self->{UserID},
                            GroupName => $Group,
                            Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',
                        );
                        if ($HasPermission) {
                            $Shown = 1;
                        }

                    }
                }

                # scalar access restriction
                elsif ( $Hash{$Permission} ) {
                    my $HasPermission = $GroupObject->PermissionCheck(
                        UserID    => $Self->{UserID},
                        GroupName => $Hash{$Permission},
                        Type      => $Permission eq 'GroupRo' ? 'ro' : 'rw',
                    );
                    if ($HasPermission) {
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

    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    my @Favourites;
    my @FavouriteModules;
    my $PrefFavourites = $JSONObject->Decode(
        Data => $UserPreferences{AdminNavigationBarFavourites},
    ) || [];

    my @NavBarModule;
    for my $Item ( sort keys %NavBarModule ) {
        if ( grep { $_ eq $NavBarModule{$Item}->{'Frontend::Module'} } @{$PrefFavourites} ) {
            push @Favourites,       $NavBarModule{$Item};
            push @FavouriteModules, $NavBarModule{$Item}->{'Frontend::Module'};
            $NavBarModule{$Item}->{IsFavourite} = 1;
        }
        push @NavBarModule, $NavBarModule{$Item};
    }

    @NavBarModule = sort {
        $LayoutObject->{LanguageObject}->Translate( $a->{Name} )
            cmp $LayoutObject->{LanguageObject}->Translate( $b->{Name} )
    } @NavBarModule;
    @Favourites = sort {
        $LayoutObject->{LanguageObject}->Translate( $a->{Name} )
            cmp $LayoutObject->{LanguageObject}->Translate( $b->{Name} )
    } @Favourites;

    $LayoutObject->Block(
        Name => 'AdminNavBar',
        Data => {
            ManualVersion => $ManualVersion,
            View          => $UserPreferences{AdminNavigationBarView} || 'Grid',
            Items         => \@NavBarModule,
            Favourites    => \@Favourites,
        },
    );

    $LayoutObject->AddJSData(
        Key   => 'Favourites',
        Value => \@FavouriteModules,
    );

    my $Output = $LayoutObject->Output(
        TemplateFile => 'AdminNavigationBar',
        Data         => \%Param,
    );

    return $Output;
}

1;
