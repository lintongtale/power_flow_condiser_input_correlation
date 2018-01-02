function w = copula_arrary(A, B)
%% 生成Copula相关序列
% A, B均为1*N的数组

[Row, Ntime] = size(A);

p(1, :) = A;
p(2, :) = B;
p(1, :) = sort(p(1, :));
p(2, :) = sort(p(2, :));

% for m=1:2
%     s = 1;
%     for n=1:N
%         if p(m, n) < 1
%             pp(m, s) = p(m, n);
%             s = s + 1;
%         end
%     end
% end
pp = p;

u = copularnd('gaussian', 0.9, Ntime);

a = size(pp(1, :));
for i=1:2
    for j=1:a(2)
        if round(u(j, i) * Ntime) == 0
            w(j, i) = pp(i, 1);
        elseif round(u(j, i) * Ntime) <= a(2) && round(u(j, i) * Ntime) >= 1
            w(j, i) = pp(i, round(u(j, i) * Ntime));
        end
    end
end
