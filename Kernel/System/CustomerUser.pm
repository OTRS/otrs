# --
# Kernel/System/CustomerUser.pm - some customer user functions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: CustomerUser.pm,v 1.44.2.1 2009-01-20 13:33:19 tt Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::CustomerUser;

use strict;
use warnings;
use Kernel::System::CustomerCompany;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.44.2.1 $) [1];

=head1 NAME

Kernel::System::CustomerUser - customer user lib

=head1 SYNOPSIS

All customer user functions. E. g. to add and updated user and other functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::CustomerUser;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $CustomerUserObject = Kernel::System::CustomerUser->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # load generator customer preferences module
    my $GeneratorModule = $Self->{ConfigObject}->Get('CustomerPreferences')->{Module}
        || 'Kernel::System::CustomerUser::Preferences::DB';
    if ( $Self->{MainObject}->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new(%Param);
    }

    # load customer user backend module
    for my $Count ( '', 1 .. 10 ) {
        if ( $Self->{ConfigObject}->Get("CustomerUser$Count") ) {
            my $GenericModule = $Self->{ConfigObject}->Get("CustomerUser$Count")->{Module};
            if ( !$Self->{MainObject}->Require($GenericModule) ) {
                $Self->{MainObject}->Die("Can't load backend module $GenericModule! $@");
            }
            $Self->{"CustomerUser$Count"} = $GenericModule->new(
                Count => $Count,
                %Param,
                PreferencesObject => $Self->{PreferencesObject},
                CustomerUserMap   => $Self->{ConfigObject}->Get("CustomerUser$Count"),
            );
        }
    }

    $Self->{CustomerCompanyObject} = Kernel::System::CustomerCompany->new(%Param);

    return $Self;
}

=item CustomerSourceList()

return customer source list

    my %List = $CustomerUserObject->CustomerSourceList();

=cut

sub CustomerSourceList {
    my ( $Self, %Param ) = @_;

    my %Data = ();
    for ( '', 1 .. 10 ) {
        if ( $Self->{ConfigObject}->Get("CustomerUser$_") ) {
            $Data{"CustomerUser$_"} = $Self->{ConfigObject}->Get("CustomerUser$_")->{Name}
                || "No Name $_";
        }
    }
    return %Data;
}

=item CustomerSearch()

to search users

    my %List = $CustomerUserObject->CustomerSearch(
        Search => '*some*', # also 'hans+huber' possible
        Valid  => 1, # not required, default 1
    );

    my %List = $CustomerUserObject->CustomerSearch(
        UserLogin => '*some*',
        Valid     => 1, # not required, default 1
    );

    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => 'email@example.com',
        Valid            => 1, # not required, default 1
    );

=cut

