# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SearchProfile;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::SearchProfile - module to manage search profiles

=head1 DESCRIPTION

module with all functions to manage search profiles

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'SearchProfile';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    # set lower if database is case sensitive
    $Self->{Lower} = '';
    if ( $Kernel::OM->Get('Kernel::System::DB')->GetDatabaseFunction('CaseSensitive') ) {
        $Self->{Lower} = 'LOWER';
    }

    return $Self;
}

=head2 SearchProfileAdd()

to add a search profile item

    $SearchProfileObject->SearchProfileAdd(
        Base      => 'TicketSearch',
        Name      => 'last-search',
        Key       => 'Body',
        Value     => $String,    # SCALAR|ARRAYREF
        UserLogin => 123,
    );

=cut

sub SearchProfileAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Base Name Key UserLogin)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # check value
    return 1 if !defined $Param{Value};

    # create login string
    my $Login = $Param{Base} . '::' . $Param{UserLogin};

    my @Data;
    if ( ref $Param{Value} eq 'ARRAY' ) {
        @Data = @{ $Param{Value} };
        $Param{Type} = 'ARRAY';
    }
    else {
        @Data = ( $Param{Value} );
        $Param{Type} = 'SCALAR';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    for my $Value (@Data) {

        return if !$DBObject->Do(
            SQL => "
                INSERT INTO search_profile
                (login, profile_name,  profile_type, profile_key, profile_value)
                VALUES (?, ?, ?, ?, ?)
                ",
            Bind => [
                \$Login, \$Param{Name}, \$Param{Type}, \$Param{Key}, \$Value,
            ],
        );
    }

    # reset cache
    my $CacheKey = $Login . '::' . $Param{Name};
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => $Login,
    );
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    return 1;
}

=head2 SearchProfileGet()

returns hash with search profile.

    my %SearchProfileData = $SearchProfileObject->SearchProfileGet(
        Base      => 'TicketSearch',
        Name      => 'last-search',
        UserLogin => 'me',
    );

=cut

sub SearchProfileGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Base Name UserLogin)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # create login string
    my $Login = $Param{Base} . '::' . $Param{UserLogin};

    # check the cache
    my $CacheKey = $Login . '::' . $Param{Name};
    my $Cache    = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );
    return %{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get search profile
    return if !$DBObject->Prepare(
        SQL => "
            SELECT profile_type, profile_key, profile_value
            FROM search_profile
            WHERE profile_name = ?
                AND $Self->{Lower}(login) = $Self->{Lower}(?)
            ",
        Bind => [ \$Param{Name}, \$Login ],
    );

    my %Result;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        if ( $Data[0] eq 'ARRAY' ) {
            push @{ $Result{ $Data[1] } }, $Data[2];
        }
        else {
            $Result{ $Data[1] } = $Data[2];
        }
    }
    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Result
    );

    return %Result;
}

=head2 SearchProfileDelete()

deletes a search profile.

    $SearchProfileObject->SearchProfileDelete(
        Base      => 'TicketSearch',
        Name      => 'last-search',
        UserLogin => 'me',
    );

=cut

sub SearchProfileDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Base Name UserLogin)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # create login string
    my $Login = $Param{Base} . '::' . $Param{UserLogin};

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # delete search profile
    return if !$DBObject->Do(
        SQL => "
            DELETE
            FROM search_profile
            WHERE profile_name = ?
                AND $Self->{Lower}(login) = $Self->{Lower}(?)
            ",
        Bind => [ \$Param{Name}, \$Login ],
    );

    # delete cache
    my $CacheKey = $Login . '::' . $Param{Name};
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => $Login,
    );
    $Kernel::OM->Get('Kernel::System::Cache')->Delete(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    return 1;
}

=head2 SearchProfileList()

returns a hash of all profiles for the given user.

    my %SearchProfiles = $SearchProfileObject->SearchProfileList(
        Base      => 'TicketSearch',
        UserLogin => 'me',
    );

=cut

sub SearchProfileList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Base UserLogin)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # create login string
    my $Login = $Param{Base} . '::' . $Param{UserLogin};

    my $Cache = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $Login,
    );
    return %{$Cache} if $Cache;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get search profile list
    return if !$DBObject->Prepare(
        SQL => "
            SELECT profile_name
            FROM search_profile
            WHERE $Self->{Lower}(login) = $Self->{Lower}(?)
            ",
        Bind => [ \$Login ],
    );

    # fetch the result
    my %Result;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $Result{ $Data[0] } = $Data[0];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $Login,
        Value => \%Result,
    );

    return %Result;
}

=head2 SearchProfileUpdateUserLogin()

changes the UserLogin of SearchProfiles

    my $Result = $SearchProfileObject->SearchProfileUpdateUserLogin(
        Base         => 'TicketSearch',
        UserLogin    => 'me',
        NewUserLogin => 'newme',
    );

=cut

sub SearchProfileUpdateUserLogin {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Base UserLogin NewUserLogin)) {
        if ( !defined( $Param{$_} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # get existing profiles
    my %SearchProfiles = $Self->SearchProfileList(
        Base      => $Param{Base},
        UserLogin => $Param{UserLogin},
    );

    # iterate over profiles; create them for new login name and delete old ones
    for my $SearchProfile ( sort keys %SearchProfiles ) {
        my %Search = $Self->SearchProfileGet(
            Base      => $Param{Base},
            Name      => $SearchProfile,
            UserLogin => $Param{UserLogin},
        );

        # add profile for new login (needs to be done per attribute)
        for my $Attribute ( sort keys %Search ) {
            $Self->SearchProfileAdd(
                Base      => $Param{Base},
                Name      => $SearchProfile,
                Key       => $Attribute,
                Value     => $Search{$Attribute},
                UserLogin => $Param{NewUserLogin},
            );
        }

        # delete the old profile
        $Self->SearchProfileDelete(
            Base      => $Param{Base},
            Name      => $SearchProfile,
            UserLogin => $Param{UserLogin},
        );
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
