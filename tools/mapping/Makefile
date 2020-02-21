include include/Defaults.env
include include/Variables.env
include include/Functions.env
include include/Targets.env

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
	cp ${gen_mapping_files}/${prefix}_$(DATE).nc ${output_folder}
	@$(call banner,Done.)

$(STEP_2_TARGETS): $(STEP_2_DEPS) $(STEP_1_TARGETS) 
	@$(call banner,Step Two!)
	$(call setup)
	cp $(STEP_1_TARGETS) ${gen_mapping_files}
	@${gen_mapping_files}/gen_cesm_maps.sh  \
		-fatm ${fatm}  \
		-natm ${natm}  \
		-focn ${focn}  \
		-nocn ${nocn}  \
		--nogridcheck 2>&1 | tee ${log_folder}/${log_file2}
	cp -v $(notdir $(STEP_2_TARGETS)) ${output_folder}
	#rm ${gen_mapping_files}/gx1v6plioenh_$(DATE).nc
	@echo $(notdir $(STEP_2_TARGETS)) ${output_folder}
	@$(call banner,Done.)

$(STEP_3_TARGETS): $(STEP_2_TARGETS)
	@$(call banner,Step Three!)
	$(call setup)
	@${mapping}/gen_domain_files/gen_domain  \
		-m ${output_folder}/map_${prefix}_TO_${natm}_aave.${DATE}.nc  \
		-o ${prefix}  \
		-l ${natm}  \
		-c ${plio}  \
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
	   file_roff    = '${file_roff}'
	   file_ocn     = '../${prefix}_${DATE}.nc'
	   file_nn      = '${file_nn}'
	   file_smooth  = '${file_smooth}'
	   file_new     = '${file_new}'
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
		-fsrc ${fsrc}  \
		-nsrc ${nsrc}  \
		-fdst ../${prefix}_${DATE}.nc  \
		-ndst ${prefix}  \
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
