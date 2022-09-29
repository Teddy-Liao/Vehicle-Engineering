% 本代码由廖登廷制作，如有错误请在github提出issue，仅供学习交流使用
% Sept./09/2022
clear
clc

dv = 0.001;
Index = 1./dv;
v = 0:dv:200; % [m/s]
%% 空气阻力
CD = 0.35; %空气阻力系数
A = 2.026; %迎风面积
Fw = (CD .* A .* ((v.*3.6).^2))/21.15; % 注意：这个公式里速度的单位

%% 滚动阻力
M0 = 1095; %整备质量 [kg]
m0 = 70; %乘客质量[kg]
M = M0 + 2*m0;
g = 9.81;
G = M * g;
f = 0.013; %滚动阻力系数
Ff = f * G;
%% 驱动力 Ft
Ft(1,:) = -56.015*(v.^2)+933.116.*v+1847.069;
Ft(2,:) = -9.978*(v.^2)+295.415.*v+1039.277;
Ft(3,:) = -3.492*(v.^2)+146.717.*v+732.412;
Ft(4,:) = -1.493*(v.^2)+83.253.*v+551.715;
Ft(5,:) = -0.834*(v.^2)+56.478.*v+454.416;

vmin = [1.78 3.16 4.48 5.95 7.22]; %各档位怠速车速 [m/s]
vmax = [12.71 22.59 32.06 42.56 51.67]; %各档位最高车速 [m/s]

for i = 1:5
    figure(1) %驱动力图 Ft - v
    plot(v(vmin(i)*Index : vmax(i)*Index),Ft(i,vmin(i)*Index : vmax(i)*Index),'LineWidth',2);
    grid on
    hold on
    xlabel('$ v \, (m/s)$','Interpreter', 'latex')
    ylabel('$ Ft $','Interpreter', 'latex')
    title("驱动力图")
end

plot(v,Fw+Ff,'LineWidth',2)
xlim([0,50])

%% 加速度
ig(1) = 3.455;
ig(2) = 1.944;
ig(3) = 1.370; 
ig(4) = 1.032;
ig(5) = 0.850;
i0 = 3.941;

for i = 1:5
    delta(i) = 1 + 0.03 + 0.0017*((ig(i)*i0).^2);
    a(i,:) = (Ft(i,:) - Fw - Ff)./((delta(i)*M));
end

for i = 1:5
    figure(2) %加速度 a - v
    plot(v(vmin(i)*Index : vmax(i)*Index),a(i,vmin(i)*Index : vmax(i)*Index),'LineWidth',2);
    grid on
    hold on
    xlabel('$ v \, (m/s)$','Interpreter', 'latex')
    ylabel('$ a (m/s^2) $','Interpreter', 'latex')
    title("加速度图")
end

for i = 1:4
    figure(3) %加速度倒数 1/a - v
    plot(v(vmin(i)*Index : vmax(i)*Index),1./a(i,vmin(i)*Index : vmax(i)*Index),'LineWidth',2);
    grid on
    hold on
    xlabel('$ v \, (m/s)$','Interpreter', 'latex')
    ylabel('$ 1/a $','Interpreter', 'latex')
    title("1/a图")
end
plot(v(vmin(i)*Index : 45*Index),1./a(5,vmin(i)*Index : 45*Index),'LineWidth',2);
%% 计算 0 - 100 km/h 加速时间
t1 = trapz(v(vmin(1)*Index : vmax(1)*Index), 1./a(1,vmin(1)*Index : vmax(1)*Index))

t2 = trapz(v(vmax(1)*Index : vmax(2)*Index), 1./a(2,vmax(1)*Index : vmax(2)*Index))

t3 = trapz(v(vmax(2)*Index : 27.78*Index), 1./a(3,vmax(2)*Index : 27.78*Index))

%% 计算受限于驱动力的最大爬坡度
Temax = 150; %[Nm]
eta = 0.8;
r = 0.285; %[m]


betaAlpha = asind((Temax*ig(1)*i0*eta)./(G*r*sqrt(1+(f^2))));
beta = asind(f./(sqrt(1+(f^2))));
Alpha = betaAlpha - beta;
imax = tand(Alpha) %最大爬坡度

%% 计算最高档由怠速加速到120km/h的时间
t5 = trapz(v(13.89*Index : 33.33*Index), 1./a(5,13.89*Index : 33.33*Index))





