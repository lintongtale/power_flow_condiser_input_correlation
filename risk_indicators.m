%% �����������ָ��ֵ
clear;

% ���ۻ�
load U;
U = U/100;
load P;
Pin = abs(Pin);
% ��ȡ��·���Ȼ��ȼ���
load line_stability_limit;

% ���������ָ��
f_bus_overvoltage = [];
f_bus_critical_overvoltage = [];
f_line_light_load = [];
f_line_heavy_load = [];
f_line_overload = [];

% �������ض�ָ��
s_bus_overvoltage = [];
s_bus_critical_overvoltage = [];
s_line_light_load = [];
s_line_heavy_load = [];
s_line_overload = [];

% �ڵ�
for i=1:39
    % Խ�ޡ��ٽ�Խ�޸���ͳ��
    n_bus_overvoltage = 0;
    n_bus_critical_overvoltage = 0;
    % Խ�ޡ��ٽ�Խ��ƫ����ͳ��
    delta_bus_overvoltage = 0;
    delta_bus_critical_overvoltage = 0;
    for j=1:1000
        if U(i,j) > 1.1 || U(i,j) < 0.9
            n_bus_overvoltage = n_bus_overvoltage + 1;
            delta_bus_overvoltage = delta_bus_overvoltage + abs(U(i,j) - 1);
        elseif (U(i,j) < 0.95 && U(i,j) > 0.9) || (U(i,j) < 1.1 && U(i,j) > 1.05)
             n_bus_critical_overvoltage = n_bus_critical_overvoltage + 1;
             delta_bus_critical_overvoltage = delta_bus_critical_overvoltage + abs(U(i,j) - 1);
        end
    end
    f_bus_overvoltage(i) = n_bus_overvoltage/1000;
    f_bus_critical_overvoltage(i) = n_bus_critical_overvoltage/1000;
    if n_bus_overvoltage == 0
        s_bus_overvoltage(i) = 0;
    else
        s_bus_overvoltage(i) = delta_bus_overvoltage/n_bus_overvoltage;
    end
    if n_bus_critical_overvoltage == 0
        s_bus_critical_overvoltage(i) = 0;
    else
        s_bus_critical_overvoltage(i) = delta_bus_critical_overvoltage/n_bus_critical_overvoltage;
    end
end
risk_indicator_f_bus_overvoltage = sum(f_bus_overvoltage)/39;
risk_indicator_f_bus_critical_overvoltage = sum(f_bus_critical_overvoltage)/39;
risk_indicator_s_bus_overvoltage = sum(s_bus_overvoltage)/39;
risk_indicator_s_bus_critical_overvoltage = sum(s_bus_critical_overvoltage)/39;

for i=1:46
    % ���ء����ء�Խ�޸���ͳ��
    n_line_light_load = 0;
    n_line_heavy_load = 0;
    n_line_overload = 0;
    % ���ء����ء�Խ��ƫ����ͳ��
    delta_line_light_load = 0;
    delta_line_heavy_load = 0;
    delta_line_overload = 0;
    for j=1:1000
        if Pin(i,j) < 0.3 * line_stability_limit(i)
            n_line_light_load = n_line_light_load + 1;
            delta_line_light_load = delta_line_light_load + abs(Pin(i,j) - line_stability_limit(i))/line_stability_limit(i);
        elseif Pin(i,j) > 0.8 * line_stability_limit(i) && Pin(i,j) < line_stability_limit(i)
            n_line_heavy_load = n_line_heavy_load +1;
            delta_line_heavy_load = delta_line_heavy_load + abs(Pin(i,j) - line_stability_limit(i))/line_stability_limit(i);
        elseif Pin(i,j) > line_stability_limit(i)
            n_line_overload = n_line_overload + 1;
            delta_line_overload = delta_line_overload + (Pin(i,j) - line_stability_limit(i))/line_stability_limit(i);
        end
    end
    f_line_light_load(i) = n_line_light_load/1000;
    f_line_heavy_load(i) = n_line_heavy_load/1000;
    f_line_overload(i) = n_line_overload/1000;
    if n_line_light_load == 0
        s_line_light_load(i) = 0;
    else
        s_line_light_load(i) = delta_line_light_load/n_line_light_load;
    end
    if n_line_heavy_load == 0
        s_line_heavy_load(i) = 0;
    else
        s_line_heavy_load(i) = delta_line_heavy_load/n_line_heavy_load;
    end
    if n_line_overload == 0
        s_line_overload(i) = 0;
    else
        s_line_overload(i) = delta_line_overload/n_line_overload;
    end
end
risk_indicator_f_line_light_load = sum(f_line_light_load)/46;
risk_indicator_f_line_heavy_load = sum(f_line_heavy_load)/46;
risk_indicator_f_line_overload = sum(f_line_overload)/46;
risk_indicator_s_line_light_load = sum(s_line_light_load)/46;
risk_indicator_s_line_heavy_load = sum(s_line_heavy_load)/46;
risk_indicator_s_line_overload = sum(s_line_overload)/46;

