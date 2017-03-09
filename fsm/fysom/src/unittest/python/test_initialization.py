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

from fysom import Fysom


class FysomInitializationTests(unittest.TestCase):

    def test_should_have_no_state_when_no_initial_state_is_given(self):
        fsm = Fysom({
            'events': [
                {'name': 'warn', 'src': 'green', 'dst': 'yellow'},
                {'name': 'panic', 'src': 'yellow', 'dst': 'red'},
                {'name': 'calm', 'src': 'red', 'dst': 'yellow'},
                {'name': 'clear', 'src': 'yellow', 'dst': 'green'}
            ]
        })
        self.assertEqual(fsm.current, 'none')

    def test_initial_state_should_be_green_when_configured(self):
        fsm = Fysom({
            'initial': 'green',
            'events': [
                {'name': 'warn', 'src': 'green', 'dst': 'yellow'},
                {'name': 'panic', 'src': 'yellow', 'dst': 'red'},
                {'name': 'calm', 'src': 'red', 'dst': 'yellow'},
                {'name': 'clear', 'src': 'yellow', 'dst': 'green'}
            ]
        })
        self.assertEqual(fsm.current, 'green')

    def test_initial_state_should_work_with_different_event_name(self):
        fsm = Fysom({
            'initial': {'state': 'green', 'event': 'init'},
            'events': [
                {'name': 'panic', 'src': 'green', 'dst': 'red'},
                {'name': 'calm', 'src': 'red', 'dst': 'green'},
            ]
        })
        self.assertEquals(fsm.current, 'green')

    def test_deferred_initial_state_should_be_none_then_state(self):
        fsm = Fysom({
            'initial': {'state': 'green', 'event': 'init', 'defer': True},
            'events': [
                {'name': 'panic', 'src': 'green', 'dst': 'red'},
                {'name': 'calm', 'src': 'red', 'dst': 'green'},
            ]
        })
        self.assertEqual(fsm.current, 'none')
        fsm.init()
        self.assertEqual(fsm.current, 'green')

    def test_tuples_as_trasition_spec(self):
        fsm = Fysom({
            'initial': 'green',
            'events': [  # freely mix dicts and tuples
                {'name': 'warn', 'src': 'green', 'dst': 'yellow'},
                ('panic', 'yellow', 'red'),
                ('calm', 'red', 'yellow'),
                {'name': 'clear', 'src': 'yellow', 'dst': 'green'}
            ]
        })
        fsm.warn()
        fsm.panic()
        self.assertEqual(fsm.current, 'red')
        fsm.calm()
        fsm.clear()
        self.assertEqual(fsm.current, 'green')

    def test_kwargs_override_cfg(self):
        fsm = Fysom({
            'initial': 'green',
            'events': [
                {'name': 'panic', 'src': 'green', 'dst': 'red'},
                {'name': 'calm', 'src': 'red', 'dst': 'green'},
            ]},
            # override initial state and calm event
            initial='red', events=[('calm', 'red', 'black')])
        self.assertEqual(fsm.current, "red")
        fsm.calm()
        self.assertEqual(fsm.current, "black")

    def test_init_kwargs_only(self):
        fsm = Fysom(initial='green',
                    events=[('panic', 'green', 'red'),
                            ('calm', 'red', 'green')])
        self.assertEqual(fsm.current, "green")
        fsm.panic()
        self.assertEqual(fsm.current, "red")
        fsm.calm()
        self.assertEqual(fsm.current, "green")

    def test_final_kwarg(self):
        fsm = Fysom(initial='eternity', final='eternity')
        self.assertEqual(fsm.current, 'eternity')
        self.assertEqual(fsm.is_finished(), True)

    def test_callbacks_kwarg(self):
        history = []

        def ontic(e):
            history.append('tic')

        def ontoc(e):
            history.append('toc')

        fsm = Fysom(initial='left',
                    events=[('tic', 'left', 'right'),
                            ('toc', 'right', 'left')],
                    callbacks={'ontic': ontic,
                               'ontoc': ontoc})

        fsm.tic()
        fsm.toc()
        fsm.tic()
        fsm.toc()

        self.assertEqual(history, ['tic', 'toc', 'tic', 'toc'])
