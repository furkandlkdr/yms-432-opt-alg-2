function afinite = mlp_afinite(hiperparametre, X_train, y_train)
    % MLP modeli için afinite (F1-score) hesapla
    % Giriş:
    %   hiperparametre: MLP parametreleri (struct)
    %   X_train: Eğitim verisi
    %   y_train: Eğitim etiketleri
    % Çıkış:
    %   afinite: 5-Fold CV ile hesaplanan makro F1-score
    
    try
        afinite = caprazvalidasyon_f1(X_train, y_train, 'mlp', hiperparametre);
        afinite = max(0, afinite);  % Negatif değer olmasını önle
    catch
        afinite = 0;  % Hata durumunda 0 ata
    end
end
