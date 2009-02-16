# --
# Kernel/Modules/AdminLog.pm - provides a log view for admins
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminLog.pm,v 1.22 2009-02-16 11:20:52 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminLog;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

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

    # create table
    my @Lines = split( /\n/, $Self->{LogObject}->GetLog( Limit => 400 ) );
    for (@Lines) {
        my @Row = split( /;;/, $_ );
        if ( $Row[3] ) {
            if ( $Row[1] =~ /error/ ) {
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        StartFont => '<font color ="red">',
                        StopFont  => '</font>',
                        Time      => $Row[0],
                        Priority  => $Row[1],
                        Facility  => $Row[2],
                        Message   => $Row[3],
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => {
                        Time     => $Row[0],
                        Priority => $Row[1],
                        Facility => $Row[2],
                        Message  => $Row[3],
                    },
                );
            }
        }
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
