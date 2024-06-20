# accelerometer_processing

Biteplate/Mouth-based Inertial Measurement Unit for Head Impact Kinematics Measurement
This MATLAB script processes raw accelerometer and gyroscope signals to estimate head impact kinematics. The processing is divided into four main sections: Data Import, Filtering, Deriving and Filtering Rotational Acceleration, and Transformation of Linear Acceleration to the Head Center of Mass.

Table of Contents
Overview
Installation
Usage
Data Import
Filtering of Linear Acceleration and Gyroscope Data
Derive Rotational Acceleration from Filtered Gyroscope Data
Transformation of Linear Acceleration to the Head Center of Mass
Summary of Peak Kinematics
Contributing
License
Overview
This script processes head impact kinematics data from a biteplate or mouth-based inertial measurement unit. It performs the following steps:

Data Import: Reads data from CSV files containing time, rotational acceleration, rotational velocity, and linear acceleration.
Filtering of Linear Acceleration and Gyroscope Data: Applies a 4th order low pass Butterworth filter with a 200Hz cutoff frequency.
Deriving and Filtering Rotational Acceleration: Uses a five-point stencil method to derive rotational acceleration from filtered gyroscope data.
Transformation of Linear Acceleration to the Head Center of Mass: Transforms linear acceleration data to the head's center of mass based on rigid body assumptions.
Installation
Clone the repository:
sh
Copy code
git clone https://github.com/yourusername/HeadImpactKinematics.git
Ensure you have MATLAB installed on your system.
Usage
Data Import
The script reads data from CSV files in the current directory. The data should have the following column structure:

Column 1: Time
Columns 2-5: Rotational acceleration (x, y, z, resultant)
Columns 6-9: Rotational velocity (x, y, z, resultant)
Columns 10-13: Linear acceleration (x, y, z, resultant)
Filtering of Linear Acceleration and Gyroscope Data
The script applies a 4th order low pass Butterworth filter with a 200Hz cutoff frequency to the linear acceleration and gyroscope data. Adjust the cf variable if a different cutoff frequency is required.

Derive Rotational Acceleration from Filtered Gyroscope Data
The script uses a five-point stencil method to derive rotational acceleration from the filtered gyroscope data. The rot_acceleration array stores the derived rotational accelerations.

Transformation of Linear Acceleration to the Head Center of Mass
The script transforms the linear acceleration data to the head's center of mass using a specified displacement vector. The transformed data is then converted back to g's.

Summary of Peak Kinematics
The script summarizes the peak linear acceleration (PLA) and peak rotational acceleration (PRA) for each trial.
