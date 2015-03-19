function [Y,FS]=fw_dataload(FILE)
%
%
%

load(FILE,'audio');
Y=audio.data;
FS=audio.fs;
