require(ggplot2)
require(rbin)

# loads data
load_data = function(thresh=10){
  tmp_df=read.table("student_performance_data/student-por.csv",sep=";",header=TRUE)
  tmp_df$G3_bin = tmp_df$G3<=thresh
  tmp_df = subset(tmp_df, select=-c(G1, G2, G3))
  return(tmp_df)
}

# calculates frequencies of positive class in each class of a predictor variable
get_freq = function(data=NULL, resp_name=NULL, pred_name=NULL){
  vals = unique(data[, pred_name])  
  output = data.frame(matrix(0, nrow=length(vals), ncol = 1), row.names = vals)
  names(output) = c("freq")
  output$Vals = vals
  for(val in vals){
    output[toString(val), "freq"] = sum(data[, resp_name]=="TRUE" & data[, pred_name]==val) / sum(data[, pred_name]==val)
    }
  return(output)
}

# draws the histogram with the frequencies of the positive corresponding to each class of the predictor variable
get_freq_plot = function(data=NULL, resp_name=NULL, pred_name=NULL){
  d = get_freq(data = data, resp_name = resp_name, pred_name = pred_name)
  ggplot(data)+
    geom_bar(aes(x=data[, pred_name], y=after_stat(count / sum(count))), color="black", fill="white", linewidth=0.5, width=0.9)+
    scale_y_continuous(
      name = "Częstość klas zm zależnej",
      sec.axis = sec_axis(~.*1, name="Udział klasy 1 w klasie", labels = scales::percent),
      labels = scales::percent
    )+
    scale_color_grey()+scale_fill_grey()+theme_classic()+
    geom_point(data = d, aes(x=d$Vals, y=freq), col="steelblue", size=3, shape=8)+
    geom_line(data = d, aes(x=d$Vals, y=freq),  col="steelblue", linewidth=1)+
    xlab(pred_name)
}

# draws a histogram with count
get_hist = function(data = NULL, var = NULL){
  ggplot(data = data)+
    geom_bar(aes(x=data[, var], y=after_stat(count)), color="black", fill="white", size=0.5, width=0.9)+
    scale_color_grey()+scale_fill_grey()+theme_classic()+
    xlab(var)
}

# draws plots
draw_plots = function(data = NULL, varname = NULL){
  unique(data[, varname])
  get_freq(data = data, resp_name = "G3_bin", pred_name = varname)
  histogram_count = get_hist(data = data, var = varname)
  freq_plot = get_freq_plot(data = data, resp_name = "G3_bin", pred_name = varname)
  ggarrange(histogram_count, freq_plot, 
            labels = c("H", "D"),
            ncol = 2, nrow = 2)
}

# data for cumulated lift
get_lift_points = function(predictions = NULL, real_values = NULL, apriori=NULL, bins=NULL, cumulated=TRUE){
  # bins+1 if not divisible
  df = data.frame(p=as.vector(predictions), rv=as.vector(real_values))
  names(df) = c("p", "rv")
  df = df[order(df$p, decreasing = TRUE),]
  print(head(df))
  ends = c(1)
  ends = append(ends,floor(length(predictions)/bins)*(1:bins))
  #print(length(predictions))
  #print(floor(length(predictions)/bins)*(1:bins))
  if(ends[length(ends)]<length(predictions)){(ends = append(ends, length(predictions)))}
  output_points = data.frame(os_x=rep(NA, length(ends)), os_y=rep(NA, length(ends)))
  output_points[1,"os_x"] = 0
  output_points[1,"os_y"] = 1/apriori
  #print(ends)
  for(i in 2:length(ends)){
    #print(df[(ends[i-1]+1):ends[i],"rv"])
    if(cumulated){output_points[i,"os_y"] = sum(df[1:ends[i],"rv"]==TRUE)/(ends[i]*apriori)}
    else{output_points[i,"os_y"] = sum(df[(ends[i-1]+1):ends[i],"rv"]==TRUE)/((ends[i]-ends[i-1]+1)*apriori)}
    output_points[i,"os_x"] = ends[i]/length(predictions)
  }
  return(output_points)
}

# merges levels of a variables
merge_levels = function(data = NULL, varname = NULL, how_to_merge = list(c()), is_numeric = FALSE){
  new_col = data[, varname]
  if(is_numeric){
    i = 1
    for(new_lvl in how_to_merge){
      new_col[which(new_col %in% new_lvl)] = i
      i = i+1
    }
  }
  else{
    for(new_lvl in how_to_merge){
      new_col[which(new_col %in% new_lvl)] = paste(new_lvl, collapse = "_")
    }
  }
  return(new_col)
}
