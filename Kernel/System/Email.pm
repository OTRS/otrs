# --
# Kernel/System/Email.pm - the global email send module
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Email.pm,v 1.2 2003-06-01 19:20:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Email;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # debug level
    $Param{Debug} = 0;
    # check all needed objects
    foreach (qw(ConfigObject LogObject DBObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # load generator backend module
    my $GenericModule = $Self->{ConfigObject}->Get('SendmailModule')
      || 'Kernel::System::Email::Sendmail';
    if (!eval "require $GenericModule") {
        die "Can't load sendmail backend module $GenericModule! $@";
    }
    # create backend object
    $Self->{Backend} = $GenericModule->new(%Param);

    return $Self;
}
# --
sub Send {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Backend}->Send(%Param);
}
# --

1;
