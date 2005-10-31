# --
# Kernel/System/FAQ.pm - all faq funktions
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FAQ.pm,v 1.25 2005-10-31 10:26:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::FAQ;

use strict;
use MIME::Base64;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.25 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::FAQ - faq lib

=head1 SYNOPSIS

All faq functions. E. g. to add faqs or to get faqs.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a faq object

  use Kernel::Config;
  use Kernel::System::Log;
  use Kernel::System::DB;
  use Kernel::System::FAQ;

  my $ConfigObject = Kernel::Config->new();
  my $LogObject    = Kernel::System::Log->new(
      ConfigObject => $ConfigObject,
  );
  my $DBObject = Kernel::System::DB->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
  );
  my $FAQObject = Kernel::System::FAQ->new(
      ConfigObject => $ConfigObject,
      LogObject => $LogObject,
      DBObject => $DBObject,
  );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item FAQGet()

get an article

  my %Article = $FAQObject->FAQGet(
      ID => 1,
  );

=cut

sub FAQGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(FAQID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(FAQID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my %Data = ();
    my $SQL = "SELECT i.f_name, i.f_language_id, i.f_subject, ".
            " i.f_field1, i.f_field2, i.f_field3, ".
            " i.f_field4, i.f_field5, i.f_field6, ".
            " i.free_key1, i.free_value1, i.free_key2, i.free_value2, ".
            " i.free_key3, i.free_value3, i.free_key4, i.free_value4, ".
            " i.create_time, i.create_by, i.change_time, i.change_by, ".
            " i.category_id, i.state_id, c.name, s.name, l.name, i.f_keywords, i.f_number ".
            " FROM faq_item i, faq_category c, faq_state s, faq_language l ".
            " WHERE ".
            " i.state_id = s.id AND ".
            " i.category_id = c.id AND ".
            " i.f_language_id = l.id AND ".
            " i.id = $Param{FAQID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            FAQID => $Param{FAQID},
            Name => $Row[0],
            LanguageID => $Row[1],
            Title => $Row[2],
            Field1 => $Row[3],
            Field2 => $Row[4],
            Field3 => $Row[5],
            Field4 => $Row[6],
            Field5 => $Row[7],
            Field6 => $Row[8],
            FreeKey1 => $Row[9],
            FreeKey2 => $Row[10],
            FreeKey3 => $Row[11],
            FreeKey4 => $Row[12],
            FreeKey5 => $Row[13],
            FreeKey6 => $Row[14],
            Created => $Row[17],
            CreatedBy => $Row[18],
            Changed => $Row[19],
            ChangedBy => $Row[20],
            CategoryID => $Row[21],
            StateID => $Row[22],
            Category => $Row[23],
            State => $Row[24],
            Language => $Row[25],
            Keywords => $Row[26],
            Number => $Row[27],
        );
    }
    # update number
    if (!$Data{Number}) {
        my $Number = $Self->{ConfigObject}->Get('SystemID')."00".$Data{FAQID};
        $Self->{DBObject}->Do(
            SQL => "UPDATE faq_item SET f_number = '$Number' WHERE id = $Data{FAQID}",
        );
        $Data{Number} = $Number;
    }
    # get attachment
    $SQL = "SELECT filename, content_type, content_size, content ".
        " FROM faq_attachment WHERE faq_id = $Param{FAQID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # decode attachment if it's a postgresql backend and not BLOB
        if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
            $Row[3] = decode_base64($Row[3]);
        }
        $Data{Filename} = $Row[0];
        $Data{ContentType} = $Row[1];
        $Data{ContentSize} = $Row[2];
        $Data{Content} = $Row[3];
    }

    return %Data;
}

=item FAQAdd()

add an article

  my $FAQID = $FAQObject->FAQAdd(
      Number => '13402',
      Title => 'Some Text',
      CategoryID => 1,
      StateID => 1,
      LanguageID => 1,
      Field1 => 'Problem...',
      Field2 => 'Solution...',
      FreeKey1 => 'Software',
      FreeText1 => 'Apache 3.4.2',
      FreeKey2 => 'OS',
      FreeText2 => 'OpenBSD 4.2.2',
      # attachment options (not required)
      Filename => $Filename,
      Content => $Content,
      ContentType => $ContentType,
  );

=cut

