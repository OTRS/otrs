# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::FileTemp;

use strict;
use warnings;

use File::Temp qw( tempfile tempdir );

our @ObjectDependencies = (
    'Kernel::Config',
);

=head1 NAME

Kernel::System::FileTemp - tmp files

=head1 SYNOPSIS

This module is managing temporary files and directories.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{FileHandleList} = [];

    return $Self;
}

=item TempFile()

returns an opened temporary file handle and its file name.
Please note that you need to close the file handle for other processes to write to it.

    my ($FileHandle, $Filename) = $TempObject->TempFile(
        Suffix => '.png',   # optional, defaults to '.tmp'
    );

=cut

sub TempFile {
    my ($Self, %Param) = @_;

    my $TempDir = $Kernel::OM->Get('Kernel::Config')->Get('TempDir');

    my ( $FH, $Filename ) = tempfile(
        DIR    => $TempDir,
        SUFFIX => $Param{Suffix} // '.tmp',
        UNLINK => 1,
    );

    # remember created tmp files and handles
    push @{ $Self->{FileHandleList} }, $FH;

    return ( $FH, $Filename );
}

=item TempDir()

returns a temp directory. The directory and its contents will be removed
if the FileTemp object goes out of scope.

=cut

sub TempDir {
    my $Self = shift;

    my $TempDir = $Kernel::OM->Get('Kernel::Config')->Get('TempDir');

    my $DirName = tempdir(
        DIR     => $TempDir,
        CLEANUP => 1,
    );

    return $DirName;
}

sub DESTROY {
    my ( $Self, %Param ) = @_;

    # close all existing file handles
    FILEHANDLE:
    for my $FileHandle ( @{ $Self->{FileHandleList} } ) {
        next FILEHANDLE if !$FileHandle;
        close $FileHandle;
    }

    File::Temp::cleanup();

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
