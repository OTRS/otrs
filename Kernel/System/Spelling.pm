# --
# Kernel/System/Spelling.pm - the global spelling module
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Spelling;

use strict;
use warnings;

use Kernel::System::FileTemp;

=head1 NAME

Kernel::System::Spelling - spelling lib

=head1 SYNOPSIS

This module is the spellchecker backend wrapper of OTRS.
Currently, ispell and aspell are supported as spellchecker backends.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a spelling object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Spelling;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $SpellingObject = Kernel::System::Spelling->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug} = 0;

    # get needed objects
    for (qw(ConfigObject LogObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create file template object
    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    # spell checker config options
    $Self->{SpellChecker} = $Self->{ConfigObject}->Get('SpellCheckerBin') || 'ispell';

    return $Self;
}

=item Check()

spelling check for some text

    my %Result = $SpellingObject->Check(
        Text          => 'Some Text to check.',
        SpellLanguage => 'en',
    );

    # a result could be
    $Result{'SomeWordWithError'} = {
        Replace => [
            'SomeWord A',
            'SomeWord B',
            'SomeWord C',
        ],
        Line => 123,
    };

=cut

sub Check {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Text)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # default ignored words
    my @Ignore
        = qw(com org de net Cc www Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Sun Mon Tue Wed Thu Fri
        Sat Fwd Re DNS Date To Cc Bcc ca tm COM Co op netscape bcc jpg gif email Tel ie eg otrs suse redhat debian
        caldera php perl java html unsubscribe queue event day month year ticket
    );

    # add configured ignored words
    if ( ref $Self->{ConfigObject}->Get('SpellCheckerIgnore') eq 'ARRAY' ) {
        for ( @{ $Self->{ConfigObject}->Get('SpellCheckerIgnore') } ) {
            push @Ignore, $_;
        }
    }

    # don't correct emails
    $Param{Text} =~ s/<.+?\@.+?>//g;
    $Param{Text} =~ s/\s.+?\@.+?\s/ /g;

    # don't correct quoted text
    $Param{Text} =~ s/^>.*$//gm;

    # ispell encoding:
    if ( $Self->{SpellChecker} =~ /ispell/ ) {
        $Param{Text} =~ s/ä/a"/g;
        $Param{Text} =~ s/ö/o"/g;
        $Param{Text} =~ s/ü/u"/g;
        $Param{Text} =~ s/Ä/A"/g;
        $Param{Text} =~ s/Ö/O"/g;
        $Param{Text} =~ s/Ü/U"/g;
        $Param{Text} =~ s/ß/sS/g;
    }

    # check if spell checker exists in file system
    if ( !-e $Self->{ConfigObject}->Get('SpellCheckerBin') ) {
        $Self->{Error} = 1;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't find spellchecker ("
                . $Self->{ConfigObject}->Get('SpellCheckerBin') . "): $!",
        );
        return;
    }

    # add -a
    $Self->{SpellChecker} .= ' -a ';

    # set dict
    if ( $Param{SpellLanguage} ) {
        $Self->{SpellChecker} .= " -d $Param{SpellLanguage}";
    }

    # get spell output

    # write text to file and read it with (i|a)spell
    # - can't use IPC::Open* because it's not working with mod_perl* :-/
    my ( $FH, $TmpFile ) = $Self->{FileTempObject}->TempFile();
    if ( !$FH ) {
        $Self->{Error} = 1;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't write spell tmp text to $TmpFile: $!",
        );
        return;
    }

    $Self->{EncodeObject}->EncodeOutput( \$Param{Text} );
    print $FH $Param{Text};

    # aspell encoding
    if ( $Self->{SpellChecker} =~ /aspell/ ) {
        $Self->{SpellChecker} .= ' --encoding=utf-8';
    }

    # open spell checker
    my $Spell;
    if ( !open( $Spell, "-|", "$Self->{SpellChecker} < $TmpFile" ) ) {    ## no critic
        $Self->{Error} = 1;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't open spellchecker: $!",
        );
        return;
    }

    my $Output      = '';
    my $Lines       = 1;
    my $CurrentLine = 0;
    my %Data;
    while ( my $Line = <$Spell> ) {
        $CurrentLine++;

        # set utf8 stamp if running in utf8 mode
        $Self->{EncodeObject}->EncodeInput( \$Line );

        # ispell encoding:
        if ( $Self->{SpellChecker} =~ /ispell/ ) {
            $Line =~ s/a"/ä/g;
            $Line =~ s/o"/ö/g;
            $Line =~ s/u"/ü/g;
            $Line =~ s/A"/Ä/g;
            $Line =~ s/O"/Ö/g;
            $Line =~ s/U"/Ü/g;
            $Line =~ s/sS/ß/g;
        }

        # '#' words with no suggestions
        if ( $Line =~ /^# (.+?) .+?$/ ) {
            $Data{$CurrentLine} = {
                Word    => $1,
                Replace => '',
                Line    => $Lines,
            };
        }

        # '&' words with suggestions
        elsif ( $Line =~ /^& (.+?) .+?: (.*)$/ ) {
            my @Replace = split /, /, $2;
            $Data{$CurrentLine} = {
                Word    => $1,
                Replace => \@Replace,
                Line    => $Lines,
            };
        }

        # increase line count
        elsif ( $Line =~ /^\n$/ ) {
            $Lines++;
        }
    }

    # drop double words and add line of double word
    my %DoubleWords;
    for ( sort { $a <=> $b } keys %Data ) {
        if ( $DoubleWords{ $Data{$_}->{Word} } ) {
            $DoubleWords{ $Data{$_}->{Word} }->{Line} .= "/" . $Data{$_}->{Line};
            delete $Data{$_};
        }
        else {
            $DoubleWords{ $Data{$_}->{Word} } = $Data{$_};
        }
    }

    # remove ignored words
    for my $Word ( sort keys %Data ) {
        for my $IgnoreWord (@Ignore) {
            if (
                defined $Data{$Word}
                && $Data{$Word}->{Word}
                && $Data{$Word}->{Word} =~ /^$IgnoreWord$/i
                )
            {
                delete $Data{$Word};
            }
        }
    }
    close($Spell);
    return %Data;
}

=item Error()

check if spelling check returns a system error (read log backend for error message)

    my $TrueIfErro = $SpellObject->Error();

=cut

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error};
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
