phase <-
function(phix,c33,c23,acr){
  phi<-atan(phix)
  xt<-c33*cos(phi)+c23*sin(phi)
  if (xt < 0){
    phi<-phi+pi
  }
  phi<-phi*180/pi
  angle<-phi+acr
  if(angle > 0){
    angle <- angle - 360
  }
  if(angle < -360){
    angle <- angle + 360
  }
  return(angle)
}
