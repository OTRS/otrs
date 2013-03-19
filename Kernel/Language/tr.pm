# --
# Kernel/Language/tr.pm - provides Turkish language translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# Copyright (C) 2013 Sefer Şimşek / Network Group <network@kamusm.gov.tr>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::tr;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-03-12 11:32:18

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Evet',
        'No' => 'Hayır',
        'yes' => 'evet',
        'no' => 'hayır',
        'Off' => 'Kapalı',
        'off' => 'kapalı',
        'On' => 'Açık',
        'on' => 'açık',
        'top' => 'üst',
        'end' => 'son',
        'Done' => 'Tamam',
        'Cancel' => 'İptal',
        'Reset' => 'Sıfırla',
        'last' => 'son',
        'before' => 'önce',
        'Today' => 'Bugün',
        'Tomorrow' => 'Yarın',
        'Next week' => 'Gelecek hafta',
        'day' => 'gün',
        'days' => 'gün',
        'day(s)' => 'gün',
        'd' => '',
        'hour' => 'saat',
        'hours' => 'saat',
        'hour(s)' => 'saat',
        'Hours' => '',
        'h' => '',
        'minute' => 'dakika',
        'minutes' => 'dakika',
        'minute(s)' => 'dakika',
        'Minutes' => '',
        'm' => '',
        'month' => 'ay',
        'months' => 'ay',
        'month(s)' => 'ay',
        'week' => 'hafta',
        'week(s)' => 'hafta',
        'year' => 'yıl',
        'years' => 'yıl',
        'year(s)' => 'yıl',
        'second(s)' => 'saniye',
        'seconds' => 'saniye',
        'second' => 'saniye',
        's' => '',
        'wrote' => 'yazdı',
        'Message' => 'Mesaj',
        'Error' => 'Hata',
        'Bug Report' => 'Hata Kaydı',
        'Attention' => 'Dikkat',
        'Warning' => 'Uyarı',
        'Module' => 'modül',
        'Modulefile' => 'modül dosyası',
        'Subfunction' => 'Altfonksiyon',
        'Line' => 'Hat',
        'Setting' => 'Ayar',
        'Settings' => 'Ayarlar',
        'Example' => 'Örnek',
        'Examples' => 'Örnekler',
        'valid' => 'geçerli',
        'Valid' => 'Geçerli',
        'invalid' => 'geçersiz',
        'Invalid' => '',
        '* invalid' => '* geçersiz',
        'invalid-temporarily' => 'geçici olarak geçersiz',
        ' 2 minutes' => ' 2 dakika',
        ' 5 minutes' => ' 5 dakika',
        ' 7 minutes' => ' 7 dakika',
        '10 minutes' => '10 dakika',
        '15 minutes' => '15 dakika',
        'Mr.' => 'Bay',
        'Mrs.' => 'Bayan',
        'Next' => 'Ileri',
        'Back' => 'Geri',
        'Next...' => 'ileri...',
        '...Back' => '...Geri',
        '-none-' => '-hiçbiri-',
        'none' => 'hiçbiri',
        'none!' => 'hiçbiri!',
        'none - answered' => 'hiçbiri - cevaplanmadı',
        'please do not edit!' => 'Lütfen değiştirme!',
        'Need Action' => '',
        'AddLink' => 'Bağ Ekle',
        'Link' => 'Bağ',
        'Unlink' => 'Bağı çöz',
        'Linked' => 'Bağlandı',
        'Link (Normal)' => 'Bağ (Normal)',
        'Link (Parent)' => 'Bağ (Ebeveyn)',
        'Link (Child)' => 'Bağ (Alt)',
        'Normal' => 'Normal',
        'Parent' => 'Ebeveyn',
        'Child' => 'Alt',
        'Hit' => 'İsabet',
        'Hits' => 'İsabet',
        'Text' => 'Metin',
        'Standard' => '',
        'Lite' => 'Hafif',
        'User' => 'Kullanıcı',
        'Username' => 'Kullanıcı adı',
        'Language' => 'Dil',
        'Languages' => 'Diller',
        'Password' => 'Parola',
        'Preferences' => 'Tercihler',
        'Salutation' => 'Selam',
        'Salutations' => 'Selâmlamalar',
        'Signature' => 'İmza',
        'Signatures' => 'İmzalar',
        'Customer' => 'Müşteri',
        'CustomerID' => 'Müşteri IDsi',
        'CustomerIDs' => 'Müşteri IDleri',
        'customer' => 'müşteri',
        'agent' => 'aracı',
        'system' => 'sistem',
        'Customer Info' => 'Müşteri Bilgisi',
        'Customer Information' => 'Müşteri Bilgileri',
        'Customer Company' => 'Müşteri Şirketi',
        'Customer Companies' => 'Müşteri Şirketleri',
        'Company' => 'Şirket',
        'go!' => 'Başla!',
        'go' => 'başla',
        'All' => 'Tümü',
        'all' => 'tümü',
        'Sorry' => 'Üzgünüm',
        'update!' => 'güncelle!',
        'update' => 'güncelle',
        'Update' => 'Güncelle',
        'Updated!' => 'Güncellendi',
        'submit!' => 'gönder!',
        'submit' => 'gönder',
        'Submit' => 'Gönder',
        'change!' => 'değiştir!',
        'Change' => 'Değiştir',
        'change' => 'değiştir',
        'click here' => 'burayı tıklayın',
        'Comment' => 'Yorum',
        'Invalid Option!' => 'Geçersiz Seçenek!',
        'Invalid time!' => 'Geçersiz saat!',
        'Invalid date!' => 'Geçersiz tarih!',
        'Name' => 'Isim',
        'Group' => 'Grup',
        'Description' => 'Açıklama',
        'description' => 'açıklama',
        'Theme' => 'Tema',
        'Created' => 'Oluşturuldu',
        'Created by' => 'Oluşturan',
        'Changed' => 'Değiştirildi',
        'Changed by' => 'Değiştiren',
        'Search' => 'Ara',
        'and' => 've',
        'between' => 'arasında',
        'Fulltext Search' => 'Tam Metin Araması',
        'Data' => 'Veri',
        'Options' => 'Seçenekler',
        'Title' => 'Başlık',
        'Item' => 'Madde',
        'Delete' => 'Sil',
        'Edit' => 'Düzenle',
        'View' => 'Görünüm',
        'Number' => 'Sayı',
        'System' => 'Sistem',
        'Contact' => 'Bağlantı',
        'Contacts' => 'Bağlantılar',
        'Export' => 'Dışarıya aktar',
        'Up' => 'Yukarı',
        'Down' => 'Aşağı',
        'Add' => 'Ekle',
        'Added!' => 'Eklendi',
        'Category' => 'Kategori',
        'Viewer' => 'Görüntüleyici',
        'Expand' => 'Genişlet',
        'Small' => 'Küçük',
        'Medium' => 'Orta',
        'Large' => 'Büyük',
        'Date picker' => 'Tarih seçici',
        'New message' => 'Yeni mesaj',
        'New message!' => 'Yeni mesaj!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Lütfen normal kuyruk görünümüne dönmek için bu bilet(ler)i cevaplayın!',
        'You have %s new message(s)!' => '%s yeni mesajınız var!',
        'You have %s reminder ticket(s)!' => '%s hatırlatıcı biletiniz var!',
        'The recommended charset for your language is %s!' => 'Kullandığınız dil için tavsiye edilen karakter seti %s!',
        'Change your password.' => 'Parolanızı değiştirin.',
        'Please activate %s first!' => 'Önce %s aktif edin!',
        'No suggestions' => 'Öneri yok',
        'Word' => 'Kelime',
        'Ignore' => 'Yoksay',
        'replace with' => 'ile değiştir',
        'There is no account with that login name.' => 'kullanıcı adı bilinmiyor.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Oturum açılamadı! Kullanıcı adınız veya parolanız hatalı girildi.',
        'There is no acount with that user name.' => 'Bu kullanıcı adıyla bir hesap yok.',
        'Please contact your administrator' => 'Lütfen yöneticinizle irtibat kurun',
        'Logout' => 'Oturumu kapat',
        'Logout successful. Thank you for using OTRS!' => 'Oturum kapatma başarılı! OTRS\'yi kullandığınız için teşekkür ederiz!',
        'Feature not active!' => 'Özellik etkin değil!',
        'Agent updated!' => 'Aracı güncellendi!',
        'Create Database' => 'Veritabanını Oluştur',
        'System Settings' => 'Sistem Ayarları',
        'Mail Configuration' => 'E-posta ayarları',
        'Finished' => 'Tamamlandı',
        'Install OTRS' => 'OTRS\'yi kur',
        'Intro' => 'Tanıtım',
        'License' => 'Lisans',
        'Database' => 'Veritabanı',
        'Configure Mail' => 'E-posta ayarla',
        'Database deleted.' => 'Veritabanı silindi.',
        'Database setup succesful!' => 'Veritabanı kurulumu başarılı!',
        'Login is needed!' => 'Oturum açmanız gerekli!',
        'Password is needed!' => 'Parola gerekli!',
        'Take this Customer' => 'Bu Müşteriyi al',
        'Take this User' => 'Bu Kullanıcıyı al',
        'possible' => 'mümkün',
        'reject' => 'red',
        'reverse' => 'ters',
        'Facility' => 'Tesis',
        'Time Zone' => '',
        'Pending till' => 'Şu zamana kadar askıda',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Elektronik posta Kime: alanına göre gönderiliyor.',
        'Dispatching by selected Queue.' => 'Seçili Kuyruğa göre gönderiliyor.',
        'No entry found!' => 'Kayıt bulunamadı!',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Oturum süresi doldu. Lütfen tekrar oturum açın.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Yasak!',
        '(Click here to add)' => '(Eklemek için burayı tıklayın)',
        'Preview' => 'Önizleme',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '%s yazılamaz!',
        'Cannot create %s!' => '%s oluşturulamadı!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => '%s müşterisi eklendi',
        'Role added!' => 'Rol eklendi!',
        'Role updated!' => 'Rol güncellendi!',
        'Attachment added!' => 'Dosya eklendi!',
        'Attachment updated!' => 'Dosya güncellendi!',
        'Response added!' => 'Cevap eklendi!',
        'Response updated!' => 'Cevap güncellendi!',
        'Group updated!' => 'Grup güncellendi!',
        'Queue added!' => 'Kuyruk eklendi!',
        'Queue updated!' => 'Kuyruk güncellendi!',
        'State added!' => 'Durum eklendi!',
        'State updated!' => 'Durum güncellendi!',
        'Type added!' => 'Tip eklendi!',
        'Type updated!' => 'Tip güncellendi!',
        'Customer updated!' => 'Müşteri güncellendi!',
        'Customer company added!' => 'Müşteri şirketi eklendi!',
        'Customer company updated!' => 'Müşteri şirketi güncellendi!',
        'Mail account added!' => 'E-posta hesabı eklendi!',
        'Mail account updated!' => 'E-posta hesabı güncellendi!',
        'System e-mail address added!' => 'Sistem e-posta adresi eklendi!',
        'System e-mail address updated!' => 'Sistem e-posta adresi güncellendi!',
        'Contract' => 'Kontrat',
        'Online Customer: %s' => 'Online Müşteri: %s',
        'Online Agent: %s' => 'Online Aracı: %s',
        'Calendar' => 'Takvim',
        'File' => 'Dosya',
        'Filename' => 'Dosya adı',
        'Type' => 'Tip',
        'Size' => 'Boyut',
        'Upload' => 'Yükle',
        'Directory' => 'Dizin',
        'Signed' => 'İmzalı',
        'Sign' => 'İmza',
        'Crypted' => 'Şifrelenmiş',
        'Crypt' => 'Şifrele',
        'PGP' => '',
        'PGP Key' => '',
        'PGP Keys' => '',
        'S/MIME' => '',
        'S/MIME Certificate' => '',
        'S/MIME Certificates' => '',
        'Office' => 'Ofis',
        'Phone' => 'Telefon',
        'Fax' => 'Faks',
        'Mobile' => 'Cep',
        'Zip' => 'PK',
        'City' => 'Şehir',
        'Street' => 'cadde',
        'Country' => 'Ülke',
        'Location' => 'konum',
        'installed' => 'yüklendi',
        'uninstalled' => 'kaldırılmış',
        'Security Note: You should activate %s because application is already running!' =>
            'Güvenlik notu: %s etkinleştirilmeli çünkü uygulama halihazırda çalışıyor!',
        'Unable to parse repository index document.' => '',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '',
        'No packages, or no new packages, found in selected repository.' =>
            '',
        'Edit the system configuration settings.' => '',
        'printed at' => 'yazdırıldı',
        'Loading...' => 'Yükleniyor',
        'Dear Mr. %s,' => 'Sayın Bay %s,',
        'Dear Mrs. %s,' => 'Sayın Bayan %s,',
        'Dear %s,' => 'Sayın %s,',
        'Hello %s,' => 'Merhaba %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Bu e-posta adresi zaten var. Lütfen giriş yapın yada parolanızı sıfırlayın.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Yeni Hesap eklendi. Giriş bilgileri %s adresine gönderildi. Lütfen e-postanızı kontrol edin.',
        'Please press Back and try again.' => 'Lüften geri tuşuna basınız ve tekrar deneyiniz',
        'Sent password reset instructions. Please check your email.' => 'Parola sıfırlama talimatları gönderildi. Lütfen e-postanızı kontrol ediniz.',
        'Sent new password to %s. Please check your email.' => '%s adresine yeni parola gönderildi. Lütfen e-postanızı kontrol edin.',
        'Upcoming Events' => 'gelecek olgular',
        'Event' => 'Olgu',
        'Events' => 'olgular',
        'Invalid Token!' => 'geçersiz simge',
        'more' => 'daha fazla',
        'For more info see:' => 'daha geniş bilgi için bakınız',
        'Package verification failed!' => 'paket doğrulaması hatalı',
        'Collapse' => 'daralt',
        'Shown' => '',
        'Shown customer users' => '',
        'News' => 'yenilikler',
        'Product News' => 'Ürün Yenilikleri',
        'OTRS News' => 'OTRS Haberleri',
        '7 Day Stats' => '7 Günlük Durum',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Bold' => 'Kalın',
        'Italic' => 'İtalik',
        'Underline' => 'Altı çizili',
        'Font Color' => 'Karakter Rengi',
        'Background Color' => 'Fon Rengi',
        'Remove Formatting' => 'Formatı Sil',
        'Show/Hide Hidden Elements' => 'Gizli Bölümleri Göster/Kapat',
        'Align Left' => 'Sola Hizala',
        'Align Center' => 'Ortaya Hizala',
        'Align Right' => 'Sağa Hizala',
        'Justify' => 'Satır Uzunluğunu Ayarla',
        'Header' => 'Başlık',
        'Indent' => 'İçeri',
        'Outdent' => 'Dışarı',
        'Create an Unordered List' => 'Düzensiz liste yarat',
        'Create an Ordered List' => 'Düzenli iste yarat',
        'HTML Link' => 'HTML bağı',
        'Insert Image' => 'Resim yükle',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Geri',
        'Redo' => 'Tekrar',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => '',
        'International Workers\' Day' => '',
        'Christmas Eve' => '',
        'First Christmas Day' => '',
        'Second Christmas Day' => '',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => 'Oca',
        'Feb' => 'Şub',
        'Mar' => 'Mar',
        'Apr' => 'Nis',
        'May' => 'May',
        'Jun' => 'Haz',
        'Jul' => 'Tem',
        'Aug' => 'Ağu',
        'Sep' => 'Eyl',
        'Oct' => 'Eki',
        'Nov' => 'Kas',
        'Dec' => 'Ara',
        'January' => 'Ocak',
        'February' => 'Şubat',
        'March' => 'Mart',
        'April' => 'Nisan',
        'May_long' => 'Mayıs',
        'June' => 'Haziran',
        'July' => 'Temmuz',
        'August' => 'Ağustos',
        'September' => 'Eylül',
        'October' => 'Ekim',
        'November' => 'Kasım',
        'December' => 'Aralık',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Tercihler başarılı bir şekilde güncellendi!',
        'User Profile' => 'Kullanıcı Profili',
        'Email Settings' => 'E-posta ayarları',
        'Other Settings' => 'Diğer Ayarlar',
        'Change Password' => 'Parola Değiştir',
        'Current password' => 'Mevcut parola',
        'New password' => 'Yeni parola',
        'Verify password' => 'Parolayı doğrula',
        'Spelling Dictionary' => 'Sözdizim Sözlüğü',
        'Default spelling dictionary' => 'Varsayılan sözlük hecelemesi',
        'Max. shown Tickets a page in Overview.' => 'Genel bakışta bir sayfada gösterilecek en fazla Bilet sayısı.',
        'The current password is not correct. Please try again!' => 'Mevcut şifreniz hatalı. Tekrar deneyin',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Şifreniz güncellenemiyor. Yeni şifreniz eşleşmiyor. Tekrar dene.',
        'Can\'t update password, it contains invalid characters!' => 'Şifreniz güncellenemiyor. Geçersiz karakter içeriyor!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Şifreniz güncellenemiyor. En az %s karakter uzunluğunda olmalı!',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            'Şifreniz güncellenemiyor. En az 2 küçük harf, 2 büyük harf içermeli!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Şifreniz güncellenemiyor. En az 1 rakam içermeli!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Şifreniz güncellenemiyor. En az 2 karakter içermeli!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Şifreniz güncellenemiyor. Bu şifre zaten kullanıldı. Başka birini seçin!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '',
        'CSV Separator' => '',

        # Template: AAAStats
        'Stat' => 'İstatistikler',
        'Sum' => 'Toplam',
        'Please fill out the required fields!' => 'Lütfen zorunlu alanları doldurun!',
        'Please select a file!' => 'Lütfen bir dosya seçin!',
        'Please select an object!' => 'Lütfen bir nesne seçin!',
        'Please select a graph size!' => 'Lütfen bir grafik boyutu seçin!',
        'Please select one element for the X-axis!' => 'Lütfen X ekseni için bir eleman seçin!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Lütfen sadece bir eleman seçin veya seçim alanının işaretli olduğu yerden \'Sabit\' düğmesini kapatın!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Eğer bir işaretleme kutusu kullanırsanız seçim alanından bazı nitelikleri seçmelisiniz!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Lütfen seçili giriş alanına bir değer girin veya \'Sabit\' işaretleme kutusunu kapatın!',
        'The selected end time is before the start time!' => 'Seçilen bitiş zamanı başlama zamanından önce!',
        'You have to select one or more attributes from the select field!' =>
            'Seçim alanından bir veya daha fazla nitelik seçmelisiniz!',
        'The selected Date isn\'t valid!' => 'Seçilen Tarih geçerli değil!',
        'Please select only one or two elements via the checkbox!' => 'Lütfen işaretleme kutusu vasıtasıyla sadece bir veya iki eleman seçin!',
        'If you use a time scale element you can only select one element!' =>
            'Eğer bir zaman oran elemanı kullanırsanız sadece bir eleman seçebilirsiniz!',
        'You have an error in your time selection!' => 'Zaman seçiminizde bir hata var!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Raporlama zaman sıklığınız çok küçük, lütfen daha büyük bir zaman oranı seçin!',
        'The selected start time is before the allowed start time!' => 'Seçilen başlangıç zamanı izin verilen başlangıç zamanından önce!',
        'The selected end time is after the allowed end time!' => 'Seçilen bitiş zamanı izin verilen bitiş zamanından sonra!',
        'The selected time period is larger than the allowed time period!' =>
            'Seçilen zaman dönemi izin verilen zaman döneminden daha büyük!',
        'Common Specification' => 'Genel Belirtim',
        'X-axis' => 'X-Ekseni',
        'Value Series' => 'Değer Serileri',
        'Restrictions' => 'Kısıtlamalar',
        'graph-lines' => 'grafik-çizgiler',
        'graph-bars' => 'grafik-çubuklar',
        'graph-hbars' => 'grafik-yatay çubuklar',
        'graph-points' => 'grafik-noktalar',
        'graph-lines-points' => 'grafik-çizgiler-noktalar',
        'graph-area' => 'grafik-alan',
        'graph-pie' => 'grafik-pasta',
        'extended' => 'genişletilmiş',
        'Agent/Owner' => 'Aracı/Sahip',
        'Created by Agent/Owner' => 'Aracı/Sahip Tarafından Oluşturulmuş',
        'Created Priority' => 'Oluşturulma Önceliği',
        'Created State' => 'Oluşturulma Durumu',
        'Create Time' => 'Oluşturulma Zamanı',
        'CustomerUserLogin' => 'Müşteri Kullanıcı Oturumu',
        'Close Time' => 'Kapatma Saati',
        'TicketAccumulation' => 'Bilet yoğunlaşması',
        'Attributes to be printed' => 'yazdırılacak veriler',
        'Sort sequence' => 'düzenleme sırası',
        'Order by' => 'Sıralama',
        'Limit' => 'Sınır',
        'Ticketlist' => 'Biletlistesi',
        'ascending' => 'çıkarak',
        'descending' => 'inerek',
        'First Lock' => 'ilk kilitleme',
        'Evaluation by' => 'tarafından değerlendirme',
        'Total Time' => 'Tüm süre',
        'Ticket Average' => 'Bilet ortalaması',
        'Ticket Min Time' => 'Bilet minimum süresi',
        'Ticket Max Time' => 'Bilet maximum süresi',
        'Number of Tickets' => 'Bilet sayısı',
        'Article Average' => 'yazı ortalaması',
        'Article Min Time' => 'yazı minimum süresi',
        'Article Max Time' => 'yazı maximum süresi',
        'Number of Articles' => 'yazı sayısı',
        'Accounted time by Agent' => 'aracı süresi toplama',
        'Ticket/Article Accounted Time' => 'Bilet/yazı süresi toplam',
        'TicketAccountedTime' => '',
        'Ticket Create Time' => 'bilet başlangıç saati',
        'Ticket Close Time' => 'bilet kapanma saati',

        # Template: AAATicket
        'Status View' => 'Durum görünümü',
        'Bulk' => '',
        'Lock' => 'Kilitle',
        'Unlock' => 'Kilidi Aç',
        'History' => 'Geçmiş',
        'Zoom' => 'Yakınlaşma',
        'Age' => 'Yaş',
        'Bounce' => 'Yansıt',
        'Forward' => 'İleri',
        'From' => 'Kimden',
        'To' => 'Kime',
        'Cc' => 'Karbon Kopya',
        'Bcc' => 'Gizli Karbon Kopya',
        'Subject' => 'Konu',
        'Move' => 'Taşı',
        'Queue' => 'Kuyruğa koy',
        'Queues' => 'Kuyruklar',
        'Priority' => 'Öncelik',
        'Priorities' => 'Öncelikler',
        'Priority Update' => 'Öncelik güncelle!',
        'Priority added!' => 'Öncelik eklendi!',
        'Priority updated!' => 'Öncelik güncellendi!',
        'Signature added!' => 'İmza eklendi!',
        'Signature updated!' => 'İmza güncellendi!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Servis seviye anlaşması',
        'Service Level Agreements' => 'Servis seviye anlaşmaları',
        'Service' => 'Servis',
        'Services' => 'Servisler',
        'State' => 'Durum',
        'States' => 'Durumlar',
        'Status' => 'Durum',
        'Statuses' => 'Durumlar',
        'Ticket Type' => 'Bilet Tipi',
        'Ticket Types' => 'Bilet Tipleri',
        'Compose' => 'Yeni Oluştur',
        'Pending' => 'Bekliyor',
        'Owner' => 'Sahip',
        'Owner Update' => 'Sahip Güncellemesi',
        'Responsible' => 'Sorumlu',
        'Responsible Update' => 'Sorumlu Güncellemesi',
        'Sender' => 'Gönderen',
        'Article' => 'Yazı',
        'Ticket' => 'Bilet',
        'Createtime' => 'Oluşturulma zamanı',
        'plain' => 'düz',
        'Email' => 'E-Posta',
        'email' => 'e-posta',
        'Close' => 'Kapat',
        'Action' => 'Eylem',
        'Attachment' => 'Ek',
        'Attachments' => 'Ekler',
        'This message was written in a character set other than your own.' =>
            'Bu mesaj sizinkinin dışında bir karakter kümesinde yazılmış.',
        'If it is not displayed correctly,' => 'Eğer doğru görüntülenmezse,',
        'This is a' => 'Bu bir',
        'to open it in a new window.' => 'yeni pencerede açmak için',
        'This is a HTML email. Click here to show it.' => 'Bu HTML biçimli bir e-posta. Göstermek için buraya tıklayın.',
        'Free Fields' => 'Serbest Alanlar',
        'Merge' => 'birleştir',
        'merged' => 'birleştirildi',
        'closed successful' => 'kapatma başarılı',
        'closed unsuccessful' => 'kapatma başarısız',
        'Locked Tickets Total' => 'Tüm kilitlenen biletler',
        'Locked Tickets Reminder Reached' => '',
        'Locked Tickets New' => 'Yeni kilitlenen biletler',
        'Responsible Tickets Total' => 'Toplam Sorumlu Biletler',
        'Responsible Tickets New' => 'Yeni Sorumlu Biletler',
        'Responsible Tickets Reminder Reached' => '',
        'Watched Tickets Total' => 'İzlenen tüm biletler',
        'Watched Tickets New' => 'Yeni izlenen biletler',
        'Watched Tickets Reminder Reached' => '',
        'All tickets' => 'Tüm biletler',
        'Available tickets' => 'Kullanılabilir biletler',
        'Escalation' => 'Yükselme',
        'last-search' => 'Son arama',
        'QueueView' => 'Kuyruk Görünümü',
        'Ticket Escalation View' => 'Bilet Yükselme Görünümü',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'yeni',
        'open' => 'açık',
        'Open' => 'Açık',
        'Open tickets' => 'Açık biletler',
        'closed' => 'kapalı',
        'Closed' => 'Kapalı',
        'Closed tickets' => 'Kapalı Biletler',
        'removed' => 'kaldırıldı',
        'pending reminder' => 'bekleyen hatırlatıcı',
        'pending auto' => 'bekleyen otomatik',
        'pending auto close+' => 'bekleyen otomatik kapat+',
        'pending auto close-' => 'bekleyen otomatik kapat-',
        'email-external' => 'e-posta-haricî',
        'email-internal' => 'e-posta-dahilî',
        'note-external' => 'not-haricî',
        'note-internal' => 'not-dahilî',
        'note-report' => 'not-rapor',
        'phone' => 'telefon',
        'sms' => 'kısa mesaj',
        'webrequest' => 'web isteği',
        'lock' => 'kilitle',
        'unlock' => 'kilidi aç',
        'very low' => 'çok düşük',
        'low' => 'düşük',
        'normal' => 'normal',
        'high' => 'yüksek',
        'very high' => 'çok yüksek',
        '1 very low' => '1 çok düşük',
        '2 low' => '2 düşük',
        '3 normal' => '3 normal',
        '4 high' => '4 yüksek',
        '5 very high' => '5 çok yüksek',
        'auto follow up' => 'otomatik izle',
        'auto reject' => 'otomatik çıkar',
        'auto remove' => 'otomatik kaldır',
        'auto reply' => 'otomatik cevapla',
        'auto reply/new ticket' => 'otomatik cevapla/yeni bilet',
        'Ticket "%s" created!' => '"%s" bileti oluşturuldu!',
        'Ticket Number' => 'Bilet Numarası',
        'Ticket Object' => 'Bilet Nesnesi',
        'No such Ticket Number "%s"! Can\'t link it!' => '"%s" Bilet Numarası yok! Ona bağlanamaz!',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Ticket selected.' => 'Bilet seçildi.',
        'Ticket is locked by another agent.' => 'Bilet başka bir aracı tarafından kilitlendi.',
        'Ticket locked.' => 'Bilet kilitli.',
        'Don\'t show closed Tickets' => 'Kapalı Biletleri gösterme',
        'Show closed Tickets' => 'Kapalı Biletleri göster',
        'New Article' => 'Yeni Yazı',
        'Unread article(s) available' => '',
        'Remove from list of watched tickets' => '',
        'Add to list of watched tickets' => '',
        'Email-Ticket' => 'E-Posta-Bilet',
        'Create new Email Ticket' => 'Yeni E-Posta-Bilet oluştur',
        'Phone-Ticket' => 'Telefon-Bilet',
        'Search Tickets' => 'Biletleri Ara',
        'Edit Customer Users' => 'Müşteri Kullanıcıları Belirle',
        'Edit Customer Company' => '',
        'Bulk Action' => 'Toplu İşlem',
        'Bulk Actions on Tickets' => 'Biletler Üzerinde Toplu İşlem',
        'Send Email and create a new Ticket' => 'E-Postayı gönder ve yeni Bilet oluştur',
        'Create new Email Ticket and send this out (Outbound)' => 'Yeni E-Posta-Bilet oluştur ve bunu gönder (dışarı)',
        'Create new Phone Ticket (Inbound)' => 'Yeni Telefon-Bilet',
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Tüm açık Biletlere genel bakış',
        'Locked Tickets' => 'Kilitli Biletler',
        'My Locked Tickets' => 'Kilitli Biletlerim',
        'My Watched Tickets' => 'İzlediğim Biletler ',
        'My Responsible Tickets' => 'Sorumluluğumdaki Biletler',
        'Watched Tickets' => 'İzlenen Biletler',
        'Watched' => 'İzlenen',
        'Watch' => 'İzle',
        'Unwatch' => 'İzleme',
        'Lock it to work on it' => 'Üzerinde çalışmak için kilitle',
        'Unlock to give it back to the queue' => 'Kuyruğa geri vermek için aç',
        'Show the ticket history' => 'Bilet tarihini göster',
        'Print this ticket' => 'Bu bileti bas',
        'Print this article' => 'Bu yazıyı bas',
        'Split this article' => 'Bu yazıyı böl',
        'Forward article via mail' => 'Yazıyı e-posta üzerinden ilet',
        'Change the ticket priority' => 'Bilet önceliğini değiştir',
        'Change the ticket free fields!' => 'Biletteki serbest alanları değiştir!',
        'Link this ticket to other objects' => 'Bu bileti başka nesnelere bağla',
        'Change the owner for this ticket' => 'Bu bilet için sahip değiştir',
        'Change the  customer for this ticket' => 'Bu bilet için müşteri değiştir',
        'Add a note to this ticket' => 'Bu bilete not ekle',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'Bir bilete bak!',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Spam (çöp) olarak işaretle!',
        'My Queues' => 'Kuyruklarım',
        'Shown Tickets' => 'Gösterilen Biletler',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            '"<OTRS_TICKET>" bilet numaralı e-postanız "<OTRS_MERGE_TO_TICKET>" ile birleştirildi.',
        'Ticket %s: first response time is over (%s)!' => 'Bilet %s: ilk yanıt zamanı aşıldı (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Bilet %s: %s içinde ilk yanıt zamanı aşılacak!',
        'Ticket %s: update time is over (%s)!' => 'Bilet %s: güncelleme zamanı aşıldı (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Bilet %s: %s içinde güncelleme zamanı aşılacak!',
        'Ticket %s: solution time is over (%s)!' => 'Bilet %s: çözme zamanı aşıldı (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Bilet %s: %s içinde çözme zamanı aşılacak!',
        'There are more escalated tickets!' => 'Başka yükseltilmiş biletler var!',
        'Plain Format' => '',
        'Reply All' => 'Tümüne Cevapla',
        'Direction' => '',
        'Agent (All with write permissions)' => 'Aracı (Yazma yetkisine sahip herkes)',
        'Agent (Owner)' => 'Aracı (Sahip)',
        'Agent (Responsible)' => 'Aracı (Sorumlu)',
        'New ticket notification' => 'Yeni bilet bildirimi',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            '"Kuyruklarım"da yeni bir bilet olduğunda bana bildirim gönder.',
        'Send new ticket notifications' => 'Yeni bilet uyarıları gönder',
        'Ticket follow up notification' => 'Bilet izleme uyarısı',
        'Ticket lock timeout notification' => 'Bilet kilidi zaman aşımı bildirimi',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Bir biletin kilidi sistem tarafından kaldırıldığında bana bildirim gönder.',
        'Send ticket lock timeout notifications' => '',
        'Ticket move notification' => 'Bilet taşıma uyarısı',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Bilet "Kuyruklarım"dan birine taşındığında bana bildirim gönder',
        'Send ticket move notifications' => '',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'Özel Kuyruk',
        'QueueView refresh time' => 'Kuyruk Görünümü tazeleme zamanı',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            '',
        'Refresh QueueView after' => '',
        'Screen after new ticket' => 'Yeni Biletten sonraki ekran',
        'Show this screen after I created a new ticket' => '',
        'Closed Tickets' => 'Kapanmış Biletler',
        'Show closed tickets.' => 'Kapanmış biletleri göster.',
        'Max. shown Tickets a page in QueueView.' => 'Kuyruk Görünümünde bir sayfada gösterilecek en fazla Bilet sayısı.',
        'Ticket Overview "Small" Limit' => '',
        'Ticket limit per page for Ticket Overview "Small"' => '',
        'Ticket Overview "Medium" Limit' => '',
        'Ticket limit per page for Ticket Overview "Medium"' => '',
        'Ticket Overview "Preview" Limit' => '',
        'Ticket limit per page for Ticket Overview "Preview"' => '',
        'Ticket watch notification' => '',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            '',
        'Send ticket watch notifications' => '',
        'Out Of Office Time' => '',
        'New Ticket' => 'Yeni Bilet',
        'Create new Ticket' => 'Yeni Bilet oluştur',
        'Customer called' => 'Aranan müşteri',
        'phone call' => 'telefon araması',
        'Phone Call Outbound' => 'Giden Telefon Çağrısı',
        'Phone Call Inbound' => 'Gelen Telefon Çağrısı',
        'Reminder Reached' => 'Hatırlatma süresi doldu',
        'Reminder Tickets' => 'Hatırlatma biletleri',
        'Escalated Tickets' => 'Yükseltilmiş Biletler',
        'New Tickets' => 'Yeni Biletler',
        'Open Tickets / Need to be answered' => 'Açık Biletler / Cevap Bekleniyor',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            '',
        'All new tickets, these tickets have not been worked on yet' => '',
        'All escalated tickets' => 'Tüm yükseltilmiş biletler',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
        'History::Move' => 'Bilet "%s" (%s) kuyruğuna taşındı, "%s" (%s) kuyruğundan.',
        'History::TypeUpdate' => '"%s" (Kimlik=%s) tipi güncellendi.',
        'History::ServiceUpdate' => '"%s" (Kimlik=%s) servisi güncellendi.',
        'History::SLAUpdate' => '"%s" (Kimlik=%s) SLA güncellendi.',
        'History::NewTicket' => 'Yeni [%s] Bileti oluşturuldu (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => '[%s] için takip. %s',
        'History::SendAutoReject' => '"%s" için Otomatik Red gönderildi.',
        'History::SendAutoReply' => '"%s" için Otomatik Yanıt gönderildi.',
        'History::SendAutoFollowUp' => '"%s" için Otomatik Takip gönderildi.',
        'History::Forward' => '"%s" iletildi.',
        'History::Bounce' => '"%s" ötelendi.',
        'History::SendAnswer' => '"%s" için e-posta gönderildi.',
        'History::SendAgentNotification' => '"%s"- "%s" için aracıya bildirim gönderildi.',
        'History::SendCustomerNotification' => '"%s" için müşteriye bildirim gönderildi .',
        'History::EmailAgent' => 'Aracıya e-posta gönderildi.',
        'History::EmailCustomer' => 'Müşteriye e-posta gönderildi. %s',
        'History::PhoneCallAgent' => 'Aracı telefonla arandı.',
        'History::PhoneCallCustomer' => 'Müşteri telefonla arandı.',
        'History::AddNote' => 'Not eklendi (%s)',
        'History::Lock' => 'Bilet kilitlendi.',
        'History::Unlock' => 'Bilet kilidi çözüldü.',
        'History::TimeAccounting' => '%s zaman birimi hesaplandı. Toplam %s zaman birimi.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Güncellendi: %s',
        'History::PriorityUpdate' => 'Öncelik değiştirildi. Eski: "%s" (%s), Yeni: "%s" (%s).',
        'History::OwnerUpdate' => 'Yeni sahip "%s" (Kimlik=%s).',
        'History::LoopProtection' => 'Döngü Koruması! "%s" için otomatik yanıt gönderilmedi.',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Güncellendi: %s',
        'History::StateUpdate' => 'Eski: "%s" Yeni: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Güncellendi: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Web üzerinden Müşteri İsteği.',
        'History::TicketLinkAdd' => '"%s" biletine köprü eklendi.',
        'History::TicketLinkDelete' => '"%s" biletine köprü silinde.',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',
        'History::SystemRequest' => '',
        'History::ResponsibleUpdate' => '',
        'History::ArchiveFlagUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Paz',
        'Mon' => 'Pzt',
        'Tue' => 'Sal',
        'Wed' => 'Çar',
        'Thu' => 'Per',
        'Fri' => 'Cum',
        'Sat' => 'Cts',

        # Template: AdminAttachment
        'Attachment Management' => 'Eklenti yönetimi',
        'Actions' => 'Eylemler',
        'Go to overview' => 'Genel Bakışa git',
        'Add attachment' => 'Dosya ekle',
        'List' => 'Liste',
        'Validity' => 'Doğrula',
        'No data found.' => 'Veri bulunamadı.',
        'Download file' => 'Dosyayı indir',
        'Delete this attachment' => 'Bu dosyayı sil',
        'Add Attachment' => 'Dosya Ekle',
        'Edit Attachment' => 'Dosyayı görüntüle',
        'This field is required.' => 'Bu alan zorunludur',
        'or' => 'veya',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Otomatik Yanıt Yönetimi',
        'Add auto response' => '',
        'Add Auto Response' => '',
        'Edit Auto Response' => '',
        'Response' => 'Yanıt',
        'Auto response from' => '',
        'Reference' => 'Referans',
        'You can use the following tags' => '',
        'To get the first 20 character of the subject.' => 'Konunun ilk 20 karakterini al',
        'To get the first 5 lines of the email.' => 'Elektronik postanın ilk 5 satırını al',
        'To get the realname of the sender (if given).' => 'Gönderenin gerçek adını al (verilmişse)',
        'To get the article attribute' => '',
        ' e. g.' => '',
        'Options of the current customer user data' => '',
        'Ticket owner options' => '',
        'Ticket responsible options' => '',
        'Options of the current user who requested this action' => '',
        'Options of the ticket data' => '',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => '',
        'Example response' => '',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Müşteri Şirket Yönetimi',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer company' => '',
        'Please enter a search term to look for customer companies.' => '',
        'Add Customer Company' => 'Müşteri Sirket Ekle',

        # Template: AdminCustomerUser
        'Customer Management' => 'Müşteri Yönetimi',
        'Back to search result' => '',
        'Add customer' => 'Müşteri ekle',
        'Select' => 'Seç',
        'Hint' => 'İpucu',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            '',
        'Please enter a search term to look for customers.' => '',
        'Last Login' => 'Son Giriş',
        'Login as' => 'Oturum açma kimliği',
        'Switch to customer' => '',
        'Add Customer' => 'Müşteri Ekle',
        'Edit Customer' => 'Müşteri Düzenle',
        'This field is required and needs to be a valid email address.' =>
            '',
        'This email address is not allowed due to the system configuration.' =>
            '',
        'This email address failed MX check.' => '',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => '',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => '',
        'Notice' => '',
        'This feature is disabled!' => 'Bu özellik kapalı!',
        'Just use this feature if you want to define group permissions for customers.' =>
            '',
        'Enable it here!' => 'Burada aç!',
        'Search for customers.' => '',
        'Edit Customer Default Groups' => '',
        'These groups are automatically assigned to all customers.' => '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '',
        'Filter for Groups' => '',
        'Select the customer:group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '',
        'Search Result:' => 'Sonuç Ara:',
        'Customers' => 'Müşteriler',
        'Groups' => 'Gruplar',
        'No matches found.' => 'Sonuç bulunamadı.',
        'Change Group Relations for Customer' => 'Müşteri için grup ilişkilerini değiştir.',
        'Change Customer Relations for Group' => 'Grup için müşteri ilişkilerini değiştir. ',
        'Toggle %s Permission for all' => '',
        'Toggle %s permission for %s' => '',
        'Customer Default Groups:' => '',
        'No changes can be made to these groups.' => '',
        'ro' => 'so',
        'Read only access to the ticket in this group/queue.' => 'Bu grup/kuyruktaki bilete salt okunur erişim.',
        'rw' => 'oy',
        'Full read and write access to the tickets in this group/queue.' =>
            'Bu grup/kuyruktaki biletlere tam okuma ve yazma erişimi.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => '',
        'Edit default services' => '',
        'Filter for Services' => '',
        'Allocate Services to Customer' => '',
        'Allocate Customers to Service' => '',
        'Toggle active state for all' => '',
        'Active' => 'Etkin',
        'Toggle active state for %s' => '',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Dinamik alanların yönetimi',
        'Add new field for object' => 'Nesne için yeni alan ekle',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Dinamik alanların listesi',
        'Dynamic fields per page' => '',
        'Label' => 'Etiket',
        'Order' => 'Sıralama',
        'Object' => 'Nesne',
        'Delete this field' => 'Bu alanı sil',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Bu dinamik alanı silmek istediğinizden eminmisiniz? İlgili tüm veriler kaybolacak!',
        'Delete field' => 'Alanı sil',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dinamik Alan',
        'Field' => 'Alan',
        'Go back to overview' => 'Genel bakışa geri dön',
        'General' => 'Genel',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => 'Alan sıralaması',
        'This field is required and must be numeric.' => '',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Field type' => '',
        'Object type' => '',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => '',
        'Default value' => '',
        'This is the default value for this field.' => '',
        'Save' => 'Kaydet',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '',
        'This field must be numeric.' => '',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'Anahtar',
        'Value' => 'Değer',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'Not',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',

        # Template: AdminEmail
        'Admin Notification' => 'Yönetim Bilgilendirme',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '',
        'Create Administrative Message' => '',
        'Your message was sent to' => '',
        'Send message to users' => '',
        'Send message to group members' => '',
        'Group members need to have permission' => '',
        'Send message to role members' => '',
        'Also send to customers in groups' => '',
        'Body' => 'Gövde',
        'Send' => 'Gönder',

        # Template: AdminGenericAgent
        'Generic Agent' => '',
        'Add job' => '',
        'Last run' => 'Son çalıştırma',
        'Run Now!' => 'Şimdi Çalıştır!',
        'Delete this task' => '',
        'Run this task' => '',
        'Job Settings' => '',
        'Job name' => '',
        'Currently this generic agent job will not run automatically.' =>
            '',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            '',
        'Schedule minutes' => '',
        'Schedule hours' => '',
        'Schedule days' => '',
        'Toggle this widget' => '',
        'Ticket Filter' => '',
        '(e. g. 10*5155 or 105658*)' => '(örneğin 105155 veya 105658*)',
        '(e. g. 234321)' => '(örneğin 234321)',
        'Customer login' => 'Müşteri Girişi',
        '(e. g. U5150)' => '(örneğin U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '',
        'Agent' => 'Aracı',
        'Ticket lock' => 'Bilet kilitleme',
        'Create times' => 'Oluşturulma zamanı',
        'No create time settings.' => 'Oluşturma zamanı ayarı yok.',
        'Ticket created' => 'Bilet oluşturuldu',
        'Ticket created between' => 'Bilet ikisi arasında oluşturuldu:',
        'Change times' => 'Değiştirilme zamanı',
        'No change time settings.' => 'Zaman ayarlarında değişiklik yok.',
        'Ticket changed' => 'Bilet değişti',
        'Ticket changed between' => '',
        'Close times' => 'Kapanma zamanı',
        'No close time settings.' => '',
        'Ticket closed' => 'Bilet kapatıldı',
        'Ticket closed between' => 'arasındaki bilet kapatıldı',
        'Pending times' => 'Bekleme zamanı',
        'No pending time settings.' => 'Bekleme zamanı ayarı yok.',
        'Ticket pending time reached' => 'Bilet bekleme zamanına ulaşıldı',
        'Ticket pending time reached between' => 'Bilet bekleme zamanına ikisi arasında ulaşıldı:',
        'Escalation times' => '',
        'No escalation time settings.' => '',
        'Ticket escalation time reached' => '',
        'Ticket escalation time reached between' => '',
        'Escalation - first response time' => '',
        'Ticket first response time reached' => '',
        'Ticket first response time reached between' => '',
        'Escalation - update time' => '',
        'Ticket update time reached' => '',
        'Ticket update time reached between' => '',
        'Escalation - solution time' => '',
        'Ticket solution time reached' => '',
        'Ticket solution time reached between' => '',
        'Archive search option' => '',
        'Ticket Action' => '',
        'Set new service' => '',
        'Set new Service Level Agreement' => '',
        'Set new priority' => '',
        'Set new queue' => '',
        'Set new state' => '',
        'Set new agent' => '',
        'new owner' => '',
        'new responsible' => '',
        'Set new ticket lock' => '',
        'New customer' => '',
        'New customer ID' => '',
        'New title' => '',
        'New type' => '',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => '',
        'Add Note' => 'Not Ekle',
        'Time units' => 'Zaman birimleri',
        '(work units)' => '',
        'Ticket Commands' => '',
        'Send agent/customer notifications on changes' => '',
        'CMD' => 'Komut',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Bu komut çalıştırılacak. Par[0] bilet bilet numarası olacak. Par[1] bilet kimliği.',
        'Delete tickets' => 'Biletleri sil',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '',
        'Execute Custom Module' => '',
        'Param %s key' => '',
        'Param %s value' => '',
        'Save Changes' => '',
        'Results' => 'Sonuçlar',
        '%s Tickets affected! What do you want to do?' => '',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '',
        'Edit job' => '',
        'Run job' => '',
        'Affected Tickets' => '',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Zaman',
        'Remote IP' => '',
        'Loading' => '',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Tazele',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Show or hide the content' => '',
        'Clear debug log' => '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'The name you entered already exists.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => '',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Event Triggers' => '',
        'Asynchronous' => '',
        'Delete this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Save and finish' => '',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => '',
        'Mapping Simple' => '',
        'Default rule for unmapped keys' => '',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => '',
        'Key mapping' => '',
        'Map key' => '',
        'matching the' => '',
        'to new key' => '',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => '',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '',
        'The password to open the SSL certificate.' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export web service' => '',
        'Import web service' => '',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'İçeri aktar',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => '',
        'Inbound mapping' => '',
        'Outbound mapping' => '',
        'Delete this action' => '',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => '',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => '',
        'Import webservice' => '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'Sürüm',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '',
        'Group Management' => 'Grup Yönetimi',
        'Add group' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Yönetim grubu yönetim alanına ve istatistikler grubu istatistik alanına girmek içindir.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '',
        'It\'s useful for ASP solutions. ' => '',
        'Add Group' => 'Grup Ekle',
        'Edit Group' => '',

        # Template: AdminLog
        'System Log' => 'Sistem Günlüğü',
        'Here you will find log information about your system.' => '',
        'Hide this message' => '',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Add mail account' => '',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Tek hesaplı tüm gelen elektronik postalar seçili kuyruğa gönderilecek!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Eğer hesap güvenilir ise, varış zamanında (öncelik, ... için) varolan X-OTRS başlığı kullanılacak! PostMaster süzgeci her halükârda kullanılır.',
        'Host' => 'Sunucu',
        'Delete account' => '',
        'Fetch mail' => '',
        'Add Mail Account' => '',
        'Example: mail.example.com' => '',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Güvenilir',
        'Dispatching' => 'Gönderiliyor',
        'Edit Mail Account' => '',

        # Template: AdminNavigationBar
        'Admin' => 'Yönetici',
        'Agent Management' => 'Aracı Yönetimi',
        'Queue Settings' => 'Kuyruk Ayarları',
        'Ticket Settings' => 'Bilet Ayarları',
        'System Administration' => 'Sistem Yöneticisi',

        # Template: AdminNotification
        'Notification Management' => 'Bildirim Yönetimi',
        'Select a different language' => '',
        'Filter for Notification' => '',
        'Notifications are sent to an agent or a customer.' => 'Bildirimler bir aracıya veya müşteriye gönderilirler.',
        'Notification' => 'Bildirimler',
        'Edit Notification' => '',
        'e. g.' => '',
        'Options of the current customer data' => '',

        # Template: AdminNotificationEvent
        'Add notification' => 'Uyarı Ekle',
        'Delete this notification' => 'Bu uyarıyı sil',
        'Add Notification' => 'Bildirim ekle',
        'Recipient groups' => 'Alıcı Grup',
        'Recipient agents' => 'Alıcı aracılar',
        'Recipient roles' => 'Alıcı roller',
        'Recipient email addresses' => 'alıcı e-posta adresleri',
        'Article type' => 'Metin tipi',
        'Only for ArticleCreate event' => '',
        'Article sender type' => '',
        'Subject match' => 'Konu eşleme',
        'Body match' => 'Gövde eşleme',
        'Include attachments to notification' => '',
        'Notification article type' => '',
        'Only for notifications to specified email addresses' => '',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            '',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            '',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            '',

        # Template: AdminPGP
        'PGP Management' => 'PGP Yönetimi',
        'Use this feature if you want to work with PGP keys.' => '',
        'Add PGP key' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Bu şekilde Sistem Yapılandırmasında yapılandırılmış olan anahtar halkasını (keyring) direkt olarak düzenleyebilirsiniz.',
        'Introduction to PGP' => '',
        'Result' => 'Sonuç',
        'Identifier' => 'Tanımlayıcı',
        'Bit' => 'Bit',
        'Fingerprint' => 'Parmak izi',
        'Expires' => 'Geçerliliğini yitirme zamanı',
        'Delete this key' => '',
        'Add PGP Key' => '',
        'PGP key' => '',

        # Template: AdminPackageManager
        'Package Manager' => 'Paket Yöneticisi',
        'Uninstall package' => '',
        'Do you really want to uninstall this package?' => 'Gerçekten bu paketi kaldırmak istiyor musunuz?',
        'Reinstall package' => '',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '',
        'Continue' => 'Devam et',
        'Install' => 'Yükle',
        'Install Package' => 'Paketi yükle',
        'Update repository information' => 'Depo bilgilerini güncelle',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Gerekli özelliği bulamadınızmı? OTRS grubu üye müşterilerimize seçkin eklentileri sunar.',
        'Online Repository' => 'Çevrimiçi Depo',
        'Vendor' => 'Sağlayıcı',
        'Module documentation' => '',
        'Upgrade' => 'Yükselt',
        'Local Repository' => 'Yerel Depo',
        'Uninstall' => 'Kaldır',
        'Reinstall' => 'Yeniden yükle',
        'Feature Add-Ons' => '',
        'Download package' => '',
        'Rebuild package' => '',
        'Metadata' => '',
        'Change Log' => '',
        'Date' => 'Tarih',
        'List of Files' => '',
        'Permission' => 'İzin',
        'Download' => 'İndir',
        'Download file from package!' => 'Paketten dosya indir!',
        'Required' => 'Gerektirir',
        'PrimaryKey' => 'Ana Anahtar',
        'AutoIncrement' => 'Otomatik Arttır',
        'SQL' => 'SQL',
        'File differences for file %s' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performans Günlüğü',
        'This feature is enabled!' => 'Bu özellik açık!',
        'Just use this feature if you want to log each request.' => 'Bu özelliği sadece her isteği günlüğe kaydetmek istiyorsanız kullanın.',
        'Activating this feature might affect your system performance!' =>
            '',
        'Disable it here!' => 'Burada kapat!',
        'Logfile too large!' => 'Günlük dosyası çok büyük!',
        'The logfile is too large, you need to reset it' => '',
        'Overview' => 'Genel Bakış',
        'Range' => 'Aralık',
        'Interface' => 'Arayüz',
        'Requests' => 'İstekler',
        'Min Response' => 'En Az Yanıt',
        'Max Response' => 'En Çok Yanıt',
        'Average Response' => 'Ortalama Yanıt',
        'Period' => 'zaman dilimi',
        'Min' => 'min',
        'Max' => 'max',
        'Average' => 'ortalama',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMaster Süzgeç Yönetimi',
        'Add filter' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Sadece elektronik posta adresine göre eşleştirmek istiyorsanız Kimden, Kime veya Karbon Kopya alanlarında EMAILADDRESS:bilgi@ornek.com kullanın.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '',
        'Delete this filter' => '',
        'Add PostMaster Filter' => '',
        'Edit PostMaster Filter' => '',
        'Filter name' => '',
        'The name is required.' => '',
        'Stop after match' => '',
        'Filter Condition' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => '',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Öncelik yönetimi',
        'Add priority' => '',
        'Add Priority' => 'Öncelik ekle',
        'Edit Priority' => '',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'Süzgeç',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Copy' => '',
        'Print' => 'Yazdır',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'İptal & Pencereyi kapat',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => '',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Fields' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Edit Details for Field' => '',
        'ArticleType' => '',
        'Display' => '',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '',
        'Filter Activities...' => '',
        'Create New Activity' => '',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => '',
        'Condition' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Configuration' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Remove this Field' => '',
        'Add a new Field' => '',
        'Add New Condition' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => '',
        'Add a new Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => '',
        'Add queue' => '',
        'Add Queue' => '',
        'Edit Queue' => '',
        'Sub-queue of' => '',
        'Unlock timeout' => 'Kilidi kaldırmak için zaman aşımı',
        '0 = no unlock' => '0 = kilit kaldırma yok',
        'Only business hours are counted.' => '',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '',
        'Notify by' => '',
        '0 = no escalation' => '0 = yükseltme yok',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '',
        'Follow up Option' => 'Takip eden Seçeneği',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '',
        'Ticket lock after a follow up' => 'Takip eden bir mesajdan sonra bileti kilitle',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '',
        'System address' => '',
        'Will be the sender address of this queue for email answers.' => 'Elektronik posta yanıtları için bu kuyruğun gönderen adresi olur.',
        'Default sign key' => '',
        'The salutation for email answers.' => 'Elektronik posta yanıtları için selamlama.',
        'The signature for email answers.' => 'Elektronik posta yanıtları için imza.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '',
        'Filter for Queues' => '',
        'Filter for Auto Responses' => '',
        'Auto Responses' => 'Otomatik Yanıtlar',
        'Change Auto Response Relations for Queue' => '',
        'settings' => 'ayarlar',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => '',
        'Filter for Responses' => '',
        'Responses' => 'Yanıtlar',
        'Change Queue Relations for Response' => '',
        'Change Response Relations for Queue' => '',

        # Template: AdminResponse
        'Manage Responses' => '',
        'Add response' => '',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            '',
        'Don\'t forget to add new responses to queues.' => '',
        'Delete this entry' => '',
        'Add Response' => '',
        'Edit Response' => '',
        'The current ticket state is' => 'Bilet durumu',
        'Your email address is' => '',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => '',
        'Filter for Attachments' => '',
        'Change Response Relations for Attachment' => '',
        'Change Attachment Relations for Response' => '',
        'Toggle active for all' => '',
        'Link %s to selected %s' => '',

        # Template: AdminRole
        'Role Management' => 'Rol Yönetimi',
        'Add role' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Bir rol oluşturun ve içine gruplardan koyun. Sonra rolu kullanıcılara atayın.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '',
        'Add Role' => 'Rol Ekle',
        'Edit Role' => '',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '',
        'Filter for Roles' => '',
        'Roles' => 'Roller',
        'Select the role:group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '',
        'Change Role Relations for Group' => '',
        'Change Group Relations for Role' => '',
        'Toggle %s permission for all' => '',
        'move_into' => 'taşı',
        'Permissions to move tickets into this group/queue.' => 'Biletleri bu gruba/kuyruğa taşıma izni.',
        'create' => 'yarat',
        'Permissions to create tickets in this group/queue.' => 'Bu grupta/kuyrukta bilet oluşturma izni.',
        'priority' => 'öncelik',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Bu grupta/kuyrukta bilet önceliğini değiştirme izni.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '',
        'Filter for Agents' => '',
        'Agents' => '',
        'Manage Role-Agent Relations' => '',
        'Change Role Relations for Agent' => '',
        'Change Agent Relations for Role' => '',

        # Template: AdminSLA
        'SLA Management' => 'SLA Yönetimi',
        'Add SLA' => 'SLA ekle',
        'Edit SLA' => '',
        'Please write only numbers!' => '',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME Yönetimi',
        'Add certificate' => '',
        'Add private key' => '',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Ayrıca bakınız',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Buradan dosya sistemindeki sertifikaları ve kişisel anahtarları uğraşmadan düzenleyebilirsiniz.',
        'Hash' => 'Özel katar (hash)',
        'Create' => 'Oluştur',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => '',
        'Add Certificate' => 'Sertifika Ekle',
        'Add Private Key' => 'Kişisel Anahtar Ekle',
        'Secret' => 'Gizli',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Selamlama Yönetimi',
        'Add salutation' => '',
        'Add Salutation' => 'Selamlama Ekle',
        'Edit Salutation' => '',
        'Example salutation' => '',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            '',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '',

        # Template: AdminSelectBox
        'SQL Box' => '',
        'Here you can enter SQL to send it directly to the application database.' =>
            '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            '',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => 'Sonuç Biçimi',
        'Run Query' => 'Sorgu Çalıştır',

        # Template: AdminService
        'Service Management' => 'Servis Yönetimi',
        'Add service' => 'Servis ekle',
        'Add Service' => 'Servis Ekle',
        'Edit Service' => 'Servis Düzenle',
        'Sub-service of' => 'Alt servis',

        # Template: AdminSession
        'Session Management' => 'Oturum Yönetimi',
        'All sessions' => 'Bütün oturumlar',
        'Agent sessions' => 'Aracı oturum',
        'Customer sessions' => 'Müşteri oturumu',
        'Unique agents' => 'Benzer aracılar',
        'Unique customers' => 'Benzer müşteriler',
        'Kill all sessions' => 'Tüm oturumları öldür',
        'Kill this session' => 'Bu oturumu öldür',
        'Session' => 'Oturum',
        'Kill' => 'Öldür',
        'Detail View for SessionID' => 'OturumID için detaylı görünüm',

        # Template: AdminSignature
        'Signature Management' => 'İmza Yönetimi',
        'Add signature' => 'İmza ekle',
        'Add Signature' => 'İmza Ekle',
        'Edit Signature' => 'İmza Düzenle',
        'Example signature' => 'Örnek imza',

        # Template: AdminState
        'State Management' => 'Durum Yönetimi',
        'Add state' => 'Durum ekle',
        'Please also update the states in SysConfig where needed.' => 'Sysconfig\'te gerekli durumları da güncelle',
        'Add State' => 'Durum Ekle',
        'Edit State' => 'Durum Düzenle',
        'State type' => 'Durum tipi',

        # Template: AdminSysConfig
        'SysConfig' => 'Sistem Yapılandırması',
        'Navigate by searching in %s settings' => '',
        'Navigate by selecting config groups' => '',
        'Download all system config changes' => '',
        'Export settings' => '',
        'Load SysConfig settings from file' => '',
        'Import settings' => '',
        'Import Settings' => '',
        'Please enter a search term to look for settings.' => '',
        'Subgroup' => 'Alt grup',
        'Elements' => 'Öğeler',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => '',
        'This config item is only available in a higher config level!' =>
            '',
        'Reset this setting' => '',
        'Error: this file could not be found.' => '',
        'Error: this directory could not be found.' => '',
        'Error: an invalid value was entered.' => '',
        'Content' => 'Içerik',
        'Remove this entry' => '',
        'Add entry' => '',
        'Remove entry' => '',
        'Add new entry' => '',
        'Create new entry' => '',
        'New group' => '',
        'Group ro' => '',
        'Readonly group' => '',
        'New group ro' => '',
        'Loader' => '',
        'File to load for this frontend module' => '',
        'New Loader File' => '',
        'NavBarName' => 'Dolaşma Çubuğu Adı',
        'NavBar' => 'Dolaşma Çubuğu',
        'LinkOption' => 'Bağlantı Seçeneği',
        'Block' => 'Blok',
        'AccessKey' => 'Erişim Tuşu',
        'Add NavBar entry' => '',
        'Year' => 'Yıl',
        'Month' => 'Ay',
        'Day' => 'Gün',
        'Invalid year' => '',
        'Invalid month' => '',
        'Invalid day' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Sistem E-Posta Adresleri Yönetimi',
        'Add system address' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '',
        'Email address' => '',
        'Display name' => '',
        'Add System Email Address' => '',
        'Edit System Email Address' => '',
        'The display name and email address will be shown on mail you send.' =>
            '',

        # Template: AdminType
        'Type Management' => 'Tip Yönetimi',
        'Add ticket type' => '',
        'Add Type' => 'Tip Ekle',
        'Edit Type' => '',

        # Template: AdminUser
        'Add agent' => '',
        'Agents will be needed to handle tickets.' => '',
        'Don\'t forget to add a new agent to groups and/or roles!' => '',
        'Please enter a search term to look for agents.' => '',
        'Last login' => 'Son giriş',
        'Switch to agent' => '',
        'Add Agent' => '',
        'Edit Agent' => '',
        'Firstname' => 'Adı',
        'Lastname' => 'Soyadı',
        'Password is required.' => '',
        'Start' => 'Başla',
        'End' => 'Son',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => '',
        'Change Group Relations for Agent' => '',
        'Change Agent Relations for Group' => '',
        'note' => '',
        'Permissions to add notes to tickets in this group/queue.' => '',
        'owner' => 'sahip',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '',

        # Template: AgentBook
        'Address Book' => 'Adres Defteri',
        'Search for a customer' => '',
        'Add email address %s to the To field' => '',
        'Add email address %s to the Cc field' => '',
        'Add email address %s to the Bcc field' => '',
        'Apply' => '',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'Müşteri Kimliği',
        'Customer User' => 'Müşteri Kullanıcı',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Kullanıcı Ara',
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => '',

        # Template: AgentDashboardCalendarOverview
        'in' => '',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s erişilebilir',
        'Please update now.' => 'Şimdi güncelleyin',
        'Release Note' => 'Sürüm notu',
        'Level' => 'Seviye',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => '%s önce gönderildi.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Kilitli biletlerim',
        'My watched tickets' => 'İzlediğim biletler',
        'My responsibilities' => 'Sorumluluklarım',
        'Tickets in My Queues' => 'Kuyruğumdaki biletler',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Bilet kilitlendi',
        'Undo & close window' => 'Geri al & pencereyi kapat',

        # Template: AgentInfo
        'Info' => 'Bilgi',
        'To accept some news, a license or some changes.' => '',

        # Template: AgentLinkObject
        'Link Object: %s' => '',
        'go to link delete screen' => '',
        'Select Target Object' => '',
        'Link Object' => 'Bağ Nesnesi',
        'with' => 'ile',
        'Unlink Object: %s' => '',
        'go to link add screen' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Tercihleri düzenle',

        # Template: AgentSpelling
        'Spell Checker' => 'Sözdizim Denetleyicisi',
        'spelling error(s)' => 'sözdizim hatası',
        'Apply these changes' => 'Bu değişiklikleri uygula',

        # Template: AgentStatsDelete
        'Delete stat' => 'Durumu sil',
        'Stat#' => 'İstatistik numarası',
        'Do you really want to delete this stat?' => 'Bu durumu gerçekten silmek istiyormusunuz?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => '%s. adım',
        'General Specifications' => 'Genel Özellikler',
        'Select the element that will be used at the X-axis' => '',
        'Select the elements for the value series' => 'Değer serileri için öğeleri seçin',
        'Select the restrictions to characterize the stat' => '',
        'Here you can make restrictions to your stat.' => 'Burada istatistiklerinize kısıtlamalar yapabilirsiniz.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            '"Sabit" kutusunun işaretini kaldırırsanız, istatistiği oluşturan aracı karşılık gelen öğenin niteliklerini değiştirebilir.',
        'Fixed' => 'Sabit',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Lütfen sadece bir öğe seçin veya \'Sabit\' düğmesini kapatın.',
        'Absolute Period' => '',
        'Between' => 'Arasında',
        'Relative Period' => 'Değişken Süre',
        'The last' => 'Son',
        'Finish' => 'Bitir',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'İzinler',
        'You can select one or more groups to define access for different agents.' =>
            '',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            '',
        'Please contact your administrator.' => '',
        'Graph size' => '',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Eğer çıktı biçimi olana bir grafik seçerseniz en azından bir grafik boyutu seçmelisiniz.',
        'Sum rows' => 'Toplam satırları',
        'Sum columns' => 'Toplam sütunları',
        'Use cache' => '',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'İstatistiklerin çoğunluğu önbelleklenebilir. Bu, bu istatistiğin sunulmasını hızlandırır.',
        'If set to invalid end users can not generate the stat.' => '',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => '',
        'You have the possibility to select one or two elements.' => '',
        'Then you can select the attributes of elements.' => '',
        'Each attribute will be shown as single value series.' => '',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            '',
        'Scale' => 'Ölçek',
        'minimal' => 'mümkün olan en düşük',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Unutmayın değer serilerinin ölçeği X-ekseninin ölçeğinden daha yüksek olmalıdır (örneğin X-ekseni => Ay, Değer Serileri => Yıl).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            '',
        'maximal period' => 'en yüksek süre',
        'minimal scale' => 'en düşük ölçek',

        # Template: AgentStatsImport
        'Import Stat' => '',
        'File is not a Stats config' => 'Dosya bir İstatistik yapılandırması değil',
        'No File selected' => 'Dosya seçilmedi',

        # Template: AgentStatsOverview
        'Stats' => 'İstatistikler',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Öğe seçilmedi.',

        # Template: AgentStatsView
        'Export config' => '',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            '',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            '',
        'Stat Details' => '',
        'Format' => 'Biçim',
        'Graphsize' => 'Grafik boyutu',
        'Cache' => 'Tampon',
        'Exchange Axis' => 'Eksenlerin Yerini Değiştir',
        'Configurable params of static stat' => 'Değişmez istatistiğin ayarlanabilir parametreleri',
        'No element selected.' => 'Öğe seçilmedi.',
        'maximal period from' => 'en yüksek süre şundan:',
        'to' => 'şuna:',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Biletin yazısı değiştir',
        'Change Owner of Ticket' => 'Bilet sahibini değiştir',
        'Close Ticket' => 'Bileti kapat',
        'Add Note to Ticket' => 'Bilete not ekle',
        'Set Pending' => 'Beklemeyi Ayarla',
        'Change Priority of Ticket' => 'Bilet önceliğini değiştir',
        'Change Responsible of Ticket' => 'Bilet sorumluluğunu değiştir',
        'Service invalid.' => 'Servis hatalı',
        'New Owner' => 'Yeni Sahip',
        'Please set a new owner!' => 'Yeni sahip ata',
        'Previous Owner' => 'Önceki sahip',
        'Inform Agent' => 'Aracıyı bilgilendir',
        'Optional' => 'Seçimlik',
        'Inform involved Agents' => 'İlgili aracıları bilgilendir',
        'Spell check' => 'Yazım denetimi',
        'Note type' => 'Not tipi',
        'Next state' => 'Sonraki durum',
        'Pending date' => 'Bekleme tarihi',
        'Date invalid!' => 'Hatalı tarih!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Bilet ötele',
        'Bounce to' => 'Şuna ötele:',
        'You need a email address.' => 'E-posta gerekli',
        'Need a valid email address or don\'t use a local email address.' =>
            '',
        'Next ticket state' => 'Biletin sonraki durumu',
        'Inform sender' => 'Göndereni bilgilendir',
        'Send mail!' => 'Postayı gönder!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Bilet Toplu İşlemi',
        'Send Email' => 'Postayı gönder',
        'Merge to' => 'Şuna birleştir:',
        'Invalid ticket identifier!' => 'Hatalı bilet tanımlayıcı!',
        'Merge to oldest' => 'Daha eskilere birleştir',
        'Link together' => 'Birbirine bağlan',
        'Link to parent' => '',
        'Unlock tickets' => 'Biletleri aç',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Bilete cevap yaz',
        'Remove Ticket Customer' => 'Müşteri biletini kaldır',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Please include at least one recipient' => '',
        'Remove Cc' => 'KK Kaldır',
        'Remove Bcc' => 'GKK Kaldır',
        'Address book' => 'Adres defteri',
        'Pending Date' => 'Bekleme tarihi',
        'for pending* states' => 'Bekleme* durumları için',
        'Date Invalid!' => 'Hatalı Tarih',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Biletin müşterisini değiştir',
        'Customer Data' => 'Müşteri Verisi',
        'Customer user' => 'Müşteri hesabı',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Yeni e-posta bileti oluştur',
        'From queue' => 'Kuyruktan',
        'To customer' => 'Müşteriye',
        'Please include at least one customer for the ticket.' => 'En az bir müşteri bileti içermeli',
        'Get all' => 'Hepsini getir',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Şunun tarihçesi:',
        'History Content' => 'Tarihçe içeriği',
        'Zoom view' => 'Yakınlaştırma görünümü',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Bilet Birleştir',
        'You need to use a ticket number!' => 'Bilet numarası kullanmalısınız!',
        'A valid ticket number is required.' => '',
        'Need a valid email address.' => '',

        # Template: AgentTicketMove
        'Move Ticket' => 'Bileti Taşı',
        'New Queue' => 'Yeni Kuyruk',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => '',
        'No ticket data found.' => 'Bilet kaydı bulunamadı.',
        'First Response Time' => 'İlk Yanıt Zamanı',
        'Service Time' => 'Servis Zamanı',
        'Update Time' => 'Güncelleme Zamanı',
        'Solution Time' => 'Çözüm Zamanı',
        'Move ticket to a different queue' => 'Bileti başka bir kuyruğa taşı',
        'Change queue' => 'Kuyruğu değiştir',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Arama seçeneklerini değiştir',
        'Tickets per page' => 'Her sayfadaki biletler',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Yükselme',
        'Locked' => 'Kilitli',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Yeni telefon bileti oluştur',
        'From customer' => 'Müşteriden',
        'To queue' => 'Kuyruğa',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Telefon araması',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'E-posta düz metin görünümü',
        'Plain' => 'Düz',
        'Download this email' => 'Bu e-postayı indir',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Bilet Bilgisi',
        'Accounted time' => 'Hesaplanan zaman',
        'Linked-Object' => 'Bağlı Nesne',
        'by' => 'tarafından',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Arama Şablonu',
        'Create Template' => 'Şablon oluştur',
        'Create New' => 'Yeni oluştur',
        'Profile link' => 'Profil bağlantısı',
        'Save changes in template' => 'Değişiklikleri şablona kaydet',
        'Add another attribute' => 'Başka bir nitelik ekle',
        'Output' => 'Sonuç Formu',
        'Fulltext' => 'Tüm metin',
        'Remove' => 'Kaldır',
        'Customer User Login' => 'Müşteri Kullanıcı Oturum Açma',
        'Created in Queue' => 'Kuyrukta Oluşturuldu',
        'Lock state' => 'Kilit durumu',
        'Watcher' => 'İzleyici',
        'Article Create Time (before/after)' => 'Makale Oluşturulma Zamanı (önce/sonra)',
        'Article Create Time (between)' => 'Makale Oluşturulma Zamanı (arasında)',
        'Ticket Create Time (before/after)' => 'Bilet Oluşturulma Zamanı (önce/sonra)',
        'Ticket Create Time (between)' => 'Bilet Oluşturulma Zamanı (arasında)',
        'Ticket Change Time (before/after)' => 'Bilet Değiştirilme Zamanı (önce/sonra)',
        'Ticket Change Time (between)' => 'Bilet Değiştirilme Zamanı (arasında)',
        'Ticket Close Time (before/after)' => 'Bilet Kapatılma Zamanı (önce/sonra)',
        'Ticket Close Time (between)' => 'Bilet Kapatılma Zamanı (arasında)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Arşiv arama',
        'Run search' => 'Aramayı çalıştır',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Makale Filtresi',
        'Article Type' => 'Makale tipi',
        'Sender Type' => 'Gönderici tipi',
        'Save filter settings as default' => 'Filtreyi varsayılan olarak kaydet',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Linked Objects' => 'Bağlantılı Nesneler',
        'Article(s)' => 'Makale(ler)',
        'Change Queue' => 'Kuyruk Değiştir',
        'There are currently no steps available for this process.' => '',
        'This item has no articles yet.' => '',
        'Article Filter' => 'Makale Filtresi',
        'Add Filter' => 'Filtre ekle',
        'Set' => 'Ayarla',
        'Reset Filter' => 'Filtreyi Sıfırla',
        'Show one article' => 'Bir makale göster',
        'Show all articles' => 'Tüm makaleleri göster',
        'Unread articles' => 'Okunmamış makaleler',
        'No.' => '',
        'Unread Article!' => 'Okunmamış Makale!',
        'Incoming message' => 'Gelen Mesaj',
        'Outgoing message' => 'Giden Mesaj',
        'Internal message' => 'İç mesaj',
        'Resize' => 'Yeniden Boyutlandır',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Bloklu içeriği yükle.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Geri iz',

        # Template: CustomerFooter
        'Powered by' => '',
        'One or more errors occurred!' => '',
        'Close this dialog' => '',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript Kullanılamıyor',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => '',
        'The browser you are using is too old.' => '',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            '',
        'Login' => 'Oturum aç',
        'User name' => 'Adınız',
        'Your user name' => 'Soyadınız',
        'Your password' => 'parolanız',
        'Forgot password?' => 'Parolanızı unuttunuz mu?',
        'Log In' => 'Giriş',
        'Not yet registered?' => 'Henüz kayıt olmadınız mı?',
        'Sign up now' => 'Şimdi kaydol',
        'Request new password' => 'Yeni parola iste',
        'Your User Name' => 'Kullanıcı Adı',
        'A new password will be sent to your email address.' => '...',
        'Create Account' => 'Hesap oluştur',
        'Please fill out this form to receive login credentials.' => 'Giriş bilgilerini almak için bu formu doldurun.',
        'How we should address you' => 'Size nasıl hitap edelim?',
        'Your First Name' => 'Adınız',
        'Please supply a first name' => 'Lütfen bir isim belirleyiniz',
        'Your Last Name' => 'Soyadınız',
        'Please supply a last name' => 'Lütfen bir soyadı belirleyiniz',
        'Your email address (this will become your username)' => 'E-posta adresiniz (Bu kullanıcı adınız olacak)',
        'Please supply a' => 'Lütfen belirleyin bir',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Kişisel tercihleri görüntüle',
        'Logout %s' => 'Çıkış %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Servis seviye anlaşması',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Hoşgeldiniz',
        'Please click the button below to create your first ticket.' => 'Lütfen ilk biletinizi oluşturmak için aşağıdaki butona basın.',
        'Create your first ticket' => 'İlk biletinizi oluşturun',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Bilet Bas',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'örn: 10*5155 yada 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Biletler içerisinde ara (örn: "Ahmet*t" yada "Ali*")',
        'Recipient' => 'alıcı',
        'Carbon Copy' => 'Karbon kopya',
        'Time restrictions' => 'Zaman kısıtlaması',
        'No time settings' => 'Zaman ayarları yok',
        'Only tickets created' => 'Sadece biletler oluşturuldu',
        'Only tickets created between' => 'Sadece şu zaman aralığında oluşturulan biletler',
        'Ticket archive system' => 'Bilet arşiv sistemi',
        'Save search as template?' => 'Aramayı şablon olarak kaydet',
        'Save as Template?' => 'Şablon olarak kaydedilsin mi?',
        'Save as Template' => 'Şablon olarak kaydet',
        'Template Name' => 'Şablon Adı',
        'Pick a profile name' => 'Bir profil adı seç',
        'Output to' => 'Çıkar',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => '..nın',
        'Page' => 'Sayfa',
        'Search Results for' => 'için arama sonuçları ',

        # Template: CustomerTicketZoom
        'Show  article' => '',
        'Expand article' => 'Makaleyi genişlet',
        'Information' => '',
        'Next Steps' => '',
        'There are no further steps in this process' => '',
        'Reply' => 'Cevapla',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Hatalı tarih (ileri bir tarih olmalı)!',
        'Previous' => 'Önceki',
        'Sunday' => 'Pazar',
        'Monday' => 'Pazartesi',
        'Tuesday' => 'Salı',
        'Wednesday' => 'Çarşamba',
        'Thursday' => 'Perşembe',
        'Friday' => 'Cuma',
        'Saturday' => 'Cumartesi',
        'Su' => 'Paz',
        'Mo' => 'Pzt',
        'Tu' => 'Sa',
        'We' => 'Çar',
        'Th' => 'Per',
        'Fr' => 'Cu',
        'Sa' => 'Cmt',
        'Open date selection' => '',

        # Template: Error
        'Oops! An Error occurred.' => '',
        'Error Message' => 'Hata mesajı',
        'You can' => '',
        'Send a bugreport' => 'Hata raporu gönder',
        'go back to the previous page' => 'Bir önceki sayfaya geri dön',
        'Error Details' => 'Hata detayı',

        # Template: Footer
        'Top of page' => '',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => '',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => '',
        'Database Settings' => 'Veritabanı ayarları',
        'General Specifications and Mail Settings' => '',
        'Registration' => '',
        'Welcome to %s' => '%s sistemine hoşgeldiniz',
        'Web site' => '',
        'Database check successful.' => 'Veritabanı kontrolü başarılı.',
        'Mail check successful.' => 'E-posta kontrolü başarılı.',
        'Error in the mail settings. Please correct and try again.' => '',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '',
        'Outbound mail type' => '',
        'Select outbound mail type.' => '',
        'Outbound mail port' => '',
        'Select outbound mail port.' => '',
        'SMTP host' => '',
        'SMTP host.' => '',
        'SMTP authentication' => '',
        'Does your SMTP host need authentication?' => '',
        'SMTP auth user' => '',
        'Username for SMTP auth.' => '',
        'SMTP auth password' => '',
        'Password for SMTP auth.' => '',
        'Configure Inbound Mail' => '',
        'Inbound mail type' => '',
        'Select inbound mail type.' => '',
        'Inbound mail host' => '',
        'Inbound mail host.' => '',
        'Inbound mail user' => '',
        'User for inbound mail.' => '',
        'Inbound mail password' => '',
        'Password for inbound mail.' => '',
        'Result of mail configuration check' => '',
        'Check mail configuration' => '',
        'Skip this step' => '',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => '',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            '',
        'Currently only MySQL is supported in the web installer.' => '',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            '',
        'Database-User' => 'Veritabanı kullanıcısı',
        'New' => 'Yeni',
        'A new database user with limited rights will be created for this OTRS system.' =>
            '',
        'default \'hot\'' => 'varsayılan \'host\'',
        'DB host' => '',
        'Check database settings' => '',
        'Result of database check' => '',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'OTRS\'yi kullanabilmek için komut satırında (konsol/kabuk/terminal) root kullanıcısı olarak şu satırı girmelisiniz.',
        'Restart your webserver' => 'Web sunucunuzu yeniden başlatın.',
        'After doing so your OTRS is up and running.' => 'Bunu yaptıktan sonra OTRS çalışıyor olacak.',
        'Start page' => 'Başlangıç sayfası',
        'Your OTRS Team' => 'OTRS Takımınız',

        # Template: InstallerLicense
        'Accept license' => 'Lisansı kabul et',
        'Don\'t accept license' => 'Lisansı kabul etme',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Kuruluş',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'Sistem Kimliği',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '',
        'System FQDN' => 'Sistem tam adresi (FQDN)',
        'Fully qualified domain name of your system.' => '',
        'AdminEmail' => 'Yönetici E-Posta Adresi',
        'Email address of the system administrator.' => '',
        'Log' => 'Günlük',
        'LogModule' => 'Günlük Bileşeni',
        'Log backend to use.' => '',
        'LogFile' => '',
        'Log file location is only needed for File-LogModule!' => '',
        'Webfrontend' => 'Web Önyüzü',
        'Default language' => '',
        'Default language.' => '',
        'CheckMXRecord' => 'MX Kayıtlarını Kontrol Et',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '',

        # Template: LinkObject
        'Object#' => '',
        'Add links' => '',
        'Delete links' => '',

        # Template: Login
        'Lost your password?' => 'Parolanızı mı kaybettiniz?',
        'Request New Password' => 'Yeni Parola Talep Et',
        'Back to login' => 'Giriş\'e dön',

        # Template: Motd
        'Message of the Day' => 'Günün Mesajı',

        # Template: NoPermission
        'Insufficient Rights' => '',
        'Back to the previous page' => '',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'İlk sayfayı göster',
        'Show previous pages' => 'Bir önceki sayfayı göster',
        'Show page %s' => '%s. sayfayı göster',
        'Show next pages' => 'Bir sonraki sayfayı göster',
        'Show last page' => 'Son sayfayı göster',

        # Template: PictureUpload
        'Need FormID!' => 'FormID gerekli',
        'No file found!' => 'Dosya bulunamadı!',
        'The file is not an image that can be shown inline!' => '',

        # Template: PrintFooter
        'URL' => 'Adres (URL)',

        # Template: PrintHeader
        'printed by' => 'yazdıran',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS Test Sayfası',
        'Welcome %s' => 'Hoşgeldin %s',
        'Counter' => 'Sayaç',

        # Template: Warning
        'Go back to the previous page' => '',

        # SysConfig
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Agent Notifications' => '',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            '',
        'Agent interface module to access search profiles via nav bar.' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to check the used charset.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => '',
        'Agents <-> Roles' => '',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => '',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Attachments <-> Responses' => 'Ekler <-> Yanıtlar',
        'Auto Responses <-> Queues' => '',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas.' => '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Parola Değiştir',
        'Change queue!' => 'Kuyruk değiştir',
        'Change the customer for this ticket' => 'Bu bilet için müşteri değiştir',
        'Change the free fields for this ticket' => 'Bu bilet için boş alanları değiştir',
        'Change the priority for this ticket' => 'Bu bilet için öncelik değiştir',
        'Change the responsible person for this ticket' => 'Bu bilet için sorumlu kişiyi değiştir',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => 'Müşteriye ait kapalı biletler',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => '',
        'Company Tickets' => 'Şirket biletleri',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => '',
        'Create and manage agents.' => 'Aracı oluştur ve yönet',
        'Create and manage attachments.' => '',
        'Create and manage companies.' => '',
        'Create and manage customers.' => '',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => '',
        'Create and manage groups.' => '',
        'Create and manage queues.' => '',
        'Create and manage response templates.' => '',
        'Create and manage responses that are automatically sent.' => '',
        'Create and manage roles.' => '',
        'Create and manage salutations.' => '',
        'Create and manage services.' => '',
        'Create and manage signatures.' => '',
        'Create and manage ticket priorities.' => '',
        'Create and manage ticket states.' => '',
        'Create and manage ticket types.' => '',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => '',
        'Create new phone ticket (inbound)' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Müşteri Kullanıcılar',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customers <-> Groups' => '',
        'Customers <-> Services' => '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'E-Posta Adresleri',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Yükselme Görünümü',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => '',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Experimental "Slim" skin which tries to save screen space for power users.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => '',
        'GenericAgent' => 'GenelAracı',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => '',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => '',
        'Link agents to roles.' => '',
        'Link attachments to responses templates.' => '',
        'Link customers to groups.' => '',
        'Link customers to services.' => '',
        'Link queues to auto responses.' => '',
        'Link responses to queues.' => '',
        'Link roles to groups.' => '',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => '',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => 'Çoklu Seçim',
        'My Tickets' => 'Biletlerim',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Yeni e-posta bileti',
        'New phone ticket' => 'Yeni telefon bileti',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'bildirim',
        'Number of displayed tickets' => 'Görünen Biletlerin sayısı',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => 'Müşteriye ait açık biletler',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Yükseltilmiş Biletlere Genel Bakış',
        'Overview Refresh Time' => 'Genel Bakış yenileme süresi',
        'Overview of all open Tickets.' => 'Tüm açık biletlere genel bakış.',
        'PGP Key Management' => '',
        'PGP Key Upload' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Kuyruk görünümü',
        'Refresh Overviews after' => 'Genel bakıştan sonra yenile',
        'Refresh interval' => 'Yenileme süresi',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Responses <-> Queues' => 'Yanıtlar <-> Kuyruk',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Roller <-> Gruplar',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Önyüz Temasını seçin.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '',
        'Send notifications to users.' => '',
        'Send ticket follow up notifications' => '',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the size of the statistic graph.' => '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'İstatistikler',
        'Status view' => 'Durum görünümü',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Bilet Genel Bakış',
        'Tickets' => 'Biletler',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => '',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => '',
        'View system log messages.' => '',
        'Wear this frontend skin' => '',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Favori kuyruklarınızın seçim kuyruğu. Bu kuyruklar hakkında da e-posta yoluyla (eğer açıksa) bildirim alırsınız.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        ' (work units)' => ' (iş birimi)',
        '%s Tickets affected! Do you really want to use this job?' => '%s Bilet etkilendi! Gerçekten bu işi kullanmak istiyor musunuz?',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' =>
            '(Kullanılan e-posta adreslerinin MX kayıtlarını bir cevap yazarak kontrol eder. Eğer OTRS sisteminiz çevirmeli bir ağın arkasındaysa kullanmayın!)',
        '(Email of the system admin)' => '(Sistem yöneticisinin e-posta adresi)',
        '(Full qualified domain name of your system)' => '(Sisteminizin eksiksiz sunucu adresi (FQDN))',
        '(Logfile just needed for File-LogModule!)' => '(Günlük dosyası sadece günlük bileşeni Dosya olduğunda gereklidir!)',
        '(Note: It depends on your installation how many dynamic objects you can use)' =>
            '(Not: Kaç dinamik nesne kullanabileceğiniz kurulumunuza bağlıdır)',
        '(Note: Useful for big databases and low performance server)' => '(Not: Büyük veritabanı ve düşük performanslı sunucularda kullanışlıdır)',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' =>
            '(Sistemin kimliği. Her bilet numarası ve her http oturum kimliği bu numarayla başlar)',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' =>
            '(Bilet tanımlayıcısı. \'Bilet#\', \'Arama#\' oder \'Biletim#\' gibi olabilir)',
        '(Used default language)' => '(Kullanılan öntanımlı dil)',
        '(Used log backend)' => '(Kullanılan günlük arkaucu)',
        '(Used ticket number format)' => '(Kullanılan bilet numarası biçimi)',
        'A article should have a title!' => 'Metnin bir başlığı olmalıdır!',
        'A message must be spell checked!' => 'Mesajın sözyazım kontrolünden geçmesi gereki!',
        'A message should have a To: recipient!' => 'Bir mesajın alıcısı olmalıdır!',
        'A message should have a body!' => 'Mesajın bir gövdesi olmalıdır!',
        'A message should have a subject!' => 'Bir mesajın bir konusu olmalıdır!',
        'A response is default text to write faster answer (with default text) to customers.' =>
            'Bir yanıt, müşterilere daha hızlı cevap yazabilmek için önceden hazırlanan metindir.',
        'Absolut Period' => 'Belirli Süre',
        'Add Customer User' => 'Müşteri Kullanıcı Ekle',
        'Add System Address' => 'Sistem Adresi Ekle',
        'Add User' => 'Kullanıcı Ekle',
        'Add a new Agent.' => 'Yeni bir Aracı ekle.',
        'Add a new Customer Company.' => 'Yeni bir Müşteri Şirket ekle.',
        'Add a new Group.' => 'Yeni bir Grup ekle.',
        'Add a new Notification.' => 'yeni bildirim ekle',
        'Add a new Priority.' => 'yeni bir öncelik ekle',
        'Add a new Role.' => 'Yeni bir Rol ekle.',
        'Add a new SLA.' => 'Yeni bir SLA ekle.',
        'Add a new Salutation.' => 'Yeni bir Selamlama ekle.',
        'Add a new Service.' => 'Yeni bir Servis ekle.',
        'Add a new Signature.' => 'Yeni bir İmza ekle.',
        'Add a new State.' => 'Yeni bir Durum ekle.',
        'Add a new System Address.' => 'Yeni bir Sistem Adresi ekle.',
        'Add a new Type.' => 'Yeni bir Tip ekle.',
        'Add a note to this ticket!' => 'Bu bilete bir not ekle!',
        'Add note to ticket' => 'Bilete not ekle',
        'Added User "%s"' => 'Kullanıcı "%s" eklendi.',
        'Admin-Area' => 'Yönetim Alanı',
        'Admin-Password' => 'Yönetici Parolası',
        'Admin-User' => 'Yönetici Kullanıcı',
        'Agent Mailbox' => 'Aracı Posta Kutusu',
        'Agent Preferences' => 'Aracı Tercihleri',
        'Agent based' => 'aracı bazlı',
        'Agent-Area' => 'Aracı Alanı',
        'All Agent variables.' => 'Tüm Aracı değişkenleri',
        'All Agents' => 'Tüm Aracılar',
        'All Customer variables like defined in config option CustomerUser.' =>
            'Müşteri Kullanıcı yapılandırma seçeneğinde tanımlandığı şekliyle tüm Müşteri değişkenleri.',
        'All customer tickets.' => 'Tüm müşteri biletleri.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' =>
            'Bu e-posta adresinden gelen tüm e-postalar seçili kuyruğa yönlendirilir.',
        'All messages' => 'Tüm mesajlar',
        'All new tickets!' => 'Tüm yeni biletler',
        'All tickets where the reminder date has reached!' => 'hatırlatma tarihi gelen tüm biletler',
        'Allocate CustomerUser to service' => 'MüşteriKullanıcıyı servise ata',
        'Allocate services to CustomerUser' => 'Servisleri MüşteriKullanıcıya ata',
        'Answer' => 'Cevapla',
        'Attach' => 'Ekle',
        'Attribute' => 'Nitelik',
        'Auto Response From' => 'Otomatik Yanıtlayan',
        'Bounce ticket' => 'Bileti ötele',
        'CSV' => 'CSV',
        'Can\'t update password, invalid characters!' => 'Parola güncellenemiyor, geçersiz karakterler var!',
        'Can\'t update password, must be at least %s characters!' => 'Parola güncellenemiyor, en az %s karakter girmelisiniz!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' =>
            'Parola güncellenemiyor, 2 küçük harf ve 2 büyük harf girmelisiniz!',
        'Can\'t update password, needs at least 1 digit!' => 'Parola güncellenemiyor, en az 1 sayı girmelisiniz!',
        'Can\'t update password, needs at least 2 characters!' => 'Parola güncellenemiyor, en az 2 karakter girmelisiniz!',
        'Can\'t update password, your new passwords do not match! Please try again!' =>
            'Parola güncellenemiyor, parolalar birbirleriyle uyuşmuyor! Lütfen tekrar deneyin!',
        'Category Tree' => 'Kategori Ağacı',
        'Cc: (%s) added database email!' => 'Karbon kopya: (%s) veritabanı elektronik postası eklendi!',
        'Change %s settings' => '%s ayarlarını değiştir',
        'Change Time' => 'Değişiklik Zamanı',
        'Change free text of ticket' => 'Biletin serbest metnini değiştir',
        'Change owner of ticket' => 'Biletin sahibini değiştir',
        'Change priority of ticket' => 'Biletin önceliğini değiştir',
        'Change responsible of ticket' => 'Biletin sorumlusunu değiştir',
        'Change the ticket customer!' => 'Bilet müşterisini değiştir!',
        'Change the ticket owner!' => 'Bilet sahibini değiştir!',
        'Change the ticket priority!' => 'Bilet önceliğini değiştir!',
        'Change user <-> group settings' => 'Kullanıcı <-> grup seçeneklerini değiştir',
        'ChangeLog' => 'Değişiklik Günlüğü',
        'Child-Object' => 'Alt Nesne',
        'Classification' => 'Sıralama',
        'Clear From' => 'Gönderen kısmını temizle',
        'Clear To' => 'Kime alanını temizle',
        'Click here to report a bug!' => 'Hata raporlamak için buraya tıklayın!',
        'Close this ticket!' => 'Bu bileti kapat!',
        'Close ticket' => 'Bileti kapat',
        'Close type' => 'Tipi kapat',
        'Close!' => 'Kapat!',
        'Comment (internal)' => 'Yorum (iç)',
        'Companies' => 'Şirketler',
        'CompanyTickets' => 'Şirket Biletleri',
        'Compose Answer' => 'Cevap yaz',
        'Compose Email' => 'E-Posta Yaz',
        'Compose Follow up' => 'Takip mesajı yaz',
        'Config Options' => 'Yapılandırma Seçenekleri',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Yapılandırma seçenekleri (örn. &lt;OTRS_CONFIG_HttpType&gt;)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Yapılandırma seçenekleri (örn. <OTRS_CONFIG_HttpType>)',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Yapılandırma seçenekleri (örneğin <OTRS_CONFIG_HttpType).',
        'Contact customer' => 'Müşteriyle bağlantı kur',
        'Create Times' => 'Oluşturma Zamanları',
        'Create new Phone Ticket' => 'Yeni Telefon Bileti oluştur',
        'Create new database' => 'Yeni veritabanı oluştur',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' =>
            'Farklı aracı gruplarının (örneğin satınalma bölümü, destek bölümü, satış bölümü, ...) erişim izinlerini düzenlemek için yeni grupları oluştur.',
        'CreateTicket' => 'Bilet Oluştur',
        'Current Impact Rating' => 'Şu Andaki Etki Oranı',
        'Customer Move Notify' => 'Müşteri Taşıma Bildirimi',
        'Customer Owner Notify' => 'Müşteri Sahip Bildirimi',
        'Customer State Notify' => 'Müşteri Durum Bildirimi',
        'Customer User Management' => 'Müşteri Kullanıcı Yönetimi',
        'Customer Users <-> Groups' => 'Müşteri Kullanıcılar <-> Gruplar',
        'Customer Users <-> Groups Management' => 'Müşteri Kullanıcılar <-> Grup Yönetimi',
        'Customer Users <-> Services' => 'Müşteri Kullanıcılar <-> Servisler',
        'Customer Users <-> Services Management' => 'Kullanıcı Müşteriler <-> Servis Yönetimi',
        'Customer history' => 'Müşteri tarihçesi',
        'Customer history search' => 'Müşteri tarihçe araması',
        'Customer history search (e. g. "ID342425").' => 'Müşteri tarihçe araması (örn. "ID342425").',
        'Customer user will be needed to have a customer history and to login via customer panel.' =>
            'Müşteri kullanıcı bir müşteri geçmişi ve müşteri panelinden oturum açmak için gereklidir.',
        'CustomerUser' => 'MüşteriKullanıcı',
        'D' => 'D',
        'DB Admin Password' => 'Veritabanı Yöneticisi Parolası',
        'DB Admin User' => 'Veritabanı Yöneticisi Kullanıcı',
        'DB connect host' => 'Veritabanına bağlanan sunucu',
        'Default' => 'Öntanımlı',
        'Default Charset' => 'Öntanımlı karakter kümesi',
        'Default Language' => 'Öntanımlı dil',
        'Delete old database' => 'Eski veritabanını sil',
        'Delete this ticket!' => 'Bu bileti sil!',
        'Detail' => 'Detay',
        'Diff' => 'Fark',
        'Discard all changes and return to the compose screen' => 'Tüm değişiklikleri geri al ve oluşturma ekranına geri dön',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' =>
            'Gelen elektronik postaları gönderme veya süzme işlemini elektronik postadaki X-Başlıklarına göre yap! Düzenli ifadeler (RegExp) de kullanılabilir.',
        'Do you really want to delete this Object?' => 'Gerçekten bu nesneyi silmek istiyor musunuz?',
        'Do you really want to reinstall this package (all manual changes get lost)?' =>
            'Gerçekten bu paketi yeniden yüklemek istiyor musunuz (elle yaptığınız tüm değişiklikler gider)?',
        'Don\'t forget to add a new response a queue!' => 'Yeni bir yanıtı bir kuyruğa eklemeyi unutmayın!',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Yeni kullanıcıları gruplara ve/veya rollere eklemeyi unutmayın!',
        'Don\'t forget to add a new user to groups!' => 'Yeni kullanıcıyı gruplara atamayı unutmayın!',
        'Don\'t work with UserID 1 (System account)! Create new users!' =>
            'Kullanıcı kimliği 1 (Sistem hesabı) ile çalışmayın! Yeni kullanıcılar oluşturun!',
        'Download Settings' => 'İndirme Ayarları',
        'Download all system config changes.' => 'Tüm sistem yapılandırma değişikliklerini indir.',
        'Drop Database' => 'Veritabanını Sil',
        'Dynamic-Object' => 'Dinamik Nesne',
        'Edit default services.' => 'Varsayılan servisleri belirle.',
        'Email based' => 'eposta bazlı',
        'Escalation - First Response Time' => 'Yükseltme - ilk Yanıt Zamanı',
        'Escalation - Solution Time' => 'Yükseltme - Çözümleme Zamanı',
        'Escalation - Update Time' => 'Yükseltme - Güncelleme Zamanı',
        'Escalation time' => 'Yükseltme zamanı',
        'Explanation' => 'Açıklama',
        'Export Config' => 'Yapılandırmayı Dışarı Aktar',
        'FAQ Search Result' => 'SSS Arama Sonucu',
        'FAQ System History' => 'SSS Sistemi Tarihçesi',
        'File-Name' => 'Dosya adı',
        'File-Path' => 'Dosya Yolu',
        'Filelist' => 'Dosya listesi',
        'Filtername' => 'Süzgeç adı',
        'Follow up' => 'Takip',
        'Follow up notification' => 'Takip bildirimi',
        'For very complex stats it is possible to include a hardcoded file.' =>
            'Çok karmaşık istatistikler söz konusu olduğunda önceden hazırlanmış bir dosyayı da dahil etmek mümkündür.',
        'Frontend' => 'Önyüz',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Mesajda tam metin araması (örneğin "Ay*egül" veya "Çak*r")',
        'Go' => 'Devam',
        'Group Ro' => 'Grup Ro',
        'Group based' => 'grup bazlı',
        'Group selection' => 'Grup seçimi',
        'Have a lot of fun!' => 'İyi eğlenceler!',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Burada değer serilerini seçebilirsiniz. Bir veya iki öğe seçebilirsiniz. Sonra öğelerin niteliklerini seçebilirsiniz. Her nitelik tek değer serileri olarak gösterilir. Eğer herhangi bir nitelik seçmeden istatistik oluşturursanız öğenin tüm nitelikleri kullanılır.  Son yapılandırmadan sonra yeni bir nitelik eklendiğinde de.',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' =>
            'Burada X eksenini belirleyebilirsiniz. Radyo düğmesiyle bir öğe seçebilirsiniz. Sonra öğenin iki veya daha fazla niteliğini seçmelisiniz. Herhangi bir seçim yapmadan bir istatistik oluşturursanız öğenin tüm nitelikleri kullanılır. Son yapılandırmadan sonra bir nitelik eklendiğinde de.',
        'Here you can insert a description of the stat.' => 'Buraya istatistiğe bir açıklama girebilirsiniz.',
        'Here you can select the dynamic object you want to use.' => 'Burada kullanmak istediğiniz dinamik nesneyi seçebilirsiniz.',
        'Home' => 'Ana sayfa',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' =>
            'Eğer önceden hazırlanmış bir dosya bulunursa bu nitelik gösterilir ve birini seçebilirsiniz.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' =>
            'Eğer bir bilet kapatılırsa ve ardından müşteri bir mesaj gönderirse, bilet eski sahibi için kilitlenir.',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' =>
            'Eğer bir bilet bu süre zarfında yanıtlanmazsa, sadece bu bilet gösterilir.',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' =>
            'Eğer bir aracı bir bileti kilitler ve bu sürede bir yanıt göndermezse, biletin kilidi otomatik olarak kaldırılır. Dolayısıyla bilet diğer tüm aracılara görünür hale gelir.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' =>
            'Eğer hiçbirşey seçilmemişse, bu grupta hiç izin yoktu (biletler kullanıcıya açık olmayacaktır).',
        'If you need the sum of every column select yes.' => 'Her sütunun toplanmasını istiyorsanız \'Evet\'i seçin.',
        'If you need the sum of every row select yes' => 'Her satırın toplanmasını istiyorsanız \'Evet\'i seçin',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' =>
            'Düzenli ifadeler (RegExp) kullanırsanız, \'Küme\' kısmında eşleşen değer için () yerine [***]da kullanabilirsiniz. ',
        'Image' => 'Resim',
        'Important' => 'Önemli',
        'Imported' => 'İçeri aktarıldı',
        'Imported by' => 'İçeri aktaran',
        'In this form you can select the basic specifications.' => 'Bu formda temel belirtimleri seçebilirsiniz.',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' =>
            'Bu şekilde Kernel/Config.pm dosyasında yapılandırılmış olan anahtar halkasını (keyring) değiştirebilirsiniz',
        'Information about the Stat' => 'İstatistik hakkında bilgi',
        'Insert of the common specifications' => 'Sadece ortak belirtimleri gir',
        'Instance' => 'Kopya',
        'Invalid SessionID!' => 'Geçersiz oturum kimliği!',
        'Is Job Valid' => 'İşin geçerli olup olmadığı',
        'Is Job Valid?' => 'İş geçerli mi?',
        'It\'s useful for ASP solutions.' => 'ASP çözümleri için kullanışlıdır.',
        'It\'s useful for a lot of users and groups.' => 'Çok sayıda kullanıcı ve grup için kullanışlıdır.',
        'Job-List' => 'İş Listesi',
        'Keyword' => 'Anahtar kelime',
        'Keywords' => 'Anahtar Kelimeler',
        'Last update' => 'Son güncelleme',
        'Link this ticket to an other objects!' => 'Bu bileti başka nesnelere bağla!',
        'Load' => 'Yükle',
        'Load Settings' => 'Ayarları Yükle',
        'Lock it to work on it!' => 'Üzerinde çalışmak için kilitle!',
        'Logfile' => 'Günlük dosyası',
        'Logfile too large, you need to reset it!' => 'Günlük dosyası çok büyük, boşaltmalısınız!',
        'Login failed! Your username or password was entered incorrectly.' =>
            'Oturum açılamadı! Kullanıcı adınız veya parolanız hatalı girildi.',
        'Lookup' => 'Ara',
        'Mail Management' => 'Posta Yönetimi',
        'Mailbox' => 'Posta kutusu',
        'Match' => 'Eşleşen',
        'Merge this ticket!' => 'Bu bileti birleştir!',
        'Message for new Owner' => 'Yeni Sahibine mesaj',
        'Message sent to' => 'Mesaj gönderildi',
        'Misc' => 'Çeşitli',
        'Modified' => 'Değiştirildi',
        'Modules' => 'Bileşenler',
        'Move notification' => 'Taşıma bildirimi',
        'Multiple selection of the output format.' => 'Çıktı biçimi için birden fazla seçim.',
        'My Queue' => 'Kuyruğun',
        'MyTickets' => 'Biletlerim',
        'Name is required!' => 'Ad gerekli!',
        'New Agent' => 'Yeni Aracı',
        'New Customer' => 'Yeni Müşteri',
        'New Group' => 'Yeni Grup',
        'New Group Ro' => 'Yeni Grup Ro',
        'New Priority' => 'Yeni Öncelik',
        'New State' => 'Yeni Durum',
        'New Ticket Lock' => 'Yeni Bilet Kilidi',
        'New TicketFreeFields' => 'Yeni BiletSerbestAlanları',
        'New account created. Sent Login-Account to %s.' => 'Yeni hesap acıldı. Giriş bilgileri %s adresine yollandı',
        'New messages' => 'Yeni mesajlar',
        'New password again' => 'Yeni parola (tekrar)',
        'No * possible!' => '"*" kullanılamaz!',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' =>
            'Bu Çevrimiçi Depoda İstenen versiyon için Paket bulunamadı, ama başka versiyonlar için var!',
        'No Packages or no new Packages in selected Online Repository!' =>
            'Seçili Çevrimiçi Depoda hiç Paket yok veya hiç yeni Paket yok!',
        'No Permission' => 'İzin yok',
        'No means, send agent and customer notifications on changes.' => 'Hayır, değişikliklerde aracılara ve müşterilere bildirim gönder demektir.',
        'No time settings.' => 'Zaman ayarı yok.',
        'Node-Address' => 'Düğüm Adresi',
        'Node-Name' => 'Düğüm Adı',
        'Note Text' => 'Not Metni',
        'Notification (Customer)' => 'Bildirim (müşteri)',
        'Notifications' => 'Bildirimler',
        'OTRS DB Password' => 'OTRS Veritabanı Parolası',
        'OTRS sends an notification email to the customer if the ticket is moved.' =>
            'Eğer bilet taşınırsa OTRS müşteriye bir bildirim e-postası gönderir.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' =>
            'Eğer bilet sahibi değişirse OTRS müşteriye bir bildirim e-postası gönderir.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' =>
            'Eğer bilet durumu değişirse OTRS müşteriye bir bildirim e-postası gönderir.',
        'Of couse this feature will take some system performance it self!' =>
            'Elbette bu özellik sistem performansından biraz alır.',
        'Open Tickets' => 'Açık Biletler',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' =>
            'Muşteri kullanıcı verisi seçenekleri (örn. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' =>
            'Mevcut müşteri kullanıcı verileri (örn. <OTRS_CUSTOMER_DATA_UserFirstname>) seçenekleri',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' =>
            'Mevcut müşteri kullanıcı verisi seçenekleri (örneğin <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' =>
            'Bu eylemi isteyen kulanıcının (örn. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;) seçenekleri',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' =>
            'Bu eylem için istekte bulunan kullanıcının seçenekleri (örn. <OTRS_CURRENT_UserFirstname>)',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' =>
            'Bu eyleme isteyen etkin kullanıcı seçenekleri (örneğin <OTRS_CURRENT_UserFirstname).',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' =>
            'Bilet verisinin seçenekleri (örn. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Bilet verisi seçenekleri (örn. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' =>
            'Bilet verisi seçenekleri (örn. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' =>
            'Bilet verisi seçenekleri (örneğin <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Other Options' => 'Diğer Seçenekler',
        'POP3 Account Management' => 'POP3 Hesap Yönetimi',
        'Package' => 'Paket',
        'Package not correctly deployed! You should reinstall the Package again!' =>
            'Paket doğru şekilde yüklenmedi! Paketi yeniden yükleyin!',
        'Param 1' => 'Param 1',
        'Param 2' => 'Param 2',
        'Param 3' => 'Param 3',
        'Param 4' => 'Param 4',
        'Param 5' => 'Param 5',
        'Param 6' => 'Param 6',
        'Parent-Object' => 'Ebeveyn Nesne',
        'Password is already in use! Please use an other password!' => 'Parola kullanımda! Lütfen başka bir parola seçiniz!',
        'Password is already used! Please use an other password!' => 'Parola  daha önce kullanıldı! Lütfen başka bir parola seçiniz!',
        'Passwords doesn\'t match! Please try it again!' => 'Parolalar uyuşmuyor! Lütfen tekrar deneyin!',
        'Pending Times' => 'Bekleme Zamanları',
        'Pending messages' => 'Bekleyen mesajlar',
        'Pending type' => 'Bekleme tipi',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' =>
            'İzin ayarları. Ayarlanan istatistiğin farklı aracılara görünür olması için bir veya daha fazla grup seçebilirsiniz.',
        'Permissions to change the ticket owner in this group/queue.' => 'Bu grupta/kuyrukta bilet sahibini değiştirme izni.',
        'PhoneView' => 'Telefon Görünüşü',
        'Please contact your admin' => 'Lütfen yöneticiyle iletişime geçin',
        'Print this ticket!' => 'Bu bileti yazdır!',
        'Prio' => 'Öncelik',
        'Process-Path' => 'İşlem Yolu',
        'Product' => 'Ürün',
        'Queue <-> Auto Responses Management' => 'Kuyruk <-> Otomatik Yanıt Yönetimi',
        'Queue Management' => 'Kuyruk Yönetimi',
        'Queues <-> Auto Responses' => 'Kuyruk <-> Otomatik Yanıtlar',
        'Realname' => 'Gerçek ad',
        'Rebuild' => 'Yeniden İnşa Et',
        'Recipients' => 'Alıcılar',
        'Reminder' => 'Hatırlatıcı',
        'Reminder messages' => 'Hatırlatıcı mesajlar',
        'Reporter' => 'Bildiren',
        'Required Field' => 'Gerekli alan',
        'Response Management' => 'Yanıt Yönetimi',
        'Responses <-> Attachments Management' => 'Yanıtlar <-> Ekler Yönetimi',
        'Responses <-> Queue Management' => 'Yanıtlar <-> Kuyruk Yönetimi',
        'Return to the compose screen' => 'Oluşturma ekranına geri dön',
        'Role' => 'Rol',
        'Roles <-> Groups Management' => 'Roller <-> Gruplar Yönetimi',
        'Roles <-> Users' => 'Roller <-> Kullanıcılar',
        'Roles <-> Users Management' => 'Roller <-> Kullanıcılar Yönetimi',
        'Save Job as?' => 'İşi ne olarak kaydedeyim?',
        'Save Search-Profile as Template?' => 'Arama Profili Şablon olarak kaydedilsin mi?',
        'Schedule' => 'Takvim',
        'Search Result' => 'Arama Sonuç',
        'Search for' => 'Ara',
        'Select Box' => 'Seçim Kutusu',
        'Select Box Result' => 'Seçin Kutusu Sonucu',
        'Select Source (for add)' => 'Kaynağı Seçin (eklemek için)',
        'Select the customeruser:service relations.' => 'Müşterikullanıcı:servis ilişkilerini belirle.',
        'Select the element, which will be used at the X-axis' => 'X-ekseni olarak kullanılacak öğeyi seçin.',
        'Select the restrictions to characterise the stat' => 'İstatistiği kişiselleştirmek için kısıtlamaları seçin',
        'Select the role:user relations.' => 'Rol:kullanıcı ilişkilerini seçin.',
        'Select the user:group permissions.' => 'Kullanıcı:grup izinlerini değiştir.',
        'Select your QueueView refresh time.' => 'Kuyruk Görünümü tazeleme sıklığını seçin.',
        'Select your default spelling dictionary.' => 'Öntanımlı sözdizim sözlüğünüzü seçin.',
        'Select your frontend Charset.' => 'Önyüz Karakter Kümesini seçin.',
        'Select your frontend QueueView.' => 'Önyüz Kuyruk Görünümünüzü seçin.',
        'Select your frontend language.' => 'Önyüz Dilini seçin.',
        'Select your screen after creating a new ticket.' => 'Yeni bir bilet oluşturduktan sonra görmek istediğiniz ekranı seçin.',
        'Selection needed' => 'Seçim gerekli',
        'Send Notification' => 'Bildirim Gönder',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' =>
            'Eğer bu biletin sahibi bensem ve bir müşteri takip eden mesaj gönderirse bana bildirim gönder.',
        'Send no notifications' => 'Bildirim gönderme',
        'Sent new password to: %s' => 'yeni parola %s e gönderildi',
        'Sent password token to: %s' => 'parola simgesi %s e gönderildi',
        'Service-Name' => 'Servis Adı',
        'Sessions' => 'Oturumlar',
        'Set customer user and customer id of a ticket' => 'Bir biletin müşteri kullanıcısını ve müşteri kimliğini belirle',
        'Set this ticket to pending!' => 'Bu bileti beklemeye al!',
        'Show' => 'Göster',
        'Shows the ticket history!' => 'Bilet geçmişini gösterir!',
        'Site' => 'Site',
        'Solution' => 'Çözüm',
        'Sort by' => 'Şuna göre sırala:',
        'Source' => 'Kaynak',
        'Spell Check' => 'Sözdizim Kontrolü',
        'Split' => 'Ayır',
        'State Type' => 'Durum Tipi',
        'Static-File' => 'Sabit Dosya',
        'Stats-Area' => 'İstatistikler Alanı',
        'Sub-Queue of' => 'Şunun Alt Kuyruğu:',
        'Sub-Service of' => 'Şunun Alt Servisi:',
        'Subscribe' => 'Abone ol',
        'System State Management' => 'Sistem Durumu Yönetimi',
        'System Status' => 'Sistem Durumu',
        'Systemaddress' => 'Sistem adresi',
        'Take care that you also updated the default states in you Kernel/Config.pm!' =>
            'Kernel/Config.pm içindeki öntanımlı durumları da değiştirdiğinizi unutmayın',
        'The message being composed has been closed.  Exiting.' => 'Oluşturulan mesaj kapatıldı. Çıkılıyor.',
        'These values are read-only.' => 'Bu değerler salt-okunurdur.',
        'These values are required.' => 'Bu değerler gereklidir.',
        'This account exists' => 'Bu hesap zaten var',
        'This account exists.' => 'bu hesap mevcut',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' =>
            'Eğer istatistik sonuçlarının kimseye açık olmamasını veya istatistiğin yapılandırılmamış olmamasını istiyorsanız bu seçenek kullanışlıdır.',
        'This window must be called from compose window' => 'Bu pencere \'yeni mesaj\' penceresinden açılmalıdır',
        'Ticket Information' => 'Bilet Bilgileri',
        'Ticket Lock' => 'Bilet Kilidi',
        'Ticket Number Generator' => 'Bilet Numarası Üreteci',
        'Ticket Search' => 'Bilet ara',
        'Ticket Status View' => 'Bilet Durumu Görünümü',
        'Ticket escalation!' => 'Bilet Yükseltme!',
        'Ticket locked!' => 'Bilet kilitlendi!',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' =>
            'Bilet sahibi seçenekleri (örn. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Bilet sahibi seçenekleri (örn. <OTRS_OWNER_UserFirstname>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Bilet sahibi seçenekleri (örneğin <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' =>
            'Bilet sorumlusu seçenekleri (örneğin <OTRS_RESPONSIBLE_UserFirstname>).',
        'Ticket selected for bulk action!' => 'Bilet toplu işlem için seçildi',
        'Ticket unlock!' => 'Biletin kilidi açıldı!',
        'Ticket-Area' => 'Bilet Alanı',
        'TicketFreeFields' => 'BiletSerbestAlanları',
        'TicketFreeText' => 'BiletSerbestMetni',
        'TicketZoom' => 'Bilet Detayları',
        'Tickets available' => 'Uygun biletler',
        'Tickets shown' => 'Gösterilen biletler',
        'Tickets which need to be answered!' => 'cevap bekleyen biletler',
        'Timeover' => 'Süre bitimi',
        'Times' => 'Zaman',
        'Title of the stat.' => 'İstatistiğin başlığı.',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' =>
            'Yazı niteliklerini al (örneğin (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> ve <OTRS_CUSTOMER_Body>).',
        'To: (%s) replaced with database email!' => 'Kime: (%s) veritabanı elektronik postasıyla değiştirildi!',
        'Top of Page' => 'Yukarı',
        'Total hits' => 'Toplam isabet',
        'U' => 'U',
        'Unable to parse Online Repository index document!' => 'Çevrimiçi Depo endeks belgesi ayrıştırılamadı!',
        'Uniq' => 'Tekil',
        'Unlock Tickets' => 'Biletlerin kilidini aç',
        'Unlock to give it back to the queue!' => 'Kilidini kaldır ve kuyruğa geri ver!',
        'Unsubscribe' => 'Abonelikten çık',
        'Use utf-8 it your database supports it!' => 'Eğer veritabanınız destekliyorsa utf-8 kullanın!',
        'Useable options' => 'Kullanılabilir seçenekler',
        'User Management' => 'Kullanıcı Yönetimi',
        'User will be needed to handle tickets.' => 'Biletlerle ilgilenmek için kullanıcı gerekir.',
        'User-Name' => 'Kullanıcı Adı',
        'User-Number' => 'Kullanıcı Numarası',
        'Users' => 'Kullanıcılar',
        'Users <-> Groups' => 'Kullanıcılar <-> Gruplar',
        'Users <-> Groups Management' => 'Kullanıcılar <-> Gruplar Yönetimi',
        'Warning! This tickets will be removed from the database! This tickets are lost!' =>
            'Uyarı! Bu biletler veritabanından silinecek! Geri dönüşü yoktur!',
        'Web-Installer' => 'Webden Yükleme',
        'Welcome to OTRS' => 'OTRS\'ye hoşgeldiniz',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Geçersiz bir istatistikle, istatistik oluşturmak mümkün olmaz.',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' =>
            'Giriş ve seçme alanlarıyla istatistiği istediğiniz gibi ayarlayabilirsiniz. İstatistiğin hangi öğelerini değiştrebileceğiniz istatistiği ayarlayan istatistik yöneticisine bağlıdır',
        'Workflow Groups' => 'Çalışma akışı Grupları',
        'Yes means, send no agent and customer notifications on changes.' =>
            'Evet, değişiklik durumunda aracılar ve müşterilere bildirim gönderme demektir.',
        'Yes, save it with name' => 'Evet, şu adla kaydet',
        'You got new message!' => 'Yeni mesajınız var!',
        'You have to select two or more attributes from the select field!' =>
            'Seçim alanından iki veya daha fazla nitelik seçmelisiniz!',
        'You need a email address (e. g. customer@example.com) in To:!' =>
            'Kime kısmında bir e-posta adresi (örn. musteri@ornek.com) olmalıdır!',
        'You need min. one selected Ticket!' => 'En az bir Bilet seçili olmalıdır!',
        'You need to account time!' => 'Zamanı hesaba katmalısınız!',
        'You need to activate %s first to use it!' => 'Kullanabilmek için %s önce etkinleştirin!',
        'You use the DELETE option! Take care, all deleted Tickets are lost!!!' =>
            'SİL seçeneğini kullandınız! Silinen Biletlerin kurtarılamayacağını unutmayın!!!',
        'Your email address is new' => 'E-posta adresiniz yeni',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '"<OTRS_TICKET>" bilet numaralı e-postanız "<OTRS_BOUNCE_TO>" adresine gönderildi. Daha fazla bilgi için bu adresle bağlantıya geçin.',
        'Your language' => 'Diliniz',
        'Your own Ticket' => 'Kendi Biletiniz',
        'customer realname' => 'müşterinin gerçek adı',
        'down' => 'aşağı',
        'false' => 'false',
        'for agent firstname' => 'aracı adı için',
        'for agent lastname' => 'aracı soyadı için',
        'for agent login' => 'aracı oturumu için',
        'for agent user id' => 'aracı kullanıcı kimliği için',
        'kill all sessions' => 'tüm oturumları sonlandır',
        'kill session' => 'oturumu öldür',
        'modified' => 'değiştirilmiş',
        'new ticket' => 'yeni bilet',
        'next step' => 'sonraki adım',
        'not rated' => 'puan verilmedi',
        'not verified' => 'onaylanmadı',
        'read' => 'okunmuş',
        'send' => 'gönder',
        'sort downward' => 'aşağıya doğru sırala',
        'sort upward' => 'yukarı doğru sırala',
        'tmp_lock' => 'geçici kilit',
        'to get the first 20 character of the subject' => 'konunun ilk 20 karakterini almak için',
        'to get the first 5 lines of the email' => 'e-postanın ilk beş satırını almak için',
        'to get the from line of the email' => 'e-postanın \'kime\' alanını almak için',
        'to get the realname of the sender (if given)' => 'göndericinin gerçek adını (eğer verilmişse) almak için',
        'unknown' => 'bilinmiyor',
        'unread' => 'okunmadı',
        'up' => 'yukarı',
        'verified' => 'onaylandı',
        'x' => 'x',
        'your MySQL DB should have a root password! Default is empty!' =>
            'MySQL veritabanınızın root kullanıcısının bir parolası olmalıdır. Öntanımlı olarak boştur!',

    };
    # $$STOP$$
    return;
}

1;
