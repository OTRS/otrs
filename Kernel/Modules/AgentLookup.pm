# --
# Kernel/Modules/AgentLookup.pm - a generic lookup module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentLookup.pm,v 1.19 2009-02-16 11:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentLookup;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.19 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(TicketObject ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # check needed params
    for (qw(What Source)) {
        $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ );
        if ( !$Param{$_} ) {

            # error page
            return $Self->{LayoutObject}->ErrorScreen( Message => "Need Param '$_'!", );
        }
    }

    # max shown entries in a search list
    $Self->{Map} = $Self->{ConfigObject}->Get('DataLookup');
    if ( !$Self->{Map}->{ $Param{Source} } ) {

        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need '$Param{Source}' as DataLookup config option!",
        );
    }

    # config options
    $Self->{Limit} = $Self->{Map}->{ $Param{Source} }->{ResultLimit} || 250;
    $Self->{Table} = $Self->{Map}->{ $Param{Source} }->{Params}->{Table}
        || $Self->{LayoutObject}->FatalError(
        Message => "Need DataLookup->$Param{Source}->Params->Table in Kernel/Config.pm!"
        );
    $Self->{KeyList} = $Self->{Map}->{ $Param{Source} }->{KeyList}
        || $Self->{LayoutObject}->FatalError(
        Message => "Need DataLookup->$Param{Source}->KeyList in Kernel/Config.pm!"
        );
    $Self->{ValueList} = $Self->{Map}->{ $Param{Source} }->{ValueList}
        || $Self->{LayoutObject}->FatalError(
        Message => "Need DataLookup->$Param{Source}->ValueList in Kernel/Config.pm!"
        );
    $Self->{SearchPrefix} = $Self->{Map}->{ $Param{Source} }->{SearchPrefix};
    if ( !defined( $Self->{SearchPrefix} ) ) {
        $Self->{SearchPrefix} = '';
    }
    $Self->{SearchSuffix} = $Self->{Map}->{ $Param{Source} }->{SearchSuffix};
    if ( !defined( $Self->{SearchSuffix} ) ) {
        $Self->{SearchSuffix} = '*';
    }

    # create new db connect if DSN is given
    if ( $Self->{Map}->{ $Param{Source} }->{Params}->{DSN} ) {
        $Self->{DBObject} = Kernel::System::DB->new(
            LogObject    => $Self->{LogObject},
            ConfigObject => $Self->{ConfigObject},
            MainObject   => $Self->{MainObject},
            DatabaseDSN  => $Self->{Map}->{ $Param{Source} }->{Params}->{DSN},
            DatabaseUser => $Self->{Map}->{ $Param{Source} }->{Params}->{User},
            DatabasePw   => $Self->{Map}->{ $Param{Source} }->{Params}->{Password},
        );
        if ( !$Self->{DBObject} ) {
            $Self->{LayoutObject}->FatalError();
        }

        # remember that we have the DBObject not from parent call
        $Self->{NotParentDBObject} = 1;
    }

    # get data list
    my $Search = $Self->{ParamObject}->GetParam( Param => 'Search' );
    my %Result = ();
    if ($Search) {
        my $SearchDB = $Self->{SearchPrefix} . $Search . $Self->{SearchSuffix};
        $SearchDB =~ s/\*/%/g;
        $SearchDB =~ s/%%/%/g;

        # build SQL string
        my $SQL  = "SELECT ";
        my $What = '';
        for my $Entry ( @{ $Self->{KeyList} } ) {
            if ($What) {
                $What .= ', ';
            }
            $What .= $Entry;
        }
        $SQL .= $What;
        $SQL .= " FROM $Self->{Table} WHERE ";
        my $Where = '';
        for my $Entry ( @{ $Self->{KeyList} } ) {
            if ($Where) {
                $Where .= ' OR ';
            }
            $Where .= " $Entry LIKE '" . $Self->{DBObject}->Quote( $SearchDB, 'Like' ) . "'";
        }
        $SQL .= $Where;
        $Self->{DBObject}->Prepare( SQL => $SQL, Limit => 100 );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            my $KeyValue = '';
            for ( 0 .. 8 ) {
                if ( $Row[$_] ) {
                    $KeyValue .= $Row[$_] . ';';
                }
            }
            $Result{$KeyValue} = $KeyValue;
        }
    }

    # start with page ...
    $Output
        .= $Self->{LayoutObject}->Header( Area => 'Ticket', Title => 'Lookup', Type => 'Small' );
    $Output .= $Self->_Mask(
        List   => \%Result,
        Search => $Search,
        %Param,
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );
    return $Output;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # do html quoteing
    my %List = %{ $Param{List} };
    for ( sort { $List{$a} cmp $List{$b} } keys %List ) {
        my $QuoteData = $Self->{LayoutObject}->Ascii2Html( Text => $List{$_} );
        $Param{Table}
            .= '<tr><td><a href="" onclick="updateMessage(\''
            . $QuoteData
            . '\');">'
            . $QuoteData
            . "</a></td></tr>";
    }

    # create & return output
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentLookup', Data => \%Param );
}

sub DESTROY {
    my $Self = shift;

    # disconnect if it's not a parent DBObject
    if ( $Self->{NotParentDBObject} ) {
        $Self->{DBObject}->Disconnect();
    }
    return 1;
}

1;
