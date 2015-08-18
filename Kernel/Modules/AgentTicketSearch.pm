# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketSearch;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # get config data
    $Self->{StartHit} = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{SearchLimit} = $Config->{SearchLimit} || 500;
    $Self->{SortBy} = $ParamObject->GetParam( Param => 'SortBy' )
        || $Config->{'SortBy::Default'}
        || 'Age';
    $Self->{OrderBy} = $ParamObject->GetParam( Param => 'OrderBy' )
        || $Config->{'Order::Default'}
        || 'Down';
    $Self->{Profile}        = $ParamObject->GetParam( Param => 'Profile' )        || '';
    $Self->{SaveProfile}    = $ParamObject->GetParam( Param => 'SaveProfile' )    || '';
    $Self->{TakeLastSearch} = $ParamObject->GetParam( Param => 'TakeLastSearch' ) || '';
    $Self->{SelectTemplate} = $ParamObject->GetParam( Param => 'SelectTemplate' ) || '';
    $Self->{EraseTemplate}  = $ParamObject->GetParam( Param => 'EraseTemplate' )  || '';

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check request
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionTicketNumber' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentTicketSearchOpenSearchDescriptionTicketNumber',
            Data         => \%Param,
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescriptionTicketNumber.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }
    if ( $Self->{Subaction} eq 'OpenSearchDescriptionFulltext' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'AgentTicketSearchOpenSearchDescriptionFulltext',
            Data         => \%Param,
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescriptionFulltext.xml',
            ContentType => 'application/opensearchdescription+xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # check request
    if ( $ParamObject->GetParam( Param => 'SearchTemplate' ) && $Self->{Profile} ) {
        my $Profile = $LayoutObject->LinkEncode( $Self->{Profile} );
        return $LayoutObject->Redirect(
            OP =>
                "Action=AgentTicketSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Profile"
        );
    }

    # get single params
    my %GetParam;

    # get needed objects
    my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');
    my $DynamicFieldObject  = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $BackendObject       = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = $Config->{DynamicField};

    # get the dynamic fields for ticket object
    my $DynamicField = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # load profiles string params (press load profile)
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Self->{Profile} ) || $Self->{TakeLastSearch} ) {
        %GetParam = $SearchProfileObject->SearchProfileGet(
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
            Agent ResultForm TimeSearchType ChangeTimeSearchType CloseTimeSearchType LastChangeTimeSearchType EscalationTimeSearchType
            UseSubQueues AttachmentName
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
            TicketLastChangeTimePointFormat TicketLastChangeTimePoint
            TicketLastChangeTimePointStart
            TicketLastChangeTimeStart TicketLastChangeTimeStartDay TicketLastChangeTimeStartMonth
            TicketLastChangeTimeStartYear
            TicketLastChangeTimeStop TicketLastChangeTimeStopDay TicketLastChangeTimeStopMonth
            TicketLastChangeTimeStopYear
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
            TicketCloseTimeNewerDate TicketCloseTimeOlderDate
            )
            )
        {

            # get search string params (get submitted params)
            $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );

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
            my @Array = $ParamObject->GetArray( Param => $Key );
            if (@Array) {
                $GetParam{$Key} = \@Array;
            }
        }

        # get Dynamic fields from param object
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $BackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # extract the dynamic field value from the web request
                my $DynamicFieldValue = $BackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    ReturnProfileStructure => 1,
                    LayoutObject           => $LayoutObject,
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

    # get last change time option
    if ( !$GetParam{LastChangeTimeSearchType} ) {
        $GetParam{'LastChangeTimeSearchType::None'} = 1;
    }
    elsif ( $GetParam{LastChangeTimeSearchType} eq 'TimePoint' ) {
        $GetParam{'LastChangeTimeSearchType::TimePoint'} = 1;
    }
    elsif ( $GetParam{LastChangeTimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'LastChangeTimeSearchType::TimeSlot'} = 1;
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

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # show result site
    if ( $Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate} ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} || !$Self->{SaveProfile} ) {
            $Self->{Profile} = 'last-search';
        }

        # save search profile (under last-search or real profile name)
        $Self->{SaveProfile} = 1;

        # remember last search values
        if ( $Self->{SaveProfile} && $Self->{Profile} ) {

            # remove old profile stuff
            $SearchProfileObject->SearchProfileDelete(
                Base      => 'TicketSearch',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );

            # convert attributes
            if ( $GetParam{ShownAttributes} && ref $GetParam{ShownAttributes} eq '' ) {
                $GetParam{ShownAttributes} = [ split /;/, $GetParam{ShownAttributes} ];
            }

            # insert new profile params
            KEY:
            for my $Key ( sort keys %GetParam ) {
                next KEY if !defined $GetParam{$Key};
                $SearchProfileObject->SearchProfileAdd(
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
            TicketLastChange => 'LastChangeTime',
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
                    $GetParam{ $TimeType . 'TimeNewerDate' } = $GetParam{ $TimeType . 'TimeStartYear' } . '-'
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
                    $GetParam{ $TimeType . 'TimeOlderDate' } = $GetParam{ $TimeType . 'TimeStopYear' } . '-'
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

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Special behaviour for the fulltext search toolbar module:
        # - Check full text string to see if contents is a ticket number.
        # - If exists and not in print or CSV mode, redirect to the ticket.
        # See http://bugs.otrs.org/show_bug.cgi?id=4238 for details.
        #   The original problem was that tickets with customer reply will be
        #   found by a fulltext search (ticket number is in the subjects), but
        #   'new' tickets will not be found.
        if (
            $GetParam{Fulltext}
            && $ParamObject->GetParam( Param => 'CheckTicketNumberAndRedirect' )
            && $GetParam{ResultForm} ne 'Normal'
            && $GetParam{ResultForm} ne 'Print'
            )
        {
            my $TicketID = $TicketObject->TicketIDLookup(
                TicketNumber => $GetParam{Fulltext},
                UserID       => $Self->{UserID},
            );
            if ($TicketID) {
                return $LayoutObject->Redirect(
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
        if ( $ConfigObject->Get('Ticket::ArchiveSystem') ) {

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
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $BackendObject->SearchFieldPreferences(
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
                my $SearchParameter = $BackendObject->SearchFieldParameterBuild(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Profile            => \%GetParam,
                    LayoutObject       => $LayoutObject,
                    Type               => $Preference->{Type},
                );

                # set search parameter
                if ( defined $SearchParameter ) {
                    $DynamicFieldSearchParameters{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Parameter};
                }
            }
        }

        my @ViewableTicketIDs;

        {
            local $Kernel::System::DB::UseSlaveDB = 1;

            # perform ticket search
            @ViewableTicketIDs = $TicketObject->TicketSearch(
                Result              => 'ARRAY',
                SortBy              => $Self->{SortBy},
                OrderBy             => $Self->{OrderBy},
                Limit               => $Self->{SearchLimit},
                UserID              => $Self->{UserID},
                ConditionInline     => $Config->{ExtendedSearchCondition},
                ContentSearchPrefix => '*',
                ContentSearchSuffix => '*',
                FullTextIndex       => 1,
                %GetParam,
                %DynamicFieldSearchParameters,
            );
        }

        # get needed objects
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $TimeObject         = $Kernel::OM->Get('Kernel::System::Time');

        # get the ticket dynamic fields for CSV display
        my $CSVDynamicField = $DynamicFieldObject->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Ticket'],
            FieldFilter => $Config->{SearchCSVDynamicField} || {},
        );

        # CSV and Excel output
        if (
            $GetParam{ResultForm} eq 'CSV'
            ||
            $GetParam{ResultForm} eq 'Excel'
            )
        {

            # create head (actual head and head for data fill)
            my @TmpCSVHead = @{ $Config->{SearchCSVData} };
            my @CSVHead    = @{ $Config->{SearchCSVData} };

            # include the selected dynamic fields in CVS results
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                next DYNAMICFIELD if !$DynamicFieldConfig->{Name};
                next DYNAMICFIELD if $DynamicFieldConfig->{Name} eq '';

                push @TmpCSVHead, 'DynamicField_' . $DynamicFieldConfig->{Name};
                push @CSVHead,    $DynamicFieldConfig->{Label};
            }

            my @CSVData;
            for my $TicketID (@ViewableTicketIDs) {

                # get first article data
                my %Data = $TicketObject->ArticleFirstArticle(
                    TicketID      => $TicketID,
                    Extended      => 1,
                    DynamicFields => 1,
                );

                if ( !%Data ) {

                    # get ticket data instead
                    %Data = $TicketObject->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 1,
                    );

                    # set missing information
                    $Data{Subject} = $Data{Title} || 'Untitled';
                    $Data{Body} = $LayoutObject->{LanguageObject}->Get(
                        'This item has no articles yet.'
                    );
                    $Data{From} = '--';
                }

                for my $Key (qw(State Lock)) {
                    $Data{$Key} = $LayoutObject->{LanguageObject}->Translate( $Data{$Key} );
                }

                $Data{Age} = $LayoutObject->CustomerAge(
                    Age   => $Data{Age},
                    Space => ' '
                );

                # get whole article (if configured!)
                if ( $Config->{SearchArticleCSVTree} ) {
                    my @Article = $TicketObject->ArticleGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                    );

                    if ( $#Article == -1 ) {
                        $Data{ArticleTree}
                            .= 'This item has no articles yet.';
                    }
                    else
                    {
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
                }

                # customer info (customer name)
                if ( $Data{CustomerUserID} ) {
                    $Data{CustomerName} = $CustomerUserObject->CustomerName(
                        UserLogin => $Data{CustomerUserID},
                    );
                }

                # user info
                my %UserInfo = $UserObject->GetUserData(
                    User => $Data{Owner},
                );

                # merge row data
                my %Info = (
                    %Data,
                    %UserInfo,
                    AccountedTime =>
                        $TicketObject->TicketAccountedTimeGet( TicketID => $TicketID ),
                );

                my @Data;
                for my $Header (@TmpCSVHead) {

                    # check if header is a dynamic field and get the value from dynamic field
                    # backend
                    if ( $Header =~ m{\A DynamicField_ ( [a-zA-Z\d]+ ) \z}xms ) {

                        # loop over the dynamic fields configured for CSV output
                        DYNAMICFIELD:
                        for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
                            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

                            # skip all fields that does not match with current field name ($1)
                            # with out the 'DynamicField_' prefix
                            next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                            # get the value as for print (to correctly display)
                            my $ValueStrg = $BackendObject->DisplayValueRender(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                Value              => $Info{$Header},
                                HTMLOutput         => 0,
                                LayoutObject       => $LayoutObject,
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
            my $UserCSVSeparator = $LayoutObject->{LanguageObject}->{Separator};

            if ( $ConfigObject->Get('PreferencesGroups')->{CSVSeparator}->{Active} ) {
                my %UserData = $UserObject->GetUserData( UserID => $Self->{UserID} );
                $UserCSVSeparator = $UserData{UserCSVSeparator} if $UserData{UserCSVSeparator};
            }

            my %HeaderMap = (
                TicketNumber => 'Ticket Number',
                CustomerName => 'Customer Realname',
            );

            my @CSVHeadTranslated = map { $LayoutObject->{LanguageObject}->Translate( $HeaderMap{$_} || $_ ); }
                @CSVHead;

            my $FileName = 'ticket_search';
            my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
                SystemTime => $TimeObject->SystemTime(),
            );
            $M = sprintf( "%02d", $M );
            $D = sprintf( "%02d", $D );
            $h = sprintf( "%02d", $h );
            $m = sprintf( "%02d", $m );

            # get CSV object
            my $CSVObject = $Kernel::OM->Get('Kernel::System::CSV');

            # generate CSV output
            if ( $GetParam{ResultForm} eq 'CSV' ) {
                my $CSV = $CSVObject->Array2CSV(
                    Head      => \@CSVHeadTranslated,
                    Data      => \@CSVData,
                    Separator => $UserCSVSeparator,
                );

                # return csv to download
                return $LayoutObject->Attachment(
                    Filename    => $FileName . "_" . "$Y-$M-$D" . "_" . "$h-$m.csv",
                    ContentType => "text/csv; charset=" . $LayoutObject->{UserCharset},
                    Content     => $CSV,
                );
            }

            # generate Excel output
            elsif ( $GetParam{ResultForm} eq 'Excel' ) {
                my $Excel = $CSVObject->Array2CSV(
                    Head   => \@CSVHeadTranslated,
                    Data   => \@CSVData,
                    Format => 'Excel',
                );

                # return Excel to download
                return $LayoutObject->Attachment(
                    Filename => $FileName . "_" . "$Y-$M-$D" . "_" . "$h-$m.xlsx",
                    ContentType =>
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    Content => $Excel,
                );
            }
        }

        # PDF output
        elsif ( $GetParam{ResultForm} eq 'Print' ) {

            # get PDF object
            my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

            my @PDFData;
            for my $TicketID (@ViewableTicketIDs) {

                # get first article data
                my %Data = $TicketObject->ArticleFirstArticle(
                    TicketID      => $TicketID,
                    DynamicFields => 1,
                );

                if ( !%Data ) {

                    # get ticket data instead
                    %Data = $TicketObject->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 1,
                    );

                    # set missing information
                    $Data{Subject} = $Data{Title} || 'Untitled';
                    $Data{From} = '--';
                }

                # customer info
                my %CustomerData;
                if ( $Data{CustomerUserID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        User => $Data{CustomerUserID},
                    );
                }
                elsif ( $Data{CustomerID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        CustomerID => $Data{CustomerID},
                    );
                }

                # customer info (customer name)
                if ( $CustomerData{UserLogin} ) {
                    $Data{CustomerName} = $CustomerUserObject->CustomerName(
                        UserLogin => $CustomerData{UserLogin},
                    );
                }

                # user info
                my %UserInfo = $UserObject->GetUserData(
                    User => $Data{Owner},
                );

                # customer info string
                $UserInfo{CustomerName} = '(' . $UserInfo{CustomerName} . ')'
                    if ( $UserInfo{CustomerName} );

                my %Info = ( %Data, %UserInfo );
                my $Created = $LayoutObject->{LanguageObject}->FormatTimeString(
                    $Data{Created},
                    'DateFormat',
                );
                my $Owner    = "$Info{Owner} ($Info{UserFullname})";
                my $Customer = "$Data{CustomerID} $Data{CustomerName}";

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

            my $Title = $LayoutObject->{LanguageObject}->Translate('Ticket') . ' '
                . $LayoutObject->{LanguageObject}->Translate('Search');
            my $PrintedBy = $LayoutObject->{LanguageObject}->Translate('printed by');
            my $Page      = $LayoutObject->{LanguageObject}->Translate('Page');
            my $Time      = $LayoutObject->{Time};

            # get maximum number of pages
            my $MaxPages = $ConfigObject->Get('PDF::MaxPages');
            if ( !$MaxPages || $MaxPages < 1 || $MaxPages > 1000 ) {
                $MaxPages = 100;
            }

            my $CellData;

            # verify if there are tickets to show
            if (@PDFData) {

                # create the header
                $CellData->[0]->[0]->{Content} = $ConfigObject->Get('Ticket::Hook');
                $CellData->[0]->[0]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[1]->{Content} = $LayoutObject->{LanguageObject}->Translate('Created');
                $CellData->[0]->[1]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[2]->{Content} = $LayoutObject->{LanguageObject}->Translate('From');
                $CellData->[0]->[2]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[3]->{Content} = $LayoutObject->{LanguageObject}->Translate('Subject');
                $CellData->[0]->[3]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[4]->{Content} = $LayoutObject->{LanguageObject}->Translate('State');
                $CellData->[0]->[4]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[5]->{Content} = $LayoutObject->{LanguageObject}->Translate('Queue');
                $CellData->[0]->[5]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[6]->{Content} = $LayoutObject->{LanguageObject}->Translate('Owner');
                $CellData->[0]->[6]->{Font}    = 'ProportionalBold';
                $CellData->[0]->[7]->{Content} = $LayoutObject->{LanguageObject}->Translate('CustomerID');
                $CellData->[0]->[7]->{Font}    = 'ProportionalBold';

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
                $CellData->[0]->[0]->{Content} = $LayoutObject->{LanguageObject}->Translate('No ticket data found.');
            }

            # page params
            my %PageParam;
            $PageParam{PageOrientation} = 'landscape';
            $PageParam{MarginTop}       = 30;
            $PageParam{MarginRight}     = 40;
            $PageParam{MarginBottom}    = 40;
            $PageParam{MarginLeft}      = 40;
            $PageParam{HeaderRight}     = $Title;
            $PageParam{HeadlineLeft}    = $Title;

            # table params
            my %TableParam;
            $TableParam{CellData}            = $CellData;
            $TableParam{Type}                = 'Cut';
            $TableParam{FontSize}            = 6;
            $TableParam{Border}              = 0;
            $TableParam{BackgroundColorEven} = '#DDDDDD';
            $TableParam{Padding}             = 1;
            $TableParam{PaddingTop}          = 3;
            $TableParam{PaddingBottom}       = 3;

            # create new pdf document
            $PDFObject->DocumentNew(
                Title  => $ConfigObject->Get('Product') . ': ' . $Title,
                Encode => $LayoutObject->{UserCharset},
            );

            # start table output
            $PDFObject->PageNew(
                %PageParam,
                FooterRight => $Page . ' 1',
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );

            # output title
            $PDFObject->Text(
                Text     => $Title,
                FontSize => 13,
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -6,
            );

            # output "printed by"
            $PDFObject->Text(
                Text => $PrintedBy . ' '
                    . $Self->{UserFirstname} . ' '
                    . $Self->{UserLastname} . ' ('
                    . $Self->{UserEmail} . ')'
                    . ', ' . $Time,
                FontSize => 9,
            );

            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -14,
            );

            PAGE:
            for my $PageNumber ( 2 .. $MaxPages ) {

                # output table (or a fragment of it)
                %TableParam = $PDFObject->Table(%TableParam);

                # stop output or another page
                if ( $TableParam{State} ) {
                    last PAGE;
                }
                else {
                    $PDFObject->PageNew(
                        %PageParam,
                        FooterRight => $Page . ' ' . $PageNumber,
                    );
                }
            }

            # return the pdf document
            my $Filename = 'ticket_search';
            my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
                SystemTime => $TimeObject->SystemTime(),
            );
            $M = sprintf( "%02d", $M );
            $D = sprintf( "%02d", $D );
            $h = sprintf( "%02d", $h );
            $m = sprintf( "%02d", $m );
            my $PDFString = $PDFObject->DocumentOutput();
            return $LayoutObject->Attachment(
                Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
                ContentType => "application/pdf",
                Content     => $PDFString,
                Type        => 'inline',
            );
        }
        else {

            # redirect to the ticketzoom if result of the search is only one
            if ( scalar @ViewableTicketIDs eq 1 && !$Self->{TakeLastSearch} ) {
                return $LayoutObject->Redirect(
                    OP => "Action=AgentTicketZoom;TicketID=$ViewableTicketIDs[0]",
                );
            }

            # store last overview screen
            my $URL = "Action=AgentTicketSearch;Subaction=Search"
                . ";Profile=" . $LayoutObject->LinkEncode( $Self->{Profile} )
                . ";SortBy=" . $LayoutObject->LinkEncode( $Self->{SortBy} )
                . ";OrderBy=" . $LayoutObject->LinkEncode( $Self->{OrderBy} )
                . ";TakeLastSearch=1;StartHit="
                . $LayoutObject->LinkEncode( $Self->{StartHit} );

            $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastScreenOverview',
                Value     => $URL,
            );

            # start html page
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            $Self->{Filter} = $ParamObject->GetParam( Param => 'Filter' ) || '';
            $Self->{View}   = $ParamObject->GetParam( Param => 'View' )   || '';

            # show tickets
            my $LinkPage = 'Filter='
                . $LayoutObject->LinkEncode( $Self->{Filter} )
                . ';View=' . $LayoutObject->LinkEncode( $Self->{View} )
                . ';SortBy=' . $LayoutObject->LinkEncode( $Self->{SortBy} )
                . ';OrderBy=' . $LayoutObject->LinkEncode( $Self->{OrderBy} )
                . ';Profile='
                . $LayoutObject->LinkEncode( $Self->{Profile} )
                . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkSort = 'Filter='
                . $LayoutObject->LinkEncode( $Self->{Filter} )
                . ';View=' . $LayoutObject->LinkEncode( $Self->{View} )
                . ';Profile='
                . $LayoutObject->LinkEncode( $Self->{Profile} )
                . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            my $LinkFilter = 'TakeLastSearch=1;Subaction=Search;Profile='
                . $LayoutObject->LinkEncode( $Self->{Profile} )
                . ';';
            my $LinkBack = 'Subaction=LoadProfile;Profile='
                . $LayoutObject->LinkEncode( $Self->{Profile} )
                . ';TakeLastSearch=1&';

            my $FilterLink = 'SortBy=' . $LayoutObject->LinkEncode( $Self->{SortBy} )
                . ';OrderBy=' . $LayoutObject->LinkEncode( $Self->{OrderBy} )
                . ';View=' . $LayoutObject->LinkEncode( $Self->{View} )
                . ';Profile='
                . $LayoutObject->LinkEncode( $Self->{Profile} )
                . ';TakeLastSearch=1;Subaction=Search'
                . ';';
            $Output .= $LayoutObject->TicketListShow(
                TicketIDs => \@ViewableTicketIDs,
                Total     => scalar @ViewableTicketIDs,

                View => $Self->{View},

                Env        => $Self,
                LinkPage   => $LinkPage,
                LinkSort   => $LinkSort,
                LinkFilter => $LinkFilter,
                LinkBack   => $LinkBack,
                Profile    => $Self->{Profile},

                TitleName => 'Search Results',
                Bulk      => 1,
                Limit     => $Self->{SearchLimit},

                Filter     => $Self->{Filter},
                FilterLink => $FilterLink,

                OrderBy      => $Self->{OrderBy},
                SortBy       => $Self->{SortBy},
                RequestedURL => 'Action=' . $Self->{Action} . ';' . $LinkPage,

                # do not print the result earlier, but return complete content
                Output => 1,
            );

            # build footer
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
    }
    elsif ( $Self->{Subaction} eq 'AJAXProfileDelete' ) {
        my $Profile = $ParamObject->GetParam( Param => 'Profile' );

        # remove old profile stuff
        $SearchProfileObject->SearchProfileDelete(
            Base      => 'TicketSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );
        my $Output = $LayoutObject->JSONEncode(
            Data => 1,
        );
        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Content     => $Output,
            Type        => 'inline'
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXStopWordCheck' ) {

        my $StopWordCheckResult = {
            FoundStopWords => [],
        };

        if ( $Kernel::OM->Get('Kernel::System::Ticket')->SearchStringStopWordsUsageWarningActive() ) {
            my @ParamNames = $ParamObject->GetParamNames();
            my %SearchStrings;
            SEARCHSTRINGPARAMNAME:
            for my $SearchStringParamName ( sort @ParamNames ) {
                next SEARCHSTRINGPARAMNAME if $SearchStringParamName !~ m{\ASearchStrings\[(.*)\]\z}sm;
                $SearchStrings{$1} = $ParamObject->GetParam( Param => $SearchStringParamName );
            }

            $StopWordCheckResult->{FoundStopWords}
                = $Kernel::OM->Get('Kernel::System::Ticket')->SearchStringStopWordsFind(
                SearchStrings => \%SearchStrings,
                );
        }

        my $Output = $LayoutObject->JSONEncode(
            Data => $StopWordCheckResult,
        );
        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Content     => $Output,
            Type        => 'inline'
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAX' ) {
        my $Profile = $ParamObject->GetParam( Param => 'Profile' ) || '';
        my $EmptySearch = $ParamObject->GetParam( Param => 'EmptySearch' );
        if ( !$Profile ) {
            $EmptySearch = 1;
        }
        my %GetParam = $SearchProfileObject->SearchProfileGet(
            Base      => 'TicketSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );

        # convert attributes
        if ( IsArrayRefWithData( $GetParam{ShownAttributes} ) ) {
            my @ShowAttributes = grep {defined} @{ $GetParam{ShownAttributes} };
            $GetParam{ShownAttributes} = join ';', @ShowAttributes;
        }

        # if no profile is used, set default params of default attributes
        if ( !$Profile ) {
            if ( $Config->{Defaults} ) {
                KEY:
                for my $Key ( sort keys %{ $Config->{Defaults} } ) {
                    next KEY if !$Config->{Defaults}->{$Key};
                    next KEY if $Key eq 'DynamicField';

                    if ( $Key =~ /^(Ticket|Article)(Create|Change|Close|Escalation)/ ) {
                        my @Items = split /;/, $Config->{Defaults}->{$Key};
                        for my $Item (@Items) {
                            my ( $Key, $Value ) = split /=/, $Item;
                            $GetParam{$Key} = $Value;
                        }
                    }
                    else {
                        $GetParam{$Key} = $Config->{Defaults}->{$Key};
                    }
                }
            }
        }
        my @Attributes = (

            # Main fields
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

            # Article fields
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
        );

        if (
            $ConfigObject->Get('Ticket::StorageModule') eq
            'Kernel::System::Ticket::ArticleStorageDB'
            )
        {
            push @Attributes, (
                {
                    Key   => 'AttachmentName',
                    Value => 'Attachment Name',
                },
            );
        }

        # Ticket fields
        push @Attributes, (
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
                Key   => 'PriorityIDs',
                Value => 'Priority',
            },
            {
                Key   => 'LockIDs',
                Value => 'Lock',
            },
            {
                Key   => 'QueueIDs',
                Value => 'Queue',
            },
            {
                Key   => 'CreatedQueueIDs',
                Value => 'Created in Queue',
            },
        );

        if ( $ConfigObject->Get('Ticket::Type') ) {
            push @Attributes, (
                {
                    Key   => 'TypeIDs',
                    Value => 'Type',
                },
            );
        }

        if ( $ConfigObject->Get('Ticket::Service') ) {
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

        push @Attributes, (
            {
                Key   => 'OwnerIDs',
                Value => 'Owner',
            },
            {
                Key   => 'CreatedUserIDs',
                Value => 'Created by',
            },
        );
        if ( $ConfigObject->Get('Ticket::Watcher') ) {
            push @Attributes, (
                {
                    Key   => 'WatchUserIDs',
                    Value => 'Watcher',
                },
            );
        }
        if ( $ConfigObject->Get('Ticket::Responsible') ) {
            push @Attributes, (
                {
                    Key   => 'ResponsibleIDs',
                    Value => 'Responsible',
                },
            );
        }

        # Time fields
        push @Attributes, (
            {
                Key      => '',
                Value    => '-',
                Disabled => 1,
            },
            {
                Key   => 'TicketLastChangeTimePoint',
                Value => 'Ticket Last Change Time (before/after)',
            },
            {
                Key   => 'TicketLastChangeTimeSlot',
                Value => 'Ticket Last Change Time (between)',
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
                Key   => 'TicketCreateTimePoint',
                Value => 'Ticket Create Time (before/after)',
            },
            {
                Key   => 'TicketCreateTimeSlot',
                Value => 'Ticket Create Time (between)',
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

        if ( $ConfigObject->Get('Ticket::ArchiveSystem') ) {
            push @Attributes, (
                {
                    Key   => 'SearchInArchive',
                    Value => 'Archive Search',
                },
            );
        }

        # Dynamic fields
        my $DynamicFieldSeparator = 1;

        # create dynamic fields search options for attribute select
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
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
            my $SearchFieldPreferences = $BackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            # translate the dynamic field label
            my $TranslatedDynamicFieldLabel = $LayoutObject->{LanguageObject}->Translate(
                $DynamicFieldConfig->{Label},
            );

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # translate the suffix
                my $TranslatedSuffix = $LayoutObject->{LanguageObject}->Translate(
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

        # create HTML strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            my $IsACLReducible = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $BackendObject->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # get historical values from database
                    my $HistoricalValues = $BackendObject->HistoricalValuesGet(
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

                    # get ticket object
                    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        Action        => $Self->{Action},
                        ReturnType    => 'Ticket',
                        ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data          => \%AclData,
                        UserID        => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $TicketObject->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $Data->{$_} } keys %Filter;
                    }
                }
            }

            # get search field preferences
            my $SearchFieldPreferences = $BackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # get field html
                $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                    = $BackendObject->SearchFieldRender(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    Profile              => \%GetParam,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    DefaultValue =>
                        $Config->{Defaults}->{DynamicField}
                        ->{ $DynamicFieldConfig->{Name} },
                    LayoutObject => $LayoutObject,
                    Type         => $Preference->{Type},
                    );
            }
        }

        $Param{AttributesStrg} = $LayoutObject->BuildSelection(
            Data     => \@Attributes,
            Name     => 'Attribute',
            Multiple => 0,
            Class    => 'Modernize',
        );
        $Param{AttributesOrigStrg} = $LayoutObject->BuildSelection(
            Data     => \@Attributes,
            Name     => 'AttributeOrig',
            Multiple => 0,
            Class    => 'Modernize',
        );

        # get all users of own groups
        my %AllUsers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 0,
        );
        if ( !$ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            my %Involved = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserInvolvedGet(
                UserID => $Self->{UserID},
                Type   => 'ro',
            );
            for my $UserID ( sort keys %AllUsers ) {
                if ( !$Involved{$UserID} ) {
                    delete $AllUsers{$UserID};
                }
            }
        }

        my @ShownUsers;
        my %UsersInvalid;

        # get valid users of own groups
        my %ValidUsers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );

        USERID:
        for my $UserID ( sort { $AllUsers{$a} cmp $AllUsers{$b} } keys %AllUsers ) {

            if ( !$ValidUsers{$UserID} ) {
                $UsersInvalid{$UserID} = $AllUsers{$UserID};
                next USERID;
            }

            push @ShownUsers, {
                Key   => $UserID,
                Value => $AllUsers{$UserID},
            };
        }

        # also show invalid agents (if any)
        if ( scalar %UsersInvalid ) {
            push @ShownUsers, {
                Key      => '-',
                Value    => '_____________________',
                Disabled => 1,
            };
            push @ShownUsers, {
                Key      => '-',
                Value    => $LayoutObject->{LanguageObject}->Translate('Invalid Users'),
                Disabled => 1,
            };
            push @ShownUsers, {
                Key      => '-',
                Value    => '',
                Disabled => 1,
            };
            for my $UserID ( sort { $UsersInvalid{$a} cmp $UsersInvalid{$b} } keys %UsersInvalid ) {
                push @ShownUsers, {
                    Key   => $UserID,
                    Value => $UsersInvalid{$UserID},
                };
            }
        }

        $Param{UserStrg} = $LayoutObject->BuildSelection(
            Data       => \@ShownUsers,
            Name       => 'OwnerIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{OwnerIDs},
            Class      => 'Modernize',
        );
        $Param{CreatedUserStrg} = $LayoutObject->BuildSelection(
            Data       => \@ShownUsers,
            Name       => 'CreatedUserIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{CreatedUserIDs},
            Class      => 'Modernize',
        );
        if ( $ConfigObject->Get('Ticket::Watcher') ) {
            $Param{WatchUserStrg} = $LayoutObject->BuildSelection(
                Data       => \@ShownUsers,
                Name       => 'WatchUserIDs',
                Multiple   => 1,
                Size       => 5,
                SelectedID => $GetParam{WatchUserIDs},
                Class      => 'Modernize',
            );
        }
        if ( $ConfigObject->Get('Ticket::Responsible') ) {
            $Param{ResponsibleStrg} = $LayoutObject->BuildSelection(
                Data       => \@ShownUsers,
                Name       => 'ResponsibleIDs',
                Multiple   => 1,
                Size       => 5,
                SelectedID => $GetParam{ResponsibleIDs},
                Class      => 'Modernize',
            );
        }

        # build service string
        if ( $ConfigObject->Get('Ticket::Service') ) {

            my %Service = $Kernel::OM->Get('Kernel::System::Service')->ServiceList(
                UserID       => $Self->{UserID},
                KeepChildren => $ConfigObject->Get('Ticket::Service::KeepChildren'),
            );
            $Param{ServicesStrg} = $LayoutObject->BuildSelection(
                Data        => \%Service,
                Name        => 'ServiceIDs',
                SelectedID  => $GetParam{ServiceIDs},
                TreeView    => $TreeView,
                Sort        => 'TreeView',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
                Class       => 'Modernize',
            );
            my %SLA = $Kernel::OM->Get('Kernel::System::SLA')->SLAList(
                UserID => $Self->{UserID},
            );
            $Param{SLAsStrg} = $LayoutObject->BuildSelection(
                Data        => \%SLA,
                Name        => 'SLAIDs',
                SelectedID  => $GetParam{SLAIDs},
                Sort        => 'AlphanumericValue',
                Size        => 5,
                Multiple    => 1,
                Translation => 0,
                Max         => 200,
                Class       => 'Modernize',
            );
        }

        $Param{ResultFormStrg} = $LayoutObject->BuildSelection(
            Data => {
                Normal => 'Normal',
                Print  => 'Print',
                CSV    => 'CSV',
                Excel  => 'Excel',
            },
            Name       => 'ResultForm',
            SelectedID => $GetParam{ResultForm} || 'Normal',
            Class      => 'Modernize',
        );

        if ( $ConfigObject->Get('Ticket::ArchiveSystem') ) {

            $Param{SearchInArchiveStrg} = $LayoutObject->BuildSelection(
                Data => {
                    ArchivedTickets    => 'Archived tickets',
                    NotArchivedTickets => 'Unarchived tickets',
                    AllTickets         => 'All tickets',
                },
                Name       => 'SearchInArchive',
                SelectedID => $GetParam{SearchInArchive} || 'NotArchivedTickets',
                Class      => 'Modernize',
            );
        }

        my %Profiles = $SearchProfileObject->SearchProfileList(
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
        $Param{ProfilesStrg} = $LayoutObject->BuildSelection(
            Data       => \%Profiles,
            Name       => 'Profile',
            ID         => 'SearchProfile',
            SelectedID => $Profile,
            Class      => 'Modernize',
        );

        $Param{StatesStrg} = $LayoutObject->BuildSelection(
            Data => {
                $Kernel::OM->Get('Kernel::System::State')->StateList(
                    UserID => $Self->{UserID},
                    Action => $Self->{Action},
                ),
            },
            Name       => 'StateIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{StateIDs},
            Class      => 'Modernize',
        );
        my %AllQueues = $Kernel::OM->Get('Kernel::System::Queue')->GetAllQueues(
            UserID => $Self->{UserID},
            Type   => 'ro',
        );
        $Param{QueuesStrg} = $LayoutObject->AgentQueueListOption(
            Data               => \%AllQueues,
            Size               => 5,
            Multiple           => 1,
            Name               => 'QueueIDs',
            TreeView           => $TreeView,
            SelectedIDRefArray => $GetParam{QueueIDs},
            OnChangeSubmit     => 0,
            Class              => 'Modernize',
        );
        $Param{CreatedQueuesStrg} = $LayoutObject->AgentQueueListOption(
            Data               => \%AllQueues,
            Size               => 5,
            Multiple           => 1,
            Name               => 'CreatedQueueIDs',
            TreeView           => $TreeView,
            SelectedIDRefArray => $GetParam{CreatedQueueIDs},
            OnChangeSubmit     => 0,
            Class              => 'Modernize',
        );
        $Param{PrioritiesStrg} = $LayoutObject->BuildSelection(
            Data => {
                $Kernel::OM->Get('Kernel::System::Priority')->PriorityList(
                    UserID => $Self->{UserID},
                    Action => $Self->{Action},
                ),
            },
            Name       => 'PriorityIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{PriorityIDs},
            Class      => 'Modernize',
        );
        $Param{LocksStrg} = $LayoutObject->BuildSelection(
            Data => {
                $Kernel::OM->Get('Kernel::System::Lock')->LockList(
                    UserID => $Self->{UserID},
                    Action => $Self->{Action},
                ),
            },
            Name       => 'LockIDs',
            Multiple   => 1,
            Size       => 5,
            SelectedID => $GetParam{LockIDs},
            Class      => 'Modernize',
        );

        $Param{ArticleCreateTimePoint} = $LayoutObject->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'ArticleCreateTimePoint',
            SelectedID => $GetParam{ArticleCreateTimePoint},
        );
        $Param{ArticleCreateTimePointStart} = $LayoutObject->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name       => 'ArticleCreateTimePointStart',
            SelectedID => $GetParam{ArticleCreateTimePointStart} || 'Last',
        );
        $Param{ArticleCreateTimePointFormat} = $LayoutObject->BuildSelection(
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
        $Param{ArticleCreateTimeStart} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix   => 'ArticleCreateTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{ArticleCreateTimeStop} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix => 'ArticleCreateTimeStop',
            Format => 'DateInputFormat',
        );
        $Param{TicketCreateTimePoint} = $LayoutObject->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketCreateTimePoint',
            SelectedID => $GetParam{TicketCreateTimePoint},
        );
        $Param{TicketCreateTimePointStart} = $LayoutObject->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name       => 'TicketCreateTimePointStart',
            SelectedID => $GetParam{TicketCreateTimePointStart} || 'Last',
        );
        $Param{TicketCreateTimePointFormat} = $LayoutObject->BuildSelection(
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
        $Param{TicketCreateTimeStart} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketCreateTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketCreateTimeStop} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketCreateTimeStop',
            Format => 'DateInputFormat',
        );

        $Param{TicketChangeTimePoint} = $LayoutObject->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketChangeTimePoint',
            SelectedID => $GetParam{TicketChangeTimePoint},
        );
        $Param{TicketChangeTimePointStart} = $LayoutObject->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name       => 'TicketChangeTimePointStart',
            SelectedID => $GetParam{TicketChangeTimePointStart} || 'Last',
        );
        $Param{TicketChangeTimePointFormat} = $LayoutObject->BuildSelection(
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
        $Param{TicketChangeTimeStart} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketChangeTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketChangeTimeStop} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketChangeTimeStop',
            Format => 'DateInputFormat',
        );

        $Param{TicketCloseTimePoint} = $LayoutObject->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketCloseTimePoint',
            SelectedID => $GetParam{TicketCloseTimePoint},
        );
        $Param{TicketCloseTimePointStart} = $LayoutObject->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name       => 'TicketCloseTimePointStart',
            SelectedID => $GetParam{TicketCloseTimePointStart} || 'Last',
        );
        $Param{TicketCloseTimePointFormat} = $LayoutObject->BuildSelection(
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
        $Param{TicketCloseTimeStart} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketCloseTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketCloseTimeStop} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketCloseTimeStop',
            Format => 'DateInputFormat',
        );

        $Param{TicketLastChangeTimePoint} = $LayoutObject->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketLastChangeTimePoint',
            SelectedID => $GetParam{TicketLastChangeTimePoint},
        );
        $Param{TicketLastChangeTimePointStart} = $LayoutObject->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Before' => 'more than ... ago',
            },
            Name       => 'TicketLastChangeTimePointStart',
            SelectedID => $GetParam{TicketLastChangeTimePointStart} || 'Last',
        );
        $Param{TicketLastChangeTimePointFormat} = $LayoutObject->BuildSelection(
            Data => {
                minute => 'minute(s)',
                hour   => 'hour(s)',
                day    => 'day(s)',
                week   => 'week(s)',
                month  => 'month(s)',
                year   => 'year(s)',
            },
            Name       => 'TicketLastChangeTimePointFormat',
            SelectedID => $GetParam{TicketLastChangeTimePointFormat},
        );
        $Param{TicketLastChangeTimeStart} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketLastChangeTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketLastChangeTimeStop} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketLastChangeTimeStop',
            Format => 'DateInputFormat',
        );

        $Param{TicketEscalationTimePoint} = $LayoutObject->BuildSelection(
            Data       => [ 1 .. 59 ],
            Name       => 'TicketEscalationTimePoint',
            SelectedID => $GetParam{TicketEscalationTimePoint},
        );
        $Param{TicketEscalationTimePointStart} = $LayoutObject->BuildSelection(
            Data => {
                'Last'   => 'within the last ...',
                'Next'   => 'within the next ...',
                'Before' => 'more than ... ago',
            },
            Name       => 'TicketEscalationTimePointStart',
            SelectedID => $GetParam{TicketEscalationTimePointStart} || 'Last',
        );
        $Param{TicketEscalationTimePointFormat} = $LayoutObject->BuildSelection(
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
        $Param{TicketEscalationTimeStart} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix   => 'TicketEscalationTimeStart',
            Format   => 'DateInputFormat',
            DiffTime => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{TicketEscalationTimeStop} = $LayoutObject->BuildDateSelection(
            %GetParam,
            Prefix => 'TicketEscalationTimeStop',
            Format => 'DateInputFormat',
        );

        my %GetParamBackup = %GetParam;
        for my $Key (
            qw(TicketEscalation TicketClose TicketChange TicketLastChange TicketCreate ArticleCreate)
            )
        {
            for my $SubKey (qw(TimeStart TimeStop TimePoint TimePointStart TimePointFormat)) {
                delete $GetParam{ $Key . $SubKey };
                delete $GetParamBackup{ $Key . $SubKey };
            }
        }

        # build type string
        if ( $ConfigObject->Get('Ticket::Type') ) {
            my %Type = $Kernel::OM->Get('Kernel::System::Type')->TypeList(
                UserID => $Self->{UserID},
            );
            $Param{TypesStrg} = $LayoutObject->BuildSelection(
                Data        => \%Type,
                Name        => 'TypeIDs',
                SelectedID  => $GetParam{TypeIDs},
                Sort        => 'AlphanumericValue',
                Size        => 3,
                Multiple    => 1,
                Translation => 0,
                Class       => 'Modernize',
            );
        }

        # html search mask output
        $LayoutObject->Block(
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
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $BackendObject->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                # skip fields that HTML could not be retrieved
                next PREFERENCE if !IsHashRefWithData(
                    $DynamicFieldHTML{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
                );

                $LayoutObject->Block(
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
            LastChangeTimeSearchType => 'TicketLastChange',
            EscalationTimeSearchType => 'TicketEscalation',
            ArticleTimeSearchType    => 'ArticleCreate',
        );
        KEY:
        for my $Key ( sort keys %Map ) {
            next KEY if !defined $GetParamBackup{$Key};
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

        if ($Profile) {
            ITEM:
            for my $Item (@Attributes) {
                my $Key = $Item->{Key};
                next ITEM if !$Key;

                # check if shown
                if (@ShownAttributes) {
                    my $Show = 0;
                    SHOWN_ATTRIBUTE:
                    for my $ShownAttribute (@ShownAttributes) {
                        if ( 'Label' . $Key eq $ShownAttribute ) {
                            $Show = 1;
                            last SHOWN_ATTRIBUTE;
                        }
                    }
                    next ITEM if !$Show;
                }
                else {
                    # Skip undefined
                    next ITEM if !defined $GetParamBackup{$Key};

                    # Skip empty strings
                    next ITEM if $GetParamBackup{$Key} eq '';

                    # Skip empty arrays
                    if ( ref $GetParamBackup{$Key} eq 'ARRAY' && !@{ $GetParamBackup{$Key} } ) {
                        next ITEM;
                    }
                }

                # show attribute
                next ITEM if $AlreadyShown{$Key};
                $AlreadyShown{$Key} = 1;
                $LayoutObject->Block(
                    Name => 'SearchAJAXShow',
                    Data => {
                        Attribute => $Key,
                    },
                );
            }
        }

        # No profile, show default screen
        else {

            # Merge regular show/hide settings and the settings for the dynamic fields
            my %Defaults = %{ $Config->{Defaults} || {} };
            for my $DynamicFields ( sort keys %{ $Config->{DynamicField} || {} } ) {
                if ( $Config->{DynamicField}->{$DynamicFields} == 2 ) {
                    $Defaults{"Search_DynamicField_$DynamicFields"} = 1;
                }
            }

            my @OrderedDefaults;
            if (%Defaults) {

                # ordering atributes on the same order like in Atributes
                for my $Item (@Attributes) {
                    my $KeyAtr = $Item->{Key};
                    for my $Key ( sort keys %Defaults ) {
                        if ( $Key eq $KeyAtr ) {
                            push @OrderedDefaults, $Key;
                        }
                    }
                }

                KEY:
                for my $Key (@OrderedDefaults) {
                    next KEY if $Key eq 'DynamicField';    # Ignore entry for DF config
                    next KEY if $AlreadyShown{$Key};
                    $AlreadyShown{$Key} = 1;

                    $LayoutObject->Block(
                        Name => 'SearchAJAXShow',
                        Data => {
                            Attribute => $Key,
                        },
                    );
                }
            }

            # If no attribute is shown, show fulltext search.
            if ( !keys %AlreadyShown ) {
                $LayoutObject->Block(
                    Name => 'SearchAJAXShow',
                    Data => {
                        Attribute => 'Fulltext',
                    },
                );
            }
        }

        my $Output .= $LayoutObject->Output(
            TemplateFile => 'AgentTicketSearch',
            Data         => \%Param,
        );
        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # show default search screen
    $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $LayoutObject->Block(
        Name => 'Search',
        Data => \%Param,
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AgentTicketSearch',
        Data         => \%Param,
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

1;
