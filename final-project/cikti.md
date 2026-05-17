╔══════════════════════════════════════════════════════════╗
║  CLONALG HIPERPARAMETRESİ OPTİMİZASYON SİSTEMİ          ║
║  Breast Cancer Wisconsin Veri Seti                     ║
╚══════════════════════════════════════════════════════════╝

--- Veri Hazırlama ---
Built-in veri seti bulunamadı, CSV dosyasından yüklenecek...


========== ÇIKTI AYIRIMI (OUTPUT SEPARATION) ==========

X - GİRİŞ ÖZELLİKLERİ (INPUT FEATURES):
  Boyut (Size): 569 x 30
  Örnek Sayısı (Samples): 569
  Öznitelik Sayısı (Features): 30

Y - ÇIKTI ETİKETLERİ (OUTPUT LABELS):
  Boyut (Size): 569 x 1
  Sınıf 0 (Benign): 357 örnek
  Sınıf 1 (Malignant): 212 örnek
========================================================


========== GİRİŞ ÖZELLİKLERİ NORMALİZASYONU ==========

X - NORMALİZE EDİLMİŞ GİRİŞ ÖZELLİKLERİ (NORMALIZED INPUT FEATURES):
  Boyut (Size): 569 x 30
  Yöntem (Method): Z-score normalization
  Min Değer: -3.112085
  Max Değer: 12.072680
  Ortalama (Mean): 0.000000
=====================================================


========== AYRILMIŞ VERİ SETLERİ (SEPARATED DATASETS) ==========

X_train - EĞİTİM GİRİŞ ÖZELLİKLERİ (TRAINING INPUT FEATURES):
  Boyut (Size): 455 x 30

y_train - EĞİTİM ÇIKTI ETİKETLERİ (TRAINING OUTPUT LABELS):
  Boyut (Size): 455 x 1

X_test - TEST GİRİŞ ÖZELLİKLERİ (TEST INPUT FEATURES):
  Boyut (Size): 114 x 30

y_test - TEST ÇIKTI ETİKETLERİ (TEST OUTPUT LABELS):
  Boyut (Size): 114 x 1
=============================================================

--- SVM Hiperparametre Optimizasyonu Başlatıldı ---
Parametreler:
  BoxConstraint (C): [0.01, 100] (logaritmik)
  KernelFunction: {linear, rbf, polynomial}
  KernelScale (Gamma): [0.001, 10]


=== CLONALG ALGORİTMASI BAŞLADI ===
Model: svm | Popülasyon: 30 | İterasyon: 30

İterasyon   1: En İyi Afinite = 0.9684
İterasyon  10: En İyi Afinite = 0.9758
İterasyon  20: En İyi Afinite = 0.9784
İterasyon  30: En İyi Afinite = 0.9791

=== ALGORİTMA TAMAMLANDI ===
En İyi Afinite: 0.9791
SVM Optimizasyonu Tamamlandı - Süre: 243.71 saniye
En İyi Afinite: 0.9791

--- Ensemble Hiperparametre Optimizasyonu Başlatıldı ---
Parametreler:
  NumLearningCycles: [10, 200]
  NPredToSample: [1, 15]


=== CLONALG ALGORİTMASI BAŞLADI ===
Model: ensemble | Popülasyon: 30 | İterasyon: 30

İterasyon   1: En İyi Afinite = 0.9618
İterasyon  10: En İyi Afinite = 0.9708
İterasyon  20: En İyi Afinite = 0.9711
İterasyon  30: En İyi Afinite = 0.9711

=== ALGORİTMA TAMAMLANDI ===
En İyi Afinite: 0.9711
Ensemble Optimizasyonu Tamamlandı - Süre: 996.64 saniye
En İyi Afinite: 0.9711

--- MLP Hiperparametre Optimizasyonu Başlatıldı ---
Parametreler:
  LayerSizes: [10, 100]
  Activation: {relu, tanh, sigmoid}
  InitialLearnRate: [0.0001, 0.1] (logaritmik)


=== CLONALG ALGORİTMASI BAŞLADI ===
Model: mlp | Popülasyon: 30 | İterasyon: 30

İterasyon   1: En İyi Afinite = 0.5311
İterasyon  10: En İyi Afinite = 0.5503
İterasyon  20: En İyi Afinite = 0.5503
İterasyon  30: En İyi Afinite = 0.5534

=== ALGORİTMA TAMAMLANDI ===
En İyi Afinite: 0.5534
MLP Optimizasyonu Tamamlandı - Süre: 18.97 saniye
En İyi Afinite: 0.5534


╔══════════════════════════════════════════════════════════╗
║                    SONUÇLAR ÖZETI                        ║
╚══════════════════════════════════════════════════════════╝

MODEL          | EN İYİ AFFİNİTE | SURE (sn) | EN İYİ PARAMETRE
---            | ---              | ---       | ---
SVM            | 0.9791            | 243.71     | 
               | C=3.1417, K=rbf, G=6.2942
Ensemble       | 0.9711            | 996.64     | 
               | Cycles=160, NPred=11
MLP            | 0.5534            | 18.97     | 
               | LS=10, A=relu, LR=0.001471

Toplam Süre: 1259.32 saniye

Grafik kaydedildi: clonalg_sonuclar.png


--- OPTİMİZASYON TERCİH ÖNERISI ---
En başarılı model: SVM (F1 = 0.9791)

Sistem Önerileri:
  1. Hiperparametre optimizasyonu başarıyla tamamlandı.
  2. Bulunan en iyi parametreler test seti üzerinde değerlendirilmelidir.
  3. Çeşitlilik sağlanması için tüm modeller birlikte ensemble kullanılabilir.
  4. Daha fazla iterasyon veya daha geniş parametre alanı denenebilir.

╔══════════════════════════════════════════════════════════╗
║                 PROGRAM BAŞARI İLE TAMAMLANDI            ║
╚══════════════════════════════════════════════════════════╝

Sonuçlar kaydedildi: clonalg_optimizasyon_sonuclari.mat