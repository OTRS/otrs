# --
# Kernel/Language.pm - provides multi language support
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Language.pm,v 1.16 2003-01-09 15:36:02 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language;

use strict;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.16 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
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
    # 0=off; 1=on; 2=get all not translated words; 3=get all requests
    # --
    $Self->{Debug} = 0;
    # --
    # user language
    # --
    $Self->{UserLanguage} = $Param{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
#    $Self->{UserLanguage} = 'english';
    # --
    # check language if long name s given --> compat 
    # --
    if ($Self->{UserLanguage} !~ /^..$/) {
      my %OldNames = (
          bb => 'Bavarian',
          en => 'English',
          de => 'German',
          nl => 'Dutch',
          fr => 'French',
          bg => 'Bulgarian',
          es => 'Spanish',
          cs => 'Czech', 
          it => 'Italian',
      );
      foreach (keys %OldNames) {
          if ($OldNames{$_} =~ /^$Self->{UserLanguage}$/i) {
              $Self->{UserLanguage} = $_;
          }
      }
    }
    # --
    # Debug 
    # --
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
          Priority => 'Debug',
          Message => "UserLanguage = $Self->{UserLanguage}",
        );
    }

    # load text catalog ...
    if (eval "require Kernel::Language::$Self->{UserLanguage}") {
       @ISA = ("Kernel::Language::$Self->{UserLanguage}");
       $Self->Data();
       if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'Debug',
                Message => "Kernel::Language::$Self->{UserLanguage} load ... done."
            );
        }
    }
    # if there is no translation
    else {
        $Self->{LogObject}->Log(
          Priority => 'Error',
          Message => "Sorry, can't locate or load Kernel::Language::$Self->{UserLanguage} ".
              "translation! Check the Kernel/Language/$Self->{UserLanguage}.pm (perl -cw)!",
        );
    }
    return $Self;
}
# --
sub Get {
    my $Self = shift;
    my $What = shift;
    my $File = shift || '';
    my @Dyn = ();
    # --
    # check
    # --
    if (! defined $What) {
        return;
    }
    # --
    # check dyn spaces
    # --
    if ($What && $What =~ /^(.+?)", "(.+?|)$/) {
        $What = $1;
        @Dyn = split(/", "/, $2);
    }
    # --
    # check wanted param and returns the 
    # lookup or the english data
    # --
    if (exists $Self->{Translation}->{$What} && $Self->{Translation}->{$What} ne '') {
        # Debug
        if ($Self->{Debug} > 3) {
            $Self->{LogObject}->Log(
              Priority => 'Debug',
              Message => "->Get('$What') = ('$Self->{Translation}->{$What}').",
            );
        }
        if ($Self->{UsedWords}->{$File}) {
           $Self->{UsedWords}->{$File} = {$What => $Self->{Translation}->{$What}, %{$Self->{UsedWords}->{$File}}};
        }
        else {
           $Self->{UsedWords}->{$File} = {$What => $Self->{Translation}->{$What}};
        }
        foreach (0..5) {
            if (defined $Dyn[$_]) {
                if ($Dyn[$_] =~ /Time\((.*)\)/) {
                    $Dyn[$_] = $Self->Time(
                        Action => 'GET', 
                        Format => $1,
                    );
                    $Self->{Translation}->{$What} =~ s/\%(s|d)/$Dyn[$_]/;
                }
                else {
                    $Self->{Translation}->{$What} =~ s/\%(s|d)/$Dyn[$_]/;
                }
            }
        }
        return $Self->{Translation}->{$What};
    }
    else {
        # warn if the value is not def
        if ($Self->{Debug} > 1) {
          $Self->{LogObject}->Log(
            Priority => 'debug',
            Message => "->Get('$What') Is not translated!!!",
          );
        }
        if ($Self->{UsedWords}->{$File}) {
           $Self->{UsedWords}->{$File} = {$What => '', %{$Self->{UsedWords}->{$File}}};
        }
        else {
            $Self->{UsedWords}->{$File} = {$What => ''};
        }
        foreach (0..5) {
            $What =~ s/\%(s|d)/$Dyn[$_]/ if (defined $Dyn[$_]);
        }
        return $What;
    }
}
# --
sub GetRecommendedCharset {
    my $Self = shift;
    if ($Self->{Charset}) {
        my @Chatsets = @{$Self->{Charset}};
        return $Chatsets[$#Chatsets];
    }
    else {
        return $Self->{ConfigObject}->Get('DefaultCharset') || 'iso-8859-1';
    }
}
# --
sub GetPossibleCharsets {
    my $Self = shift;
    if ($Self->{Charset}) {
        return @{$Self->{Charset}};
    }
    else {
        return;
    }
}
# --
sub Time {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Action Format)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $ReturnString = $Self->{$Param{Format}} || 'Need to be translated!';
    my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst);
    # --
    # set or get time
    # --
    if ($Param{Action} =~ /^GET$/i) {
        my @DAYS = qw/Sun Mon Tue Wed Thu Fri Sat/;
        my @MONS = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time);
        $Y = $Y+1900;
        $M++;
    }
    elsif ($Param{Action} =~ /^RETURN$/i) {
        $m = $Param{Minute} || 0;
        $h = $Param{Hour} || 0;
        $D = $Param{Day} || 0;
        $M = $Param{Month} || 0;
        $Y = $Param{Year} || 0;
    }
    # --
    # do replace
    # --
    if ($Param{Action} =~ /^(GET|RETURN)$/i) {
        my @DAYS = qw/Sun Mon Tue Wed Thu Fri Sat/;
        my @MONS = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        my $Time = '';
        if ($Param{Mode} && $Param{Mode} =~ /^NotNumeric$/i) {
            if (!$s) {
                $Time = "$h:$m";
            }
            else {
                $Time = "$h:$m:$s";
            }
        }
        else {
            $Time = sprintf("%02d:%02d:%02d", $h,$m,$s);
            $D = sprintf("%02d", $D);
            $M = sprintf("%02d", $M);
        }
        $ReturnString =~ s/\%T/$Time/g;
        $ReturnString =~ s/\%D/$D/g;
        $ReturnString =~ s/\%M/$M/g;
        $ReturnString =~ s/\%Y/$Y/g;
        $ReturnString =~ s/\%Y/$Y/g;
        $ReturnString =~ s{(\%A)}{$Self->Get($DAYS[$wd]);}egx;
        $ReturnString =~ s{(\%B)}{$Self->Get($MONS[$M-1]);}egx;
        return $ReturnString;
    } 
    # --
    # return
    # --
    return $ReturnString;
}
# --
sub DESTROY {
    my $Self = shift;
    if (!$Self->{ConfigObject}->Get('WriteNewTranslationFile')) {
        return 1;
    }
    if ($Self->{UsedWords}) {
        my %UniqWords = ();
        my $Data = '';
        my %Screens = %{$Self->{UsedWords}};
        $Data .= "    # possible charsets\n".
                 "    \$Self->{Charset} = [";
        if ($Self->{Charset}) {
            foreach (@{$Self->{Charset}}) {
                $Data .= "'$_', ";
            }
        }
        $Data .= "];\n".
                 "    # date formats (\%A=WeekDay;\%B=LongMonth;\%T=Time;\%D=Day;\%M=Month;\%Y=Jear;)\n".
                 "    \$Self->{DateFormat} = '$Self->{DateFormat}';\n".
                 "    \$Self->{DateFormatLong} = '$Self->{DateFormatLong}';\n".
                 "    \$Self->{DateInputFormat} = '$Self->{DateInputFormat}';\n\n".
                 "    \%Hash = (";
        foreach my $Screen (sort keys %Screens) {
            my %Words = %{$Screens{$Screen}};
            if ($Screen) {
                $Data .= "\n    # Template: $Screen\n";
                foreach my $Key (sort {uc($a) cmp uc($b)} keys %Words) {
                    if (!$UniqWords{$Key} && $Key) {
                        $UniqWords{$Key} = 1;
                        my $QuoteKey = $Key;
                        $QuoteKey =~ s/'/\\'/g;
                        if (defined $Words{$Key}) {
                            $Words{$Key} =~ s/'/\\'/g;   
                        }
                        else {
                            $Words{$Key} = '';
                        }
                        $Data .= "      '$QuoteKey' => '$Words{$Key}',\n";
                    }
                }
            }
        }
        $Data .= "\n    # Misc\n";
        foreach my $Key (sort keys %{$Self->{Translation}}) {
            if (!$UniqWords{$Key} && $Key && $Self->{Translation}->{$Key} !~ /HASH\(/) {
                $UniqWords{$Key} = 1;
                my $QuoteKey = $Key;
                $QuoteKey =~ s/'/\\'/g;
                if (defined $Self->{Translation}->{$Key}) {
                    $Self->{Translation}->{$Key} =~ s/'/\\'/g;
                }
                else {
                    $Self->{Translation}->{$Key} = '';
                }
                $Data .= "      '$QuoteKey' => '$Self->{Translation}->{$Key}',\n";
            }
        }
        $Data .= "    );\n";
        return $Data;
    }
}
# --

1;
