$(eval DATE := $(shell date +%y%m%d))
cesm_root=/glade/u/home/chrgeiger/cesm1_2_0
mapping=${cesm_root}/tools/mapping
gen_mapping_files=${mapping}/gen_mapping_files
gen_domain_files=${mapping}/gen_domain_files
runoff_to_ocn=${gen_mapping_files}/runoff_to_ocn

output_folder=$(PWD)/outputs
log_folder=$(PWD)/logs
log_file1=log_file_1.txt
log_file2=log_file_2.txt
log_file3=log_file_3.txt
log_file4=log_file_4.txt
log_file5=log_file_5.txt

export ESMFBIN_PATH=/glade/u/apps/ch/opt/esmf/7.0.0-ncdfio/intel/17.0.1/bin/binO/Linux.intel.64.mpiuni.default
export ESMFBINDIR=/glade/u/apps/ch/opt/esmf/7.0.0-ncdfio/intel/17.0.1/bin/binO/Linux.intel.64.mpiuni.default

# Pre-requisites (prereqs) are required to exist before this Makefile is run. Each prereq is also a dependency.
# === STEP 1 Dependencies & Targets ===
STEP_1_PREREQS = ${gen_mapping_files}/horiz_grid_plioenh_070820.ieeer8
STEP_1_PREREQS += ${gen_mapping_files}/fv0.9x1.25_070727.nc
STEP_1_PREREQS += ${gen_mapping_files}/topography_plio_enh_gx1v6_190619.CESM2_modMed.ieeei4

STEP_1_DEPS = $(STEP_1_PREREQS)

STEP_1_TARGETS = ${output_folder}/gx1v6plioenh_$(DATE).nc

# === STEP 2 Dependencies & Targets ===
STEP_2_PREREQS = ${gen_mapping_files}/gen_cesm_maps.sh
STEP_2_PREREQS += /glade/p/cesm/cseg/mapping/grids/fv0.9x1.25_070727.nc
STEP_2_DEPS = ${output_folder}/gx1v6plioenh_${DATE}.nc
STEP_2_DEPS += ${gen_mapping_files}/gen_cesm_maps.sh

STEP_2_TARGETS  = ${output_folder}/map_fv09_1.25_TO_gx1v6plioenh_aave.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_fv09_1.25_TO_gx1v6plioenh_blin.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_fv09_1.25_TO_gx1v6plioenh_patc.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_gx1v6plioenh_TO_fv09_1.25_aave.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_gx1v6plioenh_TO_fv09_1.25_blin.$(DATE).nc

# === STEP 3 Dependencies & Targets ===
STEP_3_DEPS = $(STEP_2_TARGETS)

STEP_3_TARGETS  = ${output_folder}/domain.ocn.gx1v6plioenh.$(DATE).nc
STEP_3_TARGETS += ${output_folder}/domain.lnd.fv1.9_2.5_gx1v6plioenh.$(DATE).nc
STEP_3_TARGETS += ${output_folder}/domain.ocn.fv1.9_2.5_gx1v6plioenh.$(DATE).nc

# === STEP 4 Dependencies & Targets ===
STEP_4_DEPS = $(STEP_3_TARGETS)

STEP_4_TARGETS  = ${output_folder}/map_r05_to_gx1v6plioenh_nn_$(DATE).nc
STEP_4_TARGETS += ${output_folder}/map_gx1v6_to_gx1v6plioenh_sm_e1000r300_$(DATE).nc
STEP_4_TARGETS += ${output_folder}/map_r05_to_gx1v6plioenh_nnsm_e1000r300_$(DATE).nc

# === STEP 5 Dependencies & Targets ===
STEP_5_DEPS = $(STEP_4_TARGETS)

STEP_5_TARGETS  = ${output_folder}/map_r05_nomask_TO_gx1v6plioenh_aave.$(DATE).nc 

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
	csh ${gen_mapping_files}/mk_SCRIPgridplio_enh.csh 2>&1 ${log_folder}/${log_file1}
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
