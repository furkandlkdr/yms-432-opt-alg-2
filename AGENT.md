# AGENT.md

Bu depo icin kalici calisma kurallari ve istem (prompt) metni.
Bu dosya, benzer istekleri tekrar tekrar yazmadan ayni stilde cikti almak icin kullanilir.

## Amac
- Bu depoda, kullanicinin istedigi projeleri ayni yazim dili ve ayni kodlama uslubuyla uret.
- Ozellikle `week3` ve `week4` klasorlerinde kullanilan stile sadik kal.
- Bu dosyadaki prompt, duzenleme degil sifirdan proje gelistirme odaginda kullanilsin.

## Zorunlu Stil Kurallari
- Programlama dili MATLAB olarak kalacak, farkli dile gecilmeyecek.
- Kodlar mumkun oldugunca bir ana script + ayri fonksiyon dosyalari yapisinda yazilacak.
- Fonksiyon adlari Turkce anlamli olacak ama Turkce karakter icermeyecek.
- Fonksiyon dosya adi ile fonksiyon adi birebir ayni olacak.
- Aciklayici yorum satirlari Turkce yazilacak ve yorumlarda Turkce karakter kullanilacak.
- Gereken ortak degiskenler `global` ile paylastirilacak.
- Mevcut dosya ve degisken adlandirma stiline uyum korunacak.
- Gereksiz buyuk mimari degisiklik yapma; isteneni minimum ama temiz degisiklikle tamamla.

## Is Akisi Kurallari
1. Once problem tanimini ve hedef ciktilari netlestir.
2. Cozumu ana script + ayri fonksiyon dosyalari mimarisinde sifirdan tasarla.
3. Algoritmanin adimlarini net yorumlarla acikla ve moduler fonksiyonlara bol.
4. Fonksiyon adlarini Turkce anlamli (ASCII) sec; dosya/fonksiyon adini birebir eslestir.
5. Ortak kullanilan degiskenleri gerekli oldugu yerde global tanimla ve tum ilgili dosyalarda tutarli kullan.
6. Sonucta calisan bir proje teslim et: veri hazirlama, algoritma calisma akisi, sonuc raporlama/gorsellestirme.
7. Hata kontrolu yap, varsa duzelt, en sonda degisiklik ve calistirma ozetini ver.

## Gelistirici Icin Hazir Prompt
Asagidaki metni dogrudan kullan (duzenleyici degil, sifirdan gelistirici odagi):

"Bu repoda sifirdan yeni bir MATLAB projesi gelistir.
Kodu `week3` ve `week4` klasorlerindeki stile uygun yaz.
MATLAB dili disina cikma.
Kodlari ana script + ayri fonksiyon dosyalari olarak duzenle.
Fonksiyon adlarini Turkce anlamli ama Turkce karakter olmadan ver.
Yorum satirlarini Turkce karakterlerle yaz.
Gereken degiskenleri global olarak paylastir.
Sifirdan gelistirdigin icin tam bir calisma akisi kur: veri hazirlama, algoritma adimlari, sonuc uretimi.
Buyuk ama gereksiz mimari karmasa kurma; sade, okunabilir ve genisletilebilir yapi kur.
Dosya/fonksiyon isim eslesmesine dikkat et.
Teslimden once hata kontrolu yap, hatalari gider, en sonda ne yaptigini ve nasil calistirilacagini ozetle."

## Kisa Prompt Surumu
"Week3-Week4 stilinde, MATLAB ile sifirdan proje gelistir.
Ana script + ayri fonksiyon dosyalari kullan.
Fonksiyon adlari Turkce anlamli ve ASCII olsun.
Yorumlar Turkce karakterli olsun.
Gerekli degiskenleri global paylastir.
Cozumu calisir halde teslim et, hata kontrolu ve ozet ekle."

## Hizli Kontrol Listesi
- [ ] MATLAB disina cikilmadi.
- [ ] Ana script ve fonksiyon dosyalari ayrildi.
- [ ] Fonksiyon isimleri Turkce ama ASCII.
- [ ] Yorumlar Turkce karakterli.
- [ ] Global degiskenler gereken yerde tanimli.
- [ ] Dosya adi = fonksiyon adi.
- [ ] Hata kontrolu yapildi.
