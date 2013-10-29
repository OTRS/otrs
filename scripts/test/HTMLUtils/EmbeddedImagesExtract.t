# --
# EmbeddedImagesExtract.t - HTMLUtils tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::HTMLUtils;

my $HTMLUtilsObject = Kernel::System::HTMLUtils->new( %{$Self} );
#
# EmbeddedImagesExtract()
#
my $InlineImage
    = '<img alt="text" src="data:image/gif;base64,R0lGODlhAQABAJH/AP///wAAAP///wAAACH/C0FET0JFOklSMS4wAt7tACH5BAEAAAIALAAAAAABAAEAAAICVAEAOw==" />';
my @Tests = (
    {
        Name   => 'no image',
        Body   => '',
        Result => {
            Success     => 1,
            Body        => qr|^$|,
            Attachments => [],
            }
    },
    {
        Name   => 'no body',
        Body   => undef,
        Result => {
            Success => 0,
            }
    },
    {
        Name   => 'single image',
        Body   => "$InlineImage",
        Result => {
            Success     => 1,
            Body        => qr|^<img alt="text" src="cid:.*?" />$|,
            Attachments => [
                {
                    ContentType => qr|^image/gif;|,
                }
            ],
            }
    },
    {
        Name   => 'two images',
        Body   => "123 $InlineImage 456 $InlineImage 789",
        Result => {
            Success => 1,
            Body =>
                qr|^123 <img alt="text" src="cid:.*?" /> 456 <img alt="text" src="cid:.*?" /> 789$|,
            Attachments => [
                {
                    ContentType => qr|^image/gif;|,
                },
                {
                    ContentType => qr|^image/gif;|,
                }
            ],
            }
    },
    {
        Name   => 'two images, only one embedded',
        Body   => "123 $InlineImage 456 <img src=\"http://some.url/image.gif\" /> 789",
        Result => {
            Success => 1,
            Body =>
                qr|^123 <img alt="text" src="cid:.*?" /> 456 <img src=\"http://some.url/image.gif\" /> 789$|,
            Attachments => [
                {
                    ContentType => qr|^image/gif;|,
                },
            ],
            }
    },
    {
        Name => 'Win7 snipping tool',
        Body =>
            'Snipping Tool: <img alt="" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQIAAADJCAIAAABHdavEAAAgAElEQVR4nOx9d1gUWfZ27e63O0rnUJ2ISs5BRTFhzjo65uyYc4bOIFEUM9nsmHPOihkxkaGBJphQQM="> 456',
        Result => {
            Success => 1,
            Body =>
                qr|^Snipping Tool: <img alt="" src="cid:.*?"> 456$|,
            Attachments => [
                {
                    ContentType => qr|^image/png;|,
                },
            ],
            }
    },
);

TEST:
for my $Test (@Tests) {
    my $Body = $Test->{Body};
    my @Attachments;
    my $Success = $HTMLUtilsObject->EmbeddedImagesExtract(
        DocumentRef    => \$Body,
        AttachmentsRef => \@Attachments,
    );

    $Self->Is(
        $Success ? 1 : 0,
        $Test->{Result}->{Success},
        "$Test->{Name} success",
    );

    next TEST if !$Success;

    $Self->True(
        scalar $Body =~ ( $Test->{Result}->{Body} ),
        "$Test->{Name} body after image extraction (body: $Body, check: $Test->{Result}->{Body})",
    );

    $Self->Is(
        scalar @Attachments,
        scalar @{ $Test->{Result}->{Attachments} },
        "$Test->{Name} number of attachments",
    );

    my $Index = 0;
    for my $Attachment (@Attachments) {

        $Self->True(
            scalar $Attachment->{ContentType}
                =~ ( $Test->{Result}->{Attachments}->[$Index]->{ContentType} ),
            "$Test->{Name} content type of attachment $Index (content type: $Attachment->{ContentType}, check: $Test->{Result}->{Attachments}->[$Index]->{ContentType})",
        );
        $Self->True(
            scalar $Attachment->{Content},
            "$Test->{Name} content of attachment $Index is not empty",
        );

        $Index++;
    }
}

1;
