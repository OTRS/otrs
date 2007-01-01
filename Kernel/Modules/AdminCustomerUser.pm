# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user and preferences
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminCustomerUser.pm,v 1.44 2007-01-01 23:18:15 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.44 $ ';
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

    # needed objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $NavBar = '';
    my $Link = '';
    my $Nav = $Self->{ParamObject}->GetParam(Param => 'Nav') || 0;
    my $Source = $Self->{ParamObject}->GetParam(Param => 'Source') || 'CustomerUser';
    my $Search = $Self->{ParamObject}->GetParam(Param => 'Search');
    my $AddedUID = $Self->{ParamObject}->GetParam(Param => 'AddedUID') || '';
    my $Screen = $Self->{ParamObject}->GetParam(Param => 'Screen') || '';
    if ($Screen eq 'Remember' && $Self->{LastScreenEdit}) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'CustomerEditReturn',
            Value => $Self->{LastScreenEdit},
        );
        $Self->{LayoutObject}->SetEnv(
            Key => 'CustomerEditReturn',
            Value => $Self->{LastScreenEdit},
        );
    }
    elsif ($Screen eq 'Return') {
        # redirect
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'CustomerEditReturn',
            Value => '',
        );
        return $Self->{LayoutObject}->Redirect(
            OP => $Self->{CustomerEditReturn},
        );
    }
    my %UserList = ();
    # check nav bar
    if (!$Nav) {
        if ($ENV{HTTP_REFERER} && $ENV{HTTP_REFERER} !~ /Admin/) {
            $Nav = 'Agent';
        }
        else {
            $Nav = 'Admin';
        }
    }
    if ($Nav eq 'Admin') {
        $NavBar = $Self->{LayoutObject}->Header();
        $NavBar .= $Self->{LayoutObject}->NavigationBar();
    }
    elsif ($Nav eq 'None') {
        $NavBar = $Self->{LayoutObject}->Header(Type => 'Small');
    }
    else {
        $NavBar = $Self->{LayoutObject}->Header();
        $NavBar .= $Self->{LayoutObject}->NavigationBar(Type => $Self->{LastNavBarName});
    }
    # add notify
    if ($AddedUID) {
        my $OnClick = '';
        if ($Nav eq 'None') {
            $OnClick = " onclick=\"updateMessage('$AddedUID')\"";
        }
        my $URL = '';
        if ($Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketPhone}) {
            $URL .= "<a href=\"\$Env{\"CGIHandle\"}?Action=AgentTicketPhone&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$AddedUID\"$OnClick>".
                $Self->{LayoutObject}->{LanguageObject}->Get('PhoneView')."</a>";
        }
        if ($Self->{ConfigObject}->Get('Frontend::Module')->{AgentTicketEmail}) {
            if ($URL) {
                $URL .= " - ";
            }
            $URL .= "<a href=\"\$Env{\"CGIHandle\"}?Action=AgentTicketEmail&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$AddedUID\"$OnClick>".
                $Self->{LayoutObject}->{LanguageObject}->Get('Compose Email')."</a>";
        }
        if ($URL) {
            $NavBar .= $Self->{LayoutObject}->Notify(
                Data => $Self->{LayoutObject}->{LanguageObject}->Get('Added User "%s"", "'.$AddedUID).
                    " ( $URL )!",
            );
        }
    }
    # search user list
    if ($Search) {
        %UserList = $Self->{CustomerUserObject}->CustomerSearch(
            Valid => 0,
            Search => $Search,
        );
        # build user result list
        if (%UserList) {
            foreach (sort keys %UserList) {
                my $AddLink = '';
                if ($Nav eq 'None') {
                    $AddLink = "<a href=\"\" onclick=\"updateMessage('$_')\">\$Text{\"Take this Customer\"}</a>";
                }
                else {
                    $AddLink = $_;
                }
                $Self->{LayoutObject}->Block(
                    Name => 'CustomerSelection',
                    Data => {
                        AddLink => $AddLink,
                        Nav => $Nav,
                        Search => $Search,
                        Name => $UserList{$_},
                        UserID => $_,
                    },
                );
            }
        }
    }
    # get user data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $User = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $User);
        my $Output = $NavBar.$Self->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            Source => $Source,
            Search => $Search,
            %UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # download file preferences
    elsif ($Self->{Subaction} eq 'Download') {
        my $Group = $Self->{ParamObject}->GetParam(Param => 'Group') || '';
        my $User = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my $File = $Self->{ParamObject}->GetParam(Param => 'File') || '';
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $User);
        my %Preferences = %{$Self->{ConfigObject}->Get('CustomerPreferencesGroups')};
        my $Module = $Preferences{$Group}->{Module};
        if ($Self->{MainObject}->Require($Module)) {
            my $Object = $Module->new(
                %{$Self},
                ConfigItem => $Preferences{$Group},
                UserObject => $Self->{CustomerUserObject},
                Debug => $Self->{Debug},
            );
            my %File = $Object->Download(UserData => \%UserData);

            return $Self->{LayoutObject}->Attachment(%File);
        }
        else {
            return $Self->{LayoutObject}->FatalError();
        }
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my $Note = '';
        # get params
        my %GetParam;
        foreach my $Entry (@{$Self->{ConfigObject}->Get($Source)->{Map}}) {
            $GetParam{$Entry->[0]} = $Self->{ParamObject}->GetParam(Param => $Entry->[0]) || '';
        }
        $GetParam{ID} = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # update user
        if ($Self->{CustomerUserObject}->CustomerUserUpdate(%GetParam, UserID => $Self->{UserID})) {
            # update preferences
            my %Preferences = %{$Self->{ConfigObject}->Get('CustomerPreferencesGroups')};
            foreach my $Group (keys %Preferences) {
                if ($Group eq 'Password') {
                    next;
                }
                # get user data
                my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $GetParam{UserLogin});
                my $Module = $Preferences{$Group}->{Module};
                if ($Self->{MainObject}->Require($Module)) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        UserObject => $Self->{CustomerUserObject},
                        Debug => $Self->{Debug},
                    );
                    my @Params = $Object->Param(UserData => \%UserData);
                    if (@Params) {
                        my %GetParam = ();
                        foreach my $ParamItem (@Params) {
                            my @Array = $Self->{ParamObject}->GetArray(Param => $ParamItem->{Name});
                            $GetParam{$ParamItem->{Name}} = \@Array;
                        }
                        if (!$Object->Run(GetParam => \%GetParam, UserData => \%UserData)) {
                            $Note .= $Self->{LayoutObject}->Notify(Info => $Object->Error());
                        }
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
            # get user data and show screen again
            $Note .= $Self->{LayoutObject}->Notify(Info => 'Customer updated!');
            my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $GetParam{ID});
            my $Output = $NavBar.$Note.$Self->AdminCustomerUserForm(
                Nav => $Nav,
                UserLinkList => $Link,
                Source => $Source,
                Search => $Search,
                %UserData,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # search
    elsif ($Self->{Subaction} eq 'Search') {
        my $Output .= $NavBar.$Self->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            Search => $Search,
            Source => $Source,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # add new user
    elsif ($Self->{Subaction} eq 'AddAction') {
        # get params
        my %GetParam;
        foreach my $Entry (@{$Self->{ConfigObject}->Get($Source)->{Map}}) {
            $GetParam{$Entry->[0]} = $Self->{ParamObject}->GetParam(Param => $Entry->[0]) || '';
        }
        # add user
        if (my $User = $Self->{CustomerUserObject}->CustomerUserAdd(%GetParam, UserID => $Self->{UserID}, Source => $Source)) {
            # update preferences
            my %Preferences = %{$Self->{ConfigObject}->Get('CustomerPreferencesGroups')};
            foreach my $Group (keys %Preferences) {
                if ($Group eq 'Password') {
                    next;
                }
                # get user data
                my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $GetParam{UserLogin});
                my $Module = $Preferences{$Group}->{Module};
                if ($Self->{MainObject}->Require($Module)) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Group},
                        UserObject => $Self->{CustomerUserObject},
                        Debug => $Self->{Debug},
                    );
                    my @Params = $Object->Param(%{$Preferences{$Group}}, UserData => \%UserData);
                    if (@Params) {
                        my %GetParam = ();
                        foreach my $ParamItem (@Params) {
                            my @Array = $Self->{ParamObject}->GetArray(Param => $ParamItem->{Name});
                            $GetParam{$ParamItem->{Name}} = \@Array;
                        }
                        if (!$Object->Run(GetParam => \%GetParam, UserData => \%UserData)) {
#                            $Note .= $Self->{LayoutObject}->Notify(Info => $Object->Error());
                        }
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminCustomerUser&Nav=$Nav&Search=$Search&AddedUID=$User",
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # else ! print form
    else {
        # get params
        my %GetParam;
        foreach my $Entry (@{$Self->{ConfigObject}->Get($Source)->{Map}}) {
            $GetParam{$Entry->[0]} = $Self->{ParamObject}->GetParam(Param => $Entry->[0]);
        }
        my $Output .= $NavBar.$Self->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            Search => $Search,
            Source => $Source,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # set header, navbar and footer
    # all stuff
        # user search
        # source selection
    # overview
    # edit
    # addaction
    # change
    # changeaction
}

sub AdminCustomerUserForm {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    $Self->{LayoutObject}->Block(
        Name => 'Body',
        Data => {
            %Param,
        },
    );
    # build source string
    $Param{'SourceOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {$Self->{CustomerUserObject}->CustomerSourceList()},
        Name => 'Source',
        SelectedID => $Param{Source},
    );

    foreach my $Entry (@{$Self->{ConfigObject}->Get($Param{Source})->{Map}}) {
        if ($Entry->[0]) {
            my $Block = 'Input';
            # check input type
            if ($Entry->[0] =~ /^UserPasswor/i) {
                $Block = 'Password';
            }
            # check if login auto creation
            if ($Self->{ConfigObject}->Get($Param{Source})->{AutoLoginCreation} && $Entry->[0] =~ /^UserLogin$/) {
                $Block = 'InputHidden';
            }
            if ($Entry->[7]) {
                $Param{ReadOnlyType} = 'readonly';
                $Param{ReadOnly} = '*';
            }
            else {
                $Param{ReadOnlyType} = '';
                $Param{ReadOnly} = '';
            }
            # build selections or input fields
            if ($Self->{ConfigObject}->Get($Param{Source})->{Selections}->{$Entry->[0]}) {
                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data => $Self->{ConfigObject}->Get($Param{Source})->{Selections}->{$Entry->[0]},
                    Name => $Entry->[0],
                    LanguageTranslation => 0,
                    SelectedID => $Param{$Entry->[0]},
                );

            }
            elsif ($Entry->[0] =~ /^ValidID/i) {
                # build ValidID string
                $Block = 'Option';
                $Param{Option} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data => {
                        $Self->{DBObject}->GetTableData(
                            What => 'id, name',
                            Table => 'valid',
                            Valid => 0,
                        )
                    },
                    Name => $Entry->[0],
                    SelectedID => defined ($Param{$Entry->[0]}) ? $Param{$Entry->[0]} : 1,
                );
            }
            else {
                $Param{Value} = $Param{$Entry->[0]} || '';
            }
            # show required flag
            if ($Entry->[4]) {
                $Param{Required} = '*';
            }
            else {
                $Param{Required} = '';
            }
            # add form option
            if ($Param{Type} && $Param{Type} eq 'hidden') {
                $Param{Preferences} .= $Param{Value};
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'PreferencesGeneric',
                    Data => { Item => $Entry->[1], %Param},
                );
                $Self->{LayoutObject}->Block(
                    Name => "PreferencesGeneric$Block",
                    Data => {
                        Item => $Entry->[1],
                        Name => $Entry->[0],
                        %Param,
                    },
                );
            }
        }
    }
    my $PreferencesUsed = $Self->{ConfigObject}->Get($Param{Source})->{AdminSetPreferences};
    if ((defined($PreferencesUsed) && $PreferencesUsed != 0) || !defined($PreferencesUsed)) {
    my @Groups = @{$Self->{ConfigObject}->Get('CustomerPreferencesView')};
    foreach my $Colum (@Groups) {
        my %Data = ();
        my %Preferences = %{$Self->{ConfigObject}->Get('CustomerPreferencesGroups')};
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
            if (!$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}) {
                next;
            }
            my %Preference = %{$Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}};
            if ($Group eq 'Password') {
                next;
            }
            my $Module = $Preference{Module} || 'Kernel::Output::HTML::CustomerPreferencesGeneric';
            # load module
            if ($Self->{MainObject}->Require($Module)) {
                my $Object = $Module->new(
                    %{$Self},
                    ConfigItem => \%Preference,
                    UserObject => $Self->{CustomerUserObject},
                    Debug => $Self->{Debug},
                );
                my @Params = $Object->Param(UserData => \%Param);
                if (@Params) {
                    foreach my $ParamItem (@Params) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Item',
                            Data => { %Param },
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
                                %Param,
                                %Data,
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

    }
    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminCustomerUserForm', Data => \%Param);
}

1;
