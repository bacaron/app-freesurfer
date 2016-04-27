#################################################################################
########### Extract Data from BA - GaussVol for all the subjects ################
            ########### Freesurfer 5.3 version ###############
                         ## Pratik Gandhi ## 

### Define the base directory
i<-0
setwd(basedir)
dir.create("Results")
dirs <- list.dirs(path=basedir, full.names=TRUE, recursive=FALSE) # List the directories

# Writing the column names and writing it to a csv file
colnames<-c("subjectid","Left_BA1_GausVol","Right_BA1_GausVol","Left_BA2_GausVol","Right_BA2_GausVol","Left_BA3a_GausVol","Right_BA3a_GausVol","Left_BA3b_GausVol","Right_BA3b_GausVol","Left_BA4a_GausVol","Right_BA4a_GausVol","Left_BA4p_GausVol","Right_BA4p_GausVol","Left_BA6_GausVol","Right_BA6_GausVol","Left_BA44_GausVol","Right_BA44_GausVol","Left_BA45_GausVol","Right_BA45_GausVol","Left_V1_GausVol","Right_V1_GausVol","Left_V2_GausVol","Right_V2_GausVol","Left_MT_GausVol","Right_MT_GausVol","Left_perirhinal_GausVol","Right_perirhinal_GausVol")
colnames<-t(colnames)
write.table(colnames,"Results/BA_GausVol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)

### Reading in the template for matching and filling up the missing values in the data 
setwd(temp_dir)
local_files <- list.files(temp_dir)
base_file <- local_files[grepl("lh.BA.stats$",local_files)]
table_base<- read.table(base_file)

### Again directing to the base directory
setwd(basedir)
length_dirs<- length(dirs)-1

# Getting inside the individual directories
for (i in 1:length_dirs){
    
  setwd(dirs[i])
  allfiles<-list.files(,recursive=TRUE)
  lhBA<-allfiles[grepl("lh.BA.stats$",allfiles)] # Reading the lh-BA file
  rhBA<-allfiles[grepl("rh.BA.stats$",allfiles)] # Reading the rh-BA file

        linn_lh<-readLines(lhBA)
        linn_rh<-readLines(rhBA)

    split <- strsplit(linn_lh[15], " ")[[1]]
    subjectid<-split[length(split)]     # Getting the subject id for the respective subject

    table_lh<-read.table(lhBA)
    table_rh<-read.table(rhBA)
    
    # Converting them to matrix form for matching to template and inserting the missing values
    table_rh <- as.matrix(table_rh)
    table_lh <- as.matrix(table_lh)
    table_base <- as.matrix(table_base[,1])
    
    table_lh <- merge(x=table_base,y=table_lh, all.x = TRUE ) # Doing for LH
    table_lh <- table_lh[match(table_base[,1],table_lh[,1]),]
    table_lh <- as.matrix(table_lh)
    table_lh[is.na(table_lh)] <- 0
    
    table_rh <- merge(x=table_base,y=table_rh, all.x = TRUE ) # Doing for RH
    table_rh <- table_rh[match(table_base[,1],table_rh[,1]),]
    table_rh <- as.matrix(table_rh)
    table_rh[is.na(table_lh)] <- 0
    
    # Converting back to data frame
    table_lh <- as.data.frame(table_lh)
    table_rh <- as.data.frame(table_rh)
    
    table_values_lh<-data.frame(table_lh[,c("V7")])
    table_values_rh<-data.frame(table_rh[,c("V7")])
    
    tot_table <- data.frame(table_values_lh,table_values_rh)
    
    ext<-data.frame(matrix(ncol = 1,nrow = 1))
    
    for (k in 1:nrow(tot_table)){
      ind_row <- tot_table[k,]
      ext <- cbind(ext,ind_row)
    }
    
    ext[,1] <- NULL
    
    sub_id<-data.frame(subjectid)
    
    z<-cbind(sub_id,ext)  # Combining the values and the subjectid, putting in one data frame
    
    setwd(basedir)
    write.table(z,"Results/BA_GausVol.csv",append=TRUE,quote=FALSE,sep=",",row.names=FALSE,col.names=FALSE)  # Writing it to the csv file created
}
setwd(basedir)
