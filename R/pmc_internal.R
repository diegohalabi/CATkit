pmc_internal <-
function(X, alpha = 0.05){
  #browser()
  # create output data.frame
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
    Hi.CI.PHI =  numeric(),
    errMsg = numeric()       #character()
  )
  printP = numeric()
  # phi <- intToUtf8(0x03A6)   upper case
  # phi <- intToUtf8(0x03C6)   lower case
  sigma_matrix <- matrix(0, nrow = 3, ncol = 3)

  k <- nrow(X)
  df <- k - 1
  
  if (df>1){       #  do not calculate if <3 rows of data
      beta= X$amp*cos(X$phi * pi/180)
      gamma=-X$amp*sin(X$phi * pi/180)
      
      beta_hat <- mean(beta)
      gamma_hat <- mean(gamma)
      
      # fill covariance matrix (triangular)
      sigma_matrix[1,1] <- sum((X$mesor - mean(X$mesor))^2)/df
      sigma_matrix[1,2] <- sum((X$mesor - mean(X$mesor)) %*% (beta - mean(beta)))/df
      sigma_matrix[1,3] <- sum((X$mesor - mean(X$mesor)) %*% (gamma - mean(gamma)))/df
      sigma_matrix[2,2] <- sum((beta - mean(beta))^2)/df
      sigma_matrix[2,3] <- sum((beta - mean(beta)) %*% (gamma - mean(gamma)))/df
      sigma_matrix[3,3] <- sum((gamma - mean(gamma))^2)/df
      
      # mirror lower matrix
      sigma_matrix[lower.tri(sigma_matrix)] <- sigma_matrix[upper.tri(sigma_matrix)]
      
      # Percentage Rhythm
      pr <- mean(X$pr)
      
      # Population MESOR
      mesor <- mean(X$mesor)
      
      # Population Acrophase
      acr <- -phsrd(beta, gamma)
      
      # Population Amplitude
      amp <- module(beta, gamma)
      
      # t-value
      tval <- qt(1-alpha/2, df)
      
      # MESOR CI
      cim <- tval * sqrt(sigma_matrix[1,1]/k)
      
      # Amplitude CI
      c22 <- (sigma_matrix[2,2] * beta_hat^2 + 2*sigma_matrix[2,3]*beta_hat*gamma_hat + sigma_matrix[3,3] * gamma_hat^2) / (k * amp^2)
      if (c22>0){
        cia <- tval*sqrt(c22)
      }
      else {
        cia<--0.1
      }
    
      # Acrophase CI
      c23 <- (-(sigma_matrix[2,2] - sigma_matrix[3,3]) * (beta_hat*gamma_hat) + sigma_matrix[2,3]*(beta_hat^2 - gamma_hat^2)) / (k * amp^2)
      c33 <- (sigma_matrix[2,2] * gamma_hat^2 - 2 * sigma_matrix[2,3] * beta_hat * gamma_hat + sigma_matrix[3,3]*beta_hat^2) / (k * amp^2)
      
      an2 <- amp^2 - (c22*c33 - c23^2) * (tval^2)/c33
      
      if(an2 < 0){
        phi1 <- 0
        phi2 <- 0
      }else{
        den<-(amp^2)-c22*(tval^2)
        an2<-tval*sqrt(c33)*sqrt(an2)
        an1<-c23*(tval^2)
        phi1=phase(phix=(an1+an2)/den,c33,c23,acr)
        phi2=phase(phix=(an1-an2)/den,c33,c23,acr)
        
        
        # phi1 <- phi + atan((c23 * tval^2 + tval*sqrt(c33) * sqrt(an1))/(amp^2 - c22*tval^2)) * 180/pi
        # phi2 <- phi + atan((c23 * tval^2 - tval*sqrt(c33) * sqrt(an1))/(amp^2 - c22*tval^2)) * 180/pi
        # phi1 <- phase(phi1)
        # phi2 <- phase(phi2)
      }

      # p-value calculation
      r <- sigma_matrix[2,3]/sqrt(sigma_matrix[2,2]*sigma_matrix[3,3])
      fval <- k*(k-2)/(2*(k-1) * (1-r^2)) *
        (beta_hat^2/sigma_matrix[2,2]
         -2*r*beta_hat*gamma_hat/sqrt(sigma_matrix[2,2]*sigma_matrix[3,3])
         +gamma_hat^2/sigma_matrix[3,3]
        )
      p <- pf(fval, df1 = 2, df2 = k - 2, lower.tail = FALSE)
      
      
      # This could be much more concise but doing it like this to be explicit
      out[1,"k"] <- as.integer(k)
      out[1,"P.R."] <- round(mean(X$pr),1)
      printP <- round(p, 4)
      printP[printP<.0005]<-c("<.001")
      out[1,"P"]<-printP
      out[1,"MESOR"] <- signif(mesor, 6)
      out[1,"CI.M"] <- signif(cim, 4)
      out[1,"Amplitude"] <- signif(amp, 5)
      amp_cia<-amp - cia
      
      out[1,"Lo.CI.A"] <- ifelse(p < alpha, signif(amp_cia, 5), NA)     #  round indicates # decimal places
      out[1,"Hi.CI.A"] <- ifelse(p < alpha, signif(amp + cia, 5), NA)     #  signif indicates # of significant digires
      out[1,"PHI"] <- round(acr, 1)
      out[1,"Lo.CI.PHI"] <- ifelse(p < alpha, round(phi1, 1), NA)    #  remove -.05
      out[1,"Hi.CI.PHI"] <- ifelse(p < alpha, round(phi2, 1), NA)
      #out[1,"Period"] <- perd
      if (amp_cia < 0 && p<=alpha) {
        out[1,"errMsg"]<-paste("Warn1")         # "Warn1:"
        #errMsg<-paste("Warning:  Negative CI for amplitude for ",names(X),".  This is an indicator that the data are not well behaved.\n")
      }
      if (amp < .000000000001){
        out[1,"PHI"]<-NA
        out[1,"Lo.CI.PHI"] <- NA
        out[1,"Hi.CI.PHI"] <- NA
        out[1,"errMsg"]<-paste(out[1,"errMsg"],"Warn3")         # "Warn3:  amp=0, phi undefined"
      }
  }
    else {
      out[1,"k"] <- as.integer(k)
      out[1,"P.R."] <- NA
      out[1,"P"]<-NA
      out[1,"MESOR"] <- NA
      out[1,"CI.M"] <- NA
      out[1,"Amplitude"] <- NA
      
      out[1,"Lo.CI.A"] <- NA     #  round indicates # decimal places
      out[1,"Hi.CI.A"] <- NA     #  signif indicates # of significant digires
      out[1,"PHI"] <- NA
      out[1,"Lo.CI.PHI"] <- NA    #  remove -.05
      out[1,"Hi.CI.PHI"] <- NA
      out[1,"errMsg"]<-paste("Warn2")         # "Warn2:"
        #errMsg<-paste("Warning:  There must be at least 3 cases to do a PMC.  Skipping this combination\n")
    }

  return(out )
  
}
