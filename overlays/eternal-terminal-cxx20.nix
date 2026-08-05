# TEMPORARY: eternal-terminal 7.0.0 pins C++17, but the abseil it now builds
# against (via protobuf 36) requires C++20 — its headers use std::weak_ordering
# & friends from <compare> unconditionally, so the build dies in et-lib's
# precompiled header with a wall of "'weak_ordering' in namespace 'absl' does
# not name a type".
#
# Mirrors https://github.com/NixOS/nixpkgs/pull/569401 — drop this overlay once
# that lands in nixos-unstable.
final: prev: {
  eternal-terminal = prev.eternal-terminal.overrideAttrs (old: {
    # -DCMAKE_CXX_STANDARD=20 does NOT work here: the plain set() in
    # CMakeLists.txt shadows the cache variable, so patch the source line.
    # ThreadPool.h then needs fixing too, since C++20 removed std::result_of.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "set(CMAKE_CXX_STANDARD 17)" "set(CMAKE_CXX_STANDARD 20)"
      substituteInPlace external_imported/ThreadPool/ThreadPool.h \
        --replace-fail "std::result_of<F(Args...)>::type" "std::invoke_result<F, Args...>::type"
      sed -i 's|#include <stdexcept>|#include <stdexcept>\n#include <type_traits>|' \
        external_imported/ThreadPool/ThreadPool.h
    '';

    # Upstream sets CXXFLAGS=-std=c++17 on clang, which would undo the above.
    env = { };
  });
}
