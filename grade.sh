CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
if [[ -f student-submission/ListExamples.java ]] 
then 
    echo "Correct file submitted"
else
    echo "Wrong file submitted"
    echo "You may have submitted a directory containing the correct files. If so, please resubmit with just the required files."
    exit
fi

cp -R student-submission/ grading-area/
cp -R TestListExamples.java grading-area/
cp -R lib grading-area/

cd grading-area

javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java 2> compile-errors.txt
if [[ $? -ne 0 ]]
then
    echo "Compile error"
    grep -e "error:" compile-errors.txt > debug-errors.txt
    cat debug-errors.txt
    exit
else
    echo "Compile successful"
fi

java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > output.txt

grep -e "Failure" output.txt > failed-tests.txt

grep -e "Exception" output.txt > error-messages.txt

grep -e "OK" output.txt > results.txt

cat failed-tests.txt
cat error-messages.txt

cat results.txt