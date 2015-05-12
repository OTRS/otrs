# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::Notification::Generic;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::Output::HTML::Layout',
    'Kernel::Config',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # define default value
    my %Arguments = (
        Priority => 'Warning',
    );

    # Check which class to add
    if ( $Param{Config}->{Priority} && $Param{Config}->{Priority} eq 'Error' ) {
        $Arguments{Priority} = 'Error';
    }
    elsif ( $Param{Config}->{Priority} && $Param{Config}->{Priority} eq 'Success' ) {
        $Arguments{Priority} = 'Success';
    }
    elsif ( $Param{Config}->{Priority} && $Param{Config}->{Priority} eq 'Info' ) {
        $Arguments{Priority} = 'Info';
    }

    if ( $Param{Config}->{Text} ) {
        $Arguments{Info} = $Param{Config}->{Text};
    }
    elsif ( $Param{Config}->{File} ) {

        $Param{Config}->{File} =~ s{<OTRS_CONFIG_(.+?)>}{$Kernel::OM->Get('Kernel::Config')->Get($1)}egx;

        return '' if !-e $Param{Config}->{File};

        # try to read the file
        my $FileContent = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Param{Config}->{File},
            Mode     => 'utf8',
            Type     => 'Local',
            Result   => 'SCALAR',
        );

        return '' if !$FileContent;
        return '' if ref $FileContent ne 'SCALAR';

        $Arguments{Info} = ${$FileContent};
    }
    else {
        return '';
    }

    # add link if available
    if ( $Param{Config}->{Link} ) {
        $Arguments{Link} = $Param{Config}->{Link};
    }

    return '' if !$Arguments{Info};

    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Notify(%Arguments);
}

1;
