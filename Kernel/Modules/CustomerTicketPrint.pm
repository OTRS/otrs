# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketPrint;

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

    my $Output;
    my $QueueID;
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen( Message => 'Need TicketID!' );
    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    $QueueID = $TicketObject->TicketQueueID( TicketID => $Self->{TicketID} );
    if ( !$QueueID ) {
        return $LayoutObject->ErrorScreen( Message => 'Need TicketID!' );
    }

    # check permissions
    if (
        !$TicketObject->TicketCustomerPermission(
            Type     => 'ro',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        )
    {

        # error screen, don't show ticket
        return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
    }

    # get content
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 0,
    );
    my @CustomerArticleTypes = $TicketObject->ArticleTypeList( Type => 'Customer' );
    my @ArticleBox = $TicketObject->ArticleContentIndex(
        TicketID                   => $Self->{TicketID},
        ArticleType                => \@CustomerArticleTypes,
        StripPlainBodyAsAttachment => 1,
        UserID                     => $Self->{UserID},
        DynamicFields              => 0,
    );

    # customer info
    my %CustomerData;
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    if ( $Ticket{CustomerUserID} ) {
        %CustomerData = $CustomerUserObject->CustomerUserDataGet(
            User => $Ticket{CustomerUserID},
        );
    }
    elsif ( $Ticket{CustomerID} ) {
        %CustomerData = $CustomerUserObject->CustomerUserDataGet(
            CustomerID => $Ticket{CustomerID},
        );
    }

    # do some html quoting
    $Ticket{Age} = $LayoutObject->CustomerAge(
        Age   => $Ticket{Age},
        Space => ' '
    );
    if ( $Ticket{UntilTime} ) {
        $Ticket{PendingUntil} = $LayoutObject->CustomerAge(
            Age   => $Ticket{UntilTime},
            Space => ' ',
        );
    }
    else {
        $Ticket{PendingUntil} = '-';
    }

    my $PDFObject
        = ( $Kernel::OM->Get('Kernel::Config')->Get('PDF') ) ? $Kernel::OM->Get('Kernel::System::PDF') : undef;

    # generate pdf output
    if ($PDFObject) {
        my $PrintedBy = $LayoutObject->{LanguageObject}->Translate('printed by');
        my $Time      = $LayoutObject->{Time};
        my %Page;
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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

        $Page{MarginTop}     = 30;
        $Page{MarginRight}   = 40;
        $Page{MarginBottom}  = 40;
        $Page{MarginLeft}    = 40;
        $Page{HeaderRight}   = $HeaderRight;
        $Page{HeadlineLeft}  = $HeadlineLeft;
        $Page{HeadlineRight} = $PrintedBy . ' '
            . $Self->{UserFirstname} . ' '
            . $Self->{UserLastname} . ' ('
            . $Self->{UserEmail} . ') '
            . $Time;
        $Page{FooterLeft} = '';
        $Page{PageText}   = $LayoutObject->{LanguageObject}->Translate('Page');
        $Page{PageCount}  = 1;

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

        # type of print tag
        my $PrintTag = '';

        $PrintTag = ( $LayoutObject->{LanguageObject}->Translate('Ticket') ) . ' ' .
            ( $LayoutObject->{LanguageObject}->Translate('Print') );

        # output headline
        $PDFObject->Text(
            Text     => $PrintTag,
            Height   => 9,
            Type     => 'Cut',
            Font     => 'ProportionalBold',
            Align    => 'right',
            FontSize => 9,
            Color    => '#666666',
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -6,
        );

        # output ticket infos
        $Self->_PDFOutputTicketInfos(
            PageData   => \%Page,
            TicketData => \%Ticket,
        );

        # output ticket dynamic fields
        $Self->_PDFOutputTicketDynamicFields(
            PageData   => \%Page,
            TicketData => \%Ticket,
        );

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

        # return the pdf document
        my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');
        my $Filename   = 'Ticket_' . $Ticket{TicketNumber};
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

    # generate html output
    else {

        # output header
        $Output .= $LayoutObject->PrintHeader( Value => $Ticket{TicketNumber} );

        # output customer infos
        if (%CustomerData) {
            $Param{CustomerTable} = $LayoutObject->AgentCustomerViewTable(
                Data => \%CustomerData,
                Max  => 100,
            );
        }

        # show ticket
        $Output .= $Self->_HTMLMask(
            TicketID   => $Self->{TicketID},
            QueueID    => $QueueID,
            ArticleBox => \@ArticleBox,
            %Param,
            %Ticket,
        );

        # add footer
        $Output .= $LayoutObject->PrintFooter();

        # return output
        return $Output;
    }
}

