%% Project: Spotify Data Transmission Workflow
%  Developers: Rudra Prakash Singh

%% Getting Audio Data
[y, Fs] = audioread("mother_tongue_cropped.mp3");
%y - sampled data from audio signal
%Fs - sampling frequency

%wavEditedData.mat & wavRawData.mat were for testing purposes. use
%audioread method for getting y-values
y = y*1000; %x1000 to make conversion to bits easier
y = round(y, 0);%same thing

%% Converting .wav to bits

bitConvert = zeros(length(y)*16,1); %create empty array length of length(y)*16
for n = 1:length(y)
%     string(round((floor(sin(y(n)))+ceil(sin(y(n)))+1)/2))+string(dec2bin(abs(y(n)),15)); % 
% :)
      bits = string(int8(y(n) ~= -abs(y(n))))+string(dec2bin(abs(y(n)), 15));

    for i = 1:16
        bitConvert((n-1)*16+i) = extract(bits, i);
    end
end

%% Converting bits to States
%for loop that takes 2 bits at a time and converts them into 
% its corresponding state. this is done for all bits 
%states are stored in variable numState
numState = [];
mTest = (length(bitConvert));
for m = 1:(((mTest-1)/2)+1) 
    if m==1
        start = bitConvert(m);
        stop = bitConvert(m+1);        
    end

    if m>=2
            diff = m-2;
            start = bitConvert(m+(diff+1));    
            stop = bitConvert(m+(diff+2)); 
    end

    str = [start stop];
%     if str == [0,0]
%         numState(end+1) = 0;
%     end
%     if str == [0,1]
%         numState(end+1) = 1;
%     end
%     if str == [1,0]
%         numState(end+1) = 2;
%     end
%     if str == [1,1]
%         numState(end+1) = 3;
%     end

numState(end+1) = str(1) * 2 + str(2);
% 
end
% 
numState = flip(rot90(numState)); %this lets you view states in MATLAB as
% a column. it appears as not viewable row as default

%% Here would ideally be QPSK modulation
%% Converting States to Bits
bitBack = zeros(length(numState) * 2,1);
for n = 1:length(numState) 
        bitBack(n*2-1) = floor(numState(n)/2);
        bitBack(n*2) = mod(numState(n), 2);
end

bitToNum = zeros(length(y),1); %create empty array length of length(y)


%% Converting bits back to .wav
for n = 1:length(y)
    stri = "";
    for i = 2:16
        stri = stri + string(bitBack((n-1)*16+i));
    end
    bitToNum(n) = bin2dec(stri) * (bitBack((n-1)*16+1)*2-1);
end
disp("Done");

bitToNum = bitToNum / 1000; %converting x1000 y-vals back to original

%% Writes .wav file
audiowrite("mother_tongue_back.wav", bitToNum, 48000); 
%writing audio file of original song (showcase modulation process worked)


%bitConvert is bits
%numState is states
