class Duckpond < Formula
  desc "Encrypted environment-variable profiles with GPG or age passphrase"
  homepage "https://github.com/al-bashkir/duckpond"
  license "MIT"

  # Upstream ships only aarch64-apple-darwin and x86_64-unknown-linux-musl.
  # The arch deps make brew refuse the unsupported platforms before any fetch.
  # The stub blocks reuse the supported URL only so the formula passes the
  # tap-syntax check on every runner. Replace a stub with a real URL and drop
  # its arch dep once upstream builds that target.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.0/duckpond-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "69d946e193e2c90284b258a6bcff17d3a8f6851b1ec9c4f8553ef4bdb1643152"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.0/duckpond-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "69d946e193e2c90284b258a6bcff17d3a8f6851b1ec9c4f8553ef4bdb1643152"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.0/duckpond-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dcaf70da508fbd34dafbc215d1b9257077ce9809104ca5759cdaa017979c1998"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.0/duckpond-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dcaf70da508fbd34dafbc215d1b9257077ce9809104ca5759cdaa017979c1998"
    end
  end

  def install
    bin.install "duckpond"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckpond --version")
  end
end
