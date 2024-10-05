{ lib, buildGoModule }:
buildGoModule rec {
  pname = "pinentry-keyring";
  version = "1.0.0";
  src = lib.cleanSource ./.;
  vendorHash = "sha256-fr67mNicDA60Y4X8wY/P/4odALEGTfbYmWUnvwaubvc=";
  ldflags = [ "-w" "-s" "-X main.version=v${version}" ];
  meta = with lib; {
    mainProgram = "pinentry-keyring";
    supportedPlatforms = platforms.linux;
  };
}
