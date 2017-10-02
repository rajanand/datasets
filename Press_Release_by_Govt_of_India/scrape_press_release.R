#load required libraries
library(tidyverse)
library(rvest)
library(stringr)
library(lubridate)

scrape_press_release_data <- function(pr_start = 1, pr_end = 171322) {
    #create empty df to hold all the data
    pr_df <- data.frame(matrix(ncol = 5, nrow = 0))
    pr_df_colnames <- c("id","datetime","ministry_name","title","content")
    colnames(pr_df) <- pr_df_colnames
    pr_base_url <- "http://pib.nic.in/newsite/PrintRelease.aspx?relid="
    
    for(pr_id in pr_start:pr_end) {
        pr_url <- paste(pr_base_url,pr_id, sep="")
        pr_html <- read_html(pr_url, encoding = "latin1")
        
        pr_datetime <- pr_html %>%
          html_nodes(xpath = '//*[@id="thd1"]/span') %>%
          html_text()
        
        pr_ministry_name <- pr_html %>%
          html_nodes(xpath = '//*[@id="thd1"]/text()[3]') %>%
          html_text()
          
        pr_title <- pr_html %>%
          html_nodes(xpath = '//*[@id="condiv"]/div[1]') %>%
          html_text()
        
        pr_content <- pr_html %>%
          html_nodes(xpath = '//*[@id="condiv"]/div[2]') %>%
          html_text()
        
        #remove multiple spaces in the text.
        pr_datetime <- gsub("\\s+", " ", str_trim(pr_datetime))
        pr_ministry_name <- gsub("\\s+", " ", str_trim(pr_ministry_name))
        pr_title <- gsub("\\s+", " ", str_trim(pr_title))
        pr_content <- gsub("\\s+", " ", str_trim(pr_content))
        
        #datatype conversion
        pr_datetime <- strptime(trimws(pr_datetime), "%d-%B-%Y %H:%M")
        
        #append data into dataframe
        if(!length(pr_datetime)==0 & !length(pr_ministry_name)==0 & !length(pr_title)==0 & !length(pr_content)==0) {
          current_pr_df <- data.frame(pr_id,pr_datetime,pr_ministry_name,pr_title,pr_content)
          pr_df <- rbind(pr_df,current_pr_df)
        }
          
        #avoid overload on server (i.e, 1 second gap for every 10 requests) 
        if(pr_id%%10 == 0){
          Sys.sleep(1)
        }
    }
    
    #write the data into a file
    file_name <- paste("press_release", min(pr_df$pr_id), max(pr_df$pr_id), sep="_")
    write.csv(pr_df, file=paste(file_name,"csv", sep="."), row.names=FALSE)
}



# execute the function
scrape_press_release_data(1,100)


