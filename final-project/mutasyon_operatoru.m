function antikor_mutant = mutasyon_operatoru(antikor, afinite, model_tipi, rho)
    % Antikorun somatik hipermutasyonunu uygular
    % Afinite yüksekse az mutasyon, düşükse çok mutasyon
    % Giriş:
    %   antikor: Mutasyona tabi tutulacak antikor (hiperparametre seti)
    %   afinite: Antikorun afinite değeri
    %   model_tipi: 'svm', 'rf', 'mlp'
    %   rho: Mutasyon sabiti (varsayılan 0.1)
    % Çıkış:
    %   antikor_mutant: Mutasyona uğramış antikor
    
    if nargin < 4
        rho = 0.1;
    end
    
    antikor_mutant = antikor;
    
    % Mutasyon oranı: Afinite yüksekse az mutasyon
    % mutation_rate = rho * exp(-afinite)
    mutation_rate = rho * exp(-max(0, afinite));
    
    if strcmpi(model_tipi, 'svm')
        % SVM hiperparametreleri
        % 1: BoxConstraint (sürekli, log uzay)
        if rand() < mutation_rate
            % Log uzayda mutasyon
            log_val = log(antikor_mutant.BoxConstraint);
            log_val = log_val + randn() * mutation_rate;
            antikor_mutant.BoxConstraint = exp(log_val);
            % Sınır kontrolü
            antikor_mutant.BoxConstraint = max(0.01, min(100, antikor_mutant.BoxConstraint));
        end
        
        % 2: KernelFunction (kategorik)
        if rand() < mutation_rate * 0.5  % Kategorik için düşük olasılık
            kernels = {'linear', 'rbf', 'polynomial'};
            current_idx = find(strcmpi(kernels, antikor_mutant.KernelFunction));
            other_idx = setdiff(1:3, current_idx);
            new_idx = other_idx(randi(length(other_idx)));
            antikor_mutant.KernelFunction = kernels{new_idx};
        end
        
        % 3: KernelScale (Gamma) (sürekli)
        if rand() < mutation_rate
            antikor_mutant.KernelScale = antikor_mutant.KernelScale + randn() * mutation_rate;
            % Sınır kontrolü
            antikor_mutant.KernelScale = max(0.001, min(10, antikor_mutant.KernelScale));
        end
        
    elseif strcmpi(model_tipi, 'rf')
        % Random Forest hiperparametreleri
        % 1: NumTrees (tam sayı)
        if rand() < mutation_rate
            delta = round(randn() * mutation_rate * 50);
            antikor_mutant.NumTrees = antikor_mutant.NumTrees + delta;
            antikor_mutant.NumTrees = max(10, min(200, antikor_mutant.NumTrees));
        end
        
        % 2: MinLeafSize (tam sayı)
        if rand() < mutation_rate
            delta = round(randn() * mutation_rate * 5);
            antikor_mutant.MinLeafSize = antikor_mutant.MinLeafSize + delta;
            antikor_mutant.MinLeafSize = max(1, min(20, antikor_mutant.MinLeafSize));
        end
        
    elseif strcmpi(model_tipi, 'mlp')
        % MLP hiperparametreleri
        % 1: LayerSizes (tam sayı)
        if rand() < mutation_rate
            delta = round(randn() * mutation_rate * 30);
            antikor_mutant.LayerSizes = antikor_mutant.LayerSizes + delta;
            antikor_mutant.LayerSizes = max(10, min(100, antikor_mutant.LayerSizes));
        end
        
        % 2: Activation (kategorik)
        if rand() < mutation_rate * 0.5  % Kategorik için düşük olasılık
            activations = {'relu', 'tanh', 'sigmoid'};
            current_idx = find(strcmpi(activations, antikor_mutant.Activation));
            other_idx = setdiff(1:3, current_idx);
            new_idx = other_idx(randi(length(other_idx)));
            antikor_mutant.Activation = activations{new_idx};
        end
        
        % 3: InitialLearnRate (sürekli, log uzay)
        if rand() < mutation_rate
            % Log uzayda mutasyon
            log_val = log(antikor_mutant.InitialLearnRate);
            log_val = log_val + randn() * mutation_rate;
            antikor_mutant.InitialLearnRate = exp(log_val);
            % Sınır kontrolü
            antikor_mutant.InitialLearnRate = max(0.0001, min(0.1, antikor_mutant.InitialLearnRate));
        end
    end
end
