function [X, y] = veri_yukle()
    % Gögüs Kanseri Wisconsin veri setini yükler ve hazırlar
    % Çıkışlar:
    %   X: Öznitelik matris (N x D)
    %   y: Hedef etiketi (N x 1), 1=kötü huylu, 0=iyi huylu
    
    % MATLAB built-in veri setini yükle
    % Deneme: cancerInputs ve cancerTargets
    try
        load cancerInputs.mat cancerInputs
        load cancerTargets.mat cancerTargets
        
        % Veri setinin boyutlarını kontrol et
        X = cancerInputs';  % Transpose işlemi
        y = cancerTargets';  % Transpose işlemi
        
        % y etiketi 0.5 aşağısındaki 0, üstü 1 olarak dönüştür
        y = double(y > 0.5);
        
    catch
        % Eğer veri seti bulunamazsa, random veri oluştur (demo amaçlı)
        fprintf('Uyarı: Breast Cancer Wisconsin veri seti bulunamadı.\n');
        fprintf('Demo için randomly generated veri kullanılıyor.\n\n');
        
        % Synthetic veri: 
        n_samples = 500;
        n_features = 30;
        
        X = randn(n_samples, n_features);
        y = round(rand(n_samples, 1));
        
        fprintf('Synthetic Veri Oluşturuldu:\n');
        fprintf('  - Örnek Sayısı: %d\n', n_samples);
        fprintf('  - Öznitelik Sayısı: %d\n', n_features);
        fprintf('  - Sınıf 0 Sayısı: %d\n', sum(y==0));
        fprintf('  - Sınıf 1 Sayısı: %d\n\n', sum(y==1));
        return;
    end
    
    % Veri setinin istatistiklerini yazdır
    fprintf('Veri Seti Yüklendi:\n');
    fprintf('  - Örnek Sayısı: %d\n', size(X, 1));
    fprintf('  - Öznitelik Sayısı: %d\n', size(X, 2));
    fprintf('  - Sınıf 0 Sayısı: %d\n', sum(y==0));
    fprintf('  - Sınıf 1 Sayısı: %d\n\n', sum(y==1));
end
