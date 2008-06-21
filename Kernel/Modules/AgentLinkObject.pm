# --
# Kernel/Modules/AgentLinkObject.pm - to link objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentLinkObject.pm,v 1.31 2008-06-21 12:07:05 ub Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentLinkObject;

use strict;
use warnings;

use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.31 $) [1];

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
    $Self->{LinkObject} = Kernel::System::LinkObject->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %Form;
    $Form{SourceObject} = $Self->{ParamObject}->GetParam( Param => 'SourceObject' );
    $Form{SourceKey}    = $Self->{ParamObject}->GetParam( Param => 'SourceKey' );
    $Form{State}        = $Self->{ParamObject}->GetParam( Param => 'State' ) || 'Valid';

    # check needed stuff
    if ( !$Form{SourceObject} || !$Form{SourceKey} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need SourceObject and SourceKey!",
            Comment => 'Please contact the admin.',
        );
    }

    # get source object description
    my %SourceObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
        Object => $Form{SourceObject},
        Key    => $Form{SourceKey},
        UserID => $Self->{UserID},
    );

    # ------------------------------------------------------------ #
    # link delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'LinkDelete' ) {

        if ( $Self->{ParamObject}->GetParam( Param => 'SubmitDelete' ) ) {

            # get the link delete keys and target object
            my @LinkDeleteIdentifier = $Self->{ParamObject}->GetArray(
                Param => 'LinkDeleteIdentifier',
            );

            # delete links from database
            IDENTIFIER:
            for my $Identifier (@LinkDeleteIdentifier) {

                my @Target = split q{::}, $Identifier;

                next IDENTIFIER if !$Target[0];    # TargetObject
                next IDENTIFIER if !$Target[1];    # TargetKey
                next IDENTIFIER if !$Target[2];    # LinkType

                # delete link from database
                $Self->{LinkObject}->LinkDelete(
                    Object1 => $Form{SourceObject},
                    Key1    => $Form{SourceKey},
                    Object2 => $Target[0],
                    Key2    => $Target[1],
                    Type    => $Target[2],
                    UserID  => $Self->{UserID},
                );
            }
        }

        # output link block
        $Self->{LayoutObject}->Block(
            Name => 'Delete',
            Data => {
                %Form,
                SourceObjectNormal => $SourceObjectDescription{Normal},
            },
        );

        # get already linked objects
        my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
            Object => $Form{SourceObject},
            Key    => $Form{SourceKey},
            State  => $Form{State},
            UserID => $Self->{UserID},
        );

        # redirect to overview if list is empty
        if ( !$LinkListWithData || !%{$LinkListWithData} ) {

            return $Self->{LayoutObject}->Redirect(
                OP =>
                    "Action=$Self->{Action}&SourceObject=$Form{SourceObject}&SourceKey=$Form{SourceKey}",
            );
        }

        # create the link table
        my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreateComplex(
            LinkListWithData => $LinkListWithData,
            ViewMode         => 'ComplexDelete',
        );

        # output the link table
        $Self->{LayoutObject}->Block(
            Name => 'DeleteTableComplex',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentLinkObject',
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        # get form params
        $Form{TargetIdentifier} = $Self->{ParamObject}->GetParam( Param => 'TargetIdentifier' )
            || $Form{SourceObject};

        # investigate the target object
        if ( $Form{TargetIdentifier} =~ m{ \A ( .+? ) :: ( .+ ) \z }xms ) {
            $Form{TargetObject}    = $1;
            $Form{TargetSubObject} = $2;
        }
        else {
            $Form{TargetObject} = $Form{TargetIdentifier};
        }

        # add new links
        if ( $Self->{ParamObject}->GetParam( Param => 'SubmitLink' ) ) {

            # get the link target keys
            my @LinkTargetKeys = $Self->{ParamObject}->GetArray( Param => 'LinkTargetKeys' );

            # get the type
            my $TypeIdentifier = $Self->{ParamObject}->GetParam( Param => 'TypeIdentifier' );

            # split the identifier
            my @Type = split q{::}, $TypeIdentifier;

            if ( $Type[0] && $Type[1] && ( $Type[1] eq 'Source' || $Type[1] eq 'Target' ) ) {

                # add links
                for my $TargetKeyOrg (@LinkTargetKeys) {

                    my $SourceObject = $Form{TargetObject};
                    my $SourceKey    = $TargetKeyOrg;
                    my $TargetObject = $Form{SourceObject};
                    my $TargetKey    = $Form{SourceKey};

                    if ( $Type[1] eq 'Target' ) {
                        $SourceObject = $Form{SourceObject};
                        $SourceKey    = $Form{SourceKey};
                        $TargetObject = $Form{TargetObject};
                        $TargetKey    = $TargetKeyOrg;
                    }

                    # add links to database
                    $Self->{LinkObject}->LinkAdd(
                        SourceObject => $SourceObject,
                        SourceKey    => $SourceKey,
                        TargetObject => $TargetObject,
                        TargetKey    => $TargetKey,
                        Type         => $Type[0],
                        State        => $Form{State},
                        UserID       => $Self->{UserID},
                    );
                }
            }
        }

        # get the selectable object list
        my $TargetObjectStrg = $Self->{LayoutObject}->LinkObjectSelectableObjectList(
            Object   => $Form{SourceObject},
            Selected => $Form{TargetIdentifier},
        );

        # check needed stuff
        if ( !$TargetObjectStrg ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "The Object $Form{SourceObject} cannot link with other object!",
                Comment => 'Please contact the admin.',
            );
        }

        # output link block
        $Self->{LayoutObject}->Block(
            Name => 'Link',
            Data => {
                %Form,
                SourceObjectNormal => $SourceObjectDescription{Normal},
                SourceObjectLong   => $SourceObjectDescription{Long},
                TargetObjectStrg   => $TargetObjectStrg,
            },
        );

        # get search option list
        my @SearchOptionList = $Self->{LayoutObject}->LinkObjectSearchOptionList(
            Object => $Form{TargetObject},
        );

        # output search option fields
        for my $Option (@SearchOptionList) {

            # output link search row block
            $Self->{LayoutObject}->Block(
                Name => 'LinkSearchRow',
                Data => $Option,
            );
        }

        # create the search param hash
        my %SearchParam;
        OPTION:
        for my $Option (@SearchOptionList) {

            next OPTION if !$Option->{FormData};
            $SearchParam{ $Option->{Key} } = $Option->{FormData};
        }

        # start search
        my $SearchList = $Self->{LinkObject}->ObjectSearch(
            Object       => $Form{TargetObject},
            SearchParams => \%SearchParam,
            UserID       => $Self->{UserID},
        );

        # remove the source object from the list
        if ( $SearchList->{ $Form{SourceObject} } ) {

            for my $LinkType ( keys %{ $SearchList->{ $Form{SourceObject} } } ) {

                # extract link type List
                my $LinkTypeList = $SearchList->{ $Form{SourceObject} }->{$LinkType};

                for my $Direction ( keys %{$LinkTypeList} ) {

                    # remove the source key
                    delete $LinkTypeList->{$Direction}->{ $Form{SourceKey} };
                }
            }
        }

        # get already linked objects
        my $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
            Object => $Form{SourceObject},
            Key    => $Form{SourceKey},
            State  => $Form{State},
            UserID => $Self->{UserID},
        );

        # output back link
        if ( $LinkListWithData && %{$LinkListWithData} ) {

            # output the link back block
            $Self->{LayoutObject}->Block(
                Name => 'LinkBack',
                Data => \%Form,
            );
        }

        # add search result to link list
        if ( $SearchList && $SearchList->{ $Form{TargetObject} } ) {
            $LinkListWithData->{ $Form{TargetObject} }->{NOTLINKED}
                = $SearchList->{ $Form{TargetObject} }->{NOTLINKED};
        }

        # get possible types list
        my %PossibleTypesList = $Self->{LinkObject}->PossibleTypesList(
            Object1 => $Form{SourceObject},
            Object2 => $Form{TargetObject},
            UserID  => $Self->{UserID},
        );

        # create the selectable type list
        my @SelectableTypesList;
        POSSIBLETYPE:
        for my $PossibleType ( sort { lc $a cmp lc $b } keys %PossibleTypesList ) {

            # lookup type id
            my $TypeID = $Self->{LinkObject}->TypeLookup(
                Name   => $PossibleType,
                UserID => $Self->{UserID},
            );

            # get type
            my %Type = $Self->{LinkObject}->TypeGet(
                TypeID => $TypeID,
                UserID => $Self->{UserID},
            );

            # create the source name
            my %SourceName;
            $SourceName{Key}   = $PossibleType . '::Source';
            $SourceName{Value} = $Type{SourceName};

            push @SelectableTypesList, \%SourceName;

            next POSSIBLETYPE if !$Type{Pointed};

            # create the source name
            my %TargetName;
            $TargetName{Key}   = $PossibleType . '::Target';
            $TargetName{Value} = $Type{TargetName};

            push @SelectableTypesList, \%TargetName;
        }
        continue {
            my %BlankLine;
            $BlankLine{Key}   = '-';
            $BlankLine{Value} = '';

            push @SelectableTypesList, \%BlankLine;
        }

        # removed last (empty) entry
        pop @SelectableTypesList;

        # create link type string
        my $LinkTypeStrg = $Self->{LayoutObject}->BuildSelection(
            Data       => \@SelectableTypesList,
            Name       => 'TypeIdentifier',
            SelectedID => 'Normal::Source',
        );

        # create the link table
        my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreateComplex(
            LinkListWithData => {
                $Form{TargetObject} => $LinkListWithData->{ $Form{TargetObject} },
            },
            ViewMode         => 'ComplexAdd',
            LinkTypeStrg     => $LinkTypeStrg,
        );

        # output the link table
        $Self->{LayoutObject}->Block(
            Name => 'LinkTableComplex',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentLinkObject',
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
