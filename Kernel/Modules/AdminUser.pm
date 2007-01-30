# --
# Kernel/Modules/AdminUser.pm - to add/update/delete user and preferences
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminUser.pm,v 1.38 2007-01-30 14:08:06 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminUser;

use strict;
use Kernel::System::Valid;

use vars qw($VERSION);
$VERSION = '$Revision: 1.38 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # allocate new hash for objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{ValidObject} = Kernel::System::Valid->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    $Param{NextScreen} = 'AdminUser';

    # get user data 2 form
    if ($Self->{ConfigObject}->Get('SwitchToUser') && $Self->{ParamObject}->GetParam(Param => 'Switch')) {
        my $UserID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my %UserData = $Self->{UserObject}->GetUserData(UserID => $UserID);
        # get groups rw
        my %GroupData = $Self->{GroupObject}->GroupMemberList(
            Result => 'HASH',
            Type => 'rw',
            UserID => $UserData{UserID},
        );
        foreach (keys %GroupData) {
            $UserData{"UserIsGroup[$GroupData{$_}]"} = 'Yes';
        }
        # get groups ro
        %GroupData = $Self->{GroupObject}->GroupMemberList(
            Result => 'HASH',
            Type => 'ro',
            UserID => $UserData{UserID},
        );
        foreach (keys %GroupData) {
            $UserData{"UserIsGroupRo[$GroupData{$_}]"} = 'Yes';
        }
        my $NewSessionID = $Self->{SessionObject}->CreateSessionID(
            _UserLogin => $UserData{UserLogin},
            _UserPw => 'lal',
            %UserData,
            UserLastRequest => $Self->{TimeObject}->SystemTime(),
            UserType => 'User',
        );
        # create a new LayoutObject with SessionIDCookie
        my $Expires = '+'.$Self->{ConfigObject}->Get('SessionMaxTime').'s';
        if (!$Self->{ConfigObject}->Get('SessionUseCookieAfterBrowserClose')) {
            $Expires = '';
        }
        my $LayoutObject = Kernel::Output::HTML::Layout->new(
            %{$Self},
            SetCookies => {
                SessionIDCookie => $Self->{ParamObject}->SetCookie(
                    Key => $Self->{ConfigObject}->Get('SessionName'),
                    Value => $NewSessionID,
                    Expires => $Expires,
                ),
            },
            SessionID => $NewSessionID,
            SessionName => $Self->{ConfigObject}->Get('SessionName'),
        );
        # log event
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Switched to User ($Self->{UserLogin} -=> $UserData{UserLogin})",
        );
        # redirect with new session id
        print $LayoutObject->Redirect(OP => "");
    }
    elsif ($Self->{Subaction} eq 'Change') {
        my $UserID = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # get user data
        my %UserData = $Self->{UserObject}->GetUserData(UserID => $UserID);
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->AdminUserForm(UserData => \%UserData);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        # get params
        my %GetParam;
        foreach (qw(ID Salutation Login Firstname Lastname Email ValidID Pw)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        $GetParam{Preferences} = $Self->{ParamObject}->GetParam(Param => 'Preferences') || '';
        # update user
        if ($Self->{UserObject}->UserUpdate(%GetParam, UserID => $Self->{UserID})) {
            my %Preferences = %{$Self->{ConfigObject}->Get('PreferencesGroups')};
            foreach my $Group (keys %Preferences) {
                if ($Group eq 'Password') {
                    next;
                }
                # get user data
                my %UserData = $Self->{UserObject}->GetUserData(UserID => $GetParam{ID});
                my $Module = $Preferences{$Group}->{Module};
                if ($Self->{MainObject}->Require($Module)) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        Debug => $Self->{Debug},
                    );
                    my @Params = $Object->Param(%{$Preferences{$Group}}, UserData => \%UserData);
                    if (@Params) {
                        my %GetParam = ();
                        foreach my $ParamItem (@Params) {
                            my @Array = $Self->{ParamObject}->GetArray(Param => $ParamItem->{Name});
                            $GetParam{$ParamItem->{Name}} = \@Array;
                        }
                        my $Message = $Object->Run(GetParam => \%GetParam, UserData => \%UserData);
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
            # redirect
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # add new user
    elsif ($Self->{Subaction} eq 'AddAction') {
        # get params
        my %GetParam;
        foreach (qw(ID Salutation Login Firstname Lastname Email ValidID Pw)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        $GetParam{Preferences} = $Self->{ParamObject}->GetParam(Param => 'Preferences') || '';
        # add user
        if (my $UserID = $Self->{UserObject}->UserAdd(%GetParam, UserID => $Self->{UserID})) {
            # update preferences
            my %Preferences = %{$Self->{ConfigObject}->Get('PreferencesGroups')};
            foreach my $Group (keys %Preferences) {
                if ($Group eq 'Password') {
                    next;
                }
                # get user data
                my %UserData = $Self->{UserObject}->GetUserData(UserID => $UserID);
                my $Module = $Preferences{$Group}->{Module};
                if ($Self->{MainObject}->Require($Module)) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        Debug => $Self->{Debug},
                    );
                    my @Params = $Object->Param(UserData => \%UserData);
                    if (@Params) {
                        my %GetParam = ();
                        foreach my $ParamItem (@Params) {
                            my @Array = $Self->{ParamObject}->GetArray(Param => $ParamItem->{Name});
                            $GetParam{$ParamItem->{Name}} = \@Array;
                        }
                        $Object->Run(GetParam => \%GetParam, UserData => \%UserData);
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
            # redirect
            if (!$Self->{ConfigObject}->Get('Frontend::Module')->{AdminUserGroup} &&
                $Self->{ConfigObject}->Get('Frontend::Module')->{AdminRoleUser}) {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AdminRoleUser&Subaction=User&ID=$UserID",
                );
            }
            if ($Self->{ConfigObject}->Get('Frontend::Module')->{AdminUserGroup}) {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AdminUserGroup&Subaction=User&ID=$UserID",
                );
            }
            else {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AdminUser",
                );
            }
        }
        else {
            return $Self->{LayoutObject}->FatalError();
        }
    }
    # else ! print form
    else {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->AdminUserForm(UserData => {});
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub AdminUserForm {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{ValidObject}->ValidIDsGet(),
        },
        Name => 'ValidID',
        SelectedID => $Param{UserData}->{ValidID},
    );

    $Param{UserOption} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What => "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
                    " $Self->{ConfigObject}->{DatabaseUserTableUser}, ".
                    "$Self->{ConfigObject}->{DatabaseUserTableUserID}",
                Valid => 0,
                Clamp => 1,
                Table => $Self->{ConfigObject}->{DatabaseUserTable},
            )
        },
        Size => 15,
        Name => 'ID',
        SelectedID => $Param{UserData}->{ID},
    );

    my @Groups = @{$Self->{ConfigObject}->Get('PreferencesView')};
    foreach my $Colum (@Groups) {
        my %Data = ();
        my %Preferences = %{$Self->{ConfigObject}->Get('PreferencesGroups')};
        foreach my $Group (keys %Preferences) {
            if ($Preferences{$Group}->{Colum} eq $Colum) {
                if ($Data{$Preferences{$Group}->{Prio}}) {
                    foreach (1..151) {
                        $Preferences{$Group}->{Prio}++;
                        if (!$Data{$Preferences{$Group}->{Prio}}) {
                            $Data{$Preferences{$Group}->{Prio}} = $Group;
                            last;
                        }
                    }
                }
                $Data{$Preferences{$Group}->{Prio}} = $Group;
            }
        }
        # sort
        foreach my $Key (keys %Data) {
            $Data{sprintf("%07d", $Key)} = $Data{$Key};
            delete $Data{$Key};
        }
        # show each preferences setting
        foreach my $Prio (sort keys %Data) {
            my $Group = $Data{$Prio};
            if (!$Self->{ConfigObject}->{PreferencesGroups}->{$Group}) {
                next;
            }
            my %Preference = %{$Self->{ConfigObject}->{PreferencesGroups}->{$Group}};
            if ($Group eq 'Password') {
                next;
            }
            my $Module = $Preference{Module} || 'Kernel::Output::HTML::PreferencesGeneric';
            # load module
            if ($Self->{MainObject}->Require($Module)) {
                my $Object = $Module->new(
                    %{$Self},
                    ConfigItem => \%Preference,
                    Debug => $Self->{Debug},
                );
                my @Params = $Object->Param(UserData => $Param{UserData});
                if (@Params) {
                    foreach my $ParamItem (@Params) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Item',
                            Data => { %Param, },
                        );
                        if (ref($ParamItem->{Data}) eq 'HASH' || ref($Preference{Data}) eq 'HASH') {
                            $ParamItem->{'Option'} = $Self->{LayoutObject}->OptionStrgHashRef(
                                %Preference,
                                %{$ParamItem},
                            );
                        }
                        $Self->{LayoutObject}->Block(
                            Name => $ParamItem->{Block} || $Preference{Block} || 'Option',
                            Data => {
                                Group => $Group,
                                %Preference,
                                %{$ParamItem},
                            },
                        );
                    }
                }
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }
    if ($Self->{ConfigObject}->Get('SwitchToUser')) {
        $Self->{LayoutObject}->Block(
            Name => 'SwitchToUser',
            Data => { },
        );
    }
    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminUserForm', Data => {%Param, %{$Param{UserData}}});
}

1;