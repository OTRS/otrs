# --
# Kernel/Language.pm - provides multi language support
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language;

use strict;
use warnings;

use Kernel::System::Time;

use vars qw(@ISA $VERSION);

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
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::Language;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $LanguageObject = Kernel::Language->new(
        MainObject   => $MainObject,
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        UserLanguage => 'de',
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject MainObject EncodeObject)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    # time object
    $Self->{TimeObject} = Kernel::System::Time->new(%Param);

    # 0=off; 1=on; 2=get all not translated words; 3=get all requests
    $Self->{Debug} = 0;

    # check if LanguageDebug is configured
    if ( $Self->{ConfigObject}->Get('LanguageDebug') ) {
        $Self->{LanguageDebug} = 1;
    }

    # user language
    $Self->{UserLanguage} = $Param{UserLanguage}
        || $Self->{ConfigObject}->Get('DefaultLanguage')
        || 'en';

    # check if language is configured
    my %Languages = %{ $Self->{ConfigObject}->Get('DefaultUsedLanguages') };
    if ( !$Languages{ $Self->{UserLanguage} } ) {
        $Self->{UserLanguage} = 'en';
    }

    # take time zone
    $Self->{TimeZone} = $Param{UserTimeZone} || $Param{TimeZone} || 0;

    # Debug
    if ( $Self->{Debug} > 0 ) {
        $Self->{LogObject}->Log(
            Priority => 'Debug',
            Message  => "UserLanguage = $Self->{UserLanguage}",
        );
    }

    # load text catalog ...
    if ( !$Self->{MainObject}->Require("Kernel::Language::$Self->{UserLanguage}") ) {
        $Self->{LogObject}->Log(
            Priority => 'Error',
            Message  => "Sorry, can't locate or load Kernel::Language::$Self->{UserLanguage} "
                . "translation! Check the Kernel/Language/$Self->{UserLanguage}.pm (perl -cw)!",
        );
    }

    # add module to ISA
    @ISA = ("Kernel::Language::$Self->{UserLanguage}");

    # execute translation map
    if ( eval { $Self->Data() } ) {

        # debug info
        if ( $Self->{Debug} > 0 ) {
            $Self->{LogObject}->Log(
                Priority => 'Debug',
                Message  => "Kernel::Language::$Self->{UserLanguage} load ... done."
            );
        }
    }

    # load action text catalog ...
    my $CustomTranslationModule = '';

    # do not include addition translation files, a new translation file gets created
    if ( !$Param{TranslationFile} ) {

        # looking to addition translation files
        my $Home  = $Self->{ConfigObject}->Get('Home') . '/';
        my @Files = $Self->{MainObject}->DirectoryRead(
            Directory => $Home . "Kernel/Language/",
            Filter    => "$Self->{UserLanguage}_*.pm",
        );
        for my $File (@Files) {

            # get module name based on file name
            $File =~ s/^$Home(.*)\.pm$/$1/g;
            $File =~ s/\/\//\//g;
            $File =~ s/\//::/g;

            # ignore language translation files like (en_GB, en_CA, ...)
            next if $File =~ /.._..$/;

            # remember custom files to load at least
            if ( $File =~ /_Custom$/ ) {
                $CustomTranslationModule = $File;
                next;
            }

            # load translation module
            if ( !$Self->{MainObject}->Require($File) ) {
                $Self->{LogObject}->Log(
                    Priority => 'Error',
                    Message  => "Sorry, can't load $File! " . "Check the $File (perl -cw)!",
                );
                next;
            }

            # add module to ISA
            @ISA = ($File);

            # execute translation map
            if ( eval { $Self->Data() } ) {

                # debug info
                if ( $Self->{Debug} > 0 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'Debug',
                        Message  => "$File load ... done."
                    );
                }
            }
        }

        # load custom text catalog ...
        if ( $CustomTranslationModule && $Self->{MainObject}->Require($CustomTranslationModule) ) {

            # add module to ISA
            @ISA = ($CustomTranslationModule);

            # execute translation map
            if ( eval { $Self->Data() } ) {

                # debug info
                if ( $Self->{Debug} > 0 ) {
                    $Self->{LogObject}->Log(
                        Priority => 'Debug',
                        Message  => "Kernel::Language::$Self->{UserLanguage}_Custom load ... done."
                    );
                }
            }
        }
    }

    # if no return charset is given, use recommended return charset
    if ( !$Self->{ReturnCharset} ) {
        $Self->{ReturnCharset} = $Self->GetRecommendedCharset();
    }

    # get source file charset
    # what charset should I use (take it from translation file)!
    if ( $Self->{Charset} && ref $Self->{Charset} eq 'ARRAY' ) {
        $Self->{TranslationCharset} = $Self->{Charset}->[-1];
    }

    return $Self;
}

