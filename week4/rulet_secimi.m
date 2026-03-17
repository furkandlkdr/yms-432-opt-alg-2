function indeks = rulet_secimi
% Rulet tekeri olasılıklarına göre bir indeks seçer.

global secimOlasiliklari

birikimliOlasilik = cumsum(secimOlasiliklari(:));
rastgeleDeger = rand;
indeks = find(birikimliOlasilik >= rastgeleDeger, 1, 'first');
if isempty(indeks)
    indeks = numel(secimOlasiliklari);
end

end
