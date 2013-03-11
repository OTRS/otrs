# --
# Kernel/Modules/AdminNotification.pm - provides admin notification translations
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminNotification;

use strict;
use warnings;

use Kernel::System::Notification;
use Kernel::System::HTMLUtils;

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ParamObject DBObject LayoutObject ConfigObject LogObject)) {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{NotificationObject} = Kernel::System::Notification->new(%Param);
    $Self->{HTMLUtilsObject}    = Kernel::System::HTMLUtils->new(%Param);

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my @Params = (qw(Name Type Charset Language Subject Body UserID LanguageSelection));
    my %GetParam;
    my $Note = '';
    for my $Parameter (@Params) {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
    }
    if ( !$GetParam{Language} && $GetParam{Name} ) {
        if ( $GetParam{Name} =~ /^(.+?)(::.*)/ ) {
            $GetParam{Language} = $1;
        }
    }

    # get content type
    my $ContentType = 'text/plain';
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $ContentType = 'text/html';
    }

    # ------------------------------------------------------------ #
    # Select language action
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'SelectLanguage' ) {
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_MaskNotificationForm(
            %GetParam,
            %Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;

    }

    # ------------------------------------------------------------ #
    # get data 2 form
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my %Notification = $Self->{NotificationObject}->NotificationGet(%GetParam);
        my $Output       = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_MaskNotificationForm(
            %GetParam,
            %Param,
            %Notification,
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

        my %Errors;
        my $Update;

        # check for needed data
        for my $Needed (qw(Subject Body)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        if ( !%Errors ) {
            $Update = $Self->{NotificationObject}->NotificationUpdate(
                %GetParam,
                ContentType => $ContentType,
                UserID      => $Self->{UserID},
            );
            if ($Update) {
                $Note = $Self->{LayoutObject}->Notify( Info => 'Notification updated!' );
            }
        }

        if ( %Errors || !$Update ) {
            my %Notification = $Self->{NotificationObject}->NotificationGet(%GetParam);
            my $Output       = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->_MaskNotificationForm(
                %GetParam,
                %Param,
                %Notification,
                %Errors,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # else ! print form
    # ------------------------------------------------------------ #
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Output .= $Note;
    $Self->{Action}    = 'AdminNotification';
    $Self->{Subaction} = '';
    $Output .= $Self->_MaskNotificationForm();
    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

sub _MaskNotificationForm {
    my ( $Self, %Param ) = @_;

    # get lenguages
    my %Languages        = %{ $Self->{ConfigObject}->{DefaultUsedLanguages} };
    my %UserData         = $Self->{UserObject}->GetUserData( UserID => $Self->{UserID} );
    my $SelectedLanguage = $Param{LanguageSelection}
        || $UserData{UserLanguage}
        || $Self->{ConfigObject}->{DefaultLanguage};

    # build LanguageOption string
    $Param{LanguageOption} = $Self->{LayoutObject}->BuildSelection(
        Data        => {%Languages},
        Name        => 'LanguageSelection',
        SelectedID  => $SelectedLanguage,
        Translation => 0,
        HTMLQuote   => 0,
    );

    $Self->{LayoutObject}->Block(
        Name => 'ActionList',
    );

    #Show update form
    if ( $Self->{Subaction} eq 'SelectLanguage' || !$Self->{Subaction} ) {

        $Self->{LayoutObject}->Block(
            Name => 'ActionLanguageOptions',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'NotificationFilter',
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewResult',
        );

        # get Notifications
        my %NotificationList = $Self->{NotificationObject}->NotificationList();

        for my $Notification ( sort { lc($a) cmp lc($b) } keys %NotificationList ) {
            $Notification =~ /^(\w+)::(.*)$/;
            my $LanguageKey      = $1;
            my $NotificationType = $2;
            next if $LanguageKey ne $SelectedLanguage;
            $Self->{LayoutObject}->Block(
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

        $Self->{LayoutObject}->Block(
            Name => 'ActionOverview',
        );
        $Self->{LayoutObject}->Block(
            Name => 'OverviewUpdate',
            Data => \%Param,
        );

        # add rich text editor
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $Self->{LayoutObject}->Block(
                Name => 'RichText',
                Data => \%Param,
            );

            # reformat from plain to html
            if ( $Param{ContentType} && $Param{ContentType} =~ /text\/plain/i ) {
                $Param{Body} = $Self->{HTMLUtilsObject}->ToHTML(
                    String => $Param{Body},
                );
            }
        }
        else {

            # reformat from html to plain
            if ( $Param{ContentType} && $Param{ContentType} =~ /text\/html/i ) {
                $Param{Body} = $Self->{HTMLUtilsObject}->ToAscii(
                    String => $Param{Body},
                );
            }
        }
    }

    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminNotification',
        Data         => \%Param
    );
}

1;
