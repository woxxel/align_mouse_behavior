#!/bin/bash

cpus=1
datapath_in=/usr/users/cidbn1/neurodyn
datapath_out=/usr/users/cidbn1/placefields
dataset="AlzheimerMice_Hayashi"

SUBMIT_FILE=./sbatch_submit.sh

mice=$(find $datapath_in/$dataset/* -maxdepth 0 -type d -exec basename {} \;)
echo "Found mice in dataset $dataset: $mice"
read -p 'Which mouse should be processed? ' mouse

# for mouse in $mice
# do
  echo "Processing mouse $mouse"
  mkdir -p $datapath_out/$dataset/$mouse

  ## getting all sessions of $mouse to loop through
  session_names=$(find $datapath_in/$dataset/$mouse/Session* -maxdepth 0 -type d -exec basename {} \;)

  for session_name in $session_names
  do
    echo "Running behavior alignment and resmapling on mouse $mouse, $session_name..."

    if ! $(test -d $datapath_out/$dataset/$mouse/$session_name); then;
      mkdir -p $datapath_out/$dataset/$mouse/$session_name; 
    fi

    cat > $SUBMIT_FILE <<- EOF
#!/bin/bash
#SBATCH -A all
#SBATCH -p medium
#SBATCH -c $cpus
#SBATCH -t 00:05:00
#SBATCH --mem=1000

module use /usr/users/cidbn_sw/sw/modules
module load cidbn_caiman-1.9.10_py-3.9
source activate caiman-1.9.10_py-3.9

export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export VECLIB_MAXIMUM_THREADS=1
export OMP_NUM_THREADS=1

python3 ./align_session.py $datapath_in $datapath_out $dataset $mouse $session_name
EOF
    sbatch $SUBMIT_FILE
    rm $SUBMIT_FILE

  done
# done
