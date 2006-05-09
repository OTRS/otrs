# --
# Kernel/Modules/AgentLookup.pm - a generic lookup module
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentLookup.pm,v 1.6.2.1 2006-05-09 14:53:46 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentLookup;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6.2.1 $';
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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
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
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need Param '$_'!",
            );
        }
    }
    # max shown entries in a search list
    $Self->{Map} = $Self->{ConfigObject}->Get('DataLookup');
    if (!$Self->{Map}->{$Param{Source}}) {
        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need '$Param{Source}' as DataLookup config option!",
        );
    }
    # config options
    $Self->{Limit} = $Self->{Map}->{$Param{Source}}->{ResultLimit} || 250;
    $Self->{Table} = $Self->{Map}->{$Param{Source}}->{Params}->{Table} || die "Need DataLookup->$Param{Source}->Params->Table in Kernel/Config.pm!";
    $Self->{KeyList} = $Self->{Map}->{$Param{Source}}->{KeyList} || die "Need DataLookup->$Param{Source}->KeyList in Kernel/Config.pm!";
    $Self->{ValueList} = $Self->{Map}->{$Param{Source}}->{ValueList} || die "Need DataLookup->$Param{Source}->ValueList in Kernel/Config.pm!";
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
        );
        if (!$Self->{DBObject}) {
            $Self->{LayoutObject}->FatalError();
        }
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
        my $SQL = "SELECT ";
        my $What = '';
        foreach my $Entry (@{$Self->{KeyList}}) {
            if ($What) {
                $What .= ', ';
            }
            $What .= $Entry;
        }
        $SQL .= $What;
        $SQL .= " FROM $Self->{Table} WHERE ";
        my $Where = '';
        foreach my $Entry (@{$Self->{KeyList}}) {
            if ($Where) {
                $Where .= ' OR ';
            }
            $Where .= " $Entry LIKE '".$Self->{DBObject}->Quote($SearchDB)."'";
        }
        $SQL .= $Where;
        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 100);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            my $KeyValue = '';
            foreach (0..8) {
                if ($Row[$_]) {
                    $KeyValue .= $Row[$_].';';
                }
            }
            $Result{$KeyValue} = $KeyValue;
        }
    }
    # start with page ...
    $Output .= $Self->{LayoutObject}->Header(Area => 'Ticket', Title => 'Lookup', Type => 'Small');
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
