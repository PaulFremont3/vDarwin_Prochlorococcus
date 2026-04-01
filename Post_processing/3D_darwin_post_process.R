library('ncdf4')
library('viridis')
library('matlab')
library('pals')
source('functions_map.R')


directory=commandArgs(trailingOnly=T)[1]
date=commandArgs(trailingOnly=T)[2]
suffix=commandArgs(trailingOnly=T)[3]

# tracers names
names_tracers=c('Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus', '%Inf', '%Vmort', '%Zmort', '%Omort', 'Total_P', 'GR_S', 'NPP', 'DIC', 'NO3', 'NO2', 'NH4', 'PO4', 'FeT', 'SiO2', 'DOC', 'DON', 'DOP', 'DOFe', 'POC', 'PON', 'POP', 'POFe', 'POSi',
	       	'PIC', 'Alk', 'O2', 'CDOM', 'log10_DON_NO3', 'log10_DON_DIN','VL', 'GR_I','TDN', 'DIN', 'chl', 'C/chl', 'Mort_S', 'Mort_I', 'Mort', 'LR_Z', 'LR_V', 'LR_O', 'GR')
data_list=rep(list(array(NA, dim = c(360, 160, 23, 12))), length(names_tracers))
names(data_list)=names_tracers
times=seq(26160, 28800, 240)

# grid files
lon=readRDS('lon.rds')
lat=readRDS('lat.rds')
depths=readRDS('depths.rds')
depths_u=readRDS('depths_u.rds')
depths_l=readRDS('depths_l.rds')
dzs=abs(depths_l-depths_u)
dzs=as.numeric(dzs)
print(dzs)

min_lo=-20
max_lo=360
min_lt=-84.5
max_lt=90
step_lo=60
step_lt=30

# store data in a list
for (k in 1:12){
	file=list.files(path = paste('../',directory,'/diags_mds_',date,'/', sep=''),pattern = paste("biomass_c\\.00000", times[k],'.nc',sep=''))
	u=ncdf4::nc_open(paste('../',directory,'/diags_mds_',date,'/', file,sep=''))
	t1=ncdf4::ncvar_get(u, "data")
	for (j in 21:25){
      		data_list[[names_tracers[j-20]]][,,,k]=t1[,,,j]
    	}
	tracers=c('DIC', 'NO3', 'NO2', 'NH4', 'PO4', 'FeT', 'SiO2', 'DOC', 'DON', 'DOP', 'DOFe', 'POC', 'PON', 'POP', 'POFe', 'POSi', 'PIC', 'Alk', 'O2', 'CDOM')
    	count=1
	for (j in 1:20){
		namet=tracers[j]
	        nt=tracers[count]
                data_list[[nt]][,,,k]=t1[,,,j]
		count=count+1
        }
	
	file=list.files(path = paste('../',directory,'/diags_mds_',date,'/', sep=''),pattern = paste("GR\\.00000", times[k],'.nc',sep=''))
	u=ncdf4::nc_open(paste('../',directory,'/diags_mds_',date,'/', file,sep=''))
	t1=ncdf4::ncvar_get(u, 'data')	
	data_list[['GR_S']][,,,k]=t1[,,,1]*86400
	data_list[['GR_I']][,,,k]=t1[,,,2]*86400
	
	file=list.files(path = paste('../',directory,'/diags_mds_',date,'/', sep=''),pattern = paste("VL\\.00000", times[k],'.nc',sep=''))
	u=ncdf4::nc_open(paste('../',directory,'/diags_mds_',date,'/', file,sep=''))
	t1=ncdf4::ncvar_get(u, 'data')
	data_list[['VL']][,,,k]=t1[,,,2]*86400
	
	file=list.files(path = paste('../',directory,'/diags_mds_',date,'/', sep=''),pattern = paste("Mort\\.00000", times[k],'.nc',sep=''))
	u=ncdf4::nc_open(paste('../',directory,'/diags_mds_',date,'/', file,sep=''))
	t1=ncdf4::ncvar_get(u, 'data')
	data_list[['Mort_S']][,,,k]=t1[,,,1]*86400
	data_list[['Mort_I']][,,,k]=t1[,,,2]*86400
	data_list[['Mort']][,,,k]=t1[,,,1]*86400+t1[,,,2]*86400
	
	file=list.files(path = paste('../',directory,'/diags_mds_',date,'/', sep=''),pattern = paste("PP\\.00000", times[k],'.nc',sep=''))
	u=ncdf4::nc_open(paste('../',directory,'/diags_mds_',date,'/', file,sep=''))
	t1=ncdf4::ncvar_get(u, 'data')
	data_list[['NPP']][,,,k]=t1[,,,1]*86400+t1[,,,2]*86400
	
	file=list.files(path = paste('../',directory,'/diags_mds_',date,'/', sep=''),pattern = paste("chl\\.00000", times[k],'.nc',sep=''))
	u=ncdf4::nc_open(paste('../',directory,'/diags_mds_',date,'/', file,sep=''))
	t1=ncdf4::ncvar_get(u, 'data')
	data_list[['chl']][,,,k]=t1[,,,1]+t1[,,,2]
}

