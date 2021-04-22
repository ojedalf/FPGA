set broken 0

onbreak {
    set broken 1
    echo "STACK DUMP AT FAILRE"
    transcribe tb
    if { $env(HALT_ON_FAIL) != 1} {
        run -continue
        echo "HALTED AFTER CONTINUE"
    }
    resume
}

do coverage.do

# Run all the test
run -a
exit