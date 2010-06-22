# --
# Type.t - Type tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: Type.t,v 1.9 2010-06-22 22:00:51 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Type;

$Self->{TypeObject} = Kernel::System::Type->new( %{$Self} );

# add type
my $TypeNameRand0 = 'unittest' . int rand 1000000;

my $TypeID = $Self->{TypeObject}->TypeAdd(
    Name    => $TypeNameRand0,
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $TypeID,
    'TypeAdd()',
);

# get the type by using the type id
my %Type = $Self->{TypeObject}->TypeGet(
    ID => $TypeID,
);

$Self->Is(
    $Type{Name} || '',
    $TypeNameRand0,
    'TypeGet() - Name (using the type id)',
);
$Self->Is(
    $Type{ValidID} || '',
    1,
    'TypeGet() - ValidID',
);

# get the type by using the type name
%Type = $Self->{TypeObject}->TypeGet(
    Name => $TypeNameRand0,
);

$Self->Is(
    $Type{Name} || '',
    $TypeNameRand0,
    'TypeGet() - Name (using the type name)',
);

my %TypeList = $Self->{TypeObject}->TypeList(
    Valid => 0,
);
my $Hit = 0;
for ( sort keys %TypeList ) {
    if ( $_ eq $TypeID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'TypeList()',
);

my $TypeUpdate = $Self->{TypeObject}->TypeUpdate(
    ID      => $TypeID,
    Name    => $TypeNameRand0 . '1',
    ValidID => 2,
    UserID  => 1,
);

$Self->True(
    $TypeUpdate,
    'TypeUpdate()',
);

%Type = $Self->{TypeObject}->TypeGet(
    ID => $TypeID,
);

$Self->Is(
    $Type{Name} || '',
    $TypeNameRand0 . '1',
    'TypeGet() - Name',
);

$Self->Is(
    $Type{ValidID} || '',
    2,
    'TypeGet() - ValidID',
);

my $TypeLookup = $Self->{TypeObject}->TypeLookup(
    TypeID => $TypeID,
);

$Self->Is(
    $TypeLookup || '',
    $TypeNameRand0 . '1',
    'TypeLookup() - TypeID',
);

my $TypeIDLookup = $Self->{TypeObject}->TypeLookup(
    Type => $TypeLookup,
);

$Self->Is(
    $TypeIDLookup || '',
    $TypeID,
    'TypeLookup() - Type',
);

1;
