# --
# Valid.t - valid module tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: Valid.t,v 1.3 2010-10-29 22:16:59 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::Valid;

my $ValidObject = Kernel::System::Valid->new( %{$Self} );

# tests the method to make sure there is at least 2 registries: valid - invalid
my %ValidList = $ValidObject->ValidList();

my $ValidListLength = keys %ValidList;

$Self->True(
    $ValidListLength > 1,
    'Valid length.',
);

# tests ValidIDsGet. At least 1 valid registry
my @ValidIDsList = $ValidObject->ValidIDsGet();

$Self->True(
    scalar @ValidIDsList >= 1,
    'Valid registry exists.',
);

my $Counter;
for my $ValidID (@ValidIDsList) {
    $Counter++;
    $Self->True(
        $ValidList{$ValidID},
        "Test ValidIDsGet $Counter with array exists.",
    );
}

# makes sure that all ValidIDs in the array are also in the hash containing all IDs
$Counter = 0;
for my $ValidIDKey ( keys %ValidList ) {
    my $Number = scalar grep /^\Q$ValidIDKey\E$/, @ValidIDsList;
    $Counter++;
    if ( $ValidList{$ValidIDKey} eq 'valid' ) {
        $Self->True(
            $Number,
            "Test ValidIDsGet $Counter with hash exists.",
        );
    }
    else {
        $Self->False(
            $Number,
            "Test ValidIDsGet $Counter with hash doesn't exists.",
        );
    }

    # tests ValidLookup to verify the values of the hash
    my $ValidLookupName = $ValidObject->ValidLookup( ValidID => $ValidIDKey );
    $Self->Is(
        $ValidLookupName,
        $ValidList{$ValidIDKey},
        "Test ValidLookup $Counter - both names are equivalent.",
    );

    $ValidLookupName = $ValidList{$ValidIDKey};
    my $ValidLookupID = $ValidObject->ValidLookup( Valid => $ValidLookupName );
    $Self->Is(
        $ValidLookupID,
        $ValidIDKey,
        "Test ValidLookup $Counter - both IDs are equivalent.",
    );
}

1;
