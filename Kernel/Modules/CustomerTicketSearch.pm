# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketSearch;

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
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = $Config->{DynamicField};

    # get dynamic field object
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

    # get the dynamic fields for ticket object
    my $DynamicField = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

    my $Profile = $ParamObject->GetParam( Param => 'Profile' ) || '';

    # check request
    if ( $ParamObject->GetParam( Param => 'SearchTemplate' ) && $Profile ) {
        return $LayoutObject->Redirect(
            OP =>
                "Action=CustomerTicketSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Profile",
        );
    }

    # remember exclude attributes
    my @Excludes = $ParamObject->GetArray( Param => 'Exclude' );

    # get single params
    my %GetParam;

    # get config data
    my $StartHit = int( $ParamObject->GetParam( Param => 'StartHit' ) || 1 );
    my $SearchLimit = $ConfigObject->Get('Ticket::CustomerTicketSearch::SearchLimit')
        || 200;
    my $SearchPageShown = $ConfigObject->Get('Ticket::CustomerTicketSearch::SearchPageShown') || 40;
    my $SortBy = $ParamObject->GetParam( Param => 'SortBy' )
        || $ConfigObject->Get('Ticket::CustomerTicketSearch::SortBy::Default')
        || 'Age';
    my $CurrentOrder = $ParamObject->GetParam( Param => 'Order' )
        || $ConfigObject->Get('Ticket::CustomerTicketSearch::Order::Default')
        || 'Down';

    # get search profile object
    my $SearchProfileObject = $Kernel::OM->Get('Kernel::System::SearchProfile');
    my $TakeLastSearch = $ParamObject->GetParam( Param => 'TakeLastSearch' ) || '';

    # load profiles string params (press load profile)
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Profile ) || $TakeLastSearch ) {
        %GetParam = $SearchProfileObject->SearchProfileGet(
            Base      => 'CustomerTicketSearch',
            Name      => $Profile,
            UserLogin => $Self->{UserLogin},
        );
    }

    # get search string params (get submitted params)
    else {
        for my $Key (
            qw(TicketNumber From To Cc Subject Body CustomerID ResultForm TimeSearchType StateType
            SearchInArchive AttachmentName
            TicketCreateTimePointFormat TicketCreateTimePoint
            TicketCreateTimePointStart
            TicketCreateTimeStart TicketCreateTimeStartDay TicketCreateTimeStartMonth
            TicketCreateTimeStartYear
            TicketCreateTimeStop TicketCreateTimeStopDay TicketCreateTimeStopMonth
            TicketCreateTimeStopYear
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
            qw(StateIDs StateTypeIDs PriorityIDs OwnerIDs ResponsibleIDs ServiceIDs TypeIDs)
            )
        {

            # get search array params (get submitted params)
            my @Array = $ParamObject->GetArray( Param => $Key );
            if (@Array) {
                $GetParam{$Key} = \@Array;
            }
        }

        # get Dynamic fields form param object
        # cycle through the activated Dynamic Fields for this screen
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

                # set the complete value structure in GetParam to store it later in the search
                # profile
                if ( IsHashRefWithData($DynamicFieldValue) ) {
                    %GetParam = ( %GetParam, %{$DynamicFieldValue} );
                }
            }
        }
    }

    # check if item need to get excluded
    for my $Exclude (@Excludes) {
        if ( $GetParam{$Exclude} ) {
            delete $GetParam{$Exclude};
        }
    }

    # get time option
    if ( !$GetParam{TimeSearchType} ) {
        $GetParam{'TimeSearchType::None'} = 'checked="checked"';
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
        $GetParam{'TimeSearchType::TimePoint'} = 'checked="checked"';
    }
    elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
        $GetParam{'TimeSearchType::TimeSlot'} = 'checked="checked"';
    }

    # set result form env
    if ( !$GetParam{ResultForm} ) {
        $GetParam{ResultForm} = '';
    }
    if ( $GetParam{ResultForm} eq 'Print' ) {
        $SearchPageShown = $SearchLimit;
    }

    # check request
    if ( $Self->{Subaction} eq 'OpenSearchDescription' ) {
        my $Output = $LayoutObject->Output(
            TemplateFile => 'CustomerTicketSearchOpenSearchDescription',
            Data         => {%Param},
        );
        return $LayoutObject->Attachment(
            Filename    => 'OpenSearchDescription.xml',
            ContentType => 'text/xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get profil search and template data
    my $SaveProfile    = $ParamObject->GetParam( Param => 'SaveProfile' )    || '';
    my $SelectTemplate = $ParamObject->GetParam( Param => 'SelectTemplate' ) || '';
    my $EraseTemplate  = $ParamObject->GetParam( Param => 'EraseTemplate' )  || '';

    # check for server errors
    my %ServerErrors;
    if (
        $Self->{Subaction} eq 'Search'
        && !$Self->{EraseTemplate}
        )
    {

        # check for stop word errors
        my %StopWordsServerErrors = $Self->_StopWordsServerErrorsGet(
            From    => $GetParam{From},
            To      => $GetParam{To},
            Cc      => $GetParam{Cc},
            Subject => $GetParam{Subject},
            Body    => $GetParam{Body},
        );

        %ServerErrors = ( %ServerErrors, %StopWordsServerErrors );
    }

    # show result page
    if ( !%ServerErrors && $Self->{Subaction} eq 'Search' && !$EraseTemplate ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Profile || !$SaveProfile ) {
            $Profile = 'last-search';
        }

        # store search URL in LastScreenOverview to make sure the
        # customer can use the "back" link as expected
        my $URL = "Action=CustomerTicketSearch;Subaction=Search;Profile=$Profile;"
            . "SortBy=$SortBy;Order=$CurrentOrder;TakeLastSearch=1;"
            . "StartHit=$StartHit";
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $URL,
        );

        # save search profile (under last-search or real profile name)
        $SaveProfile = 1;

        # remember last search values
        if ( $SaveProfile && $Profile ) {

            # remove old profile stuff
            $SearchProfileObject->SearchProfileDelete(
                Base      => 'CustomerTicketSearch',
                Name      => $Profile,
                UserLogin => $Self->{UserLogin},
            );

            # insert new profile params
            for my $Key ( sort keys %GetParam ) {
                if ( $GetParam{$Key} ) {
                    $SearchProfileObject->SearchProfileAdd(
                        Base      => 'CustomerTicketSearch',
                        Name      => $Profile,
                        Key       => $Key,
                        Value     => $GetParam{$Key},
                        UserLogin => $Self->{UserLogin},
                    );
                }
            }
        }

        my %TimeMap = (
            TicketCreate => 'Time',
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

        # prepare archive flag
        if (
            $ConfigObject->Get('Ticket::ArchiveSystem')
            && $ConfigObject->Get('Ticket::CustomerArchiveSystem')
            && $ConfigObject->Get('Ticket::CustomerArchiveSystem') eq 1
            )
        {

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
        elsif (
            $ConfigObject->Get('Ticket::ArchiveSystem')
            && $ConfigObject->Get('Ticket::CustomerArchiveSystem')
            && $ConfigObject->Get('Ticket::CustomerArchiveSystem') eq 2
            )
        {
            $GetParam{ArchiveFlags} = ['n'];
        }
        else {
            $GetParam{ArchiveFlags} = [ 'y', 'n' ];
        }

        # dynamic fields search parameters for ticket search
        my %DynamicFieldSearchParameters;
        my %DynamicFieldSearchDisplay;

        # cycle through the activated Dynamic Fields for this screen
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

                my $DynamicFieldValue = $BackendObject->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $ParamObject,
                    Type                   => $Preference->{Type},
                    ReturnProfileStructure => 1,
                );

                # set the complete value structure in %DynamicFieldValues to discard those where the
                # value will not be possible to get
                next PREFERENCE if !IsHashRefWithData($DynamicFieldValue);

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

                    # set value to display
                    $DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Display};
                }
            }
        }

        # disable output of customer company tickets
        my $DisableCompanyTickets = $ConfigObject->Get('Ticket::Frontend::CustomerDisableCompanyTicketAccess');

        if ($DisableCompanyTickets) {
            $GetParam{CustomerUserLogin} = $Self->{UserID};
        }

        # perform ticket search
        my @ViewableTicketIDs = $TicketObject->TicketSearch(
            Result              => 'ARRAY',
            SortBy              => $SortBy,
            OrderBy             => $CurrentOrder,
            Limit               => $SearchLimit,
            CustomerUserID      => $Self->{UserID},
            ConditionInline     => $Config->{ExtendedSearchCondition},
            ContentSearchPrefix => '*',
            ContentSearchSuffix => '*',
            FullTextIndex       => 1,
            %GetParam,
            %DynamicFieldSearchParameters,
        );

        # get needed objects
        my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
        my $TimeObject         = $Kernel::OM->Get('Kernel::System::Time');

        # CSV and Excel output
        if (
            $GetParam{ResultForm} eq 'CSV'
            || $GetParam{ResultForm} eq 'Excel'
            )
        {

            # create head (actual head and head for data fill)
            my @TmpCSVHead = @{ $Config->{SearchCSVData} };
            my @CSVHead    = @{ $Config->{SearchCSVData} };

            # get the ticket dynamic fields for CSV display
            my $CSVDynamicField = $DynamicFieldObject->DynamicFieldListGet(
                Valid       => 1,
                ObjectType  => ['Ticket'],
                FieldFilter => $Config->{SearchCSVDynamicField} || {},
            );

            # reduce the dynamic fields to only the ones that are desinged for customer interface
            my @CSVCustomerDynamicFields;
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$CSVDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsCustomerInterfaceCapable',
                );
                next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

                push @CSVCustomerDynamicFields, $DynamicFieldConfig;
            }
            $CSVDynamicField = \@CSVCustomerDynamicFields;

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

                # if no article found, use ticket information
                if ( !%Data ) {
                    my %Ticket = $TicketObject->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                        UserID        => $Self->{UserID},
                    );
                    %Data = %Ticket;
                    $Data{Subject} = $Ticket{Title} || 'Untitled';
                    $Data{Body} = $LayoutObject->{LanguageObject}->Translate(
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
                if ( $Config->{SearchArticleCSVTree} && $GetParam{ResultForm} eq 'CSV' ) {
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

                            # skip all fields that do not match the current field name ($1)
                            # with out the 'DynamicField_' prefix
                            next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                            # get the value for print
                            my $ValueStrg = $BackendObject->DisplayValueRender(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                Value              => $Info{$Header},
                                HTMLOutput         => 0,
                                LayoutObject       => $LayoutObject,
                            );
                            push @Data, $ValueStrg->{Value};

                            # terminate the loop
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

            # return csv to download
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

            if ( $GetParam{ResultForm} eq 'CSV' ) {

                my $CSV = $CSVObject->Array2CSV(
                    Head => \@CSVHeadTranslated,
                    Data => \@CSVData,
                );
                return $LayoutObject->Attachment(
                    Filename    => $FileName . "_" . "$Y-$M-$D" . "_" . "$h-$m.csv",
                    ContentType => "text/csv; charset=" . $LayoutObject->{UserCharset},
                    Content     => $CSV,
                );

            }

            # return Excel to download
            elsif ( $GetParam{ResultForm} eq 'Excel' ) {
                my $Excel = $CSVObject->Array2CSV(
                    Head   => \@CSVHeadTranslated,
                    Data   => \@CSVData,
                    Format => "Excel",
                );

                return $LayoutObject->Attachment(
                    Filename => $FileName . "_" . "$Y-$M-$D" . "_" . "$h-$m.xlsx",
                    ContentType =>
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    Content => $Excel,
                );
            }
        }

        elsif ( $GetParam{ResultForm} eq 'Print' ) {

            # get PDF object
            my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

            my @PDFData;
            for my $TicketID (@ViewableTicketIDs) {

                # get first article data
                my %Data = $TicketObject->ArticleLastCustomerArticle(
                    TicketID      => $TicketID,
                    Extended      => 1,
                    DynamicFields => 0,
                );

                if ( !%Data ) {

                    # get ticket data instead
                    %Data = $TicketObject->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 1,
                        UserID        => $Self->{UserID},
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

                my $Customer = "$Data{CustomerID} $Data{CustomerName}";

                my @PDFRow;
                push @PDFRow,  $Data{TicketNumber};
                push @PDFRow,  $Created;
                push @PDFRow,  $Data{From};
                push @PDFRow,  $Data{Subject};
                push @PDFRow,  $Data{State};
                push @PDFRow,  $Data{Queue};
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
                $CellData->[0]->[6]->{Content} = $LayoutObject->{LanguageObject}->Translate('CustomerID');
                $CellData->[0]->[6]->{Font}    = 'ProportionalBold';

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

        my $Counter = 0;

        # get the ticket dynamic fields for overview display
        my $OverviewDynamicField = $DynamicFieldObject->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Ticket'],
            FieldFilter => $Config->{SearchOverviewDynamicField} || {},
        );

        # reduce the dynamic fields to only the ones that are desinged for customer interface
        my @OverviewCustomerDynamicFields;
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$OverviewDynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsCustomerInterfaceCapable',
            );
            next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

            push @OverviewCustomerDynamicFields, $DynamicFieldConfig;
        }
        $OverviewDynamicField = \@OverviewCustomerDynamicFields;

        # if there are results to show
        if (@ViewableTicketIDs) {

            # Dynamic fields table headers
            # cycle through the activated Dynamic Fields for this screen
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{$OverviewDynamicField} ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $Label = $DynamicFieldConfig->{Label};

                # get field sortable condition
                my $IsSortable = $BackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsSortable',
                );

                if ($IsSortable) {
                    my $CSS   = '';
                    my $Order = 'Down';
                    if (
                        $SortBy
                        && (
                            $SortBy eq
                            ( 'DynamicField_' . $DynamicFieldConfig->{Name} )
                        )
                        )
                    {
                        if ( $CurrentOrder && ( $CurrentOrder eq 'Up' ) ) {
                            $Order = 'Down';
                            $CSS .= ' SortAscending';
                        }
                        else {
                            $Order = 'Up';
                            $CSS .= ' SortDescending';
                        }
                    }

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicField',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicFieldSortable',
                        Data => {
                            %Param,
                            Order            => $Order,
                            Label            => $Label,
                            DynamicFieldName => $DynamicFieldConfig->{Name},
                        },
                    );
                }
                else {

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicField',
                        Data => {
                            %Param,
                        },
                    );

                    $LayoutObject->Block(
                        Name => 'HeaderDynamicFieldNotSortable',
                        Data => {
                            %Param,
                            Label => $Label,
                        },
                    );
                }
            }

            for my $TicketID (@ViewableTicketIDs) {
                $Counter++;

                # build search result
                if (
                    $Counter >= $StartHit
                    && $Counter < ( $SearchPageShown + $StartHit )
                    )
                {

                    # get first article data
                    my %Article = $TicketObject->ArticleLastCustomerArticle(
                        TicketID      => $TicketID,
                        Extended      => 1,
                        DynamicFields => 1,
                    );

                    my %Ticket = $TicketObject->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                        UserID        => $Self->{UserID},
                    );

                    # if no article found, use ticket information
                    if ( !%Article ) {
                        %Article = %Ticket;
                        $Article{Subject} = $Ticket{Title} || 'Untitled';
                        $Article{Body} = $LayoutObject->{LanguageObject}->Translate(
                            'This item has no articles yet.'
                        );
                    }

                    # customer info
                    my %CustomerData;
                    if ( $Article{CustomerUserID} ) {
                        %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                            User => $Article{CustomerUserID},
                        );
                    }
                    elsif ( $Article{CustomerID} ) {
                        %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                            User => $Article{CustomerID},
                        );
                    }

                    # customer info (customer name)
                    if ( $CustomerData{UserLogin} ) {
                        $Article{CustomerName} = $CustomerUserObject->CustomerName(
                            UserLogin => $CustomerData{UserLogin},
                        );
                    }

                    # user info
                    my %Owner = $UserObject->GetUserData(
                        User => $Article{Owner},
                    );

                    # Condense down the subject
                    my $Subject = $TicketObject->TicketSubjectClean(
                        TicketNumber => $Article{TicketNumber},
                        Subject      => $Article{Subject} || '',
                    );
                    $Article{CustomerAge} = $LayoutObject->CustomerAge(
                        Age   => $Article{Age},
                        Space => ' '
                    );

                    # customer info string
                    if ( $Article{CustomerName} ) {
                        $Article{CustomerName} = '(' . $Article{CustomerName} . ')';
                    }

                    # add blocks to template
                    $LayoutObject->Block(
                        Name => 'Record',
                        Data => {
                            %Article,
                            %Ticket,
                            Subject => $Subject,
                            %Owner,
                        },
                    );

                    # Dynamic fields
                    # cycle through the activated Dynamic Fields for this screen
                    DYNAMICFIELD:
                    for my $DynamicFieldConfig ( @{$OverviewDynamicField} ) {
                        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                        # get field value
                        my $ValueStrg = $BackendObject->DisplayValueRender(
                            DynamicFieldConfig => $DynamicFieldConfig,
                            Value              => $Article{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                            ValueMaxChars      => 20,
                            LayoutObject       => $LayoutObject,
                        );

                        $LayoutObject->Block(
                            Name => 'RecordDynamicField',
                            Data => {
                                Value => $ValueStrg->{Value},
                                Title => $ValueStrg->{Title},
                            },
                        );
                    }
                }
            }
        }

        # otherwise show a no data found msg
        else {
            $LayoutObject->Block( Name => 'NoDataFoundMsg' );
        }

        # show attributes used for search
        my %IDMap = (
            StateIDs => {
                Name        => 'State',
                Object      => 'State',
                Method      => 'StateLookup',
                Key         => 'StateID',
                Translation => 1,
            },
            StateTypeIDs => {
                Name        => 'StateType',
                Object      => 'State',
                Method      => 'StateTypeLookup',
                Key         => 'StateTypeID',
                Translation => 1,
            },
            PriorityIDs => {
                Name        => 'Priority',
                Object      => 'Priority',
                Method      => 'PriorityLookup',
                Key         => 'PriorityID',
                Translation => 1,
            },
            QueueIDs => {
                Name        => 'Queue',
                Object      => 'Queue',
                Method      => 'QueueLookup',
                Key         => 'QueueID',
                Translation => 0,
            },
            OwnerIDs => {
                Name        => 'Owner',
                Object      => 'User',
                Method      => 'UserLookup',
                Key         => 'UserID',
                Translation => 0,
            },
            ResponsibleIDs => {
                Name        => 'Responsible',
                Object      => 'User',
                Method      => 'UserLookup',
                Key         => 'UserID',
                Translation => 0,
            },

            ResponsibleIDs => {
                Name        => 'Responsible',
                Object      => 'User',
                Method      => 'UserLookup',
                Key         => 'UserID',
                Translation => 0,
            },
        );

        KEY:
        for my $Key (
            qw(TicketNumber From To Cc Subject Body CustomerID TimeSearchType StateType
            StateIDs StateTypeIDs PriorityIDs OwnerIDs ResponsibleIDs
            )
            )
        {
            next KEY if !$GetParam{$Key};
            my $Attribute = $IDMap{$Key}->{Name}   || $Key;
            my $Object    = $IDMap{$Key}->{Object} || '';
            my $Method    = $IDMap{$Key}->{Method};
            my $MethodKey = $IDMap{$Key}->{Key};
            my $Translation = $IDMap{$Key}->{Translation};
            my $Value;

            # get appropriate object
            my $LookupObject;
            if ( $IDMap{$Key}->{Name} ) {
                $LookupObject = $Kernel::OM->Get( 'Kernel::System::' . $Object );
            }

            if ( ref $GetParam{$Key} eq 'ARRAY' ) {
                for my $ItemRaw ( @{ $GetParam{$Key} } ) {
                    my $Item = $ItemRaw;
                    if ($Value) {
                        $Value .= '+';
                    }
                    if ($LookupObject) {
                        $Item = $LookupObject->$Method( $MethodKey => $Item );
                        if ($Translation) {
                            $Item = $LayoutObject->{LanguageObject}->Translate($Item);
                        }
                    }
                    $Value .= $Item;
                }
            }
            else {
                my $Item = $GetParam{$Key};
                if ($LookupObject) {
                    $Item = $LookupObject->$Method( $MethodKey => $Item );
                    if ($Translation) {
                        $Item = $LayoutObject->{LanguageObject}->Translate($Item);
                    }
                }
                $Value = $Item;
            }

            if ( $Key eq 'TimeSearchType' ) {

                if ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {

                    my $StartDate = $LayoutObject->{LanguageObject}->FormatTimeString(
                        $GetParam{TicketCreateTimeStartYear}
                            . '-' . $GetParam{TicketCreateTimeStartMonth}
                            . '-' . $GetParam{TicketCreateTimeStartDay}
                            . ' 00:00:00', 'DateFormatShort'
                    );

                    my $StopDate = $LayoutObject->{LanguageObject}->FormatTimeString(
                        $GetParam{TicketCreateTimeStopYear}
                            . '-' . $GetParam{TicketCreateTimeStopMonth}
                            . '-' . $GetParam{TicketCreateTimeStopDay}
                            . ' 00:00:00', 'DateFormatShort'
                    );

                    $Attribute = 'Created between';
                    $Value     = $StartDate . ' '
                        . $LayoutObject->{LanguageObject}->Translate('and') . ' '
                        . $StopDate;
                }
                else {

                    my $Mapping = {
                        'Last'   => 'Created within the last',
                        'Before' => 'Created more than ... ago',
                    };

                    $Attribute = $Mapping->{ $GetParam{TicketCreateTimePointStart} };
                    $Value     = $GetParam{TicketCreateTimePoint} . ' '
                        . $LayoutObject->{LanguageObject}->Get( $GetParam{TicketCreateTimePointFormat} . '(s)' );
                }
            }

            $LayoutObject->Block(
                Name => 'SearchTerms',
                Data => {
                    %Param,
                    Attribute => $Attribute,
                    Key       => $Key,
                    Value     => $Value,
                },
            );
        }

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD
                if !$DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

            $LayoutObject->Block(
                Name => 'SearchTerms',
                Data => {
                    Attribute => $DynamicFieldConfig->{Label},
                    Value =>
                        $DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                },
            );
        }

        my $Link = 'Profile=' . $LayoutObject->LinkEncode($Profile) . ';';
        $Link .= 'SortBy=' . $LayoutObject->LinkEncode($SortBy) . ';';
        $Link .= 'Order=' . $LayoutObject->LinkEncode($CurrentOrder) . ';';
        $Link .= 'TakeLastSearch=1;';

        # build search navigation bar
        my %PageNav = $LayoutObject->PageNavBar(
            Limit     => $SearchLimit,
            StartHit  => $StartHit,
            PageShown => $SearchPageShown,
            AllHits   => $Counter,
            Action    => "Action=CustomerTicketSearch;Subaction=Search",
            Link      => $Link,
            IDPrefix  => "CustomerTicketSearch",
        );

        # show footer filter - show only if more the one page is available
        if ( $PageNav{TotalHits} && ( $PageNav{TotalHits} > $SearchPageShown ) ) {
            $LayoutObject->Block(
                Name => 'Pagination',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
        }

        my $Order = 'Down';
        if ( $CurrentOrder eq 'Down' ) {
            $Order = 'Up';
        }
        my $Sort       = '';
        my $StateSort  = '';
        my $TicketSort = '';
        my $AgeSort    = '';

        # define sort order
        if ( $Order eq 'Down' ) {
            $Sort = 'SortAscending';
        }
        if ( $Order eq 'Up' ) {
            $Sort = 'SortDescending';
        }

        if ( $SortBy eq 'State' ) {
            $StateSort = $Sort;
        }
        if ( $SortBy eq 'Ticket' ) {
            $TicketSort = $Sort;
        }
        if ( $SortBy eq 'Age' ) {
            $AgeSort = $Sort;
        }

        # start html page
        my $Output = $LayoutObject->CustomerHeader();
        $Output .= $LayoutObject->CustomerNavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'CustomerTicketSearchResultShort',
            Data         => {
                %Param,
                %PageNav,
                Order      => $Order,
                StateSort  => $StateSort,
                TicketSort => $TicketSort,
                AgeSort    => $AgeSort,
                Profile    => $Profile,
            },
        );

        # build footer
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }

    # empty search site
    else {

        # delete profile
        if ( $EraseTemplate && $Profile ) {

            # remove old profile stuff
            $SearchProfileObject->SearchProfileDelete(
                Base      => 'CustomerTicketSearch',
                Name      => $Profile,
                UserLogin => $Self->{UserLogin},
            );
            %GetParam = ();
            $Profile  = '';
        }

        # create HTML strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle through the activated Dynamic Fields for this screen
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

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        Action         => $Self->{Action},
                        ReturnType     => 'Ticket',
                        ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data           => \%AclData,
                        CustomerUserID => $Self->{UserID},
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
                    LayoutObject           => $LayoutObject,
                    ConfirmationCheckboxes => 1,
                    Type                   => $Preference->{Type},
                    );
            }
        }

        # generate search mask
        my $Output = $LayoutObject->CustomerHeader();
        $Output .= $LayoutObject->CustomerNavigationBar();
        $Output .= $Self->MaskForm(
            %GetParam,
            Profile          => $Profile,
            Area             => 'Customer',
            DynamicFieldHTML => \%DynamicFieldHTML,
            %ServerErrors,
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }
}

