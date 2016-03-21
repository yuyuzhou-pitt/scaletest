LOGDIR=/home/cc/exp/kvm/log/log-"$(date +"%H:%M_%b_%d_%y")"
SCRIPT_DIR=/home/cc/exp/kvm/mantevo/script
mkdir -p "$LOGDIR"

cd /home/cc/exp/kvm/mantevo/

cd miniFE-2.0_ref/src/

for NCPU in 2 4 8 16 32 46 48 ; do # scale up cpu
    for i in 0 1 2 3 4 5; do #  run 10 times to get average
        case $NCPU in 
	2)
	    (time -p mpirun -np 2 --hosts 10.40.1.137,10.40.1.171 taskset -c 0 ./miniFE.x nx=128 ny=128 nz=160) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
	;;
	4)
	    (time -p mpirun -np 4 --hosts 10.40.1.137,10.40.1.171 taskset -c 0,12 ./miniFE.x nx=256 ny=128 nz=160) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
	;;
	8)
	    (time -p mpirun -np 8 --hosts 10.40.1.137,10.40.1.171 taskset -c 0-1,12-13 ./miniFE.x nx=256 ny=256 nz=160) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
	;;
	16)
	    (time -p mpirun -np 16 --hosts 10.40.1.137,10.40.1.171 taskset -c 0-3,12-15 ./miniFE.x nx=512 ny=256 nz=160) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
	;;
        32)
	    (time -p mpirun -np 32 --hosts 10.40.1.137,10.40.1.171 taskset -c 0-7,12-19 ./miniFE.x nx=512 ny=256 nz=320) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
	;;
        46)
	    (time -p mpirun -np 46 --hosts 10.40.1.137,10.40.1.171 taskset -c 0-22 ./miniFE.x nx=512 ny=256 nz=460) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
	;;
        48)
	    (time -p mpirun -np 48 --hosts 10.40.1.137,10.40.1.171 taskset -c 0-23 ./miniFE.x nx=512 ny=256 nz=480) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
	;;
	esac
    done
done
