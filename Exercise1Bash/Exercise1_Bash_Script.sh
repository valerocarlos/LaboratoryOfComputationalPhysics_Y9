%%bash
set -e

# 1a: Download the CSV
cd /home/charli/Desktop/LAB-COMP-PHYSICS/LaboratoryOfComputationalPhysics_Y9
mkdir -p Exercise1Bash
cd Exercise1Bash

input="students_list.csv"

wget -nv -O "$input" \
"https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7&dl=1"

# Check that the downloaded file is not empty
if [[ ! -s "$input" ]]; then
    echo "Error: CSV download failed or the file is empty."
    exit 1
fi

echo "=== Download completed ==="
ls -lh "$input"


# 1b: Separate Physics and PoD students
head -n 1 "$input" > physics_students.csv
head -n 1 "$input" > pod_students.csv

tail -n +2 "$input" | while IFS= read -r line
do
    if [[ "$line" == *"Physics"* ]]; then
        echo "$line" >> physics_students.csv
    else
        echo "$line" >> pod_students.csv
    fi
done

echo
echo "=== Students by program ==="
echo "Physics students: $(( $(wc -l < physics_students.csv) - 1 ))"
echo "PoD students: $(( $(wc -l < pod_students.csv) - 1 ))"


# 1c: Count surnames starting with each letter
echo
echo "=== Students by surname initial ==="

for letter in {A..Z}; do
    count=$(tail -n +2 "$input" | cut -d',' -f1 | grep -ic "^${letter}" || true)
    echo "$letter: $count"
done


# 1d: Find the letter with the highest count
max_count=0
max_letter=""

for letter in {A..Z}; do
    count=$(tail -n +2 "$input" | cut -d',' -f1 | grep -ic "^${letter}" || true)

    if (( count > max_count )); then
        max_count=$count
        max_letter=$letter
    fi
done

echo
echo "=== Most common surname initial ==="
echo "Letter: $max_letter"
echo "Number of students: $max_count"


# 1e: Group students modulo 18
for i in {1..18}; do
    head -n 1 "$input" > "group_${i}.csv"
done

student=0

while IFS= read -r line; do
    student=$((student + 1))
    group=$(( (student - 1) % 18 + 1 ))

    echo "$line" >> "group_${group}.csv"
done < <(tail -n +2 "$input")

echo
echo "=== Modulo 18 groups ==="
for i in {1..18}; do
    count=$(( $(wc -l < "group_${i}.csv") - 1 ))
    echo "Group $i: $count students"
done

echo
echo "=== All tasks completed ==="
ls -lh

