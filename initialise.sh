#!/usr/bin/tcsh -f

#####################################################################################################################################
# This code is responsible for:
#
# (a) Loading in the dataset features
# (b) Computing the dataset distance matrices (kernels)
# (c) Computing the multinomial word smoothing matrices
#
######################################################################################################################################

set YARI=$1
set DATASET_DIR=$2
set TMP_DIR=$3          # Stores temporary intermediate matrices
set DATASET_PREFIX=$4   # Test or Validation dataset for evaluation?

# Clean up the data directories (remove stale data)

if ( -d $TMP_DIR ) then
	rm -rf $TMP_DIR
endif

if ( ! -d $TMP_DIR ) then
	mkdir $TMP_DIR
endif

######################################################################################################################################
# Initialise variables to point to the dataset feature files
######################################################################################################################################

set TRAIN_DOC_BLOBS_FP=$DATASET_DIR/train_doc_blobs_DenseSift.rcv
set TRAIN_DOC_WORDS_FP=$DATASET_DIR/train_doc_words_DenseSift.rcv
set TRAIN_BLOBS_FP=$DATASET_DIR/train_blobs_DenseSift.rcv
set TRAIN_BLOB_COUNTS_FP=$DATASET_DIR/train_blob_counts_DenseSift.txt

set TEST_DOC_BLOBS_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_DenseSift.rcv
set TEST_DOC_WORDS_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_DenseSift.rcv
set TEST_BLOBS_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_DenseSift.rcv
set TEST_BLOB_COUNTS_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_DenseSift.txt

set TRAIN_DOC_BLOBS_DS_FP=$DATASET_DIR/train_doc_blobs_DenseSift.rcv
set TRAIN_DOC_WORDS_DS_FP=$DATASET_DIR/train_doc_words_DenseSift.rcv
set TRAIN_BLOBS_DS_FP=$DATASET_DIR/train_blobs_DenseSift.rcv
set TRAIN_BLOB_COUNTS_DS_FP=$DATASET_DIR/train_blob_counts_DenseSift.txt

set TEST_DOC_BLOBS_DS_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_DenseSift.rcv
set TEST_DOC_WORDS_DS_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_DenseSift.rcv
set TEST_BLOBS_DS_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_DenseSift.rcv
set TEST_BLOB_COUNTS_DS_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_DenseSift.txt

set TRAIN_DOC_BLOBS_DS_V3H1_FP=$DATASET_DIR/train_doc_blobs_DenseSiftV3H1.rcv
set TRAIN_DOC_WORDS_DS_V3H1_FP=$DATASET_DIR/train_doc_words_DenseSiftV3H1.rcv
set TRAIN_BLOBS_DS_V3H1_FP=$DATASET_DIR/train_blobs_DenseSiftV3H1.rcv
set TRAIN_BLOB_COUNTS_DS_V3H1_FP=$DATASET_DIR/train_blob_counts_DenseSiftV3H1.txt

set TEST_DOC_BLOBS_DS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_DenseSiftV3H1.rcv
set TEST_DOC_WORDS_DS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_DenseSiftV3H1.rcv
set TEST_BLOBS_DS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_DenseSiftV3H1.rcv
set TEST_BLOB_COUNTS_DS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_DenseSiftV3H1.txt

set TRAIN_DOC_BLOBS_GIST_FP=$DATASET_DIR/train_doc_blobs_Gist.rcv
set TRAIN_DOC_WORDS_GIST_FP=$DATASET_DIR/train_doc_words_Gist.rcv
set TRAIN_BLOBS_GIST_FP=$DATASET_DIR/train_blobs_Gist.rcv
set TRAIN_BLOB_COUNTS_GIST_FP=$DATASET_DIR/train_blob_counts_Gist.txt

set TEST_DOC_BLOBS_GIST_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_Gist.rcv
set TEST_DOC_WORDS_GIST_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_Gist.rcv
set TEST_BLOBS_GIST_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_Gist.rcv
set TEST_BLOB_COUNTS_GIST_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_Gist.txt

set TRAIN_DOC_BLOBS_HH_FP=$DATASET_DIR/train_doc_blobs_HarrisHue.rcv
set TRAIN_DOC_WORDS_HH_FP=$DATASET_DIR/train_doc_words_HarrisHue.rcv
set TRAIN_BLOBS_HH_FP=$DATASET_DIR/train_blobs_HarrisHue.rcv
set TRAIN_BLOB_COUNTS_HH_FP=$DATASET_DIR/train_blob_counts_HarrisHue.txt

set TEST_DOC_BLOBS_HH_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_HarrisHue.rcv
set TEST_DOC_WORDS_HH_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_HarrisHue.rcv
set TEST_BLOBS_HH_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_HarrisHue.rcv
set TEST_BLOB_COUNTS_HH_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_HarrisHue.txt

