%%bash

cd /home/charli/Desktop/LAB-COMP-PHYSICS/LaboratoryOfComputationalPhysics_Y9/Exercise2Bash || exit 1

# 1. Prepare data.txt: remove metadata and commas
cp data.csv data.txt
grep -v "^#" data.txt > data_nometa.txt
mv data_nometa.txt data.txt
sed -i "s/,//g" data.txt

# 2. Extract even numbers and count them
grep -oE '\b[0-9]*[02468]\b' data.txt > even_numbers.txt

count=$(wc -l < even_numbers.txt)
echo "Total number of even numbers: $count" >> even_numbers.txt

# 3. Classify data according to the norm of X, Y, Z
awk '{
    norm = sqrt($1^2 + $2^2 + $3^2)

    if (norm >= 100*sqrt(3)/2)
        print $0, "--> Norm X,Y,Z greater than or equal to 100*sqrt(3)/2"
    else
        print $0, "--> Norm X,Y,Z smaller than 100*sqrt(3)/2"
}' data.txt > data_classified.txt

# 4. Create n copies, dividing all numbers by i
n=10

for i in $(seq 1 "$n"); do
    awk -v divisor="$i" '{
        for (j=1; j<=NF; j++)
            $j = $j / divisor
        print
    }' data.txt > "datacopy_${i}.txt"
done

echo "All operations completed successfully!"
