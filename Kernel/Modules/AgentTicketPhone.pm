# --
# Kernel/Modules/AgentTicketPhone.pm - to handle phone calls
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketPhone;

use strict;
use warnings;

use Mail::Address;

use Kernel::System::CheckItem;
use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::State;
use Kernel::System::StandardTemplate;
use Kernel::System::StdAttachment;
use Kernel::System::SystemAddress;
use Kernel::System::TemplateGenerator;
use Kernel::System::VariableCheck qw(:all);
use Kernel::System::Web::UploadCache;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject MainObject ConfigObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{SystemAddress}          = Kernel::System::SystemAddress->new(%Param);
    $Self->{CustomerUserObject}     = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject}        = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject}            = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject}      = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{LinkObject}             = Kernel::System::LinkObject->new(%Param);
    $Self->{HTMLUtilsObject}        = Kernel::System::HTMLUtils->new(%Param);
    $Self->{DynamicFieldObject}     = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}          = Kernel::System::DynamicField::Backend->new(%Param);
    $Self->{StandardTemplateObject} = Kernel::System::StandardTemplate->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %GetParam;
    for my $Key (
        qw(ArticleID LinkTicketID PriorityID NewUserID
        From Subject Body NextStateID TimeUnits
        Year Month Day Hour Minute
        NewResponsibleID ResponsibleAll OwnerAll TypeID ServiceID SLAID StandardTemplateID
        )
        )
    {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam;
    $ACLCompatGetParam{OwnerID} = $GetParam{NewUserID};

    # If is an action about attachments
    my $IsUpload = ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ? 1 : 0 );

    # MultipleCustomer From-field
    my @MultipleCustomer;
    my $CustomersNumber
        = $Self->{ParamObject}->GetParam( Param => 'CustomerTicketCounterFromCustomer' ) || 0;
    my $Selected = $Self->{ParamObject}->GetParam( Param => 'CustomerSelected' ) || '';

    # hash for check duplicated entries
    my %AddressesList;

    if ($CustomersNumber) {
        my $CustomerCounter = 1;
        for my $Count ( 1 ... $CustomersNumber ) {
            my $CustomerElement
                = $Self->{ParamObject}->GetParam( Param => 'CustomerTicketText_' . $Count );
            my $CustomerSelected = ( $Selected eq $Count ? 'checked="checked"' : '' );
            my $CustomerKey = $Self->{ParamObject}->GetParam( Param => 'CustomerKey_' . $Count )
                || '';

            if ($CustomerElement) {

                my $CountAux         = $CustomerCounter++;
                my $CustomerError    = '';
                my $CustomerErrorMsg = 'CustomerGenericServerErrorMsg';
                my $CustomerDisabled = '';

                if ( !$IsUpload ) {
                    $GetParam{From} .= $CustomerElement . ',';

                    # check email address
                    for my $Email ( Mail::Address->parse($CustomerElement) ) {
                        if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) )
                        {
                            $CustomerErrorMsg = $Self->{CheckItemObject}->CheckErrorType()
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

    # get Dynamic fields form ParamObject
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} }
            = $Self->{BackendObject}->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $Self->{ParamObject},
            LayoutObject       => $Self->{LayoutObject},
            );
    }

    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldACLParameters;
    DYNAMICFIELD:
    for my $DynamicField ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField }
            = $DynamicFieldValues{$DynamicField};
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
        %GetParam = $Self->{LayoutObject}->TransformDateSelection(
            %GetParam,
        );
    }

    if ( !$Self->{Subaction} || $Self->{Subaction} eq 'Created' ) {

        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        # if there is no ticket id!
        if ( $Self->{TicketID} && $Self->{Subaction} eq 'Created' ) {

            # notify info
            my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
            $Output .= $Self->{LayoutObject}->Notify(
                Info => 'Ticket "%s" created!", "' . $Ticket{TicketNumber},
                Link => '$Env{"Baselink"}Action=AgentTicketZoom;TicketID=' . $Ticket{TicketID},
            );
        }

        # store last queue screen
        if (
            $Self->{LastScreenOverview}
            && $Self->{LastScreenOverview} !~ /Action=AgentTicketPhone/
            && $Self->{RequestedURL} !~ /Action=AgentTicketPhone.*LinkTicketID=/
            )
        {
            $Self->{SessionObject}->UpdateSessionID(
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
        if ( $GetParam{ArticleID} ) {

            my $Access = $Self->{TicketObject}->TicketPermission(
                Type     => 'ro',
                TicketID => $Self->{TicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $Self->{LayoutObject}->NoPermission(
                    Message    => "You need ro permission!",
                    WithHeader => 'yes',
                );
            }

            %Article = $Self->{TicketObject}->ArticleGet(
                ArticleID     => $GetParam{ArticleID},
                DynamicFields => 0,
            );

            # check if article is from the same TicketID as we checked permissions for.
            if ( $Article{TicketID} ne $Self->{TicketID} ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Article does not belong to ticket $Self->{TicketID}!",
                );
            }

            $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject => $Article{Subject} || '',
            );

            # save article from for addresses list
            $ArticleFrom = $Article{From};

            # body preparation for plain text processing
            $Article{Body} = $Self->{LayoutObject}->ArticleQuote(
                TicketID           => $Article{TicketID},
                ArticleID          => $GetParam{ArticleID},
                FormID             => $Self->{FormID},
                UploadCacheObject  => $Self->{UploadCacheObject},
                AttachmentsInclude => 1,
            );
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $Article{ContentType} = 'text/html';
            }
            else {
                $Article{ContentType} = 'text/plain';
            }

            # show customer info
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
                if ( $Article{CustomerUserID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );
                }
                elsif ( $Article{CustomerID} ) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Article{CustomerID},
                    );
                }
            }
            if ( $Article{CustomerUserID} ) {
                my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
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
            %CustomerDataFrom = $Self->{CustomerUserObject}->CustomerUserDataGet(
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
            if ( !$Self->{CheckItemObject}->CheckEmail( Address => $EmailAddress ) )
            {
                $CustomerErrorMsg = $Self->{CheckItemObject}->CheckErrorType()
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

            push @MultipleCustomer, {
                Count            => $CountAux,
                CustomerElement  => $Email->address(),
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
        my %UserPreferences = $Self->{UserObject}->GetUserData(
            UserID => $Self->{UserID},
        );

        # store the dynamic fields default values or used specific default values to be used as
        # ACLs info for all fields
        my %DynamicFieldDefaults;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if !IsHashRefWithData( $DynamicFieldConfig->{Config} );
            next DYNAMICFIELD if !$DynamicFieldConfig->{Name};

            # get default value from dynamic field config (if any)
            my $DefaultValue = $DynamicFieldConfig->{Config}->{DefaultValue} || '';

            # override the value from user preferences if is set
            if ( $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} } ) {
                $DefaultValue
                    = $UserPreferences{ 'UserDynamicField_' . $DynamicFieldConfig->{Name} };
            }

            next DYNAMICFIELD if $DefaultValue eq '';
            next DYNAMICFIELD if ref $DefaultValue eq 'ARRAY' && !IsArrayRefWithData($DefaultValue);

            $DynamicFieldDefaults{ 'DynamicField_' . $DynamicFieldConfig->{Name} } = $DefaultValue;
        }
        $GetParam{DynamicField} = \%DynamicFieldDefaults;

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
            my %SplitTicketData = $Self->{TicketObject}->TicketGet(
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
            $SplitTicketParam{ToSelected}
                = $SplitTicketData{QueueID} . '||' . $SplitTicketData{Queue};

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

            my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $Self->{TicketObject}->TicketAcl(
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
                        my %Filter = $Self->{TicketObject}->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter}
                            = map { $_ => $PossibleValues->{$_} }
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
                my $ObjectID
                    = $DynamicFieldConfig->{ObjectType} eq 'Ticket'
                    ? $Self->{TicketID}
                    : $Article{ArticleID};

                # get value stored on the database (split)
                $Value = $Self->{BackendObject}->ValueGet(
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
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} }
                = $Self->{BackendObject}->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Value                => $Value,
                LayoutObject         => $Self->{LayoutObject},
                ParamObject          => $Self->{ParamObject},
                AJAXUpdate           => 1,
                UpdatableFields      => $Self->_GetFieldsToUpdate(),
                Mandatory => $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # get and format default subject and body
        my $Subject = $Article{Subject};
        if ( !$Subject ) {
            $Subject = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Subject} || '',
            );
        }
        my $Body = $Article{Body} || '';
        if ( !$Body ) {
            $Body = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Body} || '',
            );
        }

        # make sure body is rich text (if body is based on config)
        if ( !$GetParam{ArticleID} && $Self->{LayoutObject}->{BrowserRichText} ) {
            $Body = $Self->{LayoutObject}->Ascii2RichText(
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

        # html output
        my $Services = $Self->_GetServices(
            %GetParam,
            %ACLCompatGetParam,
            %SplitTicketParam,
            CustomerUserID => $CustomerData{UserLogin} || '',
            QueueID        => $Self->{QueueID}         || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            %ACLCompatGetParam,
            %SplitTicketParam,
            CustomerUserID => $CustomerData{UserLogin} || '',
            QueueID        => $Self->{QueueID}         || 1,
            Services       => $Services,
        );
        $Output .= $Self->_MaskPhoneNew(
            QueueID    => $Self->{QueueID},
            NextStates => $Self->_GetNextStates(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1,
            ),
            Priorities => $Self->_GetPriorities(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1,
            ),
            Types => $Self->_GetTypes(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID        => $Self->{QueueID}         || 1,
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
            To => $Self->_GetTos(
                %GetParam,
                %ACLCompatGetParam,
                %SplitTicketParam,
                CustomerUserID => $CustomerData{UserLogin} || '',
                QueueID => $Self->{QueueID},
            ),
            From         => $Article{From},
            Subject      => $Subject,
            Body         => $Body,
            CustomerID   => $Article{CustomerID},
            CustomerUser => $Article{CustomerUserID},
            CustomerData => \%CustomerData,
            Attachments  => \@Attachments,
            LinkTicketID => $GetParam{LinkTicketID} || '',

            #            %GetParam,
            %SplitTicketParam,
            DynamicFieldHTML => \%DynamicFieldHTML,
            MultipleCustomer => \@MultipleCustomer,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # create new ticket and article
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {

        my %Error;
        my %StateData;
        if ( $GetParam{NextStateID} ) {
            %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NextStateID},
            );
        }
        my $NextState = $StateData{Name} || '';
        my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';

        # see if only a name has been passed
        if ( $Dest && $Dest !~ m{\A \d+ \| \| .+ \z}msx ) {

            # see if we can get an ID for this queue name
            my $DestID = $Self->{QueueObject}->QueueLookup(
                Queue => $Dest,
            );

            if ($DestID) {
                $Dest = $DestID . '||' . $Dest;
            }
            else {
                $Dest = '';
            }
        }

        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        my $CustomerUser = $Self->{ParamObject}->GetParam( Param => 'CustomerUser' )
            || $Self->{ParamObject}->GetParam( Param => 'PreSelectedCustomerUser' )
            || $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' )
            || '';
        my $CustomerID = $Self->{ParamObject}->GetParam( Param => 'CustomerID' ) || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam( Param => 'ExpandCustomerName' )
            || 0;
        my %FromExternalCustomer;
        $FromExternalCustomer{Customer}
            = $Self->{ParamObject}->GetParam( Param => 'PreSelectedCustomerUser' )
            || $Self->{ParamObject}->GetParam( Param => 'CustomerUser' )
            || '';

        if ( $Self->{ParamObject}->GetParam( Param => 'OwnerAllRefresh' ) ) {
            $GetParam{OwnerAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $Self->{ParamObject}->GetParam( Param => 'ResponsibleAllRefresh' ) ) {
            $GetParam{ResponsibleAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ( $Self->{ParamObject}->GetParam( Param => 'ClearFrom' ) ) {
            $GetParam{From} = '';
            $ExpandCustomerName = 3;
        }
        for my $Count ( 1 .. 2 ) {
            my $Item = $Self->{ParamObject}->GetParam( Param => "ExpandCustomerName$Count" ) || 0;
            if ( $Count == 1 && $Item ) {
                $ExpandCustomerName = 1;
            }
            elsif ( $Count == 2 && $Item ) {
                $ExpandCustomerName = 2;
            }
        }

        # rewrap body if no rich text is used
        if ( $GetParam{Body} && !$Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{Body} = $Self->{LayoutObject}->WrapPlainText(
                MaxCharacters => $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote'),
                PlainText     => $GetParam{Body},
            );
        }

        # attachment delete
        my @AttachmentIDs = map {
            my ($ID) = $_ =~ m{ \A AttachmentDelete (\d+) \z }xms;
            $ID ? $ID : ();
        } $Self->{ParamObject}->GetParamNames();

        COUNT:
        for my $Count ( reverse sort @AttachmentIDs ) {
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
            next COUNT if !$Delete;
            $Error{AttachmentDelete} = 1;
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Count,
            );
            $IsUpload = 1;
        }

        # attachment upload
        if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
            $IsUpload                = 1;
            %Error                   = ();
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param => 'FileUpload',
            );
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # check pending date
        if ( !$ExpandCustomerName && $StateData{TypeName} && $StateData{TypeName} =~ /^pending/i ) {
            if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                if ( $IsUpload == 0 ) {
                    $Error{DateInvalid} = ' ServerError';
                }
            }
            if (
                $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                < $Self->{TimeObject}->SystemTime()
                )
            {
                if ( $IsUpload == 0 ) {
                    $Error{DateInvalid} = ' ServerError';
                }
            }
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $Self->{TicketObject}->TicketAcl(
                        %GetParam,
                        CustomerUserID => $CustomerUser || '',
                        Action         => $Self->{Action},
                        ReturnType     => 'Ticket',
                        ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data           => \%AclData,
                        UserID         => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $Self->{TicketObject}->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter}
                            = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            my $ValidationResult;

            # do not validate on attachment upload
            if ( !$IsUpload && !$ExpandCustomerName ) {

                $ValidationResult = $Self->{BackendObject}->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $Self->{ParamObject},
                    Mandatory =>
                        $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message =>
                            "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                        Comment => 'Please contact the admin.',
                    );
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} }
                = $Self->{BackendObject}->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                ServerError          => $ValidationResult->{ServerError} || '',
                ErrorMessage         => $ValidationResult->{ErrorMessage} || '',
                LayoutObject         => $Self->{LayoutObject},
                ParamObject          => $Self->{ParamObject},
                AJAXUpdate           => 1,
                UpdatableFields      => $Self->_GetFieldsToUpdate(),
                Mandatory => $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );
        }

        # expand customer name
        my %CustomerUserData;
        if ( $ExpandCustomerName == 1 ) {

            # search customer
            my %CustomerUserList;
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $GetParam{From},
            );

            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            for my $KeyCustomerUser ( sort keys %CustomerUserList ) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast}     = $CustomerUserList{$KeyCustomerUser};
                $Param{CustomerUserListLastUser} = $KeyCustomerUser;
            }
            if ( $Param{CustomerUserListCount} == 1 ) {
                $GetParam{From}            = $Param{CustomerUserListLast};
                $Error{ExpandCustomerName} = 1;
                my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ( $CustomerUserData{UserCustomerID} ) {
                    $CustomerID = $CustomerUserData{UserCustomerID};
                }
                if ( $CustomerUserData{UserLogin} ) {
                    $CustomerUser = $CustomerUserData{UserLogin};
                    $FromExternalCustomer{Customer} = $CustomerUserData{UserLogin};
                }
                if ( $FromExternalCustomer{Customer} ) {
                    my %ExternalCustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $FromExternalCustomer{Customer},
                    );
                    $FromExternalCustomer{Email} = $ExternalCustomerUserData{UserEmail};
                }
            }

            # if more than one customer user exist, show list
            # and clean CustomerUserID and CustomerID
            else {

                # don't check email syntax on multi customer select
                $Self->{ConfigObject}->Set( Key => 'CheckEmailAddresses', Value => 0 );
                $CustomerID = '';

                # clear from if there is no customer found
                if ( !%CustomerUserList ) {
                    $GetParam{From} = '';
                }
                $Error{ExpandCustomerName} = 1;
            }
        }

        # get from and customer id if customer user is given
        elsif ( $ExpandCustomerName == 2 ) {
            %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUser,
            );
            my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                UserLogin => $CustomerUser,
            );
            for my $KeyCustomerUser ( sort keys %CustomerUserList ) {
                $GetParam{From} = $CustomerUserList{$KeyCustomerUser};
            }
            if ( $CustomerUserData{UserCustomerID} ) {
                $CustomerID = $CustomerUserData{UserCustomerID};
            }
            if ( $CustomerUserData{UserLogin} ) {
                $CustomerUser = $CustomerUserData{UserLogin};
            }
            if ( $FromExternalCustomer{Customer} ) {
                my %ExternalCustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $FromExternalCustomer{Customer},
                );
                $FromExternalCustomer{Email} = $ExternalCustomerUserData{UserEmail};
            }
            $Error{ExpandCustomerName} = 1;
        }

        # if a new destination queue is selected
        elsif ( $ExpandCustomerName == 3 ) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }

        # 'just' no submit
        elsif ( $ExpandCustomerName == 4 ) {
            $Error{NoSubmit} = 1;
        }

        # show customer info
        my %CustomerData;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
            if ( $CustomerUser || $SelectedCustomerUser ) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser || $SelectedCustomerUser,
                );
            }
            elsif ($CustomerID) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }

        # check email address
        for my $Email ( Mail::Address->parse( $GetParam{From} ) ) {
            if ( !$Self->{CheckItemObject}->CheckEmail( Address => $Email->address() ) ) {
                $Error{ErrorType}   = $Self->{CheckItemObject}->CheckErrorType() . 'ServerErrorMsg';
                $Error{FromInvalid} = ' ServerError';
            }
        }

        if ( !$IsUpload && !$ExpandCustomerName ) {
            if ( !$GetParam{From} )
            {
                $Error{'FromInvalid'} = ' ServerError';
            }
            if ( !$GetParam{Subject} ) {
                $Error{'SubjectInvalid'} = ' ServerError';
            }
            if ( !$NewQueueID ) {
                $Error{'DestinationInvalid'} = ' ServerError';
            }
            if (
                $Self->{ConfigObject}->Get('Ticket::Service')
                && $GetParam{SLAID}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }

            # check mandatory service
            if (
                $Self->{ConfigObject}->Get('Ticket::Service')
                && $Self->{Config}->{ServiceMandatory}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }

            # check mandatory sla
            if (
                $Self->{ConfigObject}->Get('Ticket::Service')
                && $Self->{Config}->{SLAMandatory}
                && !$GetParam{SLAID}
                )
            {
                $Error{'SLAInvalid'} = ' ServerError';
            }

            if ( ( !$GetParam{TypeID} ) && ( $Self->{ConfigObject}->Get('Ticket::Type') ) ) {
                $Error{'TypeIDInvalid'} = ' ServerError';
            }
            if ( !$GetParam{Body} ) {
                $Error{'RichTextInvalid'} = ' ServerError';
            }
            if (
                $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
                && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                && $GetParam{TimeUnits} eq ''
                )
            {
                $Error{'TimeUnitsInvalid'} = ' ServerError';
            }
        }

        if (%Error) {

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
                CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                QueueID        => $NewQueueID   || 1,
                Services       => $Services,
            );

            # header
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

            # html output
            $Output .= $Self->_MaskPhoneNew(
                QueueID => $Self->{QueueID},
                Users   => $Self->_GetUsers(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{OwnerAll},
                ),
                UserSelected     => $GetParam{NewUserID},
                ResponsibleUsers => $Self->_GetResponsibles(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID  => $NewQueueID,
                    AllUsers => $GetParam{ResponsibleAll}
                ),
                ResponsibleUserSelected => $GetParam{NewResponsibleID},
                NextStates              => $Self->_GetNextStates(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                NextState  => $NextState,
                Priorities => $Self->_GetPriorities(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Types => $Self->_GetTypes(
                    %GetParam,
                    %ACLCompatGetParam,
                    CustomerUserID => $CustomerUser || $SelectedCustomerUser || '',
                    QueueID => $NewQueueID || 1,
                ),
                Services          => $Services,
                SLAs              => $SLAs,
                StandardTemplates => $Self->_GetStandardTemplates(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID => $NewQueueID || '',
                ),
                CustomerID => $Self->{LayoutObject}->Ascii2Html( Text => $CustomerID ),
                CustomerUser => $CustomerUser,
                CustomerData => \%CustomerData,
                To           => $Self->_GetTos(
                    %GetParam,
                    %ACLCompatGetParam,
                    QueueID => $NewQueueID
                ),
                ToSelected  => $Dest,
                Errors      => \%Error,
                Attachments => \@Attachments,
                %GetParam,
                DynamicFieldHTML     => \%DynamicFieldHTML,
                MultipleCustomer     => \@MultipleCustomer,
                FromExternalCustomer => \%FromExternalCustomer,
            );

            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            Title        => $GetParam{Subject},
            QueueID      => $NewQueueID,
            Subject      => $GetParam{Subject},
            Lock         => 'unlock',
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            StateID      => $GetParam{NextStateID},
            PriorityID   => $GetParam{PriorityID},
            OwnerID      => 1,
            CustomerNo   => $CustomerID,
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
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # get pre loaded attachment
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'FileUpload',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # remove unused inline images
            my @NewAttachmentData;
            for my $Attachment (@AttachmentData) {
                my $ContentID = $Attachment->{ContentID};
                if ($ContentID) {
                    my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                        Text => $ContentID,
                    );

                    # workaround for link encode of rich text editor, see bug#5053
                    my $ContentIDLinkEncode = $Self->{LayoutObject}->LinkEncode($ContentID);
                    $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                    # ignore attachment if not linked in body
                    next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # remember inline images and normal attachments
                push @NewAttachmentData, \%{$Attachment};
            }
            @AttachmentData = @NewAttachmentData;

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ( $GetParam{NewUserID} ) {
            $NoAgentNotify = 1;
        }
        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            NoAgentNotify    => $NoAgentNotify,
            TicketID         => $TicketID,
            ArticleType      => $Self->{Config}->{ArticleType},
            SenderType       => $Self->{Config}->{SenderType},
            From             => $GetParam{From},
            To               => $To,
            Subject          => $GetParam{Subject},
            Body             => $GetParam{Body},
            MimeType         => $MimeType,
            Charset          => $Self->{LayoutObject}->{UserCharset},
            UserID           => $Self->{UserID},
            HistoryType      => $Self->{Config}->{HistoryType},
            HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => ( $Self->{ConfigObject}->Get('AutoResponseForWebTickets') )
            ? 'auto reply'
            : '',
            OrigHeader => {
                From    => $GetParam{From},
                To      => $GetParam{To},
                Subject => $GetParam{Subject},
                Body    => $Self->{LayoutObject}->RichText2Ascii( String => $GetParam{Body} ),

            },
            Queue => $Self->{QueueObject}->QueueLookup( QueueID => $NewQueueID ),
        );
        if ( !$ArticleID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # set article dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';

            # set the value
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ArticleID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # set owner (if new user id is given)
        if ( $GetParam{NewUserID} ) {
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $TicketID,
                NewUserID => $GetParam{NewUserID},
                UserID    => $Self->{UserID},
            );

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'lock',
                UserID   => $Self->{UserID},
            );
        }

        # else set owner to current agent but do not lock it
        else {
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID           => $TicketID,
                NewUserID          => $Self->{UserID},
                SendNoNotification => 1,
                UserID             => $Self->{UserID},
            );
        }

        # set responsible (if new user id is given)
        if ( $GetParam{NewResponsibleID} ) {
            $Self->{TicketObject}->TicketResponsibleSet(
                TicketID  => $TicketID,
                NewUserID => $GetParam{NewResponsibleID},
                UserID    => $Self->{UserID},
            );
        }

        # time accounting
        if ( $GetParam{TimeUnits} ) {
            $Self->{TicketObject}->TicketAccountTime(
                TicketID  => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit  => $GetParam{TimeUnits},
                UserID    => $Self->{UserID},
            );
        }

        # write attachments
        for my $Attachment (@AttachmentData) {
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{UserID},
            );
        }

        # remove pre submited attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # link tickets
        if (
            $GetParam{LinkTicketID}
            && $Self->{Config}->{SplitLinkType}
            && $Self->{Config}->{SplitLinkType}->{LinkType}
            && $Self->{Config}->{SplitLinkType}->{Direction}
            )
        {
            my $Access = $Self->{TicketObject}->TicketPermission(
                Type     => 'ro',
                TicketID => $GetParam{LinkTicketID},
                UserID   => $Self->{UserID}
            );

            if ( !$Access ) {
                return $Self->{LayoutObject}->NoPermission(
                    Message    => "You need ro permission!",
                    WithHeader => 'yes',
                );
            }

            my $SourceKey = $GetParam{LinkTicketID};
            my $TargetKey = $TicketID;

            if ( $Self->{Config}->{SplitLinkType}->{Direction} eq 'Source' ) {
                $SourceKey = $TicketID;
                $TargetKey = $GetParam{LinkTicketID};
            }

            # link the tickets
            $Self->{LinkObject}->LinkAdd(
                SourceObject => 'Ticket',
                SourceKey    => $SourceKey,
                TargetObject => 'Ticket',
                TargetKey    => $TargetKey,
                Type         => $Self->{Config}->{SplitLinkType}->{LinkType} || 'Normal',
                State        => 'Valid',
                UserID       => $Self->{UserID},
            );
        }

        # closed tickets get unlocked
        if ( $StateData{TypeName} =~ /^close/i ) {

            # set lock
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $TicketID,
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $Self->{TicketObject}->TicketPendingTimeSet(
                UserID   => $Self->{UserID},
                TicketID => $TicketID,
                %GetParam,
            );
        }

        # get redirect screen
        my $NextScreen = $Self->{UserCreateNextMask} || 'AgentTicketPhone';

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen;Subaction=Created;TicketID=$TicketID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $Dest           = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser   = $Self->{ParamObject}->GetParam( Param => 'SelectedCustomerUser' );
        my $ElementChanged = $Self->{ParamObject}->GetParam( Param => 'ElementChanged' ) || '';
        my $QueueID        = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
        }

        # get list type
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Tos = $Self->_GetTos(
            %GetParam,
            %ACLCompatGetParam,
            QueueID => $QueueID,
        );

        my $NewTos;

        if ($Tos) {
            for my $KeyTo ( sort keys %{$Tos} ) {
                $NewTos->{"$KeyTo||$Tos->{$KeyTo}"} = $Tos->{$KeyTo};
            }
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

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';

            my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DYNAMICFIELD if !$IsACLReducible;

            my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                %GetParam,
                %ACLCompatGetParam,
                CustomerUserID => $CustomerUser || '',
                Action         => $Self->{Action},
                QueueID        => $QueueID      || 0,
                ReturnType     => 'Ticket',
                ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data           => \%AclData,
                UserID         => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $Self->{TicketObject}->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            my $DataValues = $Self->{BackendObject}->BuildSelectionDataGet(
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
            my $RemoveSuccess = $Self->{UploadCacheObject}->FormIDRemove(
                FormID => $Self->{FormID},
            );
            if ( !$RemoveSuccess ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Form attachments coud not be deleted!",
                );
            }

            # get the template text and set new attachments if a template is selected
            if ( IsPositiveInteger( $GetParam{StandardTemplateID} ) ) {
                my $TemplateGenerator = Kernel::System::TemplateGenerator->new( %{$Self} );

                # set template text, replace smart tags (limited as ticket is not created)
                $TemplateText = $TemplateGenerator->Template(
                    TemplateID => $GetParam{StandardTemplateID},
                    UserID     => $Self->{UserID},
                );

                # create StdAttachmentObject
                my $StdAttachmentObject = Kernel::System::StdAttachment->new( %{$Self} );

                # add std. attachments to ticket
                my %AllStdAttachments
                    = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
                    StandardTemplateID => $GetParam{StandardTemplateID},
                    );
                for ( sort keys %AllStdAttachments ) {
                    my %AttachmentsData = $StdAttachmentObject->StdAttachmentGet( ID => $_ );
                    $Self->{UploadCacheObject}->FormIDAddFile(
                        FormID => $Self->{FormID},
                        %AttachmentsData,
                    );
                }

                # send a list of attachments in the upload cache back to the clientside JavaScript
                # which renders then the list of currently uploaded attachments
                @TicketAttachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
                    FormID => $Self->{FormID},
                );
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

        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name         => 'Dest',
                    Data         => $NewTos,
                    SelectedID   => $Dest,
                    Translation  => 0,
                    PossibleNone => 0,
                    TreeView     => $TreeView,
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
                    Translation  => 0,
                    Max          => 100,
                },
                @DynamicFieldAJAX,
                @TemplateAJAX,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your administrator',
        );
    }
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->TicketStateList(
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
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for my $KeyGroupMember ( sort keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $KeyGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$KeyGroupMember};
            }
        }
    }

    # show all system users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are owner or rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'owner',
            Result  => 'HASH',
        );
        for my $KeyMember ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$KeyMember} ) {
                $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
            }
        }
    }

    # workflow
    my $ACL = $Self->{TicketObject}->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'Owner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $Self->{TicketObject}->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetResponsibles {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for my $KeyGroupMember ( sort keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $KeyGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$KeyGroupMember};
            }
        }
    }

    # show all system users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are responsible or rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'responsible',
            Result  => 'HASH',
        );
        for my $KeyMember ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$KeyMember} ) {
                $ShownUsers{$KeyMember} = $AllGroupsMembers{$KeyMember};
            }
        }
    }

    # workflow
    my $ACL = $Self->{TicketObject}->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'Responsible',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $Self->{TicketObject}->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->TicketPriorityList(
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
        %Type = $Self->{TicketObject}->TicketTypeList(
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
        = $Self->{ConfigObject}->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $Self->{TicketObject}->TicketServiceList(
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
            %SLA = $Self->{TicketObject}->TicketSLAList(
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

    # check own selection
    my %NewTos;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewTos = %{ $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Tos;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Tos = $Self->{TicketObject}->MoveList(
                %Param,
                Type    => 'create',
                Action  => $Self->{Action},
                QueueID => $Self->{QueueID},
                UserID  => $Self->{UserID},
            );
        }
        else {
            %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }

        # get create permission queues
        my %UserGroups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type   => 'create',
            Result => 'HASH',
        );

        # build selection string
        for my $QueueID ( sort keys %Tos ) {
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next if !$UserGroups{ $QueueData{GroupID} };

            my $String = $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(
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

sub _GetStandardTemplates {
    my ( $Self, %Param ) = @_;

    # get create templates
    my %Templates;

    # check needed
    return \%Templates if !$Param{QueueID} && !$Param{TicketID};

    my $QueueID = $Param{QueueID} || '';
    if ( !$Param{QueueID} && $Param{TicketID} ) {

        # get QueueID from the ticket
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );
        $QueueID = $Ticket{QueueID} || '';
    }

    # fetch all std. templates
    my %StandardTemplates = $Self->{QueueObject}->QueueStandardTemplateMemberList(
        QueueID       => $QueueID,
        TemplateTypes => 1,
    );

    # return empty hash if there are no templates for this screen
    return \%Templates if !IsHashRefWithData( $StandardTemplates{Create} );

    # return just the templates for this screen
    return $StandardTemplates{Create};
}

sub _MaskPhoneNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build customer search autocomplete field
    $Self->{LayoutObject}->Block(
        Name => 'CustomerSearchAutoComplete',
    );

    # build string
    $Param{OptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{Users},
        SelectedID   => $Param{UserSelected},
        Translation  => 0,
        Name         => 'NewUserID',
        PossibleNone => 1,
    );

    # build next states string
    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{NextStates},
        Name          => 'NextStateID',
        Translation   => 1,
        SelectedValue => $Param{NextState} || $Self->{Config}->{StateDefault},
    );

    # build to string
    my %NewTo;
    if ( $Param{To} ) {
        for my $KeyTo ( sort keys %{ $Param{To} } ) {
            $NewTo{"$KeyTo||$Param{To}->{$KeyTo}"} = $Param{To}->{$KeyTo};
        }
    }
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
        $Param{ToStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Class          => 'Validate_Required',
            Data           => \%NewTo,
            Multiple       => 0,
            Size           => 0,
            Name           => 'Dest',
            TreeView       => $TreeView,
            SelectedID     => $Param{ToSelected},
            OnChangeSubmit => 0,
        );
    }
    else {
        $Param{ToStrg} = $Self->{LayoutObject}->BuildSelection(
            Class       => 'Validate_Required',
            Data        => \%NewTo,
            Name        => 'Dest',
            TreeView    => $TreeView,
            SelectedID  => $Param{ToSelected},
            Translation => 0,
        );
    }

    # customer info string
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose') ) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data => $Param{CustomerData},
            Max  => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $KeyError ( sort keys %{ $Param{Errors} } ) {
            $Param{$KeyError}
                = '* ' . $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
        }
    }

    # From external
    my $ShowErrors = 1;
    if (
        defined $Param{FromExternalCustomer} &&
        defined $Param{FromExternalCustomer}->{Email} &&
        defined $Param{FromExternalCustomer}->{Customer}
        )
    {
        $ShowErrors = 0;
        $Self->{LayoutObject}->Block(
            Name => 'FromExternalCustomer',
            Data => $Param{FromExternalCustomer},
        );
    }
    my $CustomerCounter = 0;
    if ( $Param{MultipleCustomer} ) {
        for my $Item ( @{ $Param{MultipleCustomer} } ) {
            if ( !$ShowErrors ) {

                # set empty values for errors
                $Item->{CustomerError}    = '';
                $Item->{CustomerDisabled} = '';
                $Item->{CustomerErrorMsg} = 'CustomerGenericServerErrorMsg';
            }
            $Self->{LayoutObject}->Block(
                Name => 'MultipleCustomer',
                Data => $Item,
            );
            $Self->{LayoutObject}->Block(
                Name => $Item->{CustomerErrorMsg},
                Data => $Item,
            );
            if ( $Item->{CustomerError} ) {
                $Self->{LayoutObject}->Block(
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
    $Self->{LayoutObject}->Block(
        Name => 'MultipleCustomerCounter',
        Data => {
            CustomerCounter => $CustomerCounter++,
        },
    );

    if ( $Param{FromInvalid} && $Param{Errors} && !$Param{Errors}->{FromErrorType} ) {
        $Self->{LayoutObject}->Block( Name => 'FromServerErrorMsg' );
    }
    if ( $Param{Errors}->{FromErrorType} || !$ShowErrors ) {
        $Param{FromInvalid} = '';
    }

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1
    );

    # create a string with the quoted dynamic field names separated by commas
    if ( IsArrayRefWithData($DynamicFieldNames) ) {
        for my $Field ( @{$DynamicFieldNames} ) {
            $Param{DynamicFieldNamesStrg} .= ",'" . $Field . "'";
        }
    }

    # build type string
    if ( $Self->{ConfigObject}->Get('Ticket::Type') ) {
        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Class => 'Validate_Required' . ( $Param{Errors}->{TypeIDInvalid} || ' ' ),
            Data  => $Param{Types},
            Name  => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }

    # build service string
    if ( $Self->{ConfigObject}->Get('Ticket::Service') ) {

        if ( $Self->{Config}->{ServiceMandatory} ) {
            $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => $Param{Services},
                Name         => 'ServiceID',
                Class        => 'Validate_Required ' . ( $Param{Errors}->{ServiceInvalid} || ' ' ),
                SelectedID   => $Param{ServiceID},
                PossibleNone => 1,
                TreeView     => $TreeView,
                Sort         => 'TreeView',
                Translation  => 0,
                Max          => 200,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketServiceMandatory',
                Data => {%Param},
            );
        }
        else {
            $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => $Param{Services},
                Name         => 'ServiceID',
                Class        => $Param{Errors}->{ServiceInvalid} || ' ',
                SelectedID   => $Param{ServiceID},
                PossibleNone => 1,
                TreeView     => $TreeView,
                Sort         => 'TreeView',
                Translation  => 0,
                Max          => 200,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketService',
                Data => {%Param},
            );
        }

        if ( $Self->{Config}->{SLAMandatory} ) {
            $Param{SLAStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => $Param{SLAs},
                Name         => 'SLAID',
                SelectedID   => $Param{SLAID},
                Class        => 'Validate_Required ' . ( $Param{Errors}->{SLAInvalid} || ' ' ),
                PossibleNone => 1,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                Max          => 200,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketSLAMandatory',
                Data => {%Param},
            );
        }
        else {
            $Param{SLAStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => $Param{SLAs},
                Name         => 'SLAID',
                SelectedID   => $Param{SLAID},
                PossibleNone => 1,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                Max          => 200,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketSLA',
                Data => {%Param},
            );
        }
    }

    # check if exists create templates regardless the queue
    my %StandardTemplates = $Self->{StandardTemplateObject}->StandardTemplateList(
        Valid => 1,
        Type  => 'Create',
    );

    # build text template string
    if ( IsHashRefWithData( \%StandardTemplates ) ) {
        $Param{StandardTemplateStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => $Param{StandardTemplates}  || {},
            Name       => 'StandardTemplateID',
            SelectedID => $Param{StandardTemplateID} || '',
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
        );
        $Self->{LayoutObject}->Block(
            Name => 'StandardTemplate',
            Data => {%Param},
        );
    }

    # build priority string
    if ( !$Param{PriorityID} ) {
        $Param{Priority} = $Self->{Config}->{Priority};
    }
    $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
        Data          => $Param{Priorities},
        Name          => 'PriorityID',
        SelectedID    => $Param{PriorityID},
        SelectedValue => $Param{Priority},
        Translation   => 1,
    );

    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format           => 'DateInputFormatLong',
        YearPeriodPast   => 0,
        YearPeriodFuture => 5,
        DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
        Class            => $Param{Errors}->{DateInvalid},
        Validate         => 1,
        ValidateDateInFuture => 1,
    );

    # show owner selection
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NewOwnerSelection') ) {
        $Self->{LayoutObject}->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
    }

    # show responsible selection
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        && $Self->{ConfigObject}->Get('Ticket::Frontend::NewResponsibleSelection')
        )
    {
        $Param{ResponsibleUsers}->{''} = '-';
        $Param{ResponsibleOptionStrg} = $Self->{LayoutObject}->BuildSelection(
            Data       => $Param{ResponsibleUsers},
            SelectedID => $Param{ResponsibleUserSelected},
            Name       => 'NewResponsibleID',
        );
        $Self->{LayoutObject}->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
    }

    # Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip fields that HTML could not be retrieved
        next DYNAMICFIELD if !IsHashRefWithData(
            $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
        );

        # get the html strings form $Param
        my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

        $Self->{LayoutObject}->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

        # example of dynamic fields order customization
        $Self->{LayoutObject}->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );
    }

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = 'Validate_Required';
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
            $Param{TimeUnitsRequired} = '';
        }
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }

    my $ShownOptionsBlock;

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {
                    %Param,
                },
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {
                %Param,
            },
        );
    }

    # show customer edit link
    my $OptionCustomer = $Self->{LayoutObject}->Permission(
        Action => 'AdminCustomerUser',
        Type   => 'rw',
    );
    if ($OptionCustomer) {

        # check if need to call Options block
        if ( !$ShownOptionsBlock ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
                Data => {
                    %Param,
                },
            );

            # set flag to "true" in order to prevent calling the Options block again
            $ShownOptionsBlock = 1;
        }

        $Self->{LayoutObject}->Block(
            Name => 'OptionCustomer',
            Data => {
                %Param,
            },
        );
    }

    # show attachments
    for my $Attachment ( @{ $Param{Attachments} } ) {
        next if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketPhone', Data => \%Param );
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updatable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields
            = qw( TypeID Dest ServiceID SLAID NewUserID NewResponsibleID NextStateID PriorityID
            StandardTemplateID
        );
    }

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );
        next DYNAMICFIELD if !$IsACLReducible;

        push @UpdatableFields, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@UpdatableFields;
}

1;
