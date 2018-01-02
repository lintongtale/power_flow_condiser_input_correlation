%% 负荷曲线拟合，以河南某节点有功负荷数据为例
clear;

load phenan;
p = phenan(:, 11);
[f_ecdf, xc] = ecdf(p);
figure;
ecdfhist(f_ecdf, xc, 20);
hold on;
xlabel('P');
ylabel('f');

[f_ks1,xi1,u1] = ksdensity(p);
plot(xi1,f_ks1,'r','linewidth',2);

legend('频率直方图', '核密度估计图', 'Location','NorthWest')
