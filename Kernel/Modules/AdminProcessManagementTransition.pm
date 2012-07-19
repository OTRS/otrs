# --
# Kernel/Modules/AdminProcessManagementTransition.pm - process management transition
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagementTransition.pm,v 1.1 2012-07-19 14:14:16 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementTransition;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity;
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
    $Self->{JSONObject}     = Kernel::System::JSON->new( %{$Self} );
    $Self->{EntityObject}   = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{ActivityObject} = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );
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
    # TransitionNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'TransitionNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # TransitionNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionNewAction' ) {

    }

    # ------------------------------------------------------------ #
    # TransitionEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionEdit' ) {

    }

    # ------------------------------------------------------------ #
    # TransitionEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionEditAction' ) {

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

    $Param{Title} = 'Create New Transition';

    my $Output = $Self->{LayoutObject}->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );

    $Param{ConditionLinking} = $Self->{LayoutObject}->BuildSelection(
        Data => [ 'and', 'or', 'xor' ],
        Name => 'ConditionLinking',
        ID   => 'ConditionLinking',
        Sort => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc',
    );

    $Param{ConditionFieldType} = $Self->{LayoutObject}->BuildSelection(
        Data => [ 'String', 'Hash', 'Array', 'Regexp', 'Module' ],
        Name => 'ConditionFieldType',
        ID   => 'ConditionFieldType',
        Sort => 'AlphanumericKey',
        Translation => 1,
    );

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementTransition",
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
