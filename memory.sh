#!/bin/bash

# Define the maximum size of the test file (in MB)
max_file_size=5000

# Define the minimum size of the test file (in MB)
min_file_size=1

# Initialize the file size to the maximum
file_size=$max_file_size

# Create a temporary file with the defined size
dd if=/dev/zero of=test_file bs=1M count=$file_size

# Measure the time taken to copy the file
start=$(date +%s)
cp test_file test_file_copy
end=$(date +%s)

# Check if duration is zero
if [ $end -eq $start ]; then
  sleep 1
  end=$(date +%s)
fi

# Calculate the speed in MB/s
speed=$(echo "($file_size / ($end - $start))" | bc)

# Check if the speed is below the desired threshold
while [ $(echo "$speed < 50" | bc) -eq 1 ]; do
  # Decrease the file size by half
  file_size=$(echo "($file_size / 2)" | bc)

  # Check if the file size has reached the minimum
  if [ $(echo "$file_size < $min_file_size" | bc) -eq 1 ]; then
    break
  fi

  # Create a temporary file with the decreased size
  dd if=/dev/zero of=test_file bs=1M count=$file_size

  # Measure the time taken to copy the file
  start=$(date +%s)
  cp test_file test_file_copy
  end=$(date +%s)

  # Check if duration is zero
  if [ $end -eq $start ]; then
    sleep 1
    end=$(date +%s)
  fi

  # Calculate the speed in MB/s
  speed=$(echo "($file_size / ($end - $start))" | bc)
done

# Measure the time taken to write the file
start=$(date +%s)
cp test_file test_file_write
end=$(date +%s)

# Check if duration is zero
if [ $end -eq $start ]; then
  sleep 1
  end=$(date +%s)
fi

# Calculate the write speed in MB/s
speed_write=$(echo "($file_size / ($end - $start))" | bc)

# Clean up the test files
rm test_file test_file_copy test_file_write

# Print the results
echo "Speed (Read): $speed MB/s"
echo "Speed (Write): $speed_write MB/s"
echo "File size used for test: $file_size MB"
