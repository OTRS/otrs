# --
# Kernel/Modules/AdminLog.pm - provides a log view for admins
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminLog.pm,v 1.6 2003-07-08 00:01:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminLog;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # --
    # print form
    # --
    my $Output = $Self->{LayoutObject}->Header(Title => 'System Log');
    $Output .= $Self->{LayoutObject}->AdminNavigationBar();
    my $LogData = $Self->{LogObject}->GetLog(Limit => 400);
    $Output .= $Self->MaskLog(Log => $LogData);
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}
# --
sub MaskLog {
    my $Self = shift;
    my %Param = @_;
    # create table
    $Param{LogTable} = '<table border="0" width="100%">';
    $Param{LogTable} .= '<tr><th width="20%">$Text{"Time"}</th><th>$Text{"Priority"}</th><th>$Text{"Facility"}</th><th width="55%">$Text{"Message"}</th></tr>';
    my @Lines = split(/\n/, $Param{Log});
    foreach (@Lines) {
        my @Row = split(/;;/, $_);
        if ($Row[5]) {
            $Row[2] = $Self->{LayoutObject}->Ascii2Html(Text => $Row[2], Max => 20);
            $Row[3] = $Self->{LayoutObject}->Ascii2Html(Text => $Row[3], Max => 25);
            $Row[5] = $Self->{LayoutObject}->Ascii2Html(Text => $Row[5], Max => 500);
            if ($Row[1] =~ /error/) {
                $Param{LogTable} .= "<tr><td><font color='red'>$Row[0]</font></td><td align='center'><font color='red'>$Row[1]</font></td><td><font color='red'>$Row[2]</font></td><td><font color='red'>$Row[5]</font></td></tr>";
            }
            else {
                $Param{LogTable} .= "<tr><td>$Row[0]</td><td align='center'>$Row[1]</td><td>$Row[2]</td><td>$Row[5]</td></tr>";
            }
        }
    }
    $Param{LogTable} .= '</table>';
    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminLog', 
        Data => \%Param,
    );
}
# --
1;
