# --
# Kernel/Output/HTML/LayoutTicket.pm - provides generic ticket HTML output
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: LayoutTicket.pm,v 1.97 2010-08-25 11:48:57 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::LayoutTicket;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.97 $) [1];

sub AgentCustomerViewTable {
    my ( $Self, %Param ) = @_;

    # check customer params
    if ( ref $Param{Data} ne 'HASH' ) {
        $Self->FatalError( Message => 'Need Hash ref in Data param' );
    }
    elsif ( ref $Param{Data} eq 'HASH' && !%{ $Param{Data} } ) {
        return $Self->{LanguageObject}->Get('none');
    }

    # add ticket params if given
    if ( $Param{Ticket} ) {
        %{ $Param{Data} } = ( %{ $Param{Data} }, %{ $Param{Ticket} } );
    }

    my @MapNew;
    my $Map = $Param{Data}->{Config}->{Map};
    if ($Map) {
        @MapNew = ( @{$Map} );
    }

    # check if customer company support is enabled
    if ( $Param{Data}->{Config}->{CustomerCompanySupport} ) {
        my $Map2 = $Param{Data}->{CompanyConfig}->{Map};
        if ($Map2) {
            push( @MapNew, @{$Map2} );
        }
    }

    my $ShownType = 1;
    if ( $Param{Type} && $Param{Type} eq 'Lite' ) {
        $ShownType = 2;

        # check if min one lite view item is configured, if not, use
        # the normal view also
        my $Used = 0;
        for my $Field (@MapNew) {
            if ( $Field->[3] == 2 ) {
                $Used = 1;
            }
        }
        if ( !$Used ) {
            $ShownType = 1;
        }
    }

    # build html table
    $Self->Block(
        Name => 'Customer',
        Data => $Param{Data},
    );

    # check Frontend::CustomerUser::Image
    my $CustomerImage = $Self->{ConfigObject}->Get('Frontend::CustomerUser::Image');
    if ($CustomerImage) {
        my %Modules = %{$CustomerImage};
        for my $Module ( sort keys %Modules ) {
            if ( !$Self->{MainObject}->Require( $Modules{$Module}->{Module} ) ) {
                $Self->FatalDie();
            }

            my $Object = $Modules{$Module}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            # run module
            next if !$Object;

            $Object->Run(
                Config => $Modules{$Module},
                Data   => $Param{Data},
            );
        }
    }

    # build table
    for my $Field (@MapNew) {
        if ( $Field->[3] && $Field->[3] >= $ShownType && $Param{Data}->{ $Field->[0] } ) {
            my %Record = (
                %{ $Param{Data} },
                Key   => $Field->[1],
                Value => $Param{Data}->{ $Field->[0] },
            );
            if ( $Field->[6] ) {
                $Record{LinkStart} = "<a href=\"$Field->[6]\"";
                if ( $Field->[8] ) {
                    $Record{LinkStart} .= " target=\"$Field->[8]\"";
                }
                $Record{LinkStart} .= "\">";
                $Record{LinkStop} = "</a>";
            }
            if ( $Field->[0] ) {
                $Record{ValueShort} = $Self->Ascii2Html(
                    Text => $Record{Value},
                    Max  => $Param{Max}
                );
            }
            $Self->Block(
                Name => 'CustomerRow',
                Data => \%Record,
            );
        }
    }

    # check Frontend::CustomerUser::Item
    my $CustomerItem      = $Self->{ConfigObject}->Get('Frontend::CustomerUser::Item');
    my $CustomerItemCount = 0;
    if ($CustomerItem) {
        $Self->Block(
            Name => 'CustomerItem',
        );
        my %Modules = %{$CustomerItem};
        for my $Module ( sort keys %Modules ) {
            if ( !$Self->{MainObject}->Require( $Modules{$Module}->{Module} ) ) {
                $Self->FatalDie();
            }

            my $Object = $Modules{$Module}->{Module}->new(
                %{$Self},
                LayoutObject => $Self,
            );

            # run module
            next if !$Object;

            my $Run = $Object->Run(
                Config => $Modules{$Module},
                Data   => $Param{Data},
            );

            next if !$Run;

            $CustomerItemCount++;
        }
    }

    # Acivity Index: History
    # CTI
    # vCard
    # Bugzilla Status
    # create & return output
    return $Self->Output( TemplateFile => 'AgentCustomerTableView', Data => \%Param );
}

# AgentQueueListOption()
#
# !! DONT USE THIS FUNCTION !! Use BuildSelection() instead.
#
# Due to compatibility reason this function is still in use and will be removed
# in a further release.

