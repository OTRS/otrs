# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketEmail;

use strict;
use warnings;

use Mail::Address;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Config->{DynamicField} || {},
    );

    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output;

    # store last queue screen
    if ( $Self->{LastScreenOverview} && $Self->{LastScreenOverview} !~ /Action=AgentTicketEmail/ ) {
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenOverview',
            Value     => $Self->{RequestedURL},
        );
    }

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get upload cache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $Debug              = $Param{Debug} || 0;
    my $Config             = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");
    my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

    # get params
    my %GetParam;
    for my $Key (
        qw(Year Month Day Hour Minute To Cc Bcc TimeUnits PriorityID Subject Body
        TypeID ServiceID SLAID OwnerAll ResponsibleAll NewResponsibleID NewUserID
        NextStateID StandardTemplateID Dest ArticleID LinkTicketID
        )
        )
    {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam;
    $ACLCompatGetParam{OwnerID} = $GetParam{NewUserID};

    # hash for check duplicated entries
    my %AddressesList;

    # MultipleCustomer To-field
    my @MultipleCustomer;
    my $CustomersNumber = $ParamObject->GetParam( Param => 'CustomerTicketCounterToCustomer' ) || 0;
    my $Selected = $ParamObject->GetParam( Param => 'CustomerSelected' ) || '';

    # get check item object
    my $CheckItemObject = $Kernel::OM->Get('Kernel::System::CheckItem');

    if ($CustomersNumber) {
        my $CustomerCounter = 1;
        for my $Count ( 1 ... $CustomersNumber ) {
            my $CustomerElement = $ParamObject->GetParam( Param => 'CustomerTicketText_' . $Count );
            my $CustomerSelected = ( $Selected eq $Count ? 'checked="checked"' : '' );
            my $CustomerKey = $ParamObject->GetParam( Param => 'CustomerKey_' . $Count )
                || '';
            if ($CustomerElement) {

                if ( $GetParam{To} ) {
                    $GetParam{To} .= ', ' . $CustomerElement;
                }
                else {
                    $GetParam{To} = $CustomerElement;
                }

                my $CustomerErrorMsg = 'CustomerGenericServerErrorMsg';
                my $CustomerError    = '';
                my $CustomerDisabled = '';
                my $CountAux         = $CustomerCounter++;

                # check email address
                for my $Email ( Mail::Address->parse($CustomerElement) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) )
                    {
                        $CustomerErrorMsg = $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $CustomerError = 'ServerError';
                    }
                }

                # check for duplicated entries
                if ( defined $AddressesList{$CustomerElement} && $CustomerError eq '' ) {
                    $CustomerErrorMsg = 'IsDuplicatedServerErrorMsg';
                    $CustomerError    = 'ServerError';
                }

                if ( $CustomerError ne '' ) {
                    $CustomerDisabled = 'disabled="disabled"';
                    $CountAux         = $Count . 'Error';
                }

                push @MultipleCustomer, {
                    Count            => $CountAux,
                    CustomerElement  => $CustomerElement,
                    CustomerSelected => $CustomerSelected,
                    CustomerKey      => $CustomerKey,
                    CustomerError    => $CustomerError,
                    CustomerErrorMsg => $CustomerErrorMsg,
                    CustomerDisabled => $CustomerDisabled,
                };
                $AddressesList{$CustomerElement} = 1;
            }
        }
    }

    # MultipleCustomer Cc-field
    my @MultipleCustomerCc;
    my $CustomersNumberCc = $ParamObject->GetParam( Param => 'CustomerTicketCounterCcCustomer' ) || 0;

    if ($CustomersNumberCc) {
        my $CustomerCounterCc = 1;
        for my $Count ( 1 ... $CustomersNumberCc ) {
            my $CustomerElementCc = $ParamObject->GetParam( Param => 'CcCustomerTicketText_' . $Count );
            my $CustomerKeyCc     = $ParamObject->GetParam( Param => 'CcCustomerKey_' . $Count )
                || '';

            if ($CustomerElementCc) {
                my $CustomerErrorMsgCc = 'CustomerGenericServerErrorMsg';
                my $CustomerErrorCc    = '';
                my $CustomerDisabledCc = '';
                my $CountAuxCc         = $CustomerCounterCc++;

                if ( $GetParam{Cc} ) {
                    $GetParam{Cc} .= ', ' . $CustomerElementCc;
                }
                else {
                    $GetParam{Cc} = $CustomerElementCc;
                }

                # check email address
                for my $Email ( Mail::Address->parse($CustomerElementCc) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) )
                    {
                        $CustomerErrorMsgCc = $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $CustomerErrorCc = 'ServerError';
                    }
                }

                # check for duplicated entries
                if ( defined $AddressesList{$CustomerElementCc} && $CustomerErrorCc eq '' ) {
                    $CustomerErrorMsgCc = 'IsDuplicatedServerErrorMsg';
                    $CustomerErrorCc    = 'ServerError';
                }

                if ( $CustomerErrorCc ne '' ) {
                    $CustomerDisabledCc = 'disabled="disabled"';
                    $CountAuxCc         = $Count . 'Error';
                }

                push @MultipleCustomerCc, {
                    Count            => $CountAuxCc,
                    CustomerElement  => $CustomerElementCc,
                    CustomerKey      => $CustomerKeyCc,
                    CustomerError    => $CustomerErrorCc,
                    CustomerErrorMsg => $CustomerErrorMsgCc,
                    CustomerDisabled => $CustomerDisabledCc,
                };
                $AddressesList{$CustomerElementCc} = 1;
            }
        }
    }

    # MultipleCustomer Bcc-field
    my @MultipleCustomerBcc;
    my $CustomersNumberBcc = $ParamObject->GetParam( Param => 'CustomerTicketCounterBccCustomer' ) || 0;

    if ($CustomersNumberBcc) {
        my $CustomerCounterBcc = 1;
        for my $Count ( 1 ... $CustomersNumberBcc ) {
            my $CustomerElementBcc = $ParamObject->GetParam( Param => 'BccCustomerTicketText_' . $Count );
            my $CustomerKeyBcc     = $ParamObject->GetParam( Param => 'BccCustomerKey_' . $Count )
                || '';

            if ($CustomerElementBcc) {

                my $CustomerDisabledBcc = '';
                my $CountAuxBcc         = $CustomerCounterBcc++;
                my $CustomerErrorMsgBcc = 'CustomerGenericServerErrorMsg';
                my $CustomerErrorBcc    = '';

                if ( $GetParam{Bcc} ) {
                    $GetParam{Bcc} .= ', ' . $CustomerElementBcc;
                }
                else {
                    $GetParam{Bcc} = $CustomerElementBcc;
                }

                # check email address
                for my $Email ( Mail::Address->parse($CustomerElementBcc) ) {
                    if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) )
                    {
                        $CustomerErrorMsgBcc = $CheckItemObject->CheckErrorType()
                            . 'ServerErrorMsg';
                        $CustomerErrorBcc = 'ServerError';
                    }
                }

                # check for duplicated entries
                if ( defined $AddressesList{$CustomerElementBcc} && $CustomerErrorBcc eq '' ) {
                    $CustomerErrorMsgBcc = 'IsDuplicatedServerErrorMsg';
                    $CustomerErrorBcc    = 'ServerError';
                }

                if ( $CustomerErrorBcc ne '' ) {
                    $CustomerDisabledBcc = 'disabled="disabled"';
                    $CountAuxBcc         = $Count . 'Error';
                }

                push @MultipleCustomerBcc, {
                    Count            => $CountAuxBcc,
                    CustomerElement  => $CustomerElementBcc,
                    CustomerKey      => $CustomerKeyBcc,
                    CustomerError    => $CustomerErrorBcc,
                    CustomerErrorMsg => $CustomerErrorMsgBcc,
                    CustomerDisabled => $CustomerDisabledBcc,
                };
                $AddressesList{$CustomerElementBcc} = 1;
            }
        }
    }

    # set an empty value if not defined
    $GetParam{Cc}  = '' if !defined $GetParam{Cc};
    $GetParam{Bcc} = '' if !defined $GetParam{Bcc};

    # get Dynamic fields form ParamObject
    my %DynamicFieldValues;

    # get needed objects
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
    my $LayoutObject              = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value from the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
        );
    }

    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldACLParameters;
    DYNAMICFIELD:
    for my $DynamicField ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField } = $DynamicFieldValues{$DynamicField};
    }
    $GetParam{DynamicField} = \%DynamicFieldACLParameters;

    # transform pending time, time stamp based on user time zone
    if (
        defined $GetParam{Year}
        && defined $GetParam{Month}
        && defined $GetParam{Day}
        && defined $GetParam{Hour}
        && defined $GetParam{Minute}
        )
    {
        %GetParam = $LayoutObject->TransformDateSelection(
            %GetParam,
        );
    }

    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'Created' ) {
        my %Ticket;
        if ( $Self->{TicketID} ) {
            %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );
        }

        # header
        $Output .= $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        # notify info
        if ( $Self->{TicketID} && $Self->{Subaction} eq 'Created' ) {

            $Output .= $LayoutObject->Notify(
                Info => $LayoutObject->{LanguageObject}->Translate(
                    'Ticket "%s" created!',
                    $Ticket{TicketNumber},
                ),
                Link => $LayoutObject->{Baselink}
                    . 'Action=AgentTicketZoom;TicketID='
                    . $Ticket{TicketID},
            );
        }

        # store last queue screen
        if (
            $Self->{LastScreenOverview}
            && $Self->{LastScreenOverview} !~ /Action=AgentTicketEmail/
            && $Self->{RequestedURL} !~ /Action=AgentTicketEmail.*LinkTicketID=/
            )
        {
            $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastScreenOverview',
                Value     => $Self->{RequestedURL},
            );
        }

        # get split article if given
        # get ArticleID
        my %Article;
        my %CustomerData;
        my $ArticleFrom = '';
        my %SplitTicketData;
        if ( $GetParam{ArticleID} ) {

            my $Access = $TicketObject->TicketPermission(
                Type     => 'ro',
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $LayoutObject->NoPermission(
                    Message    => "You need ro permission!",
                    WithHeader => 'yes',
                );
            }

            # Get information from original ticket (SplitTicket).
            %SplitTicketData = $TicketObject->TicketGet(
                TicketID      => $Self->{TicketID},
                DynamicFields => 1,
                UserID        => $Self->{UserID},
            );

            my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
                TicketID  => $Self->{TicketID},
                ArticleID => $GetParam{ArticleID},
            );

            %Article = $ArticleBackendObject->ArticleGet(
                TicketID  => $Self->{TicketID},
                ArticleID => $GetParam{ArticleID},
            );

            # check if article is from the same TicketID as we checked permissions for.
            if ( $Article{TicketID} ne $Self->{TicketID} ) {
                return $LayoutObject->ErrorScreen(
                    Message => $LayoutObject->{LanguageObject}->Translate(
                        'Article does not belong to ticket %s!', $Self->{TicketID}
                    ),
                );
            }

            $Article{Subject} = $TicketObject->TicketSubjectClean(
                TicketNumber => $Ticket{TicketNumber},
                Subject      => $Article{Subject} || '',
            );

            # save article from for addresses list
            $ArticleFrom = $Article{From};

            # if To is present
            # and is no a queue
            # and also is no a system address
            # set To as article from
            if ( IsStringWithData( $Article{To} ) ) {
                my %Queues = $QueueObject->QueueList();

                if ( $ConfigObject->{CustomerPanelOwnSelection} ) {
                    for my $Queue ( sort keys %{ $ConfigObject->{CustomerPanelOwnSelection} } ) {
                        my $Value = $ConfigObject->{CustomerPanelOwnSelection}->{$Queue};
                        $Queues{$Queue} = $Value;
                    }
                }

                my %QueueLookup = reverse %Queues;
                my %SystemAddressLookup
                    = reverse $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressList();
                my @ArticleFromAddress;
                my $SystemAddressEmail;

                if ($ArticleFrom) {
                    @ArticleFromAddress = Mail::Address->parse($ArticleFrom);
                    $SystemAddressEmail = $ArticleFromAddress[0]->address();
                }

                if ( !defined $QueueLookup{ $Article{To} } && defined $SystemAddressLookup{$SystemAddressEmail} ) {
                    $ArticleFrom = $Article{To};
                }
            }

            # body preparation for plain text processing
            $Article{Body} = $LayoutObject->ArticleQuote(
                TicketID           => $Article{TicketID},
                ArticleID          => $GetParam{ArticleID},
                FormID             => $Self->{FormID},
                UploadCacheObject  => $UploadCacheObject,
                AttachmentsInclude => 1,
            );
            if ( $LayoutObject->{BrowserRichText} ) {
                $Article{ContentType} = 'text/html';
            }
            else {
                $Article{ContentType} = 'text/plain';
            }

            # show customer info
            if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoCompose') ) {
                if ( $Article{CustomerUserID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );
                }
                elsif ( $Article{CustomerID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        CustomerID => $Article{CustomerID},
                    );
                }
                elsif ( $SplitTicketData{CustomerUserID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        User => $SplitTicketData{CustomerUserID},
                    );
                }
                elsif ( $SplitTicketData{CustomerID} ) {
                    %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                        CustomerID => $SplitTicketData{CustomerID},
                    );
                }
            }
            if ( $Article{CustomerUserID} ) {
                my %CustomerUserList = $CustomerUserObject->CustomerSearch(
                    UserLogin => $Article{CustomerUserID},
                );
                for my $KeyCustomerUserList ( sort keys %CustomerUserList ) {
                    $Article{From} = $CustomerUserList{$KeyCustomerUserList};
                }
            }
        }

        # multiple addresses list
        # check email address
        my $CountFrom = scalar @MultipleCustomer || 1;
        my %CustomerDataFrom;
        if ( $Article{CustomerUserID} ) {
            %CustomerDataFrom = $CustomerUserObject->CustomerUserDataGet(
                User => $Article{CustomerUserID},
            );
        }

        for my $Email ( Mail::Address->parse($ArticleFrom) ) {

            my $CountAux         = $CountFrom;
            my $CustomerError    = '';
            my $CustomerErrorMsg = 'CustomerGenericServerErrorMsg';
            my $CustomerDisabled = '';
            my $CustomerSelected = ( $CountFrom eq '1' ? 'checked="checked"' : '' );
            my $EmailAddress     = $Email->address();
            if ( !$CheckItemObject->CheckEmail( Address => $EmailAddress ) )
            {
                $CustomerErrorMsg = $CheckItemObject->CheckErrorType()
                    . 'ServerErrorMsg';
                $CustomerError = 'ServerError';
            }

            # check for duplicated entries
            if ( defined $AddressesList{$Email} && $CustomerError eq '' ) {
                $CustomerErrorMsg = 'IsDuplicatedServerErrorMsg';
                $CustomerError    = 'ServerError';
            }

            if ( $CustomerError ne '' ) {
                $CustomerDisabled = 'disabled="disabled"';
                $CountAux         = $CountFrom . 'Error';
            }

            my $CustomerKey = '';
            if (
                defined $CustomerDataFrom{UserEmail}
                && $CustomerDataFrom{UserEmail} eq $EmailAddress
                )
            {
                $CustomerKey = $Article{CustomerUserID};
            }

            my $CustomerElement = $EmailAddress;
            if ( $Email->phrase() ) {
                $CustomerElement = $Email->phrase() . " <$EmailAddress>";
            }

            push @MultipleCustomer, {
                Count            => $CountAux,
                CustomerElement  => $CustomerElement,
                CustomerSelected => $CustomerSelected,
                CustomerKey      => $CustomerKey,
                CustomerError    => $CustomerError,
                CustomerErrorMsg => $CustomerErrorMsg,
                CustomerDisabled => $CustomerDisabled,
            };
            $AddressesList{$EmailAddress} = 1;
            $CountFrom++;
        }

        # get user preferences
        my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID => $Self->{UserID},
        );

        # store the dynamic fields default values or used specific default values to be used as
        # ACLs info for all fields
        my %DynamicFieldDefaults;

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

            # get default value from dynamic field config (if any)
            my $DefaultValue = $DynamicFieldConfig->{Config}->{DefaultValue} || '';

            # override the value from user preferences if is set
            if ( $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} } ) {
                $DefaultValue = $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} };
            }

            next DYNAMICFIELD if $DefaultValue eq '';
            next DYNAMICFIELD
                if ref $DefaultValue eq 'ARRAY' && !IsArrayRefWithData($DefaultValue);

            $DynamicFieldDefaults{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $DefaultValue;
        }
        $GetParam{DynamicField} = \%DynamicFieldDefaults;

        # get split article if given
        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        my %SplitTicketParam;

        # in case of split a TicketID and ArticleID are always given, send the TicketID to calculate
        # ACLs based on parent information
        if ( $Self->{TicketID} && $Article{ArticleID} ) {
            $SplitTicketParam{TicketID} = $Self->{TicketID};
        }

        # fix to bug# 8068 Field & DynamicField preselection on TicketSplit
        # when splitting a ticket the selected attributes must remain in the new ticket screen
        # this information will be available in the SplitTicketParam hash
        if ( $SplitTicketParam{TicketID} ) {

            # get information from original ticket (SplitTicket)
            my %SplitTicketData = $TicketObject->TicketGet(
                TicketID      => $SplitTicketParam{TicketID},
                DynamicFields => 1,
                UserID        => $Self->{UserID},
            );

            # set simple IDs to pass them to the mask
            for my $SplitedParam (qw(TypeID ServiceID SLAID PriorityID)) {
                $SplitTicketParam{$SplitedParam} = $SplitTicketData{$SplitedParam};
            }

            # set StateID as NextStateID
            $SplitTicketParam{NextStateID} = $SplitTicketData{StateID};

            # set Owner and Responsible
            $SplitTicketParam{UserSelected}            = $SplitTicketData{OwnerID};
            $SplitTicketParam{ResponsibleUserSelected} = $SplitTicketData{ResponsibleID};

            # set additional information needed for Owner and Responsible
            if ( $SplitTicketData{QueueID} ) {
                $SplitTicketParam{QueueID} = $SplitTicketData{QueueID};
            }
            $SplitTicketParam{AllUsers} = 1;

            # set the selected queue in format ID||Name
            $SplitTicketParam{FromSelected} = $SplitTicketData{QueueID} . '||' . $SplitTicketData{Queue};

            for my $Key ( sort keys %SplitTicketData ) {
                if ( $Key =~ /DynamicField\_(.*)/ ) {
                    $SplitTicketParam{DynamicField}{$1} = $SplitTicketData{$Key};
                    delete $SplitTicketParam{$Key};
                }
            }
        }

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        %GetParam,
                        %ACLCompatGetParam,
                        %SplitTicketParam,
                        Action        => $Self->{Action},
                        ReturnType    => 'Ticket',
                        ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data          => \%AclData,
                        UserID        => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $TicketObject->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            # to store dynamic field value from database (or undefined)
            my $Value;

            # in case of split a TicketID and ArticleID are always given, Get the value
            # from DB this cases
            if ( $Self->{TicketID} && $Article{ArticleID} ) {

                # select TicketID or ArticleID to get the value depending on dynamic field configuration
                my $ObjectID = $DynamicFieldConfig->{ObjectType} eq 'Ticket'
                    ? $Self->{TicketID}
                    : $Article{ArticleID};

                # get value stored on the database (split)
                $Value = $DynamicFieldBackendObject->ValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $ObjectID,
                );
            }

            # otherwise (on a new ticket). Check if the user has a user specific default value for
            # the dynamic field, otherwise will use Dynamic Field default value
            else {

                # override the value from user preferences if is set
                if ( $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} } ) {
                    $Value = $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} };
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Value                => $Value,
                Mandatory =>
                    $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                LayoutObject    => $LayoutObject,
                ParamObject     => $ParamObject,
                AJAXUpdate      => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
                );
        }

        # run compose modules
        if (
            ref $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') eq
            'HASH'
            )
        {

            # Get Queue settings if 'Dest' param was set in the URL.
            my %GetParam;
            $GetParam{Dest} = $ParamObject->GetParam( Param => 'Dest' );

            if ( $GetParam{Dest} && $GetParam{Dest} =~ /^(\d{1,100})\|\|.+?$/ ) {
                $GetParam{QueueID} = $1;
                my %Queue = $QueueObject->GetSystemAddress( QueueID => $GetParam{QueueID} );
                $GetParam{From} = $Queue{Email};
            }

            my %Jobs = %{ $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                    return $LayoutObject->FatalError();
                }

                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    Debug => $Debug,
                );

                # get params
                PARAMETER:
                for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                    if ( $Jobs{$Job}->{ParamType} && $Jobs{$Job}->{ParamType} ne 'Single' ) {
                        @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
                        next PARAMETER;
                    }

                    $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
                }

                # run module
                my $NewParams = $Object->Run( %GetParam, Config => $Jobs{$Job} );

                if ($NewParams) {
                    for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {
                        $GetParam{$Parameter} = $NewParams;
                    }
                }
            }
        }

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # get and format default subject and body
        my $Subject = $Article{Subject};
        if ( !$Subject ) {
            $Subject = $LayoutObject->Output(
                Template => $Config->{Subject} || '',
            );
        }
        my $Body = $Article{Body} || '';
        if ( !$Body ) {
            $Body = $LayoutObject->Output(
                Template => $Config->{Body} || '',
            );
        }

        # make sure body is rich text (if body is based on config)
        if ( !$GetParam{ArticleID} && $LayoutObject->{BrowserRichText} ) {
            $Body = $LayoutObject->Ascii2RichText(
                String => $Body,
            );
        }

        # in case of ticket split set $Self->{QueueID} as the QueueID of the original ticket,
        # in order to set correct ACLs on page load (initial). See bug 8687.
        if (
            IsHashRefWithData( \%SplitTicketParam )
            && $SplitTicketParam{QueueID}
            && !$Self->{QueueID}
            )
        {
            $Self->{QueueID} = $SplitTicketParam{QueueID};
        }

        my $Dest = '';
        if ( !$Self->{QueueID} && $GetParam{Dest} ) {

            my @QueueParts = split( /\|\|/, $GetParam{Dest} );
            $Self->{QueueID} = $QueueParts[0];
            $Dest = $GetParam{Dest};
        }

        # html output
        my $Services = $Self->_GetServices(
            %GetParam,
            %ACLCompatGetParam,
            %SplitTicketParam,
            CustomerUserID => $CustomerData{UserLogin} || '',
            QueueID        => $Self->{QueueID}         || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            QueueID => $Self->{QueueID} || 1,
            Services => $Services,
            %GetParam,
            %ACLCompatGetParam,
            %SplitTicketParam,
        );
        $Output .= $Self->_MaskEmailNew(
            QueueID    => $Self->{QueueID},
            NextStates => $Self->_GetNextStates(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1
            ),
            Priorities => $Self->_GetPriorities(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1
            ),
            Types => $Self->_GetTypes(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1
            ),
            Services          => $Services,
            SLAs              => $SLAs,
            StandardTemplates => $Self->_GetStandardTemplates(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                QueueID => $Self->{QueueID} || '',
            ),
            Users => $Self->_GetUsers(
                %GetParam,
                %ACLCompatGetParam,
                QueueID => $Self->{QueueID},
                %SplitTicketParam,
            ),
            ResponsibleUsers => $Self->_GetResponsibles(
                %GetParam,
                %ACLCompatGetParam,
                QueueID => $Self->{QueueID},
                %SplitTicketParam,
            ),
            FromList => $Self->_GetTos(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID => $Self->{QueueID}
            ),
            FromSelected      => $Dest,
            To                => $Article{From} // '',
            Subject           => $Subject,
            Body              => $Body,
            CustomerID        => $SplitTicketData{CustomerID},
            CustomerUser      => $SplitTicketData{CustomerUserID},
            CustomerData      => \%CustomerData,
            Attachments       => \@Attachments,
            LinkTicketID      => $GetParam{LinkTicketID} || '',
            TimeUnitsRequired => (
                $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                ? 'Validate_Required'
                : ''
            ),
            %SplitTicketParam,
            DynamicFieldHTML    => \%DynamicFieldHTML,
            MultipleCustomer    => \@MultipleCustomer,
            MultipleCustomerCc  => \@MultipleCustomerCc,
            MultipleCustomerBcc => \@MultipleCustomerBcc,
        );

        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # deliver signature
    elsif ( $Self->{Subaction} eq 'Signature' ) {
        my $CustomerUser = $ParamObject->GetParam( Param => 'SelectedCustomerUser' ) || '';
        my $QueueID = $ParamObject->GetParam( Param => 'QueueID' );
        if ( !$QueueID ) {
            my $Dest = $ParamObject->GetParam( Param => 'Dest' ) || '';
            ($QueueID) = split( /\|\|/, $Dest );
        }

        # start with empty signature (no queue selected) - if we have a queue, get the sig.
        my $Signature = '';
        if ($QueueID) {
            $Signature = $Self->_GetSignature(
                QueueID        => $QueueID,
                CustomerUserID => $CustomerUser,
            );
        }
        my $MimeType = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $MimeType  = 'text/html';
            $Signature = $LayoutObject->RichTextDocumentComplete(
                String => $Signature,
            );
        }

        return $LayoutObject->Attachment(
            ContentType => $MimeType . '; charset=' . $LayoutObject->{Charset},
            Content     => $Signature,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # create new ticket and article
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {

        my %Error;
        my $NextStateID = $ParamObject->GetParam( Param => 'NextStateID' ) || '';
        my %StateData;
        if ($NextStateID) {
            %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet(
                ID => $NextStateID,
            );
        }
        my $NextState        = $StateData{Name};
        my $NewResponsibleID = $ParamObject->GetParam( Param => 'NewResponsibleID' ) || '';
        my $NewUserID        = $ParamObject->GetParam( Param => 'NewUserID' ) || '';
        my $Dest             = $ParamObject->GetParam( Param => 'Dest' ) || '';

        # see if only a name has been passed
        if ( $Dest && $Dest !~ m{ \A (\d+)? \| \| .+ \z }xms ) {

            # see if we can get an ID for this queue name
            my $DestID = $QueueObject->QueueLookup(
                Queue => $Dest,
            );

            if ($DestID) {
                $Dest = $DestID . '||' . $Dest;
            }
            else {
                $Dest = '';
            }
        }

        my ( $NewQueueID, $From ) = split( /\|\|/, $Dest );
        if ( !$NewQueueID ) {
            $GetParam{OwnerAll} = 1;
        }
        else {
            my %Queue = $QueueObject->GetSystemAddress( QueueID => $NewQueueID );
            $GetParam{From} = $Queue{Email};
        }

        my $CustomerUser = $ParamObject->GetParam( Param => 'CustomerUser' )
            || $ParamObject->GetParam( Param => 'PreSelectedCustomerUser' )
            || $ParamObject->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $CustomerID = $ParamObject->GetParam( Param => 'CustomerID' ) || '';
        my $SelectedCustomerUser = $ParamObject->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $ExpandCustomerName = $ParamObject->GetParam( Param => 'ExpandCustomerName' )
            || 0;
        my %FromExternalCustomer;
        $FromExternalCustomer{Customer} = $ParamObject->GetParam( Param => 'PreSelectedCustomerUser' )
            || $ParamObject->GetParam( Param => 'CustomerUser' )
            || '';
        $GetParam{QueueID}            = $NewQueueID;
        $GetParam{ExpandCustomerName} = $ExpandCustomerName;

        # get sender queue from
        my $Signature = '';
        if ($NewQueueID) {
            $Signature = $Self->_GetSignature(
                QueueID        => $NewQueueID,
                CustomerUserID => $CustomerUser
            );
        }

        if ( $ParamObject->GetParam( Param => 'OwnerAllRefresh' ) ) {
            $GetParam{OwnerAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $ParamObject->GetParam( Param => 'ResponsibleAllRefresh' ) ) {
            $GetParam{ResponsibleAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $ParamObject->GetParam( Param => 'ClearTo' ) ) {
            $GetParam{To} = '';
            $ExpandCustomerName = 3;
        }
        for my $Number ( 1 .. 2 ) {
            my $Item = $ParamObject->GetParam( Param => "ExpandCustomerName$Number" ) || 0;
            if ( $Number == 1 && $Item ) {
                $ExpandCustomerName = 1;
            }
            elsif ( $Number == 2 && $Item ) {
                $ExpandCustomerName = 2;
            }
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        %GetParam,
                        %ACLCompatGetParam,
                        CustomerUserID => $CustomerUser || '',
                        Action         => $Self->{Action},
                        ReturnType     => 'Ticket',
                        ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data           => \%AclData,
                        UserID         => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $TicketObject->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            my $ValidationResult;

            # do not validate on attachment upload
            if ( !$ExpandCustomerName ) {

                $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $ParamObject,
                    Mandatory =>
                        $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    return $LayoutObject->ErrorScreen(
                        Message =>
                            $LayoutObject->{LanguageObject}
                            ->Translate( 'Could not perform validation on field %s!', $DynamicFieldConfig->{Label} ),
                        Comment => Translatable('Please contact the administrator.'),
                    );
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Mandatory =>
                    $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                ServerError  => $ValidationResult->{ServerError}  || '',
                ErrorMessage => $ValidationResult->{ErrorMessage} || '',
                LayoutObject => $LayoutObject,
                ParamObject  => $ParamObject,
                AJAXUpdate   => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
            );
        }

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # get customer user object
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Expand Customer Name
        my %CustomerUserData;
        if ( $ExpandCustomerName == 1 ) {

            # search customer
            my %CustomerUserList;
            %CustomerUserList = $CustomerUserObject->CustomerSearch(
                Search => $GetParam{To},
            );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for my $CustomerUserKey ( sort keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$CustomerUserKey};
                $Param{CustomerUserListLastUser} = $CustomerUserKey;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $GetParam{To}              = $Param{CustomerUserListLast};
                $Error{ExpandCustomerName} = 1;
                my %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $CustomerID = $CustomerUserData{UserCustomerID};
                }
                if ( $CustomerUserData{UserLogin} ) {
                    $CustomerUser = $CustomerUserData{UserLogin};
                }
            }

            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {

                # don't check email syntax on multi customer select
                $ConfigObject->Set(
                    Key   => 'CheckEmailAddresses',
                    Value => 0
                );
                $CustomerID = '';

                # clear to if there is no customer found
                if ( !%CustomerUserList ) {
                    $GetParam{To} = '';
                }
                $Error{ExpandCustomerName} = 1;
            }
        }

        # get from and customer id if customer user is given
        elsif ( $ExpandCustomerName == 2 ) {
            %CustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                User => $CustomerUser,
            );
            my %CustomerUserList = $CustomerUserObject->CustomerSearch(
                UserLogin => $CustomerUser,
            );
            for my $CustomerUserKey ( sort keys %CustomerUserList ) {
                $GetParam{To} = $CustomerUserList{$CustomerUserKey};
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $CustomerID = $CustomerUserData{UserCustomerID};
            }
            if ( $CustomerUserData{UserLogin} ) {
                $CustomerUser = $CustomerUserData{UserLogin};
            }
            if ( $FromExternalCustomer{Customer} ) {
                my %ExternalCustomerUserData = $CustomerUserObject->CustomerUserDataGet(
                    User => $FromExternalCustomer{Customer},
                );
                $FromExternalCustomer{Email} = $ExternalCustomerUserData{UserMailString};
            }
            $Error{ExpandCustomerName} = 1;
        }

        # if a new destination queue is selected
        elsif ( $ExpandCustomerName == 3 ) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }

        # show customer info
        my %CustomerData;
        if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoCompose') ) {
            if ( $CustomerUser || $SelectedCustomerUser ) {
                %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                    User => $CustomerUser || $SelectedCustomerUser,
                );
            }
            elsif ($CustomerID) {
                %CustomerData = $CustomerUserObject->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }

        # check email address
        PARAMETER:
        for my $Parameter (qw(To Cc Bcc)) {
            next PARAMETER if !$GetParam{$Parameter};
            for my $Email ( Mail::Address->parse( $GetParam{$Parameter} ) ) {
                if ( !$CheckItemObject->CheckEmail( Address => $Email->address() ) ) {
                    $Error{ $Parameter . 'ErrorType' }
                        = $Parameter . $CheckItemObject->CheckErrorType() . 'ServerErrorMsg';
                    $Error{ $Parameter . 'Invalid' } = 'ServerError';
                }

                my $IsLocal = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressIsLocalAddress(
                    Address => $Email->address()
                );
                if ($IsLocal) {
                    $Error{ $Parameter . 'IsLocalAddress' } = 'ServerError';
                }
            }
        }

        # if it is not a subaction about attachments, check for server errors
        if ( !$ExpandCustomerName ) {
            if ( !$GetParam{To} ) {
                $Error{'ToInvalid'} = 'ServerError';
            }
            if ( !$GetParam{Subject} ) {
                $Error{'SubjectInvalid'} = 'ServerError';
            }
            if ( !$NewQueueID ) {
                $Error{'DestinationInvalid'} = 'ServerError';
            }
            if ( !$GetParam{Body} ) {
                $Error{'BodyInvalid'} = 'ServerError';
            }

            # check if date is valid
            if (
                !$ExpandCustomerName
                && $StateData{TypeName}
                && $StateData{TypeName} =~ /^pending/i
                )
            {

                # convert pending date to a datetime object
                my $PendingDateTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        %GetParam,
                        Second => 0,
                    },
                );

                # get current system epoch
                my $CurSystemDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

                if ( !$PendingDateTimeObject || $PendingDateTimeObject < $CurSystemDateTimeObject ) {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }

            if (
                $ConfigObject->Get('Ticket::Service')
                && $GetParam{SLAID}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = 'ServerError';
            }

            # check mandatory service
            if (
                $ConfigObject->Get('Ticket::Service')
                && $Config->{ServiceMandatory}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }

            # check mandatory sla
            if (
                $ConfigObject->Get('Ticket::Service')
                && $Config->{SLAMandatory}
                && !$GetParam{SLAID}
                )
            {
                $Error{'SLAInvalid'} = ' ServerError';
            }

            if ( $ConfigObject->Get('Ticket::Type') && !$GetParam{TypeID} ) {
                $Error{'TypeInvalid'} = 'ServerError';
            }
            if (
                $ConfigObject->Get('Ticket::Frontend::AccountTime')
                && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                && $GetParam{TimeUnits} eq ''
                )
            {
                $Error{'TimeUnitsInvalid'} = 'ServerError';
            }
        }

        # run compose modules
        my %ArticleParam;
        if ( ref $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {
            my %Jobs = %{ $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') };
            for my $Job ( sort keys %Jobs ) {

                # load module
                if ( !$MainObject->Require( $Jobs{$Job}->{Module} ) ) {
                    return $LayoutObject->FatalError();
                }

                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    Debug => $Debug,
                );

                # get params
                my $Multiple;
                PARAMETER:
                for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {

                    if ( $Jobs{$Job}->{ParamType} && $Jobs{$Job}->{ParamType} ne 'Single' ) {
                        @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
                        $Multiple = 1;
                        next PARAMETER;
                    }

                    $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
                }

                # run module
                $Object->Run(
                    %GetParam,
                    StoreNew => 1,
                    Config   => $Jobs{$Job}
                );

                # get options that have been removed from the selection
                # and add them back to the selection so that the submit
                # will contain options that were hidden from the agent
                my $Key = $Object->Option( %GetParam, Config => $Jobs{$Job} );

                if ( $Object->can('GetOptionsToRemoveAJAX') ) {
                    my @RemovedOptions = $Object->GetOptionsToRemoveAJAX(%GetParam);
                    if (@RemovedOptions) {
                        if ($Multiple) {
                            for my $RemovedOption (@RemovedOptions) {
                                push @{ $GetParam{$Key} }, $RemovedOption;
                            }
                        }
                        else {
                            $GetParam{$Key} = shift @RemovedOptions;
                        }
                    }
                }

                # ticket params
                %ArticleParam = (
                    %ArticleParam,
                    $Object->ArticleOption( %GetParam, %ArticleParam, Config => $Jobs{$Job} ),
                );

                # get errors
                %Error = (
                    %Error,
                    $Object->Error( %GetParam, Config => $Jobs{$Job} ),
                );
            }
        }

        if (%Error) {

            if ( $Error{ToIsLocalAddress} ) {
                $LayoutObject->Block(
                    Name => 'ToIsLocalAddressServerErrorMsg',
                    Data => \%GetParam,
                );
            }

            if ( $Error{CcIsLocalAddress} ) {
                $LayoutObject->Block(
                    Name => 'CcIsLocalAddressServerErrorMsg',
                    Data => \%GetParam,
                );
            }

            if ( $Error{BccIsLocalAddress} ) {
                $LayoutObject->Block(
                    Name => 'BccIsLocalAddressServerErrorMsg',
                    Data => \%GetParam,
                );
            }

            # get and format default subject and body
            my $Subject = $LayoutObject->Output(
                Template => $Config->{Subject} || '',
            );

            my $Body = $LayoutObject->Output(
                Template => $Config->{Body} || '',
            );

            # make sure body is rich text
            if ( $LayoutObject->{BrowserRichText} ) {
                $Body = $LayoutObject->Ascii2RichText(
                    String => $Body,
                );
            }

            #set Body and Subject parameters for Output
            if ( !$GetParam{Subject} ) {
                $GetParam{Subject} = $Subject;
            }

            if ( !$GetParam{Body} ) {
                $GetParam{Body} = $Body;
            }

            # get services
            my $Services = $Self->_GetServices(
                %GetParam,
                %ACLCompatGetParam,
                CustomerUserID => $CustomerUser || '',
                QueueID        => $NewQueueID   || 1,
            );

            # reset previous ServiceID to reset SLA-List if no service is selected
            if ( !$GetParam{ServiceID} || !$Services->{ $GetParam{ServiceID} } ) {
                $GetParam{ServiceID} = '';
            }

            my $SLAs = $Self->_GetSLAs(
                %GetParam,
                %ACLCompatGetParam,
                QueueID => $NewQueueID || 1,
                Services => $Services,
            );

            # header
            $Output .= $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();

            # html output
            $Output .= $Self->_MaskEmailNew(
                QueueID => $Self->{QueueID},
                Users   => $Self->_GetUsers(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{OwnerAll}
                ),
                UserSelected     => $NewUserID,
                ResponsibleUsers => $Self->_GetResponsibles(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{ResponsibleAll}
                ),
                ResponsibleUserSelected => $NewResponsibleID,
                NextStates              => $Self->_GetNextStates(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || '',
                    QueueID        => $NewQueueID   || 1,
                ),
                NextState  => $NextState,
                Priorities => $Self->_GetPriorities(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || '',
                    QueueID        => $NewQueueID   || 1,
                ),
                Types => $Self->_GetTypes(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || '',
                    QueueID        => $NewQueueID   || 1,
                ),
                Services          => $Services,
                SLAs              => $SLAs,
                StandardTemplates => $Self->_GetStandardTemplates(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID => $NewQueueID || '',
                ),
                CustomerID        => $LayoutObject->Ascii2Html( Text => $CustomerID ),
                CustomerUser      => $CustomerUser,
                CustomerData      => \%CustomerData,
                TimeUnitsRequired => (
                    $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_Required'
                    : ''
                ),
                FromList     => $Self->_GetTos(),
                FromSelected => $Dest,
                Subject      => $LayoutObject->Ascii2Html( Text => $GetParam{Subject} ),
                Body         => $LayoutObject->Ascii2Html( Text => $GetParam{Body} ),
                Errors       => \%Error,
                Attachments  => \@Attachments,
                Signature    => $Signature,
                %GetParam,
                DynamicFieldHTML     => \%DynamicFieldHTML,
                MultipleCustomer     => \@MultipleCustomer,
                MultipleCustomerCc   => \@MultipleCustomerCc,
                MultipleCustomerBcc  => \@MultipleCustomerBcc,
                FromExternalCustomer => \%FromExternalCustomer,
            );

            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # create new ticket, do db insert
        my $TicketID = $TicketObject->TicketCreate(
            Title        => $GetParam{Subject},
            QueueID      => $NewQueueID,
            Subject      => $GetParam{Subject},
            Lock         => 'unlock',
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            StateID      => $NextStateID,
            PriorityID   => $GetParam{PriorityID},
            OwnerID      => 1,
            CustomerID   => $CustomerID,
            CustomerUser => $SelectedCustomerUser,
            UserID       => $Self->{UserID},
        );

        # set ticket dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';

            # set the value
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # get pre loaded attachment
        @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );
        if (%UploadStuff) {
            push @Attachments, \%UploadStuff;
        }

        # prepare subject
        my $Tn = $TicketObject->TicketNumberLookup( TicketID => $TicketID );
        $GetParam{Subject} = $TicketObject->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject      => $GetParam{Subject} || '',
            Type         => 'New',
        );

        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ($NewUserID) {
            $NoAgentNotify = 1;
        }

        my $MimeType = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $MimeType = 'text/html';
            $GetParam{Body} .= '<br/><br/>' . $Signature;

            # remove unused inline images
            my @NewAttachmentData;
            ATTACHMENT:
            for my $Attachment (@Attachments) {
                my $ContentID = $Attachment->{ContentID};
                if (
                    $ContentID
                    && ( $Attachment->{ContentType} =~ /image/i )
                    && ( $Attachment->{Disposition} eq 'inline' )
                    )
                {
                    my $ContentIDHTMLQuote = $LayoutObject->Ascii2Html(
                        Text => $ContentID,
                    );

                    # workaround for link encode of rich text editor, see bug#5053
                    my $ContentIDLinkEncode = $LayoutObject->LinkEncode($ContentID);
                    $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                    # ignore attachment if not linked in body
                    next ATTACHMENT
                        if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # remember inline images and normal attachments
                push @NewAttachmentData, \%{$Attachment};
            }
            @Attachments = @NewAttachmentData;

            # verify html document
            $GetParam{Body} = $LayoutObject->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }
        else {
            $GetParam{Body} .= "\n\n" . $Signature;
        }

        # lookup sender
        my $TemplateGenerator = $Kernel::OM->Get('Kernel::System::TemplateGenerator');
        my $Sender            = $TemplateGenerator->Sender(
            QueueID => $NewQueueID,
            UserID  => $Self->{UserID},
        );

        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

        # send email
        my $ArticleID = $ArticleBackendObject->ArticleSend(
            NoAgentNotify        => $NoAgentNotify,
            Attachment           => \@Attachments,
            TicketID             => $TicketID,
            SenderType           => $Config->{SenderType},
            IsVisibleForCustomer => $Config->{IsVisibleForCustomer},
            From                 => $Sender,
            To                   => $GetParam{To},
            Cc                   => $GetParam{Cc},
            Bcc                  => $GetParam{Bcc},
            Subject              => $GetParam{Subject},
            Body                 => $GetParam{Body},
            Charset              => $LayoutObject->{UserCharset},
            MimeType             => $MimeType,
            UserID               => $Self->{UserID},
            HistoryType          => $Config->{HistoryType},
            HistoryComment       => $Config->{HistoryComment}
                || "\%\%$GetParam{To}, $GetParam{Cc}, $GetParam{Bcc}",
            %ArticleParam,
        );
        if ( !$ArticleID ) {
            return $LayoutObject->ErrorScreen();
        }

        # set article dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';

            # set the value
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ArticleID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # remove pre-submitted attachments
        $UploadCacheObject->FormIDRemove( FormID => $Self->{FormID} );

        # link tickets
        if (
            $GetParam{LinkTicketID}
            && $Config->{SplitLinkType}
            && $Config->{SplitLinkType}->{LinkType}
            && $Config->{SplitLinkType}->{Direction}
            )
        {
            my $Access = $TicketObject->TicketPermission(
                Type     => 'ro',
                TicketID => $GetParam{LinkTicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $LayoutObject->NoPermission(
                    Message    => "You need ro permission!",
                    WithHeader => 'yes',
                );
            }

            my $SourceKey = $GetParam{LinkTicketID};
            my $TargetKey = $TicketID;

            if ( $Config->{SplitLinkType}->{Direction} eq 'Source' ) {
                $SourceKey = $TicketID;
                $TargetKey = $GetParam{LinkTicketID};
            }

            # link the tickets
            $Kernel::OM->Get('Kernel::System::LinkObject')->LinkAdd(
                SourceObject => 'Ticket',
                SourceKey    => $SourceKey,
                TargetObject => 'Ticket',
                TargetKey    => $TargetKey,
                Type         => $Config->{SplitLinkType}->{LinkType} || 'Normal',
                State        => 'Valid',
                UserID       => $Self->{UserID},
            );
        }

        # set owner (if new user id is given)
        if ($NewUserID) {
            $TicketObject->TicketOwnerSet(
                TicketID  => $TicketID,
                NewUserID => $NewUserID,
                UserID    => $Self->{UserID},
            );

            # set lock
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );
        }

        # else set owner to current agent but do not lock it
        else {
            $TicketObject->TicketOwnerSet(
                TicketID           => $TicketID,
                NewUserID          => $Self->{UserID},
                SendNoNotification => 1,
                UserID             => $Self->{UserID},
            );
        }

        # set responsible (if new user id is given)
        if ($NewResponsibleID) {
            $TicketObject->TicketResponsibleSet(
                TicketID  => $TicketID,
                NewUserID => $NewResponsibleID,
                UserID    => $Self->{UserID},
            );
        }

        # time accounting
        if ( $GetParam{TimeUnits} ) {
            $TicketObject->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $GetParam{TimeUnits},
                UserID    => $Self->{UserID},
            );
        }

        # should i set an unlock?
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $TicketObject->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $TicketObject->TicketPendingTimeSet(
                UserID   => $Self->{UserID},
                TicketID => $TicketID,
                %GetParam,
            );
        }

        # get redirect screen
        my $NextScreen = $Self->{UserCreateNextMask} || 'AgentTicketEmail';

        # redirect
        return $LayoutObject->Redirect(
            OP => "Action=$NextScreen;Subaction=Created;TicketID=$TicketID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Dest           = $ParamObject->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser   = $ParamObject->GetParam( Param => 'SelectedCustomerUser' );
        my $ElementChanged = $ParamObject->GetParam( Param => 'ElementChanged' ) || '';

        # get From based on selected queue
        my $QueueID = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
            my %Queue = $QueueObject->GetSystemAddress( QueueID => $QueueID );
            $GetParam{From} = $Queue{Email};
        }

        # get list type
        my $TreeView = 0;
        if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Tos = $Self->_GetTos(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID => $QueueID,
        );

        my $NewTos;

        if ($Tos) {
            TOs:
            for my $KeyTo ( sort keys %{$Tos} ) {
                next TOs if ( $Tos->{$KeyTo} eq '-' );
                $NewTos->{"$KeyTo||$Tos->{$KeyTo}"} = $Tos->{$KeyTo};
            }
        }
        my $Signature = '';
        if ($QueueID) {
            $Signature = $Self->_GetSignature(
                QueueID        => $QueueID,
                CustomerUserID => $CustomerUser,
            );
        }
        my $Users = $Self->_GetUsers(
            %GetParam,
            %ACLCompatGetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $ResponsibleUsers = $Self->_GetResponsibles(
            %GetParam,
            %ACLCompatGetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{ResponsibleAll},
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
            Services       => $Services,
        );
        my $StandardTemplates = $Self->_GetStandardTemplates(
            %GetParam,
            %ACLCompatGetParam,
            QueueID => $QueueID || '',
        );
        my $Types = $Self->_GetTypes(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DYNAMICFIELD if !$IsACLReducible;

            my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
                %GetParam,
                %ACLCompatGetParam,
                CustomerUserID => $CustomerUser || '',
                Action         => $Self->{Action},
                TicketID       => $Self->{TicketID},
                QueueID        => $QueueID      || 0,
                ReturnType     => 'Ticket',
                ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data           => \%AclData,
                UserID         => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $TicketObject->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            my $DataValues = $DynamicFieldBackendObject->BuildSelectionDataGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                PossibleValues     => $PossibleValues,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
            ) || $PossibleValues;

            # add dynamic field to the list of fields to update
            push(
                @DynamicFieldAJAX,
                {
                    Name        => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data        => $DataValues,
                    SelectedID  => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                }
            );
        }

        my @TemplateAJAX;

        # update ticket body and attachements if needed.
        if ( $ElementChanged eq 'StandardTemplateID' ) {
            my @TicketAttachments;
            my $TemplateText;

            # remove all attachments from the Upload cache
            my $RemoveSuccess = $UploadCacheObject->FormIDRemove(
                FormID => $Self->{FormID},
            );
            if ( !$RemoveSuccess ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Form attachments could not be deleted!",
                );
            }

            # get the template text and set new attachments if a template is selected
            if ( IsPositiveInteger( $GetParam{StandardTemplateID} ) ) {
                my $TemplateGenerator = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

                # set template text, replace smart tags (limited as ticket is not created)
                $TemplateText = $TemplateGenerator->Template(
                    TemplateID => $GetParam{StandardTemplateID},
                    UserID     => $Self->{UserID},
                );

                # create StdAttachmentObject
                my $StdAttachmentObject = $Kernel::OM->Get('Kernel::System::StdAttachment');

                # add std. attachments to ticket
                my %AllStdAttachments = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
                    StandardTemplateID => $GetParam{StandardTemplateID},
                );
                for ( sort keys %AllStdAttachments ) {
                    my %AttachmentsData = $StdAttachmentObject->StdAttachmentGet( ID => $_ );
                    $UploadCacheObject->FormIDAddFile(
                        FormID      => $Self->{FormID},
                        Disposition => 'attachment',
                        %AttachmentsData,
                    );
                }

                # send a list of attachments in the upload cache back to the clientside JavaScript
                # which renders then the list of currently uploaded attachments
                @TicketAttachments = $UploadCacheObject->FormIDGetAllFilesMeta(
                    FormID => $Self->{FormID},
                );

                for my $Attachment (@TicketAttachments) {
                    $Attachment->{Filesize} = $LayoutObject->HumanReadableDataSize(
                        Size => $Attachment->{Filesize},
                    );
                }
            }

            @TemplateAJAX = (
                {
                    Name => 'UseTemplateCreate',
                    Data => '0',
                },
                {
                    Name => 'RichText',
                    Data => $TemplateText || '',
                },
                {
                    Name     => 'TicketAttachments',
                    Data     => \@TicketAttachments,
                    KeepData => 1,
                },
            );
        }

        my @ExtendedData;

        # run compose modules
        if ( ref $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') eq 'HASH' ) {

            # use QueueID from web request in compose modules
            $GetParam{QueueID} = $QueueID;

            my %Jobs = %{ $ConfigObject->Get('Ticket::Frontend::ArticleComposeModule') };
            JOB:
            for my $Job ( sort keys %Jobs ) {

                # load module
                next JOB if !$MainObject->Require( $Jobs{$Job}->{Module} );

                my $Object = $Jobs{$Job}->{Module}->new(
                    %{$Self},
                    Debug => $Debug,
                );

                my $Multiple;

                # get params
                PARAMETER:
                for my $Parameter ( $Object->Option( %GetParam, Config => $Jobs{$Job} ) ) {

                    if ( $Jobs{$Job}->{ParamType} && $Jobs{$Job}->{ParamType} ne 'Single' ) {
                        @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
                        $Multiple = 1;
                        next PARAMETER;
                    }

                    $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
                }

                # run module
                my %Data = $Object->Data( %GetParam, Config => $Jobs{$Job} );

                # get AJAX param values
                if ( $Object->can('GetParamAJAX') ) {
                    %GetParam = ( %GetParam, $Object->GetParamAJAX(%GetParam) );
                }

                # get options that have to be removed from the selection visible
                # to the agent. These options will be added again on submit.
                if ( $Object->can('GetOptionsToRemoveAJAX') ) {
                    my @OptionsToRemove = $Object->GetOptionsToRemoveAJAX(%GetParam);

                    for my $OptionToRemove (@OptionsToRemove) {
                        delete $Data{$OptionToRemove};
                    }
                }

                my $Key = $Object->Option( %GetParam, Config => $Jobs{$Job} );

                if ($Key) {
                    push(
                        @ExtendedData,
                        {
                            Name         => $Key,
                            Data         => \%Data,
                            SelectedID   => $GetParam{$Key},
                            Translation  => 1,
                            PossibleNone => 1,
                            Multiple     => $Multiple,
                            Max          => 100,
                        }
                    );
                }
            }
        }

        # convert Signature to ASCII, if RichText is on
        if ( $LayoutObject->{BrowserRichText} ) {

            #            $Signature = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii( String => $Signature, );
        }

        my $JSON = $LayoutObject->BuildSelectionJSON(
            [
                {
                    Name         => 'Dest',
                    Data         => $NewTos,
                    SelectedID   => $Dest,
                    Translation  => 0,
                    PossibleNone => 1,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                {
                    Name         => 'Signature',
                    Data         => $Signature,
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewUserID',
                    Data         => $Users,
                    SelectedID   => $GetParam{NewUserID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewResponsibleID',
                    Data         => $ResponsibleUsers,
                    SelectedID   => $GetParam{NewResponsibleID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name        => 'NextStateID',
                    Data        => $NextStates,
                    SelectedID  => $GetParam{NextStateID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name        => 'PriorityID',
                    Data        => $Priorities,
                    SelectedID  => $GetParam{PriorityID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name         => 'ServiceID',
                    Data         => $Services,
                    SelectedID   => $GetParam{ServiceID},
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                {
                    Name         => 'SLAID',
                    Data         => $SLAs,
                    SelectedID   => $GetParam{SLAID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                {
                    Name         => 'StandardTemplateID',
                    Data         => $StandardTemplates,
                    SelectedID   => $GetParam{StandardTemplateID},
                    PossibleNone => 1,
                    Translation  => 1,
                    Max          => 100,
                },
                {
                    Name         => 'TypeID',
                    Data         => $Types,
                    SelectedID   => $GetParam{TypeID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                @DynamicFieldAJAX,
                @TemplateAJAX,
                @ExtendedData,
            ],
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No Subaction!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(%Param);
        for my $GroupMemberKey ( sort keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $GroupMemberKey ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$GroupMemberKey};
            }
        }
    }

    # check show users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are owner or rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'owner',
        );
        for my $MemberKey ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$MemberKey} ) {
                $ShownUsers{$MemberKey} = $AllGroupsMembers{$MemberKey};
            }
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'Owner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetResponsibles {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(%Param);
        for my $GroupMemberKey ( sort keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $GroupMemberKey ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$GroupMemberKey};
            }
        }
    }

    # check show users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are responsible or rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'responsible',
        );
        for my $MemberKey ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$MemberKey} ) {
                $ShownUsers{$MemberKey} = $AllGroupsMembers{$MemberKey};
            }
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'Responsible',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # get type
    my %Type;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # check needed
    return \%Service if !$Param{QueueID} && !$Param{TicketID};

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer
        = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
                %Param,
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
    }
    return \%SLA;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check own selection
    my %NewTos;
    if ( $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewTos = %{ $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
        if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Tos = $Kernel::OM->Get('Kernel::System::Ticket')->MoveList(
                %Param,
                Type   => 'create',
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        else {
            %Tos = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList();
        }

        # get create permission queues
        my %UserGroups = $Kernel::OM->Get('Kernel::System::Group')->PermissionUserGet(
            UserID => $Self->{UserID},
            Type   => 'create',
        );

        # build selection string
        QUEUEID:
        for my $QueueID ( sort keys %Tos ) {
            my %QueueData = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next QUEUEID if !$UserGroups{ $QueueData{GroupID} };

            my $String = $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;

            # remove trailing spaces
            $String =~ s{\s+\z}{} if !$QueueData{Comment};

            if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressGet(
                    ID => $Tos{$QueueID},
                );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$QueueID} = $String;
        }
    }

    # add empty selection
    $NewTos{''} = '-';
    return \%NewTos;
}

