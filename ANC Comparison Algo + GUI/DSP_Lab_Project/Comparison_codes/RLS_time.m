%Implementation of RLS Adaptive Filter
clc;
clear all;

%% Read Audio signal from file
tic
disp('Recording....');
[d,Fs] = audioread('author.wav'); % Loading of input signal
disp('Playing uncorrupted sound');
sound(d,Fs); %Plays the uncorrupted sound
pause(5);
%% Noise is added to the uncorrupted signal. 
noise = wgn(length(d),1,10); % A gussian noise of power 10dbw is added to the audio input inorder to corrupt it
x = d + noise; % Uncorrupted sound + noise
disp('Playing corrupted sound');
sound(x,Fs,bits_per_sample) %Playing the corrupted sound
pause(5);
%% RLS Filter Implementation
%% Parameter List
% d - Reference signal
% x - Noissy signal
% lamda - Forgetting factor
% delta - Large positive quantity
% Rn - Covariance Matrix
%%
M = 4; % Length of FIR Filter
w = zeros(M,1); %Initialize filter weights to zero
delta = 100; %Large positive constant
Rn = eye(M)*delta; %Initialization of the covariance matrix
y = zeros(length(d),1); %output signal
error = zeros(length(d),1); % error signal
lambda = 0.999; %Forgetting factor

%x_ = zeros(length(d),1);

%Implementation of the rls Algorithm
for i = 1 : length( d )
f( 1 : i ) = flipud( x( 1 : i ) );     %Filtering operation
 if length( f ) < M 
 f( i + 1 : M, 1 ) = 0;
 elseif length( f ) > M            
 f = f( 1 : M );
 end 
K = ( Rn * f ) ./ ( lambda + (f' * Rn * f )); %Kalman Gain matrix
e( i ) = d( i ) - (f' * w); %error
w= w + (K * e( i ));%updation of weights
Rn     = ( lambda^-1 * Rn ) - ( lambda^-1 * K * f' * Rn ); % updating covariance matrix
end
%Filtered sound
disp('Playing Filtered sound');
sound(e,Fs);
pause(5);

%% Saving data file to pc
%e_rls = e;
%save('C:\Users\Megha Veerendra\Desktop\DSP_Lab\Project\data_rls.mat','e_rls');
toc

%% Note: 
%The Elapsed time displayed at the end of the code is different from
%%that in the report because pauses have been added in order to ensure that
%%the sounds playing don't overlap. Commenting out the pause will give the
%%same results as that generated in the report.