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

from fysom import Fysom, FysomError


class FysomAsynchronousStateTransitionTests(unittest.TestCase):
    def on_leave_foo(self, e):
        self.leave_foo_event = e
        return False

    def on_enter_bar(self, e):
        self.on_enter_bar_fired = True
        self.on_enter_bar_event = e

    def setUp(self):
        self.on_enter_bar_fired = False

        self.fsm = Fysom({
            'initial': 'foo',
            'events': [
                {'name': 'footobar', 'src': 'foo', 'dst': 'bar'},
                {'name': 'bartobar', 'src': 'bar', 'dst': 'bar'},
            ],
            'callbacks': {
                'onleavefoo': self.on_leave_foo,
                'onenterbar': self.on_enter_bar,
            }
        })

    def test_fsm_should_be_put_on_hold_when_onleave_state_returns_false(self):
        self.fsm.footobar(id=123)
        self.assertEqual(self.fsm.current, 'foo')
        self.assertTrue(hasattr(self, 'leave_foo_event'), 'Callback onleavefoo did not fire.')
        self.assertTrue(self.leave_foo_event is not None)
        self.assertEqual(self.leave_foo_event.id, 123)
        self.fsm.transition()
        self.assertEqual(self.fsm.current, 'bar')

    def test_onenter_state_should_not_fire_when_fsm_is_put_on_hold(self):
        self.fsm.footobar(id=123)
        self.assertFalse(self.on_enter_bar_fired)
        self.fsm.transition()
        self.assertTrue(self.on_enter_bar_fired)

    def test_should_raise_exception_upon_further_transitions_when_fsm_is_on_hold(self):
        self.fsm.footobar(id=123)
        self.assertRaises(FysomError, self.fsm.bartobar)
