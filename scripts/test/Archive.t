# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $ChecksumFileNotPresent = sub {
    $Self->False(
        1,
        'Archive unit test requires the checksum file (ARCHIVE) to be present and valid. Please first call the following command to create it: bin/otrs.CheckSum.pl -a create'
    );
    return 1;
};

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $ChecksumFile = "$Home/ARCHIVE";

# Checksum file content as an array ref.
my $ChecksumFileArrayRef = $MainObject->FileRead(
    Location        => $ChecksumFile,
    Mode            => 'utf8',
    Type            => 'Local',
    Result          => 'ARRAY',
    DisableWarnings => 1,
);
return $ChecksumFileNotPresent->() if !$ChecksumFileArrayRef || !@{$ChecksumFileArrayRef};

my $ChecksumFileSize = -s $ChecksumFile;
$Self->True(
    $ChecksumFileSize && $ChecksumFileSize > 2**10 && $ChecksumFileSize < 2**20,
    'Checksum file size in expected range (> 1KB && < 1MB)'
);

# Verify MD5 digests for the first 100 entries in the checksum file.
INDEX:
for my $Index ( 0 .. 99 ) {
    last INDEX if !defined $ChecksumFileArrayRef->[$Index];

    my @Entry = split '::', $ChecksumFileArrayRef->[$Index];
    next INDEX if @Entry < 2;

    chomp $Entry[1];
    my $Filename = "$Home/$Entry[1]";

    if ( !-f $Filename ) {
        $Self->False(
            1,
            "$Filename not found"
        );
        next INDEX;
    }

    if ( $Filename =~ /Cron|CHANGES/ ) {
        $Self->True(
            1,
            "$Filename checksum is skipped",
        );
        next INDEX;
    }

    my $Digest = $MainObject->MD5sum(
        Filename => $Filename,
    );

    if ( $Digest ne $Entry[0] && -e "$Filename.save" ) {
        $Self->True(
            1,
            "$Filename ignored ($Filename.save present)"
        );
        next INDEX;
    }

    $Self->Is(
        $Digest,
        $Entry[0],
        "$Filename digest"
    );
}

1;