# calculate some new quantiites like the percentage of infected cells
p_inf=data_list[['Infected']]*100/(data_list[['Infected']]+data_list[['Susceptible']])
data_list[['%Inf']]=p_inf

data_list[['NO3']][data_list[['NO3']]<0] = min(data_list[['NO3']][data_list[['NO3']]>0] , na.rm=T)


DIN=data_list[['NO3']]+data_list[['NO2']]+data_list[['NH4']]
data_list[['DIN']]=DIN

log10_DON_NO3=log10(data_list[['DON']]/data_list[['NO3']])
data_list[['log10_DON_NO3']]=log10_DON_NO3

log10_DON_DIN=log10(data_list[['DON']]/data_list[['DIN']])
data_list[['log10_DON_DIN']]=log10_DON_DIN


data_list[['TDN']]=data_list[['DON']]+data_list[['NO3']]+data_list[['NO2']]+data_list[['NH4']]

dzs=depths_l-depths_u
dzs=abs(dzs)
dzs=as.numeric(dzs)


ds=0.075

gz=9.8*0.226*2
tau=0.37


if (grepl('no_virus', suffix)){
	data_list[['Virus']]=array(0, dim = c(360, 160, 23, 12))
}

if (grepl('no_zoop', suffix)){
        data_list[['Zooplankton']]=array(0, dim = c(360, 160, 23, 12))
}

if (grepl('no_I', suffix)){
	data_list[['Infected']]=array(0, dim = c(360, 160, 23, 12))
}


data_list[['GR']]=data_list[['GR_S']]+data_list[['GR_I']]

pVmort=data_list[['VL']]*100/(data_list[['GR_S']]+data_list[['GR_I']]+data_list[['VL']]+data_list[['Mort']])
data_list[['%Vmort']]=pVmort


pZmort=(data_list[['GR_S']]+data_list[['GR_I']])*100/(data_list[['GR_S']]+data_list[['GR_I']]+data_list[['VL']]+data_list[['Mort']])
data_list[['%Zmort']]=pZmort


pOmort=data_list[['Mort']]*100/(data_list[['GR_S']]+data_list[['GR_I']]+data_list[['VL']]+data_list[['Mort']])
data_list[['%Omort']]=pOmort


data_list[['LR_Z']]=data_list[['GR']]/(data_list[['Susceptible']]+data_list[['Infected']])

data_list[['LR_O']]=data_list[['Mort']]/(data_list[['Susceptible']]+data_list[['Infected']])

data_list[['LR_V']]=data_list[['VL']]/(data_list[['Susceptible']]+data_list[['Infected']])



data_list[['Total_P']]=data_list[['Susceptible']]+data_list[['Infected']]
print(dim(data_list[['Total_P']]))
print(dim(data_list[['chl']]))

C_chl=data_list[['Total_P']]*12.011/data_list[['chl']]

data_list[['C/chl']]=C_chl

for (t in names_tracers){
  data_list[[t]][is.na(data_list[['%Inf']])]=NA
}
 
# function for weighted sum
sum_x=function(x, dzs, j){
	if (all(is.na(x))){
		a=NA
	} else{
		a=sum(x * dzs[1:j], na.rm = TRUE)
	}
  return(a)
}


t1=data_list[['NPP']]
jnpp=9
t1_int <- apply(t1[,,1:jnpp,1:12], c(1,2,4), sum_x, dzs=dzs, j=jnpp)#function(x) {sum(x * dzs[1:6], na.rm = TRUE)}) # depth weighted sum
t1 <- apply(t1_int, c(1,2), function(x) {sum(x * 30, na.rm = TRUE)}) # sum over the month of 30 days
t1 <- t1/ 1000 * 12 # gC.m-2.y-1 # convert
t1[t1==0]=NA
NPP=t1
rm(t1)

print(dzs)

sum_x_bis=function(x, dzs, j){
        if (all(is.na(x))){
                a=NA
        } else{
                a=sum((x[!is.na(x)] * dzs[1:j][!is.na(x)])/sum(dzs[1:j][!is.na(x)]))#sum(x * dzs[1:6], na.rm = TRUE)
        }
  return(a)
}

