mkdir('mat');
s = dir('*.rhd');
for i = 1:length(s)
	[amp,aux_input,params,notes,supply_voltage,adc,dig_in,dig_out,temp_sensor,status] = read_intan_data_cli_rhd2000(s(i).name);
	save(strcat('mat/', s(i).name(1:end-4)), 'amp','aux_input','params','notes','supply_voltage','adc','dig_in','dig_out','temp_sensor','status');
	clear amp aux_input params notes supply_voltage adc dig_in dig_out temp_sensor status
end