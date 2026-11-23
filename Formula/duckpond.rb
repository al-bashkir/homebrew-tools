class Duckpond < Formula
  desc "Encrypted environment-variable profiles with GPG or age passphrase"
  homepage "https://github.com/al-bashkir/duckpond"
  license "MIT"

  # No upstream x86_64-apple-darwin asset. The arch dep makes brew refuse
  # macOS Intel before any fetch. The on_intel stub reuses the arm64 URL only
  # so the formula passes the tap-syntax check on every runner. Replace the
  # stub with a real URL and drop the arch dep once upstream builds that target.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.3/duckpond-v0.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "27b96c7827d02f954c83c539df4e7004408b305bbf63203f168d98467d917925"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.3/duckpond-v0.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "27b96c7827d02f954c83c539df4e7004408b305bbf63203f168d98467d917925"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.3/duckpond-v0.1.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bce897775606c1de5ea7a8f23220d4501ed5c7dc153e020e3bd0927bbb126efa"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.1.3/duckpond-v0.1.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6ca4239d764f644a0dad43b060beacadfb6aa7bafd33ed4731376a0c27c33bcc"
    end
  end

  def install
    bin.install "duckpond"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckpond --version")
  end
end
