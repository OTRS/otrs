# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminEmail;

use strict;
use warnings;

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
    my $Note = '';
    my ( %GetParam, %Errors );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $UserObject   = $Kernel::OM->Get('Kernel::System::User');
    my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

    for my $Parameter (qw(From Subject Body Bcc GroupPermission NotifyCustomerUsers)) {
        $Param{$Parameter} = $ParamObject->GetParam( Param => $Parameter )
            || $Param{$Parameter}
            || '';
    }

    # ------------------------------------------------------------ #
    # send email
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Send' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # check needed stuff
        for my $Needed (qw(From Subject Body GroupPermission)) {
            if ( !$Param{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # get array params
        for my $Parameter (qw(UserIDs GroupIDs RoleIDs)) {
            if ( $ParamObject->GetArray( Param => $Parameter ) ) {
                @{ $GetParam{$Parameter} } = $ParamObject->GetArray( Param => $Parameter );
            }
        }

        if ( !%Errors ) {

            # get user recipients address
            my %Bcc;
            for my $UserID ( $ParamObject->GetArray( Param => 'UserIDs' ) ) {
                my %UserData = $UserObject->GetUserData(
                    UserID => $UserID,
                    Valid  => 1,
                );
                if ( $UserData{UserEmail} ) {
                    $Bcc{ $UserData{UserLogin} } = $UserData{UserEmail};
                }
            }

            # get group recipients address
            for my $GroupID ( $ParamObject->GetArray( Param => 'GroupIDs' ) ) {

                my %UserList = $GroupObject->PermissionGroupGet(
                    GroupID => $GroupID,
                    Type    => $Param{GroupPermission},
                );

                my @GroupMemberList = sort keys %UserList;

                for my $GroupMember (@GroupMemberList) {
                    my %UserData = $UserObject->GetUserData(
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
                for my $GroupID ( $ParamObject->GetArray( Param => 'GroupIDs' ) ) {
                    my @GroupCustomerUserMemberList
                        = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberList(
                        Result  => 'ID',
                        Type    => $Param{GroupPermission},
                        GroupID => $GroupID,
                        );
                    for my $GoupCustomerUserMember (@GroupCustomerUserMemberList) {
                        my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
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
            for my $RoleID ( $ParamObject->GetArray( Param => 'RoleIDs' ) ) {

                my %RoleMemberList = $GroupObject->PermissionRoleUserGet(
                    RoleID => $RoleID,
                );

                for my $RoleMember ( sort keys %RoleMemberList ) {

                    my %UserData = $UserObject->GetUserData(
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
                $Note = $LayoutObject->Notify(
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
                if ( $LayoutObject->{BrowserRichText} ) {
                    $ContentType = 'text/html';

                    # verify html document
                    $Param{Body} = $LayoutObject->RichTextDocumentComplete(
                        String => $Param{Body},
                    );
                }

                # send mail
                my $Sent = $Kernel::OM->Get('Kernel::System::Email')->Send(
                    From     => $Param{From},
                    Bcc      => $Param{Bcc},
                    Subject  => $Param{Subject},
                    Charset  => $LayoutObject->{UserCharset},
                    MimeType => $ContentType,
                    Body     => $Param{Body},
                );
                if ( !$Sent ) {
                    return $LayoutObject->ErrorScreen();
                }

                $LayoutObject->Block(
                    Name => 'Sent',
                    Data => \%Param,
                );
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminEmail',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }
    }

    # ------------------------------------------------------------ #
    # show mask
    # ------------------------------------------------------------ #

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {
        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }
    $Param{UserOption} = $LayoutObject->BuildSelection(
        Data        => { $UserObject->UserList( Valid => 1 ) },
        Name        => 'UserIDs',
        Size        => 6,
        Multiple    => 1,
        Translation => 0,
        Class => 'Modernize ' . ( $Errors{BccInvalid} || '' ),
    );

    $Param{GroupOption} = $LayoutObject->BuildSelection(
        Data        => { $GroupObject->GroupList( Valid => 1 ) },
        Size        => 6,
        Name        => 'GroupIDs',
        Multiple    => 1,
        Translation => 0,
        Class => 'Modernize ' . ( $Errors{BccInvalid} || '' ),
    );
    my %RoleList = $GroupObject->RoleList( Valid => 1 );
    $Param{RoleOption} = $LayoutObject->BuildSelection(
        Data        => \%RoleList,
        Size        => 6,
        Name        => 'RoleIDs',
        Multiple    => 1,
        Translation => 0,
        Class       => 'Modernize ' . ( $Errors{BccInvalid} || '' ),
    );

    $LayoutObject->Block(
        Name => 'Form',
        Data => {
            %Param,
            %Errors,
        },
    );

    if (%RoleList) {
        $LayoutObject->Block(
            Name => 'RoleRecipients',
            Data => \%Param,
        );
    }

    if ( $Kernel::OM->Get('Kernel::Config')->Get('CustomerGroupSupport') ) {
        $LayoutObject->Block(
            Name => 'CustomerUserGroups',
            Data => \%Param,
        );
    }
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Note;
    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminEmail',
        Data         => {
            %Param,
            %Errors,
        },
    );
    $Output .= $LayoutObject->Footer();
    return $Output;
}

1;
