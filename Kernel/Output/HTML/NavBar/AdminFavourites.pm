# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::HTML::NavBar::AdminFavourites;

use parent 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Unicode::Collate::Locale;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::JSON',
    'Kernel::System::User',
);

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get process management configuration
    my $FrontendModuleConfig     = $ConfigObject->Get('Frontend::Module')->{Admin};
    my $FrontendNavigationConfig = $ConfigObject->Get('Frontend::Navigation')->{Admin};

    # check if the registration config is valid
    return if !IsHashRefWithData($FrontendModuleConfig);
    return if !IsHashRefWithData($FrontendNavigationConfig);
    return if !IsArrayRefWithData( $FrontendNavigationConfig->{'001-Framework'} );

    my $NameForID = $FrontendNavigationConfig->{'001-Framework'}->[0]->{Name};
    $NameForID =~ s/[ &;]//ig;

    # check if the module name is valid
    return if !$NameForID;

    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $PrefFavourites = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $UserPreferences{AdminNavigationBarFavourites},
    ) || [];

    my %Return = %{ $Param{NavBar}->{Sub} || {} };

    my @Favourites;
    MODULE:
    for my $Module ( sort @{$PrefFavourites} ) {
        my $ModuleConfig = $ConfigObject->Get('Frontend::NavigationModule')->{$Module};
        next MODULE if !$ModuleConfig;
        $ModuleConfig->{Link} //= "Action=$Module";
        push @Favourites, $ModuleConfig;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

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

    if (@Favourites) {
        my $AdminModuleConfig = $ConfigObject->Get('Frontend::NavigationModule')->{Admin};
        $AdminModuleConfig->{Name} = $LayoutObject->{LanguageObject}->Translate('Overview');
        $AdminModuleConfig->{Link} //= "Action=Admin";
        unshift @Favourites, $AdminModuleConfig;
    }

    my $Counter = 0;
    for my $Favourite (@Favourites) {
        $Return{ $FrontendModuleConfig->{NavBarName} }->{$Counter} = $Favourite;
        $Counter++;
    }

    return ( Sub => \%Return );
}

1;