sub _PDFOutputTicketInfos {
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
    my %Ticket = %{ $Param{TicketData} };
    my %Page   = %{ $Param{PageData} };

    # create left table
    my $TableLeft = [];

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config       = $ConfigObject->Get("Ticket::Frontend::CustomerTicketZoom");

    # add ticket data, respecting AttributesView configuration
    for my $Attribute (qw(State Priority Queue Owner)) {
        if ( $Config->{AttributesView}->{$Attribute} ) {
            my $Row = {
                Key   => $LayoutObject->{LanguageObject}->Translate($Attribute) . ':',
                Value => $LayoutObject->{LanguageObject}->Translate( $Ticket{$Attribute} )
                    || $Ticket{$Attribute},
            };
            push( @{$TableLeft}, $Row );
        }
    }

    # add ticket responsible
    if (
        $ConfigObject->Get('Ticket::Responsible')
        &&
        $Config->{AttributesView}->{Responsible}
        )
    {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Responsible') . ':',
            Value => $Ticket{Responsible},
        };
        push( @{$TableLeft}, $Row );
    }

    # add type row, if feature is enabled
    if ( $ConfigObject->Get('Ticket::Type') && $Config->{AttributesView}->{Type} ) {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Type') . ':',
            Value => $Ticket{Type},
        };
        push( @{$TableLeft}, $Row );
    }

    # add service row, if feature is enabled
    if (
        $ConfigObject->Get('Ticket::Service')
        && $Config->{AttributesView}->{Service}
        )
    {
        my $RowService = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Service') . ':',
            Value => $Ticket{Service} || '-',
        };
        push( @{$TableLeft}, $RowService );
    }

    # add sla row, if feature is enabled
    if ( $ConfigObject->Get('Ticket::Service') && $Config->{AttributesView}->{SLA} )
    {
        my $RowSLA = {
            Key   => $LayoutObject->{LanguageObject}->Translate('SLA') . ':',
            Value => $Ticket{SLA} || '-',
        };
        push( @{$TableLeft}, $RowSLA );
    }

    # create right table
    my $TableRight = [
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('CustomerID') . ':',
            Value => $Ticket{CustomerID},
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Age') . ':',
            Value => $LayoutObject->{LanguageObject}->Translate( $Ticket{Age} ),
        },
        {
            Key   => $LayoutObject->{LanguageObject}->Translate('Created') . ':',
            Value => $LayoutObject->{LanguageObject}->FormatTimeString(
                $Ticket{Created},
                'DateFormat',
            ),
        },
    ];

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

    $TableParam{ColumnData}[0]{Width} = 80;
    $TableParam{ColumnData}[1]{Width} = 170.5;
    $TableParam{ColumnData}[2]{Width} = 4;
    $TableParam{ColumnData}[3]{Width} = 80;
    $TableParam{ColumnData}[4]{Width} = 170.5;

    $TableParam{Type}                = 'Cut';
    $TableParam{Border}              = 0;
    $TableParam{FontSize}            = 6;
    $TableParam{BackgroundColorEven} = '#AAAAAA';
    $TableParam{BackgroundColorOdd}  = '#DDDDDD';
    $TableParam{Padding}             = 1;
    $TableParam{PaddingTop}          = 3;
    $TableParam{PaddingBottom}       = 3;

    # output table
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

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

    # get the dynamic fields for ticket object
    my $DynamicFieldFilter
        = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::CustomerTicketPrint")->{DynamicField};
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # generate table
    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

        # skip dynamic field if is not desinged for customer interface
        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        my $Value = $BackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Ticket{TicketID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq "";

        # get print string for this dynamic field
        my $ValueStrg = $BackendObject->DisplayValueRender(
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

        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        # set new position
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -15,
        );

        # output headline
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Ticket Dynamic Fields'),
            Height   => 7,
            Type     => 'Cut',
            Font     => 'ProportionalBoldItalic',
            FontSize => 7,
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
        $TableParam{BackgroundColor} = '#DDDDDD';
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

        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        # set new position
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -15,
        );

        # output headline
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Customer Information'),
            Height   => 7,
            Type     => 'Cut',
            Font     => 'ProportionalBoldItalic',
            FontSize => 7,
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
        $TableParam{BackgroundColor} = '#DDDDDD';
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

    my $ArticleCounter = 1;
    my $LayoutObject   = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $PDFObject      = $Kernel::OM->Get('Kernel::System::PDF');

    for my $ArticleTmp ( @{ $Param{ArticleData} } ) {
        if ( $ArticleCounter == 1 ) {
            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => -15,
            );

            # output headline
            $PDFObject->Text(
                Text     => $LayoutObject->{LanguageObject}->Translate('Articles'),
                Height   => 7,
                Type     => 'Cut',
                Font     => 'ProportionalBoldItalic',
                FontSize => 7,
                Color    => '#666666',
            );
            $PDFObject->PositionSet(
                Move => 'relativ',
                Y    => 2,
            );
        }

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

        # generate article info table
        my %TableParam1;
        my $Row = 0;

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -6,
        );

        # article number tag
        $PDFObject->Text(
            Text     => '    # ' . $ArticleCounter,
            Height   => 7,
            Type     => 'Cut',
            Font     => 'ProportionalBoldItalic',
            FontSize => 7,
            Color    => '#666666',
        );

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => 2,
        );

        for my $Parameter (qw(From To Cc Subject)) {
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
            ),
            $TableParam1{CellData}[$Row][1]{Content}
            .= ' ' . $LayoutObject->{LanguageObject}->Translate('by');
        $TableParam1{CellData}[$Row][1]{Content}
            .= ' ' . $LayoutObject->{LanguageObject}->Translate( $Article{SenderType} );
        $Row++;

        # get the dynamic fields for ticket object
        my $DynamicFieldFilter
            = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::CustomerTicketPrint")->{DynamicField};
        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Article'],
            FieldFilter => $DynamicFieldFilter || {},
        );

        # generate table
        # cycle trough the activated Dynamic Fields for ticket object
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

            # skip the dynamic field if is not desinged for customer interface
            my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsCustomerInterfaceCapable',
            );
            next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

            my $Value = $BackendObject->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Article{ArticleID},
            );

            next DYNAMICFIELD if !$Value;
            next DYNAMICFIELD if $Value eq "";

            # get print string for this dynamic field
            my $ValueStrg = $BackendObject->DisplayValueRender(
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

        # table params (article infos)
        $TableParam1{Type}            = 'Cut';
        $TableParam1{Border}          = 0;
        $TableParam1{FontSize}        = 6;
        $TableParam1{BackgroundColor} = '#DDDDDD';
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
        $TableParam2{BackgroundColor}         = '#DDDDDD';
        $TableParam2{Padding}                 = 4;
        $TableParam2{PaddingTop}              = 8;
        $TableParam2{PaddingBottom}           = 8;

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

sub _HTMLMask {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Config       = $ConfigObject->Get("Ticket::Frontend::CustomerTicketZoom");

    # output state
    if ( $Config->{AttributesView}->{State} ) {
        $LayoutObject->Block(
            Name => 'TicketState',
            Data => { %Param, },
        );
    }

    # output priority
    if ( $Config->{AttributesView}->{Priority} ) {
        $LayoutObject->Block(
            Name => 'TicketPriority',
            Data => { %Param, },
        );
    }

    # output queue
    if ( $Config->{AttributesView}->{Queue} ) {
        $LayoutObject->Block(
            Name => 'TicketQueue',
            Data => { %Param, },
        );
    }

    # output type, if feature is enabled
    if ( $ConfigObject->Get('Ticket::Type') && $Config->{AttributesView}->{Type} ) {
        $LayoutObject->Block(
            Name => 'TicketType',
            Data => { %Param, },
        );
    }

    # output service, if feature is enabled
    if (
        $ConfigObject->Get('Ticket::Service')
        && $Config->{AttributesView}->{Service}
        )
    {
        $LayoutObject->Block(
            Name => 'TicketService',
            Data => {
                Service => $Param{Service} || '-',
            },
        );
    }

    # output sla, if feature is enabled
    if ( $ConfigObject->Get('Ticket::Service') && $Config->{AttributesView}->{SLA} )
    {
        $LayoutObject->Block(
            Name => 'TicketSLA',
            Data => {
                SLA => $Param{SLA} || '-',
            },
        );
    }

    # output owner
    if ( $Config->{AttributesView}->{Owner} ) {
        $LayoutObject->Block(
            Name => 'TicketOwner',
            Data => { %Param, },
        );
    }

    # output responsible
    if ( $Config->{AttributesView}->{Responsible} ) {
        $LayoutObject->Block(
            Name => 'TicketResponsible',
            Data => { %Param, },
        );
    }

    # get the dynamic fields for ticket object
    my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::CustomerTicketPrint")->{DynamicField};
    my $DynamicField       = $DynamicFieldObject->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # flag to control the header print
    my $HeaderFlag = 0;

    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip the dynamic field if is not desinged for customer interface
        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        my $Value = $BackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{TicketID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq "";

        # get print string for this dynamic field
        my $ValueStrg = $BackendObject->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            HTMLOutput         => 1,
            ValueMaxChars      => 20,
            LayoutObject       => $LayoutObject,
        );

        # display the header only once
        if ( !$HeaderFlag ) {
            $LayoutObject->Block(
                Name => 'TicketDynamicFieldHeader',
                Data => {},
            );
            $HeaderFlag = 1;
        }

        my $Label = $DynamicFieldConfig->{Label};

        $LayoutObject->Block(
            Name => 'TicketDynamicField',
            Data => {
                Label => $Label,
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );
    }

    # build article stuff
    my $SelectedArticleID = $Param{ArticleID} || '';
    my @ArticleBox = @{ $Param{ArticleBox} };

    # get last customer article
    for my $ArticleTmp (@ArticleBox) {
        my %Article = %{$ArticleTmp};

        # get attachment string
        my %AtmIndex = ();
        if ( $Article{Atms} ) {
            %AtmIndex = %{ $Article{Atms} };
        }
        $Param{'Article::ATM'} = '';
        for my $FileID ( sort keys %AtmIndex ) {
            my %File = %{ $AtmIndex{$FileID} };
            $File{Filename} = $LayoutObject->Ascii2Html( Text => $File{Filename} );
            my $DownloadText = $LayoutObject->{LanguageObject}->Translate("Download");
            $Param{'Article::ATM'}
                .= '<a href="'
                . $LayoutObject->{Baselink}
                . 'Action=CustomerTicketAttachment;'
                . "ArticleID=$Article{ArticleID};FileID=$FileID\" target=\"attachment\" "
                . "title=\"$DownloadText: $File{Filename}\">"
                . "$File{Filename}</a> $File{Filesize}<br/>";
        }

        if ( $Article{ArticleType} eq 'chat-external' ) {
            $Article{ChatMessages} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $Article{Body}
            );
            $Article{IsChat} = 1;
        }
        else {

            # check if just a only html email
            my $MimeTypeText = $LayoutObject->CheckMimeType(
                %Param, %Article,
                Action => 'AgentTicketZoom',
            );
            if ($MimeTypeText) {
                $Param{TextNote} = $MimeTypeText;
                $Article{Body}   = '';
            }
            else {

                # html quoting
                $Article{Body} = $LayoutObject->Ascii2Html(
                    NewLine => $ConfigObject->Get('DefaultViewNewLine'),
                    Text    => $Article{Body},
                    VMax    => $ConfigObject->Get('DefaultViewLines') || 5000,
                );
            }
        }

        $LayoutObject->Block(
            Name => 'Article',
            Data => { %Param, %Article },
        );

        # do some strips && quoting
        for my $Parameter (qw(From To Cc Subject)) {
            if ( $Article{$Parameter} ) {
                $LayoutObject->Block(
                    Name => 'Row',
                    Data => {
                        Key   => $Parameter,
                        Value => $Article{$Parameter},
                    },
                );
            }
        }

        # get the dynamic fields for ticket object
        my $DynamicField = $DynamicFieldObject->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Article'],
            FieldFilter => $DynamicFieldFilter || {},
        );

        # cycle trough the activated Dynamic Fields for ticket object
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # skip the dynamic field if is not desinged for customer interface
            my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsCustomerInterfaceCapable',
            );
            next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

            my $Value = $BackendObject->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Article{ArticleID},
            );

            next DYNAMICFIELD if !$Value;
            next DYNAMICFIELD if $Value eq "";

            # get print string for this dynamic field
            my $ValueStrg = $BackendObject->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                HTMLOutput         => 1,
                ValueMaxChars      => 20,
                LayoutObject       => $LayoutObject,
            );

            my $Label = $DynamicFieldConfig->{Label};

            $LayoutObject->Block(
                Name => 'ArticleDynamicField',
                Data => {
                    Label => $Label,
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );

            # example of dynamic fields order customization
            #            $LayoutObject->Block(
            #                Name => 'ArticleDynamicField_' . $DynamicFieldConfig->{Name},
            #                Data => {
            #                    Label => $Label,
            #                    Value => $ValueStrg->{Value},
            #                    Title => $ValueStrg->{Title},
            #                },
            #            );
        }
    }

    return $LayoutObject->Output(
        TemplateFile => 'CustomerTicketPrint',
        Data         => \%Param,
    );
}

1;
