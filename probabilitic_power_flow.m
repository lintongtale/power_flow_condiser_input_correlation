%% 计算
clear ;
clc;
tic

load phenan;
load qhenan;
load zhilu1;
load jiedian1;
zhilu = zhilu1;
jiedian = jiedian1;

% 节点负荷有功、无功归一化
% jiedian(:,2) = jiedian(:,2)/100;
% jiedian(:,6) = jiedian(:,6)/100;
% jiedian(:,7) = jiedian(:,7)/100;

U = [];
Ue = [];
Uf = [];
Ploss = [];
Qloss = [];
Pin = [];
Qin = [];
Pout = [];
Qout = [];
 
GenCopula = copula_arrary(wind_power_output(1000), wind_power_output(1000));

%% N次模拟计算
N = 1000;

phenanMean = mean(phenan, 1);
qhenanMean = mean(qhenan, 1);
% for i=1:19
%     p(:, i) = normrnd(phenanMean(i), 0.5, 1000, 1);
% end
% for i=1:19
%     q(:, i) = normrnd(qhenanMean(i), 0.5, 1000, 1);
% end
p = phenan;
q = qhenan;


for  cishu = 1: N;
    cishu
     
    jiedian(33, 4) = jiedian1(33, 4) * (1+ 0.15*GenCopula(N, 1));
    jiedian(34, 4) = jiedian1(33, 4) * (1+ 0.15*GenCopula(N, 2));
%     jiedian(find(jiedian1(:,6)~=0),6) = phenan(cishu,:);
%     jiedian(find(jiedian1(:,7)~=0),7) = qhenan(cishu,:);
    jiedian(find(jiedian1(:,6)~=0),6) = p(cishu,:);
    jiedian(find(jiedian1(:,7)~=0),7) = q(cishu,:);
      
    Yzheng = net_form(zhilu, jiedian);
    [e f]  = net_voltage (Yzheng, jiedian);
    line_power = net_power(e, f, zhilu);
    
    Ue = [Ue e];
    Uf = [Uf f];
    U = [U (sqrt( e.*e  + f.*f ))];
    Ploss = [Ploss line_power(:, 8)];
    Qloss = [Qloss line_power(:, 9)];
    Pin = [Pin line_power(:,4)];
    Qin = [Qin line_power(:,5)];
    Pout = [Pout line_power(:, 6)];
    Qout = [Qout line_power(:, 7)];
end

toc;
