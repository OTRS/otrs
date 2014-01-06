# --
# WebUserAgent.t - Authentication tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::WebUserAgent;
use Kernel::System::VariableCheck qw(:all);

my $TestNumber     = 1;
my $TimeOut        = $Self->{ConfigObject}->Get('Package::Timeout');
my $Proxy          = $Self->{ConfigObject}->Get('Package::Proxy');
my $RepositoryRoot = $Self->{ConfigObject}->Get('Package::RepositoryRoot') || [];

my @Tests = (
    {
        Name        => 'Test ' . $TestNumber++,
        URL         => "",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => '0',
        ErrorNumber => '400',
    },
    {
        Name        => 'Test ' . $TestNumber++,
        URL         => "wrongurl",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => '0',
        ErrorNumber => '400',
    },
    {
        Name        => 'Test ' . $TestNumber++,
        URL         => "http://novalidurl",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => '0',
        ErrorNumber => '500',
    },
    {
        Name        => 'Test ' . $TestNumber++,
        URL         => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout     => $TimeOut,
        Proxy       => 'http://NoProxy',
        Success     => '0',
        ErrorNumber => '500',
    },
    {
        Name        => 'Test ' . $TestNumber++,
        URL         => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout     => $TimeOut,
        Proxy       => 'http://NoProxy',
        Success     => '0',
        ErrorNumber => '500',
    },
    {
        Name        => 'Test ' . $TestNumber++,
        URL         => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout     => $TimeOut,
        Proxy       => 'ftp://NoProxy',
        Success     => '0',
        ErrorNumber => '400',
    },
    {
        Name    => 'Test ' . $TestNumber++,
        URL     => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout => '100',
        Proxy   => $Proxy,
        Success => '1',
    },
    {
        Name    => 'Test ' . $TestNumber++,
        URL     => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout => $TimeOut,
        Proxy   => $Proxy,
        Success => '1',
    },

);

# get repository list
for my $URL ( @{$RepositoryRoot} ) {

    my %NewEntry = (
        Name    => 'Test ' . $TestNumber++,
        URL     => $URL,
        Timeout => $TimeOut,
        Proxy   => $Proxy,
        Success => '1',
    );

    push @Tests, \%NewEntry;
}

for my $Test (@Tests) {

    my $WebUserAgentObject = Kernel::System::WebUserAgent->new(
        %{$Self},
        Timeout => $Test->{Timeout},
        Proxy   => $Test->{Proxy},
    );

    $Self->Is(
        ref $WebUserAgentObject,
        'Kernel::System::WebUserAgent',
        "$Test->{Name} - WebsUserAgent object creation",
    );

    $Self->True(
        1,
        "$Test->{Name} - Performing request",
    );

    my %Response = $WebUserAgentObject->Request(
        URL => $Test->{URL},
    );

    $Self->True(
        IsHashRefWithData( \%Response ),
        "$Test->{Name} - WebUserAgent check structure from request",
    );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Response{Content},
            "$Test->{Name} - WebUserAgent fail test for URL: $Test->{URL}",
        );
        $Self->Is(
            substr( $Response{Status}, 0, 3 ),
            $Test->{ErrorNumber},
            "$Test->{Name} - WebUserAgent - Check error number",
        );
        next;
    }
    else {
        $Self->True(
            $Response{Content},
            "$Test->{Name} - WebUserAgent - Success test for URL: $Test->{URL}",
        );
        $Self->Is(
            substr( $Response{Status}, 0, 3 ),
            '200',
            "$Test->{Name} - WebUserAgent - Check request status",
        );
    }
}

1;
