#source('axis_map.R')
library('viridis')
library('matlab')
library('RColorBrewer')
library('RANN')
library('maps')
library('pals')
source('functions_map.R')

sca=commandArgs(trailingOnly=T)[1]
type=commandArgs(trailingOnly=T)[2]
depth=commandArgs(trailingOnly=T)[3]
region=commandArgs(trailingOnly=T)[4]
ref_sim=commandArgs(trailingOnly=T)[5]
save=commandArgs(trailingOnly=T)[6]
lon=readRDS('lon.rds')
lat=readRDS('lat.rds')

print(sca)
print(type)
print(depth)
print(region)
print(ref_sim)
print(save)


if (region=='world'){
	min_lo=-20
	max_lo=360
	min_lt=-84.5
	max_lt=90
	step_lo=60
	step_lt=30
	i1_lo=1
	i2_lo=length(lon)
	i1_lt=1
	i2_lt=length(lat)
	wd=10
	hg=6
	nr=360
	nc=160
} else if (region=='gradients'){
	min_lo=180
        max_lo=220
        min_lt=20
        max_lt=50
        step_lo=10
        step_lt=10
	i1_lo=181
	i2_lo=220
	i1_lt=80+21
	i2_lt=80+50
	wd=7
	hg=7
	nr=40
        nc=40
} else if (region=='aloha'){
        min_lo=190
        max_lo=210
        min_lt=15
        max_lt=35
        step_lo=5
        step_lt=5
	i1_lo=191
	i2_lo=210
	i1_lt=80+16
	i2_lt=80+35
	wd=7
        hg=7
	nr=20
	nc=20
}

lon_mat <- t(matrix(rep(lon, each = length(lat)), nrow = length(lat)))
lat_mat <- t(matrix(rep(lat, times = length(lon)), nrow = length(lat)))

lon_vec=as.vector(lon_mat)
lat_vec=as.vector(lat_mat)

depths=readRDS('depths.rds')
if (depth!='int'){
	depth=as.integer(depth)
	de=depths[depth]
}else{
	de=0
}

#dzs <- diff(c(0, (head(depths, -1) + tail(depths, -1)) / 2, max(depths) + (depths[length(depths)] - depths[length(depths)-1]) / 2))
#dzs=abs(dzs)
depths_u=readRDS('depths_u.rds')
depths_l=readRDS('depths_l.rds')
dzs=depths_l-depths_u
dzs=as.numeric(dzs)

