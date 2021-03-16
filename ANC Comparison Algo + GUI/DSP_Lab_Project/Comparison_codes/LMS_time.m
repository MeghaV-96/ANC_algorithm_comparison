%% Initialization
clear all;
close all;
clc;
%% Read audio signal from file
tic
disp('Recording....');
[d,Fs] = audioread('author.wav'); % Loading of input signal
disp('Playing uncorrupted sound');
sound(d,Fs); %Plays the uncorrupted sound
pause(5);

%% normalization of the signal
d = d / rms(d, 1);                
% length of the signal
sg_len = length(d);                   
t=(1:sg_len)';
%% creating White Gaussian Noise

reference_signal = wgn(sg_len,1,10); % white gaussian noise with the length of the input signal

%% designing digital filter
 % maximum no.of delay elements
order = 4;      
% designing a FIR filter for adjusting weigts
fir_fil = fir1(order, 0.6);              
% filtering the reference signal
u = filter(fir_fil, 1, reference_signal);       
%% adding noise to the recorded signal

% signal to be filtered
noise_added_signal = d + u;  
disp('Playing noisy sound');
soundsc(noise_added_signal, Fs)

pause(5);
%% LMS ALgorithm for calculating weights
mu = 0.0003;     
%length of noised_signal signal
n = length(noise_added_signal);  
%initializing vectors
w = zeros(order,1);      
E = zeros(1,sg_len);
for k = order:n
 U = u(k-(order-1):k);
 % preliminary output signal 
 y = U'*w;                
 % error
 E(k) = noise_added_signal(k)-y; 
 % calculating LMS fiter weights
 w = w + mu*E(k)*U;       
end
toc;

%% PLAY FILTERED SIGNAL(OUTPUT)
soundsc(E,Fs)
pause(5);

%% Saving data file to PC
%e_lms = E;
%save('C:\Users\Megha Veerendra\Desktop\DSP_Lab\Project\data_lms.mat','d','e_lms','noised_signal');

%% Note: 
%The Elapsed time displayed at the end of the code is different from
%%that in the report because pauses have been added in order to ensure that
%%the sounds playing don't overlap. Commenting out the pause will give the
%%same results as that generated in the report.
