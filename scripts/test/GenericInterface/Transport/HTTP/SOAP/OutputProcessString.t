# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;

use vars (qw($Self));

use Kernel::GenericInterface::Debugger;
use Kernel::GenericInterface::Transport::HTTP::SOAP;

my $DebuggerObject = Kernel::GenericInterface::Debugger->new(
    DebuggerConfig => {
        DebugThreshold => 'error',
        TestMode       => 1,
    },
    CommunicationType => 'requester',
    WebserviceID      => 1,             # not used
);
my $SOAPObject = Kernel::GenericInterface::Transport::HTTP::SOAP->new(
    DebuggerObject  => $DebuggerObject,
    TransportConfig => {
        Config => {
            MaxLength            => 100000000,
            NameSpace            => 'http://www.otrs.org/TicketConnector/',
            RequestNameFreeText  => '',
            RequestNameScheme    => 'Plain',
            ResponseNameFreeText => '',
            ResponseNameScheme   => 'Response;'
        },
        Type => 'HTTP::SOAP',
    },
);

my @Tests = (
    {
        Name   => "Basic Chars '<' '&'",
        Config => {
            Data => 'a <string> & more',
        },
        ExpectedResult => 'a &lt;string&gt; &amp; more',
    },
    {
        Name   => "String With CDATA",
        Config => {
            Data => '<![CDATA[Test]]>',
        },
        ExpectedResult => '&lt;![CDATA[Test]]&gt;',
    },
    {
        Name   => "String With ']]>'",
        Config => {
            Data =>
                '<[[https://info.microsoft.com/WE-Azure-WBNR-FY17-09Sep-08-Barracuda-ISV-Webinar-244253_Registration.html?ls=Email]]>',
        },
        ExpectedResult =>
            '&lt;[[https://info.microsoft.com/WE-Azure-WBNR-FY17-09Sep-08-Barracuda-ISV-Webinar-244253_Registration.html?ls=Email]]&gt;',
    },
    {
        Name   => "String Control characters'",
        Config => {
            Data => "Test1\x{03} Test2\x{08} Test3\x{0C}",
        },
        ExpectedResult => "Test1 Test2 Test3",
    },

);

for my $Test (@Tests) {

    my $Result = $SOAPObject->_SOAPOutputProcessString( %{ $Test->{Config} } );

    $Self->Is(
        $Result,
        $Test->{ExpectedResult},
        "$Test->{Name} Result value",
    );
}

1;
