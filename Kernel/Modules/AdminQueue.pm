# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminQueue;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

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

    # Store last entity screen.
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenEntity',
        Value     => $Self->{RequestedURL},
    );

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $QueueID     = $ParamObject->GetParam( Param => 'QueueID' ) || '';

    my @Params = (
        qw(
            QueueID           ParentQueueID       Name            GroupID
            UnlockTimeout     FollowUpLock        SystemAddressID Calendar
            DefaultSignKey    SalutationID        SignatureID     FollowUpID
            FirstResponseTime FirstResponseNotify UpdateTime      UpdateNotify
            SolutionTime      SolutionNotify
            Comment           ValidID
            )
    );

    # get possible sign keys
    my %KeyList;
    my %QueueData;

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    if ($QueueID) {

        %QueueData = $QueueObject->QueueGet( ID => $QueueID );

        my $CryptObjectPGP = $Kernel::OM->Get('Kernel::System::Crypt::PGP');

        if ($CryptObjectPGP) {

            my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch( Search => $QueueData{Email} );

            for my $DataRef (@PrivateKeys) {

                my $Status = '[' . $DataRef->{Status} . ']';
                if ( $DataRef->{Status} eq 'expired' ) {
                    $Status = '[WARNING: EXPIRED KEY]';
                }
                elsif ( $DataRef->{Status} eq 'revoked' ) {
                    $Status = '[WARNING: REVOKED KEY]';
                }

                $KeyList{"PGP::Inline::$DataRef->{Key}"} = "PGP-Inline:$Status $DataRef->{Key} $DataRef->{Identifier}";
                $KeyList{"PGP::Detached::$DataRef->{Key}"}
                    = "PGP-Detached:$Status $DataRef->{Key} $DataRef->{Identifier}";
            }
        }

        my $CryptObjectSMIME = $Kernel::OM->Get('Kernel::System::Crypt::SMIME');

        if ($CryptObjectSMIME) {

            my @PrivateKeys = $CryptObjectSMIME->PrivateSearch( Search => $QueueData{Email} );

            my $Expired;
            for my $DataRef (@PrivateKeys) {
                $Expired = '';
                if (
                    defined $DataRef->{EndDate}
                    && $CryptObjectSMIME->KeyExpiredCheck( EndDate => $DataRef->{EndDate} )
                    )
                {
                    $Expired = ' [WARNING: EXPIRED KEY]';
                }
                $KeyList{"SMIME::Detached::$DataRef->{Filename}"}
                    = "SMIME-Detached:$Expired $DataRef->{Filename} [$DataRef->{EndDate}] $DataRef->{Email}";
            }
        }
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');
    my $Notification = $ParamObject->GetParam( Param => 'Notification' ) || '';

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Info => Translatable('Queue updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Self->_Edit(
            Action => 'Change',
            %Param,
            %QueueData,
            DefaultSignKeyList => \%KeyList,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (@Params) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check queue name
        if ( $GetParam{Name} =~ /::/ ) {
            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Warning(
                Message => Translatable('Don\'t use :: in queue name!'),
                Comment => Translatable('Click back and change it!'),
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }

        # get long queue name
        if ( $GetParam{ParentQueueID} ) {
            $GetParam{Name} = $QueueObject->QueueLookup(
                QueueID => $GetParam{ParentQueueID},
                )
                . '::'
                . $GetParam{Name};
        }

        # check needed data
        for my $Needed (
            qw(Name GroupID SystemAddressID SalutationID SignatureID ValidID FollowUpID)
            )
        {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check if a queue exist with this name
        my $NameExists = $QueueObject->NameExistsCheck(
            Name => $GetParam{Name},
            ID   => $GetParam{QueueID}
        );
        if ($NameExists) {
            $Errors{NameExists}    = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        # Check if queue is present in SysConfig setting
        my $UpdateEntity    = $ParamObject->GetParam( Param => 'UpdateEntity' ) || '';
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my %QueueOldData    = %QueueData;
        my @IsQueueInSysConfig;
        @IsQueueInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
            EntityType => 'Queue',
            EntityName => $QueueData{Name},
        );
        if (@IsQueueInSysConfig) {

            # An entity present in SysConfig couldn't be invalidated.
            if (
                $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $GetParam{ValidID} )
                ne 'valid'
                )
            {
                $Errors{ValidIDInvalid}         = 'ServerError';
                $Errors{ValidOptionServerError} = 'InSetting';
            }

            # In case changing name an authorization (UpdateEntity) should be send
            elsif ( $QueueData{Name} ne $GetParam{Name} && !$UpdateEntity ) {
                $Errors{NameInvalid}              = 'ServerError';
                $Errors{InSettingNameServerError} = 1;
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update queue
            my $QueueUpdate = $QueueObject->QueueUpdate(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($QueueUpdate) {

                # update preferences
                my %QueueData = $QueueObject->QueueGet( ID => $GetParam{QueueID} );

                my %Preferences;
                if ( $ConfigObject->Get('QueuePreferences') ) {
                    %Preferences = %{ $ConfigObject->Get('QueuePreferences') };
                }

                for my $Item ( sort keys %Preferences ) {

                    my $Module = $Preferences{$Item}->{Module}
                        || 'Kernel::Output::HTML::QueuePreferences::Generic';

                    # load module
                    if ( !$MainObject->Require($Module) ) {
                        return $LayoutObject->FatalError();
                    }
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Item},
                        Debug      => $Self->{Debug},
                    );

                    my @Params = $Object->Param( QueueData => \%QueueData );

                    if (@Params) {

                        my %GetParam;
                        for my $ParamItem (@Params) {

                            my @Array = $ParamObject->GetArray(
                                Param => $ParamItem->{Name},
                            );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }

                        if (
                            !$Object->Run(
                                GetParam  => \%GetParam,
                                QueueData => \%QueueData
                            )
                            )
                        {
                            $Note .= $LayoutObject->Notify( Info => $Object->Error() );
                        }
                    }
                }

                if (
                    @IsQueueInSysConfig
                    && $QueueOldData{Name} ne $GetParam{Name}
                    && $UpdateEntity
                    )
                {
                    SETTING:
                    for my $SettingName (@IsQueueInSysConfig) {

                        my %Setting = $SysConfigObject->SettingGet(
                            Name => $SettingName,
                        );

                        next SETTING if !IsHashRefWithData( \%Setting );

                        $Setting{EffectiveValue} =~ s/$QueueOldData{Name}/$GetParam{Name}/g;

                        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                            Name   => $Setting{Name},
                            Force  => 1,
                            UserID => $Self->{UserID}
                        );
                        $Setting{ExclusiveLockGUID} = $ExclusiveLockGUID;

                        my %UpdateSuccess = $SysConfigObject->SettingUpdate(
                            %Setting,
                            UserID => $Self->{UserID},
                        );
                    }

                    $SysConfigObject->ConfigurationDeploy(
                        Comments      => "Queue name change",
                        DirtySettings => \@IsQueueInSysConfig,
                        UserID        => $Self->{UserID},
                        Force         => 1,
                    );
                }

                # if $Note has some notify, create output with $Note
                # otherwise redirect depending on what button ('Save' or 'Save and Finish') is clicked
                if ( $Note ne '' ) {
                    $Self->_Overview();
                    my $Output = $LayoutObject->Header();
                    $Output .= $LayoutObject->NavigationBar();
                    $Output .= $Note;
                    $Output .= $LayoutObject->Output(
                        TemplateFile => 'AdminQueue',
                        Data         => \%Param,
                    );
                    $Output .= $LayoutObject->Footer();

                    return $Output;
                }

                # if the user would like to continue editing the queue, just redirect to the edit screen
                if (
                    defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
                    && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
                    )
                {
                    return $LayoutObject->Redirect(
                        OP => "Action=$Self->{Action};Subaction=Change;QueueID=$QueueID;Notification=Update"
                    );
                }
                else {

                    # otherwise return to overview
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Notification=Update" );
                }

            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;

    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {

        my %GetParam;
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (@Params) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check queue name
        if ( $GetParam{Name} =~ /::/ ) {

            my $Output = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $LayoutObject->Warning(
                Message => Translatable('Don\'t use :: in queue name!'),
                Comment => Translatable('Click back and change it!'),
            );
            $Output .= $LayoutObject->Footer();

            return $Output;
        }

        # get long queue name
        if ( $GetParam{ParentQueueID} ) {
            $GetParam{Name} = $QueueObject->QueueLookup(
                QueueID => $GetParam{ParentQueueID},
            ) . '::' . $GetParam{Name};
        }

        # check needed data
        for my $Needed (
            qw(Name GroupID SystemAddressID SalutationID SignatureID ValidID FollowUpID)
            )
        {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check if some fields must be set with default values
        for my $Optional (
            qw(UnlockTimeout FirstResponseTime FirstResponseNotify UpdateTime UpdateNotify SolutionTime SolutionNotify FollowUpLock Calendar)
            )
        {

            # add default values
            if ( !$GetParam{$Optional} ) {
                $GetParam{$Optional} = 0;
            }
        }

        # check if a queue exist with this name
        my $NameExists = $QueueObject->NameExistsCheck( Name => $GetParam{Name} );
        if ($NameExists) {
            $Errors{NameExists}    = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # create new queue
            my $ID = $QueueObject->QueueAdd(
                %GetParam,
                UserID          => $Self->{UserID},
                NoDefaultValues => 1,
            );

            if ($ID) {

                # update preferences
                my %QueueData = $QueueObject->QueueGet( ID => $ID );

                my %Preferences;
                if ( $ConfigObject->Get('QueuePreferences') ) {
                    %Preferences = %{ $ConfigObject->Get('QueuePreferences') };
                }

                for my $Item ( sort keys %Preferences ) {

                    my $Module = $Preferences{$Item}->{Module}
                        || 'Kernel::Output::HTML::QueuePreferences::Generic';

                    # load module
                    if ( !$MainObject->Require($Module) ) {
                        return $LayoutObject->FatalError();
                    }

                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Item},
                        Debug      => $Self->{Debug},
                    );

                    my @Params = $Object->Param( QueueData => \%QueueData );

                    if (@Params) {

                        my %GetParam;
                        for my $ParamItem (@Params) {

                            my @Array = $ParamObject->GetArray(
                                Param => $ParamItem->{Name},
                            );

                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }

                        if (
                            !$Object->Run(
                                GetParam  => \%GetParam,
                                QueueData => \%QueueData
                            )
                            )
                        {
                            $Note .= $LayoutObject->Notify( Info => $Object->Error() );
                        }
                    }
                }

                return $LayoutObject->Redirect(
                    OP => "Action=AdminQueueTemplates&Subaction=Queue&ID=$ID",
                );
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );

        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        $Self->_Overview();

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Info => Translatable('Queue updated!') )
            if ( $Notification && $Notification eq 'Update' );

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();

        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    $Param{GroupOption} = $LayoutObject->BuildSelection(
        Data => {
            $Kernel::OM->Get('Kernel::System::Group')->GroupList(
                Valid => 1,
            )
        },
        Translation => 0,
        Name        => 'GroupID',
        SelectedID  => $Param{GroupID},
        Class       => 'Modernize Validate_Required ' . ( $Param{Errors}->{'GroupIDInvalid'} || '' ),
    );

    my $ParentQueue = '';
    if ( $Param{Name} ) {
        my @Queue = split( /::/, $Param{Name} );
        for ( my $i = 0; $i < $#Queue; $i++ ) {
            if ($ParentQueue) {
                $ParentQueue .= '::';
            }
            $ParentQueue .= $Queue[$i];
        }
        $Param{Name} = $Queue[-1];
    }

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');
    my %Data        = $QueueObject->QueueList( Valid => 0 );

    my $QueueName = '';
    if ( $Param{QueueID} ) {
        $QueueName = $Data{ $Param{QueueID} } // '';
    }

    my %CleanHash = %Data;
    for my $Key ( sort keys %Data ) {
        if ( $CleanHash{$Key} eq $QueueName || $CleanHash{$Key} =~ /^\Q$QueueName\E\:\:/ ) {
            delete $CleanHash{$Key};
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $ListType = $ConfigObject->Get('Ticket::Frontend::ListType');

    # get max queue level
    my $MaxParentLevel = ( $ConfigObject->Get('Ticket::Frontend::MaxQueueLevel') || 5 ) - 1;

    # verify if queue list should be a list or a tree
    if ( $ListType eq 'tree' ) {
        $Param{QueueOption} = $LayoutObject->AgentQueueListOption(
            Data => {
                '' => ' -',
                %CleanHash,
            },
            Name           => 'ParentQueueID',
            Selected       => $ParentQueue,
            MaxLevel       => $MaxParentLevel,
            OnChangeSubmit => 0,
            Class          => 'Modernize',
        );
    }
    else {

        # leave only queues with $MaxQueueLevel levels, because max allowed level is $MaxQueueLevel + 1:
        # new queue + $MaxQueueLevel levels of parent queue = $MaxQueueLevel + 1 levels
        for my $Key ( sort keys %CleanHash ) {
            my $QueueName      = $CleanHash{$Key};
            my @QueueNameLevel = split( ::, $QueueName );
            my $QueueLevel     = $#QueueNameLevel + 1;
            if ( $QueueLevel > $MaxParentLevel ) {
                delete $CleanHash{$Key};
            }
        }

        $Param{QueueOption} = $LayoutObject->BuildSelection(
            Data          => \%CleanHash,
            Name          => 'ParentQueueID',
            SelectedValue => $ParentQueue,
            PossibleNone  => 1,
            HTMLQuote     => 0,
            Translation   => 0,
            Class         => 'Modernize',
        );
    }

    $Param{QueueLongOption} = $LayoutObject->AgentQueueListOption(
        Data           => { $QueueObject->QueueList( Valid => 0 ), },
        Name           => 'QueueID',
        Size           => 15,
        SelectedID     => $Param{QueueID},
        OnChangeSubmit => 0,
    );
    my %NotifyLevelList = (
        10 => '10%',
        20 => '20%',
        30 => '30%',
        40 => '40%',
        50 => '50%',
        60 => '60%',
        70 => '70%',
        80 => '80%',
        90 => '90%',
    );
    $Param{FirstResponseNotifyOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%NotifyLevelList,
        Translation  => 0,
        Name         => 'FirstResponseNotify',
        SelectedID   => $Param{FirstResponseNotify},
        PossibleNone => 1,
        Class        => 'Modernize',
    );
    $Param{UpdateNotifyOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%NotifyLevelList,
        Translation  => 0,
        Name         => 'UpdateNotify',
        SelectedID   => $Param{UpdateNotify},
        PossibleNone => 1,
        Class        => 'Modernize',
    );
    $Param{SolutionNotifyOptionStrg} = $LayoutObject->BuildSelection(
        Data         => \%NotifyLevelList,
        Translation  => 0,
        Name         => 'SolutionNotify',
        SelectedID   => $Param{SolutionNotify},
        PossibleNone => 1,
        Class        => 'Modernize',
    );
    $Param{SignatureOption} = $LayoutObject->BuildSelection(
        Data        => { $Kernel::OM->Get('Kernel::System::Signature')->SignatureList( Valid => 1 ), },
        Translation => 0,
        Name        => 'SignatureID',
        SelectedID  => $Param{SignatureID},
        Class       => 'Modernize Validate_Required ' . ( $Param{Errors}->{'SignatureIDInvalid'} || '' ),
    );
    $Param{FollowUpLockYesNoOption} = $LayoutObject->BuildSelection(
        Data       => $ConfigObject->Get('YesNoOptions'),
        Name       => 'FollowUpLock',
        SelectedID => $Param{FollowUpLock} // 0,
        Class      => 'Modernize',
    );

    $Param{SystemAddressOption} = $LayoutObject->BuildSelection(
        Data => {
            $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressList( Valid => 1 ),
        },
        Translation  => 0,
        Name         => 'SystemAddressID',
        SelectedID   => $Param{SystemAddressID},
        PossibleNone => 1,                         # to avoid automatic assignments if the current SA is invalid
        Max          => 200,
        Class => 'Modernize Validate_Required ' . ( $Param{Errors}->{'SystemAddressIDInvalid'} || '' ),
    );

    my %DefaultSignKeyList = ();
    if ( $Param{DefaultSignKeyList} ) {
        %DefaultSignKeyList = %{ $Param{DefaultSignKeyList} };
    }
    $Param{DefaultSignKeyOption} = $LayoutObject->BuildSelection(
        Data => {
            '' => Translatable('-none-'),
            %DefaultSignKeyList
        },
        Name       => 'DefaultSignKey',
        Max        => 150,
        SelectedID => $Param{DefaultSignKey},
        Class      => 'Modernize',
    );
    $Param{SalutationOption} = $LayoutObject->BuildSelection(
        Data        => { $Kernel::OM->Get('Kernel::System::Salutation')->SalutationList( Valid => 1 ), },
        Translation => 0,
        Name        => 'SalutationID',
        SelectedID  => $Param{SalutationID},
        Class       => 'Modernize Validate_Required ' . ( $Param{Errors}->{'SalutationIDInvalid'} || '' ),
    );

    $Param{FollowUpOption} = $LayoutObject->BuildSelection(
        Data => {
            $QueueObject->GetFollowUpOptionList(
                Valid => 0,
            ),
        },
        Name       => 'FollowUpID',
        SelectedID => $Param{FollowUpID}
            || $ConfigObject->Get('AdminDefaultFollowUpID')
            || 1,
        Class => 'Modernize Validate_Required ' . ( $Param{Errors}->{'FollowUpIDInvalid'} || '' ),
    );
    my %Calendar = ( '' => '-' );

    my $Maximum = $ConfigObject->Get("MaximumCalendarNumber") || 50;

    for my $CalendarNumber ( '', 1 .. $Maximum ) {
        if ( $ConfigObject->Get("TimeVacationDays::Calendar$CalendarNumber") ) {
            $Calendar{$CalendarNumber} = "Calendar $CalendarNumber - "
                . $ConfigObject->Get( "TimeZone::Calendar" . $CalendarNumber . "Name" );
        }
    }
    $Param{CalendarOption} = $LayoutObject->BuildSelection(
        Data        => \%Calendar,
        Translation => 0,
        Name        => 'Calendar',
        SelectedID  => $Param{Calendar},
        Class       => 'Modernize',
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    if ( $Param{DefaultSignKeyOption} ) {
        $Param{DefaultSignKeyListAvailable} = IsHashRefWithData( \%DefaultSignKeyList );
        $LayoutObject->Block(
            Name => 'OptionalField',
            Data => \%Param,
        );
    }

    # show appropriate messages for ServerError
    if ( defined $Param{Errors}->{NameExists} && $Param{Errors}->{NameExists} == 1 ) {
        $LayoutObject->Block( Name => 'ExistNameServerError' );
    }
    elsif ( defined $Param{Errors}->{InSettingNameServerError} && $Param{Errors}->{InSettingNameServerError} == 1 ) {
        $LayoutObject->Block( Name => 'InSettingNameServerError' );
    }
    else {
        $LayoutObject->Block( Name => 'NameServerError' );
    }

    # show each preferences setting
    my %Preferences;
    if ( $ConfigObject->Get('QueuePreferences') ) {
        %Preferences = %{ $ConfigObject->Get('QueuePreferences') };
    }

    for my $Item ( sort keys %Preferences ) {

        my $Module = $Preferences{$Item}->{Module}
            || 'Kernel::Output::HTML::QueuePreferences::Generic';

        # load module
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            return $LayoutObject->FatalError();
        }
        my $Object = $Module->new(
            %{$Self},
            ConfigItem => $Preferences{$Item},
            Debug      => $Self->{Debug},
        );

        my @Params = $Object->Param( QueueData => \%Param );

        if (@Params) {

            for my $ParamItem (@Params) {

                $LayoutObject->Block(
                    Name => 'Item',
                    Data => { %Param, },
                );

                if (
                    ref $ParamItem->{Data} eq 'HASH'
                    || ref $Preferences{$Item}->{Data} eq 'HASH'
                    )
                {
                    my %BuildSelectionParams = (
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    );
                    $BuildSelectionParams{Class} = join( ' ', $BuildSelectionParams{Class} // '', 'Modernize' );
                    $ParamItem->{'Option'} = $LayoutObject->BuildSelection(
                        %BuildSelectionParams
                    );
                }

                $LayoutObject->Block(
                    Name => $ParamItem->{Block} || $Preferences{$Item}->{Block} || 'Option',
                    Data => {
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    },
                );
            }
        }
    }

    # reformat from html to plain
    if ( $Param{ContentType} && $Param{ContentType} =~ /text\/html/i ) {
        $Param{Response} = $Kernel::OM->Get('Kernel::System::HTMLUtils')->ToAscii(
            String => $Param{Response},
        );
    }

    # Several error messages can be used for Valid option.
    $Param{Errors}->{ValidOptionServerError} //= 'Required';
    $LayoutObject->Block(
        Name => $Param{Errors}->{ValidOptionServerError} . 'ValidOptionServerError',
    );

    # Add warning in case the Queue belongs a SysConfig setting.
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    # In case dirty setting disable form
    my $IsDirtyConfig = 0;
    my @IsDirtyResult = $SysConfigObject->ConfigurationDirtySettingsList();
    my %IsDirtyList   = map { $_ => 1 } @IsDirtyResult;

    my @IsQueueInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
        EntityType => 'Queue',
        EntityName => $QueueName // '',
    );

    if (@IsQueueInSysConfig) {
        $LayoutObject->Block(
            Name => 'QueueInSysConfig',
            Data => {
                OldName => $QueueName,
            },
        );
        for my $SettingName (@IsQueueInSysConfig) {
            $LayoutObject->Block(
                Name => 'QueueInSysConfigRow',
                Data => {
                    SettingName => $SettingName,
                },
            );

            # Verify if dirty setting
            if ( $IsDirtyList{$SettingName} ) {
                $IsDirtyConfig = 1;
            }

        }
    }

    if ($IsDirtyConfig) {
        $LayoutObject->Block(
            Name => 'QueueInSysConfigDirty',
            ,
        );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # get queue list
    my %List = $QueueObject->QueueList( Valid => 0 );

    # error handling
    if ( !%List ) {

        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
        );

        return 1;
    }

    # get valid list
    my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

    for my $QueueID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        # get queue data
        my %Data = $QueueObject->QueueGet(
            ID => $QueueID,
        );

        # group lookup
        $Data{GroupName} = $Kernel::OM->Get('Kernel::System::Group')->GroupLookup(
            GroupID => $Data{GroupID},
        );

        $LayoutObject->Block(
            Name => 'OverviewResultRow',
            Data => {
                Valid => $ValidList{ $Data{ValidID} },
                %Data,
            },
        );
    }

    return 1;
}

1;
