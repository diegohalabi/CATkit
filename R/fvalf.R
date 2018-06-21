fvalf <-
function(mati,b_hat,g_hat,k,r){
    fval <- k*(k-2)/(2*(k-1) * (1-r^2)) *
      (b_hat^2/mati[2,2]-2*r*b_hat*g_hat/sqrt(mati[2,2]*mati[3,3])
       #-2*r*beta_hat*gamma_hat/sqrt(sigma_matrices[2,2]*sigma_matrices[3,3])
       +g_hat^2/mati[3,3]
      )
    return(fval)
  }
