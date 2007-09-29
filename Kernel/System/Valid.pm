# --
# Kernel/System/Valid.pm - all valid functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Valid.pm,v 1.3 2007-09-29 11:03:51 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Valid;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

=head1 NAME

Kernel::System::Valid - valid lib

=head1 SYNOPSIS

All valid functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Valid;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $ValidObject = Kernel::System::Valid->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item ValidList()

return a valid list as hash

    my %List = $ValidObject->ValidList();

=cut

sub ValidList {
    my $Self  = shift;
    my %Param = @_;
    my %Data  = ();

    # check cache
    if ( $Self->{'Cache::ValidList'} ) {
        return %{ $Self->{'Cache::ValidList'} };
    }

    # sql
    if ( $Self->{DBObject}->Prepare( SQL => 'SELECT id, name FROM valid' ) ) {
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Data{ $Row[0] } = $Row[1];
        }
    }

    # cache
    $Self->{'Cache::ValidList'} = \%Data;

    return %Data;
}

=item ValidIDsGet()

return all valid ids as array

    my @List = $ValidObject->ValidIDsGet();

=cut

sub ValidIDsGet {
    my $Self  = shift;
    my %Param = @_;
    my @ValidIDs;

    # check cache
    if ( $Self->{'Cache::ValidIDsGet'} ) {
        return @{ $Self->{'Cache::ValidIDsGet'} };
    }

    # sql
    if ( $Self->{DBObject}->Prepare( SQL => "SELECT id FROM valid WHERE name = 'valid'" ) ) {
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push( @ValidIDs, $Row[0] );
        }
    }

    # cache
    $Self->{'Cache::ValidIDsGet'} = \@ValidIDs;

    return @ValidIDs;
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.3 $ $Date: 2007-09-29 11:03:51 $

=cut
