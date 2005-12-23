# --
# Kernel/Modules/SystemStats.pm - show stats of otrs
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: SystemStats.pm,v 1.24.2.1 2005-12-23 09:20:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::SystemStats;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.24.2.1 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    # if we need to do a fultext search on an external mirror database
    if ($Self->{ConfigObject}->Get('Stats::DB::DSN')) {
        my $ExtraDatabaseObject = Kernel::System::DB->new(
            LogObject => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            DatabaseDSN => $Self->{ConfigObject}->Get('Stats::DB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Stats::DB::User'),
            DatabasePw => $Self->{ConfigObject}->Get('Stats::DB::Password'),
        ) || die $DBI::errstr;
        $Self->{TicketObject} = Kernel::System::Ticket->new(
            %Param,
            DBObject => $ExtraDatabaseObject,
        );
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
        # print page ...
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        my %Config = %{$Self->{ConfigObject}->Get('SystemStatsMap')};
        foreach my $Stats (sort keys %Config) {
          if ($Self->{MainObject}->Require($Config{$Stats}->{Module})) {
            my $StatsModule = $Config{$Stats}->{Module}->new(%{$Self});
            my $ParamString = '';
            my %OutputFormat = ();
            foreach (@{$Config{$Stats}->{Output}}) {
                $OutputFormat{$_} = $_;
            }
            $Param{OutputFormat} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data => \%OutputFormat,
                    Name => 'Format',
                    SelectedID => $Config{$Stats}->{OutputDefault} || '',
                );
            $Self->{LayoutObject}->Block(
                Name => 'Item',
                Data => {
                    %Param,
                    %{$Config{$Stats}},
                    Param => $ParamString,
                },
            );
            my @Params = $StatsModule->Param();
            foreach my $ParamItem (@Params) {
                $Self->{LayoutObject}->Block(
                    Name => 'ItemParam',
                    Data => {
                        Param => $ParamItem->{Frontend},
                        Field => $Self->{LayoutObject}->OptionStrgHashRef(
                            Data => $ParamItem->{Data},
                            Name => $ParamItem->{Name},
                            SelectedID => $Config{$Stats}->{"$ParamItem->{Name}Default"} || $ParamItem->{SelectedID} || '',
                            Multiple => $ParamItem->{Multiple} || 0,
                            Size => $ParamItem->{Size} || '',
                        ),
                        %Param,
                        %{$Config{$Stats}},
                    },
                );
            }
          }
          else {
              return $Self->{LayoutObject}->FatalError();
          }
        }
        # create output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'SystemStats',
            Data => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{Subaction} eq 'Output') {
        my $Module = $Self->{ParamObject}->GetParam(Param => 'Module');
        my $Format = $Self->{ParamObject}->GetParam(Param => 'Format');
        my %Config = %{$Self->{ConfigObject}->Get('SystemStatsMap')};
        my %ConfigItem = ();
        foreach my $Stats (sort keys %Config) {
            if ($Config{$Stats}->{Module} eq $Module) {
                %ConfigItem = %{$Config{$Stats}};
            }
        }
        if (!%ConfigItem) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "No Config found for '$Module'!",
                Comment => 'Please contact your admin'
            );
        }
        if ($Self->{MainObject}->Require($Module)) {
            my %GetParam = ();
            my $StatsModule = $Module->new(%{$Self});
            my @Params = $StatsModule->Param();
            foreach my $ParamItem (@Params) {
                if (!$ParamItem->{Multiple}) {
                    $GetParam{$ParamItem->{Name}} = $Self->{ParamObject}->GetParam(
                        Param => $ParamItem->{Name},
                    );
                }
                else {
                    $GetParam{$ParamItem->{Name}} = [$Self->{ParamObject}->GetArray(
                        Param => $ParamItem->{Name},
                    )];
                }
            }
            # get data
            my @Data = ();
            # use result cache if configured
            if ($ConfigItem{UseResultCache}) {
                @Data = $Self->ReadResultCache(
                    GetParam => \%GetParam,
                    Config => \%ConfigItem,
                );
            }
            # try to get data if noting is there
            if (!@Data) {
                @Data = $StatsModule->Run(%GetParam,
                    Format => $Format,
                    Module => $Module,
                );
                $Self->WriteResultCache(
                    GetParam => \%GetParam,
                    Config => \%ConfigItem,
                    Data => \@Data,
                );
            }
            my $TitleArrayRef = shift (@Data);
            my $Title = $TitleArrayRef->[0];
            my $HeadArrayRef = shift (@Data);
            if ($Format !~ /^Graph/) {
                # add sum y
                if ($ConfigItem{SumRow}) {
                    push (@{$HeadArrayRef}, 'Sum');
                    foreach my $Col (@Data) {
                        my $Sum = 0;
                        foreach (@{$Col}) {
                            if ($_ =~ /^[0-9]{1,7}$/) {
                                $Sum = $Sum + $_;
                            }
                        }
                        push (@{$Col}, $Sum);
                    }
                }
                # add sum x
                if ($ConfigItem{SumCol}) {
                    my @R1 = ();
                    foreach my $Col (@Data) {
                        my $Count = -1;
                        foreach my $Dig (@{$Col}) {
                            $Count++;
                            if ($Dig =~ /^[0-9]{1,7}$/) {
                                if ($R1[$Count]) {
                                    $R1[$Count] = $R1[$Count] + $Dig;
                                }
                                else {
                                    $R1[$Count] = $Dig;
                                }
                            }
                        }
                    }
                    # add sum
                    if (!defined($R1[0])) {
                        $R1[0] = 'Sum';
                    }
                    push (@Data, \@R1);
                }
            }
            # generate output
            if ($Format eq 'CSV') {
                $ConfigItem{Module} =~ s/^.*::(.+?)$/$1/;
                my $Output = "$ConfigItem{Name}: $Title\n";
                $Output .= $Self->{LayoutObject}->OutputCSV(
                    Head => $HeadArrayRef,
                    Data => \@Data,
                );
                # return csv to download
                my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->SystemTime(),
                );
                $M = sprintf("%02d", $M);
                $D = sprintf("%02d", $D);
                $h = sprintf("%02d", $h);
                $m = sprintf("%02d", $m);
                return $Self->{LayoutObject}->Attachment(
                    Filename => "$ConfigItem{Module}"."_"."$Y-$M-$D"."_"."$h-$m.csv",
                    ContentType => "text/csv",
                    Content => $Output,
                );
            }
            # gd output
            elsif ($Format =~ /^Graph(|Line|Bars|Pie)$/) {
                # check @Data
                if (!@Data) {
                    my $Output = $Self->{LayoutObject}->Header();
                    $Output .= $Self->{LayoutObject}->Warning(
                        Message => 'No data for this time selection available!',
                        Comment => 'Please contact your admin'
                    );
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
                my $GDBackend = '';
                if ($1 eq 'Bars') {
                    $GDBackend = 'GD::Graph::bars';
                }
                elsif ($1 eq 'Pie') {
                    $GDBackend = 'GD::Graph::pie';
                }
                else {
                    $GDBackend = 'GD::Graph::lines';
                }
                # load gd modules
                foreach my $Module ('GD', 'GD::Graph', $GDBackend) {
                    if (!$Self->{MainObject}->Require($Module)) {
                        return $Self->{LayoutObject}->FatalError();
                    }
                }
                # remove first y/x position
                my $XLable = shift (@{$HeadArrayRef});
                # get first col for legend
                my @YLine = ();
                foreach my $Tmp (@Data) {
                    push (@YLine, $Tmp->[0]);
                    shift (@{$Tmp});
                }
                # build plot data
                my @PData = ($HeadArrayRef, @Data);
                my ($XSize, $YSize) = split(/x/, $GetParam{GraphSize});
                my $graph = $GDBackend->new($XSize || 550, $YSize || 350);
                $graph->set(
                    x_label            => $XLable,
#                    y_label            => 'YLable',
                    title              => "$ConfigItem{Name}: $Title",
#               y_max_value       => 20,
#            y_tick_number     => 16,
#               y_label_skip      => 4,
#            x_tick_number     => 8,
                    t_margin            => 10,
                    b_margin            => 10,
                    l_margin            => 10,
                    r_margin            => 20,
                    bgclr               => 'white',
                    transparent         => 0,
                    interlaced          => 1,
                    fgclr               => 'black',
                    boxclr              => 'white',
                    accentclr           => 'black',
                    shadowclr           => 'black',
                    legendclr           => 'black',
                    textclr             => 'black',
                    dclrs => [ qw(red green blue yellow black purple orange pink marine cyan lgray lblue lyellow lgreen lred lpurple lorange lbrown) ],
                    x_tick_offset       => 0,
                    x_label_position    => 1/2, y_label_position => 1/2,
                    x_labels_vertical   => 31,

                    line_width          => 1,
                    legend_placement    => 'BC', legend_spacing => 4,
                    legend_marker_width => 12, legend_marker_height => 8,
                );
                # set legend (y-line)
                if ($Format ne 'GraphPie') {
                    $graph->set_legend(@YLine);
                }
                # return csv to download
                my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->SystemTime(),
                );
                $M = sprintf("%02d", $M);
                $D = sprintf("%02d", $D);
                $h = sprintf("%02d", $h);
                $m = sprintf("%02d", $m);
                $ConfigItem{Module} =~ s/^.*::(.+?)$/$1/;
                # plot graph
                my $Ext = '';
                if (!$graph->can('png')) {
                    $Ext = 'png';
                }
                else {
                    $Ext = $graph->export_format;
                    $Self->{LogObject}->Log(
                        Priority => 'notice',
                        Message => "Can't write png! Write: $Ext",
                    );
                }
                my $Content = eval { $graph->plot(\@PData)->$Ext() };
                if (!$Content) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message => "To much data, can't use it with graph!",
                    );
                }
                # return image to bowser
                return $Self->{LayoutObject}->Attachment(
                    Filename => "$ConfigItem{Module}"."_"."$Y-$M-$D"."_"."$h-$m.$Ext",
                    ContentType => "image/$Ext",
                    Content => $Content,
                    Type => 'inline',
                );
            }
            # print output
            else {
                my $Output = $Self->{LayoutObject}->PrintHeader(Value => $ConfigItem{Name});
                $Output .= "$ConfigItem{Name}: $Title";
                $Output .= $Self->{LayoutObject}->OutputHTMLTable(
                    Head => $HeadArrayRef,
                    Data => \@Data,
                );

                $Output .= $Self->{LayoutObject}->PrintFooter();
                return $Output;
            }
        }
        else {
            return $Self->{LayoutObject}->FatalError();
        }
    }
    else {
        $Self->{LogObject}->Log(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin'
        );
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin'
        );
    }
}
# --
sub WriteResultCache {
    my $Self = shift;
    my %Param = @_;
    my %GetParam = %{$Param{GetParam}};
    my %Config = %{$Param{Config}};
    my @Data = @{$Param{Data}};
    my $Cache = 0;
    # check if we should cache this result
    my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    if ($GetParam{Year} && $GetParam{Month}) {
        if ($Y > $GetParam{Year}) {
            $Cache = 1;
        }
        elsif ($GetParam{Year} == $Y && $GetParam{Month} <= $M) {
            if ($GetParam{Month} < $M) {
                $Cache = 1;
            }
            if ($GetParam{Month} == $M && $GetParam{Day} && $GetParam{Day} < $D) {
                $Cache = 1;
            }
        }
    }
    # format month and day params
    foreach (qw(Month Day)) {
        $GetParam{$_} = sprintf("%02d", $GetParam{$_}) if ($GetParam{$_});
    }
    # write cache file
    if ($Cache) {
        my $Path = $Self->{ConfigObject}->Get('TempDir');
        my $File = $Config{Module};
        $File =~ s/::/-/g;
        if ($GetParam{Year}) {
            $File .= "-$GetParam{Year}";
        }
        if ($GetParam{Month}) {
            $File .= "-$GetParam{Month}";
        }
        if ($GetParam{Day}) {
            $File .= "-$GetParam{Day}";
        }
        $File .= ".cache";
        # write cache file
        if (open (DATA, "> $Path/$File")) {
            foreach my $Row (@Data) {
                foreach (@{$Row}) {
                    print DATA "$_;;";
                }
                print DATA "\n";
            }
            close (DATA);
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message => "Can't write: $Path/$File: $!",
            );
        }
    }
    return $Cache;
}
# --
sub ReadResultCache {
    my $Self = shift;
    my %Param = @_;
    my %GetParam = %{$Param{GetParam}};
    my %Config = %{$Param{Config}};
    my @Data = ();
    # format month and day params
    foreach (qw(Month Day)) {
        $GetParam{$_} = sprintf("%02d", $GetParam{$_}) if ($GetParam{$_});
    }
    # read cache file
    my $Path = $Self->{ConfigObject}->Get('TempDir');
    my $File = $Config{Module};
    $File =~ s/::/-/g;
    if ($GetParam{Year}) {
        $File .= "-$GetParam{Year}";
    }
    if ($GetParam{Month}) {
        $File .= "-$GetParam{Month}";
    }
    if ($GetParam{Day}) {
        $File .= "-$GetParam{Day}";
    }
    $File .= ".cache";
    if (open (DATA, "< $Path/$File")) {
        while (<DATA>) {
            my @Row = split(/;;/, $_);
            push (@Data, \@Row);
        }
        close (DATA);
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't open: $Path/$File: $!",
        );
    }
    return @Data;
}
# --
1;
