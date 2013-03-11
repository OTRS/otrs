# --
# Kernel/System/Web/UploadCache/DB.pm - a db upload cache
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::UploadCache::DB;

use strict;
use warnings;

use MIME::Base64;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject DBObject EncodeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub FormIDCreate {
    my ( $Self, %Param ) = @_;

    # cleanup temp form ids
    $Self->FormIDCleanUp();

    # return requested form id
    return time() . '.' . rand(12341241);
}

sub FormIDRemove {
    my ( $Self, %Param ) = @_;

    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM web_upload_cache WHERE form_id = ?',
        Bind => [ \$Param{FormID} ],
    );
    return 1;
}

sub FormIDAddFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID Filename Content ContentType)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get file size
    $Param{Filesize} = bytes::length( $Param{Content} );

    # encode attachment if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # create content id
    my $ContentID = $Param{ContentID};
    my $Disposition = $Param{Disposition} || '';
    if ( !$ContentID && lc $Disposition eq 'inline' ) {
        my $Random = rand 999999;
        my $FQDN   = $Self->{ConfigObject}->Get('FQDN');
        $ContentID = "$Disposition$Random.$Param{FormID}\@$FQDN";
    }

    # write attachment to db
    my $Time = time();
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO web_upload_cache '
            . ' (form_id, filename, content_type, content_size, content, create_time_unix,'
            . ' content_id)'
            . ' VALUES  (?, ?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Param{FormID}, \$Param{Filename}, \$Param{ContentType}, \$Param{Filesize},
            \$Param{Content}, \$Time, \$ContentID
        ],
    );
    return 1;
}

sub FormIDRemoveFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID FileID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my @Index = @{ $Self->FormIDGetAllFilesMeta(%Param) };
    my $ID    = $Param{FileID} - 1;
    $Param{Filename} = $Index[$ID]->{Filename};

    return if !$Self->{DBObject}->Do(
        SQL => 'DELETE FROM web_upload_cache WHERE form_id = ? AND filename = ?',
        Bind => [ \$Param{FormID}, \$Param{Filename} ],
    );
    return 1;
}

sub FormIDGetAllFilesData {
    my ( $Self, %Param ) = @_;

    my $Counter = 0;
    my @Data;
    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT filename, content_type, content_size, content, content_id'
            . ' FROM web_upload_cache '
            . ' WHERE form_id = ? ORDER BY create_time_unix',
        Bind => [ \$Param{FormID} ],
        Encode => [ 1, 1, 1, 0, 1 ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Counter++;

        # human readable file size
        if ( $Row[2] ) {
            if ( $Row[2] > ( 1024 * 1024 ) ) {
                $Row[2] = sprintf "%.1f MBytes", ( $Row[2] / ( 1024 * 1024 ) );
            }
            elsif ( $Row[2] > 1024 ) {
                $Row[2] = sprintf "%.1f KBytes", ( ( $Row[2] / 1024 ) );
            }
            else {
                $Row[2] = $Row[2] . ' Bytes';
            }
        }

        # encode attachment if it's a postgresql backend!!!
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
            $Row[3] = decode_base64( $Row[3] );
        }

        # add the info
        push(
            @Data,
            {
                Content     => $Row[3],
                ContentID   => $Row[4],
                ContentType => $Row[1],
                Filename    => $Row[0],
                Filesize    => $Row[2],
                FileID      => $Counter,
            }
        );
    }
    return \@Data;
}

sub FormIDGetAllFilesMeta {
    my ( $Self, %Param ) = @_;

    my $Counter = 0;
    my @Data;
    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT filename, content_type, content_size, content_id'
            . ' FROM web_upload_cache '
            . ' WHERE form_id = ? ORDER BY create_time_unix',
        Bind => [ \$Param{FormID} ],
    );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Counter++;

        # human readable file size
        if ( $Row[2] ) {
            if ( $Row[2] > ( 1024 * 1024 ) ) {
                $Row[2] = sprintf "%.1f MBytes", ( $Row[2] / ( 1024 * 1024 ) );
            }
            elsif ( $Row[2] > 1024 ) {
                $Row[2] = sprintf "%.1f KBytes", ( ( $Row[2] / 1024 ) );
            }
            else {
                $Row[2] = $Row[2] . ' Bytes';
            }
        }

        # add the info
        push(
            @Data,
            {
                ContentID   => $Row[3],
                ContentType => $Row[1],
                Filename    => $Row[0],
                Filesize    => $Row[2],
                FileID      => $Counter,
            }
        );
    }
    return \@Data;
}

sub FormIDCleanUp {
    my ( $Self, %Param ) = @_;

    my $CurrentTile = time() - ( 60 * 60 * 24 * 1 );
    return if !$Self->{DBObject}->Do(
        SQL  => 'DELETE FROM web_upload_cache WHERE create_time_unix < ?',
        Bind => [ \$CurrentTile ],
    );
    return 1;
}

1;
