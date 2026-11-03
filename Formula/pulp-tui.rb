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
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.4.0/pulp-tui-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "1a8828fc4066738fdd5150ba851fc5f0823c13c687ded8b419f3d6b3c86e7c41"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.4.0/pulp-tui-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "1a8828fc4066738fdd5150ba851fc5f0823c13c687ded8b419f3d6b3c86e7c41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.4.0/pulp-tui-v0.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c1edc208b760a7c7de1a43f309c69c3ba3165c3d04e39bf5fd4252ecf29ff362"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.4.0/pulp-tui-v0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "81f139ebd3d5a7da5ef5f502e745b2ae41e2020bc63a0b0d162b25b80b8bc47c"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
