# --
# Kernel/Output/HTML/Generic.pm - provides generic HTML output
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Generic.pm,v 1.71 2003-01-19 18:27:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Generic;

use lib "../../";

use strict;
use Kernel::Language;
use Kernel::Output::HTML::Agent;
use Kernel::Output::HTML::Admin;
use Kernel::Output::HTML::Installer;
use Kernel::Output::HTML::System;
use Kernel::Output::HTML::Customer;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.71 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

@ISA = (
    'Kernel::Output::HTML::Agent',
    'Kernel::Output::HTML::Admin',
    'Kernel::Output::HTML::Installer',
    'Kernel::Output::HTML::System',
    'Kernel::Output::HTML::Customer',
);

sub new {
    my $Type = shift;
    my %Param = @_;

    # --
    # allocate new hash for object
    # --
    my $Self = {}; 
    bless ($Self, $Type);
    # --
    # get common objects 
    # --
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # --
    # check needed objects
    # --
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_!" if (!$Self->{$_});
    } 

    # --
    # get use language (from browser) if no language is there!
    # --
    if (!$Self->{UserLanguage}) { 
        my $BrowserLang = $Self->{Lang} || $ENV{HTTP_ACCEPT_LANGUAGE} || '';
        my %Data = %{$Self->{ConfigObject}->Get('DefaultUsedLanguages')}; 
        foreach (keys %Data) {
            if ($BrowserLang =~ /^$_/i) {
                $Self->{UserLanguage} = $_;
            }
        }
    }
    # --
    # create language object
    # --
    $Self->{LanguageObject} = Kernel::Language->new(
        UserLanguage => $Self->{UserLanguage},
        LogObject => $Self->{LogObject},
        ConfigObject => $Self->{ConfigObject},
    );
    # --
    # get/set some common params
    # --
    if (!$Self->{UserTheme}) {
        $Self->{UserTheme} = $Self->{ConfigObject}->Get('DefaultTheme');
    }
    # --
    # set charset if there is no charset given
    # --
    if (!$Self->{UserCharset}) {
        $Self->{UserCharset} = $Self->{LanguageObject}->GetRecommendedCharset();
    }

    $Self->{Charset}   = $Self->{UserCharset}; # just for compat.
    $Self->{SessionID} = $Param{SessionID} || '';
    $Self->{SessionName} = $Param{SessionName} || 'SessionID';
    $Self->{CGIHandle} = $ENV{'SCRIPT_NAME'} || 'No-$ENV{"SCRIPT_NAME"}';
    # --
    # Baselink 
    # --
    $Self->{Baselink}  = "$Self->{CGIHandle}?";
    $Self->{Time}      = $Self->{LanguageObject}->Time(
        Action => 'GET', 
        Format => 'DateFormat',
    );
    $Self->{TimeLong}      = $Self->{LanguageObject}->Time(
        Action => 'GET', 
        Format => 'DateFormatLong',
    );
    $Self->{HighlightAge1} = $Self->{ConfigObject}->Get('HighlightAge1');
    $Self->{HighlightAge2} = $Self->{ConfigObject}->Get('HighlightAge2');
    $Self->{HighlightColor1} = $Self->{ConfigObject}->Get('HighlightColor1');
    $Self->{HighlightColor2} = $Self->{ConfigObject}->Get('HighlightColor2');
    # --
    # check browser (defaut is IE because I don't have IE)
    # --
    $Self->{BrowserWrap} = 'physical';
    $Self->{Browser} = 'Unknown';
    if (!$ENV{'HTTP_USER_AGENT'}) {
        $Self->{Browser} = 'Unknown - no $ENV{"HTTP_USER_AGENT"}';
    }
    elsif ($ENV{'HTTP_USER_AGENT'}) { 
        # msie
        if ($ENV{'HTTP_USER_AGENT'} =~ /MSIE ([0-9.]+)/i ||
            $ENV{'HTTP_USER_AGENT'} =~ /Internet Explorer\/([0-9.]+)/i) {
            $Self->{Browser} = 'MSIE';
            $Self->{BrowserWrap} = 'physical';
            # For IE 5.5, we break the header in a special way that makes
            # things work. I don't really want to know.
            if ($1 =~ /(\d)\.(\d)/) {
                $Self->{BrowserMajorVersion} = $1;
                $Self->{BrowserMinorVersion} = $2;
                if ($1 == 5 && $2 == 5) {
                    $Self->{BrowserBreakDispositionHeader} = 1;
                }
            }
        }
        # netscape
        elsif ($ENV{'HTTP_USER_AGENT'} =~ /netscape/i) {
            $Self->{Browser} = 'Netscape';
            $Self->{BrowserWrap} = 'hard';
        }
        # konqueror 
        elsif ($ENV{'HTTP_USER_AGENT'} =~ /konqueror/i) {
            $Self->{Browser} = 'Konqueror';
            $Self->{BrowserWrap} = 'hard';
        }
        # mozilla 
        elsif ($ENV{'HTTP_USER_AGENT'} =~ /^mozilla/i) {
            $Self->{Browser} = 'Mozilla';
            $Self->{BrowserWrap} = 'hard';
        }
        # konqueror 
        elsif ($ENV{'HTTP_USER_AGENT'} =~ /^opera.*/i) {
            $Self->{Browser} = 'Opera';
            $Self->{BrowserWrap} = 'hard';
        }
        # w3m 
        elsif ($ENV{'HTTP_USER_AGENT'} =~ /^w3m.*/i) {
            $Self->{Browser} = 'w3m';
        }
        # lynx 
        elsif ($ENV{'HTTP_USER_AGENT'} =~ /^lynx.*/i) {
            $Self->{Browser} = 'Lynx';
        }
        # links
        elsif ($ENV{'HTTP_USER_AGENT'} =~ /^links.*/i) {
            $Self->{Browser} = 'Links';
        }
        else {
            $Self->{Browser} = "Unknown - $ENV{'HTTP_USER_AGENT'}";
        }
    }
    # --
    # get release data
    # --
    my %ReleaseData = $Self->GetRelease();
    $Self->{Product} = $ReleaseData{Product} || '???'; 
    $Self->{Version} = $ReleaseData{Version} || '???'; 
    # --
    # load theme
    # --
    my $Theme = $Self->{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme') || 'Standard';
    # --
    # locate template files
    # --
    $Self->{TemplateDir} = $Self->{ConfigObject}->Get('TemplateDir')."/HTML/$Theme";
    if (!$Self->{TemplateDir}) {
        die "No templates found in '$Self->{TemplateDir}'! Check your Home in Kernel/Config.pm";
    }

    if ($Self->{PermissionObject}) {
        # --
        # should the admin link be shown?
        # --
        if ($Self->{PermissionObject}->Section(
            UserID => $Self->{UserID},
            Section => 'Admin')
        ){
          $Self->{UserIsAdmin}='Yes';
        }
        # --
        # should the stats link be shown?
        # --
        if ($Self->{PermissionObject}->Section(
            UserID => $Self->{UserID},
            Section => 'Stats')
        ){
            $Self->{UserIsStats}='Yes';
        }
    }

    return $Self;
}
# --
sub Output {
    my $Self = shift;
    my %Param = @_;
    my %Data = ();
    if ($Param{Data}) {
        %Data = %{$Param{Data}};
    }
    # --
    # create %Env for this round!
    # --
    my %Env = ();
    if (!$Self->{EnvRef}) {
        # --
        # build OTRS env
        # --
        %Env = %ENV;
        # --
        # all $Self->{*}
        # --
        foreach (keys %{$Self}) {
            $Env{$_} = $Self->{$_} || '';
        }
    }  
    else {
        # --
        # get %Env from $Self->{EnvRef} 
        # --
        %Env = %{$Self->{EnvRef}};
    }
    # -- 
    # create refs
    # --
    my $EnvRef = \%Env;
    my $DataRef = \%Data;
    my $GlobalRef = {
        EnvRef => $EnvRef, 
        DataRef => $DataRef, 
        ConfigRef => $Self->{ConfigObject},
    };
    # -- 
    # read template from filesystem
    # --
    my @Template = ();
    if ($Param{Template}) {
         @Template = @{$Param{Template}};
    }
    else {
        open (TEMPLATEIN, "< $Self->{TemplateDir}/$Param{TemplateFile}.dtl")  
           ||  die "Can't read $Self->{TemplateDir}/$Param{TemplateFile}.dtl: $!";
        while (my $Line = <TEMPLATEIN>) {
            push (@Template, $Line);
        }
        close (TEMPLATEIN);
    }

    my $Output = '';
    foreach my $Line (@Template) {
      # filtering of comment lines
      if ($Line !~ /^#/) {
        if ($Line =~ /<dtl/) {
          # --
          # do template set (<dtl set $Data{"adasd"} = "lala">) 
          # do system call (<dtl system-call $Data{"adasd"} = "uptime">)
          # --
          $Line =~ s{
            <dtl\W(system-call|set)\W\$(Data|Env|Config)\{\"(.+?)\"\}\W=\W\"(.+?)\">
          }
          {
            my $Data = '';
            if ($1 eq "set") {
              $Data = $4;
            }
            else {
              open (SYSTEM, " $4 | ") || print STDERR "Can't open $4: $!";
              while (<SYSTEM>) {
                $Data .= $_;
              }
              close (SYSTEM);      
            }

            $GlobalRef->{"$2Ref"}->{$3} = $Data;
            # output replace with nothing!
            "";
          }egx;

          # --
          # do template if dynamic
          # --
          $Line =~ s{
            <dtl\Wif\W\(\$(Env|Data|Text)\{\"(.*)\"\}\W(eq|ne)\W\"(.*)\"\)\W\{\W\$(Data|Env|Text)\{\"(.*)\"\}\W=\W\"(.*)\";\W\}>
          }
          {
            if ($3 eq "eq") {
              # --
              # do eq actions
              # --
              if ($1 eq "Text") {
                if ($Self->{LanguageObject}->Get($2, $Param{TemplateFile}) eq $4) {
                  $GlobalRef->{"$5Ref"}->{$6} = $7;
                  "";
                }
              }
              elsif ($1 eq "Env" || $1 eq "Data") {
                if ((defined $GlobalRef->{"$1Ref"}->{$2}) && $GlobalRef->{"$1Ref"}->{$2} eq $4) {
                  $GlobalRef->{"$5Ref"}->{$6} = $7;
                  "";
                }
                else {
                  # output replace with nothing!
                  "";
                }
              }
          }
          elsif ($3 eq "ne") {
              # --
              # do ne actions
              # --
              if ($1 eq "Text") {
                if ($Self->{LanguageObject}->Get($2, $Param{TemplateFile}) ne $4) {
                   $GlobalRef->{"$5Ref"}->{$6} = $7;
                   # output replace with nothing!
                   "";
                }
              }
              elsif ($1 eq "Env" || $1 eq "Data") {
                if ((defined $GlobalRef->{"$1Ref"}->{$2}) && $GlobalRef->{"$1Ref"}->{$2} ne $4) {
                  $GlobalRef->{"$5Ref"}->{$6} = $7;
                  # output replace with nothing!
                  "";
                }
                else {
                  # output replace with nothing!
                  "";
                }
              }
            }
          }egx;
        }
        # add this line to output
        $Output .= $Line;
      }
    }
    # --
    # variable & env & config replacement (two times)
    # --
    foreach (1..2) {
        $Output =~ s{
            \$(Data|Env|Config){"(.+?)"}
        }
        {
            if ($1 eq "Data" || $1 eq "Env") {
                if (defined $GlobalRef->{"$1Ref"}->{$2}) {
                    $GlobalRef->{"$1Ref"}->{$2};
                }
                else {
                    # output replace with nothing!
                    "";
                }
            }
            # replace with
            elsif ($1 eq "Config") {
                if (defined $Self->{ConfigObject}->Get($2)) {
                    $Self->{ConfigObject}->Get($2);
                }
                else {
                    # output replace with nothing!
                    "";
                }
            }
        }egx;
    }
    # --
    # do translation
    # --
    foreach (1..2) {
        $Output =~ s{
            \$Text({"(.+?)"}|{""})
        }
        { 
            $Self->{LanguageObject}->Get($2 || '', $Param{TemplateFile});
        }egx;
    }
    # --
    # Check if the brwoser sends the SessionID cookie! 
    # If not, add the SessinID to the links and forms!
    # --
    if (!$Self->{SessionIDCookie}) {
        # rewrite a hrefs
        $Output =~ s{
            (<a.+?href=")(.+?)(">|".+?>)
        }
        { 
            my $AHref = $1;
            my $Target = $2;
            my $End = $3;
            if ($Target =~ /^(http:|https:|#|ftp:)/i || $Target !~ /(\.pl|\.php|\.cgi)(\?|$)/) {
                "$AHref$Target$End"; 
            } 
            else {
                "$AHref$Target&$Self->{SessionName}=$Self->{SessionID}$End"; 
            }
        }iegx;
        # rewrite img src
        $Output =~ s{
            (<img.+?src=")(.+?)(">|".+?>)
        }
        { 
            my $AHref = $1;
            my $Target = $2;
            my $End = $3;
            if ($Target =~ /^(http:|https:)/i || !$Self->{SessionID} || 
                 $Target !~ /(\.pl|\.php|\.cgi)(\?|$)/) {
                "$AHref$Target$End"; 
            } 
            else {
                "$AHref$Target&$Self->{SessionName}=$Self->{SessionID}$End"; 
            }
        }iegx;
        # rewrite forms: <form action="index.pl" method="get">
        $Output =~ s{
            (<form.+?action=")(.+?)(">|".+?>) 
        }
        { 
            my $Start = "$1";
            my $Target = $2;
            my $End = "$3";
            if ($Target =~ /^(http:|https:)/i || !$Self->{SessionID}) {
                "$Start$Target$End"; 
            } 
            else {
                "$Start$Target$End<input type=\"hidden\" name=\"$Self->{SessionName}\" value=\"$Self->{SessionID}\">";
            }
        }iegx;
    }

    # save %Env
    $Self->{EnvRef} = $EnvRef;

    # return output
    return $Output;
}
# --
sub Redirect {
    my $Self = shift;
    my %Param = @_;
    my $SessionIDCookie = '';
    my $Output = '';
    # --
    # add cookies if exists
    # --
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    # --
    # create & return output
    # --
    if ($Param{ExtURL}) {
        # external redirect
        $Param{Redirect} = $Param{ExtURL};
        return $Self->Output(TemplateFile => 'Redirect', Data => \%Param);
    }
    else {
        # internal redirect
        $Param{Redirect} = $Self->{Baselink} . $Param{OP};
        $Output .= $Self->Output(TemplateFile => 'Redirect', Data => \%Param);
        if (!$Self->{SessionIDCookie}) {
            # rewrite location header 
            $Output =~ s{
                (location: )(.*)
            }
            { 
                my $Start = "$1";
                my $Target = $2;
                if ($Target =~ /http/i || !$Self->{SessionID}) {
                    "$Start$Target"; 
                }
                else {
                    if ($Target =~ /(\?|&)$/) {
                        "$Start$Target$Self->{SessionName}=$Self->{SessionID}";
                    }
                    elsif ($Target !~ /\?/) {
                        "$Start$Target?$Self->{SessionName}=$Self->{SessionID}";
                    }
                    elsif ($Target =~ /\?/) {
                        "$Start$Target&$Self->{SessionName}=$Self->{SessionID}";
                    }
                    else {
                        "$Start$Target?&$Self->{SessionName}=$Self->{SessionID}";
                    }
                }
            }iegx;
        }
        return $Output;
    }
}
# --
sub Test {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'Test', Data => \%Param);
}
# --
sub Login {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # add cookies if exists
    # --
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    # --
    # get message of the day
    # --
    if ($Self->{ConfigObject}->Get('ShowMotd')) {
        $Param{"Motd"} = $Self->Output(TemplateFile => 'Motd', Data => \%Param);
    }
    # --
    # get language options
    # --
    $Param{Language} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
        Name => 'Lang',
        SelectedID => $Self->{UserLanguage},
        OnChange => 'submit()'
    );

    # --
    # create & return output
    # --
    $Output .= $Self->Output(TemplateFile => 'Login', Data => \%Param);
    # --
    # get lost password y
    # --
    if ($Self->{ConfigObject}->Get('LostPassword') 
         && $Self->{ConfigObject}->Get('AuthModule') eq 'Kernel::System::Auth::DB') {
        $Output .= $Self->Output(TemplateFile => 'LostPassword', Data => \%Param);
    }
    return $Output;
}
# --
sub Error {
    my $Self = shift;
    my %Param = @_;

    # get backend error messages
    foreach (qw(Message Subroutine Line Version)) {
      $Param{'Backend'.$_} = $Self->{LogObject}->Error($_) || '';
    }
    if (!$Param{Message}) {
      $Param{Message} = $Param{BackendMessage};
    } 

    # get frontend error messages
    ($Param{Package}, $Param{Filename}, $Param{Line}, $Param{Subroutine}) = caller(0);
    ($Param{Package1}, $Param{Filename1}, $Param{Line1}, $Param{Subroutine1}) = caller(1);
    ($Param{Package2}, $Param{Filename2}, $Param{Line2}, $Param{Subroutine2}) = caller(2);
    $Param{Version} = eval("\$$Param{Package}". '::VERSION');

    # create & return output
    return $Self->Output(TemplateFile => 'Error', Data => \%Param);
}
# --
sub Warning {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'Warning', Data => \%Param);
}
# --
sub Notify {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'Notify', Data => \%Param);
}
# --
sub Header {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # add cookies if exists
    # --
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    # --
    # create & return output
    # --
    $Output .= $Self->Output(TemplateFile => 'Header', Data => \%Param);
    return $Output;
}
# --
sub Footer {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'Footer', Data => \%Param);
}
# --
sub PrintHeader {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # create & return output
    # --
    $Output .= $Self->Output(TemplateFile => 'PrintHeader', Data => \%Param);
    return $Output;
}
# --
sub PrintFooter {
    my $Self = shift;
    my %Param = @_;
    $Param{Host} = $Self->Ascii2Html(
        Text => $ENV{SERVER_NAME}.$ENV{REQUEST_URI},
        Max => 100,
    );
    # create & return output
    return $Self->Output(TemplateFile => 'PrintFooter', Data => \%Param);
}
# --
sub Ascii2Html {
    my $Self = shift;
    my %Param = @_;
    my $Text = defined $Param{Text} ? $Param{Text} : return;
    my $Max  = $Param{Max} || '';
    my $VMax = $Param{VMax} || '';
    my $NewLine = $Param{NewLine} || '';

    # max width
    if ($Max) {
        $Text =~ s/^(.{$Max}).*$/$1\[\.\.\.\]/gs;
    }
    # newline
    if ($NewLine) {
         $Text =~ s/\r/\n/g;
         $Text =~ s/(.{$NewLine}.+?\s)/$1\n/g;
    }
    # max lines
    if ($VMax) {
        my @TextList = split ('\n', $Text);
        $Text = '';
        my $Counter = 1;
        foreach (@TextList) {
          $Text .= $_ . "\n" if ($Counter <= $VMax);
          $Counter++;
        }
        $Text .= "[...]\n" if ($Counter >= $VMax);
    }
    # html quoting
    $Text =~ s/&/&amp;/g;
    $Text =~ s/</&lt;/g;
    $Text =~ s/>/&gt;/g;
    $Text =~ s/"/&quot;/g;
    $Text =~ s/ç/&ccedil;/g;
#&ntilde;
    # return result
    return $Text;
}
# --
sub LinkQuote {
    my $Self = shift;
    my %Param = @_;
    my $Text = $Param{Text} || '';
    my $Target = $Param{Target} || 'NewPage'. int(rand(199));

    # do link quote
    $Text =~ s/(http:\/\/.*?)(\s|\)|\"|]|')/<a href=\"$1\" target=\"$Target\">$1<\/a>$2/gi;
    $Text =~ s/(https:\/\/.*?)(\s|\)|\"|]|')/<a href=\"$1\" target=\"$Target\">$1<\/a>$2/gi;
    # do mail to quote
    $Text =~ s/(mailto:.*?)(\s|\)|\"|]|')/<a href=\"$1\">$1<\/a>$2/gi;

    return $Text;
}
# --
sub LinkEncode {
    my $Self = shift;
    my $Link = shift || return;
    $Link =~ s/&/%26/g;
    $Link =~ s/=/%3D/g;
    $Link =~ s/\!/%21/g;
    $Link =~ s/"/%22/g;
    $Link =~ s/\#/%23/g;
    $Link =~ s/\$/%24/g;
    $Link =~ s/'/%27/g;
    $Link =~ s/\+/%2B/g;
    $Link =~ s/\?/%3F/g;
    $Link =~ s/\|/%7C/g;
    $Link =~ s/§/\%A7/g;
    $Link =~ s/ /\+/g;
    return $Link;
}
# --
sub CustomerAge {
    my $Self = shift;
    my %Param = @_;
    my $Age = $Param{Age};
    my $Space = $Param{Space} || '<BR>';
    my $AgeStrg = '';
    if ($Age =~ /^-(.*)/) {
        $Age = $1;
        $AgeStrg = '-';
    }
    # get days
    if ($Age > 86400) {
        $AgeStrg .= int( ($Age / 3600) / 24 ) . ' ';
        if (int( ($Age / 3600) / 24 ) > 1) {
            $AgeStrg .= $Self->{LanguageObject}->Get('days');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('day');
        }
        $AgeStrg .= $Space;
    }

    # get hours
    if ($Age > 3600) {
        $AgeStrg .= int( ($Age / 3600) % 24 ) . ' ';
        if (int( ($Age / 3600) % 24 ) > 1) {
            $AgeStrg .= $Self->{LanguageObject}->Get('hours');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('hour');
        }
        $AgeStrg .= $Space;
    }
    $AgeStrg .= int( ($Age / 60) % 60) . ' ';

    # get minutes
    if (int( ($Age / 60) % 60) > 1) {
        $AgeStrg .= $Self->{LanguageObject}->Get('minutes');
    }
    else {
        $AgeStrg .= $Self->{LanguageObject}->Get('minute');
    }

    return $AgeStrg;
}
# --
sub OptionStrgHashRef {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $Name = $Param{Name} || '';
    my $Multiple = $Param{Multiple} || '';
    $Multiple = 'multiple' if ($Multiple);
    my $Selected = $Param{Selected} || '';
    my $SelectedID = $Param{SelectedID} || '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $PossibleNone = $Param{PossibleNone} || '';
    my $Size = $Param{Size} || '';
    $Size = "size=$Size" if ($Size);
    if (!$Param{Data}) {
        return "Got no Data ref in OptionStrgHashRef()!";
    }
    my %Data = %{$Param{Data}};
    my $OnStuff = '';
    if ($Param{OnChangeSubmit}) {
        $OnStuff .= ' onchange="submit()" ';
    }
    if ($Param{OnChange}) {
        $OnStuff = " onchange=\"$Param{OnChange}\" ";
    }
    if ($Param{OnClick}) {
        $OnStuff = " onclick=\"$Param{OnClick}\" ";
    }
    # --
    # set default value
    # --
    if (($Name eq 'ValidID' || $Name eq 'Valid') && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultValid');
    }
    elsif (($Name eq 'CharsetID' || $Name eq 'Charset') && !$Selected  && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultCharset');
    }
    elsif (($Name eq 'LanguageID' || $Name eq 'Language') && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultLanguage');
    }
    elsif (($Name eq 'ThemeID' || $Name eq 'Theme') && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultTheme');
    }
    elsif (($Name eq 'LanguageID' || $Name eq 'Language') && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultLanguage');
    }
    elsif ($Name eq 'NoteID' && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultNoteType');
    }
    elsif ($Name eq 'CloseNoteID' && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultCloseNoteType');
    }
    elsif ($Name eq 'CloseStateID' && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultCloseType');
    }
    elsif ($Name eq 'ComposeStateID' && !$Selected && !$SelectedID) {
        $Selected = $Self->{ConfigObject}->Get('DefaultNextComposeType');
    }
    elsif (!$Selected && !$SelectedID) {
        # else set 1?
#        $SelectedID = 1;
    }

    # --
    # build select string
    # --
    $Output .= "<select name=\"$Name\" $Multiple $OnStuff $Size>\n";
    if ($PossibleNone) {
        $Output .= '<option VALUE="">$Text{"none"}</option>';
    }
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        if ((defined($_)) && ($Data{$_})) {
            # check if SelectedIDRefArray exists
            if ($SelectedIDRefArray) {
                foreach my $ID (@{$SelectedIDRefArray}) {
                    if ($ID eq $_) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }
            # build select string
            if ($_ eq $SelectedID || $Data{$_} eq $Selected || $Param{SelectedIDRefArrayOK}->{$_}) {
              $Output .= '    <option selected value="'.$Self->Ascii2Html(Text => $_).'">'.
                  $Self->Ascii2Html(Text => $Self->{LanguageObject}->Get($Data{$_})) ."</option>\n";
            }
            else {
              $Output .= '    <option VALUE="'.$Self->Ascii2Html(Text => $_).'">'.
                  $Self->Ascii2Html(Text => $Self->{LanguageObject}->Get($Data{$_})) ."</option>\n";
            }
        }
    }
    $Output .= "</select>\n";
    return $Output;
}
# --
sub NoPermission {
    my $Self = shift;
    my %Param = @_;
    my $WithHeader = $Param{WithHeader} || 'yes';
    my $Output = '';
    $Param{Message} = 'Please go away!' if (!$Param{Message});

    # create output
    $Output = $Self->Header(Title => 'No Permission') if ($WithHeader eq 'yes');
    $Output .= $Self->Output(TemplateFile => 'NoPermission', Data => \%Param);
    $Output .= $Self->Footer() if ($WithHeader eq 'yes');

    # return output
    return $Output;
}
# --
sub CheckCharset {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    if (!$Param{Action}) {
       $Param{Action} = '$Env{"Action"}';
    }
    # with utf-8 can everything be shown
    if ($Self->{UserCharset} !~ /utf/i) {
      # replace ' or "
      $Param{ContentCharset} && $Param{ContentCharset} =~ s/'|"//gi;
      # if the content charset is different to the user charset
      if ($Param{ContentCharset} && $Self->{UserCharset} !~ /^$Param{ContentCharset}$/i) {
        # if the content charset is us-ascii it is always shown correctly
        if ($Param{ContentCharset} !~ /us-ascii/i) { 
            $Output = '<p><i class="small">'.
              '$Text{"This message was written in a character set other than your own."}'.
              '$Text{"If it is not displayed correctly,"} '.
              '<a href="'.$Self->{Baselink}."Action=$Param{Action}&TicketID=$Param{TicketID}".
              "&ArticleID=$Param{ArticleID}&Subaction=ShowHTMLeMail\" target=\"HTMLeMail\" ".
              'onmouseover="window.status=\'$Text{"open it in a new window"}\'; return true;" onmouseout="window.status=\'\';">'.
              '$Text{"click here"}</a> $Text{"to open it in a new window."}</i></p>';
        }
      }
    }
    # return note string
    return $Output;
}
# --
sub CheckMimeType {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    if (!$Param{Action}) {
       $Param{Action} = '$Env{"Action"}';
    }
    # --
    # check if it is a text/plain email
    # --
    if ($Param{MimeType} && $Param{MimeType} !~ /text\/plain/i) {
         $Output = '<p><i class="small">$Text{"This is a"} '.$Param{MimeType}.
           ' $Text{"email"}, '. 
           '<a href="'.$Self->{Baselink}."Action=$Param{Action}&TicketID=".
           "$Param{TicketID}&ArticleID=$Param{ArticleID}&Subaction=ShowHTMLeMail\" ".
           'target="HTMLeMail" '.
           'onmouseover="window.status=\'$Text{"open it in a new window"}\'; return true;" onmouseout="window.status=\'\';">'.
           '$Text{"click here"}</a> '.
           '$Text{"to open it in a new window."}</i></p>';
    }
    # just to be compat
    elsif ($Param{Text} =~ /^<.DOCTYPE html PUBLIC|^<HTML>/i) {
         $Output = '<p><i class="small">$Text{"This is a"} '.$Param{MimeType}.
           ' $Text{"email"}, '.
           '<a href="'.$Self->{Baselink}.'Action=$Env{"Action"}&TicketID='.
           "$Param{TicketID}&ArticleID=$Param{ArticleID}&Subaction=ShowHTMLeMail\" ".
           'target="HTMLeMail" '.
           'onmouseover="window.status=\'$Text{"open it in a new window"}\'; return true;" onmouseout="window.status=\'\';">'.
           '$Text{"click here"}</a> '.
           '$Text{"to open it in a new window."}</i></p>';
    }
    # return note string
    return $Output;
}
# --
sub ReturnValue {
    my $Self = shift;
    my $What = shift;
    return $Self->{$What};
}
# --
sub GetRelease {
    my $Self = shift;
    my %Param = @_;
    # --
    # chekc if this is already done
    # --
    if ($Self->{ReleaseHash}) {
        return %{$Self->{ReleaseHash}};
    }
    # --
    # open release data file
    # --
    my %Release = ();
    $Release{File} = $Self->{ConfigObject}->Get('Home').'/RELEASE';
    open (PRODUCT, "< $Release{File}") || print STDERR "Can't read $Release{File}: $!";
    while (<PRODUCT>) {
      # filtering of comment lines
      if ($_ !~ /^#/) {
        if ($_ =~ /^PRODUCT.=(.*)$/i) {
            $Release{Product} = $1;
        }
        elsif ($_ =~ /^VERSION.=(.*)$/i) {
            $Release{Version} = $1;
        }
      }
    }
    close (PRODUCT);
    # --
    # store data
    # --
    $Self->{ReleaseHash} = \%Release;
    # --
    # return data
    # --
    return %Release;
}
# --
sub Attachment {
    my $Self = shift;
    my %Param = @_;
    # --    
    # return attachment  
    # --          
    my $Output = '';
    if ($Self->{BrowserBreakDispositionHeader}) {
        $Output = "Content-Disposition: filename=$Param{File}\n";
    }             
    else {
        $Output = "Content-Disposition: attachment; filename=$Param{File}\n";
    }
    $Output .= "Content-Type: $Param{Type}\n";
    $Output .= "$Param{Data}";
    return $Output;
}
# --
sub BuildDateSelection {
    my $Self = shift;
    my %Param = @_;
    my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time);
    $Y = $Y+1900;
    $M++;
    # year
    my %Year = ();
    foreach ($Y-3..$Y+10) {
        $Year{$_} = $_;
    }
    $Param{Year} = $Self->OptionStrgHashRef(
        Name => 'Year',
        Data => \%Year,
        SelectedID => $Param{Year} || $Y,
    );
    # month
    my %Month = ();
    foreach (1..12) {
        my $Tmp = sprintf("%02d", $_);
        $Month{$_} = $Tmp;
    }
    $Param{Month} = $Self->OptionStrgHashRef(
        Name => 'Month',
        Data => \%Month,
        SelectedID => $Param{Month} || $M,
    );
    # day
    my %Day = ();
    foreach (1..31) {
        my $Tmp = sprintf("%02d", $_);
        $Day{$_} = $Tmp;
    }
    $Param{Day} = $Self->OptionStrgHashRef(
        Name => 'Day',
        Data => \%Day,
        SelectedID => $Param{Day} || $D,
    );
    # hour
    my %Hour = ();
    foreach (1..23) {
        my $Tmp = sprintf("%02d", $_);
        $Hour{$_} = $Tmp;
    }
    $Param{Hour} = $Self->OptionStrgHashRef(
        Name => 'Hour',
        Data => \%Hour,
        SelectedID => $Param{Hour} || $h,
    );
    # minute
    my %Minute = ();
    foreach (1..59) {
        my $Tmp = sprintf("%02d", $_);
        $Minute{$_} = $Tmp;
    }
    $Param{Minute} = $Self->OptionStrgHashRef(
        Name => 'Minute',
        Data => \%Minute,
        SelectedID => $Param{Minute} || $m,
    );
    #DateFormat
    return $Self->{LanguageObject}->Time(
        Action => 'Return',
        Format => 'DateInputFormat',
        Mode => 'NotNumeric',
        %Param,
    );
}
# --

1;
