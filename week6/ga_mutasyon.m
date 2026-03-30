function kromozom = ga_mutasyon(kromozom, mutasyon_olasiligi, mutasyon_sigma, kural_gen_baslangic)

% Surekli genler icin Gauss mutasyonu
for i = 1:kural_gen_baslangic-1
    if rand < mutasyon_olasiligi
        kromozom(i) = kromozom(i) + mutasyon_sigma * randn;
    end
end

% Kural cikis genleri icin rasgele sinif atamasi
for i = kural_gen_baslangic:numel(kromozom)
    if rand < mutasyon_olasiligi
        kromozom(i) = randi([1, 3]);
    end
end

end
