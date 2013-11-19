# --
# Kernel/Modules/CustomerTicketSearch.pm - Utilities for tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: CustomerTicketSearch.pm,v 1.65.2.1 2011-08-23 12:45:25 mb Exp $
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
use Kernel::System::SearchProfile;
use Kernel::System::CSV;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.65.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{UserObject}          = Kernel::System::User->new(%Param);
    $Self->{CustomerUserObject}  = Kernel::System::CustomerUser->new(%Param);
    $Self->{PriorityObject}      = Kernel::System::Priority->new(%Param);
    $Self->{StateObject}         = Kernel::System::State->new(%Param);
    $Self->{QueueObject}         = Kernel::System::Queue->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);
    $Self->{CSVObject}           = Kernel::System::CSV->new(%Param);

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

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
            TicketFreeTime1
            TicketFreeTime1Start TicketFreeTime1StartDay TicketFreeTime1StartMonth
            TicketFreeTime1StartYear
            TicketFreeTime1Stop TicketFreeTime1StopDay TicketFreeTime1StopMonth
            TicketFreeTime1StopYear
            TicketFreeTime2
            TicketFreeTime2Start TicketFreeTime2StartDay TicketFreeTime2StartMonth
            TicketFreeTime2StartYear
            TicketFreeTime2Stop TicketFreeTime2StopDay TicketFreeTime2StopMonth
            TicketFreeTime2StopYear
            TicketFreeTime3
            TicketFreeTime3Start TicketFreeTime3StartDay TicketFreeTime3StartMonth
            TicketFreeTime3StartYear
            TicketFreeTime3Stop TicketFreeTime3StopDay TicketFreeTime3StopMonth
            TicketFreeTime3StopYear
            TicketFreeTime4
            TicketFreeTime4Start TicketFreeTime4StartDay TicketFreeTime4StartMonth
            TicketFreeTime4StartYear
            TicketFreeTime4Stop TicketFreeTime4StopDay TicketFreeTime4StopMonth
            TicketFreeTime4StopYear
            TicketFreeTime5
            TicketFreeTime5Start TicketFreeTime5StartDay TicketFreeTime5StartMonth
            TicketFreeTime5StartYear
            TicketFreeTime5Stop TicketFreeTime5StopDay TicketFreeTime5StopMonth
            TicketFreeTime5StopYear
            TicketFreeTime6
            TicketFreeTime6Start TicketFreeTime6StartDay TicketFreeTime6StartMonth
            TicketFreeTime6StartYear
            TicketFreeTime6Stop TicketFreeTime6StopDay TicketFreeTime6StopMonth
            TicketFreeTime6StopYear
            TicketFreeTime7
            TicketFreeTime7Start TicketFreeTime7StartDay TicketFreeTime7StartMonth
            TicketFreeTime7StartYear
            TicketFreeTime7Stop TicketFreeTime7StopDay TicketFreeTime7StopMonth
            TicketFreeTime7StopYear
            TicketFreeTime8
            TicketFreeTime8Start TicketFreeTime8StartDay TicketFreeTime8StartMonth
            TicketFreeTime8StartYear
            TicketFreeTime8Stop TicketFreeTime8StopDay TicketFreeTime8StopMonth
            TicketFreeTime8StopYear
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
            qw(StateIDs StateTypeIDs PriorityIDs OwnerIDs ResponsibleIDs
            TicketFreeKey1 TicketFreeText1 TicketFreeKey2 TicketFreeText2
            TicketFreeKey3 TicketFreeText3 TicketFreeKey4 TicketFreeText4
            TicketFreeKey5 TicketFreeText5 TicketFreeKey6 TicketFreeText6
            TicketFreeKey7 TicketFreeText7 TicketFreeKey8 TicketFreeText8
            TicketFreeKey9 TicketFreeText9 TicketFreeKey10 TicketFreeText10
            TicketFreeKey11 TicketFreeText11 TicketFreeKey12 TicketFreeText12
            TicketFreeKey13 TicketFreeText13 TicketFreeKey14 TicketFreeText14
            TicketFreeKey15 TicketFreeText15 TicketFreeKey16 TicketFreeText16
            )
            )
        {

            # get search array params (get submitted params)
            my @Array = $Self->{ParamObject}->GetArray( Param => $Key );
            if (@Array) {
                $GetParam{$Key} = \@Array;
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
            ContentType => 'application/opensearchdescription+xml',
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
            for my $Key ( keys %GetParam ) {
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

        # get time settings
        if ( !$GetParam{TimeSearchType} ) {

            # do nothing with time stuff
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimeSlot' ) {
            for (qw(Month Day)) {
                if ( $GetParam{"TicketCreateTimeStart$_"} <= 9 ) {
                    $GetParam{"TicketCreateTimeStart$_"}
                        = '0' . $GetParam{"TicketCreateTimeStart$_"};
                }
            }
            for (qw(Month Day)) {
                if ( $GetParam{"TicketCreateTimeStop$_"} <= 9 ) {
                    $GetParam{"TicketCreateTimeStop$_"} = '0' . $GetParam{"TicketCreateTimeStop$_"};
                }
            }
            if (
                $GetParam{TicketCreateTimeStartDay}
                && $GetParam{TicketCreateTimeStartMonth}
                && $GetParam{TicketCreateTimeStartYear}
                )
            {
                $GetParam{TicketCreateTimeNewerDate}
                    = $GetParam{TicketCreateTimeStartYear} . '-'
                    . $GetParam{TicketCreateTimeStartMonth} . '-'
                    . $GetParam{TicketCreateTimeStartDay}
                    . ' 00:00:01';
            }
            if (
                $GetParam{TicketCreateTimeStopDay}
                && $GetParam{TicketCreateTimeStopMonth}
                && $GetParam{TicketCreateTimeStopYear}
                )
            {
                $GetParam{TicketCreateTimeOlderDate}
                    = $GetParam{TicketCreateTimeStopYear} . '-'
                    . $GetParam{TicketCreateTimeStopMonth} . '-'
                    . $GetParam{TicketCreateTimeStopDay}
                    . ' 23:59:59';
            }
        }
        elsif ( $GetParam{TimeSearchType} eq 'TimePoint' ) {
            if (
                $GetParam{TicketCreateTimePoint}
                && $GetParam{TicketCreateTimePointStart}
                && $GetParam{TicketCreateTimePointFormat}
                )
            {
                my $Time = 0;
                if ( $GetParam{TicketCreateTimePointFormat} eq 'minute' ) {
                    $Time = $GetParam{TicketCreateTimePoint};
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'hour' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'day' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'week' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 7;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'month' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 30;
                }
                elsif ( $GetParam{TicketCreateTimePointFormat} eq 'year' ) {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 365;
                }
                if ( $GetParam{TicketCreateTimePointStart} eq 'Before' ) {
                    $GetParam{TicketCreateTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketCreateTimeNewerMinutes} = $Time;
                }
            }
        }

        # free time
        for ( 1 .. 6 ) {
            if ( !$GetParam{ 'TicketFreeTime' . $_ } ) {
                for my $Type (qw(Year Month Day)) {
                    $GetParam{ 'TicketFreeTime' . $_ . 'Start' . $Type } = undef;
                    $GetParam{ 'TicketFreeTime' . $_ . 'Stop' . $Type }  = undef;
                }
                $GetParam{ 'TicketFreeTime' . $_ . 'NewerDate' } = undef;
                $GetParam{ 'TicketFreeTime' . $_ . 'OlderDate' } = undef;
            }
            else {
                $GetParam{ 'TicketFreeTime' . $_ } = 'checked="checked"';
                if (
                    $GetParam{ 'TicketFreeTime' . $_ . 'StartDay' }
                    && $GetParam{ 'TicketFreeTime' . $_ . 'StartMonth' }
                    && $GetParam{ 'TicketFreeTime' . $_ . 'StartYear' }
                    )
                {
                    $GetParam{ 'TicketFreeTime' . $_ . 'NewerDate' }
                        = $GetParam{ 'TicketFreeTime' . $_ . 'StartYear' } . '-'
                        . $GetParam{ 'TicketFreeTime' . $_ . 'StartMonth' } . '-'
                        . $GetParam{ 'TicketFreeTime' . $_ . 'StartDay' }
                        . ' 00:00:01';
                }
                if (
                    $GetParam{ 'TicketFreeTime' . $_ . 'StopDay' }
                    && $GetParam{ 'TicketFreeTime' . $_ . 'StopMonth' }
                    && $GetParam{ 'TicketFreeTime' . $_ . 'StopYear' }
                    )
                {
                    $GetParam{ 'TicketFreeTime' . $_ . 'OlderDate' }
                        = $GetParam{ 'TicketFreeTime' . $_ . 'StopYear' } . '-'
                        . $GetParam{ 'TicketFreeTime' . $_ . 'StopMonth' } . '-'
                        . $GetParam{ 'TicketFreeTime' . $_ . 'StopDay' }
                        . ' 23:59:59';
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
        );

        # CSV output
        if ( $GetParam{ResultForm} eq 'CSV' ) {
            my @CSVHead;
            my @CSVData;

            for (@ViewableTicketIDs) {

                # get first article data
                my %Data = $Self->{TicketObject}->ArticleFirstArticle(
                    TicketID => $_,
                    Extended => 1,
                );

                $Data{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Data{Age}, Space => ' ' );

                # get whole article (if configured!)
                if ( $Self->{Config}->{SearchArticleCSVTree} && $GetParam{ResultForm} eq 'CSV' ) {
                    my @Article = $Self->{TicketObject}->ArticleGet(
                        TicketID => $_,
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
                        $Self->{TicketObject}->TicketAccountedTimeGet( TicketID => $_ ),
                );

                # csv quote
                if ( !@CSVHead ) {
                    @CSVHead = @{ $Self->{Config}->{SearchCSVData} };
                }
                my @Data;
                for (@CSVHead) {
                    push @Data, $Info{$_};
                }
                push @CSVData, \@Data;
            }

            # get Separator from language file
            my $UserCSVSeparator = $Self->{LayoutObject}->{LanguageObject}->{Separator};

            if ( $Self->{ConfigObject}->Get('PreferencesGroups')->{CSVSeparator}->{Active} ) {
                my %UserData = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );
                $UserCSVSeparator = $UserData{UserCSVSeparator};
            }
            my $CSV = $Self->{CSVObject}->Array2CSV(
                Head      => \@CSVHead,
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
                    TicketID => $TicketID,
                    Extended => 1,
                );

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
                        TicketID => $TicketID,
                        Extended => 1,
                    );

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
                Methode     => 'StateLookup',
                Key         => 'StateID',
                Translation => 1,
            },
            StateTypeIDs => {
                Name        => 'StateType',
                Object      => 'StateObject',
                Methode     => 'StateTypeLookup',
                Key         => 'StateTypeID',
                Translation => 1,
            },
            PriorityIDs => {
                Name        => 'Priority',
                Object      => 'PriorityObject',
                Methode     => 'PriorityLookup',
                Key         => 'PriorityID',
                Translation => 1,
            },
            QueueIDs => {
                Name        => 'Queue',
                Object      => 'QueueObject',
                Methode     => 'QueueLookup',
                Key         => 'QueueID',
                Translation => 0,
            },
            OwnerIDs => {
                Name        => 'Owner',
                Object      => 'UserObject',
                Methode     => 'UserLookup',
                Key         => 'UserID',
                Translation => 0,
            },
            ResponsibleIDs => {
                Name        => 'Responsible',
                Object      => 'UserObject',
                Methode     => 'UserLookup',
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
            my $Method    = $IDMap{$Key}->{Methode};
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

            if ( $Key ne 'TimeSearchType' ) {
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

        # this sets the opposit to the $Order
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

        # get free text config options
        my %TicketFreeText;
        for ( 1 .. 16 ) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                Type           => "TicketFreeKey$_",
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                Type           => "TicketFreeText$_",
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            NullOption => 1,
            Ticket     => \%GetParam,
            Config     => \%TicketFreeText,
        );

        # generate search mask
        my $Output = $Self->{LayoutObject}->CustomerHeader();
        $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output .= $Self->MaskForm(
            %GetParam,
            Profile => $Self->{Profile},
            Area    => 'Customer',
            %TicketFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
}

sub MaskForm {
    my ( $Self, %Param ) = @_;

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
        Name       => 'Profile',
        SelectedID => $Param{Profile},
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
        Name       => 'TicketCreateTimePoint',
        SelectedID => $Param{TicketCreateTimePoint},
    );
    $Param{TicketCreateTimePointStart} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            Last   => 'last',
            Before => 'before',
        },
        Name => 'TicketCreateTimePointStart',
        SelectedID => $Param{TicketCreateTimePointStart} || 'Last',
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
        SelectedID => $Param{TicketCreateTimePointFormat},
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

    for ( 1 .. 6 ) {
        $Param{ 'TicketFreeTime' . $_ . 'Start' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix                               => 'TicketFreeTime' . $_ . 'Start',
            'TicketFreeTime' . $_ . 'StartClass' => 'DateSelection',
            Format                               => 'DateInputFormat',
            DiffTime                             => -( ( 60 * 60 * 24 ) * 30 ),
        );
        $Param{ 'TicketFreeTime' . $_ . 'Stop' } = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix                              => 'TicketFreeTime' . $_ . 'Stop',
            'TicketFreeTime' . $_ . 'StopClass' => 'DateSelection',
            Format                              => 'DateInputFormat',
            DiffTime                            => +( ( 60 * 60 * 24 ) * 30 ),
        );
    }

    # html search mask output
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => { %Param, },
    );
    for my $Count ( 1 .. 16 ) {
        next if !$Self->{Config}->{TicketFreeText}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'FreeText',
            Data => {
                TicketFreeKeyField  => $Param{ 'TicketFreeKeyField' . $Count },
                TicketFreeTextField => $Param{ 'TicketFreeTextField' . $Count },
            },
        );
    }
    for my $Count ( 1 .. 6 ) {
        next if !$Self->{Config}->{TicketFreeTime}->{$Count};
        $Self->{LayoutObject}->Block(
            Name => 'FreeTime',
            Data => {
                TicketFreeTimeKey   => $Self->{ConfigObject}->Get( 'TicketFreeTimeKey' . $Count ),
                TicketFreeTime      => $Param{ 'TicketFreeTime' . $Count },
                TicketFreeTimeStart => $Param{ 'TicketFreeTime' . $Count . 'Start' },
                TicketFreeTimeStop  => $Param{ 'TicketFreeTime' . $Count . 'Stop' },
                Count               => $Count,
            },
        );
    }

    # html search mask output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketSearch',
        Data         => \%Param,
    );
}

sub MaskCSVResult {
    my ( $Self, %Param ) = @_;

    $Param{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Param{Age}, Space => ' ' );

    # customer info string
    $Param{CustomerName} = '(' . $Param{CustomerName} . ')' if ( $Param{CustomerName} );

    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketSearchResultCSV',
        Data         => \%Param,
    );
}

sub MaskPrintResult {
    my ( $Self, %Param ) = @_;

    $Param{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Param{Age}, Space => ' ' );

    # customer info string
    $Param{CustomerName} = '(' . $Param{CustomerName} . ')' if ( $Param{CustomerName} );

    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketSearchResultPrintTable',
        Data         => \%Param,
    );
}

1;