sub FAQAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(CategoryID StateID LanguageID Title)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check name
    if (!$Param{Name}) {
        $Param{Name} = time().'-'.rand(100);
    }
    # check number
    if (!$Param{Number}) {
        $Param{Number} = $Self->{ConfigObject}->Get('SystemID').rand(100);
    }
    # db quote (just not Content, use db Bind values)
    foreach (qw(Number Name Title Keywords Field1 Field2 Field3 Field4 Field5 Field6 FreeKey1 FreeText1 FreeKey2 FreeText2 FreeKey3 FreeText3 FreeKey4 FreeText4 Filename ContentType Filesize)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(CategoryID StateID LanguageID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }

    foreach my $Type (qw(Field FreeKey FreeText)) {
        foreach (1..6) {
            if (!defined($Param{$Type.$_})) {
                $Param{$Type.$_} = '';
            }
        }
    }
    my $SQL = "INSERT INTO faq_item (f_number, f_name, f_language_id, f_subject, ".
            " category_id, state_id, f_keywords, ".
            " f_field1, f_field2, f_field3, f_field4, f_field5, f_field6, ".
            " free_key1, free_value1, free_key2, free_value2, ".
            " free_key3, free_value3, free_key4, free_value4, ".
            " create_time, create_by, change_time, change_by)".
            " VALUES ".
            " ('$Param{Number}', '$Param{Name}', $Param{LanguageID}, '$Param{Title}', ".
            " $Param{CategoryID}, $Param{StateID}, '$Param{Keywords}', ".
            " '$Param{Field1}', '$Param{Field2}', '$Param{Field3}', ".
            " '$Param{Field4}', '$Param{Field5}', '$Param{Field6}', ".
            " '$Param{FreeKey1}', '$Param{FreeText1}', ".
            " '$Param{FreeKey2}', '$Param{FreeText2}', ".
            " '$Param{FreeKey3}', '$Param{FreeText3}', ".
            " '$Param{FreeKey4}', '$Param{FreeText4}', ".
            " current_timestamp, $Self->{UserID}, ".
            " current_timestamp, $Self->{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get id
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM faq_item WHERE ".
              "f_name = '$Param{Name}' AND f_language_id = $Param{LanguageID} ".
              " AND f_subject = '$Param{Title}'",
        );
        my $ID = 0;
        while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $ID = $Row[0];
        }
        # update number
        my $Number = $Self->{ConfigObject}->Get('SystemID')."00".$ID;
        $Self->{DBObject}->Do(
            SQL => "UPDATE faq_item SET f_number = '$Number' WHERE id = $ID",
        );
        # add attachment
        if ($Param{Content} && $Param{ContentType} && $Param{Filename}) {
            # get attachment size
            {
                use bytes;
                $Param{Filesize} = length($Param{Content});
                no bytes;
            }
            # encode attachemnt if it's a postgresql backend!!!
            if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
                $Param{Content} = encode_base64($Param{Content});
            }
            my $SQL = "INSERT INTO faq_attachment ".
                " (faq_id, filename, content_type, content_size, content, ".
                " create_time, create_by, change_time, change_by) " .
                " VALUES ".
                " ($ID, '$Param{Filename}', '$Param{ContentType}', '$Param{Filesize}', ?, ".
                " current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
            # write attachment to db
            if ($Self->{DBObject}->Do(SQL => $SQL, Bind => [\$Param{Content}])) {

            }
        }
        $Self->FAQHistoryAdd(
            Name => 'Created',
            FAQID => $ID,
        );
        return $ID;
    }
    else {
        return;
    }

}

=item FAQUpdate()

update an article

  $FAQObject->FAQUpdate(
      CategoryID => 1,
      StateID => 1,
      LanguageID => 1,
      Title => 'Some Text',
      Field1 => 'Problem...',
      Field2 => 'Solution...',
      FreeKey1 => 'Software',
      FreeText1 => 'Apache 3.4.2',
      FreeKey2 => 'OS',
      FreeText2 => 'OpenBSD 4.2.2',
      # attachment options (not required)
      Filename => $Filename,
      Content => $Content,
      ContentType => $ContentType,
  );

=cut

