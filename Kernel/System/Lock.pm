# --
# Kernel/System/Lock.pm - All Groups related function should be here eventually
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Lock.pm,v 1.2 2004-02-13 00:50:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Lock;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # get ViewableLocks
    $Self->{ViewableLocks} = $Self->{ConfigObject}->Get('ViewableLocks')
           || die 'No Config entry "ViewableLocks"!';

    return $Self;
}
# --
sub LockViewableLock {
    my $Self = shift;
    my %Param = @_;
    my @Name = ();
    my @ID = ();
    # check needed stuff
    foreach (qw(Type)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql 
    my $SQL = "SELECT id, name ".
        " FROM ".
        " ticket_lock_type ".
        " WHERE ".
        " name in ( ${\(join ', ', @{$Self->{ViewableLocks}})} ) " .
        " AND ".
        " valid_id in ( ${\(join ', ', $Self->{DBObject}->GetValidIDs())} )";
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Data = $Self->{DBObject}->FetchrowArray()) {
            push (@Name, $Data[1]);
            push (@ID, $Data[0]);
        }
        if ($Param{Type} eq 'Name') {
            return @Name;
        }
        else {
            return @ID;
        }
    }
}
# --

1;
