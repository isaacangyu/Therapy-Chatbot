{pkgs}: {
  channel = "stable-24.05";
  packages = [
    pkgs.jdk17
    pkgs.unzip
    pkgs.python3Full
    pkgs.poetry
    pkgs.postgresql
    pkgs.neo4j
    pkgs.sudo
  ];
  idx.extensions = [
    "Dart-Code.dart-code"
    "Dart-Code.flutter"
    "ms-python.debugpy"
    "ms-python.python"
  ];
  idx.previews = {
    previews = {
      # web = {
      #   command = [
      #     "flutter"
      #     "run"
      #     "--machine"
      #     "-d"
      #     "web-server"
      #     "--web-hostname"
      #     "0.0.0.0"
      #     "--web-port"
      #     "$PORT"
      #   ];
      #   manager = "flutter";
      # };
      android = {
        command = [
          "flutter"
          "run"
          "--machine"
          "-d"
          "android"
          "-d"
          "localhost:5555"
        ];
        manager = "flutter";
      };
    };
  };
}