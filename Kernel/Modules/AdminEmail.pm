# --
# Kernel/Modules/AdminEmail.pm - to send a email to all agents
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;
use warnings;

use Kernel::System::Email;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{SendmailObject} = Kernel::System::Email->new(%Param);

    if ( $Self->{ConfigObject}->Get('CustomerGroupSupport') ) {
        $Self->{CustomerUserObject}  = Kernel::System::CustomerUser->new(%Param);
        $Self->{CustomerGroupObject} = Kernel::System::CustomerGroup->new(%Param);
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    my $Note = '';
    my ( %GetParam, %Errors );

    for my $Parameter (qw(From Subject Body Bcc GroupPermission NotifyCustomerUsers)) {
        $Param{$Parameter}
            = $Self->{ParamObject}->GetParam( Param => $Parameter )
            || $Param{$Parameter}
            || '';
    }

    # ------------------------------------------------------------ #
    # send email
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Send' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check needed stuff
        for my $Needed (qw(From Subject Body GroupPermission)) {
            if ( !$Param{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # get array params
        for my $Parameter (qw(UserIDs GroupIDs RoleIDs)) {
            if ( $Self->{ParamObject}->GetArray( Param => $Parameter ) ) {
                @{ $GetParam{$Parameter} } = $Self->{ParamObject}->GetArray( Param => $Parameter );
            }
        }

        if ( !%Errors ) {

            # get user recipients address
            my %Bcc;
            for my $UserID ( $Self->{ParamObject}->GetArray( Param => 'UserIDs' ) ) {
                my %UserData = $Self->{UserObject}->GetUserData(
                    UserID => $UserID,
                    Valid  => 1,
                );
                if ( $UserData{UserEmail} ) {
                    $Bcc{ $UserData{UserLogin} } = $UserData{UserEmail};
                }
            }

            # get group recipients address
            for my $GroupID ( $Self->{ParamObject}->GetArray( Param => 'GroupIDs' ) ) {
                my @GroupMemberList = $Self->{GroupObject}->GroupMemberList(
                    Result  => 'ID',
                    Type    => $Param{GroupPermission},
                    GroupID => $GroupID,
                );
                for my $GroupMember (@GroupMemberList) {
                    my %UserData = $Self->{UserObject}->GetUserData(
                        UserID => $GroupMember,
                        Valid  => 1,
                    );
                    if ( $UserData{UserEmail} && $UserData{UserID} != 1 ) {
                        $Bcc{ $UserData{UserLogin} } = $UserData{UserEmail};
                    }
                }
            }

            # get customerusers that are a member of the groups
            if ( $Param{NotifyCustomerUsers} ) {
                for my $GroupID ( $Self->{ParamObject}->GetArray( Param => 'GroupIDs' ) ) {
                    my @GroupCustomerUserMemberList = $Self->{CustomerGroupObject}->GroupMemberList(
                        Result  => 'ID',
                        Type    => $Param{GroupPermission},
                        GroupID => $GroupID,
                    );
                    for my $GoupCustomerUserMember (@GroupCustomerUserMemberList) {
                        my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                            User  => $GoupCustomerUserMember,
                            Valid => 1,
                        );
                        if ( $CustomerUserData{UserEmail} ) {
                            $Bcc{ $CustomerUserData{UserLogin} } = $CustomerUserData{UserEmail};
                        }
                    }
                }
            }

            # get role recipients addresses
            for my $RoleID ( $Self->{ParamObject}->GetArray( Param => 'RoleIDs' ) ) {
                my @RoleMemberList = $Self->{GroupObject}->GroupUserRoleMemberList(
                    Result => 'ID',
                    RoleID => $RoleID,
                );
                for my $RoleMember (@RoleMemberList) {
                    my %UserData = $Self->{UserObject}->GetUserData(
                        UserID => $RoleMember,
                        Valid  => 1,
                    );
                    if ( $UserData{UserEmail} ) {
                        $Bcc{ $UserData{UserLogin} } = $UserData{UserEmail};
                    }
                }
            }
            for my $BccKey ( sort keys %Bcc ) {
                $Param{Bcc} .= $Bcc{$BccKey} . ', ';
            }

            # check needed stuff
            if ( !$Param{Bcc} ) {
                $Note = $Self->{LayoutObject}->Notify(
                    Priority => 'Error',
                    Info     => 'Select at least one recipient.'
                );
                $Errors{BccInvalid} = 'ServerError';
            }

            # if no errors occurred
            if ( !%Errors ) {

                # clean up
                $Param{Body} =~ s/(\r\n|\n\r)/\n/g;
                $Param{Body} =~ s/\r/\n/g;

                # get content type
                my $ContentType = 'text/plain';
                if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                    $ContentType = 'text/html';

                    # verify html document
                    $Param{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                        String => $Param{Body},
                    );
                }

                # send mail
                my $Sent = $Self->{SendmailObject}->Send(
                    From     => $Param{From},
                    Bcc      => $Param{Bcc},
                    Subject  => $Param{Subject},
                    Charset  => $Self->{LayoutObject}->{UserCharset},
                    MimeType => $ContentType,
                    Body     => $Param{Body},
                );
                if ( !$Sent ) {
                    return $Self->{LayoutObject}->ErrorScreen();
                }

                $Self->{LayoutObject}->Block(
                    Name => 'Sent',
                    Data => \%Param,
                );
                my $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->NavigationBar();
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AdminEmail',
                    Data         => \%Param,
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
    }

    # ------------------------------------------------------------ #
    # show mask
    # ------------------------------------------------------------ #

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }
    $Param{UserOption} = $Self->{LayoutObject}->BuildSelection(
        Data => { $Self->{UserObject}->UserList( Valid => 1 ) },
        Name => 'UserIDs',
        Size => 6,
        Multiple    => 1,
        Translation => 0,
        Class       => $Errors{BccInvalid} || '',
    );

    $Param{GroupOption} = $Self->{LayoutObject}->BuildSelection(
        Data => { $Self->{GroupObject}->GroupList( Valid => 1 ) },
        Size => 6,
        Name => 'GroupIDs',
        Multiple    => 1,
        Translation => 0,
        Class       => $Errors{BccInvalid} || '',
    );
    my %RoleList = $Self->{GroupObject}->RoleList( Valid => 1 );
    $Param{RoleOption} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%RoleList,
        Size        => 6,
        Name        => 'RoleIDs',
        Multiple    => 1,
        Translation => 0,
        Class       => $Errors{BccInvalid} || '',
    );

    $Self->{LayoutObject}->Block(
        Name => 'Form',
        Data => {
            %Param,
            %Errors,
        },
    );

    if (%RoleList) {
        $Self->{LayoutObject}->Block(
            Name => 'RoleRecipients',
            Data => \%Param,
        );
    }

    if ( $Self->{ConfigObject}->Get('CustomerGroupSupport') ) {
        $Self->{LayoutObject}->Block(
            Name => 'CustomerUserGroups',
            Data => \%Param,
        );
    }
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Note;
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminEmail',
        Data         => {
            %Param,
            %Errors,
        },
    );
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
