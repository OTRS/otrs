# --
# Kernel/System/Crypt.pm - the main crypt module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Crypt.pm,v 1.3 2004-08-13 05:42:54 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Crypt;

use strict;
use Kernel::System::FileTemp;

use vars qw($VERSION @ISA);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    # get needed opbjects
    foreach (qw(ConfigObject LogObject DBObject CryptType)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # check if module is enabled
    if (!$Self->ConfigObject}->Get($Param{CryptType})) {
        return;
    }

    # create file template object
    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    # load generator crypt module
    $Self->{GenericModule} = "Kernel::System::Crypt::$Param{CryptType}";
    if (!eval "require $Self->{GenericModule}") {
        die "Can't load crypt backend module $Self->{GenericModule}! $@";
    }
    # add generator crypt functions
    @ISA = ("$Self->{GenericModule}");
    # call init()
    $Self->Init();
    return $Self;
}

