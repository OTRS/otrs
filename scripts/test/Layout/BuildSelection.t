# --
# scripts/test/Layout/BuildSelection.t - layout BuildSelection() testscript
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: BuildSelection.t,v 1.1 2012-05-31 02:46:26 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self %Param));

use Kernel::System::AuthSession;
use Kernel::System::Group;
use Kernel::System::JSON;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::Web::Request;
use Kernel::Output::HTML::Layout;

# create local objects
my $SessionObject = Kernel::System::AuthSession->new( %{$Self} );
my $GroupObject   = Kernel::System::Group->new( %{$Self} );
my $TicketObject  = Kernel::System::Ticket->new( %{$Self} );
my $UserObject    = Kernel::System::User->new( %{$Self} );
my $ParamObject   = Kernel::System::Web::Request->new(
    %{$Self},
    WebRequest => $Param{WebRequest} || 0,
);
my $LayoutObject = Kernel::Output::HTML::Layout->new(
    ConfigObject       => $Self->{ConfigObject},
    LogObject          => $Self->{LogObject},
    TimeObject         => $Self->{TimeObject},
    MainObject         => $Self->{MainObject},
    EncodeObject       => $Self->{EncodeObject},
    SessionObject      => $SessionObject,
    DBObject           => $Self->{DBObject},
    ParamObject        => $ParamObject,
    TicketObject       => $TicketObject,
    UserObject         => $UserObject,
    GroupObject        => $GroupObject,
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);
my $JSONObject = Kernel::System::JSON->new( %{$Self} );

