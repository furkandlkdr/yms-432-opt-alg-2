function mutasyonaUgramis = mutasyon_operatoru(kromozom)
% Her gen için global mutasyon oranı ile bit çevirme mutasyonu uygular.

global mutasyonOrani

mutasyonMaskesi = rand(size(kromozom)) < mutasyonOrani;
mutasyonaUgramis = double(xor(logical(kromozom), mutasyonMaskesi));

end
