function [v, p] = wind_power_output(N)
%% ���ؿ���ģ��������
% ����ģ�ͣ�weibull�ֲ�
% ����-�������ԣ�������١�����١��г����ٵķֶκ���

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

%% ��ͼ
% figure;
% [a, b] = hist(p);
% bar(b, a/sum(a));
% xlabel('G����������ֵ��');  % ΪX��ӱ�ǩ
% ylabel('p�����ʣ�');  % ΪY��ӱ�ǩ

end
  