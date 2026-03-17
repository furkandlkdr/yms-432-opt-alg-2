function [en_iyi_antikorun, en_iyi_afinite, afinite_gecmisi] = clonalg_algoritma(X_train, y_train, model_tipi, pop_buyut, n_secilecek, beta, rho, d, max_iterasyon)
    % CLONALG (Klonlama Seçilimi Algoritması) Ana Fonksiyonu
    % Giriş:
    %   X_train: Eğitim verisi (N x D)
    %   y_train: Eğitim etiketleri (N x 1)
    %   model_tipi: 'svm', 'rf', 'mlp'
    %   pop_buyut: Popülasyon büyüklüğü (varsayılan 50)
    %   n_secilecek: Seçilecek antikor sayısı (varsayılan 20)
    %   beta: Klon çarpanı (varsayılan 1.0)
    %   rho: Mutasyon sabiti (varsayılan 2.0)
    %   d: Her iterasyonda değiştirilecek antikor sayısı (varsayılan 10)
    %   max_iterasyon: Maksimum iterasyon sayısı (varsayılan 50)
    % Çıkış:
    %   en_iyi_antikorun: En iyi bulunmuş hiperparametre seti
    %   en_iyi_afinite: En iyi afinite değeri
    %   afinite_gecmisi: Her iterasyondaki en iyi afinite değerleri
    
    % Varsayılan parametreler
    if nargin < 4
        pop_buyut = 50;
        n_secilecek = 20;
        beta = 1.0;
        rho = 2.0;
        d = 10;
        max_iterasyon = 50;
    end
    
    % Popülasyonu başlat
    populasyon = olustur_populasyon(pop_buyut, model_tipi);
    
    % Afinite gecmisi
    afinite_gecmisi = zeros(max_iterasyon, 1);
    en_iyi_afinite = -inf;
    en_iyi_antikorun = populasyon(1);
    
    fprintf('\n=== CLONALG ALGORİTMASI BAŞLADI ===\n');
    fprintf('Model: %s | Popülasyon: %d | İterasyon: %d\n\n', model_tipi, pop_buyut, max_iterasyon);
    
    % Ana iterasyon döngüsü
    for iterasyon = 1:max_iterasyon
        % Tum antikorlarin afiniteleri hesapla
        afiniteler = zeros(pop_buyut, 1);
        for i = 1:pop_buyut
            afiniteler(i) = hesapla_afinite(populasyon(i), X_train, y_train, model_tipi);
        end
        
        % En iyi antikorlari seç
        [~, strain_indeksleri] = sort(afiniteler, 'descend');
        en_iyi_indeks = strain_indeksleri(1:n_secilecek);
        en_iyi_antikorlar = populasyon(en_iyi_indeks);
        en_iyi_afiniteler = afiniteler(en_iyi_indeks);
        
        % En iyi antikoru kaydet
        if en_iyi_afiniteler(1) > en_iyi_afinite
            en_iyi_afinite = en_iyi_afiniteler(1);
            en_iyi_antikorun = en_iyi_antikorlar(1);
        end
        
        % Klonlama
        klonlar = uygula_klonlama(en_iyi_antikorlar, en_iyi_afiniteler, beta);
        klon_sayisi = length(klonlar);
        
        % Klonların afiniteleri hesapla
        klon_afiniteler = zeros(klon_sayisi, 1);
        for i = 1:klon_sayisi
            klon_afiniteler(i) = hesapla_afinite(klonlar(i), X_train, y_train, model_tipi);
        end
        
        % Somatik hipermutasyon
        mutantlar = uygula_hipermutasyon(klonlar, klon_afiniteler, model_tipi, rho);
        
        % Mutantların afiniteleri hesapla
        mutant_afiniteler = zeros(klon_sayisi, 1);
        for i = 1:klon_sayisi
            mutant_afiniteler(i) = hesapla_afinite(mutantlar(i), X_train, y_train, model_tipi);
        end
        
        % Popülasyonu güncelle: Mevcut + Mutantlar, en iyilerini seç
        tum_populasyon = [populasyon; mutantlar];
        tum_afiniteler = [afiniteler; mutant_afiniteler];
        
        [~, en_iyi_inds] = sort(tum_afiniteler, 'descend');
        secilen_inds = en_iyi_inds(1:pop_buyut);
        populasyon = tum_populasyon(secilen_inds);
        
        % Çeşitlilik koruma: En kötü d antikorun yerini rastgele antikorlarla değiştir
        tum_afiniteler_guncel = tum_afiniteler(secilen_inds);
        [~, en_kotu_inds] = sort(tum_afiniteler_guncel, 'ascend');
        degistirilecek_inds = en_kotu_inds(1:min(d, pop_buyut));
        
        for idx = degistirilecek_inds
            populasyon(idx) = olustur_populasyon(1, model_tipi);
        end
        
        % Gecmişe kaydet
        afinite_gecmisi(iterasyon) = en_iyi_afinite;
        
        % Durum bilgisi yazdır
        if mod(iterasyon, 10) == 0 || iterasyon == 1
            fprintf('İterasyon %3d: En İyi Afinite = %.4f\n', iterasyon, en_iyi_afinite);
        end
    end
    
    fprintf('\n=== ALGORİTMA TAMAMLANDI ===\n');
    fprintf('En İyi Afinite: %.4f\n', en_iyi_afinite);
    
