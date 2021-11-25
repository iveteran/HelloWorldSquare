#!/usr/bin/env python
# encoding=utf8
__author__ = 'sofn'

def fib(n):
  if n < 2:
    return n
  else:
    return fib(n - 1) + fib(n - 2)

print(fib(36))
