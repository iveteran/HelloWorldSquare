Changelog for fysom
--------------------
* v2.1.2
  Add special symbol for dst state equals to src state.
  Pull request by [irpab](https://github.com/irpab)

* v2.1.0
  In cases where a class has a state machine instance as a member and
  uses methods for callbacks, the dependencies between the parent class and the
  child state machine created cycles in the garbage collector.

  In order to break these cycles, we modified the state machine to store weak
  references to the method. For non-method functions, we can store these safely
  since the function itself should not hold a reference to the state machine.
  Pull request by [sjlongland](https://github.com/sjlongland)

* v2.0.1
  State re-entry or 'reflexive' callbacks (onreenter_state) called when the start and end state of a transition
  are the same. This is different to the change in v1.1.0 as the new callback type is for a particular state and not
  a particular event. This allows individual callbacks for reflexive transitions rather than event callbacks
  with conditional branches to handle both reflexive and non-reflexive transitions.
  Pull request by [@mattjml](https://github.com/mattjml)

* v2.0.0
  BREAKING CHANGE - Canceling an event by returning `False` from the onbefore<event> callback
  will now raise `fysom.Canceled` instead of just ignoring the event.

* v1.1.2
  Extend Fysom constructor to allow for terser FSM specifications. Pull request by [@astanin](https://github.com/astanin).

* v1.1.1
  Resolved problems with installation on windows.

* v1.1.0
  Event callbacks (onbefore_event_|onafter_event_|on_event_) will now trigger
  when the state does not change.
  Previously those callbacks would only fire in the case of a state change,
  so events keeping the FSM in the same state would not fire callbacks at all.

* v1.0.19
  The `trigger` method now accepts any positional arguments and keyword arguments, and passes them to the underlying event method. Pull request by 
  [@poundifdef](https://github.com/poundifdef).

* v1.0.18
  From now on, a changelog will be included. Furthermore, all PyPI releases will be GPG signed.
