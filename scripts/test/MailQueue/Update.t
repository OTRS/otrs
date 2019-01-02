# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Ensure check mail addresses is enabled.
$HelperObject->ConfigSettingChange(
    Key   => 'CheckEmailAddresses',
    Value => 1,
);

# Disable MX record check.
$HelperObject->ConfigSettingChange(
    Key   => 'CheckMXRecord',
    Value => 0,
);

my $CreateTestData = sub {
    my %Param = @_;

    my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
    my %ElementData     = (
        Sender    => 'mailqueue.test@otrs.com',
        Recipient => 'mailqueue.test@otrs.com',
        Message   => {
            'Key1' => 'Value1',
            'Key2' => 'Value2',
        },
    );

    my %Elements = (
        'ArticleID::1' => {
            %ElementData,
            ArticleID => 1,
            MessageID => 'dummy',
        },
        'ID::-99' => {
            %ElementData,
            ID => -99,
        }
    );

    for my $Key ( sort keys %Elements ) {
        my $Result = $MailQueueObject->Create( %{ $Elements{$Key} } );
        $Self->True(
            $Result,
            sprintf( 'Created the mail queue element "%s" successfuly.', $Key, ),
        );
    }

    return \%Elements;
};

my $Test = sub {
    my %Param = @_;

    my $MailQueueObject      = $Kernel::OM->Get('Kernel::System::MailQueue');
    my $Data                 = $Param{Data};
    my $Filters              = $Param{Filters};
    my $NumberOfRowsToUpdate = $Param{NumberOfRowsToUpdate};
    my $Test                 = $Param{Test} || 'True';

    my $Result;

    my $StringifyValues = sub {
        my %Param = @_;

        my $Data = $Param{Data};

        my %NewData = ();
        for my $Key ( sort keys %{$Data} ) {
            my $Value = $Data->{$Key};
            my $Ref   = ref $Value;
            if ($Ref) {
                if ( $Ref eq 'HASH' ) {
                    $Value = [ sort %{$Value} ];
                }

                $Value = join( ',', @{$Value} );
            }

            $NewData{$Key} = $Value;
        }

        return \%NewData;
    };

    # Stringfy all data values
    my %ParsedData = %{ $StringifyValues->( Data => $Data ) };

    # Call update, check if it run well.
    my $BaseTestMessage = sprintf(
        'Update elements with "%s" that match "%s"',
        join( ', ', map { $_ . '=' . $ParsedData{$_} } sort( keys %ParsedData ) ),
        join( ', ', map { $_ . '=' . $Filters->{$_} } sort( keys %{$Filters} ) ),
    );

    $Result = $MailQueueObject->Update(
        Data    => $Data,
        Filters => $Filters,
    );
    $Self->$Test( $Result, $BaseTestMessage );

    if ( $Test eq 'False' ) { return; }

    # Get list of rows using the same filters, and check if matches the $NumberOfRowsToUpdate
    $Result = $MailQueueObject->List( %{$Filters} );
    $Self->True(
        $Result && scalar( @{$Result} ) == $NumberOfRowsToUpdate,
        $BaseTestMessage . ", ${ NumberOfRowsToUpdate } row(s) affected",
    );

    # Check if the data is the same
    if ($Result) {
        for my $Item ( @{$Result} ) {

            # Stringify item values.
            my $ItemData = $StringifyValues->( Data => $Item );

            for my $Key ( sort keys %ParsedData ) {
                if ( $ItemData->{$Key} ne $ParsedData{$Key} ) {
                    $Self->True(
                        0,
                        $BaseTestMessage . ', data was updated.'
                    );

                    return;
                }
            }
        }

        $Self->True( 1, $BaseTestMessage . ', data was updated' );
    }

    return;
};

my %Elements = %{ $CreateTestData->() };

my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');
my $Result;

# START THE TESTS

# Update attempts for the article -99
$Test->(
    Data => {
        Attempts => 2,
    },
    Filters => {
        ArticleID => 1,
    },
    NumberOfRowsToUpdate => 1,
);

# Update sender with a invalid mail address
$Test->(
    Data => {
        Sender => 'dummy',
    },
    Filters => {
        ID => -99,
    },
    Test => 'False',
);

# Update Recipient with a invalid mail address
$Test->(
    Data => {
        Recipient => 'dummy',
    },
    Filters => {
        ID => -99,
    },
    Test => 'False',
);

# Change the Recipient for more than one record
$Test->(
    Data => {
        Recipient => 'mailqueue.test3@otrs.com',
    },
    Filters => {
        Sender => 'mailqueue.test@otrs.com',
    },
    NumberOfRowsToUpdate => scalar( keys %Elements ),
);

# Change the Recipient (arrayref) for more than one record
$Test->(
    Data => {
        Recipient => [ 'mailqueue.test3@otrs.com', 'mailqueue.test4@otrs.com' ],
    },
    Filters => {
        Sender => 'mailqueue.test@otrs.com',
    },
    NumberOfRowsToUpdate => scalar( keys %Elements ),
);

# Update article id for a one that is already queued.
$Test->(
    Data => {
        ArticleID => 1,
    },
    Filters => {
        ID => -99,
    },
    Test => 'False',
);

# restore to the previous state is done by RestoreDatabase

1;
