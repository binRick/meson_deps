dbg_srcs = [
  '../../../submodules/dbg.h/dbg.h',
]
dbg_dirs = [
    '../../../submodules/dbg.h',
    '../../../submodules/dbg',
    '../../../submodules/asprintf',
    '../../../submodules',
]
dbg_deps = [
    asprintf_dep,
]

dbg_lib = library('dbg', 
  dbg_srcs,
  install: false, 
  dependencies: dbg_deps,
  include_directories: dbg_dirs,
)
dbg_dep = declare_dependency(
  include_directories: dbg_dirs,
  link_with: dbg_lib,
)
