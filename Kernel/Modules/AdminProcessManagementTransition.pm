# --
# Kernel/Modules/AdminProcessManagementTransition.pm - process management transition
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagementTransition.pm,v 1.3 2012-07-31 12:58:30 mab Exp $
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
$VERSION = qw($Revision: 1.3 $) [1];

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

    my $TransitionID = $Self->{ParamObject}->GetParam( Param => 'ID' )       || '';
    my $EntityID     = $Self->{ParamObject}->GetParam( Param => 'EntityID' ) || '';

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

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get transition action data
        my $TransitionData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new configuration
        $TransitionData->{Name}   = $GetParam->{Name};
        $TransitionData->{Config} = $GetParam->{Config};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                TransitionData => $TransitionData,
                Action         => 'New',
            );
        }

        # generate entity ID
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'Transition',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error generating a new EntityID for this Transition",
            );
        }

        # otherwise save configuration and return process screen
        my $TransitionID = $Self->{TransitionObject}->TransitionAdd(
            Name     => $TransitionData->{Name},
            EntityID => $EntityID,
            Config   => $TransitionData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$TransitionID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the Transition",
            );
        }

        # set entitty sync state
        my $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'Transition',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for Transition "
                    . "entity:$EntityID",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $TransitionID,
                EntityID  => $TransitionData->{EntityID},
                Subaction => 'TransitionEdit'               # always use edit screen
            );

            my $RedirectAction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectAction' ) || '';
            my $RedirectSubaction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectID' ) || '';
            my $RedirectEntityID
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectEntityID' ) || '';

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => $RedirectAction,
                    Subaction => $RedirectSubaction,
                    ID        => $RedirectID,
                    EntityID  => $RedirectID,
                },
            );
        }
        else {

            # remove last screen
            my $LastScreen = $Self->_PopSessionScreen();

            # check if needed to return to main screen or to be redirected to last screen
            if ( $LastScreen->{Action} eq 'AdminProcessManagement' ) {

                # close the popup
                return $Self->_PopupResponse(
                    ClosePopup => 1,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect => 1,
                    Screen   => $LastScreen
                );
            }
        }

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

    $Param{OverallConditionLinking} = $Self->{LayoutObject}->BuildSelection(
        Data => [ 'and', 'or', 'xor' ],
        Name => 'OverallConditionLinking',
        ID   => 'OverallConditionLinking',
        Sort => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc',
    );

    $Param{ConditionLinking} = $Self->{LayoutObject}->BuildSelection(
        Data => [ 'and', 'or', 'xor' ],
        Name => 'ConditionLinking[_INDEX_]',
        Sort => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc',
    );

    $Param{ConditionFieldType} = $Self->{LayoutObject}->BuildSelection(
        Data => [ 'String', 'Hash', 'Array', 'Regexp', 'Module' ],
        Name => 'ConditionFieldType[_INDEX_][_FIELDINDEX_]',
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

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    $GetParam->{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    $GetParam->{ConditionConfig} = $Self->{ParamObject}->GetParam( Param => 'ConditionConfig' )
        || '';

    my $Config = $Self->{JSONObject}->Decode(
        Data => $GetParam->{ConditionConfig}
    );
    $GetParam->{Config} = {};
    $GetParam->{Config}->{Condition} = $Config;

    return $GetParam;
}

sub _PopSessionScreen {
    my ( $Self, %Param ) = @_;

    my $LastScreen;

    if ( defined $Param{OnlyCurrent} && $Param{OnlyCurrent} == 1 ) {

        # check if last screen action is current screen action
        if ( $Self->{ScreensPath}->[-1]->{Action} eq $Self->{Action} ) {

            # remove last screen
            $LastScreen = pop @{ $Self->{ScreensPath} };
        }
    }
    else {

        # remove last screen
        $LastScreen = pop @{ $Self->{ScreensPath} };
    }

    # convert screens path to string (JSON)
    my $JSONScreensPath = $Self->{LayoutObject}->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return $LastScreen;
}

sub _PushSessionScreen {
    my ( $Self, %Param ) = @_;

    # add screen to the screen path
    push @{ $Self->{ScreensPath} }, {
        Action => $Self->{Action} || '',
        Subaction => $Param{Subaction},
        ID        => $Param{ID},
        EntityID  => $Param{EntityID},
    };

    # convert screens path to string (JSON)
    my $JSONScreensPath = $Self->{LayoutObject}->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return 1;
}

sub _PopupResponse {
    my ( $Self, %Param ) = @_;

    if ( $Param{Redirect} && $Param{Redirect} eq 1 ) {
        $Self->{LayoutObject}->Block(
            Name => 'Redirect',
            Data => {
                %{ $Param{Screen} },
            },
        );
    }
    elsif ( $Param{ClosePopup} && $Param{ClosePopup} eq 1 ) {
        $Self->{LayoutObject}->Block(
            Name => 'ClosePopup',
            Data => {},
        );
    }

    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementPopupResponse",
        Data         => {},
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

1;
