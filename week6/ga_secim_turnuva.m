function secilen_indis = ga_secim_turnuva(uygunluk, turnuva_boyutu)

populasyon_boyutu = numel(uygunluk);
adaylar = randperm(populasyon_boyutu, turnuva_boyutu);

[~, yerel_en_iyi] = min(uygunluk(adaylar));
secilen_indis = adaylar(yerel_en_iyi);

end
