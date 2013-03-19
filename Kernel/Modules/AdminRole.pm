# --
# Kernel/Modules/AdminRole.pm - to add/update/delete roles
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminRole;

use strict;
use warnings;

use Kernel::System::Valid;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject ConfigObject LogObject GroupObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID
            = $Self->{ParamObject}->GetParam( Param => 'ID' )
            || $Self->{ParamObject}->GetParam( Param => 'RoleID' )
            || '';
        my %Data = $Self->{GroupObject}->RoleGet( ID => $ID, );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRole',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Comment ValidID)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check for needed data
        if ( !$GetParam{Name} ) {
            $Errors{NameInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update group
            my $RoleUpdate = $Self->{GroupObject}->RoleUpdate(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($RoleUpdate) {
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Role updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminRole',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }

        # something went wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Self->_Edit(
            Action => 'Change',
            %GetParam,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRole',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();
        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRole',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Comment ValidID)) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check for needed data
        if ( !$GetParam{Name} ) {
            $Errors{NameInvalid} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add role
            my $RoleID = $Self->{GroupObject}->RoleAdd(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($RoleID) {
                $Self->_Overview();
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Role added!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminRole',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Note = $Self->{LogObject}->GetLogEntry(
                    Type => 'Error',
                    What => 'Message',
                );
            }
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Note
            ? $Self->{LayoutObject}->Notify(
            Priority => 'Error',
            Info     => $Note,
            )
            : '';
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
            %Errors,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRole',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminRole',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewHeader',
        Data => {},
    );

    my %List = $Self->{GroupObject}->RoleList( ValidID => 0, );

    # if there is data available, it is shown
    if (%List) {
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );

        # get valid list
        my %ValidList = $Self->{ValidObject}->ValidList();
        for my $KeyList ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $Self->{GroupObject}->RoleGet( ID => $KeyList );
            $Self->{LayoutObject}->Block(
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
        $Self->{LayoutObject}->Block(
            Name => 'NoRolesDefined',
            Data => {},
        );
    }
    return 1;
}

1;
