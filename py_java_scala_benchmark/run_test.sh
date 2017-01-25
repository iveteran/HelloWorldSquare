#!/bin/sh

echo python
time python fib.py
echo ----------------

echo pypy
time pypy fib.py
echo ----------------

echo java
time java fib
echo ----------------

echo scala
time scala fib.scala
echo ----------------

echo scala
time scala fib2.scala
echo ----------------
