class PulpTui < Formula
  desc "Keyboard-driven terminal UI for Pulp 3 repositories and content views"
  homepage "https://github.com/al-bashkir/pulp-tui"
  license "Apache-2.0"

  # Upstream ships only aarch64-apple-darwin and x86_64-unknown-linux-musl.
  # The arch deps make brew refuse the unsupported platforms before any fetch.
  # The stub blocks reuse the supported URL only so the formula passes the
  # tap-syntax check on every runner. Replace a stub with a real URL and drop
  # its arch dep once upstream builds that target.
  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.0/pulp-tui-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "787acae7f3c860b27a75678990c53579c78bfc826544ccc4d06a290a9a8c5c11"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.0/pulp-tui-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "787acae7f3c860b27a75678990c53579c78bfc826544ccc4d06a290a9a8c5c11"
    end
  end

  on_linux do
    depends_on arch: :x86_64

    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.0/pulp-tui-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9ab14232de59bb8ed37ce4f2be0ac5771b51c5d9a7ec3e5b62f1e8057a75708f"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.1.0/pulp-tui-v0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9ab14232de59bb8ed37ce4f2be0ac5771b51c5d9a7ec3e5b62f1e8057a75708f"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
