# --
# Kernel/Modules/AdminPostMasterFilter.pm - to add/update/delete filters
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminPostMasterFilter;

use strict;
use warnings;

use Kernel::System::DynamicField;
use Kernel::System::PostMaster::Filter;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{PostMasterFilter}   = Kernel::System::PostMaster::Filter->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Name           = $Self->{ParamObject}->GetParam( Param => 'Name' );
    my $OldName        = $Self->{ParamObject}->GetParam( Param => 'OldName' );
    my $StopAfterMatch = $Self->{ParamObject}->GetParam( Param => 'StopAfterMatch' ) || 0;
    my %GetParam = ();
    for my $Number ( 1 .. 12 ) {
        $GetParam{"MatchHeader$Number"}
            = $Self->{ParamObject}->GetParam( Param => "MatchHeader$Number" );
        $GetParam{"MatchValue$Number"}
            = $Self->{ParamObject}->GetParam( Param => "MatchValue$Number" );
        $GetParam{"SetHeader$Number"}
            = $Self->{ParamObject}->GetParam( Param => "SetHeader$Number" );
        $GetParam{"SetValue$Number"} = $Self->{ParamObject}->GetParam( Param => "SetValue$Number" );
    }

    # ------------------------------------------------------------ #
    # delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Delete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        if ( !$Self->{PostMasterFilter}->FilterDelete( Name => $Name ) ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {
        return $Self->_MaskUpdate( Data => {} );
    }

    # ------------------------------------------------------------ #
    # update
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Update' ) {
        my %Data = $Self->{PostMasterFilter}->FilterGet( Name => $Name );
        if ( !%Data ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => "No such filter: $Name" );
        }
        return $Self->_MaskUpdate(
            Name => $Name,
            Data => \%Data,
        );
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdateAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my %Match = ();
        my %Set   = ();
        for my $Number ( 1 .. 12 ) {
            if ( $GetParam{"MatchHeader$Number"} && $GetParam{"MatchValue$Number"} ) {
                $Match{ $GetParam{"MatchHeader$Number"} } = $GetParam{"MatchValue$Number"};
            }
            if ( $GetParam{"SetHeader$Number"} && $GetParam{"SetValue$Number"} ) {
                $Set{ $GetParam{"SetHeader$Number"} } = $GetParam{"SetValue$Number"};
            }
        }
        my %Errors = ();
        if (%Match) {
            my $InvalidCount = 0;
            for my $MatchKey ( sort keys %Match ) {
                $InvalidCount++;
                my $MatchValue = $Match{$MatchKey};
                if ( !eval { my $Regex = qr/$MatchValue/; 1; } ) {
                    $Errors{"MatchHeader${InvalidCount}Invalid"} = 'ServerError';
                    $Errors{"MatchValue${InvalidCount}Invalid"}  = 'ServerError';
                }
            }
        }
        else {
            $Errors{"MatchHeader1Invalid"} = 'ServerError';
            $Errors{"MatchValue1Invalid"}  = 'ServerError';
        }

        if (%Set) {
            my $InvalidCount = 0;
            for my $SetKey ( sort keys %Set ) {
                $InvalidCount++;
                if ( !defined $Set{$SetKey} ) {
                    $Errors{"SetHeader${InvalidCount}Invalid"} = 'ServerError';
                    $Errors{"SetValue${InvalidCount}Invalid"}  = 'ServerError';
                }
            }
        }
        else {
            $Errors{"SetHeader1Invalid"} = 'ServerError';
            $Errors{"SetValue1Invalid"}  = 'ServerError';
        }

        # Name validation
        if ( $Name eq '' ) {
            $Errors{"NameInvalid"} = 'ServerError';
        }

        if (%Errors) {
            return $Self->_MaskUpdate(
                Name => $Name,
                Data => {
                    %Errors,
                    Name           => $Name,
                    Set            => \%Set,
                    Match          => \%Match,
                    StopAfterMatch => $StopAfterMatch,
                },
            );
        }
        $Self->{PostMasterFilter}->FilterDelete( Name => $OldName );
        $Self->{PostMasterFilter}->FilterAdd(
            Name           => $Name,
            Match          => \%Match,
            Set            => \%Set,
            StopAfterMatch => $StopAfterMatch,
        );
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {
        my %List = $Self->{PostMasterFilter}->FilterList();

        $Self->{LayoutObject}->Block(
            Name => 'Overview',
            Data => { %Param, },
        );
        $Self->{LayoutObject}->Block( Name => 'ActionList' );
        $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
            Data => { %Param, },
        );
        if (%List) {
            for my $Key ( sort keys %List ) {
                $Self->{LayoutObject}->Block(
                    Name => 'OverviewResultRow',
                    Data => { Name => $Key, },
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'NoDataFoundMsg',
                Data => {},
            );
        }

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminPostMasterFilter',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _MaskUpdate {
    my ( $Self, %Param ) = @_;

    my %Data    = %{ $Param{Data} };
    my $Counter = 0;
    if ( $Data{Match} ) {
        for my $MatchKey ( sort keys %{ $Data{Match} } ) {
            if ( $MatchKey && $Data{Match}->{$MatchKey} ) {
                $Counter++;
                $Data{"MatchValue$Counter"}  = $Data{Match}->{$MatchKey};
                $Data{"MatchHeader$Counter"} = $MatchKey;
            }
        }
    }
    $Counter = 0;
    if ( $Data{Set} ) {
        for my $SetKey ( sort keys %{ $Data{Set} } ) {
            if ( $SetKey && $Data{Set}->{$SetKey} ) {
                $Counter++;
                $Data{"SetValue$Counter"}  = $Data{Set}->{$SetKey};
                $Data{"SetHeader$Counter"} = $SetKey;
            }
        }
    }

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    $Self->{LayoutObject}->Block( Name => 'Overview' );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # all headers
    my @Headers = @{ $Self->{ConfigObject}->Get('PostmasterX-Header') };

    # add Dynamic Field headers
    my $DynamicFields = $Self->{DynamicFieldObject}->DynamicFieldList(
        Valid      => 1,
        ObjectType => [ 'Ticket', 'Article' ],
        ResultType => 'HASH',
    );
    for my $DynamicField ( values %$DynamicFields ) {
        push @Headers, 'X-OTRS-DynamicField-' . $DynamicField;
        push @Headers, 'X-OTRS-FollowUp-DynamicField-' . $DynamicField;
    }

    my %Header = map { $_ => $_ } @Headers;
    $Header{''} = '-';
    $Header{Body} = 'Body';

    # otrs header
    my %SetHeader = ();
    for my $HeaderKey ( sort keys %Header ) {
        if ( $HeaderKey =~ /^x-otrs/i ) {
            $SetHeader{$HeaderKey} = $HeaderKey;
        }
    }
    $SetHeader{''} = '-';

    # build strings
    for my $Number ( 1 .. 12 ) {
        $Data{"MatchHeader$Number"} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%Header,
            Name        => "MatchHeader$Number",
            SelectedID  => $Data{"MatchHeader$Number"},
            Class       => $Data{ 'MatchHeader' . $Number . 'Invalid' } || '',
            Translation => 0,
            HTMLQuote   => 1,
        );
        $Data{"SetHeader$Number"} = $Self->{LayoutObject}->BuildSelection(
            Data        => \%SetHeader,
            Name        => "SetHeader$Number",
            SelectedID  => $Data{"SetHeader$Number"},
            Class       => $Data{ 'SetHeader' . $Number . 'Invalid' } || '',
            Translation => 0,
            HTMLQuote   => 1,
        );
    }
    $Data{"StopAfterMatch"} = $Self->{LayoutObject}->BuildSelection(
        Data => { 0 => 'No', 1 => 'Yes' },
        Name => 'StopAfterMatch',
        SelectedID => $Data{StopAfterMatch} || 0,
        Class => 'Validate_RequiredDropdown',
        Translation => 1,
        HTMLQuote   => 1,
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => { %Param, %Data, OldName => $Data{Name}, },
    );

    # shows header
    if ( $Self->{Subaction} eq 'AddAction' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminPostMasterFilter',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
