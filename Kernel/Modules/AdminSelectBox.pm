# --
# Kernel/Modules/AdminSelectBox.pm - provides a SelectBox for admins
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AdminSelectBox.pm,v 1.30 2009-07-09 02:29:35 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminSelectBox;

use strict;
use warnings;

use Kernel::System::CSV;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.30 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if !$Self->{$_};
    }

    $Self->{CSVObject} = Kernel::System::CSV->new(%Param);

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
        for (qw(SQL Max HTML CSV)) {
            $Param{$_} = $Self->{ParamObject}->GetParam( Param => $_ ) || '';
        }

        # add result block
        $Self->{LayoutObject}->Block(
            Name => 'Result',
            Data => \%Param,
        );

        # fetch database and add row blocks
        if ( $Self->{DBObject}->Prepare( SQL => $Param{SQL}, Limit => $Param{Max} ) ) {
            my $Count = 0;
            my @Head;
            my @Data;
            while ( my @Row = $Self->{DBObject}->FetchrowArray( RowNames => 1 ) ) {

                # get csv data
                if ( $Param{CSV} ) {
                    $Count++;
                    if ( $Count == 1 ) {
                        @Head = @Row;
                        next;
                    }
                    push @Data, \@Row;
                    next;
                    last if $Count > 2000;
                }

                # get html data
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

            # generate csv output
            if ( $Param{CSV} ) {
                my $CSV = $Self->{CSVObject}->Array2CSV(
                    Head => \@Head,
                    Data => \@Data,
                );
                return $Self->{LayoutObject}->Attachment(
                    Filename    => 'admin-select.csv',
                    ContentType => 'text/csv',
                    Content     => $CSV,
                    Type        => 'attachment'
                );
            }

            # generate html output
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
