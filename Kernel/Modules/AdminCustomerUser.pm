# --
# Kernel/Modules/AdminCustomerUser.pm - to add/update/delete customer user and preferences
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminCustomerUser.pm,v 1.27 2004-09-24 10:05:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminCustomerUser;

use strict;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.27 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
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
        die "Got no $_!" if (!$Self->{$_});
    }

    # needed objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $NavBar = '';
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
        $NavBar = $Self->{LayoutObject}->Header(Area => 'Admin', Title => 'Customer User');
        $NavBar .= $Self->{LayoutObject}->NavigationBar(Type => 'Admin');
        $NavBar .= $Self->{LayoutObject}->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);
    }
    elsif ($Nav eq 'None') {
        $NavBar = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Customer User', Type => 'Small');
    }
    else {
        $NavBar = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Customer User');
        $NavBar .= $Self->{LayoutObject}->NavigationBar();
    }
    # add notify
    if ($AddedUID) {
        my $OnClick = '';
        if ($Nav eq 'None') {
            $OnClick = " onclick=\"updateMessage('$AddedUID')\"";
        }
        $NavBar .= $Self->{LayoutObject}->Notify(
            Info => $Self->{LayoutObject}->{LanguageObject}->Get('Added User "%s"", "'.$AddedUID).
            " ( <a href=\"?Action=AgentPhone&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$AddedUID\"$OnClick>".$Self->{LayoutObject}->{LanguageObject}->Get('PhoneView')."</a>".
            " - <a href=\"?Action=AgentEmail&Subaction=StoreNew&ExpandCustomerName=2&CustomerUser=$AddedUID\"$OnClick>".$Self->{LayoutObject}->{LanguageObject}->Get('Compose Email')."</a> )!",
        );
    }
    # search user list
    if ($Search) {
        %UserList = $Self->{CustomerUserObject}->CustomerSearch(
            Valid => 0,
            Search => $Search,
        );
    }
    # build user result list
    my $Link = '';
    if (%UserList) {
        foreach (sort keys %UserList) {
            my $AddLink = '';
            if ($Nav eq 'None') {
                $AddLink = "<a href=\"\" onclick=\"updateMessage('$_')\">\$Text{\"Take this Customer\"}</a>";
            }
            else {
                $AddLink = $_;
            }
            $Link .= "<tr><td valign='top'>$AddLink</td><td valign='top'><a href=\"\$Env{\"Baselink\"}Action=AdminCustomerUser&Subaction=Change&ID=$_&Search=".$Self->{LayoutObject}->LinkEncode($Search)."&Nav=$Nav\">".$Self->{LayoutObject}->Ascii2Html(Text => $UserList{$_}, Max => 45)."</a></td></tr>";
        }
    }
    # get user data 2 form
    if ($Self->{Subaction} eq 'Change') {
        my $User = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $User);
        my $Output = $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()},
            Source => $Source,
            Search => $Search,
            %UserData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # download file preferences
    elsif ($Self->{Subaction} eq 'Download') {
        my $User = $Self->{ParamObject}->GetParam(Param => 'ID') || '';
        my $File = $Self->{ParamObject}->GetParam(Param => 'File') || '';
        # get user data
        my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $User);

        return $Self->{LayoutObject}->Attachment(
            Content => $UserData{"$File"},
            ContentType => $UserData{$File."::ContentType"},
            Filename => $UserData{$File."::Filename"},
        );
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
            foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('CustomerPreferencesView')}) {
              foreach my $Group (@{$Self->{ConfigObject}->Get('CustomerPreferencesView')->{$Pref}}) {
                my $PrefKey = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{PrefKey} || '';
                my $Type = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Type} || '';
                if ($Type eq 'Generic' && $PrefKey) {
                    if (!$Self->{CustomerUserObject}->SetPreferences(
                      UserID => $GetParam{ID},
                      Key => $PrefKey,
                      Value => $Self->{ParamObject}->GetParam(Param => "GenericTopic::$PrefKey"),
                    )) {
                        my $Output = $NavBar.$Self->{LayoutObject}->Error();
                        $Output .= $Self->{LayoutObject}->Footer();
                        return $Output;
                    }
                }
                if ($Type eq 'Upload' && $PrefKey) {
                    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                        Param => "GenericTopic::$PrefKey",
                        Source => 'String',
                    );
                    if ($UploadStuff{Content}) {

# TODO
                        my $True = 0;
                        use Kernel::System::Crypt;
                        if ($PrefKey =~ /PGP/) {
                          my $CryptObject = Kernel::System::Crypt->new(
                            LogObject => $Self->{LogObject},
                            DBObject => $Self->{DBObject},
                            ConfigObject => $Self->{ConfigObject},
                            CryptType => 'PGP',
                          );
                          my $Message = $CryptObject->KeyAdd(Key => $UploadStuff{Content});
                          if (!$Message) {
                              $Message = $Self->{LogObject}->GetLogEntry(
                                  Type => 'Error',
                                  What => 'Message',
                              );
                          }
                          else {
                              if ($Message =~ /gpg: key (.*):/) {
                                  my @Result = $CryptObject->SearchPublicKey(Search => $1);
                                  if ($Result[0]) {
                                     $UploadStuff{Filename} = "$Result[0]->{Identifier}-$Result[0]->{Bit}-$Result[0]->{Key}.$Result[0]->{Type}";
                                  }
                              }
                              $True = 1;
                          }
                          if ($Message) {
                              $Note .= $Self->{LayoutObject}->Notify(Info => $Message);
                          }
                        }
                        if ($PrefKey =~ /SMIME/) {
                          my $CryptObject = Kernel::System::Crypt->new(
                            LogObject => $Self->{LogObject},
                            DBObject => $Self->{DBObject},
                            ConfigObject => $Self->{ConfigObject},
                            CryptType => 'SMIME',
                          );
                          my $Message = $CryptObject->CertificateAdd(Certificate => $UploadStuff{Content});
                          if (!$Message) {
                              $Message = $Self->{LogObject}->GetLogEntry(
                                  Type => 'Error',
                                  What => 'Message',
                              );
                          }
                          else {
                              my %Attributes = $CryptObject->CertificateAttributes(
                                  Certificate => $UploadStuff{Content},
                              );
                              if ($Attributes{Hash}) {
                                  $UploadStuff{Filename} = "$Attributes{Hash}.pem";
                              }
                              $True = 1;
                          }
                          if ($Message) {
                              $Note .= $Self->{LayoutObject}->Notify(Info => $Message);
                          }
                        }
# TODO
                        if ($True) {

                      $Self->{CustomerUserObject}->SetPreferences(
                        UserID => $GetParam{ID},
                        Key => $PrefKey,
                        Value => $UploadStuff{Content},
                      );
                      $Self->{CustomerUserObject}->SetPreferences(
                        UserID => $GetParam{ID},
                        Key => $PrefKey."::Filename",
                        Value => $UploadStuff{Filename},
                      );
                      $Self->{CustomerUserObject}->SetPreferences(
                        UserID => $GetParam{ID},
                        Key => $PrefKey."::ContentType",
                        Value => $UploadStuff{ContentType},
                      );
                    }
        }
                }
              }
            }
             # get user data and show screen again
            $Note .= $Self->{LayoutObject}->Notify(Info => 'Customer updated!');
            my %UserData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $GetParam{ID});
            my $Output = $NavBar.$Note.$Self->{LayoutObject}->AdminCustomerUserForm(
                Nav => $Nav,
                UserLinkList => $Link,
                SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()},
                Source => $Source,
                Search => $Search,
                %UserData,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $NavBar.$Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # search
    elsif ($Self->{Subaction} eq 'Search') {
        my $Output .= $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()},
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
            foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('CustomerPreferencesView')}) {
              foreach my $Group (@{$Self->{ConfigObject}->Get('CustomerPreferencesView')->{$Pref}}) {
                my $PrefKey = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{PrefKey} || '';
                my $Type = $Self->{ConfigObject}->{CustomerPreferencesGroups}->{$Group}->{Type} || '';
                if ($Type eq 'Generic' && $PrefKey) {
                    if (!$Self->{CustomerUserObject}->SetPreferences(
                      UserID => $User,
                      Key => $PrefKey,
                      Value => $Self->{ParamObject}->GetParam(Param => "GenericTopic::$PrefKey"),
                    )) {
                        my $Output = $NavBar.$Self->{LayoutObject}->Error();
                        $Output .= $Self->{LayoutObject}->Footer();
                        return $Output;
                    }
                }
                if ($Type eq 'Upload' && $PrefKey) {
                    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                        Param => "GenericTopic::$PrefKey",
                        Source => 'String',
                    );
                    if ($UploadStuff{Content}) {
                      $Self->{CustomerUserObject}->SetPreferences(
                        UserID => $User,
                        Key => $PrefKey,
                        Value => $UploadStuff{Content},
                      );
                      $Self->{CustomerUserObject}->SetPreferences(
                        UserID => $User,
                        Key => $PrefKey."::Filename",
                        Value => $UploadStuff{Filename},
                      );
                      $Self->{CustomerUserObject}->SetPreferences(
                        UserID => $User,
                        Key => $PrefKey."::ContentType",
                        Value => $UploadStuff{ContentType},
                      );
                    }
                }
              }
            }
            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminCustomerUser&Nav=$Nav&Search=$Search&AddedUID=$User",
            );
        }
        else {
            my $Output = $NavBar.$Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # else ! print form
    else {
        my $Output .= $NavBar.$Self->{LayoutObject}->AdminCustomerUserForm(
            Nav => $Nav,
            UserLinkList => $Link,
            SourceList => {$Self->{CustomerUserObject}->CustomerSourceList()},
            Search => $Search,
            Source => $Source,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
