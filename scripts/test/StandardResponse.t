# --
# StandardResponse.t - StandardResponse tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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

my $StandardResponseObject = Kernel::System::StandardResponse->new( %{$Self} );

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
    my $ID = $StandardResponseObject->StandardResponseAdd(
        %{ $Test->{Add} },
    );
    $Self->True(
        $ID,
        "StandardResponseAdd()",
    );

    my %Data = $StandardResponseObject->StandardResponseGet(
        ID => $ID,
    );
    for my $Key ( sort keys %{ $Test->{AddGet} } ) {
        $Self->Is(
            $Test->{AddGet}->{$Key},
            $Data{$Key},
            "StandardResponseGet() - $Key",
        );
    }

    # lookup by ID
    my $Name = $StandardResponseObject->StandardResponseLookup(
        StandardResponseID => $ID
    );
    $Self->Is(
        $Name,
        $Test->{Name},
        "StandardResponseLookup()",
    );

    # lookup by Name
    my $LookupID = $StandardResponseObject->StandardResponseLookup(
        StandardResponse => $Test->{Name},
    );
    $Self->Is(
        $ID,
        $LookupID,
        "StandardResponseLookup()",
    );

    # update
    my $Update = $StandardResponseObject->StandardResponseUpdate(
        ID => $ID,
        %{ $Test->{Update} },
    );
    $Self->True(
        $ID,
        "StandardResponseUpdate()",
    );
    %Data = $StandardResponseObject->StandardResponseGet(
        ID => $ID,
    );
    for my $Key ( sort keys %{ $Test->{UpdateGet} } ) {
        $Self->Is(
            $Test->{UpdateGet}->{$Key},
            $Data{$Key},
            "StandardResponseGet() - $Key",
        );
    }

    # delete
    my $Delete = $StandardResponseObject->StandardResponseDelete(
        ID => $ID,
    );
    $Self->True(
        $ID,
        "StandardResponseDelete()",
    );
}

1;
