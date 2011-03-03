# --
# Kernel/GenericInterface/Operation/Common.pm - common operation functions
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Common.pm,v 1.2 2011-03-03 14:55:40 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::GenericInterface::Operation::Common;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Kernel::System::Auth;
use Kernel::System::User;
use Kernel::System::Group;
use Kernel::System::CustomerAuth;

=head1 NAME

Kernel::GenericInterface::Operation::Common - common operation functions

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you do not need to instantiate this object directly.
It will be passed to all Operation backends so that they can
take advantage of it.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(MainObject ConfigObject LogObject EncodeObject TimeObject DBObject)
        )
    {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!"
            };
        }

        $Self->{$Needed} = $Param{$Needed};
    }

    $Self->{CacheObject} = Kernel::System::Cache->new(
        %{$Self},
    );

    return $Self;
}

=item CachedAuth()

helper function which authenticates Agents or Customers.

    my $UserID = $OperationCommonObject->CachedAuth(
        Type     => 'Agent',    # Agent or Customer
        Username => 'User',
        Password => 'PW',
    );

Returns UserID (for Agents), CustomerUserID (for Customers), or undef
(on authentication failure).

=cut

sub CachedAuth {
    my ( $Self, %Param ) = @_;

    # check all parameters are present
    for my $Key (qw(Type Username Password)) {
        if ( !$Param{$Key} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # check if type is correct
    return if ( $Param{Type} ne 'Agent' && $Param{Type} ne 'Customer' );

    my $CacheType = 'GenericInterface::Operation::Common::CachedAuth';
    my $CacheKey  = "CachedAuth::$Param{Type}::$Param{Username}::$Param{Password}";

    # check cache
    my $CachedData = $Self->{CacheObject}->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );
    return $CachedData if $CachedData;

    my $Result;

    if ( $Param{Type} eq 'Agent' ) {
        my $UserObject  = Kernel::System::User->new( %{$Self} );
        my $GroupObject = Kernel::System::Group->new(
            %{$Self},
            UserObject => $UserObject,
        );

        my $AuthObject = Kernel::System::Auth->new(
            %{$Self},
            UserObject  => $UserObject,
            GroupObject => $GroupObject,
        );

        my $UserLogin = $AuthObject->Auth( User => $Param{Username}, Pw => $Param{Password} );

        if ( !$UserLogin ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Auth for user $Param{Username} failed!",
            );
            return;
        }

        # set user id
        $Result = $UserObject->UserLookup(
            UserLogin => $UserLogin,
        );
    }
    elsif ( $Param{Type} eq 'Customer' ) {
        my $AuthObject = Kernel::System::CustomerAuth->new( %{$Self} );

        # perform authentication
        my $UserLogin = $AuthObject->Auth( User => $Param{Username}, Pw => $Param{Password} );

        if ( !$UserLogin ) {
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message  => "Auth for user $Param{Username} failed!",
            );
            return;
        }

        my $CustomerUserObject = Kernel::System::CustomerUser->new( %{$Self} );

        my %User = $CustomerUserObject->CustomerUserDataGet(
            User => $UserLogin,
        );

        $Result = $User{UserID},
    }

    # don't cache auth failures
    return if !$Result;

    my $CacheTTL = $Self->{ConfigObject}
        ->Get("GenericInterface::Operation::Common::CachedAuth::$Param{Type}CacheTTL");
    $CacheTTL = 300 if !defined $CacheTTL;

    # cache successful authentication
    $Self->{CacheObject}->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => $Result,
        TTL   => $CacheTTL,
    );

    # return the Agent ot Customer UserID
    return $Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2011-03-03 14:55:40 $

=cut
