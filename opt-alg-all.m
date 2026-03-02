%% main.m

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

%% best_g_hesapla.m
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

%% best_p_hesapla.m
function [ ] = best_p_hesapla ( )

global populasyon fd best_p best_p_fd n

for i=1:n
    if(fd(i,:) < best_p_fd(i,:))
        best_p(i,:) = populasyon(i,:);
    end
end

end

%% hesapla_fitness_best_p.m

function [ ] = hesapla_fitness_best_p ( )

global n best_p best_p_fd

for i= 1:n
    % Örnek olması açısından rastgele bir hesaplama yazılmıştır,
    % istenilen fitness fonksiyonu seçilebilir.
    best_p_fd(i,:) = ( best_p(i)*3) - (best_p(i,2)*4) / best_p(i,1)+best_p(i,2) + best_p(i,3);
end

end


%% hesapla_fitness.m

function [ ] = hesapla_fitness ( )

global n populasyon fd

for i= 1:n
    % Örnek olması açısından rastgele bir hesaplama yazılmıştır,
    % istenilen fitness fonksiyonu seçilebilir.
    fd(i,:) = ( populasyon(i)*3) - (populasyon(i,2)*4) / populasyon(i,1)+populasyon(i,2) + populasyon(i,3);
end

end

%% hizlari_belirle.m
function [ ] = hizlari_belirle( )

global n v_pop m
for i = 1:n
    for j = 1:m
        v_pop(i, j) = abs(rand(1));
    end
end

end

%% konumlari_iyilestir.m

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

%% populasyon_olustur.m

function [] = populasyon_olustur( )

global n m populasyon Rn_min Rn_max T_min T_max U_min U_max

for i=1:n % popülasyon sayısı
    for j=1:m %boyut
        if (j==1)
            sinir_ust=Rn_max;
            sinir_alt=Rn_min;
        end
        if (j==2)
            sinir_ust=T_max;
            sinir_alt=T_min;
        end
        if (j==3)
            sinir_ust=U_max;
            sinir_alt=U_min;
        end
        populasyon(i, j) = sinir_alt + (sinir_ust - sinir_alt) * rand(1);

    end

end
end
