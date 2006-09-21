# --
# Kernel/Modules/AgentStats.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentStats.pm,v 1.13 2006-09-21 12:26:50 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentStats;

use strict;
use Kernel::System::Stats;
use Kernel::System::CSV;
use Kernel::System::PDF;

use vars qw($VERSION);
$VERSION = '$Revision: 1.13 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
     # check needed Opjects
    foreach (qw(GroupObject ParamObject DBObject ModuleReg LogObject
        ConfigObject UserObject MainObject)) {
        $Self->{LayoutObject}->FatalError(Message => "Got no $_!") if (!$Self->{$_});
    }
    # create needed objects
    $Self->{StatsObject} = Kernel::System::Stats->new(%Param);
    $Self->{CSVObject}   = Kernel::System::CSV->new(%Param);
    $Self->{PDFObject}   = Kernel::System::PDF->new(%Param);

    return $Self;
}

# --
sub Run {
    my $Self        = shift;
    my %Param       = @_;
    my $Output      = '';

    # ---------------------------------------------------------- #
    # subaction overview
    # ---------------------------------------------------------- #
    if ($Self->{Subaction} eq 'Overview') {
        # permission check
        $Self->{AccessRo} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # Get Params
        $Param{SearchPageShown} = $Self->{ConfigObject}->Get('Stats::SearchPageShown') || 10;
        $Param{SearchLimit}     = $Self->{ConfigObject}->Get('Stats::SearchLimit')     || 100;
        $Param{OrderBy}         = $Self->{ParamObject}->GetParam(Param => 'OrderBy')   || 'ID';
        $Param{Direction}       = $Self->{ParamObject}->GetParam(Param => 'Direction') || 'ASC';
        $Param{StartHit}        = $Self->{ParamObject}->GetParam(Param => 'StartHit')  || 1;

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $Self->{RequestedURL},
        );

        # get all Stats from the db
        my $Result = $Self->{StatsObject}->GetStatsList(
            OrderBy   => $Param{OrderBy},
            Direction => $Param{Direction},
        );

        # build the info
        my %Frontend = $Self->{LayoutObject}->PageNavBar(
            Limit     => $Param{SearchLimit},
            StartHit  => $Param{StartHit},
            PageShown => $Param{SearchPageShown},
            AllHits   => $#{$Result} + 1,
            Action    => "Action=AgentStats&Subaction=Overview",
            Link      => "&Direction=".($Param{Direction}||'')."&OrderBy=".($Param{OrderBy}||'')."&",
        );

        # list result
        my $Index  = -1;
        my $Counter = 0;
        for (my $Z = 0; ($Z < $Param{SearchPageShown} && $Index < $#{$Result}); $Z++) {
            $Counter++;
            $Index = $Param{StartHit} + $Z -1;
            my $StatID = $Result->[$Index];
            my $Stat = $Self->{StatsObject}->StatsGet(
                StatID => $StatID,
                NoObjectAttributes => 1,
            );
            if ($Counter % 2) {
                $Stat->{css} = 'searchactive';
            }
            else {
                $Stat->{css} = 'searchpassive';
            }
            $Self->{LayoutObject}->Block(
                Name => 'Result',
                Data => $Stat,
            );
        }

        # build output
        $Output .= $Self->{LayoutObject}->Header(Title => "Overview");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            Data         => {%Frontend, %Param},
            TemplateFile => 'AgentStatsOverview',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # subaction add
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Add') {
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        my $StatID = 'new';

        # redirect to edit

        return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                                                     "Subaction=EditSpecification&" .
                                                     "StatID=$StatID");
    }
    # ---------------------------------------------------------- #
    # subaction View
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'View') {
        # permission check
        $Self->{AccessRo} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # get statID
        my $StatID  = $Self->{ParamObject}->GetParam(Param => 'StatID');
        if (!$StatID){
            return $Self->{LayoutObject}->ErrorScreen(Message => "View: Get no StatID!");
        }
        # get message if one available
        my $Message = $Self->{ParamObject}->GetParam(Param => 'Message');

        my $Stat = $Self->{StatsObject}->StatsGet(StatID => $StatID);
        # object
        $Stat->{ObjectName} = '';
        if ($Stat->{StatType} eq 'static') {
            $Stat->{ObjectName} = $Stat->{File};
        }
        elsif ($Stat->{StatType} eq 'dynamic') {
            $Stat->{ObjectName} = $Stat->{Object};
        }
        # check object file
        my $ObjectFileCheck = $Self->{StatsObject}->ObjectFileCheck(
            Type => $Stat->{StatType},
            Name => $Stat->{ObjectName},
        );

        $Stat->{Description} = $Self->{LayoutObject}->Ascii2Html(
            Text           => $Stat->{Description},
            HTMLResultMode => 1,
            NewLine        => 72,
        );

        # create format select box
        my %SelectFormat = ();
        my $Flag         = 0;
        my $Counter      = 0;
        my $Format       = $Self->{ConfigObject}->Get('Stats::Format');
        foreach my $UseAsValueSeries (@{$Stat->{UseAsValueSeries}}) {
            if ($UseAsValueSeries->{Selected}) {
                $Counter++;
            }
        }
        my $CounterII = 0;
        foreach my $Value (@{$Stat->{Format}}) {
            unless ($Counter > 0 && $Value eq "GD::Graph::pie") {
                $SelectFormat{$Value} = $Format->{$Value};
                $CounterII++;
            }
            if ($Value =~ /^GD::Graph\.*/) {
                $Flag = 1;
            }
        }
        if ($CounterII > 1) {
            my %Frontend     = ();
            $Frontend{SelectFormat} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data               => \%SelectFormat,
                Name               => 'Format',
            );
            $Self->{LayoutObject}->Block(
                Name => 'Format',
                Data => \%Frontend,
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'FormatFixed',
                Data => {Format => $Format->{$Stat->{Format}->[0]},
                    FormatKey => $Stat->{Format}->[0],
                },
            );
        }

        # create graphic size select box
        if ($Stat->{GraphSize} && $Flag) {
            my %GraphSize    = ();
            my %Frontend     = ();
            my $GraphSizeRef = $Self->{ConfigObject}->Get('Stats::GraphSize');

            foreach my $Value (@{$Stat->{GraphSize}}) {
                $GraphSize{$Value} = $GraphSizeRef->{$Value};
            }
            if ($#{$Stat->{GraphSize}} > 0) {
                $Frontend{SelectGraphSize} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data => \%GraphSize,
                    Name => 'GraphSize',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'Graphsize',
                    Data => \%Frontend,
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'GraphsizeFixed',
                    Data => {GraphSize => $GraphSizeRef->{$Stat->{GraphSize}->[0]},
                        GraphSizeKey => $Stat->{GraphSize}->[0],
                    },
                );
            }
        }

        if ($Self->{ConfigObject}->Get("Stats::ExchangeAxis")) {
            my $ExchangeAxis = $Self->{LayoutObject}->OptionStrgHashRef(
                Data => {1 => 'Yes', 0 => 'No'},
                Name => 'ExchangeAxis',
                SelectedID => 0,
            );

            $Self->{LayoutObject}->Block(
                Name => 'ExchangeAxis',
                Data => {ExchangeAxis => $ExchangeAxis}
            );
        }


        # get static attributes
        if ($Stat->{StatType} eq 'static') {
            # load static modul
            my $Params = $Self->{StatsObject}->GetParams(StatID => $StatID);
            $Self->{LayoutObject}->Block(
                Name => 'Static',
            );
            foreach my $ParamItem (@{$Params}) {
                next if $ParamItem->{Name} eq 'GraphSize';
                $Self->{LayoutObject}->Block(
                    Name => 'ItemParam',
                    Data => {
                        Param => $ParamItem->{Frontend},
                        Field => $Self->{LayoutObject}->OptionStrgHashRef(
                            Data       => $ParamItem->{Data},
                            Name       => $ParamItem->{Name},
                            SelectedID => $ParamItem->{SelectedID} || '',
                            Multiple   => $ParamItem->{Multiple}   || 0,
                            Size       => $ParamItem->{Size}       || '',
                        ),
                    },
                );
            }
        }

        # get dynamic attributes
        elsif ($Stat->{StatType} eq 'dynamic') {
            my %Name = (
                UseAsXvalue      => 'X-axis',
                UseAsValueSeries => 'ValueSeries',
                UseAsRestriction => 'Restriction',
            );
            foreach my $Use (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {
                my $Flag = 0;
                $Self->{LayoutObject}->Block(
                    Name => 'Dynamic',
                    Data => {Name => $Name{$Use}},
                );
                foreach my $ObjectAttribute (@{$Stat->{$Use}}) {
                    if ($ObjectAttribute->{Selected}) {
                        my %ValueHash = ();
                        $Flag = 1;

                        # Select All function
                        if (!$ObjectAttribute->{SelectedValues}[0]) {
                            my @Values = keys (%{$ObjectAttribute->{Values}});
                            $ObjectAttribute->{SelectedValues} = \@Values;
                        }

                        foreach (@{$ObjectAttribute->{SelectedValues}}) {
                            if ($ObjectAttribute->{Values}) {
                                $ValueHash{$_} = $ObjectAttribute->{Values}{$_};
                            }
                            else {
                                $ValueHash{Value} = $_;
                            }
                        }

                        $Self->{LayoutObject}->Block(
                            Name => 'Element',
                            Data => {Name => $ObjectAttribute->{Name}},
                        );

                        # show fixed elements
                        if ($ObjectAttribute->{Fixed}) {
                            if ($ObjectAttribute->{Block} eq 'Time') {
                                if ($Use eq 'UseAsRestriction') {
                                    delete ($ObjectAttribute->{SelectedValues});
                                }
                                my $TimeScale = _TimeScale();
                                if ($ObjectAttribute->{TimeStart}) {
                                    $Self->{LayoutObject}->Block(
                                        Name => 'TimePeriodFixed',
                                        Data => {
                                            TimeStart => $ObjectAttribute->{TimeStart},
                                            TimeStop  => $ObjectAttribute->{TimeStop},
                                        },
                                    );
                                }
                                elsif ($ObjectAttribute->{TimeRelativeUnit}) {
                                    $Self->{LayoutObject}->Block(
                                        Name => 'TimeRelativeFixed',
                                        Data => {
                                            TimeRelativeUnit  => $TimeScale->{$ObjectAttribute->{TimeRelativeUnit}}{Value},
                                            TimeRelativeCount => $ObjectAttribute->{TimeRelativeCount},
                                        },
                                    );
                                }
                                if ($ObjectAttribute->{SelectedValues}[0]) {
                                    $Self->{LayoutObject}->Block(
                                        Name => 'TimeScaleFixed',
                                        Data => {
                                            Scale => $TimeScale->{$ObjectAttribute->{SelectedValues}[0]}{Value},
                                            Count => $ObjectAttribute->{TimeScaleCount},
                                        },
                                    );
                                }
                            }
                            else {
                                foreach (sort{$ValueHash{$a} cmp $ValueHash{$b}} keys %ValueHash) {
                                    my $Value = $ValueHash{$_};
                                    if ($ObjectAttribute->{LanguageTranslation}) {
                                        $Value = "\$Text{\"$ValueHash{$_}\"}";
                                    }
                                    $Self->{LayoutObject}->Block(
                                        Name => 'Fixed',
                                        Data => {
                                            Value   => $Value,
                                            Key     => $_,
                                            Use     => $Use,
                                            Element => $ObjectAttribute->{Element},
                                        },
                                    );
                                }
                            }
                        }
                        # show  unfixed elements
                        else {
                            my %BlockData = ();
                            $BlockData{Name}    = $ObjectAttribute->{Name};
                            $BlockData{Element} = $ObjectAttribute->{Element};
                            $BlockData{Value}   = $ObjectAttribute->{SelectedValues}->[0];

                            if ($ObjectAttribute->{Block} eq 'MultiSelectField') {
                                $BlockData{SelectField} = $Self->{LayoutObject}->OptionStrgHashRef(
                                    Data                => \%ValueHash,
                                    Name                => $Use . '->' .$ObjectAttribute->{Element},
                                    Multiple            => 1,
                                    Size                => 4,
                                    SelectedIDRefArray  => $ObjectAttribute->{SelectedValues},
                                    LanguageTranslation => $ObjectAttribute->{LanguageTranslation},
                                );
                                $Self->{LayoutObject}->Block(
                                    Name => 'MultiSelectField',
                                    Data => \%BlockData,
                                );
                            }
                            elsif ($ObjectAttribute->{Block} eq 'SelectField') {
                                $BlockData{SelectField} = $Self->{LayoutObject}->OptionStrgHashRef(
                                    Data               => \%ValueHash,
                                    Name                => $ObjectAttribute->{Element},
                                    LanguageTranslation => $ObjectAttribute->{LanguageTranslation},
                                );
                                $Self->{LayoutObject}->Block(
                                    Name => 'SelectField',
                                    Data => \%BlockData,
                                );
                            }

                            elsif ($ObjectAttribute->{Block} eq 'InputField') {

                                $Self->{LayoutObject}->Block(
                                    Name => 'InputField',
                                    Data => {
                                        Key => $Use . '->' . $ObjectAttribute->{Element},
                                        Value => $ObjectAttribute->{SelectedValues}[0],
                                     },
                                );
                            }
                            elsif ($ObjectAttribute->{Block} eq 'Time') {
                                $ObjectAttribute->{Element} = $Use . '->' .$ObjectAttribute->{Element};
                                my $TimeType = $Self->{ConfigObject}->Get("Stats::TimeType") || 'Normal';
                                my %TimeData = _Timeoutput($Self, %{$ObjectAttribute}, OnlySelectedAttributs => 1);
                                %BlockData = (%BlockData, %TimeData);
                                if ($ObjectAttribute->{TimeStart}) {
                                    $BlockData{TimeStartMax} = $ObjectAttribute->{TimeStart};
                                    $BlockData{TimeStopMax}  = $ObjectAttribute->{TimeStop};
                                    $Self->{LayoutObject}->Block(
                                        Name => 'TimePeriod',
                                        Data => \%BlockData,
                                    );
                                }

                                elsif ($ObjectAttribute->{TimeRelativeUnit}) {
                                    my $TimeScale       = _TimeScale();
                                    if ($TimeType eq 'Extended') {
                                        my @TimeScaleArray  = reverse(keys(%{$TimeScale}));
                                        my %TimeScaleOption = ();
                                        foreach (@TimeScaleArray) {
                                            $TimeScaleOption{$_} = $TimeScale->{$_}{Value};
                                            if ($ObjectAttribute->{TimeRelativeUnit} eq $_) {
                                                last;
                                            }
                                        }
                                        $BlockData{TimeRelativeUnit} = $Self->{LayoutObject}->OptionStrgHashRef(
                                            Data => \%TimeScaleOption,
                                            Name => $ObjectAttribute->{Element} . 'TimeRelativeUnit',
                                        );
                                    }
                                    $BlockData{TimeRelativeCountMax} = $ObjectAttribute->{TimeRelativeCount};
                                    $BlockData{TimeRelativeUnitMax}  = $TimeScale->{$ObjectAttribute->{TimeRelativeUnit}}{Value};

                                    $Self->{LayoutObject}->Block(
                                         Name => 'TimePeriodRelative',
                                         Data => \%BlockData,
                                    );
                                }

                                # build the Timescale output
                                if ($Use ne 'UseAsRestriction') {
                                    if ($TimeType eq 'Normal') {
                                        $BlockData{TimeScaleCount} = 1;
                                        $BlockData{TimeScaleUnit} = $BlockData{TimeSelectField};
                                    }
                                    elsif ($TimeType eq 'Extended') {
                                        my $TimeScale       = _TimeScale();
                                        my %TimeScaleOption = ();
                                        foreach (keys %{$TimeScale}) {
                                            $TimeScaleOption{$_} = $TimeScale->{$_}->{Value};
                                            if ($ObjectAttribute->{SelectedValues}[0] eq $_) {
                                                last;
                                            }
                                        }
                                        $BlockData{TimeScaleUnitMax} = $TimeScale->{$ObjectAttribute->{SelectedValues}[0]}{Value},
                                        $BlockData{TimeScaleCountMax} = $ObjectAttribute->{TimeScaleCount},

                                        $BlockData{TimeScaleUnit} = $Self->{LayoutObject}->OptionStrgHashRef(
                                            Data => \%TimeScaleOption,
                                            Name => $ObjectAttribute->{Element},
                                        );
                                        $Self->{LayoutObject}->Block(
                                            Name => 'TimeScaleInfo',
                                            Data => \%BlockData,
                                        );

                                    }
                                    if ($ObjectAttribute->{SelectedValues}) {
                                        $Self->{LayoutObject}->Block(
                                            Name => 'TimeScale',
                                            Data => \%BlockData,
                                        );
                                        if ($BlockData{TimeScaleUnitMax}) {
                                            $Self->{LayoutObject}->Block(
                                                Name => 'TimeScaleInfo',
                                                Data => \%BlockData,
                                            );
                                        }
                                    }
                                }
                                # ent of build timescale output
                            }
                        }
                    }
                }
                # Show this Block if no valueseries or restrictions are selected
                if (!$Flag) {
                    $Self->{LayoutObject}->Block(
                        Name => 'NoElement',
                    );
                }
            }
        }
        my %YesNo        = (0 => 'No', 1 => 'Yes');
        my %ValidInvalid = (0 => 'invalid', 1 => 'valid');
        $Stat->{SumRowValue} = $YesNo{$Stat->{SumRow}};
        $Stat->{SumColValue} = $YesNo{$Stat->{SumCol}};
        $Stat->{CacheValue}  = $YesNo{$Stat->{Cache}};
        $Stat->{ValidValue}  = $ValidInvalid{$Stat->{Valid}};

        foreach (qw(CreatedBy ChangedBy)) {
            $Stat->{$_} = $Self->{UserObject}->UserName(UserID => $Stat->{$_});
        }

        # store last screen
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $Self->{RequestedURL},
        );
        # show admin links
        if ($Self->{AccessRw}) {
            $Self->{LayoutObject}->Block(
                Name => 'AdminLinks',
                Data => $Stat,
            );
        }
        # Completenesscheck
        my @Notify = $Self->{StatsObject}->CompletenessCheck(
              StatData => $Stat,
              Section  => 'All'
        );

        # show the start buttom if the stat is valid and complettnesscheck true
        if ($Stat->{Valid} && !@Notify) {
            $Self->{LayoutObject}->Block(
                Name => 'FormSubmit',
                Data => $Stat,
            );
        }

        # build output
        $Output .= $Self->{LayoutObject}->Header(Title => "View");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # Errorwaring if some have done wrong setting in the view mask
        # search for better solution
        if ($Message) {
            if ($Message == 1) {
                $Message = 'The selected start time is before the allowed start time!';
            }
            elsif ($Message == 2) {
                $Message = 'The selected end time is after the allowed end time!';
            }
            elsif ($Message == 3) {
                $Message = 'The selected time period is larger than the allowed time period!';
            }
            elsif ($Message == 4) {
                $Message = 'Your reporting time interval is to small, please use a larger time scale!';
            }
            $Output .= $Self->{LayoutObject}->Notify(
                Info     => $Message,
                Priority => 'Error',
            );
        }
        $Output .= $Self->_Notify(StatData => $Stat, Section => 'All');
        $Output .= $Self->{LayoutObject}->Output(
            Data         => $Stat,
            TemplateFile => 'AgentStatsView',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # show delete screen
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Delete') {
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        # get params
        foreach (qw(Status Yes No)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        my $StatID = $Self->{ParamObject}->GetParam(Param => 'StatID');
        if (!$StatID){
            return $Self->{LayoutObject}->ErrorScreen(Message => "Delete: Get no StatID!");
        }

        # delete Stat
        if ($Param{Status} && $Param{Status} eq 'Action') {
            if ($Param{Yes}) {
                $Self->{StatsObject}->StatsDelete(StatID => $StatID);
            }
            # redirect to edit
            return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                                                         "Subaction=Overview");
        }
        else {
            my $Stat = $Self->{StatsObject}->StatsGet(StatID => $StatID);

            # build output
            $Output .= $Self->{LayoutObject}->Header(Title => "Delete");
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentStatsDelete',
                Data         => $Stat,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # ---------------------------------------------------------- #
    # show export screen
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Export') {
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # get params
        my $StatID = $Self->{ParamObject}->GetParam(Param => 'StatID');

        # check if available
        if (!$StatID){
            return $Self->{LayoutObject}->ErrorScreen(Message => "Export: Get no StatID!");
        }
        my $ExportFile =  $Self->{StatsObject}->Export(StatID => $StatID);

        return $Self->{LayoutObject}->Attachment(
            Filename    => $ExportFile->{Filename},
            Content     => $ExportFile->{Content},
            ContentType => 'text/xml',
        );
    }
    # ---------------------------------------------------------- #
    # show import screen
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Import') {
        my $Error = 0;

        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # get params
        foreach (qw(Status)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # importing
        if ($Param{Status} && $Param{Status} eq 'Action') {
            my $Uploadfile = '';
            if ($Uploadfile = $Self->{ParamObject}->GetParam(Param => 'file_upload')) {
                    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                        Param  => "file_upload",
                        Source => 'string',
                    );
                    if ($UploadStuff{Content} =~ /<otrs_stats>/) {
                        my $StatID = $Self->{StatsObject}->Import(
                            Content  => $UploadStuff{Content},
                        );
                        # redirect to edit
                        return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                                                            "Subaction=View&" .
                                                            "StatID=$StatID");
                    }
                    else {
                        # return to import: doctype not found!
                        $Error = 1;
                    }
            }
            # return to import: no file selected!
            else {
                $Error = 2;
            }
        }
