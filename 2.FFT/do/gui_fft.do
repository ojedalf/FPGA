onbreak {
    resume
    puts "Simulation Finished"
    pause
}

# call do files
do wave_fft.do
do coverage.do

# Run all the test
run -a
