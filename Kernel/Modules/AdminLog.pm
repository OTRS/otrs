# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminLog;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # print form
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # get log data
    my $Log = $Self->{LogObject}->GetLog( Limit => 400 ) || '';

    # split data to lines
    my @Message = split /\n/, $Log;

    # create table
    ROW:
    for my $Row (@Message) {

        my @Parts = split /;;/, $Row;

        next ROW if !$Parts[3];

        my $ErrorClass = ( $Parts[1] =~ /error/ ) ? 'Error' : '';

        $Self->{LayoutObject}->Block(
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

    # create & return output
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminLog',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
