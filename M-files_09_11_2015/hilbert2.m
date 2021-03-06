function [filt_signal]=hilbert2(input, sampling_rate, lower_bound, upper_bound, tm_OR_fr)
%  [filt_signal]=hilbert(input, sampling_rate, lower_bound, upper_bound, tm_OR_fr)
%     input         - input signal to be filtered (time or frequency domain)
%     sampling_rate - signal's sampling rate
%     lower_bound     - lower frequency bound for bandpass filtering
%     upper_bound   - upper frequency bound for bandpass filtering
%     tm_OR_fr      - 1 if the input signal is in the time domain, 0 if it
%                     is in the frequency domain
%
%  The function returns the filtered signal (low->high) in the time domain
%
    if (nargin<5)
        tm_OR_fr=1;
    end
    if (nargin<4)
        error('Please enter at least 4 arguments');
    end

    max_freq=sampling_rate/2;
    df=2*max_freq/length(input);
    centre_freq=(upper_bound+lower_bound)/2;
    filter_width=upper_bound-lower_bound;
    x=0:df:max_freq;
    gauss=exp(-(x-centre_freq).^2);
    %gauss=(sign(gauss-0.5)+1)/2;
    
    cnt_gauss = round(centre_freq/df);
	flat_padd = round(filter_width/df);  % flat padding at the max value of the gaussian
	padd_left = floor(flat_padd/2);
	padd_right = ceil(flat_padd/2);
    
	our_wind = [gauss((padd_left+1):cnt_gauss) ones(1,flat_padd) gauss((cnt_gauss+1):(end-padd_right))];
    our_wind=[our_wind zeros(1,length(input)-length(our_wind))];
    if (tm_OR_fr==1)
        input=fft(input,[],2);
	end        
    our_wind = repmat(our_wind,size(input,1),1);
    %figure
    %plot(input.*our_wind,'c')
    filt_signal=ifft(input.*our_wind,[],2);
    
    %size(input)
    %size(filt_signal)
    %size(our_wind)
    
%     figure(10)
%     subplot(5,1,1)
%     plot(real(input))
%     hold on
%     subplot(5,1,2)
%     plot(our_wind*100000,'r.-')
%     hold off
%     subplot(5,1,3)
%     %plot(abs(fft(our_wind)))
%     hold on
%     plot((real(filt_signal)))
%     subplot(5,1,4)
%     plot(abs(real(filt_signal)))
%     subplot(5,1,5)
%     plot(abs(filt_signal))
end
    
    

