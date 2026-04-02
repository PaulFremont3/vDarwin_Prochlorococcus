library('viridis')
library('matlab')
library('RColorBrewer')
library('pals')
source('functions_map.R')

# note that this script allows for purely longitudinal or latitudinal transect (either lat1==lat0 or lon1==lon0)
sca=commandArgs(trailingOnly=T)[1] # scale: 0 (linear) or log10 
type=commandArgs(trailingOnly=T)[2] # mol or ind
lat0=commandArgs(trailingOnly=T)[3] # bottom latitude
lat1=commandArgs(trailingOnly=T)[4] # top latitude
lon0=commandArgs(trailingOnly=T)[5] # left longitude 
lon1=commandArgs(trailingOnly=T)[6] # right longitude
name=commandArgs(trailingOnly=T)[7] # name for pdf outputs
save=commandArgs(trailingOnly=T)[8] # save or plot mode
ref_sim=commandArgs(trailingOnly=T)[9] # code name refering to the list of simulations being compared

lat0=as.numeric(lat0)
lat1=as.numeric(lat1)
lon0=as.numeric(lon0)
lon1=as.numeric(lon1)

# lon and lats
lon=readRDS('lon.rds')
lat=readRDS('lat.rds')

# find closest indices in the grid to the transect
i_lt0=which.min(abs(lat-lat0))
i_lt1=which.min(abs(lat-lat1))
i_lo0=which.min(abs(lon-lon0))
i_lo1=which.min(abs(lon-lon1))

# longitudinal or latidinal transects 
if (i_lt0==i_lt1){
	lons=lon[i_lo0:i_lo1]
	lats=rep(lat[i_lt0], length(lons))
} else{
	lats=lat[i_lt0:i_lt1]
	lons=rep(lon[i_lo0], length(lats))
}


# depth
depths=readRDS('depths.rds')
depths_u=readRDS('depths_u.rds')
depths_l=readRDS('depths_l.rds')
dzs=depths_l-depths_u
dzs=as.numeric(dzs)

# transect position
pdf(paste('transect_position_',name,'.pdf', sep=''), width = 10, height = 6)
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

