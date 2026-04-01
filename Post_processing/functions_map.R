axis_map <- function(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt) {
  # X-axis (bottom)
  axis(1, pos=min_lt, at=seq(0, 360, step_lo),
       cex.axis=1.5, tck=-0.03, las=1, font=2,
       labels=c(paste(seq(0, 180, step_lo), '°E', sep=''), paste(seq(180-step_lo, 0, -step_lo), '°W', sep='')),
       lwd=1.4, padj=0)
  
  # Y-axis (left)
  axis(2, pos=max(c(0, min_lo)), at=c(-84.5, seq(-90+step_lt, -10, step_lt),0 , seq(step_lt, 80, step_lt), 90),
       cex.axis=1.5, tck=-0.03, las=1, font=2,
       labels=c(NA, paste(seq(90-step_lt, 10, -step_lt),'°S', sep=''), '0', paste(seq(step_lt, 80, step_lt),'°N', sep=''), NA),
       lwd=1.4, padj=0.45)
  
  # Top axis
  axis(3, pos=max_lt, at=c(0, 60, 120, 180, 240, 300, 360), labels=F, tck=0, lwd=1.4)
  
  # Right axis
  axis(4, pos=max_lo, at=c(-84.5, -60, -30, 0, 30, 60, 90), labels=F, tck=0, lwd=1.4)
}


template_map=function(min_lo, max_lo, min_lt, max_lt){
  maps::map(database="world2",fill=T,col="black",border="black",xpd=F,  xlim=c(min_lo, max_lo), ylim=c(min_lt, max_lt))
  rect(min_lo, min_lt-100, max_lo, min_lt, col = 'white', border='white')
  rect(min_lo, max_lt, max_lo, max_lt+100, col = 'white', border = 'white')
}

template_map_xpd=function(min_lo, max_lo, min_lt, max_lt){
  maps::map(database="world2",fill=T,col="black",border="black",xpd=T,  xlim=c(min_lo, max_lo), ylim=c(min_lt, max_lt))
  rect(min_lo, min_lt-100, max_lo, min_lt, col = 'white', border='white')
  rect(min_lo, max_lt, max_lo, max_lt+100, col = 'white', border = 'white')
  usr <- par("usr")
  rect(usr[1], usr[3], usr[2], usr[3] + 5,
     col = "white", border = 'white')
}


template_map_mar=function(min_lo, max_lo, min_lt, max_lt){
  par(mar = c(5.1, 4.1, 4.1, 0.5))
  maps::map(database="world2",fill=T,col="black",border="black",xpd=F,  xlim=c(min_lo, max_lo), ylim=c(min_lt, max_lt))
  rect(min_lo, min_lt-100, max_lo, min_lt, col = 'white', border='white')
  rect(min_lo, max_lt, max_lo, max_lt+100, col = 'white', border = 'white')
}

template_map_no_fill=function(min_lo, max_lo, min_lt, max_lt){
  #plot(0,0, xpd=F,  xlim=c(min_lo, max_lo), ylim=c(min_lt, max_lt))
  maps::map(database="world2",fill=F,col=scales::alpha("white", 0),border=scales::alpha("white", 0),xpd=F,  xlim=c(min_lo, max_lo), ylim=c(min_lt, max_lt))
  rect(min_lo, min_lt-100, max_lo, min_lt, col = 'white', border='white')
  rect(min_lo, max_lt, max_lo, max_lt+100, col = 'white', border = 'white')
}

striped_band <- function(min_lo, max_lo, lat_min, lat_max,
                         spacing = 6,
                         tilt = 0.5,
                         col = rgb(0,0,0,0.7),
                         lwd = 2) {

  dx <- lat_max - lat_min

  lon_min <- 1
  lon_max <- 359
  lat_clip_min <- -83.5
  lat_clip_max <- 89

  for (x in seq(min_lo - dx, max_lo + dx, by = spacing)) {

    x0 <- x
    y0 <- lat_min
    x1 <- x + tilt * dx
    y1 <- lat_max

    # --- longitude clipping ---
    if (x0 < lon_min) {
      y0 <- y0 + (y1 - y0) * (lon_min - x0) / (x1 - x0)
      x0 <- lon_min
    }

    if (x1 < lon_min) next

    if (x1 > lon_max) {
      y1 <- y0 + (y1 - y0) * (lon_max - x0) / (x1 - x0)
      x1 <- lon_max
    }

    if (x0 > lon_max) next

    # --- latitude clipping ---
    if (y0 < lat_clip_min) {
      x0 <- x0 + (x1 - x0) * (lat_clip_min - y0) / (y1 - y0)
      y0 <- lat_clip_min
    }

    if (y1 < lat_clip_min) next

    if (y1 > lat_clip_max) {
      x1 <- x0 + (x1 - x0) * (lat_clip_max - y0) / (y1 - y0)
      y1 <- lat_clip_max
    }

    if (y0 > lat_clip_max) next

    segments(x0, y0, x1, y1, col = col, lwd = lwd)
  }
}
#striped_band <- function(min_lo, max_lo, lat_min, lat_max,
#                         spacing = 6,
#                         tilt = 0.5,
#                         col = rgb(0,0,0,0.7),
#                         lwd = 2) {
#
#  dx <- lat_max - lat_min
#
#  for (x in seq(min_lo - dx, max_lo + dx, by = spacing)) {
#
#    x0 <- x
#    y0 <- lat_min
#    x1 <- x + tilt * dx
#    y1 <- lat_max
#
#    # clip to longitude range [1,359]
#    if (x0 < 1) {
#      y0 <- y0 + (y1 - y0) * (1 - x0) / (x1 - x0)
#      x0 <- 1
#    }
#
#    if (x1 < 1) next
#
#    if (x1 > 359) {
#      y1 <- y0 + (y1 - y0) * (359 - x0) / (x1 - x0)
#      x1 <- 359
#    }
#
#    if (x0 > 359) next
#
#    segments(x0, y0, x1, y1, col = col, lwd = lwd)
#  }
#}

