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
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.5.0/pulp-tui-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "78174b752574a2df65f82043a0f4ddd39d2350d0ff1f69603f9d1757fa834a4c"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.5.0/pulp-tui-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "78174b752574a2df65f82043a0f4ddd39d2350d0ff1f69603f9d1757fa834a4c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.5.0/pulp-tui-v0.5.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f7ccedfdd11bf2a080aff60cb19298fdfb32478beae5e86996b67002adcf959c"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.5.0/pulp-tui-v0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f1f18360e9315bd919bd3d7d82373bb25900b1ec86f05d536389f82b3f66a5a8"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
