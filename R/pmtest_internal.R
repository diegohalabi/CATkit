pmtest_internal <-
function(X, alpha = 0.05, GrpID, VarID, rtf){
    
    outS <- data.frame(
      k = integer(),
      MESOR = numeric(),
      CI.M = numeric(),
      Amplitude =  numeric(),
      CI.A = numeric(),
      PHI =  numeric(),
      CI.PHI = character(),
      P = numeric(),
      errMsg = numeric()     
    )
    as.list(outS)
    
    pmc <- data.frame(
      k = integer(),
      MESOR = numeric(),
      Amplitude =  numeric(),
      PHI =  numeric(),
      P = numeric()
    )
    as.list(pmc)
    
    # total sample size
    K <- nrow(X)
    # number of populations
    m <- length(unique(X[,GrpID]))
    # population sample sizes
    k <- table(X[,GrpID])
    vecLen<-length(k)
    phi1=vector(mode="logical",length=vecLen)
    phi2=vector(mode="logical",length=vecLen)
    den=vector(mode="logical",length=vecLen)
    an1=vector(mode="logical",length=vecLen)
    an2=vector(mode="logical",length=vecLen)
    # 
    rownames<-X[,GrpID]     #   uses assertr   cjlg
    X_list <- split(X, rownames)   #   cjlg
    
    beta_star <- X$amp*cos(X$phi * pi/180)
    gamma_star <- -X$amp*sin(X$phi * pi/180)

    beta <- sapply(X_list, function(x) x$amp*cos(x$phi * pi/180), simplify = FALSE)
    beta_hat <- sapply(beta, mean)
    gamma <- sapply(X_list, function(x) -x$amp*sin(x$phi * pi/180), simplify = FALSE)
    gamma_hat <- sapply(gamma, mean)
    
    # Population MESORs
    M <- sapply(X_list, function(x) mean(x$mesor))
#browser()
    # Population Acrophases
    phi <- mapply(function(b, g) -phsrd(b, g), beta, gamma)
    phi_star <- -phsrd(beta_star, gamma_star)
    
    # Population Amplitudes
    A <- mapply(function(b, g) module(b, g), beta, gamma)
    A_star <- module(beta_star, gamma_star)

    # get sigma_matrix for each population
    #sigma_matrices <- lapply(names(X_list), function(i) {generate_sigma_matrix(X_list[[i]], beta[[i]], gamma[[i]])})
    sigma_matrices <- sapply(names(X_list), function(i) {generate_sigma_matrix(X_list[[i]], beta[[i]], gamma[[i]])},simplify=FALSE, USE.NAMES=TRUE)
    
    #  *******     CI and P for each population       **************
    df<-k-1   #cjlg
#browser()
    if (all(df>1)){       #  do not calculate if <3 rows of data
      # t-value
      tval <- qt(1-alpha/2, df)
      
      # MESOR CI          tval * sqrt(sigma_matrix[1,1]/k), 
      cim <- sapply(names(X_list), function(i) {cimf(tval[i], sigma_matrices[[i]], k[i])}, USE.NAMES=TRUE)
      
      # Amplitude CI   (sigma_matrices[2,2] * beta_hat^2 + 2*sigma_matrices[2,3]*beta_hat*gamma_hat + sigma_matrices[3,3] * gamma_hat^2) / (k * amp^2)
      c22 <- sapply(names(X_list), function(i) {c22f(sigma_matrices[[i]], beta_hat[[i]], gamma_hat[[i]], k[i], A[[i]])}, USE.NAMES=TRUE)     #    simplify=FALSE,
        
      # if (c22>0){
      #   cia <- tval*sqrt(unlist(c22))
      # }
      # else {
      #   cia<--0.1
      # }
      
      cia <- tval*sqrt(c22)
      cia[c22<=0]<--.1
      
      # Acrophase CI
      #c23 <- (-(sigma_matrices[2,2] - sigma_matrices[3,3]) * (beta_hat*gamma_hat) + sigma_matrices[2,3]*(beta_hat^2 - gamma_hat^2)) / (k * amp^2)
      c23 <- sapply(names(X_list), function(i) {c23f(sigma_matrices[[i]], beta_hat[[i]], gamma_hat[[i]], k[i], A[[i]])}, USE.NAMES=TRUE)
      #c33 <- (sigma_matrices[2,2] * gamma_hat^2 - 2 * sigma_matrices[2,3] * beta_hat * gamma_hat + sigma_matrices[3,3]*beta_hat^2) / (k * amp^2)
      c33 <- sapply(names(X_list), function(i) {c33f(sigma_matrices[[i]], beta_hat[[i]], gamma_hat[[i]], k[i], A[[i]])}, USE.NAMES=TRUE)
      #  
      #  align naming between all variables for phase() function
      names(c23)<-names(tval)
      names(c33)<-names(tval)
      
      an2 <- A^2 - (c22*c33 - c23^2) * (tval^2)/c33
      
      # if(an2 < 0){   #  this version doesn't work with vectors (to calculate the CI)
      #   phi1 <- 0
      #   phi2 <- 0
      # }else{
      #   den<-(A^2)-c22*(tval^2)
      #   an2<-tval*sqrt(c33)*sqrt(an2)
      #   an1<-c23*(tval^2)
      #   phi1=phase(phix=(an1+an2)/den,c33,c23,phi)
      #   phi2=phase(phix=(an1-an2)/den,c33,c23,phi)
      # }

      an2LT0<-which(an2<0)
      an2GTE0<-which(an2>=0)
      if (length(an2LT0)!=length(an2)){
        den<-(A^2)-c22*(tval^2)    #  removed index of an2GTE0 in this and next 2 lines;  figure out how to calc only these (NaNs otherwise)
        an2<-tval*sqrt(c33)*sqrt(an2)
        an1<-c23*(tval^2)
        names(an1)<-names(tval)
        names(den)<-names(tval)
        phi1[an2GTE0]=sapply(names(X_list)[an2GTE0], function(i) {phase(phix=(an1[i]+an2[i])/den[i],c33[i],c23[i],phi[i])}, USE.NAMES=TRUE)
        phi2[an2GTE0]=sapply(names(X_list)[an2GTE0], function(i) {phase(phix=(an1[i]-an2[i])/den[i],c33[i],c23[i],phi[i])}, USE.NAMES=TRUE)
      }
      phi1[an2LT0]<-NA  #  changed from 0 5/8/18
      phi2[an2LT0]<-NA
      
      # p-value calculation
      r <- sapply(names(X_list), function(i) {r_f(sigma_matrices[[i]])}, USE.NAMES=TRUE)
      fval <- sapply(names(X_list), function(i) {fvalf(sigma_matrices[[i]],beta_hat[[i]],gamma_hat[[i]],k[i],r[i])},USE.NAMES=TRUE)
      #p <- pf(fval, df1 = 2, df2 = k - 2, lower.tail = FALSE)
      names(fval)<-names(r)     #  fval has two part names, so set to same as r
      p <- sapply(names(X_list), function(i) pf(fval[i], df1 = 2, df2 = k[i] - 2, lower.tail = FALSE))
      
      #  *******             **************
      # Eq. 66  pooled estimate for comparison between two or more populations
      #sigma_matrix_hat <- sum((k - 1) * sigma_matrix_j / (K - m))
      sigma_matrix_hat <- Reduce(`+`, lapply(1:m, function(j) (k[j] - 1) * sigma_matrices[[j]]/(K - m)))
      
      M_bar <- sum(k * M)/K
      beta_bar <- sum(k * beta_hat)/K
      gamma_bar <- sum(k * gamma_hat)/K
      
      print("meanM, A*, phi*")
      print(mean(X$mesor))
      print(A_star)
      print(phi_star)
      
      # Eq. 67
      t_mat <- matrix(0, nrow = 3, ncol = 3)
      t_mat[1,1] <- sum(k * (M - M_bar)^2)
      t_mat[1,2] <- sum(k * (M - M_bar) * (beta_hat - beta_bar))
      t_mat[1,3] <- sum(k * (M - M_bar) * (gamma_hat - gamma_bar))
      t_mat[2,2] <- sum(k * (beta_hat - beta_bar)^2)
      t_mat[2,3] <- sum(k * (beta_hat - beta_bar) * (gamma_hat - gamma_bar))
      t_mat[3,3] <- sum(k * (gamma_hat - gamma_bar)^2)
      
      t_mat[lower.tri(t_mat)] <- t_mat[upper.tri(t_mat)]
      
      t1 <- t_mat[2:3, 2:3]
      
      # test for equal population MESORs
      # Eq. 68
      m_fval <- t_mat[1,1]/((m - 1) * sigma_matrix_hat[1,1])
      m_p <- pf(m_fval, df1 = m-1, df2 = K-m, lower.tail = FALSE)
      
      
      # multivariate test of rhythm parameters
      # Eq. 69
      J <- solve(sigma_matrix_hat[2:3, 2:3]) %*% t1
      # J <- t1/sigma_matrix_hat[2:3, 2:3]
      print(J)
      # Eq. 70
      D <- det(diag(2) + J/(K-m))
      
      # should be ~ 1.548542
      print(D)
      
      # if(m > 2){
        # Eq. 71   (same as Eq. 72, and Eq 72, below, is giving wrong output here)
        rhythm_fval <- (K-m-1)/(m-1) * (sqrt(D) - 1)
        rhythm_p <- pf(rhythm_fval, df1 = 2*m - 2, df2=2*K - 2*m - 2, lower.tail = FALSE)
        rhythm_df1<-2*m-2
        rhythm_df2<-2*K - 2*m - 2
      # }else{  #   this part of the formula was failing, but should be the same result as #71
      #   # Eq. 72
      #   rhythm_fval <- (sum(k) - 3)/2 * (D - 1)
      #   rhythm_p <- pf(rhythm_fval, df1 = 2, df2 = sum(k) - 3, lower.tail = FALSE)
      #   rhythm_df1<-2
      #   rhythm_df2<-sum(k) - 3
      # }

      # if multivariate test significant?
      # test for equivalent population acrophases (approximate)
      
      num <- sum(k * A^2 * sin(2*phi * pi/180))
      den <- sum(k * A^2 * cos(2*phi * pi/180))

      if (den==0){
        populations<-paste(names(X_list),collapse=" ")
        paste("F and P cannot be calculated for PHI.  The denominator for phi_tilda=0 for populations: ",populations)
        stop("This is a very rare case. Amplitudes and PHIs for all listed populations, together, result in 0 for sum(k * A^2 * cos(2*phi * pi/180))")
      }
      phi_tilda <- atan(num/den)/2
      if(den < 0){
        phi_tilda <- phi_tilda + pi/2
      } 
      # if all cos tilda b - sin tilda g
      # if den > 0 = -pi/4 and pi/4
      # if den < 0 = pi/4 and 3*pi/4 = 0.7853982 and 2.356194

      phi_delta<-beta_hat*cos(phi_tilda)-gamma_hat*sin(phi_tilda)
      #phi_delta<-sapply(names(X_list), function(i) {phi_deltaf(phi_tilda,beta[[i]],gamma[[i]])},simplify=TRUE, USE.NAMES=TRUE)

      # if not all pos or all neg, skip phi_fval and phi_p calculation;  set phi to NA
      if (all(phi_delta>=0) || all(phi_delta<0)){    # chg to all(phi_delta<=0) but that's not right  5/25
        # Eq. 74
        num <- sum(k * A^2 * sin((phi * pi/180) - phi_tilda)^2)/(m - 1)
        den <- (sigma_matrix_hat[2,2] * sin(phi_tilda)^2) + (2 * sigma_matrix_hat[2,3] * cos(phi_tilda) * sin(phi_tilda)) + (sigma_matrix_hat[3,3] * cos(phi_tilda)^2)
        phi_fval <- num/den
        phi_p <- pf(phi_fval, df1 = m-1, df2 = K-m, lower.tail = FALSE)
      } else {
        # do not calculate phi~, F, P if some ph_delta are + and some -
        phi_tilda<-NA
        phi_fval<-NA
        phi_p<-NA
      }
      #browser()
      phi_same<-FALSE
      #  do no calculate F and P if all PHIs are the same -- P=1
      if ((abs(max(phi) - min(phi))) < .001 || (abs(max(phi) - min(phi)) > 359.99)){   # are all equal within a tolerance of .001?
        phi_fval<-NA
        phi_p<-NA
        phi_same<-TRUE
      }
      # test for equivalent population amplitudes
      # NO KNOWN SOLUTION
      # ASSUMPTION - acrophases do not differ greatly
      # Eq. 75
      #  only calculate F and P if all As are NOT the same -- P=1
      if (abs(max(A) - min(A)) >= .0001){   # are all equal within a tolerance of .001?
        num <- sum(k * (A - A_star)^2)/(m-1)
        den <- (sigma_matrix_hat[2,2] * (cos(phi_star * pi/180)^2)) - (2 * sigma_matrix_hat[2,3] * cos(phi_star * pi/180)*sin(phi_star * pi/180)) + (sigma_matrix_hat[3,3]*(sin(phi_star * pi/180)^2))
        amp_fval <- num/den
        amp_p <- pf(amp_fval, df1 = m-1, df2 = K-m, lower.tail = FALSE)
      } else {
        #  do no calculate F and P if all Amps are the same -- P=1
        amp_fval<-NA
        amp_p<-NA
      }
      # combined params
      print("Combined:  meanM, A*, phi*")
      print(M_bar)
      print(A_star)
      print(phi_star)
      printp <- round(p, 4)
      #browser()
      printp[printp<.0005]<-c("<.001")
      # printP <- round(p, 4)
      # printP[printP<.0005]<-c("<.001")
      # out[1,"P"]<-printP

      if (A_star < .000000000001){
        phi_star<-"--"
      }
      outS<-rbind.data.frame(outS, cbind(k,MESOR=formatC(M,digits=3,format="f"),CI.M=formatC(cim,digits=3,format="f"),Amplitude=formatC(A,digits=3,format="f"),CI.A=formatC(cia,digits=3,format="f"),PHI=formatC(phi,digits=1,format="f"),CI.PHI=paste("(",round(phi1,1),",",round(phi2,1),")"),P=printp))   #  combine results from loop 1-n with loop 0   #formatC(p,digits=6,format="f"
      pmc<-rbind.data.frame(pmc, cbind(k=NA,MESOR=formatC(M_bar,digits=3,format="f"),CI.M="",Amplitude=formatC(A_star,digits=3,format="f"),CI.A="",PHI=formatC(phi_star,digits=1,format="f"),CI.PHI="",P=""))
      rownames(pmc)[1]<-"Combined parameters:"
      outS[which(A-cia<0 & p<=alpha),"errMsg"]<-paste(outS[which(A-cia<0 & p<=alpha),"errMsg"],"Warn1")
      
      if (A_star < .000000000001){
        pmc[1,"errMsg"]<- "Warn7"
      } else {
        pmc[1,"errMsg"]<-NA    #   filler to make the data forms match
      }
      
      outS<-rbind.data.frame(outS, pmc)

      if (exists("rtf")){   #  print out the matrix of pmtest for this loop
        addParagraph(rtf,paste("\nPopulation Mean Cosinor (PMC)"))
        addTable(rtf,outS, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
      }
      addParagraph(rtf,"\nTests of Equality of Parameters (PMC Test): ")
      
      P <- c(m_p, amp_p, phi_p, rhythm_p)
      printP <- formatC(P,digits=4,format="f")
      #P <- signif(c(m_p, amp_p, phi_p, rhythm_p),4)
      printP[P<.0005]<-c("<.001")
      out <- data.frame(df1 = c(m-1, m-1, m-1,rhythm_df1),
                        df2 = c(K-m, K-m, K-m,rhythm_df2),
                        F = formatC(c(m_fval, amp_fval, phi_fval, rhythm_fval),digits=4,format="f"),
                        P=printP)
      
      row.names(out) <- c("MESOR", "Amplitude", "Acrophase", "(A, phi)")
      #  Check for error conditions
      if (is.na(phi_tilda)){
        out[3,"errMsg"]<-"Warn4"
        #   #errMsg<-paste("Warning:  PHIs cannot be compared;  the values are two far apart.\n")
      } else {
        out[1,"errMsg"]<-NA    #   filler to make the data forms match
      }
      if (is.na(amp_fval) && is.na(amp_p)){
        out[2,"errMsg"]<-"Warn5"       #  Amplitudes are the same;  comparison is meaningless
      }
      if (phi_same){
        if (is.na(out[3,"errMsg"])){
          out[3,"errMsg"]<-"Warn6"       #  Acrophases are the same;  comparison is meaningless
        } else {
          out[3,"errMsg"]<-paste(out[3,"errMsg"],"; Warn6",sep="")       #  Acrophases are the same;  comparison is meaningless
          }  
        }
    }
    else {
      # if any of the elements of this combination cannot be calculated, none can be since they are done as a vector.
      outS<-rbind.data.frame(outS, cbind(k,MESOR=NA,CI.M=NA,Amplitude=NA,CI.A="",PHI=NA,CI.PHI=NA,P=NA,errMsg=""))
      pmc<-rbind.data.frame(pmc, cbind(k=NA,MESOR="--",CI.M="",Amplitude="--",CI.A="",PHI="--",CI.PHI="",P="",errMsg="Warn2"))
      rownames(pmc)[1]<-"Combined parameters:"
      
      outS<-rbind.data.frame(outS, pmc)
      if (exists("rtf")){   #  print out the matrix of pmtest for this loop
        addParagraph(rtf,paste("\nPopulation Mean Cosinor (PMC)"))
        addTable(rtf,outS, col.justify='C',header.col.justify='C' ,font.size=11,row.names=TRUE,NA.string="--")   #  chgd R --> C by gc request 2/28/18
      }
      addParagraph(rtf,"\nTests of Equality of Parameters (PMC Test): ")
      out <- data.frame(df1 = NA,
                        df2 = NA,
                        F = NA,
                        P=NA)
      out[1,"errMsg"]<-paste("Warn3")         # "Warn3:"
      #errMsg<-paste("Warning2:  There must be at least 3 cases to do a PMC;  skipping this combination.  Combined PMC cannot be calculated.\n")
      #errMsg<-paste("Warning3:  Parameter Tests will also be skipped for this combination.\n")
      
      }
  
    return(out)
  }
