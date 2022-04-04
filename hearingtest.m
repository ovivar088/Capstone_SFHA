user_hearing = hearing_test()
function response_db = hearing_test()


freqs = [125,250,500,1000,2000,4000,8000];
amps = 10./(10.^((3/20)*(0:25)));

fprintf('Info you are trying to print: %f', length(amps));

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


    
%play soun
sound(wave,fs);

end