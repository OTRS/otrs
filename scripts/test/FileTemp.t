# --
# FileTemp.t - FileTemp tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: FileTemp.t,v 1.8 2009-02-16 12:41:12 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

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