if (ref_sim=='no_virus'){
	#suffixes=c('3P1V1Z_3D_param_Fremont_etal_shuttle-075','3P1V1Z_3D_param_Fremont_etal_shuttle-09', '3P1V1Z_3D_param_Fremont_etal', '3P1V1Z_3D_param_Fremont_etal_no_virus')#, '3P1V1Z_3D_param_Fremont_etal_no_virus_no_zoop')
	#suffixes_bis=c('virus_shuttle-025','virus_shuttle-01','virus', 'no_virus')#,'no_virus_no_zoop' )
	#suffixes_bis=c('V(75-25)', 'V(90-10)', 'V', 'NV')
	suffixes=c('virus_shunt-50','virus_shunt-60' ,'virus_shunt-75', 'virus_shunt-90', 'virus_shunt-100', 'no_virus')
	suffixes_bis=c('V50','V60' ,'V75', 'V90', 'V100', 'NV')
} else if (ref_sim=='virus'){
	#suffixes=c('3P1V1Z_3D_param_Fremont_etal_shuttle-075','3P1V1Z_3D_param_Fremont_etal_shuttle-09', '3P1V1Z_3D_param_Fremont_etal')
	#suffixes_bis=c('virus_shuttle-025','virus_shuttle-01','virus')
	#suffixes_bis=c('V(75-25)', 'V(90-10)', 'V(100-0)')
	suffixes=c('virus_shunt-50', 'virus_shunt-60','virus_shunt-75', 'virus_shunt-90', 'virus_shunt-100')
	suffixes_bis=c('V50','V60' ,'V75', 'V90', 'V100')
} else if (ref_sim=='virus_shunt'){
        #suffixes=c('3P1V1Z_3D_param_Fremont_etal_shuttle-025', '3P1V1Z_3D_param_Fremont_etal_shuttle-05', '3P1V1Z_3D_param_Fremont_etal_shuttle-075','3P1V1Z_3D_param_Fremont_etal_shuttle-09', '3P1V1Z_3D_param_Fremont_etal')
        #suffixes_bis=c('virus_shuttle-025','virus_shuttle-01','virus')
        #suffixes_bis=c('V(25-75)','V(50-50)','V(75-25)', 'V(90-10)', 'V(100-0)')
	suffixes=c('virus_shunt-0','virus_shunt-25','virus_shunt-50', 'virus_shunt-75',  'virus_shunt-100')
        suffixes_bis=c('V0','V25','V50', 'V75', 'V100')
} else if (ref_sim=='no_virus_shunt'){
        #suffixes=c('3P1V1Z_3D_param_Fremont_etal_shuttle-025', '3P1V1Z_3D_param_Fremont_etal_shuttle-05', '3P1V1Z_3D_param_Fremont_etal_shuttle-075','3P1V1Z_3D_param_Fremont_etal_shuttle-09', '3P1V1Z_3D_param_Fremont_etal', '3P1V1Z_3D_param_Fremont_etal_no_virus')
        #suffixes_bis=c('virus_shuttle-025','virus_shuttle-01','virus')
        #suffixes_bis=c('V(25-75)','V(50-50)','V(75-25)', 'V(90-10)', 'V(100-0)', 'NV')
	suffixes=c('virus_shunt-0','virus_shunt-25', 'virus_shunt-50', 'virus_shunt-75', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V0', 'V25','V50', 'V75', 'V100', 'NV')
} else if (ref_sim=='virus_shunt_all'){
        suffixes=c('virus_shunt-0','virus_shunt-25','virus_shunt-50','virus_shunt-60' ,'virus_shunt-75','virus_shunt-90' , 'virus_shunt-100')
        suffixes_bis=c('V0','V25','V50','V60' ,'V75','V90' ,'V100')
} else if (ref_sim=='no_virus_shunt_all'){
        suffixes=c('virus_shunt-0','virus_shunt-25', 'virus_shunt-50','virus_shunt-60' , 'virus_shunt-75', 'virus_shunt-90' ,'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V0', 'V25','V50','V60', 'V75', 'V90','V100', 'NV')
} else if (ref_sim=='virus_virulence'){
	#suffixes=c('3P1V1Z_3D_param_Fremont_etal_low_phi', '3P1V1Z_3D_param_Fremont_etal_high_phi', '3P1V1Z_3D_param_Fremont_etal')
	#suffixes_bis=c('virus_low_phi','virus_high_phi','virus')
	#suffixes_bis=c('V.phi/2', 'V.2phi', 'V')
	suffixes=c('virus_low_phi', 'virus_high_phi', 'virus_shunt-100')
	suffixes_bis=c('V.phi/1.5', 'V.1.5phi', 'V')
} else if (ref_sim=='no_virus_virulence'){
        #suffixes=c('3P1V1Z_3D_param_Fremont_etal_low_phi', '3P1V1Z_3D_param_Fremont_etal_high_phi', '3P1V1Z_3D_param_Fremont_etal', '3P1V1Z_3D_param_Fremont_etal_no_virus')
        #suffixes_bis=c('virus_low_phi','virus_high_phi','virus', 'no_virus')
	#suffixes_bis=c('V.phi/2', 'V.2phi', 'V', 'NV')
	suffixes=c('virus_low_phi', 'virus_high_phi', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V.phi/1.5', 'V.1.5phi', 'V', 'NV')
} else if (ref_sim=='virus_misc'){
	suffixes=c('virus_shunt-100_no_I', 'virus_shunt-100_I_growth','virus_shunt-100_no_DON_transport', 'virus_shunt-100')
        suffixes_bis=c('V_noI','V_IG', 'V_NDT', 'V')
} else if (ref_sim=='no_virus_misc'){
        suffixes=c('virus_shunt-100_no_I', 'virus_shunt-100_I_growth','virus_shunt-100_no_DON_transport', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V_noI','V_IG', 'V_NDT', 'V', 'NV')
} else if (ref_sim=='virus_I'){
        suffixes=c('virus_shunt-100_no_I', 'virus_shunt-100_I_growth', 'virus_shunt-100')
        suffixes_bis=c('V_noI','V_IG', 'V')
} else if (ref_sim=='no_virus_I'){
        suffixes=c('virus_shunt-100_no_I', 'virus_shunt-100_I_growth', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V_noI','V_IG', 'V', 'NV')
} else if (ref_sim=='no_virus_lrm'){
        suffixes=c('virus_shunt-50_lrm','virus_shunt-60_lrm','virus_shunt-75_lrm', 'virus_shunt-90_lrm' ,'virus_shunt-100_lrm','no_virus_lrm')
        suffixes_bis=c('V50', 'V60','V75','V90' ,'V100','NV')
}


#else if (ref_sim=='all_virus'){
   #     suffixes=c('3P1V1Z_3D_param_Fremont_etal_shuttle-075','3P1V1Z_3D_param_Fremont_etal_shuttle-09','3P1V1Z_3D_param_Fremont_etal_low_phi', '3P1V1Z_3D_param_Fremont_etal_high_phi', '3P1V1Z_3D_param_Fremont_etal')
        #suffixes_bis=c('virus_shuttle-025','virus_shuttle-01','virus_low_phi','virus_high_phi','virus')
#	suffixes_bis=c('V(75-25)', 'V(90-10)','V.phi/2', 'V.2phi', 'V')
#} else if (ref_sim=='all_no_virus'){
#        suffixes=c('3P1V1Z_3D_param_Fremont_etal_shuttle-075','3P1V1Z_3D_param_Fremont_etal_shuttle-09','3P1V1Z_3D_param_Fremont_etal_low_phi', '3P1V1Z_3D_param_Fremont_etal_high_phi', '3P1V1Z_3D_param_Fremont_etal', '3P1V1Z_3D_param_Fremont_etal_no_virus')
        #suffixes_bis=c('virus_shuttle-025','virus_shuttle-01','virus_low_phi','virus_high_phi','virus', 'no_virus')
#	suffixes_bis=c('V(75-25)', 'V(90-10)','V.phi/2', 'V.2phi', 'V', 'NV')
#}

names_tracers=c('Total_P','Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus', '%Inf', '%Vmort', "%Zmort", '%Omort', 
		'GR_S', 'NPP', 'DIC', 'NO3', 'NO2', 'NH4', 'PO4', 'FeT', 'SiO2', 'DOC', 'DON', 'DOP', 'DOFe', 'POC', 
		'PON', 'POP', 'POFe', 'POSi', 'PIC', 'Alk', 'O2', 'CDOM', 'log10_DON_NO3', 'log10_DON_DIN','VL', 'GR_I', 'TDN', 'chl', 'C/chl', 'Mort_S', 'Mort_I', 'Mort', 'LR_Z', 'LR_V', 'LR_O', 'GR', 'DIN')


if (grepl('no_virus', ref_sim)){
  	ns=length(suffixes)
} else{
	ns=length(suffixes)-1
}
#if (ref_sim %in% c('virus', 'virus_virulence', 'all_virus', 'virus_shuttle') ){
#         ns=length(suffixes)
#} else if (ref_sim %in% c('no_virus', 'no_virus_virulence', 'all_no_virus', 'no_virus_shuttle', 'no_virus_lm')){
#         ns=length(suffixes)-1
#}

#ns=length(suffixes)
Qvs=rep(4.18214600e-15*1000,length(suffixes))
Qps=rep(4.04125e-12, length(suffixes))*1000
Qzs=rep(1.06e-09, length(suffixes))*1000


Qs=rep(list(rep(list(NULL), length(names_tracers))), length(suffixes))

if (save==1){
	datas=rep(list(NULL), length(suffixes))
	names(datas)=suffixes
	co=1
	for (suff in suffixes){
		u=readRDS(paste('data_3D_darwin_10th_year_', suff, '.rds', sep=''))
		datas[[suff]]=u
		for (n in names_tracers){
			if (n %in% c( 'Total_P','Susceptible', 'Infected','Resistant')){
				Qs[[suff]][[n]]=Qps[co]
			} else if (n=='Zooplankton'){
				Qs[[suff]][[n]]=Qzs[co]
			} else if (n=='Virus'){
                        	Qs[[suff]][[n]]=Qvs[co]
                	}
		}
		co=co+1
	}
} else{
  co=1
  for (suff in suffixes){
                  #u=readRDS(paste('data_3D_darwin_10th_year_', suff, '.rds', sep=''))
                  #datas[[suff]]=u
  	  for (n in names_tracers){
        	  if (n %in% c( 'Total_P','Susceptible', 'Infected','Resistant')){
                	  Qs[[suff]][[n]]=Qps[co]
                  } else if (n=='Zooplankton'){
                          Qs[[suff]][[n]]=Qzs[co]
                  } else if (n=='Virus'){
                          Qs[[suff]][[n]]=Qvs[co]
                  }
          }
          co=co+1
  }
}


star <- function(x=0, y=0, r=1, col="red", n=5){
  angles <- seq(0, 2*pi, length.out = 2*n + 1)
  radii <- rep(c(r, r/2), n+1)
  xs <- x + radii * cos(angles + pi/2)
  ys <- y + radii * sin(angles + pi/2)
  xs=xs[1:length(xs)-1]
  ys=ys[1:length(ys)-1]
  polygon(xs, ys, col=col, border="black", lwd=2)
}


data_to_plot=rep(list(rep(list(NULL), length(names_tracers))), length(suffixes))
mins=rep(list(NULL), length(names_tracers))
maxs=rep(list(NULL), length(names_tracers))
  #data_to_plot=rep(rep(list(NULL), length(names_tracers)), length(suffixes))
names(data_to_plot)=suffixes
names(maxs)=names_tracers
names(mins)=names_tracers
for (suff in suffixes){
        names(data_to_plot[[suff]])=names_tracers
}

log10_vars=c('Total_P','Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus', 'NPP', 'GR_S', 'GR_I', 'VL', 'TDN', 'Mort_S', 'Mort_I', 'Mort', 'LR_Z', 'LR_V', 'LR_O', 'GR', 'DIN', 'chl', 'NO3')
if (save=='1'){
  for (n in names_tracers){
	  print(n)
	  for (suff in suffixes){
		  print(suff)
		  data_list=datas[[suff]]#readRDS(paste('data_3D_darwin_10th_year_average_',sca, '_', type,'_', suff, '.rds', sep=''))#datas[[suff]]
		  t1=data_list[[n]]
		  if (type=='ind' & n %in% c('Total_P','Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus')){
			  t1=t1/Qs[[suff]][[n]]
		  }
		  #datas[[suff]][[n]]=NULL
		  #print(n)
		  #print(dim(t1))
		  #print(n)
                  #print(suff)
		  #print(max(t1, na.rm=T))
		  
		  #t1=data_list[['NPP']]
		  #t1_int <- apply(t1[,,1:6,1:12], c(1,2,4), function(x) {sum(x * dzs[1:6], na.rm = TRUE)}) # depth weighted sum
		  #t1 <- apply(t1_int, c(1,2), function(x) {sum(x * 30, na.rm = TRUE)}) # sum over the month of 30 days
		  #t1 <- t1/ 1000 * 12 # gC.m-2.y-1 # convert
		  #t1[t1==0]=NA
		  NPP=data_list[['NPP_annual']]
		  NPP=NPP[i1_lo:i2_lo,i1_lt:i2_lt]
		  #rm(t1)


		  if (depth!='int'){
  			  t1=apply(t1[i1_lo:i2_lo,i1_lt:i2_lt,depth,1:3], c(1,2), function(x){mean(x, na.rm=T)})
		  } else{
			  if (n=='NPP'){
                                  #t1_int <- apply(t1[,,1:6,1:12], c(1,2,4), function(x) {sum(x * dzs[1:6], na.rm = TRUE)})
                                  #t1 <- apply(t1_int, c(1,2), function(x) {sum(x * 30, na.rm = TRUE)})
                                  #t1 <- t1/ 1000 * 12 # gC.m-2.y-1
                                  #t1[t1==0]=NA
				  t1=NPP
                          } else{
				  t1=apply(t1[,,1:6,1:12], c(1,2, 4), function(x) {sum((x[!is.na(x)] * dzs[1:6][!is.na(x)])/sum(dzs[1:6][!is.na(x)]))}) # depth weighted average
        			  t1=apply(t1, c(1,2), function(x) {mean(x, na.rm = TRUE)}) # average across the year
        			  t1[is.na(NPP)]=NA
                                  #t1=apply(t1[i1_lo:i2_lo,i1_lt:i2_lt,1:6,1:12], c(1,2), function(x){mean(x, na.rm=T)})
				  #t1=apply(t1[,,1:6,1:12], c(1,2, 4), function(x) {sum((x * dzs[1:6])/sum(dzs[1:6]), na.rm=T)}) # depth weighted average
        			  #t1=apply(t1, c(1,2), function(x) {mean(x, na.rm = TRUE)}) # average across the year
				  #t1[is.na(NPP)]=NA
                          }

			#t1=apply(t1[i1_lo:i2_lo,i1_lt:i2_lt,1:6,1:12], c(1,2), function(x){mean(x, na.rm=T)})
		  }
		  data_to_plot[[suff]][[n]]=t1
			
		  print(max(t1, na.rm=T))
		  if (sca=='log10' & n %in% log10_vars){
			  mi=log10(min(t1[t1!=0 & t1!=Inf & t1!=-Inf], na.rm=T))
			  mx=log10(max(t1[t1!=0 & t1!=Inf & t1!=-Inf], na.rm=T))
		  } else{
			  mi=min(t1[t1!=Inf & t1!=-Inf], na.rm=T)
                          mx=max(t1[t1!=Inf & t1!=-Inf], na.rm=T)
		  }
		  mins[[n]]=c(mins[[n]],mi)
		  maxs[[n]]=c(maxs[[n]], mx)
	  }
  }
  #list_to_save=list(data_to_plot, mins, maxs)
  for (suff in suffixes){
    if (depth=='int' & region=='world'){
  	  saveRDS(data_to_plot[[suff]], paste('data_3D_darwin_10th_year_average_',sca, '_', type,'_', suff, '.rds', sep=''))
    } else if (depth!='int' & region=='world'){
  	  saveRDS(data_to_plot[[suff]], paste('data_3D_darwin_10th_year_average_depth-',de,'_',sca, '_', type,'_', suff, '.rds', sep=''))
    } else {
	  saveRDS(data_to_plot[[suff]], paste('data_3D_darwin_10th_year_average_depth-',de,'_',region,'_',sca, '_', type,'_', suff, '.rds', sep=''))
    }
  }
  saveRDS(list(mins, maxs), paste('mins_maxs_depth-' ,de,'_',region,'_',sca, '_', type,'_', ref_sim, '.rds', sep=''))
} else {
  for (suff in suffixes){
	if (depth=='int' & region=='world'){
		list_to_read=readRDS(paste('data_3D_darwin_10th_year_average_',sca, '_', type,'_', suff, '.rds', sep=''))
	} else if (depth!='int' & region=='world'){
		list_to_read=readRDS(paste('data_3D_darwin_10th_year_average_depth-',de,'_',sca, '_', type,'_', suff, '.rds', sep=''))
	} else{
		list_to_read=readRDS(paste('data_3D_darwin_10th_year_average_depth-',de,'_',region,'_', sca, '_', type,'_',suff, '.rds', sep=''))
	}
	data_to_plot[[suff]]=list_to_read
	rm(list_to_read)
  }
  mins_maxs=readRDS(paste('mins_maxs_depth-' ,de,'_',region,'_',sca, '_', type,'_', ref_sim, '.rds', sep=''))
  mins=mins_maxs[[1]]
  maxs=mins_maxs[[2]]
}
#print(data_to_plot[['virus_shunt-100']][['Total_P']])
#print(maxs)

#n_suff=length(suffixes)
#suff_ref=suffixes[n_suff]

#R <- 6371   # Earth radius in km
#deg2rad <- pi/180
#dlat <- 1 * deg2rad   # 1 degree in radians
#dlon <- 1 * deg2rad
#lat_rad <- lat_vec * deg2rad
#cell_area <- (R^2) * cos(lat_rad) * dlon * dlat

# calculate ocean area 
#lat_all <- seq(-89.5, 89.5, 1)
# area per latitude row
#lat_rad_all <- lat_all * deg2rad
#cell_area_all <- (R^2) * cos(lat_rad_all) * dlon * dlat   # km^2
# build grid
#grid_all <- expand.grid(lon = lon, lat = lat_all)
# land/ocean mask
#grid_all$land <- map.where("world", grid_all$lon, grid_all$lat)
# attach cell area
#grid_all$area <- cell_area_all[match(grid_all$lat, lat_all)]
# select ocean 
#ocean <- is.na(grid_all$land)
# total ocean area
#ocean_area <- sum(grid_all$area[ocean])
#tot_surf_ocean=ocean_area#sum(cell_area[!is.na(conts)], na.rm=T)+ocean_area_80N

#if (ref_sim %in% c('no_virus_shunt', 'no_virus_shunt_all')){
#  areas_dec=NULL
#  areas_inc=NULL
#  areas_dec_5=NULL
#  areas_inc_5=NULL
#  NPP_change=NULL
#  ref_npp=as.vector(data_to_plot[[suff_ref]][['NPP']])
#  ref_npp=ref_npp[abs(lat_vec)<40]
#  cell_area_40=cell_area[abs(lat_vec)<40]
#  prod_ref=sum(cell_area_40*1e6*ref_npp, na.rm = TRUE)
#  for (suff in suffixes[1:(ns-1)]){
#    npp_exp=as.vector(data_to_plot[[suff]][['NPP']])
#    npp_exp=npp_exp[abs(lat_vec)<40]
#
#    dnpp=(npp_exp-ref_npp)*100/ref_npp
#
#    prod_exp=sum(cell_area_40*1e6*npp_exp, na.rm = TRUE)
#    dprod=(prod_exp-prod_ref)*100/prod_ref
#    NPP_change=c(NPP_change, dprod)
#
#    area_dec=sum(cell_area_40[dnpp<0], na.rm=T)
#    area_inc=sum(cell_area_40[dnpp>0], na.rm=T)
#    area_dec_5=sum(cell_area_40[dnpp< -5], na.rm=T)
#    area_inc_5=sum(cell_area_40[dnpp>5], na.rm=T)
#
#    areas_dec=c(areas_dec, area_dec)
#    areas_inc=c(areas_inc, area_inc)
#    areas_dec_5=c(areas_dec_5, area_dec_5)
#    areas_inc_5=c(areas_inc_5, area_inc_5)
#  }
#  area_40=sum(cell_area_40[!is.na(dnpp)])
#  area_40_perc=area_40*100/tot_surf_ocean
#  #print('area_40_perc')
#  #print(area_40_perc)
#  pdf(paste('npp_plot_stats_',ref_sim,'.pdf', sep=''), width = wd, height = hg)
#  if (ref_sim=='no_virus_shunt'){
#    shunts=c(0, 25, 50, 75, 100)
#  } else{
#    shunts=c(0, 25, 50, 60,75, 90,100)
#  }
#  print(areas_dec*100/tot_surf_ocean)
#  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(-1.1*area_40_perc, 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='lightblue')
#  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='lightblue')
#  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='lightpink1')
#  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='lightpink1')
#  points(shunts,areas_dec_5*100/tot_surf_ocean, cex=3, col='blue', pch=17)
#  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
#  points(shunts,areas_inc_5*100/tot_surf_ocean, cex=3, col='red', pch=15)
#  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
#  points(shunts, NPP_change, cex=3, pch=18)
#  lines(shunts, NPP_change, lty=1, lwd=2)
#  abline(h=0)
#  abline(h=area_40_perc, lty=2)
  #abline(h=-area_40_perc, lty=2)

#  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(-1.1*max(abs(NPP_change)), 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='lightblue')
#  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='lightblue')
#  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='lightpink1')
#  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='lightpink1')
#  points(shunts,areas_dec_5*100/tot_surf_ocean, cex=3, col='blue', pch=17)
#  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
#  points(shunts,areas_inc_5*100/tot_surf_ocean, cex=3, col='red', pch=15)
#  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
#  points(shunts, NPP_change, cex=3, pch=18)
#  lines(shunts, NPP_change, lty=1, lwd=2)
#  abline(h=0)
#  abline(h=area_40_perc, lty=2)

#  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(0, 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='lightblue')
#  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='lightblue')
#  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='lightpink1')
#  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='lightpink1')
#  points(shunts,areas_dec_5*100/tot_surf_ocean, cex=3, col='blue', pch=17)
#  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
#  points(shunts,areas_inc_5*100/tot_surf_ocean, cex=3, col='red', pch=15)
#  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
#  abline(h=area_40_perc, lty=2)
#
#  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(0, 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='blue')
#  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
#  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='red')
#  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='red')
#  abline(h=area_40_perc, lty=2)
#
#  plot(shunts, areas_dec_5*100/tot_surf_ocean, ylim=c(0, 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='blue')
#  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
#  points(shunts, areas_inc_5*100/tot_surf_ocean, cex=3, pch=15, col='red')
#  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
#  abline(h=area_40_perc, lty=2)
#
#  plot(shunts, NPP_change, cex=3, pch=18, ylim=c( -1.05*max(abs(NPP_change)), 1.05*max(abs(NPP_change)) ) , ylab='%')
#  lines(shunts, NPP_change, lty=1, lwd=2)
#  abline(h=0)
#  dev.off()
#}


cols=c('navyblue', "chocolate", 'sandybrown', 'grey')
if (ref_sim=='no_virus' & type=='mol' & region=='world'){
  pdf('latitude_vs_mortality.pdf', width = wd, height = hg)
  for (n in c('%Omort', '%Zmort', '%Vmort', 'LR_O', 'LR_Z', 'LR_V')){
	  count=1
  	  for (suff in suffixes){
		  suff_bis=suffixes_bis[count]
	  	  morts=as.vector(data_to_plot[[suff]][[n]])
		  #tot_p=as.vector(data_to_plot[[suff]][['Total_P']])
		  chl=as.vector(data_to_plot[[suff]][['chl']])
		  #olig=tot_p>0.2 & tot_p<0.5
		  #hyp_olig=tot_p<0.2 & tot_p>0
		  olig=chl<0.1 & chl>0.05
		  hyp_olig=chl<0.05 & chl>0
		  sel=!is.na(morts)
		  classes=rep(1,length(lat_vec))
		  classes[olig==T]=2
		  classes[hyp_olig==T]=3
		  classes[abs(lat_vec)>40]=4
		  #par(lwd = 2, las = 1)
		  par(mar = c(5, 5.2, 2, 2))
		  if (n %in% c('%Omort', '%Zmort', '%Vmort')){
		  	ylims=c(0, 100)
		  } else if (n %in% c('LR_O', 'LR_Z', 'LR_V')){
		  	ylims=c(0, 0.5)
		  }
		  plot(lat_vec[sel], morts[sel], xlab='', ylab='', pch=19, ylim=ylims, xlim=c(min(lat), max(lat)), col=cols[classes[sel]],  yaxt = "n", xaxt='n', main=suff_bis)
		  axis(1, at = seq(-80, 80, by = 20), lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
		  axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
		  box(lwd = 3)
		  mtext('Latitude', side = 1, line = 3.5, cex = 1.6)
		  mtext(n, side = 2, line = 4, cex = 1.6)
		  #,main=paste(suff_bis, sep=' ')
		  #sel=!is.na(morts) & !olig & !hyp_olig
		  #plot(lat_vec[sel], morts[sel], xlab='Latitude', ylab=n, pch=19, main=paste(suff_bis, 'non oligotrophic', sep=' '), ylim=c(0,100), xlim=c(min(lat), max(lat)))
		  #sel_olig=!is.na(morts) & olig & !hyp_olig
		  #plot(lat_vec[sel_olig], morts[sel_olig], xlab='Latitude', ylab=n, pch=19, main=paste(suff, 'oligotrophic', sep=' '), ylim=c(0,100), xlim=c(min(lat), max(lat)))
		  #sel_holig=!is.na(morts) & !olig & hyp_olig
                  #plot(lat_vec[sel_holig], morts[sel_holig], xlab='Latitude', ylab=n, pch=19, main=paste(suff, 'hyper oligotrophic', sep=' '), ylim=c(0,100), xlim=c(min(lat), max(lat)))
	  	  count=count+1
	  }
  }
  dev.off()
  pdf('latitude_vs_delta_mortality.pdf', width = wd, height = hg)
  count=1
  for (suff in suffixes[1:(length(suffixes)-1)]){
	  suff_bis=suffixes_bis[count]
	  morts=as.vector(data_to_plot[[suff]][['%Zmort']]-data_to_plot[[suff]][['%Vmort']])
	  #tot_p=as.vector(data_to_plot[[suff]][['Total_P']])
          chl=as.vector(data_to_plot[[suff]][['chl']])
	  #olig=tot_p>0.2 & tot_p<0.5
          #hyp_olig=tot_p<0.2 & tot_p>0
          olig=chl<0.1 & chl>0.05
          hyp_olig=chl<0.05 & chl>0
          sel=!is.na(morts)
          classes=rep(1,length(lat_vec))
          classes[olig==T]=2
          classes[hyp_olig==T]=3
	  classes[abs(lat_vec)>40]=4
          #par(lwd = 2, las = 1)
          par(mar = c(5, 5.2, 2, 2))
	  amax=max(abs(morts[sel]), na.rm=T)
          plot(lat_vec[sel], morts[sel], xlab='', ylab='', pch=19,ylim=c(-amax, amax), xlim=c(min(lat), max(lat)), col=cols[classes[sel]],  yaxt = "n", xaxt='n', main=suff_bis)
          axis(1, at = seq(-80, 80, by = 20), lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  abline(h=0, lwd=3)
          mtext('Latitude', side = 1, line = 3.5, cex = 1.6)
          mtext("%Zmort-%Vmort", side = 2, line = 4, cex = 1.6)
	  count=count+1
  }
  dev.off()
}



par(mar=c(5.1, 4.1, 4.1, 2.1))


if (depth=='int'){
	if (region=='world'){
		pdf(paste('3D_darwin_maps_comparisons_bis_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
	} else{
		pdf(paste('3D_darwin_maps_comparisons_bis_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
	}
} else{
	if (region=='world'){
		pdf(paste('3D_darwin_maps_comparisons_bis_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
	} else{
		pdf(paste('3D_darwin_maps_comparisons_bis_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
	}	
}
for (n in names_tracers[ c(1:3, 5:12, 14, 21, 33:47)]){
	mi=min(mins[[n]][mins[[n]]!=-Inf & mins[[n]]!=Inf], na.rm=T)
	mx=max(maxs[[n]], na.rm=T)
	#print(mx)
	if (n %in% c('%Inf', '%Vmort','%Zmort',  '%Omort' )){
      		zlim=c(0,100)
		zlim1=c(0, mx)
      		colos=hcl.colors(100, palette = "Spectral", rev=T)
      		lab=t
    	} else{
		if (sca=='log10' & n!='log10_DON_NO3' & n!='log10_DON_DIN'){
			zlim <- c(mi, mx)
		} else if (n %in% c('log10_DON_NO3', 'log10_DON_DIN')){
			mx=max(abs(c(mi,mx)))
			mi=-mx
			zlim <- c(-mx, mx)
		} else{
      			zlim <- c(0, mx)#range(t1, na.rm = TRUE)
			if (n=='C/chl'){
			  zlim=c(mi, mx)
			}
		}
		if (n=='NPP'){
                        colos=colorRampPalette(c("#7b3294",  "#4575b4",  "#74add1", "#abdda4", "#fee500", "#f46d43","#d73027" ))(100)
                        lab='mmolC.m-3.d-1'
                } else if (n %in% c('GR_S', 'GR_I', 'GR', 'VL', 'Mort', 'Mort_I', 'Mort_S')){
                        colos=viridis::viridis(100, option = "C")
                        lab='mmol.m-3.d-1'
                } else if (n %in% c('LR_O', 'LR_Z', 'LR_V')){
                        colos=viridis::viridis(100,option='turbo' ,direction = 1)
                        lab='d-1'
                } else if (n %in% c('log10_DON_NO3', 'log10_DON_DIN')){
                        colos= colorRampPalette(rev(RColorBrewer::brewer.pal(11, "BrBG")))(100)#viridis(100, option = "C")
                        lab=''
                } else{
                        colos=hcl.colors(100, "YlOrRd", rev = TRUE)
                        lab='mmolC.m-3'
			if (n=='chl'){
                        	colos=parula(100)#colorRampPalette(c("white",'lightgreen', "darkgreen"))(100)
                        	lab='mgCHL.m-3'
      			}
			if (n=='C/chl'){
                        	lab='gC/gchl'
                                colos=jet.colors(100)
                        }

                }

    	}

	for (suff in suffixes){
		if (sca=='log10' & n %in% log10_vars){#c('Total_P','Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus', 'GR_S', 'NPP', 'DON_NO3', 'GR_I', 'VL', 'TDN')){
			t=log10(data_to_plot[[suff]][[n]])
		} else{
			t=data_to_plot[[suff]][[n]]
		}
		template_map(min_lo, max_lo, min_lt, max_lt)
		#maps::map("world2",, col = "black", lwd = 0.7,xlim = c(-20, 360), ylim = c(-85, 80), fill=T,interior = FALSE, main=n)

		# overlay the raster
		print(n)
		print(zlim)
		image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], t,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim, main=n)
    		axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)

		if (n=='%Inf'){
		  template_map(min_lo, max_lo, min_lt, max_lt)
		  image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], t,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim1, main=n)
                  axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
		}
		if (n %in% c('LR_O', 'LR_Z', 'LR_V')){
			template_map(min_lo, max_lo, min_lt, max_lt)
			image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], t,add = TRUE, useRaster = TRUE, col = colos, zlim = c(0, 0.5), main=n)
                	axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
		}
		if (n %in% c('GR', 'Mort', 'VL')){
			template_map(min_lo, max_lo, min_lt, max_lt)
			image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], t,add = TRUE, useRaster = TRUE, col = colos, zlim = c(0, 0.85), main=n)
                        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
		}
		if (region=='aloha'){
			lon_g=202.5
			lat_g=24.5
			star(lon_g,lat_g, r=0.5, col="dodgerblue")
		}
		if( region=='gradients'){
			lon_g=202 #360-158 (lon of gradients)
			lats_g=seq(23.5, 43.5, 1)
			lon_g_ind=which.min(abs(lon-lon_g))
			lats_g_ind=sapply(lats_g, function(x, lt){which.min(abs(x-lt))}, lt=lat)
			points(rep(lon_g_ind,length(lats_g_ind)) ,lats_g , pch=19, type='l', lwd=3)
		}
	}
	
	# 1️⃣ Determine limits
	t1_max <- mx
    	if  (sca=='log10' & n %in% log10_vars | n %in% c('log10_DON_NO3', 'log10_DON_DIN')){
		t1_min = mi
	} else {
		t1_min <- 0
		if (n %in% c('%Inf', '%Vmort',  '%Zmort',  '%Omort')){
			t1_max <-100
		}
		if (n=='C/chl'){
			t1_min <- mi
		}
	}	

    	# 2️⃣ Position of the legend
    	legend_x <- 1       # x-position (right of map)

   	 # 3️⃣ Draw the gradient as tiny rectangles
    	# Draw gradient as stacked rectangles
    	plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',
        	 xlab='', ylab='', bty='n')
    	
	text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
    	for (i in 1:length(colos)){
      		rect(xleft = legend_x, xright = legend_x + 10,
          	ybottom = i,
          	ytop    = i+1,
          	col     = colos[i], border = NA)
    	}
    	if (n %in% c('%Inf', '%Vmort')){
      		text(x=legend_x+12, y=i+1, labels = 100)
		text(x=legend_x+14, y=i+1, labels = signif(t1_max, 2))
    	} else{
      		text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
    	}
    	text(x=legend_x,y=i+3, labels=n )


	# scale them to the gradient range
	scale_to_y <- function(val, minv, maxv, ncols){
    		return(1 + (val - minv) / (maxv - minv) * (ncols - 1))
	}

	make_ticks=function(ticks_vals, tick_labels, colos, n, t1_min, t1_max){

		ticks_pos <- scale_to_y(ticks_vals, t1_min, t1_max, length(colos))
		# draw the ticks
		segments(x0 = legend_x + 10, x1 = legend_x + 12,
         	y0 = ticks_pos, y1 = ticks_pos, col = "black")

		labs=NULL
		for (i in 1:length(tick_labels)){
			labs=c(labs, paste(signif(ticks_vals[i], 2),' : ', tick_labels[i], sep='')) 
		}
		# add labels
		text(x = legend_x + 14, y = ticks_pos,labels = labs, adj = 0)
	}
	#make_ticks(mins[[n]],  suffixes_bis, colos)
	make_ticks(maxs[[n]],  suffixes_bis, colos,n, t1_min, t1_max)
}
dev.off()

#if (ref_sim %in% c('virus', 'virus_virulence', 'all_virus', 'virus_shuttle') ){
#        ns=length(suffixes)
#} else if (ref_sim %in% c('no_virus', 'no_virus_virulence', 'all_no_virus', 'no_virus_shuttle', 'no_virus_lm')){
#        ns=length(suffixes)-1
#}

if (sca=='0' & type=='mol' & region=='world'){
  if (depth!='int'){
  	  pdf(paste('3D_darwin_comparisons_correlations_PI_bis_depth',de,'_ref-',ref_sim,'.pdf', sep=''))
  } else{
	  pdf(paste('3D_darwin_comparisons_correlations_PI_bis_ref-',ref_sim,'.pdf', sep=''))
  }
  cols=c('navyblue', "chocolate", 'sandybrown', 'grey')
  par(mar=c(5.1, 5.1, 4.1, 0.1))
  for (suff in suffixes[1:ns]){
  	  chl=as.vector(data_to_plot[[suff]][['chl']])
	  olig=chl<0.1 & chl>0.05
          hyp_olig=chl<0.05 & chl>0
          #olig=tot_p>0.2 & tot_p<0.5 #& abs(lat_vec)<40
          #hyp_olig=tot_p<0.2 & tot_p>0 #& abs(lat_vec)<40

          classes=rep(1,length(chl))
          classes[olig==T]=2
          classes[hyp_olig==T]=3
          classes[abs(lat_vec)>40]=4

	  pinf=as.vector(data_to_plot[[suff]][['%Inf']])
	  LR_V=as.vector(data_to_plot[[suff]][['LR_V']])

	  sel=!is.na(pinf) & !is.na(LR_V)
	  pinf=pinf[sel]
	  LR_V=LR_V[sel]
	  co=cor.test(pinf, LR_V)
	  plot(pinf, LR_V,  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
	  axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)

	  pinf=as.vector(data_to_plot[[suff]][['%Inf']])
          LV=as.vector(data_to_plot[[suff]][['VL']])

          sel=!is.na(pinf) & !is.na(LV)
          pinf=pinf[sel]
          LV=LV[sel]
          co=cor.test(pinf, LV)
          plot(pinf, LV,  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)

          pinf=as.vector(data_to_plot[[suff]][['%Inf']])
	  pvmort=as.vector(data_to_plot[[suff]][['%Vmort']])

          sel=!is.na(pinf) & !is.na(pvmort)
          pinf=pinf[sel]
          pvmort=pvmort[sel]
          co=cor.test(pinf, pvmort)
          plot(pinf, pvmort,  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)



          #mtext('% Inf', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)


	  #plot(pinf, pvmort,col= cols[classes],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
          #axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          #axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          #box(lwd = 3)
          #mtext('% Inf', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

	  #sel1=classes==1 | classes==4
	  #x=pinf[sel1]
	  #y=pvmort[sel1]
	  #co=cor.test(x, y)
	  #plot(x, y,col= cols[classes[sel1]],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
          #axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          #axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          #box(lwd = 3)
          #mtext('% Inf', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

	  #sel2=classes==1
	  #x=pinf[sel2]
          #y=pvmort[sel2]
	  #co=cor.test(x, y)
          #plot(x, y,col= cols[classes[sel2]],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
          #axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          #axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          #box(lwd = 3)
          #mtext('% Inf', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

	  #sel3=classes==3
	  #x=pinf[sel3]
          #y=pvmort[sel3]
	  #co=cor.test(x, y)
          #plot(x, y,col= cols[classes[sel3]],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
          #axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          #axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          #box(lwd = 3)
          #mtext('% Inf', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

	  #sel4=classes==2
	  #x=pinf[sel4]
          #y=pvmort[sel4]
	  #co=cor.test(x, y)
          #plot(x, y,col= cols[classes[sel4]],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", ylab='', xlab='')
          #axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          #axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          #box(lwd = 3)
          #mtext('% Inf', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)
  }
  dev.off()
  if (depth!='int'){
          pdf(paste('3D_darwin_comparisons_correlations_bis_depth',de,'_ref-',ref_sim,'.pdf', sep=''))
  } else{
          pdf(paste('3D_darwin_comparisons_correlations_bis_ref-',ref_sim,'.pdf', sep=''))
  }
  par(mar=c(5.1, 5.1, 4.1, 0.1))
  #cols=c('navyblue', "chocolate", 'sandybrown', 'grey')
  for (suff in suffixes[1:ns]){
          pzmort=as.vector(data_to_plot[[suff]][['%Zmort']])
          pvmort=as.vector(data_to_plot[[suff]][['%Vmort']])
	  GR=as.vector(data_to_plot[[suff]][['GR']])
	  VL=as.vector(data_to_plot[[suff]][['VL']])
	  LR_Z=as.vector(data_to_plot[[suff]][['LR_Z']])
	  LR_V=as.vector(data_to_plot[[suff]][['LR_V']])
	  
	  chl=as.vector(data_to_plot[[suff]][['chl']])
	  #tot_p=as.vector(data_to_plot[[suff]][['Total_P']])
	  #Sc=1.5
	  #S_sep=1/((data_list[['Susceptible']]+data_list[['Infected']])+Sc)
	  #GR=as.vector(gz*S_sep)
	  #p_inf=data_list[['Infected']]*100/(data_list[['Infected']]+data_list[['Susceptible']])
	  #tau=0.37
	  #VL=as.vector(p_inf/100/tau)
        
          sel=!is.na(pzmort) & !is.na(pvmort)
          pzmort=pzmort[sel]
          pvmort=pvmort[sel]
	  GR=GR[sel]
	  VL=VL[sel]
	  LR_Z=LR_Z[sel]
	  LR_V=LR_V[sel]
	  chl=chl[sel]
	  lat_vec0=lat_vec[sel]

	  #olig=tot_p>0.2 & tot_p<0.5
    	  olig=chl<0.1 & chl>0.05
	  hyp_olig=chl<0.05 & chl>0
	  #olig=tot_p>0.2 & tot_p<0.5 #& abs(lat_vec)<40
          #hyp_olig=tot_p<0.2 & tot_p>0 #& abs(lat_vec)<40

	  classes=rep(1,length(chl))
          classes[olig==T]=2
	  classes[hyp_olig==T]=3
	  classes[abs(lat_vec)>40]=4
          co=cor.test(pzmort, pvmort)
	  plot(pzmort, pvmort,  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes], xlab='', ylab='')
	  axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
          lines(c(0,100), c(0,100), lwd=2)
	  mtext('% Z mort', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)
	  
	  co=cor.test(GR,VL)
	  plot(GR, VL,  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss', side = 2, line = 2.9, cex = 1.6)

	  co=cor.test(LR_Z,LR_V)
          plot(LR_Z, LR_V,  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss rate', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss rate', side = 2, line = 2.9, cex = 1.6)

	  sel1=classes==1 | classes==4
	  co=cor.test(pzmort[sel1], pvmort[sel1])
          plot(pzmort[sel1], pvmort[sel1],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel1]], xlab='', ylab='')
	  axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('% Z mort', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

	  co=cor.test(GR[sel1], VL[sel1])
	  plot(GR[sel1], VL[sel1],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel1]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss', side = 2, line = 2.9, cex = 1.6)

	  co=cor.test(LR_Z[sel1], LR_V[sel1])
          plot(LR_Z[sel1], LR_V[sel1],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel1]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss rate', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss rate', side = 2, line = 2.9, cex = 1.6)

	  sel4=classes==1
	  co=cor.test(pzmort[sel4], pvmort[sel4])
          plot(pzmort[sel4], pvmort[sel4],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel4]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('% Z mort', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

          co=cor.test(GR[sel4], VL[sel4])
          plot(GR[sel4], VL[sel4],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel4]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss', side = 2, line = 2.9, cex = 1.6)

	  co=cor.test(LR_Z[sel4], LR_V[sel4])
          plot(LR_Z[sel4], LR_V[sel4],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel4]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss rate', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss rate', side = 2, line = 2.9, cex = 1.6)

	  sel2=classes==2
	  co=cor.test(pzmort[sel2], pvmort[sel2])
	  plot(pzmort[sel2], pvmort[sel2],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel2]], xlab='', ylab='')
	  axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('% Z mort', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

	  co=cor.test(GR[sel2], VL[sel2])
	  plot(GR[sel2], VL[sel2],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel2]], xlab='', ylab='')
	  axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss', side = 2, line = 2.9, cex = 1.6)
	  
	  co=cor.test(LR_Z[sel2], LR_V[sel2])
          plot(LR_Z[sel2], LR_V[sel2],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel2]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss rate', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss rate', side = 2, line = 2.9, cex = 1.6)


	  sel3=classes==3
	  co=cor.test(pzmort[sel3], pvmort[sel3])
	  plot(pzmort[sel3], pvmort[sel3],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19,xaxt='n', yaxt="n" ,col=cols[classes[sel3]], xlab='', ylab='')
  	  axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('% Z mort', side = 1, line = 3.5, cex = 1.6)
          #mtext('% V mort', side = 2, line = 2.9, cex = 1.6)

	  co=cor.test(GR[sel3], VL[sel3])
	  plot(GR[sel3], VL[sel3],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel3]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss', side = 2, line = 2.9, cex = 1.6)

	  co=cor.test(LR_Z[sel3], LR_V[sel3])
          plot(LR_Z[sel3], LR_V[sel3],  main=paste(suff,'\n','cor=',signif(co$estimate, 2), ' p.value=',signif(co$p.value,2) ,sep=''), pch=19, xaxt='n', yaxt="n", col=cols[classes[sel3]], xlab='', ylab='')
          axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 1.2, 0))
          axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
          box(lwd = 3)
	  lines(c(0,100), c(0,100), lwd=2)
          mtext('Z loss rate', side = 1, line = 3.5, cex = 1.6)
          #mtext('V loss rate', side = 2, line = 2.9, cex = 1.6)
  }
  dev.off()
}


