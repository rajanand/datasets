#load required libraries
library(tidyverse)
library(rvest)
library(stringr)
library(xml2)

#create empty df to hold all the data
rajyasabha_df <- data.frame(matrix(ncol = 9, nrow = 0))
rajyasabha_df_colnames <- c("question","ministry_name","answer_date","question_type","question_no","question_by","question_title","question_description","answer")
colnames(rajyasabha_df) <- rajyasabha_df_colnames

question_start <- 1
question_end <- 10000

for(question in question_start:question_end) {
  
  get_html_parameter <- paste("phantomjs get_html.js",question)
  system(get_html_parameter)
  
  html_file_name <- paste(question, "html", sep=".")
  rajyasabha_html <- read_html(html_file_name)
  
  ministry <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_Label1"]') %>%
    html_text()
  
  answer_date <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_Label4"]') %>%
    html_text()
  
  question_type <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_Label2"]') %>%
    html_text()
  
  question_no <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_Label3"]') %>%
    html_text()
  
  question_by <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_Label7"]') %>%
    html_text()
  
  question_title <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_Label5"]') %>%
    html_text()
  
  question_description <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_GridView2"]/tbody/tr/td/table[1]/tbody/tr/td') %>%
    html_text()
  
  answer <- rajyasabha_html %>% 
    html_nodes(xpath = '//*[@id="ctl00_ContentPlaceHolder1_GridView2"]/tbody/tr/td/table[2]/tbody/tr[2]/td') %>%
    html_text()
  
  #remove multiple spaces in the text.
  question_by <- gsub("\\s+", " ", str_trim(question_by))
  question_title <- gsub("\\s+", " ", str_trim(question_title))
  question_description <- gsub("\\s+", " ", str_trim(question_description))
  answer <- gsub("\\s+", " ", str_trim(answer))
  
  if(!length(ministry) == 0 ) {
    current_question_df <- data.frame(question,ministry,answer_date,question_type,question_no,question_by,question_title,question_description,answer)
    rajyasabha_df <- rbind(rajyasabha_df,current_question_df)
  }
  
  if(question%%10 == 0) {
    Sys.sleep(1)
  }
}

#write the data into a file
file_name <- paste("rajyasabha", min(rajyasabha_df$question), max(pr_df$question), sep="_")
write.csv(rajyasabha_df, file=paste(file_name,"csv", sep="."), row.names=FALSE)




