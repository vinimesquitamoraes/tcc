--[[
Sumario
Calls a function with a custom error handler

Prototype

ok, result = xpcall (f, err)

Description

Calls function f with err as the custom error handler.

If an error occurs in f it is caught and the error-handler 'err' is called. 

Then xpcall returns false, and whatever the error handler returned.

If there is no error in f, then xpcall returns true, followed by the function results from f.

Note that the supplied error function is called before the stack is unwound (in case of error) 
so this is a good time to find what functions were on the stack leading up to the error. 

In the example below we use the debug.traceback function, which shows a stack trace as at the time 
of the error.
]]

function f ()
  return "a" + 2  -- will cause error
end

function err (x)
  print ("err called", x)
  return "oh no!"
end -- err

print (xpcall (f, err))

function f2 ()
  return 2 + 2
end -- f

print (xpcall (f, err))  --> true 4

function f ()
return "a" + 2
end -- f

print (xpcall (f, debug.traceback))