sub FAQUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(FAQID CategoryID StateID LanguageID Title)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check name
    if (!$Param{Name}) {
        my %Article = $Self->FAQGet(%Param);
        $Param{Name} = $Article{Name};
    }
    # db quote (just not Content, use db Bind values)
    foreach (qw(Number Name Title Keywords Field1 Field2 Field3 Field4 Field5 Field6 FreeKey1 FreeText1 FreeKey2 FreeText2 FreeKey3 FreeText3 FreeKey4 FreeText4 Filename ContentType Filesize)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(FAQID CategoryID StateID LanguageID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # fill up empty stuff
    foreach my $Type (qw(Field FreeKey FreeText)) {
        foreach (1..6) {
            if (!$Param{$Type.$_}) {
                $Param{$Type.$_} = '';
            }
        }
    }
    my $SQL = "UPDATE faq_item SET f_name = '$Param{Name}', ".
            " f_language_id = $Param{LanguageID}, f_subject = '$Param{Title}', ".
            " category_id = $Param{CategoryID}, state_id = $Param{StateID}, ".
            " f_keywords = '$Param{Keywords}', ".
            " f_field1 = '$Param{Field1}', f_field2 = '$Param{Field2}', ".
            " f_field3 = '$Param{Field3}', f_field4 = '$Param{Field4}', ".
            " f_field5 = '$Param{Field5}', f_field6 = '$Param{Field6}', ".
            " free_key1 = '$Param{FreeKey1}', free_value1 = '$Param{FreeText1}', ".
            " free_key2 = '$Param{FreeKey2}', free_value2 = '$Param{FreeText2}', ".
            " free_key3 = '$Param{FreeKey3}', free_value3 = '$Param{FreeText3}', ".
            " free_key4 = '$Param{FreeKey4}', free_value4 = '$Param{FreeText4}', ".
            " change_time = current_timestamp, change_by = $Self->{UserID} ".
            " WHERE id = $Param{FAQID} ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # add attachment
        if ($Param{Content} && $Param{ContentType} && $Param{Filename}) {
            # get attachment size
            {
                use bytes;
                $Param{Filesize} = length($Param{Content});
                no bytes;
            }
            # encode attachemnt if it's a postgresql backend!!!
            if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
                $Param{Content} = encode_base64($Param{Content});
            }
            # delete old attachment
            $Self->{DBObject}->Do(
                SQL => "DELETE FROM faq_attachment WHERE faq_id = $Param{FAQID}",
            );
            my $SQL = "INSERT INTO faq_attachment ".
                " (faq_id, filename, content_type, content_size, content, ".
                " create_time, create_by, change_time, change_by) " .
                " VALUES ".
                " ($Param{FAQID}, '$Param{Filename}', '$Param{ContentType}', '$Param{Filesize}', ?, ".
                " current_timestamp, $Self->{UserID}, current_timestamp, $Self->{UserID})";
            # write attachment to db
            if ($Self->{DBObject}->Do(SQL => $SQL, Bind => [\$Param{Content}])) {

            }
        }
        $Self->FAQHistoryAdd(
            Name => 'Updated',
            FAQID => $Param{FAQID},
        );
        return 1;
    }
    else {
        return;
    }
}

=item FAQDelete()

delete an article

  $FAQObject->FAQDelete(FAQID => 1);

=cut

sub FAQDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(FAQID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(FAQID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if ($Self->FAQHistoryDelete(%Param)) {
        if ($Self->{DBObject}->Prepare(SQL => "DELETE FROM faq_item WHERE id = $Param{FAQID}")) {
            return 1;
        }
        else {
            return;
        }
    }
    else {
        return;
    }
}

=item FAQHistoryAdd()

add an history to an article

  $FAQObject->FAQHistoryAdd(
      FAQID => 1,
      Name => 'Updated Article.',
  );

=cut

sub FAQHistoryAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(FAQID Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(FAQID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO faq_history (name, item_id, ".
            " create_time, create_by, change_time, change_by)".
            " VALUES ".
            " ('$Param{Name}', $Param{FAQID}, ".
            " current_timestamp, $Self->{UserID}, ".
            " current_timestamp, $Self->{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item FAQHistoryGet()

get a array with hachref (Name, Created) with history of an article back

  my @Data = $FAQObject->FAQHistoryGet(
      FAQID => 1,
  );

=cut

sub FAQHistoryGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(FAQID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(FAQID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my @Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT name, create_time FROM faq_history WHERE item_id = $Param{FAQID}",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Record = (
            Name => $Row[0],
            Created => $Row[1],
        );
        push (@Data, \%Record);
    }
    return @Data;
}

=item FAQHistoryDelete()

delete an history of an article

  $FAQObject->FAQHistoryDelete(
      FAQID => 1,
  );

=cut

sub FAQHistoryDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(FAQID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(FAQID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    $Self->{DBObject}->Prepare(
        SQL => "DELETE FROM faq_history WHERE item_id = $Param{FAQID}",
    );
    return 1;
}

=item HistoryGet()

get the system history

  my @Data = $FAQObject->HistoryGet();

=cut

sub HistoryGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # query
    my $SQL = "SELECT i.id, h.name, h.create_time, h.create_by FROM".
        " faq_item i, faq_state s, faq_history h WHERE".
        " s.id = i.state_id AND h.item_id = i.id";
    if ($Param{States} && ref($Param{States}) eq 'ARRAY' && @{$Param{States}}) {
        $SQL .= " AND s.name IN ('${\(join '\', \'', @{$Param{States}})}') ";
    }
    $SQL .= ' ORDER BY create_time DESC';
    my @Data = ();
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 200);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Record = (
            FAQID => $Row[0],
            Name => $Row[1],
            Created => $Row[2],
            CreatedBy => $Row[3],
        );
        push (@Data, \%Record);
    }
    return @Data;
}

=item CategoryList()

get the category list as hash

  my %Categories = $FAQObject->CategoryList();

=cut

sub CategoryList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my %List = ();
    $Self->{DBObject}->Prepare(SQL => 'SELECT id, name FROM faq_category');
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $List{$Row[0]} = $Row[1];
    }
    return %List;
}