=item Get()

Translate a string.

    my $Text = $LanguageObject->Get('Hello');

    Example: (the quoting looks strange, but is in fact correct!)

    my $String = 'History::NewTicket", "2011031110000023", "Postmaster", "3 normal", "open", "9';

    my $TranslatedString = $LanguageObject->Get( $String );

=cut

sub Get {
    my ( $Self, $What ) = @_;

    # check
    return if !defined $What;
    return '' if $What eq '';

    # check dyn spaces
    my @Dyn;
    if ( $What && $What =~ /^(.+?)",\s{0,1}"(.*?)$/ ) {
        $What = $1;
        @Dyn = split( /",\s{0,1}"/, $2 );
    }

    # check wanted param and returns the
    # lookup or the english data
    if ( $Self->{Translation}->{$What} ) {

        # Debug
        if ( $Self->{Debug} > 3 ) {
            $Self->{LogObject}->Log(
                Priority => 'Debug',
                Message  => "->Get('$What') = ('$Self->{Translation}->{$What}').",
            );
        }

        # charset convert from source translation into shown charset
        if ( !$Self->{TranslationConvert}->{$What} ) {

            # remember that charset convert is already done
            $Self->{TranslationConvert}->{$What} = 1;

            # convert
            $Self->{Translation}->{$What} = $Self->{EncodeObject}->Convert(
                Text => $Self->{Translation}->{$What},
                From => $Self->{TranslationCharset},
                To   => $Self->{ReturnCharset},
            );
        }
        my $Text = $Self->{Translation}->{$What};
        if (@Dyn) {
            for ( 0 .. $#Dyn ) {

                # be careful $Dyn[$_] can be 0! bug#3826
                last if !defined $Dyn[$_];

                if ( $Dyn[$_] =~ /Time\((.*)\)/ ) {
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

    # warn if the value is not def
    if ( $Self->{Debug} > 1 ) {
        $Self->{LogObject}->Log(
            Priority => 'debug',
            Message  => "->Get('$What') Is not translated!!!",
        );
    }

    if ( $Self->{LanguageDebug} ) {
        print STDERR "No translation available for '$What'\n";
    }

    if (@Dyn) {
        for ( 0 .. $#Dyn ) {

            # be careful $Dyn[$_] can be 0! bug#3826
            last if !defined $Dyn[$_];

            if ( $Dyn[$_] =~ /Time\((.*)\)/ ) {
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

=item FormatTimeString()

Get date format in used language format (based on translation file).

    my $Date = $LanguageObject->FormatTimeString('2009-12-12 12:12:12', 'DateFormat');

=cut

sub FormatTimeString {
    my ( $Self, $String, $Config, $Short ) = @_;

    return '' if !$String;

    if ( !$Config ) {
        $Config = 'DateFormat';
    }
    if ( !$Short ) {
        $Short = 0;
    }

    my $ReturnString = $Self->{$Config} || "$Config needs to be translated!";
    if ( $String =~ /(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d:\d\d:\d\d)/ ) {
        my ( $Y, $M, $D, $T ) = ( $1, $2, $3, $4 );

        # Add user time zone diff, but only if we actually display the time!
        # Otherwise the date might be off by one day because of the TimeZone diff.
        if ( $Self->{TimeZone} && $Config ne 'DateFormatShort' ) {
            my $TimeStamp = $Self->{TimeObject}->TimeStamp2SystemTime( String => "$Y-$M-$D $T", );
            $TimeStamp = $TimeStamp + ( $Self->{TimeZone} * 60 * 60 );
            my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $TimeStamp,
            );
            ( $Y, $M, $D, $T ) = ( $Year, $Month, $Day, "$Hour:$Min:$Sec" );
        }

        if ($Short) {
            $T =~ s/(\d\d:\d\d):\d\d/$1/g;
        }
        $ReturnString =~ s/\%T/$T/g;
        $ReturnString =~ s/\%D/$D/g;
        $ReturnString =~ s/\%M/$M/g;
        $ReturnString =~ s/\%Y/$Y/g;
        if ( $Self->{TimeZone} && $Config ne 'DateFormatShort' ) {
            return $ReturnString . " ($Self->{TimeZone})";
        }
        return $ReturnString;
    }
    elsif ( $String =~ /^(\d\d:\d\d:\d\d)$/ ) {
        return $String;
    }

    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message  => "No FormatTimeString() translation found for '$String' string!",
    );

    return $String;

}

=item GetRecommendedCharset()

DEPRECATED. Don't use this function any more, 'utf-8' is always the internal charset.

Returns the recommended charset for frontend (based on translation
file or utf-8).

    my $Charset = $LanguageObject->GetRecommendedCharset().

=cut

sub GetRecommendedCharset {
    my $Self = shift;

    return 'utf-8';
}

=item GetPossibleCharsets()

Returns an array of possible charsets (based on translation file).

    my @Charsets = $LanguageObject->GetPossibleCharsets().

=cut

sub GetPossibleCharsets {
    my $Self = shift;

    return @{ $Self->{Charset} } if $Self->{Charset};
    return;
}

=item Time()

Returns a time string in language format (based on translation file).

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
        Year   => 1977,
        Month  => 10,
        Day    => 27,
        Hour   => 20,
        Minute => 10,
        Second => 05,
    );

=cut

sub Time {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Action Format)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $ReturnString = $Self->{ $Param{Format} } || 'Need to be translated!';
    my ( $s, $m, $h, $D, $M, $Y, $WD, $YD, $DST );

    # set or get time
    if ( lc $Param{Action} eq 'get' ) {
        my @DAYS = qw/Sun Mon Tue Wed Thu Fri Sat/;
        my @MONS = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        ( $s, $m, $h, $D, $M, $Y, $WD, $YD, $DST ) = $Self->{TimeObject}->SystemTime2Date(
            SystemTime => $Self->{TimeObject}->SystemTime(),
        );
    }
    elsif ( lc $Param{Action} eq 'return' ) {
        $s = $Param{Second} || 0;
        $m = $Param{Minute} || 0;
        $h = $Param{Hour}   || 0;
        $D = $Param{Day}    || 0;
        $M = $Param{Month}  || 0;
        $Y = $Param{Year}   || 0;
    }

    # do replace
    if ( ( lc $Param{Action} eq 'get' ) || ( lc $Param{Action} eq 'return' ) ) {
        my @DAYS = qw/Sun Mon Tue Wed Thu Fri Sat/;
        my @MONS = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
        my $Time = '';
        if ( $Param{Mode} && $Param{Mode} =~ /^NotNumeric$/i ) {
            if ( !$s ) {
                $Time = "$h:$m";
            }
            else {
                $Time = "$h:$m:$s";
            }
        }
        else {
            $Time = sprintf( "%02d:%02d:%02d", $h, $m, $s );
            $D    = sprintf( "%02d",           $D );
            $M    = sprintf( "%02d",           $M );
        }
        $ReturnString =~ s/\%T/$Time/g;
        $ReturnString =~ s/\%D/$D/g;
        $ReturnString =~ s/\%M/$M/g;
        $ReturnString =~ s/\%Y/$Y/g;
        $ReturnString =~ s/\%Y/$Y/g;
        $ReturnString =~ s{(\%A)}{$Self->Get($DAYS[$WD]);}egx;
        $ReturnString =~ s{(\%B)}{$Self->Get($MONS[$M-1]);}egx;
        return $ReturnString;
    }

    return $ReturnString;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

=cut