if (depth=='int'){
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_deltas_ZV_mort_bis_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_deltas_ZV_mort_bis_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
        }
} else{
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_deltas_ZV_mort_bis_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_deltas_ZV_mort_bis_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        }
}
colos=colorRampPalette(c("blue", "white", "red"))(100)
for (suff in suffixes[1:ns]){
	delta=data_to_plot[[suff]][['%Zmort']]-data_to_plot[[suff]][['%Vmort']]
	mi=min(delta, na.rm=T)
	mx=max(delta, na.rm=T)
	mxa=max(abs(c(mi, mx)))
	zlim=c(-mxa, mxa)
	template_map(min_lo, max_lo, min_lt, max_lt)
	image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim, main=paste('delta Zmort-Vmort ', suff, sep=''))
	axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
	t1_min=-mxa
	t1_max=mxa
	legend_x <- 1       # x-position (right of map)

	# 3️⃣ Draw the gradient as tiny rectangles
	# Draw gradient as stacked rectangles
	plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',xlab='', ylab='', bty='n')

	text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
	for (i in 1:length(colos)){
        	rect(xleft = legend_x, xright = legend_x + 10,
             	ybottom = i,
             	ytop    = i+1,
             	col     = colos[i], border = NA)
	}
	text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
}
dev.off()



if (depth=='int'){
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_mort_bis_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_mort_bis_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
        }
} else{
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_mort_bis_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_mort_bis_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        }
}
colos=colorRampPalette(c("blue", "white", "red"))(100)
for (suff in suffixes[1:ns]){
        if (sca=='log10'){
                ratio=log10(data_to_plot[[suff]][['%Zmort']]/data_to_plot[[suff]][['%Vmort']])
        } else{
                ratio_p=data_to_plot[[suff]][['%Zmort']]/data_to_plot[[suff]][['%Vmort']]
                ratio_n=data_to_plot[[suff]][['%Vmort']]/data_to_plot[[suff]][['%Zmort']]
        }

        if (sca=='log10'){
                mi=min(ratio, na.rm=T)
                mx=max(ratio, na.rm=T)
                mxa=max(abs(c(mi, mx)))
		print(mxa)
                if (mxa>1){
                        mxa=1
                        ratio[ratio>1]=1
                        ratio[ratio< -1]=-1
                }
                zlim=c(-mxa, mxa)
		#print(min(ratio, na.rm=T))
		#ratio[ratio<-1]=-1
		#print(min(ratio, na.rm=T))
		#print(ratio)
		#print(zlim)
		saveRDS(ratio, paste('log10_ratio_Z_V_mort_', suff,'.rds', sep=''))
                template_map(min_lo, max_lo, min_lt, max_lt)
                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], ratio,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim, main=paste('ratio Zmort/Vmort ', suff, sep=''))
                axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
        } else{
                mxa=max(c(ratio_p, ratio_n), na.rm=T)
                if (mxa>10 | is.na(mxa)){
                        mxa=10
                        ratio_p[ratio_p>10]=10
                        ratio_n[ratio_n>10]=10
                }
                zlim=c(1, mxa)
                template_map(min_lo, max_lo, min_lt, max_lt)
                ratio_p[ratio_p<1]=NA
                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], ratio_p,add = TRUE, useRaster = TRUE, col = colos[51:100], zlim = zlim, main=paste('ratio Zmort/Vmort ', suff, sep=''))
                ratio_n[ratio_n<1]=NA
                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], ratio_n,add = TRUE, useRaster = TRUE, col = colos[50:1], zlim = zlim, main=paste('ratio Zmort/Vmort ', suff, sep=''))
                axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
        }

        t1_min=-mxa
        t1_max=mxa
        legend_x <- 1       # x-position (right of map)

        # 3️⃣ Draw the gradient as tiny rectangles
        # Draw gradient as stacked rectangles
        plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',xlab='', ylab='', bty='n')

        text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
        for (i in 1:length(colos)){
                rect(xleft = legend_x, xright = legend_x + 10,
                     ybottom = i,
                     ytop    = i+1,
                     col     = colos[i], border = NA)
        }
        text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))


}
dev.off()

