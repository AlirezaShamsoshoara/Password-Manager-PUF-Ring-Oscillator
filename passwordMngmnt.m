clc;
clear;


%% Initializing
Flag = 1;
ChallengeTable = cell(16, 16);

for i = 1:16
    for j = 1:16
        ChallengeTable{i, j}{end + 1} = 2;
    end
end


Mode = 0;
EnableSocket = 1;


%% Creating Socket to connect to the Host(Listener == Raspberry PI)
if EnableSocket
    t = tcpip('199.1.1.3', 12345, 'NetworkRole', ...
        'client', 'Timeout', 1);
    t.InputBufferSize = 2;
    fopen(t);
end


while Flag
    
    %% Mode Selection
    while (Mode ~= 1) && (Mode ~= 2) && (Mode ~= 3) && (Mode ~= 4)
        fprintf('Mode --> 1: Sign up and Registration\n');
        fprintf('Mode --> 2: Sign in and Authentication\n');
        fprintf('Mode --> 3: Demonstrate the Table\n');
        fprintf('Mode --> 4: Quit\n');
        Mode = input('Which Mode you prefer?\n');
    end
    
    %%     Mode 4 ==> Quit
    
    if Mode == 4
        Mode = 0;
        fprintf('Exiting the Program\n');
        break
    end
    %% Mode 1  Getting ID and Password from the user for Registration
    
    if Mode == 1
%         ID = 'sm3275';
        ID = input('Please Enter your Username: ','s');
