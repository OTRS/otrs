# --
# Language.pm - provides multi language support
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Language.pm,v 1.6 2002-05-09 23:41:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language;

use strict;
use lib '../';
# --
# Note: If you want to add new translation files, you juast have to
# ass the module in the next line. 
# --
use Kernel::Language::German;
use Kernel::Language::English;
use Kernel::Language::French;
use Kernel::Language::Bavarian;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # get Log Object
    $Self->{LogObject} = $Param{LogObject} || die "Got no LogObject!";

    # 0=off; 1=on; 2=get all not translated words; 3=get all requests
    $Self->{Debug} = 0;

    # user language
    $Self->{Language} = $Param{Language} || 'English';

    # Debug
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'Debug',
          MSG => "UserLanguage = $Self->{Language}",
        );
    }

    # load text catalog ...
    if (eval '$Kernel::Language::'.$Self->{Language}.'::VERSION') {
        @ISA = ("Kernel::Language::$Self->{Language}");
        $Self->Data();
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'Debug',
                MSG => "Kernel::Language::$Self->{Language} load ... done."
            );
        }
    }
    # if there is no translation
    else {
        $Self->{LogObject}->Log(
          Priority => 'Error',
          MSG => "Sorry, can't locate Kernel::Language::$Self->{Language} translation!",
        );
    }

    return $Self;
}
# --
sub Get {
    my $Self = shift;
    my $What = shift;

    # check wanted param and returns the 
    # lookup or the english data
    if (exists $Self->{$What}) {
        # Debug
        if ($Self->{Debug} > 3) {
            $Self->{LogObject}->Log(
              Priority => 'Debug',
              MSG => "->Get('$What') = ('$Self->{$What}').",
            );
        }
        return $Self->{$What};
    }
    else {
        # warn if the value is not def
        if ($Self->{Debug} > 1) {
          $Self->{LogObject}->Log(
            Priority => 'error',
            MSG => "->Get('$What') Is not translated!!!",
          );
        }
        return $What;
    }
}
# --

1;

