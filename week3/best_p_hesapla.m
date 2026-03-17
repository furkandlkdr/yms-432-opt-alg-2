function [ ] = best_p_hesapla ( )

global populasyon fd best_p best_p_fd n

for i=1:n
    if(fd(i,:) < best_p_fd(i,:))
        best_p(i,:) = populasyon(i,:);
    end
end

end