if (depth=='int'){
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_bis_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_bis_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
        }
} else{
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_bis_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_ratios_ZV_bis_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        }
}
colos=colorRampPalette(c("blue", "white", "red"))(100)

for (suff in suffixes[1:ns]){
        if (sca=='log10'){
                ratio=log10(data_to_plot[[suff]][['Zooplankton']]/data_to_plot[[suff]][['Virus']])
        } else{
                ratio_p=data_to_plot[[suff]][['Zooplankton']]/data_to_plot[[suff]][['Virus']]
                ratio_n=data_to_plot[[suff]][['Virus']]/data_to_plot[[suff]][['Zooplankton']]
        }

        if (sca=='log10'){
                mi=min(ratio, na.rm=T)
                mx=max(ratio, na.rm=T)
                mxa=max(abs(c(mi, mx)))
                print(mxa)
                if (mxa>2){
                        mxa=2
                        ratio[ratio>2]=2
                        ratio[ratio< -2]=-2
                }
                zlim=c(-mxa, mxa)
		template_map(min_lo, max_lo, min_lt, max_lt)
                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], ratio,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim, main=paste('ratio Zmort/Vmort ', suff, sep=''))
                axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
        } else{
                mxa=max(c(ratio_p, ratio_n), na.rm=T)
                print(mxa)
		if (mxa>10 | is.na(mxa)){
                        mxa=10
                        ratio_p[ratio_p>10]=10
                        ratio_n[ratio_n>10]=10
                }
                zlim=c(1, mxa)
                template_map(min_lo, max_lo, min_lt, max_lt)
                ratio_p[ratio_p<1]=NA
                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], ratio_p,add = TRUE, useRaster = TRUE, col = colos[51:100], zlim = zlim, main=paste('ratio Zmort/Vmort ', suff, sep=''))
                ratio_n[ratio_n<1]=NA
                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], ratio_n,add = TRUE, useRaster = TRUE, col = colos[50:1], zlim = zlim, main=paste('ratio Zmort/Vmort ', suff, sep=''))
                axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
        }

        t1_min=-mxa
        t1_max=mxa
        legend_x <- 1       # x-position (right of map)

        # 3️⃣ Draw the gradient as tiny rectangles
        # Draw gradient as stacked rectangles
        plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',xlab='', ylab='', bty='n')

        text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
        for (i in 1:length(colos)){
                rect(xleft = legend_x, xright = legend_x + 10,
                     ybottom = i,
                     ytop    = i+1,
                     col     = colos[i], border = NA)
        }
        text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))


}
dev.off()



tracers_to_save=c('Total_P', 'NPP', 'TDN', 'log10_DON_DIN', 'chl')

data_to_save=rep(list(rep(list(NULL), length(tracers_to_save))), length(suffixes)-1)
names(data_to_save)=suffixes[1:(length(suffixes)-1)]
for (suff in names(data_to_save)){
	names(data_to_save[[suff]])=tracers_to_save
}	
if (startsWith(ref_sim, 'virus')){
  var_to_plot=c(1:3, 5:12, 14, 21, 33,34, 37:46, 47)#, 38, 39)
} else{
  var_to_plot=c(1:2, 5,9,10, 12, 14, 21, 33,34, 37:40, 42, 43, 45, 46, 47)#, 38, 39)
}

if (depth=='int'){
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_deltas_bis_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_deltas_bis_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
        }
} else{
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_deltas_bis_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_deltas_bis_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        }
}

n_suff=length(suffixes)
suff_ref=suffixes[n_suff]
print(suff_ref)
suff_ref_bis=suffixes_bis[n_suff]
#print(suff_ref)
colos=colorRampPalette(c("blue", "white", "red"))(100)

for (n in names_tracers[var_to_plot]){
	mins=NULL
	maxs=NULL
	distrib=NULL
	mxs_d=NULL
	for (suff in suffixes[1:(n_suff-1)]){
		if (!grepl('%', n) & !grepl('log', n)){
			if (sca=='0'){
				delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])*100/data_to_plot[[suff_ref]][[n]]	
			} else{
				delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
			}

		} else{
			if (sca=='0'){
				delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
			} else{
				if (!grepl('log', n)){
					delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
				} else{
					delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
				}
			}
		}
		#print(delta)
		#print(data_to_plot[[suff_ref]][[n]])
		if (length(as.vector( delta[delta!=-Inf & delta!=Inf & !is.na(delta)] )) >2){
		  dens=density(as.vector( delta[delta!=-Inf & delta!=Inf & !is.na(delta)] ) )
		  mxs_d=c(mxs_d, max(dens$y) ) 
		}  
		distrib=c(distrib, as.vector(delta[delta!=-Inf & delta!=Inf & !is.na(delta)]))
			#print(delta)
		mins=c(mins, min(delta[delta!=-Inf & delta!=Inf], na.rm=T))
		maxs=c(maxs, max(delta[delta!=-Inf & delta!=Inf], na.rm=T))
		if (n %in% tracers_to_save){
                	data_to_save[[suff]][[n]]=delta
        	}
	}

	#print(n)
	#print(mins)
	#print(maxs)
	mx_d=max(mxs_d)
	mx_ab= quantile(abs(distrib), 0.99)#max(abs(c(mins[mins!=-Inf & mins!=Inf], maxs[maxs!=-Inf & maxs!=Inf])), na.rm=T)
	print(n)
	print(mx_ab)
	mx_ab1=mx_ab

	if (sca=='log10' ){
		lim_max=2
	} else if (sca=='0'){
		lim_max=200
	} #else{
	#	lim_max=10^300
	#}

	if (mx_ab>lim_max){
		mx_ab=lim_max
	}	
	zlim=c(-mx_ab, mx_ab)

	for (suff in suffixes[1:(n_suff-1)]){
		if (!grepl('%', n) & !grepl('log', n)){
			if (sca=='0'){
				delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])*100/data_to_plot[[suff_ref]][[n]]
			} else{
				delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
			}
		} else{
			if (sca=='0'){
                                delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
                        } else{
				if (!grepl('log', n)){
                                        delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
                                } else{
                                        delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
                                }
                                #delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
                        }
		}
		#if (mx_ab==lim_max){
		delta[delta>mx_ab]=mx_ab
		delta[delta< -mx_ab]= -mx_ab
		#}
		old_par <- par(no.readonly = TRUE)
		par(old_par)
		#par(mar = c(5.1, 4.1, 4.1, 2.1))
		template_map(min_lo, max_lo, min_lt, max_lt)
                #maps::map("world2",, col = "black", lwd = 0.7,xlim = c(-20, 360), ylim = c(-85, 80), fill=T,interior = FALSE, main=n)

                # overlay the raster
                #print(zlim)
                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim, main=paste('delta ', n, sep=''))
                axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
                delta_cont=delta
		delta_cont[delta>0]=1
		delta_cont[delta<0]=0

		template_map(min_lo, max_lo, min_lt, max_lt)
		image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim, main=paste('delta ', n, sep=''))
                axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
		contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta_cont, levels=c(0,1), add=T, labels=0, lwd=2)
		
		if (n %in% c('%Zmort', '%Omort', '%Vmort') & sca=='0'){
			template_map(min_lo, max_lo, min_lt, max_lt)
                	image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta,add = TRUE, useRaster = TRUE, col = colos, zlim = c(-30, 30), main=paste('delta ', n, sep=''))
                	axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
                	contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta_cont, levels=c(0,1), add=T, labels=0, lwd=2)
		}
		
		if (region=='aloha'){
                        lon_g=202.5
                        lat_g=24.5
                        star(lon_g,lat_g, r=0.5, col="dodgerblue")
                }
                if( region=='gradients'){
                        lon_g=202 #360-158 (lon of gradients)
                        lats_g=seq(23.5, 43.5, 1)
                        lon_g_ind=which.min(abs(lon-lon_g))
                        lats_g_ind=sapply(lats_g, function(x, lt){which.min(abs(x-lt))}, lt=lat)
                        points(rep(lon_g_ind,length(lats_g_ind)) ,lats_g , pch=19, type='l', lwd=3)
                }

		if (sum(!is.na(as.vector(delta)))>10){
		  d=density(delta[!is.na(delta)])
		  y_max_buffered <- mx_d * 1.1
		  local({
	          old_par <- par(no.readonly = TRUE)
                  on.exit(par(old_par))
		  par(mar = c(5.1, 4.1, 17.5, 2.1))
		  plot(d, lwd = 2,xlab = "",ylab = "", xlim=zlim, xaxs = "i", yaxs="i", ylim=c(0, y_max_buffered))
		  polygon(d, col = adjustcolor("grey", alpha.f = 0.6), border = NA)
	  	  cdf=cumsum(d$y)/sum(d$y)
	          points(d$x, cdf*y_max_buffered, type='l', lwd=9, col='#ff00ff')
		  axis(4, at=c(0,y_max_buffered), labels=c(0,1))	
		  })  
		}
		#par(old_par)

	}

	t1_min=-mx_ab
	t1_max=mx_ab
	# 2️⃣ Position of the legend
        legend_x <- 1       # x-position (right of map)

         # 3️⃣ Draw the gradient as tiny rectangles
        # Draw gradient as stacked rectangles
	par(mar = c(5.1, 4.1, 4.1, 2.1))
        plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',
                 xlab='', ylab='', bty='n')

        text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
        for (i in 1:length(colos)){
                rect(xleft = legend_x, xright = legend_x + 10,
                ybottom = i,
                ytop    = i+1,
                col     = colos[i], border = NA)
        }
        #if (n %in% c('%Inf', '%Vmort')){
        #        text(x=legend_x+12, y=i+1, labels = 100)
        #} else{
        text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
        #}
        text(x=legend_x,y=i+3, labels=paste('delta ', n, sep='') )
	
	if (mx_ab1>200){
		ceil_to_power_of_10 <- function(x) {
  			if (any(x <= 0)) stop("x must be positive")
  				ceiling(log10(x))
		}

		zlim=c(log10(1), log10(mx_ab1))
		print(zlim)
		for (suff in suffixes[1:(n_suff-1)]){
			if (!grepl('%', n)  & !grepl('log', n) ){
				if (sca=='0'){
					delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])*100/data_to_plot[[suff_ref]][[n]]
				} else{
					delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
				}
			} else{
				delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
			}
			delta1=delta
			delta1[delta<0]=NA
			delta1[delta1<1]=1
			delta1=log10(delta1)
			template_map(min_lo, max_lo, min_lt, max_lt)
			image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta1,add = TRUE, useRaster = TRUE, col = colos[51:100], zlim = zlim, main=paste('delta ', n, sep=''))
		
			delta2=delta
                	delta2[delta>0]=NA
                	delta2[delta2>-1]=-1
                	delta2=log10(abs(delta2))
			image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta2,add = TRUE, useRaster = TRUE, col = colos[50:1], zlim = zlim, main=paste('delta ', n, sep=''))
			axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
                	
			if (sum(!is.na(as.vector(delta1)))>10){
			  d=density(delta1[!is.na(delta1)])
                	  y_max_buffered <- max(d$y) * 1.1
                          plot(d, lwd = 2,xlab = "",ylab = "", xlim=zlim, xaxs = "i", yaxs="i", ylim=c(0, y_max_buffered))
                	  polygon(d, col = adjustcolor("grey", alpha.f = 0.6), border = NA)
			}

			if (region=='aloha'){
                        	lon_g=202.5
                        	lat_g=24.5
                        	star(lon_g,lat_g, r=0.5, col="dodgerblue")
                	}
			if( region=='gradients'){
                        	lon_g=202 #360-158 (lon of gradients)
                        	lats_g=seq(23.5, 43.5, 1)
                        	lon_g_ind=which.min(abs(lon-lon_g))
                        	lats_g_ind=sapply(lats_g, function(x, lt){which.min(abs(x-lt))}, lt=lat)
                        	points(rep(lon_g_ind,length(lats_g_ind)) ,lats_g , pch=19, type='l', lwd=3)
                	}
		}

		t1_min=-mx_ab1
        	t1_max=mx_ab1
		legend_x <- 1       # x-position (right of map)

         	# 3️⃣ Draw the gradient as tiny rectangles
        	# Draw gradient as stacked rectangles
       		plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',xlab='', ylab='', bty='n')

        	text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
        	for (i in 1:length(colos)){
                	rect(xleft = legend_x, xright = legend_x + 10,
                	ybottom = i,
                	ytop    = i+1,
                	col     = colos[i], border = NA)
        	}
		text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
        	#}
        	text(x=legend_x,y=i+3, labels=paste('delta ', n, sep='') )
		text(x=legend_x+12, y=50, labels = 0)
		mx_pow=ceil_to_power_of_10(mx_ab1)-1
		dec_1=1
		for (j in 1:mx_pow){
			text(x=legend_x+12, y=50+50*j/log10(mx_ab1), labels = dec_1*10^j)
			text(x=legend_x+12, y=50-50*j/log10(mx_ab1), labels = -dec_1*10^j)
		}
	}
}
dev.off()

t_test_ignore_gps=function(grouping, totest){
  min_n <- 2  # minimum observations required per group

  print(length(totest))
  print(length(grouping))
  # Compute valid counts
  grp_valid_n <- tapply(totest, grouping, function(v) sum(!is.na(v)))

  # Groups that are valid for testing
  valid_groups <- names(grp_valid_n)[grp_valid_n >= min_n]

  # Run test only on valid groups
  keep <- grouping %in% valid_groups
  t_test <- pairwise.wilcox.test(totest[keep], grouping[keep],
                                 p.adjust.method = "bonferroni")

  # Create full p-value matrix including invalid pairs set to 1
  all_groups <- names(grp_valid_n)
  ng=length(all_groups)
  p_full <- matrix(1, nrow = ng-1, ncol = ng-1,
                   dimnames = list(all_groups[2:ng], all_groups[1:(ng-1)]))

  #print(dim(t_test$p.value))
  print('init')
  print(t_test$p.value)
  #print(length(valid_groups))
  print(p_full)
  # Insert the computed p-values in the correct locations
  #p_full[valid_groups, valid_groups] <- t_test$p.value
  for (j in 1:dim(t_test$p.value)[1]){
	  for (i in 1:dim(t_test$p.value)[2]){
	  	ng1=colnames(t_test$p.value)[j]
	  	ng2=rownames(t_test$p.value)[i]
		p_full[ng2,ng1]=t_test$p.value[i,j]
	  }
  	
  }
  print(p_full)
  print('')
  # final result
  t_test$p.value <- p_full
  return(t_test)
}


plot_sigs=function(totest,vec_to_plot, names, sep_vals){
    grouping=NULL
    for (j in names(vec_to_plot)){
        grouping=c(grouping, rep(j, length(vec_to_plot[[j]]) ))
    }
    t_test=t_test_ignore_gps(grouping, totest)#pairwise.wilcox.test(x = totest,g=grouping, p.adjust.method = 'bonferroni')
    #print(t_test)
    if (length(t_test$p.value)!=0){
      lowercase_alphabet <- letters
      sigs_x=NULL
      sigs_text=NULL
      c=1
      cs=rep(1,length(names))
      
      for (i in 1:dim(t_test$p.value)[1]){
        for (j in 1:dim(t_test$p.value)[1]){
          if (j<=i){
            i_t=match(rownames(t_test$p.value)[i],names )
            j_t=match(colnames(t_test$p.value)[j],names )
            ci=cs[i_t]
            cj=cs[j_t]
            
            if (!is.na(t_test$p.value[i,j]) & t_test$p.value[i,j]<0.01){
              #print(i_t)
              #print(j_t)
              #print(i)
              #print(j)
              sigs_x=c(sigs_x, i_t+sep_vals[ci])
              sigs_x=c(sigs_x, j_t+sep_vals[cj])
              sigs_text=c(sigs_text, letters[c])
              sigs_text=c(sigs_text, letters[c])
              c=c+1
              cs[i_t]=cs[i_t]+1
              cs[j_t]=cs[j_t]+1
            }
          }
          #print(sigs_x)
          #print('')
        }
        
      }
      #print(sigs_x)
      #print(sigs_text)
      #if (length(sigs_x)>0){
      #  text(x=sigs_x, y=1.12*max(totest), sigs_text, cex=5)
      #}
    }
    return(list(sigs_x, sigs_text))
}


