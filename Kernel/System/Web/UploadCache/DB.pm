# --
# Kernel/System/Web/UploadCache/DB.pm - a db upload cache
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.pm,v 1.12 2007-10-02 10:35:04 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Web::UploadCache::DB;

use strict;
use warnings;
use MIME::Base64;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.12 $) [1];

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
    return $Self->{DBObject}
        ->Do( SQL => "DELETE FROM web_upload_cache WHERE form_id = '$Param{FormID}'", );
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
    {
        use bytes;
        $Param{Filesize} = length( $Param{Content} );
        no bytes;
    }

    # encode attachemnt if it's a postgresql backend!!!
    if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
        $Self->{EncodeObject}->EncodeOutput( \$Param{Content} );
        $Param{Content} = encode_base64( $Param{Content} );
    }

    # db quote (just not Content, use db Bind values)
    for (qw(FormID Filename ContentType Filesize)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    my $SQL
        = "INSERT INTO web_upload_cache "
        . " (form_id, filename, content_type, content_size, content, "
        . " create_time_unix) "
        . " VALUES "
        . " ('$Param{FormID}', '$Param{Filename}', '$Param{ContentType}', "
        . " '$Param{Filesize}', ?, "
        . time() . ")";

    # write attachment to db
    return $Self->{DBObject}->Do( SQL => $SQL, Bind => [ \$Param{Content} ] );
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

    # db quote
    for (qw(FormID Filename)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_} );
    }
    return $Self->{DBObject}->Do( SQL =>
            "DELETE FROM web_upload_cache WHERE form_id = '$Param{FormID}' AND filename = '$Param{Filename}'",
    );
}

sub FormIDGetAllFilesData {
    my ( $Self, %Param ) = @_;

    my $Counter = 0;
    my @Data    = ();
    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $SQL
        = "SELECT filename, content_type, content_size, content FROM web_upload_cache "
        . " WHERE "
        . " form_id = '"
        . $Self->{DBObject}->Quote( $Param{FormID} ) . "'"
        . " ORDER BY create_time_unix";
    $Self->{DBObject}->Prepare( SQL => $SQL, Encode => [ 1, 1, 1, 0 ] );
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

        # encode attachemnt if it's a postgresql backend!!!
        if ( !$Self->{DBObject}->GetDatabaseFunction('DirectBlob') ) {
            $Row[3] = decode_base64( $Row[3] );
        }

        # add the info
        push(
            @Data,
            {   Content     => $Row[3],
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
    my @Data    = ();
    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $SQL
        = "SELECT filename, content_type, content_size FROM web_upload_cache "
        . " WHERE "
        . " form_id = '"
        . $Self->{DBObject}->Quote( $Param{FormID} ) . "'"
        . " ORDER BY create_time_unix";
    $Self->{DBObject}->Prepare( SQL => $SQL );
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
            {   ContentType => $Row[1],
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
    return $Self->{DBObject}
        ->Do( SQL => "DELETE FROM web_upload_cache WHERE create_time_unix < $CurrentTile", );
}

1;
