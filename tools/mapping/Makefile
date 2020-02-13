include include/Defaults.env
include include/Variables.env

define \n


endef

define check_prereqs
	@$(foreach DEP,$(1),\
	ifeq ("$(wildcard $(DEP))","")\
	$(error ${\n}Pre-requisite $(DEP) not found. ${\n}${\n}\
	Try adding the file: ${\n}\
	$(notdir $(DEP)) to $(dir $(DEP))${\n}))
endef

define setup
	mkdir -p ${log_folder}
	mkdir -p ${output_folder}
endef

define banner
    printf "\n"
    printf '### $(1) ###\n'
endef

TARGETS = $(STEP_1_TARGETS) $(STEP_2_TARGETS) $(STEP_3_TARGETS) $(STEP_4_TARGETS) $(STEP_5_TARGETS)

all : $(TARGETS) cleanup

$(STEP_1_PREREQS): 
	$(call check_prereqs,$(STEP_1_DEPS))

# TODO: Find a way to generate and link config.csh on each run.
$(STEP_1_TARGETS): $(STEP_1_DEPS) 
	@$(call banner,Step One!)
	@echo "TODO: add a way to verify nx, ny were read correctly."
	$(call setup)
	cd ${gen_mapping_files} && \
	csh ${gen_mapping_files}/mk_SCRIPgridplio_enh.csh 2>&1 | tee ${log_folder}/${log_file1}
	cp ${gen_mapping_files}/gx1v6plioenh_$(DATE).nc ${output_folder}
	@$(call banner,Done.)

$(STEP_2_TARGETS): $(STEP_2_DEPS) $(STEP_1_TARGETS) 
	@$(call banner,Step Two!)
	$(call setup)
	cp $(STEP_1_TARGETS) ${gen_mapping_files}
	@${gen_mapping_files}/gen_cesm_maps.sh  \
		-fatm /glade/p/cesm/cseg/mapping/grids/fv0.9x1.25_070727.nc  \
		-natm fv09_1.25  \
		-focn ${mapping}/gen_mapping_files/gx1v6plioenh_${DATE}.nc  \
		-nocn gx1v6plioenh  \
		--nogridcheck 2>&1 | tee ${log_folder}/${log_file2}
	cp -v $(notdir $(STEP_2_TARGETS)) ${output_folder}
	#rm ${gen_mapping_files}/gx1v6plioenh_$(DATE).nc
	@echo $(notdir $(STEP_2_TARGETS)) ${output_folder}
	@$(call banner,Done.)

$(STEP_3_TARGETS): $(STEP_2_TARGETS)
	@$(call banner,Step Three!)
	$(call setup)
	@${mapping}/gen_domain_files/gen_domain  \
		-m ${output_folder}/map_gx1v6plioenh_TO_fv09_1.25_aave.${DATE}.nc  \
		-o gx1v6plioenh  \
		-l fv1.9_2.5  \
		-c plioenh  \
		-p 2 2>&1 | tee ${log_folder}/${log_file3}
	cp $(notdir $(STEP_3_TARGETS)) ${output_folder}
	@$(call banner,Done.)

.ONESHELL:
$(STEP_4_TARGETS): $(STEP_3_TARGETS)
	@$(call banner,Step Four!)
	cp -v $(STEP_3_TARGETS) ${gen_domain_files}
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
	cd ${runoff_to_ocn}
	@${runoff_to_ocn}/runoff_map < ${runoff_to_ocn}/runoff_map.nml 2>&1 | tee ${log_folder}/${log_file4}
	cp $(notdir $(STEP_4_TARGETS)) ${output_folder}
	@$(call banner,Done.)

$(STEP_5_TARGETS): $(STEP_4_TARGETS)
	@$(call banner,Step Five!)
	@${mapping}/gen_mapping_files/gen_ESMF_mapping_file/create_ESMF_map.sh \
		-fsrc /glade/p/cesm/cseg/mapping/grids/r05_nomask_070925.nc  \
		-nsrc r05_nomask  \
		-fdst ../gx1v6plioenh_${DATE}.nc  \
		-ndst gx1v6plioenh  \
		-map aave 2>&1 | tee ${log_folder}/${log_file5}
	@$(call banner,Done.)

clean-interactive:
	@$(call banner,Cleaning...)
	rm -irv ${output_folder}
	rm -irv ${log_folder}
	@$(call banner,Done.)

clean:
	@$(call banner,Cleaning...)
	rm -rfv ${output_folder}
	rm -rfv ${log_folder}
	@$(call banner,Done.)

cleanup:
	@$(call banner,Cleaning copied files...)
	rm -v $(notdir $(TARGETS))
	@$(call banner,Done.)

#TODO: test
.PHONY : all clean clean-interactive cleanup test setup
