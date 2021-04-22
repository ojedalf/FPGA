# Check simulation flag signal in order to save coverage results
when {/FFT_tb/end_sim = 1'b1} {
echo "Simulation End $now"
stop -sync
echo "Coverage Results"
coverage save ./coverage_results
}