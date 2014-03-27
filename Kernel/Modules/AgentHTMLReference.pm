# --
# Kernel/Modules/AgentHTMLReference.pm - HTML reference pages
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: AgentHTMLReference.pm,v 1.3 2010-10-06 08:44:30 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentHTMLReference;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $NeededData (
        qw(
        GroupObject   ParamObject  DBObject   ModuleReg  LayoutObject
        LogObject     ConfigObject UserObject MainObject TimeObject
        SessionObject UserID       AccessRo   SessionID
        EncodeObject
        )
        )
    {
        if ( !$Param{$NeededData} ) {
            $Param{LayoutObject}->FatalError( Message => "Got no $NeededData!" );
        }
        $Self->{$NeededData} = $Param{$NeededData};
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    my $Subaction = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || 'Overview';

    # security: cleanup input data to prevent directory traversal
    $Subaction =~ s{[./]}{}smxg;

    my $HeaderType = $Self->{ParamObject}->GetParam( Param => 'Header' ) || '';

    # build output
    $Output .= $Self->{LayoutObject}->Header(
        Title => 'AgentHTMLReference - ' . $Subaction,
        Type  => $HeaderType,
    );
    if ( !$HeaderType ) {
        $Output .= $Self->{LayoutObject}->NavigationBar();
    }
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentHTMLReference' . $Subaction,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

1;
