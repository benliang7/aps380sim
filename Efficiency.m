for i = 1:length(RPM_vals)
    for j = 1:length(Torque_vals)
        run = simOutputs(i, j);
        efficiency(i, j) = (run.Motor_Electrical_Power(51, 1) + run.AC_Cable_Power_Loss(51, 1)) / run.Inverter_Power(51, 1);
    end
end