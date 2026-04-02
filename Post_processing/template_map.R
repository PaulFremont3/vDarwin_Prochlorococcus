source('functions_map.R')
pdf(paste('template_map.pdf', sep=''), width = 10, height = 6)
min_lo=-20
max_lo=360
min_lt=-84.5
max_lt=90
step_lo=60
step_lt=30
template_map(min_lo, max_lo, min_lt, max_lt)
segments(lon0,lat0, lon1,lat1, lwd=3)
axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
dev.off()
