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
        % Eğer built-in veri seti bulunamazsa, CSV dosyasından yükle
        try
            fprintf('Built-in veri seti bulunamadı, CSV dosyasından yüklenecek...\n\n');
            
            % CSV dosyasının tam yolunu belirt
            csv_dosya = fullfile(fileparts(mfilename('fullpath')), 'data.csv');
            
            % CSV dosyasını oku — manuel başlık ayrıştırma ile (ReadVariableNames=false)
            fid = fopen(csv_dosya, 'r', 'n', 'UTF-8');
            if fid == -1
                error('Dosya açılamadı: %s', csv_dosya);
            end
            headerLine = fgetl(fid);
            fclose(fid);

            % Başlık satırını virgüle göre böl ve tırnakları temizle
            rawTokens = strsplit(headerLine, ',');
            % Temizle ve boş token'ları kaldır
            varNames = {};
            for i = 1:numel(rawTokens)
                t = rawTokens{i};
                if isstring(t) || ischar(t)
                    t = char(t);
                end
                t = strtrim(t);
                if startsWith(t, '"') && endsWith(t, '"')
                    t = t(2:end-1);
                end
                if ~isempty(t)
                    varNames{end+1} = t; %#ok<AGROW>
                end
            end

            % Geçerli MATLAB değişken isimlerine dönüştür
            varNames = matlab.lang.makeValidName(varNames);

            % Dosyayı değişken isimleri olmadan oku ve sonra isimleri ata
            data = readtable(csv_dosya, 'Delimiter', ',', 'ReadVariableNames', false, 'TextType', 'string');
            if ~isempty(varNames)
                % Eğer sütun sayısı tutmuyorsa, hata ver
                if numel(varNames) ~= width(data)
                    warning('Header sütun sayısı ile veri sütun sayısı uyuşmuyor. Header: %d, Veri sütunları: %d', numel(varNames), width(data));
                end
                % Kısa kenarı eşleştirerek isim ata
                nAssign = min(numel(varNames), width(data));
                data.Properties.VariableNames(1:nAssign) = varNames(1:nAssign);
            end
            
            % Diagnosis sütununu bul ve binary değerlere çevir (M=1, B=0)
            varNames = data.Properties.VariableNames;
            varDesc = {};
            if isprop(data.Properties, 'VariableDescriptions')
                varDesc = data.Properties.VariableDescriptions;
            end

            diagIdx = [];
            % Öncelikle VariableDescriptions içinde ara (orijinal header burada saklı olabilir)
            if ~isempty(varDesc)
                for i = 1:numel(varDesc)
                    if contains(lower(varDesc{i}), 'diagnosis')
                        diagIdx = i; break;
                    end
                end
            end

            % Bulunamadıysa VariableNames içinde ara
            if isempty(diagIdx)
                for i = 1:numel(varNames)
                    if contains(lower(varNames{i}), 'diagnosis')
                        diagIdx = i; break;
                    end
                end
            end

            % Hala yoksa olası id sütununu al ve diagnosis'ı ikinci sütun olarak kabul et
            if isempty(diagIdx)
                idIdx = find(contains(lower(varNames), 'id'), 1);
                if ~isempty(idIdx) && numel(varNames) >= 2
                    cand = setdiff(1:numel(varNames), idIdx);
                    if ~isempty(cand)
                        diagIdx = cand(1);
                    end
                end
            end

            if isempty(diagIdx)
                error('diagnosis column not found in CSV. Variable names: %s', strjoin(varNames, ', '));
            end

            diagnosis = data{:, diagIdx};
            if iscell(diagnosis) || isstring(diagnosis) || ischar(diagnosis)
                diagnosis = string(diagnosis);
                y = double(diagnosis == "M");
            else
                y = double(diagnosis);
            end

            % ID ve diagnosis sütunlarını çıkar, geri kalanı features
            idIdx = find(contains(lower(varNames), 'id'), 1);
            colsToRemove = diagIdx;
            if ~isempty(idIdx)
                colsToRemove = unique([idIdx, diagIdx]);
            end
            featIdx = setdiff(1:numel(varNames), colsToRemove);
            featTable = data(:, featIdx);

            % Table'dan sayısal matris elde et
            tmp = table2array(featTable);
            if iscell(tmp)
                X = cellfun(@(c) str2double(c), tmp);
            else
                X = double(tmp);
            end

            fprintf('\n========== ÇIKTI AYIRIMI (OUTPUT SEPARATION) ==========\n\n');
            fprintf('X - GİRİŞ ÖZELLİKLERİ (INPUT FEATURES):\n');
            fprintf('  Boyut (Size): %d x %d\n', size(X, 1), size(X, 2));
            fprintf('  Örnek Sayısı (Samples): %d\n', size(X, 1));
            fprintf('  Öznitelik Sayısı (Features): %d\n\n', size(X, 2));
            fprintf('Y - ÇIKTI ETİKETLERİ (OUTPUT LABELS):\n');
            fprintf('  Boyut (Size): %d x 1\n', size(y, 1));
            fprintf('  Sınıf 0 (Benign): %d örnek\n', sum(y==0));
            fprintf('  Sınıf 1 (Malignant): %d örnek\n', sum(y==1));
            fprintf('========================================================\n\n');
            return;
        catch ME
            % Son çare: Eğer CSV da yoksa, random veri oluştur (demo amaçlı)
            fprintf('Uyarı: CSV dosyası okunurken hata oluştu:\n');
            fprintf('Error: %s\n\n', ME.message);
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
        end;
    end;
    
    % Çıkış ayırımı ve istatistikleri göster
    fprintf('\n========== ÇIKTI AYIRIMI (OUTPUT SEPARATION) ==========\n\n');
    fprintf('X - GİRİŞ ÖZELLİKLERİ (INPUT FEATURES):\n');
    fprintf('  Boyut (Size): %d x %d\n', size(X, 1), size(X, 2));
    fprintf('  Örnek Sayısı (Samples): %d\n', size(X, 1));
    fprintf('  Öznitelik Sayısı (Features): %d\n\n', size(X, 2));
    fprintf('Y - ÇIKTI ETİKETLERİ (OUTPUT LABELS):\n');
    fprintf('  Boyut (Size): %d x 1\n', size(y, 1));
    fprintf('  Sınıf 0 (Benign): %d örnek\n', sum(y==0));
    fprintf('  Sınıf 1 (Malignant): %d örnek\n', sum(y==1));
    fprintf('========================================================\n\n');
end
