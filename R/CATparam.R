CATparam <-
function(data, fileName, colNames, GrpID = NA, VarID = NA, alpha = 0.05, header=FALSE, sep="\t", Output=list(Doc=TRUE,Txt=FALSE), functionName="", title=""){
   #  setting colNames=NA here causes read to fail
  if (!missing("fileName") && header==FALSE && missing("colNames")){   # with a filename, either colnames or header must be set
    stop("A header or column names is required, containing required columns:  PR, MESOR, Amp, PHI, factors...")
  }
  
  if (missing("data") && !missing("fileName")){   #  if a matrix has not been passed, read from the file into matrix
    data <- read.table(fileName, sep=sep, header=header, stringsAsFactors=FALSE, col.names=colNames, blank.lines.skip = TRUE)    #  quote="",
  } else {
    if (header==FALSE && !missing("colNames")){      #  if no file read, and column names have been passed, read them into matrix
      colnames(data) <- colNames
    }
    fileName="console matrix"
  }
  if (missing("GrpID") ){
      stop("At least one GrpID parameter must be specified.")
  }
  if (!missing("VarID") ){
    if (length(VarID)>1){
      stop("Only one column can be specified in VarID")
    } 
  }
  vars <- tolower(colnames(data))
  idx <- which(vars %in% c("pr", "mesor", "amp", "phi"))
#browser()
  if (!is.numeric(unlist(data[,idx]))){
    stop("Non-numeric data found in parameter columns (pr, MESOR, amp, phi).  (If header=FALSE, while a header is present, data will read as non-numeric).")
  }
  if (is.factor(data[,GrpID[1]])){
    stop("Data was read in as a data type of factor.  Add 'stringsAsFactors=FALSE' to read.table")
    
  }
  colnames(data)[idx] <- vars[idx]

  out <- data.frame(df1 = vector(mode="logical",length=4),
                    df2 = vector(mode="logical",length=4),
                    F = vector(mode="logical",length=4),     # c(m_fval, amp_fval, phi_fval, rhythm_fval),
                    P = vector(mode="logical",length=4),
                    errMsg=vector(mode="logical",length=4))
                    #param = vector(mode="logical",length=4))     # c(m_p, amp_p, phi_p, rhythm_p))
  str(data)
  
  if(!all(c("pr", "mesor", "amp", "phi") %in% vars)){
    if(!"pr" %in% vars){
      data$pr <- NA
    }
    if(!"mesor" %in% vars){
      #data$mesor <- NA
      stop("data must contain a column labeled 'MESOR' for PMC -- if there is no MESOR, include a columns of NA's")   
    }
    if(!"amp" %in% vars){
      #data$amp <- 1
      stop("data must contain a column labeled 'amp' for PMC -- if there is no amplitude, include a columns of 1's")   
    }
    if(!"phi" %in% vars){
      stop("data must contain 'phi' for PMC")   
    }
  }
  if (Output$Doc){     #  open output .rtf document
    
    BaseTime<-Sys.time()        
    thisTime <- format(BaseTime, "--%d%b%y--%H-%M-%OS")
    #fileName2<-paste(fileName,thisTime,functionName,"ParamTest.txt",sep="")
    fileName3<-paste(fileName,thisTime,functionName,"ParamTest.rtf",sep="")
    colNameStr<-paste(names(data),collapse=" ") 
    GrpIDStr<-paste(GrpID,collapse=" ") 
    VarIDStr<-paste(VarID,collapse=" ") 
    rtf<-RTF(fileName3,width=11,height=8.5,omi=c(.5,.25,.5,.25), font.size=11)
    output<-gsub(pattern='\b\b',replacement='\b',fileName3)
    #  Parameters
    addParagraph(rtf,paste("data fileName ",fileName,"\n  colNames: ", colNameStr, ";    GrpID: ",GrpIDStr, ";  VarID: ",VarIDStr, ";   header: ", header, ";   sep: ",sep, ";  Output.Doc/Txt: ",Output$Doc,"/",Output$Txt,"\n"))
    addParagraph(rtf,font.size=14,paste("Program CATkit.pt --- Estimation of point  and interval estimates of population rhythm parameter"))
    addParagraph(rtf,paste("Output file:",fileName3))
    addParagraph(rtf,paste("Probability level selected is ",alpha,"\n"))
    
    addParagraph(rtf,paste("Title: ",title))
    #addParagraph(rtf,paste(functionName))
    
    addParagraph(rtf,paste("\n =============== Parameter tests ================ \n"))
  }
  
  #####################################################################################################
  #                                                                                                   #
  #     Calculation look: An outer loop splits the data into Variable values if VarID is specified.   #
  #                       (VarID can be left undefined, or one column can be selected -- not multiple)#
  #                       Each variable value will be grouped with each combination of GrpID values   #
  #                       (factors) for calculation of a pt.  Examples of Variables:  period, or     #
  #                       a measurement such as temp, heart rate, a measurement (of concentration),   #
  #                       or counts.                                                                  #
  #                                        -----------------------                                    #
  #                An inner loop performs pt for 1)  All data for each VarID value (but not all together)#
  #                                               2)  All groups for each factor value within each VarID#
  #                                               3)  All combinations between factor/columns chosen  #
  #                The pt function is called for each of these three; and a table is printed to      #
  #                an .rtf file.  Examples of factors:  gender, age, smoking vs non-smoking, or       #
  #                other groups that comprehensively categorize a poplulation                         #
  #                                                                                                   #
  #####################################################################################################
  
  varNames<-names(data)
  if ((missing(VarID) | is.null(VarID)) | any(is.na(VarID))) {   # use all data for outer loop
    varData<-as.data.frame(data)          # load all data
    VarCnt<-c("none")      # used for outer loop count (j)
    VarMsg<-""
  } else {
    rownames<-data[,VarID]  # load rowcounts to split by
    newData<-split(data, rownames)   #  send split arrays into outer loop
    VarCnt<-names(newData)            #  factors in VarCnt, used for outer loop count (j)
    VarMsg<-paste("\n v v v v v v v v v v v v v v  VarID column:",VarID,"  v v v v v v v v v v v v v v  ")
  }
  
  rowCnt<-length(data[,1])
  writeOutput(rtf,VarMsg,Output$Doc)
  Loops<-length(GrpID)
  for (j in VarCnt) {  #  this neeeds to be unique values n ALL specified columns (VarID)
    #browser()
    if (!is.null(VarID) && !any(is.na(VarID))){  
      varData<-as.data.frame(newData[j])
      names(varData)<-varNames     # reset names to NOT have the varName with them
      if (VarCnt[1]!="none"){
        if (length(VarCnt)<2 ){
          stop(paste("There must be at least two different values for the factor in VarID column", VarID))
        } else {
          if (length(VarCnt)>rowCnt/2 ){
            #browser()
            stop(paste("There are too many factors in VarID column", VarID,". Must be less than rowCnt/2 factors (",rowCnt/2,")."))
          }
        }
        writeOutput(rtf,paste("\n===================  VarID value:",names(newData[j])," ==================="),Output$Doc)
        } 
    }
    
    #############  Begin inner loop for group ids    ##############################################

      for (i in 1:Loops){   #  loop through GrpIDs  (for each column)
        # varData$pr<-as.numeric(varData$pr)
        # varData$mesor<-as.numeric(varData$mesor)
        # varData$amp<-as.numeric(varData$amp)
        # varData$phi<-as.numeric(varData$phi)
        print(j)
        GrpCnt<-length(unique(varData[,GrpID[i]]))
        if (GrpCnt<2 ){    #  must be a count
          stop(paste("No parameter test comparison can be done on GrpID.  The factor selected, GrpID=", GrpID[i],", must have more than one value."))
        } else {
          #browser()
          if (GrpCnt>rowCnt/2 ){
            stop(paste("There are too many factors in GrpID column", GrpID[i],". Must be less than rowCnt/2 factors (",rowCnt/2,")."))
          }
        }
        writeOutput(rtf,paste("\n===================  GrpID column:",GrpID[i]," ==================="),Output$Doc)
        
        # rowname for: combinations of multiple columns
        rownames<-col_concat(as.data.frame(varData[,GrpID[i]]), sep = ":")
        rownamesStr<-paste(unique(rownames),collapse=":")
        writeOutput(rtf,paste("\n-------------------- all factors:  ",rownamesStr," --------------------"),Output$Doc)

        # loop over each group and bind results together
        combo <- pmtest_internal(varData, alpha = alpha, GrpID=GrpID[i], VarID=VarID,rtf)
        out<-rbind.data.frame(out, combo)   #  combine results from loop 1-n with loop 0
        if (Output$Doc){   #  print out the matrix of pmtest for this loop
          addTable(rtf,combo, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
        }
        factorID<-unique(varData[,GrpID[i]])
        Combs<-length(factorID)   #  do param test on all factors together for this column (and var if elected)
        nSet<-subsets(Combs,2,factorID)       #  creates an array with Comb rows & (Combs-k) columns
        nSelect<-choose(Combs,2)
        if (nSelect>1){  #  no inner loop if only two factors
          for (l in 1:nSelect){
            #browser()
            # rownames<-col_concat(varData[,nSet[l,]], sep = ":")
            #  do not pass a list -- pass a table.  Use which?
            nSetStr<-paste(nSet[l,],collapse=":")            #nSet[l,]
            writeOutput(rtf,paste("\n-------------------- pairwise factors:  ",nSetStr," --------------------"),Output$Doc)
            pmcGrp<-which(varData[,GrpID[i]] %in% nSet[l,])   #nSet[l,] if not factors #factorID[nSet[l,]] of factors!!
            combo<-pmtest_internal(varData[pmcGrp,], alpha = alpha, GrpID=GrpID[i], VarID=VarID, rtf)
            #split(varData, nSet[l,])
            # combo <- do.call('rbind',
            #                  lapply(varData[pmcGrp,], function(x){
            #                    pmtest_internal(x, alpha = alpha, GrpID=GrpID[i], VarID=VarID)
            #                  })
            # )
            out<-rbind.data.frame(out, combo)   #  combine results from loop 1-n with loop 0
            if (Output$Doc){   #  print out the matrix of pmtest for this loop
              addTable(rtf,combo, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
            }   #  if Output$Doc
          }    #  for l in nSelect
        }  #  if Combs>2
      }  # for i=0 Loops  --  Loops through GrpIDs
      
      row.names(out)    #  if there's a varID it doesn't do this  why??
      out
  }
    
  addNewLine(rtf,8)
  addParagraph(rtf,paste("Key for errMsg:  \n Warn1:  Warning:  P<alpha, but lower CI limit for Amp is negative, indicating violation of underlying assumptions."))  
  addParagraph(rtf,paste(" Warn2:  Warning:  k<3 for one or more PMC populations in this comparison -- k must be >2 to perform a PMC;  all PMCs and the combined parameter calculation are skipped."))  
  addParagraph(rtf,paste(" Warn3:  Warning:  Tests of equality of parameters will be skipped because one or more PMCs were not performed (see Warn2)."))  
  addParagraph(rtf,paste(" Warn4:  Warning:  Test of equality of acrophases cannot be performed -- population acrophases are too far apart."))  
  addParagraph(rtf,paste(" Warn5:  Warning:  Test of equality of amplitudes is not performed when amplitudes are equal for all populations."))  
  # calculation of amplitude is an estimate and depends on phi, in part.  When As are all equal, F & P may not be (0,1) because the phases may vary, and this is obviously wrong, so it is not calculate.  [Same for phi.]  
  addParagraph(rtf,paste(" Warn6:  Warning:  Test of equality of acrophases is not performed when acrophases are equal for all populations."))   
  addParagraph(rtf,paste(" Warn7:  Warning:  The combined amplitude is equal or approaching 0 (<10^-n);  acrophase is undefined when the associated amplitude=0."))  
  
  addNewLine(rtf,4)
  addPageBreak(rtf)
  addSessionInfo(rtf)
  done(rtf)
  opar = par()
  closeOutput(file=fileName3,output=Output,opar=opar)
  return(out)  
  
}
