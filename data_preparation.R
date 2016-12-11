# get the file's path and read in the info
filepath<-"D:/Google Drive/School/Machine Learning/Project 1/output/MERGED2013_PP.csv"
data<-read.csv(filepath, header=TRUE, stringsAsFactors=FALSE)

# check the contents for accuracy
dim(data) # [1] 7804 1729
head(data)

## csv file is now read and info is put in the 'data' variable

# I will be looking at fields relating to:
# tuition, admission rate, SAT scores, and debt upon graduating
# Tuition --> TUITFTE
# Admission Rate --> ADM_RATE_ALL
# SAT Scores --> SATVRMID, SATWRMID, SATMTMID, SAT_AVG_ALL
# Debt Upon Graduating --> GRAD_DEBT_MDN
# 
# Therefore, all other columns will be removed.
# The fields being looked at are described above.

data.important <- cbind(data['TUITFTE'], data['ADM_RATE_ALL'], data['SATVRMID'], data['SATWRMID'], data['SATMTMID'], data['SAT_AVG_ALL'], data['GRAD_DEBT_MDN'])


# classes <- c(TUITFTE="numeric", ADM_RATE_ALL="numeric", SATVRMID="numeric", SATWRMID="numeric", SATMTMID="numeric", SAT_AVG_ALL="numeric", GRAD_DEBT_MDN="numeric")

# get rid of any rows that contain a 'NULL' value
data.clean <- data.important[!rowSums(data.important=='NULL'),]
dim(data.clean) # [1] 781 7

# specifying stringsAsFactors=FALSE during read.csv caused all numerics to be read as characters
# so each column must be converted to a numeric column
data.clean$TUITFTE<-as.numeric(data.clean$TUITFTE)
data.clean$ADM_RATE_ALL<-as.numeric(data.clean$ADM_RATE_ALL)
data.clean$SATVRMID<-as.numeric(data.clean$SATVRMID)
data.clean$SATWRMID<-as.numeric(data.clean$SATWRMID)
data.clean$SATMTMID<-as.numeric(data.clean$SATMTMID)
data.clean$SAT_AVG_ALL<-as.numeric(data.clean$SAT_AVG_ALL)
data.clean$GRAD_DEBT_MDN<-as.numeric(data.clean$GRAD_DEBT_MDN)

# this introduces some NA values in the GRAD_DEBT_MDN column so remove those rows
data.clean<-data.clean[complete.cases(data.clean),]
dim(data.clean) # [1] 772 7

## data is now cleaned and put in the 'data.clean' variable