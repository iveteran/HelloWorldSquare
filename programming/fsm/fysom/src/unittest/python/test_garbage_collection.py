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
import gc

from fysom import Fysom


class FysomGarbageCollectionTests(unittest.TestCase):

    def test_should_not_create_circular_ref(self):
        class MyTestObject(object):

            def __init__(self):
                self._states = []
                self._fsm = Fysom({
                    'initial': 'green',
                    'events': [
                        {'name': 'warn', 'src': 'green', 'dst': 'yellow'},
                        {'name': 'panic', 'src': 'yellow', 'dst': 'red'},
                        {'name': 'calm', 'src': 'red', 'dst': 'yellow'},
                        {'name': 'clear', 'src': 'yellow', 'dst': 'green'}
                    ],
                    'callbacks': {
                        'ongreen':  self._on_green,
                        'onyellow': self._on_yellow,
                        'onred':    self._on_red
                    }
                })

            def warn(self):
                self._fsm.warn()

            def panic(self):
                self._fsm.panic()

            def calm(self):
                self._fsm.calm()

            def clear(self):
                self._fsm.clear()

            def _on_green(self, *args, **kwargs):
                self._states.append('green')

            def _on_yellow(self, *args, **kwargs):
                self._states.append('yellow')

            def _on_red(self, *args, **kwargs):
                self._states.append('red')

        obj = MyTestObject()
        obj.warn()
        obj.clear()
        del obj

        self.assertEqual(list(filter(lambda o: isinstance(o, MyTestObject),
                                     gc.get_objects())), [])

    def test_gc_should_not_break_callback(self):
        class MyTestObject(object):

            def __init__(self):
                self._states = []
                self._fsm = None

            def warn(self):
                self._fsm.warn()

            def panic(self):
                self._fsm.panic()

            def calm(self):
                self._fsm.calm()

            def clear(self):
                self._fsm.clear()

            def _on_green(self, *args, **kwargs):
                self._states.append('green')

            def _on_yellow(self, *args, **kwargs):
                self._states.append('yellow')

            def _on_red(self, *args, **kwargs):
                self._states.append('red')

        obj = MyTestObject()
        fsm = Fysom({
            'initial': 'green',
            'events': [
                {'name': 'warn', 'src': 'green', 'dst': 'yellow'},
                {'name': 'panic', 'src': 'yellow', 'dst': 'red'},
                {'name': 'calm', 'src': 'red', 'dst': 'yellow'},
                {'name': 'clear', 'src': 'yellow', 'dst': 'green'}
            ],
            'callbacks': {
                'ongreen':  obj._on_green,
                'onyellow': obj._on_yellow,
                'onred':    obj._on_red
            }
        })
        obj._fsm = fsm
        obj.warn()
        obj.clear()
        del obj
        fsm.warn()
