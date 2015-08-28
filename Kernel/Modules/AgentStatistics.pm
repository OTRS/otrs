# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentStatistics;

use strict;
use warnings;

use List::Util qw( first );

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    for my $NeededData (qw( UserID Subaction AccessRo SessionID ))
    {
        if ( !$Param{$NeededData} ) {
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError( Message => "Got no $NeededData!" );
        }
        $Self->{$NeededData} = $Param{$NeededData};
    }

    # AccessRw controls the adding/editing of statistics.
    for my $Param (qw( AccessRw RequestedURL LastStatsOverview)) {
        if ( $Param{$Param} ) {
            $Self->{$Param} = $Param{$Param};
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Subaction = $Self->{Subaction};

    my %RoSubactions = (
        Overview => 'OverviewScreen',
        View     => 'ViewScreen',
        Run      => 'RunAction',
    );

    if ( $RoSubactions{$Subaction} ) {
        if ( !$Self->{AccessRo} ) {
            return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->NoPermission( WithHeader => 'yes' );
        }
        my $Method = $RoSubactions{$Subaction};
        return $Self->$Method();
    }

    my %RwSubactions = (
        Add                             => 'AddScreen',
        AddAction                       => 'AddAction',
        Edit                            => 'EditScreen',
        EditAction                      => 'EditAction',
        Import                          => 'ImportScreen',
        ImportAction                    => 'ImportAction',
        ExportAction                    => 'ExportAction',
        DeleteAction                    => 'DeleteAction',
        ExportAction                    => 'ExportAction',
        GeneralSpecificationsWidgetAJAX => 'GeneralSpecificationsWidgetAJAX',
    );

    if ( $RwSubactions{$Subaction} ) {
        if ( !$Self->{AccessRw} ) {
            return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->NoPermission( WithHeader => 'yes' );
        }
        my $Method = $RwSubactions{$Subaction};
        return $Self->$Method();
    }

    # No (known) subaction?
    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->ErrorScreen( Message => 'Invalid Subaction.' );
}

sub OverviewScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastStatsOverview',
        Value     => $Self->{RequestedURL},
        StoreData => 1,
    );

    # Get Params
    $Param{SearchPageShown} = $ConfigObject->Get('Stats::SearchPageShown') || 50;
    $Param{SearchLimit}     = $ConfigObject->Get('Stats::SearchLimit')     || 1000;
    $Param{OrderBy}   = $ParamObject->GetParam( Param => 'OrderBy' )   || 'ID';
    $Param{Direction} = $ParamObject->GetParam( Param => 'Direction' ) || 'ASC';
    $Param{StartHit} = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );

    # store last screen
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastStatsOverview',
        Value     => $Self->{RequestedURL},
        StoreData => 1,
    );

    # get all Stats from the db
    my $Result = $Kernel::OM->Get('Kernel::System::Stats')->GetStatsList(
        AccessRw  => $Self->{AccessRw},
        OrderBy   => $Param{OrderBy},
        Direction => $Param{Direction},
        UserID    => $Self->{UserID},
    );

    if ( $Param{StartHit} > 1 && $Param{StartHit} > scalar @{ $Result || [] } ) {
        return $LayoutObject->Redirect( OP => "Action=AgentStatistics;Subaction=Overview" );
    }

    my %Order2CSSSort = (
        ASC  => 'SortAscending',
        DESC => 'SortDescending',
    );

    my %InverseSorting = (
        ASC  => 'DESC',
        DESC => 'ASC',
    );

    $Param{ 'CSSSort' . $Param{OrderBy} } = $Order2CSSSort{ $Param{Direction} };
    for my $Type (qw(ID Title Object)) {
        $Param{"LinkSort$Type"} = ( $Param{OrderBy} eq $Type ) ? $InverseSorting{ $Param{Direction} } : 'ASC';
    }

    # build the info
    my %Pagination = $LayoutObject->PageNavBar(
        Limit     => $Param{SearchLimit},
        StartHit  => $Param{StartHit},
        PageShown => $Param{SearchPageShown},
        AllHits   => $#{$Result} + 1,
        Action    => 'Action=AgentStatistics;Subaction=Overview',
        Link      => ";Direction=$Param{Direction};OrderBy=$Param{OrderBy};",
        IDPrefix  => 'AgentStatisticsOverview'
    );

    # list result
    my $Index = -1;
    for ( my $Z = 0; ( $Z < $Param{SearchPageShown} && $Index < $#{$Result} ); $Z++ ) {
        $Index = $Param{StartHit} + $Z - 1;
        my $StatID = $Result->[$Index];
        my $Stat   = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
            StatID             => $StatID,
            NoObjectAttributes => 1,
            UserID             => $Self->{UserID},
        );

        # get the object name
        if ( $Stat->{StatType} eq 'static' ) {
            $Stat->{ObjectName} = $Stat->{File};
        }

        # if no object name is defined use an empty string
        $Stat->{ObjectName} ||= '';

        $LayoutObject->Block(
            Name => 'Result',
            Data => {
                %$Stat,
                AccessRw => $Self->{AccessRw},
            },
        );
    }

    # build output
    my $Output = $LayoutObject->Header( Title => 'Overview' );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        Data => {
            %Pagination,
            %Param,
            AccessRw => $Self->{AccessRw},
        },
        TemplateFile => 'AgentStatisticsOverview',
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub ImportScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Errors = %{ $Param{Errors} // {} };

    my $Output = $LayoutObject->Header( Title => 'Import' );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentStatisticsImport',
        Data         => {
            %Errors,
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub ImportAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my %Errors;

    # challenge token check for write action
    $LayoutObject->ChallengeTokenCheck();

    my $UploadFile = $ParamObject->GetParam( Param => 'File' );
    if ($UploadFile) {
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param    => 'File',
            Encoding => 'Raw'
        );
        if ( $UploadStuff{Content} =~ m{<otrs_stats>}x ) {
            my $StatID = $Kernel::OM->Get('Kernel::System::Stats')->Import(
                Content => $UploadStuff{Content},
                UserID  => $Self->{UserID},
            );

            if ($StatID) {
                $Errors{FileServerError}        = 'ServerError';
                $Errors{FileServerErrorMessage} = Translatable("Statistic could not be imported.");
            }

            # redirect to configure
            return $LayoutObject->Redirect(
                OP => "Action=AgentStatistics;Subaction=Edit;StatID=$StatID"
            );
        }
        else {
            $Errors{FileServerError}        = 'ServerError';
            $Errors{FileServerErrorMessage} = Translatable("Please upload a valid statistic file.");
        }
    }
    else {
        $Errors{FileServerError}        = 'ServerError';
        $Errors{FileServerErrorMessage} = Translatable("This field is required.");
    }

    return $Self->ImportScreen( Errors => \%Errors );
}

