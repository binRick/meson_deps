progress_cargs = [
  '-Wno-macro-redefined',
]
progress_srcs = [
  meson_deps_dir + '/submodules/progress.c/progress.c',
]

progress_lib = library('process', 
  progress_srcs,
  install: false, 
  dependencies: [
  ], 
  include_directories: [
    inc,
  ],
  c_args: progress_cargs,
)

progress_dep = declare_dependency(
  include_directories: [
    inc,
  ], 
  link_with: progress_lib,
)
