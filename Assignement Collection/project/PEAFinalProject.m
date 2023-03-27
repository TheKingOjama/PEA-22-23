clear all;
conversion=1000;
%A
fileID = fopen('TraceA-A.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);

M1_A = sum(A) / length(A);
A_lambda_fitted = 1/M1_A;

%B
fileID = fopen('TraceA-B.txt','r');
formatSpec = '%f';
B = fscanf(fileID,formatSpec);

M1_B = sum(B) / length(B);
B_lambda_fitted = 1/M1_B;

%C
fileID = fopen('TraceA-C.txt','r');
formatSpec = '%f';
C = fscanf(fileID,formatSpec);

M1_C = sum(C) / length(C);


C_lambda_fitted = 1/M1_C;
%D
fileID = fopen('TraceA-D.txt','r');
formatSpec = '%f';
D = fscanf(fileID,formatSpec);


M1_D = sum(D) / length(D);

D_lambda_fitted = 1/M1_D;
%E
fileID = fopen('TraceA-E.txt','r');
formatSpec = '%f';
E = fscanf(fileID,formatSpec);


M1_E = sum(E) / length(E);
E_lambda_fitted = 1/M1_E;

lambda_fitted=[A_lambda_fitted B_lambda_fitted C_lambda_fitted D_lambda_fitted E_lambda_fitted];
Exp = @(RandomNumber, Lambda) -log(RandomNumber) / Lambda;
n_core=1;
s=1;
run_time=0;
pCtoB=0.9;
pEtoB=0.8;
ok=0;

Throughput = 0;

while ok == 0
    s = 1;
    run_time = 0;
    counter = 0; 
    
    while counter <= 50000
        if s == 1
           dT = Exp(rand(), lambda_fitted(1, 1));
           ns = 2;
        end
        if s == 2
            dT = Exp(rand(), lambda_fitted(1, 2)) / n_core;
           ns = 3;
        end
        if s == 3
            RandomNumber = rand();
            if RandomNumber <= 0.9
                ns = 2;
            else
                ns = 4;
            end 
            dT = Exp(rand(), lambda_fitted(1, 3));
             
        end
        if s == 4
            dT = Exp(rand(), lambda_fitted(1, 4));
            ns = 5;
        end
        if s == 5
            RandomNumber = rand();
            if RandomNumber <= 0.8
                ns = 2;
            else
                ns = 1;
                counter = counter + 1;
            end
            dT = Exp(rand(), lambda_fitted(1, 5)) / n_core;
            
        end

        run_time = run_time + dT;
        s = ns;
    end
    run_time = run_time / 1000;
    
    Throughput = counter / run_time;
    
    if Throughput <= 30
        n_core=n_core +1;
    else
        ok = 1;
    end
    
end


fprintf(1, "Minimum number of cores: %g\n", n_core);
fprintf(1, "Number of jobs per second: %g job/s", Throughput);
