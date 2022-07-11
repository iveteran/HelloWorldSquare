let sprintf = import("sprintf-js").then(loaded => sprintf= loaded)
let name = 'Volume'
let unit = 'MByte'
sprintf.vsprintf('%s(%s)', [name, unit])
