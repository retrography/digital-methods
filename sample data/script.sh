git clone http://github.com/retrography/digital-methods
cd digital-methods
cd sample\ data
ls
ls -l

cat sample.csv
head sample.csv
tail sample.csv
cut -d, -f1 sample.csv
cut -d, -f3 sample.csv # Why doesn't this work properly?
q -d , "select distinct c3 from sample.csv limit 10" sample.csv

cat sample.json | less
jq ".[] | {name: .name, topping: .topping[].type} | [.name,.topping] | @csv" sample.json
jq ".[] | {name: .name, topping: .topping[].type} | [.name,.topping] | @csv" sample.json > desserts.csv
cat desserts.csv
jq ".[] | {name: .name, topping: .topping[].type} | [.name,.topping] | @csv" sample.json | head -n 2 | tail -n 1

wget https://archive.org/download/stackexchange/beer.stackexchange.com.7z
7z x beer.stackexchange.com.7z

