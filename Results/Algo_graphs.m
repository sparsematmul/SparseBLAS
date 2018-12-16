power = [5.61 4.36 4.28; 7.56 4.47 4.28; 6.32 4.45 4.28; 4.42 3.97 4.74; 5.44 4.19 4.39; 7.32 5.06 4.46];
energy = [0.9 0.7 0.69; 1.02 0.6 0.58; 0.25 0.18 0.17; 0.00136 0.00122 0.00146; 0.00936 0.00721 0.00343; 0.01 0.00896 0.01104];
exectime = [50.876 50.298 75.92 0.247 20 1.159];
snipetime = [391.83 464.05 123.53 1.27 5.39 9.07];
algos = {'Normal'; 'KIJ'; 'Tiled'; 'CSR'; 'SparseBLAS'; 'Eigen'};

figure(1);
bar(power,'stacked');
title('Average power for different algorithms');
ylabel('Avg Power/W');
set(gca,'xtick',[1:6],'xticklabel',algos);
legend({'Core','Cache','Others'}, 'Location', 'northwest');
reorderLegend([1,2,3]);


figure(2);
bar(energy,'stacked');
title('Energy for different algorithms');
ylabel('Energy/J');
set(gca,'xtick',[1:6],'xticklabel',algos);
legend({'Core','Cache','Others'}, 'Location', 'northeast');
reorderLegend([1,2,3]);

figure(3);
plot(snipetime,'-bx');
title('Execution time for different algorithms');
ylabel('Execution time/s');
set(gca,'xtick',[1:6],'xticklabel',algos);
xlim([0 6]);
ylim([0 465]);