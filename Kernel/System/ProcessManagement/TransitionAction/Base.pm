# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::ProcessManagement::TransitionAction::Base;

use strict;
use warnings;

use utf8;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DynamicField',
    'Kernel::System::DynamicField::Backend',
    'Kernel::System::Encode',
    'Kernel::System::HTMLUtils',
    'Kernel::System::Log',
    'Kernel::System::TemplateGenerator',
    'Kernel::System::Ticket::Article',
    'Kernel::System::User',
);

sub _CheckParams {
    my ( $Self, %Param ) = @_;

    my $CommonMessage = $Param{CommonMessage};

    for my $Needed (
        qw(UserID Ticket ProcessEntityID ActivityEntityID TransitionEntityID
        TransitionActionEntityID Config
        )
        )
    {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check if we have Ticket to deal with
    if ( !IsHashRefWithData( $Param{Ticket} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "Ticket has no values!",
        );
        return;
    }

    # Check if we have a ConfigHash
    if ( !IsHashRefWithData( $Param{Config} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => $CommonMessage . "Config has no values!",
        );
        return;
    }

    return 1;
}

sub _OverrideUserID {
    my ( $Self, %Param ) = @_;

    if ( IsNumber( $Param{Config}->{UserID} ) ) {
        $Param{UserID} = $Param{Config}->{UserID};
        delete $Param{Config}->{UserID};
    }

    return $Param{UserID};
}

sub _ReplaceTicketAttributes {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $DynamicFieldObject        = $Kernel::OM->Get('Kernel::System::DynamicField');
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    for my $Attribute ( sort keys %{ $Param{Config} } ) {

        # Replace ticket attributes such as
        # <OTRS_Ticket_DynamicField_Name1> or <OTRS_TICKET_DynamicField_Name1>
        # or
        # <OTRS_TICKET_DynamicField_Name1_Value> or <OTRS_Ticket_DynamicField_Name1_Value>.
        # <OTRS_Ticket_*> is deprecated and should be removed in further versions of OTRS.
        my $Count = 0;
        REPLACEMENT:
        while (
            $Param{Config}->{$Attribute}
            && $Param{Config}->{$Attribute} =~ m{<OTRS_TICKET_([A-Za-z0-9_]+)>}msxi
            && $Count++ < 1000
            )
        {
            my $TicketAttribute = $1;

            if ( $TicketAttribute =~ m{DynamicField_(\S+?)_Value} ) {
                my $DynamicFieldName = $1;

                my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                    Name => $DynamicFieldName,
                );
                next REPLACEMENT if !$DynamicFieldConfig;

                # Get the display value for each dynamic field.
                my $DisplayValue = $DynamicFieldBackendObject->ValueLookup(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Key                => $Param{Ticket}->{"DynamicField_$DynamicFieldName"},
                );

                my $DisplayValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $DisplayValue,
                );

                $Param{Config}->{$Attribute}
                    =~ s{<OTRS_TICKET_$TicketAttribute>}{$DisplayValueStrg->{Value} // ''}ige;

                next REPLACEMENT;
            }
            elsif ( $TicketAttribute =~ m{DynamicField_(\S+)} ) {
                my $DynamicFieldName = $1;

                my $DynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
                    Name => $DynamicFieldName,
                );
                next REPLACEMENT if !$DynamicFieldConfig;

                # Get the readable value (key) for each dynamic field.
                my $ValueStrg = $DynamicFieldBackendObject->ReadableValueRender(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    Value              => $Param{Ticket}->{"DynamicField_$DynamicFieldName"},
                );

                $Param{Config}->{$Attribute}
                    =~ s{<OTRS_TICKET_$TicketAttribute>}{$ValueStrg->{Value} // ''}ige;

                next REPLACEMENT;
            }

            # if ticket value is scalar substitute all instances (as strings)
            # this will allow replacements for "<OTRS_TICKET_Title> <OTRS_TICKET_Queue"
            if ( !ref $Param{Ticket}->{$TicketAttribute} ) {
                $Param{Config}->{$Attribute}
                    =~ s{<OTRS_TICKET_$TicketAttribute>}{$Param{Ticket}->{$TicketAttribute} // ''}ige;
            }
            else {

                # if the vale is an array (e.g. a multiselect dynamic field) set the value directly
                # this unfortunately will not let a combination of values to be replaced
                $Param{Config}->{$Attribute} = $Param{Ticket}->{$TicketAttribute};
            }
        }
    }

    return 1;
}

sub _ReplaceAdditionalAttributes {
    my ( $Self, %Param ) = @_;

    # get system default language
    my %User;
    if ( $Param{UserID} ) {
        %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
            UserID => $Param{UserID},
        );
    }

    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $DefaultLanguage = $ConfigObject->Get('DefaultLanguage') || 'en';
    my $Language        = $User{UserLanguage} || $DefaultLanguage;

    # get and store richtext information
    my $RichText = $ConfigObject->Get('Frontend::RichText');

    # Determine if RichText (text/html) is used in the config as well.
    #   If not, we have to deactivate it, otherwise HTML content and plain text are mixed up (see bug#13764).
    if ($RichText) {

        # Check for ContentType or MimeType.
        if (
            ( IsStringWithData( $Param{Config}->{ContentType} ) && $Param{Config}->{ContentType} !~ m{text/html}i )
            || ( IsStringWithData( $Param{Config}->{MimeType} ) && $Param{Config}->{MimeType} !~ m{text/html}i )
            )
        {
            $RichText = 0;
        }
    }

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    # get last customer article
    my @ArticleListCustomer = $ArticleObject->ArticleList(
        TicketID   => $Param{Ticket}->{TicketID},
        SenderType => 'customer',
        OnlyLast   => 1,
    );

    my %ArticleCustomer;
    if (@ArticleListCustomer) {
        %ArticleCustomer = $ArticleObject->BackendForArticle( %{ $ArticleListCustomer[0] } )->ArticleGet(
            %{ $ArticleListCustomer[0] },
            DynamicFields => 0,
        );
    }

    # get last agent article
    my @ArticleListAgent = $ArticleObject->ArticleList(
        TicketID   => $Param{Ticket}->{TicketID},
        SenderType => 'agent',
        OnlyLast   => 1,
    );

    my %ArticleAgent;
    if (@ArticleListAgent) {
        %ArticleAgent = $ArticleObject->BackendForArticle( %{ $ArticleListAgent[0] } )->ArticleGet(
            %{ $ArticleListAgent[0] },
            DynamicFields => 0,
        );
    }

    my $HTMLUtilsObject = $Kernel::OM->Get('Kernel::System::HTMLUtils');

    # set the accounted time as part of the article information
    ARTICLEDATA:
    for my $ArticleData ( \%ArticleCustomer, \%ArticleAgent ) {

        next ARTICLEDATA if !$ArticleData->{ArticleID};

        my $AccountedTime = $ArticleObject->ArticleAccountedTimeGet(
            ArticleID => $ArticleData->{ArticleID},
        );

        $ArticleData->{TimeUnit} = $AccountedTime;

        my $ArticleBackendObject = $ArticleObject->BackendForArticle(
            ArticleID => $ArticleData->{ArticleID},
            TicketID  => $Param{Ticket}->{TicketID},
        );

        # get richtext body for customer and agent article
        if ($RichText) {

            # check if there are HTML body attachments
            my %AttachmentIndexHTMLBody = $ArticleBackendObject->ArticleAttachmentIndex(
                ArticleID    => $ArticleData->{ArticleID},
                OnlyHTMLBody => 1,
            );

            my @HTMLBodyAttachmentIDs = sort keys %AttachmentIndexHTMLBody;

            if ( $HTMLBodyAttachmentIDs[0] ) {

                my %AttachmentHTML = $ArticleBackendObject->ArticleAttachment(
                    TicketID  => $Param{Ticket}->{TicketID},
                    ArticleID => $ArticleData->{ArticleID},
                    FileID    => $HTMLBodyAttachmentIDs[0],
                );

                my $Charset = $AttachmentHTML{ContentType} || '';
                $Charset =~ s/.+?charset=("|'|)(\w+)/$2/gi;
                $Charset =~ s/"|'//g;
                $Charset =~ s/(.+?);.*/$1/g;

                # convert html body to correct charset
                my $Body = $Kernel::OM->Get('Kernel::System::Encode')->Convert(
                    Text  => $AttachmentHTML{Content},
                    From  => $Charset,
                    To    => 'utf-8',
                    Check => 1,
                );

                $Body = $HTMLUtilsObject->LinkQuote(
                    String => $Body,
                );

                $Body = $HTMLUtilsObject->DocumentStrip(
                    String => $Body,
                );

                $ArticleData->{Body} = $Body;
            }
        }
    }

    my $TemplateGeneratorObject = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

    # start replacing of OTRS smart tags
    for my $Attribute ( sort keys %{ $Param{Config} } ) {

        my $ConfigValue = $Param{Config}->{$Attribute};

        if ( $ConfigValue && $ConfigValue =~ m{<OTRS_[A-Za-z0-9_]+(?:\[(?:.+?)\])?>}smxi ) {

            if ($RichText) {
                $ConfigValue = $HTMLUtilsObject->ToHTML(
                    String => $ConfigValue,
                );
            }

            $ConfigValue = $TemplateGeneratorObject->_Replace(
                RichText   => $RichText,
                Text       => $ConfigValue,
                Data       => \%ArticleCustomer,
                DataAgent  => \%ArticleAgent,
                TicketData => $Param{Ticket},
                UserID     => $Param{UserID},
                Language   => $Language,
            );

            if ($RichText) {
                $ConfigValue = $HTMLUtilsObject->ToAscii(
                    String => $ConfigValue,
                );

                # For body, create a completed html doc for correct displaying.
                if ( $Attribute eq 'Body' ) {
                    $ConfigValue = $HTMLUtilsObject->DocumentComplete(
                        String  => $ConfigValue,
                        Charset => 'utf-8',
                    );
                }
            }

            $Param{Config}->{$Attribute} = $ConfigValue;
        }
    }

    return 1;
}

sub _ConvertScalar2ArrayRef {
    my ( $Self, %Param ) = @_;

    my @Data = split /,/, $Param{Data};

    # remove any possible heading and tailing white spaces
    for my $Item (@Data) {
        $Item =~ s{\A\s+}{};
        $Item =~ s{\s+\z}{};
    }

    return \@Data;
}

1;
