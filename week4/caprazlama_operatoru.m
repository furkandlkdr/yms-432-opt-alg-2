function [cocuk1, cocuk2] = caprazlama_operatoru(ebeveyn1, ebeveyn2)
% İndeks tutarlılığı ile tek nokta veya iki nokta çaprazlama uygular.

genSayisi = numel(ebeveyn1);

if genSayisi < 2
    cocuk1 = ebeveyn1;
    cocuk2 = ebeveyn2;
    return;
end

if genSayisi < 3 || rand < 0.5
    % Tek nokta çaprazlama
    caprazlamaNoktasi = randi([1, genSayisi - 1]);
    cocuk1 = [ebeveyn1(1:caprazlamaNoktasi), ebeveyn2(caprazlamaNoktasi + 1:end)];
    cocuk2 = [ebeveyn2(1:caprazlamaNoktasi), ebeveyn1(caprazlamaNoktasi + 1:end)];
else
    % İki nokta çaprazlama
    caprazlamaNoktalari = sort(randperm(genSayisi - 1, 2));
    nokta1 = caprazlamaNoktalari(1);
    nokta2 = caprazlamaNoktalari(2);
    cocuk1 = [ebeveyn1(1:nokta1), ebeveyn2(nokta1 + 1:nokta2), ebeveyn1(nokta2 + 1:end)];
    cocuk2 = [ebeveyn2(1:nokta1), ebeveyn1(nokta1 + 1:nokta2), ebeveyn2(nokta2 + 1:end)];
end

end
