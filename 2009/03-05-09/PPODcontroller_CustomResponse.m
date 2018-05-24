function handles = PPODcontroller_CustomResponse(handles)

platesignals = handles.globalinfo.platesignals;
rawplatesignals = handles.globalinfo.rawplatesignals;
controlsignals = handles.globalinfo.controlsignals;

N = handles.daqinfo.cycles_per_update;
Na = handles.daqinfo.num_transient_cycles;
Nb = handles.daqinfo.num_collected_cycles;
Nc = handles.daqinfo.num_processing_cycles;
maxupdates = handles.globalinfo.maxupdates;

samples_per_cycle = handles.controllerinfo.samples_per_cycle;
basefreq = handles.controllerinfo.basefreq;

%get matrix converting L to W to frame
A = handles.signalinfo.A;

%specify how many samples to collect upon trigger
handles.daqinfo.ai.SamplesPerTrigger = Nb*samples_per_cycle;

controllerupdates_per_plot = 1;

%get u signals
u = handles.signalinfo.u;

%fft Nb cycles of u
u_fft = fft(repmat(u,[Nb,1]));

%create N cycles of u.
u_ao = repmat(u ,[N,1]);

%create clock ao signal with trigger just before cycle Na
clock = 0*u_ao(:,1);
clock(Na*samples_per_cycle) = 5;

%put u_ao_init and clock_init into the queue
putdata(handles.daqinfo.ao, [clock u_ao])

%start analog intput device (set to log during trigger event and then stops
%once data has been logged)
start(handles.daqinfo.ai)

%start analog output device (sends out data immediately)
start(handles.daqinfo.ao)

controllerupdates = 0;
set(handles.controllerupdates,'string',num2str(controllerupdates))

while controllerupdates < maxupdates && get(handles.run,'value')
    %wait for data to be collected from analog input (the device stops once
    %the data is logged)
    
    %make sure there are still samples left in queue for ao to output. if
    %there are no more samples then the ao device will be "off" and must be restarted.
    if get(handles.daqinfo.ao,'samplesavailable') < samples_per_cycle*(Nb+Nc)
        inloop = get(handles.daqinfo.ao,'running')%%%
        putdata(handles.daqinfo.ao, [clock u_ao])
        if strcmp(get(handles.daqinfo.ao,'Running'), 'off')
            start(handles.daqinfo.ao)
        end
    end
    get(handles.daqinfo.ao,'samplesavailable')%%%
    afterloop = get(handles.daqinfo.ao,'running')%%%
    
    %wait for data to be collected from analog input (the device stops once
    %the data is logged)
    wait(handles.daqinfo.ai,2) %HARD CODED WAIT TIME--MODIFY???

    %import Nb cycles of accelerometer signals.  columns of aidata
    %correspond to ai_channel_names (i.e., sp1, sp2, sp3, sp4, x1dd, y1dd,
    %x2dd, y2dd, etc)
    V_per_ms2 = .01; %volts per m/s^2
    V_per_ms2 = .0065; %volts per m/s^2
    aidata = 1/V_per_ms2*getdata(handles.daqinfo.ai);

    %subtract offset from data due to accelerometer bias
    aidata = aidata - repmat(mean(aidata),[size(aidata,1),1]);

    %put aidata into signal matrices
    y_raw_ai = aidata(:,1:numel(rawplatesignals));

    %convert raw acceleration signals in local frames into plate
    %acceleration in W frame
    y_ai =A\y_raw_ai';
    y_ai = y_ai'; %put y_ai back into format where each signal is a column

    %fft y_ai
    y_fft = fft(y_ai);
    
    %check to make sure that u does not exceed saturation voltage.  on
    %indices where it does, replace those voltages with +/-saturation
    %voltage
    signu = sign(u);
    saturation = handles.controllerinfo.saturation*ones(size(u));
    ind = find(abs(u) > saturation);
    u(ind) = signu(ind).*saturation(ind);

    %make N cycles of u to send to analog out.
    u_ao = repmat(u,[N,1]);

    %put new u_ao into queue
    putdata(handles.daqinfo.ao, [clock u_ao])

    %restart analog input device
    start(handles.daqinfo.ai)

    %put signals back into handles
    handles.signalinfo.y = y_ai(1:samples_per_cycle,:);
    handles.signalinfo.y_raw = y_raw_ai(1:samples_per_cycle,:);
    handles.signalinfo.u = u;

    %plot data in GUI
    if mod(controllerupdates,controllerupdates_per_plot) == 0
        PlotControls_CustomResponse(handles)
        PlotPlate_CustomResponse(handles)
    end
    controllerupdates = controllerupdates + 1;
    handles.globalinfo.controllerupdates = controllerupdates;
    set(handles.controllerupdates,'string',num2str(controllerupdates))
end

stop(handles.daqinfo.ai)
stop(handles.daqinfo.ao)

set(handles.run,'value',0,'string','Run')


