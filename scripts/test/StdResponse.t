# --
# StdResponse.t - StdResponse tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: StdResponse.t,v 1.2 2008-10-06 16:44:38 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use utf8;
use Kernel::System::StdResponse;

$Self->{StdResponseObject} = Kernel::System::StdResponse->new( %{$Self} );

# tests
my @Tests = (
    {
        Name => 'text',
        Add  => {
            Name     => 'text',
            ValidID  => 1,
            Response => 'Response text',
            Comment  => 'some comment',
            UserID   => 1,
        },
        AddGet => {
            Name     => 'text',
            ValidID  => 1,
            Response => 'Response text',
            Comment  => 'some comment',
        },
        Update => {
            Name     => 'text2',
            ValidID  => 1,
            Response => 'Response text\'2',
            Comment  => 'some comment2',
            UserID   => 1,
        },
        UpdateGet => {
            Name     => 'text2',
            ValidID  => 1,
            Response => 'Response text\'2',
            Comment  => 'some comment2',
        },
    },
);

for my $Test (@Tests) {

    # add
    my $ID = $Self->{StdResponseObject}->StdResponseAdd(
        %{ $Test->{Add} },
    );
    $Self->True(
        $ID,
        "StdResponseAdd()",
    );

    my %Data = $Self->{StdResponseObject}->StdResponseGet(
        ID => $ID,
    );
    for my $Key ( keys %{ $Test->{AddGet} } ) {
        $Self->Is(
            $Test->{AddGet}->{$Key},
            $Data{$Key},
            "StdResponseGet() - $Key",
        );
    }

    # update
    my $Update = $Self->{StdResponseObject}->StdResponseUpdate(
        ID => $ID,
        %{ $Test->{Update} },
    );
    $Self->True(
        $ID,
        "StdResponseUpdate()",
    );
    %Data = $Self->{StdResponseObject}->StdResponseGet(
        ID => $ID,
    );
    for my $Key ( keys %{ $Test->{UpdateGet} } ) {
        $Self->Is(
            $Test->{UpdateGet}->{$Key},
            $Data{$Key},
            "StdResponseGet() - $Key",
        );
    }

    # delete
    my $Delete = $Self->{StdResponseObject}->StdResponseDelete(
        ID => $ID,
    );
    $Self->True(
        $ID,
        "StdResponseDelete()",
    );
}

1;
