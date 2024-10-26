clc
clear variables
close all
addpath(genpath('Functions'))
addpath(genpath('OpenTrack Tracks'))
addpath(genpath('Lookup Tables'))
addpath(genpath('Logged Data'))
addpath(genpath('ReferenceModelsLibrary'))
addpath(genpath('Dependencies'))
addpath(genpath('Images'));

%% Emrax228 + VTC6
vehicle.powertrain.W_lim = vehicle.powertrain.Max_rpm * ((2 * pi) / 60); % [rad/s]

powertrain = {};
motor = {};
inverter = {};
battery = {};

%% Motor

% RPM based free run loss
motor.RPM_x_Power_y = Emrax_228_HV_Mech_Loss_Map();

% Parameters

motor.Pp = 10;                                          % Pole pairs [-]
motor.Rw = 0.0167;                                      % Winding resistance [ohm]

% Derived from torque constant kt
motor.Lambda_m = 0.0542;                                % Flux linkage [Wb]

% Ld and Lq are swapped in the AMK motor datasheet
% Supported by AMK LUTs and analysis using electrical dynamic equations
motor.Ld = 177e-6;                                      % Direct axis inductance [H]
motor.Lq = 183e-6;                                      % Quadrature axis inductance [H]

% Limits

motor.RPM_lim = 5500;                                   % Motor speed limit [RPM]
motor.W_lim = motor.RPM_lim * pi/30;                    % Motor speed limit [rad/s]
motor.T_lim = 230;                                      % Motor torque limit [Nm]

% Imax * sqrt(2)
motor.I_lim = 339.411255;                               % Motor current limit [A]
motor.Id_max = -150;                                    % Motor Id current limit [A]

%% Battery

battery.soc_x_ocv_y = Murata_VTC6_SOC_OCV_Curve();      % Murata VTC6 SOC/OCV curve

battery.Vmax = 4.2;                                     % Max voltage per cell [V]
battery.Vnom = 3.7;                                     % Nominal cell voltage [V]
battery.DCIR = 0.0009;                                  % Cell internal resistance [Ohm]
battery.S = 142;                                        % Number of series cells [-]
battery.P = 1;                                          % Number of parallel cells [-]
battery.Ah = 14;                                        % Cell capacity [Ah]
battery.Rdc = battery.S * battery.DCIR / battery.P;     % Cell internal resistance [Ohm]
battery.Voc = battery.S *  battery.Vmax;                % Initial open circuit voltage [V]
battery.Voc_nom = battery.S *  battery.Vnom;            % Nominal DC voltage [V]

% Mass
% battery.cell_mass = 0.278;                            % Cell module mass [kg]
% battery.mass = battery.S * battery.cell_mass;         % Battery total cell mass [kg]

%% Powertrain

% 4 AWG AC cable
powertrain.rac = 2.5945e-3;                             % AC cable radius [m]
powertrain.lac = 0.35;                                  % AC cable length [m]

powertrain.Rdc = 0.1;                                   % DC bus resistance [Ohm]

% powertrain.Rdischarge = 120000;                       % Passive discharge resistance [Ohm]
% powertrain.R_total = powertrain.Rdc + battery.Rdc;    % Total resistance [Ohm]

% Pack discharge limit [A]
% powertrain.I_lim = battery.N_cell * battery.Vmax / (2 * R_total);

%% Inverter

% Current based power module loss LUTs
[inverter.swi_x_swe_y, ...
    inverter.rri_x_rre_y, ...
    inverter.ci_x_cp_y, ...
    inverter.di_x_dp_y] = PM_100_DZ_Map();

% Parameters
inverter.Cdc_link = 280e-6;                             % DC link capacitance [F]
inverter.fsw = 12000;                                   % AMK inverter switching frequency [Hz]
inverter.Rccee = 0.5e-3;                                % Collecter + emitter resistance [ohm]
inverter.Vref = 300;                                    % Switching loss reference voltage [V]
inverter.Qg = 4.8e-6;                                   % Gate charge
inverter.Vge = 23;                                      % Gate-emitter on/off voltage delta

% From Semikron switching loss application notes
% Since Vref is 600V, set to 1.2 to capture maximum reasonable switching losses
inverter.n_igbt = 1.4;                                  % IGBT switching loss sensitivity

% Assumptions
inverter.td = 5e-6;                                     % Dead time [s]
inverter.dt_duty = 2 *  inverter.td * inverter.fsw;     % Dead time duty [-]

% Fundamental frequency of zero sequence is 3 times modulation frequency
% 3 samples per period will capture rms value of fundamental frequency without interpolation
% 3 * 3 * factor of safety of 40 = 360
inverter.n_sample = 360;       
