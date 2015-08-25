# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPrint;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my $Output;
    my $QueueID = $TicketObject->TicketQueueID( TicketID => $Self->{TicketID} );
    my $ArticleID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ArticleID' );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} || !$QueueID ) {
        return $LayoutObject->ErrorScreen( Message => 'Need TicketID!' );
    }

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    return $LayoutObject->NoPermission( WithHeader => 'yes' ) if !$Access;

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    # get linked objects
    my $LinkObject       = $Kernel::OM->Get('Kernel::System::LinkObject');
    my $LinkListWithData = $LinkObject->LinkListWithData(
        Object           => 'Ticket',
        Key              => $Self->{TicketID},
        State            => 'Valid',
        UserID           => $Self->{UserID},
        ObjectParameters => {
            Ticket => {
                IgnoreLinkedTicketStateTypes => 1,
            },
        },
    );

    # get link type list
    my %LinkTypeList = $LinkObject->TypeList(
        UserID => $Self->{UserID},
    );

    # get the link data
    my %LinkData;
    if ( $LinkListWithData && ref $LinkListWithData eq 'HASH' && %{$LinkListWithData} ) {
        %LinkData = $LayoutObject->LinkObjectTableCreate(
            LinkListWithData => $LinkListWithData,
            ViewMode         => 'SimpleRaw',
        );
    }

    # get content
    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
    );
    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID                   => $Self->{TicketID},
        StripPlainBodyAsAttachment => 1,
        UserID                     => $Self->{UserID},
        DynamicFields              => 0,
    );

    # check if only one article need printed
    if ($ArticleID) {

        ARTICLE:
        for my $Article (@ArticleBox) {
            if ( $Article->{ArticleID} == $ArticleID ) {
                @ArticleBox = ($Article);
                last ARTICLE;
            }
        }
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config settings
    my $ZoomExpandSort = $ConfigObject->Get('Ticket::Frontend::ZoomExpandSort');

    # resort article order
    if ( $ZoomExpandSort eq 'reverse' ) {
        @ArticleBox = reverse(@ArticleBox);
    }

    # show total accounted time if feature is active:
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        $Ticket{TicketTimeUnits} = $TicketObject->TicketAccountedTimeGet(
            TicketID => $Ticket{TicketID},
        );
    }

    # get user object
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # user info
    my %UserInfo = $UserObject->GetUserData(
        User => $Ticket{Owner},
    );

    # responsible info
    my %ResponsibleInfo;
    if ( $ConfigObject->Get('Ticket::Responsible') && $Ticket{Responsible} ) {
        %ResponsibleInfo = $UserObject->GetUserData(
            User => $Ticket{Responsible},
        );
    }

    # customer info
    my %CustomerData;
    if ( $Ticket{CustomerUserID} ) {
        %CustomerData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );
    }

    # do some html quoting
    $Ticket{Age} = $LayoutObject->CustomerAge(
        Age   => $Ticket{Age},
        Space => ' ',
    );

    if ( $Ticket{UntilTime} ) {
        $Ticket{PendingUntil} = $LayoutObject->CustomerAge(
            Age   => $Ticket{UntilTime},
            Space => ' ',
        );
    }

    # get PDF object
    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

    my $PrintedBy = $LayoutObject->{LanguageObject}->Translate('printed by');
    my $Time      = $LayoutObject->{Time};
    my %Page;

    # get maximum number of pages
    $Page{MaxPages} = $ConfigObject->Get('PDF::MaxPages');
    if ( !$Page{MaxPages} || $Page{MaxPages} < 1 || $Page{MaxPages} > 1000 ) {
        $Page{MaxPages} = 100;
    }
    my $HeaderRight  = $ConfigObject->Get('Ticket::Hook') . $Ticket{TicketNumber};
    my $HeadlineLeft = $HeaderRight;
    my $Title        = $HeaderRight;
    if ( $Ticket{Title} ) {
        $HeadlineLeft = $Ticket{Title};
        $Title .= ' / ' . $Ticket{Title};
    }

    $Page{MarginTop}    = 30;
    $Page{MarginRight}  = 40;
    $Page{MarginBottom} = 40;
    $Page{MarginLeft}   = 40;
    $Page{HeaderRight}  = $HeaderRight;
    $Page{FooterLeft}   = '';
    $Page{PageText}     = $LayoutObject->{LanguageObject}->Translate('Page');
    $Page{PageCount}    = 1;

    # create new pdf document
    $PDFObject->DocumentNew(
        Title  => $ConfigObject->Get('Product') . ': ' . $Title,
        Encode => $LayoutObject->{UserCharset},
    );

    # create first pdf page
    $PDFObject->PageNew(
        %Page,
        FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
    );
    $Page{PageCount}++;

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # output title
    $PDFObject->Text(
        Text     => $Ticket{Title},
        FontSize => 13,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # output "printed by"
    $PDFObject->Text(
        Text => $PrintedBy . ' '
            . $Self->{UserFirstname} . ' '
            . $Self->{UserLastname} . ' ('
            . $Self->{UserEmail} . ')'
            . ', ' . $Time,
        FontSize => 9,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -14,
    );

    # output ticket infos
    $Self->_PDFOutputTicketInfos(
        PageData        => \%Page,
        TicketData      => \%Ticket,
        UserData        => \%UserInfo,
        ResponsibleData => \%ResponsibleInfo,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    $PDFObject->HLine(
        Color     => '#aaa',
        LineWidth => 0.5,
    );

    # output ticket dynamic fields
    $Self->_PDFOutputTicketDynamicFields(
        PageData   => \%Page,
        TicketData => \%Ticket,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    $PDFObject->HLine(
        Color     => '#aaa',
        LineWidth => 0.5,
    );

    # output linked objects
    if (%LinkData) {
        $Self->_PDFOutputLinkedObjects(
            PageData     => \%Page,
            LinkData     => \%LinkData,
            LinkTypeList => \%LinkTypeList,
        );
    }

    # output customer infos
    if (%CustomerData) {
        $Self->_PDFOutputCustomerInfos(
            PageData     => \%Page,
            CustomerData => \%CustomerData,
        );
    }

    # output articles
    $Self->_PDFOutputArticles(
        PageData    => \%Page,
        ArticleData => \@ArticleBox,
    );

    # get ticket object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # return the pdf document
    my $Filename = 'Ticket_' . $Ticket{TicketNumber};
    my ( $s, $m, $h, $D, $M, $Y ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );
    $M = sprintf( "%02d", $M );
    $D = sprintf( "%02d", $D );
    $h = sprintf( "%02d", $h );
    $m = sprintf( "%02d", $m );
    my $PDFString = $PDFObject->DocumentOutput();
    return $LayoutObject->Attachment(
        Filename    => $Filename . "_" . "$Y-$M-$D" . "_" . "$h-$m.pdf",
        ContentType => "application/pdf",
        Content     => $PDFString,
        Type        => 'inline',
    );
}

sub _PDFOutputTicketInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageData TicketData UserData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    my %Ticket   = %{ $Param{TicketData} };
    my %UserInfo = %{ $Param{UserData} };
    my %Page     = %{ $Param{PageData} };

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # create left table
    my $TableLeft = [
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('State'),
            Value => $LayoutObject->{LanguageObject}->Translate( $Ticket{State} ),
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Priority'),
            Value => $LayoutObject->{LanguageObject}->Translate( $Ticket{Priority} ),
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Queue'),
            Value => $Ticket{Queue},
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Lock'),
            Value => $LayoutObject->{LanguageObject}->Translate( $Ticket{Lock} ),
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('CustomerID'),
            Value => $Ticket{CustomerID},
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Owner'),
            Value => $Ticket{Owner} . ' ('
                . $UserInfo{UserFirstname} . ' '
                . $UserInfo{UserLastname} . ')',
        },
    ];

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # add responsible row, if feature is enabled
    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        my $Responsible = '-';
        if ( $Ticket{Responsible} ) {
            $Responsible = $Ticket{Responsible} . ' ('
                . $Param{ResponsibleData}->{UserFirstname} . ' '
                . $Param{ResponsibleData}->{UserLastname} . ')';
        }
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Responsible'),
            Value => $Responsible,
        };
        push( @{$TableLeft}, $Row );
    }

    # add type row, if feature is enabled
    if ( $ConfigObject->Get('Ticket::Type') ) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Type'),
            Value => $Ticket{Type},
        };
        push( @{$TableLeft}, $Row );
    }

    # add service and sla row, if feature is enabled
    if ( $ConfigObject->Get('Ticket::Service') ) {
        my $RowService = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Service'),
            Value => $Ticket{Service} || '-',
        };
        push( @{$TableLeft}, $RowService );
        my $RowSLA = {
            Key   => $LayoutObject->{LanguageObject}->Translate('SLA'),
            Value => $Ticket{SLA} || '-',
        };
        push( @{$TableLeft}, $RowSLA );
    }

    # create right table
    my $TableRight = [
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Age'),
            Value => $LayoutObject->{LanguageObject}->Translate( $Ticket{Age} ),
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Created'),
            Value => $LayoutObject->{LanguageObject}->FormatTimeString(
                $Ticket{Created},
                'DateFormat',
            ),
        },
    ];

    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Accounted time'),
            Value => $Ticket{TicketTimeUnits},
        };
        push( @{$TableRight}, $Row );
    }

    # only show pending until unless it is really pending
    if ( $Ticket{PendingUntil} ) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Pending till'),
            Value => $Ticket{PendingUntil},
        };
        push( @{$TableRight}, $Row );
    }

    # add first response time row
    if ( defined( $Ticket{FirstResponseTime} ) ) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('First Response Time'),
            Value => $LayoutObject->{LanguageObject}->FormatTimeString(
                $Ticket{FirstResponseTimeDestinationDate},
                'DateFormat',
                'NoSeconds',
            ),
        };
        push( @{$TableRight}, $Row );
    }

    # add update time row
    if ( defined( $Ticket{UpdateTime} ) ) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Update Time'),
            Value => $LayoutObject->{LanguageObject}->FormatTimeString(
                $Ticket{UpdateTimeDestinationDate},
                'DateFormat',
                'NoSeconds',
            ),
        };
        push( @{$TableRight}, $Row );
    }

    # add solution time row
    if ( defined( $Ticket{SolutionTime} ) ) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Solution Time'),
            Value => $LayoutObject->{LanguageObject}->FormatTimeString(
                $Ticket{SolutionTimeDestinationDate},
                'DateFormat',
                'NoSeconds',
            ),
        };
        push( @{$TableRight}, $Row );
    }

    my $Rows = @{$TableLeft};
    if ( @{$TableRight} > $Rows ) {
        $Rows = @{$TableRight};
    }

    my %TableParam;
    for my $Row ( 1 .. $Rows ) {
        $Row--;
        $TableParam{CellData}[$Row][0]{Content}         = $TableLeft->[$Row]->{Key};
        $TableParam{CellData}[$Row][0]{Font}            = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content}         = $TableLeft->[$Row]->{Value};
        $TableParam{CellData}[$Row][2]{Content}         = ' ';
        $TableParam{CellData}[$Row][2]{BackgroundColor} = '#FFFFFF';
        $TableParam{CellData}[$Row][3]{Content}         = $TableRight->[$Row]->{Key};
        $TableParam{CellData}[$Row][3]{Font}            = 'ProportionalBold';
        $TableParam{CellData}[$Row][4]{Content}         = $TableRight->[$Row]->{Value};
    }

    $TableParam{ColumnData}[0]{Width} = 70;
    $TableParam{ColumnData}[1]{Width} = 156.5;
    $TableParam{ColumnData}[2]{Width} = 1;
    $TableParam{ColumnData}[3]{Width} = 70;
    $TableParam{ColumnData}[4]{Width} = 156.5;

    $TableParam{Type}                = 'Cut';
    $TableParam{Border}              = 0;
    $TableParam{FontSize}            = 7;
    $TableParam{BackgroundColorEven} = '#F2F2F2';
    $TableParam{Padding}             = 6;
    $TableParam{PaddingTop}          = 3;
    $TableParam{PaddingBottom}       = 3;

    # output table
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # get PDF object
        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        # output table (or a fragment of it)
        %TableParam = $PDFObject->Table( %TableParam, );

        # stop output or output next page
        if ( $TableParam{State} ) {
            last PAGE;
        }
        else {
            $PDFObject->PageNew(
                %Page,
                FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }
    return 1;
}

