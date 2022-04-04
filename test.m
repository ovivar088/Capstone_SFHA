user_hearing = hearing_test()
[freqs, thresholds_left, thresholds_right, offset, marginfactor, rolloff, center, focus] = params(user_hearing)
[gt_data, gt_freqs, gt_levels] = prescription_minimalistic(freqs, thresholds_left, thresholds_right, offset, marginfactor, rolloff, center, focus)



function [freqs, thresholds_left, thresholds_right, offset, marginfactor, rolloff, center, focus] = params(response_db)

freqs = [125,250,500,1000,2000,4000,8000];
thresholds_init  = response_db; % dB SPL for user
normal_threshold = [ 33  24  13    5   13   15   14    11]; % Estimated

offsetslider=0;
rolloffslider=0;
marginfactorslider=0;
centerslider=0;
focusslider=0;

offset = 30+30.*(0.5-offsetslider);
rolloff = 1+2.^-(rolloffslider.*3);
marginfactor = marginfactorslider;
center = 50+centerslider.*40;
focus = round(focusslider.*100)./10;

thresholds_left = zeros(size(freqs));
thresholds_left = response_db;
thresholds_right = zeros(size(freqs));
thresholds_right = response_db;

end


function [gt_data, gt_freqs, gt_levels] = prescription_minimalistic(freqs, thresholds_left, thresholds_right, offset, marginfactor, rolloff, center, focus)
  gt_freqs = [177 297 500 841 1414 2378 4000 6727 11314];
  gt_levels = -10:1:110;
  reference_freqs  = [125 250 500 1000 2000 4000 8000 16000];
  reference_levels = abs(polyval([focus 0],log2(reference_freqs./1000)))+offset;
  thresholds_left_ext = [0 0 thresholds_left 0 0];
  thresholds_right_ext = [0 0 thresholds_right 0 0];
  freqs_ext = [0 50 freqs 16000 48000];
  gt_data_left = zeros(length(gt_levels),length(gt_freqs));
  gt_data_right = zeros(length(gt_levels),length(gt_freqs));
  maxgain = 40;
  maxlevel = 110;
  for i=1:length(gt_freqs)
    reference_level = interp1(reference_freqs,reference_levels,gt_freqs(i),'extrap');
    threshold_level_left = interp1(freqs_ext,thresholds_left_ext,gt_freqs(i),'extrap');
    threshold_level_right = interp1(freqs_ext,thresholds_right_ext,gt_freqs(i),'extrap');
    low_level_gain_left = max(0,threshold_level_left-reference_level);
    low_level_gain_right = max(0,threshold_level_right-reference_level);
    margin_left = marginfactor.*(center-(reference_level+low_level_gain_left));
    margin_right = marginfactor.*(center-(reference_level+low_level_gain_right));
    gt_data_left(:,i) = interp1([gt_levels(1);reference_level+margin_left;reference_level+margin_left+low_level_gain_left.*rolloff;gt_levels(end)],[low_level_gain_left;low_level_gain_left;0;0],gt_levels);
    gt_data_right(:,i) = interp1([gt_levels(1);reference_level+margin_right;reference_level+margin_right+low_level_gain_right.*rolloff;gt_levels(end)],[low_level_gain_right;low_level_gain_right;0;0],gt_levels);
  end
  gt_data = [gt_data_left.';gt_data_right.'];
  gt_data = min(maxgain,gt_data);
  gt_data = gt_data + min(0,maxlevel - (gt_data+gt_levels));
end




function response_db = hearing_test()

freqs = [125,250,500,1000,2000,4000,8000];
amps = 10./(10.^((3/20)*(0:25)));

fprintf('Debug - check amp array: %f', length(amps));

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
                response(f) = amps(a);
                break; 
            end
    end
end

%dB
for i = 1:length(response)
    response_db(i) = mag2db(response(i));
end


end

function tone(w,amp)

fs=40000;  %sample freq in Hz

t = [0:1/fs:.5]; 


wave=amp*sin(2*pi*w*t); 
envelope = sin(pi*t/t(length(t)));

wave = wave .* envelope;


    
%play sound
sound(wave,fs);

end