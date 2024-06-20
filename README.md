# Biteplate/Mouth-based Inertial Measurement Unit for Head Impact Kinematics Measurement

This MATLAB script processes raw accelerometer and gyroscope signals to estimate head impact kinematics. The processing is divided into four main sections: Data Import, Filtering, Deriving and Filtering Rotational Acceleration, and Transformation of Linear Acceleration to the Head Center of Mass. 

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
- [Usage](#usage)
  - [Data Import](#data-import)
  - [Filtering of Linear Acceleration and Gyroscope Data](#filtering-of-linear-acceleration-and-gyroscope-data)
  - [Derive Rotational Acceleration from Filtered Gyroscope Data](#derive-rotational-acceleration-from-filtered-gyroscope-data)
  - [Transformation of Linear Acceleration to the Head Center of Mass](#transformation-of-linear-acceleration-to-the-head-center-of-mass)
- [Summary of Peak Kinematics](#summary-of-peak-kinematics)

## Overview
This script processes head impact kinematics data from a biteplate or mouth-based inertial measurement unit. It performs the following steps:
1. **Data Import**: Reads data from CSV files containing time, rotational acceleration, rotational velocity, and linear acceleration.
2. **Filtering of Linear Acceleration and Gyroscope Data**: Applies a 4th order low pass Butterworth filter with a 200Hz cutoff frequency.
3. **Deriving and Filtering Rotational Acceleration**: Uses a five-point stencil method to derive rotational acceleration from filtered gyroscope data.
4. **Transformation of Linear Acceleration to the Head Center of Mass**: Transforms linear acceleration data to the head's center of mass based on rigid body assumptions.

## Data Input
Note,  Assumes Data is formatted in individual .csv files and saved within file directory. Data stored as cell array, with the assume column structure of column 1 = time; columns 2-5 rotational acceleration (x,y,z,resultant); columns 6-9 rotational velocity (x,y,z,resultant); columns 10-13 linear acceleration (x,y,z,resultant). Although rotational acceleration may be given, we will filter and derive ourselves.
