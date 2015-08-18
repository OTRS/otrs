# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminState;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $StateObject  = $Kernel::OM->Get('Kernel::System::State');

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data = $StateObject->StateGet( ID => $ID );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name TypeID Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TypeID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update the state data
            my $UpdateSuccess = $StateObject->StateUpdate(
                %GetParam,
                UserID => $Self->{UserID},
            );

            # update was successful
            if ($UpdateSuccess) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'State updated!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminState',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID TypeID Name Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TypeID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add state
            my $StateID = $StateObject->StateAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );
            if ($StateID) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'State added!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminState',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $StateObject  = $Kernel::OM->Get('Kernel::System::State');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );
    $Param{StateTypeOption} = $LayoutObject->BuildSelection(
        Data       => { $StateObject->StateTypeList( UserID => 1 ), },
        Name       => 'TypeID',
        SelectedID => $Param{TypeID},
        Class => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
    );
    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $LayoutObject->Block( Name => 'HeaderEdit' );
    }
    else {
        $LayoutObject->Block( Name => 'HeaderAdd' );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my $StateObject = $Kernel::OM->Get('Kernel::System::State');
    my %List        = $StateObject->StateList(
        UserID => 1,
        Valid  => 0,
    );

    # if there are any states, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        for my $ListKey ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $StateObject->StateGet( ID => $ListKey );
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                },
            );
        }
    }

    # otherwise a no data found msg is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }
    return 1;
}

1;
