# --
# Kernel/Modules/AgentLookup.pm - a generic lookup module
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentLookup.pm,v 1.1 2004-04-26 11:15:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentLookup;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(TicketObject ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # check needed params 
    foreach (qw(What Source)) {
        $Param{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        if (!$Param{$_}) {
            # error page
            my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Need Param '$_'!",
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # max shown entries in a search list
    $Self->{Map} = $Self->{ConfigObject}->Get('DataLookup'); 
    if (!$Self->{Map}->{$Param{Source}}) {
        # error page
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "Need '$Param{Source}' as DataLookup config option!",
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # config options
    $Self->{Limit} = $Self->{Map}->{$Param{Source}}->{ResultLimit} || 250;
    $Self->{Table} = $Self->{Map}->{$Param{Source}}->{Params}->{Table} || die "Need DataLookup->$Param{Source}->Params->Table in Kernel/Config.pm!";
    $Self->{Key} = $Self->{Map}->{$Param{Source}}->{Key} || die "Need DataLookup->$Param{Source}->Key in Kernel/Config.pm!";
    $Self->{Value} = $Self->{Map}->{$Param{Source}}->{Value} || die "Need DataLookup->$Param{Source}->Value in Kernel/Config.pm!";
    $Self->{SearchPrefix} = $Self->{Map}->{$Param{Source}}->{SearchPrefix}; 
    if (!defined($Self->{SearchPrefix})) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{Map}->{$Param{Source}}->{SearchSuffix};
    if (!defined($Self->{SearchSuffix})) {
        $Self->{SearchSuffix} = '*';
    }
    # create new db connect if DSN is given
    if ($Self->{Map}->{$Param{Source}}->{Params}->{DSN}) {
        $Self->{DBObject} = Kernel::System::DB->new(
            LogObject => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            DatabaseDSN => $Self->{Map}->{$Param{Source}}->{Params}->{DSN},
            DatabaseUser => $Self->{Map}->{$Param{Source}}->{Params}->{User},
            DatabasePw => $Self->{Map}->{$Param{Source}}->{Params}->{Password},
        ) || die $DBI::errstr;
        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }
    # get data list
    my $Search = $Self->{ParamObject}->GetParam(Param => 'Search');
    my %Result = ();
    if ($Search) {
        my $SearchDB = $Self->{SearchPrefix}.$Search.$Self->{SearchSuffix};
        $SearchDB =~ s/\*/%/g;
        $SearchDB =~ s/%%/%/g;
        # build SQL string
        my $SQL = "SELECT $Self->{Key}, $Self->{Value} FROM $Self->{Table} WHERE $Self->{Key} LIKE '".$Self->{DBObject}->Quote($SearchDB)."'";
        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 100);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Result{$Row[0]} = $Row[0];
        }
    }
    # start with page ...
    $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Lookup', Type => 'Small');
    $Output .= $Self->_Mask(
        List => \%Result,
        Search => $Search,
        %Param,
    );
    $Output .= $Self->{LayoutObject}->Footer(Type => 'Small');
    return $Output;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # do html quoteing
    my %List = %{$Param{List}};
    foreach (sort {$List{$a} cmp $List{$b}} keys %List) {
        my $QuoteData = $Self->{LayoutObject}->Ascii2Html(Text => $List{$_});
        $Param{Table} .= '<tr><td><a href="" onclick="updateMessage(\''.$QuoteData.'\');">'.$QuoteData."</a></td></tr>";
    }
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentLookup', Data => \%Param);
}
# --
sub DESTROY {
    my $Self = shift;
    # disconnect if it's not a parent DBObject
    if ($Self->{NotParentDBObject}) {
        $Self->{DBObject}->Disconnect();
    }
}   
# --
1;
