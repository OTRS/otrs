# --
# WebUserAgent.t - Authentication tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
        Name        => 'GET - empty url - Test ' . $TestNumber++,
        URL         => "",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => '0',
        ErrorNumber => '400',
    },
    {
        Name        => 'GET - wrong url - Test ' . $TestNumber++,
        URL         => "wrongurl",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => '0',
        ErrorNumber => '400',
    },
    {
        Name        => 'GET - invalid url - Test ' . $TestNumber++,
        URL         => "http://novalidurl",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => '0',
        ErrorNumber => '500',
    },
    {
        Name        => 'GET - http - invalid proxy - Test ' . $TestNumber++,
        URL         => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout     => $TimeOut,
        Proxy       => 'http://NoProxy',
        Success     => '0',
        ErrorNumber => '500',
    },
    {
        Name        => 'GET - http - ftp proxy - Test ' . $TestNumber++,
        URL         => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout     => $TimeOut,
        Proxy       => 'ftp://NoProxy',
        Success     => '0',
        ErrorNumber => '400',
    },
    {
        Name    => 'GET - http - long timeout - Test ' . $TestNumber++,
        URL     => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout => '100',
        Proxy   => $Proxy,
        Success => '1',
    },
    {
        Name    => 'GET - http - Test ' . $TestNumber++,
        URL     => "http://ftp.otrs.org/pub/otrs/packages/otrs.xml",
        Timeout => $TimeOut,
        Proxy   => $Proxy,
        Success => '1',
    },
    {
        Name    => 'GET - https - Test ' . $TestNumber++,
        URL     => "https://portal.otrs.com/",
        Timeout => $TimeOut,
        Proxy   => $Proxy,
        Success => '1',
    },
    {
        Name => 'POST - hashref - Test ' . $TestNumber++,
        URL  => "https://pav.otrs.com/otrs/public.pl",
        Type => "POST",
        Data => {
            'Action'  => 'PublicPackageVerification',
            'Package' => 'Test::9fa881ef2e2cdafecd06fa689ca2044e',
        },
        Timeout => $TimeOut,
        Proxy   => $Proxy,
        Success => '1',
        Content => '{"Test":"not_verified"}',
    },
    {
        Name => 'POST - arrayref - Test ' . $TestNumber++,
        URL  => "https://pav.otrs.com/otrs/public.pl",
        Type => "POST",
        Data => [
            'Action'  => 'PublicPackageVerification',
            'Package' => 'Test::9fa881ef2e2cdafecd06fa689ca2044e',
        ],
        Timeout => $TimeOut,
        Proxy   => $Proxy,
        Success => '1',
        Content => '{"Test":"not_verified"}',
    },
    {
        Name        => 'POST - data but no arrayref or hashref - Test ' . $TestNumber++,
        URL         => "https://pav.otrs.com/otrs/public.pl",
        Type        => "POST",
        Data        => 'SomeData',
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => 0,
        ErrorNumber => 0,
    },
    {
        Name        => 'POST - no data - Test ' . $TestNumber++,
        URL         => "https://pav.otrs.com/otrs/public.pl",
        Type        => "POST",
        Timeout     => $TimeOut,
        Proxy       => $Proxy,
        Success     => 0,
        ErrorNumber => 0,
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
        "$Test->{Name} - WebUserAgent object creation",
    );

    $Self->True(
        1,
        "$Test->{Name} - Performing request",
    );

    my %Response = $WebUserAgentObject->Request(
        URL  => $Test->{URL},
        Type => $Test->{Type},
        Data => $Test->{Data},
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
    if ( $Test->{Content} ) {
        $Self->Is(
            ${ $Response{Content} },
            $Test->{Content},
            "$Test->{Name} - WebUserAgent - Check request content",
        );
    }
}

1;
