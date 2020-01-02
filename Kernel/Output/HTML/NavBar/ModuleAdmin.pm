# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::NavBar::ModuleAdmin;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;
use Unicode::Collate::Locale;

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

    my $Config           = $ConfigObject->Get('Frontend::Module')           || {};
    my $NavigationModule = $ConfigObject->Get('Frontend::NavigationModule') || {};

    MODULE:
    for my $Module ( sort keys %{$NavigationModule} ) {
        my %Hash = %{ $NavigationModule->{$Module} };

        next MODULE if !$Hash{Name};
        next MODULE if !$Config->{$Module};    # If module is not registered, skip it.

        if ( $Hash{Module} eq 'Kernel::Output::HTML::NavBar::ModuleAdmin' ) {

            # check permissions (only show accessable modules)
            my $Shown       = 0;
            my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

            for my $Permission (qw(GroupRo Group)) {

                # no access restriction
                if (
                    ref $Hash{GroupRo} eq 'ARRAY'
                    && !scalar @{ $Hash{GroupRo} }
                    && ref $Hash{Group} eq 'ARRAY'
                    && !scalar @{ $Hash{Group} }
                    )
                {
                    $Shown = 1;
                }

                # array access restriction
                elsif ( $Hash{$Permission} && ref $Hash{$Permission} eq 'ARRAY' ) {
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
            }
            next MODULE if !$Shown;

            $NavBarModule{$Module} = {
                'Frontend::Module' => $Module,
                %Hash,
            };
        }
    }

    # get modules which were marked as favorite by the current user
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );
    my @Favourites;
    my @FavouriteModules;
    my $PrefFavourites = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $UserPreferences{AdminNavigationBarFavourites},
    ) || [];

    @Favourites = sort {
        $LayoutObject->{LanguageObject}->Translate( $a->{Name} )
            cmp $LayoutObject->{LanguageObject}->Translate( $b->{Name} )
    } @Favourites;

    my @ModuleGroups;
    my $ModuleGroupsConfig = $ConfigObject->Get('Frontend::AdminModuleGroups');

    # get all registered groups
    for my $Group ( sort keys %{$ModuleGroupsConfig} ) {
        for my $Key ( sort keys %{ $ModuleGroupsConfig->{$Group} } ) {
            push @ModuleGroups, {
                'Key'   => $Key,
                'Order' => $ModuleGroupsConfig->{$Group}->{$Key}->{Order},
                'Title' => $ModuleGroupsConfig->{$Group}->{$Key}->{Title},
            };
        }
    }

    # sort groups by order number
    @ModuleGroups = sort { $a->{Order} <=> $b->{Order} } @ModuleGroups;

    my %Modules;
    ITEMS:
    for my $Module ( sort keys %NavBarModule ) {

        # dont show the admin overview as a tile
        next ITEMS if ( $NavBarModule{$Module}->{'Link'} && $NavBarModule{$Module}->{'Link'} eq 'Action=Admin' );

        if ( grep { $_ eq $Module } @{$PrefFavourites} ) {
            push @Favourites, $NavBarModule{$Module};
            $NavBarModule{$Module}->{IsFavourite} = 1;
        }

        # add the item to its Block
        my $Block = $NavBarModule{$Module}->{'Block'} || 'Miscellaneous';
        if ( !grep { $_->{Key} eq $Block } @ModuleGroups ) {
            $Block = 'Miscellaneous';
        }
        push @{ $Modules{$Block} }, $NavBarModule{$Module};
    }

    # Create collator according to the user chosen language.
    my $Collator = Unicode::Collate::Locale->new(
        locale => $LayoutObject->{LanguageObject}->{UserLanguage},
    );

    @Favourites = sort {
        $Collator->cmp(
            $LayoutObject->{LanguageObject}->Translate( $a->{Name} ),
            $LayoutObject->{LanguageObject}->Translate( $b->{Name} )
        )
    } @Favourites;

    for my $Favourite (@Favourites) {
        push @FavouriteModules, $Favourite->{'Frontend::Module'};
    }

    # Sort the items within the groups.
    for my $Block ( sort keys %Modules ) {
        for my $Entry ( @{ $Modules{$Block} } ) {
            $Entry->{NameTranslated} = $LayoutObject->{LanguageObject}->Translate( $Entry->{Name} );
        }
        @{ $Modules{$Block} }
            = sort { $Collator->cmp( $a->{NameTranslated}, $b->{NameTranslated} ) } @{ $Modules{$Block} };
    }

    $LayoutObject->Block(
        Name => 'AdminNavBar',
        Data => {
            ManualVersion => $ManualVersion,
            Items         => \%Modules,
            Groups        => \@ModuleGroups,
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
