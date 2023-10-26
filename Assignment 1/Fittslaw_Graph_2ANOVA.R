# 2D Fitts' Law analysis & graph
# by Wen Ying 

library(ggplot2)
library(hrbrthemes)
library(ggsci)

#read csv file
fittslaw_init.data <- read.csv("./extracted/Data_Mouse_overall.csv", 
                               header = TRUE, colClasses = c("factor", "factor", "factor", "factor", "factor", "factor", "numeric", "numeric", "numeric"))

summary(fittslaw_init.data)

#Creating bar plots comparing mean completion time by hand
CTdm <- fittslaw_init.data[fittslaw_init.data$Hand.Dominance=="Dominant",]$Mean.Completion.Time..ms.
CTnondm <- fittslaw_init.data[fittslaw_init.data$Hand.Dominance=="Non-Dominant",]$Mean.Completion.Time..ms.

CThand <- data.frame(
  factor = c("Dominant", "Non-Dominant"),
  value = c(mean(CTdm), mean(CTnondm)),
  sd = c(sd(CTdm), sd(CTnondm))
)

ggplot(CThand, aes(x=factor, y=value, fill=factor)) +
  geom_bar(position="dodge", stat="identity", width=0.6)+
  geom_errorbar( aes(ymin=value-sd, ymax=value+sd), width=0.2, linewidth=1.5) +
  xlab("Hand Dominance") +
  ylab("Mean Completion Time (ms)") +
  theme_ipsum() +
  scale_fill_d3()+
  theme(
    axis.text.x=element_text(size=rel(2)),
    axis.text.y=element_text(size=rel(2)),
    axis.title.y = element_text(size = rel(2), margin = margin(1*c(0.7,0.7,0.7,0.7), unit = "cm"), hjust = 0.5),
    axis.title.x = element_text(size = rel(2), margin = margin(1*c(0.7,0.7,0.7,0.7), unit = "cm"), hjust = 0.5),
    legend.position="none"
  )

#Creating bar plots comparing mean completion time by sessions
CTS1 <- fittslaw_init.data[fittslaw_init.data$Session.Code=="S1",]$Mean.Completion.Time..ms.
CTS2 <- fittslaw_init.data[fittslaw_init.data$Session.Code=="S2",]$Mean.Completion.Time..ms.
CTS3 <- fittslaw_init.data[fittslaw_init.data$Session.Code=="S3",]$Mean.Completion.Time..ms.
CTS4 <- fittslaw_init.data[fittslaw_init.data$Session.Code=="S4",]$Mean.Completion.Time..ms.
CTS5 <- fittslaw_init.data[fittslaw_init.data$Session.Code=="S5",]$Mean.Completion.Time..ms.

CTS <- data.frame(
  factor = c("S1", "S2", "S3", "S4", "S5"),
  value = c(mean(CTS1), mean(CTS2), mean(CTS3), mean(CTS4), mean(CTS5)),
  sd = c(sd(CTS1), sd(CTS2), sd(CTS3), sd(CTS4), sd(CTS5))
)

ggplot(CTS, aes(x=factor, y=value, fill=factor)) +
  geom_bar(position="dodge", stat="identity", width=0.7)+
  geom_errorbar( aes(ymin=value-sd, ymax=value+sd), width=0.2, linewidth=1.5) +
  xlab("Session") +
  ylab("Mean Completion Time (ms)") +
  theme_ipsum() +
  scale_fill_d3()+
  theme(
    axis.text.x=element_text(size=rel(2)),
    axis.text.y=element_text(size=rel(2)),
    axis.title.y = element_text(size = rel(2), margin = margin(1*c(0.7,0.7,0.7,0.7), unit = "cm"), hjust = 0.5),
    axis.title.x = element_text(size = rel(2), margin = margin(1*c(0.7,0.7,0.7,0.7), unit = "cm"), hjust = 0.5),
    legend.position="none"
  )


#2-way ANOVA for completion time within hand and sessions
CT <- fittslaw_init.data$Mean.Completion.Time..ms.
Hand <- factor(fittslaw_init.data$Hand.Dominance)
Session <- factor(fittslaw_init.data$Session.Code)
Participant <- factor(fittslaw_init.data$Participant.Code)

fittslaw_ANOVA.data <- data.frame(Hand, Session, Participant, CT)

options(contrasts=c("contr.sum", "contr.poly"))

fittslaw_ANOVA2.data <- data.frame(with(fittslaw_ANOVA.data, cbind(CT[Hand=="Dominant"&Session=="S1"],CT[Hand=="Non-Dominant"&Session=="S1"],
                                                                   + CT[Hand=="Dominant"&Session=="S2"],CT[Hand=="Non-Dominant"&Session=="S2"],
                                                                   + CT[Hand=="Dominant"&Session=="S3"],CT[Hand=="Non-Dominant"&Session=="S3"],
                                                                   + CT[Hand=="Dominant"&Session=="S4"],CT[Hand=="Non-Dominant"&Session=="S4"],
                                                                   + CT[Hand=="Dominant"&Session=="S5"],CT[Hand=="Non-Dominant"&Session=="S5"])))
result <- aov(CT ~ Hand*Session, data = fittslaw_ANOVA2.data)
summary(result)

#post-hoc tests
TukeyHSD(result)

#Shapiro-Wilk Test for normality test
shapiro.test(residuals(result))

#log tranform
fittslaw_ANOVA2_transformed.data <- log(fittslaw_ANOVA2.data)
result <- aov(CT ~ Hand*Session, data = fittslaw_ANOVA2_transformed.data)
summary(result)
