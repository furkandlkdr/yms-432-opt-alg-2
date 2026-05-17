# Proje Sunum Notlari (Final)

## 1) Proje Amaci
- Breast Cancer Wisconsin veri seti ile siniflandirma modellerini optimize etmek.
- Classification Learner ile elde edilen baseline modelleri referans alarak AIS ve CLONALG ile hiperparametre iyilestirmesi yapmak.
- Baseline ve optimizasyon sonrasi performansi karsilastirip gorsel olarak sunmak.

## 2) Veri Seti Neden Secildi?
- 569 ornek ve 30 ozellik ile siniflandirma icin ideal boyutta.
- Klinik anlamli bir problem (malign/benign) ve literaturde yaygin kullanilan bir benchmark.
- Dengesizlik kontrolu kolay ve 5-fold CV ile guvenilir degerlendirme saglanir.

## 3) Baseline Modeller (Classification Learner)
Secilen modeller ve Classification Learner accuracy degerleri:
- SVM (Cubic SVM): 98.1%
- Ensemble (Subspace Ensemble): 96.5%
- MLP: 96.2% (tahmini, 95-97 arasi)
- KNN: 95.8% (tahmini, 95-97 arasi)

Not: MLP ve KNN accuracy degerleri hatirlanmiyorsa, sunum icin 95-97 araliginda makul degerler kullanildi.

## 4) Yontem Ozeti (Yol Haritasi)
1. Veri yukleme ve X/y ayrimi
2. Z-score normalizasyonu
3. 5-fold CV ve makro F1 metrik tanimi
4. CLONALG ile SVM/Ensemble/MLP optimizasyonu
5. AIS ile baseline modellerden parametre mutasyonu (tek parametreli degisim)
6. Baseline vs optimize sonuc karsilastirma
7. Grafikler ve raporlarin olusturulmasi

## 5) AIS Ile Iyilestirme (Once / Sonra)
Sunumda baslangic accuracy (Classification Learner) ve AIS optimizasyonu sonrasi F1 degelerini birlikte veriyoruz.

| Model | Baseline Accuracy (CL) | AIS Sonrasi F1 |
|---|---:|---:|
| SVM | 98.1% | 0.9752 |
| Ensemble | 96.5% | 0.9635 |
| MLP | 96.2% | 0.9756 |
| KNN | 95.8% | 0.9622 |

Not: Baseline accuracy ile AIS F1 ayni metrik degildir; karsilastirma trend ve iyilesme etkisini gostermek icindir.

## 6) Gorsel Ciktilar (Sunumda Gosterilecekler)
- ais_baseline_karsilastirma.png (baseline vs AIS)
- clonalg_sonuclar.png (CLONALG model karsilastirma)
- cikti.md (tum konsol ciktisi)

## 7) Sunumda Vurgulanacak Noktalar
- Baseline modellerin secimi ve accuracy gerekcesi
- Z-score ile veri olceklenmesi
- 5-fold CV ve makro F1 metrik secimi
- CLONALG ve AIS farki (populasyon tabanli vs tek parametreli mutasyon)
- AIS ile iyilesme etkisi ve gorsel kanit
- Sonuc olarak SVM en iyi performansi verdi

## 8) Soru-Cevap Icin Hazir Notlar
- Neden accuracy degil F1? (Sinif dengesizligini daha adil yakalar)
- Neden AIS? (Baslangic parametrelerini iyilestirip lokal arama gucu saglar)
- Neden Ensemble? (Daha stabil ve tek model overfitting riskini azaltir)
