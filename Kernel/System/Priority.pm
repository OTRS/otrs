# --
# Kernel/System/Priority.pm - All priority related function should be here eventually
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Priority.pm,v 1.1 2004-04-20 09:30:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Priority;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
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

    return $Self;
}
# --
sub PriorityList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID} && !$Param{CustomerUserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "UserID or CustomerUserID!");
        return;
    }
    # check cache
    if ($Self->{PriorityList}) {
        return %{$Self->{PriorityList}};
    } 
    # sql 
    my %Data = ();
    if ($Self->{DBObject}->Prepare(SQL => 'SELECT id, name FROM ticket_priority')) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{$Row[0]} = $Row[1];
        }
    }
    # cache result
    $Self->{PriorityList} = \%Data;
    return %Data;
}
# --

1;
