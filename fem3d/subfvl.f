c
c routine to write volume
c
c revision log :
c
c 28.04.2010    ggu     written from scratch
c
c******************************************************************

	subroutine wrfvla

c write of finite volume data

	implicit none

	include 'param.h'

        integer nkn,nel,nrz,nrq,nrb,nbc,ngr,mbw
        common /nkonst/ nkn,nel,nrz,nrq,nrb,nbc,ngr,mbw
        integer nlvdi,nlv
        common /level/ nlvdi,nlv

        integer ilhkv(1)
        common /ilhkv/ilhkv

        real hdknv(nlvdim,nkndim)
        common /hdknv/hdknv
        real areakv(nlvdim,nkndim)
        common /areakv/areakv
        real saux1(nlvdim,nkndim)
        common /saux1/saux1

	integer k,l,lmax,id,nvar

	real getpar
	logical has_output,next_output

	integer ia_out(4)
	save ia_out

        integer icall
        save icall
        data icall /0/

c start of code

        if( icall .eq. -1 ) return

c initialization

        if( icall .eq. 0 ) then

	  call init_output('itmcon','idtcon',ia_out)

	  if( .not. has_output(ia_out) ) icall = -1
	  if( icall .le. -1 ) return

	  nvar = 1
	  call open_scalar_file(ia_out,nlv,nvar,'fvl')

        end if

c normal call

        icall = icall + 1

	if( .not. next_output(ia_out) ) return

	do k=1,nkn
	  lmax = ilhkv(k)
	  do l=1,lmax
	    saux1(l,k) = areakv(l,k) * hdknv(l,k)
	  end do
	end do

        id = 66       			!for finite volume
	call write_scalar_file(ia_out,id,nlvdi,saux1)

	end

c******************************************************************