sub CustomerSearch {
    my ( $Self, %Param ) = @_;

    # remove leading and ending spaces
    if ( $Param{Search} ) {
        $Param{Search} =~ s/^\s+//;
        $Param{Search} =~ s/\s+$//;
    }

    my %Data = ();
    for ( '', 1 .. 10 ) {
        if ( $Self->{"CustomerUser$_"} ) {
            my %SubData = $Self->{"CustomerUser$_"}->CustomerSearch(%Param);
            %Data = ( %SubData, %Data );
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
    my ( $Self, %Param ) = @_;

    my %Data = ();
    for ( '', 1 .. 10 ) {
        if ( $Self->{"CustomerUser$_"} ) {
            my %SubData = $Self->{"CustomerUser$_"}->CustomerUserList(%Param);
            %Data = ( %Data, %SubData );
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
    my ( $Self, %Param ) = @_;

    for ( '', 1 .. 10 ) {
        if ( $Self->{"CustomerUser$_"} ) {
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
    my ( $Self, %Param ) = @_;

    for ( '', 1 .. 10 ) {
        if ( $Self->{"CustomerUser$_"} ) {
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
    my ( $Self, %Param ) = @_;

    for ( '', 1 .. 10 ) {
        if ( $Self->{"CustomerUser$_"} ) {
            my %Customer = $Self->{"CustomerUser$_"}->CustomerUserDataGet( %Param, );
            if (%Customer) {
                my %Company = ();

                # check if customer company support is enabled
                if (
                    $Self->{ConfigObject}->Get("CustomerCompany")
                    && $Self->{ConfigObject}->Get("CustomerUser$_")->{CustomerCompanySupport}
                    )
                {
                    %Company = $Self->{CustomerCompanyObject}->CustomerCompanyGet(
                        CustomerID => $Customer{UserCustomerID},
                    );
                }
                return (
                    %Company,
                    %Customer,
                    Source        => "CustomerUser$_",
                    Config        => $Self->{ConfigObject}->Get("CustomerUser$_"),
                    CompanyConfig => $Self->{ConfigObject}->Get("CustomerCompany"),
                );
            }
        }
    }
    return;
}

=item CustomerUserAdd()

to add new customer users

    my $UserLogin = $CustomerUserObject->CustomerUserAdd(
        Source         => 'CustomerUser', # CustomerUser source config
        UserFirstname  => 'Huber',
        UserLastname   => 'Manfred',
        UserCustomerID => 'A124',
        UserLogin      => 'mhuber',
        UserPassword   => 'some-pass', # not required
        UserEmail      => 'email@example.com',
        ValidID        => 1,
        UserID         => 123,
    );

=cut

sub CustomerUserAdd {
    my ( $Self, %Param ) = @_;

    # check data source
    if ( !$Param{Source} ) {
        $Param{Source} = 'CustomerUser';
    }

    # check if user exists
    if ( $Param{UserLogin} ) {
        my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
        if (%User) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "User already exists '$Param{UserLogin}'!",
            );
            return;
        }
    }
    return $Self->{ $Param{Source} }->CustomerUserAdd(%Param);
}

=item CustomerUserUpdate()

to update customer users

    $CustomerUserObject->CustomerUserUpdate(
        Source        => 'CustomerUser', # CustomerUser source config
        ID            => 'mh'            # current user login
        UserLogin     => 'mhuber',       # new user login
        UserFirstname => 'Huber',
        UserLastname  => 'Manfred',
        UserPassword  => 'some-pass',    # not required
        UserEmail     => 'email@example.com',
        ValidID       => 1,
        UserID        => 123,
    );

=cut

sub CustomerUserUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "User UserLogin!" );
        return;
    }

    # check for UserLogin-renaming and if new UserLogin already exists...
    if ( ($Param{ID}) &&  ($Param{UserLogin} ne $Param{ID}) ) {
        my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
        if (%User) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "User already exists '$Param{UserLogin}'!",
            );
            return;
        }
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{ID} || $Param{UserLogin} );
    if ( !%User ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "No such user!" );
        return;
    }
    return $Self->{ $User{Source} }->CustomerUserUpdate(%Param);
}

=item SetPassword()

to set customer users passwords

    $CustomerUserObject->SetPassword(
        UserLogin => 'some-login',
        PW        => 'some-new-password'
    );

=cut

sub SetPassword {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserLogin} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "User UserLogin!" );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
    if ( !%User ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "No such user!" );
        return;
    }
    return $Self->{ $User{Source} }->SetPassword(%Param);
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

    return $Self->{CustomerUser}->GenerateRandomPassword(@_);
}

=item SetPreferences()

set customer user preferences

    $CustomerUserObject->SetPreferences(
        Key    => 'UserComment',
        Value  => 'some comment',
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

=item SearchPreferences()

search in user preferences

    my %UserList = $CustomerUserObject->SearchPreferences(
        Key   => 'UserSomeKey',
        Value => 'SomeValue',
    );

=cut

sub SearchPreferences {
    my $Self = shift;

    return $Self->{PreferencesObject}->SearchPreferences(@_);
}

=item TokenGenerate()

generate a random token

    my $Token = $UserObject->TokenGenerate(
        UserID => 123,
    );

=cut

sub TokenGenerate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need UserID!" );
        return;
    }

    # The list of characters that can appear in a randomly generated token.
    my @Chars = ( 0 .. 9, 'A' .. 'Z', 'a' .. 'z' );

    # The number of characters in the list.
    my $CharsLen = scalar @Chars;

    # Generate the token.
    my $Token = 'C';
    for ( my $i = 0; $i < 14; $i++ ) {
        $Token .= $Chars[ rand($CharsLen) ];
    }

    # save token in preferences
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => $Token,
        UserID => $Param{UserID},
    );

    # Return the Token.
    return $Token;
}

=item TokenCheck()

check password token

    my $Valid = $UserObject->TokenCheck(
        Token  => $Token,
        UserID => 123,
    );

=cut

sub TokenCheck {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Token} || !$Param{UserID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Token and UserID!" );
        return;
    }

    # get preferences token
    my %Preferences = $Self->GetPreferences(
        UserID => $Param{UserID},
    );

    # check requested vs. stored token
    if ( $Preferences{UserToken} && $Preferences{UserToken} eq $Param{Token} ) {

        # reset password token
        $Self->SetPreferences(
            Key    => 'UserToken',
            Value  => '',
            UserID => $Param{UserID},
        );

        # return true if token is valid
        return 1;
    }
    else {

        # return false if token is invalid
        return;
    }
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.

=cut

=head1 VERSION

$Revision: 1.44.2.1 $ $Date: 2009-01-20 13:33:19 $

=cut