set TRAIN_DOC_BLOBS_HH_V3H1_FP=$DATASET_DIR/train_doc_blobs_HarrisHueV3H1.rcv
set TRAIN_DOC_WORDS_HH_V3H1_FP=$DATASET_DIR/train_doc_words_HarrisHueV3H1.rcv
set TRAIN_BLOBS_HH_V3H1_FP=$DATASET_DIR/train_blobs_HarrisHueV3H1.rcv
set TRAIN_BLOB_COUNTS_HH_V3H1_FP=$DATASET_DIR/train_blob_counts_HarrisHueV3H1.txt

set TEST_DOC_BLOBS_HH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_HarrisHueV3H1.rcv
set TEST_DOC_WORDS_HH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_HarrisHueV3H1.rcv
set TEST_BLOBS_HH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_HarrisHueV3H1.rcv
set TEST_BLOB_COUNTS_HH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_HarrisHueV3H1.txt

set TRAIN_DOC_BLOBS_RGB_V3H1_FP=$DATASET_DIR/train_doc_blobs_RgbV3H1.rcv
set TRAIN_DOC_WORDS_RGB_V3H1_FP=$DATASET_DIR/train_doc_words_RgbV3H1.rcv
set TRAIN_BLOBS_RGB_V3H1_FP=$DATASET_DIR/train_blobs_RgbV3H1.rcv
set TRAIN_BLOB_COUNTS_RGB_V3H1_FP=$DATASET_DIR/train_blob_counts_RgbV3H1.txt

set TEST_DOC_BLOBS_RGB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_RgbV3H1.rcv
set TEST_DOC_WORDS_RGB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_RgbV3H1.rcv
set TEST_BLOBS_RGB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_RgbV3H1.rcv
set TEST_BLOB_COUNTS_RGB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_RgbV3H1.txt

set TRAIN_DOC_BLOBS_RGB_FP=$DATASET_DIR/train_doc_blobs_Rgb.rcv
set TRAIN_DOC_WORDS_RGB_FP=$DATASET_DIR/train_doc_words_Rgb.rcv
set TRAIN_BLOBS_RGB_FP=$DATASET_DIR/train_blobs_Rgb.rcv
set TRAIN_BLOB_COUNTS_RGB_FP=$DATASET_DIR/train_blob_counts_Rgb.txt

set TEST_DOC_BLOBS_RGB_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_Rgb.rcv
set TEST_DOC_WORDS_RGB_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_Rgb.rcv
set TEST_BLOBS_RGB_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_Rgb.rcv
set TEST_BLOB_COUNTS_RGB_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_Rgb.txt

set TRAIN_DOC_BLOBS_HS_FP=$DATASET_DIR/train_doc_blobs_HarrisSift.rcv
set TRAIN_DOC_WORDS_HS_FP=$DATASET_DIR/train_doc_words_HarrisSift.rcv
set TRAIN_BLOBS_HS_FP=$DATASET_DIR/train_blobs_HarrisSift.rcv
set TRAIN_BLOB_COUNTS_HS_FP=$DATASET_DIR/train_blob_counts_HarrisSift.txt

set TEST_DOC_BLOBS_HS_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_HarrisSift.rcv
set TEST_DOC_WORDS_HS_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_HarrisSift.rcv
set TEST_BLOBS_HS_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_HarrisSift.rcv
set TEST_BLOB_COUNTS_HS_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_HarrisSift.txt

set TRAIN_DOC_BLOBS_HS_V3H1_FP=$DATASET_DIR/train_doc_blobs_HarrisSiftV3H1.rcv
set TRAIN_DOC_WORDS_HS_V3H1_FP=$DATASET_DIR/train_doc_words_HarrisSiftV3H1.rcv
set TRAIN_BLOBS_HS_V3H1_FP=$DATASET_DIR/train_blobs_HarrisSiftV3H1.rcv
set TRAIN_BLOB_COUNTS_HS_V3H1_FP=$DATASET_DIR/train_blob_counts_HarrisSiftV3H1.txt

set TEST_DOC_BLOBS_HS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_HarrisSiftV3H1.rcv
set TEST_DOC_WORDS_HS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_HarrisSiftV3H1.rcv
set TEST_BLOBS_HS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_HarrisSiftV3H1.rcv
set TEST_BLOB_COUNTS_HS_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_HarrisSiftV3H1.txt

set TRAIN_DOC_BLOBS_DH_V3H1_FP=$DATASET_DIR/train_doc_blobs_DenseHueV3H1.rcv
set TRAIN_DOC_WORDS_DH_V3H1_FP=$DATASET_DIR/train_doc_words_DenseHueV3H1.rcv
set TRAIN_BLOBS_DH_V3H1_FP=$DATASET_DIR/train_blobs_DenseHueV3H1.rcv
set TRAIN_BLOB_COUNTS_DH_V3H1_FP=$DATASET_DIR/train_blob_counts_DenseHueV3H1.txt

set TEST_DOC_BLOBS_DH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_DenseHueV3H1.rcv
set TEST_DOC_WORDS_DH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_DenseHueV3H1.rcv
set TEST_BLOBS_DH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_DenseHueV3H1.rcv
set TEST_BLOB_COUNTS_DH_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_DenseHueV3H1.txt

