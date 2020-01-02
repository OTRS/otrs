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

use LWP::UserAgent;

use Kernel::System::UnitTest::Helper;

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $JSONObject   = $Kernel::OM->Get('Kernel::System::JSON');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        SkipSSLVerify => 1
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TestUserLogin         = $Helper->TestUserCreate();
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

my $BaseURL = $ConfigObject->Get('HttpType') . '://';

$BaseURL .= $Helper->GetTestHTTPHostname() . '/';
$BaseURL .= $ConfigObject->Get('ScriptAlias') . 'index.pl?';

my $UserAgent = LWP::UserAgent->new(
    Timeout => 60,
);
$UserAgent->cookie_jar( {} );    # keep cookies

my $Response = $UserAgent->get(
    $BaseURL . "Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
);
if ( !$Response->is_success() ) {
    $Self->True(
        0,
        "Could not login to agent interface, aborting! URL: ${BaseURL}Action=Login;User=$TestUserLogin;Password=$TestUserLogin;"
    );
    return 1;
}

my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');
my $FormID            = $UploadCacheObject->FormIDCreate();

my $CheckUpload = sub {
    my %Param = @_;

    $Self->Is(
        $Response->code(),
        200,
        "Response status is successful",
    );

    my $Method = $Param{Successful} ? 'True' : 'False';

    $Self->$Method(
        scalar $Response->content() =~ m{Action=PictureUpload},
        "Response check for link to uploaded image",
    );

    if ( $Param{Successful} ) {
        my ($ContentID) = $Response->content() =~ m{ContentID=(.*)"};

        $Response = $UserAgent->get("${BaseURL}Action=PictureUpload;FormID=$FormID;ContentID=$ContentID");

        $Self->Is(
            $Response->content(),
            $Param{Content},
            'Response content',
        );

        $Self->Is(
            substr( $Response->header('Content-Type'), 0, 6 ),
            'image/',
            'Response content type',
        );
    }
};

# Upload image correctly and verify it.
$Response = $UserAgent->post(
    $BaseURL,
    Content_Type => 'form-data',
    Content      => {
        Action => 'PictureUpload',
        FormID => $FormID,
        upload => [
            undef, 'index1.png',
            'Content-Type' => 'image/png',
            Content        => '123'
        ],
    }
);

$CheckUpload->(
    Successful => 1,
    Content    => '123'
);

# Upload image with wrong content-type, must fail.
$Response = $UserAgent->post(
    $BaseURL,
    Content_Type => 'form-data',
    Content      => {
        Action => 'PictureUpload',
        FormID => $FormID,
        upload => [
            undef, 'index2.png',
            'Content-Type' => 'text/html',
            Content        => '123'
        ],
    }
);

$CheckUpload->( Successful => 0 );

# Store image with wrong content-type and verify that it is not served by the application.
my $ContentID = 'inline695415.287823406.1544532925.8063442.1111111111@unittest.local';
$UploadCacheObject->FormIDAddFile(
    FormID      => $FormID,
    Filename    => 'index3.png',
    Content     => '123',
    ContentID   => $ContentID,
    ContentType => 'text/html',
    Disposition => 'inline',       # optional
);

$Response = $UserAgent->get("${BaseURL}Action=PictureUpload;FormID=$FormID;ContentID=$ContentID");
$Self->True(
    index(
        $Response->content(),
        q|CKEDITOR.tools.callFunction(0, '', "The file is not an image that can be shown inline!"|
    ) > -1,
    'Response check for CKEditor error handler',
);

## nofilter(TidyAll::Plugin::OTRS::Whitespace::Tabs)
my $ContentSVG = <<'EOF',
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg">
<polygon id="triangle" points="0,0 0,50 50,0" fill="#009900" stroke="#004400"/>
<script type="text/javascript">alert(document.domain);</script></svg>
EOF
    ;

my $EscapedContentSVG = <<'EOF',
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">

<svg version="1.1" baseProfile="full" xmlns="http://www.w3.org/2000/svg">
<polygon id="triangle" points="0,0 0,50 50,0" fill="#009900" stroke="#004400"/>
</svg>
EOF
    ;

# Upload svg image with png file and script element.
$Response = $UserAgent->post(
    $BaseURL,
    Content_Type => 'form-data',
    Content      => {
        Action => 'PictureUpload',
        FormID => $FormID,
        upload => [
            undef, 'index4.png',
            'Content-Type' => 'image/svg+xml',
            Content        => $ContentSVG,
        ],
    }
);

$CheckUpload->(
    Successful => 1,
    Content    => $EscapedContentSVG,
);

1;