R <- 6371   # Earth radius in km
deg2rad <- pi/180
dlat <- 1 * deg2rad   # 1 degree in radians
dlon <- 1 * deg2rad
lat_rad <- lat_vec * deg2rad
cell_area <- (R^2) * cos(lat_rad) * dlon * dlat


# ocean area above 80N
lat_all <- seq(-89.5, 89.5, 1)

# area per latitude row
lat_rad_all <- lat_all * deg2rad
cell_area_all <- (R^2) * cos(lat_rad_all) * dlon * dlat   # km^2

# build grid
grid_all <- expand.grid(lon = lon, lat = lat_all)

# land/ocean mask
grid_all$land <- map.where("world", grid_all$lon, grid_all$lat)

# attach cell area
grid_all$area <- cell_area_all[match(grid_all$lat, lat_all)]

# select ocean north of 70N
ocean80 <- grid_all$lat >= 80 & is.na(grid_all$land)

# total ocean area
ocean_area_80N <- sum(grid_all$area[ocean80])

if (grepl('no_virus', ref_sim)){
if (depth=='int'){
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
        }
} else{
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        }
}

#breaks <- c(-0.5, 0.5, 1.5, 2.5)
cols <- c("green4", "gold")

surfaces=matrix(0, ncol=n_suff-1, nrow=2)
prods=matrix(0, ncol=(n_suff-1)*2, nrow=3)
colnames(surfaces)=suffixes_bis[1:(n_suff-1)]
names_prods=NULL
for (suff in suffixes_bis[1:(n_suff-1)]){
	names_prods=c(names_prods, suff, paste(suff, '_ref', sep=''))
}
colnames(prods)=names_prods
#print(dim(prods))
#colnames(prods)=c(suffixes_bis[1:(n_suff-1)], paste(suffixes_bis[1:(n_suff-1)], '_ref', sep=''))

productivities_all=rep(list(rep(list(NULL),(n_suff-1)*2)), length(cols)+1)
wilcox_tests=rep(list(rep(list(NULL),(n_suff-1))), length(cols)+1)

x=suffixes_bis[1:(n_suff-1)]
nas= as.vector(rbind(paste('NV',x, sep='-'), x))
for (i in 1:(length(cols)+1)){
        names(productivities_all[[i]])=nas#suffixes_bis[(n_suff):1]
        names(wilcox_tests[[i]])=suffixes_bis[1:(n_suff-1)]
}

count=1
count0=1
for (suff in suffixes[1:(n_suff-1)]){
	suff_bis=suffixes_bis[which(suffixes==suff)]

	cond_1=data_to_save[[suff]][['NPP']] >0  & data_to_save[[suff]][['log10_DON_DIN']] <0
	cond_2=data_to_save[[suff]][['NPP']] >0  & data_to_save[[suff]][['log10_DON_DIN']] >0
	conts=matrix(0, nrow=nr, ncol=nc)
	conts[cond_1==T]=1
	conts[cond_2==T]=2
	conts[is.na(data_to_plot[[suff]][['%Inf']])]=NA
	conts0=conts
        conts0[conts==0]=NA
	 bks=seq(0.5, length(cols)+0.5, 1)
	template_map(min_lo, max_lo, min_lt, max_lt)	
	image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = cols, useRaster = TRUE, add = TRUE, breaks=bks)
	#.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
	axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)	

	conts=as.vector(conts)

	area_1=sum(cell_area[conts == 1], na.rm = TRUE)
	area_2=sum(cell_area[conts == 2], na.rm = TRUE)
	surfaces[1, count0]=area_1
	surfaces[2, count0]=area_2

	prod=as.vector(data_to_plot[[suff]][['NPP']])
	prod_ref=as.vector(data_to_plot[[suffixes[n_suff]]][['NPP']])
	
	prod_1=sum(cell_area[conts == 1]*1e6*prod[conts == 1], na.rm = TRUE)
	prod_2=sum(cell_area[conts == 2]*1e6*prod[conts == 2], na.rm = TRUE)
	prod_3=sum(cell_area[conts == 0]*1e6*prod[conts == 0], na.rm = TRUE)
	
	prod_1_ref=sum(cell_area[conts == 1]*1e6*prod_ref[conts == 1], na.rm = TRUE)
        prod_2_ref=sum(cell_area[conts == 2]*1e6*prod_ref[conts == 2], na.rm = TRUE)
        prod_3_ref=sum(cell_area[conts == 0]*1e6*prod_ref[conts == 0], na.rm = TRUE)


	prods[1, count]=prod_2_ref
        prods[2, count]=prod_1_ref
        prods[3, count]=prod_3_ref

	prods[1, count+1]=prod_2
        prods[2, count+1]=prod_1
        prods[3, count+1]=prod_3
	
	
	productivities_all[[1]][[suff_bis]]=prod[conts == 1]
        productivities_all[[2]][[suff_bis]]=prod[conts == 2]
	productivities_all[[3]][[suff_bis]]=prod[conts == 0]
        
        productivities_all[[1]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 1]
        productivities_all[[2]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 2]
        productivities_all[[3]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 0]
	
	for (i in 1:3){
                if (i!=3){
                        if (sum(conts == i, na.rm=T)>5){
                                p_val=wilcox.test(prod_ref[conts == i], prod[conts == i], paired=T)$p.value
                        } else{
                                p_val=1
                        }
                        wilcox_tests[[i]][[suff_bis]]=p_val
                } else{
                        if (sum(conts == 0, na.rm=T)>5){
                                p_val=wilcox.test(prod_ref[conts == 0], prod[conts == 0], paired=T)$p.value
                        } else{
                                p_val=1
                        }
                        wilcox_tests[[i]][[suff_bis]]=p_val
                }
        }
	
	count=count+2
	count0=count0+1
}


tot_surf_ocean=sum(cell_area[!is.na(conts)], na.rm=T)+ocean_area_80N
barplot(surfaces*100/tot_surf_ocean, col=c("green4", "gold"), ylab='% OceanArea', beside=T)
area_ticks <- pretty(c(0, max(surfaces)))
pct_ticks <- 100 * area_ticks / tot_surf_ocean
axis(side = 4, at = pct_ticks, labels = format(area_ticks, big.mark = ","))
mtext("Area (km²)", side = 4, line = 3)


print(prods)
print(apply(prods, 2, sum))
tot_prod=sum(prods[,(n_suff-1)*2])
print(tot_prod)
barplot(prods*100/tot_prod, col=c("gold", "green4", 'dodgerblue'), ylab='%NPP (gC.year-1))', space=rep(c(1,0) , n_suff-1))
prod_ticks <- pretty(c(0, max(tot_prod)))
pct_ticks <- 100 * prod_ticks / tot_prod
axis(side = 4, at = pct_ticks, labels = format(prod_ticks, big.mark = ","))
mtext("NPP (gC.year-1))", side = 4, line = 3)

prod_perc=prods*100/tot_prod
new_df=prod_perc
new_df[1, ] <- prod_perc[1, ] + prod_perc[2, ]
new_df <- new_df[-2, ]

barplot(new_df, col=c("red", 'blue'), ylab='%NPP (gC.year-1))', space=rep(c(1,0) , n_suff-1))
prod_ticks <- pretty(c(0, max(tot_prod)))
pct_ticks <- 100 * prod_ticks / tot_prod
axis(side = 4, at = pct_ticks, labels = format(prod_ticks, big.mark = ","))
mtext("NPP (gC.year-1))", side = 4, line = 3)

saveRDS(prods, paste('production_new-prod_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
saveRDS(prods*100/tot_prod,paste('production_partitioning_new-prod_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
saveRDS(surfaces*100/tot_surf_ocean,paste('area_partitioning_new-prod_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))


library('vioplot')
cols=c("green4", "gold", 'dodgerblue')
sep_vals=seq(-0.25, 0.25, 0.5/(length(suffixes)-2))#c(-0.25, -0.125, 0, 0.125, 0.25)
par(mar=c(5.1,5, 1, 1))
for (i in 1:length(cols)){
        for (na in names(productivities_all[[i]])){
	  #print(na)
	  #print(productivities_all[[i]])
          if (sum(productivities_all[[i]][[na]], na.rm=T)==0 | sum(!is.na(productivities_all[[i]][[na]])) <25 ){
            productivities_all[[i]][[na]]=rep(0,length(productivities_all[[i]][[na]]))
          }
        }
        val_list=unlist(productivities_all[[i]])

        vioplot(productivities_all[[i]],  col=cols[i], ylim=c(min(val_list, na.rm=T), 1.12*max(val_list, na.rm=T)), yaxt='n', xaxt='n')
        axis(1,  lwd = 0, lwd.ticks = 3, las = 2, cex.axis=2, mgp = c(3, 2, 0), labels=names(productivities_all[[i]]), at=1:length(names(productivities_all[[i]])))
        axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
        medians=lapply(productivities_all[[i]], function(x){median(x, na.rm=T)})
        medians=unlist(medians)
        means=lapply(productivities_all[[i]], function(x){mean(x, na.rm=T)})
        means=unlist(medians)
        box(lwd = 3)
        stripchart(productivities_all[[i]], method='jitter', vertical=T, pch=19, add=T, col='black', cex=0.1)
        points(1:length(productivities_all[[i]]), medians, col='white', cex=1.5, pch=19)
        p_vals=NULL
        for (k in 1:length(wilcox_tests[[i]])){
                p_vals=c(p_vals, wilcox_tests[[i]][[k]])
        }
        p_vals_h=p.adjust(p_vals, method='BH')
        #print('pvals')
        #print(p_vals_h)
        for (j in 1:(length(productivities_all[[i]])/2)){
                na=nas[j*2-1]
                med=median(productivities_all[[i]][[na]], na.rm=T)
                if (sd(productivities_all[[i]][[na]],  na.rm=T)!=0){
			segments(j*2-1-0.5, med, j*2-1+1.5, med,  lwd=3, lty='dashed')
		}
		if (p_vals_h[j]<0.001){
                        text('***', x=j*2-1+0.5, y=1.1*max(val_list, na.rm=T), cex=2)
                        segments(j*2-1, 1.05*max(val_list, na.rm=T), j*2-1+1, lwd=3)
                } else if (p_vals_h[j]<0.01){
                        text('**', x=j*2-1+0.5,y=1.1*max(val_list, na.rm=T), cex=2)
                        segments(j*2-1, 1.05*max(val_list, na.rm=T), j*2-1+1, lwd=3)
		} else if (p_vals_h[j]<0.01){
                        text('**', x=j*2-1+0.5,y=1.1*max(val_list, na.rm=T), cex=2)
                        segments(j*2-1, 1.05*max(val_list, na.rm=T), j*2-1+1, lwd=3)
                } else if (p_vals_h[j]<0.05){
                        text('*', x=j*2-1+0.5,y=1.1*max(val_list, na.rm=T), cex=2)
                        segments(j*2-1, 1.05*max(val_list, na.rm=T), j*2-1+1, lwd=3)
                }
        }
	saveRDS(list(medians, means), paste('new_prod_productivities_',cols[i],'_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
}

dev.off()


if (depth=='int'){
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_bis_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_bis_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
        }
} else{
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_bis_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_new-prod_regions_bis_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        }
}

#breaks <- c(-0.5, 0.5, 1.5, 2.5, 3.5)
cols <- c("purple","green4", "gold", "darkred")
cols_b <- c("limegreen", "deepskyblue", "red4")

surfaces=matrix(0, ncol=n_suff-1, nrow=4)
prods=matrix(0, ncol=(n_suff-1)*2, nrow=5)
colnames(surfaces)=suffixes_bis[1:(n_suff-1)]
names_prods=NULL
for (suff in suffixes_bis[1:(n_suff-1)]){
        names_prods=c(names_prods, paste(suff, '_ref', sep=''), suff)
}
colnames(prods)=names_prods

productivities=rep(list(rep(list(NULL),n_suff)), length(cols)+1)
for (i in 1:(length(cols)+1)){
        names(productivities[[i]])=suffixes_bis[1:(n_suff)]
}

productivities_all=rep(list(rep(list(NULL),(n_suff-1)*2)), length(cols)+1)
wilcox_tests=rep(list(rep(list(NULL),(n_suff-1))), length(cols)+1)

x=suffixes_bis[1:(n_suff-1)]
nas= as.vector(rbind(paste('NV',x, sep='-'), x))
print(nas)
for (i in 1:(length(cols)+1)){
        names(productivities_all[[i]])=nas#suffixes_bis[(n_suff):1]
	names(wilcox_tests[[i]])=suffixes_bis[1:(n_suff-1)]
}



#print(dim(prods))
#colnames(prods)=c(suffixes_bis[1:(n_suff-1)], paste(suffixes_bis[1:(n_suff-1)], '_ref', sep=''))
count=1
count0=1
for (suff in suffixes[1:(n_suff-1)]){
	cond_P = data_to_save[[suff]][['Total_P']] >0
	cont_P=cond_P
	cont_P[cond_P==T]=1
	cont_P[cond_P==F]=0

	cond_chl = data_to_save[[suff]][['chl']] >0
        cont_chl=cond_chl
        cont_chl[cond_chl==T]=1
        cont_chl[cond_chl==F]=0

        cond_1=data_to_save[[suff]][['NPP']] >0  & data_to_save[[suff]][['log10_DON_DIN']] <0 & sign(data_to_plot[[suff]][['log10_DON_DIN']]) != sign(data_to_plot[[suff_ref]][['log10_DON_DIN']])
        cond_2=data_to_save[[suff]][['NPP']] >0  & data_to_save[[suff]][['log10_DON_DIN']] <0 & sign(data_to_plot[[suff]][['log10_DON_DIN']]) == sign(data_to_plot[[suff_ref]][['log10_DON_DIN']])
	
	cond_3=data_to_save[[suff]][['NPP']] >0  & data_to_save[[suff]][['log10_DON_DIN']] >0 & sign(data_to_plot[[suff]][['log10_DON_DIN']]) == sign(data_to_plot[[suff_ref]][['log10_DON_DIN']])
	cond_4=data_to_save[[suff]][['NPP']] >0  & data_to_save[[suff]][['log10_DON_DIN']] >0 & sign(data_to_plot[[suff]][['log10_DON_DIN']]) != sign(data_to_plot[[suff_ref]][['log10_DON_DIN']])

        cond_1_b=data_to_save[[suff]][['NPP']] >0 & data_to_save[[suff]][['Total_P']] >0 & data_to_save[[suff]][['chl']] >0
	cond_2_b=data_to_save[[suff]][['NPP']] >0 & data_to_save[[suff]][['Total_P']] <0 & data_to_save[[suff]][['chl']] >0
	cond_3_b=data_to_save[[suff]][['NPP']] >0 & data_to_save[[suff]][['Total_P']] <0 & data_to_save[[suff]][['chl']] <0
	
	
	conts=matrix(0, nrow=nr, ncol=nc)
        conts[cond_1==T]=1
        conts[cond_2==T]=2
	conts[cond_3==T]=3
	conts[cond_4==T]=4
	conts_b=matrix(0, nrow=nr, ncol=nc)
	conts_b[cond_1_b==T]=1
        conts_b[cond_2_b==T]=2
        conts_b[cond_3_b==T]=3
	na_cond=is.na(data_to_plot[[suff]][['%Inf']])
        conts[na_cond]=NA
	conts_b[na_cond]=NA
	cont_P[na_cond]=NA
	cont_chl[na_cond]=NA
        conts0=conts
        conts0[conts==0]=NA
	conts0_b=conts_b
        conts0_b[conts_b==0]=NA
	bks=seq(0.5, length(cols)+0.5, 1)
	bks_b=seq(0.5, length(cols_b)+0.5, 1)

        template_map(min_lo, max_lo, min_lt, max_lt)
        image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = cols, useRaster = TRUE, add = TRUE,  breaks=bks)
        #.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)

	template_map(min_lo, max_lo, min_lt, max_lt)
        image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = cols, useRaster = TRUE, add = TRUE,  breaks=bks)
        #.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
	contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt],cont_P, levels=c(0,1), add=T, labels=0, lwd=2)
        
	template_map(min_lo, max_lo, min_lt, max_lt)
        image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = cols, useRaster = TRUE, add = TRUE,  breaks=bks)
        #.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
        contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt],cont_P, levels=c(0,1), add=T, labels=0, lwd=2)
	contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt],cont_chl, levels=c(0,1), add=T, labels=0, lwd=2, col='turquoise')

	template_map(min_lo, max_lo, min_lt, max_lt)
        image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0_b, col = cols_b, useRaster = TRUE, add = TRUE,  breaks=bks_b)
        #.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)

	conts=as.vector(conts)

        area_1=sum(cell_area[conts == 1], na.rm = TRUE)
        area_2=sum(cell_area[conts == 2], na.rm = TRUE)
        area_3=sum(cell_area[conts == 3], na.rm = TRUE)
	area_4=sum(cell_area[conts == 4], na.rm = TRUE)
	surfaces[1, count0]=area_1
        surfaces[2, count0]=area_2
	surfaces[3, count0]=area_3
	surfaces[4, count0]=area_4

        prod=as.vector(data_to_plot[[suff]][['NPP']])
        prod_ref=as.vector(data_to_plot[[suffixes[n_suff]]][['NPP']])

        prod_1=sum(cell_area[conts == 1]*1e6*prod[conts == 1], na.rm = TRUE)
        prod_2=sum(cell_area[conts == 2]*1e6*prod[conts == 2], na.rm = TRUE)
	prod_3=sum(cell_area[conts == 3]*1e6*prod[conts == 3], na.rm = TRUE)
        prod_4=sum(cell_area[conts == 4]*1e6*prod[conts == 4], na.rm = TRUE)
	prod_5=sum(cell_area[conts == 0]*1e6*prod[conts == 0], na.rm = TRUE)

        prod_1_ref=sum(cell_area[conts == 1]*1e6*prod_ref[conts == 1], na.rm = TRUE)
        prod_2_ref=sum(cell_area[conts == 2]*1e6*prod_ref[conts == 2], na.rm = TRUE)
        prod_3_ref=sum(cell_area[conts == 3]*1e6*prod_ref[conts == 3], na.rm = TRUE)
	prod_4_ref=sum(cell_area[conts == 4]*1e6*prod_ref[conts == 4], na.rm = TRUE)
	prod_5_ref=sum(cell_area[conts == 0]*1e6*prod_ref[conts == 0], na.rm = TRUE)
      

        prods[1, count]=prod_4_ref
        prods[2, count]=prod_3_ref
	prods[3, count]=prod_2_ref
        prods[4, count]=prod_1_ref
	prods[5, count]=prod_5_ref

	prods[1, count+1]=prod_4
        prods[2, count+1]=prod_3
        prods[3, count+1]=prod_2
        prods[4, count+1]=prod_1
        prods[5, count+1]=prod_5

	suff_bis=suffixes_bis[which(suffixes==suff)]
        
	productivities[[1]][[suff_bis]]=prod[conts == 1]
        productivities[[2]][[suff_bis]]=prod[conts == 2]
	productivities[[3]][[suff_bis]]=prod[conts == 3]
        productivities[[4]][[suff_bis]]=prod[conts == 4]
	productivities[[5]][[suff_bis]]=prod[conts == 0]
	
	productivities_all[[1]][[suff_bis]]=prod[conts == 1]
        productivities_all[[2]][[suff_bis]]=prod[conts == 2]
        productivities_all[[3]][[suff_bis]]=prod[conts == 3]
        productivities_all[[4]][[suff_bis]]=prod[conts == 4]
        productivities_all[[5]][[suff_bis]]=prod[conts == 0]

	if (count0==(n_suff-1)){
		productivities[[1]][[suff_ref_bis]]=prod_ref[conts == 1]
        	productivities[[2]][[suff_ref_bis]]=prod_ref[conts == 2]
        	productivities[[3]][[suff_ref_bis]]=prod_ref[conts == 3]
        	productivities[[4]][[suff_ref_bis]]=prod_ref[conts == 4]
        	productivities[[5]][[suff_ref_bis]]=prod_ref[conts == 0]
	}

	productivities_all[[1]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 1]
        productivities_all[[2]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 2]
        productivities_all[[3]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 3]
        productivities_all[[4]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 4]
        productivities_all[[5]][[paste('NV', suff_bis, sep='-')]]=prod_ref[conts == 0]
	
	for (i in 1:5){
		if (i!=5){
			if (sum(conts == i, na.rm=T)>5){
				p_val=wilcox.test(prod_ref[conts == i], prod[conts == i], paired=T)$p.value
			} else{
				p_val=1
			}
			wilcox_tests[[i]][[suff_bis]]=p_val
		} else{
			if (sum(conts == 0, na.rm=T)>5){
                                p_val=wilcox.test(prod_ref[conts == 0], prod[conts == 0], paired=T)$p.value
                        } else{
                                p_val=1
                        }
                        wilcox_tests[[i]][[suff_bis]]=p_val
		}
	}
	#wilcox_tests[[1]][[suff_bis]]= wilcox.test(prod_ref[conts == 1], prod[conts == 1], paired=T)$p.value
	#wilcox_tests[[2]][[suff_bis]]= wilcox.test(prod_ref[conts == 2], prod[conts == 2], paired=T)$p.value
	#wilcox_tests[[3]][[suff_bis]]= wilcox.test(prod_ref[conts == 3], prod[conts == 3], paired=T)$p.value
	#wilcox_tests[[4]][[suff_bis]]= wilcox.test(prod_ref[conts == 4], prod[conts == 4], paired=T)$p.value
	#wilcox_tests[[5]][[suff_bis]]= wilcox.test(prod_ref[conts == 0], prod[conts == 0], paired=T)$p.value

        count=count+2
        count0=count0+1
}


