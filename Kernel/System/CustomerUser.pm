# --
# Kernel/System/CustomerUser.pm - some customer user functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerUser.pm,v 1.29 2007-01-20 23:11:34 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CustomerUser;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.29 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::CustomerUser - customer user lib

=head1 SYNOPSIS

All customer user functions. E. g. to add and updated user and other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::CustomerUser;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $CustomerUserObject = Kernel::System::CustomerUser->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

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
    my $GeneratorModule = $Self->{ConfigObject}->Get('CustomerPreferences')->{Module} ||
        'Kernel::System::CustomerUser::Preferences::DB';
    eval "require $GeneratorModule";
    $Self->{PreferencesObject} = $GeneratorModule->new(%Param);

    # load master backend customer user module
    $GeneratorModule = $Self->{ConfigObject}->Get('CustomerUser')->{Module} ||
        'Kernel::System::CustomerUser::DB';
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

=item CustomerSourceList()

return customer source list

    my %List = $CustomerUserObject->CustomerSourceList();

=cut

sub CustomerSourceList {
    my $Self = shift;
    my %Param = @_;
    my %Data = ();
    foreach ('', 1..10) {
        if ($Self->{ConfigObject}->Get("CustomerUser$_")) {
            $Data{"CustomerUser$_"} = $Self->{ConfigObject}->Get("CustomerUser$_")->{Name} || "No Name $_";
        }
    }
    return %Data;
}

=item CustomerSearch()

to search users

    my %List = $CustomerUserObject->CustomerSearch(
        Search => '*some*', # also 'hans+huber' possible
        ValidID => 1, # not required, default 1
    );

    my %List = $CustomerUserObject->CustomerSearch(
        UserLogin => '*some*',
        ValidID => 1, # not required, default 1
    );

    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => 'email@example.com',
        ValidID => 1, # not required, default 1
    );

=cut

sub CustomerSearch {
    my $Self = shift;
    my %Param = @_;
    my %Data = ();
    # remove leading and ending spaces
    if ($Param{Search}) {
        $Param{Search} =~ s/^\s+//;
        $Param{Search} =~ s/\s+$//;
    }
    foreach ('', 1..10) {
        if ($Self->{"CustomerUser$_"}) {
            my %SubData = $Self->{"CustomerUser$_"}->CustomerSearch(%Param);
            %Data = (%SubData, %Data);
        }
    }
    return %Data;
}

=item CustomerUserList()

return a hash with all users (depreciated)

    my %List = $CustomerUserObject->CustomerUserList(
        Valid => 1, # not required
    );

=cut

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

=item CustomerName()

get customer user name

    my $Name = $CustomerUserObject->CustomerName(
        UserLogin => 'some-login',
    );

=cut

sub CustomerName {
    my $Self = shift;
    my %Param = @_;
    foreach ('', 1..10) {
        if ($Self->{"CustomerUser$_"}) {
            my $Name = $Self->{"CustomerUser$_"}->CustomerName(%Param);
            if ($Name) {
                return $Name;
            }
        }
    }
    return;
}

=item CustomerIDs()

get customer user customer ids

    my @CustomerIDs = $CustomerUserObject->CustomerIDs(
        User => 'some-login',
    );

=cut

sub CustomerIDs {
    my $Self = shift;
    my %Param = @_;
    foreach ('', 1..10) {
        if ($Self->{"CustomerUser$_"}) {
            my @CustomerIDs = $Self->{"CustomerUser$_"}->CustomerIDs(%Param);
            if (@CustomerIDs) {
                return @CustomerIDs;
            }
        }
    }
    return;
}

=item CustomerUserDataGet()

get user data (UserLogin, UserFirstname, UserLastname, UserEmail, ...)

    my %User = $CustomerUserObject->CustomerUserDataGet(
        User => 'franz',
    );

=cut

sub CustomerUserDataGet {
    my $Self = shift;
    my %Param = @_;
    foreach ('', 1..10) {
        if ($Self->{"CustomerUser$_"}) {
            my %GetData = $Self->{"CustomerUser$_"}->CustomerUserDataGet(
                %Param,
            );
            if (%GetData) {
                return (
                    %GetData,
                    Source => "CustomerUser$_",
                    Config => $Self->{ConfigObject}->Get("CustomerUser$_"),
                );
            }
        }
    }
    return;
}

=item CustomerUserAdd()

to add new customer users

    my $UserLogin = $CustomerUserObject->CustomerUserAdd(
        Source => 'CustomerUser', # CustomerUser source config
        UserFirstname => 'Huber',
        UserLastname => 'Manfred',
        UserCustomerID => 'A124',
        UserLogin => 'mhuber',
        UserPassword => 'some-pass', # not required
        UserEmail => 'email@example.com',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub CustomerUserAdd {
    my $Self = shift;
    my %Param = @_;
    # check data source
    if (!$Param{Source}) {
        $Param{Source} = 'CustomerUser';
    }
    # check if user exists
    if ($Param{UserLogin}) {
        my %User = $Self->CustomerUserDataGet(User => $Param{UserLogin});
        if (%User) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "User already exists '$Param{UserLogin}'!");
            return;
        }
    }
    return $Self->{$Param{Source}}->CustomerUserAdd(@_);
}

=item CustomerUserUpdate()

to update customer users

    $CustomerUserObject->CustomerUserUpdate(
        Source => 'CustomerUser', # CustomerUser source config
        UserLogin => 'mhuber',
        UserFirstname => 'Huber',
        UserLastname => 'Manfred',
        UserPassword => 'some-pass', # not required
        UserEmail => 'email@example.com',
        ValidID => 1,
        UserID => 123,
    );

=cut

sub CustomerUserUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserLogin}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "User UserLogin!");
        return;
    }
    # check if user exists
    my %User = $Self->CustomerUserDataGet(User => $Param{ID} || $Param{UserLogin});
    if (!%User) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No such user!");
        return;
    }
    return $Self->{$User{Source}}->CustomerUserUpdate(%Param);
}

=item SetPassword()

to set customer users passwords

    $CustomerUserObject->SetPassword(
        UserLogin => 'some-login',
        PW => 'some-new-password'
    );

=cut

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

=item GenerateRandomPassword()

generate a random password

    my $Password = $CustomerUserObject->GenerateRandomPassword();

    or

    my $Password = $CustomerUserObject->GenerateRandomPassword(
        Size => 16,
    );

=cut

sub GenerateRandomPassword {
    my $Self = shift;
    my %Param = @_;
    return $Self->{CustomerUser}->GenerateRandomPassword(@_);
}

=item SetPreferences()

set customer user preferences

    $CustomerUserObject->SetPreferences(
        Key => 'UserComment',
        Value => 'some comment',
        UserID => 'some-login',
    );

=cut

sub SetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->SetPreferences(@_);
}

=item GetPreferences()

get customer user preferences

    my %Preferences = $CustomerUserObject->GetPreferences(
        UserID => 'some-login',
    );

=cut

sub GetPreferences {
    my $Self = shift;
    return $Self->{PreferencesObject}->GetPreferences(@_);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.29 $ $Date: 2007-01-20 23:11:34 $

=cut