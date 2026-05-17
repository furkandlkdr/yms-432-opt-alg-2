function sonuc = ais_optimizasyon(iterasyon_sayisi)
    % Export edilen baseline modelleri kullanarak AIS optimizasyonu calistirir
    % Giriş:
    %   iterasyon_sayisi: Her model icin denenecek AIS adim sayisi
    % Çıkış:
    %   sonuc: Modellerin en iyi parametrelerini ve gecmisini iceren struct

    if nargin < 1
        iterasyon_sayisi = 25;
    end

    clear global;
    clc;

    fprintf('\n');
    fprintf('╔══════════════════════════════════════════════════════════╗\n');
    fprintf('║                AIS PARAMETRE OPTIMIZASYONU               ║\n');
    fprintf('║        Baseline + tek tek parametre denemesi             ║\n');
    fprintf('╚══════════════════════════════════════════════════════════╝\n\n');

    [X, y] = veri_yukle();
    X = normalize_veriler(X);

    baselines = ais_baseline_olustur(X);
    sonuc = struct();
    sonuc.baselines = baselines;
    sonuc.modeller = cell(numel(baselines), 1);

    for i = 1:numel(baselines)
        fprintf('--- %s AIS Baslaniyor ---\n', baselines(i).model_adi);
        sonuc.modeller{i} = ais_model_optimize(X, y, baselines(i), iterasyon_sayisi);
        fprintf('En iyi afinitesi: %.4f\n\n', sonuc.modeller{i}.en_iyi_afinite);
    end

    sonuc.oyetler = struct('iterasyon_sayisi', iterasyon_sayisi);

    ais_raporla(sonuc);

    save('ais_optimizasyon_sonuclari.mat', 'sonuc', '-v7.3');
    fprintf('Sonuclar kaydedildi: ais_optimizasyon_sonuclari.mat\n');
end