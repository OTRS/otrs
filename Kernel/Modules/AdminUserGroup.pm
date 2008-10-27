# --
# Kernel/Modules/AdminUserGroup.pm - to add/update/delete groups <-> users
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminUserGroup.pm,v 1.30 2008-10-27 00:13:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminUserGroup;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.30 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
    $Param{NextScreen} = 'AdminUserGroup';

    # user <-> group 1:n
    if ( $Self->{Subaction} eq 'User' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get user data
        my %UserData = $Self->{UserObject}->GetUserData( UserID => $ID );

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        my %Types = ();
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my %Data = $Self->{GroupObject}->GroupGroupMemberList(
                UserID => $ID,
                Type   => $Type,
                Result => 'HASH',
            );
            $Types{$Type} = \%Data;
        }
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            Data => \%GroupData,
            %Types,
            ID   => $UserData{UserID},
            Name => $UserData{UserLogin},
            Type => 'User',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # group <-> user n:1
    elsif ( $Self->{Subaction} eq 'Group' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get user data
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        for ( keys %UserData ) {

            # get user data
            my %User = $Self->{UserObject}->GetUserData( UserID => $_, Cached => 1 );
            if ( $User{UserFirstname} && $User{UserLastname} ) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }

        # get permission list users
        my %Types = ();
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my %Data = $Self->{GroupObject}->GroupGroupMemberList(
                GroupID => $ID,
                Type    => $Type,
                Result  => 'HASH',
            );
            $Types{$Type} = \%Data;
        }

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupGet( ID => $ID );
        $Output .= $Self->MaskAdminUserGroupChangeForm(
            %Types,
            Data => \%UserData,
            ID   => $GroupData{ID},
            Name => $GroupData{Name},
            Type => 'Group',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # add user to groups
    elsif ( $Self->{Subaction} eq 'ChangeGroup' ) {

        # get new groups
        my %Permissions = ();
        for ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my @IDs = $Self->{ParamObject}->GetArray( Param => $_ );
            $Permissions{$_} = \@IDs;
        }

        # get group data
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        my %NewPermission = ();
        for ( keys %UserData ) {
            for my $Permission ( keys %Permissions ) {
                $NewPermission{$Permission} = 0;
                my @Array = @{ $Permissions{$Permission} };
                for my $ID (@Array) {
                    if ( $_ == $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{GroupObject}->GroupMemberAdd(
                UID        => $_,
                GID        => $ID,
                Permission => {%NewPermission},
                UserID     => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Param{NextScreen}" );
    }

    # groups to user
    elsif ( $Self->{Subaction} eq 'ChangeUser' ) {

        # get new groups
        my %Permissions = ();
        for ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my @IDs = $Self->{ParamObject}->GetArray( Param => $_ );
            $Permissions{$_} = \@IDs;
        }

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        my %NewPermission = ();
        for ( keys %GroupData ) {
            for my $Permission ( keys %Permissions ) {
                $NewPermission{$Permission} = 0;
                my @Array = @{ $Permissions{$Permission} };
                for my $ID (@Array) {
                    if ( $_ == $ID ) {
                        $NewPermission{$Permission} = 1;
                    }
                }
            }
            $Self->{GroupObject}->GroupMemberAdd(
                UID        => $ID,
                GID        => $_,
                Permission => {%NewPermission},
                UserID     => $Self->{UserID},
            );
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Param{NextScreen}" );
    }

    # else ! print form
    else {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # get user data
        my %UserData = $Self->{UserObject}->UserList( Valid => 1 );
        for ( keys %UserData ) {

            # get user data
            my %User = $Self->{UserObject}->GetUserData( UserID => $_, Cached => 1 );
            if ( $User{UserFirstname} && $User{UserLastname} ) {
                $UserData{$_} .= " ($User{UserFirstname} $User{UserLastname})";
            }
        }

        # get group data
        my %GroupData = $Self->{GroupObject}->GroupList( Valid => 1 );
        $Output .= $Self->MaskAdminUserGroupForm(
            GroupData => \%GroupData,
            UserData  => \%UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub MaskAdminUserGroupChangeForm {
    my ( $Self, %Param ) = @_;

    my %Data     = %{ $Param{Data} };
    my $BaseLink = $Self->{LayoutObject}->{Baselink};
    my $Type     = $Param{Type} || 'User';
    my $NeType   = 'Group';
    $NeType = 'User' if ( $Type eq 'Group' );
    $Param{Name} = $Self->{LayoutObject}->Ascii2Html(
        Text                => $Param{Name},
        HTMLQuote           => 1,
        LanguageTranslation => 0,
    ) || '';
    $Param{OptionStrg0}
        .= "<B>\$Text{\"$Type\"}:</B> <A HREF=\"$BaseLink"
        . "Action=Admin$Type&Subaction=Change&ID=$Param{ID}\">"
        . "$Param{Name}</A> (id=$Param{ID})<BR>";
    $Param{OptionStrg0} .= '<INPUT TYPE="hidden" NAME="ID" VALUE="' . $Param{ID} . '"><BR>';

    $Param{OptionStrg0} .= "<br/>\n";
    $Param{OptionStrg0} .= "<table cellspacing=\"0\" cellpadding=\"4\">\n";
    $Param{OptionStrg0} .= "<tr valign=\"top\"><th>\$Text{\"$NeType\"}</th>";
    for ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
        $Param{OptionStrg0} .= "<th>$_<br/>";
        if ( $_ eq 'rw' ) {
            $Param{OptionStrg0} .= " | ";
        }
        $Param{OptionStrg0} .= "<input type=\"checkbox\" name=\"$_\" value=\"\" onchange=\"select_items('$_');\"></th>";
    }
    $Param{OptionStrg0} .= "</tr>\n";
    my $CssClass = 'searchactive';
    for ( sort { uc( $Data{$a} ) cmp uc( $Data{$b} ) } keys %Data ) {

        # set output class
        if ( $CssClass && $CssClass eq 'searchactive' ) {
            $CssClass = 'searchpassive';
        }
        else {
            $CssClass = 'searchactive';
        }
        $Param{Data}->{$_} = $Self->{LayoutObject}->Ascii2Html(
            Text                => $Param{Data}->{$_},
            HTMLQuote           => 1,
            LanguageTranslation => 0,
        ) || '';
        $Param{OptionStrg0} .= "<tr class=\"$CssClass\"><td>";
        $Param{OptionStrg0} .= "<a href=\"$BaseLink"
            . "Action=Admin$NeType&Subaction=Change&ID=$_\">$Param{Data}->{$_}</a></td>";
        for my $Type ( @{ $Self->{ConfigObject}->Get('System::Permission') } ) {
            my $Selected = '';
            if ( $Param{$Type}->{$_} ) {
                $Selected = ' checked';
            }
            $Param{OptionStrg0} .= '<td align="center">';
            if ( $Type eq 'rw' ) {
                $Param{OptionStrg0} .= " | ";
            }
            $Param{OptionStrg0}
                .= '<input type="checkbox" name="'
                . $Type
                . '" value="'
                . $_
                . "\"$Selected> </td>";

        }
        $Param{OptionStrg0} .= '</tr>' . "\n";
    }
    $Param{OptionStrg0} .= "</table>\n";

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminUserGroupChangeForm',
        Data         => \%Param,
    );
}

sub MaskAdminUserGroupForm {
    my ( $Self, %Param ) = @_;

    my $UserData     = $Param{UserData};
    my %UserDataTmp  = %$UserData;
    my $GroupData    = $Param{GroupData};
    my %GroupDataTmp = %$GroupData;
    my $BaseLink     = $Self->{LayoutObject}->{Baselink} . "Action=AdminUserGroup&";
    for ( sort { uc( $UserDataTmp{$a} ) cmp uc( $UserDataTmp{$b} ) } keys %UserDataTmp ) {
        $UserDataTmp{$_} = $Self->{LayoutObject}->Ascii2Html(
            Text                => $UserDataTmp{$_},
            HTMLQuote           => 1,
            LanguageTranslation => 0,
        ) || '';
        $Param{UserStrg}
            .= "<A HREF=\"$BaseLink" . "Subaction=User&ID=$_\">$UserDataTmp{$_}</A><BR>";
    }
    for ( sort { uc( $GroupDataTmp{$a} ) cmp uc( $GroupDataTmp{$b} ) } keys %GroupDataTmp ) {
        $GroupDataTmp{$_} = $Self->{LayoutObject}->Ascii2Html(
            Text                => $GroupDataTmp{$_},
            HTMLQuote           => 1,
            LanguageTranslation => 0,
        ) || '';
        $Param{GroupStrg}
            .= "<A HREF=\"$BaseLink" . "Subaction=Group&ID=$_\">$GroupDataTmp{$_}</A><BR>";
    }

    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminUserGroupForm',
        Data         => \%Param,
    );
}

1;
