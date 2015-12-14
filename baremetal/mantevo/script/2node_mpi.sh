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

LOGDIR=log-"$(date +"%H:%M_%b_%d_%y")"
cd /home/yuyuzhou/data/
mkdir "$LOGDIR"

#unzip mantevo
cd /home/yuyuzhou/mantevo/
tar xzvf CloverLeaf-1.1.tar.gz
tar xzvf CoMD_Ref.tgz
tar xzvf HPCCG-1.0.tar.gz
tar xzvf miniFE-2.0_openmp_ref.tgz
tar xzvf miniFE-2.0_ref.tgz
 
# compiler each mini application
cd CloverLeaf-1.1/CloverLeaf_MPI
make
cd -
## cd CloverLeaf-1.1/CloverLeaf_OpenMP
## make COMPILER=GNU
## cd -
 
cd CoMD_Ref/src-mpi
cp Makefile.vanilla Makefile
make
cd -
## cd CoMD_Ref/src-openmp
## cp Makefile.vanilla Makefile
## make
## cd -
  
cd miniFE-2.0_ref/src/
make
cd - 
## cd miniFE-2.0_openmp_ref/src/
## cp Makefile.gnu.openmp Makefile
## make
## cd -
## 
## #run each benchmake and record the time
cd CloverLeaf-1.1/CloverLeaf_MPI
cp clover_bm2_short.in clover.in
for NCPU in 1 2 4 8 16 32 64 96; do # scale up cpu
    for i in 0 1 2 3 4 5 6 7 8 9;do # run 10 times to get average
       (time -p mpirun -np $NCPU --hostfile ./hostfile --bind-to rr ./clover_leaf) > /home/yuyuzhou/data/$LOGDIR/CloverLeaf_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
   done
done
cd -
 
## cd CloverLeaf-1.1/CloverLeaf_OpenMP
## cp clover_bm2_short.in clover.in
## for NTHREAD in 1 2 4 8 16 32 48 64; do # scale up thread
##     export OMP_NUM_THREADS=$NTHREAD
##     for i in 0 1 2 3 4 5 6 7 8 9;do # run 10 times to get average
##         (time -p ./clover_leaf) > /home/yuyuzhou/data/$LOGDIR/CloverLeaf_OMP_NTHREAD_"$NTHREAD"_No_"$i".log 2>&1
##     done
## done
## cd -

cd CoMD_Ref/bin
for NCPU in 1 2 4 8 16 32 64 96; do # scale up cpu
    for i in 0 1 2 3 4 5 6 7 8 9;do # run 10 times to get average
       case $NCPU in
           1)
              (time -p mpirun -np $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 1 -j 1 -k 1 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;
           2)
              (time -p mpirun -np $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 2 -j 1 -k 1 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;; 
           4)
             (time -p mpirun -np $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 2 -j 2 -k 1 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;
           8)
             (time -p mpirun -NP $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 2 -j 2 -k 2 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
           ;;
          16)
             (time -p mpirun -NP $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 4 -j 2 -k 2 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
          ;;
          32)
             (time -p mpirun -NP $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 4 -j 4 -k 2 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
          ;;
          64)
             (time -p mpirun -NP $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 4 -j 4 -k 4 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
          ;;
          96)
             (time -p mpirun -NP $NCPU --hostfile ./hostfile --bind-to rr ./CoMD-mpi -i 6 -j 4 -k 4 -x 32 -y 32 -z 24) > /home/yuyuzhou/data/$LOGDIR/CoMD_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
          ;;
       esac
    done
done

## for NTHREAD in 1 2 4 8 16 32 48 64; do # scale up thread
##     export OMP_NUM_THREADS=$NTHREAD
##     for i in 0 1 2 3 4 5 6 7 8 9;do # run 10 times to get average
##         (time -p ./CoMD-openmp-mpi -x 30 -y 30 -z 30) > /home/yuyuzhou/data/$LOGDIR/CoMD_OMP_NTHREAD_"$NTHREAD"_No_"$i".log 2>&1
##     done
## done
cd -
## 
cd HPCCG-1.0
rm mpi_HPCCG
make clean
make CXX=/home/cc/mpich/bin/mpic++ LINKER=/home/cc/mpich/bin/mpic++ USE_MPI=-DUSING_MPI TARGET=mpi_HPCCG
## 
for NCPU in 1 2 4 8 16 32 64 96; do # scale up cpu
    for i in 0 1 2 3 4 5 6 7 8 9; do # run 10 times to get average
        (time -p mpirun -np $NCPU --hostfile ./hostfile --bind-to rr ./mpi_HPCCG 100 100 100) > /home/yuyuzhou/data/$LOGDIR/HPCCG_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
    done
done
## 
## rm omp_HPCCG
## make clean
## make CXX=/usr/lib64/openmpi/bin/mpic++ LINKER=/usr/lib64/openmpi/bin/mpic++ USE_OMP=-DUSING_OMP OMP_FLAGS=-fopenmp TARGET=omp_HPCCG
## for NTHREAD in 1 2 4 8 16 32 48 64; do # scale up thread
##     export OMP_NUM_THREADS=$NTHREAD
##     for i in 0 1 2 3 4 5 6 7 8 9; do # run 10 times to get average
##         (time -p ./omp_HPCCG 100 100 100) > /home/yuyuzhou/data/$LOGDIR/HPCCG_OMP_NTHREAD_"$NTHREAD"_No_"$i".log 2>&1
##     done
## done
cd -
## 
cd miniFE-2.0_ref/src/
for NCPU in 1 2 4 8 16 32 64 96; do # scale up cpu
    for i in 0 1 2 3 4 5 6 7 8 9; do #  run 10 times to get average
        (time -p mpirun -np $NCPU --hostfile ./hostfile --bind-to rr ./miniFE.x nx=256 ny=128 nz=128) > /home/yuyuzhou/data/$LOGDIR/miniFE_MPI_NCPU_"$NCPU"_No_"$i".log 2>&1
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
