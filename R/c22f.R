c22f <-
function(mati,b_hat,g_hat,k,amp){
    c22 <- (mati[2,2] * b_hat^2 + 2*mati[2,3]*b_hat*g_hat + mati[3,3] * g_hat^2) / (k * amp^2)
    return(c22)
  }
