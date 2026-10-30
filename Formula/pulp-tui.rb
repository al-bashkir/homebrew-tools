class PulpTui < Formula
  desc "Keyboard-driven terminal UI for Pulp 3 repositories and content views"
  homepage "https://github.com/al-bashkir/pulp-tui"
  license "Apache-2.0"

  # Upstream ships no x86_64-apple-darwin asset. The arch dep makes brew refuse
  # macOS Intel before any fetch. The on_intel stub reuses the arm64 URL only so
  # the formula passes the tap-syntax check on every runner. Replace the stub
  # with a real URL and drop the arch dep once upstream builds that target.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.2.0/pulp-tui-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "6dd04ab7a79f4ac2c7117473bc5f71bb60c8b0878fa963e9c3b554f6a924b58c"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.2.0/pulp-tui-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "6dd04ab7a79f4ac2c7117473bc5f71bb60c8b0878fa963e9c3b554f6a924b58c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.2.0/pulp-tui-v0.2.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "28e858c381431f581ac7c613c1c940d0332b3efa5f9f3bbdc159eeed884fadc2"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.2.0/pulp-tui-v0.2.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b75ff430055567184b4cb9c5722a42da4151c3e44354b3c5d9b6a560170bfcec"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
