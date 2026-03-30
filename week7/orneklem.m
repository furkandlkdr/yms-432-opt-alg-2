function [egitim, egitimc, test, testc] = orneklem(data)
ornekyuzde = 30 ;
% Veri setinden orneklem olusturma programi

% SISTEMATIK ORNEKLEME
 
% Toplum hacminin 1000 dolaylarinda oldugu ve
% birimlere 1'den N'e kadar sira numarasi verilebildigi
% durumlarda uygulanir. 
% n orneklem; 
% 1) Devir sayisi (d) ; d <= N/n
% 2) Baslangic sayisi (a); 1<= a <= d belirlenir .
% 3) Orneklem nolari a, a+d, a+2d, ..., a+(n-1)d seklinde
% belirlenir .

% Not: Orneklem olusturulurken satir sayilari arasinda orneklem secilir. Sutunlar dikkate alinmaz.
% Not: Genel veri setinin oncelikle secilecek ozellice gore sirlanmasi gerekmektedir.
% Siralama icin  B = sortrows(A,3) komutu kullanilabilir. A siralanacak
% matris, 3 ise referans olarak siralanacak matrisi ifade eder.

N =  size(data,1);
% ornekyuzde = 25 ;
n = floor(N*ornekyuzde/100) ;

% n = orneklem, N adet ornekten secilecek yuzdelik miktari temsil eder.

% Devir sayisinin hesaplanmasi
d = round(N/n) ; 

% Baslangic sayisi (a)
a = 1 ;
s = size(data,2) ;
% Orneklenmi matris olusturma (OM) Test verisi olarak kullanilacaktir.
% Test Veri seti
for i=1:n
    B=(a+d*(i-1));
    if (B>N)
        C=B-N;
    else
        C=B;
    end
	test1(i,:) = data(C,:) ;
end

test = test1(:,1:s-1) ;

testc = test1(:,s) ;

% Egitim Veri seti

egitim1 = data ;
for i=1:n
	silme(i) = (a+d*(i-1)) ;
end    
    
silme=sort(silme,'descend');

for i=1:n
    k = silme(i) ;
    egitim1(k,:) = [] ;
end    

egitim = egitim1(:,1:s-1) ;

egitimc = egitim1(:,s) ;

end