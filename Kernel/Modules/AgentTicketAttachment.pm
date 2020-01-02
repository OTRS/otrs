# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketAttachment;
## nofilter(TidyAll::Plugin::OTRS::Perl::Print)

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

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get ArticleID
    my $ArticleID = $ParamObject->GetParam( Param => 'ArticleID' );
    my $FileID    = $ParamObject->GetParam( Param => 'FileID' );

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

    # check params
    if ( !$FileID || !$ArticleID ) {
        $LogObject->Log(
            Message  => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        return $LayoutObject->ErrorScreen();
    }

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check permissions
    my %Article = $TicketObject->ArticleGet(
        ArticleID     => $ArticleID,
        DynamicFields => 0,
        UserID        => $Self->{UserID},
    );
    if ( !$Article{TicketID} ) {
        $LogObject->Log(
            Message  => "No TicketID for ArticleID ($ArticleID)!",
            Priority => 'error',
        );
        return $LayoutObject->ErrorScreen();
    }

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $Article{TicketID},
        UserID   => $Self->{UserID}
    );
    if ( !$Access ) {
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # get a attachment
    my %Data = $TicketObject->ArticleAttachment(
        ArticleID => $ArticleID,
        FileID    => $FileID,
        UserID    => $Self->{UserID},
    );
    if ( !%Data ) {
        $LogObject->Log(
            Message  => "No such attachment ($FileID).",
            Priority => 'error',
        );
        return $LayoutObject->ErrorScreen();
    }

    my $Viewers = $ParamObject->GetParam( Param => 'Viewer' ) || 0;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # find viewer for ContentType
    my $Viewer = '';
    if ( $Viewers && $ConfigObject->Get('MIME-Viewer') ) {
        for ( sort keys %{ $ConfigObject->Get('MIME-Viewer') } ) {
            if ( $Data{ContentType} =~ /^$_/i ) {
                $Viewer = $ConfigObject->Get('MIME-Viewer')->{$_};
                $Viewer =~ s/\<OTRS_CONFIG_(.+?)\>/$ConfigObject->{$1}/g;
            }
        }
    }

    # show with viewer
    if ( $Viewers && $Viewer ) {

        # write tmp file
        my $FileTempObject = $Kernel::OM->Get('Kernel::System::FileTemp');
        my ( $FH, $Filename ) = $FileTempObject->TempFile();
        if ( open( my $ViewerDataFH, '>', $Filename ) ) {    ## no critic
            print $ViewerDataFH $Data{Content};
            close $ViewerDataFH;
        }
        else {

            # log error
            $LogObject->Log(
                Priority => 'error',
                Message  => "Cant write $Filename: $!",
            );
            return $LayoutObject->ErrorScreen();
        }

        # use viewer
        my $Content = '';
        if ( open( my $ViewerFH, "-|", "$Viewer $Filename" ) ) {    ## no critic
            while (<$ViewerFH>) {
                $Content .= $_;
            }
            close $ViewerFH;
        }
        else {
            return $LayoutObject->FatalError(
                Message => "Can't open: $Viewer $Filename: $!",
            );
        }

        # return new page
        return $LayoutObject->Attachment(
            %Data,
            ContentType => 'text/html',
            Content     => $Content,
            Type        => 'inline',
            Sandbox     => 1,
        );
    }

    # view attachment for html email
    if ( $Self->{Subaction} eq 'HTMLView' ) {

        # set download type to inline
        $ConfigObject->Set(
            Key   => 'AttachmentDownloadType',
            Value => 'inline'
        );

        # just return for non-html attachment (e. g. images)
        if ( $Data{ContentType} !~ /text\/html/i ) {
            return $LayoutObject->Attachment(
                %Data,
                Sandbox => 1,
            );
        }

        # set filename for inline viewing
        $Data{Filename} = "Ticket-$Article{TicketNumber}-ArticleID-$Article{ArticleID}.html";

        # generate base url
        my $URL = 'Action=AgentTicketAttachment;Subaction=HTMLView'
            . ";ArticleID=$ArticleID;FileID=";

        # replace links to inline images in html content
        my %AtmBox = $TicketObject->ArticleAttachmentIndex(
            ArticleID => $ArticleID,
            UserID    => $Self->{UserID},
        );

        # Do not load external images if 'BlockLoadingRemoteContent' is enabled.
        my $LoadExternalImages;
        if ( $ConfigObject->Get('Ticket::Frontend::BlockLoadingRemoteContent') ) {
            $LoadExternalImages = 0;
        }
        else {
            $LoadExternalImages = $ParamObject->GetParam(
                Param => 'LoadExternalImages'
            ) || 0;

            # Safety check only on customer article.
            if ( !$LoadExternalImages && $Article{SenderType} ne 'customer' ) {
                $LoadExternalImages = 1;
            }
        }

        # reformat rich text document to have correct charset and links to
        # inline documents
        %Data = $LayoutObject->RichTextDocumentServe(
            Data               => \%Data,
            URL                => $URL,
            Attachments        => \%AtmBox,
            LoadExternalImages => $LoadExternalImages,
        );

        # if there is unexpectedly pgp decrypted content in the html email (OE),
        # we will use the article body (plain text) from the database as fall back
        # see bug#9672
        if (
            $Data{Content} =~ m{
            ^ .* -----BEGIN [ ] PGP [ ] MESSAGE-----  .* $      # grep PGP begin tag
            .+                                                  # PGP parts may be nested in html
            ^ .* -----END [ ] PGP [ ] MESSAGE-----  .* $        # grep PGP end tag
        }xms
            )
        {

            # html quoting
            $Article{Body} = $LayoutObject->Ascii2Html(
                NewLine        => $ConfigObject->Get('DefaultViewNewLine'),
                Text           => $Article{Body},
                VMax           => $ConfigObject->Get('DefaultViewLines') || 5000,
                HTMLResultMode => 1,
                LinkFeature    => 1,
            );

            # use the article body as content, because pgp was definitly descrypted if possible
            $Data{Content} = $Article{Body};
        }

        # return html attachment
        return $LayoutObject->Attachment(
            %Data,
            Sandbox => 1,
        );
    }

    # download it AttachmentDownloadType is configured
    return $LayoutObject->Attachment(
        %Data,
        Sandbox => 1,
    );
}

1;