=item CategoryGet()

get a category as hash

  my %Category = $FAQObject->CategoryGet(
      ID => 1,
  );

=cut

sub CategoryGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name, comments FROM faq_category WHERE id = $Param{ID}",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            ID => $Row[0],
            Name => $Row[1],
            Comment => $Row[2],
        );
    }
    return %Data;
}

=item CategoryAdd()

add a category

  my $ID = $FAQObject->CategoryAdd(
      Name => 'Some Category',
      Comment => 'some comment ...',
  );

=cut

sub CategoryAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    my $SQL = "INSERT INTO faq_category (name, comments, ".
            " create_time, create_by, change_time, change_by)".
            " VALUES ".
            " ('$Param{Name}', '$Param{Comment}', ".
            " current_timestamp, $Self->{UserID}, ".
            " current_timestamp, $Self->{UserID})";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # get new category id
        $SQL = "SELECT id ".
          " FROM " .
          " faq_category " .
          " WHERE " .
          " name = '$Param{Name}'";
        my $ID = '';
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
          $ID = $Row[0];
        }
        # log notice
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "FAQCategory: '$Param{Name}' ID: '$ID' created successfully ($Self->{UserID})!",
        );
        return $ID;
    }
    else {
        return;
    }
}

=item CategoryUpdate()

update a category

  $FAQObject->CategoryUpdate(
      ID => 1,
      Name => 'Some Category',
      Comment => 'some comment ...',
  );

=cut

sub CategoryUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE faq_category SET name = '$Param{Name}', ".
          " comments = '$Param{Comment}', ".
          " change_time = current_timestamp, change_by = $Self->{UserID} ".
          " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        # log notice
        $Self->{LogObject}->Log(
          Priority => 'notice',
          Message => "FAQCategory: '$Param{Name}' ID: '$Param{ID}' updated successfully ($Self->{UserID})!",
        );
        return 1;
    }
    else {
        return;
    }
}

=item CategoryDelete()

delete a category

  $FAQObject->CategoryDelete(
      ID => 1,
  );

=cut

sub CategoryDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }


}

=item StateTypeList()

get the state type list as hash

  my %StateTypes = $FAQObject->StateTypeList();

=cut

sub StateTypeList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my %List = ();
    $Self->{DBObject}->Prepare(SQL => 'SELECT id, name FROM faq_state_type');
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $List{$Row[0]} = $Row[1];
    }
    return %List;
}

=item StateList()

get the state list as hash

  my %States = $FAQObject->StateList();

=cut

sub StateList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my %List = ();
    $Self->{DBObject}->Prepare(SQL => 'SELECT id, name FROM faq_state');
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $List{$Row[0]} = $Row[1];
    }
    return %List;
}

=item StateUpdate()

update a state

  $FAQObject->StateUpdate(
      ID => 1,
      Name => 'public',
      TypeID => 1,
  );

=cut

sub StateUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name TypeID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID TypeID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE faq_state SET name = '$Param{Name}', type_id = $Param{TypeID}, ".
          " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item StateAdd()

add a state

  my $ID = $FAQObject->StateAdd(
      ID => 1,
      Name => 'public',
      TypeID => 1,
  );

=cut

