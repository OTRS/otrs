# --
# Kernel/Modules/AgentLinkObject.pm - to link objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentLinkObject.pm,v 1.45 2008-08-04 14:07:55 mh Exp $
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
$VERSION = qw($Revision: 1.45 $) [1];

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
    $Form{Mode}         = $Self->{ParamObject}->GetParam( Param => 'Mode' ) || 'Normal';

    # check needed stuff
    if ( !$Form{SourceObject} || !$Form{SourceKey} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need SourceObject and SourceKey!",
            Comment => 'Please contact the admin.',
        );
    }

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

    # get possible objects list
    my %PossibleObjectsList = $Self->{LinkObject}->PossibleObjectsList(
        Object => $Form{SourceObject},
        UserID => $Self->{UserID},
    );

    # check if target object is a possible object to link with the source object
    if ( !$PossibleObjectsList{ $Form{TargetObject} } ) {
        my @PossibleObjects = sort { lc $a cmp lc $b } keys %PossibleObjectsList;
        $Form{TargetObject} = $PossibleObjects[0];
    }

    # set mode params
    if ( $Form{Mode} eq 'Temporary' ) {
        $Form{State} = 'Temporary';
    }
    else {
        $Form{Mode}  = 'Normal';
        $Form{State} = 'Valid';
    }

    # get source object description
    my %SourceObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
        Object => $Form{SourceObject},
        Key    => $Form{SourceKey},
        Mode   => $Form{Mode},
        UserID => $Self->{UserID},
    );

    # ------------------------------------------------------------ #
    # link delete
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'LinkDelete' ) {

        # output header and navbar
        my $Output = $Self->{LayoutObject}->Header();

        # output navbar
        if ( $Form{Mode} eq 'Normal' ) {
            $Output .= $Self->{LayoutObject}->NavigationBar();
        }

        if ( $Self->{ParamObject}->GetParam( Param => 'SubmitDelete' ) ) {

            # delete all temporary links older than one day
            $Self->{LinkObject}->LinkCleanup(
                State  => 'Temporary',
                Age    => ( 60 * 60 * 24 ),
                UserID => $Self->{UserID},
            );

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
                my $Success = $Self->{LinkObject}->LinkDelete(
                    Object1 => $Form{SourceObject},
                    Key1    => $Form{SourceKey},
                    Object2 => $Target[0],
                    Key2    => $Target[1],
                    Type    => $Target[2],
                    UserID  => $Self->{UserID},
                );

                next IDENTIFIER if $Success;

                # get target object description
                my %TargetObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
                    Object => $Target[0],
                    Key    => $Target[1],
                    Mode   => $Form{Mode},
                    UserID => $Self->{UserID},
                );

                # output an error notification
                $Output .= $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Data     => '$Text{"Can not delete link with %s!", "'
                        . $TargetObjectDescription{Normal}
                        . '"}',
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
                OP => "Action=$Self->{Action}&Mode=$Form{Mode}"
                    . "&SourceObject=$Form{SourceObject}&SourceKey=$Form{SourceKey}"
                    . "&TargetIdentifier=$Form{TargetIdentifier}",
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

        # get the type
        my $TypeIdentifier = $Self->{ParamObject}->GetParam( Param => 'TypeIdentifier' );

        # output header
        my $Output = $Self->{LayoutObject}->Header();

        # output navbar
        if ( $Form{Mode} eq 'Normal' ) {
            $Output .= $Self->{LayoutObject}->NavigationBar();
        }

        # add new links
        if ( $Self->{ParamObject}->GetParam( Param => 'SubmitLink' ) ) {

            # get the link target keys
            my @LinkTargetKeys = $Self->{ParamObject}->GetArray( Param => 'LinkTargetKeys' );

            # get all links that the source object already has
            my $LinkList = $Self->{LinkObject}->LinkList(
                Object => $Form{SourceObject},
                Key    => $Form{SourceKey},
                State  => $Form{State},
                UserID => $Self->{UserID},
            );

            # split the identifier
            my @Type = split q{::}, $TypeIdentifier;

            if ( $Type[0] && $Type[1] && ( $Type[1] eq 'Source' || $Type[1] eq 'Target' ) ) {

                # add links
                TARGETKEYORG:
                for my $TargetKeyOrg (@LinkTargetKeys) {

                    TYPE:
                    for my $LType ( keys %{ $LinkList->{ $Form{TargetObject} } } ) {

                        # extract source and target
                        my $Source = $LinkList->{ $Form{TargetObject} }->{$LType}->{Source} ||= {};
                        my $Target = $LinkList->{ $Form{TargetObject} }->{$LType}->{Target} ||= {};

                        # check if source and target object are already linked
                        next TYPE
                            if !$Source->{$TargetKeyOrg} && !$Target->{$TargetKeyOrg};

                        # next type, if link already exists
                        if ( $LType eq $Type[0] ) {
                            next TYPE if $Type[1] eq 'Source' && $Source->{$TargetKeyOrg};
                            next TYPE if $Type[1] eq 'Target' && $Target->{$TargetKeyOrg};
                        }

                        # check the type groups
                        my $TypeGroupCheck = $Self->{LinkObject}->PossibleType(
                            Type1  => $Type[0],
                            Type2  => $LType,
                            UserID => $Self->{UserID},
                        );

                        next TYPE if $TypeGroupCheck && $Type[0] ne $LType;

                        # get target object description
                        my %TargetObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
                            Object => $Form{TargetObject},
                            Key    => $TargetKeyOrg,
                            UserID => $Self->{UserID},
                        );

                        # lookup type id
                        my $TypeID = $Self->{LinkObject}->TypeLookup(
                            Name   => $LType,
                            UserID => $Self->{UserID},
                        );

                        # get type data
                        my %TypeData = $Self->{LinkObject}->TypeGet(
                            TypeID => $TypeID,
                            UserID => $Self->{UserID},
                        );

                        # investigate type name
                        my $TypeName = $TypeData{SourceName};
                        if ( $Target->{$TargetKeyOrg} ) {
                            $TypeName = $TypeData{TargetName};
                        }

                        # translate the type name
                        $TypeName = $Self->{LayoutObject}->{LanguageObject}->Get($TypeName);

                        # output an error notification
                        $Output .= $Self->{LayoutObject}->Notify(
                            Priority => 'Error',
                            Data     => '$Text{"Can not create link with %s!", "'
                                . $TargetObjectDescription{Normal}
                                . '"} $Text{"Object already linked as %s.", "'
                                . $TypeName
                                . '"}',
                        );

                        next TARGETKEYORG;
                    }

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
                    my $Success = $Self->{LinkObject}->LinkAdd(
                        SourceObject => $SourceObject,
                        SourceKey    => $SourceKey,
                        TargetObject => $TargetObject,
                        TargetKey    => $TargetKey,
                        Type         => $Type[0],
                        State        => $Form{State},
                        UserID       => $Self->{UserID},
                    );

                    next TARGETKEYORG if $Success;

                    # get target object description
                    my %TargetObjectDescription = $Self->{LinkObject}->ObjectDescriptionGet(
                        Object => $Form{TargetObject},
                        Key    => $TargetKeyOrg,
                        UserID => $Self->{UserID},
                    );

                    # output an error notification
                    $Output .= $Self->{LayoutObject}->Notify(
                        Priority => 'Error',
                        Data     => '$Text{"Can not create link with %s!", "'
                            . $TargetObjectDescription{Normal}
                            . '"}',
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
            Object    => $Form{TargetObject},
            SubObject => $Form{TargetSubObject},
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
            next OPTION if $Option->{FormData}
                    && ref $Option->{FormData} eq 'ARRAY' && !@{ $Option->{FormData} };

            $SearchParam{ $Option->{Key} } = $Option->{FormData};
        }

        # start search
        my $SearchList = $Self->{LinkObject}->ObjectSearch(
            Object       => $Form{TargetObject},
            SubObject    => $Form{TargetSubObject},
            SearchParams => \%SearchParam,
            UserID       => $Self->{UserID},
        );

        # remove the source object from the search list
        if ( $SearchList && $SearchList->{ $Form{SourceObject} } ) {

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
        my $LinkListWithData = {};
        if ( $SearchList && $SearchList->{ $Form{TargetObject} } ) {
            $LinkListWithData = $Self->{LinkObject}->LinkListWithData(
                Object => $Form{SourceObject},
                Key    => $Form{SourceKey},
                State  => $Form{State},
                UserID => $Self->{UserID},
            );
        }

        if ( $LinkListWithData && $LinkListWithData->{ $Form{TargetObject} } ) {

            # build object id lookup hash from search list
            my %SearchListObjectKeys;
            for my $Key ( keys %{ $SearchList->{ $Form{TargetObject} }->{NOTLINKED}->{Source} } ) {
                $SearchListObjectKeys{$Key} = 1;
            }

            # check if linked objects are part of the search list
            for my $LinkType ( keys %{ $LinkListWithData->{ $Form{TargetObject} } } ) {

                # extract link type List
                my $LinkTypeList = $LinkListWithData->{ $Form{TargetObject} }->{$LinkType};

                for my $Direction ( keys %{$LinkTypeList} ) {

                    # extract the keys
                    KEY:
                    for my $Key ( keys %{ $LinkTypeList->{$Direction} } ) {

                        next KEY if $SearchListObjectKeys{$Key};

                        # delete from linked objects list if key is not in search list
                        delete $LinkTypeList->{$Direction}->{$Key};
                    }
                }
            }
        }

        my %LinkMenuOutput;
        if ( $Form{Mode} eq 'Normal' ) {
            $LinkMenuOutput{Back} = 1;
        }
        if ( $LinkListWithData && %{$LinkListWithData} ) {
            $LinkMenuOutput{Delete} = 1;
        }

        # output link menu
        if (%LinkMenuOutput) {

            # output the link menu block
            $Self->{LayoutObject}->Block(
                Name => 'LinkMenu',
            );
        }

        # output back link
        if ( $LinkMenuOutput{Back} ) {

            # output the link menu back block
            $Self->{LayoutObject}->Block(
                Name => 'LinkMenuBack',
                Data => \%Form,
            );
        }

        # output link seperator
        if ( $LinkMenuOutput{Back} && $LinkMenuOutput{Delete} ) {

            # output the link menu seperator block
            $Self->{LayoutObject}->Block(
                Name => 'LinkMenuSeperator',
            );
        }

        # output delete link
        if ( $LinkMenuOutput{Delete} ) {

            # output the link menu delete block
            $Self->{LayoutObject}->Block(
                Name => 'LinkMenuDelete',
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

        # define blank line entry
        my %BlankLine = (
            Key      => '-',
            Value    => '-------------------------',
            Disabled => 1,
        );

        # create the selectable type list
        my $Counter = 0;
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

            # add blank line
            push @SelectableTypesList, \%BlankLine;

            $Counter++;
        }

        # removed last (empty) entry
        pop @SelectableTypesList;

        # add blank lines on top and bottom of the list if more then two linktypes
        if ( $Counter > 2 ) {
            unshift @SelectableTypesList, \%BlankLine;
            push @SelectableTypesList, \%BlankLine;
        }

        # create link type string
        my $LinkTypeStrg = $Self->{LayoutObject}->BuildSelection(
            Data       => \@SelectableTypesList,
            Name       => 'TypeIdentifier',
            SelectedID => $TypeIdentifier || 'Normal::Source',
        );

        # create the link table
        my $LinkTableStrg = $Self->{LayoutObject}->LinkObjectTableCreateComplex(
            LinkListWithData => {
                $Form{TargetObject} => $LinkListWithData->{ $Form{TargetObject} },
            },
            ViewMode     => 'ComplexAdd',
            LinkTypeStrg => $LinkTypeStrg,
        );

        # output the link table
        $Self->{LayoutObject}->Block(
            Name => 'LinkTableComplex',
            Data => {
                LinkTableStrg => $LinkTableStrg,
            },
        );

        # start template output
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AgentLinkObject',
        );

        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

1;