# list of simulation to be compared
if (ref_sim=='no_virus'){
        suffixes=c('virus_shunt-50','virus_shunt-60' ,'virus_shunt-75', 'virus_shunt-90', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V50','V60' ,'V75', 'V90', 'V100', 'NV')
} else if (ref_sim=='virus'){
        suffixes=c('virus_shunt-50', 'virus_shunt-60','virus_shunt-75', 'virus_shunt-90', 'virus_shunt-100')
        suffixes_bis=c('V50','V60' ,'V75', 'V90', 'V100')
} else if (ref_sim=='virus_shunt'){
        suffixes=c('virus_shunt-0','virus_shunt-25','virus_shunt-50', 'virus_shunt-75',  'virus_shunt-100')
        suffixes_bis=c('V0','V25','V50', 'V75', 'V100')
} else if (ref_sim=='no_virus_shunt'){
        suffixes=c('virus_shunt-0', 'virus_shunt-50', 'virus_shunt-75', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V0', 'V50', 'V75', 'V100', 'NV')
} else if (ref_sim=='virus_virulence'){
        suffixes=c('virus_low_phi', 'virus_high_phi', 'virus_shunt-100')
        suffixes_bis=c('V.phi/1.5', 'V.1.5phi', 'V')
} else if (ref_sim=='no_virus_virulence'){
        suffixes=c('virus_low_phi', 'virus_high_phi', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V.phi/1.5', 'V.1.5phi', 'V', 'NV')
} else if (ref_sim=='virus_misc'){
        suffixes=c('virus_shunt-100_no_I', 'virus_shunt-100_I_growth','virus_shunt-100_no_DON_transport', 'virus_shunt-100')
        suffixes_bis=c('V_noI','V_IG', 'V_NDT', 'V')
} else if (ref_sim=='no_virus_misc'){
        suffixes=c('virus_shunt-100_no_I', 'virus_shunt-100_I_growth','virus_shunt-100_no_DON_transport', 'virus_shunt-100', 'no_virus')
        suffixes_bis=c('V_noI','V_IG', 'V_NDT', 'V', 'NV')
} else if (ref_sim=='no_virus_lrm'){
        suffixes=c('virus_shunt-50_lrm','virus_shunt-60_lrm' ,'virus_shunt-75_lrm', 'virus_shunt-90_lrm','virus_shunt-100_lrm','no_virus_lrm')
        suffixes_bis=c('V50','V60' ,'V75', 'V90','V100', 'NV')
}

# tracers to be plotted
names_tracers=c('Total_P','Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus', '%Inf', '%Vmort', "%Zmort", '%Omort',
                'GR_S', 'NPP', 'DIC', 'NO3', 'NO2', 'NH4', 'PO4', 'FeT', 'SiO2', 'DOC', 'DON', 'DOP', 'DOFe', 'POC',
                'PON', 'POP', 'POFe', 'POSi', 'PIC', 'Alk', 'O2', 'CDOM', 'log10_DON_NO3', 'log10_DON_DIN','VL', 'GR_I', 'TDN', 'chl', 'C/chl', 'Mort_S', 'Mort_I', 'Mort', 'LR_Z', 'LR_V', 'LR_O', 'GR', 'DIN')


# Quotas
ns=length(suffixes)
Qvs=rep(4.18214600e-15*1000,ns)
Qps=rep(4.04125e-12, ns)*1000
Qzs=rep(1.06e-09, ns)*1000


Qs=rep(list(rep(list(NULL), length(names_tracers))), length(suffixes))

# read data in save mode
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
# only quotas in plot mode
} else{
  co=1
  for (suff in suffixes){
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

# initiate data
data_to_plot=rep(list(rep(list(NULL), length(names_tracers))), length(suffixes))
mins=rep(list(NULL), length(names_tracers))
maxs=rep(list(NULL), length(names_tracers))
names(data_to_plot)=suffixes
names(maxs)=names_tracers
names(mins)=names_tracers
for (suff in suffixes){
        names(data_to_plot[[suff]])=names_tracers
}

# variables to be plotted in log10 
log10_vars=c('Total_P','Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus', 'NPP', 'GR_S', 'GR_I', 'VL', 'TDN', 'Mort_S', 'Mort_I', 'Mort', 'LR_Z', 'LR_V', 'LR_O', 'GR', 'DIN', 'chl', 'NO3')
# compute year average and range in save mode
if (save=='1'){
  for (n in names_tracers){
          print(n)
          for (suff in suffixes){
                  print(suff)
                  data_list=datas[[suff]]
                  t1=data_list[[n]]
                  if (type=='ind' & n %in% c('Total_P','Susceptible', 'Infected','Resistant',  'Zooplankton',  'Virus')){
                          t1=t1/Qs[[suff]][[n]]
                  }
		  		  t1=apply(t1[i_lo0:i_lo1,i_lt0:i_lt1,1:9,1:12], c(1,2), function(x) {mean(x, na.rm=T)}) # year average
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
  for (suff in suffixes){
    saveRDS(data_to_plot[[suff]], paste('data_',name,'_darwin_10th_year_average_',sca, '_', type,'_', suff, '.rds', sep=''))
  }
  saveRDS(list(mins, maxs), paste('mins_maxs_depth-' ,name,'_',sca, '_', type,'_', ref_sim, '.rds', sep=''))
# read data in plot mode
} else {
  for (suff in suffixes){
        list_to_read=readRDS(paste('data_',name,'_darwin_10th_year_average_',sca, '_', type,'_', suff, '.rds', sep=''))
        data_to_plot[[suff]]=list_to_read
        rm(list_to_read)
  }
  mins_maxs=readRDS(paste('mins_maxs_depth-' ,name,'_',sca, '_', type,'_', ref_sim, '.rds', sep=''))
  mins=mins_maxs[[1]]
  maxs=mins_maxs[[2]]
}

n_suff=length(suffixes)
suff_ref=suffixes[n_suff]
suff_ref_bis=suffixes_bis[n_suff]

# approx function to interpolate linearly between equidistant depths 
func_reg=function(row) {
                ok <- !is.na(row)
                if (sum(ok) < 2) {
                        return(rep(NA_real_, length(depth_reg)))
                } else{
                        return(approx(abs(depths[1:9][ok]), row[ok], depth_reg, rule = 1)$y)
                }
}

# list of vriables to plot depending on ref sim
if (startsWith(ref_sim, 'virus')){
  var_to_plot=c(1:3, 5:12, 14, 21, 33,34, 37:46, 47)
} else{
  var_to_plot=c(1:2, 5,9,10, 12, 14, 21, 33,34, 37:40, 42, 43, 45, 46, 47)
}

# plotting data
pdf(paste(name,'_darwin_maps_comparisons_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = 10, height = 6)
for (n in names_tracers[ var_to_plot]){
    mi=min(mins[[n]][mins[[n]]!=-Inf & mins[[n]]!=Inf], na.rm=T)
    mx=max(maxs[[n]], na.rm=T)
    print(n)
	# range and color palettes
    if (n %in% c('%Inf', '%Vmort','%Zmort',  '%Omort' )){
            zlim=c(0,100)
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
                    zlim <- c(0, mx)
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
                    colos=viridis::viridis(100,option='turbo' ,direction = -1)
                    lab='d-1'
            } else if (n %in% c('log10_DON_NO3', 'log10_DON_DIN')){
                    colos= colorRampPalette(rev(RColorBrewer::brewer.pal(11, "BrBG")))(100)
                    lab=''
            } else{
                    colos=hcl.colors(100, "YlOrRd", rev = TRUE)
                    lab='mmolC.m-3'
                    if (n=='chl'){
                            colos=parula(100)
                            lab='mgCHL.m-3'
                    }
                    if (n=='C/chl'){
                            lab='gC/gchl'
                            colos=jet.colors(100)
                }
            }
    }
	# transform data based on sca
    for (suff in suffixes){
        if (sca=='log10' & n %in% log10_vars){
            t=log10(data_to_plot[[suff]][[n]])
        } else{
            t=data_to_plot[[suff]][[n]]
        }
		# regularly spaced depth grid
        depth_reg <- seq(min(abs(depths[1:9])),
                 max(abs(depths[1:9])),
                 length.out = 20)
	# apply linear approx
	t_reg <- apply(t, 1, func_reg)	
	t_reg <- t(t_reg)
	t_plot <- t_reg[,ncol(t_reg):1]

	# plot data
	if (i_lt0!=i_lt1){
	  image(lat[i_lt0:i_lt1],depth_reg,t_plot,useRaster = TRUE, col = colos, zlim = zlim, main=paste(n,suff), ylab=NA, xlab=NA, axes=F)
	} else if (i_lo0!=i_lo1){
          image(lon[i_lo0:i_lo1],depth_reg,t_plot,useRaster = TRUE, col = colos, zlim = zlim, main=paste(n,suff), ylab=NA, xlab=NA, axes=F)
        }
	t_plot_na=t_plot
    t_plot_na[is.na(t_plot)]=1
    t_plot_na[!is.na(t_plot)]=NA
    if (i_lt0!=i_lt1){
        	image(lat[i_lt0:i_lt1],depth_reg,t_plot_na,add=T, useRaster = TRUE, col = "grey")
    } else if (i_lo0!=i_lo1){
        	image(lon[i_lo0:i_lo1],depth_reg,t_plot_na,add=T, useRaster = TRUE, col = "grey")
    }
	axis(1, lwd = 0, lwd.ticks = 3, cex.axis=2)
	axis(2, at = max(depth_reg)+min(depth_reg)-pretty(depth_reg),labels = pretty(depth_reg),lwd = 3, lwd.ticks = 3, cex.axis=2, las=1)
	box(lwd = 3)
	# simple nutricline (=1 mmol.m^-3 isoN)
    	if (n=='TDN' | n=='NO3' | n=='DIN'){
		cont=t_reg
		if (sca=='log10'){
			tr=log10(1)
		} else{
			tr=1
		}
        cont[t_reg>tr]=1
        cont[t_reg<tr]=0
        cont=cont[,ncol(t_reg):1]
        if (i_lt0!=i_lt1){
                contour(lat[i_lt0:i_lt1], depth_reg, cont, levels=c(0,1), add=T, labels=1, lwd=2)
        } else if (i_lo0!=i_lo1){
                contour(lon[i_lo0:i_lo1], depth_reg, cont, levels=c(0,1), add=T, labels=1, lwd=2)
        }
		if (sca=='log10' & n %in% log10_vars){
			t_ref=log10(data_to_plot[[suff_ref]][[n]])
		} else{
			t_ref=data_to_plot[[suff_ref]][[n]]
		}
            t_ref_reg=apply(t_ref, 1, func_reg)
            t_ref_reg=t(t_ref_reg)
			cont_ref=t_ref_reg
             cont_ref[t_ref_reg>tr]=1
            cont_ref[t_ref_reg<tr]=0
            cont_ref=cont_ref[,ncol(t_ref_reg):1]
            if (i_lt0!=i_lt1){
                    contour(lat[i_lt0:i_lt1], depth_reg, cont_ref, levels=c(0,1), add=T, labels=1, lwd=2, lty=2)
            } else if (i_lo0!=i_lo1){
                        contour(lon[i_lo0:i_lo1], depth_reg, cont_ref, levels=c(0,1), add=T, labels=1, lwd=2, lty=2)
            }

	}
	# DCM
	if (n=='chl'){
	  	dcm_idx <- apply(t_plot, 1, function(x) {a=which.max(x); if (length(a)==0){return(NA)}else{return(a)}})
		dcm_idx=unlist(dcm_idx)
		dcm_depth <- depth_reg[dcm_idx]
		print(dcm_depth)
		if (i_lt0!=i_lt1){
			lines(lat[i_lt0:i_lt1], dcm_depth, lwd = 2, col = "black")
		} else if (i_lo0!=i_lo1){
			lines(lon[i_lo0:i_lo1], dcm_depth, lwd = 2, col = "black")
		}
		if (sca=='log10' & n %in% log10_vars){
			t_ref=log10(data_to_plot[[suff_ref]][[n]])
		} else{
			t_ref=data_to_plot[[suff_ref]][[n]]
		}
		t_ref_reg=apply(t_ref, 1, func_reg)
		t_ref_reg=t(t_ref_reg)
		t_plot_ref=t_ref_reg[,ncol(t_ref_reg):1]
		dcm_idx_ref=apply(t_plot_ref, 1, function(x) {a=which.max(x); if (length(a)==0){return(NA)}else{return(a)}})
		dcm_depth_ref=depth_reg[dcm_idx_ref]
		
		if (i_lt0!=i_lt1){
                        lines(lat[i_lt0:i_lt1], dcm_depth_ref, lwd = 2, col = "black", lty=2)
                } else if (i_lo0!=i_lo1){
                        lines(lon[i_lo0:i_lo1], dcm_depth_ref, lwd = 2, col = "black", lty=2)
                }

	}
    }
	# legend
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
    make_ticks(maxs[[n]],  suffixes_bis, colos,n, t1_min, t1_max)

}            
dev.off()

# comparison plots to the reference simualtion
pdf(paste(name,'_darwin_maps_comparisons_delta_',sca,'_',type,'_ref-',ref_sim,'.pdf', sep=''), width = 10, height = 6)
n_suff=length(suffixes)
suff_ref=suffixes[n_suff]
suff_ref_bis=suffixes_bis[n_suff]
colos=colorRampPalette(c("blue", "white", "red"))(100)

for (n in names_tracers[var_to_plot ]){
        print(n)
		mins=NULL
        maxs=NULL
		# find range across simulations
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
                mins=c(mins, min(delta[delta!=-Inf & delta!=Inf], na.rm=T))
                maxs=c(maxs, max(delta[delta!=-Inf & delta!=Inf], na.rm=T))
        }
	mx_ab=max(abs(c(mins[mins!=-Inf & mins!=Inf], maxs[maxs!=-Inf & maxs!=Inf])), na.rm=T)
    print(mx_ab)
	mx_ab1=mx_ab
		# clipping
        if (sca=='log10' ){
                lim_max=2
        } else if (sca=='0'){
                lim_max=200
        }

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
                        }
                }
                if (mx_ab==lim_max){
                        delta[delta>=lim_max]=lim_max
                        delta[delta<= -lim_max]= -lim_max
                }
		delta_cont=delta
        delta_cont[delta>0]=1
        delta_cont[delta<0]=0
		# regulary sapced depth grid
		depth_reg <- seq(min(abs(depths[1:9])),
                 max(abs(depths[1:9])),
                 length.out = 20)
			# apply linear interpolation
        t_reg <- apply(delta, 1, function(row) {
                	ok <- !is.na(row)
                	if (sum(ok) < 2) {
                		return(rep(NA_real_, length(depth_reg)))
                	} else{	
  				return(approx(abs(depths[1:9][ok]), row[ok], depth_reg, rule = 1)$y)
		}
        })
        t_reg <- t(t_reg)
        t_plot <- t_reg[,ncol(t_reg):1]
		z_na=zlim[1] - 1
		# plotting data
		if (i_lt0!=i_lt1){
        		image(lat[i_lt0:i_lt1],depth_reg,t_plot,useRaster = TRUE, col = colos, zlim = zlim, main=paste(n,suff), ylab=NA, xlab=NA, axes=F)
		} else if (i_lo0!=i_lo1){
			image(lon[i_lo0:i_lo1],depth_reg,t_plot,useRaster = TRUE, col = colos, zlim = zlim, main=paste(n,suff), ylab=NA, xlab=NA, axes=F)
		}
		t_plot_na=t_plot
		t_plot_na[is.na(t_plot)]=1
		t_plot_na[!is.na(t_plot)]=NA
		if (i_lt0!=i_lt1){
			image(lat[i_lt0:i_lt1],depth_reg,t_plot_na,add=T, useRaster = TRUE, col = "grey")
		} else if (i_lo0!=i_lo1){
			image(lon[i_lo0:i_lo1],depth_reg,t_plot_na,add=T, useRaster = TRUE, col = "grey")
		}
		axis(1, lwd = 0, lwd.ticks = 3, cex.axis=2)
        	axis(2, at = max(depth_reg)+min(depth_reg)-pretty(depth_reg),labels = pretty(depth_reg),lwd = 3, lwd.ticks = 3, cex.axis=2, las=1)
        	box(lwd = 3)

		# contour of difference >0
		delta_cont=t_reg
        delta_cont[t_reg>0]=1
        delta_cont[t_reg<0]=0
		delta_cont=delta_cont[,ncol(t_reg):1]
		if (i_lt0!=i_lt1){
			contour(lat[i_lt0:i_lt1], depth_reg, delta_cont, levels=c(0,1), add=T, labels=0, lwd=2)
		} else if (i_lo0!=i_lo1){
			contour(lon[i_lo0:i_lo1], depth_reg, delta_cont, levels=c(0,1), add=T, labels=0, lwd=2)
		}
	}
	# legend
	t1_min=-mx_ab
    t1_max=mx_ab
    #2️⃣ Position of the legend
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
    text(x=legend_x+12, y=i+1, labels = signif(t1_max, 2))
    text(x=legend_x,y=i+3, labels=paste('delta ', n, sep='') )
}
dev.off()
