Submission=$(pwd)/Submission #contain tar.gz file
INPUT_DIR=$(pwd)/Input #Stores the testcases.
SRC_DIR=$(pwd)/uncomp #untar the source code.

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

if [ $# -lt 1 ]
then
echo "execute sh eval.sh Roll_No"
exit
fi
# Extract student directory
ROLL_NO=$1
mkdir ${SRC_DIR}/${ROLL_NO}
tar -xzf ${Submission}/${ROLL_NO}.tar.gz -C ${SRC_DIR}/${ROLL_NO}
cp "makefile" ${SRC_DIR}/${ROLL_NO}
cd ${SRC_DIR}/${ROLL_NO}/
rm -f a.out
make 
if [ $? -ne 0 ]
then
echo "Make failed!"
exit
fi

Marks=0
echo "Evaluating $ROLL_NO"
echo "*******************"
count=0
./output ${INPUT_DIR}/input1.txt Out1.txt
val=$(diff Out1.txt ${INPUT_DIR}/output1.txt | wc -l)
if [ $val -eq 0 ]
then
count=$(echo "${count} + 1" | bc -l)
echo -e "testcase $no: ${GREEN}passed${NC}"
else
echo -e "testcase $no: ${RED}failed${NC}"
fi
./output ${INPUT_DIR}/input2.txt Out2.txt
val=$(diff Out2.txt ${INPUT_DIR}/output2.txt | wc -l)
if [ $val -eq 0 ]
then
count=$(echo "${count} + 1" | bc -l)
echo -e "testcase $no: ${GREEN}passed${NC}"
else
echo -e "testcase $no: ${RED}failed${NC}"
fi
./output ${INPUT_DIR}/input3.txt Out3.txt
val=$(diff Out3.txt ${INPUT_DIR}/output3.txt | wc -l)
if [ $val -eq 0 ]
then
count=$(echo "${count} + 1" | bc -l)
echo -e "testcase $no: ${GREEN}passed${NC}"
else
echo -e "testcase $no: ${RED}failed${NC}"
fi
marks=$(echo "scale=2; $count / 2.0" | bc -l)
echo "Marks: $marks / 7"
make clean




