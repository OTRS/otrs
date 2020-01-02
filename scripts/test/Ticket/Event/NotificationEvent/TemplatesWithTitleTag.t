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

use File::Basename qw( basename );
use Kernel::System::MailQueue;

use vars (qw($Self));

# This test ensures that the notification-event templates
# don't have the html tag 'title'.

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

my $TemplatesFolder = $ConfigObject->Get('Home')
    . '/Kernel/Output/HTML/Templates/Standard/NotificationEvent/Email';
my @Templates = glob $TemplatesFolder . '/*.tt';

for my $Template (@Templates) {
    my $Contents = ${
        $MainObject->FileRead(
            Location => $Template,
        )
    };
    my $TagFound = $Contents =~ /<title>.*<\/title>/is;
    $Self->False(
        $TagFound,
        sprintf( 'NotificationEvent Template "%s" with no title tag.', basename($Template) ),
    );
}

1;
