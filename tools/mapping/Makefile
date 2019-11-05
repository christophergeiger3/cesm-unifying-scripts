TARGETS=step1 step2 step3 step4 step5
DATE=$(date +%y%m%d)
cesm_root=/glade/u/home/chrgeiger/cesm1_2_0
mapping=${cesm_root}/tools/mapping
runoff_to_ocn=${mapping}/gen_mapping_files/runoff_to_ocn

log_file1=log_file_1.txt
log_file2=log_file_2.txt
log_file3=log_file_3.txt
log_file4=log_file_4.txt
log_file5=log_file_5.txt

export ESMFBIN_PATH=/glade/u/apps/ch/opt/esmf/7.0.0-ncdfio/intel/17.0.1/bin/binO/Linux.intel.64.mpiuni.default
export ESMFBINDIR=/glade/u/apps/ch/opt/esmf/7.0.0-ncdfio/intel/17.0.1/bin/binO/Linux.intel.64.mpiuni.default

# all : $(TARGETS)

TARGET_DEPS := targetA targetB
TARGET_DEPS += targetC
TARGET_DEPS += targetD

STEP_1_DEPS := ${mapping_dir}/gen_mapping_files/horiz_grid_wais_070820.ieeer8
STEP_1_DEPS += target

step1: gx1v6plioenh_${DATE}.nc: $(STEP_1_DEPS)
	@echo "step1"
	@echo "TODO: add a way to tweak values in the csh script"
	@echo "TODO: add Make dependencies"
	@echo "TODO: add Make output files"
	@cd ${mapping}/gen_mapping_files && \
	csh ${mapping}/gen_mapping_files/mk_SCRIPgridplio_enh.csh &> ${log_file1}

step2:
	@echo "step2"
	@${mapping}/gen_mapping_files/gen_cesm_maps.sh  \
		-fatm /glade/p/cesm/cseg/mapping/grids/fv0.9x1.25_070727.nc  \
		-natm fv09_1.25  \
		-focn ${mapping}/gen_mapping_files/gx1v6plioenh_${DATE}.nc  \
		-nocn gx1v6plioenh  \
		--nogridcheck &> ${log_file2}
	@echo "done!"

step3:
	@echo "step3"
	@${mapping}/gen_domain_files/gen_domain  \
		-m ../gen_mapping_files/map_gx1v6plioenh_TO_fv09_1.25_aave.${DATE}.nc  \
		-o gx1v6plioenh  \
		-l fv1.9_2.5  \
		-c plioenh  \
		-p 2 &> ${log_file3}
	@echo "done!"

step4:
	@echo "step4"
	@cat > ${runoff_to_ocn}/runoff_map_r05_gx1v6_plioenh.nml << EOF
	  &input_nml
	   gridtype     = 'rtm'
	   file_roff    = '/glade/p/cesm/cseg/inputdata/lnd/clm2/rtmdata/rdirc.05.061026'
	   file_ocn     = '../gx1v6plioenh_${DATE}.nc'
	   file_nn      = 'map_r05_to_gx1v6plioenh_nn_${DATE}.nc '
	   file_smooth  = 'map_gx1v6_to_gx1v6plioenh_sm_e1000r300_${DATE}.nc '
	   file_new     = 'map_r05_to_gx1v6plioenh_nnsm_e1000r300_${DATE}.nc'
	   title        = 'runoff map: r05 -> gx1v6, nearest neighbor and smoothed '
	   eFold        = 1000000.0
	   rMax         =  300000.0
	   step1 = .true.
	   step2 = .true.
	   step3 = .true.
	  /
	EOF
	@ln -s ${runoff_to_ocn}/runoff_map_r05_gx1v6_plioenh.nml ${runoff_to_ocn}/runoff_map.nml
	@${runoff_to_ocn}/runoff_map < ${runoff_to_ocn}/runoff_map.nml &> ${log_file4}
	@echo "done!"

step5:
	@echo "step5"
	@${mapping}/gen_mapping_files/gen_ESMF_mapping_file/create_ESMF_map.sh \
		-fsrc /glade/p/cesm/cseg/mapping/grids/r05_nomask_070925.nc  \
		-nsrc r05_nomask  \
		-fdst ../gx1v6plioenh_${DATE}.nc  \
		-ndst gx1v6plioenh  \
		-map aave &> ${log_file5}
	@echo "done!"


.PHONY : all clean