tot_surf_ocean=sum(cell_area[!is.na(conts)], na.rm=T)+ocean_area_80N
barplot(surfaces*100/tot_surf_ocean, col=c("purple","green4", "gold", "darkred"), ylab='% OceanArea', beside=T)
area_ticks <- pretty(c(0, max(surfaces)))
pct_ticks <- 100 * area_ticks / tot_surf_ocean
axis(side = 4, at = pct_ticks, labels = format(area_ticks, big.mark = ","))
mtext("Area (km²)", side = 4, line = 3)
print(prods)
print(apply(prods, 2, sum))
tot_prod=sum(prods[,(n_suff-1)*2-1])
print(tot_prod)
barplot(prods*100/tot_prod, col=c("darkred","gold", "green4","purple", 'dodgerblue'), ylab='%NPP (gC.year-1))', space=rep(c(1,0) , n_suff-1))
prod_ticks <- pretty(c(0, max(tot_prod)))
pct_ticks <- 100 * prod_ticks / tot_prod
axis(side = 4, at = pct_ticks, labels = format(prod_ticks, big.mark = ","))
mtext("NPP (gC.year-1))", side = 4, line = 3)

#saveRDS(prods, paste('production_new-prod_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
#saveRDS(prods*100/tot_prod,paste('production_partitioning_new-prod_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
#saveRDS(surfaces*100/tot_surf_ocean,paste('area_partitioning_new-prod_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))

library('vioplot')
cols=c("purple","green4", "gold","darkred", 'dodgerblue')
sep_vals=seq(-0.25, 0.25, 0.5/(length(suffixes)-2))#c(-0.25, -0.125, 0, 0.125, 0.25)
par(mar=c(5.1,5, 1, 1))
#for (i in 1:length(cols)){
	#print('col')
	#print(col)
	#print(i)
#	totest=unlist(productivities[[i]])
#	for (na in names(productivities[[i]])){
#	  print(na)
#	  print(sum(productivities[[i]][[na]], na.rm=T))
          
#	  if (sum(productivities[[i]][[na]], na.rm=T)==0){
#            	  print(length(productivities_all[[i]][[na]]))
#		  productivities[[i]][[na]]=rep(0,length(productivities_all[[i]][[na]]))#length(productivities[[i]][[na]]))
#          }
#        }
	
	#print(productivities[[i]])

#	vioplot(productivities[[i]], col=cols[i], ylim=c(min(totest, na.rm=T), 1.12*max(totest, na.rm=T)), yaxt='n', xaxt='n')
#	axis(1,  lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, mgp = c(3, 2, 0), labels=names(productivities[[i]]), at=1:length(names(productivities[[i]])))
 #       axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
 #       medians=lapply(productivities[[i]], function(x){median(x, na.rm=T)})
#	medians=unlist(medians)
#	means=lapply(productivities[[i]], function(x){mean(x, na.rm=T)})
#        means=unlist(means)
#	box(lwd = 3)
#	stripchart(productivities[[i]], method='jitter', vertical=T, pch=19, add=T, col='black', cex=0.1)
#	points(1:length(productivities[[i]]), medians, col='white', cex=1.5, pch=19)
#        abline(h=medians[length(medians)], lwd=3, lty='dashed')
#	sigs=plot_sigs(totest, productivities[[i]], names(productivities[[i]]), sep_vals)
#	sigs_x=sigs[[1]]
#	sigs_text=sigs[[2]]
#	if (length(sigs_x)>0){
#	  text(x=sigs_x, y=1.1*max(totest, na.rm=T), sigs_text, cex=2)
#	}
#}



par(mar=c(5.1,5, 1, 1))
for (i in 1:length(cols)){
	#val_list=unlist(productivities_all[[i]])
	for (na in names(productivities_all[[i]])){
          if (sum(productivities_all[[i]][[na]], na.rm=T)==0 | sum(!is.na(productivities_all[[i]][[na]]))<25 ){
            productivities_all[[i]][[na]]=rep(0,length(productivities_all[[i]][[na]]))
          }
        }
	val_list=unlist(productivities_all[[i]])
	
	print(productivities_all[[i]])
	#print(productivities_all[[i]])
	vioplot(productivities_all[[i]],  col=cols[i], ylim=c(min(val_list, na.rm=T), 1.12*max(val_list, na.rm=T)), yaxt='n', xaxt='n')
	axis(1,  lwd = 0, lwd.ticks = 3, las = 2, cex.axis=2, mgp = c(3, 2, 0), labels=names(productivities_all[[i]]), at=1:length(names(productivities_all[[i]])))
        axis(2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
	medians=lapply(productivities_all[[i]], function(x){median(x, na.rm=T)})
        medians=unlist(medians)
        means=lapply(productivities_all[[i]], function(x){mean(x, na.rm=T)})
        means=unlist(medians)
	box(lwd = 3)
	stripchart(productivities_all[[i]], method='jitter', vertical=T, pch=19, add=T, col='black', cex=0.1)
        points(1:length(productivities_all[[i]]), medians, col='white', cex=1.5, pch=19)
	p_vals=NULL
	for (k in 1:length(wilcox_tests[[i]])){
		p_vals=c(p_vals, wilcox_tests[[i]][[k]])
	}
	p_vals_h=p.adjust(p_vals, method='BH')
	print('pvals')
	print(p_vals_h)
	for (j in 1:(length(productivities_all[[i]])/2)){
		#print(productivities_all[[i]][[j*2-1]])
		#print(j*2-1)
		#print(nas)
		na=nas[j*2-1]
		#print(na)
		#print(productivities_all[[i]][[na]])
		med=median(productivities_all[[i]][[na]], na.rm=T)
		if (sd(productivities_all[[i]][[na]], na.rm=T)!=0  ){
			segments(j*2-1-0.5, med, j*2-1+1.5, med,  lwd=3, lty='dashed')
		}
		if (p_vals_h[j]<0.001){
			text('***', x=j*2-1+0.5, y=1.1*max(val_list, na.rm=T), cex=2)
			segments(j*2-1, 1.05*max(val_list, na.rm=T), j*2-1+1, lwd=3)
		} else if (p_vals_h[j]<0.01){
                        text('**', x=j*2-1+0.5,y=1.1*max(val_list, na.rm=T), cex=2)
			segments(j*2-1, 1.05*max(val_list, na.rm=T), j*2-1+1, lwd=3)
                } else if (p_vals_h[j]<0.05){
                        text('*', x=j*2-1+0.5,y=1.1*max(val_list, na.rm=T), cex=2)
			segments(j*2-1, 1.05*max(val_list, na.rm=T), j*2-1+1, lwd=3)
                }
	}
	#saveRDS(list(medians, means), paste('new_prod_productivities_',cols[i],'_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
}
dev.off()
}

par(mar=c(5.1, 4.1, 4.1, 2.1))

lt_cop=readRDS('latitude_copernicus.rds')
lo_cop=readRDS('longitude_copernicus.rds')

lon_mat_cop <- t(matrix(rep(lo_cop, each = length(lt_cop)), nrow = length(lt_cop)))
lat_mat_cop <- t(matrix(rep(lt_cop, times = length(lo_cop)), nrow = length(lt_cop)))

lon_vec_cop=as.vector(lon_mat_cop)
lat_vec_cop=as.vector(lat_mat_cop)

olig_cop=readRDS('oligotrophic_gyres_copernicus_climatology_2025.rds')
chl_cop=readRDS('chlorophyll_copernicus_climatology_2025.rds')

cop_pts <- cbind(lon_vec_cop, lat_vec_cop)
qry_pts <- cbind(lon_vec, lat_vec)

idx_closest <- nn2(cop_pts, qry_pts, k = 1)$nn.idx[,1]
idx_olig=which(olig_cop==2)
idx_holig=which(olig_cop==1)
keep <- idx_closest %in% c(idx_olig, idx_holig)
idx_closest[!keep] <- NA

idx_closest_olig  <- idx_closest
idx_closest_olig[!(idx_closest %in% idx_olig)] <- NA

idx_closest_holig <- idx_closest
idx_closest_holig[!(idx_closest %in% idx_holig)] <- NA


lt_lim=40
olig_cop[,abs(lt_cop)>lt_lim]=0


dlat_cop <- 0.25 * deg2rad   # 0.25 degree in radians
dlon_cop <- 0.25 * deg2rad
lat_rad_cop <- lat_vec_cop * deg2rad
cell_area_cop <- (R^2) * cos(lat_rad_cop) * dlon_cop * dlat_cop


vec_cop=as.vector(olig_cop)
area_ho_cop=sum(cell_area_cop[olig_cop == 1], na.rm = TRUE)
print('area_ho_cop')
print(area_ho_cop)
area_o_cop=sum(cell_area_cop[olig_cop == 2], na.rm = TRUE)
print('area_o_cop')
print(area_o_cop)