sub StateAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name TypeID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(TypeID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "INSERT INTO faq_state (name, type_id) ".
            " VALUES ".
            " ('$Param{Name}', $Param{TypeID}) ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item StateGet()

get a state as hash

  my %State = $FAQObject->StateGet(
      ID => 1,
  );

=cut

sub StateGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM faq_state WHERE id = $Param{ID}",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            ID => $Row[0],
            Name => $Row[1],
            Comment => $Row[2],
        );
    }
    return %Data;
}

=item LanguageList()

get the language list as hash

  my %Languages = $FAQObject->LanguageList();

=cut

sub LanguageList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my %List = ();
    $Self->{DBObject}->Prepare(SQL => 'SELECT id, name FROM faq_language');
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $List{$Row[0]} = $Row[1];
    }
    return %List;
}

=item LanguageUpdate()

update a language

  $FAQObject->LanguageUpdate(
      ID => 1,
      Name => 'Some Category',
  );

=cut

sub LanguageUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE faq_language SET name = '$Param{Name}' ".
          " WHERE id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item LanguageAdd()

add a language

  my $ID = $FAQObject->LanguageAdd(
      Name => 'Some Category',
  );

=cut

sub LanguageAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(Name)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    my $SQL = "INSERT INTO faq_language (name) ".
            " VALUES ".
            " ('$Param{Name}') ";

    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}

=item LanguageGet()

get a language as hash

  my %Language = $FAQObject->LanguageGet(
      ID => 1,
  );

=cut

sub LanguageGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my %Data = ();
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id, name FROM faq_language WHERE id = $Param{ID}",
    );
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        %Data = (
            ID => $Row[0],
            Name => $Row[1],
        );
    }
    return %Data;
}

=item FAQSearch()

search in articles

  my @IDs = $FAQObject->FAQSearch(
      Number => '*134*',
      What => '*some text*',
      Keywords => '*webserver*',
      States = ['public', 'internal'],
  );

=cut

sub FAQSearch {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw()) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # sql
    my $SQL = "SELECT i.id FROM faq_item i, faq_state s WHERE ".
        " s.id = i.state_id AND ";
    my $Ext = '';
    foreach (qw(f_subject f_field1 f_field2 f_field3 f_field4 f_field5 f_field6)) {
        if ($Ext) {
            $Ext .= ' OR ';
        }
        else {
            $Ext .= ' (';
        }
        if ($Param{What}) {
            my @List = split(/;/, $Param{What});
            my $What = '';
            foreach my $Value (@List) {
                if ($What) {
                    $What .= ' OR ';
                }
                $What .= " LOWER(i.$_) LIKE LOWER('%".$Self->{DBObject}->Quote($Value)."%')";
            }
            $Ext .= $What;
        }
        else {
            $Ext .= " LOWER(i.$_) LIKE LOWER('%')";
        }
    }
    $Ext .= ' )';
    if ($Param{Number}) {
        $Param{Number} =~ s/\*/%/g;
        $Ext .= " AND LOWER(i.f_number) LIKE LOWER('".$Self->{DBObject}->Quote($Param{Number})."')";
    }
    if ($Param{Title}) {
        $Ext .= " AND LOWER(i.f_subject) LIKE LOWER('%".$Self->{DBObject}->Quote($Param{Title})."%')";
    }
    if ($Param{LanguageIDs} && ref($Param{LanguageIDs}) eq 'ARRAY' && @{$Param{LanguageIDs}}) {
        $Ext .= " AND i.f_language_id IN (${\(join ', ', @{$Param{LanguageIDs}})} )";
    }
    if ($Param{CategoryIDs} && ref($Param{CategoryIDs}) eq 'ARRAY' && @{$Param{CategoryIDs}}) {
        $Ext .= " AND i.category_id IN (${\(join ', ', @{$Param{CategoryIDs}})} )";
    }
    if ($Param{States} && ref($Param{States}) eq 'ARRAY' && @{$Param{States}}) {
        $Ext .= " AND s.name IN ('${\(join '\', \'', @{$Param{States}})}')";
    }
    if ($Param{Keyword}) {
        $Ext .= " AND LOWER(i.f_keywords) LIKE LOWER('%".$Self->{DBObject}->Quote($Param{Keyword})."%')";
    }
    $SQL .= $Ext." ORDER BY i.change_time DESC";
    my @List = ();
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 500);
    while  (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@List, $Row[0]);
    }
    return @List;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.25 $ $Date: 2005-10-31 10:26:20 $

=cut
