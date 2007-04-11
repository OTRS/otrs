# --
# FileTemp.t - FileTemp tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: FileTemp.t,v 1.2.2.2 2007-04-11 10:36:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::FileTemp;

$Self->{FileTempObject} = Kernel::System::FileTemp->new(%{$Self});

my ($fh, $Filename) = $Self->{FileTempObject}->TempFile();

$Self->True(
    $Filename,
    'TempFile()',
);

$Self->True(
    (-e $Filename),
    'TempFile() -e',
);

$Self->{FileTempObject} = undef;

# don't use this check on win (because it just gets removed after ending the process)
if ($^O !~ /win/i) {
    $Self->True(
        (! -e $Filename),
        'TempFile() -e after destroy',
    );
}

1;
