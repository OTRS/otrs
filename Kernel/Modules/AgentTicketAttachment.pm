# --
# Kernel/Modules/AgentTicketAttachment.pm - to get the attachments
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketAttachment.pm,v 1.1 2005-02-17 07:05:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketAttachment;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    # get ArticleID
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    $Self->{FileID} = $Self->{ParamObject}->GetParam(Param => 'FileID');
    $Self->{Viewer} = $Self->{ParamObject}->GetParam(Param => 'Viewer') || 0;

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # check params
    # --
    if (!$Self->{FileID} || !$Self->{ArticleID}) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'FileID and ArticleID are needed!',
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message => 'FileID and ArticleID are needed!',
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check permissions
    # --
    my %ArticleData = $Self->{TicketObject}->ArticleGet(ArticleID => $Self->{ArticleID});
    if (!$ArticleData{TicketID}) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Comment => 'Please contact your admin'
        );
        $Self->{LogObject}->Log(
            Message => "No TicketID for ArticleID ($Self->{ArticleID})!",
            Priority => 'error',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{TicketObject}->Permission(
        Type => 'ro',
        TicketID => $ArticleData{TicketID},
        UserID => $Self->{UserID})) {

        # geta attachment
        if (my %Data = $Self->{TicketObject}->ArticleAttachment(
          ArticleID => $Self->{ArticleID},
          FileID => $Self->{FileID},
        )) {
            # check viewer
            my $Viewer = '';
            if ($Self->{ConfigObject}->Get('MIME-Viewer')) {
                foreach (keys %{$Self->{ConfigObject}->Get('MIME-Viewer')}) {
                    if ($Data{ContentType} =~ /^$_/i) {
                        $Viewer = $Self->{ConfigObject}->Get('MIME-Viewer')->{$_};
                    }
                }
            }
            # show with viewer
            if ($Self->{Viewer} && $Viewer) {
                # write tmp file
                my $TmpFile = $Self->{ConfigObject}->Get('TempDir').'/view-'.$Self->{SessionID}.'.tmp';
                if (open (DATA, "> $TmpFile")) {
                    print DATA $Data{Content};
                    close (DATA);
                }
                else {
                    # log error
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Cant write $TmpFile: $!",
                    );
                    $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
                    $Output .= $Self->{LayoutObject}->Error();
                    $Output .= $Self->{LayoutObject}->Footer();
                    return $Output;
                }
                # use viewer
                my $Content = '';
                open (DATA, "$Viewer $TmpFile |");
                while (<DATA>) {
                    $Content .= $_;
                }
                close (DATA);
                # remove tmp file
                unlink ($TmpFile);
                # return new page
                return $Self->{LayoutObject}->Attachment(%Data, ContentType => 'text/html', Content => $Content, Type => 'inline');
            }
            # download it
            else {
                return $Self->{LayoutObject}->Attachment(%Data);
            }
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
              Message => "No such attacment ($Self->{FileID})!",
              Comment => 'Please contact your admin'
            );
            $Self->{LogObject}->Log(
              Message => "No such attacment ($Self->{FileID})! May be an attack!!!",
              Priority => 'error',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    else {
        # error screen
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
}
# --

1;
