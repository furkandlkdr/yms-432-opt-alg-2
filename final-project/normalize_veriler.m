function X_normalized = normalize_veriler(X)
    % Veri setini StandardScaler (zscore) ile normalizasyon yapar
    % Giriş:
    %   X: Orijinal öznitelik matrixi (N x D)
    % Çıkış:
    %   X_normalized: Normalize edilmiş veri (N x D)
    
    % Her öznitelik için mean ve std hesapla
    X_mean = mean(X, 1);  % Herm sütun için ortalama
    X_std = std(X, 1);    % Her sütun için standart sapma
    
    % Sıfır standart sapmayı önlemek için küçük değer ekle
    X_std(X_std == 0) = 1e-8;
    
    % Z-score normalizasyonu: (X - mean) / std
    X_normalized = (X - X_mean) ./ X_std;
    
    fprintf('\n========== GİRİŞ ÖZELLİKLERİ NORMALİZASYONU ==========\n\n');
    fprintf('X - NORMALİZE EDİLMİŞ GİRİŞ ÖZELLİKLERİ (NORMALIZED INPUT FEATURES):\n');
    fprintf('  Boyut (Size): %d x %d\n', size(X_normalized, 1), size(X_normalized, 2));
    fprintf('  Yöntem (Method): Z-score normalization\n');
    fprintf('  Min Değer: %.6f\n', min(X_normalized(:)));
    fprintf('  Max Değer: %.6f\n', max(X_normalized(:)));
    fprintf('  Ortalama (Mean): %.6f\n', mean(X_normalized(:)));
    fprintf('=====================================================\n\n');
end
