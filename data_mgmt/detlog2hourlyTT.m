%%%% JPE 2024 05 29 %%%%
% Nina's Pinniped Thesis: Turning detlogs into hourly presence timetables
% For analysis of Walrus & Bearded Seal Presence in Nunatsiavut


% Path to your log
DBpath = 'H:\Shared drives\SWAL_Arctic\Research_projects\Nina_pinnipeds\Interns\detLogs\calibration'; % path t
% Name of your log
filename = 'NUNAT_SB03_EbOr_NF.xlsx'; %name of the log

datapath = fullfile(DBpath,'\',filename);

% Read data from Excel file
datatmp = readtable(datapath);

data = table(datatmp.Var5, datatmp.Var6, datatmp.Var3, datatmp.Var4, ...
    'VariableNames', {'start', 'stop', 'species', 'call_type'});

% Convert start and end times to datetime
data.start = datetime(data.start, 'InputFormat', 'dd/MMM/yyyy HH:mm:ss.S');
data.stop = datetime(data.stop, 'InputFormat', 'dd/MMM/yyyy HH:mm:ss.S');

% Define the desired start and end times for the timetable
startTime = datetime(2023, 1, 14, 0, 0, 0);
stopTime = datetime(2023, 1, 20, 23, 59, 59);

% Create an hourly time vector
timeVector = startTime:hours(1):stopTime;

% Initialize presence array
EbPres = zeros(length(timeVector), 1);
OrPres = zeros(length(timeVector), 1);

% Check each call if it falls within each hour
for i = 1:height(data)
    callStart = data.start(i);
    callEnd = data.stop(i);
    species = data.species{i};
    for j = 1:length(timeVector)-1
        if callStart < timeVector(j+1) && callEnd >= timeVector(j)
            if species == 'Or'
            OrPres(j) = 1;
            elseif species == 'Eb'
                EbPres(j) = 1;
        end
    end
    end
end

% Create timetable
pinnePresTT = timetable(timeVector', EbPres, OrPres);

%%% SAVE HOWEVER U WANT <3
