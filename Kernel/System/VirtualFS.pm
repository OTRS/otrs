# --
# Kernel/System/VirtualFS.pm - all virtual fs functions
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: VirtualFS.pm,v 1.1 2009-09-23 22:07:07 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::VirtualFS;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

=head1 NAME

Kernel::System::VirtualFS - virtual fs lib

=head1 SYNOPSIS

All virtual fs functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::VirtualFS;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $VirtualFSObject = Kernel::System::VirtualFS->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # load backend
    $Self->{BackendDefault} = $Self->{ConfigObject}->Get('VirtualFS::Backend')
        || 'Kernel::System::VirtualFS::DB';
    if ( !$Self->{MainObject}->Require( $Self->{BackendDefault} ) ) {
        return;
    }
    $Self->{Backend}->{ $Self->{BackendDefault} } = $Self->{BackendDefault}->new(%Param);

    return $Self;
}

=item Read()

read a file from virtual file system

    my %File = $VirtualFSObject->Read(
        Filename => '/some/name.txt',
        Mode     => 'utf8',

        # optional
        DisableWarnings => 1,
    );

returns

    Content  => $ContentSCALAR,

    # preferences data
    Preferences => {

        # generated automaticaly
        Filesize           => '12.4 KBytes',
        FilesizeRaw        => 12345,

        # optional
        ContentType        => 'text/plain',
        ContentID          => '<some_id@example.com>',
        ContentAlternative => 1,
        SomeCustomParams   => 'with our own value',
    },

=cut

sub Read {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Filename Mode)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # lookup
    my ( $FileID, $BackendKey, $Backend ) = $Self->_FileLookup( $Param{Filename} );
    if ( !$BackendKey ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No such file '$Param{Filename}'!",
            );
        }
        return;
    }

    # get preferences
    my %Preferences;
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT preferences_key, preferences_value FROM '
            . 'virtual_fs_preferences WHERE virtual_fs_id = ?',
        Bind => [ \$FileID ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Preferences{ $Row[0] } = $Row[1];
    }

    # load backend (if not default)
    if ( !$Self->{Backend}->{$Backend} ) {
        return if !$Self->{MainObject}->Require($Backend);
        $Self->{Backend}->{$Backend} = $Backend->new( %{$Self} );
        return if !$Self->{Backend}->{$Backend};
    }

    # get file
    my $Content = $Self->{Backend}->{$Backend}->Read(
        %Param,
        BackendKey => $BackendKey,
    );
    return if !$Content;

    return (
        Preferences => \%Preferences,
        Content     => $Content,
    );
}

=item Write()

write a file to virtual file system

    my $Success = $VirtualFSObject->Write(
        Content  => \$Content,
        Filename => 'SomeFileName.txt',
        Mode     => 'binary'            # (binary|utf8)

        # optional, preferences data
        Preferences => {
            ContentType        => 'text/plain',
            ContentID          => '<some_id@example.com>',
            ContentAlternative => 1,
            SomeCustomParams   => 'with our own value',
        },
    );

=cut

sub Write {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Filename Content Mode)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # lookup
    my ($FileID) = $Self->_FileLookup( $Param{Filename} );
    if ($FileID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "File already exists '$Param{Filename}'!",
        );
        return;
    }

    # insert
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO virtual_fs (filename, backend_key, backend, create_time)'
            . ' VALUES ( ?, \'TMP\', ?, current_timestamp)',
        Bind => [ \$Param{Filename}, \$Self->{BackendDefault} ],
    );
    ($FileID) = $Self->_FileLookup( $Param{Filename} );
    if ( !$FileID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Unable to store '$Param{Filename}'!",
        );
        return;
    }

    # size calculation
    {
        use bytes;
        $Param{Preferences}->{FilesizeRaw} = length ${ $Param{Content} };
        no bytes;
    }
    my $Filesize = $Param{Preferences}->{FilesizeRaw};
    if ( $Filesize > ( 1024 * 1024 ) ) {
        $Filesize = sprintf "%.1f MBytes", ( $Filesize / ( 1024 * 1024 ) );
    }
    elsif ( $Filesize > 1024 ) {
        $Filesize = sprintf "%.1f KBytes", ( $Filesize / 1024 );
    }
    else {
        $Filesize = $Filesize . ' Bytes';
    }
    $Param{Preferences}->{Filesize} = $Filesize;

    # insert preferences
    for my $Key ( sort keys %{ $Param{Preferences} } ) {
        return if !$Self->{DBObject}->Do(
            SQL => 'INSERT INTO virtual_fs_preferences '
                . '(virtual_fs_id, preferences_key, preferences_value) VALUES ( ?, ?, ?)',
            Bind => [ \$FileID, \$Key, \$Param{Preferences}->{$Key} ],
        );
    }

    # store file
    my $BackendKey = $Self->{Backend}->{ $Self->{BackendDefault} }->Write(%Param);
    return if !$BackendKey;

    # update backend key
    return if !$Self->{DBObject}->Do(
        SQL => 'UPDATE virtual_fs SET backend_key = ? WHERE id = ?',
        Bind => [ \$BackendKey, \$FileID ],
    );

    return 1;
}

=item Delete()

delete a file from virtual file system

    my $Success = $VirtualFSObject->Delete(
        Filename => 'SomeFileName.txt',

        # optional
        DisableWarnings => 1,
    );

=cut

sub Delete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Filename)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # lookup
    my ( $FileID, $BackendKey, $Backend ) = $Self->_FileLookup( $Param{Filename} );
    if ( !$FileID ) {
        if ( !$Param{DisableWarnings} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No such file '$Param{Filename}'!",
            );
        }
        return;
    }

    # load backend (if not default)
    if ( !$Self->{Backend}->{$Backend} ) {
        return if !$Self->{MainObject}->Require($Backend);
        $Self->{Backend}->{$Backend} = $Backend->new( %{$Self} );
        return if !$Self->{Backend}->{$Backend};
    }

    # delete preferences
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM virtual_fs_preferences WHERE virtual_fs_id = ?',
        Bind => [ \$FileID ],
    );

    # delete
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM virtual_fs WHERE id = ?',
        Bind => [ \$FileID ],
    );

    # delete file
    return $Self->{Backend}->{$Backend}->Delete(
        %Param,
        BackendKey => $BackendKey,
    );
}

=item Find()

find files in virtual file system

    my @List = $VirtualFSObject->Find(
        Filename => 'some_what/*.txt',
    );

=cut

sub Find {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Filename)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # prepare search
    my $Like = $Param{Filename};
    $Like =~ s/\*/%/g;
    $Like = $Self->{DBObject}->Quote( $Like, 'Like' );

    # search
    return if !$Self->{DBObject}->Prepare(
        SQL => "SELECT filename FROM virtual_fs WHERE filename LIKE '$Like'",
    );
    my @List;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push @List, $Row[0];
    }
    return @List;
}

sub _FileLookup {
    my ( $Self, $Filename ) = @_;

    # lookup
    return if !$Self->{DBObject}->Prepare(
        SQL  => 'SELECT id, backend_key, backend FROM virtual_fs WHERE filename = ?',
        Bind => [ \$Filename ],
    );
    my $FileID;
    my $BackendKey;
    my $Backend;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $FileID     = $Row[0];
        $BackendKey = $Row[1];
        $Backend    = $Row[2];
    }
    return ( $FileID, $BackendKey, $Backend );
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

$Revision: 1.1 $ $Date: 2009-09-23 22:07:07 $

=cut
