# coding=utf-8
#
# fysom - pYthOn Finite State Machine - this is a port of Jake
#         Gordon's javascript-state-machine to python
#         https://github.com/jakesgordon/javascript-state-machine
#
# Copyright (C) 2011 Mansour Behabadi <mansour@oxplot.com>, Jake Gordon
#                                        and other contributors
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

import unittest
import copy

from fysom import Fysom


class FysomManyToManyTransitionTests(unittest.TestCase):
    fsm_descr = {
        'initial': 'hungry',
        'events': [
            {'name': 'eat', 'src': 'hungry', 'dst': 'satisfied'},
            {'name': 'eat', 'src': 'satisfied', 'dst': 'full'},
            {'name': 'eat', 'src': 'full', 'dst': 'sick'},
            {'name': 'rest', 'src': ['hungry', 'satisfied', 'full', 'sick'],
             'dst': 'hungry'}
        ]
    }

    def _get_descr(self, initial=None):
        mycopy = copy.deepcopy(self.fsm_descr)
        if initial:
            mycopy['initial'] = initial
        return mycopy

    def test_rest_should_always_transition_to_hungry_state(self):
        fsm = Fysom(self.fsm_descr)
        fsm.rest()
        self.assertEquals(fsm.current, 'hungry')

        fsm = Fysom(self._get_descr('satisfied'))
        fsm.rest()
        self.assertEquals(fsm.current, 'hungry')

        fsm = Fysom(self._get_descr('full'))
        fsm.rest()
        self.assertEquals(fsm.current, 'hungry')

        fsm = Fysom(self._get_descr('sick'))
        fsm.rest()
        self.assertEquals(fsm.current, 'hungry')

    def test_eat_should_transition_to_satisfied_when_hungry(self):
        fsm = Fysom(self._get_descr('hungry'))
        fsm.eat()
        self.assertEqual(fsm.current, 'satisfied')

    def test_eat_should_transition_to_full_when_satisfied(self):
        fsm = Fysom(self._get_descr('satisfied'))
        fsm.eat()
        self.assertEqual(fsm.current, 'full')

    def test_eat_should_transition_to_sick_when_full(self):
        fsm = Fysom(self._get_descr('full'))
        fsm.eat()
        self.assertEqual(fsm.current, 'sick')
