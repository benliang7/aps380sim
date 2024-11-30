% % Open the Simulink model
% open_system('EmraxEfficiencySimulation');
% 
% % Define RPM and Torque ranges
% RPM_vals = linspace(0, 6000, 11);
% Torque_vals = linspace(0, 230, 11);
% 
% % Preallocate simulation input array
% simIn = repmat(Simulink.SimulationInput('EmraxEfficiencySimulation'), length(RPM_vals), length(Torque_vals));
% 
% % Configure simulation inputs
% for i = 1:length(RPM_vals)
%     for j = 1:length(Torque_vals)
%         simIn(i, j) = setBlockParameter(simIn(i, j), ...
%             'EmraxEfficiencySimulation/Motor_RPM', 'Value', num2str(RPM_vals(i)));
%         simIn(i, j) = setBlockParameter(simIn(i, j), ...
%             'EmraxEfficiencySimulation/Motor_Torque', 'Value', num2str(Torque_vals(j)));
%     end
% end

% % Run batch simulation
% simOutputs = sim(simIn(:)); % Flatten the array
% 
% disp('Simulations complete!');

% Open the example model.
open_system('EmraxEfficiencySimulation');

% RPM = 0;
% Torque = 0;
% set_param('EmraxEfficiencySimulation/Motor_RPM','Value','RPM');
% set_param('EmraxEfficiencySimulation/Motor_Torque','Value','Torque')

RPM_vals = linspace(0, 6000, 11);
Torque_vals = linspace(0, 230, 11);

for i = 1:length(RPM_vals)
    for j = 1:length(Torque_vals)
        simIn(i, j) = Simulink.SimulationInput('EmraxEfficiencySimulation');
        simIn(i, j) = setVariable(simIn(i, j),'RPM',RPM_vals(i));
        simIn(i, j) = setVariable(simIn(i, j),'Torque',Torque_vals(j));
        simIn(i, j) = setBlockParameter(simIn(i, j), 'EmraxEfficiencySimulation/Motor_RPM', 'Value', num2str(RPM_vals(i)));
        simIn(i, j) = setBlockParameter(simIn(i, j), 'EmraxEfficiencySimulation/Motor_Torque', 'Value', num2str(Torque_vals(j)));
    end
end

simOutputs = sim(simIn);

% % Open the Simulink model
% open_system('EmraxEfficiencySimulation');
% 
% % Define RPM and Torque ranges
% RPM_vals = linspace(0, 6000, 11);  % RPM range
% Torque_vals = linspace(0, 230, 11); % Torque range
% 
% % Preallocate simulation input array
% simIn = repmat(Simulink.SimulationInput('EmraxEfficiencySimulation'), length(RPM_vals), length(Torque_vals));
% 
% % Configure simulation inputs
% for i = 1:length(RPM_vals)
%     for j = 1:length(Torque_vals)
%         simIn(i, j) = setVariable(simIn(i, j), 'RPM', RPM_vals(i));
%         simIn(i, j) = setVariable(simIn(i, j), 'Torque', Torque_vals(j));
%     end
% end
% 
% % Run batch simulation
% simOutputs = sim(simIn(:)); % Flatten simIn for batch execution
% 
% % Process simulation results
% disp('Simulation complete!');