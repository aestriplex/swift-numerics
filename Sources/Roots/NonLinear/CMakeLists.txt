#[[
This source file is part of the Swift Numerics open source project

Copyright (c) 2023 Apple Inc. and the Swift Numerics project authors
Licensed under Apache License v2.0 with Runtime Library Exception

See https://swift.org/LICENSE.txt for license information
#]]

add_library(Roots
  NonLinearRootFinder.swift
  Bisect.swift
  Chord.swift
  Newton.swift
  Secant.swift)
set_target_properties(Roots PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_link_libraries(Roots PUBLIC
  _NumericsShims)


_install_target(Roots)
set_property(GLOBAL APPEND PROPERTY SWIFT_NUMERICS_EXPORTS Roots)
