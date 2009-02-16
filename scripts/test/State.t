# --
# State.t - State tests
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: State.t,v 1.5 2009-02-16 12:40:23 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use Kernel::System::State;

$Self->{StateObject} = Kernel::System::State->new( %{$Self} );

# add state
my $StateNameRand0 = 'example-state' . int( rand(1000000) );
my $StateNameRand1 = 'example-state' . int( rand(1000000) );

my $StateID = $Self->{StateObject}->StateAdd(
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

my %State = $Self->{StateObject}->StateGet( ID => $StateID );

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

my %StateList = $Self->{StateObject}->StateList(
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

my $StateUpdate = $Self->{StateObject}->StateUpdate(
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

%State = $Self->{StateObject}->StateGet( ID => $StateID );

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

my %StateTypeList = $Self->{StateObject}->StateTypeList(
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