set TRAIN_DOC_BLOBS_DH_FP=$DATASET_DIR/train_doc_blobs_DenseHue.rcv
set TRAIN_DOC_WORDS_DH_FP=$DATASET_DIR/train_doc_words_DenseHue.rcv
set TRAIN_BLOBS_DH_FP=$DATASET_DIR/train_blobs_DenseHue.rcv
set TRAIN_BLOB_COUNTS_DH_FP=$DATASET_DIR/train_blob_counts_DenseHue.txt

set TEST_DOC_BLOBS_DH_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_DenseHue.rcv
set TEST_DOC_WORDS_DH_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_DenseHue.rcv
set TEST_BLOBS_DH_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_DenseHue.rcv
set TEST_BLOB_COUNTS_DH_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_DenseHue.txt

set TRAIN_DOC_BLOBS_HSV_FP=$DATASET_DIR/train_doc_blobs_Hsv.rcv
set TRAIN_DOC_WORDS_HSV_FP=$DATASET_DIR/train_doc_words_Hsv.rcv
set TRAIN_BLOBS_HSV_FP=$DATASET_DIR/train_blobs_Hsv.rcv
set TRAIN_BLOB_COUNTS_HSV_FP=$DATASET_DIR/train_blob_counts_Hsv.txt

set TEST_DOC_BLOBS_HSV_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_Hsv.rcv
set TEST_DOC_WORDS_HSV_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_Hsv.rcv
set TEST_BLOBS_HSV_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_Hsv.rcv
set TEST_BLOB_COUNTS_HSV_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_Hsv.txt

set TRAIN_DOC_BLOBS_HSV_V3H1_FP=$DATASET_DIR/train_doc_blobs_HsvV3H1.rcv
set TRAIN_DOC_WORDS_HSV_V3H1_FP=$DATASET_DIR/train_doc_words_HsvV3H1.rcv
set TRAIN_BLOBS_HSV_V3H1_FP=$DATASET_DIR/train_blobs_HsvV3H1.rcv
set TRAIN_BLOB_COUNTS_HSV_V3H1_FP=$DATASET_DIR/train_blob_counts_HsvV3H1.txt

set TEST_DOC_BLOBS_HSV_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_HsvV3H1.rcv
set TEST_DOC_WORDS_HSV_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_HsvV3H1.rcv
set TEST_BLOBS_HSV_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_HsvV3H1.rcv
set TEST_BLOB_COUNTS_HSV_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_HsvV3H1.txt

set TRAIN_DOC_BLOBS_LAB_V3H1_FP=$DATASET_DIR/train_doc_blobs_LabV3H1.rcv
set TRAIN_DOC_WORDS_LAB_V3H1_FP=$DATASET_DIR/train_doc_words_LabV3H1.rcv
set TRAIN_BLOBS_LAB_V3H1_FP=$DATASET_DIR/train_blobs_LabV3H1.rcv
set TRAIN_BLOB_COUNTS_LAB_V3H1_FP=$DATASET_DIR/train_blob_counts_LabV3H1.txt

set TEST_DOC_BLOBS_LAB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_LabV3H1.rcv
set TEST_DOC_WORDS_LAB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_LabV3H1.rcv
set TEST_BLOBS_LAB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_LabV3H1.rcv
set TEST_BLOB_COUNTS_LAB_V3H1_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_LabV3H1.txt

set TRAIN_DOC_BLOBS_LAB_FP=$DATASET_DIR/train_doc_blobs_Lab.rcv
set TRAIN_DOC_WORDS_LAB_FP=$DATASET_DIR/train_doc_words_Lab.rcv
set TRAIN_BLOBS_LAB_FP=$DATASET_DIR/train_blobs_Lab.rcv
set TRAIN_BLOB_COUNTS_LAB_FP=$DATASET_DIR/train_blob_counts_Lab.txt

set TEST_DOC_BLOBS_LAB_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_blobs_Lab.rcv
set TEST_DOC_WORDS_LAB_FP=$DATASET_DIR/${DATASET_PREFIX}_doc_words_Lab.rcv
set TEST_BLOBS_LAB_FP=$DATASET_DIR/${DATASET_PREFIX}_blobs_Lab.rcv
set TEST_BLOB_COUNTS_LAB_FP=$DATASET_DIR/${DATASET_PREFIX}_blob_counts_Lab.txt

