# --
# Kernel/System/Spelling.pm - the global spelling module
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Spelling.pm,v 1.14 2006-08-29 17:30:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Spelling;

use strict;
use Kernel::System::FileTemp;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = 0;

    # get needed objects
    foreach (qw(ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create file template object
    $Self->{FileTempObject} = Kernel::System::FileTemp->new(%Param);

    # spell checker config options
    $Self->{SpellChecker} = $Self->{ConfigObject}->Get('SpellCheckerBin') || 'ispell';
    $Self->{SpellChecker} .= ' -a ';

    return $Self;
}
# --
sub Check {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Text)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get needed dict
    if ($Param{SpellLanguage}) {
        $Self->{SpellChecker} .= " -d $Param{SpellLanguage}";
    }
    # default ignored words
    my @Ignore = qw(com org de net Cc www Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Sun Mon Tue Wed Thu Fri Sat Fwd Re DNS Date To Cc Bcc ca tm COM Co op netscape bcc jpg gif email Tel ie eg otrs suse redhat debian caldera php perl java html unsubscribe queue event day month year ticket);
    # add configured ignored words
    if (ref($Self->{ConfigObject}->Get('SpellCheckerIgnore')) eq 'ARRAY') {
        foreach (@{$Self->{ConfigObject}->Get('SpellCheckerIgnore')}) {
            push (@Ignore, $_);
        }
    }
    # don't correct emails
    $Param{Text} =~ s/<.+?\@.+?>//g;
    $Param{Text} =~ s/\s.+?\@.+?\s/ /g;
    # don't correct quoted text
    $Param{Text} =~ s/^>.*$//gm;
    # ÄÖÜäöü? (just do encoding for ispell)
    if ($Self->{SpellChecker} =~ /ispell/) {
        $Param{Text} =~ s/ä/a"/g;
        $Param{Text} =~ s/ö/o"/g;
        $Param{Text} =~ s/ü/u"/g;
        $Param{Text} =~ s/Ä/A"/g;
        $Param{Text} =~ s/Ö/O"/g;
        $Param{Text} =~ s/Ü/U"/g;
        $Param{Text} =~ s/ß/sS/g;
    }
    # --
    # get spell output
    # --
    # write text to file and read it with (i|a)spell
    # - can't use IPC::Open* because it's not working with mod_perl* :-/
    my ($FH, $TmpFile) = $Self->{FileTempObject}->TempFile();
    if ($FH) {
        print $FH $Param{Text};
    }
    else {
        $Self->{Error} = 1;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't write spell tmp text to $TmpFile: $!",
        );
        return;
    }
    if (open (SPELL, "$Self->{SpellChecker} < $TmpFile |")) {
        my $Output = '';
        my %Data = ();
        my $Lines = 1;
        my $CurrentLine = 0;
        while (my $Line = <SPELL>) {
            $CurrentLine++;
            # ÄÖÜäöü? (just do encoding for ispell)
            if ($Self->{SpellChecker} =~ /ispell/) {
                $Line =~ s/a"/ä/g;
                $Line =~ s/o"/ö/g;
                $Line =~ s/u"/ü/g;
                $Line =~ s/A"/Ä/g;
                $Line =~ s/O"/Ö/g;
                $Line =~ s/U"/Ü/g;
                $Line =~ s/sS/ß/g;
            }
            if ($Line =~ /^# (.+?) .+?$/) {
                $Data{$CurrentLine} = {
                    Word => $1,
                    Replace => '',
                    Line => $Lines,
                };
            }
            elsif ($Line =~ /^& (.+?) .+?: (.*)$/) {
                my @Replace = split(/, /, $2);
                $Data{$CurrentLine} = {
                    Word => $1,
                    Replace => \@Replace,
                    Line => $Lines,
                };
            }
            elsif ($Line =~ /^\n$/) {
                $Lines++;
            }
        }
        # drop double words and add line of double word
        my %DoubleWords;
        foreach (sort {$a <=> $b} keys %Data) {
            if ($DoubleWords{$Data{$_}->{Word}}) {
                $DoubleWords{$Data{$_}->{Word}}->{Line} .= "/".$Data{$_}->{Line};
                delete $Data{$_};
            }
            else {
                $DoubleWords{$Data{$_}->{Word}} = $Data{$_};
            }
        }
        # remove ignored words
        foreach (sort keys %Data) {
            foreach my $IgnoreWord (@Ignore) {
                if ($Data{$_}->{Word} && $Data{$_}->{Word} =~ /^$IgnoreWord$/i) {
                    delete $Data{$_};
                }
            }
        }
        close (SPELL);
        return %Data;
    }
    else {
        $Self->{Error} = 1;
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't open spell: $!",
        );
        return;
    }
}
# --
sub Error {
    my $Self = shift;
    my %Param = @_;
    return $Self->{Error};
}
# --
1;
