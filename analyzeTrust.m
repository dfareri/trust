clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'trust_summary_run_Amalia_wmeanRT.csv');
fid_run = fopen(fname,'w');
fprintf(fid_run,'subnum,run,avg_comp,avg_stranger,avg_friend,avg_comp_logRT,avg_stranger_logRT,avg_friend_logRT,avg_comp_RT,avg_stranger_RT,avg_friend_RT,misses\n');
fname = fullfile(maindir,'trust_summary_subj_Amalia_wmeanRT.csv');
fid_subj = fopen(fname,'w');
fprintf(fid_subj,'subnum,avg_comp,avg_stranger,avg_friend,avg_comp_logRT,avg_stranger_logRT,avg_friend_logRT,avg_comp_RT,avg_stranger_RT,avg_friend_RT,misses\n');

sublist = [101 102 103 104 105 106 107 108 109];


for s = 1:length(sublist)

    subj = sublist(s);
    runs = 3;

    tmp_data = zeros(runs,10);
    for r = 1:runs
        fname = fullfile(maindir,'logs',num2str(subj),sprintf('sub-%02d_task-trust_run-%d_raw.csv',subj,r-1));
        fid = fopen(fname,'r');
        C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);

        RT = C{16}; % will do something with this later
        % partner is 1 (neu), 2 (neg), 3 (pos)
        Partner = C{4};
        trust_val = C{13}; % 0-8 (with '999' for no response)
        data = [Partner trust_val RT];

        misses = length(find(data(:,2)==999));
        data(data(:,2)==999,:) = [];
        trust_val = data(:,2);
        Partner = data(:,1);
        RT = data(:,3);
        logRT = log(RT);
        avg_comp = mean(trust_val(Partner==1,1));
        avg_stranger = mean(trust_val(Partner==2,1));
        avg_friend = mean(trust_val(Partner==3,1));
        avg_comp_logRT = mean(logRT(Partner==1,1));
        avg_stranger_logRT = mean(logRT(Partner==2,1));
        avg_friend_logRT = mean(logRT(Partner==3,1));
        avg_comp_RT = mean(RT(Partner==1,1));
        avg_stranger_RT = mean(RT(Partner==2,1));
        avg_friend_RT = mean(RT(Partner==3,1));
        tmp_data(r,:) = [avg_comp avg_stranger avg_friend avg_comp_logRT avg_stranger_logRT avg_friend_logRT avg_comp_RT avg_stranger_RT avg_friend_RT misses];


        % subnum,run,avg_comp,avg_stranger,avg_friend,pct_miss
        fprintf(fid_run,'%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,r,tmp_data(r,:));

    end
    % subnum,avg_comp,avg_stranger,avg_friend,pct_miss
    fprintf(fid_subj,'%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,mean(tmp_data));

end
fclose(fid_subj);
fclose(fid_run);
