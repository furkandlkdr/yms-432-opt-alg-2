
a=newfis('bulanik');
    a=addvar(a,'input','INPUT1',[52 76]);
    a=addmf(a,'input',1,'Düşük','trimf',[52 52 57]);
    a=addmf(a,'input',1,'Orta','trimf',[54 58 62]);
    a=addmf(a,'input',1,'Yüksek','trimf',[58 74 76]);
    

    a=addvar(a,'input','INPUT2',[4 20]);
    a=addmf(a,'input',2,'Düşük','trimf',[4 4.5 5]);
    a=addmf(a,'input',2,'Orta','trimf',[4.5 5 6]);
    a=addmf(a,'input',2,'Yüksek','trimf',[5.5 11 20]);

    a=addvar(a,'output','CIKIS',[8 29]);
    a=addmf(a,'output',1,'low','trimf',[9 9.5 11]);
    a=addmf(a,'output',1,'moderate','trimf',[10 11.5 12]);
    a=addmf(a,'output',1,'high','trimf',[11 14 29]);
    ruleList=[ ...
    1 1 1 1 1
    1 3 3 1 1
    2 2 1 1 1
    3 2 3 1 1
    3 3 2 1 1];
    a=addrule(a,ruleList);
    writefis(a,'Bulanik.fis');
    
    f=readfis('Bulanik.fis');
    for i=1:5 
        tahmin(i,1)=evalfis([input1(i,1) input2(i,1)],f);
        x(i,1)=i;
    end
    
    
    
    
    showfis(a);
    
    plotfis(a);
    figure;
    plotmf(a,'input',1);
    figure;
    plotmf(a,'input',2);
    figure;
    plotmf(a,'output',1);
    figure;
    writefis(a,'bm_kd.fis');