generate_sigma_matrix <-
function(X, beta, gamma){
  
  sigma_matrix <- matrix(0, nrow = 3, ncol = 3)
  #browser()
  k <- nrow(X)
  df <- k - 1
  
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
  
  return(sigma_matrix)
}
