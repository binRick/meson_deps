
ms_inc = [
    inc,
]
ms_lib = static_library('ms', 
  meson_deps_dir + '/submodules/ms/ms.c',
  install: false, 
  dependencies: [
    asprintf_dep,
  ], 
  include_directories: ms_inc,
)
ms_dep = declare_dependency(
  include_directories: ms_inc,
  link_with: ms_lib,
)
