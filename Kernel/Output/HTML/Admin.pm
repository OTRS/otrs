# --
# HTML/Admin.pm - provides generic admin HTML output
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Admin.pm,v 1.1 2001-12-23 13:27:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Admin;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub AdminNavigationBar {
    my $Self = shift;
    my %Param = @_;

    # get output
    my $Output = $Self->Output(TemplateFile => 'AdminNavigationBar', Data => \%Param);

    # return output
    return $Output;
}
# --
sub ArticlePlain {
    my $Self = shift;
    my %Param = @_;

    # do some highlightings
    $Param{Text} =~ s/^((From|To|Cc|Subject|Reply-To|Organization|X-Company):.*)/<font color=\"red\">$1<\/font>/gm;
    $Param{Text} =~ s/^(Date:.*)/<FONT COLOR=777777>$1<\/font>/m;
    $Param{Text} =~ s/^((X-Mailer|User-Agent|X-OS):.*(Mozilla|Win?|Outlook|Microsoft|Internet Mail Service).*)/<blink>$1<\/blink>/gmi;
    $Param{Text} =~ s/(^|^<blink>)((X-Mailer|User-Agent|X-OS|X-Operating-System):.*)/<font color=\"blue\">$1$2<\/font>/gmi;
    $Param{Text} =~ s/^((Resent-.*):.*)/<font color=\"green\">$1<\/font>/gmi;
    $Param{Text} =~ s/^(From .*)/<font color=\"gray\">$1<\/font>/gm;
    $Param{Text} =~ s/^(X-OTRS.*)/<font color=\"#99BBDD\">$1<\/font>/gmi;

    # get output
    my $Output = $Self->Output(TemplateFile => 'AgentPlain', Data => \%Param);

    # return output
    return $Output;
}
# --
sub Note {
    my $Self = shift;
    my %Param = @_;

    # build ArticleTypeID string
    $Param{'NoteStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NoteTypes},
        Name => 'ArticleTypeID'
    );

    # get output
    my $Output = $Self->Output(TemplateFile => 'AgentNote', Data => \%Param);

    # return output
    return $Output;
}
# --
sub AgentPriority {
    my $Self = shift;
    my %Param = @_;

    # build ArticleTypeID string
    $Param{'OptionStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{OptionStrg},
        Name => 'PriorityID'
    );

    # get output
    my $Output = $Self->Output(TemplateFile => 'AgentPriority', Data => \%Param);

    # return output
    return $Output;
}
# --
sub AgentClose {
    my $Self = shift;
    my %Param = @_;

    # build string
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStatesStrg},
        Name => 'StateID'
    );

    # build string
    $Param{'NoteTypesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NoteTypesStrg},
        Name => 'NoteID'
    );


    # get output
    my $Output = $Self->Output(TemplateFile => 'AgentClose', Data => \%Param);

    # return output
    return $Output;
}
# --
sub AgentUtilForm {
    my $Self = shift;
    my %Param = @_;

    # get output
    my $Output = $Self->Output(TemplateFile => 'AgentUtilForm', Data => \%Param);

    # return output
    return $Output;
}
# --
sub AdminSessionTable {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';

    foreach (sort keys %Param) {
      if (($_) && ($Param{$_}) && $_ ne 'SessionID') {
        if ($_  eq 'UserSessionStart') {
          my $Age = int((time() - $Param{UserSessionStart}) / 3600);
          $Param{UserSessionStart} = scalar localtime ($Param{UserSessionStart});
          $Output .= "[ " . $_ . " = $Param{$_} / $Age h ] <BR>\n";
        }
        else {
          $Output .= "[ " . $_ . " = $Param{$_} ] <BR>\n";
        }
      }
    }

    $Param{Output} = $Output;
    # get output
    $Output = $Self->Output(TemplateFile => 'AdminSessionTable', Data => \%Param);

    return $Output;
}
# --
sub AdminSelectBoxForm {
    my $Self = shift;
    my %Param = @_;

    my $Output = $Self->Output(TemplateFile => 'AdminSelectBoxForm', Data => \%Param);

    return $Output;
} 
# --
sub AdminSelectBoxResult {
    my $Self = shift;
    my %Param = @_;
    my $DataTmp = $Param{Data};
    my @Datas = @$DataTmp;
    my $Output = '';
    foreach my $Data ( @Datas ) {
        $Output .= '<table cellspacing="0" cellpadding="3" border="0">';
        foreach (sort keys %$Data) {
            $$Data{$_} = $Self->Ascii2Html(Text => $$Data{$_}, Max => 200);
            $$Data{$_} = '<i>undef</i>' if (! defined $$Data{$_});
            $Output .= "<tr><td>$_:</td><td> = </td><td>$$Data{$_}</td></tr>\n";
        }
        $Output .= '</table>';
        $Output .= '<hr>';
   }

    $Param{Result} = $Output;
    # get output
    $Output = $Self->Output(TemplateFile => 'AdminSelectBoxResult', Data => \%Param);

    return $Output;
}
# --

1;
 
