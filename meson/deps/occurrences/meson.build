occurrences_lib = static_library('occurrences',
  '../../../submodules/occurrences/occurrences.c',
  install: false, 
  dependencies: [
  ], 
  include_directories: [
    inc,
    '../../../submodules/occurrences',
  ]
)
occurrences_dep = declare_dependency(include_directories: 
  [
    inc,
    '../../../submodules/occurrences',
  ], 
  link_with: occurrences_lib
)
