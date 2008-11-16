# --
# Kernel/Modules/AdminQueue.pm - to add/update/delete queues
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AdminQueue.pm,v 1.43.2.1 2008-11-16 18:17:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AdminQueue;

use strict;
use warnings;

use Kernel::System::Crypt;
use Kernel::System::Valid;
use Kernel::System::Salutation;
use Kernel::System::Signature;
use Kernel::System::SystemAddress;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.43.2.1 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject MainObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);
    $Self->{SalutationObject}    = Kernel::System::Salutation->new(%Param);
    $Self->{SignatureObject}     = Kernel::System::Signature->new(%Param);
    $Self->{SystemAddressObject} = Kernel::System::SystemAddress->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    $Param{NextScreen} = 'AdminQueue';
    my $QueueID = $Self->{ParamObject}->GetParam( Param => 'QueueID' ) || '';

    my @Params = (
        qw(
            QueueID           ParentQueueID       Name            GroupID
            UnlockTimeout     FollowUpLock        SystemAddressID Calendar
            DefaultSignKey    SalutationID        SignatureID     FollowUpID
            FirstResponseTime FirstResponseNotify UpdateTime      UpdateNotify
            SolutionTime      SolutionNotify
            MoveNotify        StateNotify         LockNotify      OwnerNotify
            Comment           ValidID
            )
    );

    # get possible sign keys
    my %KeyList = ();
    if ($QueueID) {
        my %QueueData = $Self->{QueueObject}->QueueGet( ID => $QueueID );
        my $CryptObjectPGP = Kernel::System::Crypt->new( %{$Self}, CryptType => 'PGP' );
        if ($CryptObjectPGP) {
            my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch( Search => $QueueData{Email}, );
            for my $DataRef (@PrivateKeys) {
                $KeyList{"PGP::Inline::$DataRef->{Key}"}
                    = "PGP-Inline: $DataRef->{Key} $DataRef->{Identifier}";
                $KeyList{"PGP::Detached::$DataRef->{Key}"}
                    = "PGP-Detached: $DataRef->{Key} $DataRef->{Identifier}";
            }
        }
        my $CryptObjectSMIME = Kernel::System::Crypt->new( %{$Self}, CryptType => 'SMIME' );
        if ($CryptObjectSMIME) {
            my @PrivateKeys = $CryptObjectSMIME->PrivateSearch( Search => $QueueData{Email}, );
            for my $DataRef (@PrivateKeys) {
                $KeyList{"SMIME::Detached::$DataRef->{Hash}"}
                    = "SMIME-Detached: $DataRef->{Hash} $DataRef->{Email}";
            }
        }
    }

    # get data
    if ( $Self->{Subaction} eq 'Change' ) {
        my %QueueData = $Self->{QueueObject}->QueueGet( ID => $QueueID );
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask( %Param, %QueueData, DefaultSignKeyList => \%KeyList );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # update action
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {
        my $Note = '';
        my %GetParam;
        for (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # check queue name
        if ( $GetParam{Name} =~ /::/ ) {
            $Output = $Self->{LayoutObject}->Header();
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
        if ( $Self->{QueueObject}->QueueUpdate( %GetParam, UserID => $Self->{UserID} ) ) {

            # update preferences
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $GetParam{QueueID} );
            my %Preferences = ();
            if ( $Self->{ConfigObject}->Get('QueuePreferences') ) {
                %Preferences = %{ $Self->{ConfigObject}->Get('QueuePreferences') };
            }
            for my $Item ( sort keys %Preferences ) {
                my $Module = $Preferences{$Item}->{Module}
                    || 'Kernel::Output::HTML::QueuePreferencesGeneric';

                # load module
                if ( $Self->{MainObject}->Require($Module) ) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Item},
                        Debug      => $Self->{Debug},
                    );
                    my @Params = $Object->Param( QueueData => \%QueueData );
                    if (@Params) {
                        my %GetParam = ();
                        for my $ParamItem (@Params) {
                            my @Array
                                = $Self->{ParamObject}->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if ( !$Object->Run( GetParam => \%GetParam, QueueData => \%QueueData ) ) {
                            $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                        }
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Param{NextScreen}" );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # add new queue
    elsif ( $Self->{Subaction} eq 'AddAction' ) {
        my $Note = '';
        my %GetParam;
        for (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # check queue name
        if ( $GetParam{Name} =~ /::/ ) {
            $Output = $Self->{LayoutObject}->Header();
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

        # create new queue
        if ( my $Id = $Self->{QueueObject}->QueueAdd( %GetParam, UserID => $Self->{UserID} ) ) {

            # update preferences
            my %QueueData = $Self->{QueueObject}->QueueGet( ID => $Id );
            my %Preferences = ();
            if ( $Self->{ConfigObject}->Get('QueuePreferences') ) {
                %Preferences = %{ $Self->{ConfigObject}->Get('QueuePreferences') };
            }
            for my $Item ( keys %Preferences ) {
                my $Module = $Preferences{$Item}->{Module}
                    || 'Kernel::Output::HTML::QueuePreferencesGeneric';

                # load module
                if ( $Self->{MainObject}->Require($Module) ) {
                    my $Object = $Module->new(
                        %{$Self},
                        ConfigItem => $Preferences{$Item},
                        Debug      => $Self->{Debug},
                    );
                    my @Params = $Object->Param( QueueData => \%QueueData );
                    if (@Params) {
                        my %GetParam = ();
                        for my $ParamItem (@Params) {
                            my @Array
                                = $Self->{ParamObject}->GetArray( Param => $ParamItem->{Name} );
                            $GetParam{ $ParamItem->{Name} } = \@Array;
                        }
                        if ( !$Object->Run( GetParam => \%GetParam, QueueData => \%QueueData ) ) {
                            $Note .= $Self->{LayoutObject}->Notify( Info => $Object->Error() );
                        }
                    }
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }

            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminQueueResponses&Subaction=Queue&ID=$Id",
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }

    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => { $Self->{ValidObject}->ValidList(), },
        Name       => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'GroupOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            $Self->{DBObject}->GetTableData(
                What  => 'id, name',
                Table => 'groups',
                Valid => 1,
            ),
        },
        LanguageTranslation => 0,
        Name                => 'GroupID',
        SelectedID          => $Param{GroupID},
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

    my %Data = $Self->{QueueObject}->QueueList( Valid => 1 );
    my $QueueName = '';
    for my $Key ( keys %Data ) {
        if ( $Param{QueueID} && $Param{QueueID} eq $Key ) {
            $QueueName = $Data{ $Param{QueueID} };
            last;
        }
    }
    my %CleanHash = %Data;
    for my $Key ( keys %Data ) {
        if ( $CleanHash{$Key} eq $QueueName || $CleanHash{$Key} =~ /^$QueueName\:\:/ ) {
            delete( $CleanHash{$Key} );
        }
    }
    $Param{'QueueOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { %CleanHash, '' => '-', },
        Name => 'ParentQueueID',
        Selected       => $ParentQueue,
        MaxLevel       => 4,
        OnChangeSubmit => 0,
    );
    $Param{'QueueLongOption'} = $Self->{LayoutObject}->AgentQueueListOption(
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
        Name         => 'FirstResponseNotify',
        SelectedID   => $Param{FirstResponseNotify},
        PossibleNone => 1,
    );
    $Param{UpdateNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%NotifyLevelList,
        Name         => 'UpdateNotify',
        SelectedID   => $Param{UpdateNotify},
        PossibleNone => 1,
    );
    $Param{SolutionNotifyOptionStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%NotifyLevelList,
        Name         => 'SolutionNotify',
        SelectedID   => $Param{SolutionNotify},
        PossibleNone => 1,
    );
    $Param{'SignatureOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{SignatureObject}->SignatureList( Valid => 1 ), },
        Name => 'SignatureID',
        SelectedID => $Param{SignatureID},
    );
    $Param{'FollowUpLockYesNoOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'FollowUpLock',
        SelectedID => $Param{FollowUpLock},
    );

    $Param{'SystemAddressOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{SystemAddressObject}->SystemAddressList( Valid => 1 ), },
        Name => 'SystemAddressID',
        SelectedID => $Param{SystemAddressID},
    );

    my %DefaultSignKeyList = ();
    if ( $Param{DefaultSignKeyList} ) {
        %DefaultSignKeyList = %{ $Param{DefaultSignKeyList} };
    }
    $Param{'DefaultSignKeyOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
            '' => '-none-',
            %DefaultSignKeyList
        },
        Name       => 'DefaultSignKey',
        Max        => 50,
        SelectedID => $Param{DefaultSignKey},
    );
    $Param{'SalutationOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { $Self->{SalutationObject}->SalutationList( Valid => 1 ), },
        Name => 'SalutationID',
        SelectedID => $Param{SalutationID},
    );
    $Param{'FollowUpOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
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
    );
    $Param{'MoveOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'MoveNotify',
        SelectedID => $Param{MoveNotify},
    );
    $Param{'StateOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'StateNotify',
        SelectedID => $Param{StateNotify},
    );
    $Param{'OwnerOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'OwnerNotify',
        SelectedID => $Param{OwnerNotify},
    );
    $Param{'LockOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name       => 'LockNotify',
        SelectedID => $Param{LockNotify},
    );
    my %Calendar = ( '' => '-' );

    for ( '', 1 .. 50 ) {
        if ( $Self->{ConfigObject}->Get("TimeVacationDays::Calendar$_") ) {
            $Calendar{$_} = "Calendar $_ - "
                . $Self->{ConfigObject}->Get( "TimeZone::Calendar" . $_ . "Name" );
        }
    }
    $Param{'CalendarOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data       => \%Calendar,
        Name       => 'Calendar',
        SelectedID => $Param{Calendar},
    );

    # show each preferences setting
    my %Preferences = ();
    if ( $Self->{ConfigObject}->Get('QueuePreferences') ) {
        %Preferences = %{ $Self->{ConfigObject}->Get('QueuePreferences') };
    }
    for my $Item ( sort keys %Preferences ) {
        my $Module = $Preferences{$Item}->{Module}
            || 'Kernel::Output::HTML::QueuePreferencesGeneric';

        # load module
        if ( $Self->{MainObject}->Require($Module) ) {
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
                        ref( $ParamItem->{Data} ) eq 'HASH'
                        || ref( $Preferences{$Item}->{Data} ) eq 'HASH'
                        )
                    {
                        $ParamItem->{'Option'} = $Self->{LayoutObject}->OptionStrgHashRef(
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
        else {
            return $Self->{LayoutObject}->FatalError();
        }
    }

    return $Self->{LayoutObject}->Output( TemplateFile => 'AdminQueueForm', Data => \%Param );
}

1;
