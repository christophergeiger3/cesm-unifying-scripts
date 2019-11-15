$(eval DATE := $(shell date +%y%m%d))
cesm_root=/glade/u/home/chrgeiger/cesm1_2_0
mapping=${cesm_root}/tools/mapping
gen_mapping_files=${mapping}/gen_mapping_files
runoff_to_ocn=${mapping}/gen_mapping_files/runoff_to_ocn

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
STEP_1_PREREQS = ${mapping}/gen_mapping_files/horiz_grid_plioenh_070820.ieeer8
STEP_1_PREREQS += ${mapping}/gen_mapping_files/fv0.9x1.25_070727.nc
STEP_1_PREREQS += ${mapping}/gen_mapping_files/topography_plio_enh_gx1v6_190619.CESM2_modMed.ieeei4

STEP_1_DEPS = $(STEP_1_PREREQS)

STEP_1_TARGETS = ${output_folder}/gx1v6plioenh_$(DATE).nc

# === STEP 2 Dependencies & Targets ===
STEP_2_PREREQS = ${gen_mapping_files}/gen_cesm_maps.sh
STEP_2_PREREQS += /glade/p/cesm/cseg/mapping/grids/fv0.9x1.25_070727.nc  # This is hardcoded, should change...
STEP_2_DEPS = ${output_folder}/gx1v6plioenh_${DATE}.nc
STEP_2_DEPS += ${gen_mapping_files}/gen_cesm_maps.sh

STEP_2_TARGETS  = ${output_folder}/map_fv09_1.25_TO_gx1v6plioenh_aave.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_fv09_1.25_TO_gx1v6plioenh_blin.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_fv09_1.25_TO_gx1v6plioenh_patc.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_gx1v6plioenh_TO_fv09_1.25_aave.$(DATE).nc
STEP_2_TARGETS += ${output_folder}/map_gx1v6plioenh_TO_fv09_1.25_blin.$(DATE).nc

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

TARGETS = $(STEP_1_TARGETS) $(STEP_2_TARGETS)

all : $(TARGETS)

$(STEP_1_PREREQS): 
	$(call check_prereqs,$(STEP_1_DEPS))

# TODO: Find a way to generate and link config.csh on each run.
$(STEP_1_TARGETS): $(STEP_1_DEPS) 
	@echo "Step One!"
	@echo "TODO: add a way to verify nx, ny were read correctly."
	$(call setup)
	cd ${gen_mapping_files} && \
	csh ${gen_mapping_files}/mk_SCRIPgridplio_enh.csh &> ${log_folder}/${log_file1}
	mv ${gen_mapping_files}/gx1v6plioenh_$(DATE).nc ${output_folder}
	@echo ""

$(STEP_2_TARGETS): $(STEP_2_DEPS) $(STEP_1_TARGETS) 
	@echo "Step Two!"
	$(call setup)
	cp $(STEP_1_TARGETS) ${gen_mapping_files}
	@${gen_mapping_files}/gen_cesm_maps.sh  \
		-fatm /glade/p/cesm/cseg/mapping/grids/fv0.9x1.25_070727.nc  \
		-natm fv09_1.25  \
		-focn ${mapping}/gen_mapping_files/gx1v6plioenh_${DATE}.nc  \
		-nocn gx1v6plioenh  \
		--nogridcheck &> ${log_folder}/${log_file2}
	mv $(notdir $(STEP_2_TARGETS)) ${output_folder}
	rm ${gen_mapping_files}/gx1v6plioenh_$(DATE).nc
	@echo $(notdir $(STEP_2_TARGETS)) ${output_folder}
	@echo ""

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

clean-interactive:
	rm -ir ${output_folder}
	rm -ir ${log_folder}/*

clean:
	rm -rf ${output_folder}
	rm -rf ${log_folder}

#TODO: test
.PHONY : all clean clean-interactive test setup
