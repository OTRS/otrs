# --
# Kernel/Modules/Test.pm - a simple test module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Test.pm,v 1.16 2008-05-08 09:36:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::Test;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.16 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get test page header
    my $Output = $Self->{LayoutObject}->Header( Title => 'OTRS Test Page' );

    # example blocks
    $Self->{LayoutObject}->Block(
        Name => 'Row',
        Data => {
            Text    => 'Some Text for the first line',
            Counter => 1,
        },
    );
    $Self->{LayoutObject}->Block(
        Name => 'Row',
        Data => {
            Text    => 'Some Text for the next line',
            Counter => 2,
        },
    );
    for ( 1 .. 2 ) {

        # fist block
        $Self->{LayoutObject}->Block(
            Name => 'System',
            Data => {
                Type    => 'System',
                Counter => $_,
            },
        );

        # sub block of System
        $Self->{LayoutObject}->Block(
            Name => 'User',
            Data => {
                Type    => 'User',
                Counter => $_,
            },
        );

        # sub blocks of User
        $Self->{LayoutObject}->Block(
            Name => 'UserID',
            Data => {
                Type    => 'UserID',
                Counter => $_,
            },
        );

        # just if $_ > 1
        if ( $_ > 1 ) {
            $Self->{LayoutObject}->Block(
                Name => 'UserID',
                Data => {
                    Type    => 'UserID',
                    Counter => $_,
                },
            );
        }

        # add this block 3 times
        for ( 4 .. 6 ) {
            $Self->{LayoutObject}->Block(
                Name => 'UserIDA',
                Data => {
                    Type    => 'UserIDA',
                    Counter => $_,
                },
            );
        }
    }

    # add the times block at least
    $Self->{LayoutObject}->Block(
        Name => 'Times',
        Data => {
            Type    => 'Times',
            Counter => 443,
        },
    );

    # get test page
    $Output .= $Self->{LayoutObject}->Output( TemplateFile => 'Test', Data => \%Param );

    # get test page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return test page
    return $Output;
}

1;
