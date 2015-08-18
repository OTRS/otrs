# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRole;

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
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID = $ParamObject->GetParam( Param => 'ID' )
            || $ParamObject->GetParam( Param => 'RoleID' )
            || '';
        my %Data = $GroupObject->RoleGet(
            ID => $ID,
        );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRole',
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

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check for needed data
        if ( !$GetParam{Name} ) {
            $Errors{NameInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            my $RoleUpdate = $GroupObject->RoleUpdate(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($RoleUpdate) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'Role updated!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminRole',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
            else {
                $Note = $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Note
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_Edit(
            Action => 'Change',
            %GetParam,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRole',
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
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRole',
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

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check for needed data
        if ( !$GetParam{Name} ) {
            $Errors{NameInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add role
            my $RoleID = $GroupObject->RoleAdd(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($RoleID) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => 'Role added!' );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminRole',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
            else {
                $Note = $LogObject->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }
        my $Output = $LayoutObject->Header();
        $Output .= $Note
            ? $LayoutObject->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
            %Errors,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminRole',
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
            TemplateFile => 'AdminRole',
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

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        Class      => 'Modernize',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
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
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );

    $LayoutObject->Block(
        Name => 'OverviewHeader',
        Data => {},
    );

    my %List = $GroupObject->RoleList(
        ValidID => 0,
    );

    # if there is data available, it is shown
    if (%List) {
        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
        for my $KeyList ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $GroupObject->RoleGet( ID => $KeyList );
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                },
            );
        }
    }

    # otherwise, a message is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoRolesDefined',
            Data => {},
        );
    }
    return 1;
}

1;
