%% Load Simulation Result (Example for Secondary Count per Cell)
load('BnftPerSecUsr_15.mat');
SecConsNo = length(SecCons);
[ItfRows, ItfCols] = size(SecBS);

%% 1️⃣ Number of Secondary Users in Each Cell
figure('Name', 'SecondaryUsersPerCell', 'NumberTitle', 'off');
ConsPC = zeros(ItfRows, ItfCols);
for i = 1:SecConsNo
    ConsPC(SecCons(i).CellNo(1), SecCons(i).CellNo(2)) = ...
        ConsPC(SecCons(i).CellNo(1), SecCons(i).CellNo(2)) + 1;
end
bar(reshape(ConsPC, 1, []));
xlabel('Cell Index');
ylabel('Secondary Users');
title('Number of Secondary Users in Each Cell');

%% 2️⃣ Benefit Analysis vs Primary Consumer Count per Cell
Bnft = zeros(1, 10);
Pnlty = zeros(1, 10);
NoPnlty = zeros(1, 10);
Pri = zeros(1, 10);
SecConsNoAll = zeros(1, 10);
NotEmptySU = zeros(1, 10);

j = 5; % Index for bar plot offset
for i = 15:20
    load(['BnftPerPriUsr_' num2str(i) '.mat']); % Contains: Bnft1, Bnft2, Penalty1, Penalty2, Cons1, Cons2, SecCons

    Bnft(j) = sum(Bnft1(:)) + sum(Bnft2(:));
    Pnlty(j) = sum(Penalty1(:)) + sum(Penalty2(:));
    Pri(j) = length(Cons1) + length(Cons2);
    NoPnlty(j) = nnz(Penalty1) + nnz(Penalty2);
    SecConsNoAll(j) = length(SecCons);

    for m = 1:SecConsNoAll(j)
        if nnz(SecCons(m).BS.Cons) == 0
            NotEmptySU(j) = NotEmptySU(j) + 1;
        end
    end
    j = j + 1;
end

%% 3️⃣ Total System Benefit Bar Plot
figure('Name', 'SystemBenefit', 'NumberTitle', 'off');
bar(Bnft);
xlabel('Primary Consumers per Cell');
ylabel('Total System Benefit');
title('System Benefit vs. Number of Primary Consumers per Cell');

%% 4️⃣ Total Penalty Paid Bar Plot
figure('Name', 'SystemPenalty', 'NumberTitle', 'off');
bar(Pnlty);
xlabel('Primary Consumers per Cell');
ylabel('Total Penalty');
title('Total Penalty Paid to Primary Users');

%% 5️⃣ Number of Penalized Primary Users
figure('Name', 'PrimaryPenaltyCount', 'NumberTitle', 'off');
x = 1:10;
bar(x, Pri, 0.5, 'FaceColor', [0.2 0.2 0.5]); hold on;
bar(x, NoPnlty, 0.25, 'FaceColor', [0 0.7 0.7]); hold off;
xlabel('Primary Consumers per Cell');
ylabel('User Count');
title('Number of Penalized Primary Users vs. Total');
legend('Total Primary Users', 'Users Receiving Penalty');

%% 6️⃣ Unserviced Secondary Users
figure('Name', 'EmptySecondaryUsers', 'NumberTitle', 'off');
x = [1, 2];
w1 = 0.5;
w2 = 0.25;
bar(x, [SecConsNo SecConsNo], w1, 'FaceColor', [0.2 0.2 0.5]); hold on;
bar(x, [NotEmptySU(end) NotEmptySU(end)], w2, 'FaceColor', [0 0.7 0.7]); hold off;
xlabel('Status');
ylabel('Secondary Users');
xticklabels({'All Secondaries', 'Unserviced'});
title('Unserviced Secondary Users vs. Total');
legend('Total', 'Unserviced');