######################################################################################################################################
# Load the features into MTX matrices
######################################################################################################################################

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_M < $TEST_DOC_WORDS_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_M < $TRAIN_DOC_BLOBS_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_M < $TRAIN_DOC_WORDS_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_M < $TRAIN_BLOBS_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_M < $TEST_DOC_BLOBS_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_M < $TEST_BLOBS_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_DS_M < $TEST_DOC_WORDS_DS_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_DS_M < $TRAIN_DOC_BLOBS_DS_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_DS_M < $TRAIN_DOC_WORDS_DS_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_DS_M  < $TRAIN_BLOBS_DS_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_DS_M < $TEST_DOC_BLOBS_DS_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_DS_M  < $TEST_BLOBS_DS_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_DS_V3H1_M < $TEST_DOC_WORDS_DS_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_DS_V3H1_M < $TRAIN_DOC_BLOBS_DS_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_DS_V3H1_M < $TRAIN_DOC_WORDS_DS_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_DS_V3H1_M  < $TRAIN_BLOBS_DS_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_DS_V3H1_M < $TEST_DOC_BLOBS_DS_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_DS_V3H1_M  < $TEST_BLOBS_DS_V3H1_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_GIST_M < $TEST_DOC_WORDS_GIST_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_GIST_M < $TRAIN_DOC_BLOBS_GIST_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_GIST_M < $TRAIN_DOC_WORDS_GIST_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_GIST_M  < $TRAIN_BLOBS_GIST_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_GIST_M < $TEST_DOC_BLOBS_GIST_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_GIST_M  < $TEST_BLOBS_GIST_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_LAB_M < $TEST_DOC_WORDS_LAB_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_LAB_M < $TRAIN_DOC_BLOBS_LAB_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_LAB_M < $TRAIN_DOC_WORDS_LAB_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_LAB_M  < $TRAIN_BLOBS_LAB_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_LAB_M < $TEST_DOC_BLOBS_LAB_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_LAB_M  < $TEST_BLOBS_LAB_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_LAB_V3H1_M < $TEST_DOC_WORDS_LAB_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_LAB_V3H1_M < $TRAIN_DOC_BLOBS_LAB_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_LAB_V3H1_M < $TRAIN_DOC_WORDS_LAB_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_LAB_V3H1_M  < $TRAIN_BLOBS_LAB_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_LAB_V3H1_M < $TEST_DOC_BLOBS_LAB_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_LAB_V3H1_M  < $TEST_BLOBS_LAB_V3H1_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_RGB_V3H1_M < $TEST_DOC_WORDS_RGB_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_RGB_V3H1_M < $TRAIN_DOC_BLOBS_RGB_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_RGB_V3H1_M < $TRAIN_DOC_WORDS_RGB_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_RGB_V3H1_M  < $TRAIN_BLOBS_RGB_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_RGB_V3H1_M < $TEST_DOC_BLOBS_RGB_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_RGB_V3H1_M  < $TEST_BLOBS_RGB_V3H1_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_RGB_M < $TEST_DOC_WORDS_RGB_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_RGB_M < $TRAIN_DOC_BLOBS_RGB_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_RGB_M < $TRAIN_DOC_WORDS_RGB_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_RGB_M  < $TRAIN_BLOBS_RGB_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_RGB_M < $TEST_DOC_BLOBS_RGB_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_RGB_M  < $TEST_BLOBS_RGB_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_HH_M < $TEST_DOC_WORDS_HH_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_HH_M < $TRAIN_DOC_BLOBS_HH_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_HH_M < $TRAIN_DOC_WORDS_HH_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_HH_M  < $TRAIN_BLOBS_HH_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_HH_M < $TEST_DOC_BLOBS_HH_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_HH_M  < $TEST_BLOBS_HH_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_HH_V3H1_M < $TEST_DOC_WORDS_HH_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_HH_V3H1_M < $TRAIN_DOC_BLOBS_HH_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_HH_V3H1_M < $TRAIN_DOC_WORDS_HH_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_HH_V3H1_M  < $TRAIN_BLOBS_HH_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_HH_V3H1_M < $TEST_DOC_BLOBS_HH_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_HH_V3H1_M  < $TEST_BLOBS_HH_V3H1_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_HS_M < $TEST_DOC_WORDS_HS_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_HS_M < $TRAIN_DOC_BLOBS_HS_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_HS_M < $TRAIN_DOC_WORDS_HS_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_HS_M  < $TRAIN_BLOBS_HS_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_HS_M < $TEST_DOC_BLOBS_HS_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_HS_M  < $TEST_BLOBS_HS_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_HS_V3H1_M < $TEST_DOC_WORDS_HS_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_HS_V3H1_M < $TRAIN_DOC_BLOBS_HS_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_HS_V3H1_M < $TRAIN_DOC_WORDS_HS_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_HS_V3H1_M  < $TRAIN_BLOBS_HS_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_HS_V3H1_M < $TEST_DOC_BLOBS_HS_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_HS_V3H1_M  < $TEST_BLOBS_HS_V3H1_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_DH_M < $TEST_DOC_WORDS_DH_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_DH_M < $TRAIN_DOC_BLOBS_DH_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_DH_M < $TRAIN_DOC_WORDS_DH_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_DH_M  < $TRAIN_BLOBS_DH_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_DH_M < $TEST_DOC_BLOBS_DH_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_DH_M  < $TEST_BLOBS_DH_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_DH_V3H1_M < $TEST_DOC_WORDS_DH_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_DH_V3H1_M < $TRAIN_DOC_BLOBS_DH_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_DH_V3H1_M < $TRAIN_DOC_WORDS_DH_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_DH_V3H1_M  < $TRAIN_BLOBS_DH_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_DH_V3H1_M < $TEST_DOC_BLOBS_DH_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_DH_V3H1_M  < $TEST_BLOBS_DH_V3H1_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_HSV_V3H1_M < $TEST_DOC_WORDS_HSV_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_HSV_V3H1_M < $TRAIN_DOC_BLOBS_HSV_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_HSV_V3H1_M < $TRAIN_DOC_WORDS_HSV_V3H1_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_HSV_V3H1_M  < $TRAIN_BLOBS_HSV_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_HSV_V3H1_M < $TEST_DOC_BLOBS_HSV_V3H1_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_HSV_V3H1_M  < $TEST_BLOBS_HSV_V3H1_FP

