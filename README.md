This is a fork of the South African Tuberculosis Vaccine Initiative's R-script for computing risk6 score reimplemented so that csv inputs can be made from the command line. (Original project page: https://bitbucket.org/satvi/risk6.git)

## Usage

For CSV files - values separated by comma (,):
```bash
cd /PATH/TO/risk6/
Rscript run_risk6_csv.R /PATH/TO/FILE.csv > /PATH/TO/RESULTS.csv
```

For CSV2 files - values separated by semicolon (;):
```bash
cd /PATH/TO/risk6/
Rscript run_risk6_csv2.R /PATH/TO/FILE.csv > /PATH/TO/RESULTS.csv
```
