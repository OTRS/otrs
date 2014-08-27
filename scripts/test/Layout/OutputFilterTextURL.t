# --
# OutputFilterTextURL.t - tests to check correct transformations of URLs
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self %Param));

use Kernel::Output::HTML::Layout;
use Kernel::System::Web::Request;

my $ParamObject   = Kernel::System::Web::Request->new(
    WebRequest => $Param{WebRequest} || 0,
);

my $LayoutObject = Kernel::Output::HTML::Layout->new(
    UserChallengeToken => 'TestToken',
    UserID             => 1,
    Lang               => 'de',
    SessionID          => 123,
);

my @Tests = (
    {
        Name  => 'Simple URL',
        Input => 'http://www.url.com',
    },
    {
        Name  => 'URL with parameters',
        Input => 'http://www.url.com?parameter=test;parameter2=test2',
    },
    {
        Name  => 'URL with round brackets',
        Input => 'http://www.url.com/file(1)name/file(2)name',
    },

    # {
    #     Name     => 'URL with square brackets',
    #     Input    => 'http://www.url.com?host[0]=hostname;[1]',
    # },
);

for my $Test (@Tests) {

    my $Output = $LayoutObject->Ascii2Html(
        Text        => $Test->{Input},
        LinkFeature => 1,
    );

    $Self->Is(
        $Output,
        '<a href="'
            . $Test->{Input}
            . '" target="_blank" title="'
            . $Test->{Input} . '">'
            . $Test->{Input} . '</a>',
        $Test->{Name},
    );
}

1;