# set tests
my @Tests = (
    {
        Name       => 'Missing Data',
        Definition => {
            Data           => undef,
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response     => undef,
        Success      => 0,
        ExecuteJSON  => 0,
        JSONResponse => undef,
    },
    {
        Name       => 'Missing Name',
        Definition => {
            Data => {
                1  => 'Object1',
                2  => 'Object1::AttributeA',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                5  => 'Object1::AttributeB',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                8  => 'Object2',
                9  => 'Object2::AttributeA',
                10 => 'Object2::AttributeA::Value1',
                11 => 'Object2::AttributeA::Value2',
                12 => 'Object2::AttributeB',
                13 => 'Object2::AttributeB::Value1',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => undef,
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response     => undef,
        Success      => 0,
        ExecuteJSON  => 0,
        JSONResponse => undef,
    },
    {
        Name       => 'Normal Tree (Hash)',
        Definition => {
            Data => {
                1  => 'Object1',
                2  => 'Object1::AttributeA',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                5  => 'Object1::AttributeB',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                8  => 'Object2',
                9  => 'Object2::AttributeA',
                10 => 'Object2::AttributeA::Value1',
                11 => 'Object2::AttributeA::Value2',
                12 => 'Object2::AttributeB',
                13 => 'Object2::AttributeB::Value1',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select name="Select1" id="Select1ID">
  <option value="1">Object1</option>
  <option value="2" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="5">&nbsp;&nbsp;AttributeB</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="8">Object2</option>
  <option value="9">&nbsp;&nbsp;AttributeA</option>
  <option value="10">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="11">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="12">&nbsp;&nbsp;AttributeB</option>
  <option value="13">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="14">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '2', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->True(), $JSONObject->True(),
                    $JSONObject->False(),
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '5', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '8', 'Object2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '9', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '10', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '11', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '12', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '13', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '14', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
            ],
        },
    },
    {
        Name       => 'Missing Emements Tree 1 (Hash)',
        Definition => {
            Data => {
                1  => 'Object1',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                10 => 'Object2::AttributeA::Value1',
                11 => 'Object2::AttributeA::Value2',
                13 => 'Object2::AttributeB::Value1',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select name="Select1" id="Select1ID">
  <option value="1">Object1</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="10">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="11">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="13">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="14">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', 'Object2', $JSONObject->False(), $JSONObject->False(), $JSONObject->True(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    '10', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '11', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    '13', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '14', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
            ],
        },
    },
    {
        Name       => 'Missing Emements Tree 2 (Hash)',
        Definition => {
            Data => {
                1  => 'Object1',
                2  => 'Object1::AttributeA',
                3  => 'Object1::AttributeA::Value1',
                4  => 'Object1::AttributeA::Value2',
                5  => 'Object1::AttributeB',
                6  => 'Object1::AttributeB::Value1',
                7  => 'Object1::AttributeB::Value2',
                8  => 'Object2',
                14 => 'Object2::AttributeB::Value2',
            },
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => 2,
            SelectedValue  => undef,
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select name="Select1" id="Select1ID">
  <option value="1">Object1</option>
  <option value="2" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="3">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="4">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="5">&nbsp;&nbsp;AttributeB</option>
  <option value="6">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="7">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="8">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="14">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    '1', 'Object1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '2', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->True(), $JSONObject->True(),
                    $JSONObject->False(),
                ],
                [
                    '3', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '4', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '5', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '6', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '7', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '8', 'Object2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    '14', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
            ],
        },
    },

    # arrayref tests
    {
        Name       => 'Normal Tree (Array)',
        Definition => {
            Data => [
                'Object1',
                'Object1::AttributeA',
                'Object1::AttributeA::Value1',
                'Object1::AttributeA::Value2',
                'Object1::AttributeB',
                'Object1::AttributeB::Value1',
                'Object1::AttributeB::Value2',
                'Object2',
                'Object2::AttributeA',
                'Object2::AttributeA::Value1',
                'Object2::AttributeA::Value2',
                'Object2::AttributeB',
                'Object2::AttributeB::Value1',
                'Object2::AttributeB::Value2',
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => 'Object1::AttributeA',
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select name="Select1" id="Select1ID">
  <option value="Object1">Object1</option>
  <option value="Object1::AttributeA" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="Object1::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object1::AttributeB">&nbsp;&nbsp;AttributeB</option>
  <option value="Object1::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object2">Object2</option>
  <option value="Object2::AttributeA">&nbsp;&nbsp;AttributeA</option>
  <option value="Object2::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object2::AttributeB">&nbsp;&nbsp;AttributeB</option>
  <option value="Object2::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'Object1', 'Object1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeA', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->True(), $JSONObject->True(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeB', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2', 'Object2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeA', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeB', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
            ],
        },
    },
    {
        Name       => 'Missing Emements Tree 1 (Array)',
        Definition => {
            Data => [
                'Object1',
                'Object1::AttributeA::Value1',
                'Object1::AttributeA::Value2',
                'Object1::AttributeB::Value1',
                'Object1::AttributeB::Value2',
                'Object2::AttributeA::Value1',
                'Object2::AttributeA::Value2',
                'Object2::AttributeB::Value1',
                'Object2::AttributeB::Value2',
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => 'Object1::AttributeA',
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select name="Select1" id="Select1ID">
  <option value="Object1">Object1</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="Object1::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="Object1::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeA</option>
  <option value="Object2::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="Object2::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'Object1', 'Object1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    'Object1::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    'Object1::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', 'Object2', $JSONObject->False(), $JSONObject->False(), $JSONObject->True(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    'Object2::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    'Object2::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
            ],
        },
    },
    {
        Name       => 'Missing Emements Tree 2 (Array)',
        Definition => {
            Data => [
                'Object1',
                'Object1::AttributeA',
                'Object1::AttributeA::Value1',
                'Object1::AttributeA::Value2',
                'Object1::AttributeB',
                'Object1::AttributeB::Value1',
                'Object1::AttributeB::Value2',
                'Object2',
                'Object2::AttributeB::Value1',
                'Object2::AttributeB::Value2',
            ],
            Name           => 'Select1',
            ID             => 'Select1ID',
            Sort           => 'TreeView',
            Multiple       => 0,
            OnChange       => undef,
            OnClick        => undef,
            SelectedID     => undef,
            SelectedValue  => 'Object1::AttributeA',
            SortReverse    => 0,
            Translation    => 0,
            PossibleNone   => 0,
            TreeView       => 1,
            DisabledBranch => undef,
            Max            => undef,
            HTMLQuote      => 0,
            Title          => undef,
            OptionTitle    => 0,
        },
        Response =>
            '<select name="Select1" id="Select1ID">
  <option value="Object1">Object1</option>
  <option value="Object1::AttributeA" selected="selected">&nbsp;&nbsp;AttributeA</option>
  <option value="Object1::AttributeA::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeA::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object1::AttributeB">&nbsp;&nbsp;AttributeB</option>
  <option value="Object1::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object1::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
  <option value="Object2">Object2</option>
  <option value="-" disabled="disabled">&nbsp;&nbsp;AttributeB</option>
  <option value="Object2::AttributeB::Value1">&nbsp;&nbsp;&nbsp;&nbsp;Value1</option>
  <option value="Object2::AttributeB::Value2">&nbsp;&nbsp;&nbsp;&nbsp;Value2</option>
</select>',
        Success      => 1,
        ExecuteJSON  => 1,
        JSONResponse => {
            'Select1' => [
                [
                    'Object1', 'Object1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeA', '&nbsp;&nbsp;AttributeA',
                    $JSONObject->True(), $JSONObject->True(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeA::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeA::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeB', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object1::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2', 'Object2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    '-', '&nbsp;&nbsp;AttributeB',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->True(),
                ],
                [
                    'Object2::AttributeB::Value1', '&nbsp;&nbsp;&nbsp;&nbsp;Value1',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
                [
                    'Object2::AttributeB::Value2', '&nbsp;&nbsp;&nbsp;&nbsp;Value2',
                    $JSONObject->False(), $JSONObject->False(),
                    $JSONObject->False(),
                ],
            ],
        },
    },

);

for my $Test (@Tests) {

    # made a copy of the original data since it might be changed by LayoutObject during the test
    my %OriginalData;
    my @OriginalData;
    if ( ref $Test->{Definition}->{Data} eq 'HASH' ) {
        %OriginalData = %{ $Test->{Definition}->{Data} };
    }
    elsif ( ref $Test->{Definition}->{Data} eq 'ARRAY' ) {
        @OriginalData = @{ $Test->{Definition}->{Data} };
    }

    # call BuildSelection
    my $HTML = $LayoutObject->BuildSelection( %{ $Test->{Definition} } );

    if ( $Test->{Success} ) {
        $Self->Is(
            $HTML,
            $Test->{Response},
            "BuildSelection() for test - $Test->{Name}: result on success match expected value",
        );
    }
    else {
        $Self->Is(
            $HTML,
            undef,
            "BuildSelection() for test - $Test->{Name}: result on failure should be undef",
        );
    }

    # restore original data
    if ( ref $Test->{Definition}->{Data} eq 'HASH' ) {
        $Test->{Definition}->{Data} = {%OriginalData};
    }
    elsif ( ref $Test->{Definition}->{Data} eq 'ARRAY' ) {
        $Test->{Definition}->{Data} = [@OriginalData];
    }

    if ( $Test->{ExecuteJSON} ) {

        # call BuildSelectionJSON
        my $JSON = $LayoutObject->BuildSelectionJSON(
            [
                $Test->{Definition},
            ],
        );

        # JSON ecode the expected data for easy compare
        my $JSONResponse = $JSONObject->Encode(
            Data => $Test->{JSONResponse},
        );

        if ( $Test->{Success} ) {
            $Self->Is(
                $JSON,
                $JSONResponse,
                "BuildSelectionJSON() for test - $Test->{Name}: result on success match expected value",
            );
        }
        else {
            $Self->Is(
                $JSON,
                undef,
                "BuildSelectionJSON() for test - $Test->{Name}: result on failure should be undef",
            );
        }

        # restore original data
        if ( ref $Test->{Definition}->{Data} eq 'HASH' ) {
            $Test->{Definition}->{Data} = {%OriginalData};
        }
        elsif ( ref $Test->{Definition}->{Data} eq 'ARRAY' ) {
            $Test->{Definition}->{Data} = [@OriginalData];
        }
    }
}

1;
