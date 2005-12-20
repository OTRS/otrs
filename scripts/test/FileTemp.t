# --
# FileTemp.t - FileTemp tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FileTemp.t,v 1.1 2005-12-20 22:53:43 martin Exp $
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

$Self->True(
    (! -e $Filename),
    'TempFile() -e after destroy',
);

1;
