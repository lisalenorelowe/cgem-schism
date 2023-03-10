Module SDM 

IMPLICIT NONE

SAVE

INTEGER :: NPOINTS   !This is read in from A 
INTEGER :: NEQ       !Calculated from A
INTEGER :: NS
REAL(kind=4), allocatable :: sedflux(:) 
REAL(kind=8), dimension(100) :: A
REAL(kind=8), allocatable :: YY_init(:)
REAL(kind=8), allocatable :: pph_init(:)
integer, parameter :: sO2 = 1
integer, parameter :: sNO3 = 2
integer, parameter :: sNH4 = 3
integer, parameter :: sDIC = 4
integer, parameter :: sOM1 = 5
integer, parameter :: sOM2 = 6
integer, parameter :: sALK = 7
integer, parameter :: sDOC = 8
integer, parameter :: nsed = 8
integer, parameter :: mrow=64


contains

Subroutine SDM_allocate()

!YY is giant, so only allocated SDM arrays if SDM is used

IMPLICIT NONE

DOUBLE PRECISION, allocatable :: dummy1(:), dummy2(:)
!integer, intent(in) :: myid, numprocs
!integer :: i, mpierr
integer :: i
 
allocate(dummy1(NPOINTS))
allocate(dummy2(NEQ))

     OPEN(11, STATUS = 'UNKNOWN', file = 'SDM/ph2bprofile.dat')
     READ(11,*) (dummy1(i), i = 1, NPOINTS)
     CLOSE(11)

     OPEN(11, STATUS = 'UNKNOWN', file = 'SDM/normoxia.dat')
     READ(11,*) (dummy2(i), i = 1, NEQ)
     CLOSE(11)


allocate (sedflux(nsed))
allocate (ppH_init(NPOINTS))
allocate (YY_init(NEQ))

!Initialize whole grid to the initial values
do i = 1, NPOINTS
   ppH_init(i) = dummy1(i)
enddo

do i = 1, NEQ
   YY_init(i) = dummy2(i)
enddo

 
END Subroutine SDM_allocate

END MODULE SDM
