# --
# Kernel/System/CustomerUser.pm - some customer user functions
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CustomerUser.pm,v 1.17 2004-02-13 00:50:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.17 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }
    # load generator customer preferences module
    my $GeneratorModule = $Self->{ConfigObject}->Get('CustomerPreferences')->{Module}
      || 'Kernel::System::CustomerUser::Preferences::DB';
    eval "require $GeneratorModule";
    $Self->{PreferencesObject} = $GeneratorModule->new(%Param);

    # load master backend customer user module
    $GeneratorModule = $Self->{ConfigObject}->Get('CustomerUser')->{Module}
      || 'Kernel::System::CustomerUser::DB';
    eval "require $GeneratorModule";
    $Self->{CustomerUser} = $GeneratorModule->new(
        %Param,  
        PreferencesObject => $Self->{PreferencesObject},
        CustomerUserMap => $Self->{ConfigObject}->Get("CustomerUser"),
    );
 
    # load slave backend customer user module
    foreach (1..10) {
        if ($Self->{ConfigObject}->Get("CustomerUser$_")) {
            $GeneratorModule = $Self->{ConfigObject}->Get("CustomerUser$_")->{Module};
            eval "require $GeneratorModule";
            $Self->{"CustomerUser$_"} = $GeneratorModule->new(
                %Param,  
                PreferencesObject => $Self->{PreferencesObject},
                CustomerUserMap => $Self->{ConfigObject}->Get("CustomerUser$_"),
            );
        }
    }

    return $Self;
}
# --
sub CustomerSourceList {
    my $Self = shift; 
    my %Param = @_;
    my %Data = ();
    $Data{CustomerUser} = $Self->{ConfigObject}->Get("CustomerUser")->{Name} || 'No Name';
    foreach (1..10) {
        if ($Self->{ConfigObject}->Get("CustomerUser$_")) {
            $Data{"CustomerUser$_"} = $Self->{ConfigObject}->Get("CustomerUser$_")->{Name} || "No Name $_";
        }
    }
    return %Data;
}
# --
sub CustomerSearch {
    my $Self = shift; 
    my %Param = @_;
    my %Data = $Self->{CustomerUser}->CustomerSearch(%Param); 
    foreach (1..10) {
        if ($Self->{"CustomerUser$_"}) {
            my %SubData = $Self->{"CustomerUser$_"}->CustomerSearch(%Param);
            %Data = (%Data, %SubData);
        }
    }
    return %Data;
}
# --
sub CustomerUserList {
    my $Self = shift;
    my %Param = @_;
    my %Data = $Self->{CustomerUser}->CustomerUserList(%Param); 
    foreach (1..10) {
        if ($Self->{"CustomerUser$_"}) {
            my %SubData = $Self->{"CustomerUser$_"}->CustomerUserList(%Param);
            %Data = (%Data, %SubData);
        }
    }
    return %Data;
}
# --
sub CustomerName {
    my $Self = shift;
    my %Param = @_;
    my $Name = $Self->{CustomerUser}->CustomerName(%Param) || ''; 
    foreach (1..10) {
        if ($Self->{"CustomerUser$_"}) {
            $Name = $Self->{"CustomerUser$_"}->CustomerName(%Param);
        }
    }
    return $Name;
}
# --
sub CustomerUserDataGet {
    my $Self = shift;
    my %Param = @_;
    my %Data = $Self->{CustomerUser}->CustomerUserDataGet(%Param);
    if (%Data) {
        $Data{Source} = "CustomerUser";
        $Data{Config} = $Self->{ConfigObject}->Get("CustomerUser");
    }
    foreach (1..10) {
        if ($Self->{"CustomerUser$_"}) {
            my %GetData = $Self->{"CustomerUser$_"}->CustomerUserDataGet(
                %Param,
            );
            if (%GetData) {
                %Data = (
                    %GetData, 
                    Source => "CustomerUser$_",
                    Config => $Self->{ConfigObject}->Get("CustomerUser$_"),
                );
            }
        }
    }
    return %Data;
}
# --
sub CustomerUserAdd {
    my $Self = shift;
    my %Param = @_;
    # check data source
    if (!$Param{Source}) {
#        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Source!");
        $Param{Source} = 'CustomerUser';
#        return;
    }
    # check if user exists
    my %User = $Self->CustomerUserDataGet(User => $Param{UserLogin});
    if (%User) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "User already exists '$Param{UserLogin}'!");
        return;
    }
    else {
        return $Self->{$Param{Source}}->CustomerUserAdd(@_);
    }
}
# --
sub CustomerUserUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserLogin}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "User UserLogin!");
        return;
    }
    # check if user exists
    my %User = $Self->CustomerUserDataGet(User => $Param{UserLogin});
    if (!%User) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No such user!");
        return;
    }
    return $Self->{$User{Source}}->CustomerUserUpdate(%Param);
}   
# --
sub SetPassword {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserLogin}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "User UserLogin!");
        return;
    }
    # check if user exists
    my %User = $Self->CustomerUserDataGet(User => $Param{UserLogin});
    if (!%User) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No such user!");
        return;
    }
    return $Self->{$User{Source}}->SetPassword(%Param);
}
# --
sub GenerateRandomPassword {
    my $Self = shift;
    my %Param = @_;
    return $Self->{CustomerUser}->GenerateRandomPassword(@_);
}
# --
sub GetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->GetPreferences(@_);
}
# --
sub SetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->SetPreferences(@_);
}
# --

1;
