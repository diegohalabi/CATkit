\name{CATparam}
\alias{CATparam}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Population-mean Cosinor Test (PMCtest)
%%  ~~function to do ... ~~
}
\description{Statistical test performed on the output parameters from the PMC, testing the equality of rhythm parameters (MESOR, Amplitude, Acrophase) from two or more populations, considered singly or (Amplitude, Acrophase) jointly.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
CATparam(data, fileName, colNames, GrpID = NA, VarID = NA, alpha = 0.05, 
       header=FALSE, sep="\t", Output=list(Doc=TRUE, Txt=FALSE), 
       functionName="", title="")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{data}{(optional) An array of data;  either a data frame object or a fileName must be provided
%%     ~~Describe \code{x} here~~
}
\item{fileName}{(optional) A data file with path;  either a data frame or a fileName must be provided. "/" is used on Macs in the file pathname; "/" changes to "\\" on PCs.
%%     ~~Describe \code{x} here~~
}
\item{colNames}{Specific column names are required by the program:  PR, MESOR, Amp, Phi (case insensitive).  Must be specified if column headers are absent, or if you wish to rename columns. 
%%     ~~Describe \code{x} here~~
}
\item{GrpID}{(required)  a vector of column names (or numbers) referring to factors to be used for comparing populations among levels (group identifiers) within each factor (GrpID).  There must be at least 2 levels in any GrpID column, as a PMC test compares parameters between two or more populations.  Populations are compared among all levels, as well as all level pairs, for each factor (GrpID).  If multiple GrpIDs are specified, corresponding to multiple factors, comparisons are performed within each factor separately -- populations identified by one GrpID are not compared to populations identified by a different GrpID. 
%%     ~~Describe \code{x} here~~
}
\item{VarID}{(optional) a single column can be included as a Variable.  There must be at least 2 unique names in any VarID column.  All population comparisons defined under GrpID are performed separately for each level in VarID.  A column would be specified as a VarID if it makes no sense to combine multiple levels (values) for PMC -- such as combining temperature with blood pressure, or rhythm parameters related to different trial periods. 
%%     ~~Describe \code{x} here~~
}
\item{alpha}{significance level (p) for testing  (default = .05).
%%     ~~Describe \code{x} here~~
}
\item{header}{does the file have a header? (default = TRUE);  column headers are used as column names unless colNames is used.
%%     ~~Describe \code{x} here~~
}
\item{sep}{is the file tab delimited ("\\t") or comma delimited (",")  (default = "\\t").
%%     ~~Describe \code{x} here~~
}
\item{Output}{Doc=TRUE will output an RTF file;  Doc=FALSE will not.  Output is always sent to the console.
%%     ~~Describe \code{x} here~~
}
\item{functionName}{a short descriptor, this will be used as a part of the file name for use in identifying output.
%%     ~~Describe \code{x} here~~
}
\item{title}{A longer text descriptor printed out in the header of the result file.
%%     ~~Describe \code{x} here~~
}
}
\section{Input Data:}{  
                  The PMCtest uses the parameters resulting from a single- or multiple-component single cosinor as input.

Data format:  Comma or tab delimited file.  There are four required column headers, one optional VarID (variable) column, and one or more GrpID (factor) columns:   
PR, MESOR, Amp, Phi, variable, factor1, factor2, ....
                  }
                  
\section{Output:}{  
                  Data Format:  An .rtf data file is written to the same file path where the data file is found.

Returned:  An output data frame is returned from the function call, and printed to the console.
                  }
                  
\references{http://564394709114639785.weebly.com/running-cat-PMCtest.html
                  %% ~put references to the literature/web site here ~
                  }
\author{Cathy Lee Gierke, Germaine Cornelissen-Guillaume
                  
                  Maintainer: \email{ Cathy Lee Gierke <leegi001@umn.edu>}
                  }
                  
                  %% ~Make other sections like Warning with \section{Warning }{....} ~
                  
 \examples{
                # Data is from east Indian subjects:  lipids, smoking, diet, gender, age group
                #        every 6 hours.
                #---------------------  Vignette5    Population-Mean Cosinor Parameter test
                # testing equivalency of parameters from the Population Mean Cosinor
                # according to behavioral factors and lipids for a population of subjects

                #  Normally you would use these lines to read a file for use in CATkit 
                #        (use filePath format for your OS)
                # filePath<-"~/file/path/Installing CAT/Vignette4"          # use for mac
                # filePath<-"c:\\file\\path\\Installing CAT\\Vignette4"     # use for PC
                # fileName<-file.path(filePath,'cos02x03.csv')
                
                # this line is used instead of the above since it is part of a package.
                file.copy(system.file("extdata", "cos02x03.csv", package = "CATkit"), 
                    tempdir(), overwrite = TRUE, recursive = FALSE, copy.mode = TRUE, 
                    copy.date = FALSE)
                filePath<-tempdir()
                fileName<-file.path(filePath,'cos02x03.csv')

                #fileName<-system.file("extdata", "cos02x03.csv", package = "CATkit")
                CATparam(fileName=fileName, VarID=8, GrpID=c(5,10),header=TRUE,
                sep=",",functionName="V8,G5,10", title="PMCtest V8,G5,10")
                }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~Population-mean Cosinor }
\keyword{ ~pmc }
\keyword{ ~Population-mean Cosinor Parameter test}
\keyword{ ~PMC test }
\keyword{ ~parameter test }
\keyword{ ~cosinor }% __ONLY ONE__ keyword per line
