#!/usr/bin/tcsh -f 

#####################################################################################################################################
# This code evaluates the SKL-CRM using mean per word recall, precision and number of words greater than zero (N+)
######################################################################################################################################

set YARI=$1
set DATASET_DIR=$2
set TMP_DIR=$3          # Stores temporary intermediate matrices
set DATASET_PREFIX=$4   # Test or Validation dataset for evaluation?

set BANDWIDTH=`cat $TMP_DIR/BW.txt`
set TOP_WORDS=5

set NUM_TRAIN_FEAT=`$YARI size $TMP_DIR/TRAIN_BLOBS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'`       # Number of images in our validation dataset
set NUM_TEST_IMAGES=`$YARI size $TMP_DIR/TEST_DOC_WORDS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'`   # Number of images in our validing dataset
set NUM_TRAIN_IMAGES=`$YARI size $TMP_DIR/TRAIN_DOC_WORDS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'` # Number of images in our validing dataset
set NUM_WORDS=`$YARI size $TMP_DIR/TRAIN_DOC_WORDS_M | cut -d 'x' -f 2 | sed 's/ //'` # Number of words

set TRAIN_DOC_WORDS_FP=$DATASET_DIR/train_doc_words_DenseSift.rcv
set TEST_DOC_WORDS_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_DenseSift.rcv

#####################################################################################################################################
# Add up the distances across each of the 15 different feature types
######################################################################################################################################

rm -rf $TMP_DIR/IMAGE_DISTS_M

$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+' $TMP_DIR/IMAGE_DISTS_GIST_M
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_HSV_V3H1_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+' $TMP_DIR/IMAGE_DISTS_HSV_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+' $TMP_DIR/IMAGE_DISTS_DS_V3H1_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_DS_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+' $TMP_DIR/IMAGE_DISTS_DH_V3H1_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_DH_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_HH_V3H1_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_HH_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+' $TMP_DIR/IMAGE_DISTS_HS_V3H1_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_RGB_M
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_HS_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_LAB_V3H1_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_LAB_M 
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '+'  $TMP_DIR/IMAGE_DISTS_RGB_V3H1_M 
$YARI $TMP_DIR/IMAGE_DISTS_M = $TMP_DIR/IMAGE_DISTS_M '/' '15'

#####################################################################################################################################
# Error checking
######################################################################################################################################

$YARI print:rcv $TMP_DIR/IMAGE_DISTS_M > "$TMP_DIR/nan_find.txt"
set IS_NAN = `cat "$TMP_DIR/nan_find.txt" | grep "nan" | wc -l`
set IS_INF = `cat "$TMP_DIR/nan_find.txt" | grep "inf" | wc -l`

if ($IS_NAN > 0) then
    echo "ERROR: NaN found!"
    exit
endif

if ($IS_INF > 0) then
    echo "ERROR: Inf found!"
    exit
endif


$YARI print:rcv $TMP_DIR/WORD_PROBS_M > "$TMP_DIR/nan_find.txt"
set IS_NAN = `cat "$TMP_DIR/nan_find.txt" | grep "nan" | wc -l`
set IS_INF = `cat "$TMP_DIR/nan_find.txt" | grep "inf" | wc -l`

if ($IS_NAN > 0) then
    echo "ERROR: NaN found!"
    exit
endif

if ($IS_INF > 0) then
    echo "ERROR: Inf found!"
    exit
endif

#####################################################################################################################################
# Annotate the images
######################################################################################################################################

# Compute the image-image probabilities (P(I|J))
$YARI transpose $TMP_DIR/TRAIN_DOC_WORDS_M
$YARI $TMP_DIR/IMAGE_DISTS_M =  $TMP_DIR/IMAGE_DISTS_M '/' $BANDWIDTH
$YARI $TMP_DIR/IMAGE_LOG_PROBS_M = $TMP_DIR/IMAGE_DISTS_M '#' $TMP_DIR/ID_TRAIN_FEAT_M 'logSexp'
$YARI $TMP_DIR/IMAGE_POST_PROBS_M = $TMP_DIR/ID_TEST_FEAT_M.T 'x' $TMP_DIR/IMAGE_LOG_PROBS_M
$YARI $TMP_DIR/IMAGE_PROBS_M = weigh:log2p $TMP_DIR/IMAGE_POST_PROBS_M   

