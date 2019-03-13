#!/bin/bash

peak_gflops=${1:-100000}
peak_gbs=${2:-1000}
data_type=${3:fp32}
batch_size=${4:-512}
num_batches=${5:-30}

ts_root_dir=`pwd`

cd ${ts_root_dir}/characterization_scripts/
./official_nmt.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'software'

cd ${ts_root_dir}/characterization_scripts/
./official_nmt.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'none'

cd ${ts_root_dir}/characterization_scripts/
./official_nmt.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'hardware'


