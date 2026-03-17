% README - CLONALG Hiperparametre Optimizasyonu Sistemi
% ========================================================================
%
% AÇIKLAMA:
% ========================================================================
% Bu proje, CLONALG (Klonlama Seçilimi Algoritması) kullanarak 3 farklı
% makine öğrenmesi modelinin hiperparametrelerini otomatik olarak
% optimize eden bir MATLAB uygulamasıdır.
%
% DESTEKLENEN MODELLER:
% ========================
% 1. Destek Vektör Makineleri (SVM)      - fitcsvm()
% 2. Rastgele Orman (Random Forest)      - TreeBagger()
% 3. Çok Katmanlı Algılayıcı (MLP)       - trainNetwork() / fitcnet()
%
% VERİ SETİ:
% ========================
% Breast Cancer Wisconsin (569 örnek, 30 öznitelik)
% - İkili sınıflandırma problemi
% - Otomatik normalizasyon (z-score)
%
% DOSYA YAPISI:
% ========================
% main.m                      - Ana script (başlangıç noktası)
% veri_yukle.m                - Veri seti yükleme
% normalize_veriler.m         - Z-score normalizasyonu
% clonalg_algoritma.m         - Ana CLONALG algoritması
% mutasyon_operatoru.m        - Somatik hipermutasyon
% caprazvalidasyon_f1.m       - 5-Fold CV ve F1-score hesaplama
% svm_afinite.m               - SVM için afinite fonksiyonu
% randomforest_afinite.m      - RF için afinite fonksiyonu
% mlp_afinite.m               - MLP için afinite fonksiyonu
%
% CLONALG ALGORİTMASI ADİMLARI:
% ==============================
% 1. BAŞLATMA: Rastgele hiperparametre popülasyonu oluş
% 2. AFFİNİTE: Her antikorun kalitesi 5-Fold CV ile ölçülür (Makro F1)
% 3. SEÇİM: En iyi n antikorun seçilmesi
% 4. KLONLAMA: Afiniteye göre antikorlara klon sayısı atanır
% 5. SOMATIK HIPERMUTASYON: Klonlar mutasyona tabi tutulur
%    - Afinite yüksek = Az mutasyon
%    - Afinite düşük = Çok mutasyon
% 6. GÜNCELLEME: Mevcut + mutantlar arasından en iyileri seç
% 7. ÇEŞİTLİLİK KORUMA: En kötü d antikorun yerine rastgele yenilerini ekle
%
% MUTASYON TÜRLERİ:
% ==================
% Sürekli Parametreler (C, Gamma, Learn Rate):
%   - Gaussian gürültüsü eklenir
%   - Log-uzayda aranılan parametreler log-space'te mutasyona tabi
%
% Tam Sayı Parametreler (NumTrees, LayerSizes):
%   - Gaussian gürültüsü + round()
%
% Kategorik Parametreler (KernelFunction, Activation):
%   - Olasılıksal dönüşüm: başka bir seçenek rastgele seçilir
%
% Sınır Kontrolü (Clipping):
%   - Mutasyon sonrası değer sınırları dışındaysa sabitlenir
%
% KULLANIM:
% ==========
% 1. MATLAB açın ve final-project klasörüne gidin:
%    >> cd /path/to/final-project
%
% 2. Main scriptini çalıştırın:
%    >> main
%
% 3. Sonuçlar otomatik olarak şu dosyalarda kaydedilecektir:
%    - clonalg_sonuclar.png           (grafik rapor)
%    - clonalg_optimizasyon_sonuclari.mat (sonuçlar)
%
% ÇIKTI ÖRNEĞİ:
% ===============
%
% MODEL          | EN İYİ AFFİNİTE | SURE (sn) | EN İYİ PARAMETRE
% ---            | ---              | ---       | ---
% SVM            | 0.9234           | 45.23    |
%                | C=15.32, K=rbf, G=0.456
% Random Forest  | 0.8956           | 32.15    |
%                | Trees=145, MinLeaf=3
% MLP            | 0.9512           | 58.74    |
%                | LS=64, A=relu, LR=0.001
%
% SISTEM GEREKSINIMLERI:
% =======================
% - MATLAB R2020b veya üstü (Deep Learning Toolbox önerilir)
% - Statistics and Machine Learning Toolbox (SVM, RF için)
% - Neural Network Toolbox (MLP için)
% - Memory: Min 4GB (CV hesapları yoğun olabilir)
%
% NOTLAR:
% =======
% 1. İlk çalıştırma yavaş olabilir (model eğitim yoğun)
% 2. CV hesapları parallelleştirilebilir (parpool)
% 3. Hiperparametre alanı genişletilse iterasyon sayısı artırılmalı
% 4. Sonuçlar seed değerinden bağımsız olabilir (rastgele başlatma)
%
% REFERANSLAR:
% =============
% - de Castro, L. N. & Von Zuben, F. J. (2002). Learning and optimization
%   in the immune system. IEEE Transactions on SMC, 32(5).
% - Python ais.py implementasyon
%
% YAZIM STANDARTLARI:
% ====================
% - Fonksiyon adları: Türkçe anlamı, ASCII (ä→a, ö→o, ü→u, etc.)
% - Yorum satırları: Türkçe karakterler kullanılır
% - Dosya adı = Fonksiyon adı
% - Modüler yapı: Ana script + ayrı fonksiyon dosyaları
%
% ========================================================================