$YARI load:rcv $TMP_DIR/TEST_DOC_WORDS_HSV_M < $TEST_DOC_WORDS_HSV_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_BLOBS_HSV_M < $TRAIN_DOC_BLOBS_HSV_FP
$YARI load:rcv $TMP_DIR/TRAIN_DOC_WORDS_HSV_M < $TRAIN_DOC_WORDS_HSV_FP
$YARI load:rcv $TMP_DIR/TRAIN_BLOBS_HSV_M  < $TRAIN_BLOBS_HSV_FP
$YARI load:rcv $TMP_DIR/TEST_DOC_BLOBS_HSV_M < $TEST_DOC_BLOBS_HSV_FP
$YARI load:rcv $TMP_DIR/TEST_BLOBS_HSV_M  < $TEST_BLOBS_HSV_FP

######################################################################################################################################
# Compute helpful statistics on the training and validation datasets
######################################################################################################################################

set NUM_TRAIN_FEAT=`$YARI size $TMP_DIR/TRAIN_BLOBS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'`       # Number of images in our validing dataset
set NUM_TEST_IMAGES=`$YARI size $TMP_DIR/TEST_DOC_WORDS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'` # Number of images in our validing dataset
set NUM_TRAIN_IMAGES=`$YARI size $TMP_DIR/TRAIN_DOC_WORDS_M | cut -d 'x' -f 1 | sed 's/ //' | cut -d ':' -f 2 | sed 's/ //'` # Number of images in our validing dataset
set NUM_WORDS=`$YARI size $TMP_DIR/TRAIN_DOC_WORDS_M | cut -d 'x' -f 2 | sed 's/ //'` # Number of words

######################################################################################################################################
# Compute an initial estimate of the Multinomial word smoothing component of the CRM (P(w|I))
######################################################################################################################################
set MU=1
$YARI transpose $TMP_DIR/TRAIN_DOC_WORDS_M

$YARI $TMP_DIR/WORD_COOCUR_M = $TMP_DIR/TRAIN_DOC_WORDS_M.T 'x' $TMP_DIR/TRAIN_DOC_WORDS_M

# Create a vector of 1's to extract the counts off the co-occurence matrix diagonal
$YARI $TMP_DIR/ID_WORDS_V = ones $NUM_WORDS 1
$YARI transpose $TMP_DIR/ID_WORDS_V

# Create a identity matrix: we use it to remove non-diagonal elements from the cooccurrence matrix
$YARI $TMP_DIR/ID_WORDS_M = eye $TMP_DIR/ID_WORDS_V

$YARI $TMP_DIR/WORD_COOCUR_DIAG_M = $TMP_DIR/WORD_COOCUR_M '*' $TMP_DIR/ID_WORDS_M

$YARI $TMP_DIR/WORD_FREQ_M = $TMP_DIR/WORD_COOCUR_DIAG_M 'x' $TMP_DIR/ID_WORDS_V  # W_FREQ holds the frequency of the training set words
$YARI transpose $TMP_DIR/WORD_FREQ_M

$YARI $TMP_DIR/ID_IMAGES_V = ones 1 $NUM_TRAIN_IMAGES    
$YARI transpose $TMP_DIR/ID_IMAGES_V                     

$YARI $TMP_DIR/TOTAL_WORD_COUNT_M = $TMP_DIR/ID_WORDS_V.T 'x' $TMP_DIR/WORD_FREQ_M                # Calculate the total word count for the collection

$YARI $TMP_DIR/TOTAL_WORD_COUNT_REP_M = $TMP_DIR/TOTAL_WORD_COUNT_M 'x' $TMP_DIR/ID_WORDS_V.T     # Replicate this across the training images
$YARI $TMP_DIR/WORD_REL_FREQ_M = $TMP_DIR/WORD_FREQ_M.T '/' $TMP_DIR/TOTAL_WORD_COUNT_REP_M       # Compute the relative frequency of each word

$YARI transpose $TMP_DIR/WORD_REL_FREQ_M
$YARI $TMP_DIR/WORD_REL_FREQ_REP_M = $TMP_DIR/WORD_REL_FREQ_M.T 'x' $TMP_DIR/ID_IMAGES_V          # Replicate the relative frequency across the training images

$YARI $TMP_DIR/WORD_REL_FREQ_REP_M = $TMP_DIR/WORD_REL_FREQ_REP_M '*' $MU                         # Furnish with the smoothing constant MU
$YARI transpose $TMP_DIR/WORD_REL_FREQ_REP_M                                                                                              
$YARI $TMP_DIR/SMOOTH_NOMINATOR_M = $TMP_DIR/WORD_REL_FREQ_REP_M.T '+' $TMP_DIR/TRAIN_DOC_WORDS_M # This is the top part of the Dirichlet smoothing equation

