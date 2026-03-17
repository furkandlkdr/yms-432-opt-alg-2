function [ ] = best_g_hesapla ( )

global n best_p best_p_fd best_g en_uygun_fd

hesapla_fitness_best_p;
en_uygun_fd = best_p_fd(1,:);
en_uygun_cozum = best_p(1,:);
for i = 2:n
    if en_uygun_fd > best_p_fd(i,:)
        en_uygun_fd = best_p_fd(i,:);
        en_uygun_cozum = best_p(i,:);
    end
end
best_g = en_uygun_cozum;

end
