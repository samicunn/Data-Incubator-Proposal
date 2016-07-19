%Samantha Scott
%Data Incubator: Project Preliminary Analysis
%July 2016

%% Determining number of A, B, and C letter grades in each Las Vegas zip code

%Given a matrix (obtained from Las Vegas Health Inspection public database)
%where column 1 = zip codes, 2 = current letter grade, 3 = previous letter
%grade, 4 = current number of demerits

load('C:\Users\Samantha\Desktop\zip_grades_2015.mat'); 
    %Where letter grades are represented as: 1 = A, 2 = B, 3 = C, 4 (or closed down) = X

%Create table where zero letter entries are changed to NaNs (columns 2 and
%3) and rows with NaNs are deleted
zip_grades(zip_grades(:,2) == 0) = NaN;
zip_grades(zip_grades(:,3) == 0) = NaN;

zip_grades_clean = zip_grades(~any(isnan(zip_grades),2),:); 

zipcode = zip_grades_clean(:,1);
current_letter = zip_grades_clean(:,2);
past_letter = zip_grades_clean(:,3);
demerits = zip_grades_clean(:,4);

zip_grades_table = table(zipcode, current_letter, past_letter, demerits);


%Count number of A,B,C, and X grades in each zip code
zipcode_list = unique(zipcode);     %List of zip codes in table
sz = size(zipcode_list,1);

k = 3;                              %Ignoring first two incorrect zip codes
j = 1;

letter_count = zeros(sz,6);       	%For current letter grades and demerits ONLY
letter_count_norm = zeros(sz,6);
while k <= sz                       %Creating individual table for each zip code
    current_zip = zipcode_list(k);
    
    zip_matrix = zip_grades_table(zip_grades_table.zipcode == current_zip, :);
    sz_list = size(zip_matrix,1);  %size of current zip code list for normalization
    
    filename = ['C:\Users\Samantha\Desktop\ZipCodes\zip_matrix_', num2str(current_zip), '.mat'];
    save(filename, 'zip_matrix');
    
    letter_count(j,1) = current_zip;
    letter_count(j,2) = sum((zip_matrix{:,2}) == 1);
    letter_count(j,3) = sum((zip_matrix{:,2}) == 2);
    letter_count(j,4) = sum((zip_matrix{:,2}) == 3);
    letter_count(j,5) = sum((zip_matrix{:,2}) == 4);
    letter_count(j,6) = sum(zip_matrix{:,4});
    
    letter_count_norm(j,1) = current_zip;
    letter_count_norm(j,2) = (sum((zip_matrix{:,2}) == 1))/sz_list;
    letter_count_norm(j,3) = (sum((zip_matrix{:,2}) == 2))/sz_list;
    letter_count_norm(j,4) = (sum((zip_matrix{:,2}) == 3))/sz_list;
    letter_count_norm(j,5) = (sum((zip_matrix{:,2}) == 4))/sz_list;
    letter_count_norm(j,6) = (sum(zip_matrix{:,4}))/sz_list;
    
    k = k + 1;
    j = j + 1;          %Incrementing rows

end

letter_count_table = array2table(letter_count,...
    'VariableNames',{'zipcode','As','Bs', 'Cs', 'Xs', 'Demerits'});

letter_count_norm_table = array2table(letter_count_norm,...
    'VariableNames',{'zipcode','As','Bs', 'Cs', 'Xs', 'Demerits'});


clear all
%% Determining number of Yelp negative food safety words in each Las Vegas zip code

%Given a text file containing a zip code in one column and Las Vegas Yelp reviews in a second column
fid = fopen('reviews_zip.csv');
reviews_zip = textscan(fid,'%f %s','Delimiter',';');
fclose(fid);

zipcode = reviews_zip{1};
Yelp_reviews = reviews_zip{2};

reviews_zip_table = table(zipcode, Yelp_reviews);
zipcode_list = unique(zipcode);
sz = size(zipcode_list,1);

word_count = zeros(sz,10);
k = 1;
j = 1;
while k <= sz                       %Creating individual table for each zip code
    current_zip = zipcode_list(k);
    
    review_matrix = reviews_zip_table(reviews_zip_table.zipcode == current_zip, :);
    sz_list = size(review_matrix,1);  %size of current zip code list for normalization
    
    word_count(j,1) = current_zip;
    word_count(j,2) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'dirty'))));
    word_count(j,3) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'hair'))));
    word_count(j,4) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'undercooked'))));
    word_count(j,5) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'spoiled'))));
    word_count(j,6) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'stink'))));
    word_count(j,7) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'nauseous'))));
    word_count(j,8) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'old'))));
    word_count(j,9) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'sick'))));
    word_count(j,10) = sum(~cellfun('isempty',(strfind(review_matrix{:,2}, 'raw'))));
    
    k = k + 1;
    j = j + 1;          %Incrementing rows

end

%Additional database spreadsheets processing, statistics, and graphs completed in Excel.
