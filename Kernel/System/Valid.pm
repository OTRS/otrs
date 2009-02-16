# --
# Kernel/System/Valid.pm - all valid functions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: Valid.pm,v 1.9 2009-02-16 11:49:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Valid;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

=head1 NAME

Kernel::System::Valid - valid lib

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Valid;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );

    my $ValidObject = Kernel::System::Valid->new(
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
    for my $Object (qw(DBObject ConfigObject LogObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    return $Self;
}

=item ValidList()

return a valid list as hash

    my %List = $ValidObject->ValidList();

=cut

sub ValidList {
    my ( $Self, %Param ) = @_;

    # read cache
    return %{ $Self->{'Cache::ValidList'} } if $Self->{'Cache::ValidList'};

    # get list from database
    $Self->{DBObject}->Prepare( SQL => 'SELECT id, name FROM valid' );

    # fetch the result
    my %Data;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{ $Row[0] } = $Row[1];
    }

    # write cache
    $Self->{'Cache::ValidList'} = \%Data;

    return %Data;
}

=item ValidIDsGet()

return all valid ids as array

    my @List = $ValidObject->ValidIDsGet();

=cut

sub ValidIDsGet {
    my ( $Self, %Param ) = @_;

    # read cache
    return @{ $Self->{'Cache::ValidIDsGet'} } if $Self->{'Cache::ValidIDsGet'};

    # get valid ids
    $Self->{DBObject}->Prepare( SQL => "SELECT id FROM valid WHERE name = 'valid'" );

    # fetch the results
    my @ValidIDs;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @ValidIDs, $Row[0];
    }

    # write cache
    $Self->{'Cache::ValidIDsGet'} = \@ValidIDs;

    return @ValidIDs;
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

$Revision: 1.9 $ $Date: 2009-02-16 11:49:56 $

=cut
