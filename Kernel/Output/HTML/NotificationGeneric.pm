# --
# Kernel/Output/HTML/NotificationGeneric.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationGeneric;

use strict;
use warnings;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject TimeObject MainObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # define default value
    my %Arguments = (
        Priority => 'Warning',
    );

    # switch to priotity error
    if ( $Param{Config}->{Priority} && $Param{Config}->{Priority} eq 'Error' ) {
        $Arguments{Priority} = 'Error';
    }

    if ( $Param{Config}->{Text} ) {
        $Arguments{Info} = $Param{Config}->{Text};
    }
    elsif ( $Param{Config}->{File} ) {

        $Param{Config}->{File} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;

        return '' if !-e $Param{Config}->{File};

        # try to read the file
        my $FileContent = $Self->{MainObject}->FileRead(
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

    return $Self->{LayoutObject}->Notify(%Arguments);
}

1;
