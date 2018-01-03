\name{CATCosinor}
\alias{CATCosinor}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Cosinor Analysis
        %%  ~~function to do ... ~~
}
\description{ Performs one of various cosinor-based analyses:  single cosinor, least squares spectrum, multiple-component cosinor, progressive single cosinor, chronobiologic serial section (single- or multiple-component model), gliding spectrum.
              
              %%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{  
  CATCosinor(TimeCol=1,Y=2, Components=1, window="noTaper", RefDateTime=NA, 
    timeFormat="\%Y\%m\%d\%H\%M", RangeDateTime=list(Start=NA, End=NA), Units="hours", 
    dt=0, Progressive=list(Interval=0, Increment=0), Period=list(Set=0,Start=0,
    Increment=1,End=0),header=FALSE, Skip=0, Colors="BW", Graphics="pdf",Output=list
    (Txt=FALSE,Dat=TRUE,Doc=TRUE,Graphs=FALSE),yLabel="", Console=FALSE,Debug=FALSE,
    IDcol="fileName",fileName=fileName,functionName="") 
  
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{TimeCol}{Column number where time is found. Time format of the TimeCol is given by timeFormat parameter. Time is read to the minute. Seconds are discarded. Date and Time can be in any column.  Valid values are as follows:  
                   1)  "numeric":  numeric (in number of hours from starting time); timeFormat may be ignored.
2)  A scalar:  If date/time is in one column; or
3)  A vector:  If date/time are in two column, Date must be in the first of the 2 columns specified, and Time in the second, i.e.,  c(3,6).

%%     ~~Describe \code ~~
  }

\item{Y}{The column number(s) of the data to be analyzed.  This is a numeric, either scalar or vector.  May use any valid R vector, such as c(4,5) or a single number.
         %%     ~~Describe \code ~~
}
\item{Components}{Default=1.  Indicates if this is a single or multiple component cosinor analysis, where the number of components is specified (0 is invalid).  If doing a single component cosinor, set Components=1.  If doing a multiple components model, set Components equal to the number of frequencies in the model.  
                  %%     ~~Describe \code here~~
}
\item{window}{Valid windowing function to be applied are:  "noTaper","Hanning","Hamming", "Bartlett","Blackman"
              %%     ~~Describe \code{ } here~~
}
\item{RefDateTime}{Date used as reference, and subtracted from all data dates, to make the number smaller.  **Must be in the same time zone!!!!!**
                     If RefDateTime = NA, uses the 1st date of the data as the RefDateTime.  
                   If RefDateTime = 0, uses midnight of the same day as start-of-data. 
                   %%     ~~Describe \code{ } here~~
}
\item{timeFormat}{Can be "numeric", or any valid R time conversion specification,  i.e., "\%Y\%m\%d\%H\%M".  See strptime for conversion specifications.
                If timeFormat= "numeric", time column in data file can be simple numbers (0 - 99999...) in Units from a reference time.
                If timeFormat= "numeric", the data are sorted by time to be sure they are ordered ascending.  First must be smallest , and last largest.
                  Time can also be in two columns (indicate in TimeCol  Ex:  c(1,2));  timeFormat is ignored when time is in two columns -- the format use is \%d/\%m/\%y in the first of the two columns, and \%H:\%M:\%S or \%H:\%M in the second of the two
}

