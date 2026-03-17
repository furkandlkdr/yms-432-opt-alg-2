function [ ] = hizlari_belirle( )

global n v_pop m
for i = 1:n
    for j = 1:m
        v_pop(i, j) = abs(rand(1));
    end
end

end
