#!/bin/bash

peak_gflops=${1:-100000}
peak_gbs=${2:-1000}
data_type=${3:fp32}
batch_size=${4:-512}
num_batches=${5:-30}

#all_models=( mlperf_translation_base mlperf_translation_big )
all_models=( mlperf_translation_base )

ts_root_dir=`pwd`
for model_name in ${all_models[@]}; do
     export TENSORSCOPE_BENCHMARK_NAME=${model_name}

     cd ${ts_root_dir}/characterization_scripts/
     ./mlperf_translation.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'none' ${model_name}  
     
     cd ${ts_root_dir}/characterization_scripts/
     ./mlperf_translation.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'software' ${model_name}  

     cd ${ts_root_dir}/characterization_scripts/
     ./mlperf_translation.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_size} ${data_type} 'hardware' ${model_name}  

done


