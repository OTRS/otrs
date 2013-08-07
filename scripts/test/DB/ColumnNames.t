# --
# ColumnNames.t - database tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars qw($Self);

use Kernel::System::XML;

my $XMLObject = Kernel::System::XML->new( %{$Self} );
my $DBObject  = Kernel::System::DB->new( %{$Self} );

# ------------------------------------------------------------ #
# column name tests
# ------------------------------------------------------------ #

my @Tests = (
    {
        Name   => 'SELECT with named columns',
        Data   => 'SELECT id, name FROM groups',
        Result => [qw (id name)],
    },
    {
        Name   => 'SELECT with all columns',
        Data   => 'SELECT * FROM groups',
        Result => [qw (id name comments valid_id create_time create_by change_time change_by)],
    },
);

for my $Test (@Tests) {
    my $Result = $DBObject->Prepare(
        SQL => $Test->{Data},
    );
    my @Names = $DBObject->GetColumnNames();

    my $Counter = 0;
    for my $Field ( @{ $Test->{Result} } ) {

        $Self->Is(
            lc $Names[$Counter],
            $Field,
            "GetColumnNames - field $Field - $Test->{Name}",
        );
        $Counter++;
    }
}

1;
