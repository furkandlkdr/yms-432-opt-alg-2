function[] = populasyon_olustur()

global sinir_alt sinir_ust n m populasyon

    for i=1:n
        populasyon(i,:) = sort(unifrnd(sinir_alt, sinir_ust, 1,m));
    end
end