# Annotate the data
$YARI $TMP_DIR/ANNOTATIONS_M = $TMP_DIR/IMAGE_PROBS_M 'x' $TMP_DIR/WORD_PROBS_M        # Perform the actual image annotation step

$YARI transpose $TMP_DIR/ANNOTATIONS_M
$YARI $TMP_DIR/ANNO_MAX_M = max $TMP_DIR/ANNOTATIONS_M.T
$YARI $TMP_DIR/ANNO_MIN_M = min $TMP_DIR/ANNOTATIONS_M.T

$YARI $TMP_DIR/ONES_M = ones $NUM_TEST_IMAGES 1
$YARI transpose $TMP_DIR/ANNO_MAX_M
$YARI transpose $TMP_DIR/ANNO_MIN_M

# Normalise the annotation probabilities (P(w|I)) with min-max normalisation
$YARI $TMP_DIR/ANNO_MAX_M = $TMP_DIR/ONES_M 'x' $TMP_DIR/ANNO_MAX_M.T
$YARI $TMP_DIR/ANNO_MIN_M = $TMP_DIR/ONES_M 'x' $TMP_DIR/ANNO_MIN_M.T
$YARI $TMP_DIR/ANNO_MIN_MAX_M = $TMP_DIR/ANNO_MAX_M '-' $TMP_DIR/ANNO_MIN_M
$YARI $TMP_DIR/ANNOTATIONS_M = $TMP_DIR/ANNOTATIONS_M '-' $TMP_DIR/ANNO_MIN_M
$YARI $TMP_DIR/ANNOTATIONS_M = $TMP_DIR/ANNOTATIONS_M '/' $TMP_DIR/ANNO_MIN_MAX_M

$YARI print:rcv,top=$TOP_WORDS $TMP_DIR/ANNOTATIONS_M > $TMP_DIR/ann.rcv               # Print out the top 5 words for each image

#####################################################################################################################################
# Evaluate the annotations
######################################################################################################################################

echo "###################### Computing Results #######################"

###### Filter for words that occur both in training and test sets

$YARI $TMP_DIR/TEST_WORDS_FILTER_M =  $TMP_DIR/TEST_DOC_WORDS_M = 1
$YARI transpose $TMP_DIR/TEST_WORDS_FILTER_M                       
$YARI $TMP_DIR/TEST_WORDS_FILTER_M = sum $TMP_DIR/TEST_WORDS_FILTER_M.T

$YARI $TMP_DIR/TRAIN_WORDS_FILTER_M =  $TMP_DIR/TRAIN_DOC_WORDS_M = 1
$YARI transpose $TMP_DIR/TRAIN_WORDS_FILTER_M                        
$YARI $TMP_DIR/TRAIN_WORDS_FILTER_M = sum $TMP_DIR/TRAIN_WORDS_FILTER_M.T

$YARI $TMP_DIR/WORDS_FILTER_M = $TMP_DIR/TEST_WORDS_FILTER_M '*' $TMP_DIR/TRAIN_WORDS_FILTER_M

$YARI $TMP_DIR/WORDS_FILTER_M = $TMP_DIR/WORDS_FILTER_M = 1
$YARI transpose $TMP_DIR/WORDS_FILTER_M                    
$YARI $TMP_DIR/WORD_COUNT_M = sum $TMP_DIR/WORDS_FILTER_M.T

$YARI print:rcv $TMP_DIR/WORD_COUNT_M > "$TMP_DIR/word_count.txt"
set word_count = `cat "$TMP_DIR/word_count.txt" | awk '{ print $3 }'`

