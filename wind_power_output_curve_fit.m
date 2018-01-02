%% ������������ϣ����з��������ݻ��ڷ����������ֲ�����
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

%% ��ͼ�������ܶ�
% ����ecdf��������xc���ľ���ֲ�����ֵf_ecdf
[f_ecdf, xc] = ecdf(p);
% �½�ͼ�δ��ڣ�Ȼ�����Ƶ��ֱ��ͼ��ֱ��ͼ��Ӧ7��С����
figure;
ecdfhist(f_ecdf, xc, 97);
hold on;
xlabel('x');  % ΪX��ӱ�ǩ
ylabel('f(x)');  % ΪY��ӱ�ǩ

% ����ksdensity�������к��ܶȹ���
[f_ks1,xi1,u1] = ksdensity(p);
% ���ƺ��ܶȹ���ͼ������������Ϊ��ɫʵ�ߣ��߿�Ϊ3
plot(xi1,f_ks1,'r','linewidth',2);

ms = mean(p);  % ����x��ƽ��ֵ
ss = std(p);  % ����x�ı�׼��
% ����xi1������̬�ֲ��ܶȺ���ֵ����̬�ֲ��ľ�ֵΪms����׼��Ϊss
f_norm = normpdf(xi1,ms,ss); 
% ������̬�ֲ��ܶȺ���ͼ������������Ϊ��ɫ�㻮�ߣ��߿�Ϊ3
plot(xi1,f_norm,'k-.','linewidth',2)

% Ϊͼ�μӱ�ע�򣬱�ע���λ��������ϵ�����Ͻ�
legend('Ƶ��ֱ��ͼ','���ܶȹ���ͼ', '��̬�ֲ��ܶ�ͼ', 'Location','NorthWest')

%% ��ͼ �ۻ��ֲ�
figure;
hold on;
xlabel('x');  % ΪX��ӱ�ǩ
ylabel('f(x)');  % ΪY��ӱ�ǩ

% ����ksdensity�������к��ܶȹ���
[f_ks2,xi2,u2] = ksdensity(p, 'function', 'cdf');
% ���ƺ��ܶȹ���ͼ������������Ϊ��ɫʵ�ߣ��߿�Ϊ3
plot(xi2,f_ks2,'r','linewidth',2)

ms2 = mean(p);  % ����x��ƽ��ֵ
ss2 = std(p);  % ����x�ı�׼��
% ����xi2������̬�ֲ��ܶȺ���ֵ����̬�ֲ��ľ�ֵΪms����׼��Ϊss
f_norm = normcdf(xi2,ms2,ss2); 
% ������̬�ֲ��ܶȺ���ͼ������������Ϊ��ɫ�㻮�ߣ��߿�Ϊ3
plot(xi2,f_norm,'k-.','linewidth',2)

% Ϊͼ�μӱ�ע�򣬱�ע���λ��������ϵ�����Ͻ�
legend('���ܶȹ���ͼ', '��̬�ֲ��ܶ�ͼ', 'Location','NorthWest')