end

function populasyon = olustur_populasyon(n, model_tipi)
    % Rastgele hiperparametre popülasyonu oluştur
    % Struct array dizisi döndürür
    
    % Struct array oluştur
    populasyon = repmat(struct(...
        'BoxConstraint', 0, ...
        'KernelFunction', '', ...
        'KernelScale', 0, ...
        'NumTrees', 0, ...
        'MinLeafSize', 0, ...
        'LayerSizes', 0, ...
        'Activation', '', ...
        'InitialLearnRate', 0), n, 1);
    
    if strcmpi(model_tipi, 'svm')
        % SVM parametrelerini rastgele oluştur
        for i = 1:n
            % BoxConstraint: log uzayda
            log_c = log(0.01) + (log(100) - log(0.01)) * rand();
            populasyon(i).BoxConstraint = exp(log_c);
            
            % KernelFunction: Kategorik
            kernels = {'linear', 'rbf', 'polynomial'};
            populasyon(i).KernelFunction = kernels{randi(3)};
            
            % KernelScale: Sürekli
            log_gamma = log(0.001) + (log(10) - log(0.001)) * rand();
            populasyon(i).KernelScale = exp(log_gamma);
        end
        
    elseif strcmpi(model_tipi, 'rf')
        % RF parametrelerini rastgele oluştur
        for i = 1:n
            populasyon(i).NumTrees = round(10 + (200 - 10) * rand());
            populasyon(i).MinLeafSize = round(1 + (20 - 1) * rand());
        end
        
    elseif strcmpi(model_tipi, 'mlp')
        % MLP parametrelerini rastgele oluştur
        for i = 1:n
            populasyon(i).LayerSizes = round(10 + (100 - 10) * rand());
            
            activations = {'relu', 'tanh', 'sigmoid'};
            populasyon(i).Activation = activations{randi(3)};
            
            % InitialLearnRate: log uzayda
            log_lr = log(0.0001) + (log(0.1) - log(0.0001)) * rand();
            populasyon(i).InitialLearnRate = exp(log_lr);
        end
    end
end

function afinite = hesapla_afinite(antikor, X_train, y_train, model_tipi)
    % Antikorun afinitesini hesapla
    if strcmpi(model_tipi, 'svm')
        afinite = svm_afinite(antikor, X_train, y_train);
    elseif strcmpi(model_tipi, 'rf')
        afinite = randomforest_afinite(antikor, X_train, y_train);
    elseif strcmpi(model_tipi, 'mlp')
        afinite = mlp_afinite(antikor, X_train, y_train);
    else
        afinite = 0;
    end
end

function klonlar = uygula_klonlama(antikorlar, afiniteler, beta)
    % Afiniteye göre klonlama yap
    % n_clones = round(beta * (affinity_i / sum(affinity)))
    
    toplam_afinite = sum(afiniteler);
    klonlar = [];
    
    for i = 1:length(antikorlar)
        % Klon sayısını hesapla
        klon_sayisi = round(beta * afiniteler(i) / (toplam_afinite + eps));
        klon_sayisi = max(1, klon_sayisi);  % En az 1 klon
        
        % Klonları ekle
        for j = 1:klon_sayisi
            klonlar = [klonlar; antikorlar(i)];
        end
    end
end

function mutantlar = uygula_hipermutasyon(klonlar, klon_afiniteler, model_tipi, rho)
    % Somatik hipermutasyon uygula
    mutantlar = klonlar;
    
    for i = 1:length(klonlar)
        mutantlar(i) = mutasyon_operatoru(klonlar(i), klon_afiniteler(i), model_tipi, rho);
    end
end
