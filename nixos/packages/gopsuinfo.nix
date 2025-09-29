{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gopsuinfo";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "gopsuinfo";
    rev = "v${version}";
    hash = "sha256-e+obIFbhjxsdnyJe3+sUpe9pK9eNTspxNH+Cvf4RBMQ=";
  };

  vendorHash = "sha256-S2ZHfrbEjPDweazwWbMbEMcMl/i+8Nru0G0e7RjOJMk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Lightweight system resource usage monitor for panels";
    homepage = "https://github.com/nwg-piotr/gopsuinfo";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "gopsuinfo";
  };
}