sub ExportAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->ChallengeTokenCheck();

    my $StatID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'StatID' );
    if ( !$StatID ) {
        return $LayoutObject->ErrorScreen( Message => 'Export: Need StatID!' );
    }

    my $ExportFile = $Kernel::OM->Get('Kernel::System::Stats')->Export(
        StatID => $StatID,
        UserID => $Self->{UserID},
    );

    return $LayoutObject->Attachment(
        Filename    => $ExportFile->{Filename},
        Content     => $ExportFile->{Content},
        ContentType => 'text/xml',
    );
}

sub DeleteAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $StatID = $ParamObject->GetParam( Param => 'StatID' );
    if ( !$StatID ) {
        return $LayoutObject->ErrorScreen( Message => 'Delete: Get no StatID!' );
    }

    # challenge token check for write action
    $LayoutObject->ChallengeTokenCheck();
    $Kernel::OM->Get('Kernel::System::Stats')->StatsDelete(
        StatID => $StatID,
        UserID => $Self->{UserID},
    );
    return $LayoutObject->Redirect( OP => $Self->{LastStatsOverview}  );
}

sub EditScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get param
    if ( !( $Param{StatID} = $ParamObject->GetParam( Param => 'StatID' ) ) ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Need StatID!',
        );
    }

    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
        StatID => $Param{StatID},
        UserID => $Self->{UserID},
    );

    my %Frontend;
    $Frontend{GeneralSpecificationsWidget}
        = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->GeneralSpecificationsWidget(
        StatID => $Stat->{StatID},
        UserID => $Self->{UserID},
        );

    if ( $Stat->{StatType} eq 'dynamic' ) {
        $Frontend{PreviewWidget} = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->PreviewWidget(
            Stat   => $Stat,
            UserID => $Self->{UserID},
        );
        $Frontend{XAxisWidget} = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->XAxisWidget(
            Stat   => $Stat,
            UserID => $Self->{UserID},
        );
        $Frontend{YAxisWidget} = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->YAxisWidget(
            Stat   => $Stat,
            UserID => $Self->{UserID},
        );
        $Frontend{RestrictionsWidget} = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->RestrictionsWidget(
            Stat   => $Stat,
            UserID => $Self->{UserID},
        );
    }

    my $Output = $LayoutObject->Header( Title => 'Edit' );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentStatisticsEdit',
        Data         => {
            %Frontend,
            %{$Stat},
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub EditAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Errors;

    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
        StatID => $ParamObject->GetParam( Param => 'StatID' ),
        UserID => $Self->{UserID},
    );

    if ( !$Stat ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Need StatID!',
        );
    }

    #
    # General Specification
    #
    my %Data;
    for my $Key (qw(Title Description Valid)) {
        $Data{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
        if ( !length $Data{$Key} ) {    # Valid can be 0
            $Errors{ $Key . 'ServerError' } = 'ServerError';
        }
    }

    for my $Key (qw(SumRow SumCol Cache ShowAsDashboardWidget)) {
        $Data{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
    }

    for my $Key (qw(Permission Format)) {
        $Data{$Key} = [ $ParamObject->GetArray( Param => $Key ) ];
        if ( !@{ $Data{$Key} } ) {
            $Errors{ $Key . 'ServerError' } = 'ServerError';

            #$Data{$Key} = '';
        }
    }

    #
    # X Axis
    #
    if ( $Stat->{StatType} eq 'dynamic' ) {
        my $SelectedElement = $ParamObject->GetParam( Param => 'XAxisSelectedElement' );
        $Data{StatType} = $Stat->{StatType};

        OBJECTATTRIBUTE:
        for my $ObjectAttribute ( @{ $Stat->{UseAsXvalue} } ) {
            next OBJECTATTRIBUTE if !defined $SelectedElement;
            next OBJECTATTRIBUTE if $SelectedElement ne 'XAxis' . $ObjectAttribute->{Element};

            my @Array = $ParamObject->GetArray( Param => $SelectedElement );
            $Data{UseAsXvalue}[0]{SelectedValues} = \@Array;
            $Data{UseAsXvalue}[0]{Element}        = $ObjectAttribute->{Element};
            $Data{UseAsXvalue}[0]{Block}          = $ObjectAttribute->{Block};
            $Data{UseAsXvalue}[0]{Selected}       = 1;

            my $Fixed = $ParamObject->GetParam( Param => 'Fixed' . $SelectedElement );
            $Data{UseAsXvalue}[0]{Fixed} = $Fixed ? 1 : 0;

            # Check if Time was selected
            next OBJECTATTRIBUTE if $ObjectAttribute->{Block} ne 'Time';

            # This part is only needed if the block time is selected
            # perhaps a separate function is better
            my %Time;
            $Data{UseAsXvalue}[0]{TimeScaleCount}
                = $ParamObject->GetParam( Param => $SelectedElement . 'TimeScaleCount' ) || 1;
            my $TimeSelect = $ParamObject->GetParam( Param => $SelectedElement . 'TimeSelect' ) || 'Absolut';

            if ( $TimeSelect eq 'Absolut' ) {
                for my $Limit (qw(Start Stop)) {
                    for my $Unit (qw(Year Month Day Hour Minute Second)) {
                        if ( defined( $ParamObject->GetParam( Param => "$SelectedElement$Limit$Unit" ) ) ) {
                            $Time{ $Limit . $Unit } = $ParamObject->GetParam(
                                Param => "$SelectedElement$Limit$Unit",
                            );
                        }
                    }
                    if ( !defined( $Time{ $Limit . 'Hour' } ) ) {
                        if ( $Limit eq 'Start' ) {
                            $Time{StartHour}   = 0;
                            $Time{StartMinute} = 0;
                            $Time{StartSecond} = 0;
                        }
                        elsif ( $Limit eq 'Stop' ) {
                            $Time{StopHour}   = 23;
                            $Time{StopMinute} = 59;
                            $Time{StopSecond} = 59;
                        }
                    }
                    elsif ( !defined( $Time{ $Limit . 'Second' } ) ) {
                        if ( $Limit eq 'Start' ) {
                            $Time{StartSecond} = 0;
                        }
                        elsif ( $Limit eq 'Stop' ) {
                            $Time{StopSecond} = 59;
                        }
                    }

                    $Data{UseAsXvalue}[0]{"Time$Limit"} = sprintf(
                        "%04d-%02d-%02d %02d:%02d:%02d",
                        $Time{ $Limit . 'Year' },
                        $Time{ $Limit . 'Month' },
                        $Time{ $Limit . 'Day' },
                        $Time{ $Limit . 'Hour' },
                        $Time{ $Limit . 'Minute' },
                        $Time{ $Limit . 'Second' },
                    );
                }
            }
            else {
                $Data{UseAsXvalue}[0]{TimeRelativeUnit} = $ParamObject->GetParam(
                    Param => $SelectedElement . 'TimeRelativeUnit'
                );
                $Data{UseAsXvalue}[0]{TimeRelativeCount} = $ParamObject->GetParam(
                    Param => $SelectedElement . 'TimeRelativeCount'
                );
                $Data{UseAsXvalue}[0]{TimeRelativeUpcomingCount} = $ParamObject->GetParam(
                    Param => $SelectedElement . 'TimeRelativeUpcomingCount'
                );
            }
        }
    }

    #
    # Y Axis
    #
    if ( $Stat->{StatType} eq 'dynamic' ) {

        my $Index = 0;
        $Data{StatType} = $Stat->{StatType};

        OBJECTATTRIBUTE:
        for my $ObjectAttribute ( @{ $Stat->{UseAsValueSeries} } ) {
            my $Element = 'YAxis' . $ObjectAttribute->{Element};
            if ( !$ParamObject->GetParam( Param => "Select$Element" ) ) {
                next OBJECTATTRIBUTE;
            }

            my @Array = $ParamObject->GetArray( Param => $Element );
            $Data{UseAsValueSeries}[$Index]{SelectedValues} = \@Array;
            $Data{UseAsValueSeries}[$Index]{Element}        = $ObjectAttribute->{Element};
            $Data{UseAsValueSeries}[$Index]{Block}          = $ObjectAttribute->{Block};
            $Data{UseAsValueSeries}[$Index]{Selected}       = 1;

            my $FixedElement = 'Fixed' . $Element;
            my $Fixed = $ParamObject->GetParam( Param => $FixedElement );
            $Data{UseAsValueSeries}[$Index]{Fixed} = $Fixed ? 1 : 0;

            # Check if Time was selected
            if ( $ObjectAttribute->{Block} eq 'Time' ) {

                # for working with extended time
                $Data{UseAsValueSeries}[$Index]{TimeScaleCount} = $ParamObject->GetParam(
                    Param => $Element . 'TimeScaleCount'
                ) || 1;

                # check if the current selected value is allowed for the x axis selected time scale
                my $SelectedXAxisTimeScaleValue = $Data{UseAsXvalue}[0]{SelectedValues}[0];

                my $TimeScale = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->_TimeScale(
                    SelectedXAxisValue => $SelectedXAxisTimeScaleValue,
                );

                my %TimeScaleLookup = map { $_ => 1 } sort keys %{$TimeScale};

                # set the first allowed time scale value as default
                if (   !$Data{UseAsValueSeries}[$Index]{SelectedValues}[0]
                    || !exists $TimeScaleLookup{ $Data{UseAsValueSeries}[$Index]{SelectedValues}[0] } )
                {

                    my @TimeScaleSorted
                        = sort { $TimeScale->{$a}->{Position} <=> $TimeScale->{$b}->{Position} } keys %{$TimeScale};

                    $Data{UseAsValueSeries}[$Index]{SelectedValues}[0] = $TimeScaleSorted[0];
                }
            }
            $Index++;
        }

        $Data{UseAsValueSeries} ||= [];
    }

    #
    # Restrictions
    #
    if ( $Stat->{StatType} eq 'dynamic' ) {
        my $Index = 0;
        $Data{StatType} = $Stat->{StatType};

        OBJECTATTRIBUTE:
        for my $ObjectAttribute ( @{ $Stat->{UseAsRestriction} } ) {

            my $Element = 'Restrictions' . $ObjectAttribute->{Element};
            if ( !$ParamObject->GetParam( Param => "Select$Element" ) ) {
                next OBJECTATTRIBUTE;
            }

            my @Array = $ParamObject->GetArray( Param => $Element );
            $Data{UseAsRestriction}[$Index]{SelectedValues} = \@Array;
            $Data{UseAsRestriction}[$Index]{Element}        = $ObjectAttribute->{Element};
            $Data{UseAsRestriction}[$Index]{Block}          = $ObjectAttribute->{Block};
            $Data{UseAsRestriction}[$Index]{Selected}       = 1;

            my $Fixed = $ParamObject->GetParam( Param => 'Fixed' . $Element );
            $Data{UseAsRestriction}[$Index]{Fixed} = $Fixed ? 1 : 0;

            if ( $ObjectAttribute->{Block} eq 'Time' ) {
                my %Time;
                my $TimeSelect = $ParamObject->GetParam( Param => $Element . 'TimeSelect' )
                    || 'Absolut';
                if ( $TimeSelect eq 'Absolut' ) {
                    for my $Limit (qw(Start Stop)) {
                        for my $Unit (qw(Year Month Day Hour Minute Second)) {
                            if ( defined( $ParamObject->GetParam( Param => "$Element$Limit$Unit" ) ) )
                            {
                                $Time{ $Limit . $Unit } = $ParamObject->GetParam(
                                    Param => "$Element$Limit$Unit",
                                );
                            }
                        }
                        if ( !defined( $Time{ $Limit . 'Hour' } ) ) {
                            if ( $Limit eq 'Start' ) {
                                $Time{StartHour}   = 0;
                                $Time{StartMinute} = 0;
                                $Time{StartSecond} = 0;
                            }
                            elsif ( $Limit eq 'Stop' ) {
                                $Time{StopHour}   = 23;
                                $Time{StopMinute} = 59;
                                $Time{StopSecond} = 59;
                            }
                        }
                        elsif ( !defined( $Time{ $Limit . 'Second' } ) ) {
                            if ( $Limit eq 'Start' ) {
                                $Time{StartSecond} = 0;
                            }
                            elsif ( $Limit eq 'Stop' ) {
                                $Time{StopSecond} = 59;
                            }
                        }

                        $Data{UseAsRestriction}[$Index]{"Time$Limit"} = sprintf(
                            "%04d-%02d-%02d %02d:%02d:%02d",
                            $Time{ $Limit . 'Year' },
                            $Time{ $Limit . 'Month' },
                            $Time{ $Limit . 'Day' },
                            $Time{ $Limit . 'Hour' },
                            $Time{ $Limit . 'Minute' },
                            $Time{ $Limit . 'Second' },
                        );
                    }
                }
                else {
                    $Data{UseAsRestriction}[$Index]{TimeRelativeUnit} = $ParamObject->GetParam(
                        Param => $Element . 'TimeRelativeUnit'
                    );
                    $Data{UseAsRestriction}[$Index]{TimeRelativeCount} = $ParamObject->GetParam(
                        Param => $Element . 'TimeRelativeCount'
                    );
                    $Data{UseAsRestriction}[$Index]{TimeRelativeUpcomingCount} = $ParamObject->GetParam(
                        Param => $Element . 'TimeRelativeUpcomingCount'
                    );
                }
            }

            $Index++;
        }

        $Data{UseAsRestriction} ||= [];
    }

    # my @Notify = $Kernel::OM->Get('Kernel::System::Stats')->CompletenessCheck(
    #     StatData => {
    #         %{$Stat},
    #         %Data,
    #     },
    #     Section => 'Specification'
    # );

    if (%Errors) {
        return $Self->EditScreen(
            Errors   => \%Errors,
            GetParam => \%Data,
        );
    }

    $Kernel::OM->Get('Kernel::System::Stats')->StatsUpdate(
        StatID => $Stat->{StatID},
        Hash   => \%Data,
        UserID => $Self->{UserID},
    );

    if ( $ParamObject->GetParam( Param => 'SaveAndFinish' ) ) {
        return $LayoutObject->Redirect( OP => $Self->{LastStatsOverview} );
    }

    return $Self->EditScreen(
        Errors   => \%Errors,
        GetParam => \%Data,
    );
}

sub ViewScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my @Errors;
    if ( ref $Param{Errors} eq 'ARRAY' ) {
        @Errors = @{ $Param{Errors} || [] };
    }

    # get StatID
    my $StatID = $ParamObject->GetParam( Param => 'StatID' );
    if ( !$StatID ) {
        return $LayoutObject->ErrorScreen( Message => 'Need StatID!' );
    }

    # get message if one available
    #my $Message = $ParamObject->GetParam( Param => 'Message' );

    # Get all statistics that the current user may see (does permission check).
    my $StatsList = $Kernel::OM->Get('Kernel::System::Stats')->StatsListGet(
        UserID => $Self->{UserID},
    );
    if ( !IsHashRefWithData( $StatsList->{$StatID} ) ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Could not load stat.',
        );
    }

    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
        StatID => $StatID,
        UserID => $Self->{UserID},
    );

    # get param
    if ( !IsHashRefWithData($Stat) ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Could not load stat.',
        );
    }

    my %Frontend;

    $Frontend{StatsParamsWidget} = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsWidget(
        Stat   => $Stat,
        UserID => $Self->{UserID},
    );

    my $Output = $LayoutObject->Header( Title => 'View' );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentStatisticsView',
        Data         => {
            AccessRw => $Self->{AccessRw},
            Errors   => \@Errors,
            %Frontend,
            %{$Stat},
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub AddScreen {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # In case of page reload because of errors
    my %Errors   = %{ $Param{Errors}   // {} };
    my %GetParam = %{ $Param{GetParam} // {} };

    my %Frontend;

    my $DynamicFiles = $Kernel::OM->Get('Kernel::System::Stats')->GetDynamicFiles();
    DYNAMIC_FILE:
    for my $DynamicFile ( sort keys %{ $DynamicFiles // {} } ) {
        my $ObjectName = 'Kernel::System::Stats::Dynamic::' . $DynamicFile;

        next DYNAMIC_FILE if !$Kernel::OM->Get('Kernel::System::Main')->Require($ObjectName);
        my $Object = $ObjectName->new();
        next DYNAMIC_FILE if !$Object;
        if ( $Object->can('GetStatElement') ) {
            $Frontend{ShowAddDynamicMatrixButton}++;
        }
        else {
            $Frontend{ShowAddDynamicListButton}++;
        }
    }

    my $StaticFiles = $Kernel::OM->Get('Kernel::System::Stats')->GetStaticFiles(
        OnlyUnusedFiles => 1,
        UserID          => $Self->{UserID},
    );
    if ( scalar keys %{$StaticFiles} ) {
        $Frontend{ShowAddStaticButton}++;
    }

    # This is a page reload because of validation errors
    if (%Errors) {
        $Frontend{StatisticPreselection} = $ParamObject->GetParam( Param => 'StatisticPreselection' );
        $Frontend{GeneralSpecificationsWidget}
            = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->GeneralSpecificationsWidget(
            Errors   => \%Errors,
            GetParam => \%GetParam,
            UserID   => $Self->{UserID},
            );
        $Frontend{ShowFormInitially} = 1;
    }

    # build output
    my $Output = $LayoutObject->Header( Title => 'Add New Statistic' );
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentStatisticsAdd',
        Data         => {
            %Frontend,
            %Errors,
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub AddAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Errors;

    my %Data;
    for my $Key (qw(Title Description ObjectModule StatType Valid)) {
        $Data{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
        if ( !length $Data{$Key} ) {    # Valid can be 0
            $Errors{ $Key . 'ServerError' } = 'ServerError';
        }
    }

    # This seems to be historical metadata that is needed for display.
    my $Object = $Data{ObjectModule};
    $Object = [ split( m{::}, $Object ) ]->[-1];
    if ( $Data{StatType} eq 'static' ) {
        $Data{File} = $Object;
    }
    else {
        $Data{Object} = $Object;
    }

    for my $Key (qw(SumRow SumCol Cache ShowAsDashboardWidget)) {
        $Data{$Key} = $ParamObject->GetParam( Param => $Key ) // '';
    }

    for my $Key (qw(Permission Format)) {
        $Data{$Key} = [ $ParamObject->GetArray( Param => $Key ) ];
        if ( !@{ $Data{$Key} } ) {
            $Errors{ $Key . 'ServerError' } = 'ServerError';

            #$Data{$Key} = '';
        }
    }

    # my @Notify = $Kernel::OM->Get('Kernel::System::Stats')->CompletenessCheck(
    #     StatData => \%Data,
    #     Section  => 'Specification'
    # );

    if (%Errors) {
        return $Self->AddScreen(
            Errors   => \%Errors,
            GetParam => \%Data,
        );
    }

    $Param{StatID} = $Kernel::OM->Get('Kernel::System::Stats')->StatsAdd(
        UserID => $Self->{UserID},
    );
    if ( !$Param{StatID} ) {
        return $LayoutObject->ErrorScreen( Message => 'Could not create statistic.' );
    }
    $Kernel::OM->Get('Kernel::System::Stats')->StatsUpdate(
        StatID => $Param{StatID},
        Hash   => \%Data,
        UserID => $Self->{UserID},
    );

    # For static stats, the configuration is finished
    if ( $Data{StatType} eq 'static' ) {
        return $LayoutObject->Redirect(
            OP => "Action=AgentStatistics;Subaction=View;StatID=$Param{StatID}",
        );
    }

    # Continue configuration for dynamic stats
    return $LayoutObject->Redirect(
        OP => "Action=AgentStatistics;Subaction=Edit;StatID=$Param{StatID}",
    );
}

sub RunAction {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get params
    for (qw(Format StatID ExchangeAxis Name Cached)) {
        $Param{$_} = $ParamObject->GetParam( Param => $_ );
    }
    my @RequiredParams = (qw(Format StatID));
    if ( $Param{Cached} ) {
        push @RequiredParams, 'Name';
    }
    for my $Required (@RequiredParams) {
        if ( !$Param{$Required} ) {
            return $LayoutObject->ErrorScreen( Message => "Run: Get no $Required!" );
        }
    }

    my $Stat = $Kernel::OM->Get('Kernel::System::Stats')->StatsGet(
        StatID => $Param{StatID},
        UserID => $Self->{UserID},
    );

    # permission check
    if ( !$Self->{AccessRw} ) {
        my $UserPermission = 0;

        return $LayoutObject->NoPermission( WithHeader => 'yes' ) if !$Stat->{Valid};

        # get user groups
        my %GroupList = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'ro',
        );

        GROUPID:
        for my $GroupID ( @{ $Stat->{Permission} } ) {

            next GROUPID if !$GroupID;
            next GROUPID if !$GroupList{$GroupID};

            $UserPermission = 1;

            last GROUPID;
        }

        return $LayoutObject->NoPermission( WithHeader => 'yes' ) if !$UserPermission;
    }

    # get params
    my %GetParam = eval {
        $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsParamsGet(
            Stat   => $Stat,
            UserID => $Self->{UserID},
        );
    };
    if ($@) {
        return $Self->ViewScreen( Errors => $@ );
    }

    # run stat...
    my @StatArray;

    # called from within the dashboard. will use the same mechanism and configuration like in
    # the dashboard stats - the (cached) result will be the same as seen in the dashboard
    if ( $Param{Cached} ) {

        # get settings for specified stats by using the dashboard configuration for the agent
        my %Preferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
            UserID => $Self->{UserID},
        );
        my $PrefKeyStatsConfiguration = 'UserDashboardStatsStatsConfiguration' . $Param{Name};
        my $StatsSettings             = {};
        if ( $Preferences{$PrefKeyStatsConfiguration} ) {
            $StatsSettings = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $Preferences{$PrefKeyStatsConfiguration},
            );
        }
        @StatArray = @{
            $Kernel::OM->Get('Kernel::System::Stats')->StatsResultCacheGet(
                StatID       => $Param{StatID},
                UserGetParam => $StatsSettings,
                UserID       => $Self->{UserID},
            );
            }
    }

    # called normally within the stats area - generate stats now and use provided configuraton
    else {
        @StatArray = @{
            $Kernel::OM->Get('Kernel::System::Stats')->StatsRun(
                StatID   => $Param{StatID},
                GetParam => \%GetParam,
                UserID   => $Self->{UserID},
            );
        };
    }

    # exchange axis if selected
    if ( $Param{ExchangeAxis} ) {
        my @NewStatArray;
        my $Title = $StatArray[0][0];

        shift(@StatArray);
        for my $Key1 ( 0 .. $#StatArray ) {
            for my $Key2 ( 0 .. $#{ $StatArray[0] } ) {
                $NewStatArray[$Key2][$Key1] = $StatArray[$Key1][$Key2];
            }
        }
        $NewStatArray[0][0] = '';
        unshift( @NewStatArray, [$Title] );
        @StatArray = @NewStatArray;
    }

    return $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')->StatsResultRender(
        StatArray => \@StatArray,
        Stat      => $Stat,
        UserID    => $Self->{UserID},
        %Param
    );

    return
}

sub GeneralSpecificationsWidgetAJAX {

    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    return $LayoutObject->Attachment(
        ContentType => 'text/html',
        Content     => $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View')
            ->GeneralSpecificationsWidget( UserID => $Self->{UserID} ),
        Type    => 'inline',
        NoCache => 1,
    );
}

# ATTENTION: this function delivers only approximations!!!
sub _TimeInSeconds {
    my ( $Self, %Param ) = @_;

    # check if need params are available
    if ( !$Param{TimeUnit} ) {
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')
            ->ErrorScreen( Message => '_TimeInSeconds: Need TimeUnit!' );
    }

    my %TimeInSeconds = (
        Year     => 31536000,    # 60 * 60 * 24 * 365
        HalfYear => 15724800,    # 60 * 60 * 24 * 182
        Quarter  => 7862400,     # 60 * 60 * 24 * 91
        Month    => 2592000,     # 60 * 60 * 24 * 30
        Week     => 604800,      # 60 * 60 * 24 * 7
        Day      => 86400,       # 60 * 60 * 24
        Hour     => 3600,        # 60 * 60
        Minute   => 60,
        Second   => 1,
    );

    return $TimeInSeconds{ $Param{TimeUnit} };
}

1;
