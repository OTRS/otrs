# --
# MD5DBUpgrade.t - DB upgrade tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::XML;
use Kernel::Config;

# create local objects
my $XMLObject = Kernel::System::XML->new( %{$Self} );

# create database for tests
my $XML = '
<Table Name="test_md5_conversion">
    <Column Name="message_id" Required="true" Size="3800" Type="VARCHAR"/>
    <Column Name="message_id_md5" Required="false" Size="32" Type="VARCHAR"/>
</Table>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my @SQL = $Self->{DBObject}->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

# create data
my %MessageIDs;
my $Success;

INSERT:
for ( 1 .. 10_000 ) {

    my $RandomString = $Self->{MainObject}->GenerateRandomString( Length => 50 );
    $MessageIDs{$RandomString} = $Self->{MainObject}->MD5sum( String => $RandomString );
    $Success = $Self->{DBObject}->Do(
        SQL => 'INSERT INTO test_md5_conversion ( message_id )'
            . ' VALUES ( ? )',
        Bind => [ \$RandomString ],
    );
    last INSERT if !$Success;
}
$Self->True(
    $Success,
    'INSERT ok',
);

# conversion to MD5
if (
    $Self->{DBObject}->GetDatabaseFunction('Type') eq 'mysql'
    || $Self->{DBObject}->GetDatabaseFunction('Type') eq 'postgresql'
    )
{
    $Self->True(
        $Self->{DBObject}
            ->Do( SQL => 'UPDATE test_md5_conversion SET message_id_md5 = MD5(message_id)' ) || 0,
        "UPDATE statement",
    );
}
else {
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT message_id, message_id_md5
                    FROM test_md5_conversion
                ',
    );
    MESSAGEID:
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        next MESSAGEID if !$Row[0];
        my $MessageID = $Row[0];
        my $MD5 = $Self->{MainObject}->MD5sum( String => $Row[0] );
        $Self->{DBObject}->Do(
            SQL => "UPDATE test_md5_conversion
                     SET message_id_md5 = ?
                     WHERE message_id = ?",
            Bind => [ \$MD5, \$MessageID ],
        );
    }
}

# test conversion
return if !$Self->{DBObject}->Prepare(
    SQL => 'SELECT message_id, message_id_md5 FROM test_md5_conversion',
);

my $Result = 1;

RESULT:
while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
    next RESULT if $Row[1] eq $MessageIDs{ $Row[0] };
    $Result = 0;
}

$Self->True(
    $Result,
    'Conversion result',
);

# cleanup
$Self->True(
    $Self->{DBObject}->Do( SQL => 'DROP TABLE test_md5_conversion' ) || 0,
    "Do() DROP TABLE",
);

1;
