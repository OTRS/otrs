# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBar::AdminFavourites;

use base 'Kernel::Output::HTML::Base';

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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
    return if !IsHashRefWithData( $FrontendNavigationConfig->{1} );

    my $NameForID = $FrontendNavigationConfig->{1}->{Name};
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
        my $ModuleConfig = $ConfigObject->Get('Frontend::Module')->{$Module};
        next MODULE if !$ModuleConfig;
        next MODULE if !$ModuleConfig->{NavBarModule};
        $ModuleConfig->{NavBarModule}->{Link} //= "Action=$Module";
        push @Favourites, $ModuleConfig->{NavBarModule};
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    @Favourites = sort {
        $LayoutObject->{LanguageObject}->Translate( $a->{Name} )
            cmp $LayoutObject->{LanguageObject}->Translate( $b->{Name} )
    } @Favourites;

    if (@Favourites) {
        my $AdminModuleConfig = $ConfigObject->Get('Frontend::Module')->{Admin};
        $AdminModuleConfig->{NavBarModule}->{Name} = $LayoutObject->{LanguageObject}->Translate('Overview');
        $AdminModuleConfig->{NavBarModule}->{Link} //= "Action=Admin";
        unshift @Favourites, $AdminModuleConfig->{NavBarModule};
    }

    my $Counter = 0;
    for my $Favourite (@Favourites) {
        $Return{ $FrontendModuleConfig->{NavBarName} }->{$Counter} = $Favourite;
        $Counter++;
    }

    return ( Sub => \%Return );
}

1;
