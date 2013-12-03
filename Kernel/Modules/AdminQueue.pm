# --
# Kernel/Modules/AdminQueue.pm - to add/update/delete queues
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminQueue;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::System::Crypt;
use Kernel::System::Valid;
use Kernel::System::Salutation;
use Kernel::System::Signature;
use Kernel::System::SystemAddress;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (
        qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);
    $Self->{SalutationObject}    = Kernel::System::Salutation->new(%Param);
    $Self->{SignatureObject}     = Kernel::System::Signature->new(%Param);
    $Self->{SystemAddressObject} = Kernel::System::SystemAddress->new(%Param);
    $Self->{GroupObject}         = Kernel::System::Group->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $QueueID = $Self->{ParamObject}->GetParam( Param => 'QueueID' ) || '';

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

    if ($QueueID) {

        %QueueData = $Self->{QueueObject}->QueueGet( ID => $QueueID );

        my $CryptObjectPGP = Kernel::System::Crypt->new(
            %{$Self},
            CryptType => 'PGP',
        );

        if ($CryptObjectPGP) {

            my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch( Search => $QueueData{Email} );

            for my $DataRef (@PrivateKeys) {
                $KeyList{"PGP::Inline::$DataRef->{Key}"}
                    = "PGP-Inline: $DataRef->{Key} $DataRef->{Identifier}";
                $KeyList{"PGP::Detached::$DataRef->{Key}"}
                    = "PGP-Detached: $DataRef->{Key} $DataRef->{Identifier}";
            }
        }

        my $CryptObjectSMIME = Kernel::System::Crypt->new(
            %{$Self},
            CryptType => 'SMIME',
        );

        if ($CryptObjectSMIME) {

            my @PrivateKeys = $CryptObjectSMIME->PrivateSearch( Search => $QueueData{Email} );

            for my $DataRef (@PrivateKeys) {
                $KeyList{"SMIME::Detached::$DataRef->{Filename}"}
                    = "SMIME-Detached: $DataRef->{Filename} [$DataRef->{EndDate}] $DataRef->{Email}";
            }
        }
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Self->_Edit(
            Action => 'Change',
            %Param,
            %QueueData,
            DefaultSignKeyList => \%KeyList,
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (@Params) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check queue name
        if ( $GetParam{Name} =~ /::/ ) {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Warning(
                Message => 'Don\'t use :: in queue name!',
                Comment => 'Click back and change it!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        # get long queue name
        if ( $GetParam{ParentQueueID} ) {
            $GetParam{Name}
                = $Self->{QueueObject}->QueueLookup( QueueID => $GetParam{ParentQueueID}, ) . '::'
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

        # if no errors occurred
        if ( !%Errors ) {

            # update queue
            my $QueueUpdate = $Self->{QueueObject}->QueueUpdate(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($QueueUpdate) {

                # update preferences
                my %QueueData = $Self->{QueueObject}->QueueGet( ID => $GetParam{QueueID} );

                my %Preferences;
                if ( $Self->{ConfigObject}->Get('QueuePreferences') ) {
                    %Preferences = %{ $Self->{ConfigObject}->Get('QueuePreferences') };
                }

                for my $Item ( sort keys %Preferences ) {

                    my $Module = $Preferences{$Item}->{Module}
                        || 'Kernel::Output::HTML::QueuePreferencesGeneric';

                    # load module
                    if ( !$Self->{MainObject}->Require($Module) ) {
                        return $Self->{LayoutObject}->FatalError();
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

                            my @Array = $Self->{ParamObject}->GetArray(
                                Param => $ParamItem->{Name},
                            );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }

                        if ( !$Object->Run( GetParam => \%GetParam, QueueData => \%QueueData ) ) {
                            $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                        }
                    }
                }

                $Self->_Overview();

                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Notify( Info => 'Queue updated!' );
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminQueue',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();

                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );

        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;

    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {

        my %GetParam;
        $GetParam{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' );

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();

        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (@Params) {
            $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
        }

        # check queue name
        if ( $GetParam{Name} =~ /::/ ) {

            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Warning(
                Message => 'Don\'t use :: in queue name!',
                Comment => 'Click back and change it!',
            );
            $Output .= $Self->{LayoutObject}->Footer();

            return $Output;
        }

        # get long queue name
        if ( $GetParam{ParentQueueID} ) {
            $GetParam{Name} = $Self->{QueueObject}->QueueLookup(
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

        # if no errors occurred
        if ( !%Errors ) {

            # create new queue
            my $ID = $Self->{QueueObject}->QueueAdd(
                %GetParam,
                UserID          => $Self->{UserID},
                NoDefaultValues => 1,
            );

            if ($ID) {

                # update preferences
                my %QueueData = $Self->{QueueObject}->QueueGet( ID => $ID );

                my %Preferences;
                if ( $Self->{ConfigObject}->Get('QueuePreferences') ) {
                    %Preferences = %{ $Self->{ConfigObject}->Get('QueuePreferences') };
                }

                for my $Item ( sort keys %Preferences ) {

                    my $Module = $Preferences{$Item}->{Module}
                        || 'Kernel::Output::HTML::QueuePreferencesGeneric';

                    # load module
                    if ( !$Self->{MainObject}->Require($Module) ) {
                        return $Self->{LayoutObject}->FatalError();
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

                            my @Array = $Self->{ParamObject}->GetArray(
                                Param => $ParamItem->{Name},
                            );

                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }

                        if ( !$Object->Run( GetParam => \%GetParam, QueueData => \%QueueData ) ) {
                            $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                        }
                    }
                }

                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=AdminQueueTemplates&Subaction=Queue&ID=$ID",
                );
            }
        }

        # something has gone wrong
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Notify( Priority => 'Error' );

        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );

        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }

    # ------------------------------------------------------------ #
    # overview
    # ------------------------------------------------------------ #
    else {

        $Self->_Overview();

        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminQueue',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();

        return $Output;
    }
}

sub _Edit {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );
    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Self->{ValidObject}->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    $Param{GroupOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{DBObject}->GetTableData(
                What  => 'id, name',
                Table => 'groups',
                Valid => 1,
            ),
        },
        Translation => 0,
        Name        => 'GroupID',
        SelectedID  => $Param{GroupID},
        Class       => 'Validate_Required ' . ( $Param{Errors}->{'GroupIDInvalid'} || '' ),
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
        $Param{Name} = $Queue[$#Queue];
    }

    my %Data = $Self->{QueueObject}->QueueList( Valid => 0 );

    my $QueueName = '';
    KEY:
    for my $Key ( sort keys %Data ) {

        if ( $Param{QueueID} && $Param{QueueID} eq $Key ) {
            $QueueName = $Data{ $Param{QueueID} };
            last KEY;
        }
    }
    my %CleanHash = %Data;
    for my $Key ( sort keys %Data ) {
        if ( $CleanHash{$Key} eq $QueueName || $CleanHash{$Key} =~ /^\Q$QueueName\E\:\:/ ) {
            delete $CleanHash{$Key};
        }
    }

    # get list type
    my $ListType = $Self->{ConfigObject}->Get('Ticket::Frontend::ListType');

    # get max queue level
    my $MaxParentLevel = ( $Self->{ConfigObject}->Get('Ticket::Frontend::MaxQueueLevel') || 5 ) - 1;

    # verify if queue list should be a list or a tree
    if ( $ListType eq 'tree' ) {
        $Param{QueueOption} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => { '' => ' -', %CleanHash, },
            Name => 'ParentQueueID',
            Selected       => $ParentQueue,
            MaxLevel       => $MaxParentLevel,
            OnChangeSubmit => 0,
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

        $Param{QueueOption} = $Self->{LayoutObject}->BuildSelection(
            Data          => \%CleanHash,
            Name          => 'ParentQueueID',
            SelectedValue => $ParentQueue,
            PossibleNone  => 1,
            HTMLQuote     => 0,
            Translation   => 0,
        );
    }

    $Param{QueueLongOption} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { $Self->{QueueObject}->QueueList( Valid => 0 ), },
        Name => 'QueueID',
        Size => 15,
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
    $Param{FirstResponseNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%NotifyLevelList,
        Translation  => 0,
        Name         => 'FirstResponseNotify',
        SelectedID   => $Param{FirstResponseNotify},
        PossibleNone => 1,
    );
    $Param{UpdateNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%NotifyLevelList,
        Translation  => 0,
        Name         => 'UpdateNotify',
        SelectedID   => $Param{UpdateNotify},
        PossibleNone => 1,
    );
    $Param{SolutionNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%NotifyLevelList,
        Translation  => 0,
        Name         => 'SolutionNotify',
        SelectedID   => $Param{SolutionNotify},
        PossibleNone => 1,
    );
    $Param{SignatureOption} = $Self->{LayoutObject}->BuildSelection(
        Data => { $Self->{SignatureObject}->SignatureList( Valid => 1 ), },
        Translation => 0,
        Name        => 'SignatureID',
        SelectedID  => $Param{SignatureID},
        Class       => 'Validate_Required ' . ( $Param{Errors}->{'SignatureIDInvalid'} || '' ),
    );
    $Param{FollowUpLockYesNoOption} = $Self->{LayoutObject}->BuildSelection(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'FollowUpLock',
        SelectedID => $Param{FollowUpLock} || 0,
    );

    $Param{SystemAddressOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{SystemAddressObject}->SystemAddressList( Valid => 1 ),
        },
        Translation => 0,
        Name        => 'SystemAddressID',
        SelectedID  => $Param{SystemAddressID},
        PossibleNone => 1,     # to avoid automatic assignments if the current SA is invalid
        Max          => 200,
        Class => 'Validate_Required ' . ( $Param{Errors}->{'SystemAddressIDInvalid'} || '' ),
    );

    my %DefaultSignKeyList = ();
    if ( $Param{DefaultSignKeyList} ) {
        %DefaultSignKeyList = %{ $Param{DefaultSignKeyList} };
    }
    $Param{DefaultSignKeyOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            '' => '-none-',
            %DefaultSignKeyList
        },
        Name       => 'DefaultSignKey',
        Max        => 50,
        SelectedID => $Param{DefaultSignKey},
    );
    $Param{SalutationOption} = $Self->{LayoutObject}->BuildSelection(
        Data => { $Self->{SalutationObject}->SalutationList( Valid => 1 ), },
        Translation => 0,
        Name        => 'SalutationID',
        SelectedID  => $Param{SalutationID},
        Class       => 'Validate_Required ' . ( $Param{Errors}->{'SalutationIDInvalid'} || '' ),
    );
    $Param{FollowUpOption} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            $Self->{DBObject}->GetTableData(
                What  => 'id, name',
                Valid => 1,
                Table => 'follow_up_possible',
            ),
        },
        Name       => 'FollowUpID',
        SelectedID => $Param{FollowUpID}
            || $Self->{ConfigObject}->Get('AdminDefaultFollowUpID')
            || 1,
        Class => 'Validate_Required ' . ( $Param{Errors}->{'FollowUpIDInvalid'} || '' ),
    );
    my %Calendar = ( '' => '-' );

    for my $Number ( '', 1 .. 50 ) {
        if ( $Self->{ConfigObject}->Get("TimeVacationDays::Calendar$Number") ) {
            $Calendar{$Number} = "Calendar $Number - "
                . $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $Number . "Name" );
        }
    }
    $Param{CalendarOption} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%Calendar,
        Translation => 0,
        Name        => 'Calendar',
        SelectedID  => $Param{Calendar},
    );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # shows header
    if ( $Param{Action} eq 'Change' ) {
        $Self->{LayoutObject}->Block( Name => 'HeaderEdit' );
    }
    else {
        $Self->{LayoutObject}->Block( Name => 'HeaderAdd' );
    }

    if ( $Param{DefaultSignKeyOption} ) {
        $Self->{LayoutObject}->Block(
            Name => 'OptionalField',
            Data => \%Param,
        );
    }

    # show each preferences setting
    my %Preferences;
    if ( $Self->{ConfigObject}->Get('QueuePreferences') ) {
        %Preferences = %{ $Self->{ConfigObject}->Get('QueuePreferences') };
    }

    for my $Item ( sort keys %Preferences ) {

        my $Module = $Preferences{$Item}->{Module}
            || 'Kernel::Output::HTML::QueuePreferencesGeneric';

        # load module
        if ( !$Self->{MainObject}->Require($Module) ) {
            return $Self->{LayoutObject}->FatalError();
        }
        my $Object = $Module->new(
            %{$Self},
            ConfigItem => $Preferences{$Item},
            Debug      => $Self->{Debug},
        );

        my @Params = $Object->Param( QueueData => \%Param );

        if (@Params) {

            for my $ParamItem (@Params) {

                $Self->{LayoutObject}->Block(
                    Name => 'Item',
                    Data => { %Param, },
                );

                if (
                    ref $ParamItem->{Data} eq 'HASH'
                    || ref $Preferences{$Item}->{Data} eq 'HASH'
                    )
                {
                    $ParamItem->{'Option'} = $Self->{LayoutObject}->BuildSelection(
                        %{ $Preferences{$Item} },
                        %{$ParamItem},
                    );
                }

                $Self->{LayoutObject}->Block(
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
        $Param{Response} = $Self->{HTMLUtilsObject}->ToAscii(
            String => $Param{Response},
        );
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    $Self->{LayoutObject}->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $Self->{LayoutObject}->Block( Name => 'ActionList' );
    $Self->{LayoutObject}->Block( Name => 'ActionAdd' );

    $Self->{LayoutObject}->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    # get queue list
    my %List = $Self->{QueueObject}->QueueList( Valid => 0 );

    # error handling
    if ( !%List ) {

        $Self->{LayoutObject}->Block(
            Name => 'NoDataFoundMsg',
        );

        return 1;
    }

    # get valid list
    my %ValidList = $Self->{ValidObject}->ValidList();

    for my $QueueID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

        # get queue data
        my %Data = $Self->{QueueObject}->QueueGet(
            ID => $QueueID,
        );

        # group lookup
        $Data{GroupName} = $Self->{GroupObject}->GroupLookup(
            GroupID => $Data{GroupID},
        );

        $Self->{LayoutObject}->Block(
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
