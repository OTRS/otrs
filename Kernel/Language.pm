# --
# Kernel/Language.pm - provides multi language support
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Language.pm,v 1.10 2002-11-21 22:22:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language;

use strict;

use vars qw(@ISA $VERSION);

$VERSION = '$Revision: 1.10 $';
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

    # 0=off; 1=on; 2=get all not translated words; 3=get all requests
    $Self->{Debug} = 0;

    # user language
    $Self->{UserLanguage} = $Param{UserLanguage} || 'English';

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

    return $Self;
}
# --
sub Get {
    my $Self = shift;
    my $What = shift;
    my $File = shift || '';
    my @Dyn = ();
    # --
    # check dyn spaces
    # --
    if ($What && $What =~ /^(.+?)", "(.+?|)$/) {
        $What = $1;
        @Dyn = split(/", "/, $2);
    }
    # compat
    if ($Self->{$What}) {
#        $Self->{Translation}->{$What} = $Self->{$What};
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
            $Self->{Translation}->{$What} =~ s/\%(s|d)/$Dyn[$_]/ if (defined $Dyn[$_]);
        }
        return $Self->{Translation}->{$What};
    }
    else {
        # warn if the value is not def
        if ($Self->{Debug} > 1) {
          $Self->{LogObject}->Log(
            Priority => 'error',
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
sub DESTROY {
    my $Self = shift;

    if (!$Self->{ConfigObject}->Get('WriteNewTranslationFile')) {
        return 1;
    }

    if ($Self->{UsedWords}) {
        my %UniqWords = ();
        my %Screens = %{$Self->{UsedWords}};
        print STDERR "Write /tmp/$Self->{UserLanguage}.pm!\n";
        open (TEMPLATEOUT, "> /tmp/$Self->{UserLanguage}.pm") || die "Can't write .pm: $!";
        print TEMPLATEOUT "# --\n";
        print TEMPLATEOUT "# Kernel/Language/$Self->{UserLanguage}.pm - provides $Self->{UserLanguage} language translation\n";
        print TEMPLATEOUT "# Copyright (C) 2002 ??? <???>\n";
        print TEMPLATEOUT "# --\n";
        print TEMPLATEOUT "# \$Id: Language.pm,v 1.10 2002-11-21 22:22:12 martin Exp $\n";
        print TEMPLATEOUT "# --\n";
        print TEMPLATEOUT "# This software comes with ABSOLUTELY NO WARRANTY. For details, see\n";
        print TEMPLATEOUT "# the enclosed file COPYING for license information (GPL). If you\n";
        print TEMPLATEOUT "# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.\n";
        print TEMPLATEOUT "# --\n";
        print TEMPLATEOUT "package Kernel::Language::$Self->{UserLanguage};\n";
        print TEMPLATEOUT "\n";
        print TEMPLATEOUT "use strict;\n";
        print TEMPLATEOUT "\n";
        print TEMPLATEOUT "use vars qw(\$VERSION);\n";
        print TEMPLATEOUT "\$VERSION = '\$Revision: 1.10 $';\n";
        print TEMPLATEOUT '$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;';
        print TEMPLATEOUT "\n";
        print TEMPLATEOUT "# --\n";
        print TEMPLATEOUT "sub Data {\n";
        print TEMPLATEOUT "    my \$Self = shift;\n";
        print TEMPLATEOUT "    my \%Param = \@_;\n";
        print TEMPLATEOUT "    my \%Hash = ();\n";
        print TEMPLATEOUT "\n";
        print TEMPLATEOUT "    # possible charsets\n";
        print TEMPLATEOUT "    \$Self->{Charset} = [";
        if ($Self->{Charset}) {
            foreach (@{$Self->{Charset}}) {
                print TEMPLATEOUT "'$_', ";
            }
        }
        print TEMPLATEOUT "];\n";
#        print TEMPLATEOUT "\n";

        foreach my $Screen (sort keys %Screens) {
            my %Words = %{$Screens{$Screen}};
            if ($Screen) {
                print TEMPLATEOUT "\n    # Template: $Screen\n";
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
#                        print TEMPLATEOUT "    \$Self->{T}->{'$Key'} = '$Words{$Key}';\n";
                        print TEMPLATEOUT "    \$Hash{'$QuoteKey'} = '$Words{$Key}';\n";
                    }
                }
            }
        }

        print TEMPLATEOUT "\n    # Misc\n";
#        foreach my $Key (sort keys %{$Self->{Translation}}) {
        foreach my $Key (sort keys %{$Self}) {
#            if (!$UniqWords{$Key} && $Key && $Self->{Translation}->{$Key} !~ /HASH\(/) {
            if (!$UniqWords{$Key} && $Key && $Self->{$Key} !~ /HASH\(/) {
                $UniqWords{$Key} = 1;
                my $QuoteKey = $Key;
                $QuoteKey =~ s/'/\\'/g;
#                $Key =~ s/'/\\'/g;
                if (defined $Self->{$Key}) {
#                if (defined $Self->{Translation}->{$Key}) {
                    $Self->{$Key} =~ s/'/\\'/g;
                }
                else {
                    $Self->{$Key} = '';
                }
#                print TEMPLATEOUT "    \$Self->{'$Key'} = '$Self->{$Key}';\n";
#                print TEMPLATEOUT "    \$Hash{'$QuoteKey'} = '$Self->{Translation}->{$Key}';\n";
                print TEMPLATEOUT "    \$Hash{'$QuoteKey'} = '$Self->{$Key}';\n";
            }
        }

        print TEMPLATEOUT "\n";
        print TEMPLATEOUT "    \$Self->{Translation} = \\\%Hash;\n";
        print TEMPLATEOUT "\n";
        print TEMPLATEOUT "}\n";
        print TEMPLATEOUT "# --\n";
        print TEMPLATEOUT "1;\n";
        close (TEMPLATEOUT);
    }
 
}
# --

1;

