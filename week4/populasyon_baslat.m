function populasyon = populasyon_baslat
% Rastgele ikili popülasyon üretir; boş kromozomları engeller.

global populasyonBoyutu ozellikSayisi

populasyon = double(rand(populasyonBoyutu, ozellikSayisi) > 0.5);

bosSatirlar = find(sum(populasyon, 2) == 0);
for i = 1:numel(bosSatirlar)
    populasyon(bosSatirlar(i), randi(ozellikSayisi)) = 1;
end

end
