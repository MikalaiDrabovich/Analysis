#!/bin/bash

ts_root_dir=`pwd`

peak_gflops=${1:-100000}
peak_gbs=${2:-1000}
data_type=${3:fp32}
num_batches=${4:-3}


# characterize all resnets, adapt batch size for larger resnet sizes 
# to prevent OOM errors
model_verisons=( 1 2 )
data_types=( fp32 fp16 )
resnet_sizes=( 18 34 50 101 152 200 )

#batch_sizes_fp32=( 128 64 32 16 8 8 )
#batch_sizes_fp16=( 256 128 64 32 16 16 )

batch_sizes_fp32=( 512 256 128 64 32 16 )
batch_sizes_fp16=( 1024 512 256 128 64 32 )

inds=($(seq 0 1 5))


data_type=fp32
for model_verison in ${model_verisons[@]}; do
   for ind in ${inds[@]}; do
    cd ${ts_root_dir}/characterization_scripts/
    ./mlperf_image_classification.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_sizes_fp32[${ind}]} ${data_type} 'software' ${resnet_sizes[${ind}]} ${model_verison} 
    
    cd ${ts_root_dir}/characterization_scripts/
    ./mlperf_image_classification.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_sizes_fp32[${ind}]} ${data_type} 'none' ${resnet_sizes[${ind}]} ${model_verison} 
    
    cd ${ts_root_dir}/characterization_scripts/
    ./mlperf_image_classification.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_sizes_fp32[${ind}]} ${data_type} 'hardware' ${resnet_sizes[${ind}]} ${model_verison} 
  done
done

data_type=fp16
for model_verison in ${model_verisons[@]}; do
   for ind in ${inds[@]}; do
    cd ${ts_root_dir}/characterization_scripts/
    ./mlperf_image_classification.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_sizes_fp16[${ind}]} ${data_type} 'software' ${resnet_sizes[${ind}]} ${model_verison} 
    
    cd ${ts_root_dir}/characterization_scripts/
    ./mlperf_image_classification.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_sizes_fp16[${ind}]} ${data_type} 'none' ${resnet_sizes[${ind}]} ${model_verison} 
    
    cd ${ts_root_dir}/characterization_scripts/
    ./mlperf_image_classification.sh ${peak_gflops} ${peak_gbs} ${num_batches} ${batch_sizes_fp16[${ind}]} ${data_type} 'hardware' ${resnet_sizes[${ind}]} ${model_verison} 
  done
done

