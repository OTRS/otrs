# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Output::PDF::Ticket;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::LinkObject',
    'Kernel::System::Log',
    'Kernel::System::PDF',
    'Kernel::System::JSON',
    'Kernel::System::User',
    'Kernel::System::CustomerUser',
    'Kernel::System::Ticket',
    'Kernel::System::Ticket::Article',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
);

use Kernel::System::VariableCheck qw(IsHashRefWithData);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub GeneratePDF {
    my ( $Self, %Param ) = @_;

    # Check needed params.
    for my $Needed (qw(TicketID UserID Interface)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => "error",
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Get appropriate interface flag.
    my %Interface;
    if ( $Param{Interface} eq 'Agent' ) {
        $Interface{Agent} = 1;
    }
    elsif ( $Param{Interface} eq 'Customer' ) {
        $Interface{Customer}             = 1;
        $Interface{IsVisibleForCustomer} = {
            IsVisibleForCustomer => 1,
        };
    }

    # Get ticket content.
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my %Ticket       = $TicketObject->TicketGet(
        TicketID      => $Param{TicketID},
        DynamicFields => 0,
        UserID        => $Param{UserID},
    );

    # Get article list.
    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my @MetaArticles  = $ArticleObject->ArticleList(
        TicketID => $Ticket{TicketID},
        UserID   => $Param{UserID},
        %{ $Interface{IsVisibleForCustomer} },
    );

    # Check if only one article should be printed in agent interface.
    if ( $Param{ArticleID} ) {
        @MetaArticles = grep { $_->{ArticleID} == $Param{ArticleID} } @MetaArticles;
    }

    # Get article content.
    my @ArticleBox;
    for my $MetaArticle (@MetaArticles) {
        my $ArticleBackendObject = $ArticleObject->BackendForArticle( %{$MetaArticle} );
        my %Article              = $ArticleBackendObject->ArticleGet(
            %{$MetaArticle},
            DynamicFields => 0,
        );
        my %Attachments = $ArticleBackendObject->ArticleAttachmentIndex(
            %{$MetaArticle},
            ExcludePlainText => 1,
            ExcludeHTMLBody  => 1,
            ExcludeInline    => 1,
        );
        $Article{Atms} = \%Attachments;
        push @ArticleBox, \%Article;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LinkObject   = $Kernel::OM->Get('Kernel::System::LinkObject');

    # Get necessary data only for agent interface.
    my %TicketInfo;
    my %LinkData;
    if ( $Interface{Agent} ) {

        # Show total accounted time if feature is active.
        if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
            $Ticket{TicketTimeUnits} = $TicketObject->TicketAccountedTimeGet(
                TicketID => $Ticket{TicketID},
            );
        }

        # Get user data.
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');
        my %User       = $UserObject->GetUserData(
            UserID => $Param{UserID},
        );
        $TicketInfo{User} = \%User;

        # Get owner info.
        my %Owner = $UserObject->GetUserData(
            User => $Ticket{Owner},
        );
        $TicketInfo{Owner} = \%Owner;

        # Get responsible info.
        if ( $ConfigObject->Get('Ticket::Responsible') && $Ticket{Responsible} ) {
            my %Responsible = $UserObject->GetUserData(
                User => $Ticket{Responsible},
            );
            $TicketInfo{Responsible} = \%Responsible;
        }

        # Get link ticket data.
        my $LinkListWithData = $LinkObject->LinkListWithData(
            Object           => 'Ticket',
            Key              => $Param{TicketID},
            State            => 'Valid',
            UserID           => $Param{UserID},
            ObjectParameters => {
                Ticket => {
                    IgnoreLinkedTicketStateTypes => 1,
                },
            },
        );

        # Get the link data.
        if ( $LinkListWithData && ref $LinkListWithData eq 'HASH' && %{$LinkListWithData} ) {
            %LinkData = $LayoutObject->LinkObjectTableCreate(
                LinkListWithData => $LinkListWithData,
                ViewMode         => 'SimpleRaw',
            );
        }
    }

    # Get customer info.
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my %CustomerData;
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

    # Transform time values into human readable form.
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

    # Get maximum number of pages.
    my %Page;
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

    # Create new PDF document.
    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');
    $PDFObject->DocumentNew(
        Title  => $ConfigObject->Get('Product') . ': ' . $Title,
        Encode => $LayoutObject->{UserCharset},
    );

    # Create first PDF page.
    $PDFObject->PageNew(
        %Page,
        FooterRight => $Page{PageText} . ' ' . $Page{PageCount},
    );
    $Page{PageCount}++;

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # Output title.
    $PDFObject->Text(
        Text     => $Ticket{Title},
        FontSize => 13,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # Output "printed by".
    my $PrintedBy      = $LayoutObject->{LanguageObject}->Translate('printed by');
    my $DateTimeString = $Kernel::OM->Create('Kernel::System::DateTime')->ToString();
    my $Time           = $LayoutObject->{LanguageObject}->FormatTimeString(
        $DateTimeString,
        'DateFormat',
    );
    if ( $Interface{Agent} ) {
        $PrintedBy .= ' ' . $TicketInfo{User}{UserFullname} . ' ('
            . $TicketInfo{User}{UserEmail} . ')'
            . ', ' . $Time;
    }
    elsif ( $Interface{Customer} ) {
        $PrintedBy .= ' ' . $CustomerData{UserFullname} . ' ('
            . $CustomerData{UserEmail} . ')'
            . ', ' . $Time;
    }

    $PDFObject->Text(
        Text     => $PrintedBy,
        FontSize => 9,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -14,
    );

    # Output ticket infos.
    $Self->_PDFOutputTicketInfos(
        PageData        => \%Page,
        TicketData      => \%Ticket,
        OwnerData       => $TicketInfo{Owner},
        ResponsibleData => $TicketInfo{Responsible},
        Interface       => \%Interface,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # Output ticket dynamic fields.
    $Self->_PDFOutputTicketDynamicFields(
        PageData   => \%Page,
        TicketData => \%Ticket,
        Interface  => \%Interface,
    );

    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -6,
    );

    # Output linked objects.
    if (%LinkData) {

        # Get link type list.
        my %LinkTypeList = $LinkObject->TypeList(
            UserID => $Param{UserID},
        );

        $Self->_PDFOutputLinkedObjects(
            PageData     => \%Page,
            LinkData     => \%LinkData,
            LinkTypeList => \%LinkTypeList,
        );
    }

    # Output customer infos.
    if (%CustomerData) {
        $Self->_PDFOutputCustomerInfos(
            PageData     => \%Page,
            CustomerData => \%CustomerData,
        );
    }

    # Output articles.
    $Self->_PDFOutputArticles(
        PageData      => \%Page,
        ArticleData   => \@ArticleBox,
        ArticleNumber => $Param{ArticleNumber},
        Interface     => \%Interface,
    );

    # Return the PDF document.
    return $PDFObject->DocumentOutput();
}

sub _PDFOutputTicketInfos {
    my ( $Self, %Param ) = @_;

    # Check needed stuff for both interfaces.
    for my $Needed (qw(PageData TicketData Interface)) {
        if ( !defined( $Param{$Needed} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Check needed param for agent interface.
    if ( $Param{Interface}{Agent} && !defined( $Param{OwnerData} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need OwnerData!"
        );
        return;
    }

    my %Ticket = %{ $Param{TicketData} };
    my %Page   = %{ $Param{PageData} };

    # Get needed objects.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Create left table.
    my $TableLeft = [];
    my $CustomerConfig;
    if ( $Param{Interface}{Customer} ) {
        $CustomerConfig = $ConfigObject->Get("Ticket::Frontend::CustomerTicketZoom");
    }

    # Add ticket data, respecting AttributesView configuration for customer interface.
    for my $Attribute (qw(State Priority Queue Lock CustomerID)) {
        if ( $Param{Interface}{Agent} || $CustomerConfig->{AttributesView}->{$Attribute} ) {
            my $Row = {
                Key   => $LayoutObject->{LanguageObject}->Translate($Attribute),
                Value => $LayoutObject->{LanguageObject}->Translate( $Ticket{$Attribute} )
                    || $Ticket{$Attribute} || '-',
            };
            push( @{$TableLeft}, $Row );
        }
    }

    # Add Owner data, different output between interfaces.
    if ( $Param{Interface}{Agent} ) {
        my $OwnerRow = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Owner'),
            Value => $Ticket{Owner} . ' (' . $Param{OwnerData}->{UserFullname} . ')',
        };
        push( @{$TableLeft}, $OwnerRow );
    }
    elsif ( $Param{Interface}{Customer} && $CustomerConfig->{AttributesView}->{Owner} ) {
        my $OwnerRow = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Owner'),
            Value => $Ticket{Owner},
        };
        push( @{$TableLeft}, $OwnerRow );
    }

    # Add Responsible row, if feature is enabled.
    if ( $ConfigObject->Get('Ticket::Responsible') ) {
        my $Responsible = '-';
        if ( $Param{Interface}{Agent} && $Ticket{Responsible} ) {
            $Responsible = $Ticket{Responsible} . ' (' . $Param{ResponsibleData}->{UserFullname} . ')';
        }
        elsif (
            $Param{Interface}{Customer}
            && $CustomerConfig->{AttributesView}->{Responsible}
            && $Ticket{Responsible}
            )
        {
            $Responsible = $Ticket{Responsible};
        }
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Responsible'),
            Value => $Responsible,
        };
        push( @{$TableLeft}, $Row );
    }

    # Add Type row, if feature is enabled.
    if (
        $ConfigObject->Get('Ticket::Type')
        && ( $Param{Interface}{Agent} || $CustomerConfig->{AttributesView}->{Type} )
        )
    {
        my $Row = {
            Key   => $LayoutObject->{LanguageObject}->Translate('Type'),
            Value => $Ticket{Type},
        };
        push( @{$TableLeft}, $Row );
    }

    # Add Service and SLA row, if feature is enabled.
    if ( $ConfigObject->Get('Ticket::Service') ) {
        if ( $Param{Interface}{Agent} || $CustomerConfig->{AttributesView}->{Service} ) {
            my $RowService = {
                Key   => $LayoutObject->{LanguageObject}->Translate('Service'),
                Value => $Ticket{Service} || '-',
            };
            push( @{$TableLeft}, $RowService );
        }
        if ( $Param{Interface}{Agent} || $CustomerConfig->{AttributesView}->{SLA} ) {
            my $RowSLA = {
                Key   => $LayoutObject->{LanguageObject}->Translate('SLA'),
                Value => $Ticket{SLA} || '-',
            };
            push( @{$TableLeft}, $RowSLA );
        }
    }

    # Create right table.
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

    if ( $Param{Interface}{Customer} ) {
        unshift(
            @{$TableRight},
            {
                Key   => $LayoutObject->{LanguageObject}->Translate('CustomerID'),
                Value => $Ticket{CustomerID},
            }
        );
    }
    elsif ( $Param{Interface}{Agent} ) {

        # Show created by if different then User ID 1.
        if ( $Ticket{CreateBy} > 1 ) {
            my $Row = {
                Key   => $LayoutObject->{LanguageObject}->Translate('Created by'),
                Value => $Kernel::OM->Get('Kernel::System::User')->UserName( UserID => $Ticket{CreateBy} ),
            };
            push( @{$TableRight}, $Row );
        }

        # Show accounted time.
        if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
            my $Row = {
                Key   => $LayoutObject->{LanguageObject}->Translate('Accounted time'),
                Value => $Ticket{TicketTimeUnits},
            };
            push( @{$TableRight}, $Row );
        }

        # Only show pending until unless it is really pending.
        if ( $Ticket{PendingUntil} ) {
            my $Row = {
                Key   => $LayoutObject->{LanguageObject}->Translate('Pending till'),
                Value => $Ticket{PendingUntil},
            };
            push( @{$TableRight}, $Row );
        }

        # Add first response time row.
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

        # Add update time row.
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

        # Add solution time row.
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

    # Output table.
    my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # Output table (or a fragment of it).
        %TableParam = $PDFObject->Table( %TableParam, );

        # Stop output or output next page.
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

    # Check needed stuff.
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

    # Get needed objects.
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $PDFObject    = $Kernel::OM->Get('Kernel::System::PDF');

    for my $LinkTypeLinkDirection ( sort { lc $a cmp lc $b } keys %{ $Param{LinkData} } ) {

        # Investigate link type name.
        my @LinkData     = split q{::}, $LinkTypeLinkDirection;
        my $LinkTypeName = $TypeList{ $LinkData[0] }->{ $LinkData[1] . 'Name' };
        $LinkTypeName = $LayoutObject->{LanguageObject}->Translate($LinkTypeName);

        # Define headline.
        $TableParam{CellData}[$Row][0]{Content} = $LinkTypeName . ':';
        $TableParam{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam{CellData}[$Row][1]{Content} = '';

        # Extract object list.
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

    $PDFObject->HLine(
        Color     => '#aaa',
        LineWidth => 0.5,
    );

    # Set new position.
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -10,
    );

    # Output headline.
    $PDFObject->Text(
        Text     => $LayoutObject->{LanguageObject}->Translate('Linked Objects'),
        Height   => 10,
        Type     => 'Cut',
        Font     => 'Proportional',
        FontSize => 9,
        Color    => '#666666',
    );

    # Set new position.
    $PDFObject->PositionSet(
        Move => 'relativ',
        Y    => -4,
    );

    # Table params.
    $TableParam{Type}          = 'Cut';
    $TableParam{Border}        = 0;
    $TableParam{FontSize}      = 6;
    $TableParam{Padding}       = 1;
    $TableParam{PaddingTop}    = 3;
    $TableParam{PaddingBottom} = 3;

    # Output table.
    PAGE:
    for ( $Page{PageCount} .. $Page{MaxPages} ) {

        # Output table (or a fragment of it).
        %TableParam = $PDFObject->Table( %TableParam, );

        # Stop output or output next page.
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

    # Check needed stuff.
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

    # Get dynamic field config for appropriate frontend module.
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldFilter;
    if ( $Param{Interface}{Agent} ) {
        $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::AgentTicketPrint")->{DynamicField};
    }
    elsif ( $Param{Interface}{Customer} ) {
        $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::CustomerTicketPrint")->{DynamicField};
    }

    # Get the dynamic fields for ticket object.
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $DynamicFieldFilter || {},
    );

    # Get needed objects.
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $LayoutObject              = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Generate table, cycle trough the activated Dynamic Fields for ticket object.
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        if ( $Param{Interface}{Customer} ) {

            # Skip dynamic field if is not designed for customer interface.
            my $IsCustomerInterfaceCapable = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsCustomerInterfaceCapable',
            );
            next DYNAMICFIELD if !$IsCustomerInterfaceCapable;
        }

        my $Value = $DynamicFieldBackendObject->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Ticket{TicketID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq "";

        # Get print string for this dynamic field.
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

    # Output ticket dynamic fields.
    if ($Output) {

        my $PDFObject = $Kernel::OM->Get('Kernel::System::PDF');

        $PDFObject->HLine(
            Color     => '#aaa',
            LineWidth => 0.5,
        );

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -10,
        );

        # Output headline.
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Ticket Dynamic Fields'),
            Height   => 10,
            Type     => 'Cut',
            Font     => 'Proportional',
            FontSize => 8,
            Color    => '#666666',
        );

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # Table params.
        $TableParam{Type}          = 'Cut';
        $TableParam{Border}        = 0;
        $TableParam{FontSize}      = 6;
        $TableParam{Padding}       = 1;
        $TableParam{PaddingTop}    = 3;
        $TableParam{PaddingBottom} = 3;

        # Output table.
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # Output table (or a fragment of it).
            %TableParam = $PDFObject->Table( %TableParam, );

            # Stop output or output next page.
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

    # Check needed stuff.
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

    # Check if customer company support is enabled.
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

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -10,
        );

        $PDFObject->HLine(
            Color     => '#aaa',
            LineWidth => 0.5,
        );

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # Output headline.
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Customer Information'),
            Height   => 10,
            Type     => 'Cut',
            Font     => 'Proportional',
            FontSize => 8,
            Color    => '#666666',
        );

        # Set new position.
        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -4,
        );

        # Table params.
        $TableParam{Type}          = 'Cut';
        $TableParam{Border}        = 0;
        $TableParam{FontSize}      = 6;
        $TableParam{Padding}       = 1;
        $TableParam{PaddingTop}    = 3;
        $TableParam{PaddingBottom} = 3;

        # Output table.
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # Output table (or a fragment of it).
            %TableParam = $PDFObject->Table( %TableParam, );

            # Stop output or output next page.
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

    # Check needed stuff.
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

    # Get needed objects.
    my $PDFObject                 = $Kernel::OM->Get('Kernel::System::PDF');
    my $ArticleObject             = $Kernel::OM->Get('Kernel::System::Ticket::Article');
    my $LayoutObject              = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject              = $Kernel::OM->Get('Kernel::Config');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my @ArticleData  = @{ $Param{ArticleData} };
    my $ArticleCount = scalar @ArticleData;

    # Get config settings.
    my $ZoomExpandSort = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ZoomExpandSort');

    # Resort article order.
    if ( $Param{Interface}{Agent} && $ZoomExpandSort eq 'reverse' ) {
        @ArticleData = reverse(@ArticleData);
    }

    my $ArticleCounter = 1;
    for my $ArticleTmp (@ArticleData) {

        my %Article = %{$ArticleTmp};

        # Get attachment string.
        my %AtmIndex = ();
        if ( $Article{Atms} ) {
            %AtmIndex = %{ $Article{Atms} };
        }
        my $Attachments;
        for my $FileID ( sort keys %AtmIndex ) {
            my %File     = %{ $AtmIndex{$FileID} };
            my $Filesize = $LayoutObject->HumanReadableDataSize( Size => $File{FilesizeRaw} );
            $Attachments .= $File{Filename} . ' (' . $Filesize . ")\n";
        }

        # Show total accounted time if feature is active.
        if ( $Param{Interface}{Agent} && $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
            $Article{'Accounted time'} = $ArticleObject->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID},
            );
        }

        # Generate article info table.
        my %TableParam1;
        my $Row = 0;

        $PDFObject->PositionSet(
            Move => 'relativ',
            Y    => -6,
        );

        # Get article number.
        my $ArticleNumber;
        if ( $Param{ArticleNumber} ) {
            $ArticleNumber = $Param{ArticleNumber};
        }
        else {
            $ArticleNumber = $ZoomExpandSort eq 'reverse' ? $ArticleCount - $ArticleCounter + 1 : $ArticleCounter;
        }

        if ( $Param{Interface}{Customer} ) {
            $ArticleNumber = $ArticleCounter;
        }

        # Article number tag.
        $PDFObject->Text(
            Text     => $LayoutObject->{LanguageObject}->Translate('Article') . ' #' . $ArticleNumber,
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

        my %ArticleFields = $LayoutObject->ArticleFields(%Article);

        # Display article fields.
        ARTICLE_FIELD:
        for my $ArticleFieldKey (
            sort { $ArticleFields{$a}->{Prio} <=> $ArticleFields{$b}->{Prio} }
            keys %ArticleFields
            )
        {
            my %ArticleField = %{ $ArticleFields{$ArticleFieldKey} // {} };

            next ARTICLE_FIELD if $Param{Interface}->{Customer} && $ArticleField{HideInCustomerInterface};
            next ARTICLE_FIELD if $ArticleField{HideInTicketPrint};
            next ARTICLE_FIELD if !$ArticleField{Value};

            $TableParam1{CellData}[$Row][0]{Content}
                = $LayoutObject->{LanguageObject}->Translate( $ArticleField{Label} ) . ':';
            $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
            $TableParam1{CellData}[$Row][1]{Content} = $ArticleField{Value};
            $Row++;
        }

        # Display article accounted time.
        if ( $Param{Interface}{Agent} ) {
            my $ArticleTime = $ArticleObject->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID},
            );
            if ($ArticleTime) {
                $TableParam1{CellData}[$Row][0]{Content}
                    = $LayoutObject->{LanguageObject}->Translate('Accounted time') . ':';
                $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
                $TableParam1{CellData}[$Row][1]{Content} = $ArticleTime;
                $Row++;
            }
        }

        $TableParam1{CellData}[$Row][0]{Content} = $LayoutObject->{LanguageObject}->Translate('Created') . ':';
        $TableParam1{CellData}[$Row][0]{Font}    = 'ProportionalBold';
        $TableParam1{CellData}[$Row][1]{Content} = $LayoutObject->{LanguageObject}->FormatTimeString(
            $Article{CreateTime},
            'DateFormat',
        );
        $TableParam1{CellData}[$Row][1]{Content}
            .= ' ' . $LayoutObject->{LanguageObject}->Translate('by');
        my $SenderType = $ArticleObject->ArticleSenderTypeLookup(
            SenderTypeID => $Article{SenderTypeID},
        );
        $TableParam1{CellData}[$Row][1]{Content}
            .= ' ' . $LayoutObject->{LanguageObject}->Translate($SenderType);
        $Row++;

        # Get dynamic field config for appropriate frontend module.
        my $DynamicFieldFilter;
        if ( $Param{Interface}{Agent} ) {
            $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::AgentTicketPrint")->{DynamicField};
        }
        elsif ( $Param{Interface}{Customer} ) {
            $DynamicFieldFilter = $ConfigObject->Get("Ticket::Frontend::CustomerTicketPrint")->{DynamicField};
        }

        # Get the dynamic fields for ticket object.
        my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Article'],
            FieldFilter => $DynamicFieldFilter || {},
        );

        # Generate table, cycle trough the activated Dynamic Fields for ticket object.
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            if ( $Param{Interface}{Customer} ) {

                # Skip the dynamic field if it is not designed for customer interface.
                my $IsCustomerInterfaceCapable = $DynamicFieldBackendObject->HasBehavior(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Behavior           => 'IsCustomerInterfaceCapable',
                );
                next DYNAMICFIELD if !$IsCustomerInterfaceCapable;
            }

            my $Value = $DynamicFieldBackendObject->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Article{ArticleID},
            );

            next DYNAMICFIELD if !$Value;
            next DYNAMICFIELD if $Value eq "";

            # Get print string for this dynamic field.
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

        # Table params (article infos).
        $TableParam1{Type}          = 'Cut';
        $TableParam1{Border}        = 0;
        $TableParam1{FontSize}      = 6;
        $TableParam1{Padding}       = 1;
        $TableParam1{PaddingTop}    = 3;
        $TableParam1{PaddingBottom} = 3;

        # Output table (article infos).
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # Output table (or a fragment of it).
            %TableParam1 = $PDFObject->Table( %TableParam1, );

            # Stop output or output next page.
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

        my $ArticlePreview = $LayoutObject->ArticlePreview(
            %Article,
            ResultType => 'plain',
        );

        # Table params (article body).
        my %TableParam2;
        $TableParam2{CellData}[0][0]{Content} = $ArticlePreview || ' ';
        $TableParam2{Type}                    = 'Cut';
        $TableParam2{Border}                  = 0;
        $TableParam2{Font}                    = 'Monospaced';
        $TableParam2{FontSize}                = 7;
        $TableParam2{BackgroundColor}         = '#f2f2f2';
        $TableParam2{Padding}                 = 4;
        $TableParam2{PaddingTop}              = 4;
        $TableParam2{PaddingBottom}           = 4;

        # Output table (article body).
        PAGE:
        for ( $Page{PageCount} .. $Page{MaxPages} ) {

            # Output table (or a fragment of it).
            %TableParam2 = $PDFObject->Table( %TableParam2, );

            # Stop output or output next page.
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
