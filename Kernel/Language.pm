# --
# Kernel/Language.pm - provides multi language support
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Language.pm,v 1.42 2007-01-30 17:49:56 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language;

use strict;
use Kernel::System::Encode;
use Kernel::System::Time;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.42 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::Language - global language interface

=head1 SYNOPSIS

All language functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a language object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::Langauge;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );

    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );

    my $LangaugeObject = Kernel::Langauge->new(
        MainObject => $MainObject,
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        UserLanguage => 'de',
    );

=cut

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
    # check needed objects
    foreach (qw(ConfigObject LogObject MainObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    # encode object
    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);
    # time object
    $Self->{TimeObject} = Kernel::System::Time->new(%Param);
    # 0=off; 1=on; 2=get all not translated words; 3=get all requests
    $Self->{Debug} = 0;
    # user language
    $Self->{UserLanguage} = $Param{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage') || 'en';
    $Self->{TimeZone} = $Param{UserTimeZone} || $Param{TimeZone} || 0;
    # Debug
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
    # load action text catalog ...
    if (!$Param{TranslationFile}) {
        my $Home = $Self->{ConfigObject}->Get('Home').'/';
        my @Files = glob($Home."Kernel/Language/$Self->{UserLanguage}_*.pm");
        foreach my $File (@Files) {
            if ($File =~ /_Custom.pm$/) {
                next;
            }
            $File =~ s/^$Home(.*)\.pm$/$1/g;
            $File =~ s/\/\//\//g;
            $File =~ s/\//::/g;
            if ($Self->{MainObject}->Require($File)) {
                @ISA = ($File);
                $Self->Data();
                if ($Self->{Debug} > 0) {
                    $Self->{LogObject}->Log(
                        Priority => 'Debug',
                        Message => "$File load ... done."
                    );
                }
            }
        }
    }
    # load custom text catalog ...
    if (!$Param{TranslationFile} && eval "require Kernel::Language::$Self->{UserLanguage}_Custom") {
        @ISA = ("Kernel::Language::$Self->{UserLanguage}_Custom");
        $Self->Data();
        if ($Self->{Debug} > 0) {
            $Self->{LogObject}->Log(
                Priority => 'Debug',
                Message => "Kernel::Language::$Self->{UserLanguage}_Custom load ... done."
            );
        }
    }
    # if no return charset is given, use recommended return charset
    if (!$Self->{ReturnCharset}) {
        $Self->{ReturnCharset} = $Self->GetRecommendedCharset();
    }
    # get source file charset
    # what charset shoud I use (take it from translation file)!
    if ($Self->{Charset}) {
        my @Chatsets = @{$Self->{Charset}};
        $Self->{TranslationCharset} = $Chatsets[$#Chatsets];
    }
    return $Self;
}

=item Get()

Translate a words.

  my $Text = $LanguageObject->Get('Hello');

=cut

sub Get {
    my $Self = shift;
    my $What = shift;
    my $File = shift || '';
    my @Dyn = ();
    # check
    if (! defined $What) {
        return;
    }
    # check dyn spaces
    if ($What && $What =~ /^(.+?)", "(.+?|)$/) {
        $What = $1;
        @Dyn = split(/", "/, $2);
    }
    # check wanted param and returns the
    # lookup or the english data
    if (exists $Self->{Translation}->{$What} && $Self->{Translation}->{$What} ne '') {
        # Debug
        if ($Self->{Debug} > 3) {
            $Self->{LogObject}->Log(
              Priority => 'Debug',
              Message => "->Get('$What') = ('$Self->{Translation}->{$What}').",
            );
        }
        # charset convert from source translation into shown charset
        if (!$Self->{TranslationConvert}->{$What}) {
            # remember that charset convert is already done
            $Self->{TranslationConvert}->{$What} = 1;
            # convert it
            $Self->{Translation}->{$What} = $Self->CharsetConvert(
                Text => $Self->{Translation}->{$What},
                From => $Self->{TranslationCharset},
            );
        }
        my $Text = $Self->{Translation}->{$What};
        foreach (0..3) {
            if (defined $Dyn[$_]) {
                if ($Dyn[$_] =~ /Time\((.*)\)/) {
                    $Dyn[$_] = $Self->Time(
                        Action => 'GET',
                        Format => $1,
                    );
                    $Text =~ s/\%(s|d)/$Dyn[$_]/;
                }
                else {
                    $Text =~ s/\%(s|d)/$Dyn[$_]/;
                }
            }
        }
        return $Text;
    }
    else {
        # warn if the value is not def
        if ($Self->{Debug} > 1) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message => "->Get('$What') Is not translated!!!",
            );
        }
        foreach (0..3) {
            if (defined $Dyn[$_]) {
                if ($Dyn[$_] =~ /Time\((.*)\)/) {
                    $Dyn[$_] = $Self->Time(
                        Action => 'GET',
                        Format => $1,
                    );
                    $What =~ s/\%(s|d)/$Dyn[$_]/;
                }
                else {
                    $What =~ s/\%(s|d)/$Dyn[$_]/;
                }
            }
        }
        return $What;
    }
}

