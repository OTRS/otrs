# --
# Kernel/Modules/AdminProcessManagement.pm - process management
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagement.pm,v 1.1 2012-07-09 12:56:01 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagement;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (
        qw(ParamObject DBObject LayoutObject ConfigObject LogObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    # ------------------------------------------------------------ #
    # ProcessNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ProcessNew' ) {

        $Param{StateSelection} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                0 => 'Active',
                1 => 'Inactive',
                2 => 'Fade Away',
            },
            Name  => 'StateID',
            ID    => 'StateID',
            Class => 'W50pc',
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminProcessManagementProcessNew',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # ProcessEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessEdit' ) {

        $Param{StateSelection} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                0 => 'Active',
                1 => 'Inactive',
                2 => 'Fade Away',
            },
            Name  => 'StateID',
            ID    => 'StateID',
            Class => 'W50pc',
        );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminProcessManagementProcessEdit',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # Overview
    # ------------------------------------------------------------ #
    else {

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminProcessManagement',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
