# --
# HTML/Generic.pm - provides generic HTML output
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Generic.pm,v 1.1 2001-12-05 19:01:50 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Generic;

use strict;
use MIME::Words qw(:all);
use Kernel::Language;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    $Self->{FileHandle} = 'index.pl';
    $Self->{ImagePath} = '/images';
    $Self->{SessionID} = $Param{SessionID};
#    $Self->{Baselink}  = "$Self->{FileHandle}?SessionID=$Self->{SessionID}";
    $Self->{Time}      = localtime();
    $Self->{Title}     = 'Open Ticket Request System' . ' - ' . $Self->{Time};
    $Self->{TableTitle}= 'OpenTRS - Open Ticket Request System';
    $Self->{HistoryCounter} = 0;

    # load theme
    my $Theme = $Self->{UserTheme} || 'Standard';

    # locate template files
    $Self->{TemplateDir} = '/home/martin/src/otrs/Kernel/Output/HTML/'. $Theme;

    # get log object
    $Self->{LogObject} = $Param{LogObject} || die "Got no LogObject!";

    # get config object
    $Self->{ConfigObject} = $Param{ConfigObject} || die "Got no Config!";

    # create language object
    $Self->{LanguageObject} = Kernel::Language->new(
      Language => $Self->{UserLanguage},
      LogObject => $Self->{LogObject},
    );

    return $Self;
}
# --
sub Output {
    my $Self = shift;
    my %Param = @_;
    my %Data = ();
    my %Env = %ENV;
    $Env{SessionID} = $Self->{SessionID};
    $Env{Time} = $Self->{Time};
    my $Output = '';
    open (IN, "< $Self->{TemplateDir}/$Param{TemplateFile}")  
         ||  die "Can't read $Param{TemplateFile}: $!";
    while (<IN>) {
        $Output .= $_;

    }


    # text translation
    $Output =~ s{
        \$Text{"(.*)"}         # find a TEXT sign
    }
    {
        $Self->{LanguageObject}->Get($1)   # do translation
    }egx;


    # config replacement
    $Output =~ s{
        \$Config{"(.*)"}         # find a TEXT sign
    }
    {
        $Self->{ConfigObject}->Get($1)   # replace with
    }egx;


    # variable replace
    $Output =~ s{
        \$Data{"(.*)"}
    }
    {
        if ($Data{$1}) {
            $Data{$1};
        }
        else {
            "<i>\$$1 isn't true!</i>";
        }
    }egx;


    # env replace
    $Output =~ s{
        \$Env{"(.*)"}
    }
    {
        if ($Env{$1}) {
            $Env{$1};
        }
        else {
            "<i>\$$1 isn't true!</i>";
        }
    }egx;


    # return output
    return $Output;
}
# --
sub Test {
    my $Self = shift;
    my %Param = @_;

    my $Output = $Self->Output(TemplateFile => 'head.tmpl');

    # return output
    return $Output;

}
# --

1;
 