$YARI $TMP_DIR/COUNTS_PER_IMAGE_M = $TMP_DIR/TRAIN_DOC_WORDS_M 'x' $TMP_DIR/ID_WORDS_V         # Calculate the denominator of the Dirichlet smoothing equation
$YARI $TMP_DIR/COUNTS_PER_IMAGE_REP_M = $TMP_DIR/COUNTS_PER_IMAGE_M 'x' $TMP_DIR/ID_WORDS_V.T                                                                    
$YARI $TMP_DIR/SMOOTH_DENOMINATOR_M = $TMP_DIR/COUNTS_PER_IMAGE_REP_M '+' $MU                                                                                    
$YARI $TMP_DIR/WORD_PROBS_M = $TMP_DIR/SMOOTH_NOMINATOR_M '/' $TMP_DIR/SMOOTH_DENOMINATOR_M       # WORD_PROBS_M is P(w|I)

######################################################################################################################################
# Compute the distances between the image features
######################################################################################################################################

# Create an indexing matrix to sum over the right features for each training image
set region_id_offset=`expr 1`
set feature_id=`expr 1`
foreach region_count ( "`cat $TRAIN_BLOB_COUNTS_FP`" )
	foreach region_id (`seq 1 $region_count`)
		echo $feature_id $region_id_offset 1 >> $TMP_DIR/ID_TRAIN_FEAT_rcv
		set region_id_offset=`expr $region_id_offset + 1`
	end
	set feature_id=`expr $feature_id + 1`
end
$YARI load:rcv $TMP_DIR/ID_TRAIN_FEAT_M < $TMP_DIR/ID_TRAIN_FEAT_rcv
$YARI $TMP_DIR/ID_TRAIN_FEAT_M = weigh:L1 $TMP_DIR/ID_TRAIN_FEAT_M

# Create an indexing matrix to do the same for the testing images.
set region_id_offset=`expr 1`
set feature_id=`expr 1`
foreach region_count ( "`cat $TEST_BLOB_COUNTS_FP`" )
	foreach region_id (`seq 1 $region_count`)
		echo $region_id_offset $feature_id 1 >> $TMP_DIR/ID_TEST_FEAT_rcv
		set region_id_offset=`expr $region_id_offset + 1`
	end
	set feature_id=`expr $feature_id + 1`
end


$YARI load:rcv $TMP_DIR/ID_TEST_FEAT_M < $TMP_DIR/ID_TEST_FEAT_rcv
$YARI $TMP_DIR/ID_TEST_FEAT_M = weigh:L1 $TMP_DIR/ID_TEST_FEAT_M

$YARI transpose $TMP_DIR/ID_TEST_FEAT_M
$YARI transpose $TMP_DIR/ID_TRAIN_FEAT_M

rm -rf $TMP_DIR/IMAGE_DISTS_GIST_M
rm -rf $TMP_DIR/IMAGE_DISTS_DS_V3H1_M
rm -rf $TMP_DIR/IMAGE_DISTS_DS_M
rm -rf $TMP_DIR/IMAGE_DISTS_RGB_M
rm -rf $TMP_DIR/IMAGE_DISTS_RGB_V3H1_M
rm -rf $TMP_DIR/IMAGE_DISTS_LAB_M
rm -rf $TMP_DIR/IMAGE_DISTS_LAB_V3H1_M
rm -rf $TMP_DIR/IMAGE_DISTS_HH_V3H1_M
rm -rf $TMP_DIR/IMAGE_DISTS_HH_M
rm -rf $TMP_DIR/IMAGE_DISTS_HS_V3H1_M
rm -rf $TMP_DIR/IMAGE_DISTS_HS_M
rm -rf $TMP_DIR/IMAGE_DISTS_DH_M
rm -rf $TMP_DIR/IMAGE_DISTS_DH_V3H1_M	
rm -rf $TMP_DIR/IMAGE_DISTS_HSV_M
rm -rf $TMP_DIR/IMAGE_DISTS_HSV_V3H1_M

######################################################################################################################################
# L1 normalise the features (except GIST)
######################################################################################################################################

