# --
# Kernel/System/SearchProfile.pm - module to manage search profiles
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: SearchProfile.pm,v 1.12 2009-02-16 11:57:40 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SearchProfile;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

=head1 NAME

Kernel::System::SearchProfile - module to manage search profiles

=head1 SYNOPSIS

module with all functions to manage search profiles

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::SearchProfile;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $SearchProfileObject = Kernel::System::SearchProfile->new(
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
    for (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item SearchProfileAdd()

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

    my @Data = ();

    # check needed stuff
    for (qw(Base Name Key UserLogin)) {
        if ( !defined( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check value
    if ( !defined( $Param{Value} ) ) {
        return 1;
    }
    if ( ref( $Param{Value} ) eq 'ARRAY' ) {
        @Data = @{ $Param{Value} };
        $Param{Type} = 'ARRAY';
    }
    else {
        @Data = ( $Param{Value} );
        $Param{Type} = 'SCALAR';
    }

    for my $Value (@Data) {
        my $Login = "$Param{Base}::$Param{UserLogin}";
        return if !$Self->{DBObject}->Do(
            SQL =>
                "INSERT INTO search_profile (login, profile_name,  profile_type, profile_key, profile_value)"
                . " VALUES (?, ?, ?, ?, ?) ",
            Bind => [
                \$Login, \$Param{Name}, \$Param{Type}, \$Param{Key}, \$Value,
            ],
        );
    }
    return 1;
}

=item SearchProfileGet()

returns a hash with search profile

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    my $Login = $Self->{DBObject}->Quote("$Param{Base}::$Param{UserLogin}");
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT profile_type, profile_key, profile_value FROM "
            . "search_profile WHERE profile_name = ? AND LOWER(login) = LOWER('$Login')",
        Bind => [ \$Param{Name} ],
    );

    my %Result;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        if ( $Data[0] eq 'ARRAY' ) {
            push( @{ $Result{ $Data[1] } }, $Data[2] );
        }
        else {
            $Result{ $Data[1] } = $Data[2];
        }
    }
    return %Result;
}

=item SearchProfileDelete()

deletes an profile

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    my $Login = $Self->{DBObject}->Quote("$Param{Base}::$Param{UserLogin}");
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM search_profile WHERE "
            . " profile_name = ? AND LOWER(login) = LOWER('$Login')",
        Bind => [ \$Param{Name} ],
    );
}

=item SearchProfileList()

returns a hash of all proviles

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql
    my $Login = $Self->{DBObject}->Quote("$Param{Base}::$Param{UserLogin}");
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT profile_name FROM search_profile WHERE LOWER(login) = LOWER('$Login')",
    );
    my %Result = ();
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Result{ $Data[0] } = $Data[0];
    }
    return %Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see http://www.gnu.org/licenses/agpl.txt.

=cut

=head1 VERSION

$Revision: 1.12 $ $Date: 2009-02-16 11:57:40 $

=cut