# TODO Sollten die ErrorWarnings nicht in die Notificationzeile?
        # show errors
        if ($Error == 1) {
            $Self->{LayoutObject}->Block(
                Name => 'ErrorDoctype1',
            );
        }
        elsif ($Error == 2) {
            $Self->{LayoutObject}->Block(
                Name => 'ErrorDoctype2',
            );
        }

        # show import form
        $Output  = $Self->{LayoutObject}->Header(Title => "Import");
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AgentStatsImport');
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # action after edit a Stats
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Action') {
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        # get params
        foreach (qw(StatID Home Back Next)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # check if needed params are available
        foreach (qw(StatID Home)) {
            if (!$Param{$_}){
                return $Self->{LayoutObject}->ErrorScreen(Message => "EditAction: Need $_!");
            }
        }

        if ($Param{StatID} eq 'new') {
            # call the StatsAddfunction and get the new StatID
            $Param{StatID} = $Self->{StatsObject}->StatsAdd();
            if (!$Param{StatID}){
                return $Self->{LayoutObject}->ErrorScreen(Message => "Add: Get no StatID!");
            }
        }

        # get save data
        my %Data      = ();
        my $Subaction = '';

        # save EditSpecification
        if ($Param{Home} eq 'EditSpecification') {
            # save string
            foreach (qw(Title Description Object File SumRow SumCol Cache StatType Valid)) {
                if (defined ($Self->{ParamObject}->GetParam(Param => $_))) {
                    my $Param = $Self->{ParamObject}->GetParam(Param => $_);
                    $Data{$_} = $Param;
                }
                else {
                    $Data{$_} = '';
                }
            }
            if($Data{StatType} eq '') {
                $Data{File}         = '';
                $Data{Object}       = '';
                $Data{ObjectModule} = '';
            }
            elsif($Data{StatType} eq 'dynamic' && $Data{Object}) {
                $Data{File}         = '';
                $Data{ObjectModule} = 'Kernel::System::Stats::Dynamic::' . $Data{Object};
            }
            elsif($Data{StatType} eq 'static' && $Data{File}) {
                $Data{Object}       = '';
                $Data{ObjectModule} = 'Kernel::System::Stats::Static::' . $Data{File};
            }
            # save array
            foreach my $Key (qw(Permission Format GraphSize)) {
                if ($Self->{ParamObject}->GetArray(Param => $Key)) {
                    my @Array = $Self->{ParamObject}->GetArray(Param => $Key);
                    foreach my $Index (0..$#Array) {
                        $Data{$Key}[$Index] = $Array[$Index];
                    }
                }
                else {
                    $Data{$Key} = '';
                }
            }

            # CompletenessCheck and set next subaction
            my @Notify = $Self->{StatsObject}->CompletenessCheck(
                 StatData => \%Data,
                 Section  => 'Specification'
            );
            if (@Notify) {
                $Subaction = 'EditSpecification';
            }
            elsif ($Data{StatType} eq 'static') {
                $Subaction = 'View';
            }
            else {
                $Subaction = 'EditXaxis' ;
            }

        }
        # save EditXaxis
        elsif ($Param{Home} eq 'EditXaxis') {
            my $Stat  = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});
            $Param{Select} = $Self->{ParamObject}->GetParam(Param => 'Select');
            $Data{StatType}       = $Stat->{StatType};
            foreach my $ObjectAttribute (@{$Stat->{UseAsXvalue}}) {
                if ($Param{Select} eq $ObjectAttribute->{Element}) {
                    my @Array = $Self->{ParamObject}->GetArray(Param => $Param{Select});
                    $Data{UseAsXvalue}[0]{SelectedValues} = \@Array;
                    $Data{UseAsXvalue}[0]{Element}        = $Param{Select};
                    $Data{UseAsXvalue}[0]{Block}          = $ObjectAttribute->{Block};
                    $Data{UseAsXvalue}[0]{Selected}       = 1;

                    if ($Self->{ParamObject}->GetParam(Param => 'Fixed' . $Param{Select})) {
                        $Data{UseAsXvalue}[0]{Fixed} = 1;
                    }
                    else {
                        $Data{UseAsXvalue}[0]{Fixed} = 0;
                    }

                    # Check if Time was selected
                    if ($ObjectAttribute->{Block} eq 'Time') {
                        my $TimeType = $Self->{ConfigObject}->Get("Stats::TimeType") || 'Normal';
                        # perhaps not useful because the period should unfixed
                        #if ($TimeType eq 'Normal') {
                        #    # if the admin has only one unit selected, unfixed is useless
                        #    if (!$Data{UseAsXvalue}[0]{SelectedValues}[1] && $Data{UseAsXvalue}[0]{SelectedValues}[0]) {
                        #        $Data{UseAsXvalue}[0]{Fixed} = 1;
                        #    }
                        #}
                        #elsif ($TimeType eq 'TimeExtended') {
                        #
                        #}
                        my %Time    = ();
                        my $Element = $Data{UseAsXvalue}[0]{Element};
                        $Data{UseAsXvalue}[0]{TimeScaleCount} = $Self->{ParamObject}->GetParam(Param => $Element . 'TimeScaleCount') || 1;
                        my $TimeSelect = $Self->{ParamObject}->GetParam(Param => $Element . 'TimeSelect')  || 'Absolut';
                        if ($TimeSelect eq 'Absolut') {
                            foreach my $Limit (qw(Start Stop)) {
                                foreach my $Unit (qw(Year Month Day Hour Minute Second)) {
                                    if (defined($Self->{ParamObject}->GetParam(Param => "$Element$Limit$Unit"))) {
                                        $Time{$Limit . $Unit} = $Self->{ParamObject}->GetParam(
                                            Param => "$Element$Limit$Unit"
                                        );
                                    }
                                }
                                if (!defined($Time{$Limit . "Hour"})) {
                                    if ($Limit eq 'Start') {
                                        $Time{"StartHour"} = 0;
                                        $Time{"StartMinute"} = 0;
                                        $Time{"StartSecond"} = 0;
                                    }
                                    elsif ($Limit eq 'Stop') {
                                        $Time{"StopHour"} = 23;
                                        $Time{"StopMinute"} = 59;
                                        $Time{"StopSecond"} = 59;
                                    }
                                }
                                elsif (!defined($Time{$Limit . "Second"})) {
                                    if ($Limit eq 'Start') {
                                        $Time{"StartSecond"} = 0;
                                    }
                                    elsif ($Limit eq 'Stop') {
                                        $Time{"StopSecond"} = 59;
                                    }
                                }


                                $Data{UseAsXvalue}[0]{"Time$Limit"} =
                                    sprintf("%04d-%02d-%02d %02d:%02d:%02d",
                                    $Time{$Limit . "Year"},
                                    $Time{$Limit . "Month"},
                                    $Time{$Limit . "Day"},
                                    $Time{$Limit . "Hour"},
                                    $Time{$Limit . "Minute"},
                                    $Time{$Limit . "Second"},
                                ); # Second for later functions
                            }
                        }
                        else {
                            $Data{UseAsXvalue}[0]{TimeRelativeUnit}  = $Self->{ParamObject}->GetParam(Param => $Element . 'TimeRelativeUnit');
                            $Data{UseAsXvalue}[0]{TimeRelativeCount} = $Self->{ParamObject}->GetParam(Param => $Element . 'TimeRelativeCount');
                        }
                    }
                }
            }
            # CompletenessCheck and set next subaction
            my @Notify = $Self->{StatsObject}->CompletenessCheck(
                 StatData => \%Data,
                 Section  => 'Xaxis'
            );
            if (@Notify) {
                $Subaction = 'EditXaxis';
            }
            elsif ($Param{Back}) {
                $Subaction = 'EditSpecification';
            }
            else {
                $Subaction = 'EditValueSeries' ;
            }
        }

        # save EditValueSeries
        elsif ($Param{Home} eq 'EditValueSeries') {
            my $Stat  = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});
            my $Index = 0;
            $Data{StatType} = $Stat->{StatType};
            foreach my $ObjectAttribute (@{$Stat->{UseAsValueSeries}}) {

                if ($Self->{ParamObject}->GetParam(Param => "Select" . $ObjectAttribute->{Element})) {
                    my @Array = $Self->{ParamObject}->GetArray(Param => $ObjectAttribute->{Element});
                    $Data{UseAsValueSeries}[$Index]{SelectedValues} = \@Array;
                    $Data{UseAsValueSeries}[$Index]{Element}        = $ObjectAttribute->{Element};
                    $Data{UseAsValueSeries}[$Index]{Block}          = $ObjectAttribute->{Block};
                    $Data{UseAsValueSeries}[$Index]{Selected}       = 1;

                    if ($Self->{ParamObject}->GetParam(Param => 'Fixed' . $ObjectAttribute->{Element})) {
                        $Data{UseAsValueSeries}[$Index]{Fixed} = 1;
                    }
                    else {
                        $Data{UseAsValueSeries}[$Index]{Fixed} = 0;
                    }

                    # Check if Time was selected
                    if ($ObjectAttribute->{Block} eq 'Time') {
                        my $TimeType = $Self->{ConfigObject}->Get("Stats::TimeType") || 'Normal';
                        if ($TimeType eq 'Normal') {
                            # if the admin has only one unit selected, unfixed is useless
                            if (!$Data{UseAsValueSeries}[0]{SelectedValues}[1] && $Data{UseAsValueSeries}[0]{SelectedValues}[0]) {
                                $Data{UseAsValueSeries}[0]{Fixed} = 1;
                            }
                        }
                        # for working with extended time
                        $Data{UseAsValueSeries}[$Index]{TimeScaleCount} = $Self->{ParamObject}->GetParam(Param => $ObjectAttribute->{Element} . 'TimeScaleCount') || 1;
                    }
                    $Index++;
                }
            }
            if (!$Data{UseAsValueSeries}) {
                $Data{UseAsValueSeries} = [];
            }

            # CompletenessCheck and set next subaction
            my @Notify = $Self->{StatsObject}->CompletenessCheck(
                 StatData => \%Data,
                 Section  => 'ValueSeries'
            );
            if (@Notify) {
                $Subaction = 'EditValueSeries';
            }
            elsif ($Param{Back}) {
                $Subaction = 'EditXaxis';
            }
            else {
                $Subaction = 'EditRestrictions' ;
            }
        }
        # save EditRestrictions
        elsif ($Param{Home} eq 'EditRestrictions') {
            my $Stat  = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});
            my $Index = 0;
            my $SelectFieldError = 0;
            $Data{StatType} = $Stat->{StatType};
            foreach my $ObjectAttribute (@{$Stat->{UseAsRestriction}}) {
                if ($Self->{ParamObject}->GetParam(Param => "Select" . $ObjectAttribute->{Element})) {
                    my $Element = $ObjectAttribute->{Element};
                    my @Array   = $Self->{ParamObject}->GetArray(Param => $Element);
                    $Data{UseAsRestriction}[$Index]{SelectedValues} = \@Array;
                    $Data{UseAsRestriction}[$Index]{Element}        = $Element;
                    $Data{UseAsRestriction}[$Index]{Block}          = $ObjectAttribute->{Block};
                    $Data{UseAsRestriction}[$Index]{Selected}       = 1;

                    if ($Self->{ParamObject}->GetParam(Param => 'Fixed' . $Element)) {
                        $Data{UseAsRestriction}[$Index]{Fixed} = 1;
                    }
                    else {
                        $Data{UseAsRestriction}[$Index]{Fixed} = 0;
                    }

                    if ($ObjectAttribute->{Block} eq 'Time') {
                        my %Time = ();
                        my $TimeSelect = $Self->{ParamObject}->GetParam(Param => $Element . 'TimeSelect')  || 'Absolut';
                        if ($TimeSelect eq 'Absolut') {
                            foreach my $Limit (qw(Start Stop)) {
                                foreach my $Unit (qw(Year Month Day Hour Minute Second)) {
                                    if (defined($Self->{ParamObject}->GetParam(Param => "$Element$Limit$Unit"))) {
                                        $Time{$Limit . $Unit} = $Self->{ParamObject}->GetParam(
                                            Param => "$Element$Limit$Unit"
                                        );
                                    }
                                }
                                if (!defined($Time{$Limit . "Hour"})) {
                                    if ($Limit eq 'Start') {
                                        $Time{"StartHour"}   = 0;
                                        $Time{"StartMinute"} = 0;
                                        $Time{"StartSecond"} = 0;
                                    }
                                    elsif ($Limit eq 'Stop') {
                                        $Time{"StopHour"}   = 23;
                                        $Time{"StopMinute"} = 59;
                                        $Time{"StopSecond"} = 59;
                                    }
                                }
                                elsif (!defined($Time{$Limit . "Second"})) {
                                    if ($Limit eq 'Start') {
                                        $Time{"StartSecond"} = 0;
                                    }
                                    elsif ($Limit eq 'Stop') {
                                        $Time{"StopSecond"} = 59;
                                    }
                                }

                                $Data{UseAsRestriction}[$Index]{"Time$Limit"} =
                                    sprintf("%04d-%02d-%02d %02d:%02d:%02d",
                                    $Time{$Limit . "Year"},
                                    $Time{$Limit . "Month"},
                                    $Time{$Limit . "Day"},
                                    $Time{$Limit . "Hour"},
                                    $Time{$Limit . "Minute"},
                                    $Time{$Limit . "Second"},
                                ); # Second for later functions
                            }
                        }
                        else {
                            $Data{UseAsRestriction}[$Index]{TimeRelativeUnit}  = $Self->{ParamObject}->GetParam(Param => $Element . 'TimeRelativeUnit');
                            $Data{UseAsRestriction}[$Index]{TimeRelativeCount} = $Self->{ParamObject}->GetParam(Param => $Element . 'TimeRelativeCount');
                        }
                    }
                    $Index++;
                }
            }
            if (!$Data{UseAsRestriction}) {
                $Data{UseAsRestriction} = [];
            }
            # CompletenessCheck and set next subaction
            my @Notify = $Self->{StatsObject}->CompletenessCheck(
                 StatData => \%Data,
                 Section  => 'Restrictions'
            );
            if (@Notify || $SelectFieldError) {
                $Subaction = 'EditRestrictions';
            }
            elsif ($Param{Back}) {
                $Subaction = 'EditValueSeries';
            }
            else {
                $Subaction = 'View' ;
            }
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "EditAction: Invalid declaration of the Home-Attribute!"
            );
        }

        # save xmlhash in db
        $Self->{StatsObject}->StatsUpdate(
            StatID => $Param{StatID},
            Hash   => \%Data,
        );
        # redirect
        return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                                                     "Subaction=$Subaction&" .
                                                     "StatID=$Param{StatID}");
    }
    # ---------------------------------------------------------- #
    # edit stats specification
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'EditSpecification') {
        my %Frontend = ();
        my $Stat = {};
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # get params
        foreach (qw(StatID)) {
            if (!($Param{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "EditSpecification: Need $_!"
                );
            }
        }

        # get Stat data
        if ($Param{StatID} ne 'new') {
            $Stat = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});
        }
        else {
            $Stat->{StatID}     = 'new';
            $Stat->{StatNumber} = 'New';
        }

        # build the dynamic or/and static stats selection if nothing is selected
        if (!$Stat->{StatType}) {
            my $DynamicFiles      = $Self->{StatsObject}->GetDynamicFiles();
            my $StaticFiles       = $Self->{StatsObject}->GetStaticFiles();
            my @DynamicFilesArray = keys %{$DynamicFiles};
            my @StaticFilesArray  = keys %{$StaticFiles};

            # build the Dynamic Object selection
            if (@DynamicFilesArray && $#DynamicFilesArray > 0) {
                $Self->{LayoutObject}->Block(
                    Name => 'Selection',
                );
                # need a radiobutton if dynamic and static stats available
                if ($#StaticFilesArray > 0) {
                    $Self->{LayoutObject}->Block(
                        Name => 'RadioButton',
                        Data => {
                            Name      => 'Dynamic-Object',
                            StateType => 'dynamic',
                        }                    );
                }
                # need no radio button if no static stats available
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'NoRadioButton',
                        Data => {
                            Name      => 'Dynamic-Object',
                            StateType => 'dynamic',
                        }                    );
                }
                # need a dropdown menue if more dynamic objects available
                if ($#DynamicFilesArray > 1) {
                    $Frontend{SelectField} = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data     => $DynamicFiles,
                        Name     => 'Object',
                        LanguageTranslation => 0,
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'SelectField',
                        Data => {
                            SelectField => $Frontend{SelectField},
                        },
                    );
                }
                # show this, if only one dynamic object is available
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'Selected',
                        Data => {
                            SelectedKey => 'Object',
                            Selected    => $DynamicFilesArray[0],
                        },
                    );
                }
            }
            # build the static stats selection if one or more static stats available
            if (@StaticFilesArray && $#StaticFilesArray > 0) {
                $Self->{LayoutObject}->Block(
                    Name => 'Selection',
                );
                # need a radiobutton if dynamic and static stats available
                if ($#DynamicFilesArray > 0) {
                    $Self->{LayoutObject}->Block(
                        Name => 'RadioButton',
                        Data => {
                            Name      => 'Static-File',
                            StateType => 'static',
                        }
                    );
                }
                # if no dynamic objects available radio buttons not needed
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'NoRadioButton',
                        Data => {
                            Name      => 'Static-File',
                            StateType => 'static',
                        }                    );
                }
                # more static stats available? than make a SelectField
                if ($#StaticFilesArray > 1) {
                    $Frontend{SelectField} = $Self->{LayoutObject}->OptionStrgHashRef(
                        Data     => $StaticFiles,
                        Name     => 'File',
                        LanguageTranslation => 0,
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'SelectField',
                        Data => {
                            SelectField => $Frontend{SelectField},
                        },
                    );
                }
                # only one static stats available? than show the onw
                else {
                    $Self->{LayoutObject}->Block(
                        Name => 'Selected',
                        Data => {
                            SelectedKey => 'File',
                            Selected    => $StaticFilesArray[0],
                        },
                    );
                }
            }
        }
        # show the dynamic object if it is selected
        elsif ($Stat->{StatType} eq 'dynamic') {
            $Self->{LayoutObject}->Block(
                Name => 'Selection',
            );
            $Self->{LayoutObject}->Block(
                Name => 'NoRadioButton',
                Data => {
                    Name      => 'Dynamic-Object',
                    StateType => 'dynamic',
                }
            );
            $Self->{LayoutObject}->Block(
                Name => 'Selected',
                Data => {
                    SelectedKey => 'Object',
                    Selected    => $Stat->{Object},
                },
            );
        }
        # show the static file if it is selected
        elsif ($Stat->{StatType} eq 'static') {
            $Self->{LayoutObject}->Block(
                Name => 'Selection',
            );
            $Self->{LayoutObject}->Block(
                Name => 'NoRadioButton',
                Data => {
                    Name      => 'Static-File',
                    StateType => 'static',
                }                     );
            $Self->{LayoutObject}->Block(
                Name => 'Selected',
                Data => {
                    SelectedKey => 'File',
                    Selected    => $Stat->{File},
                },
            );
        }

        # create selectboxes 'Cache', 'SumRow', 'SumCol', and 'Valid'
        foreach my $Key (qw(Cache SumRow SumCol)) {
            $Frontend{'Select' . $Key} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data       =>{0 => 'No', 1 => 'Yes'},
                SelectedID => $Stat->{$Key},
                Name       => $Key,
            );
        }

        $Frontend{SelectValid} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       =>{0 => 'invalid', 1 => 'valid'},
            SelectedID => $Stat->{Valid},
            Name       => 'Valid',
        );

        # create multiselectboxes 'permission', 'format'  and 'graphsize'
        my %Values = ();
        $Values{Permission} = {$Self->{GroupObject}->GroupList(Valid => 1)};
        $Values{Format}     = $Self->{ConfigObject}->Get('Stats::Format');
        $Values{GraphSize}  = $Self->{ConfigObject}->Get('Stats::GraphSize');

        foreach my $Key (qw(Permission)) {
            $Stat->{'Select' . $Key} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data                => $Values{$Key},
                Name                => $Key,
                Multiple            => 1,
                Size                => 4,
                SelectedIDRefArray  => $Stat->{$Key},
                LanguageTranslation => 0,
            );
        }

        foreach my $Key (qw(Format GraphSize)) {
            $Stat->{'Select' . $Key} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data               => $Values{$Key},
                Name               => $Key,
                Multiple           => 1,
                Size               => 4,
                SelectedIDRefArray => $Stat->{$Key},
            );
        }
        # presentation
        $Output  = $Self->{LayoutObject}->Header(
            Area  => 'Stats',
            Title => 'Common Specification'
        );
        $Output .= $Self->{LayoutObject}->NavigationBar ();
        $Output .= $Self->_Notify(StatData => $Stat, Section => 'Specification');
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentStatsEditSpecification',
            Data         => {%{$Stat}, %Frontend},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # edit stats X-axis
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'EditXaxis') {
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # get params
        foreach (qw(StatID)) {
            if (!($Param{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "EditXaxis: Need $_!"
                );
            }
        }

        my $Stat = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});
        my $Flag = 0;

        foreach my $ObjectAttribute (@{$Stat->{UseAsXvalue}}) {
            my %BlockData       = ();
            $BlockData{Fixed}   = "checked=\"checked\"";
            $BlockData{Checked} = '';

            if ($ObjectAttribute->{Selected}) {
                $BlockData{Checked}    = "checked=\"checked\"";
                if (!$ObjectAttribute->{Fixed}) {
                    $BlockData{Fixed}   = "";
                }
            }

            if ($ObjectAttribute->{Block} eq 'SelectField') {
                 $ObjectAttribute->{Block} = 'MultiSelectField';
            }



            if ($ObjectAttribute->{Block} eq 'MultiSelectField') {
                $BlockData{SelectField} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data                => $ObjectAttribute->{Values},
                    Name                => $ObjectAttribute->{Element},
                    Multiple            => 1,
                    Size                => 4,
                    SelectedIDRefArray  => $ObjectAttribute->{SelectedValues},
                    LanguageTranslation => $ObjectAttribute->{LanguageTranslation},
                );
            }

            $BlockData{Name}    = $ObjectAttribute->{Name};
            $BlockData{Element} = $ObjectAttribute->{Element};

            # show the attribute block
            $Self->{LayoutObject}->Block(
                Name => 'Attribute',
            );

            # show line if needed
            if ($Flag) {
                $Self->{LayoutObject}->Block(
                    Name => 'hr',
                );
            }
            $Flag = 1;

            if ($ObjectAttribute->{Block} eq 'Time') {
                my $TimeType = $Self->{ConfigObject}->Get("Stats::TimeType") || 'Normal';
                if ($TimeType eq 'Time') {
                    $ObjectAttribute->{Block} = 'Time';
                }
                elsif ($TimeType eq 'Extended') {
                    $ObjectAttribute->{Block} = 'TimeExtended';
                }

                my %TimeData = _Timeoutput($Self, %{$ObjectAttribute});
                %BlockData = (%BlockData, %TimeData);
            }
            # show the input element
            $Self->{LayoutObject}->Block(
                Name => $ObjectAttribute->{Block},
                Data => \%BlockData,
            );
        }

        $Output  = $Self->{LayoutObject}->Header(
            Area  => 'Stats',
            Title => 'Xaxis'
        );
        $Output .= $Self->{LayoutObject}->NavigationBar ();
        $Output .= $Self->_Notify(StatData => $Stat, Section => 'Xaxis');
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentStatsEditXaxis',
            Data         => $Stat,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # edit stats ValueSeries
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'EditValueSeries') {
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # get params
        foreach (qw(StatID)) {
            if (!($Param{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "EditValueSeries: Need $_!"
                );
            }
        }

        my $Stat = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});
        my $Flag = 0;

        foreach my $ObjectAttribute (@{$Stat->{UseAsValueSeries}}) {
            my %BlockData       = ();
            $BlockData{Fixed}   = "checked=\"checked\"";
            $BlockData{Checked} = '';

            if ($ObjectAttribute->{Selected}) {
                $BlockData{Checked}   = "checked=\"checked\"";
                if (!$ObjectAttribute->{Fixed}) {
                    $BlockData{Fixed} = "";
                }
            }

            if ($ObjectAttribute->{Block} eq 'SelectField') {
                 $ObjectAttribute->{Block} = 'MultiSelectField';
            }

            if ($ObjectAttribute->{Block} eq 'MultiSelectField') {
                $BlockData{SelectField} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data                => $ObjectAttribute->{Values},
                    Name                => $ObjectAttribute->{Element},
                    Multiple            => 1,
                    Size                => 4,
                    SelectedIDRefArray  => $ObjectAttribute->{SelectedValues},
                    LanguageTranslation => $ObjectAttribute->{LanguageTranslation},
                );
            }

            $BlockData{Name}    = $ObjectAttribute->{Name};
            $BlockData{Element} = $ObjectAttribute->{Element};

            # show the attribute block
            $Self->{LayoutObject}->Block(
                Name => 'Attribute',
            );

            # show line if needed
            if ($Flag) {
                $Self->{LayoutObject}->Block(
                    Name => 'hr',
                );
            }
            $Flag = 1;

            if ($ObjectAttribute->{Block} eq 'Time') {
                my $TimeType = $Self->{ConfigObject}->Get("Stats::TimeType") || 'Normal';
                foreach (@{$Stat->{UseAsXvalue}}) {
                    if ($_->{Selected} && ($_->{Fixed} || (!$_->{SelectedValues}[1] && $TimeType eq 'Normal')) && $_->{Block} eq 'Time') {
                        $ObjectAttribute->{OnlySelectedAttributs} = 1;
                        if ($_->{SelectedValues}[0] eq 'Second') {
                            $ObjectAttribute->{SelectedValues} = ['Minute'];
                        }
                        elsif ($_->{SelectedValues}[0] eq 'Minute') {
                            $ObjectAttribute->{SelectedValues} = ['Hour'];
                        }
                        elsif ($_->{SelectedValues}[0] eq 'Hour') {
                            $ObjectAttribute->{SelectedValues} = ['Day'];
                        }
                        elsif ($_->{SelectedValues}[0] eq 'Day') {
                            $ObjectAttribute->{SelectedValues} = ['Month'];
                        }
                        elsif ($_->{SelectedValues}[0] eq 'Month') {
                            $ObjectAttribute->{SelectedValues} = ['Year'];
                        }
                    }
                    #needs an emprovement of the OnlySelectedAttributs function or a new Attribute!
                    #be careful of an clean code!
                    #elsif ($_->{Selected} && !$_->{Fixed}  && $_->{Block} eq 'Time') {
                    #    $ObjectAttribute->{OnlySelectedAttributs} = 1;
                    #    if ($_->{SelectedValues}[0] eq 'Second') {
                    #        $ObjectAttribute->{SelectedValues} = ['Minute','Hour','Day','Month','Year'];
                    #    }
                    #    elsif ($_->{SelectedValues}[0] eq 'Minute') {
                    #        $ObjectAttribute->{SelectedValues} = ['Hour','Day','Month','Year'];
                    #    }
                    #    elsif ($_->{SelectedValues}[0] eq 'Hour') {
                    #        $ObjectAttribute->{SelectedValues} = ['Day','Month','Year'];
                    #    }
                    #    elsif ($_->{SelectedValues}[0] eq 'Day') {
                    #        $ObjectAttribute->{SelectedValues} = ['Month','Year'];
                    #    }
                    #    elsif ($_->{SelectedValues}[0] eq 'Month') {
                    #        $ObjectAttribute->{SelectedValues} = ['Year'];
                    #    }
                    #}
                }

                if ($TimeType eq 'Normal') {
                    $ObjectAttribute->{Block} = 'Time';
                }
                elsif ($TimeType eq 'Extended') {
                    $ObjectAttribute->{Block} = 'TimeExtended';
                }


                my %TimeData = _Timeoutput($Self, %{$ObjectAttribute});
                %BlockData = (%BlockData, %TimeData);
            }

            # show the input element
            $Self->{LayoutObject}->Block(
                Name => $ObjectAttribute->{Block},
                Data => \%BlockData,
            );
        }

        # presentation
        $Output  = $Self->{LayoutObject}->Header(
            Area => 'Stats',
            Title => 'Value Series',
        );
        $Output .= $Self->{LayoutObject}->NavigationBar ();
        $Output .= $Self->_Notify(StatData => $Stat, Section => 'ValueSeries');
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentStatsEditValueSeries',
            Data         => $Stat,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # edit stats restrictions
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'EditRestrictions') {
        # permission check
        $Self->{AccessRw} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');

        # get params
        foreach (qw(StatID)) {
            if (!($Param{$_} = $Self->{ParamObject}->GetParam(Param => $_))) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "EditRestrictions: Need $_!",
                );
            }
        }

        my $Stat = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});
        my $Flag = 0;
        foreach my $ObjectAttribute (@{$Stat->{UseAsRestriction}}) {
            my %BlockData       = ();
            $BlockData{Fixed}   = "checked=\"checked\"";
            $BlockData{Checked} = '';

            if ($ObjectAttribute->{Selected}) {
                $BlockData{Checked}   = "checked=\"checked\"";
                if (!$ObjectAttribute->{Fixed}) {
                    $BlockData{Fixed} = "";
                }
            }

            if ($ObjectAttribute->{SelectedValues}) {
                $BlockData{SelectedValue} = $ObjectAttribute->{SelectedValues}[0];
            }
            else {
                $BlockData{SelectedValue}          = '';
                $ObjectAttribute->{SelectedValues} = undef;
            }

            if ($ObjectAttribute->{Block} eq 'MultiSelectField' || $ObjectAttribute->{Block} eq 'SelectField') {
                $BlockData{SelectField} = $Self->{LayoutObject}->OptionStrgHashRef(
                    Data               => $ObjectAttribute->{Values},
                    Name               => $ObjectAttribute->{Element},
                    Multiple           => 1,
                    Size               => 4,
                    SelectedIDRefArray => $ObjectAttribute->{SelectedValues},
                    LanguageTranslation => $ObjectAttribute->{LanguageTranslation},
                );
            }

            $BlockData{Element} = $ObjectAttribute->{Element};
            $BlockData{Name}    = $ObjectAttribute->{Name};

            # show the attribute block
            $Self->{LayoutObject}->Block(
                Name => 'Attribute',
            );
            if ($ObjectAttribute->{Block} eq 'Time') {
                my $TimeType = $Self->{ConfigObject}->Get("Stats::TimeType") || 'Normal';
                if ($TimeType eq 'Normal') {
                    $ObjectAttribute->{Block} = 'Time';
                }
                elsif ($TimeType eq 'Extended') {
                    $ObjectAttribute->{Block} = 'TimeExtended';
                }

                my %TimeData = _Timeoutput($Self, %{$ObjectAttribute});
                %BlockData = (%BlockData, %TimeData);
            }

            # show the input element
            $Self->{LayoutObject}->Block(
                Name => $ObjectAttribute->{Block},
                Data => \%BlockData,
            );
            # show line if needed
            if ($Flag) {
                $Self->{LayoutObject}->Block(
                    Name => 'hr',
                );
            }
            $Flag = 1;
        }

        # presentation
        $Output  = $Self->{LayoutObject}->Header(
            Area  => 'Stats',
            Title => 'Restrictions',
        );
        $Output .= $Self->{LayoutObject}->NavigationBar ();
        $Output .= $Self->_Notify(StatData => $Stat, Section => 'Restrictions');
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentStatsEditRestrictions',
            Data         => $Stat,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # ---------------------------------------------------------- #
    # edit stats running
    # ---------------------------------------------------------- #
    elsif ($Self->{Subaction} eq 'Run') {
        # permission check
        $Self->{AccessRo} || return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        # get params
        foreach (qw (Format GraphSize StatID ExchangeAxis)) {
            $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }

        foreach (qw(Format StatID)) {
            if (!$Param{$_}){
                return $Self->{LayoutObject}->ErrorScreen(Message => "Run: Get no $_!");
            }
        }

        if ($Param{Format} =~ /^GD::Graph\.*/ && !$Param{GraphSize}) {
            return $Self->{LayoutObject}->ErrorScreen(Message => "Run: Need GraphSize!");
        }

        my $Stat = $Self->{StatsObject}->StatsGet(StatID => $Param{StatID});

        # permission check
        if (!$Self->{AccessRw}) {
            my $UserPermission = 0;
            # get user groups
            my @Groups = $Self->{GroupObject}->GroupMemberList(
                UserID => $Self->{UserID},
                Type   => 'ro',
                Result => 'ID',
            );
            if ($Stat->{Valid}) {
                MARKE: foreach my $GroupID (@{$Stat->{Permission}}) {
                    foreach my $UserGroup (@Groups) {
                        if ($GroupID == $UserGroup) {
                            $UserPermission = 1;
                            last MARKE;
                            last;
                        }
                    }
                }
            }
            if(!$UserPermission) {
                return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
            }
        }

        # get params
        my %GetParam = ();
        # not sure, if this is the right way
        if ($Stat->{StatType} eq 'static') {
            my $Params   = $Self->{StatsObject}->GetParams(StatID => $Param{StatID});
            foreach my $ParamItem (@{$Params}) {
                # param is array
                if ($ParamItem->{Multiple}) {
                    my @Array = $Self->{ParamObject}->GetArray(Param => $ParamItem->{Name});
                    $GetParam{$ParamItem->{Name}} = \@Array;
                }
                # param is string
                else {
                    $GetParam{$ParamItem->{Name}} = $Self->{ParamObject}->GetParam(Param => $ParamItem->{Name});
                }
            }
        }
        else {
            my $TimePeriod = 0;
            foreach my $Use (qw(UseAsRestriction UseAsXvalue UseAsValueSeries)) {
                my @Array = @{$Stat->{$Use}};
                my $Counter = 0;
                foreach my $Element (@Array) {
                    if ($Element->{Selected}) {
                        if (!$Element->{Fixed}) {
                            if ($Self->{ParamObject}->GetArray(Param => $Use . '->' . $Element->{Element})) {
                                my @SelectedValues = $Self->{ParamObject}->GetArray(Param => $Use . '->' . $Element->{Element});
                                $Element->{SelectedValues} = \@SelectedValues;
                            }
                            if ($Element->{Block} eq 'Time') {
                                if ($Self->{ParamObject}->GetParam(Param => $Use . "->" . $Element->{Element} . "StartYear")) {
                                    my %Time = ();
                                    foreach my $Limit (qw(Start Stop)) {
                                        foreach my $Unit (qw(Year Month Day Hour Minute Second)) {
                                            if (defined($Self->{ParamObject}->GetParam(Param => $Use . "->" . $Element->{Element} . "$Limit$Unit"))) {
                                                $Time{$Limit . $Unit} = $Self->{ParamObject}->GetParam(
                                                    Param => $Use . "->" . $Element->{Element} . "$Limit$Unit"
                                                );
                                            }
                                        }
                                        if (!defined($Time{$Limit . "Hour"})) {
                                            if ($Limit eq 'Start') {
                                                $Time{"StartHour"} = 0;
                                                $Time{"StartMinute"} = 0;
                                                $Time{"StartSecond"} = 0;
                                            }
                                            elsif ($Limit eq 'Stop') {
                                                $Time{"StopHour"} = 23;
                                                $Time{"StopMinute"} = 59;
                                                $Time{"StopSecond"} = 59;
                                            }
                                        }
                                        elsif (!defined($Time{$Limit . "Second"})) {
                                            if ($Limit eq 'Start') {
                                                $Time{"StartSecond"} = 0;
                                            }
                                            elsif ($Limit eq 'Stop') {
                                                $Time{"StopSecond"} = 59;
                                            }
                                        }
                                        $Time{"Time$Limit"} =
                                            sprintf("%04d-%02d-%02d %02d:%02d:%02d",
                                            $Time{$Limit . "Year"},
                                            $Time{$Limit . "Month"},
                                            $Time{$Limit . "Day"},
                                            $Time{$Limit . "Hour"},
                                            $Time{$Limit . "Minute"},
                                            $Time{$Limit . "Second"},
                                        ); # Second for later functions
                                    }
                                    # integrate this functionality in the completenesscheck
                                    if ($Self->{TimeObject}->TimeStamp2SystemTime(String => $Time{TimeStart}) > $Self->{TimeObject}->TimeStamp2SystemTime(String => $Element->{TimeStart})) {
                                        # redirect to edit
                                        return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                                            "Subaction=View&StatID=$Param{StatID}&Message=1"
                                        );
                                        #$Element->{TimeStart} = $Time{TimeStart};
                                    }
                                    # integrate this functionality in the completenesscheck
                                    if ($Self->{TimeObject}->TimeStamp2SystemTime(String => $Time{TimeStop}) < $Self->{TimeObject}->TimeStamp2SystemTime(String => $Element->{TimeStop})) {
                                        return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                                            "Subaction=View&StatID=$Param{StatID}&Message=2"
                                        );
                                        #$Element->{TimeStop} = $Time{TimeStop};
                                    }
                                    $TimePeriod = ($Self->{TimeObject}->TimeStamp2SystemTime(String => $Element->{TimeStop})) - ($Self->{TimeObject}->TimeStamp2SystemTime(String => $Element->{TimeStart}));
                                }
                                else {
                                    my %Time = ();
                                    my $TimePeriodAdmin = 0;
                                    my $TimePeriodAgent = 0;
                                    my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
                                        SystemTime => $Self->{TimeObject}->SystemTime(),
                                    );

                                    $Time{TimeRelativeUnit}  = $Self->{ParamObject}->GetParam(Param => $Use . "->" . $Element->{Element} . 'TimeRelativeUnit');
                                    if ($Self->{ParamObject}->GetParam(Param => $Use . "->" . $Element->{Element} . 'TimeRelativeCount')) {
                                        $Time{TimeRelativeCount} = $Self->{ParamObject}->GetParam(Param => $Use . "->" . $Element->{Element} . 'TimeRelativeCount');
                                    }
                                    if ($Element->{TimeRelativeUnit} eq 'Year') {
                                        $TimePeriodAdmin = $Element->{TimeRelativeCount}*60*60*24*365;
                                    }
                                    elsif ($Element->{TimeRelativeUnit} eq 'Month') {
                                        $TimePeriodAdmin = $Element->{TimeRelativeCount}*60*60*24*30;
                                    }
                                    elsif ($Element->{TimeRelativeUnit} eq 'Day') {
                                        $TimePeriodAdmin = $Element->{TimeRelativeCount}*60*60*24;
                                    }
                                    elsif ($Element->{TimeRelativeUnit} eq 'Hour') {
                                        $TimePeriodAdmin = $Element->{TimeRelativeCount}*60*60;
                                    }
                                    elsif ($Element->{TimeRelativeUnit} eq 'Minute') {
                                        $TimePeriodAdmin = $Element->{TimeRelativeCount}*60;
                                    }
                                    elsif ($Element->{TimeRelativeUnit} eq 'Second') {
                                        $TimePeriodAdmin = $Element->{TimeRelativeCount};
                                    }

                                    if ($Time{TimeRelativeUnit} eq 'Year') {
                                        $TimePeriodAgent = $Time{TimeRelativeCount}*60*60*24*365;
                                    }
                                    elsif ($Time{TimeRelativeUnit} eq 'Month') {
                                        $TimePeriodAgent = $Time{TimeRelativeCount}*60*60*24*30;
                                    }
                                    elsif ($Time{TimeRelativeUnit} eq 'Day') {
                                        $TimePeriodAgent = $Time{TimeRelativeCount}*60*60*24;
                                    }
                                    elsif ($Time{TimeRelativeUnit} eq 'Hour') {
                                        $TimePeriodAgent = $Time{TimeRelativeCount}*60*60;
                                    }
                                    elsif ($Time{TimeRelativeUnit} eq 'Minute') {
                                        $TimePeriodAgent = $Time{TimeRelativeCount}*60;
                                    }
                                    elsif ($Time{TimeRelativeUnit} eq 'Second') {
                                        $TimePeriodAgent = $Time{TimeRelativeCount};
                                    }
                                    # integrate this functionality in the completenesscheck
                                    if ($TimePeriodAgent < $TimePeriodAdmin) {
                                        return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                                            "Subaction=View&StatID=$Param{StatID}&Message=3"
                                        );
                                        #$Element->{TimeRelativeUnit} = $Time{TimeRelativeUnit};
                                        #$Element->{TimeRelativeCount} = $Time{TimeRelativeCount};
                                    }

                                    $TimePeriod = $TimePeriodAgent;
                                }
                                if ($Self->{ParamObject}->GetParam(Param => $Use . "->" . $Element->{Element} . 'TimeScaleCount')) {
                                    $Element->{TimeScaleCount} = $Self->{ParamObject}->GetParam(Param => $Use . "->" . $Element->{Element} . 'TimeScaleCount');
                                }
                                else {
                                    $Element->{TimeScaleCount} = 1;
                                }
                            }
                        }
                        # not realy needed because the GenerateStats function can do the same
                        #else {
                        #    if (!$Element->{SelectedValues}) {
                        #        if (!$Element->{SelectedValues}[0] && $Element->{Block} ne 'Time') {
                        #            my @Values = keys (%{$Element->{Values}});
                        #            $Element->{SelectedValues} = \@Values;
                        #        }
                        #    }
                        #}
                        $GetParam{$Use}[$Counter] = $Element;
                        $Counter++;
                    }
                }
                if (ref($GetParam{$Use}) ne 'ARRAY') {
                    $GetParam{$Use} = [];
                }
            }
            # check if the timeperiod is to big or the time scale to small
            if ($GetParam{UseAsValueSeries}[0]{Block} ne 'Time' && $GetParam{UseAsXvalue}[0]{Block} eq 'Time') {
                my $ScalePeriod = 0;
                if ($GetParam{UseAsXvalue}[0]{SelectedValues}[0] eq 'Second') {
                    $ScalePeriod = 1;
                }
                elsif ($GetParam{UseAsXvalue}[0]{SelectedValues}[0] eq 'Minute') {
                    $ScalePeriod = 60;
                }
                elsif ($GetParam{UseAsXvalue}[0]{SelectedValues}[0] eq 'Hour') {
                    $ScalePeriod = 60 * 60;
                }
                elsif ($GetParam{UseAsXvalue}[0]{SelectedValues}[0] eq 'Day') {
                    $ScalePeriod = 60 * 60 * 24;
                }
                elsif ($GetParam{UseAsXvalue}[0]{SelectedValues}[0] eq 'Month') {
                    $ScalePeriod = 60 * 60 * 24 * 30;
                }
                elsif ($GetParam{UseAsXvalue}[0]{SelectedValues}[0] eq 'Year') {
                    $ScalePeriod = 60 * 60 * 24 * 365;
                }
                # integrate this functionality in the completenesscheck
                if ($TimePeriod / ($ScalePeriod * $GetParam{UseAsXvalue}[0]{TimeScaleCount}) > ($Self->{ConfigObject}->Get('Stats::MaxXaxisAttributes') || 100)) {
                    return $Self->{LayoutObject}->Redirect(OP => "Action=AgentStats&" .
                        "Subaction=View&StatID=$Param{StatID}&Message=4"
                    );
                }
            }
        }

        # run stat...
        my @StatArray = @{$Self->{StatsObject}->StatsRun(
            StatID   => $Param{StatID},
            GetParam => \%GetParam,
        )};

        # exchange axis if selected
        if ($Param{ExchangeAxis}) {
            my @NewStatArray = ();
            my $Title = $StatArray[0][0];

            shift(@StatArray);
            foreach my $Key1 (0..$#StatArray) {
                foreach my $Key2 (0..$#{$StatArray[0]}) {
                    $NewStatArray[$Key2][$Key1] = $StatArray[$Key1][$Key2];
                }
            }
            $NewStatArray[0][0] = '';
            unshift(@NewStatArray, [$Title]);
            @StatArray = @NewStatArray;
        }

        # presentation
        my $TitleArrayRef = shift (@StatArray);
        my $Title = $TitleArrayRef->[0];
        my $HeadArrayRef = shift (@StatArray);
        # if array = empty
        if (!@StatArray) {
            push(@StatArray, [' ',0]);
        }
        # Gernerate Filename
        my $Filename = $Self->{StatsObject}->StringAndTimestamp2Filename(
            String => $Title . " Created",
        );

        # csv output
        if ($Param{Format} eq 'CSV') {
            my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
               SystemTime => $Self->{TimeObject}->SystemTime(),
            );
            my $Time = sprintf("%04d-%02d-%02d %02d:%02d:%02d",$Y,$M,$D,$h,$m,$s);
            my $Output = "Name: $Title; Created: $Time\n";
            $Output .= $Self->{CSVObject}->Array2CSV(
                Head => $HeadArrayRef,
                Data => \@StatArray,
            );

            return $Self->{LayoutObject}->Attachment(
                Filename    => $Filename . ".csv",
                ContentType => "text/csv",
                Content     => $Output,
            );
        }
        # pdf or html output
        elsif ($Param{Format} eq 'Print') {
            # PDF Output
            if ($Self->{PDFObject}) {
                my $PrintedBy = $Self->{LayoutObject}->{LanguageObject}->Get('printed by');
                my $Page = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
                my $Time = $Self->{LayoutObject}->Output(Template => '$Env{"Time"}');
                my $Url = ' ';
                if ($ENV{REQUEST_URI}) {
                    $Url = $Self->{ConfigObject}->Get('HttpType') . '://' .
                        $Self->{ConfigObject}->Get('FQDN') .
                        $ENV{REQUEST_URI};
                }
                # get maximum number of pages
                my $MaxPages = $Self->{ConfigObject}->Get('PDF::MaxPages');
                if (!$MaxPages || $MaxPages < 1 || $MaxPages > 1000) {
                    $MaxPages = 100;
                }
                # create the header
                my $CellData;
                my $CounterRow = 0;
                my $CounterHead = 0;
                foreach my $Content (@{$HeadArrayRef}) {
                    $CellData->[$CounterRow]->[$CounterHead]->{Content} = $Content;
                    $CellData->[$CounterRow]->[$CounterHead]->{Font} = 'HelveticaBold';
                    $CounterHead++;
                }
                if ($CounterHead > 0) {
                    $CounterRow++;
                }
                # create the content array
                foreach my $Row (@StatArray) {
                    my $CounterColumn = 0;
                    foreach my $Content (@{$Row}) {
                        $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
                        $CounterColumn++;
                    }
                    $CounterRow++;
                }
                # output 'No Result', if no content was given
                if (!$CellData->[0]->[0]) {
                    $CellData->[0]->[0]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('No Result!');
                }
                # page params
                my %PageParam;
                $PageParam{PageOrientation} = 'landscape';
                $PageParam{MarginTop} = 30;
                $PageParam{MarginRight} = 40;
                $PageParam{MarginBottom} = 40;
                $PageParam{MarginLeft} = 40;
                $PageParam{HeaderRight} = $Self->{ConfigObject}->Get('Stats::StatsHook') . $Stat->{StatNumber};
                $PageParam{FooterLeft} = $Url;
                $PageParam{HeadlineLeft} = $Title;
                $PageParam{HeadlineRight} = $PrintedBy . ' ' .
                    $Self->{UserFirstname} . ' ' .
                    $Self->{UserLastname} . ' (' .
                    $Self->{UserEmail} . ') ' .
                    $Time;
                # table params
                my %TableParam;
                $TableParam{CellData} = $CellData;
                $TableParam{Type} = 'Cut';
                $TableParam{FontSize} = 6;
                $TableParam{Border} = 0;
                $TableParam{BackgroundColorEven} = '#AAAAAA';
                $TableParam{BackgroundColorOdd} = '#DDDDDD';
                $TableParam{Padding} = 1;
                $TableParam{PaddingTop} = 3;
                $TableParam{PaddingBottom} = 3;

                # create new pdf document
                $Self->{PDFObject}->DocumentNew(
                    Title => $Self->{ConfigObject}->Get('Product') . ': ' . $Title,
                );
                # start table output
                $Self->{PDFObject}->PageNew(
                    %PageParam,
                    FooterRight => $Page . ' 1',
                );
                for (2..$MaxPages) {
                    # output table (or a fragment of it)
                    %TableParam = $Self->{PDFObject}->Table(
                        %TableParam,
                    );
                    # stop output or output next page
                    if ($TableParam{State}) {
                        last;
                    }
                    else {
                        $Self->{PDFObject}->PageNew(
                            %PageParam,
                            FooterRight => $Page . ' ' . $_,
                        );
                    }
                }
                # return the pdf document
                my $PDFString = $Self->{PDFObject}->DocumentOutput();
                return $Self->{LayoutObject}->Attachment(
                    Filename => $Filename . '.pdf',
                    ContentType => "application/pdf",
                    Content => $PDFString,
                    Type => 'attachment',
                );
            }
            # HTML Output
            else {
                #if ($Stat->{StatType} eq 'dynamic') {
                #    my %Name = (
                #        UseAsXvalue      => 'X-axis',
                #        UseAsValueSeries => 'ValueSeries',
                #        UseAsRestriction => 'Restriction',
                #    );

                #    foreach my $Use (qw(UseAsXvalue UseAsValueSeries UseAsRestriction)) {
                #        my $Flag = 0;
                #        $Self->{LayoutObject}->Block(
                #            Name => 'Dynamic',
                #            Data => {Name => $Name{$Use}},
                #        );
                #        foreach my $ObjectAttribute (@{$GetParam{$Use}}) {
                #            my %ValueHash = ();
                #            $Flag = 1;

                #            # Select All function
                #            if (!$ObjectAttribute->{SelectedValues}[0]) {
                #                my @Values = keys (%{$ObjectAttribute->{Values}});
                #                $ObjectAttribute->{SelectedValues} = \@Values;
                #            }

                #           foreach (@{$ObjectAttribute->{SelectedValues}}) {
                #                if ($ObjectAttribute->{Values}) {
                #                    $ValueHash{$_} = $ObjectAttribute->{Values}{$_};
                #                }
                #                else {
                #                    $ValueHash{Value} = $_;
                #                }
                #            }

                #            $Self->{LayoutObject}->Block(
                #                Name => 'Element',
                #                Data => {Name => $ObjectAttribute->{Name}},
                #            );

                #            # show fixed elements
                #            if ($ObjectAttribute->{Block} eq 'Time') {
                #                # required because of the SELECTALL function
                #                if ($Use eq 'UseAsRestriction') {
                #                    delete ($ObjectAttribute->{SelectedValues});
                #                }
                #                my $TimeScale = _TimeScale();
                #                if ($ObjectAttribute->{TimeStart}) {
                #                    $Self->{LayoutObject}->Block(
                #                        Name => 'TimePeriodFixed',
                #                        Data => {
                #                            TimeStart => $ObjectAttribute->{TimeStart},
                #                            TimeStop  => $ObjectAttribute->{TimeStop},
                #                        },
                #                    );
                #                }
                #                if ($ObjectAttribute->{SelectedValues}[0]) {
                #                    $Self->{LayoutObject}->Block(
                #                        Name => 'TimeScaleFixed',
                #                        Data => {
                #                            Scale => $TimeScale->{$ObjectAttribute->{SelectedValues}[0]}{Value},
                #                            Count => $ObjectAttribute->{TimeScaleCount},
                #                        },
                #                    );
                #                }
                #            }
                #            else {
                #                foreach (sort{$ValueHash{$a} cmp $ValueHash{$b}} keys %ValueHash) {
                #                    $Self->{LayoutObject}->Block(
                #                        Name => 'Fixed',
                #                        Data => {Value => $ValueHash{$_}},
                #                    );
                #                }
                #            }
                #        }
                #        # Show this Block if no valueseries or restrictions are selected
                #        if (!$Flag) {
                #            $Self->{LayoutObject}->Block(
                #                Name => 'NoElement',
                #            );
                #        }
                #    }
                #}

                #$Stat->{Description} = $Self->{LayoutObject}->Ascii2Html(
                #    Text           => $Stat->{Description},
                #    HTMLResultMode => 1,
                #    NewLine        => 72,
                #);


                $Stat->{Table} = $Self->{LayoutObject}->OutputHTMLTable(
                    Head => $HeadArrayRef,
                    Data => \@StatArray,
                );

                $Stat->{Title} = $Title;

                # presentation
                my $Output = $Self->{LayoutObject}->PrintHeader(Value => $Title);
                $Output .= $Self->{LayoutObject}->Output(
                    Data         => $Stat,
                    TemplateFile => 'AgentStatsPrint',
                );
                $Output .= $Self->{LayoutObject}->PrintFooter();
                return $Output;
            }
        }
        # graph
        elsif ($Param{Format} =~ /^GD::Graph\.*/) {
            # make graph
            my $Ext = 'png';
            my $Graph = $Self->{StatsObject}->GenerateGraph(
                Array        => \@StatArray,
                HeadArrayRef => $HeadArrayRef,
                Title        => $Title,
                Format       => $Param{Format},
                GraphSize    => $Param{GraphSize},
            );
            if (!$Graph) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "To much data, can't use it with graph!",
                );
            }

            # return image to bowser
            return $Self->{LayoutObject}->Attachment(
                Filename    => $Filename . "." . $Ext,
                ContentType => "image/$Ext",
                Content     => $Graph,
                Type        => 'inline',
            );
        }
    }
    # ---------------------------------------------------------- #
    # show error screen
    # ---------------------------------------------------------- #
    return $Self->{LayoutObject}->ErrorScreen(Message => "Invalid Subaction process!");
}