sub AgentQueueListOption {
    my ( $Self, %Param ) = @_;

    my $Size       = $Param{Size}                  ? "size='$Param{Size}'" : '';
    my $MaxLevel   = defined( $Param{MaxLevel} )   ? $Param{MaxLevel}      : 10;
    my $SelectedID = defined( $Param{SelectedID} ) ? $Param{SelectedID}    : '';
    my $Selected   = defined( $Param{Selected} )   ? $Param{Selected}      : '';
    my $Class      = defined( $Param{Class} )      ? $Param{Class}         : '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $Multiple = $Param{Multiple} ? 'multiple = "multiple"' : '';
    my $OnChangeSubmit = defined( $Param{OnChangeSubmit} ) ? $Param{OnChangeSubmit} : '';
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit();\"";
    }
    else {
        $OnChangeSubmit = '';
    }

    # set OnChange if AJAX is used
    if ( $Param{Ajax} ) {
        if ( !$Param{Ajax}->{Depend} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Depend Param Ajax option!',
            );
            $Self->FatalError();
        }
        if ( !$Param{Ajax}->{Update} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Need Update Param Ajax option()!',
            );
            $Self->FatalError();
        }
        $Param{OnChange}
            = "Core.AJAX.FormUpdate($('#"
            . $Param{Name} . "'), '"
            . $Param{Ajax}->{Subaction} . "',"
            . " '$Param{Name}',"
            . " ['"
            . join( "', '", @{ $Param{Ajax}->{Update} } ) . "']);";
    }

    if ( $Param{OnChange} ) {
        $OnChangeSubmit = " onchange=\"$Param{OnChange}\"";
    }

    # just show a simple list
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'list' ) {
        $Param{MoveQueuesStrg} = $Self->BuildSelection( %Param, HTMLQuote => 0, );
        return $Param{MoveQueuesStrg};
    }

    # build tree list
    $Param{MoveQueuesStrg}
        = '<select name="'
        . $Param{Name}
        . '" id="'
        . $Param{Name}
        . '" class="'
        . $Class
        . "\" $Size $Multiple $OnChangeSubmit>\n";
    my %UsedData;
    my %Data;

    if ( $Param{Data} && ref $Param{Data} eq 'HASH' ) {
        %Data = %{ $Param{Data} };
    }
    else {
        return 'Need Data Ref in AgentQueueListOption()!';
    }

    # add suffix for correct sorting
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        $Data{$_} .= '::';
    }

    # to show disabled queues only one time in the selection tree
    my %DisabledQueueAlreadyUsed;

    # build selection string
    for ( sort { $Data{$a} cmp $Data{$b} } keys %Data ) {
        my @Queue = split( /::/, $Param{Data}->{$_} );
        $UsedData{ $Param{Data}->{$_} } = 1;
        my $UpQueue = $Param{Data}->{$_};
        $UpQueue =~ s/^(.*)::.+?$/$1/g;
        if ( !$Queue[$MaxLevel] && $Queue[-1] ne '' ) {
            $Queue[-1] = $Self->Ascii2Html( Text => $Queue[-1], Max => 50 - $#Queue );
            my $Space = '';
            for ( my $i = 0; $i < $#Queue; $i++ ) {
                $Space .= '&nbsp;&nbsp;';
            }

            # check if SelectedIDRefArray exists
            if ($SelectedIDRefArray) {
                for my $ID ( @{$SelectedIDRefArray} ) {
                    if ( $ID eq $_ ) {
                        $Param{SelectedIDRefArrayOK}->{$_} = 1;
                    }
                }
            }

            if ( !$UsedData{$UpQueue} ) {

                # integrate the not selectable parent and root queues of this queue
                # useful for ACLs and complex permission settings
                for my $Index ( 0 .. ( scalar @Queue - 2 ) ) {
                    if ( !$DisabledQueueAlreadyUsed{ $Queue[$Index] } ) {
                        my $DSpace = '&nbsp;&nbsp;' x $Index;
                        $Param{MoveQueuesStrg}
                            .= '<option value="-" disabled="disabled">'
                            . $DSpace
                            . $Queue[$Index]
                            . "</option>\n";
                        $DisabledQueueAlreadyUsed{ $Queue[$Index] } = 1;
                    }
                }
            }

            # create selectable elements
            my $String = $Space . $Queue[-1];
            if (
                $SelectedID  eq $_
                || $Selected eq $Param{Data}->{$_}
                || $Param{SelectedIDRefArrayOK}->{$_}
                )
            {
                $Param{MoveQueuesStrg}
                    .= '<option selected="selected" value="' . $_ . '">' . $String . "</option>\n";
            }
            else {
                $Param{MoveQueuesStrg} .= '<option value="' . $_ . '">' . $String . "</option>\n";
            }
        }
    }
    $Param{MoveQueuesStrg} .= "</select>\n";

    return $Param{MoveQueuesStrg};
}