sub _GetSignature {
    my ( $Self, %Param ) = @_;

    # prepare signature
    my $TemplateGenerator = $Kernel::OM->Get('Kernel::System::TemplateGenerator');
    my $Signature         = $TemplateGenerator->Signature(
        QueueID => $Param{QueueID},
        Data    => \%Param,
        UserID  => $Self->{UserID},
    );

    return $Signature;
}

sub _GetStandardTemplates {
    my ( $Self, %Param ) = @_;

    my %Templates;
    my $QueueID = $Param{QueueID} || '';

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');

    if ( !$QueueID ) {
        my $UserDefaultQueue = $ConfigObject->Get('Ticket::Frontend::UserDefaultQueue') || '';

        if ($UserDefaultQueue) {
            $QueueID = $QueueObject->QueueLookup( Queue => $UserDefaultQueue );
        }
    }

    # check needed
    return \%Templates if !$QueueID && !$Param{TicketID};

    if ( !$QueueID && $Param{TicketID} ) {

        # get QueueID from the ticket
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );
        $QueueID = $Ticket{QueueID} || '';
    }

    # fetch all std. templates
    my %StandardTemplates = $QueueObject->QueueStandardTemplateMemberList(
        QueueID       => $QueueID,
        TemplateTypes => 1,
    );

    # return empty hash if there are no templates for this screen
    return \%Templates if !IsHashRefWithData( $StandardTemplates{Create} );

    # return just the templates for this screen
    return $StandardTemplates{Create};
}

