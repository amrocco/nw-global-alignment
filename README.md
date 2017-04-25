# Needleman-Wunsch Global Alignment

### To run

./global_alignment.rb or
ruby global_alignment.rb

##### Options
`-h --help`  
Prints a summary of all other options

`-s --sequences`
Two comma delimited sequences must be passed to this option. Ex:
./global_alignment.rb -s ATCG,TCG

`-g --gap-penalty`
This is the value used for the gap penalty. If no value is passed then the
script will default to using -1 as the gap penalty. Ex:
./global_alignment.rb -s ATCG,TCG -g -2

`-m --match`
This is the value used for a match. If no value is passed then the
script will default to using 1. Ex:
./global_alignment.rb -s ATCG,TCG -g -2 -m 1

`-i --mismatch`
This is the value used for a mismatch. If no value is passed then the
script will default to using -1. Ex:
./global_alignment.rb -s ATCG,TCG -g -2 -m 1 -i -2