sub AgentFreeText {
    my ( $Self, %Param ) = @_;

    my %NullOption;
    my %SelectData;
    my %Ticket;
    my %Config;
    my $Class = '';
    if ( $Param{NullOption} ) {

        #        $NullOption{''} = '-';
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    if ( $Param{Class} ) {
        $Class = $Param{Class};
    }
    my %Data;
    for ( 1 .. 16 ) {

        # key
        if ( ref $Config{"TicketFreeKey$_"} eq 'HASH' && %{ $Config{"TicketFreeKey$_"} } ) {
            my $Counter = 0;
            my $LastKey = '';
            for ( keys %{ $Config{"TicketFreeKey$_"} } ) {
                $Counter++;
                $LastKey = $_;
            }
            if ( $Counter == 1 && $Param{NullOption} ) {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"} = $Config{"TicketFreeKey$_"}->{$LastKey};
                }
            }
            elsif ( $Counter > 1 ) {
                $Data{"TicketFreeKeyField$_"} = $Self->BuildSelection(
                    Data => { %NullOption, %{ $Config{"TicketFreeKey$_"} }, },
                    Name => "TicketFreeKey$_",
                    SelectedID          => $Ticket{"TicketFreeKey$_"},
                    LanguageTranslation => 0,
                    Class               => 'TicketFreeKey',
                    HTMLQuote           => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"TicketFreeKeyField$_"}
                        = $Config{"TicketFreeKey$_"}->{$LastKey}
                        . '<input type="hidden" name="TicketFreeKey'
                        . $_
                        . '" value="'
                        . $Self->Ascii2Html( Text => $LastKey ) . '"/>';
                }
            }
        }
        else {
            if ( defined $Ticket{"TicketFreeKey$_"} ) {
                if ( ref $Ticket{"TicketFreeKey$_"} eq 'ARRAY' ) {
                    if ( $Ticket{"TicketFreeKey$_"}->[0] ) {
                        $Ticket{"TicketFreeKey$_"} = $Ticket{"TicketFreeKey$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeKey$_"} = '';
                    }
                }
                $Data{"TicketFreeKeyField$_"}
                    = '<input type="text" class="TicketFreeKey" name="TicketFreeKey'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Ticket{"TicketFreeKey$_"} )
                    . '" />';
            }
            else {
                $Data{"TicketFreeKeyField$_"}
                    = '<input type="text" class="TicketFreeKey" name="TicketFreeKey' . $_
                    . '" value="" />';
            }
        }

        # Add Validate and Error classes
        my $ClassParam = "$Class ";
        my $DataParam  = "";
        if ( $Config{"Required"}->{$_} ) {
            $ClassParam .= 'Validate_Required';
            if ( ref $Config{"TicketFreeText$_"} eq 'HASH' ) {
                $ClassParam .= 'Dropdown';
            }
            $ClassParam .= ' ';

            $DataParam
                .= '<div id="TicketFreeText'
                . $_
                . 'Error" class="TooltipErrorMessage"><p>$Text{"Required."}</p></div>';
        }

        if ( $Config{"Error"}->{$_} ) {
            $ClassParam .= 'ServerError ';
            $DataParam
                .= '<div id="TicketFreeText'
                . $_
                . 'ServerError" class="TooltipErrorMessage"><p>$Text{"Required."}</p></div>';
        }

        # value
        if ( ref $Config{"TicketFreeText$_"} eq 'HASH' ) {
            $Data{"TicketFreeTextField$_"} = $Self->BuildSelection(
                Data => { %NullOption, %{ $Config{"TicketFreeText$_"} }, },
                Name => "TicketFreeText$_",
                SelectedID          => $Ticket{"TicketFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote           => 1,
                Class               => "TicketFreeText $ClassParam",
                %SelectData,
            );

            $Data{"TicketFreeTextField$_"} .= $DataParam;

        }
        else {
            if ( defined $Ticket{"TicketFreeText$_"} ) {
                if ( ref $Ticket{"TicketFreeText$_"} eq 'ARRAY' ) {
                    if ( $Ticket{"TicketFreeText$_"}->[0] ) {
                        $Ticket{"TicketFreeText$_"} = $Ticket{"TicketFreeText$_"}->[0];
                    }
                    else {
                        $Ticket{"TicketFreeText$_"} = '';
                    }
                }
                $Data{"TicketFreeTextField$_"}
                    = '<input type="text" class="TicketFreeText $ClassParam" name="TicketFreeText'
                    . $_
                    . '" id="TicketFreeText'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Ticket{"TicketFreeText$_"} )
                    . '" />';

                $Data{"TicketFreeTextField$_"} .= $DataParam;

            }
            else {
                $Data{"TicketFreeTextField$_"}
                    = '<input type="text" class="TicketFreeText ' . $ClassParam
                    . '" name="TicketFreeText'
                    . $_
                    . '" id="TicketFreeText'
                    . $_
                    . '" value="" />';

                $Data{"TicketFreeTextField$_"} .= $DataParam;
            }
        }
    }
    return %Data;
}

