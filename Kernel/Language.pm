# --
# Language.pm - provides multi language support
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Language.pm,v 1.2 2001-12-21 17:49:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language;

use strict;
use lib '../';
use Kernel::Language::German;
use Kernel::Language::English;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.2 $';
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
    $Self->{DEBUG} = 0;

    # integrated languages
    my @Languages = ('German', 'English');

    # user language
    $Self->{Language} = $Param{Language} || 'German';

    # debug
    if ($Self->{DEBUG} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'debug',
          MSG => "UserLanguage = $Self->{Language}",
        );
    }

    # load text catalog ...
    foreach (@Languages) {
        if ($_ eq $Self->{Language}) {
            @ISA = ("Kernel::Language::$_");
            $Self->Data();
            if ($Self->{DEBUG} > 0) {
                $Self->{LogObject}->Log(
                  Priority => 'debug',
                  MSG => "Kernel::Language::$_ load ... done."
                );
            }
        }
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
        # debug
        if ($Self->{DEBUG} > 3) {
            $Self->{LogObject}->Log(
              Priority => 'debug',
              MSG => "->Get('$What') = ('$Self->{$What}').",
            );
        }
        return $Self->{$What};
    }
    else {
        # warn if the value is not def
        if ($Self->{DEBUG} > 1) {
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

