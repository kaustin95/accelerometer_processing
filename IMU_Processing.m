%% Basic processing of an biteplate/mouth based inertial measurment unit for head impact kinematics measurement
% Kieran Austin

% This script presents a basic processing of raw accelerometer and
% gyroscope signals to estimate head impact kinematics. This process is
% broken into four sections:

% 1. Data Import
% 2. Filtering of linear acceleration and gyroscope data
% 3. Deriving and filtering rotational acceleration
% 4. Transformation of linear acceleration to the head centre of mass

clear all
close all

%% Data Import
% Assumes Data is formatted in individual .csv files and saved within file
% directory. Data stored as cell array, with the assume column structure
% of column 1 = time; columns 2-5 rotational acceleration
% (x,y,z,resultant); columns 6-9 rotational velocity (x,y,z,resultant);
% columns 10-13 linear acceleration (x,y,z,resultant). Although rotational
% acceleration may be given, we will filter and derive ourselves.

files = dir(fullfile('*.csv'));

for i = 1:length(files)
    
    % Import 
    data = readmatrix(fullfile(files(i).name));

    % Assign to variables
    linear{i,1} = data(:,10:12);
    velocity{i,1} = data(:,6:8);

    clear data

end

clear i
%% Filtering of linear acceleration and gyroscope data
% Filter type, and cut off frequency of filter will likely be specific to system and
% individual impacts. Here, a representative 4th order low pass Butterworth
% filter with 200Hz cut off is used. 

fs = 3200; %sampling rate of sensor
cf = 200; %cut off frequency of filter

[b,a] = butter(4,cf/(fs/2));

% Loops through all trials and all axes of accelerometer and gyroscope
for i = 1:length(files)
    for ii = 1:3
        linear{i,1}(:,ii) = filtfilt(b,a,linear{i,1}(:,ii));
        velocity{i,1}(:,ii) = filtfilt(b,a,velocity{i,1}(:,ii));
    end
end

%% Derive rotational acceleration from filtered gyroscope data
% Utilises five-point stencil method to derive rotatinal acceleration for
% all axes

h = 1/fs; % time step

for k = 1:length(files)
    gyroData = velocity{k}; 
    [numSamples, numAxes] = size(gyroData); %establish length
    
    % Preallocate the rotational acceleration array
    rotAccel = zeros(numSamples, numAxes);
    
    % Apply the five-point stencil for interior points
    for i = 3:numSamples-2
        for j = 1:numAxes
            rotAccel(i,j) = (-gyroData(i+2,j) + 8*gyroData(i+1,j) - 8*gyroData(i-1,j) + gyroData(i-2,j)) / (12*h);
        end
    end  
    % Handle boundary points (using lower-order finite differences)
    % First two points
    for j = 1:numAxes
        rotAccel(1,j) = (gyroData(2,j) - gyroData(1,j)) / h; % Forward difference
        rotAccel(2,j) = (gyroData(3,j) - gyroData(1,j)) / (2*h); % Central difference
    end    
    % final two points
    for j = 1:numAxes
        rotAccel(numSamples,j) = (gyroData(numSamples,j) - gyroData(numSamples-1,j)) / h; % Backward difference
        rotAccel(numSamples-1,j) = (gyroData(numSamples,j) - gyroData(numSamples-2,j)) / (2*h); % Central difference
    end
    
    rot_acceleration{k,1} = rotAccel;
end

% Filter
for i = 1:length(files)
    for ii = 1:3
        rot_acceleration{i,1}(:,ii) = filtfilt(b,a,rot_acceleration{i,1}(:,ii));
    end
end

% Resultant
for i = 1:length(files)
   rot_acceleration{i,1}(:,4) = (sqrt(rot_acceleration{i,1}(:,1).^2+rot_acceleration{i,1}(:,2).^2+rot_acceleration{i,1}(:,3).^2));
end

clear i ii j k m 
%% Transformation of linear acceleration to the head centre of mass
% For accurate estimate of head COM linear accelerations, accelerometer
% values need to be transformed to the head COM, based on rigid body
% assumptions. Note, the transformation vector is left blank to account for
% specific accelerometer location. 

% Displacement Vector
x = [-0.04584; -0.032; -0.06228];  

for m = 1:length(files)   
    for i = 1:numSamples
        w{m,1}(:,i) = [velocity{m,1}(i,1); velocity{m,1}(i,2); velocity{m,1}(i,3)];
        dw{m,1}(:,i) = [rot_acceleration{m,1}(i,1); rot_acceleration{m,1}(i,2); rot_acceleration{m,1}(i,3)];
        LinAccVec{m,1}(:,i) = [linear{m,1}(i,1); linear{m,1}(i,2); linear{m,1}(i,3)];
        cross_rot{m,1}(:,i) = cross(w{m,1}(:,i),x);
        tranlin(:,i) = LinAccVec{m,1}(:,i) + cross(dw{m,1}(:,i),x) + cross(cross_rot{m,1}(:,i),w{m,1}(:,i));
                 
        %Transformed linear acceleration data for every axis, divided by
        %9.81 to convert back to g's
        trans_linear{m,1}(i,1) = (tranlin(1,i))/9.81;
        trans_linear{m,1}(i,2) = (tranlin(2,i))/9.81;
        trans_linear{m,1}(i,3) = (tranlin(3,i))/9.81;
        trans_linear{m,1}(i,4) = (sqrt(trans_linear{m,1}(i,1).^2+trans_linear{m,1}(i,1).^2+trans_linear{m,1}(i,1).^2));
        
    end
end

%% Summarise Peak Kinematics

for i = 1:length(files)
    PLA(i,:) = max(trans_linear{i,1}(:,4));
    PRA(i,:) = max(rot_acceleration{i,1}(:,4));
end


