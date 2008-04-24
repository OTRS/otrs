# --
# FileTemp.t - FileTemp tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: FileTemp.t,v 1.6 2008-04-24 17:32:15 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::FileTemp;

$Self->{FileTempObject} = Kernel::System::FileTemp->new(%{$Self});

my ($FH, $Filename) = $Self->{FileTempObject}->TempFile();

$Self->True(
    $Filename,
    'TempFile()',
);

$Self->True(
    (-e $Filename),
    'TempFile() -e',
);

# destroy object or delete the tempfiles
$Self->{FileTempObject} = undef;

$Self->True(
    (! -e $Filename),
    'TempFile() -e after destroy',
);

1;
