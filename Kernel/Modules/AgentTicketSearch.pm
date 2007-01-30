# --
# Kernel/Modules/AgentTicketSearch.pm - Utilities for tickets
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketSearch.pm,v 1.35 2007-01-30 19:57:20 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketSearch;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::Priority;
use Kernel::System::State;
use Kernel::System::SearchProfile;
use Kernel::System::PDF;

use vars qw($VERSION);
$VERSION = '$Revision: 1.35 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject MainObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{PriorityObject} = Kernel::System::Priority->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{SearchProfileObject} = Kernel::System::SearchProfile->new(%Param);
    $Self->{PDFObject} = Kernel::System::PDF->new(%Param);

    # if we need to do a fulltext search on an external mirror database
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::Search::DB::DSN')) {
        my $ExtraDatabaseObject = Kernel::System::DB->new(
            LogObject => $Param{LogObject},
            ConfigObject => $Param{ConfigObject},
            DatabaseDSN => $Self->{ConfigObject}->Get('Ticket::Frontend::Search::DB::DSN'),
            DatabaseUser => $Self->{ConfigObject}->Get('Ticket::Frontend::Search::DB::User'),
            DatabasePw => $Self->{ConfigObject}->Get('Ticket::Frontend::Search::DB::Password'),
        );
        if (!$ExtraDatabaseObject) {
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

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # get confid data
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 1;
    $Self->{SearchLimit} = $Self->{Config}->{SearchLimit} || 200;
    $Self->{SearchPageShown} = $Self->{Config}->{SearchPageShown} || 40;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam(Param => 'SortBy') || $Self->{Config}->{'SortBy::Default'} || 'Age';
    $Self->{Order} = $Self->{ParamObject}->GetParam(Param => 'Order') || $Self->{Config}->{'Order::Default'} || 'Down';
    $Self->{Profile} = $Self->{ParamObject}->GetParam(Param => 'Profile') || '';
    $Self->{SaveProfile} = $Self->{ParamObject}->GetParam(Param => 'SaveProfile') || '';
    $Self->{TakeLastSearch} = $Self->{ParamObject}->GetParam(Param => 'TakeLastSearch') || '';
    $Self->{SelectTemplate} = $Self->{ParamObject}->GetParam(Param => 'SelectTemplate') || '';
    $Self->{EraseTemplate} = $Self->{ParamObject}->GetParam(Param => 'EraseTemplate') || '';
    # check request
    if ($Self->{ParamObject}->GetParam(Param => 'SearchTemplate') && $Self->{Profile}) {
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentTicketSearch&Subaction=Search&TakeLastSearch=1&SaveProfile=1&Profile=$Self->{Profile}"
        );
    }
    # get signle params
    my %GetParam = ();

    # load profiles string params (press load profile)
    if (($Self->{Subaction} eq 'LoadProfile' && $Self->{Profile}) || $Self->{TakeLastSearch}) {
        %GetParam = $Self->{SearchProfileObject}->SearchProfileGet(
            Base => 'TicketSearch',
            Name => $Self->{Profile},
            UserLogin => $Self->{UserLogin},
        );
    }
    # get search string params (get submitted params)
    else {
        foreach (qw(TicketNumber From To Cc Subject Body CustomerID CustomerUserLogin
            Agent ResultForm TimeSearchType
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
        )) {
            # get search string params (get submitted params)
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
            # remove white space on the start and end
            if ($GetParam{$_}) {
                $GetParam{$_} =~ s/\s+$//g;
                $GetParam{$_} =~ s/^\s+//g;
            }
        }
        # get array params
        foreach (qw(StateIDs StateTypeIDs QueueIDs PriorityIDs OwnerIDs
            CreatedQueueIDs CreatedUserIDs
            TicketFreeKey1 TicketFreeText1 TicketFreeKey2 TicketFreeText2
            TicketFreeKey3 TicketFreeText3 TicketFreeKey4 TicketFreeText4
            TicketFreeKey5 TicketFreeText5 TicketFreeKey6 TicketFreeText6
            TicketFreeKey7 TicketFreeText7 TicketFreeKey8 TicketFreeText8
            TicketFreeKey9 TicketFreeText9 TicketFreeKey10 TicketFreeText10
            TicketFreeKey11 TicketFreeText11 TicketFreeKey12 TicketFreeText12
            TicketFreeKey13 TicketFreeText13 TicketFreeKey14 TicketFreeText14
            TicketFreeKey15 TicketFreeText15 TicketFreeKey16 TicketFreeText16)
        ) {
            # get search array params (get submitted params)
            my @Array = $Self->{ParamObject}->GetArray(Param => $_);
            if (@Array) {
                $GetParam{$_} = \@Array;
            }
        }
    }
    # get time option
    if (!$GetParam{TimeSearchType}) {
        $GetParam{'TimeSearchType::None'} = 'checked';
    }
    elsif ($GetParam{TimeSearchType} eq 'TimePoint') {
        $GetParam{'TimeSearchType::TimePoint'} = 'checked';
    }
    elsif ($GetParam{TimeSearchType} eq 'TimeSlot') {
        $GetParam{'TimeSearchType::TimeSlot'} = 'checked';
    }
    # set result form env
    if (!$GetParam{ResultForm}) {
        $GetParam{ResultForm} = '';
    }
    if ($GetParam{ResultForm} eq 'Print' || $GetParam{ResultForm} eq 'CSV') {
        $Self->{SearchPageShown} = $Self->{SearchLimit};
    }
    # show result site
    if ($Self->{Subaction} eq 'Search' && !$Self->{EraseTemplate}) {
        # fill up profile name (e.g. with last-search)
        if (!$Self->{Profile} || !$Self->{SaveProfile}) {
            $Self->{Profile} = 'last-search';
        }
        # store last queue screen
        my $URL = "Action=AgentTicketSearch&Subaction=Search&Profile=$Self->{Profile}&SortBy=$Self->{SortBy}".
            "&Order=$Self->{Order}&TakeLastSearch=1&StartHit=$Self->{StartHit}";
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenOverview',
            Value => $URL,
        );
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $URL,
        );
        # save search profile (under last-search or real profile name)
        $Self->{SaveProfile} = 1;
        # remember last search values
        if ($Self->{SaveProfile} && $Self->{Profile}) {
            # remove old profile stuff
            $Self->{SearchProfileObject}->SearchProfileDelete(
                Base => 'TicketSearch',
                Name => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );
            # insert new profile params
            foreach my $Key (keys %GetParam) {
                if ($GetParam{$Key}) {
                    $Self->{SearchProfileObject}->SearchProfileAdd(
                        Base => 'TicketSearch',
                        Name => $Self->{Profile},
                        Key => $Key,
                        Value => $GetParam{$Key},
                        UserLogin => $Self->{UserLogin},
                    );
                }
            }
        }

        # get time settings
        if (!$GetParam{TimeSearchType}) {
            # do noting ont time stuff
        }
        elsif ($GetParam{TimeSearchType} eq 'TimeSlot') {
            foreach (qw(Month Day)) {
                $GetParam{"TicketCreateTimeStart$_"} = sprintf("%02d", $GetParam{"TicketCreateTimeStart$_"});
            }
            foreach (qw(Month Day)) {
                $GetParam{"TicketCreateTimeStop$_"} = sprintf("%02d", $GetParam{"TicketCreateTimeStop$_"});
            }
            if ($GetParam{TicketCreateTimeStartDay} &&
                $GetParam{TicketCreateTimeStartMonth} &&
                $GetParam{TicketCreateTimeStartYear}
            ) {
                $GetParam{TicketCreateTimeNewerDate} = $GetParam{TicketCreateTimeStartYear}.
                    '-'.$GetParam{TicketCreateTimeStartMonth}.
                    '-'.$GetParam{TicketCreateTimeStartDay}.
                    ' 00:00:01';
            }
            if ($GetParam{TicketCreateTimeStopDay} &&
                $GetParam{TicketCreateTimeStopMonth} &&
                $GetParam{TicketCreateTimeStopYear}
            ) {
                $GetParam{TicketCreateTimeOlderDate} = $GetParam{TicketCreateTimeStopYear}.
                    '-'.$GetParam{TicketCreateTimeStopMonth}.
                    '-'.$GetParam{TicketCreateTimeStopDay}.
                    ' 23:59:59';
            }
        }
        elsif ($GetParam{TimeSearchType} eq 'TimePoint') {
            if ($GetParam{TicketCreateTimePoint} &&
                $GetParam{TicketCreateTimePointStart} &&
                $GetParam{TicketCreateTimePointFormat}
            ) {
                my $Time = 0;
                if ($GetParam{TicketCreateTimePointFormat} eq 'minute') {
                    $Time = $GetParam{TicketCreateTimePoint};
                }
                elsif ($GetParam{TicketCreateTimePointFormat} eq 'hour') {
                    $Time = $GetParam{TicketCreateTimePoint} * 60;
                }
                elsif ($GetParam{TicketCreateTimePointFormat} eq 'day') {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24;
                }
                elsif ($GetParam{TicketCreateTimePointFormat} eq 'week') {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 7;
                }
                elsif ($GetParam{TicketCreateTimePointFormat} eq 'month') {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 30;
                }
                elsif ($GetParam{TicketCreateTimePointFormat} eq 'year') {
                    $Time = $GetParam{TicketCreateTimePoint} * 60 * 24 * 365;
                }
                if ($GetParam{TicketCreateTimePointStart} eq 'Before') {
                    $GetParam{TicketCreateTimeOlderMinutes} = $Time;
                }
                else {
                    $GetParam{TicketCreateTimeNewerMinutes} = $Time;
                }
            }
        }
        # free time
        foreach (1..6) {
            if (!$GetParam{'TicketFreeTime'.$_}) {
                foreach my $Type (qw(Year Month Day)) {
                    $GetParam{'TicketFreeTime'.$_.'Start'.$Type} = undef;
                    $GetParam{'TicketFreeTime'.$_.'Stop'.$Type} = undef;
                }
                $GetParam{'TicketFreeTime'.$_.'NewerDate'} = undef;
                $GetParam{'TicketFreeTime'.$_.'OlderDate'} = undef;
            }
            else {
                $GetParam{'TicketFreeTime'.$_} = 'checked';
                if ($GetParam{'TicketFreeTime'.$_.'StartDay'} &&
                    $GetParam{'TicketFreeTime'.$_.'StartMonth'} &&
                    $GetParam{'TicketFreeTime'.$_.'StartYear'}
                ) {
                    $GetParam{'TicketFreeTime'.$_.'NewerDate'} = $GetParam{'TicketFreeTime'.$_.'StartYear'}.
                        '-'.$GetParam{'TicketFreeTime'.$_.'StartMonth'}.
                        '-'.$GetParam{'TicketFreeTime'.$_.'StartDay'}.
                        ' 00:00:01';
                }
                if ($GetParam{'TicketFreeTime'.$_.'StopDay'} &&
                    $GetParam{'TicketFreeTime'.$_.'StopMonth'} &&
                    $GetParam{'TicketFreeTime'.$_.'StopYear'}
                ) {
                    $GetParam{'TicketFreeTime'.$_.'OlderDate'} = $GetParam{'TicketFreeTime'.$_.'StopYear'}.
                        '-'.$GetParam{'TicketFreeTime'.$_.'StopMonth'}.
                        '-'.$GetParam{'TicketFreeTime'.$_.'StopDay'}.
                        ' 23:59:59';
                }
            }
        }
        # focus of "From To Cc Subject Body"
        foreach (qw(From To Cc Subject Body)) {
            if (defined($GetParam{$_}) && $GetParam{$_} ne '') {
                $GetParam{$_} = "*$GetParam{$_}*";
            }
        }
        # perform ticket search
        my $Counter = 0;
        my @ViewableIDs = $Self->{TicketObjectSearch}->TicketSearch(
            Result => 'ARRAY',
            SortBy => $Self->{SortBy},
            OrderBy => $Self->{Order},
            Limit => $Self->{SearchLimit},
            UserID => $Self->{UserID},
            %GetParam,
        );

        my @CSVHead = ();
        my @CSVData = ();
        my @PDFData = ();
        foreach (@ViewableIDs) {
            $Counter++;
            # build search result
            if ($Counter >= $Self->{StartHit} && $Counter < ($Self->{SearchPageShown}+$Self->{StartHit}) ) {
                # get first article data
                my %Data = $Self->{TicketObjectSearch}->ArticleFirstArticle(TicketID => $_);
                # get whole article (if configured!)
                if ($Self->{Config}->{'SearchArticleCSVTree'} && $GetParam{ResultForm} eq 'CSV') {
                    my @Article = $Self->{TicketObjectSearch}->ArticleGet(
                        TicketID => $_
                    );
                    foreach my $Articles (@Article) {
                        if ($Articles->{Body}) {
                            $Data{ArticleTree} .= "\n-->||$Articles->{ArticleType}||$Articles->{From}||".
                                $Articles->{Created}."||<--------------\n".$Articles->{Body};
                        }
                    }
                }
                # customer info
                my %CustomerData = ();
                if ($Data{CustomerUserID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Data{CustomerUserID},
                    );
                }
                elsif ($Data{CustomerID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Data{CustomerID},
                    );
                }
                # customer info (customer name)
                if ($CustomerData{UserLogin}) {
                    $Data{CustomerName} = $Self->{CustomerUserObject}->CustomerName(
                        UserLogin => $CustomerData{UserLogin},
                    );
                }
                # user info
                my %UserInfo = $Self->{UserObject}->GetUserData(
                    User => $Data{Owner},
                    Cached => 1
                );
                # get age
                $Data{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Data{Age}, Space => ' ');
                # customer info string
                $UserInfo{CustomerName} = '('.$UserInfo{CustomerName}.')' if ($UserInfo{CustomerName});
                # generate ticket result
                if ($GetParam{ResultForm} eq 'Preview') {
                    # check if just a only html email
                    if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(
                        %Data,
                        Action => 'AgentTicketZoom',
                    )) {
                        $Data{TextNote} = $MimeTypeText;
                        $Data{Body} = '';
                    }
                    else {
                        # do some text quoting
                        $Data{Body} = $Self->{LayoutObject}->Ascii2Html(
                            NewLine => $Self->{ConfigObject}->Get('DefaultViewNewLine') || 85,
                            Text => $Data{Body},
                            VMax => $Self->{Config}->{SearchViewableTicketLines} || 15,
                            StripEmptyLines => 1,
                            HTMLResultMode => 1,
                        );
                        # do charset check
                        if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
                            Action => 'AgentTicketZoom',
                            ContentCharset => $Data{ContentCharset},
                            TicketID => $Data{TicketID},
                            ArticleID => $Data{ArticleID} )) {
                            $Data{TextNote} = $CharsetText;
                        }
                    }
                    # customer info string
                    $UserInfo{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
                        Data => \%CustomerData,
                        Max => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoQueueMaxSize'),
                    );
                    # do some html highlighting
                    my $HighlightStart = '<font color="orange"><b><i>';
                    my $HighlightEnd = '</i></b></font>';
                    if (%GetParam) {
                        foreach (qw(Body From To Subject)) {
                            if ($GetParam{$_}) {
                                $GetParam{$_} =~ s/(\*|\%)//g;
                                my @Parts = split('%', $GetParam{$_});
                                if ($Data{$_}) {
                                    foreach my $Part (@Parts) {
                                        $Data{$_} =~ s/($Part)/$HighlightStart$1$HighlightEnd/gi;
                                    }
                                }
                            }
                        }
                    }
                    foreach (qw(From To Subject)) {
                        if (!$GetParam{$_}) {
                            $Data{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Data{$_}, Max => 80);
                        }
                    }
                    # add ticket block
                    $Self->{LayoutObject}->Block(
                        Name => 'Record',
                        Data => {
                            %Data,
                            %UserInfo,
                        },
                    );
                    # add ticket title
                    if ($Self->{ConfigObject}->Get('Ticket::Frontend::Title')) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Title',
                            Data => {
                                %Data,
                                %UserInfo,
                            },
                        );
                    }
                }
                elsif ($GetParam{ResultForm} eq 'Print') {
                    if ($Self->{PDFObject}) {
                        my %Info = (%Data, %UserInfo),
                        my $Created = $Self->{LayoutObject}->Output(
                            Template => '$TimeLong{"$Data{"Created"}"}',
                            Data => \%Data,
                        );
                        my $Owner = $Self->{LayoutObject}->Output(
                            Template => '$QData{"Owner","30"} ($Quote{"$Data{"UserFirstname"} $Data{"UserLastname"}","30"})',
                            Data => \%Info
                        );
                        my $Customer = $Self->{LayoutObject}->Output(
                            Template => '$QData{"CustomerID","15"} $QData{"CustomerName","15"}',
                            Data => \%Data
                        );

                        my @PDFRow;
                        push (@PDFRow, $Data{TicketNumber});
                        push (@PDFRow, $Created);
                        push (@PDFRow, $Data{From});
                        push (@PDFRow, $Data{Subject});
                        push (@PDFRow, $Data{State});
                        push (@PDFRow, $Data{Queue});
                        push (@PDFRow, $Owner);
                        push (@PDFRow, $Customer);

                        push (@PDFData, \@PDFRow);
                    }
                    else {
                        # add table block
                        $Self->{LayoutObject}->Block(
                            Name => 'Record',
                            Data => {
                                %Data,
                                %UserInfo,
                            },
                        );
                    }
                }
                elsif ($GetParam{ResultForm} eq 'CSV') {
                    # merge row data
                    my %Info = (
                        %Data,
                        %UserInfo,
                        AccountedTime => $Self->{TicketObjectSearch}->TicketAccountedTimeGet(TicketID => $_),
                    );
                    # csv quote
                    if (!@CSVHead) {
                        @CSVHead = @{$Self->{Config}->{SearchCSVData}};
                    }
                    my @Data = ();
                    foreach (@CSVHead) {
                        push (@Data, $Info{$_});
                    }
                    push (@CSVData, \@Data);
                }
                else {
                    # condense down the subject
                    my $Subject = $Self->{TicketObject}->TicketSubjectClean(
                        TicketNumber => $Data{TicketNumber},
                        Subject => $Data{Subject} || '',
                    );
                    # add table block
                    $Self->{LayoutObject}->Block(
                        Name => 'Record',
                        Data => {
                            %Data,
                            Subject => $Subject,
                            %UserInfo,
                        },
                    );
                }
            }
        }
        # start html page
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # build search navigation bar
        my %PageNav = $Self->{LayoutObject}->PageNavBar(
            Limit => $Self->{SearchLimit},
            StartHit => $Self->{StartHit},
            PageShown => $Self->{SearchPageShown},
            AllHits => $Counter,
            Action => "Action=AgentTicketSearch&Subaction=Search",
            Link => "Profile=$Self->{Profile}&SortBy=$Self->{SortBy}&Order=$Self->{Order}&TakeLastSearch=1&",
        );
        # build shown ticket
        if ($GetParam{ResultForm} eq 'Preview') {
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketSearchResult',
                Data => { %Param, %PageNav, Profile => $Self->{Profile}, },
            );
        }
        elsif ($GetParam{ResultForm} eq 'Print') {
            # PDF Output
            if ($Self->{PDFObject}) {
                my $Title = $Self->{LayoutObject}->{LanguageObject}->Get('Ticket') . ' ' .
                    $Self->{LayoutObject}->{LanguageObject}->Get('Search');
                my $PrintedBy = $Self->{LayoutObject}->{LanguageObject}->Get('printed by');
                my $Page = $Self->{LayoutObject}->{LanguageObject}->Get('Page');
                my $Time = $Self->{LayoutObject}->Output(Template => '$Env{"Time"}');
                my $Url = '';
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
                $CellData->[0]->[0]->{Content} = $Self->{ConfigObject}->Get('Ticket::Hook');
                $CellData->[0]->[0]->{Font} = 'HelveticaBold';
                $CellData->[0]->[1]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('Created');
                $CellData->[0]->[1]->{Font} = 'HelveticaBold';
                $CellData->[0]->[2]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('From');
                $CellData->[0]->[2]->{Font} = 'HelveticaBold';
                $CellData->[0]->[3]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('Subject');
                $CellData->[0]->[3]->{Font} = 'HelveticaBold';
                $CellData->[0]->[4]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('State');
                $CellData->[0]->[4]->{Font} = 'HelveticaBold';
                $CellData->[0]->[5]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('Queue');
                $CellData->[0]->[5]->{Font} = 'HelveticaBold';
                $CellData->[0]->[6]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('Owner');
                $CellData->[0]->[6]->{Font} = 'HelveticaBold';
                $CellData->[0]->[7]->{Content} = $Self->{LayoutObject}->{LanguageObject}->Get('CustomerID');
                $CellData->[0]->[7]->{Font} = 'HelveticaBold';
                # create the content array
                my $CounterRow = 1;
                foreach my $Row (@PDFData) {
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
                $PageParam{HeaderRight} = $Title;
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
                    # stop output or another page
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
                my $Filename = 'ticket_search';
                my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->SystemTime(),
                );
                $M = sprintf("%02d", $M);
                $D = sprintf("%02d", $D);
                $h = sprintf("%02d", $h);
                $m = sprintf("%02d", $m);
                my $PDFString = $Self->{PDFObject}->DocumentOutput();
                return $Self->{LayoutObject}->Attachment(
                    Filename => $Filename."_"."$Y-$M-$D"."_"."$h-$m.pdf",
                    ContentType => "application/pdf",
                    Content => $PDFString,
                    Type => 'attachment',
                );
            }
            else {
                $Output = $Self->{LayoutObject}->PrintHeader(Width => 800);
                if (@ViewableIDs == $Self->{SearchLimit}) {
                    $Param{Warning} = '$Text{"Reached max. count of %s search hits!", "'.$Self->{SearchLimit}.'"}';
                }
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketSearchResultPrint',
                    Data => \%Param,
                );
                # add footer
                $Output .= $Self->{LayoutObject}->PrintFooter();
                # return output
                return $Output;
            }
        }
        elsif ($GetParam{ResultForm} eq 'CSV') {
            my $CSV = $Self->{LayoutObject}->OutputCSV(
                Head => \@CSVHead,
                Data => \@CSVData,
            );
            # return csv to download
            my $CSVFile = 'ticket_search';
            my ($s,$m,$h, $D,$M,$Y) = $Self->{TimeObject}->SystemTime2Date(
                SystemTime => $Self->{TimeObject}->SystemTime(),
            );
            $M = sprintf("%02d", $M);
            $D = sprintf("%02d", $D);
            $h = sprintf("%02d", $h);
            $m = sprintf("%02d", $m);
            return $Self->{LayoutObject}->Attachment(
                Filename => $CSVFile."_"."$Y-$M-$D"."_"."$h-$m.csv",
                ContentType => "text/csv",
                Content => $CSV,
            );
        }
        else {
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentTicketSearchResultShort',
                Data => { %Param, %PageNav, Profile => $Self->{Profile}, },
            );
        }
        # build footer
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # empty search site
    else {
        # delete profile
        if ($Self->{EraseTemplate} && $Self->{Profile}) {
            # remove old profile stuff
            $Self->{SearchProfileObject}->SearchProfileDelete(
                Base => 'TicketSearch',
                Name => $Self->{Profile},
                UserLogin => $Self->{UserLogin},
            );
            %GetParam = ();
            $Self->{Profile} = '';
        }
        # generate search mask
        my $Output = $Self->{LayoutObject}->Header();
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..16) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                Type => "TicketFreeKey$_",
                FillUp => 1,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                Type => "TicketFreeText$_",
                FillUp => 1,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            NullOption => 1,
            Ticket => \%GetParam,
            Config => \%TicketFreeText,
        );
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        $Output .= $Self->MaskForm(
            %GetParam,
            %TicketFreeTextHTML,
            Profile => $Self->{Profile},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub MaskForm {
    my $Self = shift;
    my %Param = @_;
    # get user of own groups
    my %ShownUsers = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    if ($Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone')) {
        %ShownUsers = %AllGroupsMembers;
    }
    else {
        my @Involved = $Self->{GroupObject}->GroupMemberInvolvedList(
            UserID => $Self->{UserID},
            Type => 'ro',
        );
        foreach (@Involved) {
            $ShownUsers{$_} = $AllGroupsMembers{$_};
        }
    }
    $Param{'UserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%ShownUsers,
        Name => 'OwnerIDs',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{OwnerIDs},
    );
    $Param{'CreatedUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%ShownUsers,
        Name => 'CreatedUserIDs',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{CreatedUserIDs},
    );
    $Param{'ResultFormStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            Preview => 'Preview',
            Normal => 'Normal',
            Print => 'Print',
            CSV => 'CSV',
        },
        Name => 'ResultForm',
        SelectedID => $Param{ResultForm} || 'Normal',
    );
    $Param{'ProfilesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            '',
            '-',
            $Self->{SearchProfileObject}->SearchProfileList(
                Base => 'TicketSearch',
                UserLogin => $Self->{UserLogin},
            ),
        },
        Name => 'Profile',
        SelectedID => $Param{Profile},
    );
    $Param{'StatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{StateObject}->StateList(
                UserID => $Self->{UserID},
                Action => $Self->{Action},
            ),
        },
        Name => 'StateIDs',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{StateIDs},
    );
    my %AllQueues = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
        Type => 'ro',
    );
    $Param{'QueuesStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => \%AllQueues,
        Size => 5,
        Multiple => 1,
        Name => 'QueueIDs',
        SelectedIDRefArray => $Param{QueueIDs},
        OnChangeSubmit => 0,
    );
    $Param{'CreatedQueuesStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => \%AllQueues,
        Size => 5,
        Multiple => 1,
        Name => 'CreatedQueueIDs',
        SelectedIDRefArray => $Param{CreatedQueueIDs},
        OnChangeSubmit => 0,
    );
    $Param{'PriotitiesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{PriorityObject}->PriorityList(
                UserID => $Self->{UserID},
                Action => $Self->{Action},
            ),
        },
        Name => 'PriorityIDs',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{PriorityIDs},
    );
    $Param{'TicketCreateTimePoint'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            1 => ' 1',
            2 => ' 2',
            3 => ' 3',
            4 => ' 4',
            5 => ' 5',
            6 => ' 6',
            7 => ' 7',
            8 => ' 8',
            9 => ' 9',
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
        Name => 'TicketCreateTimePoint',
        SelectedID => $Param{TicketCreateTimePoint},
    );
    $Param{'TicketCreateTimePointStart'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            'Last' => 'last',
            'Before' => 'before',
        },
        Name => 'TicketCreateTimePointStart',
        SelectedID => $Param{TicketCreateTimePointStart} || 'Last',
    );
    $Param{'TicketCreateTimePointFormat'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            minute => 'minute(s)',
            hour => 'hour(s)',
            day => 'day(s)',
            week => 'week(s)',
            month => 'month(s)',
            year => 'year(s)',
        },
        Name => 'TicketCreateTimePointFormat',
        SelectedID => $Param{TicketCreateTimePointFormat},
    );
    $Param{TicketCreateTimeStart} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'TicketCreateTimeStart',
        Format => 'DateInputFormat',
        DiffTime => -((60*60*24)*30),
    );
    $Param{TicketCreateTimeStop} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Prefix => 'TicketCreateTimeStop',
        Format => 'DateInputFormat',
    );
    foreach (1..6) {
        $Param{'TicketFreeTime'.$_.'Start'} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => 'TicketFreeTime'.$_.'Start',
            Format => 'DateInputFormat',
            DiffTime => -((60*60*24)*30),
        );
        $Param{'TicketFreeTime'.$_.'Stop'} = $Self->{LayoutObject}->BuildDateSelection(
            %Param,
            Prefix => 'TicketFreeTime'.$_.'Stop',
            Format => 'DateInputFormat',
            DiffTime => +((60*60*24)*30),
        );
    }
    # html search mask output
    $Self->{LayoutObject}->Block(
        Name => 'Search',
        Data => {
            %Param,
        },
    );
    my $Count = 0;
    foreach (1..16) {
        $Count++;
        if ($Self->{Config}->{'TicketFreeText'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText',
                Data => {
                    TicketFreeKeyField => $Param{'TicketFreeKeyField'.$Count},
                    TicketFreeTextField => $Param{'TicketFreeTextField'.$Count},
                    Count => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText'.$Count,
                Data => {
                    %Param,
                },
            );
        }
    }
    $Count = 0;
    foreach (1..6) {
        $Count++;
        if ($Self->{Config}->{'TicketFreeTime'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get('TicketFreeTimeKey'.$Count),
                    TicketFreeTime => $Param{'TicketFreeTime'.$Count},
                    TicketFreeTimeStart => $Param{'TicketFreeTime'.$Count.'Start'},
                    TicketFreeTimeStop => $Param{'TicketFreeTime'.$Count.'Stop'},
                    Count => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime'.$Count,
                Data => {
                    %Param,
                    Count => $Count,
                },
            );
        }
    }
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketSearch',
        Data => \%Param,
    );
    return $Output;
}

1;