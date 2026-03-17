function mse = uygunluk_fonksiyonu(kromozom)
% Seçilen özelliklerle lineer regresyon eğitir ve test MSE döndürür.

global XEgitim yEgitim XTest yTest

secili = logical(kromozom);
if ~any(secili)
    mse = 1e6;
    return;
end

XEgitimSecili = XEgitim(:, secili);
XTestSecili = XTest(:, secili);

XEgitimArtirilmis = [ones(size(XEgitimSecili, 1), 1), XEgitimSecili];
XTestArtirilmis = [ones(size(XTestSecili, 1), 1), XTestSecili];

% Doğrusal bağımlılık durumunda sayısal kararlılık için küçük ridge terimi.
ridgeKatsayisi = 1e-6;
gramMatrisi = XEgitimArtirilmis' * XEgitimArtirilmis;
sagTaraf = XEgitimArtirilmis' * yEgitim;
katsayilar = (gramMatrisi + ridgeKatsayisi * eye(size(gramMatrisi))) \ sagTaraf;
yTahmin = XTestArtirilmis * katsayilar;

% Etiket tutarlılığı için tahminleri [0,1] aralığında tut.
yTahmin = min(max(yTahmin, 0), 1);

hata = yTest - yTahmin;
mse = mean(hata .^ 2);

if ~isfinite(mse)
    mse = 1e6;
end

end
