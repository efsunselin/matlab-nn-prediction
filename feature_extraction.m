  subplot(2,1,1);
            data{1} = T2;
            t{1} = 'Original Data';
            PlotData(data,'Time (min)','Utilization (%)',t,'MEM1',1,1);
            subplot(2,1,2);
            data{1} = app2;
            t{1} = 'DWT';
            PlotData(data,'Time (min)','Utilization (%)',t,'MEM1',1,1);   