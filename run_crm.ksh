#!/usr/bin/ksh

#####################################################################################################################################
# This code is the main module for the SKL-CRM. It is responsible for setting up the model by calling the supporting scripts.
#                                                                        
# ./run_crm.ksh
#                                                                                                                                    
######################################################################################################################################

######################################################################################################################################
#  Change these variables to appropriate values for your system
######################################################################################################################################
function set_env_vars
{
        YARI=/home/sean/mtx                                # Location of Yari (mtx library)
	CRM_DIR=/home/sean/release/skl_crm/                # Location of the SKL-CRM codebase

	VALID_DATASET_DIR="/disk2/sean/yari_corel_valid/"  # Location of directory containing data .RCV files
	VALID_TMP_DIR=/disk2/sean/crm_temp_valid/          # Stores temporary intermediate matrices
	VALID_DATASET_PREFIX="valid"

	TEST_DATASET_DIR="/disk2/sean/yari_corel_test/"    # Location of directory containing data .RCV files
	TEST_TMP_DIR=/disk2/sean/crm_temp_test/            # Stores temporary intermediate matrices
	TEST_DATASET_PREFIX="test"

	export YARI
	export TMP_DIR
	export OUT_DIR
	export BW_W
	export MU_W

	export VALID_DATASET_DIR
	export VALID_TMP_DIR
	export VALID_DATASET_PREFIX

	export TEST_DATASET_DIR
	export TEST_TMP_DIR
	export TEST_DATASET_PREFIX
}


######################################################################################################################################
# This function performs a grid search for the best kernel bandwidth and multinomial word smoothing parameters
######################################################################################################################################
function find_mu_and_beta
{
    
        rm "./res.log"

        F1_MAX=0.0
	echo "******* SETTING MU/BETA *********" >> "./res.log"
	echo "*******                 *********" >> "./res.log"

	for BW_W in 0.01 0.03 0.05 0.07 0.09 0.1 0.3 0.5 0.7 0.9 1.0 
	do

		echo "Coord: BW_W: " $BW_W
		echo $BW_W > $VALID_TMP_DIR/"BW.txt"
		echo $BW_W > $TEST_TMP_DIR/"BW.txt"

		for MU_W in 0.001 0.01 0.1 1.0
		do
			echo "Coord: MU_W: " $MU_W
			echo $MU_W > $VALID_TMP_DIR/"MU.txt"
			echo $MU_W > $TEST_TMP_DIR/"MU.txt"

		        csh $CRM_DIR/multinomial.sh $YARI $VALID_TMP_DIR
		        wait $!

			csh $CRM_DIR/evaluate.sh $YARI $VALID_DATASET_DIR $VALID_TMP_DIR $VALID_DATASET_PREFIX
			wait $!

			VALID_F1=$(cat $VALID_TMP_DIR/"res.txt" | awk '{print $1}')
			rm $VALID_TMP_DIR/"res.txt"

			VAL=$(echo "$VALID_F1 >= $F1_MAX" | bc)
			if [[ $VAL -eq 1 ]];
			then
				MU_MAX_W=$MU_W
				BW_MAX_W=$BW_W
				F1_MAX=$VALID_F1

				csh $CRM_DIR/multinomial.sh $YARI $TEST_TMP_DIR
				wait $!

				csh $CRM_DIR/evaluate.sh $YARI $TEST_DATASET_DIR $TEST_TMP_DIR $TEST_DATASET_PREFIX
				wait $!

				TEST_F1=$(cat $TEST_TMP_DIR/"res.txt" | awk '{print $1}')
				rm $TEST_TMP_DIR/"res.txt"

				echo " MU_W: " $MU_W " BANDWIDTH: " $BW_W " VALID_F1:" $VALID_F1 " TEST_F1:" $TEST_F1  >> "./res.log"

			fi
		done
	done

	echo $BW_MAX_W > $VALID_TMP_DIR/"BW.txt"
	echo $BW_MAX_W > $TEST_TMP_DIR/"BW.txt"
	echo $MU_MAX_W > $VALID_TMP_DIR/"MU.txt"
	echo $MU_MAX_W > $TEST_TMP_DIR/"MU.txt"

	BW_W=$BW_MAX_W
	MU_W=$MU_MAX_W

	# Print the best test set results to standard output
        csh $CRM_DIR/evaluate.sh $YARI $TEST_DATASET_DIR $TEST_TMP_DIR $TEST_DATASET_PREFIX
        wait $!
}


######################################################################################################################################
# Main function
######################################################################################################################################
function main
{
	echo "###################### Running CRM #####################################"

        set_env_vars

	csh $CRM_DIR/initialise.sh $YARI $VALID_DATASET_DIR $VALID_TMP_DIR $VALID_DATASET_PREFIX
	wait $!

	csh $CRM_DIR/initialise.sh $YARI $TEST_DATASET_DIR $TEST_TMP_DIR $TEST_DATASET_PREFIX
	wait $!

	find_mu_and_beta

	echo "###################### Finished CRM #####################################"
}


main 
