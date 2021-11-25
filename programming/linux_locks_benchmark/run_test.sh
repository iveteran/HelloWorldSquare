#!/bin/sh

echo "-------- no lock --------"
time ./no_lock
echo "-------- asm lock --------"
time ./asm_lock
echo "-------- atomic lock --------"
time ./atomic_lock
echo "-------- spin lock --------"
time ./spin_lock
echo "-------- mutex lock --------"
time ./mutex_lock