sub _PDFOutputLinkedObjects {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageData LinkData LinkTypeList)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my %Page     = %{ $Param{PageData} };
    my %TypeList = %{ $Param{LinkTypeList} };
    my %TableParam;
    my $Row = 0;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %{ $Param{LinkData} } ) {

        # investigate link type name
        my @LinkData = split q{::}, $LinkTypeLinkDirection;
        my $LinkTypeName = $TypeList{ $LinkData[0] }->{ $LinkData[1] . 'Name' };
        $LinkTypeName = $LayoutObject->{LanguageObject}->Translate($LinkTypeName);

        # define headline
        $TableParam{CellData}[$Row][0]{Content} = $LinkTypeName . ':';
        $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content} = '';

        # extract object list
        my $ObjectList = $Param{LinkData}->{$LinkTypeLinkDirection};

        for my $Object ( sort { lc $a cmp lc $b } keys %{$ObjectList} ) {

            for my $Item ( @{ $ObjectList->{$Object} } ) {

                $TableParam{CellData}[$Row][0]{Content} ||= '';
                $TableParam{CellData}[$Row][1]{Content} = $Item->{Title} || '';
            }
            continue {
                $Row++;
            }
        }
    }

    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 431;

    # get PDF object
    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

    # set new position
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -10,
    );

    # output headline
    $PDFObject->Text(
        Text     => $LayoutObject->{LanguageObject}->Translate('Linked Objects'),
        Height   => 10,
        Type     => 'Cut',
        Font     => 'Proportional',
        FontSize => 9,
        Color    => '#666666',
    );

    # set new position
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -4,
    );

    # table params
    $TableParam{Type}            = 'Cut';
    $TableParam{Border}          = 0;
    $TableParam{FontSize}        = 6;
    $TableParam{Padding}         = 1;
    $TableParam{PaddingTop}      = 3;
    $TableParam{PaddingBottom}   = 3;

    # output table
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # output table (or a fragment of it)
        %TableParam = $PDFObject->Table( %TableParam, );

        # stop output or output next page
        if ( $TableParam{State} ) {
            last PAGE;
        }
        else {
            $PDFObject->PageNew(
                %Page,
                FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
            );
            $Page{PageCount}++;
        }
    }

    return 1;
}