sub AgentFreeDate {
    my ( $Self, %Param ) = @_;

    my %NullOption;
    my %SelectData;
    my %Ticket;
    my %Config;
    my $Class = '';
    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    if ( $Param{Class} ) {
        $Class = $Param{Class};
    }
    my %Data;
    for my $Count ( 1 .. 6 ) {
        my %TimePeriod;
        if ( $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) ) {
            %TimePeriod = %{ $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) };
        }
        $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
            %Param,
            %Ticket,
            Prefix                              => 'TicketFreeTime' . $Count,
            Format                              => 'DateInputFormatLong',
            'TicketFreeTime' . $Count . 'Class' => $Class,
            DiffTime => $Self->{ConfigObject}->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
            %TimePeriod,
        );
    }
    return %Data;
}

sub TicketArticleFreeText {
    my ( $Self, %Param ) = @_;

    my %NullOption;
    my %SelectData;
    my %Article;
    my %Config;
    my $Class = '';
    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Article} ) {
        %Article = %{ $Param{Article} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    if ( $Param{Class} ) {
        $Class = $Param{Class};
    }
    my %Data;
    for ( 1 .. 3 ) {

        # key
        if ( ref $Config{"ArticleFreeKey$_"} eq 'HASH' && %{ $Config{"ArticleFreeKey$_"} } ) {
            my $Counter = 0;
            my $LastKey = '';
            for ( keys %{ $Config{"ArticleFreeKey$_"} } ) {
                $Counter++;
                $LastKey = $_;
            }
            if ( $Counter == 1 && $Param{NullOption} ) {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"} = $Config{"ArticleFreeKey$_"}->{$LastKey};
                }
            }
            elsif ( $Counter > 1 ) {
                $Data{"ArticleFreeKeyField$_"} = $Self->BuildSelection(
                    Data => { %NullOption, %{ $Config{"ArticleFreeKey$_"} }, },
                    Name => "ArticleFreeKey$_",
                    SelectedID          => $Article{"ArticleFreeKey$_"},
                    LanguageTranslation => 0,
                    Class               => 'ArticleFreeKey',
                    HTMLQuote           => 1,
                    %SelectData,
                );
            }
            else {
                if ($LastKey) {
                    $Data{"ArticleFreeKeyField$_"}
                        = $Config{"ArticleFreeKey$_"}->{$LastKey}
                        . '<input type="hidden" name="ArticleFreeKey'
                        . $_
                        . '" value="'
                        . $Self->Ascii2Html( Text => $LastKey ) . '"/>';
                }
            }
        }
        else {
            if ( defined $Article{"ArticleFreeKey$_"} ) {
                if ( ref $Article{"ArticleFreeKey$_"} eq 'ARRAY' ) {
                    if ( $Article{"ArticleFreeKey$_"}->[0] ) {
                        $Article{"ArticleFreeKey$_"} = $Article{"ArticleFreeKey$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeKey$_"} = '';
                    }
                }
                $Data{"ArticleFreeKeyField$_"}
                    = '<input type="text" class="ArticleFreeKey" name="ArticleFreeKey'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Article{"ArticleFreeKey$_"} )
                    . '" />';
            }
            else {
                $Data{"ArticleFreeKeyField$_"}
                    = '<input type="text" class="ArticleFreeKey" name="ArticleFreeKey' . $_
                    . '" value="" />';
            }
        }

        # Add Validate and Error classes
        my $ClassParam = "$Class ";
        my $DataParam  = "";
        if ( $Config{"Required"}->{$_} ) {
            $ClassParam .= 'Validate_Required';
            if ( ref $Config{"ArticleFreeText$_"} eq 'HASH' ) {
                $ClassParam .= 'Dropdown';
            }
            $ClassParam .= ' ';

            $DataParam
                .= '<div id="ArticleFreeText'
                . $_
                . 'Error" class="TooltipErrorMessage"><p>$Text{"Required."}</p></div>';
        }

        if ( $Config{"Error"}->{$_} ) {
            $ClassParam .= 'ServerError ';
            $DataParam
                .= '<div id="ArticleFreeText'
                . $_
                . 'ServerError" class="TooltipErrorMessage"><p>$Text{"Required."}</p></div>';
        }

        # value
        if ( ref $Config{"ArticleFreeText$_"} eq 'HASH' ) {
            $Data{"ArticleFreeTextField$_"} = $Self->BuildSelection(
                Data => { %NullOption, %{ $Config{"ArticleFreeText$_"} }, },
                Name => "ArticleFreeText$_",
                SelectedID          => $Article{"ArticleFreeText$_"},
                LanguageTranslation => 0,
                HTMLQuote           => 1,
                Class               => "ArticleFreeText $ClassParam",
                %SelectData,
            );

            $Data{"ArticleFreeTextField$_"} .= $DataParam;
        }
        else {
            if ( defined $Article{"ArticleFreeText$_"} ) {
                if ( ref $Article{"ArticleFreeText$_"} eq 'ARRAY' ) {
                    if ( $Article{"ArticleFreeText$_"}->[0] ) {
                        $Article{"ArticleFreeText$_"} = $Article{"ArticleFreeText$_"}->[0];
                    }
                    else {
                        $Article{"ArticleFreeText$_"} = '';
                    }
                }
                $Data{"ArticleFreeTextField$_"}
                    = '<input type="text" class="ArticleFreeText $ClassParam" name="ArticleFreeText'
                    . $_
                    . '" id="ArticleFreeText'
                    . $_
                    . '" value="'
                    . $Self->Ascii2Html( Text => $Article{"ArticleFreeText$_"} )
                    . '" />';

                $Data{"ArticleFreeTextField$_"} .= $DataParam;
            }
            else {
                $Data{"ArticleFreeTextField$_"}
                    = '<input type="text" class="ArticleFreeText ' . $ClassParam
                    . '" name="ArticleFreeText'
                    . $_
                    . '" id="ArticleFreeText'
                    . $_
                    . '" value="" />';

                $Data{"ArticleFreeTextField$_"} .= $DataParam;
            }
        }
    }
    return %Data;
}

