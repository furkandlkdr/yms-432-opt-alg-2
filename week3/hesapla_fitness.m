function [ ] = hesapla_fitness ( )

global n populasyon fd

for i= 1:n
    % Örnek olması açısından rastgele bir hesaplama yazılmıştır,
    % istenilen fitness fonksiyonu seçilebilir.
    fd(i,:) = ( populasyon(i)*3) - (populasyon(i,2)*4) / populasyon(i,1)+populasyon(i,2) + populasyon(i,3);
end

end
