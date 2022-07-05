%% Set important dates and choose country

% |endhist| is the last period used for the estimation of the model
% parameters
endhist = qq(2022,1);

% |endproj| is the date until which the Kalman smoother is run
endproj = qq(2026,4);

% Type the two-letter country code of the country you would like to
% analyze. Make sure that file named data_|country|.csv containing data 
% for that country exists in |InputData| subdirectory.
country = 'BR';

% Choose a name for the version of the results  
version = 'VER2';
