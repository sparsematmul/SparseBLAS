power = [0.822 0.564 1.006 0 0.235; 0.690 0.248 0 0.056 0.061];
util = [56 62 98; 43 91 138];
algos = {'Normal'; 'CSR'};

figure(1);
bar(power,'stacked');
title('Non-I/O power for different implementations');
ylabel('Avg Power/W');
set(gca,'xtick',[1:2],'xticklabel',algos);
legend({'Signals','Logic','DSP', 'BRAM', 'Static'}, 'Location', 'northwest');
reorderLegend([1,2,3,4,5]);

figure(2);
bar(util,'stacked');
title('Utilization for different implementations');
ylabel('Number of resources');
set(gca,'xtick',[1:2],'xticklabel',algos);
legend({'Slice Registers','LUTs','Others'}, 'Location', 'northwest');
reorderLegend([1,2,3]);