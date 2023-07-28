# DOWNLOAD CSV FILE
***/dilans_data.csv
dilans_data.csv | head -100

# MAKE DIR / COPY CSV FILE
mkdir DILAN
cp dilans_data.csv /****/raw_data.csv
head raw_data.csv 

# SPLIT TIMESTAMP TO DATE AND TIME
awk -F';' 'BEGIN {OFS=";"} {split($1, datetime, " "); $1=""; $2=datetime[1]; $3=datetime[2]; $0=substr($0,2); print}' raw_data.csv > raw_data_new.csv

# REMOVAL OF EXCESSIVE SPACE
sed 's/North America/North_America/g' raw_data_new.csv > tmp.csv
rm raw_data_new.csv 
mv tmp.csv raw_data_new.csv
sed 's/South America/South_America/g' raw_data_new.csv > tmp2.csv
rm raw_data_new.csv 
mv tmp2.csv raw_data_new.csv

# SEPARATE ROWS INTO 3 CSV
grep 'read' raw_data_new.csv > read.csv
grep 'subscribe' raw_data_new.csv > subscribe.csv
grep 'buy' raw_data_new.csv > buy.csv

# DELETE EMPTY COLUMNS FROM BUY.CSV
cut -d';' -f1,2,3,4,5 buy.csv > buy2.csv
rm buy.csv
mv buy2.csv buy.csv
rm buy2.csv

# DELETE EMPTY COLUMNS FROM SUBSCRIBE.CSV
cut -d';' -f1,2,3,4 subscribe.csv > tmp.csv
rm subscribe.csv 
mv tmp.csv subscribe.csv
rm tmp.csv

# DELETE EMPTY COLUMNS FROM READ.CSV
sed 's/Asia;/;Asia/g' read.csv > tmp.csv
rm read.csv
mv tmp.csv read.csv
sed 's/Africa;/;Africa/g' read.csv > tmp.csv
rm read.csv
mv tmp.csv read.csv
sed 's/Australia;/;Australia/g' read.csv > tmp.csv
rm read.csv
mv tmp.csv read.csv
sed 's/Europe;/;Europe/g' read.csv > tmp.csv
rm read.csv
mv tmp.csv read.csv
sed 's/North_America;/;North_America/g' read.csv > tmp.csv
rm read.csv
mv tmp.csv read.csv
sed 's/South_America;/;South_America/g' read.csv > tmp.csv
rm read.csv
mv tmp.csv read.csv

# CHECK SQL DATA LOAD
grep 'Reddit' raw_data.csv | wc -l
grep 'SEO' raw_data.csv | wc -l
grep 'Asia' raw_data.csv | wc -l
grep 'Europe' raw_data.csv | wc -l
grep 'country_5' raw_data.csv | wc -l
grep 'country_1' raw_data.csv | wc -l
grep 'subscribe' raw_data.csv | wc -l
grep ';8' raw_data.csv | wc -l
grep ';80' raw_data.csv | wc -l
