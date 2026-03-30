
clc; clear all;close all;
load("bm1.mat")

f=readfis('bm.fis');
for i=1:173 
    tahmin(i,1)=evalfis([input1(i,1) input2(i,1)],f);
    x(i,1)=i;
end

plot(x,output,'b',x,tahmin,'r')
xlabel('Sıra')
ylabel('Veri')
title('Gerçek ve Tahmin degerleri')
