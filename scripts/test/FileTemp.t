# --
# FileTemp.t - FileTemp tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: FileTemp.t,v 1.9 2010-06-22 22:00:52 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use Kernel::System::FileTemp;

$Self->{FileTempObject} = Kernel::System::FileTemp->new( %{$Self} );

my ( $FH, $Filename ) = $Self->{FileTempObject}->TempFile();

$Self->True(
    $Filename,
    'TempFile()',
);

$Self->True(
    ( -e $Filename ),
    'TempFile() -e',
);

# destroy object or delete the tempfiles
$Self->{FileTempObject} = undef;

$Self->True(
    ( !-e $Filename ),
    'TempFile() -e after destroy',
);

1;
