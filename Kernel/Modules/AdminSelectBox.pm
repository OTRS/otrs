# --
# Kernel/Modules/AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminSelectBox.pm,v 1.7 2003-07-08 00:01:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
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
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Subaction = $Self->{Subaction}; 
    # --
    # print form
    # --
    if ($Subaction eq '' || !$Subaction) {
        my $Output = $Self->{LayoutObject}->Header(Title => 'Select box');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->MaskSelectBoxForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # do select
    # --
    elsif ($Subaction eq 'Select') {
        my $SQL = $Self->{ParamObject}->GetParam(Param => 'SQL') || '';
        my $Max = $Self->{ParamObject}->GetParam(Param => 'Max') || '';
        my $Output = $Self->{LayoutObject}->Header(Title => 'Select box');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        if ($Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Max)) {
          my @Data = ();
          while (my $Row = $Self->{DBObject}->FetchrowHashref() ){
             push (@Data, $Row);
          }
          $Output .= $Self->MaskSelectBoxResult(
            Data => \@Data, 
            SQL => $SQL, 
            Limit => $Max,
          );
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
       }
       else {
         my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
         $Output .= $Self->{LayoutObject}->AdminNavigationBar();
         $Output .= $Self->{LayoutObject}->Error();
         $Output .= $Self->{LayoutObject}->Footer();
         return $Output;
       }
    } 
    # else! error!
    else {
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No Subaction!!',
                Comment => 'Please contact your admin');
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub MaskSelectBoxForm {
    my $Self = shift;
    my %Param = @_;
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminSelectBoxForm', 
        Data => \%Param,
    );
}
# --
sub MaskSelectBoxResult {
    my $Self = shift;
    my %Param = @_;
    my $DataTmp = $Param{Data};
    my @Datas = @$DataTmp;
    my $Output = '';
    foreach my $Data ( @Datas ) {
        $Output .= '<table cellspacing="0" cellpadding="3" border="0">';
        foreach (sort keys %$Data) {
            $$Data{$_} = $Self->{LayoutObject}->Ascii2Html(
                Text => $$Data{$_}, 
                Max => 200,
            );
            $$Data{$_} = '<i>undef</i>' if (! defined $$Data{$_});
            $Output .= "<tr><td>$_:</td><td> = </td><td>$$Data{$_}</td></tr>\n";
        }
        $Output .= '</table>';
        $Output .= '<hr>';
   }

    $Param{Result} = $Output;
    # get output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminSelectBoxResult', 
        Data => \%Param,
    );
}
# --
1;
