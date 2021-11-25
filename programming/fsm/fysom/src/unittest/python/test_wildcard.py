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

from fysom import Fysom
from test_many_to_many import FysomManyToManyTransitionTests


class FysomWildcardTransitionTests(FysomManyToManyTransitionTests):
    fsm_descr = {
        'initial': 'hungry',
        'events': [
            {'name': 'eat', 'src': 'hungry', 'dst': 'satisfied'},
            {'name': 'eat', 'src': 'satisfied', 'dst': 'full'},
            {'name': 'eat', 'src': 'full', 'dst': 'sick'},
            {'name': 'rest', 'src': '*', 'dst': 'hungry'}
        ]
    }

    def test_if_src_not_specified_then_is_wildcard(self):
        fsm = Fysom({
            'initial': 'hungry',
            'events': [
                {'name': 'eat', 'src': 'hungry', 'dst': 'satisfied'},
                {'name': 'eat', 'src': 'satisfied', 'dst': 'full'},
                {'name': 'eat', 'src': 'full', 'dst': 'sick'},
                {'name': 'rest', 'dst': 'hungry'}
            ]
        })
        fsm.eat()
        self.assertEqual(fsm.current, 'satisfied')
        fsm.rest()
        self.assertEqual(fsm.current, 'hungry')
        fsm.eat()
        fsm.eat()
        self.assertEqual(fsm.current, 'full')
        fsm.rest()
        self.assertEqual(fsm.current, 'hungry')
