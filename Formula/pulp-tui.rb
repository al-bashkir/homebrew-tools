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
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.0/pulp-tui-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "4d542f05250b8c0895c94dea165c4d519fe33ee1213b1f0aa836130fb56d90e0"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.0/pulp-tui-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "4d542f05250b8c0895c94dea165c4d519fe33ee1213b1f0aa836130fb56d90e0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.0/pulp-tui-v0.6.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e6b34366fe31a28b8780e8ac889a10de042d7c45376fb18aebca1b20159580ac"
    end
    on_intel do
      url "https://github.com/al-bashkir/pulp-tui/releases/download/v0.6.0/pulp-tui-v0.6.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cb435b1ac5002435d9b1cc6024ada800d0eaf8a9fcac25b061f3e9c68713b7bd"
    end
  end

  def install
    bin.install "pulp-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp-tui --version")
  end
end