=item FormatTimeString()

Get date format in used language formate (based on translation file).

  my $Date = $LanguageObject->FormatTimeString('2005-12-12 12:12:12', 'DateFormat');

=cut

sub FormatTimeString {
    my $Self = shift;
    my $String = shift || return;
    my $Config = shift || 'DateFormat';
    my $Short  = shift || 0;
    my $ReturnString = $Self->{$Config} || "$Config needs to be translated!";
    if ($String =~ /(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d:\d\d:\d\d)/) {
        my ($Y,$M,$D, $T) = ($1, $2, $3, $4);
        # add user time zone diff
        if ($Self->{TimeZone}) {
            my $TimeStamp = $Self->{TimeObject}->TimeStamp2SystemTime(
                String => "$Y-$M-$D $T",
            );
            $TimeStamp = $TimeStamp + ($Self->{TimeZone}*60*60);
            my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $TimeStamp,
            );
            ($Y,$M,$D, $T) = ($Year, $Month, $Day, "$Hour:$Min:$Sec");
        }

        if ($Short) {
            $T =~ s/(\d\d:\d\d):\d\d/$1/g;
        }
        $ReturnString =~ s/\%T/$T/g;
        $ReturnString =~ s/\%D/$D/g;
        $ReturnString =~ s/\%M/$M/g;
        $ReturnString =~ s/\%Y/$Y/g;
        if ($Self->{TimeZone}) {
            return $ReturnString ." ($Self->{TimeZone})";
        }
        else {
            return $ReturnString;
        }
    }
    elsif ($String =~ /^(\d\d:\d\d:\d\d)$/) {
        return $String;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "No FormatTimeString() translation found for '$String' string!",
        );
        return $String;
    }
}

=item GetRecommendedCharset()

Returns the recommended charset for frontend (based on translation
file or from DefaultCharset (from Kernel/Config.pm) is utf-8).

  my $Charset = $LanguageObject->GetRecommendedCharset().

=cut

sub GetRecommendedCharset {
    my $Self = shift;
    # should I use default frontend charset (e. g. utf-8)?
    if ($Self->{EncodeObject}->EncodeFrontendUsed()) {
        return $Self->{EncodeObject}->EncodeFrontendUsed();
    }
    # if not, what charset shoud I use (take it from translation file)?
    if ($Self->{Charset}) {
        my @Chatsets = @{$Self->{Charset}};
        return $Chatsets[$#Chatsets];
    }
    else {
        return $Self->{ConfigObject}->Get('DefaultCharset') || 'iso-8859-1';
    }
}

=item GetPossibleCharsets()

Returns an array of possible charsets (based on translation file).

  my @Charsets = $LanguageObject->GetPossibleCharsets().

=cut

sub GetPossibleCharsets {
    my $Self = shift;
    if ($Self->{Charset}) {
        return @{$Self->{Charset}};
    }
    else {
        return;
    }
}

=item Time()

Returns a time string in language formate (based on translation file).

    $Time = $LanguageObject->Time(
        Action => 'GET',
        Format => 'DateFormat',
    );

    $TimeLong = $LanguageObject->Time(
        Action => 'GET',
        Format => 'DateFormatLong',
    );

    $TimeLong = $LanguageObject->Time(
        Action => 'RETURN',
        Format => 'DateFormatLong',
        Year => 1977,
        Month => 10,
        Day => 27,
        Hour => 20,
        Minute => 10,
    );

=cut

sub Time {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Action Format)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $ReturnString = $Self->{$Param{Format}} || 'Need to be translated!';
    my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst);
    # set or get time
    if ($Param{Action} =~ /^GET$/i) {
        my @DAYS = qw/Sun Mon Tue Wed Thu Fri Sat/;
        my @MONS = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
    }
    elsif ($Param{Action} =~ /^RETURN$/i) {
        $m = $Param{Minute} || 0;
        $h = $Param{Hour} || 0;
        $D = $Param{Day} || 0;
        $M = $Param{Month} || 0;
        $Y = $Param{Year} || 0;
    }
    # do replace
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
    # return
    return $ReturnString;
}

=item CharsetConvert()

Converts charset from a source string (if no To is given, the the
GetRecommendedCharset() will be used).

  my $Text = $LanguageObject->CharsetConvert(
      Text => $String,
      From => 'iso-8859-15',
      To => 'utf-8',
  );

=cut

sub CharsetConvert {
    my $Self = shift;
    my %Param = @_;
    my $Text = defined $Param{Text} ? $Param{Text} : return;
    my $From = $Param{From} || return $Text;
    my $To = $Param{To} || $Self->{ReturnCharset} || return $Text;
    $From =~ s/'|"//g;
    # encode
    return $Self->{EncodeObject}->Convert(
        From => $From,
        To => $To,
        Text => $Text,
    );
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.42 $ $Date: 2007-01-30 17:49:56 $

=cut
