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
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.2.0/duckpond-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "507c96305158aaa49f206a9123ddd7f9c6bf941aee8010fee28c03a7eca02b2b"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.2.0/duckpond-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "507c96305158aaa49f206a9123ddd7f9c6bf941aee8010fee28c03a7eca02b2b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.2.0/duckpond-v0.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "46667d163d3434299f1c87a736429b14adbebf0838e18232c7c3b9099c25815a"
    end
    on_intel do
      url "https://github.com/al-bashkir/duckpond/releases/download/v0.2.0/duckpond-v0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5ae0f0051890c33e13f4f953bfa45a62c765b2ab480a8305a750aca8fd146987"
    end
  end

  def install
    bin.install "duckpond"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckpond --version")
  end
end
