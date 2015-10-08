#!/usr/bin/tcsh -f

#####################################################################################################################################
# This code is responsible for learning the multinomial word smoothing P(w|I) portion of the CRM
######################################################################################################################################

set YARI=$1
set TMP_DIR=$2          # Stores temporary intermediate matrices

set TOP_WORDS=5                                            
set MU=`cat $TMP_DIR/MU.txt`   

set NUM_TRAIN_FEAT=`$YARI size $TMP_DIR/TRAIN_BLOBS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'` # Number of images in our testing datset
set NUM_TEST_IMAGES=`$YARI size $TMP_DIR/TEST_DOC_WORDS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'` # Number of images in our testing dataset             
set NUM_TRAIN_IMAGES=`$YARI size $TMP_DIR/TRAIN_DOC_WORDS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'` # Number of images in our testing dataset             
set NUM_WORDS=`$YARI size $TMP_DIR/TRAIN_DOC_WORDS_M | cut -d 'x' -f 2 | sed 's/ //'` # Number of words  

rm -rf $TMP_DIR/WORD_PROBS_M
rm -rf $TMP_DIR/WORD_REL_FREQ_REP_TEMP_M

$YARI $TMP_DIR/WORD_REL_FREQ_REP_TEMP_M = $TMP_DIR/WORD_REL_FREQ_REP_M '*' $MU                         # Furnish with the smoothing constant MU
$YARI transpose $TMP_DIR/WORD_REL_FREQ_REP_TEMP_M
$YARI $TMP_DIR/SMOOTH_NOMINATOR_M = $TMP_DIR/WORD_REL_FREQ_REP_TEMP_M.T '+' $TMP_DIR/TRAIN_DOC_WORDS_M # This is the top part of the Dirichlet smoothing equation

$YARI $TMP_DIR/COUNTS_PER_IMAGE_M = $TMP_DIR/TRAIN_DOC_WORDS_M 'x' $TMP_DIR/ID_WORDS_V         # Calculate the denominator of the Dirichlet smoothing equation
$YARI $TMP_DIR/COUNTS_PER_IMAGE_REP_M = $TMP_DIR/COUNTS_PER_IMAGE_M 'x' $TMP_DIR/ID_WORDS_V.T
$YARI $TMP_DIR/SMOOTH_DENOMINATOR_M = $TMP_DIR/COUNTS_PER_IMAGE_REP_M '+' $MU

$YARI $TMP_DIR/WORD_PROBS_M = $TMP_DIR/SMOOTH_NOMINATOR_M '/' $TMP_DIR/SMOOTH_DENOMINATOR_M        # WORD_PROBS is P(w|I)
