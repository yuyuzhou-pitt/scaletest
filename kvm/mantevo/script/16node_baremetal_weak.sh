#!/bin/bash
# This is a simaple script try to measure the running of mantevo mini application. 
# To compile mantevo with MPI
# For CentOS7
# sudo yum install openmpi openmpi-devel make gcc gcc-c++ time
#export PATH=:$PATH
#export LD_LIBRARY_PATH=/home/cc/mpich/lib:$LD_LIBRARY_PATH

# For Ubuntu 14.04
# sudo apt-get install make libcr-dev mpich2 mpich2-doc
# Then: $make
# To compile mantevo with OpenMP
# $make make COMPILER=GNU 

LOGDIR=/home/cc/exp/kvm/log/log-"$(date +"%H:%M_%b_%d_%y")"
SCRIPT_DIR=/home/cc/exp/kvm/mantevo/script
mkdir -p "$LOGDIR"

#unzip mantevo
cd /home/cc/exp/kvm/mantevo/
tar xzvf CloverLeaf-1.1.tar.gz
tar xzvf CoMD_Ref.tgz
tar xzvf miniFE-2.0_ref.tgz
 
# compiler each mini application
cd CloverLeaf-1.1/CloverLeaf_MPI
make
cd -
 
cd CoMD_Ref/src-mpi
cp Makefile.vanilla Makefile
make
cd -
  
cd miniFE-2.0_ref/src/
make
cd - 

cd CloverLeaf-1.1/CloverLeaf_MPI
cp clover_bm2_short.in clover.in
cp $SCRIPT_DIR/host* ./
for NCPU in 384 24 48 96 192; do # scale up cpu
    bm_val=$[NCPU/24*64]
    cp clover_bm"$bm_val"_short.in clover.in
    for i in 0 1 2 3 4;do # run 10 times to get average
       (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" ./clover_leaf) > $LOGDIR/CloverLeaf_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
   done
done
cd -
 
cd CoMD_Ref/bin
cp $SCRIPT_DIR/host* ./
for NCPU in 384 24 48 96 192; do # scale up cpu
    for i in ;do # run 10 times to get average
       case $NCPU in
           24)
              (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" ./CoMD-mpi -i 2 -j 4 -k 3 -x 144 -y 144 -z 144) > $LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;

           48)
              (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" ./CoMD-mpi -i 4 -j 4 -k 3 -x 288 -y 144 -z 144) > $LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;
           96)
              (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" ./CoMD-mpi -i 4 -j 8 -k 3 -x 288 -y 288 -z 144) > $LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;
           192)
              (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" taskset -c 0-23 ./CoMD-mpi -i 4 -j 8 -k 6 -x 288 -y 288 -z 288) > $LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;
           384)
              (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" ./CoMD-mpi -i 8 -j 8 -k 6 -x 576 -y 288 -z 288) > $LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;
       esac
    done
done
cd -

cd miniFE-2.0_ref/src/
cp $SCRIPT_DIR/host* ./
for NCPU in 384 192 96 48 24; do # scale up cpu
    for i in ; do #  run 10 times to get average
        case $NCPU in
        24)
            (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" ./miniFE.x nx=256 ny=256 nz=420) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
        ;;
        48)
            (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" taskset -c 0-23 ./miniFE.x nx=512 ny=256 nz=420) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
        ;;
        96)
            (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" taskset -c 0-23 ./miniFE.x nx=512 ny=512 nz=420) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
        ;;
        192)
            (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" taskset -c 0-23 ./miniFE.x nx=512 ny=512 nz=840) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
        ;;
        384)
            (time -p mpirun -np $NCPU --hostfile ./hostfile"$NCPU" taskset -c 0-23 ./miniFE.x nx=1024 ny=512 nz=840) > $LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
        ;;
        esac
    done
done
cd -
## 
## cd miniFE-2.0_openmp_ref/src/
## for NTHREAD in 1 2 4 8 16 32 48 64; do # scale up thread
##     export OMP_NUM_THREADS=$NTHREAD
##     for i in 0 1 2 3 4 5 6 7 8 9; do # run 10 times to get average
##         (time -p ./miniFE.x nx=256 ny=128 nz=128) > /home/yuyuzhou/data/$LOGDIR/miniFE_OMP_NTHREAD_"$NTHREAD"_No_"$i".log 2>&1
##     done
## done
## cd -
