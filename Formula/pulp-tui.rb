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
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.7.0/pulp-tui-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "dac4acdd79b8fc6bd9d3c28ae224beaf52c92176a00f09b3d3a5428275a63ae7"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.7.0/pulp-tui-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "dac4acdd79b8fc6bd9d3c28ae224beaf52c92176a00f09b3d3a5428275a63ae7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.7.0/pulp-tui-v0.7.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "22c6892fa449cae3fd6c4b4eec2ea46ba79dc84181f8826d2a581f446d87a95f"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.7.0/pulp-tui-v0.7.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c97f88e177c3042002ccfc45692feeffddc46fb5f94441fbfa9023907d59024a"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
