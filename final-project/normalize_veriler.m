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
    
    fprintf('Veriler normalizasyon işleminden geçti.\n');
end