sub _PDFOutputTicketDynamicFields {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageData TicketData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    my $Output = 0;
    my %Ticket = %{ $Param{TicketData} };
    my %Page   = %{ $Param{PageData} };

    my %TableParam;
    my $Row = 0;

    # get dynamic field config for frontend module
    my $DynamicFieldFilter
        = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::AgentTicketPrint")->{DynamicField};

    # get the dynamic fields for ticket object
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # generate table
    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $Value = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Ticket{TicketID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq "";

        # get print string for this dynamic field
        my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            HTMLOutput         => 0,
            LayoutObject       => $LayoutObject,
        );

        $TableParam{CellData}[$Row][0]{Content}
            = $LayoutObject->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} )
            . ':';
        $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content} = $ValueStrg->{Value};

        $Row++;
        $Output = 1;
    }

    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 431;

    # output ticket dynamic fields
    if ($Output) {

        # get PDF object
        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        # set new position
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -10,
        );

        # output headline
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Ticket Dynamic Fields'),
            Height   => 10,
            Type     => 'Cut',
            Font     => 'Proportional',
            FontSize => 8,
            Color    => '#666666',
        );

        # set new position
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # table params
        $TableParam{Type}            = 'Cut';
        $TableParam{Border}          = 0;
        $TableParam{FontSize}        = 6;
        $TableParam{Padding}         = 1;
        $TableParam{PaddingTop}      = 3;
        $TableParam{PaddingBottom}   = 3;

        # output table
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # output table (or a fragment of it)
            %TableParam = $PDFObject->Table( %TableParam, );

            # stop output or output next page
            if ( $TableParam{State} ) {
                last PAGE;
            }
            else {
                $PDFObject->PageNew(
                    %Page,
                    FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
                );
                $Page{PageCount}++;
            }
        }
    }
    return 1;
}

