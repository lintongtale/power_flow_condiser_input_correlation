function [v, p] = wind_power_output(N)
%% 蒙特卡洛模拟风机出力
% 风速模型：weibull分布
% 风速-功率特性：切入风速、额定风速、切出风速的分段函数

Ntime = N;
% Ntime = 1000;
v = wblrnd(8,2,1,Ntime);
vci = 3.5;
vr = 13;
vco = 30;
p = [];

for i = 1:Ntime
    if v(i) > 3 && v(i) < 14.34
        p(i) = -0.00017172 * v(i)^7 + 0.010832 * v(i)^6 ...
            -0.25304 * v(i)^5 + 2.65814 * v(i)^4 ...
            -12.75459 * v(i)^3 + 38.59397 * v(i)^2 ...
            -44.89076 * v(i) + 11.33231;
    elseif 14.34 <= v(i) && v(i) <= 20
        p(i) = 1425;
    else
        p(i) = 0;
    end
end

p = p/10;

%% 作图
% figure;
% [a, b] = hist(p);
% bar(b, a/sum(a));
% xlabel('G（出力标幺值）');  % 为X轴加标签
% ylabel('p（概率）');  % 为Y轴加标签

end
  