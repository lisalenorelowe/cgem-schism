      SUBROUTINE Sediment_Diagenesis_Flux(dT, f_nf, T, S, pH, sedflux_ij,    &
                                        & s_x1A, s_y1A, s_z1A, s_x2A, s_y2A, &
                                        & s_z2A, s_x1Z, s_y1Z, s_z1Z, s_x2Z, &
                                        & s_y2Z, s_z2Z, YY_ij, ppH_ij )

      use cgem, only: nf
      USE SDM, only: A, NPOINTS, NEQ, nsed
      USE Model_Diagenesis, ONLY: model

      IMPLICIT NONE

      REAL, intent(in) :: f_nf(nf), pH 
      REAL, intent(in) :: T, S    ! State variables: Temperature, Salinity
      REAL(kind=4), intent(out) :: sedflux_ij(nsed) 
      REAL, intent(in) :: s_x1A,s_y1A,s_z1A,s_x2A,s_y2A,s_z2A
      REAL, intent(in) :: s_x1Z,s_y1Z,s_z1Z,s_x2Z,s_y2Z,s_z2Z 
      integer, intent(in) :: dT
      REAL(kind=8), intent(inout) :: ppH_ij(NPOINTS), YY_ij(NEQ)
    
! Change A values according to state variables, T, and S
      call changeA(A, f_nf, T, S, pH,   &
                 & s_x1A, s_y1A, s_z1A, &
                 & s_x2A, s_y2A, s_z2A, &
                 & s_x1Z, s_y1Z, s_z1Z, &
                 & s_x2Z,s_y2Z,s_z2Z )

#ifdef DEBUG
      write(6,*) "After change A: ", NPOINTS, NEQ
#endif

      call model(A, dT, YY_ij, ppH_ij, sedflux_ij)

#ifdef DEBUG
      write(6,*) "After model", sedflux_ij
#endif

      RETURN

      END SUBROUTINE Sediment_Diagenesis_Flux
