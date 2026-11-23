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
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.1/duckpond-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "7361849e4d0f81f9b29d44a7267ec8858dd609f78bc12ad7b089299dca846fac"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.1/duckpond-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "7361849e4d0f81f9b29d44a7267ec8858dd609f78bc12ad7b089299dca846fac"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.1/duckpond-v0.1.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a7a8448958a7783217b6909697fcf6bce1575aab88cf407ede7e269c2ab5c069"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.1/duckpond-v0.1.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a7a8448958a7783217b6909697fcf6bce1575aab88cf407ede7e269c2ab5c069"
    end
  end

  def install
    bin.install "duckpond"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckpond --version")
  end
end