###### MPP #####

$YARI $TMP_DIR/TOP_ANN_M = top=5 $TMP_DIR/ANNOTATIONS_M
$YARI $TMP_DIR/RET_REL_M = $TMP_DIR/TOP_ANN_M '*' $TMP_DIR/TEST_DOC_WORDS_M

$YARI $TMP_DIR/TOP_ANN_M = $TMP_DIR/TOP_ANN_M = 1
$YARI transpose $TMP_DIR/TOP_ANN_M               
$YARI $TMP_DIR/TOP_ANN_SUM_M = sum $TMP_DIR/TOP_ANN_M.T
$YARI $TMP_DIR/TOP_ANN_SUM_M = $TMP_DIR/TOP_ANN_SUM_M '*' $TMP_DIR/WORDS_FILTER_M

$YARI $TMP_DIR/RET_REL_M = $TMP_DIR/RET_REL_M = 1
$YARI transpose $TMP_DIR/RET_REL_M               
$YARI $TMP_DIR/RET_REL_SUM_M = sum $TMP_DIR/RET_REL_M.T
$YARI $TMP_DIR/RET_REL_SUM_M = $TMP_DIR/RET_REL_SUM_M '*' $TMP_DIR/WORDS_FILTER_M

$YARI $TMP_DIR/PREC_M = $TMP_DIR/RET_REL_SUM_M '/' $TMP_DIR/TOP_ANN_SUM_M
$YARI transpose $TMP_DIR/PREC_M                                          
$YARI $TMP_DIR/PREC_SUM_M = sum $TMP_DIR/PREC_M.T                        
$YARI $TMP_DIR/PREC_SUM_M = $TMP_DIR/PREC_SUM_M '/' $word_count           

$YARI print:rcv $TMP_DIR/PREC_SUM_M > "$TMP_DIR/mpp.txt"
set mpp = `cat "$TMP_DIR/mpp.txt" | awk '{ print $3 }'` 

###### MPR #####

$YARI $TMP_DIR/REL_M =  $TMP_DIR/TEST_DOC_WORDS_M = 1
$YARI transpose $TMP_DIR/REL_M                       
$YARI $TMP_DIR/REL_SUM_M = sum $TMP_DIR/REL_M.T      

$YARI $TMP_DIR/RECALL_M = $TMP_DIR/RET_REL_SUM_M '/' $TMP_DIR/REL_SUM_M

$YARI transpose $TMP_DIR/RECALL_M
$YARI $TMP_DIR/RECALL_SUM_M = sum $TMP_DIR/RECALL_M.T
$YARI $TMP_DIR/RECALL_SUM_M = $TMP_DIR/RECALL_SUM_M '/' $word_count

$YARI print:rcv $TMP_DIR/RECALL_SUM_M > "$TMP_DIR/mpr.txt"
set mpr = `cat "$TMP_DIR/mpr.txt" | awk '{ print $3 }'`   

####### Words with recall > 0 ####

$YARI $TMP_DIR/RET_REL_SUM_M = $TMP_DIR/RET_REL_SUM_M = 1
$YARI transpose $TMP_DIR/RET_REL_SUM_M                   
$YARI $TMP_DIR/NWRGZ_M = sum $TMP_DIR/RET_REL_SUM_M.T    
$YARI print:rcv $TMP_DIR/NWRGZ_M > "$TMP_DIR/nwrgz.txt" 

set nrgz = `cat "$TMP_DIR/nwrgz.txt" | awk '{ print $3 }'`
set f1=`echo "2*($mpp*$mpr)/($mpp + $mpr)" | bc -l | awk '{printf "%0.4f\n", $1}'`
set res_fp=$TMP_DIR/"res.txt"

echo "Results computed on $word_count words:"
echo "MPR: " $mpr
echo "MPP: " $mpp
echo "F1: " $f1
echo "# Words recall > 0: " $nrgz

echo $f1 > $res_fp
