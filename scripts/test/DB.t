# --
# DB.t - database tests
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: DB.t,v 1.1 2005-12-20 22:53:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'INSERT INTO valid (name) VALUES (\'Some\')',
    ),
    'INSERT',
);

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM valid WHERE name = \'Some\'',
        Limit => 1,
    ),
    'SELECT - Prepare',
);

$Self->True(
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
        ref($Self->{DBObject}->FetchrowArray()) eq '',
    'SELECT - FetchrowArray',
);

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM valid WHERE name = \'Some\'',
    ),
    'DELETE',
);

$Self->True(
    $Self->{DBObject}->Quote(1, 'Integer') == 1,
    'Quote Integer - 1',
);
$Self->True(
    $Self->{DBObject}->Quote(123, 'Integer') == 123,
    'Quote Integer - 123',
);

$Self->True(
    $Self->{DBObject}->Quote(61712, 'Integer') == 61712,
    'Quote Integer - 61712',
);

$Self->True(
    $Self->{DBObject}->Quote(-61712, 'Integer') == -61712,
    'Quote Integer - -61712',
);

$Self->True(
    $Self->{DBObject}->Quote('+61712', 'Integer') eq '+61712',
    'Quote Integer - +61712',
);

$Self->True(
    $Self->{DBObject}->Quote(123.23, 'Number') == 123.23,
    'Quote Number - 123.23',
);

$Self->True(
    $Self->{DBObject}->Quote(0.23, 'Number') == 0.23,
    'Quote Number - 0.23',
);

$Self->True(
    $Self->{DBObject}->Quote('+123.23', 'Number') eq '+123.23',
    'Quote Number - +123.23',
);

$Self->True(
    $Self->{DBObject}->Quote('+0.23132', 'Number') eq '+0.23132',
    'Quote Number - +0.23132',
);

$Self->True(
    $Self->{DBObject}->Quote('+12323', 'Number') eq '+12323',
    'Quote Number - +12323',
);

$Self->True(
    $Self->{DBObject}->Quote(-123.23, 'Number') == -123.23,
    'Quote Number - -123.23',
);

$Self->True(
    $Self->{DBObject}->Quote(-123, 'Number') == -123,
    'Quote Number - -123',
);

$Self->True(
    $Self->{DBObject}->Quote(-0.23, 'Number') == -0.23,
    'Quote Number - -0.23',
);

$Self->True(
    $Self->{DBObject}->Quote("Test'l") eq 'Test\\\'l',
    'Quote String - Test\'l',
);

$Self->True(
    $Self->{DBObject}->Quote("Test'l;") eq 'Test\\\'l\\;',
    'Quote String - Test\'l;',
);

1;
