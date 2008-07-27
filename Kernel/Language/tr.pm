# --
# Kernel/Language/tr.pm - provides tr language translation
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: tr.pm,v 1.11 2008-07-27 10:22:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
package Kernel::Language::tr;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Fri May 16 14:09:04 2008

    # possible charsets
    $Self->{Charset} = ['iso-8859-9', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Evet',
        'No' => 'Hayýr',
        'yes' => 'evet',
        'no' => 'hayýr',
        'Off' => 'Kapalý',
        'off' => 'kapalý',
        'On' => 'Açýk',
        'on' => 'açýk',
        'top' => 'üst',
        'end' => 'son',
        'Done' => 'Tamam',
        'Cancel' => 'Ýptâl',
        'Reset' => 'Sýfýrla',
        'last' => 'son',
        'before' => 'önce',
        'day' => 'gün',
        'days' => 'gün',
        'day(s)' => 'gün',
        'hour' => 'saat',
        'hours' => 'saat',
        'hour(s)' => 'saat',
        'minute' => 'dakika',
        'minutes' => 'dakika',
        'minute(s)' => 'dakika',
        'month' => 'ay',
        'months' => 'ay',
        'month(s)' => 'ay',
        'week' => 'hafta',
        'week(s)' => 'hafta',
        'year' => 'yýl',
        'years' => 'yýl',
        'year(s)' => 'yýl',
        'second(s)' => 'saniye',
        'seconds' => 'saniye',
        'second' => 'saniye',
        'wrote' => 'yazdý',
        'Message' => 'Mesaj',
        'Error' => 'Hata',
        'Bug Report' => 'Hata Kaydý',
        'Attention' => 'Dikkat',
        'Warning' => 'Uyarý',
        'Module' => 'modül',
        'Modulefile' => 'modül dosyasý',
        'Subfunction' => 'Altfonksiyon',
        'Line' => 'Hat',
        'Example' => 'Örnek',
        'Examples' => 'Beispiele',
        'valid' => 'geçerli',
        'invalid' => 'geçersiz',
        '* invalid' => '* geçersiz',
        'invalid-temporarily' => 'geçici olarak geçersiz',
        ' 2 minutes' => ' 2 dakika',
        ' 5 minutes' => ' 5 dakika',
        ' 7 minutes' => ' 7 dakika',
        '10 minutes' => '10 dakika',
        '15 minutes' => '15 dakika',
        'Mr.' => 'Bay',
        'Mrs.' => 'Bayan',
        'Next' => 'Sonraki',
        'Back' => 'Geri',
        'Next...' => 'Sonraki...',
        '...Back' => '...Geri',
        '-none-' => '-hiçbiri-',
        'none' => 'hiçbiri',
        'none!' => 'hiçbiri!',
        'none - answered' => 'hiçbiri - cevaplandý',
        'please do not edit!' => 'Lütfen deðiþtirmeyiniz!',
        'AddLink' => 'Bað Ekle',
        'Link' => 'Bað',
        'Unlink' => '',
        'Linked' => 'Baðlandý',
        'Link (Normal)' => 'Bað (Normal)',
        'Link (Parent)' => 'Bað (Ebeveyn)',
        'Link (Child)' => 'Bað (Alt)',
        'Normal' => 'Normal',
        'Parent' => 'Ebeveyn',
        'Child' => 'Alt',
        'Hit' => 'Ýsabet',
        'Hits' => 'Ýsabet',
        'Text' => 'Metin',
        'Lite' => 'Hafif',
        'User' => 'Kullanýcý',
        'Username' => 'Kullanýcý adý',
        'Language' => 'Dil',
        'Languages' => 'Diller',
        'Password' => 'Parola',
        'Salutation' => 'Selam',
        'Signature' => 'Ýmza',
        'Customer' => 'Müþteri',
        'CustomerID' => 'Müþteri kimliði',
        'CustomerIDs' => 'Müþteri kimlikleri',
        'customer' => 'müþteri',
        'agent' => 'aracý',
        'system' => 'sistem',
        'Customer Info' => 'Müþteri Bilgisi',
        'Customer Company' => 'Müþteri Þirket',
        'Company' => 'Þirket',
        'go!' => 'Baþla!',
        'go' => 'baþla',
        'All' => 'Tümü',
        'all' => 'tümü',
        'Sorry' => 'Üzgünüm',
        'update!' => 'güncelle!',
        'update' => 'güncelle',
        'Update' => 'Güncelle',
        'submit!' => 'gönder!',
        'submit' => 'gönder',
        'Submit' => 'Gönder',
        'change!' => 'deðiþtir!',
        'Change' => 'Deðiþtir',
        'change' => 'deðiþtir',
        'click here' => 'buraya týklayýn',
        'Comment' => 'Yorum',
        'Valid' => 'Geçerli',
        'Invalid Option!' => 'Geçersiz Seçenek!',
        'Invalid time!' => 'Geçersiz saat!',
        'Invalid date!' => 'Geçersiz tarih!',
        'Name' => 'Ad',
        'Group' => 'Grup',
        'Description' => 'Açýklama',
        'description' => 'açýklama',
        'Theme' => 'Tema',
        'Created' => 'Oluþturma',
        'Created by' => 'Oluþturan',
        'Changed' => 'Deðiþim',
        'Changed by' => 'Deðiþtiren',
        'Search' => 'Ara',
        'and' => 've',
        'between' => 'arasýnda',
        'Fulltext Search' => 'Tümmetin Aramasý',
        'Data' => 'Veri',
        'Options' => 'Seçenekler',
        'Title' => 'Baþlýk',
        'Item' => 'Madde',
        'Delete' => 'Sil',
        'Edit' => 'Düzenle',
        'View' => 'Görünüm',
        'Number' => 'Sayý',
        'System' => 'Sistem',
        'Contact' => 'Baðlantý',
        'Contacts' => 'Baðlantýlar',
        'Export' => 'Dýþarýya aktar',
        'Up' => 'Yukarý',
        'Down' => 'Aþaðý',
        'Add' => 'Ekle',
        'Category' => 'Kategori',
        'Viewer' => 'Görüntüleyen',
        'New message' => 'Yeni mesaj',
        'New message!' => 'Yeni mesaj!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Lütfen normal kuyruk görünümüne dönmek için bu bilet(ler)i cevaplayýn!',
        'You got new message!' => 'Yeni mesajýnýz var!',
        'You have %s new message(s)!' => '%s yeni mesajýnýz var!',
        'You have %s reminder ticket(s)!' => '%s hatýrlatýcý biletiniz var!',
        'The recommended charset for your language is %s!' => 'Kullandýðýnýz dil için tavsiye edilen karakter kümesi %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Parolalar uyuþmuyor! Lütfen tekrar denetin!',
        'Password is already in use! Please use an other password!' => 'Parola zaten kullanýmda! Lütfen baþka bir parola kullanýn!',
        'Password is already used! Please use an other password!' => 'Parola zaten kullanýldý! Lütfen baþka bir parola kullanýn!',
        'You need to activate %s first to use it!' => 'Kullanabilmek için %s önce etkinleþtirilmeli!',
        'No suggestions' => 'Öneri yok',
        'Word' => 'Kelime',
        'Ignore' => 'Yoksay',
        'replace with' => 'ile deðiþtir',
        'There is no account with that login name.' => 'Bu kullanýcý adýnda bir hesap yok.',
        'Login failed! Your username or password was entered incorrectly.' => 'Oturum açýlamadý! Kullanýcý adýnýz veya parolanýz yanlýþ girildi.',
        'Please contact your admin' => 'Lütfen yöneticiyle iletiþime geçin',
        'Logout successful. Thank you for using OTRS!' => 'Oturum kapatma baþarýlý! OTRS\'yi kullandýðýnýz için teþekkür ederiz!',
        'Invalid SessionID!' => 'Geçersiz oturum kimliði!',
        'Feature not active!' => 'Özellik etkin deðil!',
        'Login is needed!' => 'Oturum açmanýz gerekli!',
        'Password is needed!' => 'Parola gerekli!',
        'License' => 'Lisans',
        'Take this Customer' => 'Bu Müþteriyi al',
        'Take this User' => 'Bu Kullanýcýyý al',
        'possible' => 'mümkün',
        'reject' => 'reddet',
        'reverse' => 'ters',
        'Facility' => 'Tesis',
        'Timeover' => 'Süre bitimi',
        'Pending till' => 'Þu zamana kadar askýda',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Kullanýcý kimliði 1 (Sistem hesabý) ile çalýþmayýn! Yeni kullanýcýlar oluþturun!',
        'Dispatching by email To: field.' => 'Elektronik posta Kime: alanýna göre gönderiliyor.',
        'Dispatching by selected Queue.' => 'Seçili Kuyruða göre gönderiliyor.',
        'No entry found!' => 'Kayýt bulunamadý!',
        'Session has timed out. Please log in again.' => 'Oturum süresi doldu. Lütfen tekrar oturum açýn.',
        'No Permission!' => 'Ýzin yok!',
        'To: (%s) replaced with database email!' => 'Kime: (%s) veritabaný elektronik postasýyla deðiþtirilir!',
        'Cc: (%s) added database email!' => 'Karbon kopya: (%s) veritabaný elektronik postasý eklendi!',
        '(Click here to add)' => '(Eklemek için buraya týklayýn)',
        'Preview' => 'Önizleme',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Paket doðru þekilde yüklenmemiþ! Paketi yeniden yüklemelisiniz!',
        'Added User "%s"' => '"%s" kullanýcýsý eklendi.',
        'Contract' => 'Kontrat',
        'Online Customer: %s' => 'Çevrimiçi Müþteri: %s',
        'Online Agent: %s' => 'Çevirimi Aracý: %s',
        'Calendar' => 'Takvim',
        'File' => 'Dosya',
        'Filename' => 'Dosya adý',
        'Type' => 'Tip',
        'Size' => 'Boyut',
        'Upload' => 'Yükle',
        'Directory' => 'Dizin',
        'Signed' => 'Ýmzalý',
        'Sign' => 'Ýmza',
        'Crypted' => 'Þifrelenmiþ',
        'Crypt' => 'Þifre',
        'Office' => 'Büro',
        'Phone' => 'Telefon',
        'Fax' => 'Faks',
        'Mobile' => 'Cep',
        'Zip' => 'PK',
        'City' => 'Þehir',
        'Location' => '',
        'Street' => '',
        'Country' => 'Ülke',
        'installed' => 'yüklenmiþ',
        'uninstalled' => 'kaldýrýlmýþ',
        'Security Note: You should activate %s because application is already running!' => 'Güvenlik notu: %s etkinleþtirilmeli çünkü uygulama halihazýrda çalýþýyor!',
        'Unable to parse Online Repository index document!' => 'Çevrimiçi Depo endeks belgesi ayrýþtýrýlamadý!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Bu Çevrimiçi Depoda Ýstenen Çatý için Paket bulunamadý, ama baþka Çatýlar için var!',
        'No Packages or no new Packages in selected Online Repository!' => 'Seçili Çevrimiçi Depoda hiç Paket yok veya hiç yeni Paket yok!',
        'printed at' => 'yazdýrýldý',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => '',
        'New account created. Sent Login-Account to %s.' => '',
        'Please press Back and try again.' => '',
        'Sent password token to: %s' => '',
        'Sent new password to: %s' => '',
        'Invalid Token!' => '',

        # Template: AAAMonth
        'Jan' => 'Oca',
        'Feb' => 'Þub',
        'Mar' => 'Mar',
        'Apr' => 'Nis',
        'May' => 'May',
        'Jun' => 'Haz',
        'Jul' => 'Tem',
        'Aug' => 'Aðu',
        'Sep' => 'Eyl',
        'Oct' => 'Eki',
        'Nov' => 'Kas',
        'Dec' => 'Ara',
        'January' => 'Ocak',
        'February' => 'Þubat',
        'March' => 'Mart',
        'April' => 'Nisan',
        'June' => 'Haziran',
        'July' => 'Temmuz',
        'August' => 'Aðustos',
        'September' => 'Eylül',
        'October' => 'Ekim',
        'November' => 'Kasým',
        'December' => 'Aralýk',

        # Template: AAANavBar
        'Admin-Area' => 'Yönetim Alaný',
        'Agent-Area' => 'Aracý Alaný',
        'Ticket-Area' => 'Bilet Alaný',
        'Logout' => 'Oturumu kapat',
        'Agent Preferences' => 'Aracý Tercihleri',
        'Preferences' => 'Tercihler',
        'Agent Mailbox' => 'Aracý Posta Kutusu',
        'Stats' => 'Ýstatistikler',
        'Stats-Area' => 'Ýstatistikler Alaný',
        'Admin' => 'Yönetici',
        'Customer Users' => 'Müþteri Kullanýcýlar',
        'Customer Users <-> Groups' => 'Müþteri Kullanýcýlar <-> Gruplar',
        'Users <-> Groups' => 'Kullanýcýlar <-> Gruplar',
        'Roles' => 'Roller',
        'Roles <-> Users' => 'Roller <-> Kullanýcýlar',
        'Roles <-> Groups' => 'Roller <-> Gruplar',
        'Salutations' => 'Selâmlamalar',
        'Signatures' => 'Ýmzalar',
        'Email Addresses' => 'E-Posta Adresleri',
        'Notifications' => 'Bildirimler',
        'Category Tree' => 'Kategori Aðacý',
        'Admin Notification' => 'Yönetim Bilgilendirme',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Tercihler baþarýlý bir þekilde güncellendi!',
        'Mail Management' => 'Posta Yönetimi',
        'Frontend' => 'Önyüz',
        'Other Options' => 'Diðer Seçenekler',
        'Change Password' => 'Parola Deðiþtir',
        'New password' => 'Yeni parola',
        'New password again' => 'Yeni parola (tekrar)',
        'Select your QueueView refresh time.' => 'Kuyruk Görünümü tazeleme sýklýðýný seçin.',
        'Select your frontend language.' => 'Önyüz Dilini seçin.',
        'Select your frontend Charset.' => 'Önyüz Karakter Kümesini seçin.',
        'Select your frontend Theme.' => 'Önyüz Temasýný seçin.',
        'Select your frontend QueueView.' => 'Önyüz Kuyruk Görünümünüzü seçin.',
        'Spelling Dictionary' => 'Sözdizim Sözlüðü',
        'Select your default spelling dictionary.' => 'Öntanýmlý sözdizim sözlüðünüzü seçin.',
        'Max. shown Tickets a page in Overview.' => 'Genel bakýþta bir sayfada gösterilecek en fazla Bilet sayýsý.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Parola güncellenemiyor, parolalar birbirleriyle uyuþmuyor! Lütfen tekrar deneyin!',
        'Can\'t update password, invalid characters!' => 'Parola güncellenemiyor, geçersiz karakterler var!',
        'Can\'t update password, need min. 8 characters!' => 'Parola güncellenemiyor, en az 8 karakter girmelisiniz!',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Parola güncellenemiyor, 2 küçük harf ve 2 büyük harf girmelisiniz!',
        'Can\'t update password, need min. 1 digit!' => 'Parola güncellenemiyor, en az 1 sayý girmelisiniz!',
        'Can\'t update password, need min. 2 characters!' => 'Parola güncellenemiyor, en az 2 karakter girmelisiniz!',

        # Template: AAAStats
        'Stat' => 'Ýstatistikler',
        'Please fill out the required fields!' => 'Lütfen zorunlu alanlarý doldurun!',
        'Please select a file!' => 'Lütfen bir dosya seçin!',
        'Please select an object!' => 'Lütfen bir nesne seçin!',
        'Please select a graph size!' => 'Lütfen bir grafik boyutu seçin!',
        'Please select one element for the X-axis!' => 'Lütfen X ekseni için bir eleman seçin!',
        'You have to select two or more attributes from the select field!' => 'Seçim alanýndan iki veya daha fazla nitelik seçmelisiniz!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Lütfen sadece bir eleman seçin veya seçim alanýnýn iþaretli olduðu yerden \'Sabit\' düðmesini kapatýn!',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Eðer bir iþaretleme kutusu kullanýrsanýz seçim alanýndan bazý nitelikleri seçmelisiniz!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Lütfen seçili giriþ alanýna bir deðer girin veya \'Sabit\' iþaretleme kutusunu kapatýn!',
        'The selected end time is before the start time!' => 'Seçilen bitiþ zamaný baþlama zamanýndan önce!',
        'You have to select one or more attributes from the select field!' => 'Seçim alanýndan bir veya daha fazla nitelik seçmelisiniz!',
        'The selected Date isn\'t valid!' => 'Seçilen Tarih geçerli deðil!',
        'Please select only one or two elements via the checkbox!' => 'Lütfen iþaretleme kutusu vasýtasýyla sadece bir veya iki eleman seçin!',
        'If you use a time scale element you can only select one element!' => 'Eðer bir zaman oran elemaný kullanýrsanýz sadece bir eleman seçebilirsiniz!',
        'You have an error in your time selection!' => 'Zaman seçiminizde bir hata var!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Raporlama zaman sýklýðýnýz çok küçük, lütfen daha büyük bir zaman oraný seçin!',
        'The selected start time is before the allowed start time!' => 'Seçilen baþlangýç zamaný izin verilen baþlangýç zamanýndan önce!',
        'The selected end time is after the allowed end time!' => 'Seçilen bitiþ zamaný izin verilen bitiþ zamanýndan sonra!',
        'The selected time period is larger than the allowed time period!' => 'Seçilen zaman dönemi izin verilen zaman döneminden daha büyük!',
        'Common Specification' => 'Genel Belirtim',
        'Xaxis' => 'X ekseni',
        'Value Series' => 'Deðer Serileri',
        'Restrictions' => 'Kýsýtlamalar',
        'graph-lines' => 'grafik-çizgiler',
        'graph-bars' => 'grafik-çubuklar',
        'graph-hbars' => 'grafik-yatay çubuklar',
        'graph-points' => 'grafik-noktalar',
        'graph-lines-points' => 'grafik-çizgiler-noktalar',
        'graph-area' => 'grafik-alan',
        'graph-pie' => 'grafik-pasta',
        'extended' => 'geniþletilmiþ',
        'Agent/Owner' => 'Aracý/Sahip',
        'Created by Agent/Owner' => 'Aracý/Sahip Tarafýndan Oluþturulmuþ',
        'Created Priority' => 'Oluþturulma Önceliði',
        'Created State' => 'Oluþturulma Durumu',
        'Create Time' => 'Oluþturulma Zamaný',
        'CustomerUserLogin' => 'Müþteri Kullanýcý Oturumu',
        'Close Time' => 'Kapanma Zamaný',

        # Template: AAATicket
        'Lock' => 'Kilitle',
        'Unlock' => 'Kilidi Aç',
        'History' => 'Geçmiþ',
        'Zoom' => 'Yakýnlaþma',
        'Age' => 'Yaþ',
        'Bounce' => 'Yansýt',
        'Forward' => 'Ýleri',
        'From' => 'Kimden',
        'To' => 'Kime',
        'Cc' => 'Karbon Kopya',
        'Bcc' => 'Gizli Karbon Kopya',
        'Subject' => 'Konu',
        'Move' => 'Taþý',
        'Queue' => 'Kuyruða koy',
        'Priority' => 'Öncelik',
        'Priority Update' => '',
        'State' => 'Durum',
        'Compose' => 'Yeni Oluþtur',
        'Pending' => 'Bekliyor',
        'Owner' => 'Sahip',
        'Owner Update' => 'Sahip Güncellemesi',
        'Responsible' => 'Sorumlu',
        'Responsible Update' => 'Sorumlu Güncellemesi',
        'Sender' => 'Gönderen',
        'Article' => 'Yazý',
        'Ticket' => 'Bilet',
        'Createtime' => 'Oluþturulma zamaný',
        'plain' => 'düz',
        'Email' => 'E-Posta',
        'email' => 'e-posta',
        'Close' => 'Kapat',
        'Action' => 'Eylem',
        'Attachment' => 'Ek',
        'Attachments' => 'Ekler',
        'This message was written in a character set other than your own.' => 'Bu mesaj sizinkinin dýþýnda bir karakter kümesinde yazýlmýþ.',
        'If it is not displayed correctly,' => 'Eðer doðru görüntülenmezse,',
        'This is a' => 'Bu bir',
        'to open it in a new window.' => 'yeni pencerede açmak için',
        'This is a HTML email. Click here to show it.' => 'Bu HTML biçimli bir e-posta. Göstermek için buraya týklayýn.',
        'Free Fields' => 'Serbest Alanlar',
        'Merge' => 'birleþtir',
        'merged' => 'birleþtirildi',
        'closed successful' => 'kapatma baþarýlý',
        'closed unsuccessful' => 'kapatma baþarýsýz',
        'new' => 'yeni',
        'open' => 'aç',
        'closed' => 'kapalý',
        'removed' => 'kaldýrýldý',
        'pending reminder' => 'bekleyen hatýrlatýcý',
        'pending auto' => 'bekleyen otomatik',
        'pending auto close+' => 'bekleyen otomatik kapat+',
        'pending auto close-' => 'bekleyen otomatik kapat-',
        'email-external' => 'e-posta-haricî',
        'email-internal' => 'e-posta-dahilî',
        'note-external' => 'not-haricî',
        'note-internal' => 'not-dahilî',
        'note-report' => 'not-rapor',
        'phone' => 'telefon',
        'sms' => 'kýsa mesaj',
        'webrequest' => 'web isteði',
        'lock' => 'kilitle',
        'unlock' => 'kilidi aç',
        'very low' => 'çok düþük',
        'low' => 'düþük',
        'normal' => 'normal',
        'high' => 'yüksek',
        'very high' => 'çok yüksek',
        '1 very low' => '1 çok düþük',
        '2 low' => '2 düþük',
        '3 normal' => '3 normal',
        '4 high' => '4 yüksek',
        '5 very high' => '5 çok yüksek',
        'Ticket "%s" created!' => '"%s" bileti oluþturuldu!',
        'Ticket Number' => 'Bilet Numarasý',
        'Ticket Object' => 'Bilet Nesnesi',
        'No such Ticket Number "%s"! Can\'t link it!' => '"%s" Bilet Numarasý yok! Ona baðlanamaz!',
        'Don\'t show closed Tickets' => 'Kapalý Biletleri gösterme',
        'Show closed Tickets' => 'Kapalý Biletleri göster',
        'New Article' => 'Yeni Yazý',
        'Email-Ticket' => 'E-Posta-Bilet',
        'Create new Email Ticket' => 'Yeni E-Posta-Bilet oluþtur',
        'Phone-Ticket' => 'Telefon-Bilet',
        'Search Tickets' => 'Biletleri Ara',
        'Edit Customer Users' => 'Müþteri Kullanýcýlarý Belirle',
        'Edit Customer Company' => '',
        'Bulk-Action' => 'Toplu Ýþlem',
        'Bulk Actions on Tickets' => 'Biletler Üzerinde Toplu Ýþlem',
        'Send Email and create a new Ticket' => 'E-Postayý gönder ve yeni Bilet oluþtur',
        'Create new Email Ticket and send this out (Outbound)' => 'Yeni E-Posta-Bilet oluþtur ve bunu gönder (dýþarý)',
        'Create new Phone Ticket (Inbound)' => 'Yeni Telefon-Bilet',
        'Overview of all open Tickets' => 'Tüm açýk Biletlere genel bakýþ',
        'Locked Tickets' => 'Kilitli Biletler',
        'Watched Tickets' => 'Ýzlenen Biletler',
        'Watched' => 'Ýzlenen',
        'Subscribe' => 'Abone ol',
        'Unsubscribe' => 'Abonelikten çýk',
        'Lock it to work on it!' => 'Üzerinde çalýþmak için kilitle!',
        'Unlock to give it back to the queue!' => 'Kilidini kaldýr ve kuyruða geri ver!',
        'Shows the ticket history!' => 'Bilet geçmiþini gösterir!',
        'Print this ticket!' => 'Bu bileti yazdýr!',
        'Change the ticket priority!' => 'Bilet önceliðini deðiþtir!',
        'Change the ticket free fields!' => 'Biletteki serbest alanlarý deðiþtir!',
        'Link this ticket to an other objects!' => 'Bu bileti baþka nesnelere baðla!',
        'Change the ticket owner!' => 'Bilet sahibini deðiþtir!',
        'Change the ticket customer!' => 'Bilet müþterisini deðiþtir!',
        'Add a note to this ticket!' => 'Bu bilete bir not ekle!',
        'Merge this ticket!' => 'Bu bileti birleþtir!',
        'Set this ticket to pending!' => 'Bu bileti beklemeye al!',
        'Close this ticket!' => 'Bu bileti kapat!',
        'Look into a ticket!' => 'Bir bilete bak!',
        'Delete this ticket!' => 'Bu bileti sil!',
        'Mark as Spam!' => 'Spam (çöp) olarak iþaretle!',
        'My Queues' => 'Kuyruklarým',
        'Shown Tickets' => 'Gösterilen Biletler',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '"<OTRS_TICKET>" bilet numaralý e-postanýz "<OTRS_MERGE_TO_TICKET>" ile birleþtirildi.',
        'Ticket %s: first response time is over (%s)!' => 'Bilet %s: ilk yanýt zamaný aþýldý (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Bilet %s: %s içinde ilk yanýt zamaný aþýlacak!',
        'Ticket %s: update time is over (%s)!' => 'Bilet %s: güncelleme zamaný aþýldý (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Bilet %s: %s içinde güncelleme zamaný aþýlacak!',
        'Ticket %s: solution time is over (%s)!' => 'Bilet %s: çözme zamaný aþýldý (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Bilet %s: %s içinde çözme zamaný aþýlacak!',
        'There are more escalated tickets!' => 'Baþka yükseltilmiþ biletler var!',
        'New ticket notification' => 'Yeni bilet bildirimi',
        'Send me a notification if there is a new ticket in "My Queues".' => '"Kuyruklarým"da yeni bir bilet olduðunda bana bildirim gönder.',
        'Follow up notification' => 'Takip bildirimi',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Eðer bu biletin sahibi bensem ve bir müþteri takip eden mesaj gönderirse bana bildirim gönder.',
        'Ticket lock timeout notification' => 'Bilet kilidi zaman aþýmý bildirimi',
        'Send me a notification if a ticket is unlocked by the system.' => 'Bir biletin kilidi sistem tarafýndan kaldýrýldýðýnda bana bildirim gönder.',
        'Move notification' => 'Taþýma bildirimi',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Bilet "Kuyruklarým"dan birine taþýndýðýnda bana bildirim gönder',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Favori kuyruklarýnýzýn seçim kuyruðu. Bu kuyruklar hakkýnda da e-posta yoluyla (eðer açýksa) bildirim alýrsýnýz.',
        'Custom Queue' => 'Özel Kuyruk',
        'QueueView refresh time' => 'Kuyruk Görünümü tazeleme zamaný',
        'Screen after new ticket' => 'Yeni Biletten sonraki ekran',
        'Select your screen after creating a new ticket.' => 'Yeni bir bilet oluþturduktan sonra görmek istediðiniz ekraný seçin.',
        'Closed Tickets' => 'Kapanmýþ Biletler',
        'Show closed tickets.' => 'Kapanmýþ biletleri göster.',
        'Max. shown Tickets a page in QueueView.' => 'Kuyruk Görünümünde bir sayfada gösterilecek en fazla Bilet sayýsý.',
        'CompanyTickets' => 'Þirket Biletleri',
        'MyTickets' => 'Biletlerim',
        'New Ticket' => 'Yeni Bilet',
        'Create new Ticket' => 'Yeni Bilet oluþtur',
        'Customer called' => 'Aranan müþteri',
        'phone call' => 'telefon aramasý',
        'Responses' => 'Yanýtlar',
        'Responses <-> Queue' => 'Yanýtlar <-> Kuyruk',
        'Auto Responses' => 'Otomatik Yanýtlar',
        'Auto Responses <-> Queue' => 'Otomatik Yanýtlar <-> Kuyruk',
        'Attachments <-> Responses' => 'Ekler <-> Yanýtlar',
        'History::Move' => 'Bilet "%s" (%s) kuyruðuna taþýndý, "%s" (%s) kuyruðundan.',
        'History::TypeUpdate' => '"%s" (Kimlik=%s) tipi güncellendi.',
        'History::ServiceUpdate' => '"%s" (Kimlik=%s) servisi güncellendi.',
        'History::SLAUpdate' => '"%s" (Kimlik=%s) SLA güncellendi.',
        'History::NewTicket' => 'Yeni [%s] Bileti oluþturuldu (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => '[%s] için takip. %s',
        'History::SendAutoReject' => '"%s" için Otomatik Red gönderildi.',
        'History::SendAutoReply' => '"%s" için Otomatik Yanýt gönderildi.',
        'History::SendAutoFollowUp' => '"%s" için Otomatik Takip gönderildi.',
        'History::Forward' => '"%s" iletildi.',
        'History::Bounce' => '"%s" ötelendi.',
        'History::SendAnswer' => '"%s" için e-posta gönderildi.',
        'History::SendAgentNotification' => '"%s"- "%s" için aracýya bildirim gönderildi.',
        'History::SendCustomerNotification' => '"%s" için müþteriye bildirim gönderildi .',
        'History::EmailAgent' => 'Aracýya e-posta gönderildi.',
        'History::EmailCustomer' => 'Müþteriye e-posta gönderildi. %s',
        'History::PhoneCallAgent' => 'Aracý telefonla arandý.',
        'History::PhoneCallCustomer' => 'Müþteri telefonla arandý.',
        'History::AddNote' => 'Not eklendi (%s)',
        'History::Lock' => 'Bilet kilitlendi.',
        'History::Unlock' => 'Bilet kilidi çözüldü.',
        'History::TimeAccounting' => '%s zaman birimi hesaplandý. Toplam %s zaman birimi.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Güncellendi: %s',
        'History::PriorityUpdate' => 'Öncelik deðiþtirildi. Eski: "%s" (%s), Yeni: "%s" (%s).',
        'History::OwnerUpdate' => 'Yeni sahip "%s" (Kimlik=%s).',
        'History::LoopProtection' => 'Döngü Korumasý! "%s" için otomatik yanýt gönderilmedi.',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Güncellendi: %s',
        'History::StateUpdate' => 'Eski: "%s" Yeni: "%s"',
        'History::TicketFreeTextUpdate' => 'Güncellendi: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Web üzerinden Müþteri Ýsteði.',
        'History::TicketLinkAdd' => '"%s" biletine köprü eklendi.',
        'History::TicketLinkDelete' => '"%s" biletine köprü silinde.',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Paz',
        'Mon' => 'Pzt',
        'Tue' => 'Sal',
        'Wed' => 'Çar',
        'Thu' => 'Per',
        'Fri' => 'Cum',
        'Sat' => 'Cts',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Eklenti yönetimi',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Otomatik Yanýt Yönetimi',
        'Response' => 'Yanýt',
        'Auto Response From' => 'Otomatik Yanýtlayan',
        'Note' => 'Not',
        'Useable options' => 'Kullanýlabilir seçenekler',
        'To get the first 20 character of the subject.' => 'Konunun ilk 20 karakterini al',
        'To get the first 5 lines of the email.' => 'Elektronik postanýn ilk 5 satýrýný al',
        'To get the realname of the sender (if given).' => 'Gönderenin gerçek adýný al (verilmiþse)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Yazý niteliklerini al (örneðin (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> ve <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Mevcut müþteri kullanýcý verisi seçenekleri (örneðin <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Bilet sahibi seçenekleri (örneðin <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Bilet sorumlusu seçenekleri (örneðin <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Bu eyleme isteyen etkin kullanýcý seçenekleri (örneðin <OTRS_CURRENT_UserFirstname).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Bilet verisi seçenekleri (örneðin <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Yapýlandýrma seçenekleri (örneðin <OTRS_CONFIG_HttpType).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Müþteri Þirket Yönetimi',
        'Search for' => 'Ara',
        'Add Customer Company' => 'Müþteri Sirket Ekle',
        'Add a new Customer Company.' => 'Yeni bir Müþteri Þirket ekle.',
        'List' => 'Liste',
        'This values are required.' => 'Bu deðerler gereklidir.',
        'This values are read only.' => 'Bu deðerler salt-okunurdur.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Müþteri Kullanýcý Yönetimi',
        'Add Customer User' => 'Müþteri Kullanýcý Ekle',
        'Source' => 'Kaynak',
        'Create' => 'Oluþtur',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Müþteri kullanýcý bir müþteri geçmiþi ve müþteri panelinden oturum açmak için gereklidir.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Müþteri Kullanýcýlar <-> Grup Yönetimi',
        'Change %s settings' => '%s ayarlarýný deðiþtir',
        'Select the user:group permissions.' => 'Kullanýcý:grup izinlerini deðiþtir.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Eðer hiçbirþey seçilmemiþse, bu grupta hiç izin yoktu (biletler kullanýcýya açýk olmayacaktýr).',
        'Permission' => 'Ýzin',
        'ro' => 'so',
        'Read only access to the ticket in this group/queue.' => 'Bu grup/kuyruktaki bilete salt okunur eriþim.',
        'rw' => 'oy',
        'Full read and write access to the tickets in this group/queue.' => 'Bu grup/kuyruktaki biletlere tam okuma ve yazma eriþimi.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Kullanýcý Müþteriler <-> Servis Yönetimi',
        'CustomerUser' => 'MüþteriKullanýcý',
        'Service' => 'Servis',
        'Edit default services.' => 'Varsayýlan servisleri belirle.',
        'Search Result' => 'Arama Sonuç',
        'Allocate services to CustomerUser' => 'Servisleri MüþteriKullanýcýya ata',
        'Active' => 'Etkin',
        'Allocate CustomerUser to service' => 'MüþteriKullanýcýyý servise ata',

        # Template: AdminEmail
        'Message sent to' => 'Mesaj gönderildi',
        'Recipents' => 'Alýcýlar',
        'Body' => 'Gövde',
        'Send' => 'Gönder',

        # Template: AdminGenericAgent
        'GenericAgent' => 'GenelAracý',
        'Job-List' => 'Ýþ Listesi',
        'Last run' => 'Son çalýþtýrma',
        'Run Now!' => 'Þimdi Çalýþtýr!',
        'x' => 'x',
        'Save Job as?' => 'Ýþi ne olarak kaydedeyim?',
        'Is Job Valid?' => 'Ýþ geçerli mi?',
        'Is Job Valid' => 'Ýþin geçerli olup olmadýðý',
        'Schedule' => 'Takvim',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Mesajda tam metin aramasý (örneðin "Ay*egül" veya "Çak*r")',
        '(e. g. 10*5155 or 105658*)' => '(örneðin 105155 veya 105658*)',
        '(e. g. 234321)' => '(örneðin 234321)',
        'Customer User Login' => 'Müþteri Kullanýcý Oturum Açma',
        '(e. g. U5150)' => '(örneðin U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Aracý',
        'Ticket Lock' => 'Bilet Kilidi',
        'TicketFreeFields' => 'BiletSerbestAlanlarý',
        'Create Times' => 'Oluþturma Zamanlarý',
        'No create time settings.' => 'Oluþturma zamaný ayarý yok.',
        'Ticket created' => 'Bilet oluþturuldu',
        'Ticket created between' => 'Bilet ikisi arasýnda oluþturuldu:',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => 'Bekleme Zamanlarý',
        'No pending time settings.' => 'Bekleme zamaný ayarý yok.',
        'Ticket pending time reached' => 'Bilet bekleme zamanýna ulaþýldý',
        'Ticket pending time reached between' => 'Bilet bekleme zamanýna ikisi arasýnda ulaþýldý:',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => 'Yeni Öncelik',
        'New Queue' => 'Yeni Kuyruk',
        'New State' => 'Yeni Durum',
        'New Agent' => 'Yeni Aracý',
        'New Owner' => 'Yeni Sahip',
        'New Customer' => 'Yeni Müþteri',
        'New Ticket Lock' => 'Yeni Bilet Kilidi',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => 'Yeni BiletSerbestAlanlarý',
        'Add Note' => 'Not Ekle',
        'CMD' => 'Komut',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Bu komut çalýþtýrýlacak. Par[0] bilet bilet numarasý olacak. Par[1] bilet kimliði.',
        'Delete tickets' => 'Biletleri sil',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Uyarý! Bu biletler veritabanýndan silinecek! Geri dönüþü yoktur!',
        'Send Notification' => 'Bildirim Gönder',
        'Param 1' => 'Param 1',
        'Param 2' => 'Param 2',
        'Param 3' => 'Param 3',
        'Param 4' => 'Param 4',
        'Param 5' => 'Param 5',
        'Param 6' => 'Param 6',
        'Send no notifications' => 'Bildirim gönderme',
        'Yes means, send no agent and customer notifications on changes.' => 'Evet, deðiþiklik durumunda aracýlar ve müþterilere bildirim gönderme demektir.',
        'No means, send agent and customer notifications on changes.' => 'Hayýr, deðiþikliklerde aracýlara ve müþterilere bildirim gönder demektir.',
        'Save' => 'Kaydet',
        '%s Tickets affected! Do you really want to use this job?' => '%s Bilet etkilendi! Gerçekten bu iþi kullanmak istiyor musunuz?',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Grup Yönetimi',
        'Add Group' => 'Grup Ekle',
        'Add a new Group.' => 'Yeni bir Grup ekle.',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Yönetim grubu yönetim alanýna ve istatistikler grubu istatistik alanýna girmek içindir.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Farklý aracý gruplarýnýn (örneðin satýnalma bölümü, destek bölümü, satýþ bölümü, ...) eriþim izinlerini düzenlemek için yeni gruplarý oluþtur.',
        'It\'s useful for ASP solutions.' => 'ASP çözümleri için kullanýþlýdýr.',

        # Template: AdminLog
        'System Log' => 'Sistem Günlüðü',
        'Time' => 'Zaman',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => 'Sunucu',
        'Trusted' => 'Güvenilir',
        'Dispatching' => 'Gönderiliyor',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Tek hesaplý tüm gelen elektronik postalar seçili kuyruða gönderilecek!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Eðer hesap güvenilir ise, varýþ zamanýnda (öncelik, ... için) varolan X-OTRS baþlýðý kullanýlacak! PostMaster süzgeci her halükârda kullanýlýr.',

        # Template: AdminNavigationBar
        'Users' => 'Kullanýcýlar',
        'Groups' => 'Gruplar',
        'Misc' => 'Çeþitli',

        # Template: AdminNotificationForm
        'Notification Management' => 'Bildirim Yönetimi',
        'Notification' => 'Bildirimler',
        'Notifications are sent to an agent or a customer.' => 'Bildirimler bir aracýya veya müþteriye gönderilirler.',

        # Template: AdminPackageManager
        'Package Manager' => 'Paket Yöneticisi',
        'Uninstall' => 'Kaldýr',
        'Version' => 'Sürüm',
        'Do you really want to uninstall this package?' => 'Gerçekten bu paketi kaldýrmak istiyor musunuz?',
        'Reinstall' => 'Yeniden yükle',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Gerçekten bu paketi yeniden yüklemek istiyor musunuz (elle yaptýðýnýz tüm deðiþiklikler gider)?',
        'Continue' => 'Devam et',
        'Install' => 'Yükle',
        'Package' => 'Paket',
        'Online Repository' => 'Çevrimiçi Depo',
        'Vendor' => 'Saðlayýcý',
        'Upgrade' => 'Yükselt',
        'Local Repository' => 'Yerel Depo',
        'Status' => 'Durum',
        'Overview' => 'Genel Bakýþ',
        'Download' => 'Ýndir',
        'Rebuild' => 'Yeniden Ýnþa Et',
        'ChangeLog' => 'Deðiþiklik Günlüðü',
        'Date' => 'Tarih',
        'Filelist' => 'Dosya listesi',
        'Download file from package!' => 'Paketten dosya indir!',
        'Required' => 'Gerektirir',
        'PrimaryKey' => 'Ana Anahtar',
        'AutoIncrement' => 'Otomatik Arttýr',
        'SQL' => 'SQL',
        'Diff' => 'Fark',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performans Günlüðü',
        'This feature is enabled!' => 'Bu özellik açýk!',
        'Just use this feature if you want to log each request.' => 'Bu özelliði sadece her isteði günlüðe kaydetmek istiyorsanýz kullanýn.',
        'Of couse this feature will take some system performance it self!' => 'Elbette bu özellik sistem performansýndan biraz alýr.',
        'Disable it here!' => 'Burada kapat!',
        'This feature is disabled!' => 'Bu özellik kapalý!',
        'Enable it here!' => 'Burada aç!',
        'Logfile too large!' => 'Günlük dosyasý çok büyük!',
        'Logfile too large, you need to reset it!' => 'Günlük dosyasý çok büyük, boþaltmalýsýnýz!',
        'Range' => 'Aralýk',
        'Interface' => 'Arayüz',
        'Requests' => 'Ýstekler',
        'Min Response' => 'En Az Yanýt',
        'Max Response' => 'En Çok Yanýt',
        'Average Response' => 'Ortalama Yanýt',
        'Period' => '',
        'Min' => '',
        'Max' => '',
        'Average' => '',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP Yönetimi',
        'Result' => 'Sonuç',
        'Identifier' => 'Tanýmlayýcý',
        'Bit' => 'Bit',
        'Key' => 'Anahtar',
        'Fingerprint' => 'Parmak izi',
        'Expires' => 'Geçerliliðini yitirme zamaný',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Bu þekilde Sistem Yapýlandýrmasýnda yapýlandýrýlmýþ olan anahtar halkasýný (keyring) direkt olarak düzenleyebilirsiniz.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Süzgeç Yönetimi',
        'Filtername' => 'Süzgeç adý',
        'Match' => 'Eþleþen',
        'Header' => 'Baþlýk',
        'Value' => 'Deðer',
        'Set' => 'Küme',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Gelen elektronik postalarý gönderme veya süzme iþlemini elektronik postadaki X-Baþlýklarýna göre yap! Düzenli ifadeler (RegExp) de kullanýlabilir.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Sadece elektronik posta adresine göre eþleþtirmek istiyorsanýz Kimden, Kime veya Karbon Kopya alanlarýnda EMAILADDRESS:bilgi@ornek.com kullanýn.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Düzenli ifadeler (RegExp) kullanýrsanýz, \'Küme\' kýsmýnda eþleþen deðer için () yerine [***]da kullanabilirsiniz. ',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Kuyruk <-> Otomatik Yanýt Yönetimi',

        # Template: AdminQueueForm
        'Queue Management' => 'Kuyruk Yönetimi',
        'Sub-Queue of' => 'Þunun Alt Kuyruðu:',
        'Unlock timeout' => 'Kilidi kaldýrmak için zaman aþýmý',
        '0 = no unlock' => '0 = kilit kaldýrma yok',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => 'Yükseltme - ilk Yanýt Zamaný',
        '0 = no escalation' => '0 = yükseltme yok',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => 'Yükseltme - Güncelleme Zamaný',
        'Notify by' => '',
        'Escalation - Solution Time' => 'Yükseltme - Çözümleme Zamaný',
        'Follow up Option' => 'Takip eden Seçeneði',
        'Ticket lock after a follow up' => 'Takip eden bir mesajdan sonra bileti kilitle',
        'Systemaddress' => 'Sistem adresi',
        'Customer Move Notify' => 'Müþteri Taþýma Bildirimi',
        'Customer State Notify' => 'Müþteri Durum Bildirimi',
        'Customer Owner Notify' => 'Müþteri Sahip Bildirimi',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Eðer bir aracý bir bileti kilitler ve bu sürede bir yanýt göndermezse, biletin kilidi otomatik olarak kaldýrýlýr. Dolayýsýyla bilet diðer tüm aracýlara görünür hale gelir.',
        'Escalation time' => 'Yükseltme zamaný',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Eðer bir bilet bu süre zarfýnda yanýtlanmazsa, sadece bu bilet gösterilir.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Eðer bir bilet kapatýlýrsa ve ardýndan müþteri bir mesaj gönderirse, bilet eski sahibi için kilitlenir.',
        'Will be the sender address of this queue for email answers.' => 'Elektronik posta yanýtlarý için bu kuyruðun gönderen adresi olur.',
        'The salutation for email answers.' => 'Elektronik posta yanýtlarý için selamlama.',
        'The signature for email answers.' => 'Elektronik posta yanýtlarý için imza.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'Eðer bilet taþýnýrsa OTRS müþteriye bir bildirim e-postasý gönderir.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'Eðer bilet durumu deðiþirse OTRS müþteriye bir bildirim e-postasý gönderir.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'Eðer bilet sahibi deðiþirse OTRS müþteriye bir bildirim e-postasý gönderir.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Yanýtlar <-> Kuyruk Yönetimi',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Cevapla',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Yanýtlar <-> Ekler Yönetimi',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Yanýt Yönetimi',
        'A response is default text to write faster answer (with default text) to customers.' => 'Bir yanýt, müþterilere daha hýzlý cevap yazabilmek için önceden hazýrlanan metindir.',
        'Don\'t forget to add a new response a queue!' => 'Yeni bir yanýtý bir kuyruða eklemeyi unutmayýn!',
        'The current ticket state is' => 'Bilet durumu',
        'Your email address is new' => 'E-posta adresiniz yeni',

        # Template: AdminRoleForm
        'Role Management' => 'Rol Yönetimi',
        'Add Role' => 'Rol Ekle',
        'Add a new Role.' => 'Yeni bir Rol ekle.',
        'Create a role and put groups in it. Then add the role to the users.' => 'Bir rol oluþturun ve içine gruplardan koyun. Sonra rolu kullanýcýlara atayýn.',
        'It\'s useful for a lot of users and groups.' => 'Çok sayýda kullanýcý ve grup için kullanýþlýdýr.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Roller <-> Gruplar Yönetimi',
        'move_into' => 'taþý',
        'Permissions to move tickets into this group/queue.' => 'Biletleri bu gruba/kuyruða taþýma izni.',
        'create' => 'yarat',
        'Permissions to create tickets in this group/queue.' => 'Bu grupta/kuyrukta bilet oluþturma izni.',
        'owner' => 'sahip',
        'Permissions to change the ticket owner in this group/queue.' => 'Bu grupta/kuyrukta bilet sahibini deðiþtirme izni.',
        'priority' => 'öncelik',
        'Permissions to change the ticket priority in this group/queue.' => 'Bu grupta/kuyrukta bilet önceliðini deðiþtirme izni.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rol',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Roller <-> Kullanýcýlar Yönetimi',
        'Select the role:user relations.' => 'Rol:kullanýcý iliþkilerini seçin.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Selamlama Yönetimi',
        'Add Salutation' => 'Selamlama Ekle',
        'Add a new Salutation.' => 'Yeni bir Selamlama ekle.',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => 'Sýnýr',
        'Go' => 'Devam',
        'Select Box Result' => 'Seçin Kutusu Sonucu',

        # Template: AdminService
        'Service Management' => 'Servis Yönetimi',
        'Add Service' => 'Servis Ekle',
        'Add a new Service.' => 'Yeni bir Servis ekle.',
        'Sub-Service of' => 'Þunun Alt Servisi:',

        # Template: AdminSession
        'Session Management' => 'Oturum Yönetimi',
        'Sessions' => 'Oturumlar',
        'Uniq' => 'Tekil',
        'Kill all sessions' => 'Tüm oturumlarý öldür',
        'Session' => 'Oturum',
        'Content' => 'Içerik',
        'kill session' => 'oturumu öldür',

        # Template: AdminSignatureForm
        'Signature Management' => 'Ýmza Yönetimi',
        'Add Signature' => 'Ýmza Ekle',
        'Add a new Signature.' => 'Yeni bir Ýmza ekle.',

        # Template: AdminSLA
        'SLA Management' => 'SLA Yönetimi',
        'Add SLA' => 'SLA ekle',
        'Add a new SLA.' => 'Yeni bir SLA ekle.',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME Yönetimi',
        'Add Certificate' => 'Sertifika Ekle',
        'Add Private Key' => 'Kiþisel Anahtar Ekle',
        'Secret' => 'Gizli',
        'Hash' => 'Özel katar (hash)',
        'In this way you can directly edit the certification and private keys in file system.' => 'Buradan dosya sistemindeki sertifikalarý ve kiþisel anahtarlarý uðraþmadan düzenleyebilirsiniz.',

        # Template: AdminStateForm
        'State Management' => 'Durum Yönetimi',
        'Add State' => 'Durum Ekle',
        'Add a new State.' => 'Yeni bir Durum ekle.',
        'State Type' => 'Durum Tipi',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Kernel/Config.pm içindeki öntanýmlý durumlarý da deðiþtirdiðinizi unutmayýn',
        'See also' => 'Ayrýca bakýnýz',

        # Template: AdminSysConfig
        'SysConfig' => 'Sistem Yapýlandýrmasý',
        'Group selection' => 'Grup seçimi',
        'Show' => 'Göster',
        'Download Settings' => 'Ýndirme Ayarlarý',
        'Download all system config changes.' => 'Tüm sistem yapýlandýrma deðiþikliklerini indir.',
        'Load Settings' => 'Ayarlarý Yükle',
        'Subgroup' => 'Alt grup',
        'Elements' => 'Öðeler',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Yapýlandýrma Seçenekleri',
        'Default' => 'Öntanýmlý',
        'New' => 'Yeni',
        'New Group' => 'Yeni Grup',
        'Group Ro' => 'Grup Ro',
        'New Group Ro' => 'Yeni Grup Ro',
        'NavBarName' => 'Dolaþma Çubuðu Adý',
        'NavBar' => 'Dolaþma Çubuðu',
        'Image' => 'Resim',
        'Prio' => 'Öncelik',
        'Block' => 'Blok',
        'AccessKey' => 'Eriþim Tuþu',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Sistem E-Posta Adresleri Yönetimi',
        'Add System Address' => 'Sistem Adresi Ekle',
        'Add a new System Address.' => 'Yeni bir Sistem Adresi ekle.',
        'Realname' => 'Gerçek ad',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Bu e-posta adresinden gelen tüm e-postalar seçili kuyruða yönlendirilir.',

        # Template: AdminTypeForm
        'Type Management' => 'Tip Yönetimi',
        'Add Type' => 'Tip Ekle',
        'Add a new Type.' => 'Yeni bir Tip ekle.',

        # Template: AdminUserForm
        'User Management' => 'Kullanýcý Yönetimi',
        'Add User' => 'Kullanýcý Ekle',
        'Add a new Agent.' => 'Yeni bir Aracý ekle.',
        'Login as' => 'Oturum açma kimliði',
        'Firstname' => 'Adý',
        'Lastname' => 'Soyadý',
        'User will be needed to handle tickets.' => 'Biletlerle ilgilenmek için kullanýcý gerekir.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Yeni kullanýcýlarý gruplara ve/veya rollere eklemeyi unutmayýn!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Kullanýcýlar <-> Gruplar Yönetimi',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adres Defteri',
        'Return to the compose screen' => 'Oluþturma ekranýna geri dön',
        'Discard all changes and return to the compose screen' => 'Tüm deðiþiklikleri geri al ve oluþturma ekranýna geri dön',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => 'Bilgi',

        # Template: AgentLinkObject
        'Link Object' => 'Bað Nesnesi',
        'Select' => 'Seç',
        'Results' => 'Sonuçlar',
        'Total hits' => 'Toplam isabet',
        'Page' => 'Sayfa',
        'Detail' => 'Detay',

        # Template: AgentLookup
        'Lookup' => 'Ara',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Sözdizim Denetleyicisi',
        'spelling error(s)' => 'sözdizim hatasý',
        'or' => 'veya',
        'Apply these changes' => 'Bu deðiþiklikleri uygula',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Gerçekten bu nesneyi silmek istiyor musunuz?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Ýstatistiði kiþiselleþtirmek için kýsýtlamalarý seçin',
        'Fixed' => 'Sabit',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Lütfen sadece bir öðe seçin veya \'Sabit\' düðmesini kapatýn.',
        'Absolut Period' => 'Belirli Süre',
        'Between' => 'Arasýnda',
        'Relative Period' => 'Deðiþken Süre',
        'The last' => 'Son',
        'Finish' => 'Bitir',
        'Here you can make restrictions to your stat.' => 'Burada istatistiklerinize kýsýtlamalar yapabilirsiniz.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '"Sabit" kutusunun iþaretini kaldýrýrsanýz, istatistiði oluþturan aracý karþýlýk gelen öðenin niteliklerini deðiþtirebilir.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Sadece ortak belirtimleri gir',
        'Permissions' => 'Ýzinler',
        'Format' => 'Biçim',
        'Graphsize' => 'Grafik boyutu',
        'Sum rows' => 'Toplam satýrlarý',
        'Sum columns' => 'Toplam sütunlarý',
        'Cache' => 'Tampon',
        'Required Field' => 'Gerekli alan',
        'Selection needed' => 'Seçim gerekli',
        'Explanation' => 'Açýklama',
        'In this form you can select the basic specifications.' => 'Bu formda temel belirtimleri seçebilirsiniz.',
        'Attribute' => 'Nitelik',
        'Title of the stat.' => 'Ýstatistiðin baþlýðý.',
        'Here you can insert a description of the stat.' => 'Buraya istatistiðe bir açýklama girebilirsiniz.',
        'Dynamic-Object' => 'Dinamik Nesne',
        'Here you can select the dynamic object you want to use.' => 'Burada kullanmak istediðiniz dinamik nesneyi seçebilirsiniz.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Not: Kaç dinamik nesne kullanabileceðiniz kurulumunuza baðlýdýr)',
        'Static-File' => 'Sabit Dosya',
        'For very complex stats it is possible to include a hardcoded file.' => 'Çok karmaþýk istatistikler söz konusu olduðunda önceden hazýrlanmýþ bir dosyayý da dahil etmek mümkündür.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Eðer önceden hazýrlanmýþ bir dosya bulunursa bu nitelik gösterilir ve birini seçebilirsiniz.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Ýzin ayarlarý. Ayarlanan istatistiðin farklý aracýlara görünür olmasý için bir veya daha fazla grup seçebilirsiniz.',
        'Multiple selection of the output format.' => 'Çýktý biçimi için birden fazla seçim.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Eðer çýktý biçimi olana bir grafik seçerseniz en azýndan bir grafik boyutu seçmelisiniz.',
        'If you need the sum of every row select yes' => 'Her satýrýn toplanmasýný istiyorsanýz \'Evet\'i seçin',
        'If you need the sum of every column select yes.' => 'Her sütunun toplanmasýný istiyorsanýz \'Evet\'i seçin.',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Ýstatistiklerin çoðunluðu önbelleklenebilir. Bu, bu istatistiðin sunulmasýný hýzlandýrýr.',
        '(Note: Useful for big databases and low performance server)' => '(Not: Büyük veritabaný ve düþük performanslý sunucularda kullanýþlýdýr)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Geçersiz bir istatistikle, istatistik oluþturmak mümkün olmaz.',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Eðer istatistik sonuçlarýnýn kimseye açýk olmamasýný veya istatistiðin yapýlandýrýlmamýþ olmamasýný istiyorsanýz bu seçenek kullanýþlýdýr.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Deðer serileri için öðeleri seçin',
        'Scale' => 'Ölçek',
        'minimal' => 'mümkün olan en düþük',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Unutmayýn deðer serilerinin ölçeði X-ekseninin ölçeðinden daha yüksek olmalýdýr (örneðin X-ekseni => Ay, Deðer Serileri => Yýl).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Burada deðer serilerini seçebilirsiniz. Bir veya iki öðe seçebilirsiniz. Sonra öðelerin niteliklerini seçebilirsiniz. Her nitelik tek deðer serileri olarak gösterilir. Eðer herhangi bir nitelik seçmeden istatistik oluþturursanýz öðenin tüm nitelikleri kullanýlýr.  Son yapýlandýrmadan sonra yeni bir nitelik eklendiðinde de.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'X-ekseni olarak kullanýlacak öðeyi seçin.',
        'maximal period' => 'en yüksek süre',
        'minimal scale' => 'en düþük ölçek',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Burada X eksenini belirleyebilirsiniz. Radyo düðmesiyle bir öðe seçebilirsiniz. Sonra öðenin iki veya daha fazla niteliðini seçmelisiniz. Herhangi bir seçim yapmadan bir istatistik oluþturursanýz öðenin tüm nitelikleri kullanýlýr. Son yapýlandýrmadan sonra bir nitelik eklendiðinde de.',

        # Template: AgentStatsImport
        'Import' => 'Ýçeri aktar',
        'File is not a Stats config' => 'Dosya bir Ýstatistik yapýlandýrmasý deðil',
        'No File selected' => 'Dosya seçilmedi',

        # Template: AgentStatsOverview
        'Object' => 'Nesne',

        # Template: AgentStatsPrint
        'Print' => 'Yazdýr',
        'No Element selected.' => 'Öðe seçilmedi.',

        # Template: AgentStatsView
        'Export Config' => 'Yapýlandýrmayý Dýþarý Aktar',
        'Information about the Stat' => 'Ýstatistik hakkýnda bilgi',
        'Exchange Axis' => 'Eksenlerin Yerini Deðiþtir',
        'Configurable params of static stat' => 'Deðiþmez istatistiðin ayarlanabilir parametreleri',
        'No element selected.' => 'Öðe seçilmedi.',
        'maximal period from' => 'en yüksek süre þundan:',
        'to' => 'þuna:',
        'Start' => 'Baþla',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Giriþ ve seçme alanlarýyla istatistiði istediðiniz gibi ayarlayabilirsiniz. Ýstatistiðin hangi öðelerini deðiþtrebileceðiniz istatistiði ayarlayan istatistik yöneticisine baðlýdýr',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Bileti ötele',
        'Ticket locked!' => 'Bilet kilitlendi!',
        'Ticket unlock!' => 'Biletin kilidi açýldý!',
        'Bounce to' => 'Þuna ötele:',
        'Next ticket state' => 'Biletin sonraki durumu',
        'Inform sender' => 'Göndereni bilgilendir',
        'Send mail!' => 'Postayý gönder!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Bilet Toplu Ýþlemi',
        'Spell Check' => 'Sözdizim Kontrolü',
        'Note type' => 'Not tipi',
        'Unlock Tickets' => 'Biletlerin kilidini aç',

        # Template: AgentTicketClose
        'Close ticket' => 'Bileti kapat',
        'Previous Owner' => 'Önceki sahip',
        'Inform Agent' => 'Aracýyý bilgilendir',
        'Optional' => 'Seçimlik',
        'Inform involved Agents' => 'Ýlgili aracýlarý bilgilendir',
        'Attach' => 'Ekle',
        'Next state' => 'Sonraki durum',
        'Pending date' => 'Bekleme tarihi',
        'Time units' => 'Zaman birimleri',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Bilete cevap yaz',
        'Pending Date' => 'Bekleme tarihi',
        'for pending* states' => 'Bekleme* durumlarý için',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Biletin müþterisini deðiþtir',
        'Set customer user and customer id of a ticket' => 'Bir biletin müþteri kullanýcýsýný ve müþteri kimliðini belirle',
        'Customer User' => 'Müþteri Kullanýcý',
        'Search Customer' => 'Kullanýcý Ara',
        'Customer Data' => 'Müþteri Verisi',
        'Customer history' => 'Müþteri tarihçesi',
        'All customer tickets.' => 'Tüm müþteri biletleri.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Takip',

        # Template: AgentTicketEmail
        'Compose Email' => 'E-Posta Yaz',
        'new ticket' => 'yeni bilet',
        'Refresh' => 'Tazele',
        'Clear To' => 'Kime alanýný temizle',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'yukarý',
        'down' => 'aþaðý',
        'Escalation' => '',
        'Locked' => 'Kilitli',

        # Template: AgentTicketForward
        'Article type' => 'Metin tipi',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Biletin serbest metnini deðiþtir',

        # Template: AgentTicketHistory
        'History of' => 'Þunun tarihçesi:',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Posta kutusu',
        'Tickets' => 'Biletler',
        'of' => '..nýn',
        'Filter' => 'Süzgeç',
        'New messages' => 'Yeni mesajlar',
        'Reminder' => 'Hatýrlatýcý',
        'Sort by' => 'Þuna göre sýrala:',
        'Order' => 'Sýralama',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Bilet Birleþtir',
        'Merge to' => 'Þuna birleþtir:',

        # Template: AgentTicketMove
        'Move Ticket' => 'Bileti Taþý',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Bilete not ekle',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Biletin sahibini deðiþtir',

        # Template: AgentTicketPending
        'Set Pending' => 'Beklemeyi Ayarla',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefon arasý',
        'Clear From' => 'Gönderen kýsmýný temizle',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Düz',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Bilet Bilgisi',
        'Accounted time' => 'Hesaplanan zaman',
        'First Response Time' => 'Ýlk Yanýt Zamaný',
        'Update Time' => 'Güncelleme Zamaný',
        'Solution Time' => 'Çözüm Zamaný',
        'Linked-Object' => 'Baðlý Nesne',
        'Parent-Object' => 'Ebeveyn Nesne',
        'Child-Object' => 'Alt Nesne',
        'by' => 'tarafýndan',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Biletin önceliðini deðiþtir',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Gösterilen biletler',
        'Tickets available' => 'Uygun biletler',
        'All tickets' => 'Tüm biletler',
        'Queues' => 'Kuyruklar',
        'Ticket escalation!' => 'Bilet Yükseltme!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => 'Servis Zamaný',
        'Your own Ticket' => 'Kendi Biletiniz',
        'Compose Follow up' => 'Takip mesajý yaz',
        'Compose Answer' => 'Cevap yaz',
        'Contact customer' => 'Müþteriyle baðlantý kur',
        'Change queue' => 'Kuyruðu deðiþtir',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Biletin sorumlusunu deðiþtir',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Bilet ara',
        'Profile' => 'Profil',
        'Search-Template' => 'Arama Þablonu',
        'TicketFreeText' => 'BiletSerbestMetni',
        'Created in Queue' => 'Oluþturuldu Kuyruk',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'Sonuç Formu',
        'Save Search-Profile as Template?' => 'Arama Profili Þablon olarak kaydedilsin mi?',
        'Yes, save it with name' => 'Evet, þu adla kaydet',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Arama seçeneklerini deðiþtir',

        # Template: AgentTicketSearchResultPrint
        '"}' => '',

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Bilet Durumu Görünümü',
        'Open Tickets' => 'Açýk Biletler',

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Geriiz',

        # Template: CustomerFooter
        'Powered by' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Oturum aç',
        'Lost your password?' => 'Parolanýzý mý kaybettiniz?',
        'Request new password' => 'Yeni parola iste',
        'Create Account' => 'Hesap oluþtur',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Hoþgeldin %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Zaman',
        'No time settings.' => 'Zaman ayarý yok.',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Hata raporlamak için buraya týklayýn!',

        # Template: Footer
        'Top of Page' => 'Yukarý',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Webden Yükleme',
        'Welcome to %s' => '%s sistemine hoþgeldiniz',
        'Accept license' => 'Lisansý kabul et',
        'Don\'t accept license' => 'Lisansý kabul etme',
        'Admin-User' => 'Yönetici Kullanýcý',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Yönetici Parolasý',
        'Database-User' => 'Veritabaný kullanýcýsý',
        'default \'hot\'' => 'varsayýlan \'host\'',
        'DB connect host' => 'Veritabanýna baðlanan sunucu',
        'Database' => 'Veritabaný',
        'Default Charset' => 'Öntanýmlý karakter kümesi',
        'utf8' => '',
        'false' => 'false',
        'SystemID' => 'Sistem Kimliði',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Sistemin kimliði. Her bilet numarasý ve her http oturum kimliði bu numarayla baþlar)',
        'System FQDN' => 'Sistem tam adresi (FQDN)',
        '(Full qualified domain name of your system)' => '(Sisteminizin eksiksiz sunucu adresi (FQDN))',
        'AdminEmail' => 'Yönetici E-Posta Adresi',
        '(Email of the system admin)' => '(Sistem yöneticisinin e-posta adresi)',
        'Organization' => 'Kuruluþ',
        'Log' => 'Günlük',
        'LogModule' => 'Günlük Bileþeni',
        '(Used log backend)' => '(Kullanýlan günlük arkaucu)',
        'Logfile' => 'Günlük dosyasý',
        '(Logfile just needed for File-LogModule!)' => '(Günlük dosyasý sadece günlük bileþeni Dosya olduðunda gereklidir!)',
        'Webfrontend' => 'Web Önyüzü',
        'Use utf-8 it your database supports it!' => 'Eðer veritabanýnýz destekliyorsa utf-8 kullanýn!',
        'Default Language' => 'Öntanýmlý dil',
        '(Used default language)' => '(Kullanýlan öntanýmlý dil)',
        'CheckMXRecord' => 'MX Kayýtlarýný Kontrol Et',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kullanýlan e-posta adreslerinin MX kayýtlarýný bir cevap yazarak kontrol eder. Eðer OTRS sisteminiz çevirmeli bir aðýn arkasýndaysa kullanmayýn!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'OTRS\'yi kullanabilmek için komut satýrýnda (konsol/kabuk/terminal) root kullanýcýsý olarak þu satýrý girmelisiniz.',
        'Restart your webserver' => 'Web sunucunuzu yeniden baþlatýn.',
        'After doing so your OTRS is up and running.' => 'Bunu yaptýktan sonra OTRS çalýþýyor olacak.',
        'Start page' => 'Baþlangýç sayfasý',
        'Your OTRS Team' => 'OTRS Takýmýnýz',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ýzin yok',

        # Template: Notify
        'Important' => 'Önemli',

        # Template: PrintFooter
        'URL' => 'Adres (URL)',

        # Template: PrintHeader
        'printed by' => 'yazdýran',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS Test Sayfasý',
        'Counter' => 'Sayaç',

        # Template: Warning
        # Misc
        'Create Database' => 'Veritabanýný Oluþtur',
        'verified' => 'onaylandý',
        'File-Name' => 'Dosya adý',
        'Ticket Number Generator' => 'Bilet Numarasý Üreteci',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Bilet tanýmlayýcýsý. \'Bilet#\', \'Arama#\' oder \'Biletim#\' gibi olabilir)',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Bu þekilde Kernel/Config.pm dosyasýnda yapýlandýrýlmýþ olan anahtar halkasýný (keyring) deðiþtirebilirsiniz',
        'Create new Phone Ticket' => 'Yeni Telefon Bileti oluþtur',
        'U' => 'U',
        'A message should have a To: recipient!' => 'Bir mesajýn alýcýsý olmalýdýr!',
        'Site' => 'Site',
        'Customer history search (e. g. "ID342425").' => 'Müþteri tarihçe aramasý (örn. "ID342425").',
        'your MySQL DB should have a root password! Default is empty!' => 'MySQL veritabanýnýzýn root kullanýcýsýnýn bir parolasý olmalýdýr. Öntanýmlý olarak boþtur!',
        'Close!' => 'Kapat!',
        'for agent firstname' => 'aracý adý için',
        'Reporter' => 'Bildiren',
        'The message being composed has been closed.  Exiting.' => 'Oluþturulan mesaj kapatýldý. Çýkýlýyor.',
        'Process-Path' => 'Ýþlem Yolu',
        'to get the realname of the sender (if given)' => 'göndericinin gerçek adýný (eðer verilmiþse) almak için',
        'FAQ Search Result' => 'SSS Arama Sonucu',
        'Notification (Customer)' => 'Bildirim (müþteri)',
        'CSV' => 'CSV',
        'Select Source (for add)' => 'Kaynaðý Seçin (eklemek için)',
        'Node-Name' => 'Düðüm Adý',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Bilet verisinin seçenekleri (örn. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Home' => 'Ana sayfa',
        'Workflow Groups' => 'Çalýþma akýþý Gruplarý',
        'Current Impact Rating' => 'Þu Andaki Etki Oraný',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Yapýlandýrma seçenekleri (örn. <OTRS_CONFIG_HttpType>)',
        'FAQ System History' => 'SSS Sistemi Tarihçesi',
        'customer realname' => 'müþterinin gerçek adý',
        'Pending messages' => 'Bekleyen mesajlar',
        'Modules' => 'Bileþenler',
        'for agent login' => 'aracý oturumu için',
        'Keyword' => 'Anahtar kelime',
        'Reference' => 'Referans',
        'with' => 'ile',
        'Close type' => 'Tipi kapat',
        'DB Admin User' => 'Veritabaný Yöneticisi Kullanýcý',
        'for agent user id' => 'aracý kullanýcý kimliði için',
        'sort upward' => 'yukarý doðru sýrala',
        'Classification' => 'Sýralama',
        'Change user <-> group settings' => 'Kullanýcý <-> grup seçeneklerini deðiþtir',
        'next step' => 'sonraki adým',
        'Customer history search' => 'Müþteri tarihçe aramasý',
        'not verified' => 'onaylanmadý',
        'Stat#' => 'Ýstatistik numarasý',
        'Create new database' => 'Yeni veritabaný oluþtur',
        'Year' => 'Yýl',
        'A message must be spell checked!' => 'Mesajýn sözyazým kontrolünden geçmesi gereki!',
        'X-axis' => 'X-Ekseni',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => '"<OTRS_TICKET>" bilet numaralý e-postanýz "<OTRS_BOUNCE_TO>" adresine gönderildi. Daha fazla bilgi için bu adresle baðlantýya geçin.',
        'A message should have a body!' => 'Mesajýn bir gövdesi olmalýdýr!',
        'All Agents' => 'Tüm Aracýlar',
        'Keywords' => 'Anahtar Kelimeler',
        'No * possible!' => '"*" kullanýlamaz!',
        'Load' => 'Yükle',
        'Change Time' => 'Deðiþiklik Zamaný',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Bu eylemi isteyen kulanýcýnýn (örn. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;) seçenekleri',
        'Message for new Owner' => 'Yeni Sahibine mesaj',
        'to get the first 5 lines of the email' => 'e-postanýn ilk beþ satýrýný almak için',
        'OTRS DB Password' => 'OTRS Veritabaný Parolasý',
        'Last update' => 'Son güncelleme',
        'not rated' => 'puan verilmedi',
        'to get the first 20 character of the subject' => 'konunun ilk 20 karakterini almak için',
        'Select the customeruser:service relations.' => 'Müþterikullanýcý:servis iliþkilerini belirle.',
        'DB Admin Password' => 'Veritabaný Yöneticisi Parolasý',
        'Drop Database' => 'Veritabanýný Sil',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Mevcut müþteri kullanýcý verileri (örn. <OTRS_CUSTOMER_DATA_UserFirstname>) seçenekleri',
        'Pending type' => 'Bekleme tipi',
        'Comment (internal)' => 'Yorum (iç)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Bilet sahibi seçenekleri (örn. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'This window must be called from compose window' => 'Bu pencere \'yeni mesaj\' penceresinden açýlmalýdýr',
        'User-Number' => 'Kullanýcý Numarasý',
        'You need min. one selected Ticket!' => 'En az bir Bilet seçili olmalýdýr!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Bilet verisi seçenekleri (örn. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Kullanýlan bilet numarasý biçimi)',
        'Fulltext' => 'Tümmetin',
        'Month' => 'Ay',
        'Node-Address' => 'Düðüm Adresi',
        'All Agent variables.' => 'Tüm Aracý deðiþkenleri',
        ' (work units)' => ' (iþ birimi)',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' => 'SÝL seçeneðini kullandýnýz! Silinen Biletlerin kurtarýlamayacaðýný unutmayýn!!!',
        'All Customer variables like defined in config option CustomerUser.' => 'Müþteri Kullanýcý yapýlandýrma seçeneðinde tanýmlandýðý þekliyle tüm Müþteri deðiþkenleri.',
        'for agent lastname' => 'aracý soyadý için',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Bu eylem için istekte bulunan kullanýcýnýn seçenekleri (örn. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Hatýrlatýcý mesajlar',
        'A message should have a subject!' => 'Bir mesajýn bir konusu olmalýdýr!',
        'TicketZoom' => 'Bilet Detaylarý',
        'Don\'t forget to add a new user to groups!' => 'Yeni kullanýcýyý gruplara atamayý unutmayýn!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Kime kýsmýnda bir e-posta adresi (örn. musteri@ornek.com) olmalýdýr!',
        'CreateTicket' => 'Bilet Oluþtur',
        'unknown' => 'bilinmiyor',
        'You need to account time!' => 'Zamaný hesaba katmalýsýnýz!',
        'System Settings' => 'Sistem Ayarlarý',
        'Finished' => 'Tamamlandý',
        'Imported' => 'Ýçeri aktarýldý',
        'unread' => 'okunmadý',
        'Split' => 'Ayýr',
        'D' => 'D',
        'System Status' => 'Sistem Durumu',
        'All messages' => 'Tüm mesajlar',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Bilet verisi seçenekleri (örn. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'A article should have a title!' => 'Metnin bir baþlýðý olmalýdýr!',
        'Customer Users <-> Services' => 'Müþteri Kullanýcýlar <-> Servisler',
        'This account exists' => 'Bu hesap zaten var',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Yapýlandýrma seçenekleri (örn. &lt;OTRS_CONFIG_HttpType&gt;)',
        'Event' => 'Olay',
        'Imported by' => 'Ýçeri aktaran',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Bilet sahibi seçenekleri (örn. <OTRS_OWNER_UserFirstname>)',
        'read' => 'okunmuþ',
        'Product' => 'Ürün',
        'Name is required!' => 'Ad gerekli!',
        'kill all sessions' => 'tüm oturumlarý sonlandýr',
        'to get the from line of the email' => 'e-postanýn \'kime\' alanýný almak için',
        'Solution' => 'Çözüm',
        'QueueView' => 'Kuyruk Görünümü',
        'My Queue' => 'Kuyruðun',
        'Select Box' => 'Seçim Kutusu',
        'Instance' => 'Kopya',
        'Day' => 'Gün',
        'Service-Name' => 'Servis Adý',
        'Welcome to OTRS' => 'OTRS\'ye hoþgeldiniz',
        'tmp_lock' => 'geçici kilit',
        'modified' => 'deðiþtirilmiþ',
        'Escalation in' => 'Yükselme',
        'Delete old database' => 'Eski veritabanýný sil',
        'sort downward' => 'aþaðýya doðru sýrala',
        'You need to use a ticket number!' => 'Bilet numarasý kullanmalýsýnýz!',
        'Watcher' => 'Ýzleyici',
        'Have a lot of fun!' => 'Ýyi eðlenceler!',
        'send' => 'gönder',
        'Note Text' => 'Not Metni',
        'POP3 Account Management' => 'POP3 Hesap Yönetimi',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Muþteri kullanýcý verisi seçenekleri (örn. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;).',
        'System State Management' => 'Sistem Durumu Yönetimi',
        'PhoneView' => 'Telefon Görünüþü',
        'User-Name' => 'Kullanýcý Adý',
        'File-Path' => 'Dosya Yolu',
        'Modified' => 'Deðiþtirildi',
        'Ticket selected for bulk action!' => 'Bilet toplu iþlem için seçildi',

        'Link Object: %s' => '',
        'Unlink Object: %s' => '',
        'Linked as' => '',
        'Can not create link with %s!' => '',
        'Can not delete link with %s!' => '',
        'Object already linked as %s.' => '',
        'Priority Management' => '',
        'Add a new Priority.' => '',
        'Add Priority' => '',
    };
    # $$STOP$$
    return;
}

1;
