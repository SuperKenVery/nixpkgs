{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, systemd }:

buildGoPackage rec {
  version = "0.2.0";
  pname = "grafana-loki";
  goPackagePath = "github.com/grafana/loki";

  doCheck = true;

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "loki";
    sha256 = "1f4g5qiarhsa1r7vdx1z30zpqlypd4cf5anj4jp6nc9q6zmjwk91";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ systemd.dev ];

  preFixup = ''
    wrapProgram $bin/bin/promtail \
      --prefix LD_LIBRARY_PATH : "${systemd.lib}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Like Prometheus, but for logs.";
    license = licenses.asl20;
    homepage = "https://grafana.com/loki";
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.linux;
  };
}