sub _Notify {
    my $Self  = shift;
    my %Param = @_;
    my $NotifyOutput = '';

    # check if need params are available
    foreach (qw(StatData Section)) {
        if (!$Param{$_}) {
            return $Self->{LayoutObject}->ErrorScreen(Message => "_Notify: Need $_!");
        }
    }
    # CompletenessCheck
    my @Notify = $Self->{StatsObject}->CompletenessCheck(
        StatData => $Param{StatData},
        Section  => $Param{Section},
    );

    foreach my $Ref (@Notify) {
        $NotifyOutput .= $Self->{LayoutObject}->Notify(%{$Ref});
    }
    return $NotifyOutput;
}

sub _Timeoutput {
    my $Self  = shift;
    my %Param = @_;
    my %Timeoutput = ();

    # check if need params are available
    foreach (qw(TimePeriodFormat)) {
        if (!$Param{$_}) {
            return $Self->{LayoutObject}->ErrorScreen(Message => "_Timeoutput: Need !");
        }
    }

    # get time
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    my $Element = $Param{Element};
    my %TimeConfig = ();
    # default time configuration
    $TimeConfig{Format} = $Param{TimePeriodFormat};
    $TimeConfig{$Element . 'StartYear'}   = $Year -1;
    $TimeConfig{$Element . 'StartMonth'}  = 1;
    $TimeConfig{$Element . 'StartDay'}    = 1;
    $TimeConfig{$Element . 'StartHour'}   = 0;
    $TimeConfig{$Element . 'StartMinute'} = 0;
    $TimeConfig{$Element . 'StartSecond'} = 1;
    $TimeConfig{$Element . 'StopYear'}    = $Year;
    $TimeConfig{$Element . 'StopMonth'}   = 12;
    $TimeConfig{$Element . 'StopDay'}     = 31;
    $TimeConfig{$Element . 'StopHour'}    = 23;
    $TimeConfig{$Element . 'StopMinute'}  = 59;
    $TimeConfig{$Element . 'StopSecond'}  = 59;

    foreach (qw(Start Stop)) {
        $TimeConfig{Prefix} = $Element . $_;
        # time setting if avialable
        if ($Param{'Time' . $_} && $Param{'Time' . $_} =~ /^(\d\d\d\d)-(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)$/i) {
            $TimeConfig{$Element . $_ . 'Year'}   = $1;
            $TimeConfig{$Element . $_ . 'Month'}  = $2;
            $TimeConfig{$Element . $_ . 'Day'}    = $3;
            $TimeConfig{$Element . $_ . 'Hour'}   = $4;
            $TimeConfig{$Element . $_ . 'Minute'} = $5;
            $TimeConfig{$Element . $_ . 'Second'} = $6;
        }
        $Timeoutput{'Time' . $_} = $Self->{LayoutObject}->BuildDateSelection(%TimeConfig);
    }

    # Solution I (TimeExtended)
    my %TimeLists = ();
    foreach (1..60) {
        $TimeLists{TimeRelativeCount}{$_} = sprintf("%02d",$_);
        $TimeLists{TimeScaleCount}{$_}    = sprintf("%02d",$_);
    }

    foreach (qw(TimeRelativeCount  TimeScaleCount)) {
        $Timeoutput{$_} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data       => $TimeLists{$_},
            Name       => $Element . $_,
            SelectedID => $Param{$_},
        );
    }

    if ($Param{TimeRelativeCount} && $Param{TimeRelativeUnit}) {
        $Timeoutput{CheckedRelative} = "checked=\"checked\"";
    }
    else {
        $Timeoutput{CheckedAbsolut} = "checked=\"checked\"";
    }

    my $Data = _TimeScale();
    if ($Param{SelectedValues}[0]) {
        $Data->{$Param{SelectedValues}[0]}{Selected} = 1;
    }

    $Timeoutput{TimeScaleUnit} = $Self->{LayoutObject}->OptionElement(
        Name            => $Element,
        Data            => $Data,
    );

    $Data = _TimeScale();
    if ($Param{TimeRelativeUnit}) {
        $Data->{$Param{TimeRelativeUnit}}{Selected} = 1;
    }

    $Timeoutput{TimeRelativeUnit} = $Self->{LayoutObject}->OptionElement(
        Name            => $Element . 'TimeRelativeUnit',
        Data            => $Data,
    );

    $Data     = _TimeScale();
    my $Multiple = 1;
    my $Size     = 4;

    foreach (@{$Param{SelectedValues}}){
        $Data->{$_}{Selected} = 1
    }

    # to show only the selected Attributs in the view mask
    if ($Param{OnlySelectedAttributs}) {
        foreach (keys %{$Data}) {
            if (!$Data->{$_}{Selected}) {
                delete($Data->{$_});
            }
        }
        $Multiple = 0;
        $Size     = 0;
    }

    $Timeoutput{TimeSelectField} = $Self->{LayoutObject}->OptionElement(
        Name            => $Element,
        Data            => $Data,
        Multiple        => $Multiple,
        Size            => $Size,
    );
    return %Timeoutput;
}

sub _TimeScale {
    my %TimeScale = ('Second'  => {
            Position    => 1,
            Value       => 'second(s)',
        },
        'Minute' => {
            Position    => 2,
            Value       => 'minute(s)',
        },
        'Hour' => {
            Position    => 3,
            Value       => 'hour(s)',
        },
        'Day' => {
            Position    => 4,
            Value       => 'day(s)',
        },
        'Month' => {
            Position    => 5,
            Value       => 'month(s)',
        },
        'Year' => {
            Position    => 6,
            Value       => 'year(s)',
        },
    );

   return \%TimeScale;
}

# --
1;
