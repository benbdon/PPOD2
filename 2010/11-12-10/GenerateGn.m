function handles = GenerateGn(handles)

F = handles.controllerinfo.F;
dt = handles.signalinfo.dt;

actuatorsignals = handles.globalinfo.actuatorsignals;
platesignals = handles.globalinfo.platesignals;
rawplatesignals = handles.globalinfo.rawplatesignals;
controlsignals = handles.globalinfo.controlsignals;

N = handles.daqinfo.cycles_per_update;
Na = handles.daqinfo.num_transient_cycles;
Nb = handles.daqinfo.num_collected_cycles;
Nc = handles.daqinfo.num_processing_cycles;

%initialize Gn, Gn_raw, and Gn_sp to be zero matrix of proper dimensions 
Gn = zeros(numel(platesignals), numel(controlsignals), numel(Gnfreqs));
Gn_raw = zeros(numel(rawplatesignals),numel(controlsignals),numel(Gnfreqs));
Gn_sp = zeros(numel(actuatorsignals),numel(controlsignals),numel(Gnfreqs));

%magnitude of control signal used for frequency response
input_mag = handles.controllerinfo.input_mag;

%get matrix converting L to W to frame
A = handles.signalinfo.A;

%j loops through  each frequency in Gnfreqs
%i loops through the 4 input (control) signals
for i = 1:numel(Gnfreqs)
    
    %update plateinfo
    basefreq = Gnfreqs(i);
    handles.plateinfo.basefreq = basefreq;
    w = 2*pi*basefreq;
    T = 1/basefreq;
    handles.plateinfo.T = T;
    t_all = 0:dt:T-dt;
    handles.plateinfo.t_all = t_all;
    samples_per_cycle = length(t_all);
    handles.plateinfo.samples_per_cycle = samples_per_cycle;

    %initialize desired plate motion
    d = zeros(samples_per_cycle, numel(platesignals));
    
    %specify how many samples to collect upon trigger
    handles.daqinfo.ai.SamplesPerTrigger = Nb*samples_per_cycle;

    %update plate motion panel in GUI
    set(handles.T,'string',char(sym(1/basefreq)))

    %update sampling panel in GUI
    set(handles.samples_per_cycle,'string',samples_per_cycle)


    for j = 1:numel(controlsignals)
        %initialize u and y signals to zero and proper length
        u = zeros(samples_per_cycle, numel(controlsignals));
        y = zeros(samples_per_cycle, numel(platesignals));
        y_sp = zeros(samples_per_cycle, numel(actuatorsignals));

        %set control signal of selected speaker to a sinusoid
        u(:,j) = input_mag*sin(w*t_all);

        %fft N2 cycles of u. 
        u_fft = fft(repmat(u,[Nb,1]));

        %create N cycles of u.
        u_ao = repmat(u,[N,1]);

        %create clock ao signal with trigger just before cycle Na
        clock = 0*u_ao(:,1);
        clock(Na*samples_per_cycle) = 5;
        cam_trig = 0*clock;
        
        %put u_ao_init and clock into the queue.  do not load queue
        %until previous control signal is finished
        while 1
            if strcmp(get(handles.daqinfo.ao,'Running'), 'Off')
                putdata(handles.daqinfo.ao, [clock, u_ao, cam_trig])
                break
            end
        end

        %start analog intput device (set to log during trigger event and then stops
        %once data has been logged)
        start(handles.daqinfo.ai)

        %start analog output device (sends out data immediately)
        start(handles.daqinfo.ao)

        %wait for trigger to indicate data has been collected
        wait(handles.daqinfo.ai,2) %HARD CODED WAIT TIME--MODIFY???

        %import Nb cycles of accelerometer signals.  columns of aidata
        %correspond to ai_channel_names (i.e., sp1, sp2, sp3, sp4, pl1x, pl1y,
        %pl2x, pl2y)
        V_per_ms2 = .01; %volts per m/s^2
        aidata = 1/V_per_ms2*getdata(handles.daqinfo.ai);

        %subtract offset from data due to accelerometer bias
        aidata = aidata - repmat(mean(aidata),[size(aidata,1),1]);
        
        %put aidata into signal matrices
        y_raw_ai = aidata(:,1:numel(rawplatesignals));
        y_sp_ai = aidata(:,numel(rawplatesignals)+1:end);

        %convert raw acceleration signals in local frames into plate
        %acceleration in W frame
        y_ai = A\y_raw_ai';
        y_ai = y_ai'; %put y_ai back into format where each signal is a column

        %fft y signals
        y_fft = fft(y_ai);
        y_sp_fft = fft(y_sp_ai);
        y_raw_fft = fft(y_raw_ai);

        %extract y, r_raw and y_sp
        y = y_ai(1:samples_per_cycle,:);
        y_raw = y_raw_ai(1:samples_per_cycle,:);
        y_sp = y_sp_ai(1:samples_per_cycle,:);
        
        handles.signalinfo.y = y;
        handles.signalinfo.y_raw = y_raw;
        handles.signalinfo.y_sp = y_sp;
        handles.signalinfo.u = u;
        handles.signalinfo.d = d;
        
        %construct Gn, Gn_raw, and Gn_sp
        ind = Nb+1; %index corresponding to Gnfreqs(i) in the fft
        Gn(:,j,i) = y_fft(ind,:)/u_fft(ind,j);
        Gn_raw(:,j,i) = y_raw_fft(ind,:)/u_fft(ind,j);
        if isempty(actuatorsignals)
            Gn_sp = zeros([],numel(controlsignals));
        else
            Gn_sp(:,j,i) = y_sp_fft(ind,:)/u_fft(ind,j);
        end
        
        %update speaker signals panel in GUI
        PlotControls(handles)

        %update plate signals panel in GUI
        PlotPlate(handles)

    end
end

handles.controllerinfo.Gn = Gn;
handles.controllerinfo.Gn_raw = Gn_raw;
handles.controllerinfo.Gn_sp = Gn_sp;

%save controllerinfo into controllerinfo.mat 
controllerinfo = handles.controllerinfo;
save([cd,'\SavedGn\controllerinfo'],'controllerinfo')

stop(handles.daqinfo.ai)
stop(handles.daqinfo.ao)