\item{RangeDateTime}{Specify in the form of a list:  RangeDateTime=list(Start=12, End=0).      
                     $Start:  Analysis is started at $Start.  $Start may be before the 1st data date.
                     If $Start = NA, the 1st data point is used as the StartDate.
                     if $Start =  0, midnight of the 1st date is used as the StartDate. 
                     $End:    Analysis ends at $End.  $End may be after the last data date.
                     if $End =  NA, the last data point is used as the EndDate.
                     if $End =  0, midnight at the end of the last date is used as the EndDate.   
                     %%     ~~Describe \code{k} here~~
}
\item{Units}{Units (hours, years, weeks or days) for use by Interval and Increment arguments, as well as Period arguments (Note: only Hour is currently implemented.)
             %%     ~~Describe \code{yLab} here~~
}
\item{dt}{When equidistant data, dt indicates the sampling interval. Data are assumed to be equidistant when this is nonzero.
          %%     ~~Describe \code{modulo} here~~
}
\item{Progressive}{Specify in the form of a list:  Progressive=list(Interval=0, Increment=0).
                   $Interval: length of the time span being analyzed (in Units) -- multiple are spans calculated.
                   If 0, no progression is assumed; Interval is set to the full dataset length, and Increment = full data set.
                   $Increment: (uses same Units as set for Interval) to shift forward for each successive Interval analyses.
                   If 0, no progression is assumed; Interval is set to the full dataset length, and Increment = full data set 
                   %%     ~~Describe \code{ } here~~
}
\item{Period}{Specify in the form of a list:   Period=list(Set=0,Start=0,Increment=1,End=0).
              $Start : [only used if $Set=0];  this is the first (and longest) period to calculate, in units  (as set by Units);  (Interval/1).   0 is Default: the full time range of the data file is analyzed [in hours]. (RangeDateTime$End-RangeDateTime$Start)= MyData_length; or if progressive, Interval/1.  
              $Increment : [only used if $Set=0] Increment from the starting period, in units (as set by Units).  Defaults to 1;   0 is invalid  -- default will be used in that case.
              $End : [only used if $Set=0]  Last (and smallest) period to calculate, in units (as set by Units), EXCLUSIVE.  Defaults to 4;  0 is invalid  -- default will be used in that case.
              $Set :  If Set=0, a series of periods are analyzed (spectrum) according to Period$Start, $Increment, $End (or their default value, if not specified).  If Set is not equal to 0, it overrides Period$Start and $Increment, to completely specify a set of periods to analyze (as set by Units), ending at $End.  $Set can be in the format of a single number, a vector, or R expression:  c(1,2,3) or c(8,12:24) or seq(1,50, by=.75).  When Components=1, each period specified in the vector will be assessed by cosinor independently.  When parameter Components is >1, Period$Set must have a corresponding number of components, which are assessed together in a multiple-component cosinor.    When 0, only the longest period, or the longest period per Interval, from a spectrum is listed on page 1 of the graphics output file.  Otherwise, all periods are displayed in the graphic file.    
              %%     ~~Describe \code{ } here~~
}
\item{header}{ T/F to indicate if the file has a header.  Headers are used as variable names.
               %%     ~~Describe \code{Skip} here~~
}
\item{Skip}{ How many lines to skip at the top of the file (before the header). The header will be read next, after Skip lines are skipped (if header=TRUE). 
             %%     ~~Describe \code{ } here~~
}
\item{Colors}{Colors for a heatmap.  "Heat" renders the heatmap in colors;  "BW" renders the heatmap in grayscale
              %%     ~~Describe \code{ } here~~
}
\item{Graphics}{The main results of CATCosinor are sent to a graphic file when Console=F.  Default file output type is "pdf".   Possible values: "jpg, pdf, tiff, png".   
                %%     ~~Describe \code{ } here~~
}
                \item{Output}{Specify in the form of a list:  list(Txt=F,Dat=T, Doc=T,Graphs=F).  $Txt=T will capture the console output to a .txt file.  $Dat=T will generate a .txt computer-readable file of tab delimited cosinor results: MESOR, Amplitude, Phase, standard error values, and others. It is useful for subsequent processing (by CAT, or excel, for example).  $Doc=T will generate a nicely-formatted .rtf file, also readable by Word.  $Graphs will enable a set of graphs plotting Data, Model, MESOR, Amplitude, Acrophase over time, or a heatmap.  The exact files generated will vary with the functions performed.  Heatmaps are only created when a progressive analysis least squares spectra is performed. $Graphs=F will disable printing of graphs for faster processing, if you do not need the files.
                %%     ~~Describe \code{ } here~~
                }