sub _PDFOutputCustomerInfos {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageData CustomerData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    my $Output       = 0;
    my %CustomerData = %{ $Param{CustomerData} };
    my %Page         = %{ $Param{PageData} };
    my %TableParam;
    my $Row = 0;
    my $Map = $CustomerData{Config}->{Map};

    # check if customer company support is enabled
    if ( $CustomerData{Config}->{CustomerCompanySupport} ) {
        my $Map2 = $CustomerData{CompanyConfig}->{Map};
        if ($Map2) {
            push( @{$Map}, @{$Map2} );
        }
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Field ( @{$Map} ) {
        if ( ${$Field}[3] && $CustomerData{ ${$Field}[0] } ) {
            $TableParam{CellData}[$Row][0]{Content} = $LayoutObject->{LanguageObject}->Translate( ${$Field}[1] ) . ':';
            $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
            $TableParam{CellData}[$Row][1]{Content} = $CustomerData{ ${$Field}[0] };

            $Row++;
            $Output = 1;
        }
    }
    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 431;

    if ($Output) {

        # get PDF object
        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        # set new position
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -10,
        );

        $PDFObject->HLine(
            Color     => '#aaa',
            LineWidth => 0.5,
        );

        # set new position
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # output headline
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Customer Information'),
            Height   => 10,
            Type     => 'Cut',
            Font     => 'Proportional',
            FontSize => 8,
            Color    => '#666666',
        );

        # set new position
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # table params
        $TableParam{Type}            = 'Cut';
        $TableParam{Border}          = 0;
        $TableParam{FontSize}        = 6;
        $TableParam{Padding}         = 1;
        $TableParam{PaddingTop}      = 3;
        $TableParam{PaddingBottom}   = 3;

        # output table
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # output table (or a fragment of it)
            %TableParam = $PDFObject->Table( %TableParam, );

            # stop output or output next page
            if ( $TableParam{State} ) {
                last PAGE;
            }
            else {
                $PDFObject->PageNew(
                    %Page,
                    FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
                );
                $Page{PageCount}++;
            }
        }
    }
    return 1;
}