sub CustomerFreeDate {
    my ( $Self, %Param ) = @_;

    my %NullOption;
    my %SelectData;
    my %Ticket;
    my %Config;
    if ( $Param{NullOption} ) {
        $SelectData{Size}     = 3;
        $SelectData{Multiple} = 1;
    }
    if ( $Param{Ticket} ) {
        %Ticket = %{ $Param{Ticket} };
    }
    if ( $Param{Config} ) {
        %Config = %{ $Param{Config} };
    }
    my %Data;
    for my $Count ( 1 .. 6 ) {
        my %TimePeriod;
        if ( $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) ) {
            %TimePeriod = %{ $Self->{ConfigObject}->Get( 'TicketFreeTimePeriod' . $Count ) };
        }
        $Data{ 'TicketFreeTime' . $Count } = $Self->BuildDateSelection(
            Area => 'Customer',
            %Param,
            %Ticket,
            Prefix   => 'TicketFreeTime' . $Count,
            Format   => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get( 'TicketFreeTimeDiff' . $Count ) || 0,
            "TicketFreeTime${Count}Class" => 'DateSelection',
            %TimePeriod,
        );
    }
    return %Data;
}

=item ArticleQuote()

get body and attach e. g. inline documents and/or attach all attachments to
upload cache

for forward or split, get body and attach all attachments

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCacheObject   => $Self->{UploadCacheObject},
        AttachmentsInclude => 1,
    );

or just for including inline documents to upload cache

    my $HTMLBody = $LayoutObject->ArticleQuote(
        TicketID           => 123,
        ArticleID          => 123,
        FormID             => $Self->{FormID},
        UploadCacheObject   => $Self->{UploadCacheObject},
        AttachmentsInclude => 0,
    );

Both will also work without rich text (if $ConfigObject->Get('Frontend::RichText')
is false), return param will be text/plain instead.

=cut

