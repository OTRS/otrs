# --
# StandardResponse.t - StandardResponse tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: StandardResponse.t,v 1.2 2010-06-22 22:00:52 dz Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use utf8;
use Kernel::System::StandardResponse;

$Self->{StandardResponseObject} = Kernel::System::StandardResponse->new( %{$Self} );

# tests
my @Tests = (
    {
        Name => 'text',
        Add  => {
            Name        => 'text',
            ValidID     => 1,
            Response    => 'Response text',
            ContentType => 'text/plain; charset=iso-8859-1',
            Comment     => 'some comment',
            UserID      => 1,
        },
        AddGet => {
            Name        => 'text',
            ValidID     => 1,
            Response    => 'Response text',
            ContentType => 'text/plain; charset=iso-8859-1',
            Comment     => 'some comment',
        },
        Update => {
            Name        => 'text2',
            ValidID     => 1,
            Response    => 'Response text\'2',
            ContentType => 'text/plain; charset=utf-8',
            Comment     => 'some comment2',
            UserID      => 1,
        },
        UpdateGet => {
            Name        => 'text2',
            ValidID     => 1,
            Response    => 'Response text\'2',
            ContentType => 'text/plain; charset=utf-8',
            Comment     => 'some comment2',
        },
    },
);

for my $Test (@Tests) {

    # add
    my $ID = $Self->{StandardResponseObject}->StandardResponseAdd(
        %{ $Test->{Add} },
    );
    $Self->True(
        $ID,
        "StandardResponseAdd()",
    );

    my %Data = $Self->{StandardResponseObject}->StandardResponseGet(
        ID => $ID,
    );
    for my $Key ( keys %{ $Test->{AddGet} } ) {
        $Self->Is(
            $Test->{AddGet}->{$Key},
            $Data{$Key},
            "StandardResponseGet() - $Key",
        );
    }

    # update
    my $Update = $Self->{StandardResponseObject}->StandardResponseUpdate(
        ID => $ID,
        %{ $Test->{Update} },
    );
    $Self->True(
        $ID,
        "StandardResponseUpdate()",
    );
    %Data = $Self->{StandardResponseObject}->StandardResponseGet(
        ID => $ID,
    );
    for my $Key ( keys %{ $Test->{UpdateGet} } ) {
        $Self->Is(
            $Test->{UpdateGet}->{$Key},
            $Data{$Key},
            "StandardResponseGet() - $Key",
        );
    }

    # delete
    my $Delete = $Self->{StandardResponseObject}->StandardResponseDelete(
        ID => $ID,
    );
    $Self->True(
        $ID,
        "StandardResponseDelete()",
    );
}

1;
