function [cocuk1, cocuk2] = ga_caprazlama(ebeveyn1, ebeveyn2, caprazlama_olasiligi, kural_gen_baslangic)

cocuk1 = ebeveyn1;
cocuk2 = ebeveyn2;

if rand >= caprazlama_olasiligi
    return;
end

% Surekli genlerde aritmetik caprazlama
alpha = rand;
cocuk1(1:kural_gen_baslangic-1) = alpha * ebeveyn1(1:kural_gen_baslangic-1) + (1 - alpha) * ebeveyn2(1:kural_gen_baslangic-1);
cocuk2(1:kural_gen_baslangic-1) = alpha * ebeveyn2(1:kural_gen_baslangic-1) + (1 - alpha) * ebeveyn1(1:kural_gen_baslangic-1);

% Kural genlerinde uniform caprazlama
maske = rand(1, numel(ebeveyn1) - kural_gen_baslangic + 1) > 0.5;
kural1 = ebeveyn1(kural_gen_baslangic:end);
kural2 = ebeveyn2(kural_gen_baslangic:end);

gecici = kural1;
gecici(maske) = kural2(maske);
kural2(maske) = kural1(maske);
kural1 = gecici;

cocuk1(kural_gen_baslangic:end) = kural1;
cocuk2(kural_gen_baslangic:end) = kural2;

end
