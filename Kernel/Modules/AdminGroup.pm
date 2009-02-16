# --
# Kernel/Modules/AdminGroup.pm - to add/update/delete groups
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminGroup.pm,v 1.31 2009-02-16 11:20:52 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminGroup;

use strict;
use warnings;

use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.31 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject GroupObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
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
            || $Self->{ParamObject}->GetParam( Param => 'GroupID' )
            || '';
        my %Data = $Self->{GroupObject}->GroupGet( ID => $ID );
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGroupForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {
        my $Note = '';
        my %GetParam;
        for (qw(ID Name Comment ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # update group
        if ( !$Self->{GroupObject}->GroupUpdate( %GetParam, UserID => $Self->{UserID} ) ) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Change',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminGroupForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Info => 'Group updated!' );
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGroupForm',
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
            TemplateFile => 'AdminGroupForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {
        my $Note = '';
        my %GetParam;
        for (qw(ID Name Comment ValidID)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # add user
        my $GroupID = $Self->{GroupObject}->GroupAdd( %GetParam, UserID => $Self->{UserID} );

        # error message if add user is false
        if (!$GroupID) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );
            $Self->_Edit(
                Action => 'Add',
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminGroupForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # redirect
        if (
            !$Self->{ConfigObject}->Get('Frontend::Module')->{AdminUserGroup}
            && $Self->{ConfigObject}->Get('Frontend::Module')->{AdminRoleGroup}
            )
        {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminRoleGroup&Subaction=Group&ID=$GroupID",
            );
        }
        if ( $Self->{ConfigObject}->Get('Frontend::Module')->{AdminUserGroup} ) {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminUserGroup&Subaction=Group&ID=$GroupID",
            );
        }
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AdminGroup', );
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminGroupForm',
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
    $Param{ValidOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{ValidObject}->ValidList(), },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => \%Param,
    );
    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );
    my %List = $Self->{GroupObject}->GroupList( ValidID => 0, );

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();
    my $CssClass  = 'searchactive';
    for ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        # set output class
        $CssClass = $CssClass eq 'searchactive' ? 'searchpassive' : 'searchactive' ;

        my %Data = $Self->{GroupObject}->GroupGet( ID => $_, );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid    => $ValidList{ $Data{ValidID} },
                CssClass => $CssClass,
                %Data,
            },
        );
    }
    return 1;
}

1;
