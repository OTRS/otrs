# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

my $ErrorMessage = "Unable to check Perl modules.";
my $Home         = $Self->{ConfigObject}->Get('Home');
my $TmpSumString;

if ( open( $TmpSumString, "perl $Home/bin/otrs.CheckModules.pl |" ) ) {

    open( $TmpSumString, "perl $Home/bin/otrs.CheckModules.pl |" );

    while (<$TmpSumString>) {
        my $TmpLine = $_;
        $TmpLine =~ s/\n//g;
        if (
            $TmpLine =~ m{Not \s installed! (.+?) \(Required}smx
            || $TmpLine =~ m{Not \s supported}smx
            || $TmpLine =~ m{failed!}smx
            )
        {
            $Self->False(
                $TmpLine,
                "Error in your installed perl modules: $TmpLine",
            );
        }
        else {
            $Self->True(
                $TmpLine,
                "$TmpLine",
            );
        }
    }
    close($TmpSumString);

}
else {
    $Self->False(
        $ErrorMessage,
        $ErrorMessage,
    );
}

1;
