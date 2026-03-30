function [uygunluk, fis, kural_listesi, tahmin] = ga_uygunluk_hesapla(kromozom, sabit_kural_onculleri)

global GA_VERI_GIRIS GA_VERI_CIKIS

[fis, kural_listesi] = ga_fis_olustur(kromozom, sabit_kural_onculleri);
tahmin = evalfis(fis, GA_VERI_GIRIS);

% Uygunluk metrigini MAE olarak tanimliyoruz (kucuk daha iyi)
hata = abs(GA_VERI_CIKIS - tahmin);
uygunluk = mean(hata);

end
