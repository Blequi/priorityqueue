package = "priorityqueue"
version = "dev-1"
source = {
   url = "git+https://github.com/Blequi/priorityqueue.git",
   branch = "main"
}
description = {
   homepage = "https://github.com/Blequi/priorityqueue",
   license = "MIT",
   summary = "Priority Queue data structure written in pure Lua",
   detailed = [[
Priority Queue is a data structure whose elements
are ordered by priority. Elements sharing the same
priority are maintained in a queue obeying a
FIFO behavior (first in, first out).
]]
}
dependencies = {
    "lua >= 5.1",
    "queue >= 0.0.1",
    "binarytree >= 0.0.2"
}
build = {
   type = "builtin",
   modules = {
      priorityqueue = "priorityqueue.lua"
   }
}
