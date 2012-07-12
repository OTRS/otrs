# --
# Kernel/Modules/AdminProcessManagement.pm - process management
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagement.pm,v 1.6 2012-07-12 17:40:48 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagement;

use strict;
use warnings;

use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::Activity::ActivityDialog;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Process::State;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

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
    $Self->{ProcessObject}  = Kernel::System::ProcessManagement::DB::Process->new( %{$Self} );
    $Self->{EntityObject}   = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{ActivityObject} = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );
    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::DB::Activity::ActivityDialog->new( %{$Self} );
    $Self->{StateObject} = Kernel::System::ProcessManagement::DB::Process::State->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $ProcessID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

    # ------------------------------------------------------------ #
    # ProcessNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ProcessNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # ProcessNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessNewAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get process data
        my $ProcessData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ProcessData->{Name}                  = $GetParam->{Name};
        $ProcessData->{Config}->{Description} = $GetParam->{Description};
        $ProcessData->{StateEntityID}         = $GetParam->{StateEntityID};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Description} ) {

            # add server error error class
            $Error{DescriptionServerError}        = 'ServerError';
            $Error{DescriptionServerErrorMessage} = 'This field is required';
        }

        # check if state exists
        my $StateList = $Self->{StateObject}->StateList( UserID => $Self->{UserID} );

        if ( !$StateList->{ $GetParam->{StateEntityID} } )
        {

            # add server error error class
            $Error{StateEntityIDServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ProcessData => $ProcessData,
                Action      => 'New',
            );
        }

        # generate entity ID
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'Process',
            UserID     => $Self->{UserID},
        );

        # otherwise save configuration and return to overview screen
        my $ProcessID = $Self->{ProcessObject}->ProcessAdd(
            Name          => $ProcessData->{Name},
            EntityID      => $EntityID,
            StateEntityID => $ProcessData->{StateEntityID},
            Layout        => {},
            Config        => $ProcessData->{Config},
            UserID        => $Self->{UserID},
        );

        # show error if cant create
        if ( !$ProcessID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the process",
            );
        }

        my $Success = $Self->{EntityObject}->EntityIDUpdate(
            EntityType => 'Process',
            UserID     => $Self->{UserID},
        );

        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the entity counters",
            );
        }

        # return to overview
        return $Self->_ShowOverview();
    }

    # ------------------------------------------------------------ #
    # ProcessEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessEdit' ) {

        # check for ProcessID
        if ( !$ProcessID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need ProcessID!",
            );
        }

        # get Process data
        my $ProcessData = $Self->{ProcessObject}->ProcessGet(
            ID     => $ProcessID,
            UserID => $Self->{UserID},
        );

        # check for valid Process data
        if ( !IsHashRefWithData($ProcessData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for ProcessID $ProcessID",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            ProcessID   => $ProcessID,
            ProcessData => $ProcessData,
            Action      => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # ProcessEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessEditAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get webserice configuration
        my $ProcessData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ProcessData->{Name}                  = $GetParam->{Name};
        $ProcessData->{EntityID}              = $GetParam->{EntityID};
        $ProcessData->{StateEntityID}         = $GetParam->{StateEntityID};
        $ProcessData->{Config}->{Description} = $GetParam->{Description};

        #TODO also get Layout and other prameters

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Description} ) {

            # add server error error class
            $Error{DescriptionServerError}        = 'ServerError';
            $Error{DescriptionServerErrorMessage} = 'This field is required';
        }

        # check if state exists
        my $StateList = $Self->{StateObject}->StateList( UserID => $Self->{UserID} );

        if ( !$StateList->{ $GetParam->{StateEntityID} } )
        {

            # add server error error class
            $Error{StateEntityIDServerError} = 'ServerError';
        }

        #TODO check also other parameters

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ProcessData => $ProcessData,
                Action      => 'Edit',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $Self->{ProcessObject}->ProcessUpdate(
            ID            => $ProcessID,
            Name          => $ProcessData->{Name},
            EntityID      => $ProcessData->{EntityID},
            StateEntityID => $ProcessData->{StateEntityID},
            Layout        => {},
            Config        => $ProcessData->{Config},
            UserID        => $Self->{UserID},
        );

        # show error if cant update
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the process",
            );
        }

        # return to overview
        return $Self->_ShowOverview();
    }

    # ------------------------------------------------------------ #
    # Overview
    # ------------------------------------------------------------ #
    else {
        return $Self->_ShowOverview();
    }
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # get a process list
    my $ProcessList = $Self->{ProcessObject}->ProcessList( UserID => $Self->{UserID} );

    # get each process data
    for my $ProcessID ( sort keys %{$ProcessList} ) {
        my $ProcessData = $Self->{ProcessObject}->ProcessGet(
            ID     => $ProcessID,
            UserID => $Self->{UserID},
        );

        # print each process in overview table
        $Self->{LayoutObject}->Block(
            Name => 'ProcessRow',
            Data => {
                %{$ProcessData},
                Description => $ProcessData->{Config}->{Description},
                }
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminProcessManagement',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get process information
    my $ProcessData = $Param{ProcessData} || {};

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        #TODO Add Transition and TransitionAction to Elements when backend and frontennds are ready
        # ouput available process elements in the accordion
        for my $Element (qw(Activity ActivityDialog)) {

            my $ElementMethod = $Element . 'ListGet';

            # get a list of all elements with details
            my $ElementList
                = $Self->{ $Element . 'Object' }->$ElementMethod( UserID => $Self->{UserID} );

            # check there are elements to display
            if ( IsArrayRefWithData($ElementList) ) {
                for my $ElementData ( @{$ElementList} ) {

                    # print each element in the accordion
                    $Self->{LayoutObject}->Block(
                        Name => $Element . 'Row',
                        Data => {
                            %{$ElementData},
                        },
                    );
                }
            }
            else {

                # print no data found in the accordion
                $Self->{LayoutObject}->Block(
                    Name => $Element . 'NoDataRow',
                    Data => {},
                );
            }
        }
    }

    # get a list of all states
    my $StateList = $Self->{StateObject}->StateList( UserID => $Self->{UserID} );

    my $StateError = '';
    if ( $Param{StateEntityIDServerError} ) {
        $StateError = $Param{StateEntityIDServerError};
    }

    # create estate selection
    $Param{StateSelection} = $Self->{LayoutObject}->BuildSelection(
        Data       => $StateList                    || {},
        Name       => 'StateEntityID',
        ID         => 'StateEntityID',
        SelectedID => $ProcessData->{StateEntityID} || '',
        Sort       => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc ' . $StateError,
    );

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementProcess$Param{Action}",
        Data         => {
            %Param,
            %{$ProcessData},
            Description => $ProcessData->{Config}->{Description} || '',
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw( Name EntityID Description StateEntityID )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

    return $GetParam;
}

1;
