# --
# Kernel/System/FileTemp.pm - tmp files
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: FileTemp.pm,v 1.7 2007-09-29 11:03:51 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::FileTemp;

use strict;
use warnings;

use File::Temp qw/ tempfile tempdir /;

use vars qw(@ISA $VERSION);

$VERSION = qw($Revision: 1.7 $) [1];

=head1 NAME

Kernel::System::Temp - tmp files

=head1 SYNOPSIS

This module is managing tmp files.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a tmp file object

    use Kernel::Config;
    use Kernel::System::FileTemp;

    my $ConfigObject = Kernel::Config->new();

    my $TempObject = Kernel::System::FileTemp->new(
        ConfigObject => $ConfigObject,
    );

=cut

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get common objects
    for ( keys %Param ) {
        $Self->{$_} = $Param{$_};
    }

    # check needed objects
    for (qw(ConfigObject)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

=item TempFile()

returns a file handle and the file name

    my ($fh, $Filename) = $TempObject->TempFile();

=cut

sub TempFile {
    my $Self  = shift;
    my %Param = @_;

    #    my $FH = new File::Temp(
    #        DIR => $Self->{ConfigObject}->Get('TempDir'),
    #        SUFFIX => '.tmp',
    #        UNLINK => 1,
    #    );
    #    my $Filename = $FH->filename();
    my ( $FH, $Filename ) = tempfile(
        DIR    => $Self->{ConfigObject}->Get('TempDir'),
        SUFFIX => '.tmp',
        UNLINK => 1,
    );

    # remember created tmp files
    push( @{ $Self->{FileList} }, $Filename );

    # return FH and Filename
    return ( $FH, $Filename );
}

sub DESTROY {
    my $Self  = shift;
    my %Param = @_;

    # remove all existing tmp files
    if ( $Self->{FileList} ) {
        for ( @{ $Self->{FileList} } ) {
            if ( -f $_ ) {
                unlink $_;
            }
        }
    }
    return 1;
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

$Revision: 1.7 $ $Date: 2007-09-29 11:03:51 $

=cut
