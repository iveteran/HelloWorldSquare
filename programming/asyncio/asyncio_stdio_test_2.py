import asyncio
import sys

@asyncio.coroutine
def my_task(seconds):
    print('Starting task, will %d seconds finish' % seconds)
    yield from asyncio.sleep(seconds)
    print('Task finished')

def heartbeat_handler():
    print('Heartbeat - %d' % loop.time())

def periodic_timer(loop, internal, callback):
    callback();
    loop.call_later(internal, periodic_timer, loop, internal, callback)

def reader():
    print('Received:', sys.stdin.readline())

loop = asyncio.get_event_loop()
const_internal = 2
try:
    loop.add_reader(sys.stdin.fileno(), reader)
    task = loop.create_task(my_task(seconds=6))
    loop.call_later(const_internal, periodic_timer, loop, const_internal, heartbeat_handler)
    loop.run_forever()
    #loop.run_until_complete(task)
except KeyboardInterrupt as e:
    print("Done")
    loop.stop()
finally:
    loop.close()