sub _PDFOutputArticles {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(PageData ArticleData)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    my %Page = %{ $Param{PageData} };

    # get needed objects
    my $PDFObject    = $Kernel::OM->Get('Kernel::System::PDF');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ArticleCounter = 1;
    for my $ArticleTmp ( @{ $Param{ArticleData} } ) {

        my %Article = %{$ArticleTmp};

        # get attachment string
        my %AtmIndex = ();
        if ( $Article{Atms} ) {
            %AtmIndex = %{ $Article{Atms} };
        }
        my $Attachments;
        for my $FileID ( sort keys %AtmIndex ) {
            my %File = %{ $AtmIndex{$FileID} };
            $Attachments .= $File{Filename} . ' (' . $File{Filesize} . ")\n";
        }

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # show total accounted time if feature is active:
        if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
            $Article{'Accounted time'} = $Kernel::OM->Get('Kernel::System::Ticket')->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID},
            );
        }

        # generate article info table
        my %TableParam1;
        my $Row = 0;

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -6,
        );

        # article number tag
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Article') . ' #' . $ArticleCounter,
            Height   => 10,
            Type     => 'Cut',
            Font     => 'Proportional',
            FontSize => 8,
            Color    => '#666666',
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => 2,
        );

        for my $Parameter ( 'From', 'To', 'Cc', 'Accounted time', 'Subject', ) {
            if ( $Article{$Parameter} ) {
                $TableParam1{CellData}[$Row][0]{Content} = $LayoutObject->{LanguageObject}->Translate($Parameter) . ':';
                $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
                $TableParam1{CellData}[$Row][1]{Content} = $Article{$Parameter};
                $Row++;
            }
        }
        $TableParam1{CellData}[$Row][0]{Content} = $LayoutObject->{LanguageObject}->Translate('Created') . ':';
        $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam1{CellData}[$Row][1]{Content} = $LayoutObject->{LanguageObject}->FormatTimeString(
            $Article{Created},
            'DateFormat',
        );
        $TableParam1{CellData}[$Row][1]{Content}
            .= ' ' . $LayoutObject->{LanguageObject}->Translate('by');
        $TableParam1{CellData}[$Row][1]{Content}
            .= ' ' . $LayoutObject->{LanguageObject}->Translate( $Article{SenderType} );
        $Row++;

        # get dynamic field config for frontend module
        my $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::AgentTicketPrint")->{DynamicField};

        # get the dynamic fields for ticket object
        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Article'],
            FieldFilter => $DynamicFieldFilter || {},
        );

        #  get dynamicfield backend object
        my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # generate table
        # cycle trough the activated Dynamic Fields for ticket object
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $Value = $DynamicFieldBackendObject->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Article{ArticleID},
            );

            next DYNAMICFIELD if !$Value;
            next DYNAMICFIELD if $Value eq "";

            # get print string for this dynamic field
            my $ValueStrg = $DynamicFieldBackendObject->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                HTMLOutput         => 0,
                LayoutObject       => $LayoutObject,
            );
            $TableParam1{CellData}[$Row][0]{Content}
                = $LayoutObject->{LanguageObject}->Translate( $DynamicFieldConfig->{Label} )
                . ':';
            $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
            $TableParam1{CellData}[$Row][1]{Content} = $ValueStrg->{Value};
            $Row++;
        }

        $TableParam1{CellData}[$Row][0]{Content} = $LayoutObject->{LanguageObject}->Translate('Type') . ':';
        $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam1{CellData}[$Row][1]{Content} = $LayoutObject->{LanguageObject}->Translate( $Article{ArticleType} );
        $Row++;

        if ($Attachments) {
            $TableParam1{CellData}[$Row][0]{Content} = $LayoutObject->{LanguageObject}->Translate('Attachment') . ':';
            $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
            chomp($Attachments);
            $TableParam1{CellData}[$Row][1]{Content} = $Attachments;
        }
        $TableParam1{ColumnData}[0]{Width} = 80;
        $TableParam1{ColumnData}[1]{Width} = 431;

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -6,
        );

        $PDFObject->HLine(
            Color     => '#aaa',
            LineWidth => 0.5,
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -6,
        );

        # table params (article infos)
        $TableParam1{Type}            = 'Cut';
        $TableParam1{Border}          = 0;
        $TableParam1{FontSize}        = 6;
        $TableParam1{Padding}         = 1;
        $TableParam1{PaddingTop}      = 3;
        $TableParam1{PaddingBottom}   = 3;

        # output table (article infos)
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # output table (or a fragment of it)
            %TableParam1 = $PDFObject->Table( %TableParam1, );

            # stop output or output next page
            if ( $TableParam1{State} ) {
                last PAGE;
            }
            else {
                $PDFObject->PageNew(
                    %Page,
                    FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
                );
                $Page{PageCount}++;
            }
        }

        if ( $Article{ArticleType} eq 'chat-external' || $Article{ArticleType} eq 'chat-internal' )
        {
            $Article{Body} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $Article{Body}
            );
            my $Lines;
            if ( IsArrayRefWithData( $Article{Body} ) ) {
                for my $Line ( @{ $Article{Body} } ) {
                    if ( $Line->{SystemGenerated} ) {
                        $Lines .= '[' . $Line->{CreateTime} . '] ' . $Line->{MessageText} . "\n";
                    }
                    else {
                        $Lines
                            .= '['
                            . $Line->{CreateTime} . '] '
                            . $Line->{ChatterName} . ' '
                            . $Line->{MessageText} . "\n";
                    }
                }
            }
            $Article{Body} = $Lines;
        }

        # table params (article body)
        my %TableParam2;
        $TableParam2{CellData}[0][0]{Content} = $Article{Body} || ' ';
        $TableParam2{Type}                    = 'Cut';
        $TableParam2{Border}                  = 0;
        $TableParam2{Font}                    = 'Monospaced';
        $TableParam2{FontSize}                = 7;
        $TableParam2{BackgroundColor}         = '#f2f2f2';
        $TableParam2{Padding}                 = 4;
        $TableParam2{PaddingTop}              = 4;
        $TableParam2{PaddingBottom}           = 4;

        # output table (article body)
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # output table (or a fragment of it)
            %TableParam2 = $PDFObject->Table( %TableParam2, );

            # stop output or output next page
            if ( $TableParam2{State} ) {
                last PAGE;
            }
            else {
                $PDFObject->PageNew(
                    %Page,
                    FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
                );
                $Page{PageCount}++;
            }
        }
        $ArticleCounter++;
    }
    return 1;
}

1;
