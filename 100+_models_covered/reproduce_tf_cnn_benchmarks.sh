#!/bin/bash

ts_root_dir=`pwd`

peak_gflops=${1:-100000}
peak_gbs=${2:-1000}
num_batches=${3:-3}

run_training_with_batch() {
     cd ${ts_root_dir}/characterization_scripts/
     ./tf_cnn_benchmarks.sh ${peak_gflops} ${peak_gbs} $1 $2 $3 'software' $4
     
     cd ${ts_root_dir}/characterization_scripts/
     ./tf_cnn_benchmarks.sh ${peak_gflops} ${peak_gbs} $1 $2 $3 'none' $4
     
     cd ${ts_root_dir}/characterization_scripts/
     ./tf_cnn_benchmarks.sh ${peak_gflops} ${peak_gbs} $1 $2 $3 'hardware' $4
     
     cd ${ts_root_dir}
}    

# characterize all models:
models_batch4=("nasnet" "nasnetlarge" "official_resnet200" "official_resnet200_v2")
models_batch8=("resnet152" "resnet152_v2" "official_resnet152" "official_resnet152_v2" "official_resnet200" "official_resnet200_v2")
models_batch16=("vgg11" "vgg16" "vgg19" "inception4" "overfeat" "resnet101" "resnet101_v2" "official_resnet101" "official_resnet101_v2")
models_batch32=("resnet50" "resnet50_v1.5" "resnet50_v2" "official_resnet50" "official_resnet50_v2" "inception3")
models_batch64=("official_resnet34" "official_resnet34_v2" "official_resnet101")
models_batch128=("alexnet" "trivial" "lenet" "official_resnet18" "official_resnet18_v2" )

# characterize all resnets, adapt batch size for larger resnet sizes 
# to prevent OOM errors
model_groups=( 128 64 32 16 8 4 )
inds=($(seq 0 1 1))


batch_sizes=( 512 256 128 64 32 16 )
for ind in ${inds[@]}; do
    model_groups_name=${model_groups[${ind}]} # group name is based on fp32
    batch_size=${batch_sizes[${ind}]} # group name is based on fp32
    group_name="models_batch${model_groups_name}"
    all_batch_models=$(eval echo "\$$group_name")
    for model_name in ${all_batch_models[@]}; do
      run_training_with_batch ${num_batches} ${batch_size} fp32 ${model_name}
    done
done


batch_sizes=( 1024 512 256 128 64 32 )
for ind in ${inds[@]}; do
    model_groups_name=${model_groups[${ind}]} # group name is based on fp32
    batch_size=${batch_sizes[${ind}]} # group name is based on fp32
    group_name="models_batch${model_groups_name}"
    all_batch_models=$(eval echo "\$$group_name")
    for model_name in ${all_batch_models[@]}; do
      run_training_with_batch ${num_batches} ${batch_size} fp16 ${model_name}
    done
done

echo 'Done' $0



