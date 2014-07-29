# --
# Kernel/System/CustomerUser.pm - some customer user functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CustomerUser;

use strict;
use warnings;

use Kernel::System::EventHandler;

use base qw(Kernel::System::EventHandler);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerCompany',
    'Kernel::System::Log',
    'Kernel::System::Main',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::CustomerUser - customer user lib

=head1 SYNOPSIS

All customer user functions. E. g. to add and update customer users.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # load generator customer preferences module
    my $GeneratorModule = $ConfigObject->Get('CustomerPreferences')->{Module}
        || 'Kernel::System::CustomerUser::Preferences::DB';

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    if ( $MainObject->Require($GeneratorModule) ) {
        $Self->{PreferencesObject} = $GeneratorModule->new();
    }

    # load customer user backend module
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerUser$Count");

        my $GenericModule = $ConfigObject->Get("CustomerUser$Count")->{Module};
        if ( !$MainObject->Require($GenericModule) ) {
            $MainObject->Die("Can't load backend module $GenericModule! $@");
        }
        $Self->{"CustomerUser$Count"} = $GenericModule->new(
            Count             => $Count,
            PreferencesObject => $Self->{PreferencesObject},
            CustomerUserMap   => $ConfigObject->Get("CustomerUser$Count"),
        );
    }

    # init of event handler
    $Self->EventHandlerInit(
        Config     => 'CustomerUser::EventModulePost',
        BaseObject => 'CustomerUserObject',
        Objects    => {
            %{$Self},
        },
    );

    return $Self;
}

=item CustomerSourceList()

return customer source list

    my %List = $CustomerUserObject->CustomerSourceList(
        ReadOnly => 0 # optional, 1 returns only RO backends, 0 returns writable, if not passed returns all backends
    );

=cut

sub CustomerSourceList {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$ConfigObject->Get("CustomerUser$Count");
        if ( defined $Param{ReadOnly} ) {
            my $CustomerBackendConfig = $ConfigObject->Get("CustomerUser$Count");
            if ( $Param{ReadOnly} ) {
                next SOURCE if !$CustomerBackendConfig->{ReadOnly};
            }
            else {
                next SOURCE if $CustomerBackendConfig->{ReadOnly};
            }
        }
        $Data{"CustomerUser$Count"} = $ConfigObject->Get("CustomerUser$Count")->{Name}
            || "No Name $Count";
    }
    return %Data;
}

=item CustomerSearch()

to search users

    # text search
    my %List = $CustomerUserObject->CustomerSearch(
        Search => '*some*', # also 'hans+huber' possible
        Valid  => 1, # not required, default 1
    );

    # username search
    my %List = $CustomerUserObject->CustomerSearch(
        UserLogin => '*some*',
        Valid     => 1, # not required, default 1
    );

    # email search
    my %List = $CustomerUserObject->CustomerSearch(
        PostMasterSearch => 'email@example.com',
        Valid            => 1, # not required, default 1
    );

    # search by CustomerID
    my %List = $CustomerUserObject->CustomerSearch(
        CustomerID       => 'CustomerID123',
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

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer search result of backend and merge it
        my %SubData = $Self->{"CustomerUser$Count"}->CustomerSearch(%Param);
        %Data = ( %SubData, %Data );
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

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer list result of backend and merge it
        my %SubData = $Self->{"CustomerUser$Count"}->CustomerUserList(%Param);
        %Data = ( %Data, %SubData );
    }
    return %Data;
}

=item CustomerIDList()

return a list of with all known unique CustomerIDs of the registered customers users (no SearchTerm),
or a filtered list where the CustomerIDs must contain a search term.

    my @CustomerIDs = $CustomerUserObject->CustomerIDList(
        SearchTerm  => 'somecustomer',    # optional
        Valid       => 1,                 # optional
    );

=cut

sub CustomerIDList {
    my ( $Self, %Param ) = @_;

    my @Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer list result of backend and merge it
        push @Data, $Self->{"CustomerUser$Count"}->CustomerIDList(%Param);
    }

    # make entries unique
    my %Tmp;
    @Tmp{@Data} = undef;
    @Data = sort { lc $a cmp lc $b } keys %Tmp;

    return @Data;
}

=item CustomerName()

get customer user name

    my $Name = $CustomerUserObject->CustomerName(
        UserLogin => 'some-login',
    );

=cut

