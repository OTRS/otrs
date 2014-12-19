# --
# Kernel/Modules/AdminNotification.pm - provides admin notification translations
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminNotification;

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

    my $LayoutObject       = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $NotificationObject = $Kernel::OM->Get('Kernel::System::Notification');

    my @Params = (qw(Name Type Charset Language Subject Body UserID LanguageSelection));
    my %GetParam;
    my $Note = '';
    for my $Parameter (@Params) {
        $GetParam{$Parameter} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $Parameter ) || '';
    }
    if ( !$GetParam{Language} && $GetParam{Name} ) {
        if ( $GetParam{Name} =~ /^(.+?)(::.*)/ ) {
            $GetParam{Language} = $1;
        }
    }

    # get content type
    my $ContentType = 'text/plain';
    if ( $LayoutObject->{BrowserRichText} ) {
        $ContentType = 'text/html';
    }

    # ------------------------------------------------------------ #
    # Select language action
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'SelectLanguage' ) {
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_MaskNotificationForm(
            %GetParam,
            %Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;

    }

    # ------------------------------------------------------------ #
    # get data 2 form
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my %Notification = $NotificationObject->NotificationGet(%GetParam);
        my $Output       = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $Self->_MaskNotificationForm(
            %GetParam,
            %Param,
            %Notification,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # update action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my %Errors;
        my $Update;

        # check for needed data
        for my $Needed (qw(Subject Body)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        if ( !%Errors ) {
            $Update = $NotificationObject->NotificationUpdate(
                %GetParam,
                ContentType => $ContentType,
                UserID      => $Self->{UserID},
            );
            if ($Update) {
                $Note = $LayoutObject->Notify( Info => 'Notification updated!' );
            }
        }

        if ( %Errors || !$Update ) {
            my %Notification = $NotificationObject->NotificationGet(%GetParam);
            my $Output       = $LayoutObject->Header();
            $Output .= $LayoutObject->NavigationBar();
            $Output .= $Self->_MaskNotificationForm(
                %GetParam,
                %Param,
                %Notification,
                %Errors,
            );
            $Output .= $LayoutObject->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # else ! print form
    # ------------------------------------------------------------ #
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Note;
    $Self->{Action}    = 'AdminNotification';
    $Self->{Subaction} = '';
    $Output .= $Self->_MaskNotificationForm();
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _MaskNotificationForm {
    my ( $Self, %Param ) = @_;

    my $LayoutObject    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');

    # get lenguages
    my %Languages        = %{ $ConfigObject->{DefaultUsedLanguages} };
    my %UserData         = $Kernel::OM->Get('Kernel::System::User')->GetUserData( UserID => $Self->{UserID} );
    my $SelectedLanguage = $Param{LanguageSelection}
        || $UserData{UserLanguage}
        || $ConfigObject->{DefaultLanguage};

    # build LanguageOption string
    $Param{LanguageOption} = $LayoutObject->BuildSelection(
        Data        => {%Languages},
        Name        => 'LanguageSelection',
        SelectedID  => $SelectedLanguage,
        Translation => 0,
        HTMLQuote   => 0,
    );

    $LayoutObject->Block(
        Name => 'ActionList',
    );

    #Show update form
    if ( $Self->{Subaction} eq 'SelectLanguage' || !$Self->{Subaction} ) {

        $LayoutObject->Block(
            Name => 'ActionLanguageOptions',
            Data => \%Param,
        );
        $LayoutObject->Block(
            Name => 'NotificationFilter',
        );
        $LayoutObject->Block(
            Name => 'OverviewResult',
        );

        # get Notifications
        my %NotificationList = $Kernel::OM->Get('Kernel::System::Notification')->NotificationList();

        NOTIFICATION:
        for my $Notification ( sort { lc($a) cmp lc($b) } keys %NotificationList ) {
            $Notification =~ /^(\w+)::(.*)$/;
            my $LanguageKey      = $1;
            my $NotificationType = $2;
            next NOTIFICATION if $LanguageKey ne $SelectedLanguage;
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Language => $Languages{$LanguageKey},
                    Type     => $NotificationType,
                    Name     => $Notification,
                },
            );
        }
    }
    else {

        $LayoutObject->Block(
            Name => 'ActionOverview',
        );
        $LayoutObject->Block(
            Name => 'OverviewUpdate',
            Data => \%Param,
        );

        # add rich text editor
        if ( $LayoutObject->{BrowserRichText} ) {
            $LayoutObject->Block(
                Name => 'RichText',
                Data => \%Param,
            );

            # reformat from plain to html
            if ( $Param{ContentType} && $Param{ContentType} =~ /text\/plain/i ) {
                $Param{Body} = $HTMLUtilsObject->ToHTML(
                    String => $Param{Body},
                );
            }
        }
        else {

            # reformat from html to plain
            if ( $Param{ContentType} && $Param{ContentType} =~ /text\/html/i ) {
                $Param{Body} = $HTMLUtilsObject->ToAscii(
                    String => $Param{Body},
                );
            }
        }
    }

    return $LayoutObject->Output(
        TemplateFile => 'AdminNotification',
        Data         => \%Param
    );
}

1;
