reproc_lib = library('reproc',
  '../../../submodules/reproc/reproc/src/clock.posix.c',
  '../../../submodules/reproc/reproc/src/drain.c',
  '../../../submodules/reproc/reproc/src/error.posix.c',
  '../../../submodules/reproc/reproc/src/handle.posix.c',
  '../../../submodules/reproc/reproc/src/init.posix.c',
  '../../../submodules/reproc/reproc/src/options.c',
  '../../../submodules/reproc/reproc/src/pipe.posix.c',
  '../../../submodules/reproc/reproc/src/process.posix.c',
  '../../../submodules/reproc/reproc/src/redirect.c',
  '../../../submodules/reproc/reproc/src/redirect.posix.c',
  '../../../submodules/reproc/reproc/src/reproc.c',
  '../../../submodules/reproc/reproc/src/run.c',
  '../../../submodules/reproc/reproc/src/strv.c',
  '../../../submodules/reproc/reproc/src/utf.posix.c',

  install: false, 
  dependencies: [
   timestamp_dep, 
  ], 
  include_directories: [
    '../../../submodules/reproc/reproc/include',
    '../../../submodules/reproc/reproc/include/reproc',
    '../../../submodules/reproc/reproc',
    '../../../submodules/reproc/reproc/src',
    '../../../submodules/reproc',
    inc,
  ]
)
reproc_dep = declare_dependency(include_directories: [inc], link_with: reproc_lib)
