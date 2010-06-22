# --
# WebUploadCache.t - test of the web upload cache mechanism
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: WebUploadCache.t,v 1.14 2010-06-22 22:00:52 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Web::UploadCache;
use Digest::MD5 qw(md5_hex);

use utf8;

for my $Module (qw(DB FS)) {

    $Self->{ConfigObject}->Set(
        Key   => 'WebUploadCacheModule',
        Value => "Kernel::System::Web::UploadCache::$Module",
    );

    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new( %{$Self} );

    my $FormID = $Self->{UploadCacheObject}->FormIDCreate();

    $Self->True(
        $FormID,
        "#$Module - FormIDCreate()",
    );

    # file checks
    for my $File (qw(xls txt doc png pdf)) {
        my $Content = '';
        open( IN,
            "< "
                . $Self->{ConfigObject}->Get('Home')
                . "/scripts/test/sample/WebUploadCache/WebUploadCache-Test1.$File"
            )
            || die $!;
        binmode(IN);
        while (<IN>) {
            $Content .= $_;
        }
        close(IN);
        $Self->{EncodeObject}->EncodeOutput( \$Content );
        my $MD5       = md5_hex($Content);
        my $ContentID = int rand 1234;
        my $Add       = $Self->{UploadCacheObject}->FormIDAddFile(
            FormID      => $FormID,
            Filename    => 'UploadCache Test1äöüß.' . $File,
            Content     => $Content,
            ContentType => 'text/html',
            ContentID   => $ContentID,
        );

        $Self->True(
            $Add || '',
            "#$Module - FormIDAddFile() - ." . $File,
        );

        my @Data = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $FormID,
        );
        if (@Data) {
            my %File = %{ $Data[$#Data] };
            $Self->Is(
                $File{ContentID},
                $ContentID,
                "#$Module - FormIDGetAllFilesData() - ContentID ." . $File,
            );
            $Self->Is(
                $File{Filename},
                "UploadCache Test1äöüß.$File",
                "#$Module - FormIDGetAllFilesData() - Filename ." . $File,
            );
            $Self->True(
                $File{Content} eq $Content,
                "#$Module - FormIDGetAllFilesData() - Content ." . $File,
            );
            $Self->{EncodeObject}->EncodeOutput( \$File{Content} );
            my $MD5New = md5_hex( $File{Content} );
            $Self->Is(
                $MD5New || '',
                $MD5    || '',
                "#$Module - md5 check",
            );
        }
        @Data = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $FormID,
        );
        if (@Data) {
            my %File = %{ $Data[$#Data] };
            $Self->Is(
                $File{ContentID},
                $ContentID,
                "#$Module - FormIDGetAllFilesMeta() - ContentID ." . $File,
            );
            $Self->Is(
                $File{Filename},
                "UploadCache Test1äöüß.$File",
                "#$Module - FormIDGetAllFilesMeta() - Filename ." . $File,
            );
        }
        my $Delete = $Self->{UploadCacheObject}->FormIDRemoveFile(
            FormID => $FormID,
            FileID => 1,
        );
        $Self->True(
            $Delete || '',
            "#$Module - FormIDRemoveFile() - ." . $File,
        );
    }

    my $Remove = $Self->{UploadCacheObject}->FormIDRemove( FormID => $FormID );

    $Self->True(
        $Remove,
        "#$Module - FormIDRemove()",
    );
}
1;
