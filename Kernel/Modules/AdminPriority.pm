# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminPriority;

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

    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my %GetParam = ();
        $GetParam{PriorityID} = $ParamObject->GetParam( Param => 'PriorityID' ) || '';
        my %PriorityData = $PriorityObject->PriorityGet(
            PriorityID => $GetParam{PriorityID},
            UserID     => $Self->{UserID},
        );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %PriorityData,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPriority',
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

        # get params
        for my $Parameter (qw(PriorityID Name ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update priority
            my $Update = $PriorityObject->PriorityUpdate(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($Update) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'Priority updated!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminPriority',
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
            TemplateFile => 'AdminPriority',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        $GetParam{PriorityID} = $ParamObject->GetParam( Param => 'PriorityID' ) || '';
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminPriority',
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

        # get params
        for my $Parameter (qw(PriorityID Name ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            my $NewPriority = $PriorityObject->PriorityAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );

            if ($NewPriority) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'Priority added!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminPriority',
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
            TemplateFile => 'AdminPriority',
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
            TemplateFile => 'AdminPriority',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOptionStrg} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
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

    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    # get priority list
    my %PriorityList = $PriorityObject->PriorityList(
        Valid  => 0,
        UserID => $Self->{UserID},
    );

    # if there are any priorities defined, they are shown
    if (%PriorityList) {

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        for my $PriorityID ( sort { $a <=> $b } keys %PriorityList ) {

            # get priority data
            my %PriorityData = $PriorityObject->PriorityGet(
                PriorityID => $PriorityID,
                UserID     => $Self->{UserID},
            );

            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    %PriorityData,
                    PriorityID => $PriorityID,
                    Valid      => $ValidList{ $PriorityData{ValidID} },
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
