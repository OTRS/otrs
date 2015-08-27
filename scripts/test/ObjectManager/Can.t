# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars (qw($Self));

use Kernel::System::ObjectManager;

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Stats' => {
        UserID => 1,
    },
    'Kernel::System::PostMaster' => {
        Email => [],
    },
);

$Self->True( $Kernel::OM, 'Could build object manager' );

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $SkipCryptSMIME;
if ( !$ConfigObject->Get('SMIME') ) {
    $SkipCryptSMIME = 1;
}

my $SkipCryptPGP;
if ( !$ConfigObject->Get('PGP') ) {
    $SkipCryptPGP = 1;
}

my $SkipChat;
if ( !$ConfigObject->Get('ChatEngine::Active') ) {
    $SkipChat = 1;
}

my $Home = $ConfigObject->Get('Home');

# get main object
my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my %OperationChecked;

my @DirectoriesToSearch = (
    '/bin',
    '/Custom/Kernel/Output',
    '/Custom/Kernel/System',
    '/Kernel/GenericInterface',
    '/Kernel/Output',
    '/Kernel/System',
    '/var/packagesetup'
);

for my $Directory ( sort @DirectoriesToSearch ) {
    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Home . $Directory,
        Filter    => [ '*.pm', '*.pl' ],
        Recursive => 1,
    );

    LOCATION:
    for my $Location (@FilesInDirectory) {
        my $ContentSCALARRef = $MainObject->FileRead(
            Location => $Location,
        );

        my $Module = $Location;
        $Module =~ s{$Home\/+}{}msx;

        # check if file contains a call to another module using Object manager
        #    for example: $Kernel::OM->Get('Kernel::Config')->Get('Home');
        #    the regular expression will match until $Kernel::OM->Get('Kernel::Config')->Get(
        #    including possible line returns
        #    for this example:
        #    $1 will contain Kernel::Config
        #    $2 will contain Get
        OPERATION:
        while (
            ${$ContentSCALARRef}
            =~ m{ \$Kernel::OM \s* -> \s* Get\( \s* '([^']+)'\) \s* -> \s* ([a-zA-Z1-9]+)\( }msxg
            )
        {

            # skip if the function for the object was already checked before
            next OPERATION if $OperationChecked{"$1->$2()"};

            # skip crypt object if it is not configured
            next OPERATION if $1 eq 'Kernel::System::Crypt::SMIME' && $SkipCryptSMIME;
            next OPERATION if $1 eq 'Kernel::System::Crypt::PGP'   && $SkipCryptPGP;
            next OPERATION if $1 eq 'Kernel::System::Chat'         && $SkipChat;
            next OPERATION if $1 eq 'Kernel::System::ChatChannel'  && $SkipChat;

            # load object
            my $Object = $Kernel::OM->Get("$1");

            my $Success = $Object->can($2);

            $Self->True(
                $Success,
                "$Module | $1->$2()",
            );

            # remember the already checked  operation
            $OperationChecked{"$1->$2()"} = 1;
        }
    }
}

1;