sub ArticleQuote {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID ArticleID FormID UploadCacheObject)) {
        if ( !$Param{$_} ) {
            $Self->FatalError( Message => "Need $_!" );
        }
    }

    # body preparation for plain text processing
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {

        my $Body = '';

        # check for html body
        my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(
            TicketID                   => $Param{TicketID},
            StripPlainBodyAsAttachment => 1,
            UserID                     => $Self->{UserID},
        );

        my @NotInlineAttachments;
        ARTICLE:
        for my $ArticleTmp (@ArticleBox) {

            # search for article to answer (reply article)
            next ARTICLE if $ArticleTmp->{ArticleID} ne $Param{ArticleID};

            # check if no html body exists
            last ARTICLE if !$ArticleTmp->{AttachmentIDOfHTMLBody};

            my %AttachmentHTML = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $ArticleTmp->{ArticleID},
                FileID    => $ArticleTmp->{AttachmentIDOfHTMLBody},
            );
            my $Charset = $AttachmentHTML{ContentType} || '';
            $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Charset =~ s/"|'//g;
            $Charset =~ s/(.+?);.*/$1/g;

            # convert html body to correct charset
            $Body = $Self->{EncodeObject}->Convert(
                Text => $AttachmentHTML{Content},
                From => $Charset,
                To   => $Self->{UserCharset},
            );

            # add url quoting
            $Body = $Self->{HTMLUtilsObject}->LinkQuote(
                String => $Body,
            );

            # strip head, body and meta elements
            $Body = $Self->{HTMLUtilsObject}->DocumentStrip(
                String => $Body,
            );

            # display inline images if exists
            my %Attachments = %{ $ArticleTmp->{Atms} };
            my $SessionID   = '';
            if ( $Self->{SessionID} && !$Self->{SessionIDCookie} ) {
                $SessionID = ';' . $Self->{SessionName} . '=' . $Self->{SessionID};
            }
            my $AttachmentLink = $Self->{Baselink}
                . 'Action=PictureUpload'
                . ';FormID='
                . $Param{FormID}
                . $SessionID
                . ';ContentID=';

            # search inline documents in body and add it to upload cache
            $Body =~ s{
                "cid:(.*?)"
            }
            {

                # find attachment to include
                my $ContentID = $1;

                ATMCOUNT:
                for my $AttachmentID ( keys %Attachments ) {

                    # remember not included real attachments
                    if ( $Attachments{$AttachmentID}->{ContentID} !~ /^<$ContentID>$/i ) {
                        push @NotInlineAttachments, $AttachmentID;
                        next ATMCOUNT;
                    }

                    # add to upload cache
                    my %AttachmentPicture = $Self->{TicketObject}->ArticleAttachment(
                        ArticleID => $Param{ArticleID},
                        FileID    => $AttachmentID,
                    );

                    # content id cleanup
                    $AttachmentPicture{ContentID} =~ s/^<//;
                    $AttachmentPicture{ContentID} =~ s/>$//;

                    $Param{UploadCacheObject}->FormIDAddFile(
                        FormID      => $Param{FormID},
                        Disposition => 'inline',
                        %{ $Attachments{$AttachmentID} },
                        %AttachmentPicture,
                    );
                    my @Attachments = $Param{UploadCacheObject}->FormIDGetAllFilesMeta(
                        FormID => $Param{FormID},
                    );
                    CONTENTIDRETURN:
                    for my $Attachment (@Attachments) {
                        next CONTENTIDRETURN
                            if $Attachments{$AttachmentID}->{Filename} ne $Attachment->{Filename};
                        $ContentID = $AttachmentLink . $Attachment->{ContentID};
                        last CONTENTIDRETURN;
                    }
                    last ATMCOUNT;
                }

                # return link
                '"' . $ContentID . '"';
            }egxi;

            # attach also other attachments (add all if no "cid:" was in html reply)
            my @Attachments = $Param{UploadCacheObject}->FormIDGetAllFilesMeta(
                FormID => $Param{FormID},
            );
            if ( !@Attachments ) {
                for my $Index ( keys %Attachments ) {
                    push @NotInlineAttachments, $Index;
                }
            }

            # do no more article
            last ARTICLE;
        }

        # attach also other attachments on article forward
        if ( $Body && $Param{AttachmentsInclude} ) {
            for my $AttachmentID (@NotInlineAttachments) {
                my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                    ArticleID => $Param{ArticleID},
                    FileID    => $AttachmentID,
                    UserID    => $Self->{UserID},
                );

                # add attachment
                $Param{UploadCacheObject}->FormIDAddFile(
                    FormID => $Param{FormID},
                    %Attachment,
                );
            }
        }
        return $Body if $Body;
    }

    # as fallback use text body for quote
    my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Param{ArticleID} );

    # check if original content isn't text/plain or text/html, don't use it
    if ( !$Article{ContentType} ) {
        $Article{ContentType} = 'text/plain';
    }

    if ( $Article{ContentType} !~ /text\/(plain|html)/i ) {
        $Article{Body}        = '-> no quotable message <-';
        $Article{ContentType} = 'text/plain';
    }
    else {
        my $Size = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail') || 82;
        $Article{Body} =~ s/(^>.+|.{4,$Size})(?:\s|\z)/$1\n/gm;
    }

    # attach attachments
    if ( $Param{AttachmentsInclude} ) {
        my %ArticleIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ArticleID => $Param{ArticleID},
            UserID    => $Self->{UserID},
        );
        for my $Index ( keys %ArticleIndex ) {
            my %Attachment = $Self->{TicketObject}->ArticleAttachment(
                ArticleID => $Param{ArticleID},
                FileID    => $Index,
                UserID    => $Self->{UserID},
            );

            # add attachment
            $Param{UploadCacheObject}->FormIDAddFile(
                FormID => $Param{FormID},
                %Attachment,
            );
        }
    }

    # return body as html
    if ( $Self->{ConfigObject}->Get('Frontend::RichText') ) {

        $Article{Body} = $Self->Ascii2Html(
            Text           => $Article{Body},
            HTMLResultMode => 1,
            LinkFeature    => 1,
        );
    }

    # return body as plain text
    return $Article{Body};
}

