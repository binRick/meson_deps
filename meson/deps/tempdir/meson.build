tempdir_lib = static_library('tempdir', 
  meson_deps_dir + '/submodules/tempdir.c/tempdir.c',
  install: false, dependencies: [strdup_dep],
  include_directories: inc,
)
tempdir_dep = declare_dependency(include_directories: inc,
link_with: tempdir_lib)
