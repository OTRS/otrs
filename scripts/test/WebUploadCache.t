# --
# AuthSession.t - auth session tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: WebUploadCache.t,v 1.4 2007-03-19 22:28:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::Web::UploadCache;
use utf8;

foreach my $Module (qw(DB FS)) {

    $Self->{ConfigObject}->Set(
        Key => 'WebUploadCacheModule',
        Value => "Kernel::System::Web::UploadCache::$Module",
    );

    $Self->{UploadCacheObject} = Kernel::System::Web::UploadCache->new(%{$Self});

    my $FormID = $Self->{UploadCacheObject}->FormIDCreate();

    $Self->True(
        $FormID,
        "#$Module - FormIDCreate()",
    );

    # file checks
    foreach my $File (qw(xls txt doc png pdf)) {
        my $Content = '';
        open(IN, "< ".$Self->{ConfigObject}->Get('Home')."/scripts/test/sample/WebUploadCache-Test1.$File") || die $!;
        binmode(IN);
        while (<IN>) {
            $Content .= $_;
        }
        close(IN);
        my $Add = $Self->{UploadCacheObject}->FormIDAddFile(
            FormID => $FormID,
            Filename => 'UploadCache Test1äöüß.'.$File,
            Content => $Content,
            ContentType => 'text/html',
        );

        $Self->True(
            $Add,
            "#$Module - FormIDAddFile() - .".$File,
        );

        my @Data = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $FormID,
        );
        if (@Data) {
            my %File = %{$Data[$#Data]};
            $Self->Is(
                $File{Filename},
                "UploadCache Test1äöüß.$File",
                "#$Module - FormIDGetAllFilesData() - Filename .".$File,
            );
            $Self->True(
                $File{Content} eq $Content,
                "#$Module - FormIDGetAllFilesData() - Content .".$File,
            );
        }
        my $Delete = $Self->{UploadCacheObject}->FormIDRemoveFile(
            FormID => $FormID,
            FileID => 1,
        );
        $Self->True(
            $Delete,
            "#$Module - FormIDRemoveFile() - .".$File,
        );
    }

    my $Remove = $Self->{UploadCacheObject}->FormIDRemove(FormID => $FormID);

    $Self->True(
        $Remove,
        "#$Module - FormIDRemove()",
    );
}
1;
