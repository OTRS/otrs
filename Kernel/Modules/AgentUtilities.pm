# --
# Kernel/Modules/AgentUtilities.pm - Utilities for tickets
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentUtilities.pm,v 1.32 2003-12-03 22:57:16 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentUtilities;

use strict;
use Kernel::System::CustomerUser;
    
use vars qw($VERSION);
$VERSION = '$Revision: 1.32 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
    
# --
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # get confid data
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 1;
    $Self->{SearchLimit} = $Self->{ConfigObject}->Get('SearchLimit') || 200;
    $Self->{SearchPageShown} = $Self->{ConfigObject}->Get('SearchPageShown') || 40;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam(Param => 'SortBy') || 'Age';
    $Self->{Order} = $Self->{ParamObject}->GetParam(Param => 'Order') || 'Down';
    $Self->{Profile} = $Self->{ParamObject}->GetParam(Param => 'Profile') || '';
    $Self->{SaveProfile} = $Self->{ParamObject}->GetParam(Param => 'SaveProfile') || '';
    $Self->{selecttemplate} = $Self->{ParamObject}->GetParam(Param => 'selecttemplate') || '';
    $Self->{erasetemplate} = $Self->{ParamObject}->GetParam(Param => 'erasetemplate') || '';
    # get params
    my %GetParam = ();
    my %DB = ();
    foreach (qw(Profile UserLogin)) {
        $DB{$_} = $Self->{DBObject}->Quote($Self->{$_});
    }
    foreach (qw(TicketNumber From To Cc Subject Body CustomerID CustomerUserLogin 
      Agent ResultForm TicketFreeText1 TicketFreeText2 ArticleFreeText1 
      ArticleFreeText2 ArticleFreeText3)) {
        # load profiles string params
        if ($Self->{Subaction} eq 'LoadProfile' && $Self->{Profile}) {
            my $SQL = "SELECT profile_value FROM search_profile".
              " WHERE ".
              " profile_name = '$DB{Profile}' AND ".
              " profile_key = '$_' AND ".
              " login = '$DB{UserLogin}'";
            $Self->{DBObject}->Prepare(SQL => $SQL);
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                $GetParam{$_} = $Row[0];
            }
        }
        # get search string params
        else {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
            # remove white space on the end
            if ($GetParam{$_}) {
                $GetParam{$_} =~ s/\s$//g;
            }
        }
    }
    foreach (qw(StateID StateTypeID QueueID PriorityID UserID)) {
        # load profile array params
        if ($Self->{Subaction} eq 'LoadProfile' && $Self->{Profile}) {
            my $SQL = "SELECT profile_value FROM search_profile".
              " WHERE ".
              " profile_name = '$DB{Profile}' AND ".
              " profile_key = '$_' AND ".
              " login = '$DB{UserLogin}'";
            $Self->{DBObject}->Prepare(SQL => $SQL);
            my @Array = ();
            while (my @Row = $Self->{DBObject}->FetchrowArray()) {
                push(@{$GetParam{$_}}, $Row[0]);
            }
        }
        # get search array params
        else {
            if ($Self->{ParamObject}->GetArray(Param => $_)) {
                if ($Self->{ParamObject}->GetArray(Param => $_)) {
                    @{$GetParam{$_}} = $Self->{ParamObject}->GetArray(Param => $_);
                }
            }
        }
    }
    # set result form env
    if (!$GetParam{ResultForm}) {
        $GetParam{ResultForm} = '';
    }
    if ($GetParam{ResultForm} eq 'Print' || $GetParam{ResultForm} eq 'CSV') {
        $Self->{SearchPageShown} = $Self->{SearchLimit}; 
    }
    # show result site
    if ($Self->{Subaction} eq 'Search' && !$Self->{erasetemplate}) {
        # save search profile
        if ($Self->{SaveProfile} && $Self->{Profile}) {
            # remove old profile stuff
            $Self->{DBObject}->Do(
                SQL => "DELETE FROM search_profile WHERE ".
                  "profile_name = '$DB{Profile}' AND login = '$DB{UserLogin}'",
            );
            # insert new profile params
            foreach my $Key (keys %GetParam) { 
              if ($GetParam{$Key}) {
                if (ref($GetParam{$Key}) eq 'ARRAY') {
                    foreach (@{$GetParam{$Key}}) {
                      my $SQL = "INSERT INTO search_profile (login, profile_name, ".
                        "profile_key, profile_value) VALUES ".
                        " ('$DB{UserLogin}', '$DB{Profile}', '$Key', '".
                        $Self->{DBObject}->Quote($_)."')";
                      $Self->{DBObject}->Do(SQL => $SQL);
                    } 
                }
                else {
                    my $SQL = "INSERT INTO search_profile (login, profile_name, ".
                      "profile_key, profile_value) VALUES ".
                      " ('$DB{UserLogin}', '$DB{Profile}', '$Key', '".
                        $Self->{DBObject}->Quote($GetParam{$Key})."')";
                    $Self->{DBObject}->Do(SQL => $SQL);
                }
              }
            }
        }
        # create sql statement
        my $SQL = '';
        my $ArticleLevel = 0;
        my %SearchParam = %GetParam;
        $Param{SearchLink} = '';
        if ($SearchParam{TicketNumber}) {
            $SearchParam{TicketNumber} =~ s/\*/%/g;
            $SQL .= " st.tn LIKE '$SearchParam{TicketNumber}' AND "; 
            $Param{SearchLink} .= "TicketNumber=$GetParam{TicketNumber}&";
        }
        my %IDFieldSQLMap = (
            StateID => 'st.ticket_state_id',
            QueueID => 'sq.id',
            PriorityID => 'st.ticket_priority_id',
            UserID => 'st.user_id',
        ); 
        foreach my $Key (keys %IDFieldSQLMap) {
            if ($SearchParam{$Key}) {
                my $CounterTmp = 0;
                $SQL .= " (";
                foreach (@{$SearchParam{$Key}}) {
                    if ($CounterTmp != 0) {
                        $SQL .= " or ";
                    }
                    $CounterTmp++;
                    $SQL .= " $IDFieldSQLMap{$Key} = $_ ";
                    $Param{SearchLink} .= "$Key=$_&";
                }
                $SQL .= " ) AND ";
            } 
        }
        my %FieldSQLMapFullText = (
            From => 'sa.a_from',
            To => 'sa.a_to',
            Cc => 'sa.a_cc',
            Subject => 'sa.a_subject',
            Body => 'sa.a_body',
        ); 
        foreach my $Key (keys %FieldSQLMapFullText) {
            if ($SearchParam{$Key}) {
                my $CounterTmp = 0;
                $SearchParam{$Key} =~ s/\*/%/gi;
                $SQL .= " $FieldSQLMapFullText{$Key} LIKE '\%$SearchParam{$Key}%' AND ";
                $Param{SearchLink} .= "$Key=$GetParam{$Key}&";
                $ArticleLevel = 1;
            } 
        }
        my %FieldSQLMap = (
            CustomerID => 'st.customer_id',
            CustomerUserLogin => 'st.customer_user_id',
            TicketFreeText1 => 'st.freetext1',
            TicketFreeText2 => 'st.freetext2',
            ArticleFreeText1 => 'sa.a_freetext1',
            ArticleFreeText2 => 'sa.a_freetext2',
            ArticleFreeText3 => 'sa.a_freetext3',
        ); 
        foreach my $Key (keys %FieldSQLMap) {
            if ($SearchParam{$Key}) {
                my $CounterTmp = 0;
                $SearchParam{$Key} =~ s/\*/%/gi;
                $SQL .= " $FieldSQLMap{$Key} LIKE '$SearchParam{$Key}' AND ";
                $Param{SearchLink} .= "$Key=$GetParam{$Key}&";
                $ArticleLevel = 1;
            } 
        }
        # get users groups
        my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type => 'ro',
            Result => 'ID',
        );
        # db query
        my $OutputTables = '';
        my $OutputTable = '';
        my $OrderSQL = ''; 
    
        if ($Self->{SortBy} eq 'Owner') {
            $OrderSQL .= " st.user_id ";
        }
        elsif ($Self->{SortBy} eq 'CustomerID') {
            $OrderSQL .= "st.customer_id";
        }
        elsif ($Self->{SortBy} eq 'State') {
            $OrderSQL .= "tsd.name";
        }
        elsif ($Self->{SortBy} eq 'Ticket') {
            $OrderSQL .= "st.tn";
        }
        elsif ($Self->{SortBy} eq 'Queue') {
            $OrderSQL .= "sq.name";
        }
        else {
            $OrderSQL .= "st.create_time_unix";
        }
        $Param{SearchLinkSortBy} .= "SortBy=$Self->{SortBy}&";
        # get not wanted article types
        my @ArticleTypeID = ();
        foreach (qw(email-notification-int email-notification-ext)) {
            if ($Self->{TicketObject}->ArticleTypeLookup(ArticleType => $_)) {
                push (@ArticleTypeID, $Self->{TicketObject}->ArticleTypeLookup(ArticleType => $_));
            }
        }
        if ($ArticleLevel) {
            $SQL = "SELECT DISTINCT st.id, $OrderSQL ".
              " FROM ".
              " article sa, ticket st, queue sq, ticket_state tsd ".
              " WHERE ".
              " sa.ticket_id = st.id ".
              " AND ".
              " st.ticket_state_id = tsd.id ".
              " AND ".
              " sa.article_type_id NOT IN (${\(join ', ', @ArticleTypeID)})".
              " AND $SQL"; 
$ArticleLevel = 0;
        }
        else {
            $SQL = "SELECT st.id ".
              " FROM ".
              " ticket st, queue sq, ticket_state tsd ".
              " WHERE ".
              " st.ticket_state_id = tsd.id ".
              " AND $SQL ";
        }
        $SQL .= " sq.id = st.queue_id ".
          " AND ".
          " sq.group_id IN ( ${\(join ', ', @GroupIDs)} )";

        $SQL .= " ORDER BY ".$OrderSQL." ";

        if ($Self->{Order} eq 'Up') {
            $SQL .= " ASC";
        }
        else {
            $SQL .= " DESC";
        }
        $Param{SearchLinkOrder} .= "Order=$Self->{Order}&Profile=$Self->{Profile}&ResultForm=$GetParam{ResultForm}&";

        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{SearchLimit});

        my @ViewableIDs = ();
        my $Counter = 0;
        while (my @Row = $Self->{DBObject}->FetchrowArray() ) {
             push (@ViewableIDs, $Row[0]);
        }
        foreach (@ViewableIDs) {
          $Counter++;
          # build search result
          if ($Counter >= $Self->{StartHit} && $Counter < ($Self->{SearchPageShown}+$Self->{StartHit}) ) {
            my @Index = $Self->{TicketObject}->GetArticleIndex(TicketID => $_);
            my %Data = $Self->{TicketObject}->GetArticle(ArticleID => $Index[0]);
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
            # generate ticket result
            if ($GetParam{ResultForm} eq 'Preview') {
                $Param{StatusTable} .= $Self->MaskPreviewResult(
                    %Data, 
                    CustomerData => \%CustomerData,
                    GetParam => \%GetParam,
                );
            }
            elsif ($GetParam{ResultForm} eq 'Print') {
                $Param{StatusTable} .= $Self->MaskPrintResult(
                    %Data, 
                    %UserInfo,
                    CustomerData => \%CustomerData,
                    GetParam => \%GetParam,
                );
            }
            elsif ($GetParam{ResultForm} eq 'CSV') {
                $Param{StatusTable} .= $Self->MaskCSVResult(
                    %Data, 
                    %UserInfo,
                );
            }
            else {
                # Condense down the subject
                my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
                my $Subject = $Data{Subject};
                $Subject =~ s/^RE://i;
                $Subject =~ s/\[${TicketHook}:\s*\d+\]//;

                $Param{StatusTable} .= $Self->MaskShortResult(
                    %Data,
                    Subject => $Subject,
                    %UserInfo,
                );
            }
          }
        }
        # html
        my $Output = $Self->{LayoutObject}->Header(Title => 'Utilities');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

        # build search navigation bar
        my $SearchNavBar = $Self->{LayoutObject}->PageNavBar(
          Limit => $Self->{SearchLimit}, 
          StartHit => $Self->{StartHit}, 
          SearchPageShown => $Self->{SearchPageShown},
          AllHits => $Counter,
          Action => "Action=AgentUtilities&Subaction=Search",
          Link => $Param{SearchLink}.$Param{SearchLinkSortBy}.$Param{SearchLinkOrder}, 
        );
        # build shown ticket
        if ($GetParam{ResultForm} eq 'Preview') {
            $Output .= $SearchNavBar.$Param{StatusTable};
        }
        elsif ($GetParam{ResultForm} eq 'Print') {
            $Output = $Self->{LayoutObject}->PrintHeader(Title => 'Result', Width => 800);
            if (@ViewableIDs == $Self->{SearchLimit}) {
                $Param{Warning} = '$Text{"Reached max. count of %s search hits!", "'.$Self->{SearchLimit}.'"}';
            }
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentUtilSearchResultPrint', 
                Data => \%Param,
            );
            # add footer 
            $Output .= $Self->{LayoutObject}->PrintFooter();
            # return output
            return $Output;
        }
        elsif ($GetParam{ResultForm} eq 'CSV') {
            # return csv to download
            my $CSVFile = 'search';
            my ($s,$m,$h, $D,$M,$Y, $wd,$yd,$dst) = localtime(time);
            $Y = $Y+1900;
            $M++;
            $M = sprintf("%02d", $M);
            $D = sprintf("%02d", $D);
            $h = sprintf("%02d", $h);
            $m = sprintf("%02d", $m);
            return $Self->{LayoutObject}->Attachment(
                Filename => $CSVFile."_"."$Y-$M-$D"."_"."$h-$m.csv",
                ContentType => "text/csv",
                Content => "\n".$Param{StatusTable},
            );
        }
        else {
            $Output .= $SearchNavBar.$Self->{LayoutObject}->Output(
                TemplateFile => 'AgentUtilSearchResultShort', 
                Data => \%Param,
            );
        }
        # build footer
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # empty search site
    else {
        # delete profile
        if ($Self->{erasetemplate} && $Self->{Profile}) {
            $Self->{DBObject}->Do(
                SQL => "DELETE FROM search_profile WHERE ".
                  "profile_name = '$DB{Profile}' AND login = '$DB{UserLogin}'",
            );
            %GetParam = ();
            $Self->{Profile} = '';
        }
        # set profile to zero
        elsif (!$Self->{selecttemplate}) {
            $Self->{Profile} = '';
        }
        # generate search mask
        my $Output = $Self->{LayoutObject}->Header(Title => 'Utilities');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        $Output .= $Self->MaskForm(
            %GetParam, 
            Profile => $Self->{Profile}, 
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub MaskForm {
    my $Self = shift;
    my %Param = @_;
    # --
    # get user of own groups
    # --
    my %ShownUsers = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    if ($Self->{ConfigObject}->Get('ChangeOwnerToEveryone')) {
        %ShownUsers = %AllGroupsMembers;
    }
    else {
        my %Groups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type => 'rw',
            Result => 'HASH',
        );
        foreach (keys %Groups) {
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $_,
                Type => 'rw',
                Result => 'HASH',
            );
            foreach (keys %MemberList) {
                $ShownUsers{$_} = $AllGroupsMembers{$_};
            }
        }
    }
    $Param{'UserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%ShownUsers, 
        Name => 'UserID',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{UserID},
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
        Data => { '', '-', $Self->{DBObject}->GetTableData(
                      What => 'profile_name, profile_name',
                      Table => 'search_profile',
                      Where => "login = '$Self->{UserLogin}'",
                    ) }, 
        Name => 'Profile',
        SelectedID => $Param{Profile},
    );
    $Param{'StatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{DBObject}->GetTableData(
                      What => 'id, name',
                      Table => 'ticket_state',
                      Valid => 1,
                    ) }, 
        Name => 'StateID',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{StateID},
    );
    $Param{'StateTypesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{DBObject}->GetTableData(
                      What => 'id, name',
                      Table => 'ticket_state_type',
                    ) }, 
        Name => 'StateTypeID',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{StateTypeID},
    );
    my %MoveQueues = $Self->{QueueObject}->GetAllQueues(
        UserID => $Self->{UserID},
        Type => 'move',
    );
    $Param{'QueuesStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => \%MoveQueues,
        Size => 5,
        Multiple => 1,
        Name => 'QueueID',
        SelectedIDRefArray => $Param{QueueID},
        OnChangeSubmit => 0,
    );
    $Param{'PriotitiesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{DBObject}->GetTableData(
                      What => 'id, name',
                      Table => 'ticket_priority',
                    ) },
        Name => 'PriorityID',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{PriorityID},
    );

    my $Output = $Self->{LayoutObject}->Output(TemplateFile => 'AgentUtilSearch', Data => \%Param);
    $Output .= $Self->{LayoutObject}->Output(TemplateFile => 'AgentUtilSearchByCustomerID', Data => \%Param);
    return $Output;
}
# --
sub MaskPreviewResult {
    my $Self = shift;
    my %Param = @_;
    # check if just a only html email
    if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(
        %Param,
        Action => 'AgentZoom',
    )) {
        $Param{TextNote} = $MimeTypeText;
        $Param{Body} = '';
    }
    else {
        # charset convert
#        $Param{Body} = $Self->{LayoutObject}->{LanguageObject}->CharsetConvert(
#            Text => $Param{Body},
#            From => $Param{ContentCharset},
#        );
        # do some text quoting
        $Param{Body} = $Self->{LayoutObject}->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
            Text => $Param{Body},
            VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesBySearch') || 15,
            StripEmptyLines => 1,
            HTMLResultMode => 1,
        );
        # do charset check
        if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
            Action => 'AgentZoom',
            ContentCharset => $Param{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Param{ArticleID} )) {
            $Param{TextNote} = $CharsetText;
        }
    }
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    # customer info string 
    $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => $Self->{ConfigObject}->Get('ShowCustomerInfoQueueMaxSize'),
    );
    # do some html highlighting
    my $HighlightStart = '<font color="orange"><b><i>';
    my $HighlightEnd = '</i></b></font>';
    if ($Param{GetParam}) {
        foreach (qw(Body From To Subject)) {
          if ($Param{GetParam}->{$_}) {
            my @SParts = split('%', $Param{GetParam}->{$_});
            if ($Param{$_}) {
                $Param{$_} =~ s/(${\(join('|', @SParts))})/$HighlightStart$1$HighlightEnd/gi;
            }
          }
        }
    }
    foreach (qw(From To Subject)) {
        if (!$Param{GetParam}->{$_}) {
            $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_}, Max => 80);
        } 
    }
    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentUtilSearchResult', 
        Data => \%Param,
    );
}
# --
sub MaskShortResult {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    # customer info string 
    $Param{CustomerName} = '('.$Param{CustomerName}.')' if ($Param{CustomerName});
    foreach (qw(From To Cc Subject)) {
#        $Param{$_} = $Self->{LayoutObject}->{LanguageObject}->CharsetConvert(
#            Text => $Param{$_},
#            From => $Param{ContentCharset},
#        );
    }
    # create & return output
    if (!$Param{Answered}) {
        return $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentUtilSearchResultShortTableNotAnswered', 
            Data => \%Param,
        );
    } else {
        return $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentUtilSearchResultShortTable', 
            Data => \%Param,
        );
    }
}
# --
sub MaskCSVResult {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    # customer info string 
    $Param{CustomerName} = '('.$Param{CustomerName}.')' if ($Param{CustomerName});
    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentUtilSearchResultCSV', 
        Data => \%Param,
    );
}
# --
sub MaskPrintResult {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    # customer info string 
    $Param{CustomerName} = '('.$Param{CustomerName}.')' if ($Param{CustomerName});
    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentUtilSearchResultPrintTable', 
        Data => \%Param,
    );
}
# --
1;