sub CustomerName {
    my ( $Self, %Param ) = @_;

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer name and return it
        my $Name = $Self->{"CustomerUser$Count"}->CustomerName(%Param);
        if ($Name) {
            return $Name;
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

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer id's and return it
        my @CustomerIDs = $Self->{"CustomerUser$Count"}->CustomerIDs(%Param);
        if (@CustomerIDs) {
            return @CustomerIDs;
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

    return if !$Param{User};

    # get needed objects
    my $ConfigObject          = $Kernel::OM->Get('Kernel::Config');
    my $CustomerCompanyObject = $Kernel::OM->Get('Kernel::System::CustomerCompany');

    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        my %Customer = $Self->{"CustomerUser$Count"}->CustomerUserDataGet( %Param, );
        next SOURCE if !%Customer;

        # add preferences defaults
        my $Config = $ConfigObject->Get('CustomerPreferencesGroups');
        if ($Config) {
            KEY:
            for my $Key ( sort keys %{$Config} ) {

                next KEY if !defined $Config->{$Key}->{DataSelected};
                next KEY if defined $Customer{ $Config->{$Key}->{PrefKey} };

                # set default data
                $Customer{ $Config->{$Key}->{PrefKey} } = $Config->{$Key}->{DataSelected};
            }
        }

        # check if customer company support is enabled and get company data
        my %Company;
        if (
            $ConfigObject->Get("CustomerCompany")
            && $ConfigObject->Get("CustomerUser$Count")->{CustomerCompanySupport}
            )
        {
            %Company = $CustomerCompanyObject->CustomerCompanyGet(
                CustomerID => $Customer{UserCustomerID},
            );

            $Company{CustomerCompanyValidID} = $Company{ValidID};
        }

        # return customer data
        return (
            %Company,
            %Customer,
            Source        => "CustomerUser$Count",
            Config        => $ConfigObject->Get("CustomerUser$Count"),
            CompanyConfig => $ConfigObject->Get( $Company{Source} // 'CustomerCompany' ),
        );
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "User already exists '$Param{UserLogin}'!",
            );
            return;
        }
    }

    my $Result = $Self->{ $Param{Source} }->CustomerUserAdd(%Param);
    return if !$Result;

    # trigger event
    $Self->EventHandler(
        Event => 'CustomerUserAdd',
        Data  => {
            UserLogin => $Param{UserLogin},
            NewData   => \%Param,
        },
        UserID => $Param{UserID},
    );

    return $Result;

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
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => "Need UserLogin!" );
        return;
    }

    # check for UserLogin-renaming and if new UserLogin already exists...
    if ( $Param{ID} && ( lc $Param{UserLogin} ne lc $Param{ID} ) ) {
        my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
        if (%User) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "User already exists '$Param{UserLogin}'!",
            );
            return;
        }
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{ID} || $Param{UserLogin} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserLogin}'!",
        );
        return;
    }
    my $Result = $Self->{ $User{Source} }->CustomerUserUpdate(%Param);
    return if !$Result;

    # trigger event
    $Self->EventHandler(
        Event => 'CustomerUserUpdate',
        Data  => {
            UserLogin => $Param{ID} || $Param{UserLogin},
            NewData   => \%Param,
            OldData   => \%User,
        },
        UserID => $Param{UserID},
    );

    return $Result;

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
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'User UserLogin!' );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserLogin} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserLogin}'!",
        );
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
    my ( $Self, %Param ) = @_;

    return $Self->{CustomerUser}->GenerateRandomPassword(%Param);
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
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserID} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserID}'!",
        );
        return;
    }

    # call new api (2.4.8 and higher)
    if ( $Self->{ $User{Source} }->can('SetPreferences') ) {
        return $Self->{ $User{Source} }->SetPreferences(%Param);
    }

    # call old api
    return $Self->{PreferencesObject}->SetPreferences(%Param);
}

=item GetPreferences()

get customer user preferences

    my %Preferences = $CustomerUserObject->GetPreferences(
        UserID => 'some-login',
    );

=cut

sub GetPreferences {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
    }

    # check if user exists
    my %User = $Self->CustomerUserDataGet( User => $Param{UserID} );
    if ( !%User ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No such user '$Param{UserID}'!",
        );
        return;
    }

    # call new api (2.4.8 and higher)
    if ( $Self->{ $User{Source} }->can('GetPreferences') ) {
        return $Self->{ $User{Source} }->GetPreferences(%Param);
    }

    # call old api
    return $Self->{PreferencesObject}->GetPreferences(%Param);
}

=item SearchPreferences()

search in user preferences

    my %UserList = $CustomerUserObject->SearchPreferences(
        Key   => 'UserSomeKey',
        Value => 'SomeValue',   # optional, limit to a certain value/pattern
    );

=cut

sub SearchPreferences {
    my ( $Self, %Param ) = @_;

    my %Data;
    SOURCE:
    for my $Count ( '', 1 .. 10 ) {

        next SOURCE if !$Self->{"CustomerUser$Count"};

        # get customer search result of backend and merge it
        # call new api (2.4.8 and higher)
        my %SubData;
        if ( $Self->{"CustomerUser$Count"}->can('SearchPreferences') ) {
            %SubData = $Self->{"CustomerUser$Count"}->SearchPreferences(%Param);
        }

        # call old api
        else {
            %SubData = $Self->{PreferencesObject}->SearchPreferences(%Param);
        }
        %Data = ( %SubData, %Data );
    }

    return %Data;
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
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => "Need UserID!" );
        return;
    }

    my $Token = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length => 14,
    );

    # save token in preferences
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => $Token,
        UserID => $Param{UserID},
    );

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
        $Kernel::OM->Get('Kernel::System::Log')
            ->Log( Priority => 'error', Message => "Need Token and UserID!" );
        return;
    }

    # get preferences token
    my %Preferences = $Self->GetPreferences(
        UserID => $Param{UserID},
    );

    # check requested vs. stored token
    return if !$Preferences{UserToken};
    return if $Preferences{UserToken} ne $Param{Token};

    # reset password token
    $Self->SetPreferences(
        Key    => 'UserToken',
        Value  => '',
        UserID => $Param{UserID},
    );

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
