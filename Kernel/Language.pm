# --
# Kernel/Language.pm - provides multi language support
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language;

use strict;
use warnings;

use vars qw(@ISA);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Time',
);

my @DAYS = qw/Sun Mon Tue Wed Thu Fri Sat/;
my @MONS = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;

=head1 NAME

Kernel::Language - global language interface

=head1 SYNOPSIS

All language functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a language object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::Language' => {
            UserLanguage => 'de',
        },
    );
    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # 0=off; 1=on; 2=get all not translated words; 3=get all requests
    $Self->{Debug} = 0;

    # get needed object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    # check if LanguageDebug is configured
    if ( $ConfigObject->Get('LanguageDebug') ) {
        $Self->{LanguageDebug} = 1;
    }

    # user language
    $Self->{UserLanguage} = $Param{UserLanguage}
        || $ConfigObject->Get('DefaultLanguage')
        || 'en';

    # check if language is configured
    my %Languages = %{ $ConfigObject->Get('DefaultUsedLanguages') };
    if ( !$Languages{ $Self->{UserLanguage} } ) {
        $Self->{UserLanguage} = 'en';
    }

    # take time zone
    $Self->{TimeZone} = $Param{UserTimeZone} || $Param{TimeZone} || 0;

    # Debug
    if ( $Self->{Debug} > 0 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'Debug',
            Message  => "UserLanguage = $Self->{UserLanguage}",
        );
    }

    # load text catalog ...
    if ( !$MainObject->Require("Kernel::Language::$Self->{UserLanguage}") ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'Debug',
                Message  => "Kernel::Language::$Self->{UserLanguage} load ... done.",
            );
        }
    }

    # load action text catalog ...
    my $CustomTranslationModule = '';

    # do not include addition translation files, a new translation file gets created
    if ( !$Param{TranslationFile} ) {

        # looking to addition translation files
        my $Home  = $ConfigObject->Get('Home') . '/';
        my @Files = $MainObject->DirectoryRead(
            Directory => $Home . "Kernel/Language/",
            Filter    => "$Self->{UserLanguage}_*.pm",
        );
        FILE:
        for my $File (@Files) {

            # get module name based on file name
            $File =~ s/^$Home(.*)\.pm$/$1/g;
            $File =~ s/\/\//\//g;
            $File =~ s/\//::/g;

            # ignore language translation files like (en_GB, en_CA, ...)
            next FILE if $File =~ /.._..$/;

            # remember custom files to load at least
            if ( $File =~ /_Custom$/ ) {
                $CustomTranslationModule = $File;
                next FILE;
            }

            # load translation module
            if ( !$MainObject->Require($File) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'Error',
                    Message  => "Sorry, can't load $File! " . "Check the $File (perl -cw)!",
                );
                next FILE;
            }

            # add module to ISA
            @ISA = ($File);

            # execute translation map
            if ( eval { $Self->Data() } ) {

                # debug info
                if ( $Self->{Debug} > 0 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'Debug',
                        Message  => "$File load ... done.",
                    );
                }
            }
        }

        # load custom text catalog ...
        if ( $CustomTranslationModule && $MainObject->Require($CustomTranslationModule) ) {

            # add module to ISA
            @ISA = ($CustomTranslationModule);

            # execute translation map
            if ( eval { $Self->Data() } ) {

                # debug info
                if ( $Self->{Debug} > 0 ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'Debug',
                        Message  => "Kernel::Language::$Self->{UserLanguage}_Custom load ... done.",
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

=item Translate()

translate a text with placeholders.

        my $Text = $LanguageObject->Translate('Hello %s!', 'world');

=cut

sub Translate {
    my ( $Self, $Text, @Parameters ) = @_;

    $Text //= '';

    $Text = $Self->{Translation}->{$Text} || $Text;

    return $Text if !@Parameters;

    for ( 0 .. $#Parameters ) {
        return $Text if !defined $Parameters[$_];
        $Text =~ s/\%(s|d)/$Parameters[$_]/;
    }

    return $Text;
}

=item Get()

WARNING: THIS METHOD IS DEPRECATED AND WILL BE REMOVED IN FUTURE VERSION OF OTRS! USE Translate() INSTEAD.

Translate a string.

    my $Text = $LanguageObject->Get('Hello');

    Example: (the quoting looks strange, but is in fact correct!)

    my $String = 'History::NewTicket", "2011031110000023", "Postmaster", "3 normal", "open", "9';

    my $TranslatedString = $LanguageObject->Translate( $String );

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
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'Debug',
                Message  => "->Get('$What') = ('$Self->{Translation}->{$What}').",
            );
        }

        my $Text = $Self->{Translation}->{$What};
        if (@Dyn) {
            COUNT:
            for ( 0 .. $#Dyn ) {

                # be careful $Dyn[$_] can be 0! bug#3826
                last COUNT if !defined $Dyn[$_];

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'debug',
            Message  => "->Get('$What') Is not translated!!!",
        );
    }

    if ( $Self->{LanguageDebug} ) {
        print STDERR "No translation available for '$What'\n";
    }

    if (@Dyn) {
        COUNT:
        for ( 0 .. $#Dyn ) {

            # be careful $Dyn[$_] can be 0! bug#3826
            last COUNT if !defined $Dyn[$_];

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

formats a timestamp according to the specified date format for the current
language (locale).

    my $Date = $LanguageObject->FormatTimeString(
        '2009-12-12 12:12:12',  # timestamp
        'DateFormat',           # which date format to use, e. g. DateFormatLong
        0,                      # optional, hides the seconds from the time output
    );

Please note that the TimeZone will not be applied in the case of DateFormatShort (date only)
to avoid switching to another date.

If you only pass an ISO date ('2009-12-12'), it will be returned unchanged.
Invalid strings will also be returned with an error logged.

=cut

sub FormatTimeString {
    my ( $Self, $String, $Config, $Short ) = @_;

    return '' if !$String;

    $Config ||= 'DateFormat';
    $Short  ||= 0;

    # Valid timestamp
    if ( $String =~ /(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})/ ) {
        my ( $Y, $M, $D, $h, $m, $s ) = ( $1, $2, $3, $4, $5, $6 );
        my $WD;    # day of week

        my $ReturnString = $Self->{$Config} || "$Config needs to be translated!";

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        my $TimeStamp = $TimeObject->TimeStamp2SystemTime( String => "$Y-$M-$D $h:$m:$s", );

        # Add user time zone diff, but only if we actually display the time!
        # Otherwise the date might be off by one day because of the TimeZone diff.
        if ( $Self->{TimeZone} && $Config ne 'DateFormatShort' ) {
            $TimeStamp = $TimeStamp + ( $Self->{TimeZone} * 60 * 60 );
        }

        ( $s, $m, $h, $D, $M, $Y, $WD ) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeStamp,
        );

        if ($Short) {
            $ReturnString =~ s/\%T/$h:$m/g;
        }
        else {
            $ReturnString =~ s/\%T/$h:$m:$s/g;
        }
        $ReturnString =~ s/\%D/$D/g;
        $ReturnString =~ s/\%M/$M/g;
        $ReturnString =~ s/\%Y/$Y/g;

        $ReturnString =~ s{(\%A)}{defined $WD ? $Self->Get($DAYS[$WD]) : '';}egx;
        $ReturnString
            =~ s{(\%B)}{(defined $M && $M =~ m/^\d+$/) ? $Self->Get($MONS[$M-1]) : '';}egx;

        if ( $Self->{TimeZone} && $Config ne 'DateFormatShort' ) {
            return $ReturnString . " ($Self->{TimeZone})";
        }
        return $ReturnString;
    }

    # Invalid string passed? (don't log for ISO dates)
    if ( $String !~ /^(\d{2}:\d{2}:\d{2})$/ ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "No FormatTimeString() translation found for '$String' string!",
        );
    }

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

These tags are supported: %A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;

Note that %A only works correctly with Action GET, it might be dropped otherwise.

Also note that it is also possible to pass HTML strings for date input:

    $TimeLong = $LanguageObject->Time(
        Action => 'RETURN',
        Format => 'DateInputFormatLong',
        Mode   => 'NotNumeric',
        Year   => '<input value="2014"/>',
        Month  => '<input value="1"/>',
        Day    => '<input value="10"/>',
        Hour   => '<input value="11"/>',
        Minute => '<input value="12"/>',
        Second => '<input value="13"/>',
    );

Note that %B may not work in NonNumeric mode.

=cut

sub Time {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Action Format)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }
    my $ReturnString = $Self->{ $Param{Format} } || 'Need to be translated!';
    my ( $s, $m, $h, $D, $M, $Y, $WD, $YD, $DST );

    # set or get time
    if ( lc $Param{Action} eq 'get' ) {

        # get time object
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

        ( $s, $m, $h, $D, $M, $Y, $WD, $YD, $DST ) = $TimeObject->SystemTime2Date(
            SystemTime => $TimeObject->SystemTime(),
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
        $ReturnString =~ s{(\%A)}{defined $WD ? $Self->Get($DAYS[$WD]) : '';}egx;
        $ReturnString
            =~ s{(\%B)}{(defined $M && $M =~ m/^\d+$/) ? $Self->Get($MONS[$M-1]) : '';}egx;
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
