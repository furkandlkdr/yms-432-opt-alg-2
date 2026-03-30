% CFTR veri seti yuklemesi
% CSV dosyasini tablo olarak yukle ve array'e cevir
data_cftr=table2array(CFTRSartnameUyumluOriginalCount);

% Veri seti ornekleme fonksiyonunu cagir
% (egitim, egitim etiketleri, test, test etiketleri)
[Egitim, Egitimc, Test, Testc] = orneklem(data_cftr);