sub _MaskEmailNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # set JS data
    $LayoutObject->AddJSData(
        Key   => 'CustomerSearch',
        Value => {
            ShowCustomerTickets => $ConfigObject->Get('Ticket::Frontend::ShowCustomerTickets'),
        },
    );

    # build string
    $Param{OptionStrg} = $LayoutObject->BuildSelection(
        Data         => $Param{Users},
        SelectedID   => $Param{UserSelected},
        Translation  => 0,
        PossibleNone => 1,
        Name         => 'NewUserID',
        Class        => 'Modernize',
    );

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    # build next states string
    $Param{NextStatesStrg} = $LayoutObject->BuildSelection(
        Data          => $Param{NextStates},
        Name          => 'NextStateID',
        Class         => 'Modernize',
        Translation   => 1,
        SelectedValue => $Param{NextState} || $Config->{StateDefault},
    );

    # build Destination string
    my %NewTo;
    if ( $Param{FromList} ) {
        for my $FromKey ( sort keys %{ $Param{FromList} } ) {
            $NewTo{"$FromKey||$Param{FromList}->{$FromKey}"} = $Param{FromList}->{$FromKey};
        }
    }
    if ( !$Param{FromSelected} ) {
        my $UserDefaultQueue = $ConfigObject->Get('Ticket::Frontend::UserDefaultQueue') || '';
        if ($UserDefaultQueue) {
            my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $UserDefaultQueue );
            if ($QueueID) {
                $Param{FromSelected} = "$QueueID||$UserDefaultQueue";
            }
        }
    }

    if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
        $Param{FromStrg} = $LayoutObject->AgentQueueListOption(
            Data           => \%NewTo,
            Multiple       => 0,
            Size           => 0,
            Class          => 'Validate_Required Modernize ' . ( $Param{Errors}->{DestinationInvalid} || ' ' ),
            Name           => 'Dest',
            TreeView       => $TreeView,
            SelectedID     => $Param{FromSelected},
            OnChangeSubmit => 0,
        );
    }
    else {
        $Param{FromStrg} = $LayoutObject->BuildSelection(
            Data       => \%NewTo,
            Class      => 'Validate_Required Modernize ' . ( $Param{Errors}->{DestinationInvalid} || ' ' ),
            Name       => 'Dest',
            TreeView   => $TreeView,
            SelectedID => $Param{FromSelected},
        );
    }

    # customer info string
    if ( $ConfigObject->Get('Ticket::Frontend::CustomerInfoCompose') ) {
        $Param{CustomerTable} = $LayoutObject->AgentCustomerViewTable(
            Data => $Param{CustomerData},
            Max  => $ConfigObject->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );
        $LayoutObject->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $ErrorKey ( sort keys %{ $Param{Errors} } ) {
            $Param{$ErrorKey} = $LayoutObject->Ascii2Html( Text => $Param{Errors}->{$ErrorKey} );
        }
    }

    # From external
    my $ShowErrors = 1;
    if (
        defined $Param{FromExternalCustomer}
        &&
        defined $Param{FromExternalCustomer}->{Email} &&
        defined $Param{FromExternalCustomer}->{Customer}
        )
    {
        $ShowErrors = 0;
        $LayoutObject->Block(
            Name => 'FromExternalCustomer',
            Data => $Param{FromExternalCustomer},
        );

        $LayoutObject->AddJSData(
            Key   => 'DataEmail',
            Value => $Param{FromExternalCustomer}->{Email},
        );
        $LayoutObject->AddJSData(
            Key   => 'DataCustomer',
            Value => $Param{FromExternalCustomer}->{Customer},
        );
    }

    # Cc
    my $CustomerCounterCc = 0;
    if ( $Param{MultipleCustomerCc} ) {
        for my $Item ( @{ $Param{MultipleCustomerCc} } ) {
            if ( !$ShowErrors ) {

                # set empty values for errors
                $Item->{CustomerError}    = '';
                $Item->{CustomerDisabled} = '';
                $Item->{CustomerErrorMsg} = 'CustomerGenericServerErrorMsg';
            }
            $LayoutObject->Block(
                Name => 'CcMultipleCustomer',
                Data => $Item,
            );
            $LayoutObject->Block(
                Name => 'Cc' . $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $LayoutObject->Block(
                    Name => 'CcCustomerErrorExplantion',
                );
            }
            $CustomerCounterCc++;
        }
    }

    if ( !$CustomerCounterCc ) {
        $Param{CcCustomerHiddenContainer} = 'Hidden';
    }

    # set customer counter
    $LayoutObject->Block(
        Name => 'CcMultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounterCc++,
        },
    );

    # Bcc
    my $CustomerCounterBcc = 0;
    if ( $Param{MultipleCustomerBcc} ) {
        for my $Item ( @{ $Param{MultipleCustomerBcc} } ) {
            if ( !$ShowErrors ) {

                # set empty values for errors
                $Item->{CustomerError}    = '';
                $Item->{CustomerDisabled} = '';
                $Item->{CustomerErrorMsg} = 'CustomerGenericServerErrorMsg';
            }
            $LayoutObject->Block(
                Name => 'BccMultipleCustomer',
                Data => $Item,
            );
            $LayoutObject->Block(
                Name => 'Bcc' . $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $LayoutObject->Block(
                    Name => 'BccCustomerErrorExplantion',
                );
            }
            $CustomerCounterBcc++;
        }
    }

    if ( !$CustomerCounterBcc ) {
        $Param{BccCustomerHiddenContainer} = 'Hidden';
    }

    # set customer counter
    $LayoutObject->Block(
        Name => 'BccMultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounterBcc++,
        },
    );

    # To
    my $CustomerCounter = 0;
    if ( $Param{MultipleCustomer} ) {
        for my $Item ( @{ $Param{MultipleCustomer} } ) {
            if ( !$ShowErrors ) {

                # set empty values for errors
                $Item->{CustomerError}    = '';
                $Item->{CustomerDisabled} = '';
                $Item->{CustomerErrorMsg} = 'CustomerGenericServerErrorMsg';
            }
            $LayoutObject->Block(
                Name => 'MultipleCustomer',
                Data => $Item,
            );
            $LayoutObject->Block(
                Name => $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $LayoutObject->Block(
                    Name => 'CustomerErrorExplantion',
                );
            }
            $CustomerCounter++;
        }
    }

    if ( !$CustomerCounter ) {
        $Param{CustomerHiddenContainer} = 'Hidden';
    }

    # set customer counter
    $LayoutObject->Block(
        Name => 'MultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounter++,
        },
    );

    if ( $Param{ToInvalid} && $Param{Errors} && !$Param{Errors}->{ToErrorType} ) {
        $LayoutObject->Block(
            Name => 'ToServerErrorMsg',
        );
    }
    if ( $Param{Errors}->{ToErrorType} || !$ShowErrors ) {
        $Param{ToInvalid} = '';
    }

    if ( $Param{CcInvalid} && $Param{Errors} && !$Param{Errors}->{CcErrorType} ) {
        $LayoutObject->Block(
            Name => 'CcServerErrorMsg',
        );
    }
    if ( $Param{Errors}->{CcErrorType} || !$ShowErrors ) {
        $Param{CcInvalid} = '';
    }

    if ( $Param{BccInvalid} && $Param{Errors} && !$Param{Errors}->{BccErrorType} ) {
        $LayoutObject->Block(
            Name => 'BccServerErrorMsg',
        );
    }
    if ( $Param{Errors}->{BccErrorType} || !$ShowErrors ) {
        $Param{BccInvalid} = '';
    }

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1
    );

    $LayoutObject->AddJSData(
        Key   => 'DynamicFieldNames',
        Value => $DynamicFieldNames,
    );

    # build type string
    if ( $ConfigObject->Get('Ticket::Type') ) {
        $Param{TypeStrg} = $LayoutObject->BuildSelection(
            Data         => $Param{Types},
            Name         => 'TypeID',
            Class        => 'Validate_Required Modernize ' . ( $Param{Errors}->{TypeInvalid} || ' ' ),
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $LayoutObject->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # build service string
    if ( $ConfigObject->Get('Ticket::Service') ) {

        $Param{ServiceStrg} = $LayoutObject->BuildSelection(
            Data  => $Param{Services},
            Name  => 'ServiceID',
            Class => 'Modernize '
                . ( $Config->{ServiceMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{Errors}->{ServiceInvalid} || '' ),
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
        );
        $LayoutObject->Block(
            Name => 'TicketService',
            Data => {
                ServiceMandatory => $Config->{ServiceMandatory} || 0,
                %Param,
            },
        );

        $Param{SLAStrg} = $LayoutObject->BuildSelection(
            Data       => $Param{SLAs},
            Name       => 'SLAID',
            SelectedID => $Param{SLAID},
            Class      => 'Modernize '
                . ( $Config->{SLAMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{Errors}->{SLAInvalid} || '' ),
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
        );
        $LayoutObject->Block(
            Name => 'TicketSLA',
            Data => {
                SLAMandatory => $Config->{SLAMandatory} || 0,
                %Param,
            },
        );
    }

    # check if exists create templates regardless the queue
    my %StandardTemplates = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList(
        Valid => 1,
        Type  => 'Create',
    );

    # build text template string
    if ( IsHashRefWithData( \%StandardTemplates ) ) {
        $Param{StandardTemplateStrg} = $LayoutObject->BuildSelection(
            Data       => $Param{StandardTemplates}  || {},
            Name       => 'StandardTemplateID',
            SelectedID => $Param{StandardTemplateID} || '',
            Class      => 'Modernize',
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 1,
            Max          => 200,
        );
        $LayoutObject->Block(
            Name => 'StandardTemplate',
            Data => {%Param},
        );
    }

    # build priority string
    if ( !$Param{PriorityID} ) {
        $Param{Priority} = $Config->{Priority};
    }
    $Param{PriorityStrg} = $LayoutObject->BuildSelection(
        Data          => $Param{Priorities},
        Name          => 'PriorityID',
        SelectedID    => $Param{PriorityID},
        Class         => 'Modernize',
        SelectedValue => $Param{Priority},
        Translation   => 1,
    );

    # pending data string
    $Param{PendingDateString} = $LayoutObject->BuildDateSelection(
        %Param,
        Format               => 'DateInputFormatLong',
        YearPeriodPast       => 0,
        YearPeriodFuture     => 5,
        DiffTime             => $ConfigObject->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Class                => $Param{Errors}->{DateInvalid} || ' ',
        Validate             => 1,
        ValidateDateInFuture => 1,
    );

    # show owner selection
    if ( $ConfigObject->Get('Ticket::Frontend::NewOwnerSelection') ) {
        $LayoutObject->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
    }

    # show responsible selection
    if (
        $ConfigObject->Get('Ticket::Responsible')
        && $ConfigObject->Get('Ticket::Frontend::NewResponsibleSelection')
        )
    {
        $Param{ResponsibleUsers}->{''} = '-';
        $Param{ResponsibleOptionStrg} = $LayoutObject->BuildSelection(
            Data       => $Param{ResponsibleUsers},
            SelectedID => $Param{ResponsibleUserSelected},
            Name       => 'NewResponsibleID',
            Class      => 'Modernize',
        );
        $LayoutObject->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
    }

    # Dynamic fields
    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip fields that HTML could not be retrieved
        next DYNAMICFIELD if !IsHashRefWithData(
            $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
        );

        # get the html strings form $Param
        my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

        $LayoutObject->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );
    }

    # show time accounting box
    if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
        if ( $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
        }
        $LayoutObject->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    # Show the customer user address book if the module is registered and java script support is available.
    if (
        $ConfigObject->Get('Frontend::Module')->{AgentCustomerUserAddressBook}
        && $LayoutObject->{BrowserJavaScriptSupport}
        )
    {
        $Param{OptionCustomerUserAddressBook} = 1;
    }

    # show customer edit link
    my $OptionCustomer = $LayoutObject->Permission(
        Action => 'AdminCustomerUser',
        Type   => 'rw',
    );

    my $ShownOptionsBlock;

    if ($OptionCustomer) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $LayoutObject->Block(
                Name => 'TicketOptions',
                Data => {
                    %Param,
                },
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $LayoutObject->Block(
            Name => 'OptionCustomer',
            Data => {
                %Param,
            },
        );
    }

    # show attachments
    ATTACHMENT:
    for my $Attachment ( @{ $Param{Attachments} } ) {
        if (
            $Attachment->{ContentID}
            && $LayoutObject->{BrowserRichText}
            && ( $Attachment->{ContentType} =~ /image/i )
            && ( $Attachment->{Disposition} eq 'inline' )
            )
        {
            next ATTACHMENT;
        }

        push @{ $Param{AttachmentList} }, $Attachment;
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

        # set up rich text editor
        $LayoutObject->SetRichTextParameters(
            Data => \%Param,
        );
    }

    # get output back
    return $LayoutObject->Output(
        TemplateFile => 'AgentTicketEmail',
        Data         => \%Param
    );
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updateable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields = qw(
            TypeID Dest NextStateID PriorityID ServiceID SLAID SignKeyID CryptKeyID To Cc Bcc
            StandardTemplateID
        );
    }

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsACLReducible = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );
        next DYNAMICFIELD if !$IsACLReducible;

        push @UpdatableFields, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@UpdatableFields;
}

1;
