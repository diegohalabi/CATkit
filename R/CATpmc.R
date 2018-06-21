CATpmc <-
function(data, fileName, colNames, VarID=NA, GrpID = NA, alpha = 0.05, header=FALSE, sep="\t", Output=list(Doc=TRUE,Txt=FALSE), functionName="", title=""){

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
  
  if (!missing("VarID") ){
    if (length(VarID)>1){
      stop("Only one column can be specified in VarID")
    } 
  }
  vars <- tolower(colnames(data))
  idx <- which(vars %in% c("pr", "mesor", "amp", "phi"))
  if (!is.numeric(unlist(data[,idx]))){
    stop("Non-numeric data found in parameter columns (pr, mesor, amp, phi).  (If header=FALSE, while a header is present, data will read as non-numeric).")
  }
  colnames(data)[idx] <- vars[idx]
  out <- data.frame(
    k = integer(),
    P.R. = integer(),
    P = numeric(),
    MESOR = numeric(),
    CI.M = numeric(),
    Amplitude =  numeric(),
    Lo.CI.A =  numeric(),
    Hi.CI.A =  numeric(),
    PHI =  numeric(),
    Lo.CI.PHI =  numeric(),
    Hi.CI.PHI =  numeric()
  )
  as.list(out)
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
    #fileName2<-paste(fileName,thisTime,functionName,"PMC.txt",sep="")
    fileName3<-paste(fileName,thisTime,functionName,"PMC.rtf",sep="")
    colNameStr<-paste(names(data),collapse=" ") 
    GrpIDStr<-paste(GrpID,collapse=" ") 
    VarIDStr<-paste(VarID,collapse=" ") 
    rtf<-RTF(fileName3,width=11,height=8.5,omi=c(.5,.25,.5,.25), font.size=11)
    output<-gsub(pattern='\b\b',replacement='\b',fileName3)
    #  Parameters
    addParagraph(rtf,paste("data fileName ",fileName,"\n  colNames: ", colNameStr, ";    GrpID: ",GrpIDStr, ";  VarID: ",VarIDStr, ";   header: ", header, ";   sep: ",sep, ";  Output.Doc/Txt: ",Output$Doc,"/",Output$Txt,"\n"))
    addParagraph(rtf,font.size=14,paste("Program CATkit.pmc --- Estimation of point  and interval estimates of population rhythm parameter"))
    addParagraph(rtf,paste("Output file:",fileName3))
    addParagraph(rtf,paste("Probability level selected is ",alpha,"\n"))
    
    addParagraph(rtf,paste("Title: ",title))
    #addParagraph(rtf,paste(functionName))
    
    addParagraph(rtf,paste("\n ------------ Rhythmometric Summary ------------\n"))
  }
    
  #####################################################################################################
  #                                                                                                   #
  #     Calculation look: An outer loop splits the data into Variable values if VarID is specified.   #
  #                       (VarID can be left undefined, or one column can be selected -- not multiple)#
  #                       Each variable value will be grouped with each combination of GrpID values   #
  #                       (factors) for calculation of a pmc.  Examples of Variables:  period, or     #
  #                       a measurement such as temp, heart rate, a measurement (of concentration),   #
  #                       or counts.                                                                  #
  #                                        -----------------------                                    #
  #                An inner loop performs pmc for 1)  All data for each VarID value (but not all together)#
  #                                               2)  All groups for each factor value within each VarID#
  #                                               3)  All combinations between factor/columns chosen  #
  #                The pmc function is called for each of these three; and a table is printed to      #
  #                an .rtf file.  Examples of factors:  gender, age, smoking vs non-smoking, or       #
  #                other groups that comprehensively categorize a poplulation                         #
  #                                                                                                   #
  #####################################################################################################

  varNames<-names(data)
  if ((missing(VarID) | is.null(VarID)) | any(is.na(VarID))) {   # use all data for outer loop
    varData<-data          # load all data
    VarCnt<-c("none")      # used for outer loop count (j)
    VarMsg<-""
  } else {
    rownames<-data[,VarID]  # load rowcounts to split by
    newData<-split(data, rownames)   #  send split arrays into outer loop
    VarCnt<-names(newData)            #  used for outer loop count (j)
    VarMsg<-paste("\n v v v v v v v v v v v v v v  Variable column:",VarID,"  v v v v v v v v v v v v v v  ")
  }

  writeOutput(rtf,VarMsg,Output$Doc)
  Loops<-length(GrpID)+1
  
  for (j in VarCnt) {  #  this neeeds to be unique values n ALL specified columns (VarID)

      if (!is.null(VarID) && !any(is.na(VarID))){  
        varData<-as.data.frame(newData[j])
        names(varData)<-varNames     # reset names to NOT have the varName with them
        if (VarCnt[1]!="none"){
          writeOutput(rtf,paste("\n===================  Variable value:",names(newData[j])," ==================="),Output$Doc)
        }
      }

    #############  Begin inner loop for group ids    ##############################################
      if (is.null(GrpID) | any(is.na(GrpID))){           #  ((is.null(GrpID) | any(is.na(GrpID))) && VarCnt[1]!="none"){
        varData$pr<-as.numeric(varData$pr)
        varData$mesor<-as.numeric(varData$mesor)
        varData$amp<-as.numeric(varData$amp)
        varData$phi<-as.numeric(varData$phi)
        if (!exists("out")){        #  Data split by VarID
          combo <- pmc_internal(varData, alpha)
          out<-rbind.data.frame(out, combo) 
        } else {
          out <- pmc_internal(varData, alpha)   
        }   
        
        if (Output$Doc){
         # writeOutput(rtf,paste("\n------------ GrpID is null or NA ------------"),Output$Doc)
          addTable(rtf,out, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
        }
        
      }else{
        #browser()
        for (i in 0:Loops){   #  loop through GrpIDs
            varData$pr<-as.numeric(varData$pr)
            varData$mesor<-as.numeric(varData$mesor)
            varData$amp<-as.numeric(varData$amp)
            varData$phi<-as.numeric(varData$phi)
    print(j)
            if (i==0){    #  all data as one group
               combo <- pmc_internal(varData, alpha)
               out<-rbind.data.frame(out, combo) 
               writeOutput(rtf,paste("\n------------ All data -------"),Output$Doc)
               if (Output$Doc){   #  print out the matrix of pmc for this loop
                 addTable(rtf,combo, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
               }
              }  else  {  #  rowname for: @ factor in each column; combinations of multiple columns
                
                  if (i==Loops && Loops>3){ 
                    Combs<-Loops-1
                    for (k in 3:Combs){
                      nSet<-subsets(Combs,(k-1),GrpID)       #  creates an array with Comb rows & (Combs-k) columns
                      nSelect<-choose(Combs,(k-1))
                      for (l in 1:nSelect){
                        #browser()
                        rownames<-col_concat(varData[,nSet[l,]], sep = ":")
                        combo <- do.call('rbind',
                                         lapply(split(varData, rownames), function(x){
                                           pmc_internal(x, alpha)
                                         })
                        )
                        out<-rbind.data.frame(out, combo)   #  combine results from loop 1-n with loop 0
                        #browser()
                        #rownames<-col_concat(varData[,GrpID], sep = ":")
                        writeOutput(rtf,paste("\n------------ combinations of factors: GrpID",paste(nSet[l,], collapse=","),"-------"),Output$Doc)
                        
                        if (Output$Doc){   #  print out the matrix of pmc for this loop
                          addTable(rtf,combo, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
                        }   #  if Output$Doc
                      }    #  for l in nSelect
                    }   #  for K in Combs:2
                  }  #  if (I==Loops)
                if (i==Loops){     # rowname for: combinations of multiple columns (not if only one GrpID)
                  if (length(GrpID)<2){
                    break    # in this case, the loop is done -- there is only one GrpID, no combinations.
                  }
                  rownames<-col_concat(varData[,GrpID], sep = ":")
                  writeOutput(rtf,paste("\n------------ combinations of all factors -------"),Output$Doc)
                  
                } else {         #  rowname for: @ factor in each column
                  rownames<-varData[,GrpID[i]]     #   uses assertr
                  writeOutput(rtf,paste("\n------------ each factor individually, GrpID",GrpID[i],"-------"),Output$Doc)
                  
                  # split_factor <- get_split_factors(varData, GrpID)
                  # rownames <- names(split(varData, split_factor)) 
                }
                # loop over each group and bind results together
                combo <- do.call('rbind',
                                 lapply(split(varData, rownames), function(x){
                                   pmc_internal(x, alpha)
                                 })
                )
                out<-rbind.data.frame(out, combo)   #  combine results from loop 1-n with loop 0
                if (Output$Doc){   #  print out the matrix of pmc for this loop
                  addTable(rtf,combo, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
                }
                  }  # END  @ factor in each column; combinations of multiple columns

        }  # for i=0 Loops  --  Loops through GrpIDs
        
        row.names(out)    #  if there's a varID it doesn't do this  why??
        out
      }
  }

  addNewLine(rtf,8)
  addParagraph(rtf,paste("Key for errMsg:  \n Warn1:  Warning:  P<alpha, but lower CI limit for Amp is negative, indicating violation of underlying assumptions."))  
  addParagraph(rtf,paste(" Warn2:  Warning:  k<3 for this population -- k must be >=3 to perform a PMC; skipping this population."))  
  addParagraph(rtf,paste(" Warn3:  Warning:  The amplitude is equal or approaching 0 (<10^-n);  acrophase is undefined when amplitude=0."))  
  done(rtf)
  opar = par()
  closeOutput(file=fileName3,output=Output,opar=opar)
  return(out)
}
