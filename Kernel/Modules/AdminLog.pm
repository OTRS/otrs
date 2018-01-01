# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminLog;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Print form.
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    # Get log data.
    my $Log = $Kernel::OM->Get('Kernel::System::Log')->GetLog( Limit => 400 ) || '';

    # Split data to lines.
    my @Message = split /\n/, $Log;

    # Create table.
    ROW:
    for my $Row (@Message) {

        my @Parts = split /;;/, $Row;

        next ROW if !$Parts[3];

        my $ErrorClass = ( $Parts[1] =~ /error/ ) ? 'Error' : '';

        $LayoutObject->Block(
            Name => 'Row',
            Data => {
                ErrorClass => $ErrorClass,
                Time       => $Parts[0],
                Priority   => $Parts[1],
                Facility   => $Parts[2],
                Message    => $Parts[3],
            },
        );
    }

    # Print no data found message.
    if ( !@Message ) {
        $LayoutObject->Block(
            Name => 'AdminLogNoDataRow',
            Data => {},
        );
    }

    # Create & return output.
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminLog',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

1;
