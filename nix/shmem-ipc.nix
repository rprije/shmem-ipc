{ lib
, rustPlatform
, pkg-config
, dbus
}:

let
  src = lib.cleanSourceWith {
    src = ../.;
    filter = path: type:
      (builtins.baseNameOf path == "src") ||
      (builtins.baseNameOf path == "benches") ||
      (lib.hasSuffix ".rs" path) ||
      (lib.hasSuffix ".toml" path) ||
      (builtins.baseNameOf path == "Cargo.lock");
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shmem-ipc-rob";
  version = "0.3.1";

  inherit src;

  # Treat all warnings as errors during the build
  RUSTFLAGS = "-D warnings";

  cargoLock = {
    lockFile = src + /Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  meta = {
    description = "Fork of shmem-ipc with nix build support and updated ZeroCopy";
  };
})
