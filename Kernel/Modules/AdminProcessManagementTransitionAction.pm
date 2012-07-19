# --
# Kernel/Modules/AdminProcessManagementTransitionAction.pm - process management transition action
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagementTransitionAction.pm,v 1.1 2012-07-19 14:14:16 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementTransitionAction;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Transition;

use Kernel::System::VariableCheck qw(:all);

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

    # create additional objects
    $Self->{JSONObject}   = Kernel::System::JSON->new( %{$Self} );
    $Self->{EntityObject} = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{TransitionObject}
        = Kernel::System::ProcessManagement::DB::Transition->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $ActivityID = $Self->{ParamObject}->GetParam( Param => 'ID' )       || '';
    my $EntityID   = $Self->{ParamObject}->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Self->{SessionObject}->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Self->{JSONObject}->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    # ------------------------------------------------------------ #
    # TransitionActionNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'TransitionActionNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # TransitionActionNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionActionNewAction' ) {

    }

    # ------------------------------------------------------------ #
    # TransitionActionEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionActionEdit' ) {

    }

    # ------------------------------------------------------------ #
    # TransitionActionEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionActionEditAction' ) {

    }

    # ------------------------------------------------------------ #
    # Error
    # ------------------------------------------------------------ #
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "This subaction is not valid",
        );
    }
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    $Param{Title} = 'Create New Transition Action';

    my $Output = $Self->{LayoutObject}->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementTransitionAction",
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
