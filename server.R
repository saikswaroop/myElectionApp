library(ggplot2)
library(shiny)
library(httr)
election_result=content(GET("https://raw.githubusercontent.com/kuberiitb/analytics/master/const_wise_election_result_2014.csv",destfile="const_wise_election_result_2014.csv"),type="text/csv")

#summary(election_result)

shinyServer(function(input, output){
  passData <- reactive({
    if(input$state!="India"){
      statedata <- election_result[which(election_result$State %in% input$state),]
    }else{
      statedata <- election_result
    }
  partyColor=data.frame(
	party=c("Bharatiya Janata Party", "Indian National Congress", "Bahujan Samaj Party", "India Trinamool Congress", "Samajwadi Party", "All India Anna Dravida Munnetra Kazhagam", "Communist Party of India  (Marxist)", "Telugu Desam", "Yuvajana Sramika Rythu Congress Party", "Aam Aadmi Party", "Shivsena", "Dravida Munnetra Kazhagam", "Biju Janata Dal", "Nationalist Congress Party", "Rashtriya Janata Dal", "Telangana Rashtra Samithi", "None of the Above", "Janata Dal  (United)", "Communist Party of India"),
	color=c("darkorange","green", "darkblue","chartreuse","red","limegreen","red3","yellow","lightslateblue","white","darkorange3","darkred","darkolivegreen1","green","green","hotpink","grey","forestgreen","red3"))
    
    summary=with(statedata,aggregate(Votes,by=list(Party),FUN=sum))
    wins=with(subset(statedata,winner==1),aggregate(Votes,by=list(Party),FUN=length))
    summary=merge(summary, wins,by="Group.1",all.x=TRUE)
    names(summary)<-c("party","votes","seats")
    summary[is.na(summary)] = 0
    partySorted=summary[order(-summary$votes),]
    partySorted$percent=partySorted$votes/sum(partySorted$votes)
    partySortedRem=subset(partySorted,partySorted$percent<0.01)
    partySorted=subset(partySorted,partySorted$percent>=0.01)
    #str(partySorted)
    #levels(partySorted$party)<-c(levels(partySorted$party),"Others")
    partySorted[nrow(partySorted)+1,"party"] = "Others"
    partySorted[nrow(partySorted),"votes"] = sum(partySortedRem$votes)
    partySorted[nrow(partySorted),"percent"] = sum(partySortedRem$percent)
    partySorted[nrow(partySorted),"seats"] = sum(partySortedRem$seats)
    #factor(partySorted$party)
    #partySorted$percent=NULL
  
    #partySorted$percent=ifelse(partySorted$votes/sum(partySorted$votes)>=0.02,paste0(formatC(partySorted$votes/sum(partySorted$votes)*100,digits=2,format="f"),"%"),"")
    partySorted$percent=paste0(formatC(partySorted$votes/sum(partySorted$votes)*100,digits=2,format="f"),"%")
    #partySorted$pos=ifelse(partySorted$votes/sum(partySorted$votes)>=0.02,partySorted$votes/2,0)
    
    partySorted=merge(partySorted, partyColor,by.x="party",all.x=TRUE)
    partySorted$color=as.character(partySorted$color)
    partySorted$color[which(is.na(partySorted["color"]))] <- "grey"
    partySorted=partySorted[order(-partySorted$votes),]
    partySorted
    
  })
  #output$info <- renderPrint(cat("Voting Percentage in",input$state[[1]],"is"))
  
  output$statePlot <- renderPlot(
    print(ggplot(passData(),aes(x=reorder(party,-votes), y=votes, fill=factor(color)))+geom_bar(stat="identity",fill=factor(passData()$color),color="black")+ coord_flip()+
        scale_x_discrete(limits=levels(passData()$color)[order(passData()$votes),decreasing=TRUE])+
        scale_fill_manual(values=order(passData()$color,passData()$votes))+
        ggtitle(paste("Vote distribution in",input$state[[1]]))+ 
        #geom_text(aes(y=pos,label=percent),size=5,colour="black",position="identity") +
        geom_text(aes(y=-max(votes)/15, label=percent),size=4,colour="black") +
        scale_y_continuous(breaks=seq(from=0, to=max(passData()$votes), by=floor(max(passData()$votes)/5)),
            label=paste0(formatC(seq(from=0, to=max(passData()$votes), 
                                    by=floor(max(passData()$votes)/5))/sum(passData()$votes)*100,format="f",digits=0),"%")) +
        #scale_y_continuous(breaks=NULL) +
        labs(y="Votes",x="Party")+
          theme(
            plot.title=element_text(face="bold", size=20)
            ,plot.background = element_blank()
            ,panel.grid.minor = element_blank()
            ,panel.grid.major.x = element_blank()
            ,panel.border = element_blank()
          )
    )
  )
  
  output$seatPlot <- renderPlot(
    print(ggplot(passData(),aes(x=reorder(party,-seats), y=seats,fill=factor(color)))+geom_bar(stat="identity",fill=factor(passData()$color),color="black")+ coord_flip()+
            scale_x_discrete(limits=levels(passData()$color)[order(passData()$seats),decreasing=TRUE])+
            scale_fill_manual(values=order(passData()$color,passData()$seats))+
            ggtitle(paste("Seat distribution in",input$state[[1]]))+ 
            #geom_text(aes(y=pos,label=percent),size=5,colour="black",position="identity") +
            geom_text(aes(y=-max(seats)/15, label=seats),size=4,colour="black") +
            scale_y_continuous(breaks=seq(from=0, to=max(passData()$seats)+1, by=floor(max(passData()$seats)/5+1))) +
            #scale_y_continuous(breaks=NULL) +
            labs(y="seats",x="Party")+
            theme(
              plot.title=element_text(face="bold", size=20)
              ,plot.background = element_blank()
              ,panel.grid.minor = element_blank()
              ,panel.grid.major.x = element_blank()
              ,panel.border = element_blank()
            )
    )
  )
  
    
})