sub MaskForm {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $Param{ResultFormStrg} = $LayoutObject->BuildSelection(
        Data => {
            Normal => 'Normal',
            Print  => 'Print',
            CSV    => 'CSV',
            Excel  => 'Excel',
        },
        Name       => 'ResultForm',
        SelectedID => $Param{ResultForm} || 'Normal',
        Class      => 'Modernize',
    );
    $Param{ProfilesStrg} = $LayoutObject->BuildSelection(
        Data => {
            '', '-',
            $Kernel::OM->Get('Kernel::System::SearchProfile')->SearchProfileList(
                Base      => 'CustomerTicketSearch',
                UserLogin => $Self->{UserLogin},
            ),
        },
        Translation => 0,
        Name        => 'Profile',
        SelectedID  => $Param{Profile},
        Class       => 'Modernize',
    );

    # get service object
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    my %ServiceList;
    if ( $ConfigObject->Get('Customer::TicketSearch::AllServices') ) {
        %ServiceList = $ServiceObject->ServiceList(
            UserID => $Self->{UserID},
            ),
    }
    else {
        %ServiceList = $ServiceObject->CustomerUserServiceMemberList(
            CustomerUserLogin => $Self->{UserID},
            Result            => 'HASH',
            ),
    }

    $Param{ServicesStrg} = $LayoutObject->BuildSelection(
        Data       => \%ServiceList,
        Name       => 'ServiceIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{ServiceIDs},
        TreeView   => $TreeView,
        Class      => 'Modernize',
    );
    $Param{TypesStrg} = $LayoutObject->BuildSelection(
        Data => {
            $Kernel::OM->Get('Kernel::System::Type')->TypeList(
                UserID => $Self->{UserID},
            ),
        },
        Name       => 'TypeIDs',
        SelectedID => $Param{TypeIDs},
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{TypeIDs},
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
        SelectedID => $Param{StateIDs},
        Class      => 'Modernize',
    );
    $Param{StateTypeStrg} = $LayoutObject->BuildSelection(
        Data => {
            Open   => 'open',
            Closed => 'closed',
        },
        Name       => 'StateType',
        Size       => 5,
        SelectedID => $Param{StateType},
        Class      => 'Modernize',
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
        SelectedID => $Param{PriorityIDs},
        Class      => 'Modernize',
    );
    $Param{TicketCreateTimePoint} = $LayoutObject->BuildSelection(
        Data => {
            1  => ' 1',
            2  => ' 2',
            3  => ' 3',
            4  => ' 4',
            5  => ' 5',
            6  => ' 6',
            7  => ' 7',
            8  => ' 8',
            9  => ' 9',
            10 => '10',
            11 => '11',
            12 => '12',
            13 => '13',
            14 => '14',
            15 => '15',
            16 => '16',
            17 => '17',
            18 => '18',
            19 => '19',
            20 => '20',
            21 => '21',
            22 => '22',
            23 => '23',
            24 => '24',
            25 => '25',
            26 => '26',
            27 => '27',
            28 => '28',
            29 => '29',
            30 => '30',
            31 => '31',
            32 => '32',
            33 => '33',
            34 => '34',
            35 => '35',
            36 => '36',
            37 => '37',
            38 => '38',
            39 => '39',
            40 => '40',
            41 => '41',
            42 => '42',
            43 => '43',
            44 => '44',
            45 => '45',
            46 => '46',
            47 => '47',
            48 => '48',
            49 => '49',
            50 => '50',
            51 => '51',
            52 => '52',
            53 => '53',
            54 => '54',
            55 => '55',
            56 => '56',
            57 => '57',
            58 => '58',
            59 => '59',
        },
        Translation => 0,
        Name        => 'TicketCreateTimePoint',
        SelectedID  => $Param{TicketCreateTimePoint},
    );
    $Param{TicketCreateTimePointStart} = $LayoutObject->BuildSelection(
        Data => {
            Last   => 'within the last ...',
            Before => 'more than ... ago',
        },
        Translation => 1,
        Name        => 'TicketCreateTimePointStart',
        SelectedID  => $Param{TicketCreateTimePointStart} || 'Last',
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
        Translation => 1,
        Name        => 'TicketCreateTimePointFormat',
        SelectedID  => $Param{TicketCreateTimePointFormat},
    );
    $Param{TicketCreateTimeStart} = $LayoutObject->BuildDateSelection(
        %Param,
        Prefix                     => 'TicketCreateTimeStart',
        TicketCreateTimeStartClass => 'DateSelection',
        Format                     => 'DateInputFormat',
        DiffTime                   => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{TicketCreateTimeStop} = $LayoutObject->BuildDateSelection(
        %Param,
        Prefix                    => 'TicketCreateTimeStop',
        TicketCreateTimeStopClass => 'DateSelection',
        Format                    => 'DateInputFormat',
    );

    # html search mask output
    $LayoutObject->Block(
        Name => 'Search',
        Data => { %Param, },
    );

    # enable archive search
    if (
        $ConfigObject->Get('Ticket::ArchiveSystem')
        && $ConfigObject->Get('Ticket::CustomerArchiveSystem')
        && $ConfigObject->Get('Ticket::CustomerArchiveSystem') eq 1
        )
    {

        $Param{SearchInArchiveStrg} = $LayoutObject->BuildSelection(
            Data => {
                ArchivedTickets    => 'Archived tickets',
                NotArchivedTickets => 'Unarchived tickets',
                AllTickets         => 'All tickets',
            },
            Name       => 'SearchInArchive',
            SelectedID => $Param{SearchInArchive} || 'NotArchivedTickets',
            Class      => 'Modernize',
        );

        $LayoutObject->Block(
            Name => 'SearchInArchive',
            Data => {
                SearchInArchiveStrg => $Param{SearchInArchiveStrg},
            },
        );
    }

    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # get dynamic field config for frontend module
    my $DynamicFieldFilter = $Config->{DynamicField};

    # get the dynamic fields for ticket object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

    # output Dynamic fields blocks
    # cycle through the activated Dynamic Fields for this screen
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
                $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
            );

            $LayoutObject->Block(
                Name => 'DynamicField',
                Data => {
                    Label => $Param{DynamicFieldHTML}
                        ->{ $DynamicFieldConfig->{Name} . $Preference->{Type} }->{Label},
                    Field => $Param{DynamicFieldHTML}
                        ->{ $DynamicFieldConfig->{Name} . $Preference->{Type} }->{Field},
                },
            );
        }
    }

    if (
        $ConfigObject->Get('Ticket::StorageModule') eq
        'Kernel::System::Ticket::ArticleStorageDB'
        )
    {
        $LayoutObject->Block(
            Name => 'Attachment',
            Data => \%Param
        );
    }

    # html search mask output
    return $LayoutObject->Output(
        TemplateFile => 'CustomerTicketSearch',
        Data         => \%Param,
    );
}

