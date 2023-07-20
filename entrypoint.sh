#!/bin/bash

python3 maqp.py --generate_hdf \
    --dataset imdb-light \
    --csv_seperator , \
    --csv_path imdb-benchmark \
    --hdf_path imdb-benchmark/gen_single_light \
    --max_rows_per_hdf_file 100 \

python3 maqp.py --generate_sampled_hdfs \
    --dataset imdb-light \
    --hdf_path imdb-benchmark/gen_single_light \
    --max_rows_per_hdf_file 100 \
    --hdf_sample_size 100 \


python3 maqp.py --generate_ensemble
    --dataset imdb-light 
    --samples_per_spn 100 100 100 100 100
    --ensemble_strategy rdc_based
    --hdf_path ../imdb-benchmark/gen_single_light
    --max_rows_per_hdf_file 100
    --samples_rdc_ensemble_tests 100
    --ensemble_path ../imdb-benchmark/spn_ensembles
    --database_name imdb
    --post_sampling_factor 10 10 5 1 1
    --ensemble_budget_factor 5
    --ensemble_max_no_joins 3
    --pairwise_rdc_path ../imdb-benchmark/spn_ensembles/pairwise_rdc.pkl


python3 maqp.py --evaluate_cardinalities
    --rdc_spn_selection
    --max_variants 1
    --pairwise_rdc_path ../imdb-benchmark/spn_ensembles/pairwise_rdc.pkl
    --dataset imdb-light
    --target_path ./baselines/cardinality_estimation/results/deepDB/imdb_light_model_based_budget_5.csv
    --ensemble_location ../imdb-benchmark/spn_ensembles/ensemble_join_3_budget_5_10000000.pkl
    --query_file_location ./benchmarks/job-light/sql/job_light_queries.sql
    --ground_truth_file_location ./benchmarks/job-light/sql/job_light_true_cardinalities.csv

python3 maqp.py --generate_hdf \
    --generate_sampled_hdfs \
    --generate_ensemble \
    --evaluate_cardinalities \
    --samples_per_spn 10000 10000 10000 10000 \
    --ensemble_strategy relationship \
    --ensemble_path imdb-benchmark/spn_ensembles \
    --database_name imdb \
    --post_sampling_factor 10 10 5 1 1 \
    --dataset imdb-light \
    --csv_seperator , \
    --csv_path imdb-benchmark \
    --hdf_path imdb-benchmark/gen_single_light \
    --max_rows_per_hdf_file 10000 \
    --hdf_sample_size 10000 \
    --rdc_spn_selection \
    --max_variants 1 \
    --target_path ./baselines/cardinality_estimation/results/deepDB/imdb_light_model_based_budget_5.csv \
    --ensemble_location imdb-benchmark/spn_ensembles/ensemble_relationships_imdb-light_10000.pkl \
    --query_file_location ./benchmarks/job-light/sql/job_light_queries.sql \
    --ground_truth_file_location ./benchmarks/job-light/sql/job_light_true_cardinalities.csv \
    --pairwise_rdc_path imdb-benchmark/spn_ensembles/pairwise_rdc.pkl