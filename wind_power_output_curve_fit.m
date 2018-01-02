%% 风电出力曲线拟合，其中风电出力数据基于风速威布尔分布产生
clear;
v = wblrnd(8,2,1,100000);
vci = 3.5;
vr = 13;
vco = 30;

p = [];
for i = 1:1000
    if v(i) > vci && v(i) < vr
        p(i) = ((v(i)^3 - vci^3)/(vr^3-vci^3));
    elseif vr <= v(i) && v(i) <= vco
        p(i) = 1;
    else
        p(i) = 0;
    end
end

%% 作图，概率密度
% 调用ecdf函数计算xc处的经验分布函数值f_ecdf
[f_ecdf, xc] = ecdf(p);
% 新建图形窗口，然后绘制频率直方图，直方图对应7个小区间
figure;
ecdfhist(f_ecdf, xc, 97);
hold on;
xlabel('x');  % 为X轴加标签
ylabel('f(x)');  % 为Y轴加标签

% 调用ksdensity函数进行核密度估计
[f_ks1,xi1,u1] = ksdensity(p);
% 绘制核密度估计图，并设置线条为红色实线，线宽为3
plot(xi1,f_ks1,'r','linewidth',2);

ms = mean(p);  % 计算x的平均值
ss = std(p);  % 计算x的标准差
% 计算xi1处的正态分布密度函数值，正态分布的均值为ms，标准差为ss
f_norm = normpdf(xi1,ms,ss); 
% 绘制正态分布密度函数图，并设置线条为红色点划线，线宽为3
plot(xi1,f_norm,'k-.','linewidth',2)

% 为图形加标注框，标注框的位置在坐标系的左上角
legend('频率直方图','核密度估计图', '正态分布密度图', 'Location','NorthWest')

%% 作图 累积分布
figure;
hold on;
xlabel('x');  % 为X轴加标签
ylabel('f(x)');  % 为Y轴加标签

% 调用ksdensity函数进行核密度估计
[f_ks2,xi2,u2] = ksdensity(p, 'function', 'cdf');
% 绘制核密度估计图，并设置线条为黑色实线，线宽为3
plot(xi2,f_ks2,'r','linewidth',2)

ms2 = mean(p);  % 计算x的平均值
ss2 = std(p);  % 计算x的标准差
% 计算xi2处的正态分布密度函数值，正态分布的均值为ms，标准差为ss
f_norm = normcdf(xi2,ms2,ss2); 
% 绘制正态分布密度函数图，并设置线条为红色点划线，线宽为3
plot(xi2,f_norm,'k-.','linewidth',2)

% 为图形加标注框，标注框的位置在坐标系的左上角
legend('核密度估计图', '正态分布密度图', 'Location','NorthWest')

