function [ ] = konumlari_iyilestir( )

global n m v_pop c1 c2 best_p best_g populasyon sinir_degerleri

for i=1:n
    for j=1:m
% ensure velocity initialized if empty or has wrong size
if isempty(v_pop) || any(size(v_pop) ~= [n m])
    v_pop = zeros(n,m);
end

% ensure best_p and best_g shapes are correct
if size(best_p,1) ~= n || size(best_p,2) ~= m
    error('best_p must be of size [n m].');
end
if size(best_g,2) ~= m
    error('best_g must have m columns (row or matrix with first row taken).');
end

% ensure sinir_degerleri has two columns [min max]
if size(sinir_degerleri,2) < 2
    error('sinir_degerleri must have two columns: [min max].');
end
        v_pop(i, j) = (v_pop(i,j) + (c1*rand(1)*(best_p(i,j)-populasyon(i,j)))) + (c2*rand(1)*(best_g(1,j)-populasyon(i,j)));

        if ( populasyon(i,j)+ v_pop(i,j) < sinir_degerleri(j,1) )
            % hiç bir şey yapma ?
            populasyon(i,j) = populasyon(i,j);

        elseif ( populasyon(i,j) + v_pop(i,j) > sinir_degerleri(j,2) )
            % hiç bir şey yapma ?
            populasyon(i,j) = populasyon(i,j);
        else
            populasyon(i,j) = populasyon(i,j) + v_pop(i,j);
        end

    end
end
end
