# --
# Kernel/Output/HTML/Generic.pm - provides generic HTML output
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Generic.pm,v 1.111 2004-04-07 18:27:35 martin Exp $
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
use Kernel::Output::HTML::FAQ;
use Kernel::Output::HTML::Customer;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.111 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

@ISA = (
    'Kernel::Output::HTML::Agent',
    'Kernel::Output::HTML::Admin',
    'Kernel::Output::HTML::Customer',
    'Kernel::Output::HTML::FAQ',
);

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);
    # get common objects 
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # set debug
    $Self->{Debug} = 0;
    # check needed objects
    foreach (qw(ConfigObject LogObject)) {
        die "Got no $_!" if (!$Self->{$_});
    } 
    # get/set some common params
    if (!$Self->{UserTheme}) {
        $Self->{UserTheme} = $Self->{ConfigObject}->Get('DefaultTheme');
    }
    # get use language (from browser) if no language is there!
    if (!$Self->{UserLanguage}) { 
        my $BrowserLang = $Self->{Lang} || $ENV{HTTP_ACCEPT_LANGUAGE} || '';
        my %Data = %{$Self->{ConfigObject}->Get('DefaultUsedLanguages')}; 
        foreach (keys %Data) {
            if ($BrowserLang =~ /^$_/i) {
                $Self->{UserLanguage} = $_;
            }
        }
    }
    # create language object
    $Self->{LanguageObject} = Kernel::Language->new(
        UserLanguage => $Self->{UserLanguage},
        LogObject => $Self->{LogObject},
        ConfigObject => $Self->{ConfigObject},
    );
    # --
    # set charset if there is no charset given
    # --
    $Self->{UserCharset} = $Self->{LanguageObject}->GetRecommendedCharset();
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
    $Self->{TimeLong}  = $Self->{LanguageObject}->Time(
        Action => 'GET', 
        Format => 'DateFormatLong',
    );
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
    if ($Param{Template} && ref($Param{Template}) eq 'ARRAY') {
         @Template = @{$Param{Template}};
    }
    elsif ($Param{Template}) {
         @Template = join("\n", split(/\n/, $Param{Template}));
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
            <dtl\Wif\W\(\$(Env|Data|Text|Config)\{\"(.*)\"\}\W(eq|ne|=~|!~)\W\"(.*)\"\)\W\{\W\$(Data|Env|Text)\{\"(.*)\"\}\W=\W\"(.*)\";\W\}>
          }
          {
              my $Type = $1 || '';
              my $TypeKey = $2 || '';
              my $Con = $3 || '';
              my $ConVal = $4 || '';
              my $IsType = $5 || '';
              my $IsKey = $6 || '';
              my $IsValue = $7 || '';
              # --
              # do ne actions
              # --
              if ($Type eq 'Text') {
                my $Tmp = $Self->{LanguageObject}->Get($TypeKey, $Param{TemplateFile}) || '';
                if (eval '($Tmp '.$Con.' $ConVal)') {
                  $GlobalRef->{$IsType.'Ref'}->{$IsKey} = $IsValue;
                  # output replace with nothing!
                  "";
                }
              }
              elsif ($Type eq 'Env' || $Type eq 'Data') {
                my $Tmp = $GlobalRef->{$Type.'Ref'}->{$TypeKey} || '';
                if (eval '($Tmp '.$Con.' $ConVal)') {
                  $GlobalRef->{$IsType.'Ref'}->{$IsKey} = $IsValue;
                  # output replace with nothing!
                  "";
                }
                else {
                  # output replace with nothing!
                  "";
                }
              }
              elsif ($Type eq 'Config') {
                my $Tmp = $Self->{ConfigObject}->Get($TypeKey) || '';
                if (eval '($Tmp '.$Con.' $ConVal)') {
                  $GlobalRef->{$IsType.'Ref'}->{$IsKey} = $IsValue;
                  "";
                }
              }
          }egx;
        }
        # add this line to output
        $Output .= $Line;
      }
    }
    # --
    # variable & env & config replacement (three times)
    # --
    foreach (1..3) {
        $Output =~ s{
            \$(QData|Data|Env|Config|Include){"(.+?)"}
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
            elsif ($1 eq "QData") {
                my $Text = $2;
                if (!defined($Text) || $Text =~ /^","(.+?)$/) {
                    "";
                }
                elsif ($Text =~ /^(.+?)","(.+?)$/) {
                    if (defined $GlobalRef->{"DataRef"}->{$1}) {
                        $Self->Ascii2Html(Text => $GlobalRef->{"DataRef"}->{$1}, Max => $2);
                    }
                    else {
                        # output replace with nothing!
                        "";
                    }
                }
                else {
                    if (defined $GlobalRef->{"DataRef"}->{$Text}) {
                        $Self->Ascii2Html(Text => $GlobalRef->{"DataRef"}->{$Text});
                    }
                    else {
                        # output replace with nothing!
                        "";
                    } 
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
            # include dtl files
            elsif ($1 eq "Include") {
                $Param{TemplateFile} = $2;
                $Self->Output(%Param); 
            }
        }egx;
    }
    # --
    # do time translation
    # --
    foreach (1..1) {
        $Output =~ s{
            \$TimeLong({"(.+?)"}|{""})
        }
        { 
            $Self->{LanguageObject}->FormatTimeString($2);
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
    # do html quote
    # --
    foreach (1..2) {
        $Output =~ s{
            \$Quote({"(.+?)"}|{""})
        }
        { 
            my $Text = $2;
#print STDERR "---- $Text ---\n";
            if (!defined($Text) || $Text =~ /^","(.+?)$/) {
                "";
            }
            elsif ($Text =~ /^(.+?)","(.+?)$/) {
                $Self->Ascii2Html(Text => $1, Max => $2);
            }
            else {
                $Self->Ascii2Html(Text => $Text);
            }
        }egx;
    }
    # --
    # Check if the brwoser sends the SessionID cookie! 
    # If not, add the SessinID to the links and forms!
    # --
    if (!$Self->{SessionIDCookie}) {
        # rewrite a hrefs
        $Output =~ s{
            (<a.+?href=")(.+?)(\#.+?|)(">|".+?>)
        }
        { 
            my $AHref = $1;
            my $Target = $2;
            my $End = $3;
            my $RealEnd = $4;
            if ($Target =~ /^(http:|https:|#|ftp:)/i || $Target !~ /(\.pl|\.php|\.cgi)(\?|$)/) {
                "$AHref$Target$End$RealEnd"; 
            } 
            else {
                "$AHref$Target&$Self->{SessionName}=$Self->{SessionID}$End$RealEnd"; 
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
        OnChange => 'submit()',
        HTMLQuote => 0,
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
    foreach (qw(Message Traceback)) {
      $Param{'Backend'.$_} = $Self->{LogObject}->GetLogEntry(
          Type => 'Error',
          Message => $_
      ) || '';
      $Param{'Backend'.$_} = $Self->Ascii2Html(
          Text => $Param{'Backend'.$_}, 
          HTMLResultMode => 1,
      );
    }
    if (!$Param{Message}) {
      $Param{Message} = $Param{BackendMessage};
    } 
    # create & return output
    return $Self->Output(TemplateFile => 'Error', Data => \%Param);
}
# --
sub Warning {
    my $Self = shift;
    my %Param = @_;
    # get backend error messages
    foreach (qw(Message)) {
      $Param{'Backend'.$_} = $Self->{LogObject}->GetLogEntry(
          Type => 'Notice',
          What => $_
      ) || $Self->{LogObject}->GetLogEntry(
          Type => 'Error',
          What => $_
      ) || '';
      $Param{'Backend'.$_} = $Self->Ascii2Html(
          Text => $Param{'Backend'.$_}, 
          HTMLResultMode => 1,
      );
    }
    if (!$Param{Message}) {
      $Param{Message} = $Param{BackendMessage};
    } 
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
    my $Type = $Param{Type} || '';
    # add cookies if exists
    if ($Self->{SetCookies} && $Self->{ConfigObject}->Get('SessionUseCookie')) {
        foreach (keys %{$Self->{SetCookies}}) {
            $Output .= "Set-Cookie: $Self->{SetCookies}->{$_}\n";
        }
    }
    # check area
    if (!$Param{'Area'} && $Param{'Title'}) {
        $Param{'Area'} = $Param{'Title'};
        $Param{'Title'} = '';
    }
    # create & return output
    $Output .= $Self->Output(TemplateFile => "Header$Type", Data => \%Param);
    return $Output;
}
# --
sub Footer {
    my $Self = shift;
    my %Param = @_;
    my $Type = $Param{Type} || '';
    # create & return output
    return $Self->Output(TemplateFile => "Footer$Type", Data => \%Param);
}
# --
sub PrintHeader {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    if (!$Param{Width}) {
        $Param{Width} = 640;
    }
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
    my $HTMLMode = $Param{HTMLResultMode} || '';
    my $StripEmptyLines = $Param{StripEmptyLines} || '';
    # max width
    if ($Max) {
        $Text =~ s/^(.{$Max}).*$/$1\[\.\.\]/gs;
    }
    # newline
    if ($NewLine && length($Text) < 8000) {
         $Text =~ s/\r/\n/g;
         $Text =~ s/(.{$NewLine}.+?\s)/$1\n/g;
    }
    # strip empty lines
    if ($StripEmptyLines) {
        $Text =~ s/^\s*\n//mg;
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
    # text -> html format quoting
    if ($HTMLMode) {
        $Text =~ s/\n/<br>\n/g;
        $Text =~ s/  / &nbsp;/g;
    }
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
    $Text =~ s/(http|https|ftp)(:\/\/.*?)(\s|\)|\"|&quot;|]|'|>|<|&gt;|&lt;)/<a href=\"$1$2\" target=\"$Target\">$1$2<\/a>$3/gi;
    # do mail to quote
    $Text =~ s/(mailto:.*?)(\s|\)|\"|]|')/<a href=\"$1\">$1<\/a>$2/gi;
    return $Text;
}
# --
sub LinkEncode {
    my $Self = shift;
    my $Link = shift;
    if (!defined($Link)) {
        return;
    } 
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
    my $Age = defined($Param{Age}) ? $Param{Age} : return;
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
    # get minutes (just if age < 1 day)
    if ($Self->{ConfigObject}->Get('ShowAlwaysLongTime') || $Age < 86400) {
        $AgeStrg .= int( ($Age / 60) % 60) . ' ';
        if (int( ($Age / 60) % 60) > 1) {
            $AgeStrg .= $Self->{LanguageObject}->Get('minutes');
        }
        else {
            $AgeStrg .= $Self->{LanguageObject}->Get('minute');
        }
    }
    return $AgeStrg;
}
# --
sub OptionStrgHashRef {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $Name = $Param{Name} || '';
    my $Max = $Param{Max} || 80;
    my $Multiple = $Param{Multiple} ? 'multiple' : '';
    my $HTMLQuote = defined($Param{HTMLQuote}) ? $Param{HTMLQuote} : 1;
    my $LT = defined($Param{LanguageTranslation}) ? $Param{LanguageTranslation} : 1;
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
    # hash cleanup
    foreach (keys %Data) {
        if (!defined($Data{$_})) {
            delete $Data{$_};
        }
    }
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        if ((defined($_)) && ($Data{$_})) {
            # check if SelectedIDRefArray exists
            if ($SelectedIDRefArray && ref($SelectedIDRefArray) eq 'ARRAY') {
                foreach my $ID (@{$SelectedIDRefArray}) {
                    if ($ID eq $_) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }
            # build select string
            if ($_ eq $SelectedID || $Data{$_} eq $Selected || $Param{SelectedIDRefArrayOK}->{$_}) {
              $Output .= '  <option selected value="'.$Self->Ascii2Html(Text => $_).'">';
            }
            else {
              $Output .= '  <option value="'.$Self->Ascii2Html(Text => $_).'">';
            }
            if ($LT) {
                $Data{$_} = $Self->{LanguageObject}->Get($Data{$_});
            }
            if ($HTMLQuote) {
                $Output .= $Self->Ascii2Html(Text => $Data{$_}, Max => $Max); 
            }
            else {
                $Output .= $Data{$_};
            }
            $Output .= "</option>\n";
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
    $Param{Message} = 'No Permission!' if (!$Param{Message});
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
    if ($Self->{UserCharset} !~ /^utf-8$/i) {
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
    elsif ($Param{Body} =~ /^<.DOCTYPE html PUBLIC|^<HTML>/i) {
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
    # reset binmode, don't use utf8
    binmode(STDOUT);
    # return attachment  
    my $Output = "Content-Disposition: filename=$Param{Filename}\n";
    $Output .= "Content-Type: $Param{ContentType}\n\n";
    $Output .= "$Param{Content}";
    return $Output;
}
# --
sub PageNavBar {
    my $Self = shift;
    my %Param = @_;
    my $Limit = $Param{Limit} || 0;
    $Param{AllHits} = 0 if (!$Param{AllHits});
    $Param{StartHit} = 0 if (!$Param{AllHits});
    my $Pages = int(($Param{AllHits} / $Param{SearchPageShown}) + 0.99999);
    my $Page = int(($Param{StartHit} / $Param{SearchPageShown}) + 0.99999);
    # build Results (1-5 or 16-30)
    if ($Param{AllHits} >= ($Param{StartHit}+$Param{SearchPageShown})) {
        $Param{Results} = $Param{StartHit}."-".($Param{StartHit}+$Param{SearchPageShown}-1);
    }
    else {
        $Param{Results} = "$Param{StartHit}-$Param{AllHits}";
    }
    # check total hits
    if ($Limit == $Param{AllHits}) {
       $Param{TotalHits} = "<font color=red>$Param{AllHits}</font>";
    }
    else {
       $Param{TotalHits} = $Param{AllHits};
    }
    # build page nav bar
    for (my $i = 1; $i <= $Pages; $i++) {
        $Param{SearchNavBar} .= " <a href=\"$Self->{Baselink}$Param{Action}&$Param{Link}".
         "StartHit=". ((($i-1)*$Param{SearchPageShown})+1);
         $Param{SearchNavBar} .= '">';
         if ($Page == $i) {
             $Param{SearchNavBar} .= '<b>'.($i).'</b>';
         }
         else {
             $Param{SearchNavBar} .= ($i);
         }
         $Param{SearchNavBar} .= '</a> ';
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentUtilSearchNavBar', Data => \%Param);
}
# --
sub BuildDateSelection {
    my $Self = shift;
    my %Param = @_;
    my $Prefix = $Param{'Prefix'} || '';
    my $DiffTime = $Param{'DiffTime'} || 0;
    my $Format = defined($Param{Format}) ? $Param{Format} : 'DateInputFormatLong';
    my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time()+$DiffTime);
    $Y = $Y+1900;
    $M++;
    # year
    my %Year = ();
    foreach ($Y-4..$Y+10) {
        $Year{$_} = $_;
    }
    $Param{Year} = $Self->OptionStrgHashRef(
        Name => $Prefix.'Year',
        Data => \%Year,
        SelectedID => $Param{$Prefix.'Year'} || $Y,
    );
    # month
    my %Month = ();
    foreach (1..12) {
        my $Tmp = sprintf("%02d", $_);
        $Month{$_} = $Tmp;
    }
    $Param{Month} = $Self->OptionStrgHashRef(
        Name => $Prefix.'Month',
        Data => \%Month,
        SelectedID => $Param{$Prefix.'Month'} || $M,
    );
    # day
    my %Day = ();
    foreach (1..31) {
        my $Tmp = sprintf("%02d", $_);
        $Day{$_} = $Tmp;
    }
    $Param{Day} = $Self->OptionStrgHashRef(
        Name => $Prefix.'Day',
        Data => \%Day,
        SelectedID => $Param{$Prefix.'Day'} || $D,
    );
    if ($Format eq 'DateInputFormatLong') {
        # hour
        my %Hour = ();
        foreach (0..23) {
            my $Tmp = sprintf("%02d", $_);
            $Hour{$_} = $Tmp;
        }
        $Param{Hour} = $Self->OptionStrgHashRef(
            Name => $Prefix.'Hour',
            Data => \%Hour,
            SelectedID => $Param{$Prefix.'Hour'} || $h,
        );
        # minute
        my %Minute = ();
        foreach (0..59) {
            my $Tmp = sprintf("%02d", $_);
            $Minute{$_} = $Tmp;
        }
        $Param{Minute} = $Self->OptionStrgHashRef(
            Name => $Prefix.'Minute',
            Data => \%Minute,
            SelectedID => $Param{$Prefix.'Minute'} || $m,
        );
    }
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
