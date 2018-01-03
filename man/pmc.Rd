\name{pmc}
\alias{pmc}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Population-mean Cosinor (PMC)
%%  ~~function to do ... ~~
}
\description{When data are collected as a function of time on 3 or more individuals, the population-mean cosinor procedure renders it possible to make inferences concerning a population rhythm, provided the k individuals represent a random sample from that population. Each individual series is analyzed by the single- or multiple-component single cosinor to yield estimates of population averages.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
pmc(data, fileName, colNames, GrpID = NA, alpha = 0.05, header=TRUE, sep="\t",
       Output=list(Doc=TRUE,Txt=FALSE), functionName="", title="")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{data}{(optional) An array of data;  either data or fileName must be provided
%%     ~~Describe \code{x} here~~
}
\item{fileName}{(optional) A data file, with header and sep specified, or using defaultsdata;  either data or fileName must be provided. "/" is used on Macs.  "/" changes to "\\" on PCs.
%%     ~~Describe \code{x} here~~
}
\item{colNames}{Must be specified if column headers are absent, or if you wish to rename columns. Certain column names are required by the program:  PR, Mesor, Amp, PHI (case insensitive)
%%     ~~Describe \code{x} here~~
}
\item{GrpID}{a vector of column numbers to be  used as factors in pmc (vector=NA) rownames won't have labels unless you pass a named vector of indices but the order will reflect that in the data
%%     ~~Describe \code{x} here~~
}
\item{alpha}{significance level (p) for testing  (default = .05)
%%     ~~Describe \code{x} here~~
}
\item{header}{does the file have a header? (default = TRUE);  column headers are used as column names unless colNames is used
%%     ~~Describe \code{x} here~~
}
\item{sep}{is the file tab delimited ("\\t") or comma delimited (",")  (default = "\\t")
%%     ~~Describe \code{x} here~~
}
\item{Output}{Doc=TRUE will output an RTF file;  Doc=FALSE will not.  Output is always sent to the console and returned as a frame.  Txt is not used
%%     ~~Describe \code{x} here~~
}
\item{functionName}{a short descriptor, this will be used as a part of the file name for use in identifying output
%%     ~~Describe \code{x} here~~
}
\item{title}{A longer text descriptor printed out in the header of the result file.
%%     ~~Describe \code{x} here~~
}
}
\section{Input Data:}{  
                  Data File format:  Tab- or comma-delimited (.txt) file with the following columns: PR, Mesor, Amp, PHI, factor1, factor2, ....
                  }
                  
\references{http://564394709114639785.weebly.com/running-cat.html
                  %% ~put references to the literature/web site here ~
                  }
\author{Cathy Lee Gierke, Charles Determan, Germaine Cornelissen-Guillaume
                  
                  Maintainer: \email{ Cathy Lee Gierke <leegi001@umn.edu>}
                  }
                  
                  %% ~Make other sections like Warning with \section{Warning }{....} ~
                  
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (pmc) 
{
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~Population-mean Cosinor }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~pmc }% __ONLY ONE__ keyword per line
\keyword{ ~cosinor }% __ONLY ONE__ keyword per line
