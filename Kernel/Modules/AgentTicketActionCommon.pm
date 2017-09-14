# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketActionCommon;

use strict;
use warnings;

use Kernel::System::EmailParser;
use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # Try to load draft if requested.
    if (
        $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}")->{FormDraft}
        && $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'LoadFormDraft' )
        && $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormDraftID' )
        )
    {
        $Self->{LoadedFormDraftID} = $Kernel::OM->Get('Kernel::System::Web::Request')->LoadFormDraft(
            FormDraftID => $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormDraftID' ),
            UserID      => $Self->{UserID},
        );
    }

    # get article for whom this should be a reply, if available
    my $ReplyToArticle = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'ReplyToArticle' ) || '';
    my $TicketID       = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'TicketID' )       || '';

    # check if ReplyToArticle really belongs to the ticket
    my %ReplyToArticleContent;
    my @ReplyToAdresses;
    if ($ReplyToArticle) {

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForArticle(
            TicketID  => $TicketID,
            ArticleID => $ReplyToArticle,
        );
        %ReplyToArticleContent = $ArticleBackendObject->ArticleGet(
            TicketID      => $TicketID,
            ArticleID     => $ReplyToArticle,
            DynamicFields => 0,
        );

        $Self->{ReplyToArticle}        = $ReplyToArticle;
        $Self->{ReplyToArticleContent} = \%ReplyToArticleContent;

        # get sender of original note (to inform sender about answer)
        if ( $ReplyToArticleContent{CreateBy} ) {
            my @ReplyToSenderID = ( $ReplyToArticleContent{CreateBy} );
            $Self->{ReplyToSenderUserID} = \@ReplyToSenderID;
        }

        # if article belongs to other ticket, don't use it as reply
        if ( $ReplyToArticleContent{TicketID} ne $Self->{TicketID} ) {
            $Self->{ReplyToArticle} = "";
        }

        # if article is not of type note-internal, don't use it as reply
        if (
            $ArticleBackendObject->ChannelNameGet() ne 'Internal'
            || (
                $ArticleBackendObject->ChannelNameGet() eq 'Internal'
                && $ReplyToArticleContent{SenderType} ne 'agent'
            )
            )
        {
            $Self->{ReplyToArticle} = "";
        }
    }

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

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('No TicketID is given!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # get config of frontend module
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => $Config->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message => $LayoutObject->{LanguageObject}->Translate( 'You need %s permissions!', $Config->{Permission} ),
            WithHeader => 'yes',
        );
    }

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

    # Check for failed draft loading request.
    if (
        $ParamObject->GetParam( Param => 'LoadFormDraft' )
        && !$Self->{LoadedFormDraftID}
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Loading draft failed!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    my $LoadedFormDraft;
    if ( $Self->{LoadedFormDraftID} ) {
        $LoadedFormDraft = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftGet(
            FormDraftID => $Self->{LoadedFormDraftID},
            GetContent  => 0,
            UserID      => $Self->{UserID},
        );

        my @Articles = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
            TicketID => $Self->{TicketID},
            OnlyLast => 1,
        );

        if (@Articles) {
            my $LastArticle = $Articles[0];

            my $LastArticleSystemTime;
            if ( $LastArticle->{CreateTime} ) {
                my $LastArticleSystemTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $LastArticle->{CreateTime},
                    },
                );
                $LastArticleSystemTime = $LastArticleSystemTimeObject->ToEpoch();
            }

            my $FormDraftSystemTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $LoadedFormDraft->{ChangeTime},
                },
            );
            my $FormDraftSystemTime = $FormDraftSystemTimeObject->ToEpoch();

            if ( !$LastArticleSystemTime || $FormDraftSystemTime <= $LastArticleSystemTime ) {
                $Param{FormDraftOutdated} = 1;
            }
        }
    }

    if ( IsHashRefWithData($LoadedFormDraft) ) {

        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $LoadedFormDraft->{ChangeTime},
            },
        );
        my %RelativeTime = $LayoutObject->FormatRelativeTime( DateTimeObject => $DateTimeObject );
        $LoadedFormDraft->{ChangeTimeRelative}
            = $LayoutObject->{LanguageObject}->Translate( $RelativeTime{Message}, $RelativeTime{Value} );

        $LoadedFormDraft->{ChangeByName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
            UserID => $LoadedFormDraft->{ChangeBy},
        );
    }

    $LayoutObject->Block(
        Name => 'Properties',
        Data => {
            FormDraft      => $Config->{FormDraft},
            FormDraftID    => $Self->{LoadedFormDraftID},
            FormDraftTitle => $LoadedFormDraft ? $LoadedFormDraft->{Title} : '',
            FormDraftMeta  => $LoadedFormDraft,
            FormID         => $Self->{FormID},
            ReplyToArticle => $Self->{ReplyToArticle},
            %Ticket,
            %Param,
        },
    );

    # show right header
    $LayoutObject->Block(
        Name => 'Header' . $Self->{Action},
        Data => {
            %Ticket,
        },
    );

    # get lock state
    if ( $Config->{RequiredLock} ) {
        if ( !$TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            $TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            my $Success = $TicketObject->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # show lock state
            if ($Success) {
                $LayoutObject->Block(
                    Name => 'PropertiesLock',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
        else {
            my $AccessOk = $TicketObject->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $LayoutObject->Header(
                    Type      => 'Small',
                    Value     => $Ticket{Number},
                    BodyClass => 'Popup',
                );
                $Output .= $LayoutObject->Warning(
                    Message => Translatable('Sorry, you need to be the ticket owner to perform this action.'),
                    Comment => Translatable('Please change the owner first.'),
                );
                $Output .= $LayoutObject->Footer(
                    Type => 'Small',
                );
                return $Output;
            }

            # show back link
            $LayoutObject->Block(
                Name => 'TicketBack',
                Data => {
                    %Param,
                    TicketID => $Self->{TicketID},
                },
            );
        }
    }
    else {
        $LayoutObject->Block(
            Name => 'TicketBack',
            Data => {
                %Param,
                %Ticket,
            },
        );
    }

    # get params
    my %GetParam;
    for my $Key (
        qw(
        NewStateID NewPriorityID TimeUnits IsVisibleForCustomer Title Body Subject NewQueueID
        Year Month Day Hour Minute NewOwnerID NewResponsibleID TypeID ServiceID SLAID
        Expand ReplyToArticle StandardTemplateID CreateArticle FormDraftID Title
        )
        )
    {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam = (
        StateID       => $GetParam{StateID},
        PriorityID    => $GetParam{NewPriorityID},
        QueueID       => $GetParam{NewQueueID},
        OwnerID       => $GetParam{NewOwnerID},
        ResponsibleID => $GetParam{NewResponsibleID},
    );

    # get dynamic field values form http request
    my %DynamicFieldValues;

    # define the dynamic fields to show based on the object type
    my $ObjectType = ['Ticket'];

    # only screens that add notes can modify Article dynamic fields
    if ( $Config->{Note} ) {
        $ObjectType = [ 'Ticket', 'Article' ];
    }

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Config->{DynamicField} || {},
    );

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
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
    for my $DynamicFieldItem ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicFieldItem;
        next DYNAMICFIELD if !defined $DynamicFieldValues{$DynamicFieldItem};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicFieldItem } = $DynamicFieldValues{$DynamicFieldItem};
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

    # rewrap body if no rich text is used
    if ( $GetParam{Body} && !$LayoutObject->{BrowserRichText} ) {
        $GetParam{Body} = $LayoutObject->WrapPlainText(
            MaxCharacters => $ConfigObject->Get('Ticket::Frontend::TextAreaNote'),
            PlainText     => $GetParam{Body},
        );
    }

    # get upload cache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    if (
        $Self->{Subaction} eq 'Store'
        || $Self->{LoadedFormDraftID}
        )
    {

        # challenge token check for write action
        if ( $Self->{Subaction} eq 'Store' ) {
            $LayoutObject->ChallengeTokenCheck();
        }

        $GetParam{IsVisibleForCustomer} //= 0;

        # store action
        my %Error;

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # Get and validate draft action.
        my $FormDraftAction = $ParamObject->GetParam( Param => 'FormDraftAction' );
        if ( $FormDraftAction && !$Config->{FormDraft} ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('FormDraft functionality disabled!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        my %FormDraftResponse;

        # Check draft name.
        if (
            $FormDraftAction
            && ( $FormDraftAction eq 'Add' || $FormDraftAction eq 'Update' )
            )
        {
            my $Title = $ParamObject->GetParam( Param => 'FormDraftTitle' );

            # A draft name is required.
            if ( !$Title ) {

                %FormDraftResponse = (
                    Success      => 0,
                    ErrorMessage => $Kernel::OM->Get('Kernel::Language')->Translate("Draft name is required!"),
                );
            }

            # Chosen draft name must be unique.
            else {
                my $FormDraftList = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftListGet(
                    ObjectType => 'Ticket',
                    ObjectID   => $Self->{TicketID},
                    Action     => $Self->{Action},
                    UserID     => $Self->{UserID},
                );
                DRAFT:
                for my $FormDraft ( @{$FormDraftList} ) {

                    # No existing draft with same name.
                    next DRAFT if $Title ne $FormDraft->{Title};

                    # Same name for update on existing draft.
                    if (
                        $GetParam{FormDraftID}
                        && $FormDraftAction eq 'Update'
                        && $GetParam{FormDraftID} eq $FormDraft->{FormDraftID}
                        )
                    {
                        next DRAFT;
                    }

                    # Another draft with the chosen name already exists.
                    %FormDraftResponse = (
                        Success      => 0,
                        ErrorMessage => $Kernel::OM->Get('Kernel::Language')
                            ->Translate( "FormDraft name %s is already in use!", $Title ),
                    );
                    last DRAFT;
                }
            }
        }

        # Perform draft action instead of saving form data in ticket/article.
        if ( $FormDraftAction && !%FormDraftResponse ) {

            # Reset FormDraftID to prevent updating existing draft.
            if ( $FormDraftAction eq 'Add' && $GetParam{FormDraftID} ) {
                $ParamObject->{Query}->param(
                    -name  => 'FormDraftID',
                    -value => '',
                );
            }

            my $FormDraftActionOk;
            if (
                $FormDraftAction eq 'Add'
                ||
                ( $FormDraftAction eq 'Update' && $GetParam{FormDraftID} )
                )
            {
                $FormDraftActionOk = $ParamObject->SaveFormDraft(
                    UserID         => $Self->{UserID},
                    ObjectType     => 'Ticket',
                    ObjectID       => $Self->{TicketID},
                    OverrideParams => {
                        ReplyToArticle => undef,
                    },
                );
            }

            if ($FormDraftActionOk) {
                $FormDraftResponse{Success} = 1;
            }
            else {
                %FormDraftResponse = (
                    Success      => 0,
                    ErrorMessage => 'Could not perform requested draft action!',
                );
            }
        }

        if (%FormDraftResponse) {

            # build JSON output
            my $JSON = $LayoutObject->JSONEncode(
                Data => \%FormDraftResponse,
            );

            # send JSON response
            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        # get state object
        my $StateObject = $Kernel::OM->Get('Kernel::System::State');

        # check pending time
        if ( $GetParam{NewStateID} ) {
            my %StateData = $StateObject->StateGet(
                ID => $GetParam{NewStateID},
            );

            # check state type
            if ( $StateData{TypeName} =~ /^pending/i ) {

                # check needed stuff
                for my $Needed (qw(Year Month Day Hour Minute)) {
                    if ( !defined $GetParam{$Needed} ) {
                        $Error{'DateInvalid'} = 'ServerError';
                    }
                }

                # create datetime object
                my $PendingDateTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        %GetParam,
                        Second => 0,
                    },
                );

                # get current system epoch
                my $CurSystemDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');

                # check date
                if (
                    !$PendingDateTimeObject
                    || $PendingDateTimeObject < $CurSystemDateTimeObject
                    )
                {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }
        }

        if ( $Config->{Note} && $Config->{NoteMandatory} ) {

            # check subject
            if ( !$GetParam{Subject} ) {
                $Error{'SubjectInvalid'} = 'ServerError';
            }

            # check body
            if ( !$GetParam{Body} ) {
                $Error{'BodyInvalid'} = 'ServerError';
            }
        }

        # check owner
        if ( $Config->{Owner} && $Config->{OwnerMandatory} ) {
            if ( !$GetParam{NewOwnerID} ) {
                $Error{'NewOwnerInvalid'} = 'ServerError';
            }
        }

        # check responsible
        if ( $Config->{Responsible} && $Config->{ResponsibleMandatory} ) {
            if ( !$GetParam{NewResponsibleID} ) {
                $Error{'NewResponsibleInvalid'} = 'ServerError';
            }
        }

        # check title
        if ( $Config->{Title} && !$GetParam{Title} ) {
            $Error{'TitleInvalid'} = 'ServerError';
        }

        # check type
        if (
            ( $ConfigObject->Get('Ticket::Type') )
            &&
            ( $Config->{TicketType} ) &&
            ( !$GetParam{TypeID} )
            )
        {
            $Error{'TypeIDInvalid'} = ' ServerError';
        }

        # check service
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{Service}
            && $GetParam{SLAID}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'ServiceInvalid'} = ' ServerError';
        }

        # check mandatory service
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{Service}
            && $Config->{ServiceMandatory}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'ServiceInvalid'} = ' ServerError';
        }

        # check mandatory sla
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{Service}
            && $Config->{SLAMandatory}
            && !$GetParam{SLAID}
            )
        {
            $Error{'SLAInvalid'} = ' ServerError';
        }

        # check mandatory queue
        if ( $Config->{Queue} && $Config->{QueueMandatory} ) {
            if ( !$GetParam{NewQueueID} ) {
                $Error{'NewQueueInvalid'} = 'ServerError';
            }
        }

        # check mandatory state
        if ( $Config->{State} && $Config->{StateMandatory} ) {
            if ( !$GetParam{NewStateID} ) {
                $Error{'NewStateInvalid'} = 'ServerError';
            }
        }

        # check time units, but only if the current screen has a note
        #   (accounted time can only be stored if and article is generated)
        if (
            $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            && $Config->{Note}
            && $GetParam{TimeUnits} eq ''
            )
        {
            $Error{'TimeUnitsInvalid'} = ' ServerError';
        }

        # check expand
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{Expand} = 1;
        }

        # create html strings for all dynamic fields
        my @TicketTypeDynamicFields;
        my @ArticleTypeDynamicFields;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
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
                        Action        => $Self->{Action},
                        TicketID      => $Self->{TicketID},
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

            my $ValidationResult;

            # Do not validate only if object type is Article and CreateArticle value is not defined.
            if ( !( $DynamicFieldConfig->{ObjectType} eq 'Article' && !$GetParam{CreateArticle} ) ) {

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
                            $LayoutObject->{LanguageObject}->Translate(
                            'Could not perform validation on field %s!', $DynamicFieldConfig->{Label}
                            ),
                        Comment => Translatable('Please contact the administrator.'),
                    );
                }

                # Propagate validation error to the Error variable to be detected by the frontend.
                if ( $ValidationResult->{ServerError} )
                {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            if ( $DynamicFieldConfig->{ObjectType} eq 'Ticket' ) {

                # Get field html.
                my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ServerError          => $ValidationResult->{ServerError} || '',
                    ErrorMessage         => $ValidationResult->{ErrorMessage} || '',
                    Mandatory            => $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                    LayoutObject         => $LayoutObject,
                    ParamObject          => $ParamObject,
                    AJAXUpdate           => 1,
                    UpdatableFields      => $Self->_GetFieldsToUpdate(),
                );

                push @TicketTypeDynamicFields, {
                    Name  => $DynamicFieldConfig->{Name},
                    Label => $DynamicFieldHTML->{Label},
                    Field => $DynamicFieldHTML->{Field},
                };
            }
            elsif ( $DynamicFieldConfig->{ObjectType} eq 'Article' ) {
                my $Class            = '';
                my $MandatoryTooltip = 0;

                if ( $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2 ) {
                    if (
                        $Config->{NoteMandatory} ||
                        $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                        )
                    {
                        $Class = 'Validate_Required';
                    }
                    else {
                        $Class            = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
                        $MandatoryTooltip = 1;
                    }
                }

                # Get field html.
                my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ServerError          => $ValidationResult->{ServerError} || '',
                    ErrorMessage         => $ValidationResult->{ErrorMessage} || '',
                    Mandatory            => ( $Class eq 'Validate_Required' ) ? 1 : 0,
                    Class                => $Class,
                    LayoutObject         => $LayoutObject,
                    ParamObject          => $ParamObject,
                    AJAXUpdate           => 1,
                    UpdatableFields      => $Self->_GetFieldsToUpdate(),
                );

                push @ArticleTypeDynamicFields, {
                    Name             => $DynamicFieldConfig->{Name},
                    Label            => $DynamicFieldHTML->{Label},
                    Field            => $DynamicFieldHTML->{Field},
                    MandatoryTooltip => $MandatoryTooltip,
                };
            }
        }

        # Make sure we don't save form if a draft was loaded.
        if ( $Self->{LoadedFormDraftID} ) {
            %Error = ( LoadedFormDraft => 1 );
        }

        # check errors
        if (%Error) {

            my $Output = $LayoutObject->Header(
                Type      => 'Small',
                Value     => $Ticket{TicketNumber},
                BodyClass => 'Popup',
            );
            $Output .= $Self->_Mask(
                Attachments       => \@Attachments,
                TimeUnitsRequired => (
                    $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_Required'
                    : ''
                ),
                %Ticket,
                TicketTypeDynamicFields  => \@TicketTypeDynamicFields,
                ArticleTypeDynamicFields => \@ArticleTypeDynamicFields,

                %GetParam,
                %Error,
            );
            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );
            return $Output;
        }

        # set new title
        if ( $Config->{Title} ) {
            if ( defined $GetParam{Title} ) {
                $TicketObject->TicketTitleUpdate(
                    Title    => $GetParam{Title},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new type
        if ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} ) {
            if ( $GetParam{TypeID} ) {
                $TicketObject->TicketTypeSet(
                    TypeID   => $GetParam{TypeID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new service
        if ( $ConfigObject->Get('Ticket::Service') && $Config->{Service} ) {
            if ( defined $GetParam{ServiceID} ) {
                $TicketObject->TicketServiceSet(
                    %GetParam,
                    %ACLCompatGetParam,
                    ServiceID      => $GetParam{ServiceID},
                    TicketID       => $Self->{TicketID},
                    CustomerUserID => $Ticket{CustomerUserID},
                    UserID         => $Self->{UserID},
                );
            }
            if ( defined $GetParam{SLAID} ) {
                $TicketObject->TicketSLASet(
                    SLAID    => $GetParam{SLAID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        my $UnlockOnAway = 1;

        # move ticket to a new queue, but only if the queue was changed
        if (
            $Config->{Queue}
            && $GetParam{NewQueueID}
            && $GetParam{NewQueueID} ne $Ticket{QueueID}
            )
        {

            # move ticket (send notification if no new owner is selected)
            my $BodyAsText = '';
            if ( $LayoutObject->{BrowserRichText} ) {
                $BodyAsText = $LayoutObject->RichText2Ascii(
                    String => $GetParam{Body} || 0,
                );
            }
            else {
                $BodyAsText = $GetParam{Body} || 0;
            }
            my $Move = $TicketObject->TicketQueueSet(
                QueueID            => $GetParam{NewQueueID},
                UserID             => $Self->{UserID},
                TicketID           => $Self->{TicketID},
                SendNoNotification => $GetParam{NewUserID},
                Comment            => $BodyAsText,
            );
            if ( !$Move ) {
                return $LayoutObject->ErrorScreen();
            }
        }

        # set new owner
        my @NotifyDone;
        if ( $Config->{Owner} ) {
            my $BodyText = $LayoutObject->RichText2Ascii(
                String => $GetParam{Body} || '',
            );
            if ( $GetParam{NewOwnerID} ) {
                $TicketObject->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
                my $Success = $TicketObject->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewOwnerID},
                    Comment   => $BodyText,
                );
                $UnlockOnAway = 0;

                # remember to not notify owner twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewOwnerID};
                }
            }
        }

        # set new responsible
        if ( $ConfigObject->Get('Ticket::Responsible') && $Config->{Responsible} ) {
            if ( $GetParam{NewResponsibleID} ) {
                my $BodyText = $LayoutObject->RichText2Ascii(
                    String => $GetParam{Body} || '',
                );
                my $Success = $TicketObject->TicketResponsibleSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewResponsibleID},
                    Comment   => $BodyText,
                );

                # remember to not notify responsible twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewResponsibleID};
                }
            }
        }

        # add note
        my $ArticleID = '';
        my $ReturnURL;

        # set priority
        if ( $Config->{Priority} && $GetParam{NewPriorityID} ) {
            $TicketObject->TicketPrioritySet(
                TicketID   => $Self->{TicketID},
                PriorityID => $GetParam{NewPriorityID},
                UserID     => $Self->{UserID},
            );
        }

        # set state
        if ( $Config->{State} && $GetParam{NewStateID} ) {
            $TicketObject->TicketStateSet(
                TicketID     => $Self->{TicketID},
                StateID      => $GetParam{NewStateID},
                UserID       => $Self->{UserID},
                DynamicField => $GetParam{DynamicField},
            );

            # unlock the ticket after close
            my %StateData = $StateObject->StateGet(
                ID => $GetParam{NewStateID},
            );

            # set unlock on close state
            if ( $StateData{TypeName} =~ /^close/i ) {
                $TicketObject->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # set pending time on pending state
            elsif ( $StateData{TypeName} =~ /^pending/i ) {

                # set pending time
                $TicketObject->TicketPendingTimeSet(
                    UserID   => $Self->{UserID},
                    TicketID => $Self->{TicketID},
                    %GetParam,
                );
            }

            # redirect parent window to last screen overview on closed tickets
            if (
                $StateData{TypeName} =~ /^close/i
                && !$ConfigObject->Get('Ticket::Frontend::RedirectAfterCloseDisabled')
                )
            {
                $ReturnURL = $Self->{LastScreenOverview} || 'Action=AgentDashboard';
            }
        }

        if (
            $GetParam{CreateArticle}
            && $Config->{Note}
            && ( $GetParam{Subject} || $GetParam{Body} )
            )
        {

            if ( !$GetParam{Subject} ) {
                if ( $Config->{Subject} ) {
                    my $Subject = $LayoutObject->Output(
                        Template => $Config->{Subject},
                    );
                    $GetParam{Subject} = $Subject;
                }
                $GetParam{Subject} = $GetParam{Subject}
                    || $LayoutObject->{LanguageObject}->Translate('No subject');
            }

            # get pre loaded attachment
            my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
                FormID => $Self->{FormID},
            );

            # get submit attachment
            my %UploadStuff = $ParamObject->GetUploadAll(
                Param => 'FileUpload',
            );
            if (%UploadStuff) {
                push @Attachments, \%UploadStuff;
            }

            my $MimeType = 'text/plain';
            if ( $LayoutObject->{BrowserRichText} ) {
                $MimeType = 'text/html';

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

            my $From = "\"$Self->{UserFullname}\" <$Self->{UserEmail}>";
            my @NotifyUserIDs;

            # get list of users that will be informed without selection in informed/involved list
            my @UserListWithoutSelection
                = split( ',', $ParamObject->GetParam( Param => 'UserListWithoutSelection' ) || "" );

            # get inform user list
            my @InformUserID = $ParamObject->GetArray( Param => 'InformUserID' );

            # get involved user list
            my @InvolvedUserID = $ParamObject->GetArray( Param => 'InvolvedUserID' );

            if ( $Config->{InformAgent} ) {
                push @NotifyUserIDs, @InformUserID;
            }

            if ( $Config->{InvolvedAgent} ) {
                push @NotifyUserIDs, @InvolvedUserID;
            }

            if ( $Self->{ReplyToArticle} ) {
                push @NotifyUserIDs, @UserListWithoutSelection;
            }

            if ( $Self->{Action} eq 'AgentTicketEmailOutbound' ) {
                $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email')->ArticleSend(
                    TicketID                        => $Self->{TicketID},
                    SenderType                      => 'agent',
                    From                            => $From,
                    MimeType                        => $MimeType,
                    Charset                         => $LayoutObject->{UserCharset},
                    UserID                          => $Self->{UserID},
                    HistoryType                     => $Config->{HistoryType},
                    HistoryComment                  => $Config->{HistoryComment},
                    ForceNotificationToUserID       => \@NotifyUserIDs,
                    ExcludeMuteNotificationToUserID => \@NotifyDone,
                    UnlockOnAway                    => $UnlockOnAway,
                    Attachment                      => \@Attachments,
                    %GetParam,
                );
            }
            else {
                $ArticleID = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Internal')->ArticleCreate(
                    TicketID                        => $Self->{TicketID},
                    SenderType                      => 'agent',
                    From                            => $From,
                    MimeType                        => $MimeType,
                    Charset                         => $LayoutObject->{UserCharset},
                    UserID                          => $Self->{UserID},
                    HistoryType                     => $Config->{HistoryType},
                    HistoryComment                  => $Config->{HistoryComment},
                    ForceNotificationToUserID       => \@NotifyUserIDs,
                    ExcludeMuteNotificationToUserID => \@NotifyDone,
                    UnlockOnAway                    => $UnlockOnAway,
                    Attachment                      => \@Attachments,
                    %GetParam,
                );
            }

            if ( !$ArticleID ) {
                return $LayoutObject->ErrorScreen();
            }

            # time accounting
            if ( $GetParam{TimeUnits} ) {
                $TicketObject->TicketAccountTime(
                    TicketID  => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    TimeUnit  => $GetParam{TimeUnits},
                    UserID    => $Self->{UserID},
                );
            }

            # remove pre submitted attachments
            $UploadCacheObject->FormIDRemove( FormID => $Self->{FormID} );
        }

        # set dynamic fields
        # cycle through the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # set the object ID (TicketID or ArticleID) depending on the field configration
            my $ObjectID = $DynamicFieldConfig->{ObjectType} eq 'Article' ? $ArticleID : $Self->{TicketID};

            # set the value
            my $Success = $DynamicFieldBackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ObjectID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }

        # If form was called based on a draft,
        #   delete draft since its content has now been used.
        if (
            $GetParam{FormDraftID}
            && !$Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftDelete(
                FormDraftID => $GetParam{FormDraftID},
                UserID      => $Self->{UserID},
            )
            )
        {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Could not delete draft!'),
                Comment => Translatable('Please contact the administrator.'),
            );
        }

        # load new URL in parent window and close popup
        $ReturnURL ||= "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID";

        return $LayoutObject->PopupClose(
            URL => $ReturnURL,
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my %Ticket         = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );
        my $CustomerUser   = $Ticket{CustomerUserID};
        my $ElementChanged = $ParamObject->GetParam( Param => 'ElementChanged' ) || '';

        my $ServiceID;

        # get service value from param if field is visible in the screen
        if ( $ConfigObject->Get('Ticket::Service') && $Config->{Service} ) {
            $ServiceID = $GetParam{ServiceID} || '';
        }

        # otherwise use ticket service value since it can't be changed
        elsif ( $ConfigObject->Get('Ticket::Service') ) {
            $ServiceID = $Ticket{ServiceID} || '';
        }

        my $QueueID = $GetParam{NewQueueID} || $Ticket{QueueID};
        my $StateID = $GetParam{NewStateID} || $Ticket{StateID};

        # get list type
        my $TreeView = 0;
        if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Owners = $Self->_GetOwners(
            %GetParam,
            QueueID  => $QueueID,
            StateID  => $StateID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $OldOwners = $Self->_GetOldOwners(
            %GetParam,
            QueueID  => $QueueID,
            StateID  => $StateID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $ResponsibleUsers = $Self->_GetResponsible(
            %GetParam,
            QueueID  => $QueueID,
            StateID  => $StateID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            CustomerUserID => $CustomerUser,
            QueueID        => $QueueID,
            StateID        => $StateID,
        );
        my $Types = $Self->_GetTypes(
            %GetParam,
            CustomerUserID => $CustomerUser,
            QueueID        => $QueueID,
            StateID        => $StateID,
        );
        my $NewQueues = $Self->_GetQueues(
            %GetParam,
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !defined $ServiceID || !$Services->{$ServiceID} ) {
            $ServiceID = '';
        }
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            CustomerUserID => $CustomerUser,
            QueueID        => $QueueID,
            StateID        => $StateID,
            ServiceID      => $ServiceID,
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID,
            StateID        => $StateID,
        );

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
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
                Action        => $Self->{Action},
                TicketID      => $Self->{TicketID},
                QueueID       => $QueueID,
                ReturnType    => 'Ticket',
                ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data          => \%AclData,
                UserID        => $Self->{UserID},
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

        my $StandardTemplates = $Self->_GetStandardTemplates(
            %GetParam,
            QueueID => $QueueID || '',
        );

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
                    TicketID   => $Self->{TicketID},
                    UserID     => $Self->{UserID},
                );

                # if ReplyToArticle is given, get this article to generate
                # the quoted article content
                if ( $Self->{ReplyToArticle} ) {

                    # get article to quote
                    my $Body = $LayoutObject->ArticleQuote(
                        TicketID          => $Self->{TicketID},
                        ArticleID         => $Self->{ReplyToArticle},
                        FormID            => $Self->{FormID},
                        UploadCacheObject => $UploadCacheObject,
                    );

                    # prepare quoted body content
                    $Body = $Self->_GetQuotedReplyBody(
                        %{ $Self->{ReplyToArticleContent} },
                        Body => $Body,
                    );

                    if ( $LayoutObject->{BrowserRichText} ) {
                        $TemplateText = $TemplateText . '<br><br>' . $Body;
                    }
                    else {
                        $TemplateText = $TemplateText . "\n\n" . $Body;
                    }
                }

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
                    Name => 'UseTemplateNote',
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

        my $JSON = $LayoutObject->BuildSelectionJSON(
            [

                {
                    Name         => 'NewOwnerID',
                    Data         => $Owners,
                    SelectedID   => $GetParam{NewOwnerID},
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
                    Name         => 'NewStateID',
                    Data         => $NextStates,
                    SelectedID   => $GetParam{NewStateID},
                    Translation  => 1,
                    PossibleNone => $Config->{StateDefault} ? 0 : 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewPriorityID',
                    Data         => $Priorities,
                    SelectedID   => $GetParam{NewPriorityID},
                    PossibleNone => 0,
                    Translation  => 1,
                    Max          => 100,
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
                {
                    Name         => 'NewQueueID',
                    Data         => $NewQueues,
                    SelectedID   => $GetParam{NewQueueID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                @DynamicFieldAJAX,
                @TemplateAJAX,
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

        my $Body = '';

        # if ReplyToArticle is given, get this article to generate
        # the quoted article content
        if ( $Self->{ReplyToArticle} ) {

            # get article to quote
            $Body = $LayoutObject->ArticleQuote(
                TicketID          => $Self->{TicketID},
                ArticleID         => $Self->{ReplyToArticle},
                FormID            => $Self->{FormID},
                UploadCacheObject => $UploadCacheObject,
            );

            # prepare quoted body content
            $Body = $Self->_GetQuotedReplyBody(
                %{ $Self->{ReplyToArticleContent} },
                Body => $Body,
            );
        }

        # if a body content was pre defined, add this before the quoted article content
        if ( $GetParam{Body} ) {

            # make sure body is rich text
            if ( $LayoutObject->{BrowserRichText} ) {
                $GetParam{Body} = $LayoutObject->Ascii2RichText(
                    String => $GetParam{Body},
                );
            }

            $Body = $GetParam{Body} . $Body;
        }

        # fillup configured default vars
        if ( $Body eq '' && $Config->{Body} ) {
            $Body = $LayoutObject->Output(
                Template => $Config->{Body},
            );

            # make sure body is rich text
            if ( $LayoutObject->{BrowserRichText} ) {
                $Body = $LayoutObject->Ascii2RichText(
                    String => $Body,
                );
            }
        }

        # set Body var to calculated content
        $GetParam{Body} = $Body;

        if ( $Self->{ReplyToArticle} ) {
            my $TicketSubjectRe = $ConfigObject->Get('Ticket::SubjectRe') || 'Re';
            $GetParam{Subject} = $TicketSubjectRe . ': ' . $Self->{ReplyToArticleContent}{Subject};
        }
        elsif ( !defined $GetParam{Subject} && $Config->{Subject} ) {
            $GetParam{Subject} = $LayoutObject->Output(
                Template => $Config->{Subject},
            );
        }

        my @TicketTypeDynamicFields;
        my @ArticleTypeDynamicFields;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
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
                        Action        => $Self->{Action},
                        TicketID      => $Self->{TicketID},
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

            if ( $DynamicFieldConfig->{ObjectType} eq 'Ticket' ) {

                # Only get values for Ticket fields (all screens based on AgentTickeActionCommon
                # generates a new article, then article fields will be always empty at the beginning).
                # Value is stored in the database from Ticket.
                $Value = $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };

                # Get field html.
                my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    Value                => $Value,
                    Mandatory            => $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                    LayoutObject         => $LayoutObject,
                    ParamObject          => $ParamObject,
                    AJAXUpdate           => 1,
                    UpdatableFields      => $Self->_GetFieldsToUpdate(),
                );

                push @TicketTypeDynamicFields, {
                    Name  => $DynamicFieldConfig->{Name},
                    Label => $DynamicFieldHTML->{Label},
                    Field => $DynamicFieldHTML->{Field},
                };
            }
            elsif ( $DynamicFieldConfig->{ObjectType} eq 'Article' ) {
                my $Class            = '';
                my $MandatoryTooltip = 0;

                if ( $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2 ) {
                    if (
                        $Config->{NoteMandatory} ||
                        $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                        )
                    {
                        $Class = 'Validate_Required';
                    }
                    else {
                        $Class            = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
                        $MandatoryTooltip = 1;
                    }
                }

                # Get field html.
                my $DynamicFieldHTML = $DynamicFieldBackendObject->EditFieldRender(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    Value                => $Value,
                    Mandatory            => ( $Class eq 'Validate_Required' ) ? 1 : 0,
                    Class                => $Class,
                    LayoutObject         => $LayoutObject,
                    ParamObject          => $ParamObject,
                    AJAXUpdate           => 1,
                    UpdatableFields      => $Self->_GetFieldsToUpdate(),
                );

                push @ArticleTypeDynamicFields, {
                    Name             => $DynamicFieldConfig->{Name},
                    Label            => $DynamicFieldHTML->{Label},
                    Field            => $DynamicFieldHTML->{Field},
                    MandatoryTooltip => $MandatoryTooltip,
                };
            }
        }

        # print form ...
        my $Output = $LayoutObject->Header(
            Type      => 'Small',
            Value     => $Ticket{TicketNumber},
            BodyClass => 'Popup',
        );
        $Output .= $Self->_Mask(
            TimeUnitsRequired => (
                $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                ? 'Validate_Required'
                : ''
            ),
            TicketTypeDynamicFields  => \@TicketTypeDynamicFields,
            ArticleTypeDynamicFields => \@ArticleTypeDynamicFields,
            %GetParam,
            %Ticket,
        );
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );
        return $Output;
    }
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # get list type
    my $TreeView = 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet( TicketID => $Self->{TicketID} );

    # get config of frontend module
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Define the dynamic fields to show based on the object type.
    my $ObjectType = ['Ticket'];

    # Only screens that add notes can modify Article dynamic fields.
    if ( $Config->{Note} ) {
        $ObjectType = [ 'Ticket', 'Article' ];
    }

    # Get dynamic fields for this screen.
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Config->{DynamicField} || {},
    );

    # Widget Ticket Actions
    if (
        ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} )
        ||
        ( $ConfigObject->Get('Ticket::Service')     && $Config->{Service} )     ||
        ( $ConfigObject->Get('Ticket::Responsible') && $Config->{Responsible} ) ||
        $Config->{Title}    ||
        $Config->{Queue}    ||
        $Config->{Owner}    ||
        $Config->{State}    ||
        $Config->{Priority} ||
        scalar @{ $Param{TicketTypeDynamicFields} } > 0
        )
    {
        $LayoutObject->Block(
            Name => 'WidgetTicketActions',
        );
    }

    if ( $Config->{Title} ) {
        $LayoutObject->Block(
            Name => 'Title',
            Data => \%Param,
        );
    }

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1,
    );

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'DynamicFieldNames',
        Value => $DynamicFieldNames,
    );

    # types
    if ( $ConfigObject->Get('Ticket::Type') && $Config->{TicketType} ) {
        my %Type = $TicketObject->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $LayoutObject->BuildSelection(
            Class => 'Validate_Required Modernize ' . ( $Param{Errors}->{TypeIDInvalid} || '' ),
            Data  => \%Type,
            Name  => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $LayoutObject->Block(
            Name => 'Type',
            Data => {%Param},
        );
    }

    # services
    if ( $ConfigObject->Get('Ticket::Service') && $Config->{Service} ) {
        my $Services = $Self->_GetServices(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Ticket{CustomerUserID},
            UserID         => $Self->{UserID},
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !$Param{ServiceID} || !$Services->{ $Param{ServiceID} } ) {
            $Param{ServiceID} = '';
        }

        $Param{ServiceStrg} = $LayoutObject->BuildSelection(
            Data       => $Services,
            Name       => 'ServiceID',
            SelectedID => $Param{ServiceID},
            Class      => "Modernize "
                . ( $Config->{ServiceMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{ServiceInvalid} || '' ),
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
        );

        $LayoutObject->Block(
            Name => 'Service',
            Data => {
                ServiceMandatory => $Config->{ServiceMandatory} || 0,
                %Param,
            },
        );

        my %SLA = $TicketObject->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );

        $Param{SLAStrg} = $LayoutObject->BuildSelection(
            Data       => \%SLA,
            Name       => 'SLAID',
            SelectedID => $Param{SLAID},
            Class      => "Modernize "
                . ( $Config->{SLAMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{ServiceInvalid} || '' ),
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Max          => 200,
        );

        $LayoutObject->Block(
            Name => 'SLA',
            Data => {
                SLAMandatory => $Config->{SLAMandatory},
                %Param,
            },
        );
    }

    if ( $Config->{Queue} ) {

        # fetch all queues
        my %MoveQueues = $TicketObject->TicketMoveList(
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
            Action   => $Self->{Action},
            Type     => 'move_into',
        );

        # set move queues
        $Param{QueuesStrg} = $LayoutObject->AgentQueueListOption(
            Data     => { %MoveQueues, '' => '-' },
            Multiple => 0,
            Size     => 0,
            Class    => 'NewQueueID Modernize '
                . ( $Config->{QueueMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewQueueInvalid} || '' ),
            Name           => 'NewQueueID',
            SelectedID     => $Param{NewQueueID},
            TreeView       => $TreeView,
            CurrentQueueID => $Param{QueueID},
            OnChangeSubmit => 0,
        );

        $LayoutObject->Block(
            Name => 'Queue',
            Data => {
                QueueMandatory => $Config->{QueueMandatory} || 0,
                %Param
            },
        );
    }

    # get needed objects
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my $UserObject  = $Kernel::OM->Get('Kernel::System::User');
    my $GroupObject = $Kernel::OM->Get('Kernel::System::Group');

    if ( $Config->{Owner} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'owner',
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        my $ACL = $TicketObject->TicketAcl(
            %Ticket,
            Action        => $Self->{Action},
            ReturnType    => 'Ticket',
            ReturnSubType => 'NewOwner',
            Data          => \%ShownUsers,
            UserID        => $Self->{UserID},
        );

        if ($ACL) {
            %ShownUsers = $TicketObject->TicketAclData();
        }

        # get old owner
        my @OldUserInfo = $TicketObject->TicketOwnerList( TicketID => $Self->{TicketID} );
        my @OldOwners;
        my %OldOwnersShown;
        my %SeenOldOwner;
        if (@OldUserInfo) {
            my $Counter = 1;
            USER:
            for my $User ( reverse @OldUserInfo ) {

                # skip if old owner is already in the list
                next USER if $SeenOldOwner{ $User->{UserID} };
                $SeenOldOwner{ $User->{UserID} } = 1;
                my $Key   = $User->{UserID};
                my $Value = "$Counter: $User->{UserFullname}";
                push @OldOwners, {
                    Key   => $Key,
                    Value => $Value,
                };
                $OldOwnersShown{$Key} = $Value;
                $Counter++;
            }
        }

        my $OldOwnerSelectedID = '';
        if ( $Param{OldOwnerID} ) {
            $OldOwnerSelectedID = $Param{OldOwnerID};
        }
        elsif ( $OldUserInfo[0]->{UserID} ) {
            $OldOwnerSelectedID = $OldUserInfo[0]->{UserID} . '1';
        }

        my $OldOwnerACL = $TicketObject->TicketAcl(
            %Ticket,
            Action        => $Self->{Action},
            ReturnType    => 'Ticket',
            ReturnSubType => 'OldOwner',
            Data          => \%OldOwnersShown,
            UserID        => $Self->{UserID},
        );

        if ($OldOwnerACL) {
            %OldOwnersShown = $TicketObject->TicketAclData();
        }

        # build string
        $Param{OwnerStrg} = $LayoutObject->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => $Param{NewOwnerID},
            Name       => 'NewOwnerID',
            Class      => 'Modernize '
                . ( $Config->{OwnerMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewOwnerInvalid} || '' ),
            Size         => 1,
            PossibleNone => 1,
            Filters      => {
                OldOwners => {
                    Name   => $LayoutObject->{LanguageObject}->Translate('Previous Owner'),
                    Values => \%OldOwnersShown,
                },
            },
        );

        $LayoutObject->Block(
            Name => 'Owner',
            Data => {
                OwnerMandatory => $Config->{OwnerMandatory} || 0,
                %Param,
            },
        );
    }

    if ( $ConfigObject->Get('Ticket::Responsible') && $Config->{Responsible} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $ConfigObject->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $GroupObject->PermissionGroupGet(
                GroupID => $GID,
                Type    => 'responsible',
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        my $ACL = $TicketObject->TicketAcl(
            %Ticket,
            Action        => $Self->{Action},
            ReturnType    => 'Ticket',
            ReturnSubType => 'Responsible',
            Data          => \%ShownUsers,
            UserID        => $Self->{UserID},
        );

        if ($ACL) {
            %ShownUsers = $TicketObject->TicketAclData();
        }

        # get responsible
        $Param{ResponsibleStrg} = $LayoutObject->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => $Param{NewResponsibleID},
            Name       => 'NewResponsibleID',
            Class      => 'Modernize '
                . ( $Config->{ResponsibleMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewResponsibleInvalid} || '' ),
            PossibleNone => 1,
            Size         => 1,
        );
        $LayoutObject->Block(
            Name => 'Responsible',
            Data => {
                ResponsibleMandatory => $Config->{ResponsibleMandatory} || 0,
                %Param,
            },
        );

    }

    if ( $Config->{State} ) {

        my %State;
        my %StateList = $TicketObject->TicketStateList(
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );
        if ( !$Param{NewStateID} ) {
            if ( $Config->{StateDefault} ) {
                $State{SelectedValue} = $Config->{StateDefault};
            }
        }
        else {
            $State{SelectedID} = $Param{NewStateID};
        }

        # build next states string
        $Param{StateStrg} = $LayoutObject->BuildSelection(
            Data  => \%StateList,
            Name  => 'NewStateID',
            Class => 'Modernize '
                . ( $Config->{StateMandatory} ? 'Validate_Required ' : '' )
                . ( $Param{NewStateInvalid} || '' ),
            PossibleNone => $Config->{StateDefault} ? 0 : 1,
            %State,
        );
        $LayoutObject->Block(
            Name => 'State',
            Data => {
                StateMandatory => $Config->{StateMandatory} || 0,
                %Param,
            },
        );

        if ( IsArrayRefWithData( $Config->{StateType} ) ) {

            STATETYPE:
            for my $StateType ( @{ $Config->{StateType} } ) {

                next STATETYPE if !$StateType;
                next STATETYPE if $StateType !~ /pending/i;

                # get used calendar
                my $Calendar = $TicketObject->TicketCalendarGet(
                    %Ticket,
                );

                $Param{DateString} = $LayoutObject->BuildDateSelection(
                    %Param,
                    Format           => 'DateInputFormatLong',
                    YearPeriodPast   => 0,
                    YearPeriodFuture => 5,
                    DiffTime         => $ConfigObject->Get('Ticket::Frontend::PendingDiffTime')
                        || 0,
                    Class => $Param{DateInvalid} || ' ',
                    Validate             => 1,
                    ValidateDateInFuture => 1,
                    Calendar             => $Calendar,
                );

                $LayoutObject->Block(
                    Name => 'StatePending',
                    Data => \%Param,
                );

                last STATETYPE;
            }
        }
    }

    # get priority
    if ( $Config->{Priority} ) {

        my %Priority;
        my %PriorityList = $TicketObject->TicketPriorityList(
            UserID   => $Self->{UserID},
            TicketID => $Self->{TicketID},
        );
        if ( !$Config->{PriorityDefault} ) {
            $PriorityList{''} = '-';
        }
        if ( !$Param{NewPriorityID} ) {
            if ( $Config->{PriorityDefault} ) {
                $Priority{SelectedValue} = $Config->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{NewPriorityID};
        }
        $Priority{SelectedID} ||= $Param{PriorityID};
        $Param{PriorityStrg} = $LayoutObject->BuildSelection(
            Data  => \%PriorityList,
            Name  => 'NewPriorityID',
            Class => 'Modernize',
            %Priority,
        );
        $LayoutObject->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # Get Ticket type dynamic fields.
    for my $TicketTypeDynamicField ( @{ $Param{TicketTypeDynamicFields} } ) {
        $LayoutObject->Block(
            Name => 'TicketTypeDynamicField',
            Data => $TicketTypeDynamicField,
        );
    }

    # End Widget Ticket Actions

    # Widget Article
    if ( $Config->{Note} ) {

        $Param{WidgetStatus} = 'Collapsed';

        if (
            $Config->{NoteMandatory}
            || $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            || $Self->{ReplyToArticle}
            || $Param{CreateArticle}
            )
        {
            $Param{WidgetStatus} = 'Expanded';
        }

        if (
            $Config->{NoteMandatory}
            || $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            )
        {
            $Param{SubjectRequired} = 'Validate_Required';
            $Param{BodyRequired}    = 'Validate_Required';
        }
        else {
            $Param{SubjectRequired} = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
            $Param{BodyRequired}    = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
        }

        # set customer visibility of this note to the same value as the article for whom this is the reply
        if ( $Self->{ReplyToArticle} && !defined $Param{IsVisibleForCustomer} ) {
            $Param{IsVisibleForCustomer} = $Self->{ReplyToArticleContent}->{IsVisibleForCustomer};
        }
        elsif ( !defined $Param{IsVisibleForCustomer} ) {
            $Param{IsVisibleForCustomer} = $Config->{IsVisibleForCustomerDefault};
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

        $LayoutObject->Block(
            Name => 'WidgetArticle',
            Data => {%Param},
        );

        # get all user ids of agents, that can be shown in this dialog
        # based on queue rights
        my %ShownUsers;
        my %AllGroupsMembers = $UserObject->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        my $GID = $QueueObject->GetQueueGroupID( QueueID => $Ticket{QueueID} );
        my %MemberList = $GroupObject->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'note',
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }

        # create email parser object
        my $EmailParserObject = Kernel::System::EmailParser->new(
            Mode  => 'Standalone',
            Debug => 0,
        );

        # check and retrieve involved and informed agents of ReplyTo Note
        my @ReplyToUsers;
        my %ReplyToUsersHash;
        my %ReplyToUserIDs;
        if ( $Self->{ReplyToArticle} ) {
            my @ReplyToParts = $EmailParserObject->SplitAddressLine(
                Line => $Self->{ReplyToArticleContent}->{To} || '',
            );

            REPLYTOPART:
            for my $SingleReplyToPart (@ReplyToParts) {
                my $ReplyToAddress = $EmailParserObject->GetEmailAddress(
                    Email => $SingleReplyToPart,
                );

                next REPLYTOPART if !$ReplyToAddress;
                push @ReplyToUsers, $ReplyToAddress;
            }

            $ReplyToUsersHash{$_}++ for @ReplyToUsers;

            # get user ids of available users
            for my $UserID ( sort keys %ShownUsers ) {
                my %UserData = $UserObject->GetUserData(
                    UserID => $UserID,
                );

                my $UserEmail = $UserData{UserEmail};
                if ( $ReplyToUsersHash{$UserEmail} ) {
                    $ReplyToUserIDs{$UserID} = 1;
                }
            }

            # add original note sender to list of user ids
            for my $UserID ( sort @{ $Self->{ReplyToSenderUserID} } ) {

                # if sender replies to himself, do not include sender in list
                if ( $UserID ne $Self->{UserID} ) {
                    $ReplyToUserIDs{$UserID} = 1;
                }
            }

            # remove user id of active user
            delete $ReplyToUserIDs{ $Self->{UserID} };
        }

        if ( $Config->{InformAgent} || $Config->{InvolvedAgent} ) {
            $LayoutObject->Block(
                Name => 'InformAdditionalAgents',
            );
        }

        # get param object
        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        # get all agents for "involved agents"
        if ( $Config->{InvolvedAgent} ) {

            my @UserIDs = $TicketObject->TicketInvolvedAgentsList(
                TicketID => $Self->{TicketID},
            );

            my @InvolvedAgents;
            my $Counter = 1;

            # get involved user list
            my @InvolvedUserID = $ParamObject->GetArray( Param => 'InvolvedUserID' );

            USER:
            for my $User ( reverse @UserIDs ) {

                my $Value = "$Counter: $User->{UserFullname}";
                if ( $User->{OutOfOfficeMessage} ) {
                    $Value .= " $User->{OutOfOfficeMessage}";
                }

                push @InvolvedAgents, {
                    Key   => $User->{UserID},
                    Value => $Value,
                };
                $Counter++;

                # add involved user as selected entries, if available in ReplyToAddresses list
                if ( $Self->{ReplyToArticle} && $ReplyToUserIDs{ $User->{UserID} } ) {
                    push @InvolvedUserID, $User->{UserID};
                    delete $ReplyToUserIDs{ $User->{UserID} };
                }
            }

            my $InvolvedAgentSize = $ConfigObject->Get('Ticket::Frontend::InvolvedAgentMaxSize') || 3;
            $Param{InvolvedAgentStrg} = $LayoutObject->BuildSelection(
                Data       => \@InvolvedAgents,
                SelectedID => \@InvolvedUserID,
                Name       => 'InvolvedUserID',
                Class      => 'Modernize',
                Multiple   => 1,
                Size       => $InvolvedAgentSize,
            );

            # block is called below "inform agents"
        }

        # agent list
        if ( $Config->{InformAgent} ) {

            # get inform user list
            my @InformUserID = $ParamObject->GetArray( Param => 'InformUserID' );

            if ( $Self->{ReplyToArticle} ) {

                # get email address of all users and compare to replyto-addresses
                for my $UserID ( sort keys %ShownUsers ) {
                    if ( $ReplyToUserIDs{$UserID} ) {
                        push @InformUserID, $UserID;
                        delete $ReplyToUserIDs{$UserID};
                    }
                }
            }

            my $InformAgentSize = $ConfigObject->Get('Ticket::Frontend::InformAgentMaxSize')
                || 3;
            $Param{OptionStrg} = $LayoutObject->BuildSelection(
                Data       => \%ShownUsers,
                SelectedID => \@InformUserID,
                Name       => 'InformUserID',
                Class      => 'Modernize',
                Multiple   => 1,
                Size       => $InformAgentSize,
            );
            $LayoutObject->Block(
                Name => 'InformAgent',
                Data => \%Param,
            );
        }

        # get involved
        if ( $Config->{InvolvedAgent} ) {

            $LayoutObject->Block(
                Name => 'InvolvedAgent',
                Data => \%Param,
            );
        }

        # show list of agents, that receive this note (ReplyToNote)
        # at least sender of original note and all recepients of the original note
        # that couldn't be selected with involved/inform agents
        if ( $Self->{ReplyToArticle} ) {

            my $UsersHashSize = keys %ReplyToUserIDs;
            my $Counter       = 0;
            $Param{UserListWithoutSelection} = join( ',', keys %ReplyToUserIDs );

            if ( $UsersHashSize > 0 ) {
                $LayoutObject->Block(
                    Name => 'InformAgentsWithoutSelection',
                    Data => \%Param,
                );

                for my $UserID ( sort keys %ReplyToUserIDs ) {
                    $Counter++;

                    my %UserData = $UserObject->GetUserData(
                        UserID => $UserID,
                    );

                    $LayoutObject->Block(
                        Name => 'InformAgentsWithoutSelectionSingleUser',
                        Data => \%UserData,
                    );

                    # output a separator (InformAgentsWithoutSelectionSingleUserSeparator),
                    # if not last entry
                    if ( $Counter < $UsersHashSize ) {
                        $LayoutObject->Block(
                            Name => 'InformAgentsWithoutSelectionSingleUserSeparator',
                            Data => \%UserData,
                        );
                    }
                }
            }
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

        if (
            $Config->{NoteMandatory}
            || $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            )
        {
            $LayoutObject->Block(
                Name => 'SubjectLabelMandatory',
            );
            $LayoutObject->Block(
                Name => 'RichTextLabelMandatory',
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'SubjectLabel',
            );
            $LayoutObject->Block(
                Name => 'RichTextLabel',
            );
        }

        # build text template string
        my %StandardTemplates = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList(
            Valid => 1,
            Type  => 'Note',
        );

        my $QueueStandardTemplates = $Self->_GetStandardTemplates(
            %Param,
            TicketID => $Self->{TicketID} || '',
        );

        if (
            IsHashRefWithData(
                $QueueStandardTemplates
                    || ( $Config->{Queue} && IsHashRefWithData( \%StandardTemplates ) )
            )
            )
        {
            $Param{StandardTemplateStrg} = $LayoutObject->BuildSelection(
                Data       => $QueueStandardTemplates    || {},
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

        # Get Article type dynamic fields.
        for my $ArticleTypeDynamicField ( @{ $Param{ArticleTypeDynamicFields} } ) {
            $LayoutObject->Block(
                Name => 'ArticleTypeDynamicField',
                Data => $ArticleTypeDynamicField,
            );

            if ( $ArticleTypeDynamicField->{MandatoryTooltip} ) {
                $LayoutObject->Block(
                    Name => 'ArticleTypeDynamicFieldError',
                    Data => $ArticleTypeDynamicField,
                );
            }
        }
    }

    # End Widget Article

    # get output back
    return $LayoutObject->Output(
        TemplateFile => $Self->{Action},
        Data         => \%Param
    );
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
        TicketID => $Self->{TicketID},
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
        %Param,
    );

    return \%NextStates;
}

sub _GetResponsible {
    my ( $Self, %Param ) = @_;
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with responsible or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{AllUsers} ) {
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'responsible',
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

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

sub _GetOwners {
    my ( $Self, %Param ) = @_;
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with owner or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{AllUsers} ) {
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'owner',
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'NewOwner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetOldOwners {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my @OldUserInfo = $TicketObject->TicketOwnerList( TicketID => $Self->{TicketID} );
    my %UserHash;
    if (@OldUserInfo) {
        my $Counter = 1;
        USER:
        for my $User ( reverse @OldUserInfo ) {

            next USER if $UserHash{ $User->{UserID} };

            $UserHash{ $User->{UserID} } = "$Counter: $User->{UserFullname}";
            $Counter++;
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'OldOwner',
        Data          => \%UserHash,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%UserHash;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

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

    # if non set customers can get default services then they should also be able to get the SLAs
    #  for those services (this works during ticket creation).
    # if no CustomerUserID is set, TicketSLAList will complain during AJAX updates as UserID is not
    #  passed. See bug 11147.

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer
        = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    my %SLA;
    if ( $Param{ServiceID} ) {
        %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%SLA;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
        %Param,
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
        TicketID => $Self->{TicketID},
    );

    # get config of frontend module
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    if ( !$Config->{PriorityDefault} ) {
        $Priorities{''} = '-';
    }
    return \%Priorities;
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updateable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields = qw(
            TypeID ServiceID SLAID NewOwnerID NewResponsibleID NewStateID
            NewPriorityID
        );
    }

    # define the dynamic fields to show based on the object type
    my $ObjectType = ['Ticket'];

    # get config of frontend module
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    # only screens that add notes can modify Article dynamic fields
    if ( $Config->{Note} ) {
        $ObjectType = [ 'Ticket', 'Article' ];
    }

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Config->{DynamicField} || {},
    );

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
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

sub _GetQuotedReplyBody {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $LayoutObject->{BrowserRichText} ) {

        # rewrap body if exists
        if ( $Param{Body} ) {
            $Param{Body} =~ s/\t/ /g;
            my $Quote = $LayoutObject->Ascii2Html(
                Text => $ConfigObject->Get('Ticket::Frontend::Quote') || '',
                HTMLResultMode => 1,
            );
            if ($Quote) {

                # quote text
                $Param{Body} = "<blockquote type=\"cite\">$Param{Body}</blockquote>\n";

                # cleanup not compat. tags
                $Param{Body} = $LayoutObject->RichTextDocumentCleanup(
                    String => $Param{Body},
                );

                my $ResponseFormat = $LayoutObject->{LanguageObject}
                    ->FormatTimeString( $Param{CreateTime}, 'DateFormat', 'NoSeconds' );
                $ResponseFormat .= ' - ' . $Param{From} . ' ';
                $ResponseFormat
                    .= $LayoutObject->{LanguageObject}->Translate('wrote') . ':';

                $Param{Body} = $ResponseFormat . $Param{Body};

            }
            else {
                $Param{Body} = "<br/>" . $Param{Body};

                if ( $Param{CreateTime} ) {
                    $Param{Body} = $LayoutObject->{LanguageObject}->Translate('Date') .
                        ": $Param{CreateTime}<br/>" . $Param{Body};
                }

                for (qw(Subject ReplyTo Reply-To Cc To From)) {
                    if ( $Param{$_} ) {
                        $Param{Body} = $LayoutObject->{LanguageObject}->Translate($_) .
                            ": $Param{$_}<br/>" . $Param{Body};
                    }
                }

                my $From = $LayoutObject->Ascii2RichText(
                    String => $Param{From},
                );

                my $MessageFrom = $LayoutObject->{LanguageObject}->Translate('Message from');
                my $EndMessage  = $LayoutObject->{LanguageObject}->Translate('End message');

                $Param{Body} = "<br/>---- $MessageFrom $From ---<br/><br/>" . $Param{Body};
                $Param{Body} .= "<br/>---- $EndMessage ---<br/>";
            }
        }
    }
    else {

        # prepare body, subject, ReplyTo ...
        # rewrap body if exists
        if ( $Param{Body} ) {
            $Param{Body} =~ s/\t/ /g;
            my $Quote = $ConfigObject->Get('Ticket::Frontend::Quote');
            if ($Quote) {
                $Param{Body} =~ s/\n/\n$Quote /g;
                $Param{Body} = "\n$Quote " . $Param{Body};

                my $ResponseFormat = $LayoutObject->{LanguageObject}
                    ->FormatTimeString( $Param{CreateTime}, 'DateFormat', 'NoSeconds' );
                $ResponseFormat .= ' - ' . $Param{From} . ' ';
                $ResponseFormat
                    .= $LayoutObject->{LanguageObject}->Translate('wrote') . ":\n";

                $Param{Body} = $ResponseFormat . $Param{Body};
            }
            else {
                $Param{Body} = "\n" . $Param{Body};
                if ( $Param{CreateTime} ) {
                    $Param{Body} = $LayoutObject->{LanguageObject}->Translate('Date') .
                        ": $Param{CreateTime}\n" . $Param{Body};
                }

                for (qw(Subject ReplyTo Reply-To Cc To From)) {
                    if ( $Param{$_} ) {
                        $Param{Body} = $LayoutObject->{LanguageObject}->Translate($_) .
                            ": $Param{$_}\n" . $Param{Body};
                    }
                }

                my $MessageFrom = $LayoutObject->{LanguageObject}->Translate('Message from');
                my $EndMessage  = $LayoutObject->{LanguageObject}->Translate('End message');

                $Param{Body} = "\n---- $MessageFrom $Param{From} ---\n\n" . $Param{Body};
                $Param{Body} .= "\n---- $EndMessage ---\n";
            }
        }
    }

    return $Param{Body};
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
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );
        $QueueID = $Ticket{QueueID} || '';
    }

    # fetch all std. templates
    my %StandardTemplates = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberList(
        QueueID       => $QueueID,
        TemplateTypes => 1,
    );

    # return empty hash if there are no templates for this screen
    return \%Templates if !IsHashRefWithData( $StandardTemplates{Note} );

    # return just the templates for this screen
    return $StandardTemplates{Note};
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # get type
    my %Type;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeList(
            %Param,
            TicketID => $Self->{TicketID},
            Action   => $Self->{Action},
            UserID   => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetQueues {
    my ( $Self, %Param ) = @_;

    # Get Queues.
    my %Queues = $Kernel::OM->Get('Kernel::System::Ticket')->TicketMoveList(
        %Param,
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
        Action   => $Self->{Action},
        Type     => 'move_into',
    );
    return \%Queues;
}

1;
