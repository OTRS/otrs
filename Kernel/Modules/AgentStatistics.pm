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
    for my $Param (qw( AccessRw RequestedURL)) {
        if ( $Param{$Param} ) {
            $Self->{$Param} = $Param{$Param};
        }
    }

    # Create stats object (requires UserID).
    $Kernel::OM->ObjectParamAdd(
        'Kernel::System::Stats' => {
            UserID => $Param{UserID},
        },
    );
    $Self->{StatsObject} = $Kernel::OM->Get('Kernel::System::Stats');

    $Kernel::OM->ObjectParamAdd(
        'Kernel::Output::HTML::Statistics::View' => {
            StatsObject => $Self->{StatsObject},
        },
    );
    $Self->{StatsViewObject} = $Kernel::OM->Get('Kernel::Output::HTML::Statistics::View');

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
    my $Result = $Self->{StatsObject}->GetStatsList(
        AccessRw  => $Self->{AccessRw},
        OrderBy   => $Param{OrderBy},
        Direction => $Param{Direction},
    );

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
        my $Stat   = $Self->{StatsObject}->StatsGet(
            StatID             => $StatID,
            NoObjectAttributes => 1,
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
            my $StatID = $Self->{StatsObject}->Import(
                Content => $UploadStuff{Content},
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

    my $ExportFile = $Self->{StatsObject}->Export( StatID => $StatID );

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
    $Self->{StatsObject}->StatsDelete( StatID => $StatID );
    return $LayoutObject->Redirect( OP => 'Action=AgentStatistics;Subaction=Overview' );
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

    my $Stat = $Self->{StatsObject}->StatsGet( StatID => $Param{StatID} );

    my %Frontend;
    $Frontend{GeneralSpecificationsWidget} = $Self->{StatsViewObject}->GeneralSpecificationsWidget(
        StatID => $Stat->{StatID},
    );

    if ( $Stat->{StatType} eq 'dynamic' ) {
        $Frontend{PreviewWidget} = $Self->{StatsViewObject}->PreviewWidget(
            Stat => $Stat,
        );
        $Frontend{XAxisWidget} = $Self->{StatsViewObject}->XAxisWidget(
            Stat => $Stat,
        );
        $Frontend{YAxisWidget} = $Self->{StatsViewObject}->YAxisWidget(
            Stat => $Stat,
        );
        $Frontend{RestrictionsWidget} = $Self->{StatsViewObject}->RestrictionsWidget(
            Stat => $Stat,
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

    my $Stat = $Self->{StatsObject}->StatsGet(
        StatID => $ParamObject->GetParam( Param => 'StatID' ),
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

    for my $Key (qw(GraphSize)) {
        $Data{$Key} = [ $ParamObject->GetArray( Param => $Key ) ];

        #if ( !@{ $Data{$Key} } ) {
        #    $Data{$Key} = '';
        #}
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
            my $TimeType = $ConfigObject->Get('Stats::TimeType') || 'Normal';
            my %Time;
            $Data{UseAsXvalue}[0]{TimeScaleCount}
                = $ParamObject->GetParam( Param => $SelectedElement . 'TimeScaleCount' )
                || 1;
            my $TimeSelect = $ParamObject->GetParam( Param => $SelectedElement . 'TimeSelect' )
                || 'Absolut';

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
                $Data{UseAsXvalue}[0]{TimeRelativeUnit}
                    = $ParamObject->GetParam( Param => $SelectedElement . 'TimeRelativeUnit' );
                $Data{UseAsXvalue}[0]{TimeRelativeCount}
                    = $ParamObject->GetParam( Param => $SelectedElement . 'TimeRelativeCount' );
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
                my $TimeType = $ConfigObject->Get('Stats::TimeType') || 'Normal';
                if ( $TimeType eq 'Normal' ) {

                    # if the admin has only one unit selected, unfixed is useless
                    if (
                        !$Data{UseAsValueSeries}[0]{SelectedValues}[1]
                        && $Data{UseAsValueSeries}[0]{SelectedValues}[0]
                        )
                    {
                        $Data{UseAsValueSeries}[0]{Fixed} = 1;
                    }
                }

                # for working with extended time
                $Data{UseAsValueSeries}[$Index]{TimeScaleCount} = $ParamObject->GetParam(
                    Param => $Element . 'TimeScaleCount'
                ) || 1;
            }
            $Index++;

        }

        $Data{UseAsValueSeries} ||= [];
    }

    #
    # Restrictions
    #
    if ( $Stat->{StatType} eq 'dynamic' ) {
        my $Index            = 0;
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
                }
            }

            $Index++;
        }

        $Data{UseAsRestriction} ||= [];
    }

    # my @Notify = $Self->{StatsObject}->CompletenessCheck(
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

    $Self->{StatsObject}->StatsUpdate(
        StatID => $Stat->{StatID},
        Hash   => \%Data,
    );

    if ( $ParamObject->GetParam(Param => 'SaveAndFinish') ) {
        return $LayoutObject->Redirect( OP => 'Action=AgentStatistics;Subaction=Overview' );
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
    if (ref $Param{Errors} eq 'ARRAY') {
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
    my $StatsList = $Self->{StatsObject}->StatsListGet();
    if ( !IsHashRefWithData( $StatsList->{$StatID} ) ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Could not load stat.',
        );
    }

    my $Stat = $Self->{StatsObject}->StatsGet(
        StatID => $StatID,
    );

    # get param
    if ( !IsHashRefWithData($Stat) ) {
        return $LayoutObject->ErrorScreen(
            Message => 'Could not load stat.',
        );
    }

    my %Frontend;

    $Frontend{StatsParamsWidget} = $Self->{StatsViewObject}->StatsParamsWidget(
        Stat => $Stat,
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

    my $DynamicFiles = $Self->{StatsObject}->GetDynamicFiles();
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

    my $StaticFiles = $Self->{StatsObject}->GetStaticFiles(
        OnlyUnusedFiles => 1,
    );
    if ( scalar keys %{$StaticFiles} ) {
        $Frontend{ShowAddStaticButton}++;
    }

    # This is a page reload because of validation errors
    if (%Errors) {
        $Frontend{StatisticPreselection} = $ParamObject->GetParam( Param => 'StatisticPreselection' );
        $Frontend{GeneralSpecificationsWidget} = $Self->{StatsViewObject}->GeneralSpecificationsWidget(
            Errors   => \%Errors,
            GetParam => \%GetParam,
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

    for my $Key (qw(GraphSize)) {
        $Data{$Key} = [ $ParamObject->GetArray( Param => $Key ) ];

        #if ( !@{ $Data{$Key} } ) {
        #    $Data{$Key} = '';
        #}
    }

    # my @Notify = $Self->{StatsObject}->CompletenessCheck(
    #     StatData => \%Data,
    #     Section  => 'Specification'
    # );

    if (%Errors) {
        return $Self->AddScreen(
            Errors   => \%Errors,
            GetParam => \%Data,
        );
    }

    $Param{StatID} = $Self->{StatsObject}->StatsAdd();
    if ( !$Param{StatID} ) {
        return $LayoutObject->ErrorScreen( Message => 'Could not create statistic.' );
    }
    $Self->{StatsObject}->StatsUpdate(
        StatID => $Param{StatID},
        Hash   => \%Data,
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
    for (qw(Format GraphSize StatID ExchangeAxis Name Cached)) {
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

    if ( $Param{Format} =~ m{^GD::Graph\.*}x ) {

        # check installed packages
        for my $Module ( 'GD', 'GD::Graph' ) {
            if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
                return $LayoutObject->ErrorScreen(
                    Message => "Run: Please install $Module module!"
                );
            }
        }
        if ( !$Param{GraphSize} ) {
            return $LayoutObject->ErrorScreen( Message => 'Run: Need GraphSize!' );
        }
    }

    my $Stat = $Self->{StatsObject}->StatsGet( StatID => $Param{StatID} );

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
        $Self->{StatsViewObject}->StatsParamsGet( Stat => $Stat );
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
            $Self->{StatsObject}->StatsResultCacheGet(
                StatID       => $Param{StatID},
                UserGetParam => $StatsSettings,
            );
            }
    }

    # called normally within the stats area - generate stats now and use provided configuraton
    else {
        @StatArray = @{
            $Self->{StatsObject}->StatsRun(
                StatID   => $Param{StatID},
                GetParam => \%GetParam,
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

    return $Self->{StatsViewObject}->StatsResultRender(
        StatArray => \@StatArray,
        Stat      => $Stat,
        %Param
    );

    return
}

sub GeneralSpecificationsWidgetAJAX {

    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    return $LayoutObject->Attachment(
        ContentType => 'text/html',
        Content     => $Self->{StatsViewObject}->GeneralSpecificationsWidget(),
        Type        => 'inline',
        NoCache     => 1,
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
        Year   => 31536000,    # 60 * 60 * 60 * 365
        Month  => 2592000,     # 60 * 60 * 24 * 30
        Week   => 604800,      # 60 * 60 * 24 * 7
        Day    => 86400,       # 60 * 60 * 24
        Hour   => 3600,        # 60 * 60
        Minute => 60,
        Second => 1,
    );

    return $TimeInSeconds{ $Param{TimeUnit} };
}

1;
