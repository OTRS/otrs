# --
# WebUploadCache.t - test of the web upload cache mechanism
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::Web::UploadCache;
use Digest::MD5 qw(md5_hex);
use Kernel::System::Encode;
use Kernel::Config;

# create local object
my $ConfigObject = Kernel::Config->new();

for my $Module (qw(DB FS)) {

    $ConfigObject->Set(
        Key   => 'WebUploadCacheModule',
        Value => "Kernel::System::Web::UploadCache::$Module",
    );

    my $UploadCacheObject = Kernel::System::Web::UploadCache->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );

    my $FormID = $UploadCacheObject->FormIDCreate();

    $Self->True(
        $FormID,
        "#$Module - FormIDCreate()",
    );

    # file checks
    for my $File (qw(xls txt doc png pdf)) {

        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/WebUploadCache/WebUploadCache-Test1.$File";
        my $ContentRef = $Self->{MainObject}->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content = ${$ContentRef};
        $EncodeObject->EncodeOutput( \$Content );

        my $MD5         = md5_hex($Content);
        my $ContentID   = ( int rand 99999 ) + 1;
        my $Disposition = 'inline';

        if ( $File eq 'txt' ) {
            $ContentID   = undef;
            $Disposition = 'attachment';
        }

        my $Add = $UploadCacheObject->FormIDAddFile(
            FormID      => $FormID,
            Filename    => 'UploadCache Test1äöüß.' . $File,
            Content     => $Content,
            ContentType => 'text/html',
            ContentID   => $ContentID,
            Disposition => $Disposition,
        );

        my $Filename = "UploadCache Test1äöüß.$File";

        # Mac OS (HFS+) will store all filenames as NFD internally.
        if ( $^O eq 'darwin' && $Module eq 'FS' ) {
            $Filename = Unicode::Normalize::NFD($Filename);
        }

        $Self->True(
            $Add || '',
            "#$Module - FormIDAddFile() - ." . $File,
        );

        my @Data = $UploadCacheObject->FormIDGetAllFilesData(
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
                $Filename,
                "#$Module - FormIDGetAllFilesData() - Filename ." . $File,
            );
            $Self->True(
                $File{Content} eq $Content,
                "#$Module - FormIDGetAllFilesData() - Content ." . $File,
            );
            $EncodeObject->EncodeOutput( \$File{Content} );
            my $MD5New = md5_hex( $File{Content} );
            $Self->Is(
                $MD5New || '',
                $MD5    || '',
                "#$Module - md5 check",
            );
        }
        @Data = $UploadCacheObject->FormIDGetAllFilesMeta( FormID => $FormID );
        if (@Data) {
            my %File = %{ $Data[$#Data] };
            $Self->Is(
                $File{ContentID},
                $ContentID,
                "#$Module - FormIDGetAllFilesMeta() - ContentID ." . $File,
            );

            $Self->Is(
                $File{Filename},
                $Filename,
                "#$Module - FormIDGetAllFilesMeta() - Filename ." . $File,
            );
        }
        my $Delete = $UploadCacheObject->FormIDRemoveFile(
            FormID => $FormID,
            FileID => 1,
        );
        $Self->True(
            $Delete || '',
            "#$Module - FormIDRemoveFile() - ." . $File,
        );
    }

    # file checks without ContentID
    for my $File (qw(xls txt doc png pdf)) {
        my $Location = $ConfigObject->Get('Home')
            . "/scripts/test/sample/WebUploadCache/WebUploadCache-Test1.$File";
        my $ContentRef = $Self->{MainObject}->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );

        my $Content = ${$ContentRef};
        $EncodeObject->EncodeOutput( \$Content );
        my $MD5         = md5_hex($Content);
        my $Disposition = 'inline';
        if ( $File eq 'txt' ) {
            $Disposition = 'attachment';
        }
        my $Add = $UploadCacheObject->FormIDAddFile(
            FormID      => $FormID,
            Filename    => 'UploadCache Test1äöüß.' . $File,
            Content     => $Content,
            ContentType => 'text/html',
            Disposition => $Disposition,
        );

        my $Filename = "UploadCache Test1äöüß.$File";

        # Mac OS (HFS+) will store all filenames as NFD internally.
        if ( $^O eq 'darwin' && $Module eq 'FS' ) {
            $Filename = Unicode::Normalize::NFD($Filename);
        }

        $Self->True(
            $Add || '',
            "#$Module - FormIDAddFile() - ." . $File,
        );

        my @Data = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $FormID,
        );
        if (@Data) {
            my %File = %{ $Data[$#Data] };

            $Self->Is(
                $File{Filename},
                $Filename,
                "#$Module - FormIDGetAllFilesData() - Filename ." . $File,
            );
            $Self->True(
                $File{Content} eq $Content,
                "#$Module - FormIDGetAllFilesData() - Content ." . $File,
            );
            $EncodeObject->EncodeOutput( \$File{Content} );
            my $MD5New = md5_hex( $File{Content} );
            $Self->Is(
                $MD5New || '',
                $MD5    || '',
                "#$Module - md5 check",
            );
        }
        @Data = $UploadCacheObject->FormIDGetAllFilesMeta( FormID => $FormID );
        if (@Data) {
            my %File = %{ $Data[$#Data] };
            $Self->Is(
                $File{Filename},
                $Filename,
                "#$Module - FormIDGetAllFilesMeta() - Filename ." . $File,
            );
        }
        my $Delete = $UploadCacheObject->FormIDRemoveFile(
            FormID => $FormID,
            FileID => 1,
        );
        $Self->True(
            $Delete || '',
            "#$Module - FormIDRemoveFile() - ." . $File,
        );
    }

    my $Remove = $UploadCacheObject->FormIDRemove( FormID => $FormID );

    $Self->True(
        $Remove,
        "#$Module - FormIDRemove()",
    );
}
1;
