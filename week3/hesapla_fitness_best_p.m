function [ ] = hesapla_fitness_best_p ( )

global n best_p best_p_fd

for i= 1:n
    % Örnek olması açısından rastgele bir hesaplama yazılmıştır,
    % istenilen fitness fonksiyonu seçilebilir.
    best_p_fd(i,:) = ( best_p(i)*3) - (best_p(i,2)*4) / best_p(i,1)+best_p(i,2) + best_p(i,3);
end

end
