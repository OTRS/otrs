# --
# Kernel/Modules/CustomerTicketSearch.pm - Utilities for tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketSearch;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::User;
use Kernel::System::Priority;
use Kernel::System::State;
use Kernel::System::Queue;
use Kernel::System::Service;
use Kernel::System::Type;
use Kernel::System::SearchProfile;
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
    for my $Needed (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{UserObject}          = Kernel::System::User->new(%Param);
    $Self->{CustomerUserObject}  = Kernel::System::CustomerUser->new(%Param);
    $Self->{PriorityObject}      = Kernel::System::Priority->new(%Param);
    $Self->{StateObject}         = Kernel::System::State->new(%Param);
    $Self->{QueueObject}         = Kernel::System::Queue->new(%Param);
    $Self->{ServiceObject}       = Kernel::System::Service->new(%Param);
    $Self->{TypeObject}          = Kernel::System::Type->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);
    $Self->{CSVObject}           = Kernel::System::CSV->new(%Param);
    $Self->{DynamicFieldObject}  = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}       = Kernel::System::DynamicField::Backend->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # get dynamic field config for frontend module
    $Self->{DynamicFieldFilter} = $Self->{Config}->{DynamicField};

    # get the dynamic fields for ticket object
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $Self->{DynamicField} = \@CustomerDynamicFields;

    # get the ticket dynamic fields for overview display
    $Self->{OverviewDynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{Config}->{SearchOverviewDynamicField} || {},
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @OverviewCustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{OverviewDynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @OverviewCustomerDynamicFields, $DynamicFieldConfig;
    }
    $Self->{OverviewDynamicField} = \@OverviewCustomerDynamicFields;

    # get the ticket dynamic fields for CSV display
    $Self->{CSVDynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{Config}->{SearchCSVDynamicField} || {},
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CSVCustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{CSVDynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CSVCustomerDynamicFields, $DynamicFieldConfig;
    }
    $Self->{CSVDynamicField} = \@CSVCustomerDynamicFields;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # get config data
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{SearchLimit} = $Self->{ConfigObject}->Get('Ticket::CustomerTicketSearch::SearchLimit')
        || 200;
    $Self->{SearchPageShown}
        = $Self->{ConfigObject}->Get('Ticket::CustomerTicketSearch::SearchPageShown') || 40;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{ConfigObject}->Get('Ticket::CustomerTicketSearch::SortBy::Default')
        || 'Age';
    $Self->{Order} = $Self->{ParamObject}->GetParam( Param => 'Order' )
        || $Self->{ConfigObject}->Get('Ticket::CustomerTicketSearch::Order::Default')
        || 'Down';

    $Self->{Profile}        = $Self->{ParamObject}->GetParam( Param => 'Profile' )        || '';
    $Self->{SaveProfile}    = $Self->{ParamObject}->GetParam( Param => 'SaveProfile' )    || '';
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam( Param => 'TakeLastSearch' ) || '';
    $Self->{SelectTemplate} = $Self->{ParamObject}->GetParam( Param => 'SelectTemplate' ) || '';
    $Self->{EraseTemplate}  = $Self->{ParamObject}->GetParam( Param => 'EraseTemplate' )  || '';

    # check request
    if ( $Self->{ParamObject}->GetParam( Param => 'SearchTemplate' ) && $Self->{Profile} ) {
        return $Self->{LayoutObject}->Redirect(
            OP =>
                "Action=CustomerTicketSearch;Subaction=Search;TakeLastSearch=1;SaveProfile=1;Profile=$Self->{Profile}",
        );
    }

    # remember exclude attributes
    my @Excludes = $Self->{ParamObject}->GetArray( Param => 'Exclude' );

    # get single params
    my %GetParam;

    # load profiles string params (press load profile)
    if ( ( $Self->{Subaction} eq 'LoadProfile' && $Self->{Profile} ) || $Self->{TakeLastSearch} ) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base      => 'CustomerTicketSearch',
            Name      => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
    }

    # get search string params (get submitted params)
    else {
        for my $Key (
            qw(TicketNumber From To Cc Subject Body CustomerID ResultForm TimeSearchType StateType
            SearchInArchive
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
            $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );

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
            my @Array = $Self->{ParamObject}->GetArray( Param => $Key );
            if (@Array) {
                $GetParam{$Key} = \@Array;
            }
        }

        # get Dynamic fields form param object
        # cycle through the activated Dynamic Fields for this screen
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
        $Self->{SearchPageShown} = $Self->{SearchLimit};
    }

    # check request
    if ( $Self->{Subaction} eq 'OpenSearchDescription' ) {
        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerTicketSearchOpenSearchDescription',
            Data         => {%Param},
        );
        return $Self->{LayoutObject}->Attachment(
            Filename    => 'OpenSearchDescription.xml',
            ContentType => 'text/xml',
            Content     => $Output,
            Type        => 'inline',
        );
    }

    # show result page
    if ( $Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate} ) {

        # fill up profile name (e.g. with last-search)
        if ( !$Self->{Profile} || !$Self->{SaveProfile} ) {
            $Self->{Profile} = 'last-search';
        }

        # store search URL in LastScreenOverview to make sure the
        # customer can use the "back" link as expected
        my $URL
            = "Action=CustomerTicketSearch;Subaction=Search;Profile=$Self->{Profile};"
            . "SortBy=$Self->{SortBy};Order=$Self->{Order};TakeLastSearch=1;"
            . "StartHit=$Self->{StartHit}";
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
                Base      => 'CustomerTicketSearch',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );

            # insert new profile params
            for my $Key ( sort keys %GetParam ) {
                if ( $GetParam{$Key} ) {
                    $Self->{SearchProfileObject}->SearchProfileAdd(
                        Base      => 'CustomerTicketSearch',
                        Name      => $Self->{Profile},
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

        # prepare archive flag
        if (
            $Self->{ConfigObject}->Get('Ticket::ArchiveSystem')
            && $Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem')
            && $Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem') eq 1
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
            $Self->{ConfigObject}->Get('Ticket::ArchiveSystem')
            && $Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem')
            && $Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem') eq 2
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
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # get search field preferences
            my $SearchFieldPreferences = $Self->{BackendObject}->SearchFieldPreferences(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            next DYNAMICFIELD if !IsArrayRefWithData($SearchFieldPreferences);

            PREFERENCE:
            for my $Preference ( @{$SearchFieldPreferences} ) {

                my $DynamicFieldValue = $Self->{BackendObject}->SearchFieldValueGet(
                    DynamicFieldConfig     => $DynamicFieldConfig,
                    ParamObject            => $Self->{ParamObject},
                    Type                   => $Preference->{Type},
                    ReturnProfileStructure => 1,
                );

                # set the complete value structure in %DynamicFieldValues to discard those where the
                # value will not be possible to get
                next PREFERENCE if !IsHashRefWithData($DynamicFieldValue);

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

                    # set value to display
                    $DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} }
                        = $SearchParameter->{Display};
                }
            }
        }

        # perform ticket search
        my @ViewableTicketIDs = $Self->{TicketObject}->TicketSearch(
            Result              => 'ARRAY',
            SortBy              => $Self->{SortBy},
            OrderBy             => $Self->{Order},
            Limit               => $Self->{SearchLimit},
            CustomerUserID      => $Self->{UserID},
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
                my %Data = $Self->{TicketObject}->ArticleFirstArticle(
                    TicketID      => $TicketID,
                    Extended      => 1,
                    DynamicFields => 1,
                );

                # if no article found, use ticket information
                if ( !%Data ) {
                    my %Ticket = $Self->{TicketObject}->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                        UserID        => $Self->{UserID},
                    );
                    %Data = %Ticket;
                    $Data{Subject} = $Ticket{Title} || 'Untitled';
                    $Data{Body} = $Self->{LayoutObject}->{LanguageObject}->Get(
                        'This item has no articles yet.'
                    );
                }

                for my $Key (qw(State Lock)) {
                    $Data{$Key} = $Self->{LayoutObject}->{LanguageObject}->Get( $Data{$Key} );
                }

                $Data{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Data{Age}, Space => ' ' );

                # get whole article (if configured!)
                if ( $Self->{Config}->{SearchArticleCSVTree} && $GetParam{ResultForm} eq 'CSV' ) {
                    my @Article = $Self->{TicketObject}->ArticleGet(
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
                        $Self->{TicketObject}->TicketAccountedTimeGet( TicketID => $TicketID ),
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

                            # skip all fields that do not match the current field name ($1)
                            # with out the 'DynamicField_' prefix
                            next DYNAMICFIELD if $DynamicFieldConfig->{Name} ne $1;

                            # get the value for print
                            my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                                DynamicFieldConfig => $DynamicFieldConfig,
                                Value              => $Info{$Header},
                                HTMLOutput         => 0,
                                LayoutObject       => $Self->{LayoutObject},
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
            for my $TicketID (@ViewableTicketIDs) {

                # get first article data
                my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
                    TicketID      => $TicketID,
                    Extended      => 1,
                    DynamicFields => 0,
                );

                # if no article found, use ticket information
                if ( !%Article ) {
                    my %Ticket = $Self->{TicketObject}->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                        UserID        => $Self->{UserID},
                    );
                    %Article = %Ticket;
                    $Article{Subject} = $Ticket{Title} || 'Untitled';
                    $Article{Body} = $Self->{LayoutObject}->{LanguageObject}->Get(
                        'This item has no articles yet.'
                    );
                }

                # customer info
                my %CustomerData;
                if ( $Article{CustomerUserID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );
                }
                elsif ( $Article{CustomerID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Article{CustomerID},
                    );
                }

                # customer info (customer name)
                if ( $CustomerData{UserLogin} ) {
                    $Article{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                        UserLogin => $CustomerData{UserLogin},
                    );
                }

                # user info
                my %Owner = $Self->{UserObject}->GetUserData(
                    User => $Article{Owner},
                );

                # Condense down the subject
                my $Subject = $Self->{TicketObject}->TicketSubjectClean(
                    TicketNumber => $Article{TicketNumber},
                    Subject => $Article{Subject} || '',
                );
                $Article{Age}
                    = $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' );

                # customer info string
                if ( $Article{CustomerName} ) {
                    $Article{CustomerName} = '(' . $Article{CustomerName} . ')';
                }

                # add blocks to template
                $Self->{LayoutObject}->Block(
                    Name => 'Record',
                    Data => {
                        %Article,
                        Subject => $Subject,
                        %Owner,
                    },
                );
            }
            my $Output = $Self->{LayoutObject}->PrintHeader( Width => 800 );
            if ( @ViewableTicketIDs == $Self->{SearchLimit} ) {
                $Param{Warning} = '$Text{"Reached max. count of %s search hits!", "'
                    . $Self->{SearchLimit} . '"}';
            }
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'CustomerTicketSearchResultPrint',
                Data         => \%Param,
            );

            # add footer
            $Output .= $Self->{LayoutObject}->PrintFooter();

            # return output
            return $Output;

        }

        my $Counter = 0;

        # if there are results to show
        if (@ViewableTicketIDs) {

            # Dynamic fields table headers
            # cycle through the activated Dynamic Fields for this screen
            DYNAMICFIELD:
            for my $DynamicFieldConfig ( @{ $Self->{OverviewDynamicField} } ) {
                next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                my $Label = $DynamicFieldConfig->{Label};

                # get field sortable condition
                my $IsSortable = $Self->{BackendObject}->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsSortable',
                );

                if ($IsSortable) {
                    my $CSS   = '';
                    my $Order = 'Down';
                    if (
                        $Self->{SortBy}
                        && (
                            $Self->{SortBy} eq
                            ( 'DynamicField_' . $DynamicFieldConfig->{Name} )
                        )
                        )
                    {
                        if ( $Self->{Order} && ( $Self->{Order} eq 'Up' ) ) {
                            $Order = 'Down';
                            $CSS .= ' SortAscending';
                        }
                        else {
                            $Order = 'Up';
                            $CSS .= ' SortDescending';
                        }
                    }

                    $Self->{LayoutObject}->Block(
                        Name => 'HeaderDynamicField',
                        Data => {
                            %Param,
                            CSS => $CSS,
                        },
                    );

                    $Self->{LayoutObject}->Block(
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

                    $Self->{LayoutObject}->Block(
                        Name => 'HeaderDynamicField',
                        Data => {
                            %Param,
                        },
                    );

                    $Self->{LayoutObject}->Block(
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
                    $Counter >= $Self->{StartHit}
                    && $Counter < ( $Self->{SearchPageShown} + $Self->{StartHit} )
                    )
                {

                    # get first article data
                    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(
                        TicketID      => $TicketID,
                        Extended      => 1,
                        DynamicFields => 1,
                    );

                    my %Ticket = $Self->{TicketObject}->TicketGet(
                        TicketID      => $TicketID,
                        DynamicFields => 0,
                        UserID        => $Self->{UserID},
                    );

                    # if no article found, use ticket information
                    if ( !%Article ) {
                        %Article = %Ticket;
                        $Article{Subject} = $Ticket{Title} || 'Untitled';
                        $Article{Body} = $Self->{LayoutObject}->{LanguageObject}->Get(
                            'This item has no articles yet.'
                        );
                    }

                    # customer info
                    my %CustomerData;
                    if ( $Article{CustomerUserID} ) {
                        %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                            User => $Article{CustomerUserID},
                        );
                    }
                    elsif ( $Article{CustomerID} ) {
                        %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                            User => $Article{CustomerID},
                        );
                    }

                    # customer info (customer name)
                    if ( $CustomerData{UserLogin} ) {
                        $Article{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                            UserLogin => $CustomerData{UserLogin},
                        );
                    }

                    # user info
                    my %Owner = $Self->{UserObject}->GetUserData(
                        User => $Article{Owner},
                    );

                    # Condense down the subject
                    my $Subject = $Self->{TicketObject}->TicketSubjectClean(
                        TicketNumber => $Article{TicketNumber},
                        Subject => $Article{Subject} || '',
                    );
                    $Article{CustomerAge}
                        = $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' );

                    # customer info string
                    if ( $Article{CustomerName} ) {
                        $Article{CustomerName} = '(' . $Article{CustomerName} . ')';
                    }

                    # add blocks to template
                    $Self->{LayoutObject}->Block(
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
                    for my $DynamicFieldConfig ( @{ $Self->{OverviewDynamicField} } ) {
                        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

                        # get field value
                        my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                            DynamicFieldConfig => $DynamicFieldConfig,
                            Value => $Article{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                            ValueMaxChars => 20,
                            LayoutObject  => $Self->{LayoutObject},
                        );

                        $Self->{LayoutObject}->Block(
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
            $Self->{LayoutObject}->Block( Name => 'NoDataFoundMsg' );
        }

        # show attributes used for search
        my %IDMap = (
            StateIDs => {
                Name        => 'State',
                Object      => 'StateObject',
                Method      => 'StateLookup',
                Key         => 'StateID',
                Translation => 1,
            },
            StateTypeIDs => {
                Name        => 'StateType',
                Object      => 'StateObject',
                Method      => 'StateTypeLookup',
                Key         => 'StateTypeID',
                Translation => 1,
            },
            PriorityIDs => {
                Name        => 'Priority',
                Object      => 'PriorityObject',
                Method      => 'PriorityLookup',
                Key         => 'PriorityID',
                Translation => 1,
            },
            QueueIDs => {
                Name        => 'Queue',
                Object      => 'QueueObject',
                Method      => 'QueueLookup',
                Key         => 'QueueID',
                Translation => 0,
            },
            OwnerIDs => {
                Name        => 'Owner',
                Object      => 'UserObject',
                Method      => 'UserLookup',
                Key         => 'UserID',
                Translation => 0,
            },
            ResponsibleIDs => {
                Name        => 'Responsible',
                Object      => 'UserObject',
                Method      => 'UserLookup',
                Key         => 'UserID',
                Translation => 0,
            },
        );
        for my $Key (
            qw(TicketNumber From To Cc Subject Body CustomerID TimeSearchType StateType
            StateIDs StateTypeIDs PriorityIDs OwnerIDs ResponsibleIDs
            )
            )
        {
            next if !$GetParam{$Key};
            my $Attribute = $IDMap{$Key}->{Name}   || $Key;
            my $Object    = $IDMap{$Key}->{Object} || '';
            my $Method    = $IDMap{$Key}->{Method};
            my $MethodKey = $IDMap{$Key}->{Key};
            my $Translation = $IDMap{$Key}->{Translation};
            my $Value;

            if ( ref $GetParam{$Key} eq 'ARRAY' ) {
                for my $ItemRaw ( @{ $GetParam{$Key} } ) {
                    my $Item = $ItemRaw;
                    if ($Value) {
                        $Value .= '+';
                    }
                    if ( $Self->{$Object} ) {
                        $Item = $Self->{$Object}->$Method( $MethodKey => $Item );
                        if ($Translation) {
                            $Item = $Self->{LayoutObject}->{LanguageObject}->Get($Item);
                        }
                    }
                    $Value .= $Item;
                }
            }
            else {
                my $Item = $GetParam{$Key};
                if ( $Self->{$Object} ) {
                    $Item = $Self->{$Object}->$Method( $MethodKey => $Item );
                    if ($Translation) {
                        $Item = $Self->{LayoutObject}->{LanguageObject}->Get($Item);
                    }
                }
                $Value = $Item;
            }
            if ( $Key eq 'TimeSearchType' ) {

                if ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {

                    my $StartDate = $Self->{LayoutObject}->{LanguageObject}->FormatTimeString(
                        $GetParam{TicketCreateTimeStartYear}
                            . '-' . $GetParam{TicketCreateTimeStartMonth}
                            . '-' . $GetParam{TicketCreateTimeStartDay}
                            . ' 00:00:00', 'DateFormatShort'
                    );

                    my $StopDate = $Self->{LayoutObject}->{LanguageObject}->FormatTimeString(
                        $GetParam{TicketCreateTimeStopYear}
                            . '-' . $GetParam{TicketCreateTimeStopMonth}
                            . '-' . $GetParam{TicketCreateTimeStopDay}
                            . ' 00:00:00', 'DateFormatShort'
                    );

                    $Attribute = 'Created between';
                    $Value
                        = $StartDate . ' '
                        . $Self->{LayoutObject}->{LanguageObject}->Get('and') . ' '
                        . $StopDate;
                }
                else {

                    my $Mapping = {
                        'Last'   => 'Created within the last',
                        'Before' => 'Created more than ... ago',
                    };

                    $Attribute = $Mapping->{ $GetParam{TicketCreateTimePointStart} };
                    $Value
                        = $GetParam{TicketCreateTimePoint} . ' '
                        . $Self->{LayoutObject}->{LanguageObject}
                        ->Get( $GetParam{TicketCreateTimePointFormat} . '(s)' );
                }
            }

            $Self->{LayoutObject}->Block(
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
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD
                if !$DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

            $Self->{LayoutObject}->Block(
                Name => 'SearchTerms',
                Data => {
                    Attribute => $DynamicFieldConfig->{Label},
                    Value =>
                        $DynamicFieldSearchDisplay{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                },
            );
        }

        my $Link = 'Profile=' . $Self->{LayoutObject}->LinkEncode( $Self->{Profile} ) . ';';
        $Link .= 'SortBy=' . $Self->{LayoutObject}->LinkEncode( $Self->{SortBy} ) . ';';
        $Link .= 'Order=' . $Self->{LayoutObject}->LinkEncode( $Self->{Order} ) . ';';
        $Link .= 'TakeLastSearch=1;';

        # build search navigation bar
        my %PageNav = $Self->{LayoutObject}->PageNavBar(
            Limit     => $Self->{SearchLimit},
            StartHit  => $Self->{StartHit},
            PageShown => $Self->{SearchPageShown},
            AllHits   => $Counter,
            Action    => "Action=CustomerTicketSearch;Subaction=Search",
            Link      => $Link,
            IDPrefix  => "CustomerTicketSearch",
        );

        # show footer filter - show only if more the one page is available
        if ( $PageNav{TotalHits} && ( $PageNav{TotalHits} > $Self->{SearchPageShown} ) ) {
            $Self->{LayoutObject}->Block(
                Name => 'Pagination',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
        }

        my $Order = 'Down';
        if ( $Self->{Order} eq 'Down' ) {
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

        if ( $Self->{SortBy} eq 'State' ) {
            $StateSort = $Sort;
        }
        if ( $Self->{SortBy} eq 'Ticket' ) {
            $TicketSort = $Sort;
        }
        if ( $Self->{SortBy} eq 'Age' ) {
            $AgeSort = $Sort;
        }

        # start html page
        my $Output = $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'CustomerTicketSearchResultShort',
            Data         => {
                %Param,
                %PageNav,
                Order      => $Order,
                StateSort  => $StateSort,
                TicketSort => $TicketSort,
                AgeSort    => $AgeSort,
                Profile    => $Self->{Profile},
            },
        );

        # build footer
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # empty search site
    else {

        # delete profile
        if ( $Self->{EraseTemplate} && $Self->{Profile} ) {

            # remove old profile stuff
            $Self->{SearchProfileObject}->SearchProfileDelete(
                Base      => 'CustomerTicketSearch',
                Name      => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );
            %GetParam = ();
            $Self->{Profile} = '';
        }

        # create HTML strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle through the activated Dynamic Fields for this screen
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
                        Action         => $Self->{Action},
                        ReturnType     => 'Ticket',
                        ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data           => \%AclData,
                        CustomerUserID => $Self->{UserID},
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
                    LayoutObject           => $Self->{LayoutObject},
                    ConfirmationCheckboxes => 1,
                    Type                   => $Preference->{Type},
                    );
            }
        }

        # generate search mask
        my $Output = $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output .= $Self->MaskForm(
            %GetParam,
            Profile          => $Self->{Profile},
            Area             => 'Customer',
            DynamicFieldHTML => \%DynamicFieldHTML
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}

sub MaskForm {
    my ( $Self, %Param ) = @_;

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    $Param{ResultFormStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            Normal => 'Normal',
            Print  => 'Print',
            CSV    => 'CSV',
        },
        Name => 'ResultForm',
        SelectedID => $Param{ResultForm} || 'Normal',
    );
    $Param{ProfilesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            '', '-',
            $Self->{SearchProfileObject}->SearchProfileList(
                Base      => 'CustomerTicketSearch',
                UserLogin => $Self->{UserLogin},
            ),
        },
        Translation => 0,
        Name        => 'Profile',
        SelectedID  => $Param{Profile},
    );
    $Param{ServicesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{ServiceObject}->ServiceList(
                UserID => $Self->{UserID},
            ),
        },
        Name       => 'ServiceIDs',
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{ServiceIDs},
        TreeView   => $TreeView,
    );
    $Param{TypesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{TypeObject}->TypeList(
                UserID => $Self->{UserID},
            ),
        },
        Name       => 'TypeIDs',
        SelectedID => $Param{TypeIDs},
        Multiple   => 1,
        Size       => 5,
        SelectedID => $Param{TypeIDs},
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
        SelectedID => $Param{StateIDs},
    );
    $Param{StateTypeStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            Open   => 'open',
            Closed => 'closed',
        },
        Name       => 'StateType',
        Size       => 5,
        SelectedID => $Param{StateType},
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
        SelectedID => $Param{PriorityIDs},
    );
    $Param{TicketCreateTimePoint} = $Self->{LayoutObject}->BuildSelection(
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
    $Param{TicketCreateTimePointStart} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            Last   => 'within the last ...',
            Before => 'more than ... ago',
        },
        Translation => 1,
        Name        => 'TicketCreateTimePointStart',
        SelectedID  => $Param{TicketCreateTimePointStart} || 'Last',
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
        Translation => 1,
        Name        => 'TicketCreateTimePointFormat',
        SelectedID  => $Param{TicketCreateTimePointFormat},
    );
    $Param{TicketCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix                     => 'TicketCreateTimeStart',
        TicketCreateTimeStartClass => 'DateSelection',
        Format                     => 'DateInputFormat',
        DiffTime                   => -( ( 60 * 60 * 24 ) * 30 ),
    );
    $Param{TicketCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix                    => 'TicketCreateTimeStop',
        TicketCreateTimeStopClass => 'DateSelection',
        Format                    => 'DateInputFormat',
    );

    # html search mask output
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => { %Param, },
    );

    # enable archive search
    if (
        $Self->{ConfigObject}->Get('Ticket::ArchiveSystem')
        && $Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem')
        && $Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem') eq 1
        )
    {

        $Param{SearchInArchiveStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => {
                ArchivedTickets    => 'Archived tickets',
                NotArchivedTickets => 'Unarchived tickets',
                AllTickets         => 'All tickets',
            },
            Name => 'SearchInArchive',
            SelectedID => $Param{SearchInArchive} || 'NotArchivedTickets',
        );

        $Self->{LayoutObject}->Block(
            Name => 'SearchInArchive',
            Data => {
                SearchInArchiveStrg => $Param{SearchInArchiveStrg},
            },
        );
    }

    # output Dynamic fields blocks
    # cycle through the activated Dynamic Fields for this screen
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
                $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} . $Preference->{Type} }
            );

            $Self->{LayoutObject}->Block(
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

    # html search mask output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketSearch',
        Data         => \%Param,
    );
}

1;
