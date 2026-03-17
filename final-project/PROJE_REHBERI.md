# CLONALG Hiperparametre Optimizasyonu - MATLAB

## Hızlı Başlangıç

Bu proje, Python'da yazılan CLONALG (Klonlama Seçilimi Algoritması) algoritmasını MATLAB'a çevirip, 3 farklı makine öğrenmesi modelinin hiperparametrelerini optimizasyonlaştırır.

### Dosya Listesi

| Dosya                          | İçerik |
|--------------------------------|--------|
| `main.m`                        | **Ana script** - buradan başla |
| `test.m`                        | Sistem test script'i |
| `README.m`                      | Detaylı dokumentasyon |
| `veri_yukle.m`                  | Veri seti yükleme |
| `normalize_veriler.m`           | Z-score normalizasyonu |
| `clonalg_algoritma.m`           | CLONALG ana fonksiyonu |
| `mutasyon_operatoru.m`          | Somatik hipermutasyon |
| `caprazvalidasyon_f1.m`         | 5-Fold CV + F1-Score + Model tahmini |
| `svm_afinite.m`                 | SVM için afinite |
| `randomforest_afinite.m`        | RF için afinite |
| `mlp_afinite.m`                 | MLP için afinite |

### Kurulum

Gereklilikler:
- **MATLAB R2020b+** (R2019b+ da çalışabilir)
- **Statistics and Machine Learning Toolbox** (SVM, RF için)
- **Deep Learning Toolbox** (MLP ve görselleştirme için)

### Çalıştırma

1. MATLAB'ı açın
2. `final-project` klasörüne gidin: `cd /path/to/final-project`
3. Ana scriptini çalıştırın: `main`

İşlem tamamlandığında:
- **clonalg_sonuclar.png** - Performans grafikleri
- **clonalg_optimizasyon_sonuclari.mat** - Detaylı sonuçlar

### Test Etme

Sistem tamamını test etmek ister misiniz:
```matlab
>> test
```

## Algoritma İşlevleri

### 1. **Başlatma** - `olustur_populasyon()`
Rastgele hiperparametre popülasyonu oluşturur.

**SVM Parametreleri:**
- `BoxConstraint`: [0.01, 100] (logaritmik)
- `KernelFunction`: {'linear', 'rbf', 'polynomial'}
- `KernelScale`: [0.001, 10]

**RF Parametreleri:**
- `NumTrees`: [10, 200]
- `MinLeafSize`: [1, 20]

**MLP Parametreleri:**
- `LayerSizes`: [10, 100]
- `Activation`: {'relu', 'tanh', 'sigmoid'}
- `InitialLearnRate`: [0.0001, 0.1] (logaritmik)

### 2. **Afinite Hesaplama** - `caprazvalidasyon_f1()`
Hiperparametrenin kalitesi **5-Fold Çapraz Doğrulama** ile ölçülür.
- **Metrik**: Makro F1-Score (0-1 aralığı)
- **Değerlendirme**: `tahmin_svm()`, `tahmin_randomforest()`, `tahmin_mlp()`

### 3. **Seçim** - En iyi n antikorun seçimi
Afiniteye göre sıralanır ve en iyi n antikor seçilir.

### 4. **Klonlama** - `uygula_klonlama()`
```
n_clones_i = round(β × affinity_i / Σaffinity)
```
Afinite yüksekse daha fazla klon oluşturulur.

### 5. **Somatik Hipermutasyon** - `mutasyon_operatoru()`
Mutasyon şiddeti afiniteye ters orantılı:
```
mutation_rate = ρ × exp(-affinity)
```

**Mutasyon Tipleri:**
- **Sürekli**: Gaussian gürültüsü (`X + N(0, σ)`)
- **Tam Sayı**: Gaussian + `round()`
- **Kategorik**: Rastgele başka seçenek seçimi
- **Sınır Kontrolü**: `clip(value, min, max)`

### 6. **Populasyon Güncelleme**
Mevcut + Mutantlar birleştirilir, en iyileri seçilir.

### 7. **Çeşitlilik Koruma**
En kötü d antikorun yerine rastgele yeni antikorlar eklenir.

## Türkçe Yazım Standartları

Bu proje AGENT.md kurallarına şu şekilde uyar:

✓ **MATLAB dili** - Sadece MATLAB kullanılır  
✓ **Modüler yapı** - Ana script + Ayrı fonksiyon dosyaları  
✓ **Türkçe anlamı** - Fonksiyon adları Türkçe (ASCII)  
✓ **ASCII fonksiyonu** - `normalize_veriler` (not `normalleştir_verileri`)  
✓ **Türkçe yorum** - Yorum satırları Türkçe karakterli  
✓ **Global paylaşım** - Gerekli değişkenler global  
✓ **Dosya = Fonksiyon** - `normalize_veriler.m` → `normalize_veriler()` fonksiyonu  

## Örnek Çıktı

```
╔══════════════════════════════════════════════════════════╗
║  CLONALG HIPERPARAMETRESİ OPTİMİZASYON SİSTEMİ           ║
╚══════════════════════════════════════════════════════════╝

--- SVM Hiperparametre Optimizasyonu Başlatıldı ---
SVM Optimizasyonu Tamamlandı - Süre: 45.23 saniye
En İyi Afinite: 0.9234

--- Random Forest Hiperparametre Optimizasyonu Başlatıldı ---
Random Forest Optimizasyonu Tamamlandı - Süre: 32.15 saniye
En İyi Afinite: 0.8956

--- MLP Hiperparametre Optimizasyonu Başlatıldı ---
MLP Optimizasyonu Tamamlandı - Süre: 58.74 saniye
En İyi Afinite: 0.9512

MODEL          | EN İYİ AFFİNİTE | SURE (sn) | EN İYİ PARAMETRE
SVM            | 0.9234          | 45.23   | C=15.32, K=rbf, G=0.456
Random Forest  | 0.8956          | 32.15   | Trees=145, MinLeaf=3
MLP            | 0.9512          | 58.74   | LS=64, A=relu, LR=0.001

Başarıyla Tamamlandı!
```

## Sorun Giderme

### MATLAB Hatasında:
1. Toolbox'ların yüklü olduğunu kontrol edin: `ver`
2. `test.m` ile sistem test edin
3. İşlevi ayrı ayrı çalıştırın ve hata kaynağını bulun

### CV Hesaplaması Çok Yavaşsa:
- İterasyon sayısını azaltın: `max_iterasyon = 20`
- Popülasyon boyutunu düşürün: `pop_buyut = 20`
- Parallelleştirme: `parpool('local', 4)`

### Model Tahmininde Hata:
- Toolbox yükü kontrol edin
- Veri ölçeklendirmesini doğrulayın
- Model parametrelerinin sınırlar içinde olduğunu kontrol edin

## Referanslar

- **Python Implementasyon**: `ais.py`
- **Orijinal Algoritma**: de Castro & von Zuben (2002), "Learning and Optimization in the Immune System"
- **Makro F1-Score**: Sınıf bazlı F1 skorlarının ortalaması

---

*Son güncelleme: Mart 2026*
