---
--  Lua JSON-RPC module.
--
--  I want to be JSON-RPC 2.0 compliant.
--
--  @module     jsonrpc
--  @author     t-kenji <protect.2501@gmail.com>
--  @license    MIT
--  @copyright  2020 t-kenji

local json = require('json')
local errors = require('jsonrpc.errors')

local _M = {
    _VERSION = "JSON-RPC 0.1.0",
    jsonrpc_version = '2.0',
}

local recvall = function (sock)
    local frags = {}
    while true do
        local err, partial = select(2, sock:receive('*a'))
        if err ~= 'timeout' then
            error(err)
        end

        if partial == '' then
            break
        end

        table.insert(frags, partial)
    end
    return table.concat(frags)
end

local responses = {}

function _M.run(application, stdin, stdout, stderr)
    stdin = stdin or io.stdin
    stdout = stdout or io.stdout
    stderr = stderr or io.stderr

    local json_str = recvall(stdin) or error('Connection established but noting received')
    local request = json.decode(json_str)

    local environ = {}
    for k, v in pairs(request) do
        environ[k] = v
    end
    environ['jsonrpc.input'] = stdin
    environ['jsonrpc.errors'] = stderr
    if not environ.method and environ.id then
        if responses[environ.id] then
            responses[environ.id](environ.result)
            responses[environ.id] = nil
        end
        return
    end
    environ['jsonrpc.request'] = function (method, params, id, response)
        stdout:send(json.encode{
            jsonrpc = _M.jsonrpc_version,
            method = method,
            params = params,
            id = id,
        })
        if id then
            responses[id] = response
        end
    end

    local function write(data)
        stdout:send(data)
    end

    local result, error_code = application(environ)
    local ok, err = pcall(function ()
        local response = {
            jsonrpc = _M.jsonrpc_version,
            id = environ.id,
        }
        if not error_code then
            response.result = result
        else
            response.error = {
                code = error_code,
                message = errors.message[error_code],
            }
        end

        write(json.encode(response))
    end)
    if not ok then
        error(err)
    end
end

function _M.errors(message, stdin, stdout, stderr)
    stdin = stdin or io.stdin
    stdout = stdout or io.stdout
    stderr = stderr or io.stderr

    stdout:send(json.encode({
        jsonrpc = _M.jsonrpc_version,
        error = {
            code = jsonrpc.errors.code.INTERNAL_ERROR,
            message = jsonrpc.errors.message[code],
            data = message,
        }
    }))
end

return _M
