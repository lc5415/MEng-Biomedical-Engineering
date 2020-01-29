library(growthcurver)

# Load the sample growth curve data provided in the Growthcurver package.
# The first column is the time in hours, and there is one column 
# for each well in a 96-well plate.
d <- growthdata

file_name <- "/Volumes/USB\ DISK/LUIS\ FOLDER/Allstrains_YPD_YND_serioustry_1.xlsx"
d <- read.table(file_name, header = FALSE, sep = "\t", stringsAsFactors = FALSE)

# Now, we'll use Growthcurver to summarize the growth curve data using the 
# simple background correction method (minimum value correction). This is the 
# default method, so we don't need to specify it in the command.
# This returns an object of type "gcfit" that holds information about
# the best parameters, the model fit, and additional metrics summarizing
# the growth curve.
gc_fit <- SummarizeGrowth(d$time, d$A1)

# It is easy to get the most useful metrics from a gcfit object, just type:
gc_fit
## Fit data to K / (1 + ((K - N0) / N0) * exp(-r * t)): 
##      K   N0  r
##   val:   0.336   0   1.119
##   Residual standard error: 0.004685978 on 142 degrees of freedom
## 
## Other useful metrics:
##   DT 1 / DT  auc_l   auc_e
##   0.62   1.6e+00 5.11    5.15
# And it is easy to plot the raw data and the best fit logistic curve
plot(gc_fit)

# The gcfit object returned from SummarizeGrowth also contains further metrics 
# summarizing the growth curve data.
params <- gc_fit$vals

# look at the structure of the gc_fit object
str(gc_fit)

