writeOutput <-
function(fileType,message,printFlag){
  # print to file if indicated, and always print to console
  if (printFlag){
    addParagraph(fileType,message)
  } 
  print(message)
}