# output plots file
pdf(paste('3D_darwin_maps_',suffix,'.pdf', sep=''), width = 10, height = 6)
for (t in names_tracers){
  print(t)
  t1=data_list[[t]]
  if (t=='NPP'){
	t1=NPP
	data_list[['NPP_annual']]=t1
  }else{
  	jo=6
	# calculate depth and time averaged mean
	t1=apply(t1[,,1:jo,1:12], c(1,2, 4), sum_x_bis, dzs=dzs, j=jo)# depth weighted average
  	t1=apply(t1, c(1,2), function(x) {mean(x, na.rm = TRUE)}) # average across the year
  	t1[is.na(NPP)]=NA	
  }
  if (sum(sum(t1, na.rm=T), na.rm=T)!=0){
    if (t %in% c('%Inf', '%Vmort', '%Zmort', '%Omort')){
      zlim=c(0,100)
      colos=hcl.colors(100, palette = "Spectral", rev=T)
      lab=t
    } else if (t=='NPP'){
      zlim <- c(0, max(t1, na.rm=T))
      colos=colorRampPalette(c("#7b3294",  "#4575b4",  "#74add1", "#abdda4", "#fee500", "#f46d43","#d73027" ))(100)
      lab='mmolC.m-3.y-1'
    } else if (t %in% c('GR_S', 'GR_I', 'VL', 'Mort_I', 'Mort_S', 'Mort', 'GR')){
      zlim <- range(t1, na.rm = TRUE)
      zlim[1]=0
      colos=viridis::viridis(100, option = "C")
      lab='mmolC.m-3.d-1'
    } else if (t %in% c('LR_Z', 'LR_O', 'LR_V')){
      zlim <- range(t1, na.rm = TRUE)
      zlim[1]=0
      colos=viridis::viridis(100, option = "turbo")
      lab='d-1'
    } else if (t %in% c('log10_DON_NO3', 'log10_DON_DIN')){
      mi=min(t1[t1!=Inf & t1!=-Inf], na.rm=T)
      mx=max(t1[t1!=Inf & t1!=-Inf], na.rm=T)
      mxa=max(c(abs(mi), abs(mx)))
      zlim <- c(-mxa, mxa)
      colos=colorRampPalette(rev(RColorBrewer::brewer.pal(11, "BrBG")))(100)
      lab=''
    } else{
      zlim <- c(0, max(t1, na.rm=T))
      colos=hcl.colors(100, "YlOrRd", rev = TRUE)
      lab='mmolC.m-3'
      if (t=='chl'){
        colos=parula(100)
        lab='mgCHL.m-3'
      }

      if (t=='C/chl'){
	    zlim=c(min(t1, na.rm=T), max(t1, na.rm=T))
        lab='gC/gchl'
        colos=jet.colors(100)
      }
    }
    breaks <- seq(zlim[1], zlim[2], length.out = length(colos) + 1)
    
    # plot map
    template_map(min_lo, max_lo, min_lt, max_lt)
    # overlay the raster
    image(lon, lat, t1,
          add = TRUE, useRaster = TRUE, col = colos, zlim = zlim)
    axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)

    if (t %in% c('%Inf', '%Vmort', '%Zmort', '%Omort')){
      template_map(min_lo, max_lo, min_lt, max_lt)
      # overlay the raster
      image(lon, lat, t1,
            add = TRUE, useRaster = TRUE, col = colos, zlim = c(0, max(t1, na.rm=T)))
      axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
    }

	# legend 
    # 1️⃣ Determine limits
    t1_min <- zlim[1]
    t1_max <- zlim[2]
    
    # 2️⃣ Position of the legend
    legend_x <- 1       # x-position (right of map)
    
    # 3️⃣ Draw the gradient as tiny rectangles
    # Draw gradient as stacked rectangles
    plot(0,0, xlim=c(0, 60), ylim=c(0, 120), col='white', yaxt='n', xaxt='n',
         xlab='', ylab='', bty='n')
    text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
    for (i in 1:length(colos)){
      rect(xleft = legend_x, xright = legend_x + 10,
          ybottom = i,
          ytop    = i+1,
          col     = colos[i], border = NA)
    }
    if (t %in% c('%Inf', '%Vmort', '%Zmort', '%Omort')){
      text(x=legend_x+12, y=i+1, labels = 100)
    } else{
      text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
    }
    text(x=legend_x,y=i+9, labels=t )
  
    
  }
}
dev.off()

# save data
saveRDS(data_list, paste('data_3D_darwin_10th_year_',suffix ,'.rds',sep=''))