%         PSWD = '12345';
        PSWD = input('Please Enter your Password: ','s');
        fprintf("ID = %s\n", ID);
        fprintf("PASSWORD = %s\n", PSWD);
        
        %% Calculate HEX of ID and the Password
        
        hexID = dec2hex(ID);
        hexPSWD = dec2hex(PSWD);
        
        %% Extracting just first and Second Character of ID and Password in Hex
        
        firstofID = hexID(1, 1);
        firstPSWD = hexPSWD(1, 1);
        
        secofID = hexID(1, 2);
        secPSWD = hexPSWD(1, 2);
        
        %% Extracting the Bits of the first and second characters
        
        binfirstofID = hexToBinaryVector(firstofID,4,'MSBFirst');
        binfirstofPSWD = hexToBinaryVector(firstPSWD,4,'MSBFirst');
        
        binSecofID = hexToBinaryVector(secofID,4,'MSBFirst');
        binSecofPswd = hexToBinaryVector(secPSWD,4,'MSBFirst');
        
        %% ROW and COLOUMN address of the user and passworkd in BINARY.HEX.DEC
        
        
        ROWaddrsBin = xor(binfirstofID, binfirstofPSWD);
        COLAddrsBin = xor(binSecofID, binSecofPswd);
        
        ROWaddHex = binaryVectorToHex(ROWaddrsBin);
        COLaddHex = binaryVectorToHex(COLAddrsBin);
        
        ROWaddDec = hex2dec(ROWaddHex) + 1;
        COLaddDec = hex2dec(COLaddHex) + 1;
        
        %% Calcluate the Hash of the Password in order to get the Pair Query
        % THe output of the Hash function is Hex so because we need a challenge of
        % length 16 we take 32bits of the binary data of the Hashpassword. Each
        % line has 4 bits and we are going to use only 3 bits of that because our
        % ring oscillator has only 8 lines of Ring.
        
        opt.Method = 'SHA-1';
        
        HashHexPsswrd = DataHash(PSWD, opt);
        HashbinPsswrd = ...
            hexToBinaryVector(HashHexPsswrd(1,1:32)', 4, 'MSBFirst');
        
        HashbinPsswrd3d = HashbinPsswrd(:, 2: end);
        LineReq = bi2de(HashbinPsswrd3d,'left-msb');
        
        index = 1;
        i = 1;
        PairReq = zeros(length(LineReq)/2, 2);
        while index <= length(LineReq)
            if mod(index, 2) == 1
                PairReq(i, 1) = LineReq(index);
            else
                PairReq(i, 2) = LineReq(index);
                i = i + 1;
            end
            index = index + 1;
        end
        PairReq;
        
        %% Sending Pair Queries to the PUF to RaspberryPi and Receving it 
        if EnableSocket
            i = 1;
            sizeOfPair = size(PairReq);
            data1 = zeros(1, sizeOfPair(1,1)/2);
            while i <= sizeOfPair(1,1)
                SendData = sprintf("%d%d", PairReq(i, 1), PairReq(i, 2));
                fwrite(t, SendData);
                
                data1(1, i) = fread(t, 1);
                fprintf('Challenge = %c \n', char(data1(1,i)'));
                i = i + 1;
                %     pause(2);
            end
            
            ChallengeTable{ROWaddDec, COLaddDec}{end + 1} = char(data1);
        end
        
        %         ChallengeTable{ROWaddDec, COLaddDec}{end + 1} = HashHexPsswrd;
        fprintf('Registered !!! \n');
        fprintf('--------------------------------------------------------------------\n');
    end
    
    %% Mode 2 ==> Authentication
    
    if Mode == 2
%         ID = 'sm3275';
        ID = input('Please Enter your Username: ','s');
        %         PSWD = '12345';
        PSWD = input('Please Enter your Password: ','s');
        fprintf("ID = %s\n", ID);
        fprintf("PASSWORD = %s\n", PSWD);
        
        %% Calculate HEX of ID and the Password
        
        hexID = dec2hex(ID);
        hexPSWD = dec2hex(PSWD);
        
        %% Extracting just first and Second Character of ID and Password in Hex
        
        firstofID = hexID(1, 1);
        firstPSWD = hexPSWD(1, 1);
        
        secofID = hexID(1, 2);
        secPSWD = hexPSWD(1, 2);
        
        %% Extracting the Bits of the first and second characters
        
        binfirstofID = hexToBinaryVector(firstofID,4,'MSBFirst');
        binfirstofPSWD = hexToBinaryVector(firstPSWD,4,'MSBFirst');
        
        binSecofID = hexToBinaryVector(secofID,4,'MSBFirst');
        binSecofPswd = hexToBinaryVector(secPSWD,4,'MSBFirst');
        
        %% ROW and COLOUMN address of the user and passworkd in BINARY.HEX.DEC
        
        
        ROWaddrsBin = xor(binfirstofID, binfirstofPSWD);
        COLAddrsBin = xor(binSecofID, binSecofPswd);
        
        ROWaddHex = binaryVectorToHex(ROWaddrsBin);
        COLaddHex = binaryVectorToHex(COLAddrsBin);
        
        ROWaddDec = hex2dec(ROWaddHex) + 1;
        COLaddDec = hex2dec(COLaddHex) + 1;
        
        %% Calcluate the Hash of the Password in order to get the Pair Query
        % THe output of the Hash function is Hex so because we need a challenge of
        % length 16 we take 32bits of the binary data of the Hashpassword. Each
        % line has 4 bits and we are going to use only 3 bits of that because our
        % ring oscillator has only 8 lines of Ring.
        
        opt.Method = 'SHA-1';
        
        HashHexPsswrd = DataHash(PSWD, opt);
        HashbinPsswrd = ...
            hexToBinaryVector(HashHexPsswrd(1,1:32)', 4, 'MSBFirst');
        
        HashbinPsswrd3d = HashbinPsswrd(:, 2: end);
        LineReq = bi2de(HashbinPsswrd3d,'left-msb');
        
        index = 1;
        i = 1;
        PairReq = zeros(length(LineReq)/2, 2);
        while index <= length(LineReq)
            if mod(index, 2) == 1
                PairReq(i, 1) = LineReq(index);
            else
                PairReq(i, 2) = LineReq(index);
                i = i + 1;
            end
            index = index + 1;
        end
        PairReq;
        
        if EnableSocket
            i = 1;
            sizeOfPair = size(PairReq);
            data1 = zeros(1, sizeOfPair(1,1)/2);
            while i <= sizeOfPair(1,1)
                SendData = sprintf("%d%d", PairReq(i, 1), PairReq(i, 2));
                fwrite(t, SendData);
                
                data1(1, i) = fread(t, 1);
                fprintf('Response = %c \n', char(data1(1,i)'));
                i = i + 1;
                %     pause(2);
            end
            
%             ChallengeTable{ROWaddDec, COLaddDec}{end + 1} = char(data1);
        end
        
        isSame = cellfun(@(x)isequal(x,char(data1)),ChallengeTable{ROWaddDec, COLaddDec});
        [row,col] = find(isSame);
        if isempty(find(isSame, 1))
            fprintf('Authentication Failed !!! \n');
        else
            fprintf('Response and Challenge are the same !!! \n');
            fprintf('Approved !!! \n');
        end
        fprintf('--------------------------------------------------------------------\n');
    end
    
    
    %% Mode 3 ==> Display Table
    if Mode == 3
        disp(ChallengeTable);
        fprintf('--------------------------------------------------------------------\n');
    end
    
    Mode = 0;
    
end

if EnableSocket
    fclose(t);
end