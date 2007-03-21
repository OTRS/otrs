# --
# Kernel/Modules/AdminPerformanceLog.pm - provides a log view for admins
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AdminPerformanceLog.pm,v 1.6 2007-03-21 14:36:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminPerformanceLog;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject LayoutObject LogObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;

    # performance log is enabled
    if ($Self->{ConfigObject}->Get('PerformanceLog')) {
        $Self->{LayoutObject}->Block(
            Name => 'Enabled',
            Data => {
                %Param,
            },
        );
    }
    # performance log is disabled
    else {
        $Self->{LayoutObject}->Block(
            Name => 'Disabled',
            Data => {
                %Param,
            },
        );
    }

    # reset log file
    if ($Self->{Subaction} eq 'Reset') {
        my $File = $Self->{ConfigObject}->Get('PerformanceLog::File');
        if (!unlink $File) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't unlink $File: $!",
            );
            $Self->{LayoutObject}->FatalError();
        }
        else {
            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$Self->{Action}",
            );
        }
    }
    # show overview
    else {
        # get avarage times
        my @Data = ();
        if ($Self->{ConfigObject}->Get('PerformanceLog')) {
            my $File = $Self->{ConfigObject}->Get('PerformanceLog::File');
            # check file size
            my $FileSize = -s $File;
            if ($FileSize > (1024*1024*$Self->{ConfigObject}->Get('PerformanceLog::FileMax'))) {
                $Self->{LayoutObject}->Block(
                    Name => 'Reset',
                    Data => {
                        Size => sprintf "%.1f MBytes", ($FileSize/(1024*1024)),
                    },
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminPerformanceLog',
                    Data => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                if (open(IN, "< $File")) {
                    while (<IN>) {
                        my $Line = $_;
                        my @Row = split(/::/, $Line);
                        push (@Data, \@Row);
                    }
                    close (IN);
                }
                else {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Can't open $File: $!",
                    );
                }
            }
        }
        foreach my $Minute (5, 30, 60, 2*60, 24*60, 2*24*60) {
            my %Count = ();
            my %Action = ();
            my %Sum = ();
            my %Max = ();
            my %Min = ();
            foreach my $Row (reverse @Data) {
                if ($Row->[0] > time()-(60*$Minute)) {
                    # whole
                    $Count{$Row->[1]}++;
                    if ($Sum{$Row->[1]}) {
                        $Sum{$Row->[1]} = $Sum{$Row->[1]} + $Row->[2];
                    }
                    else {
                        $Sum{$Row->[1]} = $Row->[2];
                    }
                    if (!defined($Max{$Row->[1]})) {
                        $Max{$Row->[1]} = $Row->[2];
                    }
                    elsif ($Max{$Row->[1]} < $Row->[2]) {
                        $Max{$Row->[1]} = $Row->[2];
                    }
                    if (!defined($Min{$Row->[1]})) {
                        $Min{$Row->[1]} = $Row->[2];
                    }
                    elsif ($Min{$Row->[1]} > $Row->[2]) {
                        $Min{$Row->[1]} = $Row->[2];
                    }
                    # for each action
                    if ($Row->[4] =~ /^(.+?|)Action=(.+?)(&.*|)$/) {
                        my $Module = $2;
                        $Action{$Module}->{Count}->{$Row->[1]}++;
                        if ($Action{$Module}->{Sum}->{$Row->[1]}) {
                            $Action{$Module}->{Sum}->{$Row->[1]} = $Action{$Module}->{Sum}->{$Row->[1]} + $Row->[2];
                        }
                        else {
                            $Action{$Module}->{Sum}->{$Row->[1]} = $Row->[2];
                        }
                        if (!defined($Action{$Module}->{Max}->{$Row->[1]})) {
                            $Action{$Module}->{Max}->{$Row->[1]} = $Row->[2];
                        }
                        elsif ($Action{$Module}->{Max}->{$Row->[1]} < $Row->[2]) {
                            $Action{$Module}->{Max}->{$Row->[1]} = $Row->[2];
                        }
                        if (!defined($Action{$Module}->{Min}->{$Row->[1]})) {
                            $Action{$Module}->{Min}->{$Row->[1]} = $Row->[2];
                        }
                        elsif ($Action{$Module}->{Min}->{$Row->[1]} > $Row->[2]) {
                            $Action{$Module}->{Min}->{$Row->[1]} = $Row->[2];
                        }
                    }
                }
                else {
                    last;
                }
            }
            if (%Sum) {
                $Self->{LayoutObject}->Block(
                    Name => 'Table',
                    Data => {
                        Age => $Self->{LayoutObject}->CustomerAge(Age => $Minute*60, Space => ' '),
                    },
                );
            }
            foreach (qw(Agent Customer Public)) {
                my $CssClass = '';
                if ($Sum{$_}) {
                    # set output class
                    if ($CssClass && $CssClass eq 'searchactive') {
                        $CssClass = 'searchpassive';
                    }
                    else {
                        $CssClass = 'searchactive';
                    }
                    my $Average = $Sum{$_} / $Count{$_};
                    $Average =~ s/^(.*\.\d\d).+?$/$1/g;
                    $Self->{LayoutObject}->Block(
                        Name => 'Interface',
                        Data => {
                            Interface => $_,
                            Average => $Average,
                            Count => $Count{$_} || 0,
                            Sum => $Sum{$_} || 0,
                            Max => $Max{$_} || 0,
                            Min => $Min{$_} || 0,
                            CssClass => $CssClass,
                        },
                    );
                    foreach my $Module (sort keys %Action) {
                        if ($Action{$Module}->{Sum}->{$_}) {
                            # set output class
                            if ($CssClass && $CssClass eq 'searchactive') {
                                $CssClass = 'searchpassive';
                            }
                            else {
                                $CssClass = 'searchactive';
                            }
                            my $Average = $Action{$Module}->{Sum}->{$_} / $Action{$Module}->{Count}->{$_};
                            $Average =~ s/^(.*\.\d\d).+?$/$1/g;
                            $Self->{LayoutObject}->Block(
                                Name => 'Row',
                                Data => {
                                    Interface => $Module,
                                    Average => $Average,
                                    Count => $Action{$Module}->{Count}->{$_} || 0,
                                    Sum => $Action{$Module}->{Sum}->{$_} || 0,
                                    Max => $Action{$Module}->{Max}->{$_} || 0,
                                    Min => $Action{$Module}->{Min}->{$_} || 0,
                                    CssClass => $CssClass,
                                },
                            );
                        }
                    }
                }
            }
        }
        # create & return output
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPerformanceLog',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
