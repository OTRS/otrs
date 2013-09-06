# --
# Kernel/Modules/AgentTicketSearch.pm - Utilities for tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketSearch;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::Priority;
use Kernel::System::SearchProfile;
use Kernel::System::Service;
use Kernel::System::SLA;
use Kernel::System::State;
use Kernel::System::Type;
use Kernel::System::CSV;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{CustomerUserObject}  = Kernel::System::CustomerUser->new(%Param);
    $Self->{PriorityObject}      = Kernel::System::Priority->new(%Param);
    $Self->{StateObject}         = Kernel::System::State->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);
    $Self->{ServiceObject}       = Kernel::System::Service->new(%Param);
    $Self->{SLAObject}           = Kernel::System::SLA->new(%Param);
    $Self->{TypeObject}          = Kernel::System::Type->new(%Param);
    $Self->{CSVObject}           = Kernel::System::CSV->new(%Param);
    $Self->{LockObject}          = Kernel::System::Lock->new(%Param);
    $Self->{DynamicFieldObject}  = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}       = Kernel::System::DynamicField::Backend->new(%Param);

    # if we need to do a fulltext search on an external mirror database
    if ( $Self->{ConfigObject}->Get('Core::MirrorDB::DSN') ) {
        my $ExtraDatabaseObject = Kernel::System::DB->new(
            LogObject    => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            MainObject   => $Param{MainObject},
            EncodeObject => $Param{EncodeObject},
            DatabaseDSN  => $Self->{ConfigObject}->Get('Core::MirrorDB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Core::MirrorDB::User'),
            DatabasePw   => $Self->{ConfigObject}->Get('Core::MirrorDB::Password'),
        );
        if ( !$ExtraDatabaseObject ) {
            $Self->{LayoutObject}->FatalError();
        }
        $Self->{TicketObjectSearch} = Kernel::System::Ticket->new(
            %Param,
            DBObject => $ExtraDatabaseObject,
        );
    }
    else {
        $Self->{TicketObjectSearch} = $Self->{TicketObject};
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # get dynamic field config for frontend module
    $Self->{DynamicFieldFilter} = $Self->{Config}->{DynamicField};

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # get the ticket dynamic fields for CSV display
    $Self->{CSVDynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{Config}->{SearchCSVDynamicField} || {},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get config data
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 500;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Down';
    $Self->{Profile}        = $Self->{ParamObject}->GetParam( Param => 'Profile' )        || '';
    $Self->{SaveProfile}    = $Self->{ParamObject}->GetParam( Param => 'SaveProfile' )    || '';
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam( Param => 'TakeLastSearch' ) || '';
    $Self->{SelectTemplate} = $Self->{ParamObject}->GetParam( Param => 'SelectTemplate' ) || '';
    $Self->{EraseTemplate}  = $Self->{ParamObject}->GetParam( Param => 'EraseTemplate' )  || '';

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # check request
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionTicketNumber' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketSearchOpenSearchDescriptionTicketNumber',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescriptionTicketNumber.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFulltext' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketSearchOpenSearchDescriptionFulltext',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescriptionFulltext.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # check request
    if ( $Self->{ParamObject}->GetParam( Param => 'SearchTemplate' ) && $Self->{Profile} ) {
        my $Profile = $Self->{LayoutObject}->LinkEncode( $Self->{Profile} );
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=AgentTicketSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Profile"
        );
    }

    # get single params
    my %GetParam;

    # load profiles string params (press load profile)
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Self->{Profile} ) || $Self->{TakeLastSearch} ) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'TicketSearch',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );

        # convert attributes
        if ( $GetParam{ShownAttributes} && ref $GetParam{ShownAttributes} eq 'ARRAY' ) {
            $GetParam{ShownAttributes} = join ';', @{ $GetParam{ShownAttributes} };
        }
    }

    # get search string params (get submitted params)
    else {
        for my $Key (
            qw(TicketNumber Title From To Cc Subject Body CustomerID CustomerUserLogin StateType
            Agent ResultForm TimeSearchType ChangeTimeSearchType CloseTimeSearchType EscalationTimeSearchType
            UseSubQueues
            ArticleTimeSearchType SearchInArchive
            Fulltext ShownAttributes
            ArticleCreateTimePointFormat ArticleCreateTimePoint
            ArticleCreateTimePointStart
            ArticleCreateTimeStart ArticleCreateTimeStartDay ArticleCreateTimeStartMonth
            ArticleCreateTimeStartYear
            ArticleCreateTimeStop ArticleCreateTimeStopDay ArticleCreateTimeStopMonth
            ArticleCreateTimeStopYear
            TicketCreateTimePointFormat TicketCreateTimePoint
            TicketCreateTimePointStart
            TicketCreateTimeStart TicketCreateTimeStartDay TicketCreateTimeStartMonth
            TicketCreateTimeStartYear
            TicketCreateTimeStop TicketCreateTimeStopDay TicketCreateTimeStopMonth
            TicketCreateTimeStopYear
            TicketChangeTimePointFormat TicketChangeTimePoint
            TicketChangeTimePointStart
            TicketChangeTimeStart TicketChangeTimeStartDay TicketChangeTimeStartMonth
            TicketChangeTimeStartYear
            TicketChangeTimeStop TicketChangeTimeStopDay TicketChangeTimeStopMonth
            TicketChangeTimeStopYear
            TicketCloseTimePointFormat TicketCloseTimePoint
            TicketCloseTimePointStart
            TicketCloseTimeStart TicketCloseTimeStartDay TicketCloseTimeStartMonth
            TicketCloseTimeStartYear
            TicketCloseTimeStop TicketCloseTimeStopDay TicketCloseTimeStopMonth
            TicketCloseTimeStopYear
            TicketEscalationTimePointFormat TicketEscalationTimePoint
            TicketEscalationTimePointStart
            TicketEscalationTimeStart TicketEscalationTimeStartDay TicketEscalationTimeStartMonth
            TicketEscalationTimeStartYear
            TicketEscalationTimeStop TicketEscalationTimeStopDay TicketEscalationTimeStopMonth
            TicketEscalationTimeStopYear
            )
            )
        {

            # get search string params (get submitted params)
            $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );

            # remove white space on the start and end
            if ( $GetParam{$Key} ) {
                $GetParam{$Key} =~ s/\s+$//g;
                $GetParam{$Key} =~ s/^\s+//g;
            }
        }

        # get array params
        for my $Key (
            qw(StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
            CreatedQueueIDs CreatedUserIDs WatchUserIDs ResponsibleIDs
            TypeIDs ServiceIDs SLAIDs LockIDs)
            )
        {

            # get search array params (get submitted params)
            my @Array = $Self->{ParamObject}->GetArray( Param => $Key );
            if (@Array) {
                $GetParam{$Key} = \@Array;
            }
        }

        # get Dynamic fields from param object
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $Self->{BackendObject}->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # extract the dynamic field value from the web request
                my $DynamicFieldValue = $Self->{BackendObject}->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $Self->{ParamObject},
                    ReturnProfileStructure => 1,
                    LayoutObject           => $Self->{LayoutObject},
                    Type                   => $Preference->{Type},
                );

              # set the complete value structure in GetParam to store it later in the search profile
                if ( IsHashRefWithData($DynamicFieldValue) ) {
                    %GetParam = ( %GetParam, %{$DynamicFieldValue} );
                }
            }
        }
    }

    # get article create time option
    if ( !$GetParam{ArticleTimeSearchType} ) {
        $GetParam{'ArticleTimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{ArticleTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'ArticleTimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{ArticleTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'ArticleTimeSearchType::TimeSlot'} = 1;
    }

    # get create time option
    if ( !$GetParam{TimeSearchType} ) {
        $GetParam{'TimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
        $GetParam{'TimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'TimeSearchType::TimeSlot'} = 1;
    }

    # get change time option
    if ( !$GetParam{ChangeTimeSearchType} ) {
        $GetParam{'ChangeTimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'ChangeTimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{ChangeTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'ChangeTimeSearchType::TimeSlot'} = 1;
    }

    # get close time option
    if ( !$GetParam{CloseTimeSearchType} ) {
        $GetParam{'CloseTimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'CloseTimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{CloseTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'CloseTimeSearchType::TimeSlot'} = 1;
    }

    # get escalation time option
    if ( !$GetParam{EscalationTimeSearchType} ) {
        $GetParam{'EscalationTimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{EscalationTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'EscalationTimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{EscalationTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'EscalationTimeSearchType::TimeSlot'} = 1;
    }

    # set result form env
    if ( !$GetParam{ResultForm} ) {
        $GetParam{ResultForm} = '';
    }

    # show result site
    if ( $Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate} ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} || !$Self->{SaveProfile} ) {
            $Self->{Profile} = 'last-search';
        }

        # store last queue screen
        my $URL
            = "Action=AgentTicketSearch;Subaction=Search;Profile=$Self->{Profile};SortBy=$Self->{SortBy}"
            . ";OrderBy=$Self->{OrderBy};TakeLastSearch=1;StartHit=$Self->{StartHit}";

        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );

        # save search profile (under last-search or real profile name)
        $Self->{SaveProfile} = 1;

        # remember last search values
        if ( $Self->{SaveProfile} && $Self->{Profile} ) {

            # remove old profile stuff
            $Self->{SearchProfileObject}->SearchProfileDelete(
                Base      => 'TicketSearch',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );

            # convert attributes
            if ( $GetParam{ShownAttributes} && ref $GetParam{ShownAttributes} eq '' ) {
                $GetParam{ShownAttributes} = [ split /;/, $GetParam{ShownAttributes} ];
            }

            # insert new profile params
            for my $Key ( sort keys %GetParam ) {
                next if !defined $GetParam{$Key};
                $Self->{SearchProfileObject}->SearchProfileAdd(
                    Base      => 'TicketSearch',
                    Name      => $Self->{Profile},
                    Key       => $Key,
                    Value     => $GetParam{$Key},
                    UserLogin => $Self->{UserLogin},
                );
            }
        }

        my %TimeMap = (
            ArticleCreate    => 'ArticleTime',
            TicketCreate     => 'Time',
            TicketChange     => 'ChangeTime',
            TicketClose      => 'CloseTime',
            TicketEscalation => 'EscalationTime',
        );

        for my $TimeType ( sort keys %TimeMap ) {

            # get create time settings
            if ( !$GetParam{ $TimeMap{$TimeType} . 'SearchType' } ) {

                # do nothing with time stuff
            }
            elsif ( $GetParam{ $TimeMap{$TimeType} . 'SearchType' } eq 'TimeSlot' ) {
                for my $Key (qw(Month Day)) {
                    $GetParam{ $TimeType . 'TimeStart' . $Key }
                        = sprintf( "%02d", $GetParam{ $TimeType . 'TimeStart' . $Key } );
                    $GetParam{ $TimeType . 'TimeStop' . $Key }
                        = sprintf( "%02d", $GetParam{ $TimeType . 'TimeStop' . $Key } );
                }
                if (
                    $GetParam{ $TimeType . 'TimeStartDay' }
                    && $GetParam{ $TimeType . 'TimeStartMonth' }
                    && $GetParam{ $TimeType . 'TimeStartYear' }
                    )
                {
                    $GetParam{ $TimeType . 'TimeNewerDate' }
                        = $GetParam{ $TimeType . 'TimeStartYear' } . '-'
                        . $GetParam{ $TimeType . 'TimeStartMonth' } . '-'
                        . $GetParam{ $TimeType . 'TimeStartDay' }
                        . ' 00:00:00';
                }
                if (
                    $GetParam{ $TimeType . 'TimeStopDay' }
                    && $GetParam{ $TimeType . 'TimeStopMonth' }
                    && $GetParam{ $TimeType . 'TimeStopYear' }
                    )
                {
                    $GetParam{ $TimeType . 'TimeOlderDate' }
                        = $GetParam{ $TimeType . 'TimeStopYear' } . '-'
                        . $GetParam{ $TimeType . 'TimeStopMonth' } . '-'
                        . $GetParam{ $TimeType . 'TimeStopDay' }
                        . ' 23:59:59';
                }
            }
            elsif ( $GetParam{ $TimeMap{$TimeType} . 'SearchType' } eq 'TimePoint' ) {
                if (
                    $GetParam{ $TimeType . 'TimePoint' }
                    && $GetParam{ $TimeType . 'TimePointStart' }
                    && $GetParam{ $TimeType . 'TimePointFormat' }
                    )
                {
                    my $Time = 0;
                    if ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'minute' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' };
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'hour' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'day' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'week' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 7;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'month' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 30;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointFormat' } eq 'year' ) {
                        $Time = $GetParam{ $TimeType . 'TimePoint' } * 60 * 24 * 365;
                    }
                    if ( $GetParam{ $TimeType . 'TimePointStart' } eq 'Before' ) {

                        # more than ... ago
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = $Time;
                    }
                    elsif ( $GetParam{ $TimeType . 'TimePointStart' } eq 'Next' ) {

                        # within next
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = -$Time;
                    }
                    else {
                        # within last ...
                        $GetParam{ $TimeType . 'TimeOlderMinutes' } = 0;
                        $GetParam{ $TimeType . 'TimeNewerMinutes' } = $Time;
                    }
                }
            }
        }

        # Special behaviour for the fulltext search toolbar module:
        # - Check full text string to see if contents is a ticket number.
        # - If exists and not in print or CSV mode, redirect to the ticket.
        # See http://bugs.otrs.org/show_bug.cgi?id=4238 for details.
        #   The original problem was that tickets with customer reply will be
        #   found by a fulltext search (ticket number is in the subjects), but
        #   'new' tickets will not be found.
        if (
            $GetParam{Fulltext}
            && $Self->{ParamObject}->GetParam( Param => 'CheckTicketNumberAndRedirect' )
            && $GetParam{ResultForm} ne 'Normal'
            && $GetParam{ResultForm} ne 'Print'
            )
        {
            my $TicketID = $Self->{TicketObjectSearch}->TicketIDLookup(
                TicketNumber => $GetParam{Fulltext},
                UserID       => $Self->{UserID},
            );
            if ($TicketID) {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentTicketZoom;TicketID=$TicketID",
                );
            }
        }

        # prepare full text search
        if ( $GetParam{Fulltext} ) {
            $GetParam{ContentSearch} = 'OR';
            for my $Key (qw(From To Cc Subject Body)) {
                $GetParam{$Key} = $GetParam{Fulltext};
            }
        }

        # prepare archive flag
        if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

            $GetParam{SearchInArchive} ||= '';
            if ( $GetParam{SearchInArchive} eq 'AllTickets' ) {
                $GetParam{ArchiveFlags} = [ 'y', 'n' ];
            }
            elsif ( $GetParam{SearchInArchive} eq 'ArchivedTickets' ) {
                $GetParam{ArchiveFlags} = ['y'];
            }
            else {
                $GetParam{ArchiveFlags} = ['n'];
            }
        }

        my %AttributeLookup;

        # create attibute lookup table
        for my $Attribute ( @{ $GetParam{ShownAttributes} || [] } ) {
            $AttributeLookup{$Attribute} = 1;
        }

        # dynamic fields search parameters for ticket search
        my %DynamicFieldSearchParameters;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $Self->{BackendObject}->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                if (
                    !$AttributeLookup{
                        'LabelSearch_DynamicField_'
                            . $DynamicFieldConfig->{Name}
                            . $Preference->{Type}
                    }
                    )
                {
                    next PREFERENCE;
                }

                # extract the dynamic field value from the profile
                my $SearchParameter = $Self->{BackendObject}->SearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Profile            => \%GetParam,
                    LayoutObject       => $Self->{LayoutObject},
                    Type               => $Preference->{Type},
                );

                # set search parameter
                if ( defined $SearchParameter ) {
                    $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Parameter};
                }
            }
        }

        # perform ticket search
        my @ViewableTicketIDs = $Self->{TicketObjectSearch}->TicketSearch(
            Result              => 'ARRAY',
            SortBy              => $Self->{SortBy},
            OrderBy             => $Self->{OrderBy},
            Limit               => $Self->{SearchLimit},
            UserID              => $Self->{UserID},
            ConditionInline     => $Self->{Config}->{ExtendedSearchCondition},
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            FullTextIndex       => 1,
            %GetParam,
            %DynamicFieldSearchParameters,
        );

        # CSV output
        if ( $GetParam{ResultForm} eq 'CSV' ) {

            # create head (actual head and head for data fill)
            my @TmpCSVHead = @{ $Self->{Config}->{SearchCSVData} };
            my @CSVHead    = @{ $Self->{Config}->{SearchCSVData} };

            # include the selected dynamic fields in CVS results
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{CSVDynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

                push @TmpCSVHead, 'DynamicField_' . $DynamicFieldConfig->{Name};
                push @CSVHead,    $DynamicFieldConfig->{Label};
            }

            my @CSVData;
            for my $TicketID (@ViewableTicketIDs) {

                # get first article data
                my %Data = $Self->{TicketObjectSearch}->ArticleFirstArticle(
                    TicketID      => $TicketID,
                    Extended      => 1,
                    DynamicFields => 1,
                );

                for my $Key (qw(State Lock)) {
                    $Data{$Key} = $Self->{LayoutObject}->{LanguageObject}->Get( $Data{$Key} );
                }

                $Data{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Data{Age}, Space => ' ' );

                # get whole article (if configured!)
                if ( $Self->{Config}->{SearchArticleCSVTree} ) {
                    my @Article = $Self->{TicketObjectSearch}->ArticleGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                    );
                    for my $Articles (@Article) {
                        if ( $Articles->{Body} ) {
                            $Data{ArticleTree}
                                .= "\n-->||$Articles->{ArticleType}||$Articles->{From}||"
                                . $Articles->{Created}
                                . "||<--------------\n"
                                . $Articles->{Body};
                        }
                    }
                }

                # customer info (customer name)
                if ( $Data{CustomerUserID} ) {
                    $Data{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                        UserLogin => $Data{CustomerUserID},
                    );
                }

                # user info
                my %UserInfo = $Self->{UserObject}->GetUserData(
                    User => $Data{Owner},
                );

                # merge row data
                my %Info = (
                    %Data,
                    %UserInfo,
                    AccountedTime =>
                        $Self->{TicketObjectSearch}
                        ->TicketAccountedTimeGet( TicketID => $TicketID ),
                );

                my @Data;
                for my $Header (@TmpCSVHead) {

                    # check if header is a dynamic field and get the value from dynamic field
                    # backend
                    if ( $Header =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

                        # loop over the dynamic fields configured for CSV output
                        DYNAMICFIELD:
                        for my $DynamicFieldConfig ( @{ $Self->{CSVDynamicField} } ) {
                            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                            # skip all fields that does not match with current field name ($1)
                            # with out the 'DynamicField_' prefix
                            next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                            # get the value as for print (to correctly display)
                            my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                Value              => $Info{$Header},
                                HTMLOutput         => 0,
                                LayoutObject       => $Self->{LayoutObject},
                            );
                            push @Data, $ValueStrg->{Value};

                            # terminate the DYNAMICFIELD loop
                            last DYNAMICFIELD;
                        }
                    }

                    # otherwise retrieve data from article
                    else {
                        push @Data, $Info{$Header};
                    }
                }
                push @CSVData, \@Data;
            }

            # get Separator from language file
            my $UserCSVSeparator = $Self->{LayoutObject}->{LanguageObject}->{Separator};

            if ( $Self->{ConfigObject}->Get('PreferencesGroups')->{CSVSeparator}->{Active} ) {
                my %UserData = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );
                $UserCSVSeparator = $UserData{UserCSVSeparator} if $UserData{UserCSVSeparator};
            }

            my %HeaderMap = (
                TicketNumber => 'Ticket Number',
                CustomerName => 'customer realname',
            );

            my @CSVHeadTranslated
                = map { $Self->{LayoutObject}->{LanguageObject}->Get( $HeaderMap{$_} || $_ ); }
                @CSVHead;

            my $CSV = $Self->{CSVObject}->Array2CSV(
                Head      => \@CSVHeadTranslated,
                Data      => \@CSVData,
                Separator => $UserCSVSeparator,
            );

            # return csv to download
            my $CSVFile = 'ticket_search';
            my ( $s, $m, $h, $D, $M, $Y ) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Self->{TimeObject}->SystemTime(),
            );
            $M = sprintf( "%02d", $M );
            $D = sprintf( "%02d", $D );
            $h = sprintf( "%02d", $h );
            $m = sprintf( "%02d", $m );
            return $Self->{LayoutObject}->Attachment(
                Filename    => $CSVFile . "_" . "$Y-$M-$D" . "_" . "$h-$m.csv",
                ContentType => "text/csv; charset=" . $Self->{LayoutObject}->{UserCharset},
                Content     => $CSV,
            );
        }
        elsif ( $GetParam{ResultForm} eq 'Print' ) {

            use Kernel::System::PDF;
            $Self->{PDFObject} = Kernel::System::PDF->new( %{$Self} );

            my @PDFData;
            for my $TicketID (@ViewableTicketIDs) {

                # get first article data
                my %Data = $Self->{TicketObjectSearch}->ArticleFirstArticle(
                    TicketID      => $TicketID,
                    DynamicFields => 1,
                );

                if ( !%Data ) {

                    # get ticket data instead
                    %Data = $Self->{TicketObjectSearch}->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 1,
                    );

                    # set missing information
                    $Data{Subject} = $Data{Title};
                    $Data{From}    = '--';
                }

                # customer info
                my %CustomerData;
                if ( $Data{CustomerUserID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Data{CustomerUserID},
                    );
                }
                elsif ( $Data{CustomerID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Data{CustomerID},
                    );
                }

                # customer info (customer name)
                if ( $CustomerData{UserLogin} ) {
                    $Data{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                        UserLogin => $CustomerData{UserLogin},
                    );
                }

                # user info
                my %UserInfo = $Self->{UserObject}->GetUserData(
                    User => $Data{Owner},
                );

                # get age
                $Data{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Data{Age}, Space => ' ' );

                # customer info string
                $UserInfo{CustomerName} = '(' . $UserInfo{CustomerName} . ')'
                    if ( $UserInfo{CustomerName} );

                if ( $Self->{PDFObject} ) {
                    my %Info = ( %Data, %UserInfo );
                    my $Created = $Self->{LayoutObject}->Output(
                        Template => '$TimeLong{"$Data{"Created"}"}',
                        Data     => \%Data,
                    );
                    my $Owner = $Self->{LayoutObject}->Output(
                        Template =>
                            '$QData{"Owner","30"} ($Quote{"$Data{"UserFirstname"} $Data{"UserLastname"}","30"})',
                        Data => \%Info
                    );
                    my $Customer = $Self->{LayoutObject}->Output(
                        Template => '$QData{"CustomerID","15"} $QData{"CustomerName","15"}',
                        Data     => \%Data
                    );

                    my @PDFRow;
                    push @PDFRow,  $Data{TicketNumber};
                    push @PDFRow,  $Created;
                    push @PDFRow,  $Data{From};
                    push @PDFRow,  $Data{Subject};
                    push @PDFRow,  $Data{State};
                    push @PDFRow,  $Data{Queue};
                    push @PDFRow,  $Owner;
                    push @PDFRow,  $Customer;
                    push @PDFData, \@PDFRow;
                }
                else {

                    # add table block
                    $Self->{LayoutObject}->Block(
                        Name => 'Record',
                        Data => { %Data, %UserInfo, },
                    );
                }
            }

            # PDF Output
            if ( $Self->{PDFObject} ) {
                my $Title = $Self->{LayoutObject}->{LanguageObject}->Get('Ticket') . ' '
                    . $Self->{LayoutObject}->{LanguageObject}->Get('Search');
                my $PrintedBy = $Self->{LayoutObject}->{LanguageObject}->Get('printed by');
                my $Page      = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
                my $Time      = $Self->{LayoutObject}->Output( Template => '$Env{"Time"}' );
                my $Url       = '';
                if ( $ENV{REQUEST_URI} ) {
                    $Url
                        = $Self->{ConfigObject}->Get('HttpType') . '://'
                        . $Self->{ConfigObject}->Get('FQDN')
                        . $ENV{REQUEST_URI};
                }

                # get maximum number of pages
                my $MaxPages = $Self->{ConfigObject}->Get('PDF::MaxPages');
                if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
                    $MaxPages = 100;
                }

                my $CellData;

                # verify if there are tickets to show
                if (@PDFData) {

                    # create the header
                    $CellData->[0]->[0]->{Content} = $Self->{ConfigObject}->Get('Ticket::Hook');
                    $CellData->[0]->[0]->{Font}    = 'ProportionalBold';
                    $CellData->[0]->[1]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('Created');
                    $CellData->[0]->[1]->{Font} = 'ProportionalBold';
                    $CellData->[0]->[2]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('From');
                    $CellData->[0]->[2]->{Font} = 'ProportionalBold';
                    $CellData->[0]->[3]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('Subject');
                    $CellData->[0]->[3]->{Font} = 'ProportionalBold';
                    $CellData->[0]->[4]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('State');
                    $CellData->[0]->[4]->{Font} = 'ProportionalBold';
                    $CellData->[0]->[5]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('Queue');
                    $CellData->[0]->[5]->{Font} = 'ProportionalBold';
                    $CellData->[0]->[6]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('Owner');
                    $CellData->[0]->[6]->{Font} = 'ProportionalBold';
                    $CellData->[0]->[7]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('CustomerID');
                    $CellData->[0]->[7]->{Font} = 'ProportionalBold';

                    # create the content array
                    my $CounterRow = 1;
                    for my $Row (@PDFData) {
                        my $CounterColumn = 0;
                        for my $Content ( @{$Row} ) {
                            $CellData->[$CounterRow]->[$CounterColumn]->{Content} = $Content;
                            $CounterColumn++;
                        }
                        $CounterRow++;
                    }
                }

                # otherwise, show 'No ticket data found' message
                else {
                    $CellData->[0]->[0]->{Content}
                        = $Self->{LayoutObject}->{LanguageObject}->Get('No ticket data found.');
                }

                # page params
                my %PageParam;
                $PageParam{PageOrientation} = 'landscape';
                $PageParam{MarginTop}       = 30;
                $PageParam{MarginRight}     = 40;
                $PageParam{MarginBottom}    = 40;
                $PageParam{MarginLeft}      = 40;
                $PageParam{HeaderRight}     = $Title;
                $PageParam{FooterLeft}      = $Url;
                $PageParam{HeadlineLeft}    = $Title;
                $PageParam{HeadlineRight}   = $PrintedBy . ' '
                    . $Self->{UserFirstname} . ' '
                    . $Self->{UserLastname} . ' ('
                    . $Self->{UserEmail} . ') '
                    . $Time;

                # table params
                my %TableParam;
                $TableParam{CellData}            = $CellData;
                $TableParam{Type}                = 'Cut';
                $TableParam{FontSize}            = 6;
                $TableParam{Border}              = 0;
                $TableParam{BackgroundColorEven} = '#AAAAAA';
                $TableParam{BackgroundColorOdd}  = '#DDDDDD';
                $TableParam{Padding}             = 1;
                $TableParam{PaddingTop}          = 3;
                $TableParam{PaddingBottom}       = 3;

                # create new pdf document
                $Self->{PDFObject}->DocumentNew(
                    Title  => $Self->{ConfigObject}->Get('Product') . ': ' . $Title,
                    Encode => $Self->{LayoutObject}->{UserCharset},
                );

                # start table output
                $Self->{PDFObject}->PageNew( %PageParam, FooterRight => $Page . ' 1', );
                PAGE:
                for my $PageNumber ( 2 .. $MaxPages ) {

                    # output table (or a fragment of it)
                    %TableParam = $Self->{PDFObject}->Table(%TableParam);

                    # stop output or another page
                    if ( $TableParam{State} ) {
                        last PAGE;
                    }
                    else {
                        $Self->{PDFObject}->PageNew(
                            %PageParam,
                            FooterRight => $Page . ' ' . $PageNumber,
                        );
                    }
                }

                # return the pdf document
                my $Filename = 'ticket_search';
                my ( $s, $m, $h, $D, $M, $Y )
                    = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->SystemTime(),
                    );
                $M = sprintf( "%02d", $M );
                $D = sprintf( "%02d", $D );
                $h = sprintf( "%02d", $h );
                $m = sprintf( "%02d", $m );
                my $PDFString = $Self->{PDFObject}->DocumentOutput();
                return $Self->{LayoutObject}->Attachment(
                    Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
                    ContentType => "application/pdf",
                    Content     => $PDFString,
                    Type        => 'attachment',
                );
            }
            else {
                $Output = $Self->{LayoutObject}->PrintHeader( Width => 800 );
                if ( @ViewableTicketIDs == $Self->{SearchLimit} ) {
                    $Param{Warning} = '$Text{"Reached max. count of %s search hits!", "'
                        . $Self->{SearchLimit} . '"}';
                }

                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketSearchResultPrint',
                    Data         => \%Param,
                );

                # add footer
                $Output .= $Self->{LayoutObject}->PrintFooter();

                # return output
                return $Output;
            }
        }
        else {

            # redirect to the ticketzoom if result of the search is only one
            if ( scalar @ViewableTicketIDs eq 1 ) {
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AgentTicketZoom;TicketID=$ViewableTicketIDs[0]",
                );
            }

            # start html page
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Self->{LayoutObject}->Print( Output => \$Output );
            $Output = '';

            $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || '';
            $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

            # show tickets
            my $LinkPage = 'Filter='
                . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
                . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
                . ';SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
                . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
                . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkSort = 'Filter='
                . $Self->{LayoutObject}->LinkEncode( $Self->{Filter} )
                . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
                . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkFilter = 'TakeLastSearch=1;Subaction=Search;Profile='
                . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} )
                . ';';
            my $LinkBack = 'Subaction=LoadProfile;Profile='
                . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} )
                . ';TakeLastSearch=1&';

            my $FilterLink
                = 'SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} )
                . ';OrderBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{OrderBy} )
                . ';View=' . $Self->{LayoutObject}->LinkEncode( $Self->{View} )
                . ';Profile=' . $Self->{Profile} . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            $Output .= $Self->{LayoutObject}->TicketListShow(
                TicketIDs => \@ViewableTicketIDs,
                Total     => scalar @ViewableTicketIDs,

                View => $Self->{View},

                Env        => $Self,
                LinkPage   => $LinkPage,
                LinkSort   => $LinkSort,
                LinkFilter => $LinkFilter,
                LinkBack   => $LinkBack,
                Profile    => $Self->{Profile},

                TitleName => 'Search Result',
                Bulk      => 1,
                Limit     => $Self->{SearchLimit},

                Filter     => $Self->{Filter},
                FilterLink => $FilterLink,

                OrderBy      => $Self->{OrderBy},
                SortBy       => $Self->{SortBy},
                RequestedURL => 'Action=' . $Self->{Action} . ';' . $LinkPage,
            );

            # build footer
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    elsif ( $Self->{Subaction} eq 'AJAXProfileDelete' ) {
        my $Profile = $Self->{ParamObject}->GetParam( Param => 'Profile' );

        # remove old profile stuff
        $Self->{SearchProfileObject}->SearchProfileDelete(
            Base      => 'TicketSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );
        my $Output = $Self->{LayoutObject}->JSONEncode(
            Data => 1,
        );
        return $Self->{LayoutObject}->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Content     => $Output,
            Type        => 'inline'
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAX' ) {
        my $Profile = $Self->{ParamObject}->GetParam( Param => 'Profile' ) || '';
        my $EmptySearch = $Self->{ParamObject}->GetParam( Param => 'EmptySearch' );
        if ( !$Profile ) {
            $EmptySearch = 1;
        }
        my %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'TicketSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );

        # convert attributes
        if ( defined $GetParam{ShownAttributes} && ref $GetParam{ShownAttributes} eq 'ARRAY' ) {
            $GetParam{ShownAttributes} = join ';', @{ $GetParam{ShownAttributes} };
        }

        # if no profile is used, set default params of default attributes
        if ( !$Profile ) {
            if ( $Self->{Config}->{Defaults} ) {
                for my $Key ( sort keys %{ $Self->{Config}->{Defaults} } ) {
                    next if !$Self->{Config}->{Defaults}->{$Key};
                    next if $Key eq 'DynamicField';

                    if ( $Key =~ /^(Ticket|Article)(Create|Change|Close|Escalation)/ ) {
                        my @Items = split /;/, $Self->{Config}->{Defaults}->{$Key};
                        for my $Item (@Items) {
                            my ( $Key, $Value ) = split /=/, $Item;
                            $GetParam{$Key} = $Value;
                        }
                    }
                    else {
                        $GetParam{$Key} = $Self->{Config}->{Defaults}->{$Key};
                    }
                }
            }
        }
        my @Attributes = (
            {
                Key   => 'TicketNumber',
                Value => 'Ticket Number',
            },
            {
                Key   => 'Fulltext',
                Value => 'Fulltext',
            },
            {
                Key   => 'Title',
                Value => 'Title',
            },
            {
                Key      => '',
                Value    => '-',
                Disabled => 1,
            },
            {
                Key   => 'From',
                Value => 'From',
            },
            {
                Key   => 'To',
                Value => 'To',
            },
            {
                Key   => 'Cc',
                Value => 'Cc',
            },
            {
                Key   => 'Subject',
                Value => 'Subject',
            },
            {
                Key   => 'Body',
                Value => 'Body',
            },
            {
                Key      => '',
                Value    => '-',
                Disabled => 1,
            },
            {
                Key   => 'CustomerID',
                Value => 'CustomerID',
            },
            {
                Key   => 'CustomerUserLogin',
                Value => 'Customer User Login',
            },
            {
                Key   => 'StateIDs',
                Value => 'State',
            },
            {
                Key   => 'QueueIDs',
                Value => 'Queue',
            },
            {
                Key   => 'PriorityIDs',
                Value => 'Priority',
            },
            {
                Key   => 'OwnerIDs',
                Value => 'Owner',
            },
            {
                Key   => 'CreatedQueueIDs',
                Value => 'Created in Queue',
            },
            {
                Key   => 'CreatedUserIDs',
                Value => 'Created by',
            },
        );
        if ( $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
            push @Attributes, (
                {
                    Key   => 'WatchUserIDs',
                    Value => 'Watcher',
                },
            );
        }
        if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
            push @Attributes, (
                {
                    Key   => 'ResponsibleIDs',
                    Value => 'Responsible',
                },
            );
        }
        if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
            push @Attributes, (
                {
                    Key   => 'TypeIDs',
                    Value => 'Type',
                },
            );
        }
        if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
            push @Attributes, (
                {
                    Key   => 'ServiceIDs',
                    Value => 'Service',
                },
                {
                    Key   => 'SLAIDs',
                    Value => 'SLA',
                },
            );
        }

        my $DynamicFieldSeparator = 1;

        # create dynamic fields search options for attribute select
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
            next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

            # create a separator for dynamic fields attributes
            if ($DynamicFieldSeparator) {
                push @Attributes, (
                    {
                        Key      => '',
                        Value    => '-',
                        Disabled => 1,
                    },
                );

                $DynamicFieldSeparator = 0;
            }

            # get search field preferences
            my $SearchFieldPreferences = $Self->{BackendObject}->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            # translate the dynamic field label
            my $TranslatedDynamicFieldLabel = $Self->{LayoutObject}->{LanguageObject}->Get(
                $DynamicFieldConfig->{Label},
            );

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # translate the suffix
                my $TranslatedSuffix = $Self->{LayoutObject}->{LanguageObject}->Get(
                    $Preference->{LabelSuffix},
                ) || '';

                if ($TranslatedSuffix) {
                    $TranslatedSuffix = ' (' . $TranslatedSuffix . ')';
                }

                push @Attributes, (
                    {
                        Key => 'Search_DynamicField_'
                            . $DynamicFieldConfig->{Name}
                            . $Preference->{Type},
                        Value => $TranslatedDynamicFieldLabel . $TranslatedSuffix,
                    },
                );
            }
        }

        # create a separator if a dynamic field attribute was pushed
        if ( !$DynamicFieldSeparator ) {
            push @Attributes, (
                {
                    Key      => '',
                    Value    => '-',
                    Disabled => 1,
                },
            );
        }

        # create HTML strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # get historical values from database
                    my $HistoricalValues = $Self->{BackendObject}->HistoricalValuesGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                    );

                    my $Data = $PossibleValues;

                    # add historic values to current values (if they don't exist anymore)
                    if ( IsHashRefWithData($HistoricalValues) ) {
                        for my $Key ( sort keys %{$HistoricalValues} ) {
                            if ( !$Data->{$Key} ) {
                                $Data->{$Key} = $HistoricalValues->{$Key}
                            }
                        }
                    }

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$Data};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $Self->{TicketObject}->TicketAcl(
                        Action        => $Self->{Action},
                        ReturnType    => 'Ticket',
                        ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data          => \%AclData,
                        UserID        => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $Self->{TicketObject}->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $Data->{$_} } keys %Filter;
                    }
                }
            }

            # get search field preferences
            my $SearchFieldPreferences = $Self->{BackendObject}->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # get field html
                $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                    = $Self->{BackendObject}->SearchFieldRender(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    Profile              => \%GetParam,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    DefaultValue =>
                        $Self->{Config}->{Defaults}->{DynamicField}
                        ->{ $DynamicFieldConfig->{Name} },
                    LayoutObject => $Self->{LayoutObject},
                    Type         => $Preference->{Type},
                    );
            }
        }

        push @Attributes, (
            {
                Key   => 'LockIDs',
                Value => 'Lock',
            },
            {
                Key   => 'TicketCreateTimePoint',
                Value => 'Ticket Create Time (before/after)',
            },
            {
                Key   => 'TicketCreateTimeSlot',
                Value => 'Ticket Create Time (between)',
            },
            {
                Key   => 'TicketChangeTimePoint',
                Value => 'Ticket Change Time (before/after)',
            },
            {
                Key   => 'TicketChangeTimeSlot',
                Value => 'Ticket Change Time (between)',
            },
            {
                Key   => 'TicketCloseTimePoint',
                Value => 'Ticket Close Time (before/after)',
            },
            {
                Key   => 'TicketCloseTimeSlot',
                Value => 'Ticket Close Time (between)',
            },
            {
                Key   => 'TicketEscalationTimePoint',
                Value => 'Ticket Escalation Time (before/after)',
            },
            {
                Key   => 'TicketEscalationTimeSlot',
                Value => 'Ticket Escalation Time (between)',
            },
            {
                Key   => 'ArticleCreateTimePoint',
                Value => 'Article Create Time (before/after)',
            },
            {
                Key   => 'ArticleCreateTimeSlot',
                Value => 'Article Create Time (between)',
            },
        );
        if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {
            push @Attributes, (
                {
                    Key   => 'SearchInArchive',
                    Value => 'Archive Search',
                },
            );
        }
        $Param{AttributesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data     => \@Attributes,
            Name     => 'Attribute',
            Multiple => 0,
        );
        $Param{AttributesOrigStrg} = $Self->{LayoutObject}->BuildSelection(
            Data     => \@Attributes,
            Name     => 'AttributeOrig',
            Multiple => 0,
        );

        # get user of own groups
        my %ShownUsers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( !$Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
            my %Involved = $Self->{GroupObject}->GroupMemberInvolvedList(
                UserID => $Self->{UserID},
                Type   => 'ro',
            );
            for my $UserID ( sort keys %ShownUsers ) {
                if ( !$Involved{$UserID} ) {
                    delete $ShownUsers{$UserID};
                }
            }
        }
        $Param{UserStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ShownUsers,
            Name       => 'OwnerIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{OwnerIDs},
        );
        $Param{CreatedUserStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%ShownUsers,
            Name       => 'CreatedUserIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{CreatedUserIDs},
        );
        if ( $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
            $Param{WatchUserStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%ShownUsers,
                Name       => 'WatchUserIDs',
                Multiple   => 1,
                Size       => 5,
                SelectedID => $GetParam{WatchUserIDs},
            );
        }
        if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
            $Param{ResponsibleStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%ShownUsers,
                Name       => 'ResponsibleIDs',
                Multiple   => 1,
                Size       => 5,
                SelectedID => $GetParam{ResponsibleIDs},
            );
        }

        # build service string
        if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

            my %Service = $Self->{ServiceObject}->ServiceList( UserID => $Self->{UserID}, );
            $Param{ServicesStrg} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%Service,
                Name        => 'ServiceIDs',
                SelectedID  => $GetParam{ServiceIDs},
                TreeView    => $TreeView,
                Sort        => 'TreeView',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
            );
            my %SLA = $Self->{SLAObject}->SLAList( UserID => $Self->{UserID}, );
            $Param{SLAsStrg} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%SLA,
                Name        => 'SLAIDs',
                SelectedID  => $GetParam{SLAIDs},
                Sort        => 'AlphanumericValue',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
            );
        }

        $Param{ResultFormStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                Normal => 'Normal',
                Print  => 'Print',
                CSV    => 'CSV',
            },
            Name => 'ResultForm',
            SelectedID => $GetParam{ResultForm} || 'Normal',
        );

        if ( $Self->{ConfigObject}->Get('Ticket::ArchiveSystem') ) {

            $Param{SearchInArchiveStrg} = $Self->{LayoutObject}->BuildSelection(
                Data => {
                    ArchivedTickets    => 'Archived tickets',
                    NotArchivedTickets => 'Unarchived tickets',
                    AllTickets         => 'All tickets',
                },
                Name => 'SearchInArchive',
                SelectedID => $GetParam{SearchInArchive} || 'NotArchivedTickets',
            );
        }

        my %Profiles = $Self->{SearchProfileObject}->SearchProfileList(
            Base      => 'TicketSearch',
            UserLogin => $Self->{UserLogin},
        );
        delete $Profiles{''};
        delete $Profiles{'last-search'};
        if ($EmptySearch) {
            $Profiles{''} = '-';
        }
        else {
            $Profiles{'last-search'} = '-';
        }
        $Param{ProfilesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => \%Profiles,
            Name       => 'Profile',
            ID         => 'SearchProfile',
            SelectedID => $Profile,
        );

        $Param{StatesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                $Self->{StateObject}->StateList(
                    UserID => $Self->{UserID},
                    Action => $Self->{Action},
                ),
            },
            Name       => 'StateIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{StateIDs},
        );
        my %AllQueues = $Self->{QueueObject}->GetAllQueues(
            UserID => $Self->{UserID},
            Type   => 'ro',
        );
        $Param{QueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data               => \%AllQueues,
            Size               => 5,
            Multiple           => 1,
            Name               => 'QueueIDs',
            TreeView           => $TreeView,
            SelectedIDRefArray => $GetParam{QueueIDs},
            OnChangeSubmit     => 0,
        );
        $Param{CreatedQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data               => \%AllQueues,
            Size               => 5,
            Multiple           => 1,
            Name               => 'CreatedQueueIDs',
            TreeView           => $TreeView,
            SelectedIDRefArray => $GetParam{CreatedQueueIDs},
            OnChangeSubmit     => 0,
        );
        $Param{PrioritiesStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                $Self->{PriorityObject}->PriorityList(
                    UserID => $Self->{UserID},
                    Action => $Self->{Action},
                ),
            },
            Name       => 'PriorityIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{PriorityIDs},
        );
        $Param{LocksStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                $Self->{LockObject}->LockList(
                    UserID => $Self->{UserID},
                    Action => $Self->{Action},
                ),
            },
            Name       => 'LockIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{LockIDs},
        );

        $Param{ArticleCreateTimePoint} = $Self->{LayoutObject}->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'ArticleCreateTimePoint',
            SelectedID => $GetParam{ArticleCreateTimePoint},
        );
        $Param{ArticleCreateTimePointStart} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name => 'ArticleCreateTimePointStart',
            SelectedID => $GetParam{ArticleCreateTimePointStart} || 'Last',
        );
        $Param{ArticleCreateTimePointFormat} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'ArticleCreateTimePointFormat',
            SelectedID => $GetParam{ArticleCreateTimePointFormat},
        );
        $Param{ArticleCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix   => 'ArticleCreateTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{ArticleCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix => 'ArticleCreateTimeStop',
            Format => 'DateInputFormat',
        );
        $Param{TicketCreateTimePoint} = $Self->{LayoutObject}->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketCreateTimePoint',
            SelectedID => $GetParam{TicketCreateTimePoint},
        );
        $Param{TicketCreateTimePointStart} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name => 'TicketCreateTimePointStart',
            SelectedID => $GetParam{TicketCreateTimePointStart} || 'Last',
        );
        $Param{TicketCreateTimePointFormat} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'TicketCreateTimePointFormat',
            SelectedID => $GetParam{TicketCreateTimePointFormat},
        );
        $Param{TicketCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketCreateTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketCreateTimeStop',
            Format => 'DateInputFormat',
        );

        $Param{TicketChangeTimePoint} = $Self->{LayoutObject}->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketChangeTimePoint',
            SelectedID => $GetParam{TicketChangeTimePoint},
        );
        $Param{TicketChangeTimePointStart} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name => 'TicketChangeTimePointStart',
            SelectedID => $GetParam{TicketChangeTimePointStart} || 'Last',
        );
        $Param{TicketChangeTimePointFormat} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'TicketChangeTimePointFormat',
            SelectedID => $GetParam{TicketChangeTimePointFormat},
        );
        $Param{TicketChangeTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketChangeTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketChangeTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketChangeTimeStop',
            Format => 'DateInputFormat',
        );

        $Param{TicketCloseTimePoint} = $Self->{LayoutObject}->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketCloseTimePoint',
            SelectedID => $GetParam{TicketCloseTimePoint},
        );
        $Param{TicketCloseTimePointStart} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name => 'TicketCloseTimePointStart',
            SelectedID => $GetParam{TicketCloseTimePointStart} || 'Last',
        );
        $Param{TicketCloseTimePointFormat} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'TicketCloseTimePointFormat',
            SelectedID => $GetParam{TicketCloseTimePointFormat},
        );
        $Param{TicketCloseTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketCloseTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketCloseTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketCloseTimeStop',
            Format => 'DateInputFormat',
        );

        $Param{TicketEscalationTimePoint} = $Self->{LayoutObject}->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketEscalationTimePoint',
            SelectedID => $GetParam{TicketEscalationTimePoint},
        );
        $Param{TicketEscalationTimePointStart} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Next'   => 'within the next ...',
                'Before' => 'more than ... ago',
            },
            Name => 'TicketEscalationTimePointStart',
            SelectedID => $GetParam{TicketEscalationTimePointStart} || 'Last',
        );
        $Param{TicketEscalationTimePointFormat} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'TicketEscalationTimePointFormat',
            SelectedID => $GetParam{TicketEscalationTimePointFormat},
        );
        $Param{TicketEscalationTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketEscalationTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketEscalationTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketEscalationTimeStop',
            Format => 'DateInputFormat',
        );

        my %GetParamBackup = %GetParam;
        for my $Key (qw(TicketEscalation TicketClose TicketChange TicketCreate ArticleCreate)) {
            for my $SubKey (qw(TimeStart TimeStop TimePoint TimePointStart TimePointFormat)) {
                delete $GetParam{ $Key . $SubKey };
                delete $GetParamBackup{ $Key . $SubKey };
            }
        }

        # build type string
        if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
            my %Type = $Self->{TypeObject}->TypeList( UserID => $Self->{UserID}, );
            $Param{TypesStrg} = $Self->{LayoutObject}->BuildSelection(
                Data        => \%Type,
                Name        => 'TypeIDs',
                SelectedID  => $GetParam{TypeIDs},
                Sort        => 'AlphanumericValue',
                Size        => 3,
                Multiple    => 1,
                Translation => 0,
            );
        }

        # html search mask output
        $Self->{LayoutObject}->Block(
            Name => 'SearchAJAX',
            Data => {
                %Param,
                %GetParam,
                EmptySearch => $EmptySearch,
            },
        );

        # output Dynamic fields blocks
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $Self->{BackendObject}->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # skip fields that HTML could not be retrieved
                next PREFERENCE if !IsHashRefWithData(
                    $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                );

                $Self->{LayoutObject}->Block(
                    Name => 'DynamicField',
                    Data => {
                        Label =>
                            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                            ->{Label},
                        Field =>
                            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                            ->{Field},
                    },
                );
            }
        }

        # compat. map for attributes
        my %Map = (
            TimeSearchType           => 'TicketCreate',
            ChangeTimeSearchType     => 'TicketChange',
            CloseTimeSearchType      => 'TicketClose',
            EscalationTimeSearchType => 'TicketEscalation',
            ArticleTimeSearchType    => 'ArticleCreate',
        );
        for my $Key ( sort keys %Map ) {
            next if !defined $GetParamBackup{$Key};
            if ( $GetParamBackup{$Key} eq 'TimePoint' ) {
                $GetParamBackup{ $Map{$Key} . 'TimePoint' } = 1;
            }
            elsif ( $GetParamBackup{$Key} eq 'TimeSlot' ) {
                $GetParamBackup{ $Map{$Key} . 'TimeSlot' } = 1;
            }
        }

        # show attributes
        my @ShownAttributes;
        if ( $GetParamBackup{ShownAttributes} ) {
            @ShownAttributes = split /;/, $GetParamBackup{ShownAttributes};
        }
        my %AlreadyShown;
        for my $Item (@Attributes) {
            my $Key = $Item->{Key};
            next if !$Key;

            # check if shown
            if (@ShownAttributes) {
                my $Show = 0;
                for my $ShownAttribute (@ShownAttributes) {
                    if ( 'Label' . $Key eq $ShownAttribute ) {
                        $Show = 1;
                        last;
                    }
                }
                next if !$Show;
            }
            else {
                next if !defined $GetParamBackup{$Key};
                next if $GetParamBackup{$Key} eq '';
            }

            # show attribute
            next if $AlreadyShown{$Key};
            $AlreadyShown{$Key} = 1;
            $Self->{LayoutObject}->Block(
                Name => 'SearchAJAXShow',
                Data => {
                    Attribute => $Key,
                },
            );
        }

        # if no attribute is shown, show fulltext search
        if ( !$Profile ) {

            # Merge regular show/hide settings and the settings for the dynamic fields
            my %Defaults = %{ $Self->{Config}->{Defaults} || {} };
            for my $DynamicField ( sort keys %{ $Self->{Config}->{DynamicField} || {} } ) {
                if ( $Self->{Config}->{DynamicField}->{$DynamicField} == 2 ) {
                    $Defaults{"Search_DynamicField_$DynamicField"} = 1;
                }
            }

            if (%Defaults) {
                for my $Key ( sort keys %Defaults ) {
                    next if $Key eq 'DynamicField';    # Ignore entry for DF config
                    next if $AlreadyShown{$Key};
                    $AlreadyShown{$Key} = 1;

                    $Self->{LayoutObject}->Block(
                        Name => 'SearchAJAXShow',
                        Data => {
                            Attribute => $Key,
                        },
                    );
                }
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'SearchAJAXShow',
                    Data => {
                        Attribute => 'Fulltext',
                    },
                );
            }
        }

        my $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentTicketSearch',
            Data         => \%Param,
        );
        return $Self->{LayoutObject}->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $Self->{LayoutObject}->{UserCharset},
            Content     => $Output,
            Type        => 'inline'
        );
    }

    # show default search screen
    $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketSearch',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
