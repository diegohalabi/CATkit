\name{CatCall}
\alias{CatCall} 
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Visual Analysis of Period and Phase
        %%  ~~function to do ... ~~
}
\description{ Performs one or more analyses to gain insight into periods and/or phase in a dataset:  Actogram, Smoothing, Autocorrelation or Crosscorrelation.
              
              %%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{  
  CatCall(TimeCol=1, timeFormat="\%Y\%m\%d\%H\%M",lum=4, valCols=c(3,4), sumCols=c(5,6), 
    Avg=FALSE, export=FALSE, sizePts=2, binPts=5, Interval = 0, Increment=0, k=6, 
    yLab="Activity Level (au)", modulo=1440,Rverbose=0, RmaxGap=400, Skip=0, 
    header=FALSE,Smoothing=FALSE, Actogram=FALSE,AutoCorr=FALSE,CrossCorr=FALSE,
    Console=FALSE,Graphics="pdf", Darkness=1,LagPcnt=.33,tz="GMT",fileName,file2=list
      (Name=NULL,TimeCol=1, timeFormat="\%Y\%m\%d\%H\%M", lum=4, valCols=c(3,4),
      sumCols=c(5,6),sizePts=2, binPts=5,Darkness=0))
    
}


%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{TimeCol}{List column(s) containing the date and time.  Specify one column (a scalar) if date time is all in one column.  Specify 2 time columns as a vector, c(1,2), if date is in one and time is in another.  The format for time will be expected in timeFormat parameter.  
                  %%     ~~Describe \code{TimeCol } here~~
  }
  \item{timeFormat}{Using the R time-formatting codes, specify how your dates are formatted.  Default for a 1 column time is "\%Y\%m\%d\%H\%M".  A two column time will be concatenated without spaces, and your specified format applied:  DateTime.   See strptime {base}
                    %%     ~~Describe \code{timeFormat } here~~
  }
  \item{lum}{The column number containing luminance values, or NA.  Luminance values are used to determine where the light level drops sharply, and this point is used as the starting point for analysis.  Data points prior to dark onset are not used.  (This can be reversed to use only data after light onset by setting Darkness=0.)
             %%     ~~Describe \code{lum} here~~
  }
  \item{valCols}{Specify columns that should be averaged when binned.  Specify valCols=c() if none. 
                 %%     ~~Describe \code{valCols} here~~
  }
  \item{sumCols}{Specify columns that should be summed when binned.  Specify sumCols=c() if none. 
                 %%     ~~Describe \code{sumCols} here~~
  }
  \item{Avg}{A Boolean to indicate if you would like to see the output of an average of all data columns.  If you tell CAT to analyze columns 4:8, and specify average, in addition to analyzing each column from 4 to 8, the columns will also be averaged, and that average will be analyzed.
             %%     ~~Describe \code{Avg} here~~
  }
  \item{export}{Boolean.  Default is False.  If True, a data file is saved after interpolation and binning (per parameters). When True, each function (except Actogram) exports results to (separate) comma-delimited text files.
                %%     ~~Describe \code{export} here~~
  }
  \item{sizePts}{ sizePts is the number of minutes between samples.  
                  %%     ~~Describe \code{sizePts} here~~
  }
  \item{binPts}{ binPts is the number of samples to aggregate into one bin. Binning is very flexible since it can be so important.  sizePts * binPts = number of minutes in each bin.   Only full bins are used for analysis, so there could be a few data points at the end of the data (after binEnd) that are not used.
                 %%     ~~Describe \code{binPts} here~~
  }
  \item{Interval}{Interval & Increment are two parameters that are used together to specify a progressive analysis.  The Interval is the length of subsections of data to analyze, and the increment is how far to move ahead in the data to begin the next Interval.  (Interval will need to be large enough not to trigger the error messages in the functions, which require more than 3 cycles for each analysis.) The entire data set will be analyzed (from LumStart to binEnd).   A progressive analysis can be performed by the Auto-Correlation, Cross-Correlation and Periodogram analyses.  The Actogram and Smoothing functions are performed on the full dataset length, for each column, as normal.  
              %%     ~~Describe \code{Interval} here~~
  }
  \item{Increment}{ Interval & Increment are two parameters that are used together to specify a progressive analysis.  The increment is how far to move ahead in the data to begin the next Interval.  See Interval for complete information.
                    %%     ~~Describe \code{Interval} here~~
  }
  \item{k}{Only the Smoothing function uses this parameter.  It is a count of the number of data points on each side of a point to include in the moving average.  The moving average is calculated using 2k+1 data points.
           %%     ~~Describe \code{k} here~~
  }
  \item{yLab}{Label for the Y axis on Smoothing and Actogram functions.  Default is "Activity Level (au)"
              %%     ~~Describe \code{yLab} here~~
  }
  \item{modulo}{Only the Actogram function uses this parameter. It specifies the width in minutes to be used for displaying the Actogram.  Default is 1440 min, or 1 day.  
                %%     ~~Describe \code{modulo} here~~
  }
  \item{Rverbose }{Can take on values of -1, 0,1 or 2.  0 turns off debug information.  1 or 2 add increasing amounts of debug information. -1 minimizes information displayed on graphs.
                   %%     ~~Describe \code{Rverbose} here~~
  }
  \item{RmaxGap}{specifies the maximum allowable number of missing data points in any one block.   An error will be returned if gaps larger than this are found in a data file.
                 %%     ~~Describe \code{RmaxGap} here~~
  }
  \item{header}{ TRUE/FALSE to indicate if the file has a header.  Headers are used to  name variables.
                 %%     ~~Describe \code{header} here~~
  }
  \item{Skip}{ is a parameter to the R read.table function indicating how many rows to skip before reading data.  (A header is read after lines skipped if header=TRUE.) 
               %%     ~~Describe \code{Skip} here~~
  }
  \item{Smoothing}{Default is Smoothing=FALSE;  Smoothing=TRUE will cause this function to run, thus you select only the functions you need for any purpose.
                   %%     ~~Describe \code{Smoothing} here~~
  }
  \item{Actogram}{ Default is Actogram=FALSE;  Actogram=TRUE will cause this function to run, thus you select only the functions you need for any purpose.
                   %%     ~~Describe \code{Actogram} here~~
  }
  \item{AutoCorr}{ Default is AutoCorr=FALSE;  AutoCorr=TRUE will cause this function to run, thus you select only the functions you need for any purpose.
                   %%     ~~Describe \code{AutoCorr} here~~
  }
  \item{CrossCorr}{Default is CrossCorr=FALSE;  CrossCorr=TRUE will cause this function to run, thus you select only the functions you need for any purpose.
                   %%     ~~Describe \code{CrossCorr} here~~
  }   
  \item{Console}{Default is FALSE.  When Console=TRUE output will be redirected to the RStudio Console, instead of an output file.
                 %%     ~~Describe \code{Console} here~~
  }
  \item{Graphics}{Results of CatCall are sent to a file when Console=FALSE.  Default file output type is "pdf".   Possible values: "jpg, pdf, tiff, png".   
                  %%     ~~Describe \code{Console} here~~
  }
  \item{Darkness}{ This refers to the illumination column in the first file.  CAT analysis and graphing begins at darkness onset, as indicated by the luminance column.  Normally, darkness is indicated by a very small number (<10) and light is a large number (>=10).  If this is needed to be reversed, changing the Darkness 1 or Darkness 2 defaults will correct the interpretation of the lumninance column for file1 or file2, respectively.  Darkness=0 means that darkness is a small number (<10);  Darkness=1 indicates light is a very small number, and darkness is a large number (>=10).. 
                  %%     ~~Describe \code{Darkness1} here~~
                  }
                  
  \item{LagPcnt}{  Specifies maximal lag used to calculate the Autocorrelation and Crosscorrelation functions, expressed as a percentage of the number of data.
                  %%     ~~Describe \code{LagPcnt} here~~
                  }
  \item{tz}{R timezone code.  Default GMT should be used in most cases.   
                  %%     ~~Describe \code{tz} here~~
  		}
  \item{fileName}{This is a required field, used by all functions.   If this is blank, CATCosinor will solicit a file from the user by a dialogue box.  
                  %%     ~~Describe \code{fileName} here~~
                  } 
		\item{file2}{Optional.  Only needed when running the Crosscorrelation function. A list of parameters for the second file, mirroring those for the first file.  
                  %%     ~~Describe \code{file2.Name_} here~~
                  
 		  TimeCol: Same as TimeCol above.  
                  %%     ~~Describe \code{TimeCol } here~~
  		timeFormat: Same as timeFormat above.
                    %%     ~~Describe \code{timeFormat } here~~
  		lum: Same as lum above.
             %%     ~~Describe \code{lum} here~~
  		valCols: Same as valCols above. 
                 %%     ~~Describe \code{valCols} here~~
  		sumCols: Same as sumCols above. 
                 %%     ~~Describe \code{sumCols} here~~
  		sizePts: Same as sizePts above. 
             %%     ~~Describe \code{sizePts} here~~
  		binPts: Same as binPts above. 
                %%     ~~Describe \code{binPts} here~~
  		Darkness:  Same as Darkness for the first file.
                  %%     ~~Describe \code{Darkness2} here~~
                  } 

}
                  \section{Input Data:}{  
                  Input data is assumed to be equidistant.  All columns are expected to be numeric.  
                  Data File format:  Tab- or comma-delimited (.txt) file with the following columns: time, luminance, data col1 [, data col2] . . .[, data coln]

Cross-Correlation requires 2 data files, where other functions require only one data file. A single data file with many data columns can be specified for analysis, in which case the Cross-Correlation function is skipped; or 2 data sets can be analyzed.  In all cases, interpolation is done to fill in missing data points; and then analysis is done on each specified data column in a file, as well as on the average of all columns individually analyzed (if selected).  
                  }
                  \section{Output Data:}{  
                  Sample graphics output file:  The output file is a graphics file.  See Output section on the web site for a sample of a full output file.  All output filenames contain the input data filename to clearly identify the data file under analysis, and a timestamp to show the time of analysis.  Each graph lists the column name being analyzed (or averaged),  and the starting and ending times of analysis, as they vary slightly from the full data set (Lum to binEnd).       
                  Graphic output files can be in JPG, PDF, TIFF or PNG.  TIFF and PNG are higher resolution than jpeg and PDF.  Plots in PNG and JPEG formats can easily be converted to many other bitmap formats, and both can be displayed in modern web browsers. The PNG format is lossless and is best for line diagrams and blocks of color. The JPEG format is lossy, but may be useful for image plots, for example. It is most often used in html web pages.  TIFF is a meta-format: the default format written by TIFF is lossless and stores RGB (and alpha where appropriate) values uncompressed.  Such files are widely accepted, but often much larger than other file types.
                  Binned data:  The input data is interpolated and binned.  This transformed data can be exported using the export parameter.  If export=True then each function (except Actogram) exports a file with the results of the function. 
                  %%  ~~ If necessary, more details than the description above ~~
                  }      
                  
                  \references{http://564394709114639785.weebly.com/running-cat.html
                  %% ~put references to the literature/web site here ~
                  }
                  \author{Cathy Lee Gierke, John A Lindgren, Ruth Ann Helget, Germaine Cornelissen-Guillaume
                  
                  Maintainer: \email{ Cathy Lee Gierke <leegi001@umn.edu>}
                  }
                  
                  %% ~Make other sections like Warning with \section{Warning }{....} ~
                  
                  \examples{
                  #---------------------   Vignette3      visualization
                  
                  #   
                  #  Normally you would use these lines to read a file for use in CATkit 
                  #   (use filePath format for your OS)
                  # filePath<-"~/file/path/Installing CAT/Vignette3"          # use for mac
                  # filePath<-"c:\\file\\path\\Installing CAT\\Vignette3"     # use for PC
                  # fileName<-file.path(filePath,'activity-stress-c57-2-part.txt')
                  # file2Name<-file.path(filePath,'good-6d-2m-part.txt')
                  #
                  # these lines are used instead of the above since it is part of a package.
                  file.copy(system.file("extdata", "activity-stress-c57-2-part.txt", 
                    package = "CATkit"), tempdir(), overwrite = TRUE, recursive = FALSE, 
                    copy.mode = TRUE, copy.date = FALSE)
                  file.copy(system.file("extdata", "good-6d-2m-part.txt", package = "CATkit"), 
                    tempdir(), overwrite = TRUE, recursive = FALSE, copy.mode = TRUE, 
                    copy.date = FALSE)
                  filePath<-tempdir()
                  fileName<-file.path(filePath,'activity-stress-c57-2-part.txt')
                  file2Name<-file.path(filePath,'good-6d-2m-part.txt')

                  #fileName<-system.file("extdata", "activity-stress-c57-2-part.txt", 
                    #package = "CATkit")
                  #file2Name<-system.file("extdata", "good-6d-2m-part.txt", package = "CATkit")
                  # 
                  CatCall(TimeCol=c(1,2), timeFormat="\%d/\%m/\%y \%H:\%M:\%S",lum=NA, 
                    valCols=5, sumCols=c(), Avg=FALSE, export=TRUE, sizePts=2, binPts=30, 
                    Interval = 0, Increment=0, k=5, yLab=NA, modulo=1440, Rverbose=0, RmaxGap=3000, 
                    Skip=0, header=TRUE, Smoothing=TRUE, Actogram=TRUE,AutoCorr=TRUE, 
                    CrossCorr=TRUE,Console=FALSE,Graphics="pdf", Darkness=0, LagPcnt=1,
                    fileName=fileName, file2=list(Name=file2Name,TimeCol=c(1,2), 
                      timeFormat="\%d/\%m/\%y \%H:\%M:\%S", lum=NA, valCols=5, sumCols=c(),
                      sizePts=2, binPts=30,Darkness=0))
                  }
                  
                  
                  % Add one or more standard keywords, see file 'KEYWORDS' in the
                  % R documentation directory.
                  \keyword{ ~ Actogram }
                  \keyword{ ~ Smoothing }
                  \keyword{ ~ Autocorrelation }
                  \keyword{ ~ Crosscorrelation }
                  \keyword{ ~ cosinor }
                  \keyword{ ~ chronomics }