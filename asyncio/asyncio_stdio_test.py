import asyncio
import sys

'''
# In python 3.5+
async def aio_readline(loop):
def aio_readline(loop):
    while True:
        line = await loop.run_in_executor(None, sys.stdin.readline)
        print('Got line:', line, end='')
'''

# In python 3.4+
@asyncio.coroutine
def aio_readline(loop):
    while True:
        line = yield from loop.run_in_executor(None, sys.stdin.readline)
        print('Got line:', line, end='')

        if line.strip() == 'quit' or line.strip() == 'exit':
            print('Quit')
            loop.stop()

loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(aio_readline(loop))
except KeyboardInterrupt as e:
    print("Tasks: ", asyncio.Task.all_tasks())
    loop.stop()
finally:
    loop.close()