sub TicketListShow {
    my ( $Self, %Param ) = @_;

    # take object ref to local, remove it from %Param (prevent memory leak)
    my $Env = $Param{Env};
    delete $Param{Env};

    # lookup latest used view mode
    if ( !$Param{View} && $Self->{ 'UserTicketOverview' . $Env->{Action} } ) {
        $Param{View} = $Self->{ 'UserTicketOverview' . $Env->{Action} };
    }

    # set defaut view mode to 'small'
    my $View = $Param{View} || 'Small';

    # set default view mode for AgentTicketQueue
    if ( !$Param{View} && $Env->{Action} eq 'AgentTicketQueue' ) {
        $View = 'Preview';
    }

    # store latest view mode
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'UserTicketOverview' . $Env->{Action},
        Value     => $View,
    );

    # update preferences
    if ( !$Self->{ConfigObject}->Get('DemoSystem') ) {
        $Self->{UserObject}->SetPreferences(
            UserID => $Self->{UserID},
            Key    => 'UserTicketOverview' . $Env->{Action},
            Value  => $View,
        );
    }

    # check backends
    my $Backends = $Self->{ConfigObject}->Get('Ticket::Frontend::Overview');
    if ( !$Backends ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Need config option Ticket::Frontend::Overview',
        );
    }
    if ( ref $Backends ne 'HASH' ) {
        return $Env->{LayoutObject}->FatalError(
            Message => 'Config option Ticket::Frontend::Overview need to be HASH ref!',
        );
    }

    # check if selected view is available
    if ( !$Backends->{$View} ) {

        # try to find fallback, take first configured view mode
        for my $Key ( sort keys %{$Backends} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "No Config option found for view mode $View, took $Key instead!",
                Message  => 'Need Depend Param Ajax option!',
            );
            $View = $Key;
            last;
        }
    }

    # load overview backend module
    if ( !$Self->{MainObject}->Require( $Backends->{$View}->{Module} ) ) {
        return $Env->{LayoutObject}->FatalError();
    }
    my $Object = $Backends->{$View}->{Module}->new( %{$Env} );
    return if !$Object;

    # run action row backend module
    $Param{ActionRow} = $Object->ActionRow(
        %Param,
        Config => $Backends->{$View},
    );

    # run overview backend module
    $Param{SortOrderBar} = $Object->SortOrderBar(
        %Param,
        Config => $Backends->{$View},
    );

    # check start option, if higher then tickets available, set
    # it to the last ticket page (Thanks to Stefan Schmidt!)
    my $StartHit = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;

    # get personal page shown count
    my $PageShownPreferencesKey = 'UserTicketOverview' . $View . 'PageShown';
    my $PageShown               = $Self->{$PageShownPreferencesKey} || 10;
    my $Group                   = 'TicketOverview' . $View . 'PageShown';

    # get data selection
    my %Data;
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    if ( $Config && $Config->{$Group} && $Config->{$Group}->{Data} ) {
        %Data = %{ $Config->{$Group}->{Data} };
    }

    # calculate max. sown page
    if ( $StartHit > $Param{Total} ) {
        my $Pages = int( ( $Param{Total} / $PageShown ) + 0.99999 );
        $StartHit = ( ( $Pages - 1 ) * $PageShown ) + 1;
    }

    # build nav bar
    my $Limit = $Param{Limit} || 20_000;
    my %PageNav = $Env->{LayoutObject}->PageNavBar(
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Action    => 'Action=' . $Env->{LayoutObject}->{Action},
        Link      => $Param{LinkPage},
        IDPrefix  => $Env->{LayoutObject}->{Action},
    );

    # build shown ticket a page
    $Param{RequestedURL}    = "Action=$Self->{Action}";
    $Param{Group}           = $Group;
    $Param{PageShownString} = $Self->BuildSelection(
        Name       => $PageShownPreferencesKey,
        SelectedID => $PageShown,
        Data       => \%Data,
    );

    # nav bar at the beginning of a overview
    $Param{View} = $View;
    $Env->{LayoutObject}->Block(
        Name => 'OverviewNavBar',
        Data => \%Param,
    );

    # back link
    if ( $Param{LinkBack} ) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageBack',
            Data => \%Param,
        );
    }

    # filter selection
    if ( $Param{Filters} ) {
        my @NavBarFilters;
        for my $Prio ( sort keys %{ $Param{Filters} } ) {
            push @NavBarFilters, $Param{Filters}->{$Prio};
        }
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarFilter',
            Data => {
                %Param,
            },
        );
        my $Count = 0;
        for my $Filter (@NavBarFilters) {
            $Count++;
            if ( $Count == scalar @NavBarFilters ) {
                $Filter->{CSS} = 'Last';
            }
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarFilterItem',
                Data => {
                    %Param,
                    %{$Filter},
                },
            );
            if ( $Filter->{Filter} eq $Param{Filter} ) {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelected',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
            else {
                $Env->{LayoutObject}->Block(
                    Name => 'OverviewNavBarFilterItemSelectedNot',
                    Data => {
                        %Param,
                        %{$Filter},
                    },
                );
            }
        }
    }

    # view mode
    for my $Backend ( keys %{$Backends} ) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarViewMode',
            Data => {
                %Param,
                %{ $Backends->{$Backend} },
                Filter => $Param{Filter},
                View   => $Backend,
            },
        );
        if ( $View eq $Backend ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
        else {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarViewModeNotSelected',
                Data => {
                    %Param,
                    %{ $Backends->{$Backend} },
                    Filter => $Param{Filter},
                    View   => $Backend,
                },
            );
        }
    }

    if (%PageNav) {
        $Env->{LayoutObject}->Block(
            Name => 'OverviewNavBarPageNavBar',
            Data => \%PageNav,
        );
    }

    if ( $Param{NavBar} ) {
        if ( $Param{NavBar}->{MainName} ) {
            $Env->{LayoutObject}->Block(
                Name => 'OverviewNavBarMain',
                Data => $Param{NavBar},
            );
        }
    }

    my $OutputNavBar = $Env->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOverviewNavBar',
        Data         => { %Param, },
    );
    my $OutputRaw = '';
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print( Output => \$OutputNavBar );
    }
    else {
        $OutputRaw .= $OutputNavBar;
    }

    # run overview backend module
    my $Output = $Object->Run(
        %Param,
        Config    => $Backends->{$View},
        Limit     => $Limit,
        StartHit  => $StartHit,
        PageShown => $PageShown,
        AllHits   => $Param{Total} || 0,
        Output    => $Param{Output} || '',
    );
    if ( !$Param{Output} ) {
        $Env->{LayoutObject}->Print( Output => \$Output );
    }
    else {
        $OutputRaw .= $Output;
    }

    # nav bar at the end of a overview
    #    $Env->{LayoutObject}->Block(
    #        Name => 'OverviewNavBar',
    #        Data => \%Param,
    #    );
    #    if (%PageNav) {
    #        $Env->{LayoutObject}->Block(
    #            Name => 'OverviewNavBarPageNavBar',
    #            Data => \%PageNav,
    #        );
    #    }
    #    my $OutputNavBarSmall = $Env->{LayoutObject}->Output(
    #        TemplateFile => 'AgentTicketOverviewNavBarSmall',
    #        Data         => { %Param, },
    #    );
    #    if ( !$Param{Output} ) {
    #        $Env->{LayoutObject}->Print( Output => \$OutputNavBarSmall );
    #    }
    #    else {
    #        $OutputRaw .= $OutputNavBarSmall;
    #    }

    return $OutputRaw;
}

