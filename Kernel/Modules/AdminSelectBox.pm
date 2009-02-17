# --
# Kernel/Modules/AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminSelectBox.pm,v 1.28 2009-02-17 23:37:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.28 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if !$Self->{$_};
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # do select
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Select' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get params
        for (qw(SQL Max)) {
            $Param{SQL} = $Self->{ParamObject}->GetParam( Param => 'SQL' ) || '';
            $Param{Max} = $Self->{ParamObject}->GetParam( Param => 'Max' ) || '';
        }

        # add result block
        $Self->{LayoutObject}->Block(
            Name => 'Result',
            Data => {%Param},
        );

        # fetch database and add row blocks
        if ( $Self->{DBObject}->Prepare( SQL => $Param{SQL}, Limit => $Param{Max} ) ) {
            while ( my @Row = $Self->{DBObject}->FetchrowArray( RowNames => 1 ) ) {
                my $Row = '';
                for my $Item (@Row) {
                    my $Item1 = '';
                    my $Item2 = '';
                    if ( !defined $Item ) {
                        $Item1 = '<i>NULL</i>';
                        $Item2 = 'NULL';
                    }
                    else {
                        $Item1 = $Self->{LayoutObject}->Ascii2Html(
                            Text => $Item,
                            Max  => 16,
                        );
                        $Item2 = $Self->{LayoutObject}->Ascii2Html(
                            Text => $Item,
                            Max  => 80,
                        );
                    }
                    $Item2 =~ s/\n|\r//g;
                    $Row .= "<td class=\"small\"><div title=\"$Item2\">";
                    $Row .= $Item1;
                    $Row .= "</div></td>\n";
                }
                $Self->{LayoutObject}->Block(
                    Name => 'Row',
                    Data => { Result => $Row, },
                );
            }

            # generate output
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminSelectBoxForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AdminSelectBoxForm',
                Data         => \%Param,
            );
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    # ------------------------------------------------------------ #
    # print form
    # ------------------------------------------------------------ #
    else {

        # get params
        for (qw(SQL Max)) {
            $Param{SQL} = $Self->{ParamObject}->GetParam( Param => 'SQL' ) || 'SELECT * FROM ';
            $Param{Max} = $Self->{ParamObject}->GetParam( Param => 'Max' ) || 40;
        }
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->{LayoutObject}->Output(
            TemplateFile => 'AdminSelectBoxForm',
            Data         => \%Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
