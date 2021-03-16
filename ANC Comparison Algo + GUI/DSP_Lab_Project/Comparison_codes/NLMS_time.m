%NLMS Algo
clc;
clear all;
%% Read Audio Signal from file
tic
disp('Recording....');
[d,Fs] = audioread('author.wav'); % Loading of input signal
disp('Playing uncorrupted sound');
sound(d,Fs); %Plays the uncorrupted sound
pause(5);
%% normalization of the signal
data = data / rms(data, 1);                

%% corrupting Audio Signal with noise
% filter length
M = 4; 
% designing a FIR filter for adjusting weights
FIR_fil = fir1(M, 0.6);              

% noise is added to the audio input to corrupt it
noise = wgn(length(data),1,10); 
% noise is added to the uncorrupted signal. 
noise_added_signal = data + noise; 
u = filter(FIR_fil, 1, noise_added_signal);
disp('Playing corrupted sound');
sound(noise_added_signal,Fs,bits_per_sample); %Playing the corrupted sound
pause(6);

%% NLMS parameters
% Step size
mu = 0.0003; 
% bias 
epsilon = 0.1; 
w = zeros(M,1);

for i = M:length(noise_added_signal)
 U = u(i-(M-1):i);
 % difference between LMS and NLMS
 K = mu/(abs(epsilon+(data(i)^2))); 
 % preliminary output signal
 y = U'*w;         
 % error
 E(i) = data(i)-y;     
 % cal NLMS fiter weights
 w = w + K*E(i)*U;       
end

disp('Filtered Signal');
sound(E,Fs);
pause(6);
e_nlms = E;
toc
%% Saving data file to PC
%e_lms = E;
%save('C:\Users\Megha Veerendra\Desktop\DSP_Lab\Project\data_lms.mat','d','e_lms','noised_signal');

%% Note: 
%The Elapsed time displayed at the end of the code is different from
%%that in the report because pauses have been added in order to ensure that
%%the sounds playing don't overlap. Commenting out the pause will give the
%%same results as that generated in the report.
