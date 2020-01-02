# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use SOAP::Lite;

use Kernel::System::VariableCheck qw(:all);

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {

        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $RandomID = $Helper->GetRandomID();

# define SOAP variables
my $SOAPUser     = 'User' . $RandomID;
my $SOAPPassword = $RandomID;

# update sysconfig settings
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SOAP::User',
    Value => $SOAPUser,
);
$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'SOAP::Password',
    Value => $SOAPPassword,
);

# get remote host with some precautions for certain unit test systems
my $Host = $Helper->GetTestHTTPHostname();

# skip this test on Plack
# TODO: fix this
return 1 if $Host =~ m{:5000};

# prepare RPC config
my $Proxy = $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/'
    . $ConfigObject->Get('ScriptAlias')
    . '/rpc.pl';

my $URI = $ConfigObject->Get('HttpType')
    . '://'
    . $Host
    . '/Core';

# Create SOAP Object and use RPC interface to test SOAP Lite
my $SOAPObject = SOAP::Lite->new(
    proxy => $Proxy,
    uri   => $URI,
);

# Tests for number of params in SOAP call
# SOAP::Lite 0.715 is broken in line 1993, this file was patched in CPAN directory in order to fix
# this problem. There is a similar problem reported in SOAP::Lite bug tracker in:
# http://sourceforge.net/tracker/?func=detail&aid=3547564&group_id=66000&atid=513017

my @Tests = (
    {
        Name   => 'TimeObject::SystemTime() - No parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => undef,
    },
    {
        Name   => 'TimeObject::SystemTime() - 1 parameter',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 2 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 3 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
            Param3 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 4 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
            Param3 => 1,
            Param4 => 1,
        },
    },
    {
        Name   => 'TimeObject::SystemTime() - 5 parameters',
        Object => 'TimeObject',
        Method => 'SystemTime',
        Config => {
            Param1 => 1,
            Param2 => 1,
            Param3 => 1,
            Param4 => 1,
            Param5 => 1,
        },
    },
);

for my $Test (@Tests) {

    # send SOAP request
    my $SOAPMessage = $SOAPObject->Dispatch(
        $SOAPUser,
        $SOAPPassword,
        $Test->{Object},
        $Test->{Method},
        %{ $Test->{Config} },
    );

    # get fault from SOAP message if any
    my $FaultString;
    if ( IsHashRefWithData( $SOAPMessage->fault() ) ) {
        $FaultString = $SOAPMessage->fault()->{faultstring};
    }

    # get result from SOAP message if any
    my $Result;
    if ( $SOAPMessage->result() ) {
        $Result = $SOAPMessage->result();
    }

    $Self->Is(
        $FaultString,
        undef,
        "$Test->{Name}: Message fault should be undefined",
    );

    $Self->IsNot(
        $Result,
        undef,
        "$Test->{Name}: Message result should have a value",
    );
}

# cleanup cache is done by RestoreDatabase

1;
