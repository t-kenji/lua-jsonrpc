# JSON-RPC module for Lua

## Features

- Implemented in pure Lua: works with 5.4

## Usage

The `jsonrpc.lua` file should be download into an `package.path` directory and required by it:

```lua
local jsonrpc = require('jsonrpc')
```

The module provides the following functions:

### jsonrpc.run(application, sock)

Reads a stream from the `sock` and runs an `application`.

Such like a wsgi in python implementation in python.

```lua
function application(environ)
end

jsonrpc.run(application, sock)
```

## License

This module is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.

