%% create the base waves

x = [-3:.1:3];
norm = normpdf(x,0,1);

n1 = [zeros(1,100) norm zeros(1,100)];
n2 = [zeros(1,98) norm zeros(1,102)];
d = (n1-n2)*4;

plot(d)

%%  Analyze a bipolar wave 
m = zeros(100,length(d)+200);
for i = 1:100
    m(i,:) = [zeros(1,100-i) d zeros(1,100+i)];
end
avg = mean(m,1);
repavg = avg(ones(100,1),:);
removeavg = m-repavg;

figure
subplot(2,1,1)
plot(removeavg'), title('after subtraction of the average')
subplot(2,1,2)
plot(m'), title('single trials before subtraction of average')
hold on
plot(avg,'linewidth',2,'color','k')


%%  analyze a monopolar wave (gaussian)
jit = 25;
m = zeros(jit,length(n1)+200);
for i = 1:jit
    m(i,:) = [zeros(1,100-i) n1 zeros(1,100+i)]*rand;
end
avg = mean(m,1);
repavg = avg(ones(jit,1),:);
removeavg = m-repavg;
figure
subplot(2,1,1)
plot(removeavg'), title('after subtreaction of the average')
subplot(2,1,2)
plot(m'), title('single trials before subtraction of average')
hold on
plot(avg,'linewidth',2,'color','k')
