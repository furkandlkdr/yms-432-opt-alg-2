function mseDegerleri = populasyonu_degerlendir
% Popülasyondaki her kromozom için test MSE değerini hesaplar.

global populasyon

populasyonBoyutu = size(populasyon, 1);
mseDegerleri = zeros(populasyonBoyutu, 1);

for i = 1:populasyonBoyutu
    mseDegerleri(i) = uygunluk_fonksiyonu(populasyon(i, :));
end

end