$YARI $TMP_DIR/TEST_BLOBS_DS_L1_M = L1 $TMP_DIR/TEST_BLOBS_DS_M
$YARI $TMP_DIR/TEST_BLOBS_DS_V3H1_L1_M = L1 $TMP_DIR/TEST_BLOBS_DS_V3H1_M
$YARI $TMP_DIR/TEST_BLOBS_HH_L1_M = L1 $TMP_DIR/TEST_BLOBS_HH_M
$YARI $TMP_DIR/TEST_BLOBS_HH_V3H1_L1_M = L1 $TMP_DIR/TEST_BLOBS_HH_V3H1_M
$YARI $TMP_DIR/TEST_BLOBS_HS_L1_M = L1 $TMP_DIR/TEST_BLOBS_HS_M
$YARI $TMP_DIR/TEST_BLOBS_HS_V3H1_L1_M = L1 $TMP_DIR/TEST_BLOBS_HS_V3H1_M
$YARI $TMP_DIR/TEST_BLOBS_DH_L1_M = L1 $TMP_DIR/TEST_BLOBS_DH_M
$YARI $TMP_DIR/TEST_BLOBS_DH_V3H1_L1_M = L1 $TMP_DIR/TEST_BLOBS_DH_V3H1_M
$YARI $TMP_DIR/TEST_BLOBS_RGB_L1_M = L1 $TMP_DIR/TEST_BLOBS_RGB_M
$YARI $TMP_DIR/TEST_BLOBS_RGB_V3H1_L1_M = L1 $TMP_DIR/TEST_BLOBS_RGB_V3H1_M
$YARI $TMP_DIR/TEST_BLOBS_HSV_L1_M = L1 $TMP_DIR/TEST_BLOBS_HSV_M
$YARI $TMP_DIR/TEST_BLOBS_HSV_V3H1_L1_M = L1 $TMP_DIR/TEST_BLOBS_HSV_V3H1_M
$YARI $TMP_DIR/TEST_BLOBS_LAB_L1_M = L1 $TMP_DIR/TEST_BLOBS_LAB_M
$YARI $TMP_DIR/TEST_BLOBS_LAB_V3H1_L1_M = L1 $TMP_DIR/TEST_BLOBS_LAB_V3H1_M

$YARI $TMP_DIR/TRAIN_BLOBS_DS_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_DS_M
$YARI $TMP_DIR/TRAIN_BLOBS_DS_V3H1_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_DS_V3H1_M
$YARI $TMP_DIR/TRAIN_BLOBS_HH_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_HH_M
$YARI $TMP_DIR/TRAIN_BLOBS_HH_V3H1_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_HH_V3H1_M
$YARI $TMP_DIR/TRAIN_BLOBS_HS_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_HS_M
$YARI $TMP_DIR/TRAIN_BLOBS_HS_V3H1_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_HS_V3H1_M
$YARI $TMP_DIR/TRAIN_BLOBS_DH_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_DH_M
$YARI $TMP_DIR/TRAIN_BLOBS_DH_V3H1_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_DH_V3H1_M
$YARI $TMP_DIR/TRAIN_BLOBS_RGB_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_RGB_M
$YARI $TMP_DIR/TRAIN_BLOBS_RGB_V3H1_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_RGB_V3H1_M
$YARI $TMP_DIR/TRAIN_BLOBS_HSV_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_HSV_M
$YARI $TMP_DIR/TRAIN_BLOBS_HSV_V3H1_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_HSV_V3H1_M
$YARI $TMP_DIR/TRAIN_BLOBS_LAB_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_LAB_M
$YARI $TMP_DIR/TRAIN_BLOBS_LAB_V3H1_L1_M = L1 $TMP_DIR/TRAIN_BLOBS_LAB_V3H1_M

$YARI transpose $TMP_DIR/TRAIN_BLOBS_DS_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_GIST_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_RGB_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_RGB_V3H1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_LAB_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_LAB_V3H1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HSV_V3H1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HSV_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_DH_V3H1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_DH_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HH_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HH_V3H1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HS_V3H1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HS_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_DS_V3H1_M

$YARI transpose $TMP_DIR/TRAIN_BLOBS_DS_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_GIST_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_RGB_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_RGB_V3H1_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_LAB_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_LAB_V3H1_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HSV_V3H1_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HSV_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_DH_V3H1_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_DH_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HH_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HH_V3H1_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HS_V3H1_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_HS_L1_M
$YARI transpose $TMP_DIR/TRAIN_BLOBS_DS_V3H1_L1_M

######################################################################################################################################
# Compute distances (kernels) for each feature type. We compute the default kernels here:

# 1. Laplacian (P10) for colour features
# 2. CHI2 for SIFT/Hue based features
# 3. Gaussian (P20) for Gist
#
# The SKL-CRM paper introduces the data-adaptive Generalised Gaussian and Multinomial kernels. You can easily use these kernels by amending 
# this script appropriately:
#
# a) Generalised Gaussian: If you wish to compute the generalised Gaussian kernel replace chi2/norm,p=2.0/norm,p=1.0 with norm,p=A.B, where 
# A.B is any fractional value e.g. 0.1:
#
# $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/TEST_BLOBS_${VAR1}_L1_M 'x' $TMP_DIR/TRAIN_BLOBS_${VAR1}_L1_M.T "norm,p=0.1"
# $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '*' -1
#
# b) Multinomial Kernel: use the following code-snippet to compute the Multinomial kernel. Use lm:b=A.B to set lambda to value A.B e.g lm:b=0.75 
# will compute a Multinomial kernel with lambda=0.75:
#
# $YARI $TMP_DIR/TRAIN_BLOBS_${VAR1}_MK075_M = lm:b=0.75 $TMP_DIR/TRAIN_BLOBS_${VAR1}_M
# $YARI transpose $TMP_DIR/TRAIN_BLOBS_${VAR1}_MK075_M                                
# $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_MK075_M = $TMP_DIR/TEST_BLOBS_${VAR1}_L1_M 'x' $TMP_DIR/TRAIN_BLOBS_${VAR1}_MK075_M.T
# $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_MK075_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_MK075_M '*' -1                          
######################################################################################################################################