sub TicketMetaItemsCount {
    my ( $Self, %Param ) = @_;
    return ( 'Priority', 'New Article' );

    #    return ('New Article', 'Locked', 'Watched');
}

sub TicketMetaItems {
    my ( $Self, %Param ) = @_;

    if ( ref $Param{Ticket} ne 'HASH' ) {
        $Self->FatalError( Message => 'Need Hash ref in Ticket param!' );
    }

    # return attributes
    my @Result;

    # show priority
    if (1) {
        push @Result, {

            #            Image => $Image,
            Title      => $Param{Ticket}->{Priority},
            Class      => 'Flag',
            ClassSpan  => 'PriorityID-' . $Param{Ticket}->{PriorityID},
            ClassTable => 'Flags',
        };
    }

    # show new article
    if (1) {
        my %TicketFlag = $Self->{TicketObject}->TicketFlagGet(
            TicketID => $Param{Ticket}->{TicketID},
            UserID   => $Self->{UserID},
        );

        # show if now message is in there
        if ( $TicketFlag{Seen} ) {
            push @Result, undef;
        }
        else {

            # just show ticket flags if agent belongs to the ticket
            my $ShowMeta;
            if (
                $Self->{UserID} == $Param{Ticket}->{OwnerID}
                || $Self->{UserID} == $Param{Ticket}->{ResponsibleID}
                )
            {
                $ShowMeta = 1;
            }
            if ( !$ShowMeta && $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
                my %Watch = $Self->{TicketObject}->TicketWatchGet(
                    TicketID => $Param{Ticket}->{TicketID},
                );
                if ( $Watch{ $Self->{UserID} } ) {
                    $ShowMeta = 1;
                }
            }

            # show ticket flags
            my $Image = 'meta-new-inactive.png';
            if ($ShowMeta) {
                $Image = 'meta-new.png';
                push @Result, {
                    Image      => $Image,
                    Title      => 'New Article!',
                    Class      => 'UnreadArticles',
                    ClassSpan  => 'UnreadArticles Important',
                    ClassTable => 'UnreadArticles',
                };
            }
            else {
                push @Result, {
                    Image      => $Image,
                    Title      => 'New Article!',
                    Class      => 'UnreadArticles',
                    ClassSpan  => 'UnreadArticles Unimportant',
                    ClassTable => 'UnreadArticles',
                };
            }
        }
    }

    # show if it's locked
    if (0) {
        if ( $Param{Ticket}->{Lock} eq 'lock' ) {
            if ( $Param{Ticket}->{OwnerID} == $Self->{UserID} ) {
                push @Result, {
                    Image => 'meta-lock-own.gif',
                    Title => 'Locked by you!',
                };
            }
            else {
                push @Result, {
                    Image => 'meta-lock.gif',
                    Title => 'Locked by somebody else!',
                };
            }
        }
        else {
            push @Result, undef;
        }
    }

    # check if it get watched
    if ( 0 && $Self->{ConfigObject}->Get('Ticket::Watcher') ) {
        my %Watch = $Self->{TicketObject}->TicketWatchGet(
            TicketID => $Param{Ticket}->{TicketID},
        );
        if ( $Watch{ $Self->{UserID} } ) {
            push @Result, {
                Image => 'meta-watch.gif',
                Title => 'Watched by you!',
            };
        }
        else {
            push @Result, undef;
        }
    }

    return @Result;
}

1;
