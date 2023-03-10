#
## Makefile to build the CGEM FishTank model
#
## Note:
# - These settings are for the *INTEL* compiler.
#   # - Ensure you load the appropriates modules before building (if applicable).

### =============== User Modifiable Section =============== ###

### Uncomment the next line to enable debugging
#DFLAGS = -DDEBUG
#DFLAGS = -g -warn -debug all -g -check all -ftrapuv -DDEBUG #-mcmodel=medium -shared-intel 
#DFLAGS = -Wall -Wextra -pedantic -fimplicit-none -fbacktrace #-D_CGEM -DRDEBUG -DDEBUG 
#DFLAGS = -g

### Build options for specific platforms. 
### LIBS has path to netCDF
#LIBS = -L/usr/local/usrapps/ncdfutil/cmaq-libs/intel2018.4-ncdf4/netcdf/lib -lnetcdff -lnetcdf
#INC = -I/usr/local/usrapps/ncdfutil/cmaq-libs/intel2018.4-ncdf4/netcdf/include

### =============== End User Modifiable Section  =============== ####
include moc_src/src_files
cgemdir=cgem_src
mocdir=moc_src

EXE = CGEM.exe

hostname := $(shell uname -n)

ERR = $(shell which ifort >/dev/null; echo $$?)

ifeq "$(ERR)" "0"
#Use intel on ncsu
  F90 = ifort
  F77 = ifort
  FC = ifort
  INC =   #-I.  #-I/usr/local/usrapps/ncdfutil/cmaq-libs/intel2018.4-ncdf4/netcdf/include
  DFLAGS = #-g -warn -debug all -g -check all -ftrapuv -DDEBUG -DDEBUG2 -DDEBUG_PAR #-mcmodel=medium -shared-intel
  include cgem_src/src_files
else
  F90 = gfortran
  F77 = gfortran
  FC = gfortran
  INC =
  LIBS =
  DMFLAGS = #-fimplicit-none -fbacktrace
  DFLAGS = #-Wall -Wextra -pedantic -fimplicit-none -fbacktrace -DDEBUG #-DDEBUG_PAR #-D_CGEM -DRDEBUG -DDEBUG 
  CFLAGS = 
  include cgem_src/src_files
endif


cgem: ${MOC_OBJ} ${OBJ} ${SDM_OBJ} 
	$(F90) -o $(EXE) $(FFLAGS) $(INC) $(MOC_OBJ) $(OBJ) $(SDM_OBJ) $(LIBS)
#
## Pattern rules
#
$(OBJ):%.o: $(cgemdir)/%.F90
	$(F90) -c $(FFLAGS) $(CFLAGS) $(DFLAGS) $(INC) $<

$(MOC_OBJ):%.o: $(mocdir)/%.F90
	$(F90) -c $(FFLAGS) $(DMFLAGS)  $<

clean:
	rm -f *.o ${EXE} *.mod *genmod*

tags:
	ctags --language-force=Fortran *.F90

etags:
	etags -l fortran *.F90

