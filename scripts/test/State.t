# --
# State.t - State tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::State;

my $StateObject = Kernel::System::State->new( %{$Self} );

# add state
my $StateNameRand0 = 'example-state' . int( rand(1000000) );
my $StateNameRand1 = 'example-state' . int( rand(1000000) );

my $StateID = $StateObject->StateAdd(
    Name    => $StateNameRand0,
    Comment => 'some comment',
    ValidID => 1,
    TypeID  => 1,
    UserID  => 1,
);

$Self->True(
    $StateID,
    'StateAdd()',
);

my %State = $StateObject->StateGet( ID => $StateID );

$Self->True(
    $State{Name} eq $StateNameRand0,
    'StateGet() - Name',
);
$Self->True(
    $State{Comment} eq 'some comment',
    'StateGet() - Comment',
);
$Self->True(
    $State{ValidID} eq 1,
    'StateGet() - ValidID',
);

my %StateList = $StateObject->StateList(
    UserID => 1,
);
my $Hit = 0;
for ( sort keys %StateList ) {
    if ( $_ eq $StateID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'StateList()',
);

my $StateType = $StateObject->StateTypeLookup(
    StateTypeID => 1,
);

$Self->True(
    $StateType,
    'StateTypeLookup()',
);

my @List = $StateObject->StateGetStatesByType(
    StateType => [$StateType],
    Result    => 'ID',
);

$Hit = 0;
STATEID:
for my $StateListID (@List) {
    if ( $StateID == $StateListID ) {
        $Hit = 1;
        last STATEID;
    }
}

$Self->True(
    $Hit eq 1,
    'StateGetStatesByType()',
);

my $StateUpdate = $StateObject->StateUpdate(
    ID      => $StateID,
    Name    => $StateNameRand1,
    Comment => 'some comment 1',
    ValidID => 2,
    TypeID  => 1,
    UserID  => 1,
);

$Self->True(
    $StateUpdate,
    'StateUpdate()',
);

@List = $StateObject->StateGetStatesByType(
    StateType => [$StateType],
    Result    => 'ID',
);

$Hit = 0;
STATEID:
for my $StateListID (@List) {
    if ( $StateID == $StateListID ) {
        $Hit = 1;
        last STATEID;
    }
}

$Self->True(
    $Hit eq 0,
    'StateGetStatesByType() after StateUpdate()',
);

%State = $StateObject->StateGet( ID => $StateID );

$Self->True(
    $State{Name} eq $StateNameRand1,
    'StateGet() - Name',
);
$Self->True(
    $State{Comment} eq 'some comment 1',
    'StateGet() - Comment',
);
$Self->True(
    $State{ValidID} eq 2,
    'StateGet() - ValidID',
);

my %StateTypeList = $StateObject->StateTypeList(
    UserID => 1,
);
my $New  = 0;
my $Open = 0;
for ( sort keys %StateTypeList ) {
    if ( $StateTypeList{$_} eq 'new' ) {
        $New = 1;
    }
    elsif ( $StateTypeList{$_} eq 'open' ) {
        $Open = 1;
    }
}
$Self->True(
    $New eq 1,
    'StateTypeList() - new',
);
$Self->True(
    $Open eq 1,
    'StateTypeList() - open',
);

1;