\item{yLabel}{Label for the Y axis on data graphs.  If this is left blank (the default="") then the column headers are used for Y axis label.
              %%     ~~Describe \code{yLabel} here~~
  }
                \item{Console}{Default is F.  When Console=T, output will be redirected to the RStudio Console, instead of an output file.  Otherwise, sent to file type indicated in Graphics parameter.
                %%     ~~Describe \code{ } here~~
                }
                \item{Debug}{ Turn on when you want to see more diagnostic output for programming debug purposes.  
                %%     ~~Describe \code{ } here~~
                }
                \item{IDcol}{What to use as a unique identifier:  either "fileName" or a column number.  Default = "fileName"
                %%     ~~Describe \code{ } here~~
                }
                \item{fileName}{The path to a data file to be processed.  If this is blank, CATCosinor will solicit a file from the user by a dialogue box. 
                %%     ~~Describe \code{ } here~~
                }
                \item{functionName}{Brief user-defined name for this run, used to help distinguish it from other runs.  Name is printed in output files.
                %%     ~~Describe \code{ } here~~
                }
}
                \section{Input Data requirements:}{  
                There is no need for data to be equidistant for the Cosinor.  Data columns specified in Y are expected to be numeric.  
                Input data files can be tab delimited, or comma delimited.  There may be multiple columns of data for processing.
                }
                \section{Output Data:}{  
                Sample graphics output file can be found in the Output section on the CAT web site for a sample of a full output file.  All graphs contain the input data filename to clearly identify the data file under analysis, and a timestamp to show the time of analysis.  Each graph also lists the column name being analyzed (or averaged), as well as the starting and ending times of analysis, as they vary slightly from the full data set.
                Graphic output files can be in JPG, PDF, TIFF or PNG.  TIFF and PNG are higher resolution than jpeg and PDF.  Plots in PNG and JPEG formats can easily be converted to many other bitmap formats, and both can be displayed in modern web browsers. The PNG format is lossless and is best for line diagrams and blocks of color. The JPEG format is lossy, but may be useful for image plots, for example. It is most often used in html web pages.  TIFF is a meta-format: the default format written by tiff is lossless and stores RGB (and alpha where appropriate) values uncompressed-such files are widely accepted, which is their main virtue over PNG.
                %%  ~~ If necessary, more details than the description above ~~
                }
                
                \references{http://564394709114639785.weebly.com/running-cat.html
                %% ~put references to the literature/web site here ~
                }
                \author{Cathy Lee Gierke, Ruth Ann Helget, Germaine Cornelissen-Guillaume
                
                Maintainer: \email{ <leegi001@umn.edu>}
                }
                %%  ~~who you are~~
                
                %% ~Make other sections like Warning with \section{Warning }{....} ~
                
                \examples{
                #Data is systolic and dialstolic blood pressure; and heart rate at 
                #        30 minute intervals.
                #---------------------  Vignette0    multi-component cosinor.  
                # multiple-components cosinor analysis of 24, 12 and 8 hours.  Columns 
                #       4,6,7 are processed.

                #  Normally you would use these lines to read a file for use in CATkit 
                #        (use filePath format for your OS)
                # filePath<-"~/file/path/Installing CAT/Vignette0"          # use for mac
                # filePath<-"c:\\file\\path\\Installing CAT\\Vignette0"     # use for PC
                # fileName<-file.path(filePath,'CLGi001.dat')
                
                # this line is used instead of the above since it is part of a package.
                file.copy(system.file("extdata", "CLGi001.dat", package = "CATkit"), 
                    tempdir(), overwrite = TRUE, recursive = FALSE, copy.mode = TRUE, 
                    copy.date = FALSE)
                filePath<-tempdir()
                fileName<-file.path(filePath,'CLGi001.dat')

                #fileName<-system.file("extdata", "CLGi001.dat", package = "CATkit")
                #  
                CATCosinor(TimeCol=2,Y=c(4,6,7), Components=3, window="noTaper", RefDateTime
                  ="201302030000",  timeFormat="\%Y\%m\%d\%H\%M",RangeDateTime =list(Start=0, 
                  End=0), Units='hours', dt=0, Progressive=list(Interval=0, Increment=0),
                  Period=list(Set=c(24,12,8),Start=0,Increment=1,End=0),header=FALSE, 
                  Skip=0,Colors="BW",Graphics="pdf",Output=list(Txt=FALSE,Dat=TRUE,
                  Doc=TRUE,Graphs=TRUE),Console=FALSE,Debug=FALSE,IDcol="fileName", 
                  fileName=fileName,functionName='Vignette0')
                
                #---------------------   Vignette1     Least Square spectrum
                # 
                #  Normally you would use these lines to read a file for use in CATkit 
                #     (use filePath format for your OS)
                # filePath<-"~/file/path/Installing CAT/Vignette1"          # use for mac
                # filePath<-"c:\\file\\path\\Installing CAT\\Vignette1"     # use for PC
                # fileName<-file.path(filePath,'Signal10-20.txt')
                
                # this line is used instead of the above since it is part of a package.
                file.copy(system.file("extdata", "Signal10-20.txt", package = "CATkit"), 
                    tempdir(), overwrite = TRUE, recursive = FALSE, copy.mode = TRUE, 
                    copy.date = FALSE)
                filePath<-tempdir()
                fileName<-file.path(filePath,'Signal10-20.txt')

                #fileName<-system.file("extdata", "Signal10-20.txt", package = "CATkit")
                #
                CATCosinor(TimeCol=1,Y=2, Components=1, window="noTaper", RefDateTime="0",
                timeFormat="\%Y\%m\%d\%H\%M", RangeDateTime=list(Start=0, End=0), 
                Units='hours', dt=0, Progressive=list(Interval=0, Increment=0), Period=
                list(Set=0,Start=144,Increment=1,End=4),header=FALSE, Skip=0, Colors="BW",
                Graphics="pdf",Output=list(Txt=FALSE,Dat=TRUE,Doc=TRUE,Graphs=TRUE),
                Console=FALSE,Debug=FALSE,fileName=fileName,functionName='Vignette1') 
                
                # ---------------------   Vignette2     progressive least squares spectrum
                #
                #  Normally you would use these lines to read a file for use in CATkit 
                #       (use filePath format for your OS)
                # filePath<-"~/file/path/Installing CAT/Vignette2"          # use for mac
                # filePath<-"c:\\file\\path\\Installing CAT\\Vignette2"     # use for PC
                # fileName<-file.path(filePath,'FWedited.txt')
                #
                # this line is used instead of the above since it is part of a package.
                file.copy(system.file("extdata", "FWedited.txt", package = "CATkit"), 
                    tempdir(), overwrite = TRUE, recursive = FALSE, copy.mode = TRUE, 
                    copy.date = FALSE)
                filePath<-tempdir()
                fileName<-file.path(filePath,'FWedited.txt')

                #fileName<-system.file("extdata", "FWedited.txt", package = "CATkit")
                #
                CATCosinor(TimeCol=1,Y=2, Components=1, window="noTaper",RefDateTime 
                ="199210192152",  timeFormat="\%Y\%m\%d\%H\%M", RangeDateTime= list(Start
                ="199210200000", End="199211300000"), Units='hours', dt=0, Progressive=list
                (Interval=168, Increment=24), Period=list(Set=0, Start=168,Increment=.5,
                End=9.5),header=FALSE, Skip=0, Colors="BW", Graphics="pdf",Output=list
                (Txt=FALSE,Dat=TRUE,Doc=FALSE,Graphs=TRUE),Console=FALSE,Debug=FALSE,
                fileName=fileName,functionName='Vignette2')
                }
                
                
                % Add one or more standard keywords, see file 'KEYWORDS' in the
                % R documentation directory.
                \keyword{ ~ Cosinor }
                \keyword{ ~ multi-component }
                \keyword{ ~ single-component }
                \keyword{ ~ regression }
                \keyword{ ~ least squares }
                \keyword{ ~ spectrum }
                \keyword{ ~ chronomics }