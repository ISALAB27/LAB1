fs=10000;
nb=13;
T=1/500; %% maximum period
tt=0:1/fs:10*T; %% time samples

fid = fopen('resultsm.txt');
A = fscanf(fid,'%d')';
fclose(fid);

fid2 = fopen('RESULTS.txt');
B = fscanf(fid2,'%d')';
fclose(fid2);

figure
plot(tt, A, 'c--o');

hold on
plot(tt, B, 'r--*');

Aq=A/2^(nb-1); %% convert back coefficients as nb-bit real values
Bq=B/2^(nb-1); %% convert back coefficients as nb-bit real values

hold off
thd(Bq, fs, 20)
%thd(Bq, fs,9)

