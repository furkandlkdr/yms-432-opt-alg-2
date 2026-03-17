% Bitkinin günlük su ihtiyacı formülü, Kc var bitkiye özel katsayı
clc; clear; clear all;
global n m populasyon v_pop Rn_min Rn_max T_min T_max U_min U_max fd en_uygun_fd best_p c1 c2 sinir_degerleri

n=10; %popülasyon sayısı
m=3; % çözüm boyutu
Rn_min =16.3;
Rn_max= 18.3;
T_min = 15;
T_max = 29;
U_min = 2.2;
U_max = 2.7;
sinir_degerleri=[Rn_min Rn_max; T_min T_max; U_min U_max];
% pso r katsayısı oluşturma

for i = 1:n
    for j = 1:m
        r1(i,j) = rand(1);
        r2(i,j) = rand(1);
    end
end

% pso c1 ve c2 katsayısı oluşturma
while(0<1)
    c1= 2*rand(1,1);
    c2=2*rand(1,1);
    if(c1+c2>3.9)
        break
    end
end

j=1;
iterasyon=10;
populasyon_olustur; % 2. adım
hizlari_belirle; % 2. adım 2
hesapla_fitness; % 3. adım, fd: fitness değerleri
best_p = populasyon; % İlk adımda en iyi çözüm kendisidir
best_g_hesapla;

% DÖngü

while ( j <= iterasyon)
    konumlari_iyilestir;
    hesapla_fitness;
    best_p_hesapla;
    hesapla_fitness_best_p;
    best_g_hesapla;

    j= j+1;
end
