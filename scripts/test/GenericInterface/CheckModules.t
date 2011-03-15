# --
# CheckModules.t - GenericInterface CheckModules tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: CheckModules.t,v 1.1 2011-03-15 18:27:51 cg Exp $
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
    my $TmpLog;
    open( $TmpSumString, "perl $Home/bin/otrs.CheckModules.pl |" );

    while (<$TmpSumString>) {
        my $TmpLine = $_;
        $TmpLog .= $TmpLine;
        if (
            $TmpLine =~ m{Not \s installed! }smx
            || $TmpLine =~ m{failed!}smx
            )
        {
            $TmpLine =~ s/\n//g;
            $Self->False(
                $TmpLine,
                "Error in your installed perl modules: $TmpLine",
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
