# --
# Kernel/System/Priority.pm - All priority related function should be here eventually
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Priority.pm,v 1.5 2007-01-20 23:11:34 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Priority;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Priority - priority lib

=head1 SYNOPSIS

All priority functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::DB;
    use Kernel::System::Priority;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $PriorityObject = Kernel::System::Priority->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        DBObject => $DBObject,
    );

=cut

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

=item PriorityList()

return a priority list as hash

    my %List = $PriorityObject->PriorityList(
        UserID => 123,
    );

    my %List = $PriorityObject->PriorityList(
        CustomerUserID => 'SomeCustomer',
    );

=cut

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

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.5 $ $Date: 2007-01-20 23:11:34 $

=cut