# Gaussian (P20) kernel for GIST
foreach VAR1 (GIST)

  foreach VAR2 (P20)

     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/TEST_BLOBS_${VAR1}_M 'x' $TMP_DIR/TRAIN_BLOBS_${VAR1}_M.T "norm,p=2.0"
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '*' -1

     # Normalise distances so that they have a maximum value of 1.0

     $YARI $TMP_DIR/MIN_M = min $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M
     $YARI transpose $TMP_DIR/MIN_M
     $YARI $TMP_DIR/MIN2_M = min $TMP_DIR/MIN_M.T
     $YARI print:rcv $TMP_DIR/MIN2_M > "$TMP_DIR/min_temp.txt"
     set MIN = `cat "$TMP_DIR/min_temp.txt" | awk '{ print $3 }'`

     $YARI $TMP_DIR/MAX_M = max $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M
     $YARI transpose $TMP_DIR/MAX_M
     $YARI $TMP_DIR/MAX2_M = max $TMP_DIR/MAX_M.T
     $YARI print:rcv $TMP_DIR/MAX2_M > "$TMP_DIR/max_temp.txt"
     set MAX = `cat "$TMP_DIR/max_temp.txt" | awk '{ print $3 }'`

     set MAX_MIN = `echo "$MAX - $MIN" | bc -l`

     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '-' $MIN
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '/' $MAX_MIN
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_NORM_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '*' -1
     
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_NORM_M '*' '1'

  end

end


# Laplacian (P10) kernel for the colour features
foreach VAR1 (RGB RGB_V3H1 LAB LAB_V3H1 HSV HSV_V3H1)

  foreach VAR2 (P10)

     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/TEST_BLOBS_${VAR1}_L1_M 'x' $TMP_DIR/TRAIN_BLOBS_${VAR1}_L1_M.T "norm,p=1.0"
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '*' -1

     # Normalise distances so that they have a maximum value of 1.0

     $YARI $TMP_DIR/MIN_M = min $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M
     $YARI transpose $TMP_DIR/MIN_M
     $YARI $TMP_DIR/MIN2_M = min $TMP_DIR/MIN_M.T
     $YARI print:rcv $TMP_DIR/MIN2_M > "$TMP_DIR/min_temp.txt"
     set MIN = `cat "$TMP_DIR/min_temp.txt" | awk '{ print $3 }'`

     $YARI $TMP_DIR/MAX_M = max $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M
     $YARI transpose $TMP_DIR/MAX_M
     $YARI $TMP_DIR/MAX2_M = max $TMP_DIR/MAX_M.T
     $YARI print:rcv $TMP_DIR/MAX2_M > "$TMP_DIR/max_temp.txt"
     set MAX = `cat "$TMP_DIR/max_temp.txt" | awk '{ print $3 }'`

     set MAX_MIN = `echo "$MAX - $MIN" | bc -l`

     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '-' $MIN
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '/' $MAX_MIN
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_NORM_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '*' -1
     
     $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_NORM_M '*' '1'


  end

end

# CHI2 kernel for the non-colour features
foreach VAR1 (DS DS_V3H1 HS HS_V3H1 HH HH_V3H1 DH DH_V3H1)

   foreach VAR2 (CHI2)

        $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/TEST_BLOBS_${VAR1}_L1_M 'x' $TMP_DIR/TRAIN_BLOBS_${VAR1}_L1_M.T "chi2"
	$YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '*' -1

	# Normalise distances so that they have a maximum value of 1.0

	$YARI $TMP_DIR/MIN_M = min $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M
	$YARI transpose $TMP_DIR/MIN_M
	$YARI $TMP_DIR/MIN2_M = min $TMP_DIR/MIN_M.T
	$YARI print:rcv $TMP_DIR/MIN2_M > "$TMP_DIR/min_temp.txt"
	set MIN = `cat "$TMP_DIR/min_temp.txt" | awk '{ print $3 }'`

        $YARI $TMP_DIR/MAX_M = max $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M
        $YARI transpose $TMP_DIR/MAX_M
	$YARI $TMP_DIR/MAX2_M = max $TMP_DIR/MAX_M.T
	$YARI print:rcv $TMP_DIR/MAX2_M > "$TMP_DIR/max_temp.txt"
	set MAX = `cat "$TMP_DIR/max_temp.txt" | awk '{ print $3 }'`

	set MAX_MIN = `echo "$MAX - $MIN" | bc -l`

	$YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '-' $MIN
	$YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '/' $MAX_MIN
        $YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_NORM_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_M '*' -1

	$YARI $TMP_DIR/IMAGE_DISTS_${VAR1}_M = $TMP_DIR/IMAGE_DISTS_${VAR1}_${VAR2}_NORM_M '*' '1'

    end
end
