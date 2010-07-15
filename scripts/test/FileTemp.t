# --
# FileTemp.t - FileTemp tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: FileTemp.t,v 1.10 2010-07-15 07:54:04 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use Kernel::System::FileTemp;

my $FileTempObject = Kernel::System::FileTemp->new( %{$Self} );

my ( $FH, $Filename ) = $FileTempObject->TempFile();

$Self->True(
    $Filename,
    'TempFile()',
);

$Self->True(
    ( -e $Filename ),
    'TempFile() -e',
);

# destruction of object should delete the tempfiles
$FileTempObject = undef;

$Self->False(
    ( -e $Filename ),
    'TempFile() -e after destroy',
);

1;
