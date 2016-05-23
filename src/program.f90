program sph

	! Main program of project

	!Created by Jannik Zuern on 05/16/2016
	!Last modified: 05/16/2016

	use gnufor2       !Module: gnuplot fortran visualizations
	use integrate     !Module: definition of integration functions (leapfrog)
	use sphfunctions  !Module: implementation of sph mechanics
	use linkedlists   !Module: Linked lists mechanics and bookkeeping
	use util          !Module: utiliary functions

	implicit none

! 	integer, parameter	:: N1=50
! 	real(kind=8)		:: x1(N1), f1(N1)
! 	integer :: i
! ! generate data for 2D plots
! 	do  i=1,N1
! 		x1(i)=5.0*i/N1
! 	end do
! 	f1=sin(2*x1)
!
!
! 	print *,'Example 1: simple 2D graph'
! 	print *,'call plot(x1,f1)'
! 	call plot(x1,f1)
! 	print *,'press ENTER to go to the next example'
! 	read  *



! ACTUAL PROGRAM STARTING
!-------------------------------------------------------------
!-------------------------------------------------------------

! Define variables
integer																	:: nFrames 							! number of frames to calculate
integer																	:: nSteps_per_frame     ! number of steps between shown frame
integer 																:: i,j,k 								! loop iteration variables
integer, allocatable, dimension(:)  	  :: ll 									! linked list array
integer, allocatable, dimension(:,:)  	:: lc 									! linked cell array
double precision, dimension (9)    	   	:: simulation_parameter ! Initialize sim param vector
type(systemstate)                 	    :: sstate								! Simulation state
double precision												:: dt 									! (constant) time step for numerical integration


dt = simulation_parameter(4)


! Parse input parameter file
call parse_input(simulation_parameter)

! initialize particles
call init_particles(sstate,simulation_parameter)

! initialize linked lists
call init_ll(sstate,simulation_parameter,ll)

! initialize linked cells lists
call init_lc(sstate,simulation_parameter,lc)

! setting up neighbor lists based on placed particles
call setup_neighbour_list(sstate, simulation_parameter, ll,lc)

call print_neighour_list(sstate, simulation_parameter, ll,lc)

! First integration
call compute_accel(sstate, simulation_parameter, ll,lc)
call leapfrog_start(sstate,dt)
call check_state(sstate)   				! currently not working




! Simulation loop
nFrames 						= simulation_parameter(1)
nSteps_per_frame 		= simulation_parameter(2)

do i = 1,nFrames
	! TODO: implement

	print *, "Calculating Step ", i, " of " , nFrames

	do j = 1,nSteps_per_frame
		call compute_accel(sstate, simulation_parameter,ll,lc) !update values for accellerations
		call leapfrog_step(sstate, dt) 												!update velocities and positions based on previously calculated accelleration
		call check_state(sstate);  														!not working
		call print_neighour_list(sstate,simulation_parameter,ll,lc)
	end do


	!call plotPoints(i,out, n, sstate,simulation_parameter);
	!usleep(1000)   ! TODO: implement fortran sleep
end do



! Cleanup
call free_state(sstate)


end program sph
