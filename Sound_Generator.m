
 % sound function --> sound(signal,sample rate, bits per sample)

%We will use two for loops to perform function , we will write it right now
%function [f_1,f_2,f_3,f_4,f_5,f_6,f_7] = testsound(min_dB,max_dB,time)

min_dB = 0;
max_dB = 15;
time = 1;

gain = min_dB:max_dB;
fs = 20500;  % sampling frequency
duration = time;

frequencies_tested = [125,250,500,1000,2000,4000,8000];
for i = 1:length(frequencies_tested)
    testing = frequencies_tested(i);
    values=0:1/fs:duration;
    
    for j = 1:length(gain)
        amp = gain(j);
        a = amp*sin(2*pi*testing*values);
        X = mag2db(a)
        print(X)
        sound(a,fs);
        pause(1)
    end
end


        
        
    