regs=c('all', 'trop')
for (reg in regs){
if (depth=='int'){
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_oligotrophic_regions_',reg, '_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_oligotrophic_regions_',reg, '_',sca,'_',type,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width=10, height=10)
        }
} else{
        if (region=='world'){
                pdf(paste('3D_darwin_maps_comparisons_oligotrophic_regions_',reg, '_',sca,'_',type,'_depth',de,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        } else{
                pdf(paste('3D_darwin_maps_comparisons_oligotrophic_regions_',reg, '_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.pdf', sep=''), width = wd, height = hg)
        }
}

cols <- c("chocolate", "sandybrown")

surfaces=matrix(0, ncol=n_suff, nrow=2)
prods=matrix(0, ncol=n_suff, nrow=3)
colnames(surfaces)=suffixes_bis[1:(n_suff)]
names_prods=NULL
for (suff in suffixes_bis[1:(n_suff)]){
        names_prods=c(names_prods, suff)
}
colnames(prods)=names_prods

productivities=rep(list(rep(list(NULL),n_suff)), length(cols))
for (i in 1:length(cols)){
	names(productivities[[i]])=suffixes_bis[1:(n_suff)]
}

#print(dim(prods))
#colnames(prods)=c(suffixes_bis[1:(n_suff-1)], paste(suffixes_bis[1:(n_suff-1)], '_ref', sep=''))
count=1
count0=1

if (type=='ind'){
	Q=Qps[1]
} else{
	Q=1
}

for (suff in suffixes[1:n_suff]){
        if (reg=='trop'){
	  #cond_1=data_to_plot[[suff]][['Total_P']]<0.5/Q & data_to_plot[[suff]][['Total_P']]>0.2/Q & abs(lat_mat)<35
          #cond_2=data_to_plot[[suff]][['Total_P']]>0 & data_to_plot[[suff]][['Total_P']]<0.2/Q & abs(lat_mat)<35
	  cond_1=data_to_plot[[suff]][['chl']]<0.1 & data_to_plot[[suff]][['chl']]>0.05 & abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])<lt_lim
	  cond_2=data_to_plot[[suff]][['chl']]>0 & data_to_plot[[suff]][['chl']]<0.05 & abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])<lt_lim
	  #cond_1_ref=data_to_plot[[suff_ref]][['Total_P']]<0.5/Q & data_to_plot[[suff_ref]][['Total_P']]>0.2/Q & abs(lat_mat)<35
	  #cond_2_ref=data_to_plot[[suff_ref]][['Total_P']]>0 & data_to_plot[[suff_ref]][['Total_P']]<0.2/Q & abs(lat_mat)<35
	  cond_1_ref=data_to_plot[[suff_ref]][['chl']]<0.1 & data_to_plot[[suff_ref]][['chl']]>0.05 & abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])<lt_lim
	  cond_2_ref=data_to_plot[[suff_ref]][['chl']]>0 & data_to_plot[[suff_ref]][['chl']]<0.05 & abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])<lt_lim
	} else{
	  #cond_1=data_to_plot[[suff]][['Total_P']]<0.5/Q & data_to_plot[[suff]][['Total_P']]>0.2/Q 
          #cond_2=data_to_plot[[suff]][['Total_P']]>0 & data_to_plot[[suff]][['Total_P']]<0.2/Q 
	  cond_1=data_to_plot[[suff]][['chl']]<0.1 & data_to_plot[[suff]][['chl']]>0.05
	  cond_2=data_to_plot[[suff]][['chl']]>0 & data_to_plot[[suff]][['chl']]<0.05
	  #cond_1_ref=data_to_plot[[suff_ref]][['Total_P']]<0.5/Q & data_to_plot[[suff_ref]][['Total_P']]>0.2/Q 
          #cond_2_ref=data_to_plot[[suff_ref]][['Total_P']]>0 & data_to_plot[[suff_ref]][['Total_P']]<0.2/Q
	  cond_1_ref=data_to_plot[[suff_ref]][['chl']]<0.1 & data_to_plot[[suff_ref]][['chl']]>0.05
	  cond_2_ref=data_to_plot[[suff_ref]][['chl']]>0 & data_to_plot[[suff_ref]][['chl']]<0.05
	}
	conts=matrix(0, nrow=nr, ncol=nc)
        conts[cond_1==T]=1
        conts[cond_2==T]=2
        conts[is.na(data_to_plot[[suff]][['%Inf']])]=NA
        conts0=conts
	conts0[conts==0]=NA
        
	if (reg=='trop'){
		conts[abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])>lt_lim]=3
		conts0[abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])>lt_lim]=3
		conts[is.na(data_to_plot[[suff]][['%Inf']])]=NA
		conts0[is.na(data_to_plot[[suff]][['%Inf']])]=NA
	}

	conts_ref=matrix(0, nrow=nr, ncol=nc)
        conts_ref[cond_1_ref==T]=1
        conts_ref[cond_2_ref==T]=2
        conts_ref[is.na(data_to_plot[[suff]][['%Inf']])]=NA
        conts0_ref=conts_ref
        conts0_ref[conts_ref==0]=NA
	
	if (reg=='trop'){
                conts_ref[abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])>lt_lim]=3
        }

	template_map(min_lo, max_lo, min_lt, max_lt)
        if (reg=='all'){
	  image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = cols, useRaster = TRUE, add=T, breaks=seq(0.5, 2.5, by=1) )
	} else{
	  image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = c(cols, 'gray'), useRaster = TRUE, add=T , breaks=seq(0.5, 3.5, by=1))
	}
	#.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)


	template_map(min_lo, max_lo, min_lt, max_lt)
        if (reg=='all'){
          image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = cols, useRaster = TRUE, add=T, breaks=seq(0.5, 2.5, by=1) )
        } else{
          image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, col = c(cols, 'gray'), useRaster = TRUE, add=T , breaks=seq(0.5, 3.5, by=1))
        }
        #.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
	contour(x=lo_cop, y=lt_cop,z=olig_cop, levels = c(0,1,2), add=T, drawlabels = FALSE, lwd=2, lty = c(3, 1, 2))

        diff_conts=matrix(0, nrow=nr, ncol=nc)
	diff_conts[conts==1 & conts_ref==1]=1
	diff_conts[conts==2 & conts_ref==2]=2
	diff_conts[conts==1 & conts_ref==2]=3
	diff_conts[conts==2 & conts_ref==1]=4
	diff_conts[conts==0 & conts_ref==2]=5
	diff_conts[conts==0 & conts_ref==1]=6
	diff_conts[conts==1 & conts_ref==0]=7
	diff_conts[conts==2 & conts_ref==0]=8
	diff_conts[conts==0 & conts_ref==0]=NA
	if (reg=='trop'){
	  diff_conts[abs(lat_mat[i1_lo:i2_lo,i1_lt:i2_lt])>lt_lim]=9
	  cols_diff=c('chocolate' ,'sandybrown','darkgreen', 'darkred', 'steelblue', 'steelblue1', 'gold', 'goldenrod', 'grey')
	  bks=seq(0.5, 9.5, by = 1)
	} else{
	  cols_diff=c('chocolate' ,'sandybrown','darkgreen', 'darkred', 'steelblue', 'steelblue1', 'gold', 'goldenrod')
	  bks=seq(0.5, 8.5, by = 1)
	}
	diff_conts[is.na(data_to_plot[[suff]][['%Inf']])]=NA

	template_map(min_lo, max_lo, min_lt, max_lt)
        image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], diff_conts, col = cols_diff, useRaster = TRUE, add=T, breaks=bks)
        #.filled.contour(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], conts0, levels = breaks, col = cols)
        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)

	
	conts=as.vector(conts)

        area_1=sum(cell_area[conts == 1], na.rm = TRUE)
        area_2=sum(cell_area[conts == 2], na.rm = TRUE)
        surfaces[1, count0]=area_1
        surfaces[2, count0]=area_2

        prod=as.vector(data_to_plot[[suff]][['NPP']])
        prod_ref=as.vector(data_to_plot[[suffixes[n_suff]]][['NPP']])

        prod_1=sum(cell_area[conts == 1]*1e6*prod[conts == 1], na.rm = TRUE)
        prod_2=sum(cell_area[conts == 2]*1e6*prod[conts == 2], na.rm = TRUE)
        prod_3=sum(cell_area[conts == 0]*1e6*prod[conts == 0], na.rm = TRUE)

	suff_bis=suffixes_bis[which(suffixes==suff)]
	productivities[[1]][[suff_bis]]=prod[conts == 1]
	productivities[[2]][[suff_bis]]=prod[conts == 2]
        #prod_1_ref=sum(cell_area[conts == 1]*1e6*prod_ref[conts == 1], na.rm = TRUE)
        #prod_2_ref=sum(cell_area[conts == 2]*1e6*prod_ref[conts == 2], na.rm = TRUE)
        #prod_3_ref=sum(cell_area[conts == 0]*1e6*prod_ref[conts == 0], na.rm = TRUE)

        prods[1, count0]=prod_2
        prods[2, count0]=prod_1
        prods[3, count0]=prod_3

        #prods[1, count+1]=prod_2_ref
        #prods[2, count+1]=prod_1_ref
        #prods[3, count+1]=prod_3_ref
        count=count+2
        count0=count0+1
}


tot_surf_ocean=sum(cell_area[!is.na(conts)], na.rm=T)+ocean_area_80N
barplot(surfaces*100/tot_surf_ocean, col=c("chocolate", "sandybrown"), ylab='% OceanArea', beside=T)
area_ticks <- pretty(c(0, max(surfaces)))
pct_ticks <- 100 * area_ticks / tot_surf_ocean
axis(side = 4, at = pct_ticks, labels = format(area_ticks, big.mark = ","))
mtext("Area (km²)", side = 4, line = 3)

surfaces1=cbind(surfaces*100/tot_surf_ocean, c(area_o_cop*100/tot_surf_ocean, area_ho_cop*100/tot_surf_ocean))
print('surfaces1')
print(surfaces1)
colnames(surfaces1)=c(colnames(surfaces), 'Cop')
barplot(surfaces1, col=c("chocolate", "sandybrown"), ylab='% OceanArea', beside=T)
area_ticks <- pretty(c(0, max(surfaces)))
pct_ticks <- 100 * area_ticks / tot_surf_ocean
axis(side = 4, at = pct_ticks, labels = format(area_ticks, big.mark = ","))
mtext("Area (km²)", side = 4, line = 3)

if (ref_sim %in% c('no_virus_shunt', 'no_virus', 'no_virus_shunt_all') & reg=='trop'){
        if (ref_sim=='no_virus_shunt'){
                shunts=c(0, 25, 50, 75,100)
        } else if (ref_sim=='no_virus'){
                shunts=c(50, 60, 75, 90,100)
        } else if (ref_sim=='no_virus_shunt_all'){
		shunts=c(0, 25, 50,60,75,90,100)
	}
	n_shunt=length(shunts)
	plot(shunts,surfaces1[1,1:n_shunt], ylim=c(0, 1.05*max(surfaces1)), col="chocolate", cex=3, pch=19)
	lines(shunts, surfaces1[1,1:n_shunt], col="chocolate", lwd=2)
	points(shunts, surfaces1[2,1:n_shunt], col="sandybrown", cex=3, pch=19)
	lines(shunts, surfaces1[2,1:n_shunt], col="sandybrown", lwd=2)

	abline(h=surfaces1[1,n_shunt+1], col="chocolate", lty=1, lwd=3)
	abline(h=surfaces1[2,n_shunt+1], col="sandybrown", lty=1, lwd=3)
	axis(side = 4, at = pct_ticks, labels = format(area_ticks, big.mark = ","))
	mtext("Area (km²)", side = 4, line = 3)


	plot(shunts,surfaces1[1,1:n_shunt], ylim=c(0, 1.05*max(surfaces1)), col="chocolate", cex=3, pch=19)
        lines(shunts, surfaces1[1,1:n_shunt], col="chocolate", lwd=2)
        points(shunts, surfaces1[2,1:n_shunt], col="sandybrown", cex=3, pch=19)
        lines(shunts, surfaces1[2,1:n_shunt], col="sandybrown", lwd=2)

        abline(h=surfaces1[1,n_shunt+1], col="chocolate", lty=1, lwd=3)
        abline(h=surfaces1[2,n_shunt+1], col="sandybrown", lty=1, lwd=3)
	abline(h=surfaces1[1,length(shunts)+2], col="chocolate", lty=2, lwd=3)
        abline(h=surfaces1[2,length(shunts)+2], col="sandybrown", lty=2, lwd=3)
	
	axis(side = 4, at = pct_ticks, labels = format(area_ticks, big.mark = ","))
	mtext("Area (km²)", side = 4, line = 3)


}



print(prods)
print(apply(prods, 2, sum))
tot_prod=sum(prods[,1])
print(tot_prod)
barplot(prods*100/tot_prod, col=c("sandybrown","chocolate" ,'navyblue'), ylab='%NPP (gC.year-1))')
prod_ticks <- pretty(c(0, max(tot_prod)))
pct_ticks <- 100 * prod_ticks / tot_prod
axis(side = 4, at = pct_ticks, labels = format(prod_ticks, big.mark = ","))
mtext("NPP (gC.year-1))", side = 4, line = 3)

prods0=prods[1:2,]
prods_tot=apply(prods0, 2, sum)
barplot(prods0*100/tot_prod, col=c("sandybrown","chocolate"), ylab='%NPP (gC.year-1))', beside=T)
prod_ticks <- pretty(c(0, max(prods_tot)))
pct_ticks <- 100 * prod_ticks / tot_prod
axis(side = 4, at = pct_ticks, labels = format(prod_ticks, big.mark = ","))
mtext("NPP (gC.year-1))", side = 4, line = 3)

if (ref_sim %in% c('no_virus_shunt', 'no_virus', 'no_virus_shunt_all') & reg=='trop'){
        if (ref_sim=='no_virus_shunt'){
                shunts=c(0, 25, 50, 75,100)
        } else if (ref_sim=='no_virus'){
                shunts=c(50, 60, 75, 90,100)
        } else if (ref_sim=='no_virus_shunt_all'){
		shunts=c(0, 25, 50,60, 75,90,100)
	}
        n_shunt=length(shunts)
        plot(shunts,prods0[1,1:n_shunt]*100/tot_prod, ylim=c(0, 1.05*max(prods0*100/tot_prod)), col="sandybrown", cex=3, pch=19)
        lines(shunts, prods0[1,1:n_shunt]*100/tot_prod, col="sandybrown", lwd=2)
        points(shunts, prods0[2,1:n_shunt]*100/tot_prod, col="chocolate", cex=3, pch=19)
        lines(shunts, prods0[2,1:n_shunt]*100/tot_prod, col="chocolate", lwd=2)

        abline(h=prods0[1,n_shunt+1]*100/tot_prod, col="sandybrown", lty=1, lwd=3)
        abline(h=prods0[2,n_shunt+1]*100/tot_prod, col="chocolate", lty=1, lwd=3)
	axis(side = 4, at = pct_ticks, labels = format(prod_ticks, big.mark = ","))
        mtext("NPP (gC.year-1))", side = 4, line = 3)
}


