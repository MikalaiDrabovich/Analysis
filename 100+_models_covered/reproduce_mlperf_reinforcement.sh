#!/bin/bash

peak_gflops=${1:-4270}
peak_gbs=${2:-180}
data_type=${3:fp32}
batch_size=${4:-256}
num_batches=${5:-10}

#all_models=( mlperf_translation_base mlperf_translation_big )
all_models=( mlperf_reinforcement )

ts_root_dir=`pwd`
for model_name in ${all_models[@]}; do
     export TENSORSCOPE_BENCHMARK_NAME=${model_name}
   
     cd ${ts_root_dir}/characterization_scripts/
     ./mlperf_reinforcement.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'software' ${model_name}  

     cd ${ts_root_dir}/characterization_scripts/
     ./mlperf_reinforcement.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'none' ${model_name}  
  
     cd ${ts_root_dir}/characterization_scripts/
     ./mlperf_reinforcement.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'hardware' ${model_name}  

done


