function gt_data_update = testvasu()
function response_db = hearing_test()

freqs = [125,250,500,1000,2000,4000,8000];
dbarray = [105 99 90 85 82 78 75 72 70 67 64 61 58 55 52 49 47 45 42 39 36 33 30 28 26];
amps = 1*ones(1,25);

for i=2:25
    amps(i)=amps(i-1)/(sqrt(10)^1); %dbfunc
end

% fprintf('%f', amps);

response = zeros(1,7);

for f = 1:length(freqs)    
    for a = 1:length(amps)

        pause(1)
        
        tone(freqs(f),amps(a))
             
        heard = input('Did you hear that, Y/N:','s');
            if(heard == "Y" || heard == "y")
                response(f)=a;
                %break;
            end
        
            if(heard == "N" || heard == "n") 
                response(f) = dbarray(a);
                break; 
            end
    end
end

%dB
for i = 1:length(response)
    response_db(i) = (response(i));
end

fprintf('%f', response_db);

end

function tone(w,amp)

Fs = 96000;
duration = 2.0;

numberOfSamples = Fs * duration;
samples = (1:numberOfSamples) / Fs;
% wave = 0.5*sin(2 * pi * w * samples);
wave = amp*sin(2 * pi * w * samples);

   
%play sound
sound(wave,Fs);

end

% BUFFER FUNCTION
function [freqs, thresholds_right, normal_threshold, marginfactor] = params(response_db)

freqs = [125,250,500,1000,2000,4000,8000]; % re-establish frequencies we tested
normal_threshold = [ 33  24  13    5   13   15   14    11]; % Estimated normal human hearing response

marginfactor = 0; % will use this later but dw abt this for now

thresholds_right = zeros(size(freqs)); % initialize an array
thresholds_right = response_db; % pass in hearing test results to our new array

end



% PRESCRIPTION FUNCTION TO USE
function [gt_data, gt_freqs, gt_levels] = prescription_minimalistic(freqs, thresholds_right, normal_threshold, marginfactor)

    % Establish frequencies and all levels
    gt_freqs = [177 297 500 841 1414 2378 4000 6727 11314];
    gt_levels = -10:1:110; % ?
    
    % Populate required arrays

    gt_data = zeros(25,25);
  
    freqs177 = zeros(1,25) + (thresholds_right(1)-normal_threshold(1));
    freqs297 = zeros(1,25) + (thresholds_right(1)-normal_threshold(1));
    freqs500 = zeros(1,25) + (thresholds_right(2)-normal_threshold(2));
    freqs841 = zeros(1,25) + (thresholds_right(3)-normal_threshold(3));
    freqs1414 = zeros(1,25) + (thresholds_right(4)-normal_threshold(4));
    freqs2378 = zeros(1,25) + (thresholds_right(5)-normal_threshold(5));
    freqs4000 = zeros(1,25) + (thresholds_right(6)-normal_threshold(6));
    freqs6727 = zeros(1,25) + (thresholds_right(7)-normal_threshold(7));
    freqs11314 = zeros(1,25) + (thresholds_right(7)-normal_threshold(7));
    

    gt_data = vertcat(freqs177,freqs297,freqs500,freqs841,freqs1414,freqs2378,freqs4000,freqs6727,freqs11314);
    gt_data_update = kron(gt_data,[1;1]);
    gt_data_update = max(gt_data_update,0)
    
    
    % fprintf('%f', gt_data)
    fid = fopen('outputData.txt','wt');
    for i = 1:18
        for j = 1:25
        fprintf(fid,'%.8f', gt_data_update(i,j));
        fprintf(fid,' ');
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
end

user_hearing = hearing_test();
%user_hearing = [30,30,30,30,30,30,30] %PUT YOUR VALUES HERE

% Here we pass the results of the user hearing test to the buffer function
[freqs, thresholds_right, normal_threshold, marginfactor]=params(user_hearing)

% Here we pass all the output vars from the buffer function into the basic
% prescription
[gt_data, gt_freqs, gt_levels] = prescription_minimalistic(freqs, thresholds_right, normal_threshold, marginfactor)

















 





































end