saveRDS(prods*100/tot_prod,paste('production_partitioning_oligotrophic_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
saveRDS(surfaces*100/tot_surf_ocean,paste('area_partitioning_oligotrophic_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))


barplot(prods0/surfaces, col=c("sandybrown","chocolate"), ylab='Productivity (gC.year-1.km-2))', beside=T, log='y')


library('vioplot')
par(mar=c(5.1,5, 1, 1))

sep_vals=seq(-0.25, 0.25, 0.5/(length(suffixes)-2))#c(-0.25, -0.125, 0, 0.125, 0.25)
if (grepl('no_virus', ref_sim)){
  productivities[[1]]=c(productivities[[1]][length(productivities[[1]])], productivities[[1]][-length(productivities[[1]])])
}
totest=unlist(productivities[[1]])
vioplot(productivities[[1]], col='chocolate', ylim=c(min(totest, na.rm=T), 1.12*max(totest, na.rm=T)), log='y', yaxt='n', xaxt='n')
yticks <- 10^seq(
  floor(log10(min(totest, na.rm = TRUE))),
  ceiling(log10(max(totest, na.rm = TRUE)))
)
medians=lapply(productivities[[1]], function(x){median(x, na.rm=T)})
medians=unlist(medians)
means=lapply(productivities[[1]], function(x){mean(x, na.rm=T)})
means=unlist(means)
axis(1, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, labels=names(productivities[[1]]), at=1:length(names(productivities[[i]])), mgp=c(3,2,0))
axis(2, at = yticks, labels = yticks, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
box(lwd=3)
mins <- as.vector(outer(1:9, yticks, `*`))
mins <- mins[mins > min(totest, na.rm=TRUE) &
             mins < max(totest, na.rm=TRUE)]

# Add minor ticks WITHOUT labels
axis(2, at = mins, labels = FALSE, tcl = -0.2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2) 

stripchart(productivities[[1]], method='jitter', vertical=T, pch=19, add=T, col='black', cex=0.1)
points(1:length(productivities[[1]]), medians, col='white', cex=1.5, pch=19)
abline(h=medians[1], lwd=3, lty='dashed')

sigs=plot_sigs(totest, productivities[[1]], names(productivities[[1]]), sep_vals)
sigs_x=sigs[[1]]
sigs_text=sigs[[2]]
if (length(sigs_x)>0){
  text(x=sigs_x, y=1.1*max(totest, na.rm=T), sigs_text, cex=2)
}
saveRDS(list(medians, means), paste('oligotrophic_productivities_',reg,'_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))

if (grepl('no_virus', ref_sim)){
  productivities[[2]]=c(productivities[[2]][length(productivities[[2]])], productivities[[2]][-length(productivities[[2]])])
}
totest=unlist(productivities[[2]])
vioplot(productivities[[2]], col='sandybrown', ylim=c(min(totest, na.rm=T), 1.12*max(totest, na.rm=T)), log='y', yaxt='n', xaxt='n')
yticks <- 10^seq(
  floor(log10(min(totest, na.rm = TRUE))),
  ceiling(log10(max(totest, na.rm = TRUE)))
)
axis(2, at = yticks, labels = yticks, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)
axis(1, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2, labels=names(productivities[[2]]), at=1:length(names(productivities[[i]])), mgp=c(3,2,0))
medians=lapply(productivities[[2]], function(x){median(x, na.rm=T)})
medians=unlist(medians)
means=lapply(productivities[[2]], function(x){mean(x, na.rm=T)})
means=unlist(means)
saveRDS(list(medians, means), paste('hyper-oligotrophic_productivities_',reg,'_',sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim,'.rds', sep=''))
box(lwd=3)
mins <- as.vector(outer(1:9, yticks, `*`))
mins <- mins[mins > min(totest, na.rm=TRUE) &
             mins < max(totest, na.rm=TRUE)]

# Add minor ticks WITHOUT labels
axis(2, at = mins, labels = FALSE, tcl = -0.2, lwd = 0, lwd.ticks = 3, las = 1, cex.axis=2)

stripchart(productivities[[2]], method='jitter', vertical=T, pch=19, add=T, col='black', cex=0.1)

points(1:length(productivities[[2]]), medians, col='white', cex=1.5, pch=19)
abline(h=medians[1], lwd=3, lty='dashed')

sigs=plot_sigs(totest, productivities[[2]], names(productivities[[2]]), sep_vals)
if (length(sigs_x)>0){
  text(x=sigs_x, y=1.1*max(totest, na.rm=T), sigs_text, cex=2)
}

dev.off()
}


format_p <- function(p, digits = 2) {
  formatC(signif(p, digits), format = "fg", digits = digits)
}
if (ref_sim %in% c('no_virus', 'no_virus_shunt','no_virus_shunt_all')){
pdf(paste('chlorophyll_correlations_', sca,'_',type,'_depth',de,'_', region,'_ref-',ref_sim ,'.pdf',sep=''))
for (suff in suffixes[1:ns]){
	chl=as.vector(data_to_plot[[suff]][['chl']])
	keep <- !is.na(idx_closest)

	chl_use     <- chl[keep]
	chl_cop_use <- chl_cop[idx_closest[keep]]

	co=cor.test(chl_cop_use, chl_use)
	p_val=co$p.value
	correl=co$estimate
	sel=!is.na(chl_cop_use) & !is.na(chl_use)
	rmse=sqrt(mean((chl_cop_use[sel] - chl_use[sel])^2))
	plot(chl_cop_use, chl_use, col='grey', pch=19, xlab='Data (Copernicus)', ylab='Model', ylim=c(0, 0.156),xlim=c(0, 0.1),main=paste(suff,' , cor=',round(correl,2),
													  ', p-val=',signif(p_val,2),', rmse=',signif(rmse, 2), sep=''))
	abline(a = 0, b = 1, lwd=2)
}
dev.off()
}


if (ref_sim %in% c('no_virus_shunt', 'no_virus_shunt_all')){
  areas_dec=NULL
  areas_inc=NULL
  areas_dec_5=NULL
  areas_inc_5=NULL
  NPP_change=NULL
  NPP_change_inc=NULL
  NPP_change_dec=NULL
  ref_npp=as.vector(data_to_plot[[suff_ref]][['NPP']])
  ref_npp=ref_npp[abs(lat_vec)<40]
  cell_area_40=cell_area[abs(lat_vec)<40]
  prod_ref=sum(cell_area_40*1e6*ref_npp, na.rm = TRUE)
  for (suff in suffixes[1:(ns-1)]){
    npp_exp=as.vector(data_to_plot[[suff]][['NPP']])
    npp_exp=npp_exp[abs(lat_vec)<40]
    
    dnpp=(npp_exp-ref_npp)*100/ref_npp
    
    #dnpp_p=(npp_exp[dnpp>0]-ref_npp[dnpp>0])*100/ref_npp[dnpp>0]
    #dnpp_n=(npp_exp[dnpp<0]-ref_npp[dnpp<0])*100/ref_npp[dnpp<0]

    prod_exp=sum(cell_area_40*1e6*npp_exp, na.rm = TRUE)
    dprod=(prod_exp-prod_ref)*100/prod_ref
    NPP_change=c(NPP_change, dprod)
    
    prod_exp_p=sum(cell_area_40[dnpp>0]*1e6*npp_exp[dnpp>0], na.rm = TRUE)
    prod_ref_p=sum(cell_area_40[dnpp>0]*1e6*ref_npp[dnpp>0], na.rm = TRUE)
    dprod_p=(prod_exp_p-prod_ref_p)*100/prod_ref_p
    NPP_change_inc=c(NPP_change_inc, dprod_p)

    prod_exp_n=sum(cell_area_40[dnpp<0]*1e6*npp_exp[dnpp<0], na.rm = TRUE)
    prod_ref_n=sum(cell_area_40[dnpp<0]*1e6*ref_npp[dnpp<0], na.rm = TRUE)
    dprod_n=(prod_exp_n-prod_ref_n)*100/prod_ref_n
    NPP_change_dec=c(NPP_change_dec, dprod_n)

    area_dec=sum(cell_area_40[dnpp<0], na.rm=T)
    area_inc=sum(cell_area_40[dnpp>0], na.rm=T)
    area_dec_5=sum(cell_area_40[dnpp < -5], na.rm=T)
    area_inc_5=sum(cell_area_40[dnpp > 5], na.rm=T)
    
    areas_dec=c(areas_dec, area_dec)
    areas_inc=c(areas_inc, area_inc)
    areas_dec_5=c(areas_dec_5, area_dec_5)
    areas_inc_5=c(areas_inc_5, area_inc_5)
  }
  area_40=sum(cell_area_40[!is.na(dnpp)])
  area_40_perc=area_40*100/tot_surf_ocean
  print(area_40_perc)
  pdf(paste('npp_plot_stats_',ref_sim,'.pdf', sep=''), width = wd, height = hg)
  if (ref_sim=='no_virus_shunt'){
    shunts=c(0, 25, 50, 75, 100)
  } else{
    shunts=c(0, 25, 50, 60,75, 90,100)
  }
  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(-1.05*area_40_perc, 1.05*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='lightblue')
  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='lightblue')
  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='lightpink1')
  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='lightpink1')
  points(shunts,areas_dec_5*100/tot_surf_ocean, cex=3, col='blue', pch=17)
  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
  points(shunts,areas_inc_5*100/tot_surf_ocean, cex=3, col='red', pch=15)
  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
  points(shunts, NPP_change, cex=3, pch=18)
  lines(shunts, NPP_change, lty=1, lwd=2)
  abline(h=0)
  abline(h=area_40_perc, lty=2)
#  abline(h=-area_40_perc, lty=2)

  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(-1.1*max(abs(NPP_change)), 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='lightblue')
  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='lightblue')
  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='lightpink1')
  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='lightpink1')
  points(shunts,areas_dec_5*100/tot_surf_ocean, cex=3, col='blue', pch=17)
  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
  points(shunts,areas_inc_5*100/tot_surf_ocean, cex=3, col='red', pch=15)
  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
  points(shunts, NPP_change, cex=3, pch=18)
  lines(shunts, NPP_change, lty=1, lwd=2)
  abline(h=0)
  abline(h=area_40_perc, lty=2)

  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(-1.1*max(abs(NPP_change)), 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='blue')
  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='red')
  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='red')
  points(shunts, NPP_change_dec, cex=3, pch=2, col='blue')
  lines(shunts, NPP_change_dec, lty=1, lwd=2, col='blue')
  points(shunts, NPP_change_inc, cex=3, pch=0, col='red')
  lines(shunts, NPP_change_inc, lty=1, lwd=2, col='red')
  points(shunts, NPP_change, cex=3, pch=5)
  lines(shunts, NPP_change, lty=1, lwd=2)
  abline(h=0)
  abline(h=area_40_perc, lty=2)

  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(0, 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='lightblue')
  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='lightblue')
  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='lightpink1')
  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='lightpink1')
  points(shunts,areas_dec_5*100/tot_surf_ocean, cex=3, col='blue', pch=17)
  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
  points(shunts,areas_inc_5*100/tot_surf_ocean, cex=3, col='red', pch=15)
  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
  abline(h=area_40_perc, lty=2)

  plot(shunts, areas_dec*100/tot_surf_ocean, ylim=c(0, 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='blue')
  lines(shunts, areas_dec*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
  points(shunts, areas_inc*100/tot_surf_ocean, cex=3, pch=15, col='red')
  lines(shunts, areas_inc*100/tot_surf_ocean, lty=1, lwd=2, col='red')
  abline(h=area_40_perc, lty=2)

  plot(shunts, areas_dec_5*100/tot_surf_ocean, ylim=c(0, 1.1*area_40_perc), ylab='%', xlab='shunt', cex=3, pch=17, col='blue')
  lines(shunts, areas_dec_5*100/tot_surf_ocean, lty=1, lwd=2, col='blue')
  points(shunts, areas_inc_5*100/tot_surf_ocean, cex=3, pch=15, col='red')
  lines(shunts, areas_inc_5*100/tot_surf_ocean, lty=1, lwd=2, col='red')
  abline(h=area_40_perc, lty=2)

  plot(shunts, NPP_change, cex=3, pch=18, ylim=c( -1.05*max(abs(NPP_change)), 1.05*max(abs(NPP_change)) ) , ylab='%')
  lines(shunts, NPP_change, lty=1, lwd=2)
  abline(h=0)

  plot(shunts[NPP_change_dec!=0], NPP_change_dec[NPP_change_dec!=0], cex=3, pch=17,  col='blue',ylim=c( -1.05*max(abs(c(NPP_change, NPP_change_inc, NPP_change_dec))), 1.05*max(abs(c(NPP_change, NPP_change_inc, NPP_change_dec))) ) , ylab='%')
  lines(shunts[NPP_change_dec!=0], NPP_change_dec[NPP_change_dec!=0], lty=1, lwd=2,  col='blue')
  points(shunts[NPP_change_inc!=0], NPP_change_inc[NPP_change_inc!=0], col='red', pch=15, cex=3)
  lines(shunts[NPP_change_inc!=0], NPP_change_inc[NPP_change_inc!=0],lty=1, lwd=2, col='red')
  points(shunts, NPP_change, col='black', pch=18, cex=3)
  lines(shunts, NPP_change,lty=1, lwd=2, col='black')
  abline(h=0)
  
  
  dev.off()


}
#if (depth=='int'){
#        if (region=='world'){
#                pdf(paste('3D_darwin_maps_comparisons_deltas1_bis_',sca,'_',type,'.pdf', sep=''), width = wd, height = hg)
#        } else{
#                pdf(paste('3D_darwin_maps_comparisons_deltas1_bis_',sca,'_',type,'_', region,'.pdf', sep=''), width=10, height=10)
#        }
#} else{
#        if (region=='world'){
#                pdf(paste('3D_darwin_maps_comparisons_deltas1_bis_',sca,'_',type,'_depth',de,'.pdf', sep=''), width = wd, height = hg)
#        } else{
#                pdf(paste('3D_darwin_maps_comparisons_deltas1_bis_',sca,'_',type,'_depth',de,'_', region,'.pdf', sep=''), width = wd, height = hg)
#        }
#}

#n_suff=length(suffixes)-1
#suff_ref=suffixes[n_suff]
#colos=colorRampPalette(c("blue", "white", "red"))(100)
#for (n in names_tracers[ c(1:2,5, 9,10, 11,12, 14, 21, 33, 34)]){
#        mins=NULL
#        maxs=NULL
#        for (suff in suffixes[1:(n_suff-1)]){
#		if (!grepl('%', n) & !grepl('log', n)){
#			if (sca=='0'){	
#                		delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])*100/data_to_plot[[suff_ref]][[n]]
#			} else{
#				delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
#			}
#		} else{
#			delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
#		}
#		mins=c(mins, min(delta[delta!=-Inf & delta!=Inf], na.rm=T))
#                maxs=c(maxs, max(delta[delta!=-Inf & delta!=Inf], na.rm=T))
#		print(suff)
#		print(sum(delta==Inf, na.rm=T))
#		print(sum(delta==-Inf, na.rm=T))
#
#
#        }
#        print(n)
#        print(mins)
#        print(maxs)
#        mx_ab1=max(abs(c(mins[mins!=-Inf & mins!=Inf], maxs[maxs!=-Inf & maxs!=Inf])), na.rm=T)
#	
#	if (sca=='log10' & !grepl('%', n) & !grepl('log', n)){
#                lim_max=2
#        } else if (sca=='0' & !grepl('%', n) & !grepl('log', n)){
#                lim_max=200
#        } else{
#                lim_max=10^300
#        }


	
#	mx_ab=mx_ab1
#        if (mx_ab>lim_max){
#                mx_ab=lim_max
#        }
#        zlim=c(-mx_ab, mx_ab)
#
#        for (suff in suffixes[1:(n_suff-1)]){
#		if (!grepl('%', n) & !grepl('log', n)){
#			if (sca=='0'){
#                                delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])*100/data_to_plot[[suff_ref]][[n]]
#			} else{
#                                delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
#                        }
#		} else{
#			delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
#		}
#		if (mx_ab==lim_max){
#                        delta[delta>lim_max]=lim_max
#			delta[delta< -lim_max]= -lim_max
#                }
#                template_map(min_lo, max_lo, min_lt, max_lt)
#                #maps::map("world2",, col = "black", lwd = 0.7,xlim = c(-20, 360), ylim = c(-85, 80), fill=T,interior = FALSE, main=n)
#
#                # overlay the raster
#                #print(zlim)
#                image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta,add = TRUE, useRaster = TRUE, col = colos, zlim = zlim, main=paste('delta ', n, sep=''))
#                axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
#                        if (region=='aloha'){
#                        lon_g=202.5
#                        lat_g=24.5
#                        star(lon_g,lat_g, r=0.5, col="dodgerblue")
#                }
#                if( region=='gradients'){
#                        lon_g=202 #360-158 (lon of gradients)
#                        lats_g=seq(23.5, 43.5, 1)
#                        lon_g_ind=which.min(abs(lon-lon_g))
#                        lats_g_ind=sapply(lats_g, function(x, lt){which.min(abs(x-lt))}, lt=lat)
#                        points(rep(lon_g_ind,length(lats_g_ind)) ,lats_g , pch=19, type='l', lwd=3)
#                }
#
#        }
#
#        t1_min=-mx_ab
#        t1_max=mx_ab
#        # 2️⃣ Position of the legend
#        legend_x <- 1       # x-position (right of map)
#
         # 3️⃣ Draw the gradient as tiny rectangles
        # Draw gradient as stacked rectangles
#        plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',
#                 xlab='', ylab='', bty='n')
#
#        text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
#        for (i in 1:length(colos)){
#                rect(xleft = legend_x, xright = legend_x + 10,
#                ybottom = i,
#                ytop    = i+1,
#                col     = colos[i], border = NA)
#        }
        #if (n %in% c('%Inf', '%Vmort')){
        #        text(x=legend_x+12, y=i+1, labels = 100)
        #} else{
#        text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
#        #}
#        text(x=legend_x,y=i+3, labels=paste('delta ', n, sep='') )
	
#	print(mx_ab1)
#        if (mx_ab1>200){
#                ceil_to_power_of_10 <- function(x) {
#                        if (any(x <= 0)) stop("x must be positive")
#                                ceiling(log10(x))
#                }

#                zlim=c(log10(1), log10(mx_ab1))
#                print(zlim)
#                for (suff in suffixes[1:(n_suff-1)]){
#			if (!grepl('%', n) & !grepl('log', n)){
#				if (sca=='0'){
#                                	delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])*100/data_to_plot[[suff_ref]][[n]]
#				} else{
#                                	delta=log10(data_to_plot[[suff]][[n]]/data_to_plot[[suff_ref]][[n]])
#                        	}
#          
#			} else{
#				delta=(data_to_plot[[suff]][[n]]-data_to_plot[[suff_ref]][[n]])
#			}
#			delta1=delta
#                        delta1[delta<0]=NA
#                        delta1[delta1<1]=1
#                        delta1=log10(delta1)
#                        template_map(min_lo, max_lo, min_lt, max_lt)
#                        image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta1,add = TRUE, useRaster = TRUE, col = colos[51:100], zlim = zlim, main=paste('delta ', n, sep=''))

#                        delta2=delta
#                        delta2[delta>0]=NA
#                        delta2[delta2>-1]=-1
#                        delta2=log10(abs(delta2))
#                        image(lon[i1_lo:i2_lo], lat[i1_lt:i2_lt], delta2,add = TRUE, useRaster = TRUE, col = colos[50:1], zlim = zlim, main=paste('delta ', n, sep=''))
#                        axis_map(min_lo, max_lo, min_lt, max_lt, step_lo, step_lt)
#                        if (region=='aloha'){
#                                lon_g=202.5
#                                lat_g=24.5
#                                star(lon_g,lat_g, r=0.5, col="dodgerblue")
#                        }
#                        if( region=='gradients'){
#                                lon_g=202 #360-158 (lon of gradients)
#                                lats_g=seq(23.5, 43.5, 1)
#                                lon_g_ind=which.min(abs(lon-lon_g))
#                                lats_g_ind=sapply(lats_g, function(x, lt){which.min(abs(x-lt))}, lt=lat)
#                                points(rep(lon_g_ind,length(lats_g_ind)) ,lats_g , pch=19, type='l', lwd=3)
#                        }
#                }
#
#                t1_min=-mx_ab1
#                t1_max=mx_ab1
#                legend_x <- 1       # x-position (right of map)

                # 3️⃣ Draw the gradient as tiny rectangles
                # Draw gradient as stacked rectangles
#                plot(0,0, xlim=c(0, 60), ylim=c(0, 105), col='white', yaxt='n', xaxt='n',xlab='', ylab='', bty='n')
#
#                text(x=legend_x+12, y=0, labels = signif(t1_min, 2))
#                for (i in 1:length(colos)){
#                        rect(xleft = legend_x, xright = legend_x + 10,
#                        ybottom = i,
#                        ytop    = i+1,
#                        col     = colos[i], border = NA)
#                }
#                text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
#                #}
#                text(x=legend_x,y=i+3, labels=paste('delta ', n, sep='') )
#                text(x=legend_x+12, y=50, labels = 0)
#                mx_pow=ceil_to_power_of_10(mx_ab1)-1
#                dec_1=1
#                for (j in 1:mx_pow){
#                        text(x=legend_x+12, y=50+50*j/log10(mx_ab1), labels = dec_1*10^j)
#                        text(x=legend_x+12, y=50-50*j/log10(mx_ab1), labels = -dec_1*10^j)
#                }
#        }

#}
#dev.off()



