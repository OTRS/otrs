# --
# AutoResponse.pm - sub module of Postmaster.pm
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AutoResponse.pm,v 1.4 2002-07-02 08:47:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::AutoResponse;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    $Self->{DBObject} = $Param{DBObject} || die 'Got no DBObject!';
    return $Self;
}
# --
sub GetResponseData {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID};
    my $Type = $Param{Type};
    my %Data;

    my $SQL = "SELECT ar.text0, sa.value0, sa.value1, ar.text1, ch.charset" .
	" FROM " .
	" auto_response_type art, auto_response ar, queue_auto_response qar, ".
    " system_address sa, charset ch " .
	" WHERE " .
	" qar.queue_id = $QueueID " .
	" AND " .
	" art.id = ar.type_id " .
    " AND " .
    " qar.auto_response_id = ar.id " .
	" AND " .
	" ar.system_address_id = sa.id" .
	" AND " .
    " ar.charset_id = ch.id ".
    " AND " .
	" art.name = '$Type'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{Text} = $RowTmp[0];
        $Data{Address} = $RowTmp[1];
        $Data{Realname} = $RowTmp[2]; 
        $Data{Subject} = $RowTmp[3];
        $Data{Charset} = $RowTmp[4];
    }
    return %Data;
}
# --

1;