sub _StopWordsServerErrorsGet {
    my ( $Self, %Param ) = @_;

    if ( !%Param ) {
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError( Message => "Got no values to check." );
    }

    my %StopWordsServerErrors;
    if ( !$Kernel::OM->Get('Kernel::System::Ticket')->SearchStringStopWordsUsageWarningActive() ) {
        return %StopWordsServerErrors;
    }

    my %SearchStrings;

    FIELD:
    for my $Field ( sort keys %Param ) {
        next FIELD if !defined $Param{$Field};
        next FIELD if !length $Param{$Field};

        $SearchStrings{$Field} = $Param{$Field};
    }

    if (%SearchStrings) {

        my $StopWords = $Kernel::OM->Get('Kernel::System::Ticket')->SearchStringStopWordsFind(
            SearchStrings => \%SearchStrings
        );

        FIELD:
        for my $Field ( sort keys %{$StopWords} ) {
            next FIELD if !defined $StopWords->{$Field};
            next FIELD if ref $StopWords->{$Field} ne 'ARRAY';
            next FIELD if !@{ $StopWords->{$Field} };

            $StopWordsServerErrors{ $Field . 'Invalid' }        = 'ServerError';
            $StopWordsServerErrors{ $Field . 'InvalidTooltip' } = $Self->{LayoutObject}->{LanguageObject}
                ->Translate('Please remove the following words because they cannot be used for the search:')
                . ' '
                . join( ',', sort @{ $StopWords->{$Field} } );
        }
    }

    return %StopWordsServerErrors;
}

1;
