# --
# Kernel/System/Spelling.pm - the global spellinf module
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Spelling.pm,v 1.4 2003-02-08 15:09:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Spelling;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    $Self->{Debug} = 0;

    # --
    # get needed objects
    # --
    foreach (qw(ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SpellChecker} = $Self->{ConfigObject}->Get('SpellChecker') || 'ispell';
    $Self->{SpellChecker} .= ' -a ';

    return $Self;
}
# --
sub Ckeck {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Text)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # get needed dict
    # --
    my %Languages = ( 'english' => 'English', 'deutsch' => 'German' );
    if ($Param{SpellLanguage}) {
        foreach (keys %Languages) {
            if ($Param{SpellLanguage} =~ /^$Languages{$_}$/i) {
                $Self->{SpellChecker} .= " -d $_";    
            }
        }
    }
    # --
    # ignored words
    # --
    my @Ignore = qw(com org de net Cc www Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec 
      Fwd DNS http CC ca html tm COM mmunity Co op https netscape webmail bcc jpg gif 
      email Tel ie eg otrs suse redhat debian caldera php perl java unsubscribe);
    # don't correct emails
    $Param{Text} =~ s/<.+?\@.+?>//g;
    $Param{Text} =~ s/\s.+?\@.+?\s/ /g;
    # don't correct quoted text
    $Param{Text} =~ s/^>.*$//gm;
    # --
    # get spell output
    # --
    if (open (SPELL, "echo \"$Param{Text}\" | $Self->{SpellChecker} |")) {
        my $Output = '';
        my %Data = ();
        my $Lines = 1;
        my $CurrentLine = 0;
        while (<SPELL>) {
            $CurrentLine++;
            if ($_ =~ /^# (.+?) .+?$/) {
                $Data{$CurrentLine} = {
                    Word => $1, 
                    Replace => '', 
                    Line => $Lines,
                };
            }
            elsif ($_ =~ /^& (.+?) .+?: (.*)$/) {
                my @Replace = split(/, /, $2);
                $Data{$CurrentLine} = {
                    Word => $1, 
                    Replace => \@Replace, 
                    Line => $Lines,
                };
            }
            elsif ($_ =~ /^\n$/) {
                $Lines++;
            }
        }
        # --
        # drop double words and add line of double word
        # --
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
        # --
        # remove ignored words
        # --
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
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't open spell: $!");
        return;
    } 

    
}
# --


1;
