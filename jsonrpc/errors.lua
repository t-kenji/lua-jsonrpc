---
--  Lua JSON-RPC Error object module.
--
--  I want to be JSON-RPC 2.0 compliant.
--
--  @module     jsonrpc
--  @author     t-kenji <protect.2501@gmail.com>
--  @license    MIT
--  @copyright  2020 t-kenji

local _M = {}

_M.code = {
    PARSE_ERROR = -32700,
    INVALID_REQUEST = -32600,
    METHOD_NOT_FOUND = -32601,
    INVALID_PARAMS = -32602,
    INTERNAL_ERROR = -32603,
    SERVER_ERROR = -32000,
}

_M.message = {
    [_M.code.PARSE_ERROR] = 'Parse error',
    [_M.code.INVALID_REQUEST] = 'Invalid Request',
    [_M.code.METHOD_NOT_FOUND] = 'Method not found',
    [_M.code.INVALID_PARAMS] = 'Invalid params',
    [_M.code.INTERNAL_ERROR] = 'Internal error',
    [_M.code.SERVER_ERROR] = 'Server error',
}

return _M
